defmodule SprinklerWeb.DashboardLive do
  use SprinklerWeb, :live_view

  alias Sprinkler.Devices
  alias SprinklerMqtt.IrrigationsStorage

  @telemetry_topic "telemetry"
  @irrigations_topic "irrigations"

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry_topic)
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @irrigations_topic)

    {:ok,
     assign(socket, :devices, [
       %{
         id: 1,
         tmps: [],
         hum: [],
         moist: [],
         irrigations: IrrigationsStorage.today_irrigations(Devices.get_device!(1))
       },
       %{
         id: 2,
         tmps: [],
         hum: [],
         moist: [],
         irrigations: IrrigationsStorage.today_irrigations(Devices.get_device!(2))
       }
     ])}
  end

  @impl true
  def handle_info(
        %{
          topic: @telemetry_topic,
          event: "new_reading",
          payload: %{payload: payload, device_id: device_id}
        },
        socket
      ) do
    temperature = payload["tmp"]
    humidity = payload["hum"]
    moisture = payload["moist"]
    timestamp = payload["timestamp"]

    updated_list =
      Enum.map(socket.assigns.devices, fn
        %{id: ^device_id} = device ->
          device
          |> add_reading(:tmps, temperature, timestamp)
          |> add_reading(:hum, humidity, timestamp)
          |> add_reading(:moist, moisture, timestamp)

        device ->
          device
      end)

    {:noreply, assign(socket, devices: updated_list)}
  end

  @impl true
  def handle_info(
        %{
          topic: @irrigations_topic,
          event: "new_irrigation",
          payload: %{device_id: device_id}
        },
        socket
      ) do
    today_irrigations = IrrigationsStorage.today_irrigations(Devices.get_device!(device_id))

    updated_list =
      Enum.map(socket.assigns.devices, fn
        %{id: ^device_id, irrigations: irrigations} = device ->
          %{device | irrigations: today_irrigations}

        device ->
          device
      end)

    {:noreply, assign(socket, devices: updated_list)}
  end

  defp add_reading(device, _metric_name, nil, _timestamp), do: device

  defp add_reading(%{moist: metric_values} = device, :moist, value, timestamp) do
    %{device | moist: [{value, timestamp} | metric_values]}
  end

  defp add_reading(%{hum: metric_values} = device, :hum, value, timestamp) do
    %{device | hum: [{value, timestamp} | metric_values]}
  end

  defp add_reading(%{tmps: metric_values} = device, :tmps, value, timestamp) do
    %{device | tmps: [{value, timestamp} | metric_values]}
  end

  defp encoded_devices(devices) do
    devices
    |> Enum.map(fn
      %{id: id, tmps: tmps, hum: hum, moist: moist, irrigations: irrigations} ->
        %{
          id: id,
          tmps: format_readings_for_encoding(tmps),
          hum: format_readings_for_encoding(hum),
          moist: format_readings_for_encoding(moist),
          irrigations: format_readings_for_encoding(irrigations)
        }
    end)
    |> Jason.encode!()
  end

  defp format_readings_for_encoding(readings) do
    Enum.map(readings, &Tuple.to_list/1)
  end
end
