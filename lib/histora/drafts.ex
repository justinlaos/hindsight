defmodule Histora.Drafts do
  @moduledoc """
  The Drafts context.
  """

  import Ecto.Query, warn: false
  alias Histora.Repo

  alias Histora.Drafts.Draft
  alias Histora.Drafts.Draft_user
  alias Histora.Scopes.Scope
  alias Histora.Drafts.Draft_scope

  alias Histora.Scopes.Scope_user

  @doc """
  Returns the list of drafts.

  ## Examples

      iex> list_drafts()
      [%Draft{}, ...]

  """
  def list_drafts do
    Repo.all(Draft)
  end

  def list_organization_drafts(organization) do
    (from d in Draft, where: d.organization_id == ^organization.id and d.converted == false )
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def list_your_drafts(user_id, organization_id) do
    (from d in Draft, where: d.organization_id == ^organization_id and
    d.user_id == ^user_id and d.converted == false )
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def list_scope_drafts(user_id, organization_id) do
    scopes = (from su in Scope_user, where: su.user_id == ^user_id, select: su.scope_id) |> Repo.all()
    draft_scopes = (from ds in Draft_scope, where: ds.scope_id in ^scopes, select: ds.draft_id) |> Repo.all()

    (from d in Draft, where: d.id in ^draft_scopes and d.organization_id == ^organization_id and d.converted == false )
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def list_connected_drafts(user_id, organization_id) do
    draft_users = (from du in Draft_user, where: du.user_id == ^user_id, select: du.draft_id) |> Repo.all()
    (from d in Draft, where: d.id in ^draft_users and d.organization_id == ^organization_id and d.converted == false )
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def assign_scopes_to_draft(scopes, draft_id) do
    for scope <- scopes do
      case Repo.get(Scope, scope) do
        scope -> create_draft_scope(%{"scope_id" => scope.id, "draft_id" => draft_id})
      end
    end
  end

  def create_draft_users(users, draft_id) do
    for user <- users |> Enum.map(&String.to_integer/1) do
      %Draft_user{}
        |> Draft_user.changeset(%{"user_id" => user, "draft_id" => draft_id})
        |> Repo.insert()
    end
  end

  def delete_draft_users(draft_id) do
    Ecto.assoc(Repo.get(Draft, draft_id), :draft_users) |> Repo.delete_all
  end

  def get_draft_scopes(draft_id) do
    Ecto.assoc(Repo.get(Draft, draft_id), :scopes) |> Repo.all
  end

  def delete_scopes_from_draft(draft_id) do
    Ecto.assoc(Repo.get(Draft, draft_id), :draft_scopes) |> Repo.delete_all
  end

  def mark_option_as_selected(draft_id) do
    Drafts.update_draft_option(draft_id, %{"selected" => true})
  end

  def convert_draft(draft_id, user_id, decision, date) do
    draft = get_draft!(draft_id)

    Histora.Decisions.create_decision(%{
      "draft_id" => draft_id,
      "user_id" => user_id,
      "organization_id" => draft.organization_id,
      "reference" => draft.reference,
      "what" => decision["what"],
      "why" => decision["why"],
      "date" => date
    })
  end

  @doc """
  Gets a single draft.

  Raises `Ecto.NoResultsError` if the Draft does not exist.

  ## Examples

      iex> get_draft!(123)
      %Draft{}

      iex> get_draft!(456)
      ** (Ecto.NoResultsError)

  """
  def get_draft!(id), do: Repo.get!(Draft, id) |> Repo.preload([:user, :users, :scopes, :draft_votes, draft_options: [:user, :draft_votes]])

  def create_draft_users(users, draft) do
    for user_item <- users |> Enum.map(&String.to_integer/1) do
      %Draft_user{}
        |> Draft_user.changeset(%{"user_id" => user_item, "draft_id" => draft})
        |> Repo.insert()
    end
  end

  def update_draft_users(users, draft_id) do
    (from du in Draft_user, where: du.draft_id == ^draft_id) |> Repo.delete_all
    for user_item <- users |> Enum.map(&String.to_integer/1) do
      %Draft_user{}
        |> Draft_user.changeset(%{"user_id" => user_item, "draft_id" => draft_id})
        |> Repo.insert()
    end
  end

  def get_draft_users(id) do
    (Repo.all Ecto.assoc(Repo.get(Draft, id), :users))
  end

  def get_draft_scope_users(id) do
    scopes = (Repo.all Ecto.assoc(Repo.get(Draft, id), :scopes)) |> Repo.preload([:users])
    users = Enum.map(scopes, fn scope -> scope.users end) |> List.flatten()
  end

  def get_user_drafts(id) do
    (Repo.all Ecto.assoc(Repo.get(User, id), :drafts))
  end

  def get_draft_connected_users(id) do
    draft_user = get_draft!(id).user
    draft_users = (Repo.all Ecto.assoc(Repo.get(Draft, id), :users))
    scope_users = (Repo.all Ecto.assoc(Repo.get(Draft, id), :scopes)) |> Repo.preload([:users]) |> Enum.map(fn scope -> scope.users end)

    Enum.uniq(List.flatten([draft_users, scope_users, draft_user]))
  end

  @doc """
  Creates a draft.

  ## Examples

      iex> create_draft(%{field: value})
      {:ok, %Draft{}}

      iex> create_draft(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_draft(attrs \\ %{}) do
    %Draft{}
    |> Draft.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a draft.

  ## Examples

      iex> update_draft(draft, %{field: new_value})
      {:ok, %Draft{}}

      iex> update_draft(draft, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_draft(%Draft{} = draft, attrs) do
    draft
    |> Draft.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a draft.

  ## Examples

      iex> delete_draft(draft)
      {:ok, %Draft{}}

      iex> delete_draft(draft)
      {:error, %Ecto.Changeset{}}

  """
  def delete_draft(%Draft{} = draft) do
    Repo.delete(draft)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking draft changes.

  ## Examples

      iex> change_draft(draft)
      %Ecto.Changeset{data: %Draft{}}

  """
  def change_draft(%Draft{} = draft, attrs \\ %{}) do
    Draft.changeset(draft, attrs)
  end



  @doc """
  Returns the list of draft_users.

  ## Examples

      iex> list_draft_users()
      [%Draft_user{}, ...]

  """
  def list_draft_users do
    Repo.all(Draft_user)
  end

  @doc """
  Gets a single draft_user.

  Raises `Ecto.NoResultsError` if the Draft user does not exist.

  ## Examples

      iex> get_draft_user!(123)
      %Draft_user{}

      iex> get_draft_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_draft_user!(id), do: Repo.get!(Draft_user, id)

  @doc """
  Creates a draft_user.

  ## Examples

      iex> create_draft_user(%{field: value})
      {:ok, %Draft_user{}}

      iex> create_draft_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_draft_user(attrs \\ %{}) do
    %Draft_user{}
    |> Draft_user.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a draft_user.

  ## Examples

      iex> update_draft_user(draft_user, %{field: new_value})
      {:ok, %Draft_user{}}

      iex> update_draft_user(draft_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_draft_user(%Draft_user{} = draft_user, attrs) do
    draft_user
    |> Draft_user.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a draft_user.

  ## Examples

      iex> delete_draft_user(draft_user)
      {:ok, %Draft_user{}}

      iex> delete_draft_user(draft_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_draft_user(%Draft_user{} = draft_user) do
    Repo.delete(draft_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking draft_user changes.

  ## Examples

      iex> change_draft_user(draft_user)
      %Ecto.Changeset{data: %Draft_user{}}

  """
  def change_draft_user(%Draft_user{} = draft_user, attrs \\ %{}) do
    Draft_user.changeset(draft_user, attrs)
  end



  @doc """
  Returns the list of draft_scopes.

  ## Examples

      iex> list_draft_scopes()
      [%Draft_scope{}, ...]

  """
  def list_draft_scopes do
    Repo.all(Draft_scope)
  end

  @doc """
  Gets a single draft_scope.

  Raises `Ecto.NoResultsError` if the Draft scope does not exist.

  ## Examples

      iex> get_draft_scope!(123)
      %Draft_scope{}

      iex> get_draft_scope!(456)
      ** (Ecto.NoResultsError)

  """
  def get_draft_scope!(id), do: Repo.get!(Draft_scope, id)

  @doc """
  Creates a draft_scope.

  ## Examples

      iex> create_draft_scope(%{field: value})
      {:ok, %Draft_scope{}}

      iex> create_draft_scope(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_draft_scope(attrs \\ %{}) do
    %Draft_scope{}
    |> Draft_scope.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a draft_scope.

  ## Examples

      iex> update_draft_scope(draft_scope, %{field: new_value})
      {:ok, %Draft_scope{}}

      iex> update_draft_scope(draft_scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_draft_scope(%Draft_scope{} = draft_scope, attrs) do
    draft_scope
    |> Draft_scope.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a draft_scope.

  ## Examples

      iex> delete_draft_scope(draft_scope)
      {:ok, %Draft_scope{}}

      iex> delete_draft_scope(draft_scope)
      {:error, %Ecto.Changeset{}}

  """
  def delete_draft_scope(%Draft_scope{} = draft_scope) do
    Repo.delete(draft_scope)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking draft_scope changes.

  ## Examples

      iex> change_draft_scope(draft_scope)
      %Ecto.Changeset{data: %Draft_scope{}}

  """
  def change_draft_scope(%Draft_scope{} = draft_scope, attrs \\ %{}) do
    Draft_scope.changeset(draft_scope, attrs)
  end

  alias Histora.Drafts.Draft_option

  @doc """
  Returns the list of draft_options.

  ## Examples

      iex> list_draft_options()
      [%Draft_option{}, ...]

  """
  def list_draft_options do
    Repo.all(Draft_option)
  end

  @doc """
  Gets a single draft_option.

  Raises `Ecto.NoResultsError` if the Draft option does not exist.

  ## Examples

      iex> get_draft_option!(123)
      %Draft_option{}

      iex> get_draft_option!(456)
      ** (Ecto.NoResultsError)

  """
  def get_draft_option!(id), do: Repo.get!(Draft_option, id)

  @doc """
  Creates a draft_option.

  ## Examples

      iex> create_draft_option(%{field: value})
      {:ok, %Draft_option{}}

      iex> create_draft_option(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_draft_option(attrs \\ %{}) do
    %Draft_option{}
    |> Draft_option.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a draft_option.

  ## Examples

      iex> update_draft_option(draft_option, %{field: new_value})
      {:ok, %Draft_option{}}

      iex> update_draft_option(draft_option, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_draft_option(%Draft_option{} = draft_option, attrs) do
    draft_option
    |> Draft_option.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a draft_option.

  ## Examples

      iex> delete_draft_option(draft_option)
      {:ok, %Draft_option{}}

      iex> delete_draft_option(draft_option)
      {:error, %Ecto.Changeset{}}

  """
  def delete_draft_option(%Draft_option{} = draft_option) do
    Repo.delete(draft_option)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking draft_option changes.

  ## Examples

      iex> change_draft_option(draft_option)
      %Ecto.Changeset{data: %Draft_option{}}

  """
  def change_draft_option(%Draft_option{} = draft_option, attrs \\ %{}) do
    Draft_option.changeset(draft_option, attrs)
  end

  alias Histora.Drafts.Draft_vote

  @doc """
  Returns the list of draft_votes.

  ## Examples

      iex> list_draft_votes()
      [%Draft_vote{}, ...]

  """
  def list_draft_votes do
    Repo.all(Draft_vote)
  end

  def delete_other_votes_for_draft(user_id, draft_id) do
    (from dv in Draft_vote, where: dv.draft_id == ^draft_id and dv.user_id == ^user_id) |> Repo.delete_all
  end

  @doc """
  Gets a single draft_vote.

  Raises `Ecto.NoResultsError` if the Draft vote does not exist.

  ## Examples

      iex> get_draft_vote!(123)
      %Draft_vote{}

      iex> get_draft_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_draft_vote!(id), do: Repo.get!(Draft_vote, id)

  @doc """
  Creates a draft_vote.

  ## Examples

      iex> create_draft_vote(%{field: value})
      {:ok, %Draft_vote{}}

      iex> create_draft_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_draft_vote(attrs \\ %{}) do
    %Draft_vote{}
    |> Draft_vote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a draft_vote.

  ## Examples

      iex> update_draft_vote(draft_vote, %{field: new_value})
      {:ok, %Draft_vote{}}

      iex> update_draft_vote(draft_vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_draft_vote(%Draft_vote{} = draft_vote, attrs) do
    draft_vote
    |> Draft_vote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a draft_vote.

  ## Examples

      iex> delete_draft_vote(draft_vote)
      {:ok, %Draft_vote{}}

      iex> delete_draft_vote(draft_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_draft_vote(%Draft_vote{} = draft_vote) do
    Repo.delete(draft_vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking draft_vote changes.

  ## Examples

      iex> change_draft_vote(draft_vote)
      %Ecto.Changeset{data: %Draft_vote{}}

  """
  def change_draft_vote(%Draft_vote{} = draft_vote, attrs \\ %{}) do
    Draft_vote.changeset(draft_vote, attrs)
  end
end
