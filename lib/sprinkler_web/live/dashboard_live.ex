defmodule SprinklerWeb.DashboardLive do
  use SprinklerWeb, :live_view

 @telemetry_topic "telemetry"

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry_topic)
    {:ok, assign(socket, :devices,[device_1: %{id: 1, tmps: [2]}])}
  end

  def handle_info(
        %{topic: @telemetry_topic, event: "new_reading", payload: %{tmp: tmp, device_id: device_id}},
        socket
      ) do
    updated_list = socket.assigns.devices[device_id].tmps ++ [tmp]
    {:noreply, assign(socket, devices: updated_list)}
  end
end
