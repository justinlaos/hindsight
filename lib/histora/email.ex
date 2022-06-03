defmodule Histora.Email do
    import Bamboo.Email
    import Bamboo.Phoenix

    defp base_email do
        new_email()
        |> from("4jlaos@gmail.com") # Set a default from
        # |> put_html_layout({MyApp.LayoutView, "email.html"}) # Set default layout
        # |> put_text_layout({MyApp.LayoutView, "email.text"}) # Set default text layout
    end
end
