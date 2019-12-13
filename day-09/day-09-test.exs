ExUnit.start

defmodule Day9Test do
  use ExUnit.Case

  test "store_value_in_range" do
    intcode = Day9.store_value([1,2,3,4,5], 2, "new")
    assert intcode === [1,2,"new",4,5]
  end

  test "store_value_out_of_range" do
    intcode = Day9.store_value([1,2,3,4,5], 9, "new")
    assert intcode === [1,2,3,4,5,0,0,0,0,"new"]
  end

  test "store_value_end_of_range" do
    intcode = Day9.store_value([1,2,3,4,5], 5, "new")
    assert intcode === [1,2,3,4,5,"new"]
  end

  test "retrieve_value_in_range" do
    value = Day9.retrieve_value([1,2,3,4,5], 2)
    assert value === 3
  end

  test "retrieve_value_in_range_2" do
    value = Day9.retrieve_value([1,2,3,4,5], 0)
    assert value === 1
  end

  test "day9_part_1_example_1" do
    # 109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99 takes no input and produces a copy of itself as output.
    program = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
    output = Day9.run_program(program)
    assert output[:intcode] === program
  end

  test "day9_part_1_example_2" do
    # 1102,34915192,34915192,7,4,7,99,0 should output a 16-digit number.
    program = [1102,34915192,34915192,7,4,7,99,0 ]
    output = Day9.run_program(program) |> Day9.get_program_output
    assert output |> Integer.digits |> Enum.count === 16
  end

  test "day9_part_1_example_3" do
    # 104,1125899906842624,99 should output the large number in the middle.
    program = [104,1125899906842624,99]
    output = Day9.run_program(program) |> Day9.get_program_output
    assert output === 1125899906842624
  end

  #test "part_2" do
  #  assert Day5Solver.part2() === 4847
  #end
end