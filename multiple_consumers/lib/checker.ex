defmodule Checker do
  def check() do
    2..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end
end
