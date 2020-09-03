defmodule SprinklerWeb.DashboardLive do
  use SprinklerWeb, :live_view

  @telemetry_topic "telemetry"

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry_topic)

    {:ok,
     assign(socket, :devices, [
       %{id: 1, tmps: [5], hum: [2], moist: [2]},
       %{id: 2, tmps: [5], hum: [2], moist: [2]}
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
    tmp = payload["tmp"]
    hum = payload["hum"]
    moist = payload["moist"]

    updated_list =
      Enum.map(socket.assigns.devices, fn
        %{id: ^device_id, tmps: tmps} = device ->
          %{device | tmps: [tmp | tmps], hum: [hum | hum], moist: [moist | moist]}

        device ->
          device
      end)

    {:noreply, assign(socket, devices: updated_list)}
  end
end
