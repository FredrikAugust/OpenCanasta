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
  def create_meld(cards, score \\ 0, final_round \\ false) do
    validation_results = [
      validate_min(cards, score),
      validate_number_of_cards(cards),
      validate_purity(cards),
      validate_ratio(cards, final_round)
    ]

    errors = validation_results 
             |> Enum.reject(&(&1 == :ok))

    if length(errors) == 0 do
      %Canasta.Meld{cards: cards}
    else
      {:error, Enum.map(errors, &(elem(&1, 1)))}
    end
  end

  @doc """
  Returns the type of canasta (:natural, :dirty), or :no_canasta.
  """
  def canasta?(meld) do
    natural_cards = Enum.filter(Map.get(meld, :cards), &(Canasta.Card.card_type(&1) == :natural))
    wild_cards = Enum.filter(Map.get(meld, :cards), &(Canasta.Card.card_type(&1) == :wild))

    cond do
      natural_cards >= 7 and wild_cards == 0 ->
        :natural
      natural_cards + wild_cards >= 7 ->
        :dirty
      true ->
        :no_canasta
    end
  end

  defp validate_min(cards, score) do# {{{
  # Table of required min based on score
  # <0        = 15
  # 0-1495    = 50
  # 1500-2995 = 90
  # >3000     = 120

    min = cond do
      score in -10000..-5 ->
        15
      score in 0..1495 ->
        50
      score in 1500..2995 ->
        90
      true ->
        120
    end

    if Enum.reduce(Enum.map(cards, &Canasta.Card.value/1), &+/2) < min do
      {:error, "The value of the meld is lower than the minimum (#{min})."}
    else
      :ok
    end
  end# }}}

  defp validate_number_of_cards(cards) do# {{{
    if length(cards) < 3, do: {:error, "You need at least 3 cards in a meld."}, else: :ok
  end# }}}

  defp validate_ratio(cards, final_round) do# {{{
    if Enum.count(cards, &(Canasta.Card.card_type(&1, final_round) == :natural)) > length(cards)/2 do
      :ok
    else
      {:error, "You must have more natural cards than wild cards."}
    end
  end# }}}

  defp validate_purity(cards) do# {{{
    num_uniques = Enum.filter(cards, &(Canasta.Card.card_type(&1) == :natural))
                  |> Enum.uniq
                  |> length
    if num_uniques == 1, do: :ok, else: {:error, "You can only have one type of natural card in a meld."}
  end# }}}
  end
