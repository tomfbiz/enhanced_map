defmodule EnhancedMap.MapControllerTest do
  use EnhancedMap.ConnCase

  alias EnhancedMap.Map
  import EnhancedMap.Factory

  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, edit_map_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing map"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, edit_map_path(conn, :new)
    assert html_response(conn, 200) =~ "New map"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, edit_map_path(conn, :create), map: string_params_for(:map)
    assert redirected_to(conn) == edit_map_path(conn, :index)
    assert Repo.get_by(Map, params_for(:map))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, edit_map_path(conn, :create), map: @invalid_attrs
    assert html_response(conn, 200) =~ "New map"
  end

  test "shows chosen resource", %{conn: conn} do
    map = insert(:map)
    conn = get conn, edit_map_path(conn, :show, map)
    assert html_response(conn, 200) =~ "Show map"
  end

  test "includes any markers", %{conn: conn} do
    map = insert(:map)
    marker = insert(:marker, %{map: map, name: "I am here"})

    conn = get conn, edit_map_path(conn, :show, map)
    assert html_response(conn, 200) =~ "I am here"
  end
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, edit_map_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    map = Repo.insert! %Map{}
    conn = get conn, edit_map_path(conn, :edit, map)
    assert html_response(conn, 200) =~ "Edit map"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    params = params_for(:map)
    map = Repo.insert! %Map{}
    conn = put conn, edit_map_path(conn, :update, map), map: params
    assert redirected_to(conn) == edit_map_path(conn, :show, map)
    assert Repo.get_by(Map, params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    map = Repo.insert! %Map{}
    conn = put conn, edit_map_path(conn, :update, map), map: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit map"
  end

  test "deletes chosen resource", %{conn: conn} do
    map = Repo.insert! %Map{}
    conn = delete conn, edit_map_path(conn, :delete, map)
    assert redirected_to(conn) == edit_map_path(conn, :index)
    refute Repo.get(Map, map.id)
  end
end
