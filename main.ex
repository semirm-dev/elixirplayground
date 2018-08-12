defmodule Main do
    def run() do
        do_stuff()
        lists()
        maps()
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
end