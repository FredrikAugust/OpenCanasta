defmodule Canasta.Meld do
  @moduledoc """
  Represents a meld -- when the player puts down three or more cards on the
  table.
  """

  @enforce_keys [:cards]
  defstruct [:cards]

  @doc """
  Create a new meld from an array of cards.
  """
  def create_meld(cards, final_round \\ false) do
    validation_results = [
      validate_number_of_cards(cards),
      validate_purity(cards, final_round),
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

  def meld_score(meld) do
    meld.cards
    |> Enum.map(&Canasta.Card.value/1)
    |> Enum.reduce(&+/2)
  end

  @doc """
  Returns the type of canasta (:natural, :dirty), or :no_canasta.
  """
  def canasta?(meld) do
    natural_cards = Enum.filter(meld.cards, &(Canasta.Card.card_type(&1) == :natural))
    wild_cards = Enum.filter(meld.cards, &(Canasta.Card.card_type(&1) == :wild))

    cond do
      natural_cards >= 7 and wild_cards == 0 ->
        :natural
      natural_cards + wild_cards >= 7 ->
        :dirty
      true ->
        :no_canasta
    end
  end

  defp validate_number_of_cards(cards) do# {{{
    if length(cards) < 3, do: {:error, "You need at least 3 cards in a meld."}, else: :ok
  end# }}}

  defp validate_ratio(cards, final_round) do# {{{
    if Enum.count(cards, &(Canasta.Card.card_type(&1, final_round) == :natural)) >= length(cards)/2 do
      :ok
    else
      {:error, "You must have more natural cards than wild cards."}
    end
  end# }}}

  defp validate_purity(cards, final_round) do# {{{
    num_uniques = Enum.filter(cards, &(Canasta.Card.card_type(&1, final_round) == :natural))
                  |> Enum.map(&(&1.rank))
                  |> Enum.uniq()
                  |> length
    if num_uniques == 1, do: :ok, else: {:error, "You must have one type of natural card in a meld."}
  end# }}}
  end
