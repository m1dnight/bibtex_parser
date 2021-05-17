defmodule BibTex.Test.File do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

  test "Large File" do
    input = File.read!("test/large.bib")

    result = nil

    {:ok, _, rem} = Parser.parse_entry(input)

    assert rem == ""
  end
end
