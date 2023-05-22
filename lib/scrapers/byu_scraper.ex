defmodule Scraper.ByuScraper do

  def scrape_programs() do
    base_url = "https://catalog2023.byu.edu/majors"
    {:ok, response} = HTTPoison.get(base_url)
    response
    |> Floki.parse_document!
    |> Floki.find(".content .program-list-view .field-content a")
    |> Floki.text
    |> String.trim
    |> Enum.map(fn text ->
      ByuCourseMap.Repo.insert(%ByuCourseMap.Program{

        })
    end)
  end

  def scrape_courses(rate_limit_seconds) do

    base_url = "http://catalog2023.byu.edu"

    IO.puts "Scraping courses..."

    # find the number of pages
    {:ok, response} = HTTPoison.get(base_url <> "/courses")
    num_pages = response.body
    |> Floki.parse_document!
    |> Floki.find(".pager-last a")
    |> Floki.attribute("href")
    |> hd
    |> String.split("page=")
    |> Enum.take(-1)
    |> hd
    |> Integer.parse()
    |> elem(0)

    # get all the courses on each page
    courses = 0..num_pages-1
    |> Enum.map(fn page ->
      {:ok, response} = HTTPoison.get(base_url <> "/courses?page=" <> to_string(page))
      course_urls = response.body
      |> Floki.parse_document!
      |> Floki.find(".view-content a")
      |> Floki.attribute("href")

      course_urls
      |> Enum.with_index
      |> Enum.map(fn {url, index} ->
        Process.sleep(rate_limit_seconds * 1000)
        broadcast_progress(%{
          completed_courses: page * length(course_urls) + index,
          total_courses: num_pages * length(course_urls),
          current_page: url
        })
        case HTTPoison.get(base_url <> url) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            course = body
            |> Floki.parse_document!
            |> parse_course_page

            save_course(course)
            course
          end
        end)
      end)
    |> List.flatten

    broadcast_complete(courses)
    courses
  end

  def save_course(raw_course) do
    %ByuCourseMap.Course{
      name: raw_course.name,
      course_code: raw_course.course_code,
      description: raw_course.description,
      credit_hours: raw_course.credit_hours
    }
    |> ByuCourseMap.Repo.insert()
  end

  def parse_course_page(document) do
    course_name = document
    |> Floki.find(".course-title-title")
    |> Floki.text
    |> String.trim

    course_department_code = document
    |> Floki.find(".course-code-dept-name")
    |> Floki.text
    |> String.trim

    course_code = document
    |> Floki.find(".course-code-cat-num")
    |> Floki.text
    |> String.trim

    course_description = document
    |> Floki.find(".course-title-description")
    |> Floki.text
    |> String.trim

    course_credit_hours = document
    |> Floki.find(".course-data-row .course-data-content")
    |> hd
    |> Floki.text
    |> String.split(" ")
    |> hd
    |> String.trim
    |> Float.parse
    |> elem(0)

    course_data = %{
      :name => course_name,
      :department => course_department_code,
      :code => course_code,
      :description => course_description,
      :credit_hours => course_credit_hours
    }

    course_data
  end

  defp broadcast_progress(progress) do
    Phoenix.PubSub.broadcast(ByuCourseMap.PubSub, "scrape_progress", {:scrape_progress, progress})
  end

  defp broadcast_complete(courses) do
    Phoenix.PubSub.broadcast(ByuCourseMap.PubSub, "scrape_progress", {:scrape_complete, courses})
  end
end
