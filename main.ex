defmodule Main do
    def run() do
        do_stuff()
    end

    def do_stuff() do
        age = :rand.uniform(100) # erlang module

        if age > 18 do
            IO.puts "You are old enough: #{age}"
        else
            IO.puts "You are too young: #{age}"
        end 

        cond do
            age >= 18 -> IO.puts "Go rock on: #{age}"
            age >= 14 -> IO.puts "You can wait: #{age}"
            true -> "Meh"
        end
    end
end