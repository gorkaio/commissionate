defmodule Commissionate.Merchants do
  @moduledoc """
  The Merchants context.
  """
  alias Commissionate.Router
  alias Commissionate.Merchants.Commands.Register
  alias Commissionate.Repo
  alias Commissionate.Merchants.Queries.MerchantByCif
  alias Commissionate.Merchants.Projections.Merchant

  @spec register_merchant(String.t(), String.t(), String.t()) :: :ok | {:error, reason :: term}
  def register_merchant(name, email, cif) do
    with id <- UUID.uuid4(),
         {:ok, cmd} <- Register.new(id, name, email, cif),
         :ok <- Router.dispatch(cmd, consistency: :strong) do
      get(Merchant, id)
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

  def list_merchants() do
    Repo.all(Merchant)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
