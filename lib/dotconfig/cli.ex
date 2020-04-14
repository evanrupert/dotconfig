defmodule Dotconfig.CLI do

  @help """
  dotconfig [subcommand]

  Subcommands:
  \tinit\t\tInitalizes a new gist to store your dotfiles
  """

  @type cli_args :: %{
    help: boolean(),
    subcommand: atom()
  }

  @spec parse(list(binary())) :: {:ok, cli_args} | :error
  def parse(args) do
    {flags, commands, _} = OptionParser.parse(args, strict: [help: :boolean])

    if length(commands) < 1 do
      :error
    else
      {:ok, put_subcommand_into_flags(flags, commands)}
    end
  end

  def print_help do
    IO.puts @help
  end

  defp put_subcommand_into_flags(flags, commands) do
    subcommand =
      commands
      |> List.first()
      |> String.to_atom()

    flags
    |> Map.new()
    |> Map.put(:subcommand, subcommand)
  end

end
