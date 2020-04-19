defmodule Dotconfig do
  alias Dotconfig.{CLI, Gist, Storage}

  import OK, only: [success: 1, failure: 1]

  def main(args) do
    case CLI.parse(args) do
      {:ok, args} ->
        handle_subcommands(args)
      :error ->
        invalid()
    end
  end

  defp handle_subcommands(args) do
    case args.subcommand do
      :init ->
        initialize()
      :add ->
        add(args)
      _ ->
        invalid()
    end
  end

  defp initialize do
    auth_token = ask_for_token()
    with {:ok, gist_id} <- Gist.create_initial(auth_token) do
      Storage.initialize(auth_token, gist_id)

      IO.puts """
      #{IO.ANSI.green()}
      Initialized new gist with id: #{IO.ANSI.cyan()}#{gist_id}#{IO.ANSI.green()}
      Saved new configuration file to #{IO.ANSI.yellow()}#{Storage.filepath}#{IO.ANSI.green()}
      You are ready to start tracking dotfiles
      #{IO.ANSI.reset()}
      """
    else
      {:error, reason} ->
        IO.puts "Failed to create gist with reason: #{reason}"
    end
  end

  defp add(args) do
    [filepath | []] = args.args

    case Gist.add_file(filepath) do
      success(_) ->
        Storage.add_file(filepath)
      failure(reason) ->
        IO.puts(IO.ANSI.red <> reason <> IO.ANSI.reset)
    end
  end

  defp ask_for_token do
    IO.gets("GitHub Personal Access Token: ")
    |> String.trim()
  end

  defp invalid do
    IO.puts "Invalid Command"
    CLI.print_help()
    exit(:shutdown)
  end
end
