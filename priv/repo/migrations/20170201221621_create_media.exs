defmodule Rumbl.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:medias) do
      add :image, :string
      add :video, :string
      add :content_type, :string
      add :filesize, :integer
      add :users_id, references(:users)
      timestamps()
    end
  
    create table(:mediaslocal) do
      add :image, :string
      add :video, :string
      add :content_type, :string
      add :filesize, :integer
      add :users_id, references(:users)
      timestamps()
    end

  end

end
