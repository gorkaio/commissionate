defmodule Commissionate.Shoppers.Commands.Register do
  @moduledoc """
  Command to register a new Shopper
  """

  alias Commissionate.Shoppers.Validators.Validation
  use Vex.Struct

  validates(:id, uuid: true)

  validates(:name,
    presence: [message: "can't be empty"],
    string: true,
    format: [with: ~r/^([[:alnum:]]+\s*[[:alnum:]]*)+$/, message: "Invalid name"]
  )

  validates(:email, presence: [message: "can't be empty"], string: true, email: true)
  validates(:nif, presence: [message: "can't be empty"], string: true, nif: true, unique_nif: true)

  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{id: String.t(), name: String.t(), email: String.t(), nif: String.t()}
  defstruct [:id, :name, :email, :nif]
  use ExConstructor
end
