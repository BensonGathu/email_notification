defmodule EmailNotificationWeb.GroupContactLive.FormComponent do
  require Logger
  use EmailNotificationWeb, :live_component

  alias EmailNotification.GroupContacts
  alias EmailNotification.Contacts

  @impl true
  def update(%{group_contact: group_contact} = assigns, socket) do
    current_user = assigns.current_user
    changeset = GroupContacts.change_group_contact(group_contact)
    contact = Contacts.get_contact_by_userID!(current_user.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:contacts, contact)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"group_contact" => group_contact_params}, socket) do
    changeset =
      socket.assigns.group_contact
      |> GroupContacts.change_group_contact(group_contact_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"group_contact" => group_contact_params}, socket) do
    group_id = socket.assigns.group_id

    group_contact_params_group =
      Map.put(group_contact_params, "group_id", group_id)

    save_group_contact(socket, socket.assigns.action, group_contact_params_group)
  end

  defp save_group_contact(socket, :edit, group_contact_params) do
    case GroupContacts.update_group_contact(socket.assigns.group_contact, group_contact_params) do
      {:ok, group_contact} ->
        notify_parent({:saved, group_contact})

        {:noreply,
         socket
         |> put_flash(:info, "Group contact updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_group_contact(socket, :new, group_contact_params) do
    case GroupContacts.create_group_contact(group_contact_params) do
      {:ok, group_contact} ->
        notify_parent({:saved, group_contact})

        {:noreply,
         socket
         |> put_flash(:info, "Group contact created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
