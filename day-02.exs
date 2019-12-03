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

  defp set_program_state(intcode, noun, verb) do
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

  defp process_intcode(:add, intcode, pos) do
    [input1, input2] = get_input_values(intcode, pos)
    output_position = get_output_position(intcode, pos)
    output_value = input1 + input2
    List.replace_at(intcode, output_position, output_value)
  end

  defp process_intcode(:multiply, intcode, pos) do
    [input1, input2] = get_input_values(intcode, pos)
    output_position = get_output_position(intcode, pos)
    output_value = input1 * input2
    List.replace_at(intcode, output_position, output_value)
  end

  def run_intcode(intcode) do
    # Opcodes are positioned at every 4th item of the intcode (beginning at 1)
    opcode_positions = Stream.take_every(0..length(intcode), 4)

    Enum.reduce_while(opcode_positions, intcode, fn pos, acc ->
      opcode = get_opcode(acc, pos)
      case opcode do
        1  -> {:cont, process_intcode(:add, acc, pos) }
        2  -> {:cont, process_intcode(:multiply, acc, pos) }
        99 -> {:halt, acc}
      end
    end)
  end

  @doc """
  """
  def part1 do
    intcode = get_input()
    |> parse_intcode_string()
    |> set_program_state(12, 2) # Reset program to 1202 alarm state
    run_intcode(intcode)
  end

  def part2 do
    intcode = parse_intcode_string(get_input())

    # Generate a list of noun/verb pairs to test
    test_inputs = 100..9999 |> Enum.map(fn x ->
      [div(x, 100), rem(x, 100)]
    end)

    test_inputs
    |> Enum.map(fn inputs ->
      [noun, verb] = inputs
      %{
        output: intcode
          |> set_program_state(noun, verb)
          |> run_intcode()
          |> List.first,
        solution: noun * 100 + verb
      }
    end)
    |> Enum.filter(fn x -> x[:output] === 19690720 end)
    |> Enum.map(fn x -> x[:solution] end)
  end
end

IO.puts "Part 1: #{List.first(Day2.part1)}"
IO.puts "Part 2: #{List.first(Day2.part2)}"
