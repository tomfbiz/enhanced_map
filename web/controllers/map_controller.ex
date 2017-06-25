defmodule EnhancedMap.MapController do
  use EnhancedMap.Web, :controller

  alias EnhancedMap.Map
  plug Addict.Plugs.Authenticated

  def index(conn, _params) do
    map = Repo.all(
            from map in Map, 
            where: map.user_id == ^current_user_id(conn)
          )
    render(conn, "index.html", map: map)
  end

  def new(conn, _params) do
    changeset = Map.changeset(%Map{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"map" => map_params}) do
    map_params = Elixir.Map.put(map_params, "user_id", current_user_id(conn))
    changeset = Map.changeset(%Map{}, map_params)

    case Repo.insert(changeset) do
      {:ok, _map} ->
        conn
        |> put_flash(:info, "Map created successfully.")
        |> redirect(to: edit_map_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    map = Repo.get!(Map, id)  |> Repo.preload(:markers)
    if current_user_id(conn) == map.user_id do
      render(conn, "show.html", map: map)
    else
      conn 
      |> put_status(:not_found)
      |> render(EnhancedMap.ErrorView, "404.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    map = Repo.get!(Map, id)
    if current_user_id(conn) == map.user_id do

     changeset = Map.changeset(map)
      render(conn, "edit.html", map: map, changeset: changeset)
    else
       conn 
      |> put_status(:not_found)
      |> render(EnhancedMap.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "map" => map_params}) do
    map = Repo.get!(Map, id)
    map_params = Elixir.Map.put(map_params, "user_id", map.user_id)
    changeset = Map.changeset(map, map_params)

    case Repo.update(changeset) do
      {:ok, map} ->
        conn
        |> put_flash(:info, "Map updated successfully.")
        |> redirect(to: edit_map_path(conn, :show, map))
      {:error, changeset} ->
        render(conn, "edit.html", map: map, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    map = Repo.get!(Map, id)

    if current_user_id(conn) == map.user_id do
      Repo.delete!(map)
      conn
        |> put_flash(:info, "Map deleted successfully.")
        |> redirect(to: edit_map_path(conn, :index))
    else
       conn 
          |> put_status(:not_found)
          |> render(EnhancedMap.ErrorView, "404.html")
    end

 end

  defp current_user_id(conn) do
    conn.assigns.current_user.id
  end
end
