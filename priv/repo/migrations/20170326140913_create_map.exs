defmodule EnhancedMap.Repo.Migrations.CreateMap do
  use Ecto.Migration

  def change do
    create table(:map) do
      add :title, :string
      add :description, :string
      add :center_lat, :decimal
      add :center_long, :decimal
      add :overlay_URL, :string
      add :overlay_north, :decimal
      add :overlay_south, :decimal
      add :overlay_east, :decimal
      add :overlay_west, :decimal

      timestamps()
    end

  end
end
