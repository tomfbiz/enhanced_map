defmodule EnhancedMap.ReadonlyMapController do
  use EnhancedMap.Web, :controller

  alias EnhancedMap.Map

  def show(conn, %{"id" => id}) do
    map = Repo.get!(Map, id)  |> Repo.preload(:markers)
    render(conn, "show.html", map: map)
  end
end
