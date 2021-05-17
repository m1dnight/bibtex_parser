defmodule BibtexParser do
  import BibtexParser.Parser

  def parse_file(path) do
    {entries, _} =
      File.read!(path)
      |> BibtexParser.Parser.parse_entries()

    entries
  end

  def check_file(path) do
    content = parse_file(path)

    BibtexParser.Checker.check(content)
  end
end
