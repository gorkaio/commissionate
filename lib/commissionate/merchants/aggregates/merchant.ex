defmodule Commissionate.Merchants.Aggregates.Merchant do
  @moduledoc """
  Merchant aggregate
  """
  alias __MODULE__

  @order_confirmed "CONFIRMED"

  alias Commissionate.Merchants.Commands.{Register, ConfirmOrder}
  alias Commissionate.Merchants.Events.{Registered, OrderConfirmed}

  defstruct id: nil, orders: %{}

  @doc """
  Handles registration commands
  """
  @spec execute(%Merchant{}, Register.t()) :: %Registered{} | {:error, :already_registered}
  def execute(%Merchant{id: id}, %Register{}) when id != nil, do: {:error, :already_registered}

  def execute(_, %Register{} = cmd) do
    %Registered{id: cmd.id, name: cmd.name, email: cmd.email, cif: cmd.cif}
  end

  def execute(%Merchant{orders: orders}, %ConfirmOrder{} = cmd) do
    if !Map.has_key?(orders, cmd.order_id) do
      %OrderConfirmed{
        id: cmd.id,
        shopper_id: cmd.shopper_id,
        order_id: cmd.order_id,
        amount: cmd.amount,
        confirmation_date: cmd.confirmation_date
      }
    end
  end

  def execute(%Merchant{id: id}, %ConfirmOrder{}) when id == nil, do: {:error, :not_found}

  @doc """
  Apply changes to state after a successful registration
  """
  def apply(_state, %Registered{} = ev) do
    %Merchant{id: ev.id}
  end

  @doc """
  Apply changes to state after a successful order confirmation
  """
  def apply(state, %OrderConfirmed{} = ev) do
    %Merchant{state | orders: Map.put(state.orders, ev.order_id(), @order_confirmed)}
  end
end
