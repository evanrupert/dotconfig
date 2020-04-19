defmodule Dotconfig.CLI do

  @help """
  dotconfig [subcommand]

  Subcommands:
  \tinit\t\tInitalizes a new gist to store your dotfiles
  """

  @type cli_args :: %{
    help: boolean(),
    subcommand: atom(),
    args: list(binary())
  }

  @spec parse(list(binary())) :: {:ok, cli_args} | :error
  def parse(args) do
    {flags, commands, _} = OptionParser.parse(args, strict: [help: :boolean])

    case commands do
      [subcommand | args] when args != [] ->
        flags
        |> put_subcommand(subcommand)
        |> Map.put(:args, args)
        |> ok()
      [subcommand | []] ->
        flags
        |> put_subcommand(subcommand)
        |> ok()
      [] ->
        :error
    end
  end

  defp put_subcommand(flags, subcommand) do
    flags
    |> Map.new()
    |> Map.put(:subcommand, String.to_atom(subcommand))
  end

  defp ok(x), do: {:ok, x}

  def print_help do
    IO.puts @help
  end

end
