defmodule Commissionate.Shoppers.Events.Registered do
  @moduledoc """
  Event triggered when a new Shopper is registered
  """

  use Vex.Struct

  validates(:id, uuid: true)

  validates(:name,
    presence: [message: "can't be empty"],
    string: true,
    format: [with: ~r/^([[:alpha:]]+\s*[[:alpha:]]*)+$/, message: "Invalid name"]
  )

  validates(:email, presence: [message: "can't be empty"], string: true, email: true)
  validates(:nif, presence: [message: "can't be empty"], string: true, nif: true)

  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{id: String.t(), name: String.t(), email: String.t(), nif: String.t()}
  defstruct [:id, :name, :email, :nif]
  use ExConstructor
end
