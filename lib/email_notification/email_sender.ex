defmodule EmailNotification.EmailSender do
  alias Bamboo.Email
  alias Swoosh.Adapters.Local
  require Logger
  defp build_email(subject, body, contact_email) do
    %Bamboo.Email{
      to: {contact_email},
      from: {""},
      subject: subject,
      html_body: body
    }
  end

  # def send_email(email) do
  #   Swoosh.Mailer.deliver(email, [adapter: Local, otp_app: :email_notification])
  # end
  def send_email(email) do
    EmailNotification.Mailer.deliver(email)
  end

  def send_email_with_params(subject, body, contact_email) do
    email = build_email(subject, body, contact_email)
    Logger.info("Email being sent")
    Logger.info("Email: #{inspect(email)}")

    case send_email(email) do
      :ok ->
        Logger.info("Email sending failed")
      {:error, reason} ->
        Logger.error("Email sending failed: #{reason}")
    end
  end
end
