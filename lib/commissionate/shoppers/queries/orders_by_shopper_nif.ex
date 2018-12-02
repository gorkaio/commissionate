defmodule Commissionate.Shoppers.Queries.OrdersByShopperNif do
  import Ecto.Query

  alias Commissionate.Shoppers.Projections.Order

  def new(nif) do
    from(o in Order,
      where: o.shopper_nif == ^nif
    )
  end
end
