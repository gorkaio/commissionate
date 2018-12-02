defmodule Commissionate.Shoppers.Projections.Shopper do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @primary_key {:id, :binary_id, autogenerate: false}

  schema "shoppers" do
    field(:nif, :string, unique: true)
    field(:email, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(shopper, attrs) do
    shopper
    |> cast(attrs, [:name, :email, :nif])
    |> validate_required([:name, :email, :nif])
    |> unique_constraint(:nif)
  end
end
