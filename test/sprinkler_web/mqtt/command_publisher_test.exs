defmodule SprinklerWeb.Mqtt.CommandPublisherTest do
  use ExUnit.Case, async: true
  import Mock

  @devise_id 123
  @command "command"

  describe "publisher methods" do
    test "send_command/2 publish the encoded command on the commands topic" do
      with_mock Tortoise, publish: fn _id, _topic, _message -> :ok end do
        SprinklerWeb.Mqtt.CommandPublisher.send_command(@devise_id, @command)

        enconded_command = Jason.encode!(@command)

        assert_called(
          Tortoise.publish(RootstrapSprinkler, "/rs/#{@devise_id}/commands", enconded_command)
        )
      end
    end
  end
end
