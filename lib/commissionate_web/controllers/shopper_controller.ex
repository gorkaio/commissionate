defmodule CommissionateWeb.ShopperController do
  use CommissionateWeb, :controller

  alias Commissionate.Shoppers
  alias Commissionate.Shoppers.Projections.{Shopper, Order}

  action_fallback(CommissionateWeb.FallbackController)

  def list(conn, params) do
    shoppers = Shoppers.list_shoppers(params)
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
    case Shoppers.shopper_by_nif(nif) do
      nil -> {:error, :not_found}
      shopper -> render(conn, "show.json", shopper: shopper)
    end
  end

  def list_orders(conn, %{"nif" => nif}) do
    orders = Shoppers.orders_by_nif(nif)
    render(conn, CommissionateWeb.OrderView, "index.json", orders: orders)
  end

  def create_order(conn, %{"nif" => nif, "order" => %{"merchant_cif" => merchant_cif, "amount" => amount}}) do
    with {:ok, shopper} <- shopper(nif),
         {:ok, %Order{} = order} <- Shoppers.place_order(shopper.id, merchant_cif, amount) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", shopper_path(conn, :show_order, shopper.nif, order.id))
      |> render(CommissionateWeb.OrderView, "show.json", order: order)
    end
  end

  def update_order(conn, %{"nif" => nif, "order_id" => order_id, "order" => %{"status" => "CONFIRMED"}}) do
    with {:ok, shopper} <- shopper(nif),
         {:ok, %Order{} = order} <- Shoppers.confirm_order(shopper.id, order_id) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", shopper_path(conn, :show_order, shopper.nif, order_id))
      |> render(CommissionateWeb.OrderView, "show.json", order: order)
    end
  end

  def show_order(conn, %{"nif" => nif, "order_id" => order_id}) do
    with {:ok, %Order{} = order} <- order(nif, order_id) do
      render(conn, CommissionateWeb.OrderView, "show.json", order: order)
    end
  end

  defp shopper(nif) when is_binary(nif) do
    case Shoppers.shopper_by_nif(nif) do
      nil -> {:error, :not_found}
      shopper -> {:ok, shopper}
    end
  end

  defp shopper(_), do: {:error, :not_found}

  defp order(nif, id) when is_binary(nif) and is_binary(id) do
    case Shoppers.order_by_nif_and_id(nif, id) do
      nil -> {:error, :not_found}
      order -> {:ok, order}
    end
  end

  defp order(_, _), do: {:error, :not_found}
end
