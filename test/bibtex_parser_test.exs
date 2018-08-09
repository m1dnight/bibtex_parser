defmodule BibtexParserTest do
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

  test "Test parsing of type" do
    input = """
    @book{ thomas2014programming , trash}
    """

    {:ok, result, rest, _, _, _} = Parser.type(input)
    assert result == 'book'

    {:ok, result, rest, _, _, _} = Parser.label(rest)
    assert result == 'thomas2014programming'
    assert true == match?(<<?,, _::binary>>, rest)
  end
end
