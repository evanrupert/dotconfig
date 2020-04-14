defmodule Dotconfig.Gist do
  alias Dotconfig.API

  @type gist_request :: %{
    files: %{required(binary()) => %{content: binary()}},
    public: boolean(),
    description: binary()
  }

  @spec create_initial(binary()) :: {:ok, binary()} | {:error, binary()}
  def create_initial(auth_token) do
    gist_request = %{
      files: %{
        "Dotconfig" => %{
          content: "Dotfile storage gist"
        }
      },
      public: false,
      description: "Dotfile storage gist"
    }

    case create(gist_request, auth_token) do
      {:ok, resp} ->
        {:ok, resp["id"]}
      x ->
        x
    end
  end

  @spec get(binary(), binary()) :: API.response
  defp get(id, auth_token) do
    API.get("gists/#{id}", auth_token)
  end

  @spec create(gist_request(), binary()) :: API.response()
  defp create(gist_request, auth_token) do
    API.post("gists", auth_token, gist_request)
  end

end
