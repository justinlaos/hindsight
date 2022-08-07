defmodule HistoraWeb.SearchController do
  use HistoraWeb, :controller
  alias Histora.Decisions.Decision
  alias Histora.Repo
  import Ecto.Query, warn: false

  def results(conn, %{"search_term" => search_term}) do
    %{organization: organization} = conn.assigns

    search_str =
      search_term
      |> String.split(" ")
      |> Enum.intersperse("%")
      |> Enum.join()
      |> then(&"%#{&1}%")

    search_results = from(r in Decision,
      where: fragment("? ilike ?", r.content, ^search_str),
      order_by: [desc: r.updated_at]
    )
    |> Repo.all()
    |> Repo.preload([:tags, :scopes, :users, user: :user_favorites])

    render(conn, "results.html", organization: organization, search_term: search_term, search_results: search_results)
  end

  def results(conn, _search_term) do
    %{organization: organization} = conn.assigns

    render(conn, "no_results.html", organization: organization)
  end
end
