defmodule EmailNotificationWeb.GroupLive.Show do
  require Logger
  use EmailNotificationWeb, :live_view

  alias EmailNotification.Groups
  alias EmailNotification.GroupContacts

  @impl true
  def mount(params, _session, socket) do
    {:ok, stream(socket, :members, GroupContacts.get_group_contact_by_groupID!(params["id"]))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:group, Groups.get_group!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    member = GroupContacts.get_group_contact!(id)
    {:ok, _} = GroupContacts.delete_group_contact(member)

    {:noreply, stream_delete(socket, :members, member)}
  end

  defp page_title(:show), do: "Show Group"
  defp page_title(:edit), do: "Edit Group"
end
