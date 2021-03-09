defmodule Petal.Repo.Migrations.CreateQualities do
  use Ecto.Migration

  def change do
    create table(:qualities) do
      add :name, :string, null: false
      add :quality, :integer, null: false

      timestamps()
    end
  end
end
