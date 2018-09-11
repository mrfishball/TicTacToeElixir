defmodule TTT.Core.Player do
  alias __MODULE__, as: Player

  @moduledoc """

    A player module which contains player's name, token and type.
  """

  @enforce_keys [:name, :token, :type]
  defstruct @enforce_keys

  defp setup(name, token, type) do
    %Player{name: name, token: token, type: type}
  end

  def human({name, token} = _payload) do
    setup(name, token, :human)
  end

  def naive_computer({name, token} = _payload) do
    setup(name, token, :naive_computer)
  end

  def random_computer({name, token} = _payload) do
    setup(name, token, :random_computer)
  end

  def get_longer_token({player_one, player_two}) do
    if String.length(player_one.token) >= String.length(player_two.token) do
      player_one.token
    else
      player_two.token
    end
  end
end
