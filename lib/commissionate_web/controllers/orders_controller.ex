defmodule CommissionateWeb.OrdersController do
  use CommissionateWeb, :controller

  alias Commissionate.Shoppers

  action_fallback(CommissionateWeb.FallbackController)

  def list(conn, params) do
    orders = Shoppers.list_orders(params)
    render(conn, CommissionateWeb.OrderView, "index.json", orders: orders)
  end
end
