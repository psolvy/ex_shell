defmodule ExShellWeb.TaskController do
  use ExShellWeb, :controller

  alias ExShell.Tasks

  def execute(conn, params) do
    case Tasks.validate_and_sort(params) do
      :error ->
        conn
        |> put_status(422)
        |> put_view(ExShellWeb.ErrorView)
        |> render(:"422")

      {:ok, tasks} ->
        script = Map.get(params, "script", false)

        conn
        |> put_status(200)
        |> render_success(tasks, script)
    end
  end

  defp render_success(conn, tasks, false), do: render(conn, "tasks.json", %{tasks: tasks})
  defp render_success(conn, tasks, _script), do: render(conn, "script.json", %{tasks: tasks})
end
