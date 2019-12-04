defmodule Day4 do
  @input_file "day-04-input.txt"

  defp get_input do
    {:ok, input} = File.read(@input_file)
    parse_input_to_range(input)
  end

  defp parse_input_to_range(input) do
    [ max, min ] = String.split(input, "-", trim: true)
    Range.new(
      String.to_integer(max),
      String.to_integer(min)
    )
  end

  defp is_correct_length(number) do
    length = 6
    length === (number |> Integer.digits |> Enum.count)
  end

  defp has_consecutive_siblings(password) do
    Integer.digits(password)
    |> Enum.chunk_by(fn n -> n end)
    |> Enum.any?(fn chunk -> Enum.count(chunk) > 1 end)
  end

  defp has_consecutive_twins(password) do
    Integer.digits(password)
    |> Enum.chunk_by(fn n -> n end)
    |> Enum.any?(fn chunk -> Enum.count(chunk) === 2 end)
  end

  defp does_not_decrease(password) do
    Integer.digits(password)
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn chunk -> Enum.count(chunk) === 2 end)
    |> Enum.all?(fn pair ->
      [ first, last ] = pair
      first <= last
    end)
  end

  def part1 do
    range = get_input()

    range
    |> Enum.filter(&is_correct_length/1)
    |> Enum.filter(&has_consecutive_siblings/1)
    |> Enum.filter(&does_not_decrease/1)
    |> Enum.to_list
    |> Enum.count
  end

  def part2 do
    range = get_input()

    range
    |> Enum.filter(&is_correct_length/1)
    |> Enum.filter(&has_consecutive_twins/1)
    |> Enum.filter(&does_not_decrease/1)
    |> Enum.to_list
    |> Enum.count
  end
end

IO.puts "Part 1: #{Day4.part1}"
IO.puts "Part 2: #{Day4.part2}"