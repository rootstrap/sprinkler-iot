defmodule Sprinkler.Devices.WateringPolicyTest do
  use Sprinkler.DataCase

  # alias Sprinkler.Devices.GardenReading
  alias Sprinkler.Devices.WateringPolicy

  describe "when soil moisture is medium and ambience temp is high" do
    test "when humidity is not high should return medium" do
      assert WateringPolicy.irrigation_amount(%Devices.GardenReading{
               moisture: 55,
               temperature: 35,
               humidity: 25
             }) == :water_medium
    end

    test "when humidity is high should return medium" do
      assert WateringPolicy.irrigation_amount(%Devices.GardenReading{
               moisture: 55,
               temperature: 35,
               humidity: 55
             }) == :water_medium
    end
  end

  describe "when soil moisture is medium, ambience temp is low and humidity is low" do
    test "should return low" do
      assert WateringPolicy.irrigation_amount(%Devices.GardenReading{
               moisture: 55,
               temperature: 5,
               humidity: 15
             }) == :water_low
    end
  end

  describe "when soil moisture is low and humidity is low" do
    test "when ambience is low should return low" do
      assert WateringPolicy.irrigation_amount(%Devices.GardenReading{
               moisture: 15,
               temperature: 5,
               humidity: 15
             }) == :water_high
    end

    test "when ambience is high should return low" do
      assert WateringPolicy.irrigation_amount(%Devices.GardenReading{
               moisture: 15,
               temperature: 35,
               humidity: 15
             }) == :water_high
    end
  end

  describe "when soil moisture is low, ambience is low and humidity is high" do
    test "when ambience is low should return low" do
      assert WateringPolicy.irrigation_amount(%Devices.GardenReading{
               moisture: 15,
               temperature: 5,
               humidity: 65
             }) == :water_medium
    end
  end

  describe "when soil moisture is low, ambience is high and humidity is high" do
    test "when ambience is low should return low" do
      assert WateringPolicy.irrigation_amount(%Devices.GardenReading{
               moisture: 15,
               temperature: 35,
               humidity: 65
             }) == :water_high
    end
  end
end
