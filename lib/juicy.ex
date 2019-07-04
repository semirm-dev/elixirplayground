defmodule Juicy do
  def juice do
    IO.puts("Juice :D")

    # proc()

    {:ok, pid} = start_link()

    send(pid, {:put, :hello, :world})
    IO.puts("put done")
    send(pid, {:get, :hello, self()})
    IO.puts("get done")
  end

  def proc() do
    pid = spawn(fn -> 1 + 2 end)

    IO.inspect(pid)

    send(self(), {:hello, "world"})

    receive do
      {:hello, msg} ->
        IO.puts("msg received:")
        IO.puts(msg)

      {:world, _} ->
        "does not exist"
    end

    spawn_link(fn -> raise ":O spawn_link" end)
    Task.start_link(fn -> IO.puts(":O task.start") end)
    Task.start_link(fn -> raise ":O task.start" end)
  end

  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send(caller, Map.get(map, key))
        loop(map)

      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end
