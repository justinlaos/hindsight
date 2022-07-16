defmodule Histora.Records.Record_user do
  use Ecto.Schema
  import Ecto.Changeset

  schema "record_users" do
    belongs_to(:user, Histora.Users.User)
    belongs_to(:record, Histora.Records.Record)

    timestamps()
  end

  @doc false
  def changeset(record_user, attrs) do
    record_user
    |> cast(attrs, [:user_id, :record_id])
    |> validate_required([:user_id, :record_id])
  end
end
