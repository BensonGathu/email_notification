defmodule EmailNotificationWeb.AdminLive.FormComponent do
  use EmailNotificationWeb, :live_component

  alias EmailNotification.Admins

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage admin records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="admin-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:admin_role]} type="text" label="Admin role" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Admin</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{admin: admin} = assigns, socket) do
    changeset = Admins.change_admin(admin)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"admin" => admin_params}, socket) do
    changeset =
      socket.assigns.admin
      |> Admins.change_admin(admin_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"admin" => admin_params}, socket) do
    save_admin(socket, socket.assigns.action, admin_params)
  end

  defp save_admin(socket, :edit, admin_params) do
    case Admins.update_admin(socket.assigns.admin, admin_params) do
      {:ok, admin} ->
        notify_parent({:saved, admin})

        {:noreply,
         socket
         |> put_flash(:info, "Admin updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_admin(socket, :new, admin_params) do
    case Admins.create_admin(admin_params) do
      {:ok, admin} ->
        notify_parent({:saved, admin})

        {:noreply,
         socket
         |> put_flash(:info, "Admin created successfully")
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
