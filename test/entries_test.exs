defmodule BibTex.Test.Entries do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

  test "Entry Test 0" do
    input = """
    @misc{ Nobody06,
           author = "Nobody Jr",
           title = "My Article",
           year = 2006,
          pages = "1--10", }
    """

    result = %{
      label: 'Nobody06',
      tags: [
        author: 'Nobody Jr',
        title: 'My Article',
        year: '2006',
        pages: '1--10'
      ],
      type: 'misc'
    }

    {:ok, ^result, _} = Parser.parse_entry(input)
  end

  test "Entry Test 1" do
    input = """
    @misc{ Nobody06,
           author = "Nobody Jr",
           title = "My Article",
           year = "2006",
          pages = "1--10", }
    """

    result = %{
      label: 'Nobody06',
      tags: [
        author: 'Nobody Jr',
        title: 'My Article',
        year: '2006',
        pages: '1--10'
      ],
      type: 'misc'
    }

    {:ok, ^result, _} = Parser.parse_entry(input)
  end

  test "Entry Test 2" do
    input = """
    @techreport{agha1985actors,
      title="Actors: A model of concurrent computation in distributed systems.",
      author="Agha, Gul A",
      year="1985",
      institution="MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB"
    }
    """

    result = %{
      label: 'agha1985actors',
      tags: [
        title: 'Actors: A model of concurrent computation in distributed systems.',
        author: 'Agha, Gul A',
        year: '1985',
        institution: 'MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB'
      ],
      type: 'techreport'
    }

    {:ok, ^result, _} = Parser.parse_entry(input)
  end

  test "Entry Test 3" do
    input = """
    @techreport{agha1985actors,
      title={Actors: A model of concurrent computation in distributed systems.},
      author={Agha, Gul A},
      year={1985},
      institution={MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB}
    }
    """

    result = %{
      label: 'agha1985actors',
      tags: [
        title: 'Actors: A model of concurrent computation in distributed systems.',
        author: 'Agha, Gul A',
        year: '1985',
        institution: 'MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB'
      ],
      type: 'techreport'
    }

    {:ok, ^result, _} = Parser.parse_entry(input)
  end

  test "Entry Test 4" do
    input = """
    @techreport{bobscoolpaper,
      title="Elixir" # " is " # "the bees" # " " # "knees",
      author="Jose " # "Valim",
      year={1985},
      institution={MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB}
    }
    """

    result = %{
      label: 'bobscoolpaper',
      tags: [
        title: 'Elixir is the bees knees',
        author: 'Jose Valim',
        year: '1985',
        institution: 'MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB'
      ],
      type: 'techreport'
    }

    {:ok, ^result, _} = Parser.parse_entry(input)
  end

  test "File with comments and multiple entires" do
    file = """
    %  a sample bibliography file
    %

    @article{small,
    author = {Freely, I.P.},
    title = {A small paper},
    journal = {The journal of small papers},
    volume = {-1},
    note = {to appear},
    }

    @article{big,
    author = {Jass, Hugh},
    title = {A big paper},
    journal = {The journal of big papers},
    volume = {MCMXCVII},
    }

    %  The authors mentioned here are almost, but not quite,
    %  entirely unrelated to Matt Groening.
    """

    result =
      {[
         %{
           label: 'small',
           tags: [
             author: 'Freely, I.P.',
             title: 'A small paper',
             journal: 'The journal of small papers',
             volume: '-1',
             note: 'to appear'
           ],
           type: 'article'
         },
         %{
           label: 'big',
           tags: [
             author: 'Jass, Hugh',
             title: 'A big paper',
             journal: 'The journal of big papers',
             volume: 'MCMXCVII'
           ],
           type: 'article'
         }
       ], ""}

    assert result == Parser.parse_entries(file)
  end
end
