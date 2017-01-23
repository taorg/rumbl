defmodule Rumbl.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    
    create table(:users) do
      add :name, :string
      add :username, :string, null: false
      add :password_hash, :string

      timestamps
    end
    
    create table(:instalations) do
      add :city,    :string, size: 40
      add :temp_lo, :integer
      add :temp_hi, :integer
      add :prcp,    :float

      timestamps()
    end
    create unique_index(:users, [:username])

  end
end
