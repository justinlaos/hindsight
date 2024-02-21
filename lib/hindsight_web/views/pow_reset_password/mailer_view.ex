defmodule HindsightWeb.PowResetPassword.MailerView do
  use HindsightWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
