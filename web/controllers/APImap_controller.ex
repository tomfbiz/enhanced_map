defmodule EnhancedMap.APIMapController do
  use EnhancedMap.Web, :controller
  alias EnhancedMap.Map

  plug :verify_map_for_current_user

  def update(conn, %{"id" => id, "map" => map_params}) do

    map = Repo.get!(Map, id)
    changeset = Map.changeset(map, map_params)

    case Repo.update(changeset) do
      {:ok, _map} ->
        json(conn, %{status: :ok})
      {:error, _changeset} ->
        json(conn, %{status: :error})
    end
  end



  def verify_map_for_current_user(conn, _opts) do
    map_id = conn.params["id"]
    map = Repo.get(Map, map_id)
    if conn.assigns[:current_user] && map.user_id == conn.assigns[:current_user].id do
      conn
    else
      conn
        |> json(%{status: :error}) 
        |> halt()
   end
  end
end
