ExUnit.start

defmodule Day3Test do
  use ExUnit.Case

  test "part_1_example_0" do
    wire1 = "R8,U5,L5,D3"
    wire2 = "U7,R6,D4,L4"
    assert Day3.distance_to_closest_intersection(wire1, wire2) === 6
  end

  test "part_1_example_1" do
    wire1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    wire2 = "U62,R66,U55,R34,D71,R55,D58,R83"
    assert Day3.distance_to_closest_intersection(wire1, wire2) === 159
  end

  test "part_1_example_2" do
    wire1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    wire2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    assert Day3.distance_to_closest_intersection(wire1, wire2) === 135
  end
end