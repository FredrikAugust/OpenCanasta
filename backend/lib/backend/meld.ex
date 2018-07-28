defmodule Canasta.Meld do
  @moduledoc """
  Represents a meld -- when the player puts down three or more cards on the
  table.
  """

  @enforce_keys [:cards]
  defstruct [:cards]

  @doc """
  Create a new meld from an array of cards. Optional parameter is minimum required (see Canasta.Meld.validate_min/2).
  """
  def create_meld(cards, min \\ 0, final_round \\ false) do
    
  end

  @doc """
  Checks if the cards provided are enough to surpass the minimum required. See table under for required value.

  <0        = 15
  0-1495    = 50
  1500-2995 = 90
  >3000     = 120
  """
  defp validate_min(cards, min) do
    if Enum.reduce(Enum.map(cards, &Canasta.Card.value/1), &+/2) < min do
      {:error, "The value of the meld is lower than the minimum (#{min})."}
    else
      :ok
    end
  end

  @doc """
  Checks if the meld has enough cards (3).
  """
  defp validate_number_of_cards(cards) do
    if length(cards) < 3, do: {:error, "You need at least 3 cards in a meld."}, else: :ok
  end

  @doc """
  Checks the ratio between natural cards and wild cards is correct. No more than 1:1, and at least 2 natural cards.
  """
  defp validate_ratio(cards, final_round) do
    if Enum.count(cards, &(Canasta.Card.card_type(&1, final_round) == :natural)) > length(cards)/2 do
      :ok
    else
      {:error, "You must have more natural cards than wild cards."}
    end
  end
end
