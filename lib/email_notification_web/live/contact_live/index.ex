defmodule EmailNotificationWeb.ContactLive.Index do
  use EmailNotificationWeb, :live_view

  alias EmailNotification.Contacts
  alias EmailNotification.Contacts.Contact

  @impl true
  def mount(_params, _session, socket) do

    {:ok, stream(socket, :contacts, Contacts.get_contact_by_userID!(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end
  
  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Contact")
    |> assign(:contact, Contacts.get_contact!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Contact")
    |> assign(:contact, %Contact{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Contacts")
    |> assign(:contact, nil)
  end

  @impl true
  def handle_info({EmailNotificationWeb.ContactLive.FormComponent, {:saved, contact}}, socket) do
    {:noreply, stream_insert(socket, :contacts, contact)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contact = Contacts.get_contact!(id)
    {:ok, _} = Contacts.delete_contact(contact)

    {:noreply, stream_delete(socket, :contacts, contact)}
  end
end
