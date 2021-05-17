import BibtexParser.Parser

ex1 = """
@misc{ Nobody06,
       author = "Nobody Jr",
       title = "My Article",
       year = "2006",
      pages = "1--10", }
"""

ex2 = """
@techreport{agha1985actors,
  title="Actors: A model of concurrent computation in distributed systems.",
  author="Agha, Gul A",
  year="1985",
  institution="MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB"
}
"""

ex3 = """
@techreport{agha1985actors,
  title="Actors: A model of concurrent computation in distributed systems.",
  author={Agha, Gul A},
  year="1985",
  institution="MASSACHUSETTS INST OF TECH CAMBRIDGE ARTIFICIAL INTELLIGENCE LAB"
}
"""

ex4 = """
@article{small,
author = {Freely, I.P.},
title = {A small paper},
journal = {The journal of small papers},
year = 1997,
volume = {-1},
note = {to appear},
}
"""

file = """
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
"""

file_comments = """
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
year = "1997",
volume = {MCMXCVII},
}

%  The authors mentioned here are almost, but not quite,
%  entirely unrelated to Matt Groening.


"""

test = """
% another comment
% second another comment
x y z
"""

ex5 = """
@incollection{spidersjs2,
    title={Parallel and Distributed Web Programming with Actors},
    author={Myter, Florian and Scholliers, Christophe and De Meuter, Wolfgang},
    booktitle={Programming with Actors: State-of-the-Art and Research Perspectives},
    pages={3--31},
    year={2018},
    publisher={Springer International Publishing}
}

@inproceedings{DBLP:conf/cbse/RusselloMD08,
    author    = {Giovanni Russello and
            Leonardo Mostarda and
            Naranker Dulay},
    editor    = {Michel R. V. Chaudron and
            Clemens A. Szyperski and
            Ralf H. Reussner},
    title     = {{ESCAPE:} {A} Component-Based Policy Framework for Sense and React
            Applications},
    booktitle = {Component-Based Software Engineering, 11th International Symposium,
            {CBSE} 2008, Karlsruhe, Germany, October 14-17, 2008. Proceedings},
    series    = {Lecture Notes in Computer Science},
    volume    = {5282},
    pages     = {212--229},
    publisher = {Springer},
    year      = {2008},
    url       = {https://doi.org/10.1007/978-3-540-87891-9\_14},
    doi       = {10.1007/978-3-540-87891-9\_14},
    timestamp = {Tue, 14 May 2019 10:00:47 +0200},
    biburl    = {https://dblp.org/rec/conf/cbse/RusselloMD08.bib},
    bibsource = {dblp computer science bibliography, https://dblp.org}
}
"""

test = fn ->
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

  str = BibtexParser.Writer.to_string(result)
  str
end
