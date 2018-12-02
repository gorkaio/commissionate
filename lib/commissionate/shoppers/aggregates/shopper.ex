defmodule Commissionate.Shoppers.Aggregates.Shopper do
  @moduledoc """
  Shopper aggregate
  """
  alias __MODULE__

  alias Commissionate.Shoppers.Commands.{Register, PlaceOrder}
  alias Commissionate.Shoppers.Events.{Registered, OrderPlaced}

  defstruct id: nil, orders: %{}

  defmodule Order do
    @derive [Poison.Encoder]
    @opaque t :: %__MODULE__{
              merchant_cif: String.t(),
              amount: Integer.t(),
              purchase_date: Date.t(),
              confirmation_date: Date.t()
            }
    defstruct [:merchant_cif, :amount, :purchase_date, :confirmation_date]
    use ExConstructor
  end

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

  def execute(%Shopper{} = _shopper, %PlaceOrder{} = cmd) do
    %OrderPlaced{
      id: cmd.id,
      order_id: cmd.order_id,
      merchant_cif: cmd.merchant_cif,
      amount: cmd.amount,
      purchase_date: cmd.purchase_date
    }
  end

  @doc """
  Apply changes to state after a successful registration
  """
  def apply(_state, %Registered{} = ev) do
    %Shopper{id: ev.id}
  end

  def apply(state, %OrderPlaced{} = ev) do
    order = %Order{merchant_cif: ev.merchant_cif, amount: ev.amount, purchase_date: ev.purchase_date}
    %Shopper{state | orders: Map.put(state.orders, ev.order_id, order)}
  end
end
