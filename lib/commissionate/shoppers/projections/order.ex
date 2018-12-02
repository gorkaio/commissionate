defmodule Commissionate.Shoppers.Projections.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "orders" do
    field(:shopper_nif, :string)
    field(:merchant_cif, :string)
    field(:amount, :integer)
    field(:purchase_date, :utc_datetime)
    field(:confirmation_date, :utc_datetime)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:shopper_nif, :merchant_cif, :amount, :purchase_date, :confirmation_date])
    |> validate_required([:shopper_nif, :merchant_cif, :amount, :purchase_date])
  end
end
