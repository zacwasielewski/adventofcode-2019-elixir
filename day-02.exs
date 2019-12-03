defmodule Day2 do
  @input_file "day-02-input.txt"

  defp parse_intcode_string(string) do
    string
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp get_input do
    {:ok, input} = File.read(@input_file)
    parse_intcode_string(input)
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
    [ input1_pos, input2_pos ] = get_input_positions(intcode, opcode_pos)
    [
      Enum.at(intcode, input1_pos),
      Enum.at(intcode, input2_pos)
    ]
  end

  defp get_output_position(intcode, opcode_pos) do
    Enum.at(intcode, opcode_pos + 3)
  end

  defp parse_program_state(state) do
    [_noun, _verb] = [div(state, 100), rem(state, 100)]
  end

  defp set_program_state(intcode, state) do
    [noun, verb] = parse_program_state(state)
    intcode
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  defp apply_operation(operation, intcode, opcode_pos) do
    [input1, input2] = get_input_values(intcode, opcode_pos)
    output_position = get_output_position(intcode, opcode_pos)
    output_value = case operation do
      :add -> input1 + input2
      :multiply -> input1 * input2
    end
    List.replace_at(intcode, output_position, output_value)
  end

  def process_instructions(intcode) do
    opcode_positions = Stream.take_every(0..length(intcode), 4)

    Enum.reduce_while(opcode_positions, intcode, fn opcode_pos, acc ->
      opcode = get_opcode(acc, opcode_pos)
      case opcode do
        1  -> {:cont, apply_operation(:add, acc, opcode_pos) }
        2  -> {:cont, apply_operation(:multiply, acc, opcode_pos) }
        99 -> {:halt, acc}
      end
    end)
  end

  defp get_program_output(intcode) do
    List.first(intcode)
  end

  def run_program_with_state(intcode, state) do
    intcode
    |> set_program_state(state)
    |> process_instructions()
    |> get_program_output()
  end

  def part1 do
    intcode = get_input()
    run_program_with_state(intcode, 1202)
  end

  def part2 do
    intcode = get_input()
    goal = 19690720

    # This is the range of all possible input states to check,
    # assuming that nouns and verbs are only two digits each:
    100..9999
    |> Enum.filter(fn state ->
        run_program_with_state(intcode, state) === goal
      end)
    |> List.first
  end
end

IO.puts "Part 1: #{Day2.part1}"
IO.puts "Part 2: #{Day2.part2}"
