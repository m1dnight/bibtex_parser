defmodule BibtexParser.Test.InternalKey do
  use ExUnit.Case
  doctest BibtexParser

  test "Internal Key" do
    input = ~s(myInternalKey)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.internal_key(input)

    expected = [%AST.InternalKey{content: "myInternalKey"}]

    assert expected == ast
  end
end
