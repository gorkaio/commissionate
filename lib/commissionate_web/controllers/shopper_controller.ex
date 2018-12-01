defmodule CommissionateWeb.ShopperController do
  use CommissionateWeb, :controller

  alias Commissionate.Shoppers
  alias Commissionate.Shoppers.Projections.Shopper

  action_fallback(CommissionateWeb.FallbackController)

  def list(conn, _params) do
    shoppers = Shoppers.list_shoppers()
    render(conn, "index.json", shoppers: shoppers)
  end

  def create(conn, %{"shopper" => %{"name" => name, "email" => email, "nif" => nif}}) do
    with {:ok, %Shopper{} = shopper} <- Shoppers.register_shopper(name, email, nif) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", shopper_path(conn, :show, nif))
      |> render("show.json", shopper: shopper)
    end
  end

  def show(conn, %{"nif" => nif}) do
    shopper = Shoppers.shopper_by_nif(nif)
    render(conn, "show.json", shopper: shopper)
  end
end
