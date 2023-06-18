defmodule JsonManager do
  @moduledoc "Json manager. Read and write json data"
  @filepath Application.compile_env(:remext, :filepath, "./remext.json")

  def get_value(key) do
    json_data = read_file()
    value = json_data[key]

    if value == nil do
      "'#{key}' is empty"
    else
      value
    end
  end

  def set_value(key, value, false) do
    json_data = read_file()

    if json_data[key] != nil do
      "Value at '#{key}' already set. Use --delete to override"
    else
      json_data |> Map.put(key, value) |> save_data()
      value
    end
  end

  def set_value(key, value, true) do
    read_file() |> Map.put(key, value) |> save_data()
  end

  def delete_value(key) do
    json_data = read_file()
    deleted = json_data[key]
    json_data |> Map.delete(key) |> save_data()
    deleted
  end

  def search(nil) do
    json_data = read_file()

    json_data
    |> Map.keys()
    |> Enum.map(fn x -> {x, json_data[x]} end)
  end

  def search(phrase) do
    json_data = read_file()

    json_data
    |> Map.keys()
    |> Enum.filter(&Regex.match?(~r/#{Regex.escape(phrase)}/i, &1))
    |> Enum.map(fn x -> {x, json_data[x]} end)
  end

  defp read_file() do
    read_file(File.exists?(@filepath))
  end

  defp read_file(true) do
    {:ok, json_data} = File.read(@filepath)
    Jason.decode!(json_data)
  end

  defp read_file(false) do
    Path.expand(@filepath) |> Path.dirname() |> File.mkdir_p()
    File.write(@filepath, "{}")
    Jason.decode!("{}")
  end

  defp save_data(json_data) do
    File.write(@filepath, Jason.encode!(json_data))
  end
end
