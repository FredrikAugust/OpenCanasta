defmodule Canasta.Card do
  alias Canasta.Card

  @moduledoc """
  Defines the card struct and functions working with it.
  """

  @enforce_keys [:suit, :rank]
  defstruct [:suit, :rank]

  @doc """
  Check if the suit is hearts, diamonds, clubs or spades.
  """
  def valid_suit?(%Canasta.Card{suit: suit}) when is_atom(suit) do
    if Enum.member?([:hearts, :diamonds, :clubs, :spades], suit) do
      :ok
    else
      {:error, "When suit is an atom, it must be hearts, diamonds, clubs or spades, not #{suit}."}
    end
  end

  def valid_suit?(_), do: {:error, "Suit must be an atom."}

  @doc """
  Check if the rank of the card is either ace, joker, king, queen or jack, or a number between 2 and 10.
  """
  def valid_rank?(%Canasta.Card{rank: rank}) when is_atom(rank) do
    if Enum.member?([:ace, :joker, :king, :queen, :jack], rank) do
      :ok
    else
      {:error, "When rank is an atom, it must be ace, joker, king, queen or jack, not #{rank}."}
    end
  end

  def valid_rank?(%Canasta.Card{rank: rank}) when is_integer(rank) do
    if Enum.member?(2..10, rank) do
      :ok
    else
      {:error, "When rank is an integer, it must be between 2 and 10, not #{rank}."}
    end
  end

  def valid_rank?(_), do: {:error, "Rank must be an atom or integer."}

  @doc """
  This will be called on the card passed by the player to ensure the next check checking if the player has the card will not crash due to invalid card type.
  """
  def valid?(card) do
    case {valid_suit?(card), valid_rank?(card)} do
      {:ok, rank_error} ->
        rank_error

      {suit_error, :ok} ->
        suit_error

      {{_, suit_error}, {_, rank_error}} ->
        {:error, [suit_error, rank_error]}

      _ ->
        :ok
    end
  end

  @doc """
  Value of the card.

  Red three = 100
  3-7    = 5
  8-King = 10
  2, Ace = 20
  Joker  = 50
  """
  def value(%Card{suit: suit, rank: rank}) do
    case {suit, rank} do
      {suit, 3} when suit in [:diamonds, :hearts] ->
        100

      {_, rank} when is_integer(rank) and rank in 8..10 ->
        10

      {_, :ace} ->
        20

      {_, :joker} ->
        50

      {_, rank} when is_atom(rank) ->
        10

      {_, 2} ->
        20

      _ ->
        5
    end
  end

  @doc """
  Checks whether the card is a wild card or a natural card.
  """
  def card_type(card, final_round \\ false) do
    if card in wild_cards(final_round), do: :wild, else: :natural
  end

  @doc """
  Generates a new french deck (two decks) and shuffles it.
  """
  def new_deck do# {{{
    [
      %Card{suit: :hearts, rank: 2},
      %Card{suit: :diamonds, rank: 2},
      %Card{suit: :clubs, rank: 2},
      %Card{suit: :spades, rank: 2},
      %Card{suit: :hearts, rank: 3},
      %Card{suit: :diamonds, rank: 3},
      %Card{suit: :clubs, rank: 3},
      %Card{suit: :spades, rank: 3},
      %Card{suit: :hearts, rank: 4},
      %Card{suit: :diamonds, rank: 4},
      %Card{suit: :clubs, rank: 4},
      %Card{suit: :spades, rank: 4},
      %Card{suit: :hearts, rank: 5},
      %Card{suit: :diamonds, rank: 5},
      %Card{suit: :clubs, rank: 5},
      %Card{suit: :spades, rank: 5},
      %Card{suit: :hearts, rank: 6},
      %Card{suit: :diamonds, rank: 6},
      %Card{suit: :clubs, rank: 6},
      %Card{suit: :spades, rank: 6},
      %Card{suit: :hearts, rank: 7},
      %Card{suit: :diamonds, rank: 7},
      %Card{suit: :clubs, rank: 7},
      %Card{suit: :spades, rank: 7},
      %Card{suit: :hearts, rank: 8},
      %Card{suit: :diamonds, rank: 8},
      %Card{suit: :clubs, rank: 8},
      %Card{suit: :spades, rank: 8},
      %Card{suit: :hearts, rank: 9},
      %Card{suit: :diamonds, rank: 9},
      %Card{suit: :clubs, rank: 9},
      %Card{suit: :spades, rank: 9},
      %Card{suit: :hearts, rank: 10},
      %Card{suit: :diamonds, rank: 10},
      %Card{suit: :clubs, rank: 10},
      %Card{suit: :spades, rank: 10},
      %Card{suit: :hearts, rank: :jack},
      %Card{suit: :diamonds, rank: :jack},
      %Card{suit: :clubs, rank: :jack},
      %Card{suit: :spades, rank: :jack},
      %Card{suit: :hearts, rank: :queen},
      %Card{suit: :diamonds, rank: :queen},
      %Card{suit: :clubs, rank: :queen},
      %Card{suit: :spades, rank: :queen},
      %Card{suit: :hearts, rank: :king},
      %Card{suit: :diamonds, rank: :king},
      %Card{suit: :clubs, rank: :king},
      %Card{suit: :spades, rank: :king},
      %Card{suit: :hearts, rank: :ace},
      %Card{suit: :diamonds, rank: :ace},
      %Card{suit: :clubs, rank: :ace},
      %Card{suit: :spades, rank: :ace},
      %Card{suit: nil, rank: :joker},
      %Card{suit: nil, rank: :joker},
      %Card{suit: :hearts, rank: 2},
      %Card{suit: :diamonds, rank: 2},
      %Card{suit: :clubs, rank: 2},
      %Card{suit: :spades, rank: 2},
      %Card{suit: :hearts, rank: 3},
      %Card{suit: :diamonds, rank: 3},
      %Card{suit: :clubs, rank: 3},
      %Card{suit: :spades, rank: 3},
      %Card{suit: :hearts, rank: 4},
      %Card{suit: :diamonds, rank: 4},
      %Card{suit: :clubs, rank: 4},
      %Card{suit: :spades, rank: 4},
      %Card{suit: :hearts, rank: 5},
      %Card{suit: :diamonds, rank: 5},
      %Card{suit: :clubs, rank: 5},
      %Card{suit: :spades, rank: 5},
      %Card{suit: :hearts, rank: 6},
      %Card{suit: :diamonds, rank: 6},
      %Card{suit: :clubs, rank: 6},
      %Card{suit: :spades, rank: 6},
      %Card{suit: :hearts, rank: 7},
      %Card{suit: :diamonds, rank: 7},
      %Card{suit: :clubs, rank: 7},
      %Card{suit: :spades, rank: 7},
      %Card{suit: :hearts, rank: 8},
      %Card{suit: :diamonds, rank: 8},
      %Card{suit: :clubs, rank: 8},
      %Card{suit: :spades, rank: 8},
      %Card{suit: :hearts, rank: 9},
      %Card{suit: :diamonds, rank: 9},
      %Card{suit: :clubs, rank: 9},
      %Card{suit: :spades, rank: 9},
      %Card{suit: :hearts, rank: 10},
      %Card{suit: :diamonds, rank: 10},
      %Card{suit: :clubs, rank: 10},
      %Card{suit: :spades, rank: 10},
      %Card{suit: :hearts, rank: :jack},
      %Card{suit: :diamonds, rank: :jack},
      %Card{suit: :clubs, rank: :jack},
      %Card{suit: :spades, rank: :jack},
      %Card{suit: :hearts, rank: :queen},
      %Card{suit: :diamonds, rank: :queen},
      %Card{suit: :clubs, rank: :queen},
      %Card{suit: :spades, rank: :queen},
      %Card{suit: :hearts, rank: :king},
      %Card{suit: :diamonds, rank: :king},
      %Card{suit: :clubs, rank: :king},
      %Card{suit: :spades, rank: :king},
      %Card{suit: :hearts, rank: :ace},
      %Card{suit: :diamonds, rank: :ace},
      %Card{suit: :clubs, rank: :ace},
      %Card{suit: :spades, rank: :ace},
      %Card{suit: nil, rank: :joker},
      %Card{suit: nil, rank: :joker}
    ] |> Enum.shuffle()
  end# }}}

  @doc """
  Is it a red three?
  """
  def is_red_three?(%Card{suit: suit, rank: rank}) do
    rank == 3 && (suit == :hearts || suit == :diamonds)
  end

  # argument is whether or not to include black threes
  defp wild_cards(false) do# {{{
    [
      %Card{suit: :hearts, rank: 2},
      %Card{suit: :diamonds, rank: 2},
      %Card{suit: :clubs, rank: 2},
      %Card{suit: :spades, rank: 2},
      %Card{suit: :hearts, rank: 3},
      %Card{suit: :diamonds, rank: 3},
      %Card{suit: :clubs, rank: 3},
      %Card{suit: :spades, rank: 3},
      %Card{suit: nil, rank: :joker},
    ]
  end# }}}
  # argument is whether or not to include black threes
  defp wild_cards(true) do# {{{
    [
      %Card{suit: :hearts, rank: 2},
      %Card{suit: :diamonds, rank: 2},
      %Card{suit: :clubs, rank: 2},
      %Card{suit: :spades, rank: 2},
      %Card{suit: :hearts, rank: 3},
      %Card{suit: :diamonds, rank: 3},
      %Card{suit: nil, rank: :joker},
    ]
  end# }}}
end
