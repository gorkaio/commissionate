defmodule Commissionate.Shoppers.Commands.PlaceOrder do
  @moduledoc """
  Command to register a new Order
  """

  use Vex.Struct

  validates(:id, uuid: true)
  validates(:order_id, uuid: true)
  validates(:merchant_cif, cif: true, merchant_exists: true, presence: [message: "can't be empty"])

  validates(:amount,
    presence: [message: "can't be empty"],
    money: true
  )

  validates(:purchase_date, presence: [message: "can't be empty"], date_time: true)

  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{
            id: String.t(),
            order_id: String.t(),
            merchant_cif: String.t(),
            amount: Integer.t(),
            purchase_date: DateTime.t()
          }
  defstruct [:id, :order_id, :merchant_cif, :amount, :purchase_date]
  use ExConstructor
end
