defmodule TTT.MixProject do
  alias TTT.Console.GameRunner, as: GameRunner
  use Mix.Project

  def project do
    [
      app: :ttt,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      escript: [main_module: GameRunner],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Library for build/playing a Tic Tac Toe game.
    """
  end

  defp package do
    [
    maintainers: ["Steven Kwok"],
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/mrfishball/TicTacToeElixir"}
  ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.9.1", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
