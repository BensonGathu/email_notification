defmodule EmailNotification.Repo.Migrations.CreateAdminLinks do
  use Ecto.Migration

  def change do
    create table(:admin_links) do
      add :admin_id, references(:users, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:admin_links, [:admin_id, :user_id], unique: true)

  end
end
