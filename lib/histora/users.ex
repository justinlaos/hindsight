defmodule Histora.Users do
  alias Histora.{Repo, Users.User}

  @type t :: %User{}

  @spec create_admin(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def create_admin(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: "admin", organization_id: params["organization_id"]})
    |> Repo.insert()
  end

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: "user"})
    |> Repo.insert()
  end

  @spec set_admin_role(t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def set_admin_role(user) do
    user
    |> User.changeset_role(%{role: "admin"})
    |> Repo.update()
  end

  def set_user_role(user) do
    user
    |> User.changeset_role(%{role: "user"})
    |> Repo.update()
  end

  def is_admin?(%{role: "admin"}), do: true
  def is_admin?(_any), do: false

  @spec archive(map()) :: {:ok, map()} | {:error, map()}
  def archive(user) do
    user
    |> User.archive_changeset()
    |> Repo.update()
  end

  def unarchive(user) do
    user
    |> User.unarchive_changeset()
    |> Repo.update()
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
