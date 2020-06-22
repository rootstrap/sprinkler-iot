defmodule Sprinkler.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string
      add :secret, :string
      add :client_id, :string

      timestamps()
    end

  end
end
