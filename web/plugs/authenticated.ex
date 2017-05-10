defmodule EnhancedMap.Plugs.Authenticated do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _) do
    conn = fetch_session(conn)
    session_current_user = get_session(conn, :current_user)

    cond do
      !is_nil(conn.assigns[:current_user]) -> conn
      !is_nil(session_current_user) ->
        assign(conn, :current_user, session_current_user)
      true ->
        not_logged_in_url = Addict.Configs.not_logged_in_url || "/login"
        conn |> Phoenix.Controller.redirect(to: not_logged_in_url) |> halt
    end
  end
end
