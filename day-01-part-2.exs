defmodule FuelCounterUpper do
  def fuel_required(mass) do
    trunc(mass / 3) - 2
  end

  def module_fuel_required(module_mass) do
    Stream.iterate(module_mass, &fuel_required/1)
      |> Enum.take_while(fn x -> x > 0 end)
      |> Enum.drop(1) # Exclude the mass of the module
      |> Enum.sum
  end
end

{:ok, input} = File.read("day-01-input.txt")

total_fuel_required = input
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.map(&FuelCounterUpper.module_fuel_required/1)
  |> Enum.sum

IO.puts total_fuel_required
