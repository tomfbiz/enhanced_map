defmodule EnhancedMap.ConnCaseHelper do
  import EnhancedMap.Factory

  def login_user(conn) do
    user = insert(:user)
    Plug.Conn.assign(conn, :current_user, user)
  end
end
