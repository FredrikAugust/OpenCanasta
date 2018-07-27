defmodule Canasta.Card do
  @moduledoc """
  Represents a card.
  """

  @enforce_keys [:suit, :rank]
  defstruct [:suit, :rank]

  @doc """
  Check if the suit is hearts, diamonds, clubs or spades.

    iex> Canasta.Card.valid_suit?(%Canasta.Card{suit: :hearts, rank: :queen})
    true

    iex> Canasta.Card.valid_suit?(%Canasta.Card{suit: :no, rank: 10})
    false
  """
  def valid_suit?(%Canasta.Card{suit: suit}) when is_atom(suit) do
    Enum.member?([:hearts, :diamonds, :clubs, :spades], suit)
  end
  def valid_suit?(_), do: false

  @doc """
  Check if the rank of the card is either ace, joker, king, queen or jack, or a number between 2 and 10.

    iex> Canasta.Card.valid_rank?(%Canasta.Card{suit: :hearts, rank: :queen})
    true

    iex> Canasta.Card.valid_rank?(%Canasta.Card{suit: :hearts, rank: 13})
    false
  """
  def valid_rank?(%Canasta.Card{rank: rank}) when is_atom(rank) do
    Enum.member?([:ace, :joker, :king, :queen, :jack], rank)
  end
  def valid_rank?(%Canasta.Card{rank: rank}) when is_integer(rank) do
    Enum.member?((2..10), rank)
  end
  def valid_rank?(_), do: false

  @doc """
  This will be called on the card passed by the player to ensure the next check checking if the player has the card will not crash due to invalid card type.

    iex> Canasta.Card.valid?(%Canasta.Card{suit: :hearts, rank: :ace})
    true

    iex> Canasta.Card.valid?(%Canasta.Card{suit: :noway, rank: :jose})
    false
  """
  def valid?(card) do
    valid_suit?(card) && valid_rank?(card)
  end
end
