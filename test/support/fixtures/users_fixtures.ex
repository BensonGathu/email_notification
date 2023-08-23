defmodule EmailNotification.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmailNotification.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        plan: "some plan",
        role: "some role",
        first_name: "some first_name",
        last_name: "some last_name",
        email_address: "some email_address",
        msisdn: "some msisdn",
        password_hash: "some password_hash"
      })
      |> EmailNotification.Users.create_user()

    user
  end
end
