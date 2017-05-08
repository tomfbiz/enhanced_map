defmodule EnhancedMap.MarkerControllerTest do
  use EnhancedMap.ConnCase

  alias EnhancedMap.Marker
  import EnhancedMap.Factory

  @invalid_attrs %{}

  #test "lists all entries on index", %{conn: conn} do
  # conn = get conn, marker_path(conn, :index)
  # assert html_response(conn, 200) =~ "Listing markers"
  #end

  test "renders form for new resources", %{conn: conn} do
    map = insert(:map)
    conn = get conn, edit_map_marker_path(conn, :new, map)
    assert html_response(conn, 200) =~ "New marker"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    map = insert(:map)
    marker_attrs = params_for(:marker, map: map)

    conn = post conn, edit_map_marker_path(conn, :create, map), marker: marker_attrs
    assert redirected_to(conn) == edit_map_path(conn, :show, map)
    assert Repo.get_by(Marker, valid_attrs())
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    map = insert(:map)
    conn = post conn, edit_map_marker_path(conn, :create, map), marker: @invalid_attrs
    assert html_response(conn, 200) =~ "New marker"
  end

  test "shows chosen resource", %{conn: conn} do
    marker = insert(:marker)
    conn = get conn, edit_map_marker_path(conn, :show, marker.map, marker)
    assert html_response(conn, 200) =~ "Show marker"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, edit_map_marker_path(conn, :show,-1, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    marker = insert(:marker)
    conn = get conn, edit_map_marker_path(conn, :edit, marker.map, marker)
    assert html_response(conn, 200) =~ "Edit marker"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    marker = insert(:marker)

    conn = put conn, edit_map_marker_path(conn, :update, marker.map,  marker), marker: valid_attrs()
    
    assert redirected_to(conn) == edit_map_marker_path(conn, :show, marker.map, marker)
    assert Repo.get_by(Marker, valid_attrs())
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    marker = insert(:marker)

    conn = put conn, edit_map_marker_path(conn, :update, marker.map, marker), 
               marker: params_for(:marker, name: "")
     assert html_response(conn, 200) =~ "Edit marker"
  end

  test "deletes chosen resource", %{conn: conn} do
    marker = insert(:marker)
    conn = delete conn, edit_map_marker_path(conn, :delete, marker.map, marker)
    assert redirected_to(conn) == edit_map_marker_path(conn, :index, marker.map)
    refute Repo.get(Marker, marker.id)
  end

  defp valid_attrs do
    params_for(:marker)
  end
end
