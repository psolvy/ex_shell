defmodule ExShell.TasksTest do
  use ExShellWeb.ConnCase, async: true

  alias ExShell.Tasks

  describe "validate_and_sort/1" do
    test "it returns tasks in right order with existing tasks" do
      params = %{
        "tasks" => [
          %{"name" => "task-1", "command" => "touch /tmp/file1"},
          %{"name" => "task-2", "command" => "cat /tmp/file1", "requires" => ["task-3"]},
          %{
            "name" => "task-3",
            "command" => "echo 'Hello World!' > /tmp/file1",
            "requires" => ["task-1"]
          },
          %{"name" => "task-4", "command" => "rm /tmp/file1", "requires" => ["task-2", "task-3"]}
        ]
      }

      assert {:ok,
              [
                %{"command" => "touch /tmp/file1", "name" => "task-1"},
                %{
                  "command" => "echo 'Hello World!' > /tmp/file1",
                  "name" => "task-3",
                  "requires" => ["task-1"]
                },
                %{"command" => "cat /tmp/file1", "name" => "task-2", "requires" => ["task-3"]},
                %{
                  "command" => "rm /tmp/file1",
                  "name" => "task-4",
                  "requires" => ["task-2", "task-3"]
                }
              ]} = Tasks.validate_and_sort(params)
    end

    test "it returns tasks in right order with existing loop" do
      params = %{
        "tasks" => [
          %{"name" => "task-1", "command" => "touch /tmp/file1", "requires" => ["task-2"]},
          %{"name" => "task-2", "command" => "touch /tmp/file2", "requires" => ["task-1"]}
        ]
      }

      assert {
               :ok,
               [
                 %{"command" => "touch /tmp/file2", "name" => "task-2", "requires" => ["task-1"]},
                 %{
                   "command" => "touch /tmp/file1",
                   "name" => "task-1",
                   "requires" => ["task-2"]
                 }
               ]
             } = Tasks.validate_and_sort(params)
    end

    test "it returns error without tasks" do
      params = %{}

      assert :error = Tasks.validate_and_sort(params)
    end

    test "it returns error with bad tasks" do
      params = %{"tasks" => ""}

      assert :error = Tasks.validate_and_sort(params)
    end
  end
end
