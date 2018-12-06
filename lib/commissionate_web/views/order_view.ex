defmodule CommissionateWeb.OrderView do
  use CommissionateWeb, :view
  alias CommissionateWeb.OrderView

  def render("index.json", %{orders: orders}) do
    %{data: render_many(orders, OrderView, "order.json")}
  end

  def render("show.json", %{order: order}) do
    %{data: render_one(order, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{
      id: order.id,
      shopper_nif: order.shopper_nif,
      amount: order.amount,
      merchant_cif: order.merchant_cif,
      purchase_date: order.purchase_date,
      confirmation_date: order.confirmation_date
    }
  end
end
