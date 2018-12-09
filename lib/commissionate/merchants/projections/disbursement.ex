defmodule Commissionate.Merchants.Projections.Disbursement do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "disbursements" do
    field(:merchant_id, :string)
    field(:merchant_cif, :string)
    field(:amount, :integer, default: 0)
    field(:payment_date, :date)

    timestamps()
  end

  @doc false
  def changeset(disbursement, attrs) do
    disbursement
    |> cast(attrs, [:merchant_id, :merchant_cif, :amount, :payment_date])
    |> validate_required([:merchant_id, :merchant_cif, :amount, :payment_date])
  end
end
