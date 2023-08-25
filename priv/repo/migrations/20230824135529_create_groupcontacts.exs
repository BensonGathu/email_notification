defmodule EmailNotification.Repo.Migrations.CreateGroupcontacts do
  use Ecto.Migration

  def change do
    create table(:groupcontacts) do
      add :group_id, references(:groups, on_delete: :nothing)
      add :contact_id, references(:contacts, on_delete: :nothing)

      timestamps()
    end


    create index(:groupcontacts, [:contact_id, :group_id])
  end
end
