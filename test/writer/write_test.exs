defmodule BibtexParser.Test.Write do
  use ExUnit.Case
  doctest BibtexParser

  test "Write simple entry" do
    input = %AST.Entry{
      entry_type: "notabook",
      fields: [
        %AST.Field{key: %AST.Key{content: "year"}, value: [%AST.Number{content: 1234}]}
      ],
      internal_key: "foo"
    }

    expected = """
    @notabook{foo,
        foo=bar
    }
    """
    output = BibtexParser.Writer.pretty_print(input)

    assert output == expected
  end
end
