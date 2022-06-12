defmodule Histora.Email do
    import Bamboo.Email
    import Bamboo.Phoenix

    def new_subscribe(email, url) do
        base_email() # Build your default email then customize for welcome
        |> to(email)
        |> subject("Welcome to Histora")
        |> put_header("Reply-To", "4jlaos@gmail.com")
        |> html_body("<strong>Welcome to Histora</strong>")
        |> html_body("We are excited to help your busniess know its story")
        |> html_body("Get Started by clicking this link to set your password")
        |> html_body(url)
    end

    defp base_email do
        new_email()
        |> from("4jlaos@gmail.com") # Set a default from
        # |> put_html_layout({MyApp.LayoutView, "email.html"}) # Set default layout
        # |> put_text_layout({MyApp.LayoutView, "email.text"}) # Set default text layout
    end
end
