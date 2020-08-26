defmodule Sprinkler.Devices.WateringPolicyTest do
  use Sprinkler.DataCase

  alias Sprinkler.Devices.WateringPolicy

  # method to test
  # should_irrigate(moisture, temp, humidity)

  # reference values
  # @soil_moisture_wet 70
  # @soil_moisture_medium_wet 50
  # @ambience_temperature_high 25
  # @humidity_high 50

  # TODO: refactor this and the method. I noticed
  # when developed this test that it's a bit tricky to
  # remember the order of the params and the ref values.
  # For the ref values, I think I have to create some contastns
  # or 'context' because, when the ref values changes, I will have
  # to change all tests.. still investigating how can I do it.

  describe "when soil moisture is medium and ambience temp is high" do
    test "should return medium" do
      assert WateringPolicy.should_irrigate(55, 30, 45) == :medium
    end
  end

  describe "when soil moisture is medium and humidity is not high" do
    test "should return medium" do
      assert WateringPolicy.should_irrigate(55, 10, 40) == :low
    end
  end

  describe "when soil moisture is not medium and humidity is not high" do
    test "should return medium" do
      assert WateringPolicy.should_irrigate(25, 10, 40) == :high
    end
  end

  describe "when soil moisture is not medium, humidity is high and ambience temp is high" do
    test "should return medium" do
      assert WateringPolicy.should_irrigate(25, 40, 60) == :high
    end
  end

  describe "when soil moisture is not medium, humidity is high and ambience temp is not high" do
    test "should return medium" do
      assert WateringPolicy.should_irrigate(25, 20, 60) == :medium
    end
  end
end
