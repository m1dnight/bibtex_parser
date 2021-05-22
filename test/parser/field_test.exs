defmodule BibtexParser.Test.Field do
  use ExUnit.Case
  doctest BibtexParser

  test "Field with key and value" do
    input = ~s(author = "Foo Bar")

    {:ok, ast, _, _, _, _} = BibtexParser.AST.field(input)

    expected = [
      %AST.Field{
        key: %AST.Key{content: "author"},
        value: [%AST.QuotedString{content: [%AST.PlainText{content: "Foo Bar"}]}]
      }
    ]

    assert expected == ast
  end

  test "Spaces in fields." do
    input = ~s(year = 1999)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.field(input)

    expected = [
      %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 1999}]}
    ]

    assert expected == ast
  end

  test "Multiple fields separated by comma" do
    input = ~s(year=1999,year=2000)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.fields(input)

    expected = [
      %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 1999}]},
      %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 2000}]}
    ]

    assert expected == ast
  end

  test "Multiple fields separated by comma, and trailing comma" do
    input = ~s(year=1999,year=2000,)

    {:ok, ast, _, _, _, _} = BibtexParser.AST.fields(input)

    expected = [
      %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 1999}]},
      %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 2000}]}
    ]

    assert expected == ast
  end

  test "Multiple fields spaces in between" do
    input = ~s(year = 1999 , year = 2000 , )

    {:ok, ast, _, _, _, _} = BibtexParser.AST.fields(input)

    expected = [
      %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 1999}]},
      %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 2000}]}
    ]

    assert expected == ast
  end
end
