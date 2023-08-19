defmodule HistoraWeb.Admin.InvitationController do
  use HistoraWeb, :controller

  alias PowInvitation.{Plug}
  alias Histora.Users

  def create(conn, params) do
    case Plug.create_user(conn, params["user"]) do
      {:ok, user, conn} ->
        Histora.Data.identify(user)
        Histora.Data.group(user)

        if params["role"] == "admin" do
          Users.set_admin_role(user)
          Histora.Data.event(user, "Invited As Admin")
          Histora.Data.event(conn.assigns.current_user, "Sent Invite To Admin")
        else
          Histora.Data.event(user, "Invited As User")
          Histora.Data.event(conn.assigns.current_user, "Sent Invite To User")
        end

        deliver_email(conn, user)
        Users.create_user_data(%{user_id: user.id})

        conn
        |> put_flash(:info, "Invitation sent")
        |> redirect(to: Routes.organization_path(conn, :index))

      {:error, changeset, conn} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  defp deliver_email(conn, user) do
    token      = Plug.sign_invitation_token(conn, user)
    url        = Routes.pow_invitation_invitation_url(conn, :edit, token)
    invited_by = Pow.Plug.current_user(conn)

    Histora.Email.new_invite(user.email, url, conn.assigns.current_user.email, conn.assigns.organization)
      |> Histora.Mailer.deliver_now()
  end
end
