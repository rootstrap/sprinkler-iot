defmodule Sprinkler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Sprinkler.Repo,
      # Start the Telemetry supervisor
      SprinklerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sprinkler.PubSub},
      # Start the Endpoint (http/https)
      SprinklerWeb.Endpoint,
      # Start a worker by calling: Sprinkler.Worker.start_link(arg)
      # {Sprinkler.Worker, arg}
      # Start a tortoise client
      SprinklerWeb.Tortoise.Subscriber
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sprinkler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SprinklerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
