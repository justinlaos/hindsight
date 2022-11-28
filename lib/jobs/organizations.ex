defmodule Histora.Job.Organizations do
  def update_expired_trials do
    Histora.Organizations.update_expired_trials()
    IO.inspect("updated_expired_trials")
  end
end
