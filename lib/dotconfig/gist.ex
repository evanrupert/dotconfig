defmodule Dotconfig.Gist do
  alias Dotconfig.API

  @type gist_request :: %{
    files: %{required(binary()) => %{content: binary()}},
    public: boolean(),
    description: binary()
  }

  @spec get(binary()) :: map()
  def get(id) do
    API.get("gists/#{id}")
  end

  @spec create(gist_request) :: map()
  def create(gist_request) do
    API.post("gists", gist_request)
  end

end
