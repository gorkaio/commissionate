defmodule Commissionate.Shoppers.Commands.ConfirmOrder do
  @moduledoc """
  Command to confirm an Order
  """

  use Vex.Struct

  validates(:id, uuid: true)
  validates(:order_id, uuid: true)
  validates(:confirmation_date, presence: [message: "can't be empty"], date_time: true)

  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{
            id: String.t(),
            order_id: String.t(),
            confirmation_date: DateTime.t()
          }
  defstruct [:id, :order_id, :confirmation_date]
  use ExConstructor
end
