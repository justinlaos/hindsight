defmodule Histora.Users do
  alias Histora.{Repo, Users.User}
  alias Histora.Decisions.Decision
  alias Histora.Users.User_data
  alias Histora.Teams.Team_user
  import Ecto.Changeset

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
    (from ud in User_data, where: ud.user_id == ^user.id) |> Repo.delete_all
    (from ud in Team_user, where: ud.user_id == ^user.id) |> Repo.delete_all
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
      preload: [decisions: ^from(r in Decision, order_by: [desc: r.inserted_at], limit: 3, preload: [:goals, :user])],
      order_by: [desc: (u.id)],
      group_by: u.id,
      select: u
    )
    |> Repo.all()
  end

  def selected_filtered_users(organization, users) do
    (from u in User,
      where: u.organization_id == ^organization.id,
      where: u.id == ^String.to_integer(users)
    )
    |> Repo.all()
  end

  def get_organization_users_for_settings(organization) do
    (from u in User, where: u.organization_id == ^organization.id, preload: [:teams] )
    |> Repo.all()
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_decisions_for_user(id) do
    (Repo.all Ecto.assoc(Repo.get(User, id), :decisions))
      |> Repo.preload(:goals)
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

  def list_user_data do
    Repo.all(User_data)
  end

  def get_user_data!(id), do: Repo.get!(User_data, id)

  def create_user_data(attrs \\ %{}) do
    %User_data{}
    |> User_data.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_data_from_user(user) do
    (Repo.one Ecto.assoc(Repo.get(User, user.id), :user_data))
  end

  def update_user_data(%User_data{} = user_data, attrs) do
    user_data
    |> User_data.changeset(attrs)
    |> Repo.update()
  end

  def delete_user_data(%User_data{} = user_data) do
    Repo.delete(user_data)
  end

  def change_user_data(%User_data{} = user_data, attrs \\ %{}) do
    User_data.changeset(user_data, attrs)
  end
end
