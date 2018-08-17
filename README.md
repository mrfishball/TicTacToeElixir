# Tic Tac Toe in Elixir!

[![Build Status](https://travis-ci.com/mrfishball/TicTacToeElixir.svg?branch=master)](https://travis-ci.com/mrfishball/TicTacToeElixir)

A library for building/playing a fun Tic Tac Toe game!

## Change Log

See the CHANGELOG.md file for further details.

## Building Your Own Game

Add :ttt as a dependency to your project's mix.exs with hex package manager(default):

```elixir
def deps do
  [
    {:ttt, "~> 0.1.0"}
  ]
end
```

or through GitHub:

```elixir
def deps do
  [
    {:ttt, git: "https://github.com/mrfishball/TicTacToeElixir.git", tag: "0.1.0"}
  ]
end
```

And run:

```sh
$ mix deps.get
```

## Usage

...TBA

## Compiling An Executable

Clone this repo by running:

```sh
$ git clone https://github.com/mrfishball/TicTacToeElixir.git
```

In the root of the project folder, run:

```sh
$ mix deps.get
```

And run:

```sh
$ mix escript.build
```

This will build an executable binary of the game
then, simply double click on the new executable file named "ttt" or run:

```sh
./ttt
```

## Warnings
Follow these steps to update the dependencies in order to remove any warnings.

```sh
rm -rf _build
```
follow by

```sh
mix deps.update --all
```

then the script in compile step above

## Tests

Simply run:

```sh
$ mix test
```

## Credo (Optional)

If you like to use Credo to check your code, run:

```sh
$ mix credo
```

Available flags for strict mode and detail mode use:

```sh
$ mix credo --strict
```

and

```sh
$ mix credo list
```

## Author

Steven Kwok (@mrfishball)

## License

TTT is released under the MIT License. See the LICENSE file for further
details.
