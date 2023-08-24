defmodule EmailNotificationWeb.GroupContactLiveTest do
  use EmailNotificationWeb.ConnCase

  import Phoenix.LiveViewTest
  import EmailNotification.GroupContactsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_group_contact(_) do
    group_contact = group_contact_fixture()
    %{group_contact: group_contact}
  end

  describe "Index" do
    setup [:create_group_contact]

    test "lists all groupcontacts", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/groupcontacts")

      assert html =~ "Listing Groupcontacts"
    end

    test "saves new group_contact", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/groupcontacts")

      assert index_live |> element("a", "New Group contact") |> render_click() =~
               "New Group contact"

      assert_patch(index_live, ~p"/groupcontacts/new")

      assert index_live
             |> form("#group_contact-form", group_contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#group_contact-form", group_contact: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/groupcontacts")

      html = render(index_live)
      assert html =~ "Group contact created successfully"
    end

    test "updates group_contact in listing", %{conn: conn, group_contact: group_contact} do
      {:ok, index_live, _html} = live(conn, ~p"/groupcontacts")

      assert index_live |> element("#groupcontacts-#{group_contact.id} a", "Edit") |> render_click() =~
               "Edit Group contact"

      assert_patch(index_live, ~p"/groupcontacts/#{group_contact}/edit")

      assert index_live
             |> form("#group_contact-form", group_contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#group_contact-form", group_contact: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/groupcontacts")

      html = render(index_live)
      assert html =~ "Group contact updated successfully"
    end

    test "deletes group_contact in listing", %{conn: conn, group_contact: group_contact} do
      {:ok, index_live, _html} = live(conn, ~p"/groupcontacts")

      assert index_live |> element("#groupcontacts-#{group_contact.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#groupcontacts-#{group_contact.id}")
    end
  end

  describe "Show" do
    setup [:create_group_contact]

    test "displays group_contact", %{conn: conn, group_contact: group_contact} do
      {:ok, _show_live, html} = live(conn, ~p"/groupcontacts/#{group_contact}")

      assert html =~ "Show Group contact"
    end

    test "updates group_contact within modal", %{conn: conn, group_contact: group_contact} do
      {:ok, show_live, _html} = live(conn, ~p"/groupcontacts/#{group_contact}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Group contact"

      assert_patch(show_live, ~p"/groupcontacts/#{group_contact}/show/edit")

      assert show_live
             |> form("#group_contact-form", group_contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#group_contact-form", group_contact: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/groupcontacts/#{group_contact}")

      html = render(show_live)
      assert html =~ "Group contact updated successfully"
    end
  end
end
