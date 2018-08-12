defmodule Main do
    def run() do
        do_stuff()
        lists()
        maps()
        anon_funcs()
        print_num(15)
        print_num(-5)
    end

    def do_stuff() do
        age = :rand.uniform(100) # erlang module

        if age > 18 do
            IO.puts "You are old enough: #{age}"
        else
            IO.puts "You are too young: #{age}"
        end 

        cond do # will break on first match
            age >= 18 -> IO.puts "Go rock on: #{age}"
            age >= 14 -> IO.puts "You can wait: #{age}"
            true -> "Meh"
        end

        case age do
            90 -> IO.puts "Dead, you are dead man: #{age}"
            70 -> IO.puts "You are barely alive: #{age}"
            _ -> IO.puts ":O? #{age}"
        end

        IO.puts "Ternary: #{if age > 50, do: "old enough", else: "less than 50"}"

        [length, width] = [20, 60]
        IO.puts "Width: #{width}"

        {length, width} = {20, 60}
        IO.puts "Length: #{length}"

        [_, [_, width]] = [20, [20, 80]]
        IO.puts "Width: #{width}"

        IO.puts "Def value: #{def_value(5)}"
        IO.puts "Def value: #{def_value()}"
    end

    def lists() do
        list1 = [1, 2, 3]
        list2 = [4, 5, 6]

        list3 = list1 ++ list2

        cond do
            4 in list1 -> IO.puts "4 in list1"
            4 in list2 -> IO.puts "4 in list2"
            4 in list3 -> IO.puts "4 in list3"
            true -> "Nowhere"
        end   

        [head | tail] = list3
        IO.puts "Head: #{head}"
        IO.write "Tail: " 
        IO.inspect tail, char_list: :as_list

        Enum.each list3, fn item ->
            IO.puts item
        end

        list3 = List.delete(list3, 2)

        IO.puts "Recursion:"
        display_items(list3)
    end

    
    # recursion
    def display_items([item|items]) do
        IO.puts item
        display_items(items)
    end

    def display_items([]), do: nil

    def maps() do
        # using strings as keys
        map1 = %{"Europe" => "Sweden", "USA" => "Canada"}
        # using atoms as keys
        map2 = %{europe: "Sweden", usa: "Canada"}

        IO.puts "Europe: #{map1["Europe"]}, Usa: #{map2.usa}"
    end

    def anon_funcs() do
        get_sum = fn (x, y) -> x + y end
        IO.puts "Sum: #{get_sum.(2, 6)}"

        variable_input = fn
            {x, y} -> IO.puts "Two inputs: #{x}, #{y}"
            {x, y, z} -> IO.puts "Three inputs: #{x}, #{y}, #{z}"
        end

        variable_input.({1, 2})
        variable_input.({1, 2, 3})
    end

    def def_value(x \\ 0) do
        x
    end

    # guards like in erlang
    def print_num(n) when n >= 1 do
        IO.puts "Hooray: #{n}"
    end

    def print_num(n) when n < 1 do
        IO.puts "WTF man: #{n}"
        print_num(n+1)
    end
end