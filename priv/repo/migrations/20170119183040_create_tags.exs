defmodule Rumbl.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do

    create table(:tags) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:tags, [:name])

    create table(:tag_sources) do      
      add :source_id, :integer , null: false 
      add :source_table, :string,  null: false    

      timestamps()
    end 

    create table(:tagmaps) do
      add :tag_id, references(:tags)
      add :tag_sources_id, references(:tag_sources)
      add :user_id, references(:users)
    end

  end
end