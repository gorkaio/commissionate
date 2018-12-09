defmodule Commissionate.Shoppers do
  @moduledoc """
  The Shoppers context.
  """
  alias Commissionate.Router
  alias Commissionate.Shoppers.Commands.{Register, PlaceOrder, ConfirmOrder}
  alias Commissionate.Repo

  alias Commissionate.Shoppers.Queries.{
    ShopperByNif,
    ShoppersByFilters,
    OrdersByFilters,
    OrdersByShopperNif,
    OrderByShopperNifAndId,
    OrderByShopperAndId
  }

  alias Commissionate.Shoppers.Projections.Shopper
  alias Commissionate.Shoppers.Projections.Order

  @spec register_shopper(String.t(), String.t(), String.t()) :: :ok | {:error, reason :: term}
  def register_shopper(name, email, nif) do
    id = UUID.uuid4()
    cmd = Register.new(%{"id" => id, "name" => name, "email" => email, "nif" => nif})

    with :ok <- Router.dispatch(cmd, consistency: :strong) do
      get(Shopper, id)
    else
      reply -> reply
    end
  end

  @spec shopper_by_id!(String.t()) :: Shopper.t() | {:error, reason :: term}
  def shopper_by_id!(uuid) when is_binary(uuid) do
    Repo.get(Shopper, uuid)
  end

  def shopper_by_id!(_), do: nil

  def shopper_by_nif(nif) when is_binary(nif) do
    nif
    |> ShopperByNif.new()
    |> Repo.one()
  end

  def shopper_by_nif(_), do: nil

  def list_shoppers(params) do
    ShoppersByFilters.new(params)
    |> Repo.all()
  end

  def list_orders(params) do
    OrdersByFilters.new(params)
    |> Repo.all()
  end

  def place_order(shopper_id, merchant_cif, amount) do
    order_id = UUID.uuid4()

    cmd =
      PlaceOrder.new(%{
        "id" => shopper_id,
        "order_id" => order_id,
        "merchant_cif" => merchant_cif,
        "amount" => amount,
        "purchase_date" => DateTime.utc_now()
      })

    with :ok <- Router.dispatch(cmd, consistency: :strong) do
      get(Order, order_id)
    else
      reply -> reply
    end
  end

  def confirm_order(shopper_id, order_id) do
    cmd =
      ConfirmOrder.new(%{
        "id" => shopper_id,
        "order_id" => order_id,
        "confirmation_date" => DateTime.utc_now()
      })

    with :ok <- Router.dispatch(cmd, consistency: :strong) do
      get(Order, order_id)
    else
      reply -> reply
    end
  end

  def orders_by_nif(nif) when is_binary(nif) do
    nif
    |> OrdersByShopperNif.new()
    |> Repo.all()
  end

  def order_by_nif_and_id(nif, id) when is_binary(nif) and is_binary(id) do
    OrderByShopperNifAndId.new(nif, id)
    |> Repo.one()
  end

  def order_by_shopper_and_id(shopper_id, id) when is_binary(shopper_id) and is_binary(id) do
    OrderByShopperAndId.new(shopper_id, id)
    |> Repo.one()
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
