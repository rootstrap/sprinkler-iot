defmodule SprinklerMqtt.CommandPublisher do
  @moduledoc """
  This module is used to publish commands on the correct MQTT topic
  """
  alias Sprinkler.Devices.Device

  def send_command(%Device{id: device_id}, command) do
    Tortoise.publish(RootstrapSprinkler, "rs/#{device_id}/commands", Jason.encode!(command))
  end
end
