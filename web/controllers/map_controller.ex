defmodule EnhancedMap.MapController do
  use EnhancedMap.Web, :controller

  alias EnhancedMap.Map

  def index(conn, _params) do
    map = Repo.all(Map)
    render(conn, "index.html", map: map)
  end

  def new(conn, _params) do
    changeset = Map.changeset(%Map{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"map" => map_params}) do
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
    render(conn, "show.html", map: map)
  end

  def edit(conn, %{"id" => id}) do
    map = Repo.get!(Map, id)
    changeset = Map.changeset(map)
    render(conn, "edit.html", map: map, changeset: changeset)
  end

  def update(conn, %{"id" => id, "map" => map_params}) do
    map = Repo.get!(Map, id)
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

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(map)

    conn
    |> put_flash(:info, "Map deleted successfully.")
    |> redirect(to: edit_map_path(conn, :index))
  end
end
