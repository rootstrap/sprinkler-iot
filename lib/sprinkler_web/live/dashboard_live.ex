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

    updated_list =
      Enum.map(socket.assigns.devices, fn
        %{id: ^device_id} = device ->
          device
          |> add_reading(:tmps, temperature)
          |> add_reading(:hum, humidity)
          |> add_reading(:moist, moisture)

        device ->
          device
      end)

    {:noreply, assign(socket, devices: updated_list)}
  end

  def add_reading(device, _metric_name, nil), do: device

  def add_reading(%{moist: metric_values} = device, :moist, value) do
    %{device | moist: [value | metric_values]}
  end

  def add_reading(%{hum: metric_values} = device, :hum, value) do
    %{device | hum: [value | metric_values]}
  end

  def add_reading(%{tmps: metric_values} = device, :tmps, value) do
    %{device | tmps: [value | metric_values]}
  end
end
