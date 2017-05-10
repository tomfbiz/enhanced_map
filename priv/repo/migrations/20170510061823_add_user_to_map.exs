defmodule EnhancedMap.Repo.Migrations.AddUserToMap do
  use Ecto.Migration

  def change do
    alter table(:maps) do
      add :user_id, references(:users, on_delete: :nothing)
    end
  end
end
