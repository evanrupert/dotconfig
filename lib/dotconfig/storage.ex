defmodule Dotconfig.Storage do

  @home System.get_env("HOME")
  @dotfile_path (@home <> "/.dotconfig.json")

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
    File.open!(@dotfile_path, [:write], fn file ->
      IO.write(file, Jason.encode!(%{"gist" => gist_id, "auth" => auth_token}, pretty: true))
    end)
  end

  defp replace_file_gist_id(new_gist_id) do
    File.open!(@dotfile_path, [:read, :write], fn file ->
      file
      |> IO.read(:all)
      |> Jason.decode!()
      |> Map.replace!("gist", new_gist_id)
      |> Jason.encode!(pretty: true)
      |> replace_file_content(file)
    end)

    :ok
  end

  defp replace_file_content(new_content, file) do
    file
    |> :file.position(:bof)
    |> :file.truncate()

    IO.write(file, new_content)
  end

end
