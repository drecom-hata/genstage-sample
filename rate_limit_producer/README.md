# RateLimitProducer
This is an example of doing rate limiting work on a GenStage Producer.

```
                                             +----------+
                                             | Check    |
                                       +---->+ Consumer |
                                       |     |          |
                                       |     +----------+
                                       |
         +-----------+     +------------+    +----------+
item --->| RateLimit |     | Check      |    | Check    |
item --->| Buffer    +<----+ Consumer   +--->+ Consumer |
item --->| Producer  |     | Supervisor |    |          |
         +-----------+     +------------+    +----------+
         Accept first                  |
         10 items                      |     +----------+
         per 5000 msec                 |     | Check    |
                                       +---->+ Consumer |
                                             |          |
                                             +----------+
```

## Build
```sh
$ mix deps.get
$ mix compile
```

## Usage
```bash
$ iex -S mix
...

iex> 1..4 |> Enum.to_list() |> Enum.map(&Integer.to_string/1) |> RateLimitBufferProducer.push()
:ok
11:01:55.715 [debug] RateLimitBufferProducer handle_cast({:items, ["1", "2", "3", "4"]}, %{interval: 5000, max_demand: 5, pending: 5})
11:01:55.717 [debug] CheckConsumer received 1
11:01:55.724 [debug] CheckConsumer received 2
11:01:55.724 [debug] CheckConsumer received 3
11:01:55.724 [debug] CheckConsumer received 4

iex> 1..4 |> Enum.to_list() |> Enum.map(&Integer.to_string/1) |> RateLimitBufferProducer.push()
:ok
11:01:57.566 [debug] RateLimitBufferProducer handle_cast({:items, ["1", "2", "3", "4"]}, %{interval: 5000, max_demand: 5, pending: 1})
11:01:57.566 [info]  RateLimitBufferProducer handle_cast: discarded 3 items
11:01:57.567 [debug] CheckConsumer received 1
11:01:59.462 [debug] RateLimitBufferProducer timeout
```
