defmodule Rumbl.UppyChannel do
  use Phoenix.Channel
  def handle_info :after_join, socket do
    {:noreply, socket}
  end
  def join("uppy", _message, socket) do
    IO.inspect "---------------------------"
    IO.inspect "-----------Rumbl.UserSocket----------------"
    {:ok, socket}
  end
  def join(_whatever, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end