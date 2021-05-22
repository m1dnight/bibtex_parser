defmodule BibtexParser.Test.Key do
  use ExUnit.Case
  doctest BibtexParser

  test "Key" do
    input = ~s(author)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.key(input)

    expected = [
      %AST.Key{
        content: "author"
      }
    ]

    assert expected == ast
  end

  test "Key with capitals" do
    input = ~s(AUTHOr)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.key(input)

    expected = [
      %AST.Key{
        content: "AUTHOr"
      }
    ]

    assert expected == ast
  end
end
