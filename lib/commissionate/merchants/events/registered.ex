defmodule Commissionate.Merchants.Events.Registered do
  alias Commissionate.Merchants.Validators.Validation
  use Vex.Struct

  validates(:id, uuid: true)

  validates(:name,
    presence: [message: "can't be empty"],
    string: true,
    format: [with: ~r/^([[:alpha:]]+\s*[[:alpha:]]*)+$/, message: "Invalid name"]
  )

  validates(:email, presence: [message: "can't be empty"], string: true, email: true)
  validates(:cif, presence: [message: "can't be empty"], string: true, cif: true)

  @moduledoc """
  Event triggered when a new Merchant is registered
  """
  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{id: String.t(), name: String.t(), email: String.t(), cif: String.t()}
  defstruct [:id, :name, :email, :cif]

  @doc """
  Create a new registration event

  ## Parameters

    - id: Merchant's UUID
    - name: Merchant's name
    - email: Merchant's email
    - cif: Merchant's CIF

  """
  @spec new(String.t(), String.t(), String.t(), String.t()) :: {:ok, t} | {:error, reason :: term}
  def new(id, name, email, cif) do
    Vex.validate(%__MODULE__{id: id, name: name, email: email, cif: cif})
  end
end
