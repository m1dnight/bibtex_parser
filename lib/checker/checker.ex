defmodule BibtexParser.Checker do
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
    errors
  end

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

  defp empty_tags(entry) do
    empty_tags =
      entry.tags
      |> Enum.filter(fn {_tag, content} ->
        content == ''
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
    if Keyword.has_key?(entry.tags, :journal) do
      journal = Keyword.get(entry.tags, :journal)

      if Regex.match?(~r/\./, Kernel.to_string(journal)) do
        [abbreviated_journal_title: journal]
      else
        []
      end
    else
      []
    end
  end

end
