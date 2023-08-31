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
  alias EmailNotification.EmailStatus

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

  def handle_event("save", %{"email" => email_params} = params, socket) do
    current_user = socket.assigns.current_user

    contact_id = email_params["contact_id"]

    email_params_with_user =
      Map.put(email_params, "user_id", current_user.id)
      |> Map.put("status", "Failed")

    save_email(socket, socket.assigns.action, email_params_with_user)

    {:noreply,
     socket
     |> put_flash(:info, "Email Saved successfully")
     |> push_patch(to: socket.assigns.patch)}
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
        IO.inspect(email)

        if email.contact_id do
          email_status_params = %{
            email_id: email.id,
            contact_id: email.contact_id,
            # status: "ok",
            type: "individual"
          }

          email =
            EmailFunctions.new()
            |> EmailFunctions.to(Contacts.get_contact_email!(email.contact_id))
            |> EmailFunctions.from("bensongathu23@gmail.com")
            |> EmailFunctions.subject(email_params["subject"])
            |> EmailFunctions.html_body(email_params["body"])

          case Mailer.deliver(email) do
            {:ok, _info} ->
              email_status_params=  Map.put(email_status_params , :status,"ok")
              {:noreply, assign(socket, :success)}
              save_email_status(email_status_params)
            {:error, reason} ->
              email_status_params=Map.put(email_status_params , :status,"Failed")
              {:noreply, assign(socket, :error, reason)}
              save_email_status(email_status_params)
          end


        else
          # get group members email_addresses
          IO.inspect("Groups Members")
          members = get_group_member_emails(email.group_id)

          IO.inspect(members)

          Enum.each(members, fn contact ->
            email_status_params = %{
              email_id: email.id,
              contact_id: contact.id,
              # status: "ok",
              type: "group"
            }

            email =
              EmailFunctions.new()
              |> EmailFunctions.to(contact.email_address)
              |> EmailFunctions.from("bensongathu23@gmail.com")
              |> EmailFunctions.subject(email_params["subject"])
              |> EmailFunctions.html_body(email_params["body"])

            case Mailer.deliver(email) do
              {:ok, _info} ->
                email_status_params = Map.put(email_status_params, :status, "ok")
                save_email_status(email_status_params)
                {:noreply, assign(socket, :success)}

              {:error, reason} ->
                email_status_params = Map.put(email_status_params, :status, "Failed")
                save_email_status(email_status_params)
                {:noreply, assign(socket, :error, reason)}
            end
          end)



        end

        notify_parent({:saved, email})

        {:noreply,
         socket
         |> put_flash(:info, "Email created successfully")
         |> redirect(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_email_status(email_status_params) do
    EmailStatus.create_email_status(email_status_params)
  end

  # function to get members in a grp
  def get_group_member_emails(id) do
    group_contacts = GroupContacts.get_group_contact_by_groupID!(id)

    emails =
      Enum.map(group_contacts, fn group_contact ->
        contact = group_contact.contact
        contact
      end)

    emails
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
