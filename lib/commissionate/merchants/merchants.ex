defmodule Commissionate.Merchants do
  @moduledoc """
  The Merchants context.
  """
  alias Commissionate.Router
  alias Commissionate.Merchants.Commands.{Register, ConfirmOrder}
  alias Commissionate.Repo

  alias Commissionate.Merchants.Queries.{
    MerchantByCif,
    MerchantsByFilters,
    DisbursementByMerchantAndDate,
    DisbursementByFilters
  }

  alias Commissionate.Merchants.Projections.Merchant

  @spec register_merchant(String.t(), String.t(), String.t()) :: :ok | {:error, reason :: term}
  def register_merchant(name, email, cif) do
    id = UUID.uuid4()
    cmd = Register.new(%{"id" => id, "name" => name, "email" => email, "cif" => cif})

    with :ok <- Router.dispatch(cmd, consistency: :strong) do
      get(Merchant, id)
    else
      reply -> reply
    end
  end

  def confirm_order(merchant_id, shopper_id, order_id, amount, confirmation_date) do
    cmd =
      ConfirmOrder.new(%{
        "id" => merchant_id,
        "shopper_id" => shopper_id,
        "order_id" => order_id,
        "amount" => amount,
        "confirmation_date" => confirmation_date
      })

    with :ok <- Router.dispatch(cmd, consistency: :strong) do
      Repo.get(Merchant, merchant_id)
    else
      reply -> reply
    end
  end

  def merchant_by_id!(uuid) when is_binary(uuid) do
    Repo.get(Merchant, uuid)
  end

  def merchant_by_id!(_), do: nil

  def merchant_by_cif(cif) when is_binary(cif) do
    cif
    |> MerchantByCif.new()
    |> Repo.one()
  end

  def merchant_by_cif(_), do: nil

  def list_disbursements(params) do
    DisbursementByFilters.new(params)
    |> Repo.all()
  end

  def disbursement_by_merchant_and_date(merchant_id, payment_date) do
    DisbursementByMerchantAndDate.new(merchant_id, payment_date)
    |> Repo.one()
  end

  def list_merchants(params) do
    MerchantsByFilters.new(params)
    |> Repo.all()
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
