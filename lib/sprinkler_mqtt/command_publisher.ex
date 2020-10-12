defmodule SprinklerMqtt.CommandPublisher do
  @moduledoc """
  This module is used to publish commands on the correct MQTT topic
  """
  require Logger

  alias Sprinkler.Devices.Device

  def send_command(%Device{id: device_id}, command) do
    encoded_command = Jason.encode!(command)
    topic = "rs/#{device_id}/commands"
    result = Tortoise.publish(RootstrapSprinkler, topic, encoded_command, qos: 2)

    case result do
      {:ok, _ref} ->
        Logger.info("Published #{encoded_command} to #{topic}")

      _ ->
        Logger.error(
          "Failed to publish #{encoded_command}" <>
            " to #{topic} #{inspect(result)}"
        )
    end

    result
  end
end
