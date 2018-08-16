defmodule T do
  import NimbleParsec
  import BibTex.Parser.Helpers
  require Logger

  s =
    whitespaces()
    |> concat(ignore_required_char(?"))
    |> repeat_until(utf8_char([]), [ignore_required_char(?")])
    |> concat(ignore_required_char(?"))
    |> concat(whitespaces())

  hashtag = ignore_required_char(?#)

  defparsec(
    :test,
    s
    |> optional(hashtag |> parsec(:test)),
    debug: true
  )

  def input, do: ~s("hello " #)

  @spec test() ::
          {:error, <<_::352>>, binary(), map(), {pos_integer(), pos_integer()}, pos_integer()}
          | {:ok, [...], binary(), map(), {pos_integer(), pos_integer()}, pos_integer()}
  def test do
    test(input)
  end
end
