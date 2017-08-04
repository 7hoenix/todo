defmodule Todo.DatabaseWorker do
  use GenServer

  # Client

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  def store(worker, key, data) do
    GenServer.cast(worker, {:store, key, data})
  end

  def get(worker, key) do
    GenServer.call(worker, {:get, key})
  end

  # Server

  def init(db_folder) do
    File.mkdir_p(db_folder)
    {:ok, db_folder}
  end

  def handle_cast({:store, key, data}, db_folder) do
    spawn(fn ->
      file_name(db_folder, key)
      |> File.write!(:erlang.term_to_binary(data))
    end)

    {:noreply, db_folder}
  end

  def handle_call({:get, key}, caller, db_folder) do
    spawn(fn ->
      data = case File.read(file_name(db_folder, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

      GenServer.reply(caller, data)
    end)

    {:noreply, db_folder}
  end

  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"
end




