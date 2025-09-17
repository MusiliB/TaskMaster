defmodule TodoApp.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

def change do
    alter table(:users) do
      add :role, :string, default: "frontend", null: false
    end
  end
end
