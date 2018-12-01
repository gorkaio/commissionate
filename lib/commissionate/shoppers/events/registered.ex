defmodule Commissionate.Shoppers.Events.Registered do
  alias Commissionate.Shoppers.Validators.Validation
  use Vex.Struct

  validates(:id, uuid: true)

  validates(:name,
    presence: [message: "can't be empty"],
    string: true,
    format: [with: ~r/^([[:alpha:]]+\s*[[:alpha:]]*)+$/, message: "Invalid name"]
  )

  validates(:email, presence: [message: "can't be empty"], string: true, email: true)
  validates(:nif, presence: [message: "can't be empty"], string: true, nif: true)

  @moduledoc """
  Event triggered when a new Shopper is registered
  """
  @derive [Poison.Encoder]
  @opaque t :: %__MODULE__{id: String.t(), name: String.t(), email: String.t(), nif: String.t()}
  defstruct [:id, :name, :email, :nif]

  @doc """
  Create a new registration event

  ## Parameters

    - id: Shopper's UUID
    - name: Shopper's name
    - email: Shopper's email
    - nif: Shopper's NIF

  """
  @spec new(String.t(), String.t(), String.t(), String.t()) :: {:ok, t} | {:error, reason :: term}
  def new(id, name, email, nif) do
    Vex.validate(%__MODULE__{id: id, name: name, email: email, nif: nif})
  end
end
