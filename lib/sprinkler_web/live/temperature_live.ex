defmodule SprinklerWeb.TemperatureLive do
  use Phoenix.LiveView

  @telemetry_topic "telemetry"

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry_topic)

    {:ok, assign(socket, temp: "Unknown")}
  end

  def handle_info(
        %{topic: @telemetry_topic, event: "new_reading", payload: %{temp: temp}},
        socket
      ) do
    {:noreply, assign(socket, temp: temp)}
  end
end
