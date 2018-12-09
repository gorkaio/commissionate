defmodule Commissionate.Merchants.Queries.DisbursementByFilters do
  import Ecto.Query

  alias Commissionate.Merchants.Projections.Disbursement

  def new(params) do
    filters =
      Ecto.Changeset.cast(
        %Disbursement{},
        params,
        [:merchant_id, :merchant_cif, :payment_date]
      )
      |> Map.fetch!(:changes)
      |> Map.to_list()

    Disbursement
    |> where(^filters)
  end
end
