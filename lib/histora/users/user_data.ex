defmodule Histora.Users.User_data do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_data" do
    field :getting_started_completed, :boolean
    field :welcome_admin_completed, :boolean
    belongs_to(:user, Histora.Users.User)

    timestamps()
  end

  @doc false
  def changeset(user_data, attrs) do
    user_data
    |> cast(attrs, [:user_id, :getting_started_completed, :welcome_admin_completed])
    |> validate_required([:user_id])
  end
end
