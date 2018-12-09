defmodule Commissionate.Shoppers.Queries.OrderByShopperNifAndId do
  import Ecto.Query

  alias Commissionate.Shoppers.Projections.Order

  def new(nif, id) do
    from(o in Order,
      where: o.shopper_nif == ^nif and o.id == ^id
    )
  end
end
