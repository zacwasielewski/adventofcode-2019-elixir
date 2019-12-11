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

  def get_parameter(state, n) do
    %{ intcode: intcode, position: position, relative_base: relative_base } = state
    %{ param_modes: param_modes } = get_opcode(intcode, position)
    
    mode = Enum.at(param_modes, n)
    position = state[:position] + n + 1

    case mode do
      0 -> Enum.at(intcode, Enum.at(intcode, position)) # Position mode
      1 -> Enum.at(intcode, position) # Immediate mode
      2 -> Enum.at(intcode, Enum.at(intcode, position + relative_base)) # Relative mode
    end
  end

  def get_parameter(state, n, :write) do
    %{ intcode: intcode, position: position, relative_base: relative_base } = state
    
    write_position = position + n + 1

    Enum.at(intcode, write_position)
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(1, state) do
    %{ intcode: intcode, position: position } = state

    param1 = get_parameter(state, 0)
    param2 = get_parameter(state, 1)
    param3 = get_parameter(state, 2, :write)
    
    state
    |> Map.merge(%{
      intcode: List.replace_at(intcode, param3, param1 + param2),
      position: position + 4
    })
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(2, state) do
    %{ intcode: intcode, position: position } = state

    param1 = get_parameter(state, 0)
    param2 = get_parameter(state, 1)
    param3 = get_parameter(state, 2, :write)
    
    state
    |> Map.merge(%{
      intcode: List.replace_at(intcode, param3, param1 * param2),
      position: position + 4
    })
  end

  def do_instruction(3, state) do
    %{ intcode: intcode, position: position, input: input } = state

    param1 = get_parameter(state, 0, :write)
    
    state
    |> Map.merge(%{
      intcode: List.replace_at(intcode, param1, input),
      position: position + 2
    })
  end

  def do_instruction(4, state) do
    %{ position: position, output: output } = state

    param1 = get_parameter(state, 0)

    state
    |> Map.merge(%{
      position: position + 2,
      output: (output ++ [param1]),
    })
  end

  @doc """
  Opcode 5 is jump-if-true: if the first parameter is non-zero, it
  sets the instruction pointer to the value from the second parameter.
  Otherwise, it does nothing.
  """
  def do_instruction(5, state) do
    %{ position: position } = state

    param1 = get_parameter(state, 0)
    param2 = get_parameter(state, 1)

    state
    |> Map.merge(%{
      position: (if param1 !== 0, do: param2, else: position + 3)
    })
  end

  @doc """
  Opcode 6 is jump-if-false: if the first parameter is zero, it
  sets the instruction pointer to the value from the second parameter.
  Otherwise, it does nothing.
  """
  def do_instruction(6, state) do
    %{ position: position } = state

    param1 = get_parameter(state, 0)
    param2 = get_parameter(state, 1)

    state
    |> Map.merge(%{
      position: (if param1 === 0, do: param2, else: position + 3)
    })
  end

  @doc """
  Opcode 7 is less than: if the first parameter is less than the second
  parameter, it stores 1 in the position given by the third parameter.
  Otherwise, it stores 0.
  """
  def do_instruction(7, state) do
    %{ intcode: intcode, position: position } = state

    param1 = get_parameter(state, 0)
    param2 = get_parameter(state, 1)
    param3 = get_parameter(state, 2, :write)

    store_value = if param1 < param2, do: 1, else: 0

    state
    |> Map.merge(%{
      intcode: List.replace_at(intcode, param3, store_value),
      position: position + 4,
    })
  end

  @doc """
  Opcode 8 is equals: if the first parameter is equal to the second parameter,
  it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  """
  def do_instruction(8, state) do
    %{ intcode: intcode, position: position } = state

    param1 = get_parameter(state, 0)
    param2 = get_parameter(state, 1)
    param3 = get_parameter(state, 2, :write)

    store_value = if param1 === param2, do: 1, else: 0

    state
    |> Map.merge(%{
      intcode: List.replace_at(intcode, param3, store_value),
      position: position + 4,
    })
  end

  @doc """
  Opcode 9 adjusts the relative base by the value of its only parameter.
  The relative base increases (or decreases, if the value is negative)
  by the value of the parameter.
  """
  def do_instruction(9, state) do
    %{ position: position, relative_base: relative_base } = state

    param1 = get_parameter(state, 0)

    state
    |> Map.merge(%{
      position: position + 2,
      relative_base: relative_base + param1
    })
  end

  def do_instruction(99, state) do
    state
    |> Map.merge(%{
      position: nil,
    })
  end

  def process_program_state(state) do
    %{ intcode: intcode, position: position } = state
    %{ opcode: opcode } = get_opcode(intcode, position)

    do_instruction(opcode, state)
  end

  def run_program(intcode, input \\ nil) do
    initial_state = %{
      intcode: intcode,
      position: 0,
      input: input,
      output: [],
      relative_base: 0
    }

    result = Enum.reduce_while(0..Enum.count(intcode), initial_state, fn i, state ->
      %{ position: position } = state

      # Only process the intcode if we're positioned at an opcode.
      # Otherwise, return the accumulator intact and continue iterating.
      new_state = cond do
        i === position -> process_program_state(state)
        i !== position -> state
      end

      if is_nil(new_state[:position]) do
        {:halt, new_state}
      else
        {:cont, new_state}
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
#IO.puts "Day 9, Part 2: #{Day9Solver.part2()}"
