defmodule BibtexParser do
  import BibTex.Parser

  def example do
    input = """
    @techreport{agha1985actors,
    title={Actors: A model of concurrent computation in distributed systems.},
    author={Agha, Gul A},
    year={1985},
    institution={MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB}
    }

    """

    result = parse_entry(input)

    # => {:ok,
    #  %{
    #    label: 'agha1985actors',
    #    tags: [
    #      title: 'Actors: A model of concurrent computation in distributed systems.',
    #      author: 'Agha, Gul A',
    #      year: '1985',
    #      institution: 'MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB'
    #    ],
    #    type: 'techreport'
    #  }}
  end
end
