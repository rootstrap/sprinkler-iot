defmodule SprinklerWeb.TemperatureLive do
  use Phoenix.LiveView

  @telemetry "telemetry"

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry)

    {:ok, assign(socket, temp: "Unknown")}
  end

  def handle_info(%{topic: @telemetry, temp: payload}, socket) do
    {:noreply, assign(socket, temp: payload)}
  end
end
