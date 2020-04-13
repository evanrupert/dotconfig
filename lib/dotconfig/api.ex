defmodule Dotconfig.API do
  @base_url "https://api.github.com/"
  @api_token System.get_env("GITHUB_GIST_TOKEN")

  @spec get(binary()) :: {:ok, map()} | {:error, binary()}
  def get(method) do
    headers = [
      "Authorization": "Bearer #{@api_token}",
      "Accept": "application/vnd.github.v3+json"
    ]

    HTTPoison.get(@base_url <> method, headers)
    |> parse_resp()
  end

  @spec post(binary(), map()) :: {:ok, map()} | {:error, binary()}
  def post(method, body) do
    headers = [
      "Authorization": "Bearer #{@api_token}",
      "Accept": "application/vnd.github.v3+json",
      "Content-Type": "application/json"
    ]

    HTTPoison.post(@base_url <> method, Jason.encode!(body), headers)
    |> parse_resp()
  end

  defp parse_resp(response) do
    with {:ok, resp} <- response,
         json <- Jason.decode(resp.body)
      do
      {:ok, json}
    else
      {:error, %Jason.DecodeError{}} ->
        {:error, "Json Decode Error"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

end