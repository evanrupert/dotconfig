defmodule Dotconfig.Gist do
  require OK
  import OK, only: [~>: 2]

  alias Dotconfig.{API, Storage}

  @type gist_create :: %{
    files: %{required(binary()) => %{content: binary()}},
    public: boolean(),
    description: binary()
  }

  @type gist_update :: %{
    optional(:files) => %{required(binary()) => %{content: binary()}},
    optional(:description) => binary()
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

    create(gist_request, auth_token)
    ~> Map.get("id")
  end

  @spec add_file(binary()) :: {:ok, map()} | {:error, binary()}
  def add_file(filepath) do
    OK.for do
      %{auth_token: token, gist_id: id} <- Storage.get_gist_info()
      content <- File.read(filepath)
      basename = Path.basename(filepath)
    after
      update(id, token, %{
        files: %{
          basename => %{
            content: content
          }
        }
      })
    end
  end

  @spec get(binary(), binary()) :: API.response
  defp get(id, auth_token) do
    API.get("gists/#{id}", auth_token)
  end

  @spec create(gist_create(), binary()) :: API.response()
  defp create(body, auth_token) do
    API.post("gists", auth_token, body)
  end

  @spec update(binary(), binary(), gist_update()) :: API.response()
  defp update(id, auth_token, body) do
    API.patch("gists/#{id}", auth_token, body)
  end

end
