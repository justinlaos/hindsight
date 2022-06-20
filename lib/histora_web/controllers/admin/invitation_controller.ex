defmodule HistoraWeb.Admin.InvitationController do
  use HistoraWeb, :controller

  alias PowInvitation.{Plug}

  def create(conn, %{"user" => user_params}) do
    case Plug.create_user(conn, user_params) do
      {:ok, user, conn} ->
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
