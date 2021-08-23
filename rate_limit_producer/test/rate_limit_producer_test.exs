defmodule RateLimitProducerTest do
  use ExUnit.Case
  doctest RateLimitProducer

  test "greets the world" do
    assert RateLimitProducer.hello() == :world
  end
end
