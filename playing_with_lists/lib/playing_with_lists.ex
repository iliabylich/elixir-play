defmodule PlayingWithLists do
  @moduledoc """
  Documentation for PlayingWithLists.
  """

  @doc """
  A copy of a Enum.map/2

  ## Examples

      iex> PlayingWithLists.map [1, 2, 3], fn (n) -> n * n end
      [1, 4, 9]

  """
  def map([], _), do: []
  def map([ head | tail ], f), do: [ f.(head) | map(tail, f) ]

  @doc """
  A copy of Enum.filter/2

  ## Examples

      iex> PlayingWithLists.filter [1,2,3,4], fn (n) -> rem(n, 2) == 0 end
      [2, 4]
  """
  def filter([], _), do: []
  def filter([ head | tail ], f) do
    if f.(head), do: [ head | filter(tail, f) ], else: filter(tail, f)
  end

  @doc """
  A copy of List.flatten/1

  ## Examples

      iex> PlayingWithLists.flatten [[1]]
      [1]

      iex> PlayingWithLists.flatten [ [1], [[2]], [[[3, 4]]]]
      [1, 2, 3, 4]
  """
  def flatten([]), do: []
  def flatten([ head | tail ]), do: flatten(head) ++ flatten(tail)
  def flatten(value), do: [value]

  @doc """
  Maps a provided list using provided function and calculates its sum.

  ## Examples

      iex> PlayingWithLists.mapsum [1, 2, 3], &(&1 * &1)
      14
  """
  def mapsum(list, f) do
    list
    |> Enum.map(f)
    |> Enum.sum
  end

  @doc """
  Returns a max number in the provided list

  ## Examples

      iex> PlayingWithLists.max_of([1, 2, 3])
      3
      iex> PlayingWithLists.max_of([3, 2, 1])
      3
      iex> PlayingWithLists.max_of([1, 1, 1])
      1
      iex> PlayingWithLists.max_of([])
      nil
  """
  def max_of([]), do: nil
  def max_of([head]), do: head
  def max_of([head | tail]), do: max2(head, max_of(tail))
  def max2(a, b) when a >  b, do: a
  def max2(_, b), do: b

  @doc """
  Appends N to each item of the list.

  ## Examples

      iex> PlayingWithLists.caesar('ryvkve', 13)
      'zzzxzr'
  """
  def caesar([], _), do: []
  def caesar([head | tail], n), do: [min(head + n, ?z) | caesar(tail, n)]
  def min2(a, b) when a <  b, do: a
  def min2(_, b), do: b

  @doc """
  Generates a sequence from +from+ to +to.

  ##Examples

      iex> PlayingWithLists.span(5, 1)
      []
      iex> PlayingWithLists.span(5, 5)
      [5]
      iex> PlayingWithLists.span(1, 5)
      [1, 2, 3, 4, 5]
  """
  def span(from, to) when from > to, do: []
  def span(from, from), do: [from]
  def span(from, to), do: [from | span(from + 1, to)]
end
