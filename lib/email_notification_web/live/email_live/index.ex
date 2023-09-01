defmodule EmailNotificationWeb.EmailLive.Index do
  require Logger
  use EmailNotificationWeb, :live_view

  alias EmailNotification.Emails
  alias EmailNotification.Emails.Email

  @impl true
  def mount(_params, _session, socket) do
    # current_user = socket.assigns.current_user


    socket = socket |> assign(:show_group_dropdown, false)
    socket =
      socket
      |> assign(
        :inboxes,
        Emails.get_received_email_by_useremail!(socket.assigns.current_user.email)
      )
      # {:ok ,
      # emails

      # } = Emails.get_email_by_userID!(socket.assigns.current_user.id)

    {:ok,
     stream(
       socket,
       :emails,
       Emails.get_email_by_userID!(socket.assigns.current_user.id)
     )}
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

  def handle_event("send_to_changed", %{"send_to" => "group"}, socket) do
    {:noreply, assign(socket, show_group_dropdown: true)}
  end

  def handle_event("send_to_changed", %{"send_to" => _other}, socket) do
    {:noreply, assign(socket, show_group_dropdown: false)}
  end

  @impl true
  def handle_event("retryEmail", %{"id" => id}, socket) do
    # IO.inspect("Retrying Email")
    # email = Emails.get_email!(id)

    # case Emails.update_email_by_id!(id) do
    #   {:ok, updated_email} ->
    #     {:noreply,
    #      assign(socket, emails: update_email_in_emails(socket.assigns.emails, updated_email))}

    #   {:error, _} ->
    #     {:noreply, socket}
    # end

    # {:noreply, assign(socket, show_group_dropdown: false)}

  end

  defp update_email_in_emails(emails, updated_email) do
    Enum.map(emails, fn email ->
      if email.id == updated_email.id do
        updated_email
      else
        email
      end
    end)
  end
end
