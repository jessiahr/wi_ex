defmodule WiEx do
  use GenServer
require Logger
#https://stackoverflow.com/questions/22001247/redis-how-to-store-associative-array-set-or-hash-or-list

  def start_link do
    GenServer.start_link(__MODULE__, %{}, [name: __MODULE__])
  end

  def get_interfaces do
    {result, status} = System.cmd "sudo", ["airmon-ng"]
    [headers | interfaces] = result
    |> String.split("\n")
    |> Enum.map(fn(row) -> String.split(row, "\t") end)
    |> Enum.filter(fn(row) -> Enum.count(row) > 1 end)

    headers = headers
    |> Enum.map(fn(h) -> String.downcase(h) end)

    interfaces
    |> Enum.map(fn(i) -> Enum.zip(headers, i) |> Enum.into(%{}) end)
  end
end
