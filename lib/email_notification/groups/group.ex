defmodule EmailNotification.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    has_many :group_contacts, EmailNotification.GroupContacts.GroupContact
    has_many :contacts, through: [:group_contacts, :contact]
    belongs_to :user, EmailNotification.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint([:user_id, :name])
    |> assoc_constraint(:user)
  end
end
