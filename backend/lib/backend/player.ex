defmodule Canasta.Player do
  @moduledoc """
  Represents a player in a game. Mostly used as an abstraction to simplify the
  code in backend/lib/backend/game.ex.
  """

  @enforce_keys [:hand, :table, :points, :red_threes]
  defstruct [:hand, :table, :points, :red_threes]

  @doc """
  Checks if the player has a red three - if they do, send back the index, and if
  not, nil.
  """
  def has_red_three?(%Canasta.Player{hand: hand}) do
    Enum.find_index(hand, &(&1 == %Canasta.Card{suit: :hearts, rank: 3} || &1 == %Canasta.Card{suit: :diamonds, rank: 3}))
  end

  @doc """
  Move the red three from the hand to array of red threes.
  """
  def deploy_red_three(player, index) do
    red_three = Enum.at(player.hand, index)
    %{player | red_threes: [red_three | player.red_threes], hand: player.hand -- [red_three]}
  end
end
