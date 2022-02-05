defmodule ToyRobot.CardinalTest do
  use ExUnit.Case
  doctest ToyRobot.Cardinal

  alias ToyRobot.Cardinal

  describe "when parsing from string" do
    test "it must parse :north correctly" do
      assert Cardinal.from_string("NORTH") == {:ok, :north}
    end

    test "it must parse :east correctly" do
      assert Cardinal.from_string("EAST") == {:ok, :east}
    end

    test "it must parse :south correctly" do
      assert Cardinal.from_string("SOUTH") == {:ok, :south}
    end

    test "it must parse :west correctly" do
      assert Cardinal.from_string("WEST") == {:ok, :west}
    end

    test "it must return an error tuple from invalid directions" do
      assert Cardinal.from_string("INVALID_DIRECTION") == {:error, "Invalid direction"}
    end
  end

  describe "when turning clockwise" do
    test "it must return :east from :north" do
      assert Cardinal.turn(:north, :clockwise) == {:ok, :east}
    end

    test "it must return :south from :east" do
      assert Cardinal.turn(:east, :clockwise) == {:ok, :south}
    end

    test "it must return :west from :south" do
      assert Cardinal.turn(:south, :clockwise) == {:ok, :west}
    end

    test "it must return :north from :west" do
      assert Cardinal.turn(:west, :clockwise) == {:ok, :north}
    end
  end

  describe "when turning anticlockwise" do
    test "must return :west from :north" do
      assert Cardinal.turn(:north, :anticlockwise) == {:ok, :west}
    end

    test "must return :south from :west" do
      assert Cardinal.turn(:west, :anticlockwise) == {:ok, :south}
    end

    test "must return :east from :south" do
      assert Cardinal.turn(:south, :anticlockwise) == {:ok, :east}
    end

    test "must return :north from :east" do
      assert Cardinal.turn(:east, :anticlockwise) == {:ok, :north}
    end
  end

  test "it must return error when invalid direction is used" do
    assert Cardinal.turn(:invalid_direction, :clockwise) == {:error, "Invalid direction"}
  end

  test "it must return error when invalid sense is used" do
    assert Cardinal.turn(:north, :invalid_sense) == {:error, "Invalid sense"}
  end
end
