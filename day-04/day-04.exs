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

  defp is_length(number, length) do
    length === (number |> Integer.digits |> Enum.count)
  end

  defp has_consecutive_duplicates(number) do
    digits = Integer.digits(number)
    Enum.dedup(digits) !== digits
  end

  defp does_not_decrease(number) do
    digits = Integer.digits(number)
    digit_pairs = Enum.chunk_every(digits, 2, 1)
    |> Enum.filter(fn chunk -> Enum.count(chunk) === 2 end)

    Enum.all?(digit_pairs, fn pair ->
      [ first, last ] = pair
      first <= last
    end)
  end

  def is_valid_password(password) do
    is_length(password, 6)
    && has_consecutive_duplicates(password)
    && does_not_decrease(password)
  end

  def part1 do
    range = get_input()

    range
    |> Enum.filter(fn x -> is_length(x, 6) end)
    |> Enum.filter(&has_consecutive_duplicates/1)
    |> Enum.filter(&does_not_decrease/1)
    |> Enum.to_list
    |> Enum.count
  end
end

IO.puts "Part 1: #{Day4.part1}"