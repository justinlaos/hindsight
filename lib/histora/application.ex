defmodule Histora.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Histora.Repo,
      # Start the Telemetry supervisor
      HistoraWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Histora.PubSub},
      # Start the Endpoint (http/https)
      HistoraWeb.Endpoint,
      # Start a worker by calling: Histora.Worker.start_link(arg)
      # {Histora.Worker, arg}
      Histora.Scheduler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Histora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HistoraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
