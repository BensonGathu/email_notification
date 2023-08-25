defmodule EmailNotificationWeb.EmailLive.FormComponent do
  require Logger
  alias ElixirSense.Log
  use EmailNotificationWeb, :live_component

  alias EmailNotification.Emails
  alias EmailNotification.Contacts



  @impl true
  def update(%{email: email} = assigns, socket) do
    current_user = assigns.current_user
    changeset = Emails.change_email(email)
    contact = Contacts.get_contact_by_userID!(current_user.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:contacts, contact)
     |> assign_form(changeset)}
  end 

  @impl true
  def handle_event("validate", %{"email" => email_params}, socket) do
    changeset =
      socket.assigns.email
      |> Emails.change_email(email_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"email" => email_params} = params, socket) do
    current_user = socket.assigns.current_user

    email_params_with_user =
      Map.put(email_params, "user_id", current_user.id) |> Map.put("status", "Pending")

    save_email(socket, socket.assigns.action, email_params_with_user)
  end

  defp save_email(socket, :edit, email_params) do
    case Emails.update_email(socket.assigns.email, email_params) do
      {:ok, email} ->
        notify_parent({:saved, email})

        {:noreply,
         socket
         |> put_flash(:info, "Email updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_email(socket, :new, email_params) do
    case Emails.create_email(email_params) do
      {:ok, email} ->
        notify_parent({:saved, email})

        {:noreply,
         socket
         |> put_flash(:info, "Email created successfully")
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
