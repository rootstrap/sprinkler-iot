defmodule SprinklerMqtt.Handler do
  @moduledoc false

  use Tortoise.Handler
  alias Sprinkler.Devices
  alias SprinklerMqtt.CommandPublisher
  alias SprinklerMqtt.Commands.Irrigate, as: IrrigateCommand
  alias SprinklerMqtt.IrrigationsStorage

  @telemetry_topic "telemetry"
  @irrigations_topic "irrigations"

  @valve_open_time %{
    water_high: 5,
    water_medium: 3,
    water_low: 1,
    no_water: 0
  }

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
    decoded_payload = Map.put(Jason.decode!(payload), "timestamp", DateTime.utc_now())

    SprinklerWeb.Endpoint.broadcast(@telemetry_topic, "new_reading", %{
      payload: decoded_payload,
      device_id: String.to_integer(client_id)
    })

    reading = transform_payload(decoded_payload)
    device = Devices.get_device(client_id)
    garden_reading = Devices.new_garden_reading(reading)

    maybe_irrigate_garden(device, garden_reading)

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

  defp transform_payload(payload) do
    %{"tmp" => nil, "hum" => nil, "moist" => nil}
    |> Map.merge(payload)
    |> Map.new(fn
      {"tmp", value} -> {:temperature, value}
      {"hum", value} -> {:humidity, value}
      {"moist", value} -> {:moisture, value}
      {k, v} -> {k, v}
    end)
  end

  defp maybe_irrigate_garden(nil, _), do: nil

  defp maybe_irrigate_garden(device, garden_reading) do
    Devices.irrigate_garden(garden_reading, fn water_amount ->
      seconds_to_open_valve = @valve_open_time[water_amount]

      if seconds_to_open_valve > 0 do
        CommandPublisher.send_command(device, %IrrigateCommand{water: seconds_to_open_valve})

        IrrigationsStorage.add_irrigation(Devices.get_device!(device.id), water_amount)
        SprinklerWeb.Endpoint.broadcast(@irrigations, "new_irrigation", %{
          device_id: String.to_integer(device.id)
        })
      end
    end)
  end
end
