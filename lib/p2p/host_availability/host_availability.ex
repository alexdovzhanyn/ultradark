defmodule Elixium.HostAvailability do
  use GenServer
  require IEx
  require Logger

  def start_link(_args) do
    Logger.info("Starting Host Availability through Port 31014..")
    {:ok, socket} = :gen_tcp.listen(31014, [:binary, active: true, reuseaddr: true])
    GenServer.start_link(__MODULE__, socket, name: __MODULE__)
  end

  def init(socket) do
    Process.send_after(self(), :start_accept, 1000)

    {:ok, %{listen: socket}}
  end

  def start_accept do
    GenServer.cast(__MODULE__, :start_accept)
  end

  def handle_info(:start_accept, state) do
    Logger.info("Host Availability Listening")

    {:ok, socket} = :gen_tcp.accept(state.listen)

    state = Map.put(state, :socket, socket)
    {:noreply, state}
  end

  def handle_info({:tcp, _, data}, state) do
    Logger.info("Received Data from Host: #{data}")

    :gen_tcp.send(state.socket, "HELLO")
    :gen_tcp.close(state.socket)

    {:ok, socket} = :gen_tcp.accept(state.listen)

    state = Map.put(state, :socket, socket)
    {:noreply, state}
  end

end
