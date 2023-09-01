defmodule EmailNotification.EmailStatus do
  import Ecto.Query, warn: false
  alias EmailNotification.Repo

  alias EmailNotification.Contacts.Contact
  alias EmailNotification.Emails.Email
  alias EmailNotification.Emails.EmailStatus

  # Getl all email status
  def list_email_status do
    Repo.all(EmailStatus) |> Repo.preload(:contact) |> Repo.preload(:email)
  end

  # save an item in the email statsus
  def create_email_status(attrs \\ %{}) do
    IO.inspect("SAVING EMAIL_STATUES")
    IO.inspect(attrs)
    %EmailStatus{}
    |> EmailStatus.changeset(attrs)
    |> Repo.insert()

    IO.inspect("SAVED SUCCESSFULLY")
  end

  # Get email status by contactID
  def get_email_status_by_contactID!(id) do
    from(c in EmailStatus, where: [contact_id: ^id])
    |> Repo.all()
    |> Repo.preload(:email)
    |> Repo.preload(:contact)
  end

  # Get email status by email ID
  def get_email_status_by_emailID!(id) do
    from(c in EmailStatus, where: [email_id: ^id])
    |> Repo.all()
    |> Repo.preload(:email)
    |> Repo.preload(:contact)
  end

  def get_failed_contacts_for_email!(email_id) do
    query =
      from es in EmailStatus,
        where: es.email_id == ^email_id and es.status == ^:Failed,
        join: c in assoc(es, :contact),
        select: c

    Repo.all(query)

end
  # Update the email statsu
  def update_email_statusl(%EmailStatus{} = email_status, attrs) do
    email_status
    |> EmailStatus.changeset(attrs)
    |> Repo.update()
  end
end
