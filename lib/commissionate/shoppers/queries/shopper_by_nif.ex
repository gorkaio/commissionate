defmodule Commissionate.Shoppers.Queries.ShopperByNif do
  import Ecto.Query

  alias Commissionate.Shoppers.Projections.Shopper

  def new(nif) do
    from(s in Shopper,
      where: s.nif == ^nif
    )
  end
end
