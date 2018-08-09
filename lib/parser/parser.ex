defmodule BibTex.Parser do
  import NimbleParsec
  require Logger

  #
  # Comma: Parses and ignores a comma.
  #

  comma =
    ascii_char([?,])
    |> optional()
    |> ignore()

  defparsec(:comma, comma, debug: true)
  #
  # Whitespace: Parses and "eats" all the whitespace in front of the input.
  #

  whitespace =
    repeat_until(
      choice([ascii_char([?\s]), ascii_char([?\n])]),
      [ascii_char([{:not, ?\s}, {:not, ?\n}])]
    )
    |> ignore()

  defparsec(:whitespace, whitespace, debug: true)

  #
  # Symbol: Parses a legit symbol (all unicode, no spaces, no newlines, ..)
  #

  symbol =
    whitespace
    |> choice([ascii_char([?A..?Z]), ascii_char([?0..?9]), ascii_char([?a..?z])])
    |> concat(whitespace)

  defparsec(:symbol, symbol, debug: true)

  #
  # Field: Parses a field in a bibtex file. (E.g., author, title, pages,..)
  #

  field =
    whitespace
    |> ignore()
    |> concat(symbol)
    |> repeat_until(
      symbol,
      [ascii_char([?=])]
    )
    |> concat(whitespace)

  defparsec(:field, field, debug: true)

  #
  # Argument: The value of a bibtex field. Currently the string in between quotes.
  #

  quoted_argument =
    whitespace
    |> ignore()
    |> ascii_char([?"])
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      ascii_char([]),
      [ascii_char([?"])]
    )
    |> ascii_char([?"])
    |> concat(whitespace)
    |> concat(comma)
    |> concat(whitespace)

  braced_argument =
    whitespace
    |> ignore()
    |> ascii_char([?"])
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      ascii_char([]),
      [ascii_char([?"])]
    )
    |> ascii_char([?"])
    |> concat(whitespace)
    |> concat(comma)
    |> concat(whitespace)

  argument =
    whitespace
    |> ignore()
    |> ascii_char([?"])
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      ascii_char([]),
      [ascii_char([?"])]
    )
    |> ascii_char([?"])
    |> concat(whitespace)
    |> concat(comma)
    |> concat(whitespace)

  defparsec(:argument, argument, debug: true)

  #
  # Type: Parses the type from the bibtex entry. E.g., book, article, ..
  #

  type =
    string("@")
    |> ignore()
    |> concat(whitespace)
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      symbol,
      [ascii_char([?{])]
    )
    |> concat(whitespace)

  defparsec(:type, type, debug: true)

  #
  # Ref_label: Parses the reference label from the bibtex.
  #

  ref_label =
    ascii_char([?{])
    |> concat(whitespace)
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      symbol,
      [ascii_char([?,]), ascii_char([?\s])]
    )
    |> concat(whitespace)

  defparsec(:label, ref_label, debug: true)

  #
  # Helpers
  #

  def parse_entry(input) do
    {:ok, type, rest, _, _, _} = type(input)
    {:ok, label, <<?,, rest::binary>>, _, _, _} = label(rest)

    IO.inspect(rest)

    fields = parse_fields(rest)

    %{:type => type, :label => label, :fields => fields}
  end

  def parse_fields(input) do
    case parse_field(input) do
      {nil, rest} ->
        []

      {field, arg, rest} ->
        [{String.to_atom(to_string(field)), arg}] ++ parse_fields(rest)
    end
  end

  def parse_field(input) do
    case field(input) do
      {:ok, field, <<?=, arg::binary>>, _, _, _} ->
        Logger.debug("Parsed field: #{inspect(field)} (#{inspect(arg)})")

        case argument(arg) do
          {:ok, arg, rest, _, _, _} ->
            {field, arg, rest}

          {:error, _e, _rest, _, _, _} ->
            {nil, input}
        end

      {:error, _e, _rest, _, _, _} ->
        {nil, input}
    end
  end
end
