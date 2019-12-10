defmodule Day9 do
  defp get_opcode(intcode, position) do
    Enum.at(intcode, position)
    |> normalize_opcode
  end

  @doc """
  Convert all opcodes to the parameterized format
  """
  def normalize_opcode(opcode) do
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
  
  #defp parse_program_state(state) do
  #  [_noun, _verb] = [div(state, 100), rem(state, 100)]
  #end
  #
  #defp set_program_state(intcode, state) do
  #  [noun, verb] = parse_program_state(state)
  #  intcode
  #  |> List.replace_at(1, noun)
  #  |> List.replace_at(2, verb)
  #end

  defp get_parameter(intcode, position, mode, relative_base \\ 0) do
    case mode do
      0 -> Enum.at(intcode, Enum.at(intcode, position)) # Position mode
      1 -> Enum.at(intcode, position) # Immediate mode
      2 -> Enum.at(intcode, Enum.at(intcode, position + relative_base)) # Relative mode
    end
  end

  defp get_output_parameter(intcode, position) do
    get_parameter(intcode, position, 1)
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(1, intcode, position, _input, output, relative_base) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    #IO.inspect intcode
    #IO.inspect position

    #IO.puts "==="
    #IO.inspect intcode
    #IO.inspect get_opcode(intcode, position)
    #IO.puts "position: #{position}"
    #IO.puts "relative_base: #{relative_base}"

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0), relative_base)
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1), relative_base)
    param3 = get_output_parameter(intcode, position + 3)

    #IO.puts "params:"
    #IO.inspect param1
    #IO.inspect param2
    #IO.inspect param3

    output_val = param1 + param2
    
    %{
      intcode: List.replace_at(intcode, param3, output_val),
      position: position + 4,
      output: output,
      relative_base: relative_base
    }
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(2, intcode, position, _input, output, relative_base) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1_val = get_parameter(intcode, position + 1, Enum.at(param_modes, 0), relative_base)
    param2_val = get_parameter(intcode, position + 2, Enum.at(param_modes, 1), relative_base)
    output_pos = get_output_parameter(intcode, position + 3)
    output_val = param1_val * param2_val

    %{
      intcode: List.replace_at(intcode, output_pos, output_val),
      position: position + 4,
      output: output,
      relative_base: relative_base
    }
  end

  def do_instruction(3, intcode, position, input, output, relative_base) do
    output_pos = get_output_parameter(intcode, position + 1)
    
    %{
      intcode: List.replace_at(intcode, output_pos, input),
      position: position + 2,
      output: output,
      relative_base: relative_base
    }
  end

  def do_instruction(4, intcode, position, _input, output, relative_base) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0), relative_base)
    #IO.puts "OUTPUT: #{param1}"

    %{
      intcode: intcode,
      position: position + 2,
      output: (output ++ [param1]),
      relative_base: relative_base
    }
  end

  @doc """
  Opcode 5 is jump-if-true: if the first parameter is non-zero, it
  sets the instruction pointer to the value from the second parameter.
  Otherwise, it does nothing.
  """
  def do_instruction(5, intcode, position, _input, output, relative_base) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0), relative_base)
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1), relative_base)

    new_position = if param1 !== 0, do: param2, else: position + 3

    %{
      intcode: intcode,
      position: new_position,
      output: output,
      relative_base: relative_base
    }
  end

  @doc """
  Opcode 6 is jump-if-false: if the first parameter is zero, it
  sets the instruction pointer to the value from the second parameter.
  Otherwise, it does nothing.
  """
  def do_instruction(6, intcode, position, _input, output, relative_base) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0), relative_base)
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1), relative_base)

    new_position = if param1 === 0, do: param2, else: position + 3

    %{
      intcode: intcode,
      position: new_position,
      output: output,
      relative_base: relative_base
    }
  end

  @doc """
  Opcode 7 is less than: if the first parameter is less than the second
  parameter, it stores 1 in the position given by the third parameter.
  Otherwise, it stores 0.
  """
  def do_instruction(7, intcode, position, _input, output, relative_base) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0), relative_base)
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1), relative_base)
    param3 = get_output_parameter(intcode, position + 3)

    output_val = if param1 < param2, do: 1, else: 0

    %{
      intcode: List.replace_at(intcode, param3, output_val),
      position: position + 4,
      output: output,
      relative_base: relative_base
    }
  end

  @doc """
  Opcode 8 is equals: if the first parameter is equal to the second parameter,
  it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  """
  def do_instruction(8, intcode, position, _input, output, relative_base) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0), relative_base)
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1), relative_base)
    param3 = get_output_parameter(intcode, position + 3)

    output_val = if param1 === param2, do: 1, else: 0

    %{
      intcode: List.replace_at(intcode, param3, output_val),
      position: position + 4,
      output: output,
      relative_base: relative_base
    }
  end

  @doc """
  Opcode 9 adjusts the relative base by the value of its only parameter.
  The relative base increases (or decreases, if the value is negative)
  by the value of the parameter.
  """
  def do_instruction(9, intcode, position, _input, output, relative_base) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0), relative_base)

    %{
      intcode: intcode,
      position: position + 2,
      output: output,
      relative_base: relative_base + param1
    }
  end

  def do_instruction(99, intcode, _position, _input, output, relative_base) do
    %{
      intcode: intcode,
      position: nil,
      output: output,
      relative_base: relative_base
    }
  end

  @doc """
  Process the opcode at the specified position, then return the
  updated intcode and position of the next opcode.
  """
  def process_intcode_position(intcode, position, input, output, relative_base) do
    %{ opcode: opcode } = get_opcode(intcode, position)

    %{
      intcode: new_intcode,
      position: new_position,
      output: new_output,
      relative_base: relative_base
    } = do_instruction(opcode, intcode, position, input, output, relative_base)

    %{
      intcode: new_intcode,
      position: new_position,
      input: nil,
      output: new_output,
      relative_base: relative_base
    }
  end

  def run_program(intcode, input \\ nil) do
    initial = %{
      intcode: intcode,
      position: 0,
      input: input,
      output: [],
      relative_base: 0
    }

    result = Enum.reduce_while(0..Enum.count(intcode), initial, fn i, acc ->
      %{ intcode: intcode, position: position, input: input, output: output, relative_base: relative_base} = acc

      # Only process the intcode if we're positioned at an opcode.
      # Otherwise, return the accumulator intact and continue iterating.
      new_acc = cond do
        i === position -> process_intcode_position(intcode, position, input, output, relative_base)
        i !== position -> acc
      end

      if is_nil(new_acc[:position]) do
        {:halt, new_acc}
      else
        {:cont, new_acc}
      end
    end)
    
    result
  end

  def get_program_output(result) do
    result[:output] |> List.last
  end
end

defmodule Day9Solver do
  import Day9

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
    run_program(intcode, 1)
    |> get_program_output
  end

  def part2 do
    intcode = get_input()
    run_program(intcode, 5)
    |> get_program_output
  end
end

IO.puts "Day 9, Part 1: #{Day9Solver.part1()}"
IO.puts "Day 9, Part 2: #{Day9Solver.part2()}"
