defmodule Commissionate.Router do
  use Commanded.Commands.Router

  alias Commissionate.Merchants.Aggregates.Merchant
  alias Commissionate.Merchants.Commands.Register, as: RegisterMerchant
  alias Commissionate.Support.Middleware.{Uniqueness, Validate}

  middleware Validate
  middleware Uniqueness

  dispatch([RegisterMerchant], to: Merchant, identity: :id)
end
