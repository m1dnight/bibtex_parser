defmodule BibTex.Parser.Helpers do
  import NimbleParsec

  defp not_space(<<?\s, _::binary>>, context, _, _), do: {:halt, context}
  defp not_Space(_, context, _, _), do: {:cont, context}

  # Parses whitespace.
  def whites() do
    ascii_char([?\s])
    |> repeat_while(
      ascii_char([?\s]),
      {:not_space, []}
    )
  end
end
