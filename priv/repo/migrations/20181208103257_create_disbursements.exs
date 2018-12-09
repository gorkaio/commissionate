defmodule Commissionate.Repo.Migrations.CreateDisbursements do
  use Ecto.Migration

  def change do
    create table(:disbursements, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :merchant_id, :string
      add :merchant_cif, :string
      add :amount, :integer, default: 0
      add :payment_date, :date

      timestamps()
    end
  end
end
