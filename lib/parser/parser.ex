defmodule BibTex.Parser do
  import NimbleParsec
  import BibTex.Parser.Helpers
  require Logger

  #
  # Symbol: Parses a legit symbol (all unicode, no spaces, no newlines, ..)
  #

  symbol = ascii_char([?A..?Z, ?a..?z, ?., ?0..?9, ?,])

  # ------------------------------------ Components ----------------------------#

  #
  # Tag: Parses a field in a bibtex file. (E.g., author, title, pages,..)
  #

  tag =
    whitespaces()
    |> ignore()
    |> concat(ignore_optional_char(?,))
    |> concat(symbol)
    |> repeat_until(
      symbol,
      [ascii_char([?=])]
    )
    |> concat(whitespaces())
    |> concat(ignore_optional_char(?,))
    |> concat(whitespaces())

  defparsec(:tag, tag, debug: true)

  #
  # Argument: The value of a bibtex field. Currently the string in between quotes.
  #

  quoted_tag_content =
    whitespaces()
    |> ignore()
    |> ascii_char([?=])
    |> ignore()
    |> concat(whitespaces())
    |> ascii_char([?"])
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      ascii_char([]),
      [ascii_char([?"])]
    )
    |> concat(whitespaces())
    |> concat(ignore_optional_char(?"))
    |> concat(whitespaces())
    |> concat(ignore_optional_char(?,))
    |> concat(whitespaces())

  braced_tag_content =
    whitespaces()
    |> ascii_char([?=])
    |> concat(whitespaces())
    |> ascii_char([?{])
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      ascii_char([]),
      [ascii_char([?}])]
    )
    |> concat(whitespaces())
    |> concat(ignore_optional_char(?}))
    |> concat(whitespaces())
    |> concat(ignore_optional_char(?,))
    |> concat(whitespaces())

  tag_content = choice([quoted_tag_content, braced_tag_content])

  defparsec(:tag_content, tag_content, debug: true)

  #
  # Type: Parses the type from the bibtex entry. E.g., book, article, ..
  #

  type =
    string("@")
    |> ignore()
    |> concat(whitespaces())
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      symbol,
      [ascii_char([?{])]
    )
    |> concat(whitespaces())

  defparsec(:type, type, debug: true)

  #
  # Ref_label: Parses the reference label from the bibtex.
  #

  ref_label =
    ascii_char([?{])
    |> concat(whitespaces())
    |> ignore()
    |> ascii_char([])
    |> repeat_until(
      symbol,
      [ascii_char([?,]), ascii_char([?\s])]
    )
    |> concat(whitespaces())
    |> concat(ignore_optional_char(?,))

  defparsec(:label, ref_label, debug: true)

  #
  # Helpers: Higher-level parser functions.
  #

  defparsec(:typelabel, type |> concat(ref_label), debug: true)

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
end
