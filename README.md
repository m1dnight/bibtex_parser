# Bibtex Parser

[![Module Version](https://img.shields.io/hexpm/v/bibtex_parser.svg)](https://hex.pm/packages/bibtex_parser)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/bibtex_parser/)
[![Total Download](https://img.shields.io/hexpm/dt/bibtex_parser.svg)](https://hex.pm/packages/bibtex_parser)
[![License](https://img.shields.io/hexpm/l/bibtex_parser.svg)](https://github.com/m1dnight/bibtex_parser/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/m1dnight/bibtex_parser.svg)](https://github.com/m1dnight/bibtex_parser/commits/master)

A parser for Bibtex files, implemented using NimbleParsec. Currently work in progress. Missing features are shown below:

## Missing features

 - ~~Can not parse full Bibtex files.~~
 - No support for `@STRING`, `@PREAMBLE`, or `@COMMENT`.
 - ~~String concatenation (e.g., `author = "Jose" # "Valim"`) not supported yet.~~
 - ~~Documentation~~
 - ~~Unquoted tag values (e.g., a year)~~

## Example

```elixir
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
You can use `&Parser.parse_entries/1` to parse the contents of a file containing multiple BibTeX entries.
Assume you have the following BibTeX file.

```elixir
@incollection{spidersjs2,
    title={Parallel and Distributed Web Programming with Actors},
    author={Myter, Florian and Scholliers, Christophe and De Meuter, Wolfgang},
    booktitle={Programming with Actors: State-of-the-Art and Research Perspectives},
    pages={3--31},
    year={2018},
    publisher={Springer International Publishing}
}

@inproceedings{DBLP:conf/cbse/RusselloMD08,
    author    = {Giovanni Russello and
            Leonardo Mostarda and
            Naranker Dulay},
    editor    = {Michel R. V. Chaudron and
            Clemens A. Szyperski and
            Ralf H. Reussner},
    title     = {{ESCAPE:} {A} Component-Based Policy Framework for Sense and React
            Applications},
    booktitle = {Component-Based Software Engineering, 11th International Symposium,
            {CBSE} 2008, Karlsruhe, Germany, October 14-17, 2008. Proceedings},
    series    = {Lecture Notes in Computer Science},
    volume    = {5282},
    pages     = {212--229},
    publisher = {Springer},
    year      = {2008},
    url       = {https://doi.org/10.1007/978-3-540-87891-9\_14},
    doi       = {10.1007/978-3-540-87891-9\_14},
    timestamp = {Tue, 14 May 2019 10:00:47 +0200},
    biburl    = {https://dblp.org/rec/conf/cbse/RusselloMD08.bib},
    bibsource = {dblp computer science bibliography, https://dblp.org}
}
```

Parse it as follows.

```iex
iex(1)> input = File.read!("test/large.bib") 
iex(2)> {entries, rem} = BibtexParser.Parser.parse_entries(input)
{[
   %{
     label: "spidersjs2",
     tags: [
       title: "Parallel and Distributed Web Programming with Actors",
       author: "Myter, Florian and Scholliers, Christophe and De Meuter, Wolfgang",
       booktitle: "Programming with Actors: State-of-the-Art and Research Perspectives",
       pages: "3--31",
       year: "2018",
       publisher: "Springer International Publishing"
     ],
     type: "incollection"
   },
   %{
     label: "DBLP:conf/cbse/RusselloMD08",
     tags: [
       author: "Giovanni Russello and Leonardo Mostarda and Naranker Dulay",
       editor: "Michel R. V. Chaudron and Clemens A. Szyperski and Ralf H. Reussner",
       title: "{ESCAPE:} {A} Component-Based Policy Framework for Sense and React Applications",
       booktitle: "Component-Based Software Engineering, 11th International Symposium, {CBSE} 2008, Karlsruhe, Germany, October 14-17, 2008. Proceedings",
       series: "Lecture Notes in Computer Science",
       volume: "5282",
       pages: "212--229",
       publisher: "Springer",
       year: "2008",
       url: "https://doi.org/10.1007/978-3-540-87891-9\\_14",
       doi: "10.1007/978-3-540-87891-9\\_14",
       timestamp: "Tue, 14 May 2019 10:00:47 +0200",
       biburl: "https://dblp.org/rec/conf/cbse/RusselloMD08.bib",
       bibsource: "dblp computer science bibliography, https://dblp.org"
     ],
     type: "inproceedings"
   }
 ], ""}
```
## Installation

The package can be installed by adding `:bibtex_parser` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bibtex_parser, "~> 0.2.1"}
  ]
end
```

## Copyright and License

Copyright (c) 2018 Christophe De Troyer

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
