defmodule CanastaCardTest do
  use ExUnit.Case
  alias Canasta.Card

  describe "valid_suit?/1" do# {{{
    test "validates valid suit" do# {{{
      assert Card.valid_suit?(%Card{suit: :hearts, rank: nil}) == :ok
    end# }}}

    test "validates invalid suit atom" do# {{{
      {:error, _} = Card.valid_suit?(%Card{suit: :fish, rank: nil})
    end# }}}

    test "validates invalid suit invalid type" do# {{{
      {:error, _} = Card.valid_suit?(%Card{suit: 1, rank: nil})
    end# }}}
  end# }}}

  describe "valid_rank?/1" do# {{{
    test "validates valid rank atom" do# {{{
      assert Card.valid_suit?(%Card{suit: nil, rank: :ace})
    end# }}}

    test "validates valid rank integer" do# {{{
      assert Card.valid_suit?(%Card{suit: nil, rank: 10})
    end# }}}

    test "validates invalid rank atom" do# {{{
      {:error, _} = Card.valid_suit?(%Card{suit: nil, rank: :fish})
    end# }}}

    test "validates invalid rank integer" do# {{{
      {:error, _} = Card.valid_suit?(%Card{suit: nil, rank: 12})
    end# }}}

    test "validates invalid rank invalid type" do# {{{
      {:error, _} = Card.valid_suit?(%Card{suit: nil, rank: 'n'})
    end# }}}
  end# }}}

  describe "valid?/1" do# {{{
    test "validates valid card" do# {{{
      assert Card.valid?(%Card{suit: :hearts, rank: 10}) == :ok
    end# }}}

    test "validates invalid card" do# {{{
      {:error, [_, _]} = Card.valid?(%Card{suit: nil, rank: nil})
    end# }}}

    test "validates invalid card only suit" do# {{{
      {:error, _} = Card.valid?(%Card{suit: nil, rank: 10})
    end# }}}

    test "validates invalid card only rank" do# {{{
      {:error, _} = Card.valid?(%Card{suit: :hearts, rank: 13})
    end# }}}
  end# }}}

  describe "value/1" do# {{{
    test "red threes" do# {{{
      assert Card.value(%Card{suit: :diamonds, rank: 3}) == 100
      assert Card.value(%Card{suit: :hearts, rank: 3}) == 100
    end# }}}

    test "black threes" do# {{{
      assert Card.value(%Card{suit: :clubs, rank: 3}) == 5
      assert Card.value(%Card{suit: :spades, rank: 3}) == 5
    end# }}}

    test "4-7" do# {{{
      Enum.each(4..7, fn i ->
        assert Card.value(%Card{suit: :clubs, rank: i}) == 5
        assert Card.value(%Card{suit: :spades, rank: i}) == 5
        assert Card.value(%Card{suit: :hearts, rank: i}) == 5
        assert Card.value(%Card{suit: :diamonds, rank: i}) == 5
      end)
    end# }}}

    test "8-10" do# {{{
      Enum.each(8..10, fn i ->
        assert Card.value(%Card{suit: :clubs, rank: i}) == 10
        assert Card.value(%Card{suit: :spades, rank: i}) == 10
        assert Card.value(%Card{suit: :hearts, rank: i}) == 10
        assert Card.value(%Card{suit: :diamonds, rank: i}) == 10
      end)
    end# }}}

    test "face cards" do# {{{
      Enum.each([:jack, :queen, :king], fn i ->
        assert Card.value(%Card{suit: :clubs, rank: i}) == 10
        assert Card.value(%Card{suit: :spades, rank: i}) == 10
        assert Card.value(%Card{suit: :hearts, rank: i}) == 10
        assert Card.value(%Card{suit: :diamonds, rank: i}) == 10
      end)
    end# }}}

    test "2" do# {{{
      assert Card.value(%Card{suit: :clubs, rank: 2}) == 20
      assert Card.value(%Card{suit: :spades, rank: 2}) == 20
      assert Card.value(%Card{suit: :hearts, rank: 2}) == 20
      assert Card.value(%Card{suit: :diamonds, rank: 2}) == 20
    end# }}}

    test "ace" do# {{{
      assert Card.value(%Card{suit: :clubs, rank: :ace}) == 20
      assert Card.value(%Card{suit: :spades, rank: :ace}) == 20
      assert Card.value(%Card{suit: :hearts, rank: :ace}) == 20
      assert Card.value(%Card{suit: :diamonds, rank: :ace}) == 20
    end# }}}

    test "joker" do# {{{
      assert Card.value(%Card{suit: nil, rank: :joker}) == 50
    end# }}}
  end# }}}

  describe "card type/2" do# {{{
    test "natural cards are natural" do# {{{
      assert Card.card_type(%Card{suit: :hearts, rank: 4}) == :natural
    end# }}}

    test "wild cards are wild" do# {{{
      assert Card.card_type(%Card{suit: :hearts, rank: 2}) == :wild
    end# }}}

    test "black threes will be natural in last meld" do# {{{
      assert Card.card_type(%Card{suit: :spades, rank: 3}, true) == :natural
      assert Card.card_type(%Card{suit: :clubs, rank: 3}, true) == :natural
    end# }}}
  end# }}}

  describe "new_deck/0" do# {{{
    test "108 cards" do# {{{
      assert length(Card.new_deck) == 108
    end# }}}
  end# }}}
end
