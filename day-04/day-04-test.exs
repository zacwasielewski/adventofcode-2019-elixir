ExUnit.start

defmodule Day4Test do
  use ExUnit.Case

  test "part_1_example_1" do
    assert Day4.is_valid_password(111111)
  end

  test "part_1_example_2" do
    refute Day4.is_valid_password(223450)
  end

  test "part_1_example_3" do
    refute Day4.is_valid_password(123789)
  end

  test "part_2_example_1" do
    assert Day4.is_valid_password_constrained(112233)
  end

  test "part_2_example_2" do
    refute Day4.is_valid_password_constrained(123444)
  end

  test "part_2_example_3" do
    assert Day4.is_valid_password_constrained(111122)
  end

  #test "part_1_example_1" do
  #  wire1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
  #  wire2 = "U62,R66,U55,R34,D71,R55,D58,R83"
  #  assert Day3.distance_to_closest_intersection(wire1, wire2) === 159
  #end

  #test "part_1_example_2" do
  #  wire1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
  #  wire2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
  #  assert Day3.distance_to_closest_intersection(wire1, wire2) === 135
  #end

  #test "part_2_example_1" do
  #  wire1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
  #  wire2 = "U62,R66,U55,R34,D71,R55,D58,R83"
  #  assert Day3.steps_to_closest_intersection(wire1, wire2) === 610
  #end

  #test "part_2_example_2" do
  #  wire1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
  #  wire2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
  #  assert Day3.steps_to_closest_intersection(wire1, wire2) === 410
  #end
end