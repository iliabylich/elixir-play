defmodule WordCounter do
  @moduledoc """
  A module that counts words in a string.
  """

  @doc """
  WordCount.word_count(text)

  ## Examples

      iex> WordCounter.word_count(nil)
      0
      iex> WordCounter.word_count("")
      0
      iex> WordCounter.word_count("one")
      1
      iex> WordCounter.word_count("one two three")
      3

  """
  def word_count(nil), do: 0
  def word_count(""), do: 0
  def word_count(s) do
    s |> String.split |> Enum.count
  end
end
