defmodule EmailNotification.Emails do
  @moduledoc """
  The Emails context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias EmailNotification.Repo

  alias EmailNotification.Emails.Email
  alias EmailNotification.Accounts
  alias EmailNotification.GroupContacts.GroupContact

  @doc """
  Returns the list of emails.

  ## Examples

      iex> list_emails()
      [%Email{}, ...]

  """
  def list_emails do
    Repo.all(Email) |> Repo.preload(:contact)
  end

  @doc """
  Gets a single email.

  Raises `Ecto.NoResultsError` if the Email does not exist.

  ## Examples

      iex> get_email!(123)
      %Email{}

      iex> get_email!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email!(id), do: Repo.get!(Email, id)

  def get_email_by_userID!(id) do
    from(c in Email, where: [user_id: ^id])
    |> Repo.all()
    |> Repo.preload(:contact)
    |> Repo.preload(:group)

  end

  # Get recieved emails
  def get_received_email_by_useremail!(email) do
    query =
      from(e in Email,
        join: c in assoc(e, :contact),
        where: c.email_address == ^email and e.status == "Sent",
        preload: [:contact, :group, :user]
      )

    Repo.all(query)
  end

  @doc """
  Creates a email.

  ## Examples

      iex> create_email(%{field: value})
      {:ok, %Email{}}

      iex> create_email(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email(attrs \\ %{}) do
    %Email{}
    |> Email.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a email.

  ## Examples

      iex> update_email(email, %{field: new_value})
      {:ok, %Email{}}

      iex> update_email(email, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_email(%Email{} = email, attrs) do
    email
    |> Email.changeset(attrs)
    |> Repo.update()
  end


  def update_email_by_id!(email_id) do
    email =
      from(e in EmailNotification.Emails.Email,
        where: e.id == ^email_id
      )
      |> Repo.one()
      |> Repo.preload(:contact)

    case email do
      nil ->
        {:error, "Email not found"}

      %EmailNotification.Emails.Email{} = email ->
        Logger.info("Updating email with ID #{email.contact.email_address}")

        contact_email = email.contact.email_address
        user_exists = user_exists?(contact_email)

        Logger.info(user_exists)

        updated_status = if user_exists, do: "Sent", else: "Failed"
        Logger.info(updated_status)
        # working till hhere
        updated_email = change_email_status(email, updated_status)
        changeset = EmailNotification.Emails.change_email(email, Map.from_struct(email))

        updated_email =
          case Repo.update(changeset) do
            {:ok, _updated_email} ->
              {:ok, email}

            {:error, changeset} ->
              {:error, changeset}
          end

        updated_email
    end
  end
  defp user_exists?(email) do
    case Accounts.get_user_by_email!(email) do
      nil -> false
      _ -> true
    end
  end
  defp change_email_status(email, status) do
    email
    |> Email.changeset(%{status: status})
  end
  @doc """
  Deletes a email.

  ## Examples

      iex> delete_email(email)
      {:ok, %Email{}}

      iex> delete_email(email)
      {:error, %Ecto.Changeset{}}

  """
  def delete_email(%Email{} = email) do
    Repo.delete(email)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking email changes.

  ## Examples

      iex> change_email(email)
      %Ecto.Changeset{data: %Email{}}

  """
  def change_email(%Email{} = email, attrs \\ %{}) do
    Email.changeset(email, attrs)
  end
end
