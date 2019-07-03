defmodule Elixirplayground do
  @moduledoc """
  Documentation for Elixirplayground.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elixirplayground.hello()
      :world

  """
  # .ex -> file intended to be compiled into bytecode
  # .exs -> files interpreted at source level
  # number < atom < reference < function < port < pid < tuple < map < list < bitstring

  def run() do
    do_stuff()
    IO.puts("")

    lists()
    IO.puts("")

    maps()
    IO.puts("")

    anon_funcs()
    IO.puts("")

    print_num(15)
    IO.puts("")

    print_num(-5)
    IO.puts("")

    loop(5)
    IO.puts("")

    sum_list([1, 2, 3, 4, 5, 6, 7], 0)
    IO.puts("")

    vars()
    IO.puts("")

    myIf(true, do: fn -> IO.puts("haha") end, else: "go away")
    IO.puts("")
    myIf(true, do: "wow", else: "go away")
    IO.puts("")
  end

  def do_stuff() do
    # erlang module
    age = :rand.uniform(100)

    IO.puts(:im_atom)

    if age > 18 do
      IO.puts("You are old enough: #{age}")
    else
      IO.puts("You are too young: #{age}")
    end

    # will break on first match
    cond do
      age >= 80 -> IO.puts("Go rock on: #{age}")
      age >= 50 -> IO.puts("You can wait: #{age}")
      true -> true
    end

    case age do
      90 -> IO.puts("Dead, you are dead man: #{age}")
      70 -> IO.puts("You are barely alive: #{age}")
      # <clause> when <condition> -> IO.puts "Dead, you are dead man: #{age}" # guards can be used too for more complex validation
      _ -> true
    end

    IO.puts("Ternary: #{if age > 50, do: "old enough", else: "less than 50"}")

    # [length, width] = [20, 60]
    # IO.puts("Width: #{width}")

    # {length, width} = {20, 60}
    # IO.puts("Length: #{length}")

    [_, [_, width]] = [20, [20, 80]]
    IO.puts("Width: #{width}")

    IO.puts("Def value: #{def_value(5)}")
    IO.puts("Def value: #{def_value()}")
  end

  def lists() do
    list1 = [1, 2, 3]
    list2 = [4, 5, 6]

    list3 = list1 ++ list2
    IO.write("list3: ")
    IO.inspect(list3)

    cond do
      4 in list1 -> IO.puts("4 in list1")
      4 in list2 -> IO.puts("4 in list2")
      # break on previous match
      4 in list3 -> IO.puts("4 in list3")
      true -> "Nowhere"
    end

    f = hd(list3)
    t = tl(list3)
    IO.puts("head: #{f}")
    IO.write("tail: ")
    IO.inspect(t, char_list: :as_list)

    [head | tail] = list3
    IO.puts("head: #{head}")
    IO.write("tail: ")
    IO.inspect(tail, char_list: :as_list)

    IO.puts("enum.each list3")

    Enum.each(list3, fn item ->
      IO.puts(item)
    end)

    IO.puts("removed item 2 from list 3")
    list3 = List.delete(list3, 2)

    IO.puts("Recursion list3:")
    display_items(list3)

    # filter even items in list1 ++ list2
    IO.puts("Filtered even items from list1 ++ list2")
    list4 = for i <- list1 ++ list2, rem(i, 2) == 0, do: i
    display_items(list4)

    kw_list = [{:name, "semir"}, {:age, 30}]
    IO.inspect(kw_list)

    kw_list2 = [name: "semir", age: 30]
    IO.inspect(kw_list2)

    IO.puts(kw_list2[:name])

    odd? = &(rem(&1, 2) != 0)
    total_sum = 1..100 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum()
    IO.inspect(total_sum)
  end

  # recursion
  def display_items([item | items]) do
    IO.puts(item)
    display_items(items)
  end

  def display_items([]), do: nil

  def maps() do
    # using strings as keys
    map1 = %{"Europe" => "Sweden", "USA" => "Canada"}
    # using atoms as keys
    map2 = %{europe: "Sweden", usa: "Canada"}

    IO.puts("Europe: #{map1["Europe"]}, Usa: #{map2.usa}")

    users = [
      john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
      mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
    ]

    IO.inspect(users)
  end

  def anon_funcs() do
    get_sum = fn x, y -> x + y end
    IO.puts("Sum: #{get_sum.(2, 6)}")

    variable_input = fn
      {x, y} -> IO.puts("Two inputs: #{x}, #{y}")
      {x, y, z} -> IO.puts("Three inputs: #{x}, #{y}, #{z}")
    end

    variable_input.({1, 2})
    variable_input.({1, 2, 3})

    # shortcut to create func
    fun = &IO.puts("Good #{&1}")
    fun.("morning")
    # capture func
    cap = &List.flatten(&1, &2)
    l = cap.([1, [[2], 3]], [4, 5])
    IO.inspect(l)
  end

  # default parameter
  def def_value(x \\ 0) do
    x
  end

  # tail recursion will never overflow the stack, stack is not generated because there is nothing left to do after tail call
  # in non-tail recursion there is limit of nested calls because stack is generated and can be potentially overflowed
  # guards like in erlang
  def print_num(n) when n >= 1 do
    IO.puts("Item valid: #{n}")
  end

  def print_num(n) when n < 1 do
    IO.puts("Item invalid: #{n}")
    print_num(n + 1)
  end

  def loop(n) when n <= 1 do
    IO.puts("Last item: #{n}")
  end

  def loop(n) do
    IO.puts("Item: #{n}")
    loop(n - 1)
  end

  def sum_list([head | tail], accumulator) do
    sum_list(tail, head + accumulator)
  end

  def sum_list([], accumulator) do
    accumulator
  end

  def vars() do
    # unlike in erlang, in elixir we can re-assign variables
    a = 1
    IO.puts("a is: #{a}")
    a = 2
    IO.puts("a is: #{a}")
    # must match latest/current match of "a", which in this case is 2 (not 1)
    ^a = 2
    IO.puts("a is: #{a}")

    # use latest/current assigned "a", therefore there must be previous match of "a"
    [1, ^a, 3] = [1, 2, 3]
    IO.puts("a is: #{a}")
    # use latest/current assigned "a", therefore there must be previous match of "a"
    [1, a, 3] = [1, 2, 3]
    IO.puts("a is: #{a}")
  end

  def myIf(condition, args) do
    IO.puts(condition)
    IO.inspect(args)

    if condition do
      cond do
        is_function(args[:do]) -> args[:do].()
        true -> IO.puts(args[:do])
      end
    else
      IO.puts(args[:else])
    end
  end
end
