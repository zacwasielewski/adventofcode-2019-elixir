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

  defp reset_to_1202_program_alarm_state(intcode) do
    intcode
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
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

    Enum.reduce_while(opcode_positions, intcode, fn pos, intcode_acc ->
      opcode = get_opcode(intcode_acc, pos)
      case opcode do
        1  -> {:cont, process_opcode(1, intcode_acc, pos) }
        2  -> {:cont, process_opcode(2, intcode_acc, pos) }
        99 -> {:halt, intcode_acc}
      end
    end)
  end

  @doc """
  """
  def part1 do
    intcode = parse_intcode_string(get_input())
    run_intcode(reset_to_1202_program_alarm_state(intcode))
  end
end

IO.puts "Part 1: #{Enum.join(Day2.part1, ",")}"
