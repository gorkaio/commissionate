defmodule Commissionate.Merchants.Projectors.Disbursement do
  use Commanded.Projections.Ecto,
    name: "Merchants.Projectors.Disbursement",
    consistency: :eventual

  alias Commissionate.Merchants
  alias Commissionate.Shoppers
  alias Commissionate.Merchants.Events.OrderConfirmed
  alias Commissionate.Merchants.Projections.Disbursement
  alias Commissionate.Merchants.Support.{PaymentDate, CommissionRate}

  project %OrderConfirmed{} = order_confirmed do
    payment_date = PaymentDate.from(order_confirmed.confirmation_date)
    order = Shoppers.order_by_shopper_and_id(order_confirmed.shopper_id, order_confirmed.order_id)
    disbursement = disbursement(order.merchant_id, order.merchant_cif, payment_date)
    commission = CommissionRate.from(order_confirmed.amount)

    Ecto.Multi.insert_or_update(
      multi,
      :disbursement,
      Ecto.Changeset.change(disbursement, %{amount: disbursement.amount + commission})
    )
  end

  defp disbursement(merchant_id, merchant_cif, payment_date) do
    case Merchants.disbursement_by_merchant_and_date(merchant_id, payment_date) do
      nil ->
        %Disbursement{
          id: UUID.uuid4(),
          merchant_id: merchant_id,
          merchant_cif: merchant_cif,
          payment_date: payment_date,
          amount: 0
        }

      %Disbursement{} = disbursement ->
        disbursement
    end
  end
end
