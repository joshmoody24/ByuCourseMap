defmodule ByuCourseMap.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ByuCourseMapWeb.Telemetry,
      # Start the Ecto repository
      ByuCourseMap.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ByuCourseMap.PubSub},
      # Start Finch
      {Finch, name: ByuCourseMap.Finch},
      # Start the Endpoint (http/https)
      ByuCourseMapWeb.Endpoint,
      # Start a worker by calling: ByuCourseMap.Worker.start_link(arg)
      # {ByuCourseMap.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ByuCourseMap.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ByuCourseMapWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
