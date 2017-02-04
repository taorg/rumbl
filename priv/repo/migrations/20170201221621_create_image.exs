defmodule Rumbl.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :image, :string
      add :users_id, references(:users)
      timestamps()
    end

  end
end
