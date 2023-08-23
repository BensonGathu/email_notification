defmodule EmailNotification.EmailsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmailNotification.Emails` context.
  """

  @doc """
  Generate a email.
  """
  def email_fixture(attrs \\ %{}) do
    {:ok, email} =
      attrs
      |> Enum.into(%{
        body: "some body",
        subject: "some subject"
      })
      |> EmailNotification.Emails.create_email()

    email
  end

  @doc """
  Generate a email.
  """


  @doc """
  Generate a email.
  """
  def email_fixture(attrs \\ %{}) do
    {:ok, email} =
      attrs
      |> Enum.into(%{
        status: "some status",
        body: "some body",
        subject: "some subject"
      })
      |> EmailNotification.Emails.create_email()

    email
  end
end
