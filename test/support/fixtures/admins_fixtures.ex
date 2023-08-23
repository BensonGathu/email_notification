defmodule EmailNotification.AdminsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmailNotification.Admins` context.
  """

  @doc """
  Generate a admin.
  """
  def admin_fixture(attrs \\ %{}) do
    {:ok, admin} =
      attrs
      |> Enum.into(%{
        admin_role: "some admin_role"
      })
      |> EmailNotification.Admins.create_admin()

    admin
  end
end
