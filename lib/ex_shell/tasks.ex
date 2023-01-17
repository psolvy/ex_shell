defmodule ExShell.Tasks do
  @moduledoc """
    Module provides topological sorting of tasks with dependencies
  """

  @spec validate_and_sort(any()) :: {:ok, list()} | :error
  def validate_and_sort(%{"tasks" => tasks}) when is_list(tasks), do: {:ok, sort(tasks)}
  def validate_and_sort(_params), do: :error

  @spec sort(list()) :: list()
  defp sort(tasks) do
    tasks_map = transform_into_map(tasks)

    {_, sorted} =
      Enum.reduce(tasks, {MapSet.new(), []}, fn task, {visited, sorted} ->
        visit(task, tasks_map, visited, sorted)
      end)

    Enum.reverse(sorted)
  end

  @spec transform_into_map(list()) :: map()
  defp transform_into_map(tasks),
    do: Enum.reduce(tasks, %{}, fn task, acc -> Map.put(acc, task["name"], task) end)

  @spec visit(map(), map(), MapSet.t(), list()) :: {MapSet.t(), list()}
  defp visit(task, tasks_map, visited, sorted) do
    if MapSet.member?(visited, task["name"]) do
      {visited, sorted}
    else
      visited = MapSet.put(visited, task["name"])
      {visited, sorted} = visit_requires(task, tasks_map, visited, sorted)

      {visited, [task | sorted]}
    end
  end

  @spec visit_requires(map(), map(), MapSet.t(), list()) :: {MapSet.t(), list()}
  defp visit_requires(%{"requires" => requires}, tasks_map, visited, sorted) do
    Enum.reduce(requires, {visited, sorted}, fn required_task_name, {visited, sorted} ->
      visit(tasks_map[required_task_name], tasks_map, visited, sorted)
    end)
  end

  defp visit_requires(_task, _tasks_map, visited, sorted), do: {visited, sorted}
end
