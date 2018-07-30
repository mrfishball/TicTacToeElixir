defmodule Player do

  @enforce_keys [:name, :token, :type]
  defstruct @enforce_keys

  defp setup(name, token, type) do
    %Player{name: name, token: token, type: type}
  end

  def human(name, token) do
    setup(name, token, :human)
  end

  def naive_computer(name, token) do
    setup(name, token, :naive_computer)
  end

  def random_computer(name, token) do
    setup(name, token, :random_computer)
  end
end
