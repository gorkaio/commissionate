defmodule Commissionate.Shoppers.Aggregates.Shopper do
  @moduledoc """
  Shopper aggregate
  """
  alias __MODULE__

  alias Commissionate.Shoppers.{Commands.Register, Events.Registered}

  defstruct id: nil

  @doc """
  Handles registration commands
  """
  @spec execute(%Shopper{}, Register.t()) :: %Registered{} | {:error, :already_registered}
  def execute(%Shopper{id: id}, %Register{}) when id != nil, do: {:error, :already_registered}

  def execute(_, %Register{} = cmd) do
    %Registered{id: cmd.id, name: cmd.name, email: cmd.email, nif: cmd.nif}
  end

  @doc """
  Apply changes to state after a successful registration
  """
  def apply(_state, %Registered{} = ev) do
    %Shopper{id: ev.id}
  end
end
