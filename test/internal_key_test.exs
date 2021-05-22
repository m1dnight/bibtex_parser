defmodule BibtexParser.Test.InternalKey do
  use ExUnit.Case
  doctest BibtexParser

  test "Internal Key" do
    input = ~s(myInternalKey)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.internal_key(input)

    expected = [%AST.InternalKey{content: "myInternalKey"}]

    assert expected == ast
  end

  test "Internal key with digits." do
    input = ~s(myInternalKey123)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.internal_key(input)

    expected = [%AST.InternalKey{content: "myInternalKey123"}]

    assert expected == ast
  end

  test "Internal key with slashes and such." do
    input = ~s(DBLP:conf/cbse/RusselloMD08)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.internal_key(input)

    expected = [%AST.InternalKey{content: "DBLP:conf/cbse/RusselloMD08"}]

    assert expected == ast
  end
end
