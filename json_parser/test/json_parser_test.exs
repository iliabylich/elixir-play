defmodule JsonParserTest do
  use ExUnit.Case
  import JsonParser

  test "parsing true" do
    assert parse("true") == true
  end

  test "parsing false" do
    assert parse("false") == false
  end

  test "parsing nil" do
    assert parse("nil") == nil
  end

  test "parsing numbers" do
    assert parse("123") == 123
  end

  test "parsing strings" do
    assert parse("\"\"") == ""
    assert parse("\"a string\"") == "a string"
  end

  test "parsing arrays" do
    assert parse("[]") == []
    assert parse("[[]]") == [[]]
    assert parse("[1,2,3]") == [1, 2, 3]
    assert parse("[\"a\",\"b\",\"c\"]") == ["a", "b", "c"]
    assert parse("[1,\"a\"]") == [1, "a"]
  end

  test "parsing objects" do
    assert parse("{}") == %{}
    assert parse("{\"a\":\"b\",\"c\":\"d\"}") == %{"a" => "b", "c" => "d"}
  end

  # commented out specs actually pass (which is obviously wrong)
  test "handling errors" do
    assert_raise JsonParser.ParseError, fn -> parse("a") end
    assert_raise JsonParser.ParseError, fn -> parse("123a") end
    assert_raise JsonParser.ParseError, fn -> parse("[a") end
    assert_raise JsonParser.ParseError, fn -> parse("[a,") end
    assert_raise JsonParser.ParseError, fn -> parse("[a]") end
    assert_raise JsonParser.ParseError, fn -> parse("[a;b]") end
    assert_raise JsonParser.ParseError, fn -> parse("\"") end
    assert_raise JsonParser.ParseError, fn -> parse("\"a") end
    assert_raise JsonParser.ParseError, fn -> parse("{") end
    assert_raise JsonParser.ParseError, fn -> parse("{\"") end
    assert_raise JsonParser.ParseError, fn -> parse("{\"a") end
    assert_raise JsonParser.ParseError, fn -> parse("{\"a\"") end
    assert_raise JsonParser.ParseError, fn -> parse("{\"a\":") end
    assert_raise JsonParser.ParseError, fn -> parse("{\"a\":\"") end
    assert_raise JsonParser.ParseError, fn -> parse("{\"a\":\"b") end
    assert_raise JsonParser.ParseError, fn -> parse("{\"a\":\"b\"") end

    assert_raise JsonParser.ParseError, fn -> parse("[[") end
    assert_raise JsonParser.ParseError, fn -> parse("{{") end

    # assert_raise JsonParser.ParseError, fn -> parse("[1,,2]") end
    assert_raise JsonParser.ParseError, fn -> parse("{\"a\"::\"b\"}") end

    # assert_raise JsonParser.ParseError, fn -> parse("{,}") end
    # assert_raise JsonParser.ParseError, fn -> parse("[,]") end
  end
end
