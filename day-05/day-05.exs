defmodule Day5 do
  defp get_opcode(intcode, position) do
    Enum.at(intcode, position)
    |> normalize_opcode
  end

  @doc """
  Convert all opcodes to the parameterized format
  """
  defp normalize_opcode(opcode) do
    opcode_string = opcode
    |> Integer.to_string
    |> String.pad_leading(5, "0")

    # Converting all the values of a map to integers is a little awkward:
    # https://joyofelixir.com/10-maps/

    pattern = ~r/(?<param3_mode>\d)(?<param2_mode>\d)(?<param1_mode>\d)(?<opcode>\d{2})/
    r = Regex.named_captures(pattern, opcode_string)
    |> Enum.map(fn {key, val} -> {String.to_atom(key), String.to_integer(val)} end)
    |> Enum.into(%{})

    %{
      opcode: r[:opcode],
      param_modes: [
        r[:param1_mode],
        r[:param2_mode],
        r[:param3_mode]
      ]
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

  defp get_parameter(intcode, position, mode \\ 1) do
    case mode do
      0 -> Enum.at(intcode, Enum.at(intcode, position)) # Position mode
      1 -> Enum.at(intcode, position) # Immediate mode
    end
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(1, intcode, position) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1_val = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    param2_val = get_parameter(intcode, position + 2, Enum.at(param_modes, 1))
    output_pos = get_parameter(intcode, position + 3)

    output_val = param1_val + param2_val
    List.replace_at(intcode, output_pos, output_val)
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(2, intcode, position) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1_val = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    param2_val = get_parameter(intcode, position + 2, Enum.at(param_modes, 1))
    output_pos = get_parameter(intcode, position + 3)

    output_val = param1_val * param2_val
    List.replace_at(intcode, output_pos, output_val)
  end

  def do_instruction(3, intcode, position, input_value) do
    output_pos = get_parameter(intcode, position + 1)
    List.replace_at(intcode, output_pos, input_value)
  end

  def do_instruction(4, intcode, position) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    output_val = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    IO.puts "OUTPUT: #{output_val}"
    intcode
  end

  @doc """
  Process the opcode at the specified position, then return the
  updated intcode and position of the next opcode.
  """
  defp process_intcode_position(intcode, position, input) do
    %{ opcode: opcode } = get_opcode(intcode, position)

    new_intcode = case opcode do
      1  -> do_instruction(1, intcode, position)
      2  -> do_instruction(2, intcode, position)
      3  -> do_instruction(3, intcode, position, input)
      4  -> do_instruction(4, intcode, position)
      99 -> intcode
    end

    new_position = case opcode do
      1  -> position + 4
      2  -> position + 4
      3  -> position + 2
      4  -> position + 2
      99 -> nil
    end

    %{intcode: new_intcode, position: new_position, input: nil}
  end

  def run_program(intcode, input \\ nil) do
    initial = %{
      intcode: intcode,
      position: 0,
      input: input
    }

    result = Enum.reduce_while(0..Enum.count(intcode), initial, fn i, acc ->
      %{ intcode: intcode, position: position, input: input } = acc

      # Only process the intcode if we're positioned at an opcode.
      # Otherwise, return the accumulator intact and continue iterating.
      new_acc = cond do
        i === position -> process_intcode_position(intcode, position, input)
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

  def run_program_with_input(intcode, input) do
   intcode
   |> run_program(input)
   |> get_program_output()
  end
end

defmodule Day5Solver do
  import Day5

  @input_file "day-05-input.txt"
  #@input_file "day-02-input.txt"

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
    run_program_with_input(intcode, 1)
  end

  #def part2 do
  #  intcode = get_input()
  #  goal = 19_690_720
  #
  #  # All possible input states, assuming nouns and verbs are limited to two digits
  #  100..9999
  #  |> Enum.filter(fn state ->
  #    run_program_with_state(intcode, state) === goal
  #  end)
  #  |> List.first()
  #end
end

IO.puts "Part 1: "
IO.inspect {Day5Solver.part1()}
# IO.puts "Part 2: #{Day5.part2}"
