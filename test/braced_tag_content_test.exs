defmodule BibTex.Test.BracedContent do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

  test "Braced Tag Content Test 1" do
    input = ~s(= {foo})

    {:ok, result, rest, _, _, _} = Parser.braced_tag_content(input)

    assert result == 'foo'
    assert rest == ""
  end

  test "Braced Tag Content Test 2" do
    input = ~s(= {foo bar baz})

    {:ok, result, rest, _, _, _} = Parser.braced_tag_content(input)

    assert result == 'foo bar baz'
    assert rest == ""
  end
end
