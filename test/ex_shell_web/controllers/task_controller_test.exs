defmodule ExShellWeb.TaskControllerTest do
  use ExShellWeb.ConnCase, async: true

  describe "execute/2" do
    test "it renders right order with existing tasks", %{conn: conn} do
      params = %{
        tasks: [
          %{name: "task-1", command: "touch /tmp/file1"},
          %{name: "task-2", command: "cat /tmp/file1", requires: ["task-3"]},
          %{name: "task-3", command: "echo 'Hello World!' > /tmp/file1", requires: ["task-1"]},
          %{name: "task-4", command: "rm /tmp/file1", requires: ["task-2", "task-3"]}
        ]
      }

      response = post(conn, Routes.task_path(conn, :execute), params)

      assert %{
               "tasks" => [
                 %{"command" => "touch /tmp/file1", "name" => "task-1"},
                 %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3"},
                 %{"command" => "cat /tmp/file1", "name" => "task-2"},
                 %{"command" => "rm /tmp/file1", "name" => "task-4"}
               ]
             } = json_response(response, 200)
    end

    test "it renders right script with right params", %{conn: conn} do
      params = %{
        tasks: [
          %{name: "task-1", command: "touch /tmp/file1"},
          %{name: "task-2", command: "cat /tmp/file1", requires: ["task-3"]},
          %{name: "task-3", command: "echo 'Hello World!' > /tmp/file1", requires: ["task-1"]},
          %{name: "task-4", command: "rm /tmp/file1", requires: ["task-2", "task-3"]}
        ]
      }

      response = post(conn, Routes.task_path(conn, :execute) <> "?script=1", params)

      assert %{
               "script" =>
                 "#!/usr/bin/env bash\ntouch /tmp/file1\necho 'Hello World!' > /tmp/file1\ncat /tmp/file1\nrm /tmp/file1\n"
             } = json_response(response, 200)
    end

    test "it renders right error without tasks", %{conn: conn} do
      params = %{}

      response = post(conn, Routes.task_path(conn, :execute), params)

      assert %{"errors" => %{"detail" => "Unprocessable Entity"}} = json_response(response, 422)
    end
  end
end
