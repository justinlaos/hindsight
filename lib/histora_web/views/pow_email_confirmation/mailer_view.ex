defmodule HistoraWeb.PowEmailConfirmation.MailerView do
  use HistoraWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
