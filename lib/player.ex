defmodule Player do

  @enforce_keys [:name, :token, :type]
  defstruct @enforce_keys

  def new(name, token, type) do
    %Player{name: name, token: token, type: type}
  end
end
