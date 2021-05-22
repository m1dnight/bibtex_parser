defmodule BibtexParser.Test.Write do
  use ExUnit.Case
  doctest BibtexParser

  test "Write simple entry" do
    config = %BibtexParser.Writer.Config{}

    input = """
    @incollection{spidersjs2,
      title={Parallel and Distributed Web Programming with Actors},
      author={Myter, Florian and Scholliers, Christophe and De Meuter, Wolfgang},
      booktitle={Programming with Actors: State-of-the-Art and Research Perspectives},
      pages={3--31},
      year={2018},
      publisher={Springer International Publishing}
    }
    """

    expected = """
    @incollection{spidersjs2,
        title = {Parallel and Distributed Web Programming with Actors},
        author = {Myter, Florian and Scholliers, Christophe and De Meuter, Wolfgang},
        booktitle = {Programming with Actors: State-of-the-Art and Research Perspectives},
        pages = {3--31},
        year = {2018},
        publisher = {Springer International Publishing}
    }
    """

    {:ok, ast, _, _, _, _} = BibtexParser.AST.entries(input)
    output = BibtexParser.Writer.pretty_print(ast, config)

    assert output == expected
  end
end
