defmodule Juicy do

  # You can use spawn_monitor to turn on monitoring when you spawn a process, or
  # you can use Process.monitor to monitor an existing process.
  # However, if you use Process.monitor (or link to an existing process),
  # there is a potential race condition - if the other process dies before your monitor call completes,
  # you may not receive a notification.
  # The spawn_link and spawn_monitor versions are atomic, however, so you’ll always catch a failure.

  # If the intent is that a failure in one process should terminate another, then you need links.
  # If instead you need to know when some other process exits for any reason, choose monitors.

  def juice do
    # proc()

    # start_link_usage()

    run_unlinked()
    run_linked()
    run_linked_trap_exit()
  end

  def proc() do
    pid = spawn(fn -> 1 + 2 end)

    IO.inspect(pid)
    IO.inspect(self())

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

  #
  def start_link_usage do
    {:ok, pid} = start_link()

    send(pid, {:put, :hello, :world})
    IO.puts("put done")

    send(pid, {:get, :hello, self()})
    IO.puts("get done")
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

  #
  def sad_function do
    import :timer, only: [ sleep: 1 ]

    sleep 500
    # will not affect its caller, run() in this case
    # because run() process and sad_function() process are not linked!
    exit(:boom)
  end

  def run_unlinked do
    spawn(Juicy, :sad_function, [])

    receive do
      msg ->
        IO.puts "Unlinked process: #{inspect msg}"
      after 1000 ->
        IO.puts "Unlinked process: Nothing happened as far as I am concerned"
    end
  end

  # So our child process died, and it killed the entire application. That’s the default
  # behavior of linked processes—when one exits abnormally, it kills the other.
  # What if you want to handle the death of another process? Well, you probably
  # don’t want to do this. Elixir uses the OTP framework for constructing process
  # trees, and OTP includes the concept of process supervision. An incredible
  # amount of effort has been spent getting this right, so I recommend using it most
  # of the time.
  def run_linked do
    # Process.flag(:trap_exit, false)

    spawn_link(Juicy, :sad_function, [])

    receive do
    msg ->
      IO.puts "Linked process: #{inspect msg}"
    after 1000 ->
      IO.puts "Linked process: Nothing happened as far as I am concerned"
    end
  end

  def run_linked_trap_exit do
    Process.flag(:trap_exit, true)

    spawn_link(Juicy, :sad_function, [])

    receive do
    msg ->
      IO.puts "Linked process: #{inspect msg}"
    after 1000 ->
      IO.puts "Linked process: Nothing happened as far as I am concerned"
    end
  end
end
