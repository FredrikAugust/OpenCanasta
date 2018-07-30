defmodule Canasta.Game do
  @moduledoc """
  Represents the game in its whole. This is mainly what the API will interact
  with.
  """

  @enforce_keys [:player_one, :player_two, :pile, :player_one_turn]
  defstruct [:player_one, :player_two, :pile, :player_one_turn]

  @doc """
  Creates a new game.
  """
  def create do
    deck = Canasta.Card.new_deck

    player_one = %Canasta.Player{
      hand: Enum.slice(deck, 0..10),
      table: [],
      points: 0,
      red_threes: []
    }

    player_two = %Canasta.Player{
      hand: Enum.slice(deck, 11..21),
      table: [],
      points: 0,
      red_threes: []
    }

    %Canasta.Game{
      player_one: player_one,
      player_two: player_two,
      pile: Enum.slice(deck, 22..-1),
      player_one_turn: true
    }
  end

  @doc """
  Starts the game; check if red threes on hand, give card to the one beginning.
  If one or both of the players have a red three, fix the first one detected,
  and "restart". This way it will recurse until all have been distributed.
  """
  def start(%Canasta.Game{player_one: p_one, player_two: p_two, pile: pile, player_one_turn: p_one_turn} = game) do
    case {Canasta.Player.has_red_three?(p_one), Canasta.Player.has_red_three?(p_two)} do
      {i, nil} ->
        %{game | player_one: Canasta.Player.deploy_red_three(p_one, i)}
        |> Canasta.Game.give_card(:player_one)
        |> start
      {nil, i} ->
        %{game | player_two: Canasta.Player.deploy_red_three(p_two, i)}
        |> Canasta.Game.give_card(:player_two)
        |> start
      {i, j} ->
        %{game | player_one: Canasta.Player.deploy_red_three(p_one, i), player_two: Canasta.Player.deploy_red_three(p_two, j)}
        |> Canasta.Game.give_card(:player_one)
        |> Canasta.Game.give_card(:player_two)
        |> start
    end
  end

  @doc """
  Give a card to player. Don't touch, fragile code.
  """
  def give_card(%Canasta.Game{pile: [first_card | _] = pile} = game, player) do
    %{Map.update!(game, player, &(%{ &1 | hand: [first_card | &1.hand] })) | pile: Enum.slice(pile, 1..-1)}
  end
end
