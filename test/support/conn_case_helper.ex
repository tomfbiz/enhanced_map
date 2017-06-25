defmodule EnhancedMap.ConnCaseHelper do
  import EnhancedMap.Factory

  def login_user(conn) do
    user = insert(:user)
    Plug.Test.init_test_session(conn, %{current_user: user})
  end

  def insert_map_for_user(conn) do
    session_current_user = Plug.Conn.get_session(conn, :current_user) 
    insert(:map, user_id: session_current_user.id)
  end

  def insert_map_for_other_user do
    user2 = insert( :user)
    insert(:map, user_id: user2.id, title: "other user map")
  end

  def insert_marker_for_user(conn) do
    map = insert_map_for_user(conn)
    insert(:marker, map: map)
  end
end
