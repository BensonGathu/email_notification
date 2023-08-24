defmodule EmailNotificationWeb.GroupContactLive.Show do
  use EmailNotificationWeb, :live_view

  alias EmailNotification.GroupContacts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:group_contact, GroupContacts.get_group_contact!(id))}
  end

  defp page_title(:show), do: "Show Group contact"
  defp page_title(:edit), do: "Edit Group contact"
end
