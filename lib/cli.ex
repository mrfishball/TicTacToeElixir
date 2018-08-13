defmodule Cli do

  def output(message, type \\ None) do
    case type do
      :menu -> IO.puts(Colorizer.yellow(message))
      :status -> IO.puts(Colorizer.yellow(message))
      :error -> IO.puts(Colorizer.red(message))
      None -> IO.puts(message)
    end
  end

  def input(message, type \\ None) do
    case type do
      :request ->
        input = IO.gets(Colorizer.yellow(message))
        String.trim(input)
      None ->
        input = IO.gets(message)
        String.trim(input)
    end
  end
end
