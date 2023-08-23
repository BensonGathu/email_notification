defmodule EmailNotificationWeb.HomeLive.Index do
  use EmailNotificationWeb, :live_view
  alias EmailNotification.Contacts
  alias EmailNotification.Contacts.Contact


  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :contacts, Contacts.list_contacts())}
  end

  


end
