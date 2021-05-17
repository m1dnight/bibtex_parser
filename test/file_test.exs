defmodule BibTex.Test.File do
  use ExUnit.Case
  doctest BibtexParser
  alias BibTex.Parser

  test "Large File" do
    input = File.read!("test/test.bib")

    expected_entries = [
      %{
        label: 'spidersjs2',
        tags: [
          title: 'Parallel and Distributed Web Programming with Actors',
          author: 'Myter, Florian and Scholliers, Christophe and De Meuter, Wolfgang',
          booktitle: 'Programming with Actors: State-of-the-Art and Research Perspectives',
          pages: '3--31',
          year: '2018',
          publisher: 'Springer International Publishing'
        ],
        type: 'incollection'
      },
      %{
        label: 'DBLP:conf/cbse/RusselloMD08',
        tags: [
          author: 'Giovanni Russello and Leonardo Mostarda and Naranker Dulay',
          editor: 'Michel R. V. Chaudron and Clemens A. Szyperski and Ralf H. Reussner',
          title:
            '{ESCAPE:} {A} Component-Based Policy Framework for Sense and React Applications',
          booktitle:
            'Component-Based Software Engineering, 11th International Symposium, {CBSE} 2008, Karlsruhe, Germany, October 14-17, 2008. Proceedings',
          series: 'Lecture Notes in Computer Science',
          volume: '5282',
          pages: '212--229',
          publisher: 'Springer',
          year: '2008',
          url: 'https://doi.org/10.1007/978-3-540-87891-9\\_14',
          doi: '10.1007/978-3-540-87891-9\\_14',
          timestamp: 'Tue, 14 May 2019 10:00:47 +0200',
          biburl: 'https://dblp.org/rec/conf/cbse/RusselloMD08.bib',
          bibsource: 'dblp computer science bibliography, https://dblp.org'
        ],
        type: 'inproceedings'
      }
    ]

    {entries, rem} = Parser.parse_entries(input)

    assert rem == ""
    assert entries == expected_entries
  end
end
