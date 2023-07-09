from __future__ import annotations
import sys
from datetime import datetime
from random import choice

from dahlia import Dahlia, Depth

BRIGHT = "acdeacde7"
BRIGHT_TO_DARK = dict(zip(BRIGHT, "245624568"))
DAHLIA = Dahlia(depth=Depth.LOW)


class Rainbow:
    bright = choice(BRIGHT)
    dark = BRIGHT_TO_DARK[bright]

    def __init__(self, prompt: str, *, inherit: bool = False) -> None:
        self._prompt = prompt
        self._inherit = inherit

    def __repr__(self) -> str:
        return repr(self._prompt)

    def __str__(self) -> str:
        if self._inherit:
            bright = self.bright
            dark = self.dark
            time = "        "
        else:
            Rainbow.bright = bright = choice(BRIGHT)
            Rainbow.dark = dark = BRIGHT_TO_DARK[bright]
            time = datetime.now().strftime("%H:%M:%S")
        return DAHLIA.convert(f"&{bright}{time} &{dark}{self._prompt}")


sys.ps1 = Rainbow(">>> ")
sys.ps2 = Rainbow("... ", inherit=True)

type(exit).__repr__ = lambda self: self()