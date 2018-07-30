defmodule CanastaGameTest do
  use ExUnit.Case

  describe "create/0" do
    test "creates a new game and distributes cards" do
      game = Canasta.Game.create

      assert length(game.player_one.hand) == 11
      assert length(game.player_two.hand) == 11
      assert length(game.player_one.hand) + length(game.player_two.hand) + length(game.pile) == 108
    end
  end
end
