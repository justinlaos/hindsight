defmodule HistoraWeb.Admin.InvitationController do
  use HistoraWeb, :controller

  alias PowInvitation.{Plug}
  alias Histora.Users

  def create(conn, params) do
    case Plug.create_user(conn, params["user"]) do
      {:ok, user, conn} ->
        if params["role"] == "admin" do
          Users.set_admin_role(user)
        end

        deliver_email(conn, user)

        conn
        |> put_flash(:info, "Invitation sent")
        |> redirect(to: Routes.settings_path(conn, :organization))

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

    Histora.Email.new_invite(user.email, url)
      |> Histora.Mailer.deliver_now()
  end
end
