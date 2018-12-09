defmodule Commissionate.Router do
  use Commanded.Commands.Router

  alias Commissionate.{Merchants.Aggregates.Merchant, Shoppers.Aggregates.Shopper}
  alias Commissionate.Merchants.Commands.Register, as: RegisterMerchant
  alias Commissionate.Merchants.Commands.ConfirmOrder, as: ConfirmOrderForMerchant
  alias Commissionate.Shoppers.Commands.Register, as: RegisterShopper
  alias Commissionate.Shoppers.Commands.{PlaceOrder, ConfirmOrder}
  alias Commissionate.Support.Middleware.{Uniqueness, Validate}

  middleware(Validate)
  middleware(Uniqueness)

  dispatch([RegisterMerchant, ConfirmOrderForMerchant], to: Merchant, identity: :id)
  dispatch([RegisterShopper, PlaceOrder, ConfirmOrder], to: Shopper, identity: :id)
end
