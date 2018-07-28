defmodule CanastaCardTest do
  use ExUnit.Case
  alias Canasta.Card

  describe "valid_suit?/1" do
    test "validates valid suit" do
      assert Card.valid_suit?(%Card{suit: :hearts, rank: nil}) == :ok
    end

    test "validates invalid suit atom" do
      {:error, _} = Card.valid_suit?(%Card{suit: :fish, rank: nil})
    end

    test "validates invalid suit invalid type" do
      {:error, _} = Card.valid_suit?(%Card{suit: 1, rank: nil})
    end
  end

  describe "valid_rank?/1" do
    test "validates valid rank atom" do
      assert Card.valid_suit?(%Card{suit: nil, rank: :ace})
    end

    test "validates valid rank integer" do
      assert Card.valid_suit?(%Card{suit: nil, rank: 10})
    end

    test "validates invalid rank atom" do
      {:error, _} = Card.valid_suit?(%Card{suit: nil, rank: :fish})
    end

    test "validates invalid rank integer" do
      {:error, _} = Card.valid_suit?(%Card{suit: nil, rank: 12})
    end

    test "validates invalid rank invalid type" do
      {:error, _} = Card.valid_suit?(%Card{suit: nil, rank: 'n'})
    end
  end

  describe "valid?/1" do
    test "validates valid card" do
      assert Card.valid?(%Card{suit: :hearts, rank: 10}) == :ok
    end

    test "validates invalid card" do
      {:error, [_, _]} = Card.valid?(%Card{suit: nil, rank: nil})
    end

    test "validates invalid card only suit" do
      {:error, _} = Card.valid?(%Card{suit: nil, rank: 10})
    end

    test "validates invalid card only rank" do
      {:error, _} = Card.valid?(%Card{suit: :hearts, rank: 13})
    end
  end
end
