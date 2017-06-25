defmodule EnhancedMap.APIMarkerController do
  use EnhancedMap.Web, :controller


  alias EnhancedMap.Marker

  plug :verify_map_for_current_user

  def update(conn, %{"id" => id, "marker" => marker_params}) do

    marker = Repo.get!(Marker, id)
    changeset = Marker.changeset(marker, marker_params)

    case Repo.update(changeset) do
      {:ok, _marker} ->
        json(conn, %{status: :ok})
      {:error, _changeset} ->
        json(conn, %{status: :error})
    end
  end



  def verify_map_for_current_user(conn, _opts) do
    map_id = conn.params["api_map_id"]
    map = Repo.get(EnhancedMap.Map, map_id)
    session_current_user = get_session(conn, :current_user)

    if session_current_user && map.user_id == session_current_user.id do
      conn
    else
      conn
        |> json(%{status: :error}) 
        |> halt()
   end
  end
end
