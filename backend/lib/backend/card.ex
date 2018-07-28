defmodule Canasta.Card do
  @moduledoc """
  Represents a card.
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
    if Enum.member?((2..10), rank) do
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
end
