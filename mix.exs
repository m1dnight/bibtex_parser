defmodule BibtexParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :bibtex_parser,
      version: "0.1.2",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  defp description do
    """
    Library for parsing BibTex files using NimbleParsec.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Christophe De Troyer"],
      licenses: ["GNU GPLv3"],
      links: %{"GitHub" => "https://github.com/m1dnight/bibtex_parser"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  def deps do
    [{:nimble_parsec, "~> 0.2"}, {:ex_doc, ">= 0.0.0", only: :dev}]
  end
end
