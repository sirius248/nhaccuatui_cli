defmodule NhaccuatuiCli.Mixfile do
  use Mix.Project

  def project do
    [app: :nct,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: NhaccuatuiCli],
     deps: deps()]
  end

  def application do
    [extra_applications: [:hackney, :httpoison, :logger, :table_rex]]
  end

  defp deps do
    [{:httpoison, "~> 0.11.1"},
      {:poison, "~> 3.0"},
      {:floki, "~> 0.17.0"},
      {:table_rex, "~> 0.10"}]
  end
end
