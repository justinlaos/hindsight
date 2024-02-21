defmodule Hindsight.Email do
    use Bamboo.Phoenix, view: HindsightWeb.EmailView

    def new_subscribe(email, url) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("Welcome to Hindsight")
        |> assign(:url, url)
        |> render("new_subscribe.html")
    end

    def new_invite(email, url, invited_by, organization) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("Join #{organization.name} on Hindsight")
        |> assign(:url, url)
        |> assign(:invited_by, invited_by)
        |> assign(:organization, organization)
        |> render("new_invite.html")
    end

    def trial_expired(email, organization) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("#{organization.name}'s Hindsight trial has ended")
        |> assign(:organization, organization)
        |> render("trial_expired.html")
    end

    def request_approval(user, decision) do
        base_email() # Build your default email then customize for welcome
        |> to(user.email)
        |> subject("Decision Approval Requested")
        |> assign(:decision, decision)
        |> render("request_approval.html")
        |> premail()
    end

    def request_approval_response(approval) do
        base_email() # Build your default email then customize for welcome
        |> to(approval.decision.user.email)
        |> subject("Decision Approval Response")
        |> assign(:approval, approval)
        |> render("request_approval_response.html")
        |> premail()
    end

    def scheduled_reflection(decision) do
        base_email() # Build your default email then customize for welcome
        |> to(decision.user.email)
        |> subject("Scheduled Reflection")
        |> assign(:decision, decision)
        |> render("scheduled_reflection.html")
        |> premail()
    end

    def weekly_roundup(email, teams_with_decisions) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("Hindsight Weekly Roundup")
        |> assign(:teams_with_decisions, teams_with_decisions)
        |> render("weekly_roundup.html")
        |> premail()
    end

    defp premail(email) do
        html = Premailex.to_inline_css(email.html_body)
        text = Premailex.to_text(email.html_body)

        email
        |> html_body(html)
        |> text_body(text)
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
        |> from("team@hindsight.app") # Set a default from
        |> put_html_layout({HindsightWeb.LayoutView, "email.html"})
    end
end
