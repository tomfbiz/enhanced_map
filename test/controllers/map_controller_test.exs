defmodule EnhancedMap.MapControllerTest do
  use EnhancedMap.ConnCase

  alias EnhancedMap.Map
  import EnhancedMap.Factory

  @invalid_attrs %{}

  test "redirects to login if not logged in", %{conn: conn}  do
    conn = get conn, edit_map_path(conn, :index)
    assert redirected_to(conn) == login_path(conn, :login)
  end

  test "lists all my entries on index", %{conn: conn} do
    conn = login_user(conn)
    map1 = insert_map_for_user(conn)
    map2 = insert_map_for_other_user()

    conn = get conn, edit_map_path(conn, :index)
    assert html_response(conn, 200) =~ map1.title
    refute (html_response(conn, 200) =~ map2.title)
  end

  test "renders form for new resources", %{conn: conn} do
    conn = login_user(conn)

    conn = get conn, edit_map_path(conn, :new)
    assert html_response(conn, 200) =~ "New map"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = login_user(conn)

    conn = post conn, edit_map_path(conn, :create), map: string_params_for(:map)
    assert redirected_to(conn) == edit_map_path(conn, :index)
    assert Repo.get_by(Map, params_for(:map))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = login_user(conn)

    conn = post conn, edit_map_path(conn, :create), map: @invalid_attrs
    assert html_response(conn, 200) =~ "New map"
  end

  test "shows chosen resource", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)

    conn = get conn, edit_map_path(conn, :show, map)
    assert html_response(conn, 200) =~ "Show map"
  end

  test "includes any markers", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)
    insert(:marker, %{map: map, name: "I am here"})

    conn = get conn, edit_map_path(conn, :show, map)
    assert html_response(conn, 200) =~ "I am here"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = login_user(conn)

    assert_error_sent 404, fn ->
      get conn, edit_map_path(conn, :show, -1)
    end
  end

  test "renders page not found for show when map is for another user", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()

    conn = get conn, edit_map_path(conn, :show, map)
    assert conn.status == 404
  end

  test "renders page not found for edit when map is for another user", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()

    conn = get conn, edit_map_path(conn, :edit, map)
    assert conn.status == 404
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)

    conn = get conn, edit_map_path(conn, :edit, map)
    assert html_response(conn, 200) =~ "Edit map"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    conn = login_user(conn)
    params = params_for(:map)
    map = insert_map_for_user(conn)
    conn = put conn, edit_map_path(conn, :update, map), map: params
    assert redirected_to(conn) == edit_map_path(conn, :show, map)
    assert Repo.get_by(Map, params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = login_user(conn)
    map = Repo.insert! %Map{}

    conn = put conn, edit_map_path(conn, :update, map), map: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit map"
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_user(conn)

    conn = delete conn, edit_map_path(conn, :delete, map)
    assert redirected_to(conn) == edit_map_path(conn, :index)
    refute Repo.get(Map, map.id)
  end

  test "does not delete if not current user's map", %{conn: conn} do
    conn = login_user(conn)
    map = insert_map_for_other_user()

    conn = delete conn, edit_map_path(conn, :delete, map)
    assert conn.status == 404
    assert Repo.get(Map, map.id)
  end

  defp insert_map_for_user(conn) do
    insert(:map, user_id: conn.assigns.current_user.id)
  end

  defp insert_map_for_other_user do
    user2 = insert( :user)
    insert(:map, user_id: user2.id, title: "other user map")
  end
end
