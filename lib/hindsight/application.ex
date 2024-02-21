defmodule Hindsight.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Hindsight.Repo,
      # Start the Telemetry supervisor
      HindsightWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hindsight.PubSub},
      # Start the Endpoint (http/https)
      HindsightWeb.Endpoint,
      # Start a worker by calling: Hindsight.Worker.start_link(arg)
      # {Hindsight.Worker, arg}
      Hindsight.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hindsight.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HindsightWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
