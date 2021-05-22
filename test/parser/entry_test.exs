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
          %AST.Field{key: %AST.Key{value: "year"}, value: [%AST.Number{value: 1234}]}
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
          %AST.Field{key: %AST.Key{value: "year"}, value: [%AST.Number{value: 1234}]}
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
            key: %AST.Key{value: "year"},
            value: [%AST.BracedString{content: [%AST.Number{value: 1234}]}]
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
            key: %AST.Key{value: "year"},
            value: [%AST.QuotedString{content: [%AST.Number{value: 1234}]}]
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
            key: %AST.Key{value: "year"},
            value: [%AST.QuotedString{content: [%AST.Number{value: 1234}]}]
          },
          %AST.Field{
            key: %AST.Key{value: "author"},
            value: [%AST.BracedString{content: [%AST.PlainText{value: "The Author is This"}]}]
          }
        ],
        internal_key: "foo"
      }
    ]

    assert expected == ast
  end

  test "Sample Entry" do
    input = """
    @inproceedings{DBLP:conf/cbse/RusselloMD08,
    author = {Giovanni Russello and Leonardo Mostarda and Naranker Dulay},
    bibsource = {dblp computer science bibliography, https://dblp.org},
    biburl = {https://dblp.org/rec/conf/cbse/RusselloMD08.bib},
    booktitle = {Component-Based Software Engineering, 11th International Symposium, {CBSE} 2008, Karlsruhe, Germany, October 14-17, 2008. Proceedings},
    doi = {10.1007/978-3-540-87891-9\_14},
    editor = {Michel R. V. Chaudron and Clemens A. Szyperski and Ralf H. Reussner},
    pages = {212--229},
    publisher = {Springer},
    series = {Lecture Notes in Computer Science},
    timestamp = {Tue, 14 May 2019 10:00:47 +0200},
    title = {{ESCAPE:} {A} Component-Based Policy Framework for Sense and React Applications},
    url = {https://doi.org/10.1007/978-3-540-87891-9\_14},
    volume = {5282},
    year = {2008},
    }
    """

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entry(input)

    expected = [
      %AST.Entry{
        entry_type: "inproceedings",
        fields: [
          %AST.Field{
            key: %AST.Key{value: "author"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{
                    value: "Giovanni Russello and Leonardo Mostarda and Naranker Dulay"
                  }
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "bibsource"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{value: "dblp computer science bibliography, https://dblp.org"}
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "biburl"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{value: "https://dblp.org/rec/conf/cbse/RusselloMD08.bib"}
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "booktitle"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{
                    value: "Component-Based Software Engineering, 11th International Symposium, "
                  },
                  %AST.BracedString{content: [%AST.PlainText{value: "CBSE"}]},
                  %AST.PlainText{
                    value: " 2008, Karlsruhe, Germany, October 14-17, 2008. Proceedings"
                  }
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "doi"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.Number{value: 10},
                  %AST.PlainText{value: ".1007/978-3-540-87891-9_14"}
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "editor"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.PlainText{
                    value: "Michel R. V. Chaudron and Clemens A. Szyperski and Ralf H. Reussner"
                  }
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "pages"},
            value: [%AST.BracedString{content: [%AST.Range{from: 212, to: 229}]}]
          },
          %AST.Field{
            key: %AST.Key{value: "publisher"},
            value: [%AST.BracedString{content: [%AST.PlainText{value: "Springer"}]}]
          },
          %AST.Field{
            key: %AST.Key{value: "series"},
            value: [
              %AST.BracedString{
                content: [%AST.PlainText{value: "Lecture Notes in Computer Science"}]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "timestamp"},
            value: [
              %AST.BracedString{
                content: [%AST.PlainText{value: "Tue, 14 May 2019 10:00:47 +0200"}]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "title"},
            value: [
              %AST.BracedString{
                content: [
                  %AST.BracedString{content: [%AST.PlainText{value: "ESCAPE:"}]},
                  %AST.PlainText{value: " "},
                  %AST.BracedString{content: [%AST.PlainText{value: "A"}]},
                  %AST.PlainText{
                    value: " Component-Based Policy Framework for Sense and React Applications"
                  }
                ]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "url"},
            value: [
              %AST.BracedString{
                content: [%AST.PlainText{value: "https://doi.org/10.1007/978-3-540-87891-9_14"}]
              }
            ]
          },
          %AST.Field{
            key: %AST.Key{value: "volume"},
            value: [%AST.BracedString{content: [%AST.Number{value: 5282}]}]
          },
          %AST.Field{
            key: %AST.Key{value: "year"},
            value: [%AST.BracedString{content: [%AST.Number{value: 2008}]}]
          }
        ],
        internal_key: "DBLP:conf/cbse/RusselloMD08"
      }
    ]

    assert expected == ast
  end
end
