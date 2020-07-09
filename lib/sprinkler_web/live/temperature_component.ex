defmodule SprinklerWeb.TemperatureComponent do
  use SprinklerWeb, :live_component
  require Logger

  def render(assigns) do
    ~L"""
    <div>Current temperature: <%= List.last(elem(@device, 1).tmps) %></div>
    """
  end
end
