defmodule BibtexParser.Test.Entry do
  use ExUnit.Case
  doctest BibtexParser

  test "Simple Entry" do
    input = "@book{foo, year = 1234}"

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entry(input)

    expected = [
      %AST.Entry{
        entry_type: "book",
        fields: [
          %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 1234}]}
        ],
        internal_key: "foo"
      }
    ]

    assert expected == ast
  end

  test "Simple Entry with newlines" do
    input = """
    @book      {
      foo
      ,

      year    =        1234

    }




    """

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entry(input)

    expected = [
      %AST.Entry{
        entry_type: "book",
        fields: [
          %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 1234}]}
        ],
        internal_key: "foo"
      }
    ]

    assert expected == ast
  end

  test "Entry with braced fields" do
    input = "@book{foo, year = {1234}}"

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entry(input)

    expected = [
      %AST.Entry{
        entry_type: "book",
        fields: [
          %AST.Field{
            key: %AST.Key{content: "year"},
            value: [%AST.BracedString{content: [%AST.Number{content: 1234}]}]
          }
        ],
        internal_key: "foo"
      }
    ]

    assert expected == ast
  end

  test "Entry with quoted fields" do
    input = "@book{foo, year = \"1234\"}"

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entry(input)

    expected = [
      %AST.Entry{
        entry_type: "book",
        fields: [
          %AST.Field{
            key: %AST.Key{content: "year"},
            value: [%AST.QuotedString{content: [%AST.Number{content: 1234}]}]
          }
        ],
        internal_key: "foo"
      }
    ]

    assert expected == ast
  end

  test "Entry with multiple fields" do
    input = "@book{foo, year = \"1234\", author = {The Author is This}}"

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entry(input)

    expected = [
      %AST.Entry{
        entry_type: "book",
        fields: [
          %AST.Field{
            key: %AST.Key{content: "year"},
            value: [%AST.QuotedString{content: [%AST.Number{content: 1234}]}]
          },
          %AST.Field{
            key: %AST.Key{content: "author"},
            value: [%AST.BracedString{content: [%AST.PlainText{content: "The Author is This"}]}]
          }
        ],
        internal_key: "foo"
      }
    ]

    assert expected == ast
  end

  test "Sample Entry" do
    input = ~s(@inproceedings{DBLP:conf/cbse/RusselloMD08,
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
})
    {:ok, ast, _, _, _, _} = BibtexParser.AST.entry(input)

    expected = [
      %AST.Entry{
        entry_type: "inproceedings",
        fields: [
          %AST.Field{
            key: %AST.Key{content: "author"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{
                    content:
                      "Giovanni Russello and\n            Leonardo Mostarda and\n            Naranker Dulay"
                  }
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "editor"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{
                    content:
                      "Michel R. V. Chaudron and\n            Clemens A. Szyperski and\n            Ralf H. Reussner"
                  }
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "title"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.BracedString{content: [%AST.PlainText{content: "ESCAPE:"}]},
                  %AST.PlainText{content: " "},
                  %AST.BracedString{content: [%AST.PlainText{content: "A"}]},
                  %AST.PlainText{
                    content:
                      " Component-Based Policy Framework for Sense and React\n            Applications"
                  }
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "booktitle"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{
                    content:
                      "Component-Based Software Engineering, 11th International Symposium,\n            "
                  },
                  %AST.BracedString{content: [%AST.PlainText{content: "CBSE"}]},
                  %AST.PlainText{
                    content: " 2008, Karlsruhe, Germany, October 14-17, 2008. Proceedings"
                  }
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "series"},
            value: [
              %AST.BracedString{
                content: [%AST.PlainText{content: "Lecture Notes in Computer Science"}]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "volume"},
            value: [%AST.BracedString{content: [%AST.Number{content: 5282}]}]
          },
          %AST.Field{
            key: %AST.Key{content: "pages"},
            value: [%AST.BracedString{content: [%AST.Range{from: 212, to: 229}]}]
          },
          %AST.Field{
            key: %AST.Key{content: "publisher"},
            value: [%AST.BracedString{content: [%AST.PlainText{content: "Springer"}]}]
          },
          %AST.Field{
            key: %AST.Key{content: "year"},
            value: [%AST.BracedString{content: [%AST.Number{content: 2008}]}]
          },
          %AST.Field{
            key: %AST.Key{content: "url"},
            value: [
              %AST.BracedString{
                content: [%AST.PlainText{content: "https://doi.org/10.1007/978-3-540-87891-9_14"}]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "doi"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.Number{content: 10},
                  %AST.PlainText{content: ".1007/978-3-540-87891-9_14"}
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "timestamp"},
            value: [
              %AST.BracedString{
                content: [%AST.PlainText{content: "Tue, 14 May 2019 10:00:47 +0200"}]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "biburl"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{content: "https://dblp.org/rec/conf/cbse/RusselloMD08.bib"}
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{content: "bibsource"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{content: "dblp computer science bibliography, https://dblp.org"}
                ]
              }
            ]
          }
        ],
        internal_key: "DBLP:conf/cbse/RusselloMD08"
      }
    ]

    assert expected == ast
  end
end
