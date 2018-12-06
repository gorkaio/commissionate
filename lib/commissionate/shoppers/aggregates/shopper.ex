defmodule Commissionate.Shoppers.Aggregates.Shopper do
  @moduledoc """
  Shopper aggregate
  """
  alias __MODULE__

  alias Commissionate.Shoppers.Commands.{Register, PlaceOrder, ConfirmOrder}
  alias Commissionate.Shoppers.Events.{Registered, OrderPlaced, OrderConfirmed}

  @order_unconfirmed "UNCONFIRMED"
  @order_confirmed "CONFIRMED"

  defstruct id: nil, orders: %{}

  @doc """
  Handle registration commands
  """
  @spec execute(%Shopper{}, Register.t()) :: %Registered{} | {:error, :already_registered}
  def execute(%Shopper{id: id}, %Register{}) when id != nil, do: {:error, :already_registered}

  def execute(_, %Register{} = cmd) do
    %Registered{id: cmd.id, name: cmd.name, email: cmd.email, nif: cmd.nif}
  end

  @doc """
  Handle order placement commands
  """
  @spec execute(%Shopper{}, PlaceOrder.t()) :: %PlaceOrder{} | {:error, reason :: term}
  def execute(%Shopper{id: id}, %PlaceOrder{}) when id == nil, do: {:error, :unregistered_user}

  def execute(%Shopper{} = shopper, %PlaceOrder{} = cmd) do
    if !Map.has_key?(shopper.orders, cmd.order_id) do
      %OrderPlaced{
        id: cmd.id,
        order_id: cmd.order_id,
        merchant_cif: cmd.merchant_cif,
        amount: cmd.amount,
        purchase_date: cmd.purchase_date
      }
    else
      {:error, :already_taken}
    end
  end

  @doc """
  Handle order confirmation commands
  """
  @spec execute(%Shopper{}, ConfirmOrder.t()) :: %ConfirmOrder{} | {:error, reason :: term}
  def execute(%Shopper{id: id}, %ConfirmOrder{}) when id == nil, do: {:error, :unregistered_user}

  def execute(%Shopper{} = shopper, %ConfirmOrder{} = cmd) do
    case Map.get(shopper.orders, cmd.order_id) do
      @order_unconfirmed ->
        %OrderConfirmed{
          id: cmd.id,
          order_id: cmd.order_id,
          confirmation_date: cmd.confirmation_date
        }

      @order_confirmed ->
        []

      nil ->
        {:error, :not_found}
    end
  end

  @doc """
  Apply changes to state after a successful registration
  """
  def apply(_state, %Registered{} = ev) do
    %Shopper{id: ev.id}
  end

  @doc """
  Apply changes to state after a successful order registration
  """
  def apply(state, %OrderPlaced{} = ev) do
    %Shopper{state | orders: Map.put(state.orders, ev.order_id, @order_unconfirmed)}
  end

  @doc """
  Apply changes to state after a successful order confirmation
  """
  def apply(state, %OrderConfirmed{} = ev) do
    %Shopper{state | orders: Map.put(state.orders, ev.order_id, @order_confirmed)}
  end
end
