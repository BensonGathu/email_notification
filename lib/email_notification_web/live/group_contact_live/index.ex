defmodule EmailNotificationWeb.GroupContactLive.Index do
  require Logger
  use EmailNotificationWeb, :live_view

  alias EmailNotification.GroupContacts
  alias EmailNotification.GroupContacts.GroupContact

  @impl true
  def mount(_params, _session, socket) do
    group_id = _params["id"]

    socket = socket |> assign(:group_id, group_id) 
    {:ok, stream(socket, :groupcontacts, GroupContacts.list_groupcontacts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Group contact")
    |> assign(:group_contact, GroupContacts.get_group_contact!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group contact")
    |> assign(:group_contact, %GroupContact{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Groupcontacts")
    |> assign(:group_contact, nil)
  end

  @impl true
  def handle_info(
        {EmailNotificationWeb.GroupContactLive.FormComponent, {:saved, group_contact}},
        socket
      ) do
    {:noreply, stream_insert(socket, :groupcontacts, group_contact)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    group_contact = GroupContacts.get_group_contact!(id)
    {:ok, _} = GroupContacts.delete_group_contact(group_contact)

    {:noreply, stream_delete(socket, :groupcontacts, group_contact)}
  end
end
