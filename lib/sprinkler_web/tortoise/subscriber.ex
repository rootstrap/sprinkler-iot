defmodule SprinklerWeb.Tortoise.Subscriber do
  use Supervisor

  @broker_host "localhost"
  @broker_port 1883

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
         handler: {SprinklerWeb.Tortoise.MqttHandler, []},
         subscriptions: ["rs/+/sensors"]
       ]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
