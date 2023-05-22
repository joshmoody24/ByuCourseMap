defmodule ByuCourseMapWeb.CrawlLive do
  use ByuCourseMapWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(ByuCourseMap.PubSub, "scrape_progress")
    {:ok, assign(socket, val: 0, courses: [], scrape_progress: nil, scraping: false, scraper_pid: nil)}
  end

  @impl true
  def handle_info({:scrape_progress, progress}, socket) do
    {:noreply, assign(socket, scrape_progress: progress)}
  end

  @impl true
  def handle_info({:scrape_complete, courses}, socket) do
    {:noreply, assign(socket, scraping: false, scraper_pid: nil, courses: courses)}
  end

  @impl true
  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  @impl true
  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1 - 1))}
  end

  @impl true
  def handle_event("crawl", _, socket) do
    if socket.assigns.scraping == false do
      start_scraping(socket)
    else
      stop_scraping(socket, socket.assigns.scraper_pid)
    end
  end

  @impl true
  def handle_event("crawl_programs", _, socket) do
    start_scraping_programs(socket)
  end

  defp stop_scraping(socket, pid) do
    Process.exit(pid, :kill)
    {:noreply, assign(socket, scraping: false, scraper_pid: nil)}
  end

  defp start_scraping(socket) do
    rate_limit = 1
    pid = spawn(fn -> Scraper.ByuScraper.scrape_courses(rate_limit) end)
    {:noreply, assign(socket, scraping: true, scraper_pid: pid)}
  end

  defp start_scraping_programs(socket) do
    Scraper.ByuScraper.scrape_programs()
    {:noreply, assign(socket, scraping: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <h1 class="text-4xl font-bold text-center"> The count is: <%= @val %> </h1>

    <p class="text-center">
     <.button phx-click="dec">-</.button>
     <.button phx-click="inc">+</.button>
    </p>

    <p class="text-center">
      <.button phx-click="crawl">
        <%= if @scraping == false do %>Start<% else %>Stop<% end %>
        Scraping BYU Courses
      </.button>
    </p>

    <p class="text-center">
      <.button phx-click="crawl_programs">
        Scrape BYU Programs
      </.button>
    </p>

    <%= if @scraping == true and @scrape_progress != nil do %>

      <p class="text-center">
        Scraping page <%= @scrape_progress.current_page %>
      </p>

      <p class="text-center">
        Page <%= @scrape_progress.completed_courses %> out of <%= @scrape_progress.total_courses %>
        (<%= (@scrape_progress.completed_courses / @scrape_progress.total_courses) * 100 %>%)
      </p>

    <% end %>

    <%= if length(@courses) > 0 do %>
    <h1>Course Results</h1>
    <% end %>

    <ul>
    <%= for course <- @courses do %>
      <li><%= course.department %> <%= course.code %></li>
    <% end %>
    </ul>

    </div>
    """
  end
end
