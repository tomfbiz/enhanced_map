defmodule EnhancedMap.PageController do
  use EnhancedMap.Web, :controller

  def index(conn, _params) do
require IEx
    if conn.assigns[:current_user] || get_session(conn, :current_user) do
      conn
       |> redirect(to: edit_map_path(conn, :index))
    else
      first_map = EnhancedMap.Map |> Ecto.Query.first |> Repo.one
      render(conn, "index.html" , first_map: first_map)
    end
  end
end
