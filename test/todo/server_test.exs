defmodule Todo.ServerTest do
  use ExUnit.Case, async: true

  test "Stores an entry in the database" do
    my_list = Todo.List.new
    entry = %{title: "Go to work", date: {2017, 07, 26}}

    {:noreply, {name, new_state}} = Todo.Server.handle_cast({:add_entry, entry}, {"justins_list", my_list})

    assert name == "justins_list"
    assert new_state == %Todo.List{auto_id: 2, entries: %{1 => %{id: 1, title: "Go to work", date: {2017, 07, 26}}}}
  end
end
