defmodule Rumbl.PageController do
  use Rumbl.Web, :controller
  use Drab.Controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def redirect_to_drab(conn, _params) do
    redirect conn, to: "/drab"
  end

end
