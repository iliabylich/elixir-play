defmodule GhCommits.CLITest do
  use ExUnit.Case, async: true

  alias GhCommits.CLI

  describe "#parse" do
    test "it parses --sort and -o as a string" do
      assert CLI.parse(["--sort", "created"]) == %{sort: "created"}
      assert CLI.parse(["-s",     "created"]) == %{sort: "created"}
    end

    test "it parses --creator and -c as an insteger" do
      assert CLI.parse(["--creator", "nobu"]) == %{creator: "nobu"}
      assert CLI.parse(["-c",        "nobu"]) == %{creator: "nobu"}
    end

    test "it parses --repo and -r as a string" do
      assert CLI.parse(["--repo", "ruby/ruby"]) == %{repo: "ruby/ruby"}
      assert CLI.parse(["-r",     "ruby/ruby"]) == %{repo: "ruby/ruby"}
    end

    test "it parses --limit and -l as an integer" do
      assert CLI.parse(["--limit", "5"]) == %{limit: 5}
      assert CLI.parse(["-l",      "5"]) == %{limit: 5}
    end

    test "it parses --help and -h as a boolean" do
      assert CLI.parse(["--help"]) == %{help: true}
      assert CLI.parse(["-h"    ]) == %{help: true}
    end

    test "it parses multiple params" do
      assert CLI.parse(["-s", "created", "-c", "nobu", "-r", "ruby/ruby"]) == %{sort: "created", creator: "nobu", repo: "ruby/ruby"}
    end

    test "it parses unknown arguments" do
      assert CLI.parse(["--unknown", "value"]) == %{unknown: "value"}
    end
  end

  describe "#autocomplete" do
    test "it autocompletes sort to \"id\" when it's not specified" do
      assert CLI.autocomplete(%{}) == %{sort: "created", limit: 5}
    end
  end

  describe "#validates" do
    test "it validatess each command and prints an error if it's invalid" do
      raiser = fn(message) -> raise message end

      assert CLI.validate(%{help: true}, raiser) == %{help: true}
      assert_raise RuntimeError, "Wrong argument type help: false", fn ->
        CLI.validate(%{help: false}, raiser)
      end

      assert CLI.validate(%{sort: "id"}, raiser) == %{sort: "id"}
      assert_raise RuntimeError, "Wrong argument type sort: 'id'", fn ->
        CLI.validate(%{sort: 'id'}, raiser)
      end

      assert CLI.validate(%{creator: "5"}, raiser) == %{creator: "5"}
      assert_raise RuntimeError, "Wrong argument type creator: 5", fn ->
        CLI.validate(%{creator: 5}, raiser)
      end

      assert CLI.validate(%{repo: "ruby/ruby"}, raiser) == %{repo: "ruby/ruby"}
      assert_raise RuntimeError, "Wrong argument type repo: :ruby", fn ->
        CLI.validate(%{repo: :ruby}, raiser)
      end

      assert CLI.validate(%{limit: 5}, raiser) == %{limit: 5}
      assert_raise RuntimeError, "Wrong argument type limit: \"5\"", fn ->
        CLI.validate(%{limit: "5"}, raiser)
      end

      assert_raise RuntimeError, "Unknown command make_a_coffee", fn ->
        CLI.validate(%{make_a_coffee: true}, raiser)
      end
    end
  end

  describe "#execute" do
    @last_3_shas [
      "f942b92385adbc894ee4a37903ee6a9c1a65e9a4",
      "456db25dd08a22335e401331b3becad9fdf85381",
      "298b81916795a800c46ec43bbb8d583ebd6a55a4"
    ]

    @input %{repo: "voltrb/volt", creator: "ryanstout", sort: "created", limit: 3}

    test "it returns a response from GH according to parameters" do
      output = @input |> CLI.execute |> Enum.map(&(&1.sha))
      assert output == @last_3_shas
    end
  end

  describe "#format" do
    @input [
      %GhCommits.Commit{
        sha: "f942b92385adbc894ee4a37903ee6a9c1a65e9a4",
        author: "Ryan Stout",
        date: "2016-01-12T13:01:46Z",
        message: "cleanup readme"
      }
    ]

    @expected """
    |-----------------------------------------------------------------------------------------------|
    | SHA                                      | Author     | Date                 | Message        |
    |-----------------------------------------------------------------------------------------------|
    | f942b92385adbc894ee4a37903ee6a9c1a65e9a4 | Ryan Stout | 2016-01-12T13:01:46Z | cleanup readme |
    |-----------------------------------------------------------------------------------------------|
    """

    test "it formats it to a table" do
      assert CLI.format(@input) == @expected
    end
  end
end
