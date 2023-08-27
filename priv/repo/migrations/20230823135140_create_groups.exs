defmodule EmailNotification.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:groups, [:user_id, :name])

    create index(:groups, [:user_id])
  end
end
