import Base

def pair() -> U32 & U32:
  (3, 4)

def second(p: U32 & U32) -> U32:
  (a, b) = p
  b

def main() -> U32:
  second(pair())
