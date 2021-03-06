defmodule Yggdrasil.Transformer.Json do
  @moduledoc """
  JSON Yggdrasil transformer using the library `Jason`.
  """
  use Yggdrasil.Transformer, name: :json

  alias Yggdrasil.Channel

  @doc """
  Decodes a JSON from a binary `message`. The `channel` is ignored.
  """
  @impl Yggdrasil.Transformer
  def decode(channel, message)

  def decode(%Channel{} = _, message) when is_binary(message) do
    Jason.decode(message)
  end

  def decode(_channel, _message) do
    {:error, "Cannot decode message"}
  end

  @doc """
  Encodes some `data` to a JSON binary. The `channel` is ignored.
  """
  @impl Yggdrasil.Transformer
  def encode(channel, data)

  def encode(%Channel{} = _, data) when is_map(data) do
    Jason.encode(data)
  end

  def encode(_channel, _message) do
    {:error, "Cannot encode message"}
  end
end
