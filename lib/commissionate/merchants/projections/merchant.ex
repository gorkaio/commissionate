defmodule Commissionate.Merchants.Projections.Merchant do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "merchants" do
    field(:cif, :string, unique: true)
    field(:email, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(merchant, attrs) do
    merchant
    |> cast(attrs, [:name, :email, :cif])
    |> validate_required([:name, :email, :cif])
    |> unique_constraint(:cif)
  end
end
