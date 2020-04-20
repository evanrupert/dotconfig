defmodule Dotconfig do
  require OK

  alias Dotconfig.{CLI, Commands}

  def main(args) do
    case CLI.parse(args) do
      {:ok, args} ->
        handle_subcommands(args)
      :error ->
        display_invalid()
    end
  end

  defp handle_subcommands(args) do
    result = case args.subcommand do
      :init ->
        Commands.initialize()
      :add ->
        Commands.add(args)
      _ ->
        OK.failure("#{args.subcommand} is not a valid command")
    end

    with OK.failure(reason) <- result do
      IO.puts """
      #{IO.ANSI.red()}
      #{inspect reason}
      #{IO.ANSI.reset()}
      """
    end
  end

  defp display_invalid() do
    IO.puts "Invalid Command"
    CLI.print_help()
    exit(:shutdown)
  end
end
