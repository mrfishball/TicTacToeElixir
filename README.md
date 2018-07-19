# Tic Tac Toe in Elixir!

[![Build Status](https://travis-ci.com/mrfishball/TTT-in-Elixir.svg?branch=master)](https://travis-ci.com/mrfishball/TTT-in-Elixir)

A fun Tic Tac Toe game!

## Installation

Clone this repo by running:

```sh
$ git clone https://github.com/mrfishball/TicTacToeElixir.git
```

## Prerequisites

You need to have Elixir installed. Please refer to the [official guide](http://elixir-lang.org/install.html) for instructions.

Next, cd to the root of the repo folder and fetch mix dependencies by running:

```sh
$ mix deps.get
```

You might get prompted to install further dependencies. Reply "y".

On Linux, you'll need to install `inotify-tools` to be able
to use the autorunner in this project.

## Compile

In the root of the project folder, run:

```sh
$ mix escript.build
```

This will build an executable binary of the game
then, simply double click on the new executable file named "ttt" or run:

```sh
./ttt
```

## Tests

Simply run:

```sh
$ mix test
```

## Credo

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
