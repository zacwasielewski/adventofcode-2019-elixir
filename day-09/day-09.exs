defmodule Day9 do
  defp get_opcode(intcode, position) do
    retrieve_value(intcode, position)
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

  def retrieve_value(intcode, position) do
    Enum.at(intcode, position, 0)
  end

  @doc """
  If the store position exceeds the intcode's length, increase program "memory" as needed
  """
  def store_value(intcode, position, value) do
    program_memory_size = length(intcode) - 1

    if position > program_memory_size do
      extra_memory_needed = position - program_memory_size # Off-by-one errors are the worst
      extra_memory = Enum.map(1..extra_memory_needed, fn _ -> 0 end)

      List.replace_at(intcode ++ extra_memory, position, value)
    else
      List.replace_at(intcode, position, value)
    end
  end

  def get_parameter(state, n) do
    %{ intcode: intcode, position: position, relative_base: relative_base } = state
    %{ param_modes: param_modes } = get_opcode(intcode, position)
    
    #IO.inspect get_opcode(intcode, position)

    param_mode = Enum.at(param_modes, n-1)
    param_position = position + n
    param_value = retrieve_value(intcode, param_position)

    #IO.inspect [ n, param_mode, param_value ]

    case param_mode do
      0 -> retrieve_value(intcode, param_value) # Position mode
      1 -> param_value # Immediate mode
      2 -> retrieve_value(intcode, param_value + relative_base) # Relative mode
    end
  end

  def get_parameter(state, n, :write) do
    %{ intcode: intcode, position: position, relative_base: relative_base } = state
    %{ param_modes: param_modes } = get_opcode(intcode, position)
    
    param_mode = Enum.at(param_modes, n-1)
    param_position = position + n
    param_value = retrieve_value(intcode, param_position)

    case param_mode do
      0 -> param_value
      1 -> param_value
      2 -> param_value + relative_base
    end
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(1, state) do
    %{ intcode: intcode, position: position } = state

    param1 = get_parameter(state, 1)
    param2 = get_parameter(state, 2)
    param3 = get_parameter(state, 3, :write)

    #IO.puts "params: [#{param1}, #{param2}, #{param3}]"
    #IO.puts "Store #{param1} + #{param2} at position #{param3} ->"

    state
    |> Map.merge(%{
      intcode: store_value(intcode, param3, param1 + param2),
      position: position + 4
    })
  end

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result in a third position.
  """
  def do_instruction(2, state) do
    %{ intcode: intcode, position: position } = state

    param1 = get_parameter(state, 1)
    param2 = get_parameter(state, 2)
    param3 = get_parameter(state, 3, :write)

    #IO.puts "params: [#{param1}, #{param2}, #{param3}]"
    #IO.puts "Store #{param1} * #{param2} (#{param1 * param2}) at position #{param3} ->"

    state
    |> Map.merge(%{
      intcode: store_value(intcode, param3, param1 * param2),
      position: position + 4
    })
  end

  def do_instruction(3, state) do
    %{ intcode: intcode, position: position, input: input } = state

    param1 = get_parameter(state, 1, :write)

    #IO.puts "params: [#{param1}]"
    #IO.puts "Store program input (#{input}) at position #{param1} ->"

    state
    |> Map.merge(%{
      intcode: store_value(intcode, param1, input),
      position: position + 2
    })
  end

  def do_instruction(4, state) do
    %{ position: position, output: output } = state

    param1 = get_parameter(state, 1)

    #IO.puts "params: [#{param1}]"
    #IO.puts "Append #{param1} to the program output ->"

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

    param1 = get_parameter(state, 1)
    param2 = get_parameter(state, 2)

    #IO.puts "params: [#{param1}, #{param2}]"
    #if param1 !== 0 do
    #  IO.puts "#{param1} is non-zero, so set the pointer to #{param2} ->"
    #else
    #  IO.puts "#{param1} is NOT non-zero, so do nothing ->"
    #end

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

    param1 = get_parameter(state, 1)
    param2 = get_parameter(state, 2)

    #IO.puts "params: [#{param1}, #{param2}]"
    #if param1 !== 0 do
    #  IO.puts "#{param1} is zero, so set the pointer to #{param2} ->"
    #else
    #  IO.puts "#{param1} is NOT zero, so do nothing ->"
    #end

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

    param1 = get_parameter(state, 1)
    param2 = get_parameter(state, 2)
    param3 = get_parameter(state, 3, :write)

    value = if param1 < param2, do: 1, else: 0

    #IO.puts "params: [#{param1}, #{param2}, #{param3}]"
    #if param1 < param2 do
    #  IO.puts "#{param1} is less than #{param2}, so store 1 at position #{param3} ->"
    #else
    #  IO.puts "#{param1} is NOT less than #{param2}, so store 0 at position #{param3} ->"
    #end

    state
    |> Map.merge(%{
      intcode: store_value(intcode, param3, value),
      position: position + 4,
    })
  end

  @doc """
  Opcode 8 is equals: if the first parameter is equal to the second parameter,
  it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
  """
  def do_instruction(8, state) do
    %{ intcode: intcode, position: position } = state

    param1 = get_parameter(state, 1)
    param2 = get_parameter(state, 2)
    param3 = get_parameter(state, 3, :write)

    value = if param1 === param2, do: 1, else: 0

    #IO.puts "params: [#{param1}, #{param2}, #{param3}]"
    #if param1 === param2 do
    #  IO.puts "#{param1} equals #{param2}, so store 1 at position #{param3} ->"
    #else
    #  IO.puts "#{param1} does NOT equal #{param2}, so store 0 at position #{param3} ->"
    #end

    state
    |> Map.merge(%{
      intcode: store_value(intcode, param3, value),
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

    param1 = get_parameter(state, 1)

    #IO.puts "params: [#{param1}]"
    #IO.puts "Adjust the relative base to #{relative_base} + #{param1} ->"

    state
    |> Map.merge(%{
      position: position + 2,
      relative_base: relative_base + param1
    })
  end

  def do_instruction(99, state) do

    #IO.puts "params: -"
    #IO.puts "Halt! ->"

    state
    |> Map.merge(%{
      position: nil,
    })
  end

  def process_program_state(state) do
    %{ intcode: intcode, position: position } = state
    %{ opcode: opcode } = get_opcode(intcode, position)

    #IO.puts "opcode: #{opcode}"

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

    #IO.puts "\n=== START PROGRAM:"
    #IO.inspect initial_state
    #IO.puts ""

    result = Enum.reduce_while(0..Enum.count(intcode), initial_state, fn i, state ->
      %{ position: position } = state

      # Only process the intcode if we're positioned at an opcode.
      # Otherwise, return the accumulator intact and continue iterating.
      new_state = cond do
        i === position -> process_program_state(state)
        i !== position -> state
      end

      #if i === position do
      #  IO.inspect new_state, charlists: :as_lists
      #  IO.puts ""
      #end

      if is_nil(new_state[:position]) do
        {:halt, new_state}
      else
        {:cont, new_state}
      end
    end)
    
    result |> free_program_memory( length(intcode) )
  end

  def get_program_output(result) do
    result[:output] |> List.last
  end

  def free_program_memory(result, memory_size) do
    result |> Map.update!(:intcode, &( Enum.take(&1, memory_size) ))
  end
end

defmodule Day9Solver do
  import Day9

  @input_file "day-09-input.txt"
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
    #|> get_program_output
  end

  def part2 do
    intcode = get_input()
    run_program(intcode, 5)
    |> get_program_output
  end
end

IO.puts "Day 9, Part 1:"
IO.inspect Day9Solver.part1()
#IO.puts "Day 9, Part 2: #{Day9Solver.part2()}"
