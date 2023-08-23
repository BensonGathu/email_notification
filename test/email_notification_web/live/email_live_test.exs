defmodule EmailNotificationWeb.EmailLiveTest do
  use EmailNotificationWeb.ConnCase

  import Phoenix.LiveViewTest
  import EmailNotification.EmailsFixtures

  @create_attrs %{status: "some status", body: "some body", subject: "some subject"}
  @update_attrs %{status: "some updated status", body: "some updated body", subject: "some updated subject"}
  @invalid_attrs %{status: nil, body: nil, subject: nil}

  defp create_email(_) do
    email = email_fixture()
    %{email: email}
  end

  describe "Index" do
    setup [:create_email]

    test "lists all emails", %{conn: conn, email: email} do
      {:ok, _index_live, html} = live(conn, ~p"/emails")

      assert html =~ "Listing Emails"
      assert html =~ email.status
    end

    test "saves new email", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("a", "New Email") |> render_click() =~
               "New Email"

      assert_patch(index_live, ~p"/emails/new")

      assert index_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#email-form", email: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/emails")

      html = render(index_live)
      assert html =~ "Email created successfully"
      assert html =~ "some status"
    end

    test "updates email in listing", %{conn: conn, email: email} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("#emails-#{email.id} a", "Edit") |> render_click() =~
               "Edit Email"

      assert_patch(index_live, ~p"/emails/#{email}/edit")

      assert index_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#email-form", email: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/emails")

      html = render(index_live)
      assert html =~ "Email updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes email in listing", %{conn: conn, email: email} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("#emails-#{email.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#emails-#{email.id}")
    end
  end

  describe "Show" do
    setup [:create_email]

    test "displays email", %{conn: conn, email: email} do
      {:ok, _show_live, html} = live(conn, ~p"/emails/#{email}")

      assert html =~ "Show Email"
      assert html =~ email.status
    end

    test "updates email within modal", %{conn: conn, email: email} do
      {:ok, show_live, _html} = live(conn, ~p"/emails/#{email}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Email"

      assert_patch(show_live, ~p"/emails/#{email}/show/edit")

      assert show_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#email-form", email: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/emails/#{email}")

      html = render(show_live)
      assert html =~ "Email updated successfully"
      assert html =~ "some updated status"
    end
  end
end
