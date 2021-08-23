defmodule BufferProducer do
  use GenStage
  require Logger

  @default_max_demand 10
  @default_interval 5000

  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    Logger.info("BufferProducer init")

    max_demand = opts[:max_demand] || @default_max_demand
    interval = opts[:interval] || @default_interval

    state = %{
      max_demand: max_demand,
      interval: interval,
      pending: max_demand,
    }

    schedule_timeout(state.interval)

    {:producer, state}
  end

  def handle_demand(demand, state) do
    Logger.debug("BufferProducer received demand for #{demand}")

    {:noreply, [], state}
  end

  def push(items) when is_list(items) do
    GenStage.cast(__MODULE__, {:items, items})
  end

  def handle_cast({:items, items}, state) do
    Logger.debug("BufferProducer handle_cast({:items, #{inspect(items)}}, #{inspect(state)})")

    len = length(items)
    if len <= state.pending do
      state = %{state | pending: state.pending - len}

      {:noreply, items, state}
    else
      Logger.info("BufferProducer handle_cast: discarded #{len - state.pending} items")

      items = items |> Enum.slice(0, state.pending)
      state = %{state | pending: 0}

      {:noreply, items, state}
    end
  end

  def handle_info(:timeout, state) do
    Logger.debug("BufferProducer timeout")

    schedule_timeout(state.interval)

    {:noreply, [], %{state | pending: state.max_demand}}
  end

  defp schedule_timeout(interval) do
    Process.send_after(self(), :timeout, interval)
  end
end
