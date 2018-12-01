defmodule Commissionate.Shoppers do
  @moduledoc """
  The Shoppers context.
  """
  alias Commissionate.Router
  alias Commissionate.Shoppers.Commands.Register
  alias Commissionate.Repo
  alias Commissionate.Shoppers.Queries.ShopperByNif
  alias Commissionate.Shoppers.Projections.Shopper

  @spec register_shopper(String.t(), String.t(), String.t()) :: :ok | {:error, reason :: term}
  def register_shopper(name, email, nif) do
    with id <- UUID.uuid4(),
         {:ok, cmd} <- Register.new(id, name, email, nif),
         :ok <- Router.dispatch(cmd, consistency: :strong) do
      get(Shopper, id)
    else
      reply -> reply
    end
  end

  def shopper_by_id!(uuid) when is_binary(uuid) do
    Repo.get(Shopper, uuid)
  end

  def shopper_by_id!(_), do: nil

  def shopper_by_nif(nif) when is_binary(nif) do
    nif
    |> ShopperByNif.new()
    |> Repo.one()
  end

  def shopper_by_nif(_), do: nil

  def list_shoppers() do
    Repo.all(Shopper)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
