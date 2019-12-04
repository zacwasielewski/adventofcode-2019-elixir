defmodule PasswordChecker do
  def is_correct_length(number) do
    length = 6
    length === (number |> Integer.digits |> Enum.count)
  end

  def has_consecutive_siblings(password) do
    Integer.digits(password)
    |> Enum.chunk_by(fn n -> n end)
    |> Enum.any?(fn chunk -> Enum.count(chunk) > 1 end)
  end

  def has_consecutive_twins(password) do
    Integer.digits(password)
    |> Enum.chunk_by(fn n -> n end)
    |> Enum.any?(fn chunk -> Enum.count(chunk) === 2 end)
  end

  def does_not_decrease(password) do
    Integer.digits(password)
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn chunk -> Enum.count(chunk) === 2 end)
    |> Enum.all?(fn pair ->
      [ first, last ] = pair
      first <= last
    end)
  end
end

defmodule Day4Solver do
  import PasswordChecker

  @input_file "day-04-input.txt"

  def get_input do
    {:ok, input} = File.read(@input_file)
    input
  end

  def parse_input_to_range(input) do
    [ max, min ] = String.split(input, "-", trim: true)
    Range.new(
      String.to_integer(max),
      String.to_integer(min)
    )
  end

  def part1 do
    get_input()
    |> parse_input_to_range
    |> Enum.filter(&is_correct_length/1)
    |> Enum.filter(&has_consecutive_siblings/1)
    |> Enum.filter(&does_not_decrease/1)
    |> Enum.to_list
    |> Enum.count
  end

  def part2 do
    get_input()
    |> parse_input_to_range
    |> Enum.filter(&is_correct_length/1)
    |> Enum.filter(&has_consecutive_twins/1)
    |> Enum.filter(&does_not_decrease/1)
    |> Enum.to_list
    |> Enum.count
  end
end

IO.puts "Part 1: #{Day4Solver.part1}"
IO.puts "Part 2: #{Day4Solver.part2}"
