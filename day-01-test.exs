ExUnit.start

defmodule Day1Test do
  use ExUnit.Case

  test "part_1_example_1" do
    # For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
    assert Day1.fuel_required(12) === 2
  end

  test "part_1_example_2" do
    # For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
    assert Day1.fuel_required(14) === 2
  end

  test "part_1_example_3" do
    # For a mass of 1969, the fuel required is 654.
    assert Day1.fuel_required(1969) === 654
  end

  test "part_1_example_4" do
    # For a mass of 100756, the fuel required is 33583.
    assert Day1.fuel_required(100756) === 33583
  end

  test "part_2_example_1" do
    # A module of mass 14 requires 2 fuel. This fuel requires
    # no further fuel (2 divided by 3 and rounded down is 0,
    # which would call for a negative fuel), so the total fuel
    # required is still just 2.
    assert Day1.total_fuel_required(14) === 2
  end

  test "part_2_example_2" do
    # At first, a module of mass 1969 requires 654 fuel. Then,
    # this fuel requires 216 more fuel (654 / 3 - 2). 216 then
    # requires 70 more fuel, which requires 21 fuel, which
    # requires 5 fuel, which requires no further fuel. So,
    # the total fuel required for a module of mass 1969 is
    # 654 + 216 + 70 + 21 + 5 = 966.
    assert Day1.total_fuel_required(1969) === 966
  end

  test "part_2_example_3" do
    # The fuel required by a module of mass 100756 and its fuel is:
    # 33583 + 11192 + 3728 + 1240 + 411 + 135 + 43 + 12 + 2 = 50346.
    assert Day1.total_fuel_required(100756) === 50346
  end
end