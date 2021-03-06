defmodule GhCommits.Formatter do
  @moduledoc """
  Internal module that converts a list of commits (`GhCommits.Commit`) to a table.
  """

  @vertical   "|"
  @horizontal "-"
  @headers %GhCommits.Commit{sha: "SHA", author: "Author", date: "Date", message: "Message"}

  @doc """
  Takes a list of commands an returns their string representation as a table.

  ## Examples
      iex> commit = %GhCommits.Commit{
      ...    sha: "1234",
      ...    author: "iliabylich",
      ...    date: "2017-01-01",
      ...    message: "Initial commit."
      ...  }
      iex> GhCommits.Formatter.to_table([commit])
      \"\"\"
      |--------------------------------------------------|
      | SHA  | Author     | Date.      | Message         |
      |--------------------------------------------------|
      | 1234 | iliabylich | 2017-01-01 | Initial commit. |
      |--------------------------------------------------|
      \"\"\"
  """
  def to_table(commits) do
    config = formatting_config(commits)

    headers = headers(config)
    rows = Enum.map(commits, fn(commit) -> to_row(commit, config) end)
    row_separator = row_separator(config)

    table = [row_separator, headers, row_separator] ++ rows ++ [row_separator, ""]
    Enum.join(table, "\n")
  end

  defp max_length(attribute, commits) do
    commits
    |> Enum.map(&(GhCommits.Commit.attribute(&1, attribute)))
    |> Enum.map(&String.length(&1))
    |> Enum.max
  end

  defp formatting_config(commits) do
    result = %{
      sha:     max_length(:sha,     commits),
      author:  max_length(:author,  commits),
      date:    max_length(:date,    commits),
      message: max_length(:message, commits)
    }

    #       | sha    | author    | date    | message   |
    #       ^^
    #         ^^^^^^
    #               ^^^
    #                  ^^^^^^^^^
    #                           ^^^
    #                              ^^^^^^^
    #                                     ^^^
    #                                        ^^^^^^^^^
    #                                                 ^^
    total = 2 + result.sha + 3 + result.author + 3 + result.date + 3 + result.message + 2

    Map.merge(result, %{total: total})
  end

  defp to_row(commit, config) do
    items = [
      to_cell(commit.sha,     config.sha),
      to_cell(commit.author,  config.author),
      to_cell(commit.date,    config.date),
      to_cell(commit.message, config.message)
    ]

    @vertical <> Enum.join(items, @vertical) <> @vertical
  end

  defp to_cell(value, length) do
    value |> String.ljust(length + 1) |> String.rjust(length + 2)
  end

  defp headers(config) do
    to_row(@headers, config)
  end

  defp row_separator(config) do
    @vertical <> String.duplicate(@horizontal, config.total - 2) <> @vertical
  end
end
