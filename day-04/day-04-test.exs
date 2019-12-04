ExUnit.start

defmodule Day4Test do
  use ExUnit.Case

  test "part_1_example_1" do
    assert is_valid_password(:part1, 111111)
  end

  test "part_1_example_2" do
    refute is_valid_password(:part1, 223450)
  end

  test "part_1_example_3" do
    refute is_valid_password(:part1, 123789)
  end

  test "part_2_example_1" do
    assert is_valid_password(:part2, 112233)
  end

  test "part_2_example_2" do
    refute is_valid_password(:part2, 123444)
  end

  test "part_2_example_3" do
    assert is_valid_password(:part2, 111122)
  end

  def is_valid_password(:part1, password) do
    import PasswordChecker
    
    is_correct_length(password) &&
    has_consecutive_siblings(password) &&
    does_not_decrease(password)
  end

  def is_valid_password(:part2, password) do
    import PasswordChecker

    is_correct_length(password) &&
    has_consecutive_twins(password) &&
    does_not_decrease(password)
  end
end