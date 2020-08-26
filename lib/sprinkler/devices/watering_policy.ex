defmodule Sprinkler.Devices.WateringPolicy do
  # TODO: check this values
  @soil_moisture_wet 70
  @soil_moisture_medium_wet 50
  @ambience_temperature_high 25
  @humidity_high 50

  def should_irrigate(moisture_input, temperature_input, humidity_input) do
    unless soil_moisture_wet?(moisture_input) do
      when_soil_moisture_not_wet(moisture_input, temperature_input, humidity_input)
    end
  end

  defp when_soil_moisture_not_wet(moisture_input, temperature_input, humidity_input) do
    if soil_moisture_medium?(moisture_input) do
      when_soil_moisture_medium(temperature_input, humidity_input)
    else
      when_soil_moisture_not_medium(temperature_input, humidity_input)
    end
  end

  defp when_soil_moisture_medium(temperature_input, humidity_input) do
    if ambience_temperature_high?(temperature_input) do
      :medium
    else
      unless humidity_high?(humidity_input) do
        :low
      end
    end
  end

  defp when_soil_moisture_not_medium(temperature_input, humidity_input) do
    if humidity_high?(humidity_input) do
      if ambience_temperature_high?(temperature_input) do
        :high
      else
        :medium
      end
    else
      :high
    end
  end

  defp soil_moisture_wet?(moisture_input) do
    moisture_input > @soil_moisture_wet
  end

  defp soil_moisture_medium?(moisture_input) do
    moisture_input > @soil_moisture_medium_wet
  end

  defp ambience_temperature_high?(temperature_input) do
    temperature_input > @ambience_temperature_high
  end

  defp humidity_high?(humidity_input) do
    humidity_input > @humidity_high
  end
end
