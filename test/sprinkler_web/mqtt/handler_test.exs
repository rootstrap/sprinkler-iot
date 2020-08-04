defmodule SprinklerWeb.Mqtt.HandlerTest do
  use ExUnit.Case, async: true

  @telemetry_topic "telemetry"

  describe "handler methods" do
    alias SprinklerWeb.Mqtt.Handler

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

    test "subscription/3 returns ok" do
      assert Handler.subscription(:up, "commands", []) == {:ok, []}
    end

    test "terminate/2 returns ok" do
      assert Handler.terminate("termination is imminent", []) == :ok
    end

    test "handle_message/3 when telemetry is received" do
      Phoenix.PubSub.subscribe(Sprinkler.PubSub, @telemetry_topic)
      Handler.handle_message(["rs", "2", "telemetry"], "{\"tmp\":24}", [])

      assert_receive %{
        topic: @telemetry_topic,
        event: "new_reading",
        payload: %{payload: %{"tmp" => 24}, device_id: 2}
      }
    end
  end
end
