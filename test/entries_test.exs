defmodule BibtexParser.Test.Entries do
  use ExUnit.Case
  doctest BibtexParser

  test "Simple Entries" do
    input = "@book{foo, year = 1234} @notabook{foo, year = 1234}"

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entries(input)

    expected = [
      %AST.Entry{
        entry_type: "notabook",
        fields: [
          %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 1234}]}
        ],
        internal_key: "foo"
      },
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
end
