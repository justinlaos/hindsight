defmodule Histora.Job.Organizations do
  def update_expired_trials do
    Histora.Organizations.update_expired_trials()
    IO.inspect("updated_expired_trials")
  end

  def run_weekly_roundup do
    Histora.Organizations.run_weekly_roundup()
    IO.inspect("run_weekly_roundup")
  end
end
