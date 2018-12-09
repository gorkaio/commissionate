defmodule Commissionate.Merchants.Queries.DisbursementByMerchantAndDate do
  import Ecto.Query

  alias Commissionate.Merchants.Projections.Disbursement

  def new(merchant_id, payment_date) do
    from(d in Disbursement,
      where: d.merchant_id == ^merchant_id and d.payment_date == ^payment_date
    )
  end
end
