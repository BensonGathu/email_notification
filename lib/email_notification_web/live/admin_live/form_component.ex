defmodule EmailNotificationWeb.AdminLive.FormComponent do
  require Logger
  use EmailNotificationWeb, :live_component

  alias EmailNotification.Admins
  alias EmailNotification.Accounts

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user_registration(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user_registration(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do

    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do

    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    Logger.info("SAVING USER")
    Logger.info(user_params)
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "Admin created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  # @impl true
  # def handle_event("validate", %{"admin" => admin_params}, socket) do
  #   changeset =
  #     socket.assigns.admin
  #     |> Admins.change_admin(admin_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign_form(socket, changeset)}
  # end

  # def handle_event("save", %{"user" => admin_params}, socket) do
  #   save_admin(socket, socket.assigns.action, admin_params)
  # end

  # defp save_admin(socket, :edit, admin_params) do
  #   case Admins.update_admin(socket.assigns.admin, admin_params) do
  #     {:ok, admin} ->
  #       notify_parent({:saved, admin})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Admin updated successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign_form(socket, changeset)}
  #   end
  # end

  # defp save_admin(socket, :new, admin_params) do
  #   case Admins.create_admin(admin_params) do
  #     {:ok, admin} ->
  #       notify_parent({:saved, admin})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Admin created successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign_form(socket, changeset)}
  #   end
  # end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
