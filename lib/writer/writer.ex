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

  @moduledoc false

  def pretty_print(%Entry{} = entry) do
    values = ["foo=bar"]

    values =
      values
      |> Enum.map(&("    " <> &1))
      |> Enum.join(",\n")

    """
    @#{entry.entry_type}{#{entry.internal_key},
    #{values}
    }
    """
  end
end
