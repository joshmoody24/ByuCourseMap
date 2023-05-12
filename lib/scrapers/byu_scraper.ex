defmodule Scraper.ByuScraper do

  def base_url do
    "http://catalog2023.byu.edu"
  end

  def scrape_courses do

    IO.puts "Scraping courses..."

    # find the number of pages
    {:ok, response} = HTTPoison.get(base_url() <> "/courses")
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
      1..1
      |> Enum.map(fn page ->
        {:ok, response} = HTTPoison.get(base_url() <> "/courses?page=" <> to_string(page))
        course_urls = response.body
        |> Floki.parse_document!
        |> Floki.find(".view-content a")
        |> Floki.attribute("href")

        course_urls
        |> Enum.map(fn url ->
          IO.puts "Scraping page " <> url
          case HTTPoison.get(base_url() <> url) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
              body
              |> Floki.parse_document!
              |> parse_course_page
          end
        end)
      end)
      |> List.flatten
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

    IO.inspect course_data

    course_data
  end
end
