defmodule Elixium.HostAvailability.Supervisor do
  use Supervisor

  def start_link() do
    IO.puts "Within Startlink"
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      Elixium.HostAvailability,
      Elixium.HostCheck
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end