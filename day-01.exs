defmodule FuelCounterUpper do
  def fuel_required(mass) do
    trunc(mass / 3) - 2
  end

  def total_fuel_required(module_mass) do
    Stream.iterate(module_mass, &fuel_required/1)
      |> Enum.take_while(fn x -> x > 0 end)
      |> Enum.drop(1) # Exclude the mass of the module
      |> Enum.sum
  end
end

{:ok, input} = File.read("day-01-input.txt")
module_masses = input
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)

part1 = module_masses
  |> Enum.map(&FuelCounterUpper.fuel_required/1)
  |> Enum.sum

part2 = module_masses
  |> Enum.map(&FuelCounterUpper.total_fuel_required/1)
  |> Enum.sum

IO.puts "Part 1: #{part1}"
IO.puts "Part 2: #{part2}"
