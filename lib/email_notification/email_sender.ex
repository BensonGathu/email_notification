defmodule EmailNotification.EmailSender do
  alias Bamboo.Email

  defp build_email(subject, body, contact_email) do
    email_params = %{
      to: [contact_email],
      from: "your_email@example.com",
      subject: subject,
      html_body: body
    }

    Email.build_email(email_params)
  end

  def send_email(email) do
    MyApp.Mailer.deliver(email)
  end

  def send_email_with_params(subject, body, contact_email) do
    email = build_email(subject, body, contact_email)
    send_email(email)
  end
end
