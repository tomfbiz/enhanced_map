defmodule EnhancedMap.Repo.Migrations.AddMarkerImgAndZoomToMap do
  use Ecto.Migration

  def change do
    alter table(:maps) do
      add :zoom, :integer
      add :marker_URL, :string
    end
  end
end
