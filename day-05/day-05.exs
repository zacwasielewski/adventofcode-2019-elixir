defmodule Day5 do
  defp get_opcode(intcode, position) do
    Enum.at(intcode, position)
  end
  
  defp parse_opcode(opcode) do
    
  end

  defp get_input_positions(intcode, opcode_pos) do
    [
      Enum.at(intcode, opcode_pos + 1),
      Enum.at(intcode, opcode_pos + 2)
    ]
  end

  defp get_input_values(intcode, opcode_pos) do
    [input1_pos, input2_pos] = get_input_positions(intcode, opcode_pos)
    [
      Enum.at(intcode, input1_pos),
      Enum.at(intcode, input2_pos)
    ]
  end

  defp get_output_position(intcode, opcode_pos) do
    Enum.at(intcode, opcode_pos + 3)
  end
  
  defp get_instruction(intcode, opcode_pos) do
    %{
      opcode: get_opcode(intcode, opcode_pos),
      inputs: get_input_values(intcode, opcode_pos),
      output_pos: get_output_position(intcode, opcode_pos)
    }
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
  
  # defp parse_parameter_mode(mode) do
  # end
  
  defp apply_operation(operation, intcode, opcode_pos) do
   %{
     inputs: [input1, input2],
     output_pos: output_pos
   } = get_instruction(intcode, opcode_pos)
     output_value =
     case operation do
       :add -> input1 + input2
       :multiply -> input1 * input2
     end
     List.replace_at(intcode, output_pos, output_value)
  end
  
  # def process_instructions(intcode) do
  #  # This won't work anymore!
  #  # opcode_positions = Stream.take_every(0..length(intcode), 4)
  #
  #  Enum.reduce_while(opcode_positions, intcode, fn opcode_pos, acc ->
  #    opcode = get_opcode(acc, opcode_pos)
  #
  #    case opcode do
  #      1 -> {:cont, apply_operation(:add, acc, opcode_pos)}
  #      2 -> {:cont, apply_operation(:multiply, acc, opcode_pos)}
  #      3 -> {:cont, save_input(acc, opcode_pos)}
  #      4 -> {:cont, output_value(acc, opcode_pos)}
  #      99 -> {:halt, acc}
  #    end
  #  end)
  # end

  defp do_instruction(1, intcode, position) do
    %{
      inputs: [input1, input2],
      output_pos: output_pos
    } = get_instruction(intcode, position)

    output_value = input1 + input2
    List.replace_at(intcode, output_pos, output_value)
  end

  defp do_instruction(2, intcode, position) do
    %{
      inputs: [input1, input2],
      output_pos: output_pos
    } = get_instruction(intcode, position)

    output_value = input1 * input2
    List.replace_at(intcode, output_pos, output_value)
  end

  defp normalize_opcode(opcode) do
    opcode_string = opcode
    |> Integer.to_string
    |> String.pad_leading(5, "0")

    # Converting all the values of a map to integers is a little awkward:
    # https://joyofelixir.com/10-maps/

    pattern = ~r/(?<param3_mode>\d)(?<param2_mode>\d)(?<param1_mode>\d)(?<opcode>\d{2})/
    Regex.named_captures(pattern, opcode_string)
    |> Enum.map(fn {key, val} -> {String.to_atom(key), String.to_integer(val)} end)
    |> Enum.into(%{})
  end

  @doc """
  Process the opcode at the specified position, then return the
  updated intcode and position of the next opcode.
  """
  defp process_intcode_position(intcode, position) do    
    %{
      opcode: opcode,
      param1_mode: param1_mode,
      param2_mode: param2_mode,
      param3_mode: param3_mode
    } = get_opcode(intcode, position) |> normalize_opcode

    new_intcode = case opcode do
      1  -> do_instruction(1, intcode, position)
      2  -> do_instruction(2, intcode, position)
      99 -> intcode
    end

    new_position = case opcode do
      1  -> position + 4
      2  -> position + 4
      99 -> nil
    end

    %{intcode: new_intcode, position: new_position}
  end

  def run_program(intcode) do
    initial = %{
      intcode: intcode,
      position: 0
    }

    result = Enum.reduce_while(0..Enum.count(intcode), initial, fn i, acc ->
      %{ intcode: intcode, position: position } = acc

      # Only process the intcode if we're positioned at an opcode.
      # Otherwise, return the accumulator intact and continue iterating.
      new_acc = cond do
        i === position -> process_intcode_position(intcode, position)
        i !== position -> acc
      end

      if is_nil(new_acc[:position]) do
        {:halt, new_acc}
      else
        {:cont, new_acc}
      end
    end)
    
    result[:intcode]
  end

  defp get_program_output(intcode) do
    List.first(intcode)
  end

  def run_program_with_state(intcode, state) do
   intcode
   |> set_program_state(state)
   |> run_program()
   |> get_program_output()
  end
end

defmodule Day5Solver do
  import Day5

  #@input_file "day-05-input.txt"
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

  def part1 do
    intcode = get_input()
    run_program(intcode)
  end

   def part2 do
    intcode = get_input()
    goal = 19_690_720
  
    # All possible input states, assuming nouns and verbs are limited to two digits
    100..9999
    |> Enum.filter(fn state ->
      run_program_with_state(intcode, state) === goal
    end)
    |> List.first()
   end
end

#IO.puts "Part 1: "
#IO.inspect {Day5Solver.part1()}
# IO.puts "Part 2: #{Day5.part2}"
