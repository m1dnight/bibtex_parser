import BibTex.Parser

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
