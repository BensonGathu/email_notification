defmodule EmailNotificationWeb.AdminLive.Index do
  require Logger
  use EmailNotificationWeb, :live_view

  alias EmailNotification.Admins
  alias EmailNotification.Admins.Admin
  alias EmailNotification.Accounts
  alias EmailNotification.Accounts.User
  alias EmailNotification.Roles.Role
  alias EmailNotification.Roles

  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users()
    filtered_users = Enum.reject(users, fn user -> user.id == socket.assigns.current_user.id end)

    {:ok, stream(socket, :users, filtered_users)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Admin")  
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Admins")
    |> assign(:user, nil)
  end

  @impl true
  def handle_info({EmailNotificationWeb.AdminLive.FormComponent, {:saved, user}}, socket) do
    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, stream_delete(socket, :users, user)}
  end

  @impl true
  def handle_event("makeAdmin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    {:ok, _} = Accounts.make_admin(user, %{"role_id" => 1})

    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("revokeAdmin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    {:ok, _} = Accounts.revoke_admin(user, %{"role_id" => 2})

    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("makeSuperuser", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    {:ok, _} = Accounts.make_superuser(user, %{"role_id" => 3})

    {:noreply, stream_insert(socket, :users, user)}
  end

  @impl true
  def handle_event("revokeSuperuser", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)

    {:ok, _} = Accounts.revoke_superuser(user, %{"role_id" => 1})

    {:noreply, stream_insert(socket, :users, user)}
  end
end
