defmodule Elixirplayground do
  use Application
  # import Juicy

  # aliases
  # alias My.Other.Module.Parser, as: Parser
  #
  # the as: parameters default to the last part of the module name
  # alias My.Other.Module.{Parser, Runner}

  # require a module if you want to use any macros it defines.
  # This ensures that the macro definitions are available when your code is compiled.

  # defmodule Example do
  #   @attr "one"
  #   def first, do: @attr
  #   @attr "two"
  #   def second, do: @attr
  # end
  #
  # IO.puts "#{Example.second} #{Example.first}" # => two one
  #
  # These attributes are not variables in the conventional sense. Use them for
  # configuration and metadata only. (Many Elixir programmers employ them where
  # Java or Ruby programmers might use constants.)

  # Tail recursion is a special case of recursion where the calling function does no more computation after making a recursive call. For example, the function

  # int f(int x, int y) {
  #   if (y == 0) {
  #     return x;
  #   }

  #   return f(x*y, y-1);
  # }
  # is tail recursive (since the final instruction is a recursive call) whereas this function is not tail recursive:

  # int g(int x) {
  #   if (x == 1) {
  #     return 1;
  #   }

  #   int y = g(x-1);

  #   return x*y;
  # }
  # since it does some computation after the recursive call has returned.
  #
  # Quote from Programming Elixir 1.6
  # The greet function might have worried you a little. Every time it receives a
  # message, it ends up calling itself. In many languages, that adds a new frame to
  # the stack. After a large number of messages, you might run out of memory.
  # This doesn’t happen in Elixir, as it implements tail-call optimization. If the last
  # thing a function does is call itself, there’s no need to make the call. Instead, the
  # runtime simply jumps back to the start of the function. If the recursive call has
  # arguments, then these replace the original parameters. But beware—the recursive
  # call must be the very last thing executed.
  #
  # def factorial(0), do: 1
  # def factorial(n), do: n * factorial(n-1)
  #
  # While the recursive call is physically the last thing in the function, it is not the
  # last thing executed. The function has to multiply the value it returns by n.

  # common use case for "case"
  #
  # case Repo.insert(changeset) do
  #   {:ok, user} ->
  #     case Guardian.encode_and_sign(user, :token, claims) do
  #       {:ok, token, full_claims} ->
  #         important_stuff(token, full_claims)

  #       error ->
  #         error
  #     end

  #   error ->
  #     error
  # end
  #
  # or simply use "with"
  #
  # with {:ok, user} <- Repo.insert(changeset),
  #    {:ok, token, full_claims} <- Guardian.encode_and_sign(user, :token, claims) do
  #   important_stuff(token, full_claims)
  # else
  #   :error ->
  #     IO.puts("we got error here")
  #     :error
  #   _ -> IO.puts("hmm, weirdo")
  # end

  @config %{host: "127.0.0.1", port: 3456}
  use Plug.Builder

  def start(_type, _args) do
    # run()

    # juice()

    msg = "hello"

    print_msg(msg)

    IO.puts("msg should not be changed: " <> msg)

    IO.inspect(Enum.all?(["foo", "bar", "hello"], fn(s) -> String.length(s) == 3 end))
    IO.inspect(Enum.chunk_by(["one", "two", "three", "four", "five"], fn(x) -> String.length(x) end))



    Task.start(fn -> nil end)
  end

  def print_msg(msg) do
    IO.puts("passed: " <> msg)
    msg = "changed :("
    IO.puts("changed inside function only: " <> msg)
  end

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
    IO.inspect(@config)
    IO.puts("")

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

    args = %{ :cmd => :run, :error => :unknown }

    IO.puts args.cmd
    IO.puts args[:cmd]

    opts = %{ :use_tls => true, :protocol => "tcp", :args => args, "meta" => :nan }

    IO.inspect opts
    IO.puts opts.use_tls
    IO.inspect opts.args
    IO.inspect opts[:args]
    IO.puts opts["meta"]

    kw_list = [{:name, "semir :D"}, {:surname, "mah"}, {:age, 30}]
    IO.inspect kw_list
    IO.inspect kw_list[:name]

    kw_list2 = [name: "semir", age: 30]
    IO.inspect kw_list2
    IO.inspect kw_list2[:name]

    line_no = 50

    # if (line_no == 50) do
    #   IO.puts "its 50"
    #   line_no = 0
    # end

    line_no = case line_no do
      50 -> 0
    end

    IO.puts(line_no)

    add_n = fn m -> fn n -> m + n end end
    add_two = add_n.(2)
    IO.inspect add_two.(3) # 2 parameter is remembered from definition and will be used in its body, makes sense because 2 is defined in the fn definition

    a = 1
    IO.puts("a is: #{a}")
    a = 2
    IO.puts("a is: #{a}")
    # must match latest/current match of "a", which in this case is 2 (not 1)
    ^a = 2 # since a is reassigned to 2, we can not use ^a = 1 because there is no such match
    IO.puts("a is: #{a}")

    # people = DB.find_customers
    # orders = Orders.for_customers(people)
    # tax = sales_tax(orders, 2018)
    # filing = prepare_filing(tax)
    # becomes...
    # filing = DB.find_customers
    #   |> Orders.for_customers
    #   |> sales_tax(2018)
    #   |> prepare_filing
    # The |> operator takes the result of the expression to its left
    # and inserts it as the first parameter of the function invocation to its right.

    # If all the values in a list represent printable characters, it displays the list as a string; otherwise it displays a list of integers.
    l = [99, 97, 116] # prints 'cat'
    IO.inspect l

    l2 = [99, 97, 116, 0] # prints [99, 97, 116], becuase 0 is not printable
    IO.inspect l2
  end

  def do_stuff() do
    # erlang module
    age = :rand.uniform(100)

    IO.puts(:im_atom)

    # if...else
    if age > 18 do
      IO.puts("You are old enough: #{age}")
    else
      IO.puts("You are too young: #{age}")
    end

    # if...elseif...else
    cond do # break on first match
      age >= 80 -> IO.puts("Go rock on: #{age}")
      age >= 50 -> IO.puts("You can wait: #{age}")
      true -> true
    end

    # switch...case
    case age do # break on first match
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

    semir = %User{}
    IO.inspect(semir)
    semir = %{semir | first_name: "semir"}
    IO.inspect(semir)

    IO.write("Size: ")
    IO.puts(Size.size({:ok, "hello"}))

    squared = for n <- [1, 2, 3, 4], do: n * n
    IO.write("squared: ")
    IO.inspect(squared)

    IO.write("squared mapped: ")
    IO.inspect(for {:good, n} <- [bad: 1, good: 2, good: 3, good: 4], do: n * n)
  end

  def lists() do
    # import only these two functions from List module, scope ends at the of the lists() func body
    # import List, only: [ flatten: 1, duplicate: 2 ]

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

    kw_list = [{:name, "semir", :surname, "mah"}, {:age, 30}]
    IO.inspect(kw_list)

    kw_list2 = [name: "semir", age: 30]
    IO.inspect(kw_list2)

    IO.puts(kw_list2[:name])
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

    args = %{ :cmd => :run, :error => :unknown }

    IO.puts args.cmd
    IO.puts args[:cmd]

    opts = %{ :use_tls => true, :protocol => "tcp", :args => args, "meta" => :nan }

    IO.inspect opts
    IO.puts opts.use_tls
    IO.inspect opts.args
    IO.inspect opts[:args]
    IO.puts opts["meta"]

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

    # since ordering of &() matches IO.puts, Elixir optimized away the anonymous function, replacing it with a direct reference to the function, IO.puts/1.
    # anonymous wrapper around IO.puts/1
    speak = &(IO.puts(&1))
    speak.("HI :D")

    l = &length/1 # anonymous wrapper around lenght/1
    IO.puts l.([1, 2, 3, 5])

    divrem = &{ div(&1,&2), rem(&1,&2) }
    divrem.(13, 5)

    s = &"bacon and #{&1}"
    s.("eggs")

    # The & shortcut gives us a wonderful way to pass functions to other functions.
    m = Enum.map [1,2,3,4], &(&1 + 1)
    IO.puts m


    odd? = &(rem(&1, 2) != 0) # converts into: fn x -> rem(x, 2) != 2 end
    total_sum = 1..1000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum() # each Enum.* is passed as first argument to the Enum.*
    IO.inspect(total_sum)

    total_sum = 1..10000 |> Stream.map(&(&1 * 3)) |> Stream.filter(odd?) |> Enum.sum()
    IO.inspect(total_sum)
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
    a = 2 # after this point we can not use ^a = 1, because a is reassigned to 2 and there will be no matching to 1
    IO.puts("a is: #{a}")
    # must match latest/current match of "a", which in this case is 2 (not 1), pin means "compare", do not reassign
    ^a = 2 # if we use ^a = 1, it will throw error because there is no such match
    IO.puts("a is: #{a}")

    # use latest/current assigned "a", therefore there must be previous match of "a"
    [1, ^a, 3] = [1, 2, 3]
    IO.puts("a is: #{a}")
    # use latest/current assigned "a", therefore there must be previous match of "a"
    [1, a, 3] = [1, 2, 3]
    IO.puts("a is: #{a}")


    pie = 3.14
    case "cherry pie" do
      ^pie -> IO.inspect("Not so tasty") # pin operator must be used in order to match against existing variable
      pie -> IO.inspect("I bet #{pie} is tasty") # this is not original pie variable, but newly created matching, so it always evaluates to true
    end
    ^pie = 3.14
    IO.inspect(pie)

    greeting = "Hello"
    greet = fn
      (^greeting, name) -> IO.inspect("Hi #{name}")
      (greeting, name) -> IO.inspect("#{greeting}, #{name}")
    end
    greet.("Hello", "Sean") # will match first clause
    greet.("Mornin'", "Sean") # will match anything else because no previous matching was found for "greeting"
  end

  def my_map([], _func), do: []
  def my_map([ head | tail ], func), do: [ func.(head) | my_map(tail, func) ]
  # usage: my_map [1,2,3,4], fn (n) -> n*n end
  # my_map [1,2,3,4], &(&1 * &1)

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
