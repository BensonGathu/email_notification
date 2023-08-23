defmodule EmailNotificationWeb.EmailLive.Show do
  use EmailNotificationWeb, :live_view

  alias EmailNotification.Emails

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:email, Emails.get_email!(id))}
  end

  defp page_title(:show), do: "Show Email"
  defp page_title(:edit), do: "Edit Email"
end
