defmodule HistoraWeb.OrganizationController do
  use HistoraWeb, :controller
  alias Histora.Organizations

  def home(conn, _params) do
    %{organization: organization} = conn.assigns
    render(conn, "home.html", organization: organization)
  end


end
