defmodule CanastaMeldTest do
  use ExUnit.Case
  alias Canasta.Meld
  alias Canasta.Card

  setup_all do# {{{
    {:ok, dirty: %Meld{cards: [
      %Card{suit: :hearts, rank: 6},
      %Card{suit: :hearts, rank: 6},
      %Card{suit: :diamonds, rank: 6},
      %Card{suit: :clubs, rank: 6},
      %Card{suit: :spades, rank: 2},
      %Card{suit: nil, rank: :joker},
      %Card{suit: nil, rank: :joker},
      %Card{suit: nil, rank: :joker}
    ]}, natural: %Meld{cards: [
      %Card{suit: :hearts, rank: 7},
      %Card{suit: :hearts, rank: 7},
      %Card{suit: :diamonds, rank: 7},
      %Card{suit: :clubs, rank: 7},
      %Card{suit: :spades, rank: 7},
      %Card{suit: :clubs, rank: 7},
      %Card{suit: :spades, rank: 7}
    ]}, invalid_card_number: %Meld{cards: [
      %Card{suit: :hearts, rank: 6},
      %Card{suit: :hearts, rank: 6}
    ]}, invalid_purity: %Meld{cards: [
      %Card{suit: :hearts, rank: 7},
      %Card{suit: :hearts, rank: 6},
      %Card{suit: :hearts, rank: 6},
      %Card{suit: nil, rank: :joker},
      %Card{suit: nil, rank: :joker}
    ]}, invalid_ratio: %Meld{cards: [
      %Card{suit: :hearts, rank: 6},
      %Card{suit: :hearts, rank: 6},
      %Card{suit: nil, rank: :joker},
      %Card{suit: nil, rank: :joker},
      %Card{suit: nil, rank: :joker}
    ]}, invalid_final_meld: %Meld{cards: [
      %Card{suit: :hearts, rank: 3},
      %Card{suit: :hearts, rank: 3},
      %Card{suit: :diamonds, rank: 3},
    ]}, final_meld: %Meld{cards: [
      %Card{suit: :clubs, rank: 3},
      %Card{suit: :spades, rank: 3},
      %Card{suit: :clubs, rank: 3},
    ]}}
  end# }}}

  describe "create_meld/3" do# {{{
    test "validates natural", state do# {{{
      assert state.natural == Meld.create_meld(state.natural.cards)
    end# }}}

    test "validates dirty", state  do# {{{
      assert state.dirty == Meld.create_meld(state.dirty.cards)
    end# }}}

    test "validate_ratio/2", state do# {{{
      assert {:error, ["You must have more natural cards than wild cards."]} == Meld.create_meld(state.invalid_ratio.cards)
      assert {:error, ["You must have one type of natural card in a meld.", "You must have more natural cards than wild cards."]} == Meld.create_meld(state.invalid_final_meld.cards, true)
      assert state.final_meld == Meld.create_meld(state.final_meld.cards, true)
      assert {:error, ["You must have one type of natural card in a meld.", "You must have more natural cards than wild cards."]} == Meld.create_meld(state.final_meld.cards)
    end# }}}

    test "validate_purity/1", state do# {{{
      assert {:error, ["You must have one type of natural card in a meld."]} == Meld.create_meld(state.invalid_purity.cards)
    end# }}}

    test "validate_number_of_cards/1", state do# {{{
      assert {:error, ["You need at least 3 cards in a meld."]} == Meld.create_meld(state.invalid_card_number.cards)
    end# }}}
  end# }}}

  describe "meld_score/1" do# {{{
    test "calculates the score of a meld", state do
      assert Meld.meld_score(state.dirty) == 190
      assert Meld.meld_score(state.natural) == 35
    end
  end# }}}

  describe "canasta?/1" do# {{{

  end# }}}
end
