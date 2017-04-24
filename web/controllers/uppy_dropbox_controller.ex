defmodule Rumbl.UppyDropbox do
  use Rumbl.Web, :controller
    require Logger

  def get(conn, _params) do
    IO.puts "GET-------UppyDropbox---------------"
    IO.inspect conn
  
    conn 
    |> send_resp(200,"")
  end

  def options(conn, _params) do
    IO.puts "OPTIONS------UppyDropbox----------------"
    expire_date = Date.now |> Date.add(Time.to_timestamp(7, :days))
    secs_to_expire_date = count_seconds_to_expire_date(expire_date)
    conn    
    |> put_resp_header("content-type","text/html; charset=utf-8")
    |> put_resp_header("content-length", "0")
    |> put_resp_header("access-control-allow-origin", "http://localhost:3000")    
    |> put_resp_header("access-control-allow-methods", "POST, GET, HEAD, PATCH, DELETE, OPTIONS")
    |> put_resp_header("access-control-allow-headers","Authorization, Origin, Content-Type, Accept")
    |> put_resp_header("access-control-allow-credentials", true)  
    #|>put_resp_cookie("connect.sid", "fs%3A2dc9n-9-L9-VVVY6woSm6VKxBNYerf86.5qpbYiEGcZu4%2BQ5Z%2FZbtQzigdFOoqom9vfzbDEXt96E", max_age: secs_to_expire_date)
    |>put_resp_cookie("Path","/", max_age: secs_to_expire_date)
    |> send_resp(200,"OK")
  end


  def head(conn, _params) do
    IO.puts "HEAD-----UppyDropbox-----------------"
    %{"uuid" => uuid_media} = _params


    conn
    |> put_resp_header("Content-Type","text/plain; charset=utf-8")
    |> send_resp(200, "")
  end



  defp count_seconds_to_expire_date(date) do
    expire_secs = Date.now |> Date.diff(date, :secs)
    expire_secs
  end

end