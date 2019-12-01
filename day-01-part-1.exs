defmodule FuelCounterUpper do
  def fuel_required(mass) do
    trunc(mass / 3) - 2
  end
end

{:ok, input} = File.read("day-01-input.txt")

total_fuel_required = input
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.map(&FuelCounterUpper.fuel_required/1)
  |> Enum.sum

IO.puts total_fuel_required