defmodule Remext do
  use Bakeware.Script
  @moduledoc "Main file"
  @version Mix.Project.config()[:version]
  @options [
    help: :boolean,
    set: :string,
    delete: :boolean,
    search: :boolean
  ]
  @aliases [
    h: :help,
    s: :set,
    d: :delete,
    q: :search
  ]

  @impl Bakeware.Script
  def main(args) do
    {opts, args, invalid} = OptionParser.parse(args, strict: @options, aliases: @aliases)
    execute_path(opts[:help], opts, args, invalid)
    0
  end

  # Print help regardless of other input if --help is included
  defp execute_path(true, _, _, _) do
    show_help()
  end

  # Print invalid input and then help message if any invalid flag is included
  defp execute_path(_, _, _, [head | tail]) do
    [head | tail] |> Enum.each(fn {x, _} -> IO.puts("Invalid option #{x}") end)
    show_help()
  end

  # More than one argument
  defp execute_path(_, _, [_, _ | _], _) do
    IO.puts("Too many arguments")
    show_help()
  end

  # Valid usage
  defp execute_path(_, opts, [key], _) do
    set = opts[:set]
    delete = opts[:delete] || false
    search = opts[:search] || false
    execute(key, set, delete, search)
  end

  # If no argument but possibly opts
  defp execute_path(_, opts, [], _) do
    case opts[:search] do
      true ->
        JsonManager.search(nil) |> Enum.each(fn {x, y} -> IO.puts("#{x}:#{y}") end)

      _ ->
        IO.puts("No argument")
        show_help()
    end
  end

  defp execute_path(_, _, _, _) do
    IO.puts("Invalid usage")
    show_help()
  end

  defp execute(key, nil, false, false) do
    IO.puts(JsonManager.get_value(key))
  end

  defp execute(key, nil, true, _) do
    IO.puts(JsonManager.delete_value(key))
  end

  defp execute(key, nil, false, true) do
    JsonManager.search(key) |> Enum.each(fn {x, y} -> IO.puts("#{x}:#{y}") end)
  end

  defp execute(key, set, false, _) do
    IO.puts(JsonManager.set_value(key, set, false))
  end

  defp execute(key, set, true, _) do
    IO.puts(JsonManager.set_value(key, set, true))
  end

  defp show_help do
    IO.puts("Remext #{@version}")
    IO.puts("Usage: remext [key] [options]")
    IO.puts("Options:")
    IO.puts("  -h, --help           Print help message")
    IO.puts("  -s, --set value      Set new value at key")

    IO.puts(
      "  -d, --delete         Delete value at key. Use with --set to override the given key"
    )

    IO.puts(
      "  -q, --search         Show all key pairs which includes the given phrase in its key. If no phrase is given all keys will be listed"
    )
  end
end
