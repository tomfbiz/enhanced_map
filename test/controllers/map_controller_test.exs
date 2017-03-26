defmodule EnhancedMap.MapControllerTest do
  use EnhancedMap.ConnCase

  alias EnhancedMap.Map
  @valid_attrs %{center_lat: "120.5", center_long: "120.5", description: "some content", overlay_east: "120.5", overlay_north: "120.5", overlay_south: "120.5", overlay_west: "120.5", ovetrlay_URL: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, map_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing map"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, map_path(conn, :new)
    assert html_response(conn, 200) =~ "New map"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, map_path(conn, :create), map: @valid_attrs
    assert redirected_to(conn) == map_path(conn, :index)
    assert Repo.get_by(Map, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, map_path(conn, :create), map: @invalid_attrs
    assert html_response(conn, 200) =~ "New map"
  end

  test "shows chosen resource", %{conn: conn} do
    map = Repo.insert! %Map{}
    conn = get conn, map_path(conn, :show, map)
    assert html_response(conn, 200) =~ "Show map"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, map_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    map = Repo.insert! %Map{}
    conn = get conn, map_path(conn, :edit, map)
    assert html_response(conn, 200) =~ "Edit map"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    map = Repo.insert! %Map{}
    conn = put conn, map_path(conn, :update, map), map: @valid_attrs
    assert redirected_to(conn) == map_path(conn, :show, map)
    assert Repo.get_by(Map, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    map = Repo.insert! %Map{}
    conn = put conn, map_path(conn, :update, map), map: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit map"
  end

  test "deletes chosen resource", %{conn: conn} do
    map = Repo.insert! %Map{}
    conn = delete conn, map_path(conn, :delete, map)
    assert redirected_to(conn) == map_path(conn, :index)
    refute Repo.get(Map, map.id)
  end
end
