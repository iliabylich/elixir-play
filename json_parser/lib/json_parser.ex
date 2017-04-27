defmodule JsonParser do
  @digits '1234567890'

  def parse(s) do
    case read_one(s) do
      { result, "" } -> result
      { _, buffer } -> syntax_error(buffer)
    end
  end

  def read_one("nil" <> rest), do: { nil, rest }
  def read_one("true" <> rest),  do: { true, rest }
  def read_one("false" <> rest), do: { false, rest }
  def read_one(<<digit, _ :: binary>> = buffer) when digit in @digits, do: extract_int(buffer, 0)
  def read_one(<<?", rest :: binary>>), do: extract_string(rest, "")
  def read_one(<<?[, rest :: binary>>), do: extract_list(rest, [])
  def read_one(<<?{, rest :: binary>>), do: extract_map(rest, Map.new)
  def read_one(buffer), do: syntax_error(buffer)

  defp extract_int(<<digit, rest :: binary>>, acc) when digit in @digits do
    extract_int(rest, acc * 10 + (digit - ?0))
  end
  defp extract_int(buffer, acc), do: { acc, buffer }

  defp extract_string(<<?", rest :: binary>>, acc), do: { acc, rest }
  defp extract_string(<<char, rest :: binary>>, acc), do: extract_string(rest, acc <> <<char>>)
  defp extract_string("", _), do: syntax_error("")

  defp extract_list(<<?], rest :: binary>>, acc), do: { acc, rest }
  defp extract_list(<<?,, rest :: binary>>, acc), do: extract_list(rest, acc)
  defp extract_list(buffer, acc) do
    { item, buffer } = read_one(buffer)
    extract_list(buffer, acc ++ [item])
  end

  defp extract_map(<<?}, rest :: binary>>, acc), do: { acc, rest }
  defp extract_map(<<?,, rest :: binary>>, acc), do: extract_map(rest, acc)
  defp extract_map(buffer, acc) do
    { key, value, buffer } = extract_pair(buffer)
    pair = %{ key => value}
    acc = Map.merge(acc, pair)
    extract_map(buffer, acc)
  end

  defp extract_pair(buffer) do
    { key, buffer } = read_one(buffer)
    buffer = read_constant_char(buffer, ?:)
    { value, buffer } = read_one(buffer)
    { key, value, buffer }
  end

  def read_constant_char(<<char_code, rest :: binary>>, char_code), do: rest
  def read_constant_char(buffer, _), do: syntax_error(buffer)

  defmodule ParseError do
    defexception [:message]
  end

  defp syntax_error(buffer) do
    raise ParseError, "Can't parse near '" <> String.slice(buffer, 0, 10) <> "'"
  end
end








