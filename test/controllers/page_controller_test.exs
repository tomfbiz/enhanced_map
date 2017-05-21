defmodule EnhancedMap.PageControllerTest do
  use EnhancedMap.ConnCase
  import EnhancedMap.Factory

  test "link to map if there is one", %{conn: conn} do
    map = insert(:map)

    conn = get conn, "/"

    assert html_response(conn, 200) =~ readonly_map_path(conn, :show, map)
  end

  test "redirect if logged in", %{conn: conn} do
    conn =  login_user(conn)
    
    conn= get(conn, "/")
    assert redirected_to(conn) == edit_map_path(conn, :index)
  end
end
