defmodule Commissionate.Merchants.Aggregates.Merchant do
  @moduledoc """
  Merchant aggregate
  """
  alias __MODULE__

  alias Commissionate.Merchants.{Commands.Register, Events.Registered}

  defstruct id: nil

  @doc """
  Handles registration commands
  """
  @spec execute(%Merchant{}, Register.t()) :: %Registered{} | {:error, :already_registered}
  def execute(%Merchant{id: id}, %Register{}) when id != nil, do: {:error, :already_registered}

  def execute(_, %Register{} = cmd) do
    %Registered{id: cmd.id, name: cmd.name, email: cmd.email, cif: cmd.cif}
  end

  @doc """
  Apply changes to state after a successful registration
  """
  def apply(_state, %Registered{} = ev) do
    %Merchant{id: ev.id}
  end
end
