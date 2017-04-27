defmodule Enums do
  @doc """
  Returns true if all list items match passed function.

      iex> Enums.all? [1, 2, 3], fn (x) -> x > 0 end
      true
      iex> Enums.all? [1, 2, -3], fn (x) -> x > 0 end
      false
      iex> Enums.all? [], fn (x) -> x > 0 end
      true
  """
  def all?([], _), do: true
  def all?([head | tail], f), do: f.(head) and all?(tail, f)

  def each([], _), do: nil
  def each([head | tail], f) do
    f.(head)
    each(tail, f)
  end

  @doc """
      iex> Enums.filter [1,2,3,4,5], &( rem(&1, 2) == 0 )
      [2, 4]
      iex> Enums.filter [], &( rem(&1, 2) == 0 )
      []
  """
  def filter([], _), do: []
  def filter([head | tail], f) do
    processed_head = if f.(head), do: [head], else: []

    processed_head ++ filter(tail, f)
  end

  @doc """
      iex> Enums.split [1, 2, 3, 4, 5], 3
      { [1, 2, 3], [4, 5] }
      iex> Enums.split [1, 2, 3, 4, 5], 0
      { [], [1, 2, 3, 4, 5] }
      iex> Enums.split [1, 2], 5
      { [1, 2], [] }
  """
  def split(list, 0), do: { [], list }
  def split([], _), do: { [], [] }
  def split(list, n) when n > 0 do
    [ head | tail ] = list

    { split_l, split_r } = split(tail, n - 1)
    split_l = [head] ++ split_l

    { split_l, split_r }
  end

  @doc """
      iex> Enums.take [1, 2, 3, 4, 5], 3
      [1, 2, 3]
      iex> Enums.take [], 3
      []
      iex> Enums.take [1, 2, 3], 0
      []
      iex> Enums.take [1, 2, 3], 3
      [1, 2, 3]
  """
  def take(list, n) when n == 0 or list == [], do: []
  def take([head | tail], n) do
    [head] ++ take(tail, n - 1)
  end
end
