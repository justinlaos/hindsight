defmodule Hindsight.Repo do
  use Ecto.Repo,
    otp_app: :hindsight,
    adapter: Ecto.Adapters.Postgres
end
