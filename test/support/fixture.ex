defmodule Commissionate.Fixture do
  import Commissionate.Factory

  alias Commissionate.Merchants

  def register_merchant(_context) do
    {:ok, merchant} = fixture(:merchant)

    [
      merchant: merchant
    ]
  end

  def fixture(resource, attrs \\ [])

  def fixture(:merchant, attrs) do
    merchant = build(:merchant, attrs)
    Merchants.register_merchant(merchant.name, merchant.email, merchant.cif)
  end
end
