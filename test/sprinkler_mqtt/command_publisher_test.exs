defmodule SprinklerMqtt.CommandPublisherTest do
  use ExUnit.Case, async: false
  import Mock
  alias Sprinkler.Devices.Device

  @device %Device{id: 123}
  @command %{"water" => 1}

  describe "publisher methods" do
    test "send_command/2 publish the encoded command on the commands topic" do
      with_mock Tortoise, publish: fn _id, _topic, _message -> :ok end do
        SprinklerMqtt.CommandPublisher.send_command(@device, @command)

        enconded_command = Jason.encode!(@command)

        assert_called(
          Tortoise.publish(RootstrapSprinkler, "rs/#{@device.id}/commands", enconded_command)
        )
      end
    end
  end
end
