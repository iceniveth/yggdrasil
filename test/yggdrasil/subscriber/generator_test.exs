defmodule Yggdrasil.Subscriber.GeneratorTest do
  use ExUnit.Case, async: true

  alias Yggdrasil.Backend
  alias Yggdrasil.Channel
  alias Yggdrasil.Registry
  alias Yggdrasil.Subscriber.Generator
  alias Yggdrasil.Subscriber.Manager

  test "start and stop distributor" do
    assert {:ok, generator} = Generator.start_link()
    ref = Process.monitor(generator)
    assert :ok = Generator.stop(generator)
    assert_receive {:DOWN, ^ref, :process, ^generator, :normal}
  end

  test "subscribe/unsubscribe" do
    name = make_ref()
    {:ok, channel} = Registry.get_full_channel(%Channel{name: name})
    :ok = Backend.subscribe(channel)

    assert :ok = Generator.subscribe(channel)

    assert_receive {:Y_CONNECTED, _}, 500
    assert Manager.subscribed?(channel)

    stream = %Channel{channel | name: {:"$yggdrasil_elixir", name}}
    Backend.publish(stream, "message")

    assert_receive {:Y_EVENT, _, "message"}, 500
    assert :ok = Generator.unsubscribe(channel)

    assert_receive {:Y_DISCONNECTED, _}, 500

    :ok = Backend.unsubscribe(channel)
  end
end
