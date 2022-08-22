defmodule Histora.Users do
  alias Histora.{Repo, Users.User}
  alias Histora.Users.User_favorite
  alias Histora.Decisions.Decision

  import Ecto.Query, warn: false

  @type t :: %User{}

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

  def create_admin(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: "admin", organization_id: params["organization_id"]})
    |> Repo.insert()
  end

  def is_admin?(%{role: "admin"}), do: true
  def is_admin?(_any), do: false

  def cancel_invite(user) do
    (from u in User, where: u.id == ^user.id) |> Repo.delete_all
  end

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

  def get_organization_users(organization) do
    (from u in User,
      where: u.organization_id == ^organization.id,
      preload: [:user_favorites, decisions: ^from(r in Decision, order_by: [desc: r.inserted_at], limit: 3, preload: [:tags, :user])],
      left_join: fav in assoc(u, :user_favorites),
      order_by: [desc: count(fav.id), desc: (u.id)],
      group_by: u.id,
      select: u
    )
    |> Repo.all()
  end

  def selected_filtered_users(organization, users) do
    cleaned_user_list = users |> Enum.map(&String.to_integer/1)

    (from u in User,
      where: u.organization_id == ^organization.id,
      where: u.id in ^cleaned_user_list
    )
    |> Repo.all()
  end

  def get_organization_users_for_settings(organization) do
    (from u in User, where: u.organization_id == ^organization.id, preload: :user_favorites )
    |> Repo.all()
  end

  def get_user!(id) do
    Repo.get!(User, id) |> Repo.preload(:user_favorites)
  end

  def get_decisions_for_user(id) do
    (Repo.all Ecto.assoc(Repo.get(User, id), :decisions))
      |> Repo.preload(:tags)
      |> Enum.group_by(& formate_time_stamp(&1.inserted_at))
      |> Enum.map(fn {inserted_at, decisions_collection} -> %{date: inserted_at, decisions: decisions_collection} end)
      |> Enum.reverse()
  end

  def formate_time_stamp(date) do
    case Timex.format({date.year, date.month, date.day}, "{Mfull} {D}, {YYYY}") do
      {:ok, date} -> date
      {:error, message} -> message
    end
  end

  def current_user_user_favorites(current_user) do
    (from uf in User_favorite, where: uf.user_id == ^current_user.id ) |> Repo.all()
  end

  def get_user_favorite!(favorite_user_id, user_id) do
    (from uf in User_favorite, where: uf.favorite_user_id == ^favorite_user_id and uf.user_id == ^user_id) |> Repo.one()
  end

  def create_user_favorite(attrs \\ %{}) do
    %User_favorite{}
    |> User_favorite.changeset(attrs)
    |> Repo.insert()
  end

  def delete_user_favorite(%User_favorite{} = user_favorite) do
    Repo.delete(user_favorite)
  end
end
