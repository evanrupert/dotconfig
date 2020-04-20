defmodule Dotconfig.API do
  require OK
  import OK, only: [~>>: 2]

  @base_url "https://api.github.com/"
  # @api_token System.get_env("GITHUB_GIST_TOKEN")

  @type response :: {:ok, map()} | {:error, binary()}

  @spec get(binary(), binary()) :: response
  def get(method, auth_token) do
    headers = [
      "Authorization": "Bearer #{auth_token}",
      "Accept": "application/vnd.github.v3+json"
    ]

    HTTPoison.get(@base_url <> method, headers)
    |> parse_resp()
  end

  @spec post(binary(), binary(), map()) :: response
  def post(method, auth_token, body) do
    headers = [
      "Authorization": "Bearer #{auth_token}",
      "Accept": "application/vnd.github.v3+json",
      "Content-Type": "application/json"
    ]

    HTTPoison.post(@base_url <> method, Jason.encode!(body), headers)
    |> parse_resp()
  end

  @spec patch(binary(), binary(), map()) :: response
  def patch(method, auth_token, body) do
    headers = [
      "Authorization": "Bearer #{auth_token}",
      "Accept": "application/vnd.github.v3+json",
      "Content-Type": "application/json"
    ]

    HTTPoison.patch(@base_url <> method, Jason.encode!(body), headers)
    |> parse_resp()
  end

  @spec parse_resp({:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}) :: {:ok, map()} | {:error, binary()}
  defp parse_resp( {:ok, %HTTPoison.Response{status_code: status, body: body}})
    when status in 200..300 do
    Jason.decode(body)
  end

  defp parse_resp({:ok, %HTTPoison.Response{body: body}}) do
    Jason.decode(body) ~>> (fn json -> {:error, json["message"]} end).()
  end

  defp parse_resp({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

end
