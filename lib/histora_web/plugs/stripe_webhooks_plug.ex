defmodule HistoraWeb.StripeWebhooksPlug do
    @behaviour Plug

    def init(config), do: config

    def call(%{request_path: "/stripe/webhooks"} = conn, _) do

        signing_secret = System.get_env("WEBHOOK_SIGNING_SECRET")
        [stripe_signature] = Plug.Conn.get_req_header(conn, "stripe-signature")

        {:ok, body, _} = Plug.Conn.read_body(conn)

        case Stripe.Webhook.construct_event(body, stripe_signature, signing_secret) do
            {:ok, stripe_event} -> Plug.Conn.assign(conn, :stripe_event, stripe_event)
            {:error, _error} -> conn
        end

    end

    def call(conn, _), do: conn
end
