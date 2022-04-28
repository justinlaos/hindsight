defmodule Histora.Repo do
  use Ecto.Repo,
    otp_app: :histora,
    adapter: Ecto.Adapters.Postgres
end
