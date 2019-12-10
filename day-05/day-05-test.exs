ExUnit.start

defmodule Day5Test do
  use ExUnit.Case

  test "part_1_example_1" do
    # 1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2).
    assert Day5.run_program([1,0,0,0,99]) === [2,0,0,0,99]
  end

  test "part_1_example_2" do
    # 2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6).
    assert Day5.run_program([2,3,0,3,99]) === [2,3,0,6,99]
  end

  test "part_1_example_3" do
    # 2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801).
    assert Day5.run_program([2,4,4,5,99,0]) === [2,4,4,5,99,9801]
  end

  test "part_1_example_4" do
    # 1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99.
    assert Day5.run_program([1,1,1,4,99,5,6,0,99]) === [30,1,1,4,2,5,6,0,99]
  end

  #test "part_2" do
  #  assert Day5Solver.part2() === 4847
  #end
end