defmodule EmailNotification.Emails.Email do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emails" do
    field :status, :string
    field :body, :string
    field :subject, :string
    belongs_to :user, EmailNotification.Accounts.User
    belongs_to :contact, EmailNotification.Contacts.Contact
    belongs_to :group, EmailNotification.Groups.Group
    timestamps()
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:subject, :body, :status, :user_id, :contact_id,:group_id])
    |> validate_required([:subject, :body, :status, :user_id ])
  end
end
 