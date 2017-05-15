defmodule ListAsAProcess do
  def handle(data) do
    receive do
      {sender, {:push, number}} ->
        handle_push(sender, data, number)
      {sender, :pop} ->
        handle_pop(sender, data)
      {sender, :get_all} ->
        handle_get_all(sender, data)
    end
  end

  defp handle_push(sender, data, number) do
    send sender, {:ok}
    handle(data ++ [number])
  end

  defp handle_pop(sender, [head | tail]) do
    send sender, {:ok, head}
    handle(tail)
  end

  defp handle_pop(sender, []) do
    send sender, {:ok, nil}
    handle([])
  end

  defp handle_get_all(sender, data) do
    send sender, {:ok, data}
    handle(data)
  end

  def spawn_list(initial) when is_list(initial) do
    pid = spawn(__MODULE__, :handle, [initial])
    {:ok, pid}
  end

  def spawn_list(_), do: {:error, "Initial value must be a list"}
  def spawn_list, do: spawn_list([])

  def push(list_pid, value) do
    send list_pid, {self(), {:push, value}}
    receive do
      {:ok} -> true
    end
  end

  def pop(list_pid) do
    send list_pid, {self(), :pop}
    receive do
      {:ok, message } -> message
    end
  end

  def get_all(list_pid) do
    send list_pid, {self(), :get_all}
    receive do
      {:ok, message} -> message
    end
  end
end
