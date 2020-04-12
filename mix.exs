defmodule Dotconfig.MixProject do
  use Mix.Project

  def project do
    [
      app: :dotconfig,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:httpoison],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
    ]
  end
end
