defmodule BufferProducer do
  use GenStage
  require Logger

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_demand(demand, state) do
    Logger.info("BufferProducer received demand for #{demand}")
    events = []
    {:noreply, events, state}
  end

  def push(items) when is_list(items) do
    GenStage.cast(__MODULE__, {:items, items})
  end

  def handle_cast({:items, items}, state) do
    {:noreply, items, state}
  end
end
