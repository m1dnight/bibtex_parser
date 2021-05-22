defmodule BibtexParser.Test.Entry do
  use ExUnit.Case
  doctest BibtexParser

  # test "Entry" do
  #   input = """
  #   @book{foo}
  #   """

  #   {:ok, ast, _, _, _, _} = BibtexParser.AST.entry(input)

  #   expected = [%AST.EntryType{content: "inproceedings"}]

  #   assert expected == ast
  # end
end
