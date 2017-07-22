defmodule Todo.Server do
  use GenServer

  # Client

  def start do
    {:ok, _} = GenServer.start_link(__MODULE__, Todo.List.new)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  # Server

  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  def handle_call({:entries, date}, _caller, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end
end
