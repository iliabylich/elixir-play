defmodule GhCommits.CLI do
  @moduledoc """
  A root module of the gh_commits app.

  `GhCommits.CLI.main/1` gets invoked when you invoke an executable.
  """

  @defaults %{sort: "created", limit: 5}

  @doc """
  + Parses provided command line arguments
  + Autocompetes missing parameters to defaults
  + Validates them
  + Performs a request to GH api
  + Formats to the table
  + Prints to stdout

  ## Examples

      iex> GhCommits.CLI.main(["-h"])
      help: ...
      iex> GhCommits.CLI.main(["--repo", "elixir-lang/ex_doc"])
      |---------------|
      | ...headers... |
      |---------------|
      | .....rows.....|
      |---------------|
  """
  def main(argv) do
    argv
    |> parse
    |> autocomplete
    |> validate(&error_handler/1)
    |> execute
    |> format
    |> print(&IO.puts/1)
  end

  @doc """
  Parses provided CLI arguments to a map of command_name => value pairs.

  ## Examples

      iex> GhCommits.CLI.parse(["-h"])
      {help: true}
      iex> GhCommits.CLI.parse(["--repo", "ruby/ruby", "--liimt", "10", "--creator", "matz"])
      {repo: "ruby/ruby", limit: 10, creator: "matz"}
  """
  def parse(argv) do
    { supported, _, unsupported } = OptionParser.parse(argv,
      switches: [ help: :boolean, sort: :string, creator: :string, repo: :string, limit: :integer ],
      aliases: [ h: :help , s: :sort, c: :creator, r: :repo, l: :limit ]
    )

    Enum.each(unsupported, &unsupported_command/1)

    Enum.into(supported, %{})
  end

  @doc """
    Autocomplets provided commands using defaults

    ## Examples

        iex> GhCommits.CLI.autocomplete(%{})
        %{sort: "created", limit: 5}
        iex> GhCommits.CLI.autocomplete(%{sort: "updated", limit: 20})
        %{sort: "updated", limit: 20}
  """
  def autocomplete(commands) do
    Map.merge(@defaults, commands)
  end

  @doc """
    Validates provided map of commands and passes error messages to error_handler.
    It allows you to specify the way how you want to handle errors outside.

    ## Examples

        iex> GhCommits.CLI.validate(%{repo: 'not-a-binary'}, fn(error) -> raise error end)
        *** (ArgumentError) "Expected repo to be a binary"
  """
  def validate(commands, error_handler) do
    commands
    |> GhCommits.Validator.validate
    |> Enum.each(error_handler)

    commands
  end

  @doc """
  Executes a map of commands using `GhCommits.Runner`,
  Returns a list of commit objects (`GhCommits.Commit`)
  or exits a program (when -h was provided)
  """
  def execute(commands) do
    GhCommits.Runner.run(commands)
  end

  @doc """
  Formats a list of commits to a string containing a table representation.

  Uses `GhCommits.Formatter` internally.
  """
  def format(commits) do
    GhCommits.Formatter.to_table(commits)
  end

  @doc """
  Prints provided table using specified printer behavior.
  """
  def print(table, printer) do
    printer.(table)
  end

  defp error_handler(message) do
    IO.puts message
    IO.puts "Usage: issues (-c [<creator> | username]) (-s [<sort> | created]) -r <repo>"
    IO.puts "Exiting..."
    System.halt(0)
  end

  defp unsupported_command(command) do
    IO.puts "Unsupported command #{inspect(command)}, ignoring"
  end
end
