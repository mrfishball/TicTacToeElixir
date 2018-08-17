defmodule IOcontroller do
  alias TTT.Console.Cli, as: Cli

  @moduledoc """
    This is a controller module that relays input and output to corresponding handlers.
    The handlers can be changed without having to change any code in the game logic.
  """

  @doc """

    ## Parametrs
      - payload: String of user input.
      - type (Optional): String of categories of input. For example, "error", "request", etc.
      - source: Handler function injected.

    The return data and type are determined by the handler function.
  """
  def input(payload, type \\ None, source \\ &Cli.input/2) do
    source.(payload, type)
  end

  def output(payload, type \\ None, source \\ &Cli.output/2) do
    source.(payload, type)
  end
end
