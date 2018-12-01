defmodule Commissionate.Shoppers.Projectors.Shopper do
  use Commanded.Projections.Ecto,
    name: "Shoppers.Projectors.Shopper",
    consistency: :strong

  alias Commissionate.Shoppers.Events.Registered
  alias Commissionate.Shoppers.Projections.Shopper

  project %Registered{} = registered do
    Ecto.Multi.insert(multi, :shopper, %Shopper{
      id: registered.id,
      name: registered.name,
      email: registered.email,
      nif: registered.nif
    })
  end
end
