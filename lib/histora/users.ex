defmodule Histora.Users do
  alias Histora.{Repo, Users.User}
  alias Histora.Users.User_favorite
  alias Histora.Decisions.Decision
  alias Histora.Users.User_data
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
    (from u in User,
      where: u.organization_id == ^organization.id,
      where: u.id == ^String.to_integer(users)
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



  @doc """
  Returns the list of user_data.

  ## Examples

      iex> list_user_data()
      [%User_data{}, ...]

  """
  def list_user_data do
    Repo.all(User_data)
  end

  @doc """
  Gets a single user_data.

  Raises `Ecto.NoResultsError` if the User data does not exist.

  ## Examples

      iex> get_user_data!(123)
      %User_data{}

      iex> get_user_data!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_data!(id), do: Repo.get!(User_data, id)

  @doc """
  Creates a user_data.

  ## Examples

      iex> create_user_data(%{field: value})
      {:ok, %User_data{}}

      iex> create_user_data(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_data(attrs \\ %{}) do
    %User_data{}
    |> User_data.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_data_from_user(user) do
    (Repo.one Ecto.assoc(Repo.get(User, user.id), :user_data))
  end

  @doc """
  Updates a user_data.

  ## Examples

      iex> update_user_data(user_data, %{field: new_value})
      {:ok, %User_data{}}

      iex> update_user_data(user_data, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_data(%User_data{} = user_data, attrs) do
    user_data
    |> User_data.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_data.

  ## Examples

      iex> delete_user_data(user_data)
      {:ok, %User_data{}}

      iex> delete_user_data(user_data)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_data(%User_data{} = user_data) do
    Repo.delete(user_data)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_data changes.

  ## Examples

      iex> change_user_data(user_data)
      %Ecto.Changeset{data: %User_data{}}

  """
  def change_user_data(%User_data{} = user_data, attrs \\ %{}) do
    User_data.changeset(user_data, attrs)
  end
end
