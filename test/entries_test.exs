defmodule BibTex.Test.Entries do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

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

    {:ok, ^result} = Parser.parse_entry(input)
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

    {:ok, ^result} = Parser.parse_entry(input)
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

    {:ok, ^result} = Parser.parse_entry(input)
  end
end
