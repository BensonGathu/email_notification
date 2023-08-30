defmodule EmailNotification.Repo.Migrations.CreateGroupcontacts do
  use Ecto.Migration

  def change do
    create table(:groupcontacts) do
      add :group_id, references(:groups, on_delete: :delete_all)
      add :contact_id, references(:contacts, on_delete: :delete_all)

      timestamps()
    end


    create unique_index(:groupcontacts, [:contact_id, :group_id])
  end
end
