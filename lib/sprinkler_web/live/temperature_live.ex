defmodule SprinklerWeb.TemperatureLive do
  use Phoenix.LiveView

  @telemetry "telemetry"

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry)

    {:ok, assign(socket, temp: "Unknown")}
  end

  def handle_info(%{topic: @telemetry, event: "new_reading", payload: %{temp: temp}}, socket) do
    {:noreply, assign(socket, temp: temp)}
  end
end
