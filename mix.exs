defmodule Dotconfig.MixProject do
  use Mix.Project

  def project do
    [
      app: :dotconfig,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
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
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2.0"},
      {:ok, "~> 2.3"}
    ]
  end

  defp escript do
    [
      main_module: Dotconfig,
      path: "bin/dotconfig"
    ]
  end
end
