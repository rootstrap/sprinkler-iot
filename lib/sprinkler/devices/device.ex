defmodule Sprinkler.Devices.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :client_id, :string
    field :name, :string
    field :secret, :string

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:id, :name, :secret, :client_id])
    |> validate_required([:name, :secret, :client_id])
  end
end
