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
