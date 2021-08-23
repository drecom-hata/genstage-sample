defmodule CheckConsumer do
  require Logger

  def start_link(event) do
    Logger.info("CheckConsumer received #{event}")

    Task.start_link(fn ->
      Checker.check()
    end)
  end
end
