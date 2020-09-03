defmodule SprinklerWeb.Mqtt.Subscriber do
  @moduledoc false

  use Supervisor

  @broker_url Application.get_env(:sprinkler, :mqtt_broker_url)

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {host, port, username, password} = server_connection()

    children = [
      {Tortoise.Connection,
       [
         client_id: RootstrapSprinkler,
         user_name: username,
         password: password,
         server: {Tortoise.Transport.Tcp, host: host, port: port},
         handler: {SprinklerWeb.Mqtt.Handler, []},
         subscriptions: ["rs/+/telemetry"]
       ]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp server_connection() do
    %URI{
      host: host,
      port: port,
      userinfo: user_info
    } = URI.parse(@broker_url)

    [username, password] = String.split(user_info || ":", ":")

    {host, port, username, password}
  end
end
