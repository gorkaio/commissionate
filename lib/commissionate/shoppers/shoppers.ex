defmodule Commissionate.Shoppers do
  @moduledoc """
  The Shoppers context.
  """
  alias Commissionate.Router
  alias Commissionate.Shoppers.Commands.{Register, PlaceOrder}
  alias Commissionate.Repo
  alias Commissionate.Shoppers.Queries.ShopperByNif
  alias Commissionate.Shoppers.Projections.Shopper

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

  def list_shoppers() do
    Repo.all(Shopper)
  end

  def place_order(shopper_uuid, merchant_cif, amount) do
    order_id = UUID.uuid4()

    cmd =
      PlaceOrder.new(%{
        "id" => shopper_uuid,
        "order_id" => order_id,
        "merchant_cif" => merchant_cif,
        "amount" => amount,
        "purchase_date" => DateTime.utc_now()
      })

    with :ok <- Router.dispatch(cmd, consistency: :strong) do
      get(Shopper, shopper_uuid)
    else
      reply -> reply
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end