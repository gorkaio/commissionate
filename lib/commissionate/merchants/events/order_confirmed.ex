defmodule Commissionate.Merchants.Events.OrderConfirmed do
  @moduledoc """
  Event triggered when an order is confirmed
  """
  use Vex.Struct

  validates(:id, uuid: true)
  validates(:shopper_id, uuid: true)
  validates(:order_id, uuid: true)

  validates(:amount,
    presence: [message: "can't be empty"],
    money: true
  )

  validates(:confirmation_date, presence: [message: "can't be empty"], date_time: true)

  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{
            id: String.t(),
            shopper_id: String.t(),
            order_id: String.t(),
            amount: Integer.t(),
            confirmation_date: DateTime.t()
          }
  defstruct [:id, :shopper_id, :order_id, :amount, :confirmation_date]
  use ExConstructor
end
