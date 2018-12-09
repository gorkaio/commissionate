defmodule Commissionate.Shoppers.Queries.OrderByShopperAndId do
  import Ecto.Query

  alias Commissionate.Shoppers.Projections.Order

  def new(shopper_id, id) do
    from(o in Order,
      where: o.shopper_id == ^shopper_id and o.id == ^id
    )
  end
end
