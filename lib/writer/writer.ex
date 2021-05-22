defmodule BibtexParser.Writer.Config do
  defstruct tabs_instead_of_spaces: false,
            indentation: 4,
            sanitize_whitespace: true,
            sanitize_capitals_keys: true,
            sanitize_capitals_values: true
end

defmodule BibtexParser.Writer do
  alias AST.{
    Command,
    Number,
    QuotedString,
    BracedString,
    PlainText,
    Range,
    Key,
    Field,
    Entry,
    EntryType,
    InternalKey
  }

  alias BibtexParser.Writer.Config

  @moduledoc false

  def pretty_print(%Entry{} = entry, config) do
    values = Enum.map(entry.fields, &pretty_print(&1, config)) |> Enum.join(",\n")

    """
    @#{entry.entry_type}{#{entry.internal_key},
    #{values}
    }
    """
  end

  def pretty_print(%Field{key: k, value: v}, %Config{} = config) do
    # Calculate the indentation for this field based on the config.
    indentation =
      case config.tabs_instead_of_spaces do
        true ->
          "\t" |> List.duplicate(config.indentation)

        _ ->
          " " |> List.duplicate(config.indentation)
      end

    "#{indentation}#{pretty_print(k, config)} = #{pretty_print(v, config)}"
  end

  def pretty_print(%Key{value: k}, config) do
    case config.sanitize_capitals_keys do
      true ->
        String.downcase(k)

      _ ->
        k
    end
  end

  def pretty_print(%Number{value: n}, _config) do
    "#{n}"
  end

  def pretty_print(%BracedString{content: cs}, config) do
    "{#{pretty_print(cs, config)}}"
  end

  def pretty_print(%QuotedString{content: cs}, config) do
    "\"#{pretty_print(cs, config)}\""
  end

  def pretty_print(%PlainText{value: v}, _config) do
    "#{v}"
  end

  def pretty_print(%Command{value: v}, config) do

  end

  def pretty_print(%Range{from: f, to: t}, _config) do
    "#{f}--#{t}"
  end

  def pretty_print([], _), do: ""

  def pretty_print([x | xs], config) do
    x_str = pretty_print(x, config)
    x_str <> pretty_print(xs, config)
  end
end
