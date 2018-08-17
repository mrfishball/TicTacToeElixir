defmodule MessageTags do

  @moduledoc """
    Tags that can be used to indicate message or request types being displayed of received
    for processing.
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
