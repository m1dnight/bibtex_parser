defmodule BibtexParser.Test.EntryType do
  use ExUnit.Case
  doctest BibtexParser

  test "Entry type" do
    input = ~s(inproceedings)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entry_type(input)

    expected = [%AST.EntryType{content: "inproceedings"}]

    assert expected == ast
  end
end
