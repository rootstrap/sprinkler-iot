defmodule Sprinkler.Repo do
  use Ecto.Repo,
    otp_app: :sprinkler,
    adapter: Ecto.Adapters.Postgres
end
