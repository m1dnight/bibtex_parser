defmodule BibTex.Test.Comma do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

  test "Comma Test 1" do
    input = ",foo"

    {:ok, result, rest, _, _, _} = Parser.comma(input)

    assert result == []
    assert rest == "foo"
  end

  test "Comma Test 2" do
    input = ",,foo"

    {:ok, result, rest, _, _, _} = Parser.comma(input)

    assert result == []
    assert rest == ",foo"
  end

  test "Comma Test 3" do
    input = " ,foo"

    {:ok, result, rest, _, _, _} = Parser.comma(input)

    assert result == []
    assert rest == " ,foo"
  end
end
