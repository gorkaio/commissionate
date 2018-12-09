defmodule Commissionate.Shoppers.Queries.ShoppersByFilters do
  import Ecto.Query

  alias Commissionate.Shoppers.Projections.Shopper

  def new(params) do
    filters =
      Ecto.Changeset.cast(
        %Shopper{},
        params,
        [:id, :nif, :email, :name]
      )
      |> Map.fetch!(:changes)
      |> Map.to_list()

    Shopper
    |> where(^filters)
  end
end
