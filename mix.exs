defmodule Remext.MixProject do
  use Mix.Project

  def project do
    [
      app: :remext,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: Remext],
      releases: [{:remext, release()}]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Remext, []}
    ]
  end

  defp release do
    [
      overwrite: true,
      quiet: true,
      bakeware: [
        compression_level: 19
      ],
      steps: [:assemble, &Bakeware.assemble/1],
      strip_beams: Mix.env() == :release
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bakeware, "~> 0.2.4"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.2"}
    ]
  end
end
