defmodule Histora.Job.Organizations do
  def run_weekly_roundup do
    Histora.Organizations.run_weekly_roundup()
    IO.inspect("run_weekly_roundup")
  end
end
