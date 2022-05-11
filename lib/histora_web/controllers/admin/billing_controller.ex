defmodule HistoraWeb.Admin.BillingController do
  use HistoraWeb, :controller

  def create_customer_portal_session(conn, %{"id" => id}) do
    {:ok, portal} = Stripe.BillingPortal.Session.create(%{:customer => id})
    redirect(conn, external: portal.url)
  end
end
