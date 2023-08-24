defmodule EmailNotification.GroupContacts do
  @moduledoc """
  The GroupContacts context.
  """

  import Ecto.Query, warn: false
  alias EmailNotification.Repo

  alias EmailNotification.GroupContacts.GroupContact

  @doc """
  Returns the list of groupcontacts.

  ## Examples

      iex> list_groupcontacts()
      [%GroupContact{}, ...]

  """
  def list_groupcontacts do
    Repo.all(GroupContact)|>Repo.preload([:contact])
  end

  @doc """
  Gets a single group_contact.

  Raises `Ecto.NoResultsError` if the Group contact does not exist.

  ## Examples

      iex> get_group_contact!(123)
      %GroupContact{}

      iex> get_group_contact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_contact!(id), do: Repo.get!(GroupContact, id)

  @doc """
  Creates a group_contact.

  ## Examples

      iex> create_group_contact(%{field: value})
      {:ok, %GroupContact{}}

      iex> create_group_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group_contact(attrs \\ %{}) do
    %GroupContact{}
    |> GroupContact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group_contact.

  ## Examples

      iex> update_group_contact(group_contact, %{field: new_value})
      {:ok, %GroupContact{}}

      iex> update_group_contact(group_contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_contact(%GroupContact{} = group_contact, attrs) do
    group_contact
    |> GroupContact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group_contact.

  ## Examples

      iex> delete_group_contact(group_contact)
      {:ok, %GroupContact{}}

      iex> delete_group_contact(group_contact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group_contact(%GroupContact{} = group_contact) do
    Repo.delete(group_contact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_contact changes.

  ## Examples

      iex> change_group_contact(group_contact)
      %Ecto.Changeset{data: %GroupContact{}}

  """
  def change_group_contact(%GroupContact{} = group_contact, attrs \\ %{}) do
    GroupContact.changeset(group_contact, attrs)
  end
end
