defmodule Commissionate.Merchants.Commands.Register do
  @moduledoc """
  Command to register a new Merchant
  """

  alias Commissionate.Merchants.Validators.Validation
  use Vex.Struct

  validates(:id, uuid: true)

  validates(:name,
    presence: [message: "can't be empty"],
    string: true,
    format: [with: ~r/^([[:alnum:]]+\s*[[:alnum:]]*)+$/, message: "Invalid name"]
  )

  validates(:email, presence: [message: "can't be empty"], string: true, email: true)
  validates(:cif, presence: [message: "can't be empty"], string: true, cif: true, unique_cif: true)

  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{id: String.t(), name: String.t(), email: String.t(), cif: String.t()}
  defstruct [:id, :name, :email, :cif]
  use ExConstructor
end
