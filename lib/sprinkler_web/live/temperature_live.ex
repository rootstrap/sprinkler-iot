defmodule SprinklerWeb.TemperatureLive do
  use Phoenix.LiveView

  @telemetry_topic "telemetry"

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry_topic)

    {:ok, assign(socket, tmp: "Unknown")}
  end

  def handle_info(
        %{topic: @telemetry_topic, event: "new_reading", payload: %{tmp: tmp}},
        socket
      ) do
    {:noreply, assign(socket, tmp: tmp)}
  end
end
