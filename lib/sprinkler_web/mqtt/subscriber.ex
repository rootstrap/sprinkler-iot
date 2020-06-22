defmodule SprinklerWeb.Mqtt.Subscriber do
  @moduledoc false

  use Supervisor

  @broker_host Application.get_env(:sprinkler, SprinklerWeb.Endpoint)[:broker_host]
  @broker_port Application.get_env(:sprinkler, SprinklerWeb.Endpoint)[:broker_port]

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      {Tortoise.Connection,
       [
         client_id: RootstrapSprinkler,
         server: {Tortoise.Transport.Tcp, host: @broker_host, port: @broker_port},
         handler: {SprinklerWeb.Mqtt.Handler, []},
         subscriptions: ["rs/+/telemetry"]
       ]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
