defmodule EnhancedMap.APIMarkerControllerTest do
  use EnhancedMap.ConnCase

  alias EnhancedMap.Marker
  import EnhancedMap.Factory

  @invalid_attrs %{lat: "bb" }
  @valid_attrs %{lat: Decimal.new(9), long: Decimal.new(10)}
 
  test "returns an error if not logged in", %{conn: conn}  do
    marker = insert(:marker)
    conn = patch conn, api_map_api_marker_path(conn, :update, marker.map, marker)
    before_lat = marker.lat

    response = conn
                |> patch( api_map_api_marker_path(conn, :update, marker.map,  marker),
                         %{marker: @valid_attrs})
                |> json_response(200)

assert response["status"] == "error"
    assert Repo.get(Marker, marker.id).lat == before_lat
  end

  test "returns error on  update when map is for another user", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()
    marker = insert(:marker, map: map) 
    before_lat = marker.lat

    response = conn
                |> patch( api_map_api_marker_path(conn, :update, marker.map,  marker),
                         %{marker: @valid_attrs})
                |> json_response(200)

    assert response["status"] == "error"
    assert Repo.get(Marker, marker.id).lat == before_lat
  end

  test "updates chosen resource when data is valid", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    marker = insert(:marker, map: map)

    response = conn
                |> patch( api_map_api_marker_path(conn, :update, marker.map,  marker),
                         %{marker: @valid_attrs})
                |> json_response(200)

    assert response["status"] == "ok"
    assert Repo.get_by(Marker, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    marker = insert(:marker, map: map)

    response = conn
                |> patch( api_map_api_marker_path(conn, :update, marker.map,  marker),
                          %{marker: @invalid_attrs})
                 |> json_response(200)

    assert response["status"] == "error"
    assert Repo.get(Marker, marker.id).lat != "xx"
  end
end
