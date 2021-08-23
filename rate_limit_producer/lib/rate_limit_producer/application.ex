defmodule RateLimitProducer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {RateLimitBufferProducer, %{max_demand: 5, interval: 5000}},
      CheckConsumerSupervisor,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RateLimitProducer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
