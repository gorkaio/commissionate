defmodule Commissionate.Repo.Migrations.CreateShoppers do
  use Ecto.Migration

  def change do
    create table(:shoppers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :email, :string
      add :nif, :string

      timestamps()
    end
    create unique_index(:shoppers, [:nif])
  end
end
