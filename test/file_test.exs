defmodule BibTex.Test.File do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

  test "Large File" do
    input = File.read!("test/test.bib")

    {entries, rem} = Parser.parse_entries(input)

    assert rem == ""
    # assert entries == expected_entries
  end
end
