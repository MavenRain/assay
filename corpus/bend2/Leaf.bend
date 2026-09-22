import Base

type EvmOpcodes is Data:
  Witness{}

def witness() -> EvmOpcodes:
  Witness{}

def identity_proof(p: EvmOpcodes) -> EvmOpcodes:
  p

def with_proof(-p: EvmOpcodes, x: U32) -> U32:
  x

def main() -> U32:
  with_proof(witness(), 42)
