defmodule Commissionate.Fixture do
  import Commissionate.Factory

  alias Commissionate.{Merchants, Shoppers}

  def register_merchant(_context) do
    {:ok, merchant} = fixture(:merchant)

    [
      merchant: merchant
    ]
  end

  def register_shopper(_context) do
    {:ok, shopper} = fixture(:shopper)

    [
      shopper: shopper
    ]
  end

  def fixture(resource, attrs \\ [])

  def fixture(:merchant, attrs) do
    merchant = build(:merchant, attrs)
    Merchants.register_merchant(merchant.name, merchant.email, merchant.cif)
  end

  def fixture(:shopper, attrs) do
    shopper = build(:shopper, attrs)
    Shoppers.register_shopper(shopper.name, shopper.email, shopper.nif)
  end
end
