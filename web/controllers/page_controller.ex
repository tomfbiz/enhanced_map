defmodule EnhancedMap.PageController do
  use EnhancedMap.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
