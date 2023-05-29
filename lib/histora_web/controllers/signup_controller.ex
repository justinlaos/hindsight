defmodule HistoraWeb.SignupController do
  use HistoraWeb, :controller

  def signup(conn, params) do
    plan = if Map.has_key?(params, "plan"), do: params["plan"], else: "10"
    changeset = Pow.Plug.change_user(conn)
    render(conn, "signup.html", plan: plan, changeset: changeset)
  end

  def signupEmail(conn, params) do
    plan = if Map.has_key?(params, "plan"), do: params["plan"], else: "10"
    promo = if Map.has_key?(params, "promo"), do: params["promo"], else: nil
    changeset = Pow.Plug.change_user(conn)
    render(conn, "signup_email.html", plan: plan, changeset: changeset, promo: promo)
  end

  def create_organization_trial(conn, params) do
    email = if Map.has_key?(params["user"], "email"), do: params["user"]["email"], else: nil
    password = if Map.has_key?(params["user"], "password"), do: params["user"]["password"], else: nil
    plan = if Map.has_key?(params, "plan"), do: params["plan"], else: "10"
    promo = if Map.has_key?(params, "promo"), do: params["promo"], else: nil

    case Histora.Signup.create_organization_trial(email, password, plan, promo) do
      {:ok, user} ->
        conn
        |> Pow.Plug.authenticate_user(params["user"])
        |> case do
          {:ok, conn} ->
            Histora.Data.event(conn.assigns.current_user, "Signed Up")
            conn
            |> put_flash(:info, "Welcome back!")
            |> redirect(to: Routes.decision_path(conn, :index))
          end
      {:error, error} ->
        case is_map(error) do
          true ->
            conn |> redirect(to: Routes.signup_path(conn, :signup, error: "Password is not vaild, please use at least 6 charaters"))
          false ->
            conn |> redirect(to: Routes.signup_path(conn, :signup, error: error))

        end
    end
  end
end
