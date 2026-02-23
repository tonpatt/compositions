"""Class that encapsulates and extends the Random library for musical purposes."""

from math import ceil
from random import Random
from typing import Any, List, Iterable


class Rnd(Random):
    """
    Class that adds specialized stochastic methods to the standard Random class.
    """

    def mess(self, population: Iterable[Any], k: int = 1) -> List[List[Any]]:
        """
        Generates 'k' new lists by picking one random element from each sub-sequence
        found in the population.

        If an element in the population is not a list or tuple, it is kept as a
        constant value in the generated sequences.

        Args:
            population: An iterable containing values or sub-sequences (lists/tuples).
            k: The number of randomized lists to generate.

        Returns:
            A list of 'k' lists containing the randomized selections.

        Raises:
            TypeError: If the population contains no lists or tuples to pick from.
        """
        if any(isinstance(elem, (list, tuple)) for elem in population):
            mlist = []
            for _ in range(k):
                lista = []
                for elem in population:
                    if isinstance(elem, (list, tuple)):
                        lista.append(self.choice(elem))
                    else:
                        lista.append(elem)
                mlist.append(lista)
            return mlist
        raise TypeError("The population must contain at least one list or tuple")

    def step(self, mn: float, mx: float, step: float) -> float:
        """
        Returns a random float between mn and mx, quantized to the nearest step.

        Args:
            mn: Minimum value.
            mx: Maximum value.
            step: The quantization step (resolution).

        Returns:
            A quantized random float.
        """
        return ceil(self.uniform(mx, mn - step) / step) * step

    def coin(self, p: float = 0.5) -> bool:
        """Returns True with probability p (0.0 to 1.0)."""
        return self.random() < p

    def skip(self, n: int = 1) -> "Rnd":
        """Advance random generation n times."""
        for _ in range(n):
            self.random()
        return self
