defmodule WebhooksController do
    use HistoraWeb, :controller
    import Ecto.Query, warn: false

    alias Histora.Organizations
    alias Histora.Users

    def webhooks(%Plug.Conn{body_params: stripe_event} = conn, _params) do
        case handle_webhook(stripe_event) do
            {:ok, user_email} -> {
                conn
                |> send_new_subscribe_admin_email(user_email)
                |> handle_success()
            }
            {:ok, _} -> handle_success(conn)
            {:error, error} -> handle_error(conn, error)
            _               -> handle_error(conn, "error")
        end
    end

    defp handle_success(conn) do
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, :ok)
    end

    defp handle_error(conn, error) do
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(422, error)
    end

    defp send_new_subscribe_admin_email(conn, user_email) do
        token = PowResetPassword.Plug.create_reset_token(conn, user_email)
        url = Routes.pow_reset_password_reset_password_url(conn, :edit, token)

        Histora.Email.new_subscribe(user_email, url)
        |> Histora.Mailer.deliver_now()
    end

    defp handle_webhook(%{"type" => "customer.subscription.created"} = stripe_event) do
        case Stripe.Customer.retrieve(stripe_event["data"]["object"]["customer"]) do
            {:ok, %Stripe.Customer{email: stripe_customer}} -> {
                # organization = Organizations.get_organization_by_billing_email(stripe_customer)

                # Organizations.update_organization(organization, %{
                #     "stripe_price_id" => stripe_event["data"]["object"]["plan"]["id"],
                #     "stripe_product_id" => stripe_event["data"]["object"]["plan"]["product"],
                #     "stripe_customer_id" => stripe_event["data"]["object"]["customer"],
                #     "stripe_subscription_id" => stripe_event["data"]["object"]["id"],
                #     "user_limit" => String.to_integer(stripe_event["data"]["object"]["plan"]["metadata"]["user_limit"]),
                #     "status" => "active",
                # })

                case Organizations.create_organization(%{
                    "stripe_price_id" => stripe_event["data"]["object"]["plan"]["id"],
                    "stripe_product_id" => stripe_event["data"]["object"]["plan"]["product"],
                    "stripe_customer_id" => stripe_event["data"]["object"]["customer"],
                    "stripe_subscription_id" => stripe_event["data"]["object"]["id"],
                    "billing_email" => stripe_customer,
                    "user_limit" => String.to_integer(stripe_event["data"]["object"]["plan"]["metadata"]["user_limit"]),
                    "name" => "New Organization",
                    "status" => "active",
                }) do
                    {:ok, organization} ->
                        password = UUID.uuid4(:hex)
                        case Users.create_admin(%{
                            "email" => stripe_customer,
                            "password" => password,
                            "password_confirmation" => password,
                            "role" => "admin",
                            "organization_id" => organization.id
                        }) do
                            {:ok, user} -> {:ok, user.email}
                            {:error, error} -> {:error, error}
                        end
                    {:error, error} -> {:error, error}
                end
            }
            {:error, error} -> {:error, error}
        end
    end

    defp handle_webhook(%{"type" => "customer.subscription.updated"} = stripe_event) do
        organization = Organizations.get_organization_by_subscription_id!(stripe_event["data"]["object"]["id"])
        if stripe_event["data"]["object"]["pause_collection"] != nil do
            Organizations.update_organization(organization, %{"status" => "paused"})
        else
            Organizations.update_organization(organization, %{
                "status" => "active",
                "stripe_price_id" => stripe_event["data"]["object"]["plan"]["id"],
                "stripe_product_id" => stripe_event["data"]["object"]["plan"]["product"],
                "stripe_subscription_id" => stripe_event["data"]["object"]["id"],
                "user_limit" => String.to_integer(stripe_event["data"]["object"]["plan"]["metadata"]["user_limit"]),
            })
        end
    end

    defp handle_webhook(%{"type" => "customer.subscription.deleted"} = stripe_event) do
        organization = Organizations.get_organization_by_subscription_id!(stripe_event["data"]["object"]["id"])
        Organizations.update_organization(organization, %{"status" => "cancled"})
    end

    # defp handle_webhook(%{"type" => "order.payment_failed"} = stripe_event) do

    # end


    # defp handle_webhook(%{"type" => "invoice.payment_failed"} = stripe_event) do

    # end
end
