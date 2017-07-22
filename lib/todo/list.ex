defmodule Todo.List do
  defstruct auto_id: 1, entries: Map.new

  def new, do: %Todo.List{}

  def add_entry(%Todo.List{entries: entries, auto_id: auto_id} = todo_list, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)

    %Todo.List{todo_list |
      entries: new_entries,
      auto_id: auto_id + 1
    }
  end

  def entries(%Todo.List{entries: entries}, date) do
    entries
    |> Enum.filter(fn({_, entry}) -> entry.date == date end)
  end
end
