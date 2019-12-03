defmodule Day2 do
  @input_file "day-02-input.txt"

  defp parse_intcode_string(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp get_input do
    {:ok, input} = File.read(@input_file)
    input
  end

  defp reset_program(intcode, noun, verb) do
    intcode
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  defp get_opcode(intcode, opcode_pos) do
    Enum.at(intcode, opcode_pos)
  end

  defp get_input_positions(intcode, opcode_pos) do
    [
      Enum.at(intcode, opcode_pos + 1),
      Enum.at(intcode, opcode_pos + 2)
    ]
  end

  defp get_input_values(intcode, opcode_pos) do
    input_positions = get_input_positions(intcode, opcode_pos)
    [
      Enum.at(intcode, List.first(input_positions)),
      Enum.at(intcode, List.last(input_positions))
    ]
  end

  defp get_output_position(intcode, opcode_pos) do
    Enum.at(intcode, opcode_pos + 3)
  end

  defp process_opcode(1, intcode, pos) do
    [input1, input2] = get_input_values(intcode, pos)
    output_position = get_output_position(intcode, pos)
    List.replace_at(intcode, output_position, input1 + input2)
  end

  defp process_opcode(2, intcode, pos) do
    [input1, input2] = get_input_values(intcode, pos)
    output_position = get_output_position(intcode, pos)
    List.replace_at(intcode, output_position, input1 * input2)
  end

  def run_intcode(intcode) do
    # Opcodes are positioned at every 4th item of the intcode (beginning at 1)
    opcode_positions = Stream.take_every(0..length(intcode), 4)

    Enum.reduce_while(opcode_positions, intcode, fn pos, acc ->
      opcode = get_opcode(acc, pos)
      case opcode do
        1  -> {:cont, process_opcode(1, acc, pos) }
        2  -> {:cont, process_opcode(2, acc, pos) }
        99 -> {:halt, acc}
      end
    end)
  end

  @doc """
  """
  def part1 do
    intcode = get_input()
    |> parse_intcode_string()
    |> reset_program(12, 2) # Reset program to 1202 alarm state
    run_intcode(intcode)
  end

  def part2 do
    intcode = parse_intcode_string(get_input())

    # Generate a list of noun/verb pairs to test
    test_inputs = Enum.flat_map(1..100, fn noun ->
      Enum.map(1..100, fn verb ->
        [noun, verb]
      end)
    end)

    test_inputs
    |> Enum.map(fn inputs ->
      [noun, verb] = inputs
      %{
        noun: noun,
        verb: verb,
        output: intcode
          |> reset_program(noun, verb)
          |> run_intcode()
          |> List.first,
        solution: noun * 100 + verb
      }
    end)
    |> Enum.filter(fn x -> x[:output] === 19690720 end)
  end
end

IO.puts "Part 1: #{List.first(Day2.part1)}"
IO.puts "Part 2:"
IO.inspect Day2.part2
