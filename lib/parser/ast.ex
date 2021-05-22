defmodule AST.Command, do: defstruct(content: [])
defmodule AST.Number, do: defstruct(content: [])
defmodule AST.QuotedString, do: defstruct(content: [])
defmodule AST.BracedString, do: defstruct(content: [])
defmodule AST.PlainText, do: defstruct(content: [])

defmodule BibtexParser.AST do
  import NimbleParsec

  defp tokenify(_rest, [], _context, _line, _offset, _) do
    {:error, "No result."}
  end

  defp tokenify(rest, args, context, line, offset, :command) do
    IO.puts("""
    ===============================================
    Type:    :command
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    chars = Enum.reverse(args)
    string = to_string(chars)
    token = %AST.Command{content: string}
    {[token], context}
  end

  defp tokenify(rest, args, context, line, offset, :number) do
    IO.puts("""
    ===============================================
    Type:    :number
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    chars = Enum.reverse(args)
    string = to_string(chars)
    number = String.to_integer(string)
    token = %AST.Number{content: number}
    {[token], context}
  end

  defp tokenify(rest, args, context, line, offset, :quoted_string) do
    IO.puts("""
    ===============================================
    Type:    :quoted_string
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    args = Enum.reverse(args)
    token = %AST.QuotedString{content: args}
    {[token], context}
  end

  defp tokenify(rest, args, context, line, offset, :braced_string) do
    IO.puts("""
    ===============================================
    Type:    :braced_string
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    args = Enum.reverse(args)
    token = %AST.BracedString{content: args}
    {[token], context}
  end

  defp tokenify(rest, args, context, line, offset, :plain_text) do
    IO.puts("""
    ===============================================
    Type:    :plain_text
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    chars = Enum.reverse(args)
    string = to_string(chars)
    token = %AST.PlainText{content: string}

    {[token], context}
  end

  #############################################################################
  # Latex Command
  # Example \LaTex or \leftbrace

  command =
    string("\\")
    |> repeat(
      lookahead_not(ascii_char([?\s, ?\}]))
      |> ascii_char([])
    )
    |> post_traverse({:tokenify, [:command]})

  defparsec(:command, command)

  #############################################################################
  # Numbers
  # Example: 1972

  number =
    repeat(
      lookahead_not(ascii_char([{:not, ?0..?9}]))
      |> ascii_char([])
    )
    |> post_traverse({:tokenify, [:number]})

  defparsec(:number, number)

  #############################################################################
  # Quoted String
  # Example: "This is quoted text"

  quoted_string =
    ignore(ascii_char([?\"]))
    |> repeat(
      lookahead_not(ascii_char([?\"]))
      |> parsec(:value_content)
    )
    |> ignore(ascii_char([?\"]))
    |> post_traverse({:tokenify, [:quoted_string]})

  defparsec(:quoted_string, quoted_string)

  #############################################################################
  # Braced String
  # Example: "This is quoted text"

  braced_string =
    ignore(ascii_char([?\{]))
    |> repeat(
      lookahead_not(ascii_char([?\}]))
      |> parsec(:value_content)
    )
    |> ignore(ascii_char([?\}]))
    |> post_traverse({:tokenify, [:braced_string]})

  defparsec(:braced_string, braced_string)

  #############################################################################
  # Plain Text

  plain_text =
    repeat(
      lookahead_not(utf8_char([?\", ?\{, ?\}]))
      |> utf8_char([])
    )
    |> post_traverse({:tokenify, [:plain_text]})

  defparsec(:plain_text, plain_text)

  #############################################################################
  # Content of a value.

  value_content =
    choice([parsec(:number), parsec(:quoted_string), parsec(:braced_string), parsec(:plain_text)])

  defparsec(:value_content, value_content)

  #############################################################################
  # A Value (left hand side of an entry).

  value =
    choice([parsec(:braced_string), parsec(:quoted_string), parsec(:number)])
    |> eos()

  defparsec(:value, value)
end
