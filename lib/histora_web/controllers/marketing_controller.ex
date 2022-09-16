defmodule HistoraWeb.MarketingController do
  use HistoraWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def select_plan(conn, %{"user_size" => user_size}) do
    redirect(conn, external: stripe_checkout_url(user_size))
  end

  defp stripe_checkout_url(user_size) do
    case user_size do
      "10" -> "https://buy.stripe.com/5kA7t5aRI2B9a9qcMM"
      "15" -> "https://buy.stripe.com/bIY00DcZQ2B92GY145"
      "20" -> "https://buy.stripe.com/00g7t56BsdfNchybIK"
      "25" -> "https://buy.stripe.com/9AQ5kX7Fwb7FchybIL"
      "30" -> "https://buy.stripe.com/dR65kX2lcdfN3L2bIM"
      "35" -> "https://buy.stripe.com/5kA4gT6Bsa3B2GYdQV"
      "40" -> "https://buy.stripe.com/fZeeVxcZQ3Fd81i6ou"
      "45" -> "https://buy.stripe.com/bIY3cP7FwdfNchydQX"
      "50" -> "https://buy.stripe.com/6oEbJl0d4grZ2GY6ow"
      "60" -> "https://buy.stripe.com/7sI6p15xofnV4P66ox"
      "70" -> "https://buy.stripe.com/9AQ5kX3pg2B91CU5ku"
      "80" -> "https://buy.stripe.com/00g7t5e3U8Zx5Ta8wH"
      "90" -> "https://buy.stripe.com/cN23cPcZQ3Fd4P65kw"
      "100" -> "https://buy.stripe.com/6oE7t54tk4JhftK4gt"
      "150" -> "https://buy.stripe.com/4gweVxcZQcbJbdu3cq"
      "200" -> "https://buy.stripe.com/6oEfZB3pgcbJ1CU4gv"
    end
  end
end
