defmodule EmailNotification.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :first_name, :string
    field :last_name, :string
    field :email_address, :string

    has_many :group_contacts, EmailNotification.GroupContacts.GroupContact
    has_many :groups, through: [:group_contacts, :group]
    belongs_to :user, EmailNotification.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:first_name, :last_name, :email_address, :user_id])
    |> validate_required([:first_name, :last_name, :email_address, :user_id])
    |> unique_constraint([:user_id, :email_address])

  end
end 
