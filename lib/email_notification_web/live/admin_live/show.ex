defmodule EmailNotificationWeb.AdminLive.Show do
  use EmailNotificationWeb, :live_view

  alias EmailNotification.Admins
  alias EmailNotification.Accounts
  alias EmailNotification.Emails

  @impl true
  def mount(_params, _session, socket) do
    # Mount a user and the emails

    {:ok, stream(socket, :emails, Emails.get_email_by_userID!(_params["id"]))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, Accounts.get_user!(id))}

  end

  defp page_title(:show), do: "Show Admin"
  defp page_title(:edit), do: "Edit Admin"
end
