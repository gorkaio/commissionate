defmodule CommissionateWeb.ShopperView do
  use CommissionateWeb, :view
  alias CommissionateWeb.ShopperView

  def render("index.json", %{shoppers: shoppers}) do
    %{data: render_many(shoppers, ShopperView, "shopper.json")}
  end

  def render("show.json", %{shopper: shopper}) do
    %{data: render_one(shopper, ShopperView, "shopper.json")}
  end

  def render("shopper.json", %{shopper: shopper}) do
    %{id: shopper.id, name: shopper.name, email: shopper.email, nif: shopper.nif}
  end
end
