defmodule EnhancedMap.MarkerController do
  use EnhancedMap.Web, :controller

  alias EnhancedMap.Marker

  plug :assign_map

  def index(conn, _params) do
    assign(conn, :map_id, conn.params["map_id"])
    markers = Repo.all(Marker)
    render(conn, "index.html", markers: markers)
  end

  def new(conn, _params) do
   changeset = conn.assigns[:map]
                |> build_assoc(:markers)
                |> Marker.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"marker" => marker_params}) do
    changeset = conn.assigns[:map]
                |> build_assoc(:markers)
                |> Marker.changeset(marker_params)
    case Repo.insert(changeset) do
      {:ok, _marker} ->
        conn
        |> put_flash(:info, "Marker created successfully.")
        |> redirect(to: map_path(conn, :show, conn.assigns[:map]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    marker = Repo.get!(Marker, id)
    render(conn, "show.html", marker: marker)
  end

  def edit(conn, %{"id" => id}) do
    marker = Repo.get!(Marker, id)
    changeset = Marker.changeset(marker)
    render(conn, "edit.html", marker: marker, changeset: changeset)
  end

  def update(conn, %{"id" => id, "marker" => marker_params}) do
    marker = Repo.get!(Marker, id)
    changeset = Marker.changeset(marker, marker_params)

    case Repo.update(changeset) do
      {:ok, marker} ->
        conn
        |> put_flash(:info, "Marker updated successfully.")
        |> redirect(to: map_marker_path(conn, :show, marker.map_id, marker))
      {:error, changeset} ->
        render(conn, "edit.html", marker: marker, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    marker = Repo.get!(Marker, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(marker)

    conn
    |> put_flash(:info, "Marker deleted successfully.")
    |> redirect(to: map_marker_path(conn, :index, marker.map_id))
  end

  defp assign_map(conn,_opts) do
    case conn.params do
      %{"map_id" => map_id} ->
        map  = Repo.get(EnhancedMap.Map, map_id)
        assign(conn, :map, map)
      _ ->
        conn
    end
  end
end
