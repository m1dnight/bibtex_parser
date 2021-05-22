defmodule BibtexParser.Test.Values do
  use ExUnit.Case
  doctest BibtexParser

  #############################################################################
  # Latex commands.

  test "Latex command" do
    # "\a"
    input = ~s("\\LaTeX command")

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [
      %AST.QuotedString{
        content: [
          %AST.Command{content: "LaTeX"},
          %AST.PlainText{content: " command"}
        ]
      }
    ]

    assert expected == ast
  end

  #############################################################################
  # Quoted Strings

  test "Quoted string" do
    input = ~s("quoted")

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [
      %AST.QuotedString{
        content: [
          %AST.PlainText{content: "quoted"}
        ]
      }
    ]

    assert expected == ast
  end

  test "Number in quoted string" do
    input = ~s("1234")

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [%AST.QuotedString{content: [%AST.Number{content: 1234}]}]

    assert expected == ast
  end

  test "Quoted string in quoted string" do
    input = ~s("foo "bar" baz")

    result = BibtexParser.AST.value(input)

    assert {:error, _, _, _, _, _} = result
  end

  #############################################################################
  # Braced Strings

  test "Braced string" do
    input = ~s({braced})

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [
      %AST.BracedString{
        content: [
          %AST.PlainText{content: "braced"}
        ]
      }
    ]

    assert expected == ast
  end

  test "Braced string in braced string" do
    input = ~s({{a}{b}})

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [
      %AST.BracedString{
        content: [
          %AST.BracedString{content: [%AST.PlainText{content: "a"}]},
          %AST.BracedString{content: [%AST.PlainText{content: "b"}]}
        ]
      }
    ]

    assert expected == ast
  end

  #############################################################################
  # Number

  test "Number" do
    input = ~s(1999)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [
      %AST.Number{
        content: 1999
      }
    ]

    assert expected == ast
  end

  test "Number in braced string" do
    input = ~s({1999})

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [%AST.BracedString{content: [%AST.Number{content: 1999}]}]

    assert expected == ast
  end
end
