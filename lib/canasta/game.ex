defmodule Canasta.Game do
  @moduledoc """
  Represents the game in its whole. This is mainly what the API will interact
  with.
  """

  @doc """
  :player_one -- player one
  :player_two -- player two
  :pile -- the cards the players can draft from
  :player_turn -- whose turn it is to play
  :table -- what cards are put down on the table
  :pulled -- whether or not the current player (player_turn) has pulled a card
  """
  @enforce_keys [:player_one, :player_two, :pile, :player_turn]
  defstruct [:player_one, :player_two, :pile, :player_turn, :table, :pulled]

  @doc """
  Creates a new game and starts it -- this means dealing cards (including
  handling red threes), and putting a card on the table.
  """
  def create do
    deck = Canasta.Card.new_deck()

    %Canasta.Game{
      player_one: %Canasta.Player{
        hand: Enum.slice(deck, 0..10),
        table: [],
        points: 0,
        red_threes: []
      },
      player_two: %Canasta.Player{
        hand: Enum.slice(deck, 11..21),
        table: [],
        points: 0,
        red_threes: []
      },
      pile: Enum.slice(deck, 22..-1),
      player_turn: :player_one,
      pulled: false
    }
    |> start
  end

  @doc """
  Starts the game. Puts a card on the table, and gives a card to the starting
  player.
  """
  def start(game) do
    game
    |> put_first_card()
  end

  @doc """
  Draft a card; gives a card to the player whose turn it is and prevents them
  from drafting another card.
  """
  def play(game, %{action: :draw}) do
    game
    |> deal_card
  end

  def play(game, %{action: :play_card, card: card}) do
    nil
  end

  def play(game, %{action: :meld, melds: [meld]}) do
    nil
  end

  def play(game, %{action: :meld, melds: [meld | meld_tail]}) do
    nil
  end

  @doc """
  Put the first card on the table, can not be a wild card. Will shuffle and try
  again if card is wild.
  """
  def put_first_card(%Canasta.Game{pile: [first_card | _] = pile} = game) do
    if Canasta.Card.card_type(first_card) == :wild do
      put_first_card(%{game | pile: Enum.shuffle(pile)})
    else
      %{game | table: [first_card], pile: Enum.slice(pile, 1..-1)}
    end
  end

  @doc """
  Give a card to the player whos turn it is and alter the current player.
  Doesn't allow players to draft two cards.
  """
  def deal_card(%Canasta.Game{pulled: false, player_turn: player_turn} = game) do
    game
    |> give_card(player_turn)
    |> Map.update!(:pulled, &(!&1))
  end

  def deal_card(%Canasta.Game{pulled: true} = game) do
    {:already_pulled, game}
  end

  @doc """
  Give a card to player. Don't touch, fragile code. Also checks for red three
  and fixes that.
  """
  def give_card(%Canasta.Game{pile: [first_card | _] = pile} = game, player) do
    %{
      Map.update!(
        game,
        player,
        &%{
          &1
          | hand: [first_card | &1.hand]
        }
      )
      | pile: Enum.slice(pile, 1..-1)
    }
    |> handle_red_three(player)
  end

  @doc """
  Handles eventual red threes on hand.
  """
  def handle_red_three(game, player) do
    player_struct = Map.get(game, player)

    case Canasta.Player.has_red_three?(player_struct) do
      nil ->
        game

      i ->
        game
        |> Map.update!(player, &Canasta.Player.deploy_red_three(&1, i))
        |> Canasta.Game.give_card(:player_one)
        |> handle_red_three(player)
    end
  end
end
