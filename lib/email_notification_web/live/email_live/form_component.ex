defmodule EmailNotificationWeb.EmailLive.FormComponent do
  require Logger
  alias ElixirSense.Log
  use EmailNotificationWeb, :live_component
  alias Swoosh.Email, as: EmailFunctions

  alias EmailNotification.Emails
  alias EmailNotification.Contacts

  alias EmailNotification.Groups
  alias EmailNotification.Accounts
  alias EmailNotification.GroupContacts
  alias EmailNotification.Mailer

  @impl true
  def update(%{email: email} = assigns, socket) do
    current_user = assigns.current_user
    changeset = Emails.change_email(email)
    contact = Contacts.get_contact_by_userID!(current_user.id)
    group = Groups.get_groups_by_userID!(current_user.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:show_group_dropdown, false)
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

  def handle_event("send_to_changed", %{"email" => %{"send_to" => "single_contact"}}, socket) do
    {:noreply, assign(socket, show_group_dropdown: false)}
  end

  def handle_event("send_to_changed", %{"email" => %{"send_to" => "group"}}, socket) do
    {:noreply, assign(socket, show_group_dropdown: true)}
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

    contact_id = email_params["contact_id"]

    # get email address based on contact_id

    if socket.assigns.show_group_dropdown do
      email_list = get_group_member_emails(email_params["group_id"])

      Enum.each(email_list, fn email ->
        user_exists = Accounts.get_user_by_email!(email)

        status =
          if user_exists do
            "Sent"
          else
            "Failed"
          end

        email_params_with_user =
          Map.put(email_params, "user_id", current_user.id)
          |> Map.put("status", status)

        # EmailSender.send_email(email_params_with_user)
        save_email(socket, socket.assigns.action, email_params_with_user)
      end)
    else
      contact_email = Contacts.get_contact_email!(contact_id)

      user_exists = Accounts.get_user_by_email!(contact_email)

      status =
        if user_exists do
          "Sent"
        else
          "Failed"
        end

      email_params_with_user =
        Map.put(email_params, "user_id", current_user.id)
        |> Map.put("status", status)

      # EmailSender.send_email(email_params_with_user)
      save_email(socket, socket.assigns.action, email_params_with_user)
    end

    {:noreply,
     socket
     |> put_flash(:info, "Email Saved successfully")
     |> push_patch(to: socket.assigns.patch)}
  end


  # def handle_event("save", %{"email" => email_params} = params, socket) do
  #   current_user = socket.assigns.current_user

  #   contact_id = email_params["contact_id"]

  #   # get email address based on contact_id

  #   if socket.assigns.show_group_dropdown do
  #     email_list = get_group_member_emails(email_params["group_id"])

  #     Enum.each(email_list, fn email ->
  #       user_exists = Accounts.get_user_by_email!(email)

  #       status =
  #         if user_exists do
  #           "Sent"
  #         else
  #           "Failed"
  #         end

  #       email_params_with_user =
  #         Map.put(email_params, "user_id", current_user.id)
  #         |> Map.put("status", status)

  #       # EmailSender.send_email(email_params_with_user)
  #       save_email(socket, socket.assigns.action, email_params_with_user)
  #     end)
  #   else
  #     contact_email = Contacts.get_contact_email!(contact_id)

  #     email =
  #       EmailFunctions.new()
  #       |> EmailFunctions.to(contact_email)
  #       |> EmailFunctions.from("bensongathu23@gmail.com")
  #       |> EmailFunctions.subject(email_params["subject"])
  #       |> EmailFunctions.html_body(email_params["body"])

  #       IO.inspect(email)
  #       case Mailer.deliver(email, :email_notification) do

  #       {:ok, _info} ->
  #         {:noreply, assign(socket, :success)}
  #       {:error, reason} ->
  #         {:noreply, assign(socket, :error, reason)}
  #     end

  #     # email_params_with_user =
  #     #   Map.put(email_params, "user_id", current_user.id)
  #     #   |> Map.put("status", status)

  #     # EmailSender.send_email(email_params_with_user)
  #     # save_email(socket, socket.assigns.action, email_params_with_user)
  #   end

  #   {:noreply,
  #    socket
  #    |> put_flash(:info, "Email Saved successfully")
  #    |> push_patch(to: socket.assigns.patch)}
  # end



  # function to get members in a grp
  def get_group_member_emails(id) do
    group_contacts = GroupContacts.get_group_contact_by_groupID!(id)

    emails =
      Enum.map(group_contacts, fn group_contact ->
        contact = group_contact.contact
        contact.email_address
      end)

    IO.inspect("emails")
    IO.inspect(emails)
    emails
  end

  #
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
    IO.inspect(socket.assigns)

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
         |> redirect(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
