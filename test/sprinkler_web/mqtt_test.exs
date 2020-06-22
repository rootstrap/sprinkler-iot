defmodule SprinklerWeb.MqttTest do
  use ExUnit.Case, async: true

  describe "handler" do
    alias SprinklerWeb.Mqtt.Handler

    test "init/1 returns ok" do
      assert Handler.init([]) == {:ok, []}
    end

    test "connection/2 returns ok" do
      assert Handler.connection(:up, []) == {:ok, []}
    end

    test "handle_message/3 returns ok" do
      assert Handler.handle_message(["rs", Arduino, "telemetry"], "Just a message", []) ==
               {:ok, []}
    end

    test "subscription/3 returns ok" do
      assert Handler.subscription(:up, "commands", []) == {:ok, []}
    end

    test "terminate/2 returns ok" do
      assert Handler.terminate("termination is imminent", []) == :ok
    end
  end
end
