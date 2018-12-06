defmodule Commissionate.Shoppers.Projectors.Shopper do
  use Commanded.Projections.Ecto,
    name: "Shoppers.Projectors.Shopper",
    consistency: :strong

  alias Commissionate.Shoppers.Events.{Registered, OrderPlaced, OrderConfirmed}
  alias Commissionate.Shoppers.Projections.{Shopper, Order}
  alias Commissionate.{Shoppers, Merchants}

  project %Registered{} = registered do
    Ecto.Multi.insert(multi, :shopper, %Shopper{
      id: registered.id,
      name: registered.name,
      email: registered.email,
      nif: registered.nif
    })
  end

  project %OrderPlaced{} = order_placed do
    shopper = Shoppers.shopper_by_id!(order_placed.id)
    merchant = Merchants.merchant_by_cif(order_placed.merchant_cif)
    {:ok, purchase_date, _} = DateTime.from_iso8601(order_placed.purchase_date)

    Ecto.Multi.insert(
      multi,
      :order,
      %Order{
        id: order_placed.order_id,
        shopper_id: shopper.id,
        shopper_nif: shopper.nif,
        merchant_id: merchant.id,
        merchant_cif: merchant.cif,
        amount: order_placed.amount,
        purchase_date: purchase_date,
        confirmation_date: nil
      }
    )
  end

  project %OrderConfirmed{} = order_confirmed do
    {:ok, confirmation_date, _} = DateTime.from_iso8601(order_confirmed.confirmation_date)
    update_order(multi, order_confirmed.id, order_confirmed.order_id, confirmation_date: confirmation_date)
  end

  defp update_order(multi, shopper_id, order_id, changes) do
    Ecto.Multi.update_all(multi, :order, order_query(shopper_id, order_id), set: changes)
  end

  defp order_query(shopper_id, order_id) do
    from(o in Order, where: o.shopper_id == ^shopper_id and o.id == ^order_id)
  end
end
