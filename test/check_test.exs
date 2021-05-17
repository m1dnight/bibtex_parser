defmodule BibtexParser.Test.Checks do
  use ExUnit.Case
  doctest BibtexParser
  alias BibtexParser.Checker

  test "Valid entry" do
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

    errors = BibtexParser.check_string(input)

    assert errors == []
  end

  test "Empty tag" do
    input = """
    @incollection{spidersjs2,
    title={Parallel and Distributed Web Programming with Actors},
    author={Myter, Florian and Scholliers, Christophe and De Meuter, Wolfgang},
    booktitle={Programming with Actors: State-of-the-Art and Research Perspectives},
    pages={3--31},
    year={},
    publisher={Springer International Publishing}
    }
    """

    errors = BibtexParser.check_string(input)

    assert errors == [{"spidersjs2", [empty_tags: [:year]]}]
  end

  test "Abbreviated Titles" do
    input = """
    @article{tinydb,
    author    = {Samuel Madden and
            Michael J. Franklin and
            Joseph M. Hellerstein and
            Wei Hong},
    title     = {TinyDB: an acquisitional query processing system for sensor networks},
    journal   = {{ACM} Trans. Database Syst.},
    volume    = {30},
    number    = {1},
    pages     = {122--173},
    year      = {2005},
    url       = {https://doi.org/10.1145/1061318.1061322},
    doi       = {10.1145/1061318.1061322},
    timestamp = {Wed, 14 Nov 2018 10:42:12 +0100},
    biburl    = {https://dblp.org/rec/journals/tods/MaddenFHH05.bib},
    bibsource = {dblp computer science bibliography, https://dblp.org}
    }

    """

    errors = BibtexParser.check_string(input)

    assert errors == [{"tinydb", [abbreviated_journal_title: "{ACM} Trans. Database Syst."]}]
  end

  test "Missing tags" do
    input = """
    @incollection{spidersjs2,
    title={Parallel and Distributed Web Programming with Actors},
    author={Myter, Florian and Scholliers, Christophe and De Meuter, Wolfgang},
    booktitle={Programming with Actors: State-of-the-Art and Research Perspectives},
    year={2018},
    publisher={Springer International Publishing}
    }
    """

    errors = BibtexParser.check_string(input)

    assert errors == [{"spidersjs2", [missing_tags: ["pages"]]}]
  end
end
