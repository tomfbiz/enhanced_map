defmodule EnhancedMap.MarkerController do
  use EnhancedMap.Web, :controller
  plug Addict.Plugs.Authenticated


  alias EnhancedMap.Marker

  plug :assign_map

  def new(conn, _params) do
   changeset = conn.assigns[:map]
                |> build_assoc(:markers)
                |> Marker.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"marker" => marker_params}) do
  case verify_map_for_current_user(conn) do
    {:error, conn} -> conn
    {:ok, conn} ->
    changeset = conn.assigns[:map]
                |> build_assoc(:markers)
                |> Marker.changeset(marker_params)
      case Repo.insert(changeset) do
        {:ok, _marker} ->
          conn
            |> put_flash(:info, "Marker created successfully.")
            |> redirect(to: edit_map_path(conn, :show, conn.assigns[:map]))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    case verify_map_for_current_user(conn) do
      {:error, conn} -> conn
      {:ok, conn} ->
        marker = Repo.get!(Marker, id)
        render(conn, "show.html", marker: marker)
    end
  end

  def edit(conn, %{"id" => id}) do
    case verify_map_for_current_user(conn) do
      {:error, conn} -> conn
      {:ok, conn} ->
        marker = Repo.get!(Marker, id)
        changeset = Marker.changeset(marker)
        render(conn, "edit.html", marker: marker, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "marker" => marker_params}) do
    marker = Repo.get!(Marker, id)
    changeset = Marker.changeset(marker, marker_params)

    case Repo.update(changeset) do
      {:ok, marker} ->
        if is_json?(conn) do
          json(conn, %{status: :ok})
        else
          conn
          |> put_flash(:info, "Marker updated successfully.")
          |> redirect(to: edit_map_marker_path(conn, :show, marker.map_id, marker))
        end
      {:error, changeset} ->
        render(conn, "edit.html", marker: marker, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
     case verify_map_for_current_user(conn) do
      {:error, conn} -> conn
      {:ok, conn} ->
         marker = Repo.get!(Marker, id)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
        Repo.delete!(marker)
        conn
          |> put_flash(:info, "Marker deleted successfully.")
          |> redirect(to: edit_map_path(conn, :index))
     end
  end

  defp is_json?(conn) do
    accept = get_req_header(conn, "accept")
    Enum.member?(accept,"application/json")
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

  def verify_map_for_current_user(conn) do
    if conn.assigns[:map]  && conn.assigns[:current_user] && conn.assigns[:map].user_id == conn.assigns[:current_user].id do
      {:ok, conn}
    else
      conn=conn 
            |> put_status(:not_found)
            |> render(EnhancedMap.ErrorView, "404.html")
            |> halt
      {:error, conn}
   end
  end
end
