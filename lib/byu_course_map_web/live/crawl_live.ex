defmodule ByuCourseMapWeb.CrawlLive do
  use ByuCourseMapWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, val: 0, courses: [])}
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  def handle_event("crawl", _, socket) do
    {:noreply, assign(socket, courses: Scraper.ByuScraper.scrape_courses())}
  end

  def render(assigns) do
    ~H"""
    <div>
    <h1 class="text-4xl font-bold text-center"> The count is: <%= @val %> </h1>

    <p class="text-center">
     <.button phx-click="dec">-</.button>
     <.button phx-click="inc">+</.button>
    </p>

    <p class="text-center">
      <.button phx-click="crawl">Crawl</.button>
    </p>

    <ul>
    <%= for course <- @courses do %>
      <li><%= course.department %> <%= course.code %></li>
    <%= end %>
    </ul>
    </div>
    """
  end
end
