defmodule CanastaPlayerTest do
  use ExUnit.Case
  alias Canasta.Card

  setup_all do
    {:ok,
     with_red_three: %Canasta.Player{
       hand: [
         %Card{suit: :hearts, rank: 3},
         %Card{suit: :hearts, rank: 6},
         %Card{suit: :hearts, rank: 4},
         %Card{suit: nil, rank: :joker},
         %Card{suit: :hearts, rank: 5},
         %Card{suit: :hearts, rank: 10},
         %Card{suit: :hearts, rank: 4},
         %Card{suit: :clubs, rank: 9},
         %Card{suit: :hearts, rank: 6},
         %Card{suit: :diamonds, rank: 7},
         %Card{suit: :hearts, rank: 6}
       ],
       table: [],
       points: 0,
       red_threes: []
     },
     without_red_three: %Canasta.Player{
       hand: [
         %Card{suit: :hearts, rank: 5},
         %Card{suit: :hearts, rank: 6},
         %Card{suit: :hearts, rank: 4},
         %Card{suit: nil, rank: :joker},
         %Card{suit: :hearts, rank: 5},
         %Card{suit: :hearts, rank: 10},
         %Card{suit: :hearts, rank: 4},
         %Card{suit: :clubs, rank: 9},
         %Card{suit: :hearts, rank: 6},
         %Card{suit: :diamonds, rank: 7},
         %Card{suit: :hearts, rank: 6}
       ],
       table: [],
       points: 0,
       red_threes: []
     }}
  end

  describe "has_red_three?/1" do
    test "detects if the player has a red three", state do
      assert Canasta.Player.has_red_three?(state.with_red_three) == 0
    end

    test "detects if the player does not have a red three", state do
      assert Canasta.Player.has_red_three?(state.without_red_three) == nil
    end
  end

  describe "deploy_red_three/2" do
    test "properly puts the red three in the array and removes from hand", state do
      removed_three = Canasta.Player.deploy_red_three(state.with_red_three, 0)
      assert length(removed_three.hand) == 10
      assert length(removed_three.red_threes) == 1
    end
  end
end
