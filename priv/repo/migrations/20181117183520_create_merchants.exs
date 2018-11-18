defmodule Commissionate.Repo.Migrations.CreateMerchants do
  use Ecto.Migration

  def change do
    create table(:merchants, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :email, :string
      add :cif, :string
      timestamps()
    end
    create unique_index(:merchants, [:cif])
  end
end
