defmodule GhCommits.Commit do
  @moduledoc """
  A struct representation of a single commit.

  ## Examples

      iex> %GhCommits.Commit{
      ...    sha: "1234",
      ...    author: "iliabylich",
      ...    date: "2017-01-01",
      ...    message: "Initial commit."
      ...  }
  """
  defstruct [:sha, :author, :date, :message]

  @doc """
  Takes provided attribute from the commit.

  ## Examples

      iex> GhCommits.Commit.attribute(%GhCommits.Commit{sha: "12345"}, :sha)
      "12345"
      iex> GhCommits.Commit.attribute(%GhCommits.Commit{}, :sha)
      nil
  """
  def attribute(commit, :sha),     do: commit.sha
  def attribute(commit, :author),  do: commit.author
  def attribute(commit, :date),    do: commit.date
  def attribute(commit, :message), do: commit.message
end
