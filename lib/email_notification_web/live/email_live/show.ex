defmodule EmailNotificationWeb.EmailLive.Show do
  use EmailNotificationWeb, :live_view

  alias EmailNotification.Emails
  alias EmailNotification.EmailStatus

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    # IO.inspect(EmailStatus.get_failed_contacts_for_email!(id))
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:email, Emails.get_email!(id))
      |> assign(:failed_contacts, EmailStatus.get_failed_contacts_for_email!(id))}
  end

  defp page_title(:show), do: "Show Email"
  defp page_title(:edit), do: "Edit Email"
end
