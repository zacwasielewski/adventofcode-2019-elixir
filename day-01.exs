defmodule Day1 do
  @input_file "day-01-input.txt"

  defp normalize_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp get_input do
    {:ok, input} = File.read(@input_file)
    normalize_input(input)
  end

  defp fuel_required(mass) do
    trunc(mass / 3) - 2
  end

  defp total_fuel_required(module_mass) do
    Stream.iterate(module_mass, &fuel_required/1)
    |> Enum.take_while(fn x -> x > 0 end)
    |> Enum.drop(1) # Exclude the mass of the module
    |> Enum.sum
  end

  @doc """
  Fuel required to launch a given module is based on its mass.
  Specifically, to find the fuel required for a module, take its
  mass, divide by three, round down, and subtract 2.
  """
  def part1 do
    get_input()
    |> Enum.map(&fuel_required/1)
    |> Enum.sum
  end

  @doc """
  Fuel itself requires fuel just like a module. However, that fuel
  also requires fuel, and that fuel requires fuel, and so on.
  So, for each module mass, calculate its fuel and add it to the 
  total. Then, treat the fuel amount you just calculated as the
  input mass and repeat the process, continuing until a fuel
  requirement is zero or negative.
  """
  def part2 do
    get_input()
    |> Enum.map(&total_fuel_required/1)
    |> Enum.sum
  end
end

IO.puts "Part 1: #{Day1.part1}"
IO.puts "Part 2: #{Day1.part2}"
