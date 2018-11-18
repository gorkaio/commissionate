defmodule Commissionate.Merchants.Projectors.Merchant do
  use Commanded.Projections.Ecto,
    name: "Merchants.Projectors.Merchant",
    consistency: :strong

  alias Commissionate.Merchants.Events.Registered
  alias Commissionate.Merchants.Projections.Merchant

  project %Registered{} = registered do
    Ecto.Multi.insert(multi, :merchant, %Merchant{
      id: registered.id,
      name: registered.name,
      email: registered.email,
      cif: registered.cif
    })
  end
end
