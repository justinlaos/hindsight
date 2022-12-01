defmodule Histora.Email do
    import Bamboo.Email
    use Bamboo.Phoenix, view: HistoraWeb.EmailView

    def new_subscribe(email, url) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("Welcome to Histora")
        |> assign(:url, url)
        |> render("new_subscribe.html")
    end

    def new_invite(email, url, invited_by, organization) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("Join #{organization.name} on Histora")
        |> assign(:url, url)
        |> assign(:invited_by, invited_by)
        |> assign(:organization, organization)
        |> render("new_invite.html")
    end

    def trial_expired(email, organization) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("#{organization.name}'s Histora trial has ended")
        |> assign(:organization, organization)
        |> render("trial_expired.html")
    end

    def new_trial(email, organization, promo) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("New Trial: #{organization.billing_email} #{promo}")
        |> assign(:organization, organization)
        |> render("admin/new_trial.html")
    end

    defp base_email do
        new_email()
        |> from("team@histora.app") # Set a default from
        # |> put_html_layout({MyApp.LayoutView, "email.html"}) # Set default layout
        # |> put_text_layout({MyApp.LayoutView, "email.text"}) # Set default text layout
    end
end
