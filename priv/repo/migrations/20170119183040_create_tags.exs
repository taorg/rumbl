defmodule Rumbl.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :tag, :string, null: false

      timestamps
    end
    create table(:tag_sources) do      
      add :source_id, :integer , null: false 
      add :source_table, :string,  null: false    

      timestamps
    end 
    create table(:tagmaps) do
      add :tag_id, references(:tags)
      add :tag_sources_id, references(:tag_sources)

      timestamps
    end

  end
end