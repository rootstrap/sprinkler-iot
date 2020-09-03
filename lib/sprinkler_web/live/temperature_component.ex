defmodule SprinklerWeb.TemperatureComponent do
  use SprinklerWeb, :live_component
  require Logger

  def render(assigns) do
    ~L"""
     <div class="device">
      <h3>Sprinkler <%= @device[:id] %></h3>
      <div class="metrics-container">
        <div class="metrics-container__metric">
          <h4>Temperature</h4>
          <div><%= List.first(@device[:tmps]) %>º</div>
        </div>
        <div class="metrics-container__metric">
          <h4>Humidity</h4>
          <div><%= List.first(@device[:hum]) %></div>
        </div>
        <div class="metrics-container__metric">
          <h4>Soil Moisture</h4>
          <div><%= List.first(@device[:moist]) %></div>
        </div>
      </div>
    </div>
    """
  end
end
