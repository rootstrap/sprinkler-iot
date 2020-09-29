defmodule SprinklerWeb.DashboardLive do
  use SprinklerWeb, :live_view

  @telemetry_topic "telemetry"

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry_topic)

    {:ok,
     assign(socket, :devices, [
       %{id: 1, tmps: [], hum: [], moist: [], irrigations: []},
       %{id: 2, tmps: [], hum: [], moist: [], irrigations: []}
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
