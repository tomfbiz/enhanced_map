defmodule EnhancedMap.MarkerControllerTest do
  use EnhancedMap.ConnCase

  alias EnhancedMap.Marker
  import EnhancedMap.Factory

  @invalid_attrs %{}

  test "redirects to login if not logged in", %{conn: conn}  do
    marker = insert(:marker)
    conn = get conn, edit_map_marker_path(conn, :show, marker.map, marker)
    assert redirected_to(conn) == login_path(conn, :login)
  end

  test "renders form for new resources", %{conn: conn} do
    conn = login_user(conn)
    map = insert(:map)

    conn = get conn, edit_map_marker_path(conn, :new, map)
    assert html_response(conn, 200) =~ "New marker"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    marker_attrs = params_for(:marker, map: map)

    conn = post conn, edit_map_marker_path(conn, :create, map), marker: marker_attrs
    assert redirected_to(conn) == edit_map_path(conn, :show, map)
    assert Repo.get_by(Marker, valid_attrs())
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    conn = post conn, edit_map_marker_path(conn, :create, map), marker: @invalid_attrs
    assert html_response(conn, 200) =~ "New marker"
  end

  test "renders page not found when map not for user", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()
    marker_attrs = params_for(:marker, map: map)

   conn = post conn, edit_map_marker_path(conn, :create, map), marker: marker_attrs
   assert conn.status == 404
  end

  test "shows chosen resource", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    marker = insert(:marker, map: map)
    conn = get conn, edit_map_marker_path(conn, :show, marker.map, marker)
    assert html_response(conn, 200) =~ "Show marker"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = login_user(conn)

    conn = get conn, edit_map_marker_path(conn, :show,-1, -1)
  
    assert conn.status == 404
  end

  test "renders page not found for show when map is for another user", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()
    marker = insert(:marker, map: map)
    conn = get conn, edit_map_marker_path(conn, :show, map,  marker)

    assert conn.status == 404
  end

  test "renders page not found for edit when map is for another user", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()
    marker = insert(:marker, map: map) 

    conn = get conn, edit_map_marker_path(conn, :edit, map, marker)

    assert conn.status == 404
  end


  test "renders form for editing chosen resource", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    marker = insert(:marker, map: map)

    conn = get conn, edit_map_marker_path(conn, :edit, marker.map, marker)

    assert html_response(conn, 200) =~ "Edit marker"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    conn = login_user(conn)
    marker = insert(:marker)

    conn = put conn, edit_map_marker_path(conn, :update, marker.map,  marker), marker: valid_attrs()

    assert redirected_to(conn) == edit_map_marker_path(conn, :show, marker.map, marker)
    assert Repo.get_by(Marker, valid_attrs())
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = login_user(conn)
    marker = insert(:marker)

    conn = put conn, edit_map_marker_path(conn, :update, marker.map, marker), 
               marker: params_for(:marker, name: "")

     assert html_response(conn, 200) =~ "Edit marker"
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    marker = insert(:marker, map: map)

    conn = delete conn, edit_map_marker_path(conn, :delete, marker.map, marker)

    assert redirected_to(conn) == edit_map_path(conn, :index)
    refute Repo.get(Marker, marker.id)
  end


  test "does not delete resource for other user", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()
    marker = insert(:marker, map: map)

    conn = delete conn, edit_map_marker_path(conn, :delete, marker.map, marker)

    assert conn.status == 404
    assert Repo.get(Marker, marker.id)
  end

  defp valid_attrs do
    params_for(:marker)
  end
end
