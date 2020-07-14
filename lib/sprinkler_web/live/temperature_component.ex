defmodule SprinklerWeb.TemperatureComponent do
  use SprinklerWeb, :live_component
  require Logger

  def render(assigns) do
    ~L"""
    <div>Sprinkler <%= @device[:id] %></div>
    <div>Current temperature: <%= List.first(@device[:tmps]) %></div>
    """
  end
end
