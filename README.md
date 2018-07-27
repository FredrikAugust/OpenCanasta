# OpenCanasta

OpenCanasta will be an implementation of the card game canasta -- front- and
back-end, allowing you to implement your own front-end if you don't like the one
I end up making.

The canasta version 

## Specification

_This is a work in progress._

The back-end will be written in `elixir`, using `ecto` to access an underlying
`postgresql` database (considered using `mnesia` to reduce external
dependencies, but `postgresql` is a lot easier to work with) with `plug` for
managing the routing and authentication with `guardian`. Because of `guardian`
we'll use `JWT` for authentication, and the front-end will communicate using a
asynchronous requests -- simple `ajax` requests for logging in/out, finding a
match et cetera, and WebSockets for the actual game communication.

## Structures

### Player

```
{
  hand   : Card[]
  table  : Meld[]
  points : int
}
```

### Meld

```
{
  cards : Card[]
}
```

### Game

```
{
  player1 : Player
  player2 : Player
  pile    : Card[]
}
```

### Card

```
{
  suit : [ hearts | diamonds | clubs | spades ]
  rank : [ ace | joker | king | queen | (2..10) ]
}
```


