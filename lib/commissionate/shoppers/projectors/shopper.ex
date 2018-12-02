defmodule Commissionate.Shoppers.Projectors.Shopper do
  use Commanded.Projections.Ecto,
    name: "Shoppers.Projectors.Shopper",
    consistency: :strong

  alias Commissionate.Shoppers.Events.{Registered, OrderPlaced}
  alias Commissionate.Shoppers.Projections.{Shopper, Order}
  alias Commissionate.Shoppers

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
    {:ok, purchase_date, _} = DateTime.from_iso8601(order_placed.purchase_date)

    Ecto.Multi.insert(multi, :order, %Order{
      id: order_placed.id,
      shopper_nif: shopper.nif,
      merchant_cif: order_placed.merchant_cif,
      amount: order_placed.amount,
      purchase_date: purchase_date,
      confirmation_date: nil
    })
  end
end
