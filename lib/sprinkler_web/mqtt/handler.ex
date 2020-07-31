defmodule SprinklerWeb.Mqtt.Handler do
  @moduledoc false

  use Tortoise.Handler

  @telemetry_topic "telemetry"

  def init(args) do
    {:ok, args}
  end

  def connection(_status, state) do
    # `status` will be either `:up` or `:down`; you can use this to
    # inform the rest of your system if the connection is currently
    # open or closed; tortoise should be busy reconnecting if you get
    # a `:down`
    {:ok, state}
  end

  def handle_message(["rs", client_id, "telemetry"], payload, state) do
    decoded_payload = Jason.decode!(payload)

    SprinklerWeb.Endpoint.broadcast(@telemetry_topic, "new_reading", %{
      payload: decoded_payload,
      device_id: String.to_integer(client_id)
    })

    {:ok, state}
  end

  def handle_message(_topic, _payload, state) do
    # unhandled message! You will crash if you subscribe to something
    # and you don't have a 'catch all' matcher; crashing on unexpected
    # messages could be a strategy though.

    {:ok, state}
  end

  def subscription(_status, _topic_filter, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    # tortoise doesn't care about what you return from terminate/2,
    # that is in alignment with other behaviours that implement a
    # terminate-callback
    :ok
  end
end
