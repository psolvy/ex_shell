defmodule ExShellWeb.TaskView do
  use ExShellWeb, :view

  def render("tasks.json", %{tasks: tasks}),
    do: %{tasks: render_many(tasks, __MODULE__, "task.json")}

  def render("task.json", %{task: task}),
    do: %{name: task["name"], command: task["command"]}

  def render("script.json", %{tasks: tasks}) do
    script = """
    #!/usr/bin/env bash
    #{Enum.map_join(tasks, "\n", & &1["command"])}
    """

    %{script: script}
  end
end
