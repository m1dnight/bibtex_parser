defmodule BibtexParser.Test.File do
  use ExUnit.Case
  doctest BibtexParser
  alias BibtexParser.Parser

  test "Large File" do
    input = File.read!("test/large.bib")

    {entries, rem} = Parser.parse_entries(input)

    assert rem == ""
    assert 64 == Enum.count(entries)
  end
end
