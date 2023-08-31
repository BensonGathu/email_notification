defmodule EmailNotification.Repo.Migrations.CreateEmailStatus do
  use Ecto.Migration

  def change do
    create table(:email_status) do
      add :status, :citext, null: false
      add :type, :citext, null: false
      add :email_id, references(:emails, on_delete: :delete_all)
      add :contact_id, references(:contacts, on_delete: :delete_all)

      timestamps()
    end

    create index(:email_status, [:email_id])
    create index(:email_status, [:contact_id])
  end
end
