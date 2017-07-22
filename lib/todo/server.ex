defmodule Todo.Server do
  use GenServer

  # Client

  def start(to_list_title) do
    {:ok, _} = GenServer.start_link(__MODULE__, to_list_title)
  end

  def add_entry(pid, new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  # Server

  def init(title) do
    {:ok, {title, Todo.Database.get(title) || Todo.List.new}}
  end

  def handle_cast({:add_entry, new_entry}, {title, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(title, new_state)
    {:noreply, {title, new_state}}
  end

  def handle_call({:entries, date}, _caller, {title, state}) do
    todo_list = Todo.Database.get(title)
    {:reply, Todo.List.entries(todo_list, date), state}
  end
end
