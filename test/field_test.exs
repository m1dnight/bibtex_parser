defmodule BibtexParser.Test.Field do
  use ExUnit.Case
  doctest BibtexParser

  test "Field with key and value" do
    input = ~s(author = "Foo Bar")

    {:ok, ast, _, _, _, _} = BibtexParser.AST.field(input)

    expected = [
      %AST.Field{
        key: %AST.Key{content: "author"},
        value: [%AST.QuotedString{content: [%AST.PlainText{content: "Foo Bar"}]}]
      }
    ]

    assert expected == ast
  end
end
