defmodule BibtexParser.Test.Entry do
  use ExUnit.Case
  doctest BibtexParser

  test "Entry" do
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
end
