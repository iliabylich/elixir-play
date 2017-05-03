defmodule GhCommits.Commit do
  defstruct [:sha, :author, :date, :message]

  def attribute(commit, :sha),     do: commit.sha
  def attribute(commit, :author),  do: commit.author
  def attribute(commit, :date),    do: commit.date
  def attribute(commit, :message), do: commit.message
end
