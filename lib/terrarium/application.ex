defmodule Terrarium.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TerrariumWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Terrarium.PubSub},
      # Start the Endpoint (http/https)
      TerrariumWeb.Endpoint
      # Start a worker by calling: Terrarium.Worker.start_link(arg)
      # {Terrarium.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Terrarium.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TerrariumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
