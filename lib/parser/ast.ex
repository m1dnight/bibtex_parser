defmodule AST.Command, do: defstruct(content: [])
defmodule AST.Number, do: defstruct(content: [])
defmodule AST.QuotedString, do: defstruct(content: [])
defmodule AST.BracedString, do: defstruct(content: [])
defmodule AST.PlainText, do: defstruct(content: [])
defmodule AST.Key, do: defstruct(content: [])
defmodule AST.Field, do: defstruct(key: nil, value: nil)
defmodule AST.Entry, do: defstruct(label: nil, type: nil, fields: nil)
defmodule AST.EntryType, do: defstruct(content: nil)
defmodule AST.InternalKey, do: defstruct(content: nil)

defmodule BibtexParser.AST do
  import NimbleParsec

  #############################################################################
  # Helpers

  defp debug_print(m), do: if(true, do: IO.puts(m))

  #############################################################################
  # Transformation from tokens to structs.

  defp tokenify(_rest, [], _context, _line, _offset, _) do
    {:error, "No result."}
  end

  defp tokenify(rest, args, context, line, offset, :command) do
    debug_print("""
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
    debug_print("""
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
    debug_print("""
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
    debug_print("""
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
    debug_print("""
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

  defp tokenify(rest, args, context, line, offset, :key) do
    debug_print("""
    ===============================================
    Type:    :key
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    chars = Enum.reverse(args)
    string = to_string(chars)
    token = %AST.Key{content: string}

    {[token], context}
  end

  defp tokenify(rest, args, context, line, offset, :field) do
    debug_print("""
    ===============================================
    Type:    :field
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    content = Enum.reverse(args)
    [%AST.Key{content: k} | content] = content
    token = %AST.Field{key: %AST.Key{content: k}, value: content}

    {[token], context}
  end

  defp tokenify(rest, args, context, line, offset, :entry_type) do
    debug_print("""
    ===============================================
    Type:    :entry_type
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    chars = Enum.reverse(args)
    string = to_string(chars)
    token = %AST.EntryType{content: string}

    {[token], context}
  end

  defp tokenify(rest, args, context, line, offset, :internal_key) do
    debug_print("""
    ===============================================
    Type:    :internal_key
    Rest:    #{inspect(rest)}
    Args:    #{inspect(args)}
    Context: #{inspect(context)}
    Line:    #{inspect(line)}
    Offset: #{inspect(offset)}
    ===============================================
    """)

    chars = Enum.reverse(args)
    string = to_string(chars)
    token = %AST.InternalKey{content: string}

    {[token], context}
  end

  #############################################################################
  # Helper Parsers

  whitespaces =
    repeat(
      lookahead(ascii_char([?\s, ?\t, ?\n]))
      |> ascii_char([?\s, ?\t, ?\n])
    )
    |> ignore()

  defparsec(:whitespaces, whitespaces)

  #############################################################################
  # Latex Command
  # Example \LaTex or \leftbrace

  command =
    ignore(string("\\"))
    |> repeat(
      lookahead_not(ascii_char([?\s, ?\}, ?\"]))
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
      lookahead_not(utf8_char([?\", ?\{, ?\}, ?\\]))
      |> utf8_char([])
    )
    |> post_traverse({:tokenify, [:plain_text]})

  defparsec(:plain_text, plain_text)

  #############################################################################
  # Content of a value.

  value_content =
    choice([
      parsec(:number),
      parsec(:quoted_string),
      parsec(:braced_string),
      parsec(:plain_text),
      parsec(:command)
    ])

  defparsec(:value_content, value_content)

  #############################################################################
  # A Value (left hand side of an entry).

  value = choice([parsec(:braced_string), parsec(:quoted_string), parsec(:number)])

  defparsec(:value, value)

  #############################################################################
  # Keys

  key =
    repeat(
      lookahead(ascii_char([?a..?z, ?A..?Z]))
      |> ascii_char([?a..?z, ?A..?Z])
    )
    |> post_traverse({:tokenify, [:key]})

  defparsec(:key, key)

  #############################################################################
  # Fields

  field =
    parsec(:key)
    |> parsec(:whitespaces)
    |> ignore(ascii_char([?=]))
    |> parsec(:whitespaces)
    |> parsec(:value)
    |> post_traverse({:tokenify, [:field]})

  defparsec(:field, field)

  #############################################################################
  # Entry Type

  entry_type =
    repeat(
      lookahead_not(ascii_char([?\{]))
      |> ascii_char([])
    )
    |> post_traverse({:tokenify, [:entry_type]})

  defparsec(:entry_type, entry_type)

  #############################################################################
  # Internal Key

  internal_key =
    repeat(
      lookahead(ascii_char([?a..?z, ?A..?Z]))
      |> ascii_char([?a..?z, ?A..?Z])
    )
    |> post_traverse({:tokenify, [:internal_key]})

  defparsec(:internal_key, internal_key)

  #############################################################################
  # Entry

  field_comma =
    parsec(:field)
    |> ignore(ascii_char([?,]))

  defparsec(:field_comma, field_comma)

  fields =
    repeat(
      lookahead(parsec(:field))
      |> parsec(:field_comma)
    )

  defparsec(:fields, fields)

  entry =
    ignore(ascii_char([?@]))
    |> parsec(:entry_type)
    |> parsec(:whitespaces)
    |> ignore(ascii_char([?\{]))
    |> parsec(:internal_key)
    |> parsec(:whitespaces)
    |> ignore(ascii_char([?,]))
    |> parsec(:whitespaces)
    |> repeat(
      lookahead(parsec(:field))
      |> parsec(:field)
    )
    |> ignore(ascii_char([?\}]))

  defparsec(:entry, entry)
end
