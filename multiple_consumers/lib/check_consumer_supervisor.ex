defmodule CheckConsumerSupervisor do
  use ConsumerSupervisor
  require Logger

  def start_link(_args) do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    Logger.info("CheckConsumerSupervisor init")

    children = [
      %{
        id: CheckConsumer,
        start: {CheckConsumer, :start_link, []},
        restart: :transient
      }
    ]
    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        {BufferProducer, max_demand: System.schedulers_online()}
      ]
    ]

    ConsumerSupervisor.init(children, opts)
  end
end
