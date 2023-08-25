defmodule EmailNotificationWeb.EmailLive.Index do
  use EmailNotificationWeb, :live_view

  alias EmailNotification.Emails
  alias EmailNotification.Emails.Email

  @impl true
  def mount(_params, _session, socket) do
    # current_user = socket.assigns.current_user
    {:ok, stream(socket, :emails, Emails.get_email_by_userID!(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Email")
    |> assign(:email, Emails.get_email!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Email")
    |> assign(:email, %Email{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Emails")
    |> assign(:email, nil)
  end

  @impl true
  def handle_info({EmailNotificationWeb.EmailLive.FormComponent, {:saved, email}}, socket) do
    {:noreply, stream_insert(socket, :emails, email)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    email = Emails.get_email!(id)
    {:ok, _} = Emails.delete_email(email)

    {:noreply, stream_delete(socket, :emails, email)}
  end
end
