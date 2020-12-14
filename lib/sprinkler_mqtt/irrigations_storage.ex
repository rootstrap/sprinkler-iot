defmodule SprinklerMqtt.IrrigationsStorage do
  use Agent

  alias Sprinkler.Devices.Device

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_irrigation(%Device{id: device_id}, irrigation_level) do
    new_irrigation = {irrigation_level, DateTime.utc_now()}

    Agent.update(__MODULE__, fn irrigations ->
      Map.update(irrigations, device_id, [new_irrigation], &[new_irrigation | &1])
    end)
  end

  def get_irrigations(%Device{id: device_id}) do
    Agent.get(__MODULE__, &(&1[device_id] || []))
  end

  def today_irrigations(%Device{id: device_id}) do
    Agent.get(__MODULE__, fn irrigations ->
      []
    end)
  end
end
