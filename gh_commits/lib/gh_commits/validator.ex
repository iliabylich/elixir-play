defmodule GhCommits.Validator do
  @moduledoc """
  Internal module for validating provided CLI argument.
  """

  @doc """
  Validates provided map of commands and returns generated error messages.

  ## Examples

      iex> GhCommits.Validator.validate(%{repo: 123})
      ["Wrong argument type repo: 123"]
      iex> GhCommits.Validator.validate(%{limit: "25"})
      ["Wrong argument type repo: \"25\""]
      iex> GhCommits.Validator.validate(%{unsupported: :unknown})
      ["Unknown command validate"]
  """
  def validate(map) do
    map
    |> Enum.map(&validate_one/1)
    |> Enum.filter(&has_error?/1)
    |> Enum.map(&GhCommits.Validator.ErrorMessage.build/1)
  end

  defp validate_one({:help, true}), do: :ok
  defp validate_one({:repo, repo})       when is_binary(repo),    do: :ok
  defp validate_one({:creator, creator}) when is_binary(creator), do: :ok
  defp validate_one({:sort, sort})       when is_binary(sort),    do: :ok
  defp validate_one({:limit, limit})     when is_integer(limit),  do: :ok

  defp validate_one({:help,    value}), do: {:wrong_argument_type, :help,    value}
  defp validate_one({:repo,    value}), do: {:wrong_argument_type, :repo,    value}
  defp validate_one({:creator, value}), do: {:wrong_argument_type, :creator, value}
  defp validate_one({:sort,    value}), do: {:wrong_argument_type, :sort,    value}
  defp validate_one({:limit,   value}), do: {:wrong_argument_type, :limit,   value}

  defp validate_one({command, _}), do: {:unknown_command, command}

  defp has_error?(:ok), do: false
  defp has_error?(_),   do: true

  defmodule ErrorMessage do
    @moduledoc """
    Internal module for enerating error messages depending on error cases.
    """

    @doc """
    Generates an error message for provided paramter metadata.
    """
    def build({:wrong_argument_type, command, value}) do
      "Wrong argument type #{command}: #{inspect(value)}"
    end

    def build({:unknown_command, command}) do
      "Unknown command #{command}"
    end
  end
end
