defmodule Histora.Users.User_favorite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_favorites" do
    belongs_to(:favorite_user, Histora.Users.User)
    belongs_to(:user, Histora.Users.User)

    timestamps()
  end

  @doc false
  def changeset(user_favorite, attrs) do
    user_favorite
    |> cast(attrs, [:user_id, :favorite_user_id])
    |> validate_required([:user_id, :favorite_user_id])
  end
end
