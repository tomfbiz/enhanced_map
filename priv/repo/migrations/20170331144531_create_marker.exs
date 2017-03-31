defmodule EnhancedMap.Repo.Migrations.CreateMarker do
  use Ecto.Migration

  def change do
    create table(:markers) do
      add :name, :string
      add :img_URL, :string
      add :text, :text
      add :lat, :decimal
      add :long, :decimal
      add :map_id, references(:maps, on_delete: :nothing)

      timestamps()
    end
    create index(:markers, [:map_id])

  end
end
