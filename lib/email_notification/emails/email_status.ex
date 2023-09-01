defmodule EmailNotification.Emails.EmailStatus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "email_status" do
    field :status, Ecto.Enum, values: [:ok, :Failed]
    field :type, Ecto.Enum, values: [:individual, :group]
    belongs_to :email, EmailNotification.Emails.Email
    belongs_to :contact, EmailNotification.Contacts.Contact

    timestamps()
  end

  @doc false
  def changeset(email_status, attrs) do
    email_status
    |> cast(attrs, [:status, :type, :email_id, :contact_id])
    |> validate_required([:status, :type, :email_id, :contact_id])
  end
end
