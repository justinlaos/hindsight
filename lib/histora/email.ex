defmodule Histora.Email do
    import Bamboo.Email
    import Bamboo.Phoenix

    def new_subscribe(email, url) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("Welcome to Histora")
        |> put_header("Reply-To", "4jlaos@gmail.com")
        |> html_body("<strong>Welcome to Histora</strong> <br>
            <p>Get Started by clicking this link to set your password</p> <br>
            <a href=`<%= url %>`>Set Password</a>
        ")
    end

    defp base_email do
        new_email()
        |> from("4jlaos@gmail.com") # Set a default from
        # |> put_html_layout({MyApp.LayoutView, "email.html"}) # Set default layout
        # |> put_text_layout({MyApp.LayoutView, "email.text"}) # Set default text layout
    end
end
