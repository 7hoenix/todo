defmodule Todo.Database do
  use GenServer

  # Client

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: :database_server)
  end

  def store(key, data) do
    GenServer.cast(:database_server, {:store, key, data})
  end

  def get(key) do
    GenServer.call(:database_server, {:get, key})
  end

  # Server

  def init(db_folder) do
    File.mkdir_p(db_folder)

    workers = Enum.reduce([0, 1, 2], Map.new, fn(i, acc) ->
      {:ok, workers_pid} = Todo.DatabaseWorker.start(db_folder)
      Map.put(acc, i, workers_pid)
    end)

    {:ok, workers}
  end

  def handle_cast({:store, key, data}, workers) do
    worker_pid = get_worker(workers, key)
    Todo.DatabaseWorker.store(worker_pid, key, data)

    {:noreply, workers}
  end

  def handle_call({:get, key}, caller, workers) do
    worker_pid = get_worker(workers, key)
    GenServer.reply(caller, Todo.DatabaseWorker.get(worker_pid, key))

    {:noreply, workers}
  end

  defp get_worker(workers, k) do
    index_of_worker = :erlang.phash2(k, map_size(workers))
    Map.get(workers, index_of_worker)
  end
end
