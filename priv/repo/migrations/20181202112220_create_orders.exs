defmodule Commissionate.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :shopper_id, :string
      add :shopper_nif, :string
      add :merchant_id, :string
      add :merchant_cif, :string
      add :amount, :integer
      add :purchase_date, :utc_datetime
      add :confirmation_date, :utc_datetime, null: true

      timestamps()
    end
  end
end
