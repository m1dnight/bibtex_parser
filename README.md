# Bibtex Parser

A parser for Bibtex files, implemented using NimbleParsec. Currently work in progress. Missing features are shown below.

## Example

```
defmodule BibtexParser do
  import BibtexParser.Parser

  def example do
    input = """
    @techreport{agha1985actors,
    title={Actors: A model of concurrent computation in distributed systems.},
    author={Agha, Gul A},
    year={1985},
    institution={MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB}
    }

    """

    result = parse_entry(input)

    # => {:ok,
    #  %{
    #    label: 'agha1985actors',
    #    tags: [
    #      title: 'Actors: A model of concurrent computation in distributed systems.',
    #      author: 'Agha, Gul A',
    #      year: '1985',
    #      institution: 'MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB'
    #    ],
    #    type: 'techreport'
    #  }}
  end
end

```

## Missing features

 - ~~an not parse full Bibtex files. ~~
   - No support for `@STRING`, `@PREAMBLE`, or `@COMMENT`.
 - ~~String concatenation (e.g., `author = "Jose" # "Valim"`) not supported yet.~~
 - ~~Documentation~~
 - ~~Unquoted tag values (e.g., a year)~~


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bibtex_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bibtex_parser, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bibtex_parser](https://hexdocs.pm/bibtex_parser).

