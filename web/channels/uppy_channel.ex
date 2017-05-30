defmodule Rumbl.UppyChannel do
  use Phoenix.Channel
  def handle_info :after_join, socket do
    IO.inspect "-----------CHANNEL HANDLE_INFO----------------"
    {:noreply, socket}
  end
  def join(_, _message, socket) do    
    IO.inspect "-----------CHANNEL JOIN----------------"
    {:ok, socket}
  end
  def join(_whatever, _params, _socket) do
    IO.inspect "-----------CHANNEL JOIN----------------"
    {:error, %{reason: "unauthorized"}}
  end
  def handle_in(_, payload, socket) do
    IO.inspect "-----------CHANNEL HANDLE_IN----------------"
    broadcast! socket, "new_msg", %{body: "Hello body"}
    {:noreply, socket}
  end

  def handle_out(_, payload, socket) do
     IO.inspect "-----------CHANNEL HANDLE_OUT----------------"
    push socket, "new_msg", payload
    {:noreply, socket}
  end

end