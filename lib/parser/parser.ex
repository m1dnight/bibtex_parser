defmodule BibTex.Parser do
  import NimbleParsec
  require Logger

  # ------------------------------------ Helpers -------------------------------#
  #
  # Comma: Parses and "eats" a comma.
  #

  comma =
    ascii_char([?,])
    |> optional()
    |> ignore()

  defparsec(:comma, comma, debug: true)

  #
  # Whitespace: Parses and "eats" all the whitespace in front of the input.
  #

  whitespaces =
    repeat_until(
      ascii_char([?\s, ?\t, ?\n, ?\r, ?\f, ?\v]),
      [ascii_char([{:not, ?\s}, {:not, ?\t}, {:not, ?\n}, {:not, ?\r}, {:not, ?\f}, {:not, ?\v}])]
    )
    |> ignore()

  defparsec(:whitespace, whitespaces, debug: true)

  #
  # Symbol: Parses a legit symbol (all unicode, no spaces, no newlines, ..)
  #

  symbol =
    whitespaces
    |> utf8_char([])
    |> concat(whitespaces)

  # |> choice([ascii_char([?A..?Z]), ascii_char([?0..?9]), ascii_char([?a..?z])])
  # |> concat(whitespace)

  # ------------------------------------ Components ----------------------------#

  defparsec(:symbol, symbol, debug: true)

  #
  # Tag: Parses a field in a bibtex file. (E.g., author, title, pages,..)
  #

  tag =
    whitespaces
    |> ignore()
    |> concat(symbol)
    |> repeat_until(
      symbol,
      [ascii_char([?=])]
    )
    |> concat(whitespaces)

  defparsec(:tag, tag, debug: true)

  #
  # Argument: The value of a bibtex field. Currently the string in between quotes.
  #

  quoted_tag_content =
    whitespaces
    |> ignore()
    |> ascii_char([?{])
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      ascii_char([]),
      [ascii_char([?}])]
    )
    |> ascii_char([?}])
    |> concat(whitespaces)
    |> concat(comma)
    |> concat(whitespaces)

  braced_tag_content =
    whitespaces
    |> ignore()
    |> ascii_char([?"])
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      ascii_char([]),
      [ascii_char([?"])]
    )
    |> ascii_char([?"])
    |> concat(whitespaces)
    |> concat(comma)
    |> concat(whitespaces)

  tag_end =
    whitespaces
    |> concat(comma)
    |> concat(whitespaces)
    |> ascii_char([?}])
    |> concat(whitespaces)
    |> ignore()

  defparsec(:tag_end, tag_end, debug: true)

  tag_content =
    whitespaces
    |> ignore()
    |> ascii_char([?=])
    |> ignore()
    |> concat(whitespaces)
    |> ascii_char([?"])
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      ascii_char([]),
      [ascii_char([?"])]
    )
    |> ascii_char([?"])
    |> concat(whitespaces)
    |> concat(comma)
    |> concat(whitespaces)
    |> optional(tag_end)

  defparsec(:tag_content, tag_content, debug: true)

  #
  # Type: Parses the type from the bibtex entry. E.g., book, article, ..
  #

  type =
    string("@")
    |> ignore()
    |> concat(whitespaces)
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      symbol,
      [ascii_char([?{])]
    )
    |> concat(whitespaces)

  defparsec(:type, type, debug: true)

  #
  # Ref_label: Parses the reference label from the bibtex.
  #

  ref_label =
    ascii_char([?{])
    |> concat(whitespaces)
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      symbol,
      [ascii_char([?,]), ascii_char([?\s])]
    )
    |> concat(whitespaces)

  defparsec(:label, ref_label, debug: true)

  #
  # Helpers: Higher-level parser functions.
  #

  def parse_entry(input) do
    with {:ok, type, rest} <- parse_type(input),
         {:ok, label, rest} <- parse_label(rest),
         tags <- parse_tags(rest) do
      {:ok, %{:type => type, :label => label, :tags => tags}}
    else
      {:error, e, rest} ->
        {:error, e, rest}
    end
  end

  @doc false
  def parse_type(input) do
    Logger.debug("Parsing type: #{input}")
    result = type(input)

    case result do
      {:ok, result, rest, _, _, _} ->
        {:ok, result, rest}

      {:error, e, _, _, _, _} ->
        {:error, e, input}
    end
  end

  def parse_label(input) do
    Logger.debug("Parsing label: #{input}")

    result = label(input)

    case result do
      {:ok, result, rest, _, _, _} ->
        {:ok, result, rest}

      {:error, e, _, _, _, _} ->
        {:error, e, input}
    end
  end

  def parse_tags(input) do
    Logger.debug("Parsing tags: #{input}")

    result = parse_tag(input)

    case result do
      {:ok, {tag, content}, rest} ->
        [{tag |> to_string |> String.to_atom(), content}] ++ parse_tags(rest)

      {:error, e, _input} ->
        []
    end
  end

  def parse_tag(input) do
    Logger.debug("Parsing tag: #{input}")

    with {:ok, name, rest} <- parse_tag_name(input),
         {:ok, cont, rest} <- parse_tag_content(rest) do
      {:ok, {name, cont}, rest}
    else
      {:error, e, _} ->
        {:error, e, input}
      {:error, e, _, _, _, _} ->
        {:error, "parse_tag: #{e}", input}
    end
  end

  def parse_tag_name(input) do
    Logger.debug("Parsing tag name: #{input}")

    result = tag(input)

    case result do
      {:ok, result, rest, _, _, _} ->
        {:ok, result, rest}

      {:error, e, _, _, _, _} ->
        {:error, "parse_tag_name: #{e}", input}
    end
  end

  def parse_tag_content(input) do
    Logger.debug("Parsing tag content: #{input}")

    result = tag_content(input)

    case result do
      {:ok, result, rest, _, _, _} ->
        {:ok, result, rest}

      {:error, e, _, _, _, _} ->
        {:error, "parse_tag_content: #{e}", input}
    end
  end

  # def parse_entry(input) do
  #   {:ok, type, rest, _, _, _} = type(input)
  #   {:ok, label, <<?,, rest::binary>>, _, _, _} = label(rest)

  #   IO.inspect(rest)

  #   fields = parse_fields(rest)

  #   %{:type => type, :label => label, :fields => fields}
  # end

  # def parse_fields(input) do
  #   case parse_field(input) do
  #     {nil, rest} ->
  #       []

  #     {field, arg, rest} ->
  #       [{String.to_atom(to_string(field)), arg}] ++ parse_fields(rest)
  #   end
  # end

  # def parse_field(input) do
  #   case field(input) do
  #     {:ok, field, <<?=, arg::binary>>, _, _, _} ->
  #       # Logger.debug("Parsed field: #{inspect(field)} (#{inspect(arg)})")

  #       case argument(arg) do
  #         {:ok, arg, rest, _, _, _} ->
  #           {field, arg, rest}

  #         {:error, _e, _rest, _, _, _} ->
  #           {nil, input}
  #       end

  #     {:error, _e, _rest, _, _, _} ->
  #       {nil, input}
  #   end
  # end
end
