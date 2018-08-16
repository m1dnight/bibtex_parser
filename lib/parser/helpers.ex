defmodule BibTex.Parser.Helpers do
  import NimbleParsec

  @doc """
  Eats up the given char if it exists on the input, and then ignores it.
  """
  def ignore_required_char(char) do
    ascii_char([char])
    |> ignore()
  end

  @doc """
  Eats up the given char if it exists on the input, and then ignores it.
  """
  def ignore_optional_char(char) do
    ascii_char([char])
    |> optional()
    |> ignore()
  end

  @doc """
  Eats up any whitespace at the beginning of the stream, including tabs etc.
  """
  def whitespaces do
    repeat_until(
      ascii_char([?\s, ?\t, ?\n, ?\r, ?\f, ?\v]),
      [ascii_char([{:not, ?\s}, {:not, ?\t}, {:not, ?\n}, {:not, ?\r}, {:not, ?\f}, {:not, ?\v}])]
    )
    |> ignore()
  end

  @doc """
  Parses one valid symbol. This is defined in terms of which symbols are valid in a bibtex file.
  """
  def symbol do
    ascii_char([?A..?Z, ?a..?z, ?., ?0..?9, ?,])
  end
end
