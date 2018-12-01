defmodule Commissionate.Shoppers.Commands.Register do
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

  @moduledoc """
  Command to register a new Shopper
  """
  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{id: String.t(), name: String.t(), email: String.t(), nif: String.t()}
  defstruct [:id, :name, :email, :nif]

  @doc """
  Create new register command

  ## Parameters

    - id: UUID for the new shopper
    - name: Shopper's name
    - email: Shopper's email
    - nif: Shopper's NIF

  """
  @spec new(String.t(), String.t(), String.t(), String.t()) :: {:ok, t} | {:error, reason :: term}
  def new(id, name, email, nif) do
    Vex.validate(%__MODULE__{id: id, name: name, email: email, nif: nif})
  end
end
