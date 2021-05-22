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
end
