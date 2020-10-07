defmodule SprinklerMqtt.IrrigationsStorageTest do
  use ExUnit.Case, async: true

  alias SprinklerMqtt.IrrigationsStorage
  alias Sprinkler.Devices.Device

  setup _ do
    {:ok, _pid} = IrrigationsStorage.start_link()

    :ok
  end


  describe "add_irrigation/2" do
    test "creates the key when there are no previous irrigations" do
      device = %Device{id: 1}
      IrrigationsStorage.add_irrigation(device, :water_low)

      assert [{:water_low, _timestamp}] = IrrigationsStorage.get_irrigations(device)
    end

    test "updates the key when there are previous irrigations" do
      device = %Device{id: 1}
      IrrigationsStorage.add_irrigation(device, :water_low)
      IrrigationsStorage.add_irrigation(device, :water_high)

      assert [{:water_high, _second_timestamp}, {:water_low, _first_timestamp}] =
               IrrigationsStorage.get_irrigations(device)
    end

    test "sets the timestamp on the irrigation" do
      device = %Device{id: 1}
      IrrigationsStorage.add_irrigation(device, :water_low)

      assert [{:water_low, timestamp}] = IrrigationsStorage.get_irrigations(device)
      assert DateTime.diff(timestamp, DateTime.utc_now()) < 1
    end
  end

  describe "get_irrigations/1" do
    test "returns an empty array if there are no irrigations for the device" do
      device = %Device{id: 1}

      assert [] = IrrigationsStorage.get_irrigations(device)
    end
  end


  describe "get_today_irrigations/1" do
    test "returns an empty array if there are no irrigations for the device" do
      device = %Device{id: 1}

      assert [] = IrrigationsStorage.get_irrigations(device)
    end
  end
end
