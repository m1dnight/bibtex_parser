defmodule BibtexParser.Checker do
  @moduledoc false

  def check(entries) when is_list(entries) do
    errors = []

    # Duplicate labels and titles.
    errors = duplicate(entries, & &1.label, :duplicate_labels) ++ errors
    errors = duplicate(entries, &Keyword.get(&1.tags, :title, nil), :duplicate_titles) ++ errors
    errors = duplicate(entries, &Keyword.get(&1.tags, :url, nil), :duplicate_urls) ++ errors
    errors = duplicate(entries, &Keyword.get(&1.tags, :doi, nil), :duplicate_dois) ++ errors

    # Check individual entries.
    errors =
      entries
      |> Enum.reduce(errors, fn entry, errors ->
        case check(entry) do
          [] ->
            errors

          errs ->
            errors ++ [{entry.label, errs}]
        end
      end)

    errors
  end

  def check(entry) do
    errors = []
    errors = errors ++ empty_tags(entry)
    errors = errors ++ abbreviated_titles(entry)
    errors = errors ++ missing_tags(entry)
    errors
  end

  #############################################################################
  # Global file checks.

  defp duplicate(entries, lens, error) do
    values =
      entries
      |> Enum.flat_map(fn entry ->
        case lens.(entry) do
          nil ->
            []

          v ->
            [v]
        end
      end)

    uniques = values |> Enum.uniq()
    dupes = (values -- uniques) |> Enum.uniq()

    case dupes do
      [] ->
        []

      ds ->
        [{error, ds}]
    end
  end

  #############################################################################
  # Individual entry checks.

  defp empty_tags(entry) do
    empty_tags =
      entry.tags
      |> Enum.filter(fn {_tag, content} ->
        content == ""
      end)
      |> Enum.map(fn {tag, _} -> tag end)

    case empty_tags do
      [] ->
        []

      ts ->
        [empty_tags: ts]
    end
  end

  defp abbreviated_titles(entry) do
    # Ensure that if there is a title, journal, .. it has no flawed titles (i.e., a dot in the name or something.)
    if Keyword.has_key?(entry.tags, :journal) and
         Regex.match?(~r/\./, Keyword.get(entry.tags, :journal)) do
      [abbreviated_journal_title: Keyword.get(entry.tags, :journal)]
    else
      []
    end
  end

  def missing_tags(entry) do
    required = %{
      "inproceedings" => ["author", "booktitle", "pages", "publisher", "title", "year"],
      "article" => ["author", "journal", "number", "pages", "title", "volume", "year"],
      "techreport" => ["author", "institution", "title", "year"],
      "incollection" => ["author", "booktitle", "pages", "publisher", "title", "year"],
      "book" => ["author", "publisher", "title", "year"],
      "inbook" => ["author", "booktitle", "pages", "publisher", "title", "year"],
      "proceedings" => ["editor", "publisher", "title", "year"],
      "phdthesis" => ["author", "school", "title", "year"],
      "mastersthesis" => ["author", "school", "title", "year"],
      "electronic" => ["author", "title", "url", "year"],
      "misc" => ["author", "howpublished", "title", "year"]
    }

    required_for_entry = Map.get(required, entry.type, [])
    tags = entry.tags |> Enum.map(fn {k, _v} -> Atom.to_string(k) end)

    case required_for_entry -- tags do
      [] ->
        []

      missing ->
        [missing_tags: missing]
    end
  end
end
