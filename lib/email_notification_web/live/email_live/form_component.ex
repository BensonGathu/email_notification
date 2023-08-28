defmodule EmailNotificationWeb.EmailLive.FormComponent do
  require Logger
  alias ElixirSense.Log
  use EmailNotificationWeb, :live_component

  alias EmailNotification.Emails
  alias EmailNotification.Contacts
  alias EmailNotification.EmailSender
  alias EmailNotification.Groups

  @impl true
  def update(%{email: email} = assigns, socket) do
    current_user = assigns.current_user
    changeset = Emails.change_email(email)
    contact = Contacts.get_contact_by_userID!(current_user.id)
    group = Groups.get_groups_by_userID!(current_user.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:contacts, contact)
     |> assign(:groups, group)
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

  # def handle_event("save", %{"email" => email_params} = params, socket) do
  #   current_user = socket.assigns.current_user

  #   {body, subject, contact_email} = extract_values(email_params)

  #   email_params_with_user =
  #     Map.put(email_params, "user_id", current_user.id)

  #   case EmailSender.send_email_with_params(subject, body, contact_email) do
  #     :ok ->
  #       email_params_with_status = Map.put(email_params_with_user, "status", "Success")
  #       save_email(socket, socket.assigns.action, email_params_with_status)
  #       {:noreply, socket}

  #     {:error, reason} ->
  #       email_params_with_status = Map.put(email_params_with_user, "status", "Failed")
  #       save_email(socket, socket.assigns.action, email_params_with_status)
  #       Logger.error("Email sending failed: #{reason}")
  #       {:noreply, assign(socket, error: "Email sending failed, please try again")}
  #   end
  # end



  def handle_event("save", %{"email" => email_params} = params, socket) do
    current_user = socket.assigns.current_user

    email_params_with_user =
      Map.put(email_params, "user_id", current_user.id) |> Map.put("status", "Pending")
      # EmailSender.send_email(email_params_with_user)
    save_email(socket, socket.assigns.action, email_params_with_user)
  end
  
  def extract_values(data) do
    {body, subject, contact_email} =
      Enum.reduce(data, {nil, nil, nil}, fn
        {"body", value}, {_, subject, contact_email} ->
          {value, subject, contact_email}

        {"subject", value}, {body, _, contact_email} ->
          {body, value, contact_email}

        {"contact_id", contact_id}, {body, subject, _} ->
          {body, subject, Contacts.get_contact_email!(contact_id)}

        _, acc ->
          acc
      end)

    {body, subject, contact_email}
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
