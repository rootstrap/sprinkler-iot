defmodule SprinklerWeb.MetricsComponent do
  use SprinklerWeb, :live_component
  require Logger

  def render(assigns) do
    ~L"""
     <div class="device">
      <h3>Sprinkler <%= @device[:id] %></h3>
      <div class="metrics-container">
        <div class="metrics-container__metric">
          <h4>Temperature</h4>
          <div><%= last_value(@device, :tmps) || "- " %>º</div>
        </div>
        <div class="metrics-container__metric">
          <h4>Humidity</h4>
          <div><%= last_value(@device, :hum) || "-" %></div>
        </div>
        <div class="metrics-container__metric">
          <h4>Soil Moisture</h4>
          <div><%= last_value(@device, :moist) || "-" %></div>
        </div>
        <div class="metrics-container__metric">
          <h4>Today Irrigations</h4>
          <div><%= last_value(@device, :irrigations) || "-" %></div>
        </div>
      </div>
    </div>
    """
  end

  defp last_value(metrics, metric_name) do
    case metrics[metric_name] do
      [{value, _timestamp} | _rest] -> value
      [] -> nil
    end
  end
end
