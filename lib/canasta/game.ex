defmodule Canasta.Game do
  require Logger

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
    Logger.debug("Creating a new game")
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
  def play(%{pulled: false} = game, %{action: :draw}) do
    Logger.debug("Drawing a card")

    game
    |> deal_card
  end

  def play(%{pulled: true} = game, %{action: :draw}) do
    Logger.warn("Trying to overdraw")
    {:already_pulled, game}
  end

  def play(game, %{action: :play_card, card: card}) do
    Logger.debug("Playing card #{card.suit || "no suite"}|#{card.rank || "no rank"}")

    case game.pulled do
      true ->
        case card in current_player_hand(game) do
          true ->
            game
            |> remove_card_from_hand(card)
            |> put_card_on_table(card)
            |> switch_player_turn

          false ->
            {:invalid_card, game}
        end

      false ->
        {:not_pulled, game}
    end
  end

  defp remove_card_from_hand(game, card) do
    Map.update!(game, game.player_turn, fn player ->
      %Canasta.Player{player | hand: player.hand -- [card]}
    end)
  end

  defp put_card_on_table(game, card) do
    %Canasta.Game{game | table: [game.table] ++ [card]}
  end

  defp switch_player_turn(game) do
    Map.update!(game, :player_turn, fn player ->
      case player do
        :player_one ->
          :player_two

        :player_two ->
          :player_one
      end
    end)
  end

  def play(game, %{action: :meld, melds: [meld]}) do
    Logger.debug("Creating meld with #{length(meld.cards)} cards")
    nil
  end

  def play(game, %{action: :meld, melds: [meld | meld_tail]}) do
    Logger.debug("Creating meld with #{length(meld.cards)} cards")
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
  Give a card to the player whos turn it is and alter the current player pulled
  state.  Doesn't allow players to draft two cards.
  """
  def deal_card(%Canasta.Game{player_turn: player_turn} = game) do
    Logger.debug("Dealing card to #{player_turn}")

    game
    |> give_card(player_turn)
    |> Map.update!(:pulled, &(!&1))
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
        Logger.debug("#{player} has red three, handling now")

        game
        |> Map.update!(player, &Canasta.Player.deploy_red_three(&1, i))
        |> Canasta.Game.give_card(:player_one)
        |> handle_red_three(player)
    end
  end

  defp current_player_hand(game) do
    game
    |> Map.get(game.player_turn)
    |> Map.get(:hand)
  end
end
