defmodule Commissionate.Merchants.Events.Registered do
  @moduledoc """
    Event triggered when a new Merchant is registered
  """
  use Vex.Struct

  validates(:id, uuid: true)

  validates(:name,
    presence: [message: "can't be empty"],
    string: true,
    format: [with: ~r/^([[:alpha:]]+\s*[[:alpha:]]*)+$/, message: "Invalid name"]
  )

  validates(:email, presence: [message: "can't be empty"], string: true, email: true)
  validates(:cif, presence: [message: "can't be empty"], string: true, cif: true)

  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{id: String.t(), name: String.t(), email: String.t(), cif: String.t()}
  defstruct [:id, :name, :email, :cif]
  use ExConstructor
end
