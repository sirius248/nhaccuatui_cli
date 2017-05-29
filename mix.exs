defmodule NhaccuatuiCli.Mixfile do
  use Mix.Project

  def project do
    [app: :nhaccuatui_cli,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: NhaccuatuiCli],
     deps: deps()]
  end

  def application do
    [applications: [:httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 0.11.1"},
      {:poison, "~> 3.0"},
      {:floki, "~> 0.17.0"}]
  end
end
