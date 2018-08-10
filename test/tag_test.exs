defmodule BibTex.Test.Tag do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

  test "Tag Test 1" do
    input = ~s(foobar = "baz")

    {:ok, result, rest, _, _, _} = Parser.tag(input)

    assert result == 'foobar'
    assert rest == "=\s\"baz\""
  end

  test "Tag Test 2" do
    input = ~s(foobar= "baz")

    {:ok, result, rest, _, _, _} = Parser.tag(input)

    assert result == 'foobar'
    assert rest == "=\s\"baz\""
  end
end
