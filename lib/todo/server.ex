defmodule Todo.Server do
  use GenServer

  # Client

  def start(to_list_name) do
    {:ok, _} = GenServer.start_link(__MODULE__, to_list_name)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  # Server

  def init(name) do
    {:ok, {name, Todo.List.new}}
  end

  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_call({:entries, date}, _caller, {name, state}) do
    todo_list = Todo.Database.get(name)
    {:reply, Todo.List.entries(todo_list, date), {name, state}}
  end
end
