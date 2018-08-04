# Canasta

This is a library for the card game _canasta_, providing a simple interface when
creating a back-end and/or front-end for the game.

## Installation

Simply add this to your `mix.exs` file:

```elixir
{:canasta, "~> 0.1.0"},
```

## Testing

To make sure everything works as it should, simply run `mix test`. This is also
done on every push to the repository, so you shouldn't have to worry about this.

## Usage

To provide an interface as simple as possible for the user, I've merged all
setup required into one function `Canasta.Game.create/0`. This will return a new
`Canasta.Game` structure, which is what you will interact with throughout the
use of the lib.

```elixir
game = Canasta.Game.create
```

The structure of the game looks like this, and this is what you will retrieve
when structuring your front/back-end:

```
%Canasta.Game{
  pile: [
    %Canasta.Card{rank: :jack, suit: :hearts},
    %Canasta.Card{rank: :jack, suit: :diamonds},
    %Canasta.Card{rank: 5, suit: :spades},
    %Canasta.Card{rank: 6, suit: :clubs},
    ...
  ],
  player_one: %Canasta.Player{
    hand: [
      %Canasta.Card{...},
      ...
    ],
    points: 0,
    red_threes: [%Canasta.Card{...}],
    table: [
      %Meld{cards: [%Canasta.Card{...}]}
    ]
  },
  player_turn: :player_one,
  player_two: %Canasta.Player{
    ...
  },
  pulled: true,
  table: [%Canasta.Card{...}]
}
```

### Available actions

To perform an action you will use the `Canasta.Game.play/2` function. This will
either return a tuple, where the first element is an error, or just a
`Canasta.Game` structure -- if successful.

#### Draw

_Input_: `%{action: :draw}`.

This will give a card to the player whose turn it is.

#### Play a card

_Input_: `%{action: :play_card, card: %Canasta.Card{...}}`

This will play the card from the hand of the current player.

#### Meld

_Input_: `%{action: :meld, melds: [%Canasta.Meld{...}]}`

This will create a meld (or several if specified) with the cards from the
players hand. If the player has not drafted a card, it will try to take the top
card on the table and create a meld with that. If the player has drafted a card,
a normal meld (or melds) will be created.
