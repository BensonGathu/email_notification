defmodule EmailNotification.GroupContacts.GroupContact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groupcontacts" do
    belongs_to :group, EmailNotification.Groups.Group

    belongs_to :contact, EmailNotification.Contacts.Contact

    timestamps()
  end

  @doc false
  def changeset(group_contact, attrs) do
    group_contact
    |> cast(attrs, [:group_id, :contact_id])
    |> validate_required([:group_id, :contact_id])
  end
end
