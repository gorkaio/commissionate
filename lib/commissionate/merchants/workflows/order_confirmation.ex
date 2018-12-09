defmodule Commissionate.Merchants.Workflows.OrderConfirmation do
  use Commanded.Event.Handler,
    name: "MerchantOrderConfirmation",
    consistency: :eventual

  @max_retries 3

  require Logger

  alias Commissionate.Shoppers.Events.OrderConfirmed
  alias Commissionate.Shoppers.Projections.Order
  alias Commissionate.Merchants.Projections.Merchant
  alias Commissionate.{Merchants, Shoppers}
  alias Commanded.Event.FailureContext

  @doc """
  Handles order confirmation events by triggering an order confirmation on a merchant
  """
  def handle(%OrderConfirmed{id: shopper_id, order_id: order_id, confirmation_date: confirmation_date}, _metadata) do
    {:ok, confirmation_date, _} = DateTime.from_iso8601(confirmation_date)

    with %Order{} = order <- Shoppers.order_by_shopper_and_id(shopper_id, order_id),
         %Merchant{} <-
           Merchants.confirm_order(
             order.merchant_id,
             order.shopper_id,
             order.id,
             order.amount,
             confirmation_date
           ) do
      :ok
    else
      {:error, err} -> {:error, err}
      _ -> {:error, :failed}
    end
  end

  @doc """
  Retries a failed event. Skips event and logs error after @max_retries retries
  """
  def error({:error, _error}, %OrderConfirmed{} = event, %FailureContext{context: context}) do
    context = record_failure(context)

    case Map.get(context, :failures) do
      too_many when too_many >= @max_retries ->
        Logger.warn(fn -> "Skipping bad event, too many failures: " <> inspect(event) end)
        :skip

      _ ->
        {:retry, context}
    end
  end

  defp record_failure(context) do
    Map.update(context, :failures, 1, fn failures -> failures + 1 end)
  end
end
