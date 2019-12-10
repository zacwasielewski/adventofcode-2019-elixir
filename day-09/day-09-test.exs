ExUnit.start

defmodule Day9Test do
  use ExUnit.Case

  test "day5_part_1_example_1" do
    # 1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2).
    assert Day9.run_program([1,0,0,0,99])[:intcode] === [2,0,0,0,99]
  end

  test "day5_part_1_example_2" do
    # 2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6).
    assert Day9.run_program([2,3,0,3,99])[:intcode] === [2,3,0,6,99]
  end

  test "day5_part_1_example_3" do
    # 2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801).
    assert Day9.run_program([2,4,4,5,99,0])[:intcode] === [2,4,4,5,99,9801]
  end

  test "day5_part_1_example_4" do
    # 1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99.
    assert Day9.run_program([1,1,1,4,99,5,6,0,99])[:intcode] === [30,1,1,4,2,5,6,0,99]
  end

  #test "day9_part_1_example_1" do
  #  # 109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99 takes no input and produces a copy of itself as output.
  #  program = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
  #  output = Day9.run_program(program) |> Day9.get_program_output
  #  assert output === program
  #end

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

  #test "part_2_example_1" do
  #  # 1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2).
  #  program = [3,9,8,9,10,9,4,9,99,-1,8]
  #  assert Day5.run_program_with_input(program, 8) === 1
  #  #assert Day5.run_program_with_input(program, 9) === 0
  #end

  #test "part_2" do
  #  assert Day5Solver.part2() === 4847
  #end
end