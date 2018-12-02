defmodule Commissionate.Router do
  use Commanded.Commands.Router

  alias Commissionate.{Merchants.Aggregates.Merchant, Shoppers.Aggregates.Shopper}
  alias Commissionate.Merchants.Commands.Register, as: RegisterMerchant
  alias Commissionate.Shoppers.Commands.Register, as: RegisterShopper
  alias Commissionate.Shoppers.Commands.PlaceOrder
  alias Commissionate.Support.Middleware.{Uniqueness, Validate}

  middleware(Validate)
  middleware(Uniqueness)

  dispatch([RegisterMerchant], to: Merchant, identity: :id)
  dispatch([RegisterShopper, PlaceOrder], to: Shopper, identity: :id)
end
