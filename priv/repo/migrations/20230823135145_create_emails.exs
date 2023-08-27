defmodule EmailNotification.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add :subject, :string
      add :body, :text
      add :status, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :contact_id, references(:contacts, on_delete: :nothing)
      add :group_id, references(:groups, on_delete: :nothing)

      timestamps()
    end


    create index(:emails, [:contact_id, :user_id, :group_id])
  end
end
