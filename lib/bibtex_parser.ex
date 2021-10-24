defmodule BibtexParser do
  @doc """
  Given a string containing bibtex content, returns a list of entries found in
  this string.

  ## Examples

      iex> BibtexParser.parse_string("@incollection{foo, title={Bar}")
      [%{label: "foo", tags: [title: "Bar"], type: "incollection"}]

  """
  def parse_string(str) do
    {entries, _} = BibtexParser.Parser.parse_entries(str)

    entries
  end

  @doc """
  Given a string containing bibtex content, parses the string and then runs
  checks on it to verify if the content is proper Bibtex.

  These checks can be both structural (e.g., empty fields) and semantic (e.g.
  required fields).

  Each error returned from the function is in the form of `{<label>, [<error>:
  message]}`.

  ## Examples

      iex> BibtexParser.check_string("@incollection{foo, title={Bar}")
      [{"foo", [missing_tags: ["author", "booktitle", "pages", "publisher", "year"]]}]

  """
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
