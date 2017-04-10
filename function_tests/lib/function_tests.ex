defmodule FunctionTests do
  defmodule Sampler do
    @doc """
      Returns some sample data depending on the first argument

      iex> FunctionTests.Sampler.get(:number)
      1

      iex> FunctionTests.Sampler.get(:atom)
      :atom

      iex> FunctionTests.Sampler.get(:string)
      "string"

      iex> FunctionTests.Sampler.get(:list, count: 1, item: 100)
      [100]
      iex> FunctionTests.Sampler.get(:list, count: 3, item: 5)
      [5, 5, 5]
    """
    def get(:number) do
      1
    end

    def get(:atom) do
      :atom
    end

    def get(:string) do
      "string"
    end

    def get(:list, count: count, item: item) do
      f = fn
        (count: 1, item: item) -> [item]
        (count: count, item: item) -> List.duplicate(item, count)
      end

      f.(count: count, item: item)
    end
  end

  defmodule Fizzbuzz do
    @doc """
      iex> FunctionTests.Fizzbuzz.fizzbuzz1(0, 1)
      "fizz"
      iex> FunctionTests.Fizzbuzz.fizzbuzz1(0, 2)
      "fizz"

      iex> FunctionTests.Fizzbuzz.fizzbuzz1(1, 0)
      "buzz"
      iex> FunctionTests.Fizzbuzz.fizzbuzz1(2, 0)
      "buzz"

      iex> FunctionTests.Fizzbuzz.fizzbuzz1(0, 0)
      "fizzbuzz"
    """
    def fizzbuzz1(a, b) do
      (fn
        (0, 0) -> "fizzbuzz"
        (0, _) -> "fizz"
        (_, 0) -> "buzz"
      end).(a, b)
    end

    @doc """
      iex> FunctionTests.Fizzbuzz.fizzbuzz(3)
      "fizz"
      iex> FunctionTests.Fizzbuzz.fizzbuzz(6)
      "fizz"

      iex> FunctionTests.Fizzbuzz.fizzbuzz(5)
      "buzz"
      iex> FunctionTests.Fizzbuzz.fizzbuzz(10)
      "buzz"

      iex> FunctionTests.Fizzbuzz.fizzbuzz(15)
      "fizzbuzz"
    """
    def fizzbuzz(n) do
      fizzbuzz1(rem(n, 3), rem(n, 5))
    end
  end

  defmodule Prefixer do
    @default_prefix "Def."

    @doc """
      Prefixes provided name with a prefix

      iex> FunctionTests.Prefixer.using("Mr.").("John Smith")
      "Mr. John Smith"
    """
    def using(prefix) do
      (fn (p) -> fn (n) -> "#{p} #{n}" end end).(prefix)
    end

    @doc """
      iex> FunctionTests.Prefixer.default.("John")
      "Def. John"
    """
    def default do
      using(@default_prefix)
    end
  end

  defmodule Sum do
    @doc """
      Takes N and return sum 0..N

      iex> FunctionTests.Sum.of(0)
      0
      iex> FunctionTests.Sum.of(1)
      1
      iex> FunctionTests.Sum.of(2)
      3
    """
    def of(0), do: 0
    def of(n), do: n + of(n - 1)
  end

  defmodule GCD do
    @doc """
      iex> FunctionTests.GCD.of(24, 15)
      3
    """
    def of(x, 0), do: x
    def of(x, y), do: of(y, rem(x,y))
  end

  defmodule Guess do
    @moduledoc """
      A module that can guess a number from the specified range using binary search
    """

    @doc """
      iex> FunctionTests.Guess.guess(273, 1..1000)
      [500, 250, 375, 312, 281, 265, 273]
    """
    def guess(n, range) do
      _guess(n, mid_of(range), range)
    end

    defp mid_of(first..last) do
      div(first + last, 2)
    end

    defp _guess(n, _, first..last) when n == first or n == last, do: []
    defp _guess(n, mid, first.._ ) when n <= mid, do: [mid] ++ guess(n, first..mid)
    defp _guess(n, mid, _..last  ) when n > mid,  do: [mid] ++ guess(n, mid..last)
  end
end
