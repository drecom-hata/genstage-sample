defmodule CheckConsumer do
  require Logger

  def start_link(event) do
    Logger.debug("CheckConsumer received #{event}")

    Task.start_link(fn ->
      Checker.check()
    end)
  end
end
