defmodule SprinklerMqtt.Commands do
  defmodule Irrigate do
    @derive {Jason.Encoder, only: [:water]}
    defstruct [:water]
  end
end
