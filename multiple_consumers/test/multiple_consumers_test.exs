defmodule MultipleConsumersTest do
  use ExUnit.Case
  doctest MultipleConsumers

  test "greets the world" do
    assert MultipleConsumers.hello() == :world
  end
end
