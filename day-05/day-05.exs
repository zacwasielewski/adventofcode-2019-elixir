defmodule Day5 do
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

  defp get_output_parameter(intcode, position) do
    get_parameter(intcode, position, 1)
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(1, intcode, position, _input) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    #IO.inspect intcode
    #IO.inspect position

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1))
    param3 = get_output_parameter(intcode, position + 3)
    output_val = param1 + param2
    
    %{
      intcode: List.replace_at(intcode, param3, output_val),
      position: position + 4
    }
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(2, intcode, position, _input) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1_val = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    param2_val = get_parameter(intcode, position + 2, Enum.at(param_modes, 1))
    output_pos = get_output_parameter(intcode, position + 3)
    output_val = param1_val * param2_val

    %{
      intcode: List.replace_at(intcode, output_pos, output_val),
      position: position + 4
    }
  end

  def do_instruction(3, intcode, position, input) do
    output_pos = get_output_parameter(intcode, position + 1)
    
    %{
      intcode: List.replace_at(intcode, output_pos, input),
      position: position + 2
    }
  end

  def do_instruction(4, intcode, position, _input) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    IO.puts "OUTPUT: #{param1}"

    %{
      intcode: intcode,
      position: position + 2
    }
  end

  @doc """
  Opcode 5 is jump-if-true: if the first parameter is non-zero, it
  sets the instruction pointer to the value from the second parameter.
  Otherwise, it does nothing.
  """
  def do_instruction(5, intcode, position, _input) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1))

    new_position = if param1 !== 0, do: param2, else: position + 3

    %{
      intcode: intcode,
      position: new_position
    }
  end

  @doc """
  Opcode 6 is jump-if-false: if the first parameter is zero, it
  sets the instruction pointer to the value from the second parameter.
  Otherwise, it does nothing.
  """
  def do_instruction(6, intcode, position, _input) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1))

    new_position = if param1 === 0, do: param2, else: position + 3

    %{
      intcode: intcode,
      position: new_position
    }
  end

  @doc """
  Opcode 7 is less than: if the first parameter is less than the second
  parameter, it stores 1 in the position given by the third parameter.
  Otherwise, it stores 0.
  """
  def do_instruction(7, intcode, position, _input) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1))
    param3 = get_output_parameter(intcode, position + 3)

    output_val = if param1 < param2, do: 1, else: 0

    %{
      intcode: List.replace_at(intcode, param3, output_val),
      position: position + 4
    }
  end

  @doc """
  Opcode 8 is equals: if the first parameter is equal to the second parameter,
  it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  """
  def do_instruction(8, intcode, position, _input) do
    %{ param_modes: param_modes } = get_opcode(intcode, position)

    param1 = get_parameter(intcode, position + 1, Enum.at(param_modes, 0))
    param2 = get_parameter(intcode, position + 2, Enum.at(param_modes, 1))
    param3 = get_parameter(intcode, position + 3) # Out

    output_val = if param1 === param2, do: 1, else: 0

    %{
      intcode: List.replace_at(intcode, param3, output_val),
      position: position + 4
    }
  end

  def do_instruction(99, intcode, _position, _input) do
    %{ intcode: intcode, position: nil }
  end

  @doc """
  Process the opcode at the specified position, then return the
  updated intcode and position of the next opcode.
  """
  def process_intcode_position(intcode, position, input) do
    %{ opcode: opcode } = get_opcode(intcode, position)

    result = do_instruction(opcode, intcode, position, input)
    %{
      intcode: new_intcode,
      position: new_position
    } = result

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
   #|> get_program_output()
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

  def part2 do
    intcode = get_input()
    run_program_with_input(intcode, 5)
  end
end

IO.puts "Part 1: "
IO.inspect {Day5Solver.part1()}
IO.puts "Part 2: "
IO.inspect {Day5Solver.part2()}

