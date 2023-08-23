defmodule EmailNotification.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmailNotification.Contacts` context.
  """

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        first_name: "some first_name",
        last_name: "some last_name",
        email_address: "some email_address"
      })
      |> EmailNotification.Contacts.create_contact()

    contact
  end
end
