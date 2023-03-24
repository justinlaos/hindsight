defmodule Histora.Reflections.Reflection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reflections" do
    field :content, :string
    field :status, :string

    belongs_to :organization, Histora.Organizations.Organization
    belongs_to :decision, Histora.Decisions.Decision
    belongs_to :user, Histora.Users.User

    has_many(:decisions, Histora.Decisions.Decision)

    timestamps()
  end

  @doc false
  def changeset(reflection, attrs) do
    reflection
    |> cast(attrs, [:user_id, :organization_id, :decision_id, :content, :status])
    |> validate_required([])
  end
end
