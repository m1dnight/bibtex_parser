defmodule BibtexParser do
  def parse_string(str) do
    {entries, _} = BibtexParser.Parser.parse_entries(str)

    entries
  end

  def check_string(str) do
    parse_string(str)
    |> BibtexParser.Checker.check()
  end

  def parse_file(path) do
    entries =
      File.read!(path)
      |> parse_string()

    entries
  end

  def check_file(path) do
    parse_file(path)
    |> BibtexParser.Checker.check()
  end
end
