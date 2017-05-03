defmodule GhCommits.Runner do
  @github_url Application.get_env(:gh_commits, :github_url)

  def run(%{limit: limit, repo: _} = params) do
    url_for(params)
    |> HTTPoison.get
    |> handle_response
    |> Poison.Parser.parse!
    |> Enum.take(limit)
    |> Enum.map(&wrap/1)
  end

  def run(%{help: true}), do: print_help()
  def run(_), do: print_help()

  defp url_for(%{repo: repo, sort: sort} = params) do
    query = if Map.has_key?(params, :creator) do
      %{creator: params.creator, sort: sort}
    else
      %{sort: sort}
    end

    "#{@github_url}/repos/#{repo}/commits?" <> URI.encode_query(query)
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 404}}) do
    IO.puts "404"
    IO.puts "Exiting..."
    System.halt(0)
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    IO.puts reason
    IO.puts "Exiting..."
    System.halt(0)
  end

  defp wrap(%{"sha" => sha, "commit" => %{"author" => %{"name" => author, "date" => date}, "message" => message}}) do
    %GhCommits.Commit{sha: sha, author: author, date: date, message: message}
  end

  defp print_help do
    IO.puts "Usage: issues (-c [<creator> | username]) (-s [<sort> | created]) -r <repo>"
    System.halt(0)
  end
end
