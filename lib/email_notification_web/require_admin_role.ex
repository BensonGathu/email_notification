defmodule EmailNotificationWeb.RequireAdminRole do
  require Logger
  import Plug.Conn

  def init(_opts), do: []

  def call(conn, _opts) do
    case get_user_role(conn.assigns.current_user) do
      :admin ->
        conn

      _ ->
        case get_user_role(conn.assigns.current_user) do
          :superuser ->
            conn

          _ ->
            conn
            # |> put_flash(:error, "You don't have permission to access this page.")
            # |> redirect(to: Routes.live_path(conn, MyAppWeb.ErrorLive, :unauthorized))
            |> halt()
        end
    end
  end

  defp get_user_role(user) do
    String.to_existing_atom(user.role.name)
  end
end
