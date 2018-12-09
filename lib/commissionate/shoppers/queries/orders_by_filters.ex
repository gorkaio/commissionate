defmodule Commissionate.Shoppers.Queries.OrdersByFilters do
  import Ecto.Query

  alias Commissionate.Shoppers.Projections.Order

  def new(params) do
    filters =
      Ecto.Changeset.cast(
        %Order{},
        params,
        [:shopper_id, :shopper_nif, :merchant_id, :merchant_cif, :purchase_date, :confirmation_date]
      )
      |> Map.fetch!(:changes)
      |> Map.to_list()

    Order
    |> where(^filters)
  end
end
