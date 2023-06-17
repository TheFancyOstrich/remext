defmodule Remext do
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

  def start(args) do
    {opts, args, invalid} = OptionParser.parse(args, strict: @options, aliases: @aliases)
    execute_path(opts[:help], opts, args, invalid)
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
    main(key, set, delete, search)
  end

  # If no argument but possibly opts
  defp execute_path(_, opts, [], _) do
    case opts[:search] do
      true ->
        IO.puts("List all keys")

      _ ->
        IO.puts("No argument")
        show_help()
    end
  end

  defp execute_path(_, _, _, _) do
    IO.puts("Invalid usage")
    show_help()
  end

  defp show_help do
    IO.puts("There is no help right now")
  end

  defp main(key, nil, false, false) do
    IO.puts("Show value at #{key}")
  end

  defp main(key, set, false, _) do
    IO.puts("Set value at #{key} to #{set}")
  end

  defp main(key, set, true, _) do
    IO.puts("Set value at #{key} to #{set} forcefully")
  end

  defp main(key, nil, true, _) do
    IO.puts("Delete value at #{key}")
  end

  defp main(key, _, _, true) do
    IO.puts("Search using key #{key}")
  end
end

Remext.start(System.argv())
