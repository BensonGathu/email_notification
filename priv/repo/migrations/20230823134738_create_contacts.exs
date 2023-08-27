defmodule EmailNotification.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :first_name, :string
      add :last_name, :string
      add :email_address, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:contacts, [:user_id, :email_address])

    create index(:contacts, [:user_id,])
  end 
end
