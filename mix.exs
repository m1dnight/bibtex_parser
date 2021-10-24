defmodule BibtexParser.MixProject do
  use Mix.Project

  @source_url "https://github.com/m1dnight/bibtex_parser"
  @version "0.2.0"

  def project do
    [
      app: :bibtex_parser,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  defp package do
    [
      description: "Library for parsing Bibtex files using NimbleParsec.",
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Christophe De Troyer"],
      licenses: ["GPL-3.0-or-later"],
      links: %{"GitHub" => @source_url}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def deps do
    [
      {:nimble_parsec, "~> 1.1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      formatters: ["html"]
    ]
  end
end
