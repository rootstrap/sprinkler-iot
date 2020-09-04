defmodule Sprinkler.Devices.WateringPolicy do
  # TODO: check this values
  @soil_moisture_wet 70
  @soil_moisture_medium_wet 50
  @ambience_temperature_high 25
  @humidity_high 50

  alias Sprinkler.Devices.GardenReading

  def irrigation_amount(%GardenReading{
        moisture: moisture_input,
        temperature: temperature_input,
        humidity: humidity_input
      }) do
    soil_moisture = soil_moisture_level(moisture_input)
    temperature = temperature_level(temperature_input)
    humidity = humidity_level(humidity_input)

    case {soil_moisture, temperature, humidity} do
      {:medium, :high, _} -> :water_medium
      {:medium, :low, :low} -> :water_low
      {:low, _, :low} -> :water_high
      {:low, :low, :high} -> :water_medium
      {:low, :high, :high} -> :water_high
      {_, _, _} -> :no_water
    end
  end

  defp soil_moisture_level(value) do
    cond do
      value >= @soil_moisture_wet -> :high
      value >= @soil_moisture_medium_wet -> :medium
      value < @soil_moisture_medium_wet -> :low
    end
  end

  defp temperature_level(value) do
    if value >= @ambience_temperature_high do
      :high
    else
      :low
    end
  end

  defp humidity_level(value) do
    if value >= @humidity_high do
      :high
    else
      :low
    end
  end
end
