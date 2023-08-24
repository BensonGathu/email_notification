defmodule EmailNotification.GroupContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmailNotification.GroupContacts` context.
  """

  @doc """
  Generate a group_contact.
  """
  def group_contact_fixture(attrs \\ %{}) do
    {:ok, group_contact} =
      attrs
      |> Enum.into(%{

      })
      |> EmailNotification.GroupContacts.create_group_contact()

    group_contact
  end
end
