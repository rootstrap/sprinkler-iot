defmodule Sprinkler.Devices.WateringPolicy do
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
      irrigate('medium')
    else
      unless humidity_high?(humidity_input) do
        irrigate('low')
      end
    end
  end

  defp when_soil_moisture_not_medium(temperature_input, humidity_input) do
    if humidity_high?(humidity_input) do
      if ambience_temperature_high?(temperature_input) do
        irrigate('high')
      else
        irrigate('medium')
      end
    else
      irrigate('high')
    end
  end

  defp soil_moisture_wet?(moisture_input) do
    # TODO: check this values, 70%
    if moisture_input > 70 do
      true
    else
      false
    end
  end

  defp soil_moisture_medium?(moisture_input) do
    # TODO: check this values, medium > 50%
    if moisture_input > 50 do
      true
    else
      false
    end
  end

  defp ambience_temperature_high?(temperature_input) do
    # TODO: check this values, high > 25 grades
    if temperature_input > 25 do
      true
    else
      false
    end
  end

  defp humidity_high?(humidity_input) do
    # TODO: check this values, high > 50%
    if humidity_input > 50 do
      true
    else
      false
    end
  end

  defp irrigate(irrigate_input) do
    cond do
      irrigate_input == 'high' ->
        IO.puts("Irrigating high amount of water")

      irrigate_input == 'medium' ->
        IO.puts("Irrigating medium amount of water")

      true ->
        IO.puts("Irrigating low amount of water")
    end
  end
end
