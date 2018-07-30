defmodule CanastaGameTest do
  use ExUnit.Case
  alias Canasta.Card

  setup_all do
    {:ok,
     game: %Canasta.Game{
       player_one: %Canasta.Player{
         hand: [
           %Card{suit: :hearts, rank: 3},
           %Card{suit: :hearts, rank: 3},
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
       player_two: %Canasta.Player{
         hand: [
           %Card{suit: :hearts, rank: 5},
           %Card{suit: :hearts, rank: 3},
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
       pile: [
         %Card{suit: :hearts, rank: 5},
         %Card{suit: :hearts, rank: 10},
         %Card{suit: :hearts, rank: 4},
         %Card{suit: :clubs, rank: 9},
         %Card{suit: :hearts, rank: 6},
         %Card{suit: :diamonds, rank: 7},
         %Card{suit: :hearts, rank: 6}
       ],
       player_turn: :player_one
     }}
  end

  describe "create/0" do
    test "creates a new game and distributes cards" do
      game = Canasta.Game.create()

      assert length(game.player_one.red_threes) + length(game.player_two.red_threes) +
               length(game.player_one.hand) + length(game.player_two.hand) + length(game.pile) +
               length(game.table) == 108
    end

    test "put card on table" do
      started = Canasta.Game.create()
      assert length(started.table) == 1
    end

    test "remove one card from pile" do
      started = Canasta.Game.create()
      assert length(started.pile) <= 86
    end

    test "give a card to starting player" do
      started = Canasta.Game.create()
      assert length(started.player_one.hand) == 12
    end
  end

  describe "handle_red_threes/1" do
    test "handles red threes, puts them out and deals new card", state do
      handled_threes =
        state.game
        |> Canasta.Game.handle_red_three(:player_one)
        |> Canasta.Game.handle_red_three(:player_two)

      assert [
               Canasta.Player.has_red_three?(handled_threes.player_one),
               Canasta.Player.has_red_three?(handled_threes.player_two)
             ] == [nil, nil]

      assert length(handled_threes.player_one.red_threes) == 2
      assert length(handled_threes.player_two.red_threes) == 1
      assert length(state.game.pile) - length(handled_threes.pile) == 3
    end
  end

  describe "put_first_card/1" do
    test "puts the first card down if natural", state do
      putted = Canasta.Game.put_first_card(state.game)
      assert putted.table == [hd(state.game.pile)]
    end

    test "shuffles if wild", state do
      pile = [
        %Card{suit: :hearts, rank: 3},
        %Card{suit: :hearts, rank: 5},
        %Card{suit: :hearts, rank: 10},
        %Card{suit: :hearts, rank: 4},
        %Card{suit: :clubs, rank: 9},
        %Card{suit: :hearts, rank: 6},
        %Card{suit: :diamonds, rank: 7},
        %Card{suit: :hearts, rank: 6}
      ]

      updated_state = %{state.game | pile: pile}

      putted = Canasta.Game.put_first_card(updated_state)

      assert putted.table != [hd(pile)]
    end

    test "removed one card from pile", state do
      putted = Canasta.Game.put_first_card(state.game)
      assert length(putted.pile) == length(state.game.pile) - 1
    end
  end
end
