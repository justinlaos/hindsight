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

    def new_invite(email, url) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("Welcome to Histora")
        |> assign(:url, url)
        |> render("new_invite.html")
    end
        # |> put_header("Reply-To", "4jlaos@gmail.com")
        # |> html_body("<strong>Welcome to Histora</strong> <br>
        #     <p>Get Started by clicking this link to set your password</p> <br>
        #     <a href=`"#{ url }"`>Set Password</a>
        # ")


    defp base_email do
        new_email()
        |> from("team@histora.app") # Set a default from
        # |> put_html_layout({MyApp.LayoutView, "email.html"}) # Set default layout
        # |> put_text_layout({MyApp.LayoutView, "email.text"}) # Set default text layout
    end
end
