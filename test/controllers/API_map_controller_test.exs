defmodule EnhancedMap.APIMapControllerTest do
  use EnhancedMap.ConnCase

  alias EnhancedMap.Map
  import EnhancedMap.Factory

  @invalid_attrs %{overlay_south: "xx"}
  @valid_attrs  %{overlay_north: Decimal.new(9), overlay_south: Decimal.new(8), overlay_east: Decimal.new(7), overlay_west: Decimal.new(6)}
 
  test "error if not logged in", %{conn: conn}  do
    map = insert(:map)
    response = conn
               |> patch( api_map_path(conn, :update, map),
    %{map: @valid_attrs})
                |> json_response(200)
    assert response["status"] == "error"
  end

  test "returns error update when map is for another user", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()
    before_overlay_south = map.overlay_south
    response = conn
               |> patch( api_map_path(conn, :update, map),
    %{map: @valid_attrs})
                |> json_response(200)
    assert response["status"] == "error"
    assert Repo.get(Map, map.id).overlay_south == before_overlay_south
  end

  test "updates chosen resource when data is valid", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    response = conn
               |> patch( api_map_path(conn, :update, map),
                          %{map: @valid_attrs})
                |> json_response(200)
    assert response["status"] == "ok"
    assert Repo.get_by(Map, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    response = conn
               |> patch( api_map_path(conn, :update, map),
                         %{map: @invalid_attrs}) 
                |> json_response(200)

    assert response["status"] == "error"
    assert Repo.get(Map, map.id).overlay_south != "xx"
  end
end
