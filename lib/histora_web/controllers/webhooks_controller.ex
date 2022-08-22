defmodule WebhooksController do
    use HistoraWeb, :controller
    import Ecto.Query, warn: false

    alias Histora.Organizations
    alias Histora.Users

    def webhooks(%Plug.Conn{body_params: stripe_event} = conn, _params) do
        case handle_webhook(stripe_event) do
            {{:ok, user_email}} -> {
                conn
                |> PowResetPassword.Plug.create_reset_token(%{"email" => user_email})
                |> maybe_send_email(user_email)

            }
            {{:error, error}} -> handle_error(conn, error)
        end
        Plug.Conn.send_resp(conn, 200, "ok")
    end


    defp handle_error(conn, error) do
        conn
        |> send_resp(422, error)
    end

    defp handle_webhook(%{"type" => "customer.subscription.created"} = stripe_event) do
        case Stripe.Customer.retrieve(stripe_event["data"]["object"]["customer"]) do
            {:ok, %{email: email}} -> {
                if Organizations.get_organization_by_billing_email(email) == nil do
                    create_organization(stripe_event, email)
                else
                    Organizations.update_organization(Organizations.get_organization_by_billing_email(email), %{
                        "stripe_price_id" => stripe_event["data"]["object"]["plan"]["id"],
                        "stripe_product_id" => stripe_event["data"]["object"]["plan"]["product"],
                        "stripe_customer_id" => stripe_event["data"]["object"]["customer"],
                        "stripe_subscription_id" => stripe_event["data"]["object"]["id"],
                        "user_limit" => String.to_integer(stripe_event["data"]["object"]["plan"]["metadata"]["user_limit"]),
                        "status" => "active",
                    })
                end
            }
            {:error, error} -> {:error, error}
        end
    end

    defp handle_webhook(%{"type" => "customer.subscription.updated"} = stripe_event) do
        organization = Organizations.get_organization_by_subscription_id!(stripe_event["data"]["object"]["id"])
        if stripe_event["data"]["object"]["pause_collection"] != nil do
            Organizations.update_organization(organization, %{"status" => "paused"})
            Histora.Data.event(organization.billing_email, "Subscription Paused")
        else
            Organizations.update_organization(organization, %{
                "status" => "active",
                "stripe_price_id" => stripe_event["data"]["object"]["plan"]["id"],
                "stripe_product_id" => stripe_event["data"]["object"]["plan"]["product"],
                "stripe_subscription_id" => stripe_event["data"]["object"]["id"],
                "user_limit" => String.to_integer(stripe_event["data"]["object"]["plan"]["metadata"]["user_limit"]),
            })
            Histora.Data.event(organization.billing_email, "Subscription Updated")
        end
    end

    defp handle_webhook(%{"type" => "customer.subscription.deleted"} = stripe_event) do
        organization = Organizations.get_organization_by_subscription_id!(stripe_event["data"]["object"]["id"])
        Organizations.update_organization(organization, %{"status" => "cancled"})
        Histora.Data.event(organization.billing_email, "Subscription Canceled")
    end

    # defp handle_webhook(%{"type" => "order.payment_failed"} = stripe_event) do

    # end


    # defp handle_webhook(%{"type" => "invoice.payment_failed"} = stripe_event) do

    # end


    defp create_organization(stripe_event, email) do
        case Organizations.create_organization(%{
            "stripe_price_id" => stripe_event["data"]["object"]["plan"]["id"],
            "stripe_product_id" => stripe_event["data"]["object"]["plan"]["product"],
            "stripe_customer_id" => stripe_event["data"]["object"]["customer"],
            "stripe_subscription_id" => stripe_event["data"]["object"]["id"],
            "billing_email" => email,
            "user_limit" => String.to_integer(stripe_event["data"]["object"]["plan"]["metadata"]["user_limit"]),
            "name" => "New Organization",
            "status" => "active",
        }) do
            {:ok, organization} ->
                password = UUID.uuid4(:hex)
                case Users.create_admin(%{
                    "email" => email,
                    "password" => password,
                    "password_confirmation" => password,
                    "role" => "admin",
                    "organization_id" => organization.id
                }) do
                    {:ok, user} ->
                        Histora.Data.identify(user)
                        Histora.Data.group(user)
                        Histora.Data.event(user, "Subscription Created")
                        {:ok, user.email}
                    {:error, error} -> {:error, error}
                end
            {:error, error} -> {:error, error}
        end
    end


    # Send Email Functions
    defp maybe_send_email({:ok, %{token: token, user: user}, conn}, email_address) do
        deliver_email(conn, user, token)

        {:ok, %{email: email_address}}
    end

    defp maybe_send_email({:error, _, _}, email_address) do
        {:ok, %{email: email_address}}
    end

    defp conn(), do: Pow.Plug.put_config(%Plug.Conn{}, otp_app: :golf)

    defp deliver_email(conn, user, token) do
        url = reset_password_url(token)

        Histora.Email.new_subscribe(user.email, url)
        |> Histora.Mailer.deliver_now()

        Histora.Data.event(user, "Sent Welcome Email")
    end

    defp reset_password_url(token) do
        Routes.pow_reset_password_reset_password_url(
            HistoraWeb.Endpoint,
            :edit,
            token
        )
    end
end
