defmodule HindsightWeb.Admin.InvitationController do
  use HindsightWeb, :controller

  alias PowInvitation.{Plug}
  alias Hindsight.Users

  def create(conn, params) do
    case Plug.create_user(conn, params["user"]) do
      {:ok, user, conn} ->
        Hindsight.Data.identify(user)
        Hindsight.Data.group(user)

        if params["role"] == "admin" do
          Users.set_admin_role(user)
          Hindsight.Data.event(user, "Invited As Admin")
          Hindsight.Data.event(conn.assigns.current_user, "Sent Invite To Admin")
        else
          Hindsight.Data.event(user, "Invited As User")
          Hindsight.Data.event(conn.assigns.current_user, "Sent Invite To User")
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

    Hindsight.Email.new_invite(user.email, url, conn.assigns.current_user.email, conn.assigns.organization)
      |> Hindsight.Mailer.deliver_now()
  end
end
