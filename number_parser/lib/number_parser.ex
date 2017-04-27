defmodule NumberParser do
  @doc """
      iex> NumberParser.parse_int("123")
      123
      iex> NumberParser.parse_int("-123")
      -123
      iex> NumberParser.parse_int("0")
      0
      iex> NumberParser.parse_int("notint")
      ** (ArgumentError) parse_int: n is not a digit.
  """
  def parse_int(s) when is_binary(s), do: String.to_charlist(s) |> parse_int

  def parse_int([ ?+ | tail ]), do: _parse_int(tail)
  def parse_int([ ?- | tail ]), do: _parse_int(tail) * -1
  def parse_int(list) when is_list(list), do: _parse_int(list)

  defp _parse_int(list) when is_list(list), do: _parse_int(list, 0)

  defp _parse_int(digit) when is_integer(digit), do: digit - ?0
  defp _parse_int([ digit | tail ], acc) when digit in '0123456789', do: _parse_int(tail, acc * 10 + _parse_int(digit))
  defp _parse_int([ digit | _ ], _), do: raise ArgumentError, "parse_int: #{[digit]} is not a digit."
  defp _parse_int([], acc), do: acc

  @doc """
      iex> NumberParser.parse_float("123.456")
      123.456
      iex> NumberParser.parse_float("-123.456")
      -123.456
      iex> NumberParser.parse_float("notint")
      ** (ArgumentError) parse_float: n is not a digit.
  """
  def parse_float(s) when is_binary(s), do: String.to_charlist(s) |> parse_float

  def parse_float([ ?+ | tail ]), do: _parse_float(tail)
  def parse_float([ ?- | tail ]), do: _parse_float(tail) * -1
  def parse_float(tail), do: _parse_float(tail)

  defp _parse_float(list) when is_list(list), do: _parse_float(list, 0)

  defp _parse_float([ digit | tail ], acc) when digit in '0123456789', do: _parse_float(tail, acc * 10 + _parse_int(digit))
  defp _parse_float([ ?. | tail ], acc), do: acc + (_parse_int(tail) * :math.pow(10, -length(tail)))
  defp _parse_float([ digit | _ ], _), do: raise ArgumentError, "parse_float: #{[digit]} is not a digit."
  defp _parse_float([], acc), do: acc
end
