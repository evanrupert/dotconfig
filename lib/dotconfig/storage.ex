defmodule Dotconfig.Storage do

  require OK
  import OK, only: [~>>: 2, ~>: 2]

  @home System.get_env("HOME")
  @dotfile_path (@home <> "/.dotconfig.json")

  @type gist_info :: %{
    auth_token: binary(),
    gist_id: binary()
  }

  @spec initialize(binary(), binary()) :: :ok
  def initialize(auth_token, gist_id) do
    if not File.exists?(@dotfile_path) do
      write_new_file(gist_id, auth_token)
    else
      replace_file_gist_id(gist_id)
      :ok
    end
  end

  def filepath do
    @dotfile_path
  end

  defp write_new_file(gist_id, auth_token) do
    write_dotfile(%{
      "gist_id" => gist_id,
      "auth_token" => auth_token
    })
  end

  defp replace_file_gist_id(new_gist_id) do
    update_dotfile(fn content ->
      Map.put(content, "gist_id", new_gist_id)
    end)
  end

  @spec get_gist_info :: {:ok, gist_info()} | {:error, binary()}
  def get_gist_info do
    OK.for do
      json <- read_dotfile()
      auth_token <- parse_field(json, "auth_token")
      gist_id <- parse_field(json, "gist_id")
    after
      %{auth_token: auth_token, gist_id: gist_id}
    end
  end

  defp parse_field(json, field) do
    case Map.get(json, field) do
      nil ->
        OK.failure("'#{field}' not found")
      value ->
        OK.success(value)
    end
  end

  @spec add_file(binary()) :: {:ok, binary()} | {:error, any()}
  def add_file(filepath) do
    update_dotfile(fn content ->
      Map.update(content, "files", [filepath], fn files ->
        if not Enum.member?(files, filepath) do
          [ filepath | files ]
        else
          files
        end
      end)
    end)
  end

  defp update_dotfile(f) do
    read_dotfile()
    ~> f.()
    ~>> write_dotfile()
  end

  defp read_dotfile do
    File.read(@dotfile_path)
    ~>> Jason.decode()
  end

  defp write_dotfile(content) do
    OK.for do
      content <- Jason.encode(content, pretty: true)
    after
      File.write(@dotfile_path, content)
    end
  end

end
