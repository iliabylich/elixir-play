defmodule GhCommits.CLI do
  @defaults %{sort: "created", limit: 5}

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
    Parses provided CLI arguments to a tuple containing a command.
  """
  def parse(argv) do
    { supported, _, unsupported } = OptionParser.parse(argv,
      switches: [ help: :boolean, sort: :string, creator: :string, repo: :string, limit: :integer ],
      aliases: [ h: :help , s: :sort, c: :creator, r: :repo, l: :limit ]
    )

    Enum.each(unsupported, &unsupported_command/1)

    Enum.into(supported, %{})
  end

  def autocomplete(commands) do
    Map.merge(@defaults, commands)
  end

  def validate(commands, error_handler) do
    commands
    |> GhCommits.Validator.validate_list
    |> Enum.each(error_handler)

    commands
  end

  def execute(commands) do
    GhCommits.Runner.run(commands)
  end

  def format(commits) do
    GhCommits.Formatter.to_table(commits)
  end

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
