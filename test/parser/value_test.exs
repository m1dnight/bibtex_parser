defmodule BibtexParser.Test.Values do
  use ExUnit.Case
  doctest BibtexParser

  #############################################################################
  # Should fail.

  test "Do not eat stray commas." do
    input = ~s("quoted string",)

    {:ok, ast, ",", _, _, _} = BibtexParser.AST.value(input)

    expected = [%AST.QuotedString{content: [%AST.PlainText{value: "quoted string"}]}]

    assert expected == ast
  end

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
          %AST.PlainText{value: " command"}
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
          %AST.PlainText{value: "quoted"}
        ]
      }
    ]

    assert expected == ast
  end

  test "Number in quoted string" do
    input = ~s("1234")

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [%AST.QuotedString{content: [%AST.Number{value: 1234}]}]

    assert expected == ast
  end

  test "Quoted string in quoted string does not work." do
    input = ~s("foo "bar" baz")

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [%AST.QuotedString{content: [%AST.PlainText{value: "foo "}]}]

    assert expected == ast
  end

  #############################################################################
  # Braced Strings

  test "Braced string" do
    input = ~s({braced})

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [
      %AST.BracedString{
        content: [
          %AST.PlainText{value: "braced"}
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
          %AST.BracedString{content: [%AST.PlainText{value: "a"}]},
          %AST.BracedString{content: [%AST.PlainText{value: "b"}]}
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
        value: 1999
      }
    ]

    assert expected == ast
  end

  test "Number in braced string" do
    input = ~s({1999})

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [%AST.BracedString{content: [%AST.Number{value: 1999}]}]

    assert expected == ast
  end

  test "Value with newlines and many spaces" do
    input = ~s({Giovanni Russello and
    Leonardo Mostarda and
    Naranker Dulay})

    {:ok, ast, _, _, _, _} = BibtexParser.AST.value(input)

    expected = [
      %AST.BracedString{
        content: [
          %AST.PlainText{value: "Giovanni Russello and\n    Leonardo Mostarda and\n    Naranker Dulay"}
        ]
      }
    ]

    assert expected == ast
  end
end
