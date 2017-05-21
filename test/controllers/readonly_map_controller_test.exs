defmodule EnhancedMap.ReadonlyMapControllerTest do
  use EnhancedMap.ConnCase

  alias EnhancedMap.Map
  import EnhancedMap.Factory

  test "shows chosen resource", %{conn: conn} do
    map = insert(:map)

    conn = get conn, readonly_map_path(conn, :show, map)
    assert html_response(conn, 200) =~ "<h1>#{map.title}"
  end

  test "includes any markers", %{conn: conn} do
    map = insert(:map)
    insert(:marker, %{map: map, name: "I am here"})

    conn = get conn, readonly_map_path(conn, :show, map)
    assert html_response(conn, 200) =~ "I am here"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do

    assert_error_sent 404, fn ->
      get conn, readonly_map_path(conn, :show, -1)
    end
  end
end
