defmodule EmailNotificationWeb.GroupContactLive.FormComponent do
  use EmailNotificationWeb, :live_component

  alias EmailNotification.GroupContacts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage group_contact records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="group_contact-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Group contact</.button>
        </:actions>
      </.simple_form> 
    </div>
    """
  end

  @impl true
  def update(%{group_contact: group_contact} = assigns, socket) do
    changeset = GroupContacts.change_group_contact(group_contact)

    {:ok,
     socket
     |> assign(assigns)
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
    save_group_contact(socket, socket.assigns.action, group_contact_params)
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
