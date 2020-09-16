defmodule SprinklerWeb.Mqtt.HandlerTest do
  use ExUnit.Case, async: true

  @telemetry_topic "telemetry"

  describe "handler methods" do
    import Mock
    alias Sprinkler.Devices
    alias SprinklerWeb.Mqtt.Commands.Irrigate, as: IrrigateCommand
    alias SprinklerWeb.Mqtt.Handler

    setup _ do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Sprinkler.Repo)

      :ok
    end

    test "init/1 returns ok" do
      assert Handler.init([]) == {:ok, []}
    end

    test "connection/2 returns ok" do
      assert Handler.connection(:up, []) == {:ok, []}
    end

    test "handle_message/3 returns ok" do
      assert Handler.handle_message(["rs", "2", "telemetry"], "{\"tmp\":24}", []) ==
               {:ok, []}
    end

    test "handle_message/3 broadcasts the received telemetry" do
      Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry_topic)
      Handler.handle_message(["rs", "2", "telemetry"], "{\"tmp\":24}", [])

      assert_receive %{
        topic: @telemetry_topic,
        event: "new_reading",
        payload: %{payload: %{"tmp" => 24}, device_id: 2}
      }
    end

    test "handle_message/3 sends a command to irrigate when necessary" do
      with_mock Tortoise, publish: fn _id, _topic, _message -> :ok end do
        reading = Jason.encode!(%{"tmp" => 27, "moist" => 40, "hum" => 60})
        device = device_fixture()

        Handler.handle_message(["rs", Integer.to_string(device.id), "telemetry"], reading, [])

        assert_called(
          Tortoise.publish(
            RootstrapSprinkler,
            "rs/#{device.id}/commands",
            Jason.encode!(%IrrigateCommand{water: 5})
          )
        )
      end
    end

    test "subscription/3 returns ok" do
      assert Handler.subscription(:up, "commands", []) == {:ok, []}
    end

    test "terminate/2 returns ok" do
      assert Handler.terminate("termination is imminent", []) == :ok
    end

    defp device_fixture do
      {:ok, device} =
        Devices.create_device(%{
          client_id: "123",
          name: "Some name",
          secret: "gfdgrfw"
        })

      device
    end
  end
end
