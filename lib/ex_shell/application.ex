defmodule ExShell.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExShellWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExShell.PubSub},
      # Start the Endpoint (http/https)
      ExShellWeb.Endpoint
      # Start a worker by calling: ExShell.Worker.start_link(arg)
      # {ExShell.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExShell.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExShellWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
