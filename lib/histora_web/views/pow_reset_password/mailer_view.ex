defmodule HistoraWeb.PowResetPassword.MailerView do
  use HistoraWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
