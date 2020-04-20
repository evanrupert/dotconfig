defmodule Dotconfig.Commands do
  alias Dotconfig.{CLI, Gist, Storage}

  import OK, only: [success: 1, failure: 1]

  @spec initialize :: {:ok, any()} | {:error, binary()}
  def initialize do
    auth_token = ask_for_token()

    OK.for do
      gist_id <- Gist.create_initial(auth_token)
      _ <- Storage.initialize(auth_token, gist_id)
      _ <- Gist.add_file(Storage.filepath(), remove_initial: true)
    after
      IO.puts """
      #{IO.ANSI.green()}
      Initialized new gist with id: #{IO.ANSI.cyan()}#{gist_id}#{IO.ANSI.green()}
      Saved new configuration file to #{IO.ANSI.yellow()}#{Storage.filepath}#{IO.ANSI.green()}
      You are ready to start tracking dotfiles
      #{IO.ANSI.reset()}
      """
    end
  end

  @spec ask_for_token :: binary()
  defp ask_for_token do
    IO.gets("GitHub Personal Access Token: ")
    |> String.trim()
  end

  @spec add(CLI.cli_args()) :: :ok
  def add(args) do
    [filepath | []] = args.args

    case Gist.add_file(filepath) do
      success(_) ->
        Storage.add_file(filepath)
      failure(reason) ->
        IO.puts(IO.ANSI.red <> reason <> IO.ANSI.reset)
    end
  end
end
