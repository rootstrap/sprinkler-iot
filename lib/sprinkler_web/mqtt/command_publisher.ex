defmodule SprinklerWeb.Mqtt.CommandPublisher do
  @moduledoc """
  This module is used to publish commands on the correct MQTT topic
  """

  def send_command(devise_id, command) do
    Tortoise.publish(RootstrapSprinkler, "/rs/#{devise_id}/commands", Jason.encode!(command))
  end
end
