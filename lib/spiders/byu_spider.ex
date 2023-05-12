defmodule ByuSpider do
  use Crawly.Spider

  @impl Crawly.Spider
  def base_url do
    "https://byu.edu"
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "http://catalog2023.byu.edu/courses"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = response.body
    |> Floki.parse_document

    case URI.parse(response.request_url).path do
      "/courses" ->
        course_urls = document
        |> Floki.find(".view-content a")
        |> Floki.attribute("href")

        requests = course_urls
        |> Enum.map(fn url ->
          URI.merge(response.request_url, url)
          |> to_string
          |> Crawly.Utils.request_from_url()
          end)
        %Crawly.ParsedItem{
          :items => [],
          :requests => requests
        }

      _ ->
        course_data = parse_course_document(document)

        %Crawly.ParsedItem{
          :items => [course_data],
          :requests => []
        }
    end
end

  def parse_course_document(document) do
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

    %{
      :name => course_name,
      :department => course_department_code,
      :code => course_code,
      :description => course_description,
      :credit_hours => course_credit_hours
    }
  end
end
