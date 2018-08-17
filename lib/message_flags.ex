defmodule MessageFlags do

  @moduledoc """
    Flags that can be used to indicate messages or requests being displayed of received.
  """

  def menu do
    "menu"
  end

  def title do
    "title"
  end

  def error do
    "error"
  end

  def status do
    "status"
  end

  def request do
    "request"
  end
end
