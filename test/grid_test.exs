defmodule GridTest do
  use ExUnit.Case
  doctest Grid

  describe "create" do
    test "makes all keys" do
      subject = Grid.create(1, 2)
      expected = %Grid{width: 1, height: 2, data: %{{0, 0} => nil, {0, 1} => nil}}
      assert expected == subject
    end

    test "accepts two dimensional lists" do
      subject = Grid.create([[2, 3], [0, 1]])
      expected = %{{0, 0} => 0, {1, 0} => 1, {0, 1} => 2, {1, 1} => 3}

      assert expected == subject.data
    end

    test "sets correct default value" do
      subject = Grid.create(2, 3, 1)
      assert Map.values(subject.data) |> Enum.all?(&(&1 == 1))
    end
  end

  describe "to_string" do
    test "returns string separated by newlines" do
      subject = Grid.create([[2, 3], [0, 1]])
      assert "23\n01\n" == Grid.to_string(subject)
    end
  end
end
