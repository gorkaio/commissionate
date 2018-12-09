defmodule Commissionate.Merchants.Queries.MerchantsByFilters do
  import Ecto.Query

  alias Commissionate.Merchants.Projections.Merchant

  def new(params) do
    filters =
      Ecto.Changeset.cast(
        %Merchant{},
        params,
        [:id, :cif, :email, :name]
      )
      |> Map.fetch!(:changes)
      |> Map.to_list()

    Merchant
    |> where(^filters)
  end
end
