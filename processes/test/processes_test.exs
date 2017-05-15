defmodule ListAsAProcessTest do
  use ExUnit.Case

  test "it contains an empty list by default" do
    {:ok, list_pid} = ListAsAProcess.spawn_list
    assert ListAsAProcess.get_all(list_pid) == []
  end

  test "it can be populated with custom initial value" do
    {:ok, list_pid} = ListAsAProcess.spawn_list([1, 2, 3])
    assert ListAsAProcess.get_all(list_pid) == [1, 2, 3]
  end

  test "it return error when provided custom value is not a list" do
    assert ListAsAProcess.spawn_list("not-a-list") == {:error, "Initial value must be a list"}
  end

  test "it saves any items inside by .push" do
    {:ok, list_pid} = ListAsAProcess.spawn_list
    ListAsAProcess.push(list_pid, 1)
    ListAsAProcess.push(list_pid, 2)
    ListAsAProcess.push(list_pid, 3)
    assert ListAsAProcess.get_all(list_pid) == [1, 2, 3]
  end

  test "it extracts items from the end by .pop" do
    {:ok, list_pid} = ListAsAProcess.spawn_list([1, 2, 3])
    assert ListAsAProcess.pop(list_pid) == 1
    assert ListAsAProcess.get_all(list_pid) == [2, 3]

    assert ListAsAProcess.pop(list_pid) == 2
    assert ListAsAProcess.get_all(list_pid) == [3]

    assert ListAsAProcess.pop(list_pid) == 3
    assert ListAsAProcess.get_all(list_pid) == []

    assert ListAsAProcess.pop(list_pid) == nil
    assert ListAsAProcess.get_all(list_pid) == []
  end
end
