defmodule BibTex.Test.Whitespace do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

  test "Whitespace optional parser 1" do
    input = " foo"

    {:ok, result, rest, _, _, _} = Parser.whitespace(input)

    assert result == []
    assert rest == "foo"
  end

  test "Whitespace optional parser 2" do
    input = "foo "

    {:ok, result, rest, _, _, _} = Parser.whitespace(input)

    assert result == []
    assert rest == "foo "
  end

  test "Whitespace optional parser 3" do
    input = "  foo  "

    {:ok, result, rest, _, _, _} = Parser.whitespace(input)

    assert result == []
    assert rest == "foo  "
  end

  test "Whitespace optional parser 4" do
    input = "foo"

    {:ok, result, rest, _, _, _} = Parser.whitespace(input)

    assert result == []
    assert rest == "foo"
  end

  test "Whitespace optional parser 5" do
    input = "               foo"

    {:ok, result, rest, _, _, _} = Parser.whitespace(input)

    assert result == []
    assert rest == "foo"
  end
end
