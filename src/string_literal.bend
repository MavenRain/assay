// A literal String result fits in one checked Word: tag 128 + byte length,
// followed by at most 31 bytes, right padded with zeros. Validated calldata
// offsets are bounded by 131072 bytes and cannot overlap this representation.
// Cli.EventDecode.pairs checks only the length, so ReturnAbi.Literal.word first
// requires every literal character to be a hexadecimal digit (0-9, a-f, A-F).
@unsafe
def ReturnAbi.Literal.return_or_parameter(+pure: Contract.Token, +tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big) -> CheckResult(ReturnAbi.Source):
  match tokens:
    case Con{open, Con{kind, Con{value, Con{close, rest}}}}:
      Native.choose(&2, CheckResult(ReturnAbi.Source), Bool.and(Bool.and(FunctionAbi.eq(open, "("), FunctionAbi.eq(kind, "string")), Bool.not(FunctionAbi.eq(value, ")"))), _ =>
        Native.choose(&2, CheckResult(ReturnAbi.Source), FunctionAbi.eq(close, ")"), _ =>
          CheckResult.bind(String, ReturnAbi.Source, ReturnAbi.Literal.word(value), word => ReturnAbi.scan(rest, ReturnAbi.append(FunctionAbi.tokens(pure, ["pure", "(", "word", word, ")"]), acc), functions, errors, active, result, fresh))
        , _ => Contract.fail(&2, ReturnAbi.Source, close, "ABI", "String literal requires (string 0xHEX) with at most 31 bytes"))
      , _ => ReturnAbi.parameter_return(pure, open <> kind <> value <> close <> rest, acc, functions, errors, active, result, fresh))
    case other: ReturnAbi.parameter_return(pure, other, acc, functions, errors, active, result, fresh)
@unsafe
def ReturnAbi.Literal.word(+token: Contract.Token) -> CheckResult(String):
  +text = {FunctionAbi.text(token) : String}
  +hex = {Model.segment(Big.of_nat(2n), Big.of_nat(String.length(text)), text) : String}
  Native.choose(&2, CheckResult(String), Bool.and(String.starts_with(text, "0x"), Big.is_le(Big.of_nat(String.length(hex)), Big.of_nat(62n))), _ =>
    Native.choose(&2, CheckResult(String), NativeString.all(ReturnAbi.Literal.hex_char, hex), _ =>
      ReturnAbi.Literal.checked(token, hex, Cli.EventDecode.pairs(NativeString.to_list(hex)))
    , _ => Contract.fail(&2, String, token, "ABI", "String literal requires hexadecimal bytes"))
  , _ => Contract.fail(&2, String, token, "ABI", "String literal requires (string 0xHEX) with at most 31 bytes"))
@unsafe
def ReturnAbi.Literal.hex_char(+char: Char) -> Bool:
  ReturnAbi.Literal.digit(Lexer.hex_digit(char))
@unsafe
def ReturnAbi.Literal.digit(+digit: OptionOf(Big)) -> Bool:
  match digit:
    case None{}: False{}
    case Some{_}: True{}
@unsafe
def ReturnAbi.Literal.checked(+token: Contract.Token, +hex: String, +bytes: OptionOf(ListOf(Char))) -> CheckResult(String):
  match bytes:
    case None{}: Contract.fail(&2, String, token, "ABI", "String literal requires even hexadecimal bytes")
    case Some{bytes}:
      +tag = {Big.hex_natural(Big.add(Big.of_nat(128n), Big.of_nat(List.length(&2, Char, bytes)))) : String}
      Done{String.concat(["0x", tag, hex, NativeString.repeat((62n - String.length(hex): Nat), '0')])}
@unsafe
def ReturnAbi.Literal.blocks(+label: String, +copy: String, +next: String, +source: Big, +head: Big, +tuple: Big, +base: Big, +cursor: Big) -> ListOf(Asm.Block):
  +literal = {String.append(label, "literal") : String}
  +dynamic = {String.append(label, "calldata") : String}
  +write = {String.append(label, "literalwrite") : String}
  +length = {Big.add(cursor, Big.of_nat(32n)) : Big}
  +end = {Big.add(cursor, Big.of_nat(64n)) : Big}
  +tag = {List.append(&2, Asm.Instruction, FunctionAbi.load(source), [Emit.number(Big.of_nat(248n)), Asm.Instruction.Op{"SHR"}]) : ListOf(Asm.Instruction)}
  +select = {List.concat(&2, Asm.Instruction, [[Emit.number(Big.of_nat(127n))], tag, [Asm.Instruction.Op{"GT"}]]) : ListOf(Asm.Instruction)}
  +read_length = {List.concat(&2, Asm.Instruction, [[Emit.number(Big.of_nat(128n))], tag, [Asm.Instruction.Op{"SUB"}], FunctionAbi.save(length)]) : ListOf(Asm.Instruction)}
  +size = {List.concat(&2, Asm.Instruction, [FunctionAbi.load(length), [Asm.Instruction.Op{"ISZERO"}, Asm.Instruction.Op{"ISZERO"}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"MUL"}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"ADD"}], FunctionAbi.load(cursor), [Asm.Instruction.Op{"ADD"}], FunctionAbi.save(end)]) : ListOf(Asm.Instruction)}
  +check = {List.concat(&2, Asm.Instruction, [read_length, size, [Emit.number(Big.of_nat(31n))], FunctionAbi.load(length), [Asm.Instruction.Op{"GT"}, Emit.number(Big.of_nat(131072n)), Emit.number(base)], FunctionAbi.load(end), [Asm.Instruction.Op{"SUB"}, Asm.Instruction.Op{"GT"}, Asm.Instruction.Op{"OR"}]]) : ListOf(Asm.Instruction)}
  +offset = {List.concat(&2, Asm.Instruction, [[Emit.number(tuple)], FunctionAbi.load(cursor), [Asm.Instruction.Op{"SUB"}], FunctionAbi.save(head)]) : ListOf(Asm.Instruction)}
  +data = {List.concat(&2, Asm.Instruction, [FunctionAbi.load(length), FunctionAbi.load(cursor), [Asm.Instruction.Op{"MSTORE"}], FunctionAbi.load(source), [Emit.number(Big.of_nat(8n)), Asm.Instruction.Op{"SHL"}], FunctionAbi.load(cursor), [Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"ADD"}, Asm.Instruction.Op{"MSTORE"}], FunctionAbi.load(end), FunctionAbi.save(cursor)]) : ListOf(Asm.Instruction)}
  List.concat(&2, Asm.Block, [[Emit.marked(label, select, Emit.branch_to(literal, dynamic)), FunctionAbi.check(literal, check, write), Emit.marked(write, List.append(&2, Asm.Instruction, offset, data), Emit.goto(next))], ReturnAbi.calldata_string_blocks(dynamic, copy, next, source, head, tuple, base, cursor)])
@unsafe
def ReturnAbi.Literal.value(+value: Big, +data: String) -> OptionOf(Abi.Codec.Value):
  +tag = {Big.shift_right(value, 248n) : Big}
  Native.choose(&2, OptionOf(Abi.Codec.Value), Big.is_lt(tag, Big.of_nat(128n)), _ =>
    +length = {Model.calldata_word(data, Big.add(value, Big.of_nat(4n))) : Big}
    +hex = {Model.segment(Big.mul(Big.add(value, Big.of_nat(36n)), Big.of_nat(2n)), Big.mul(length, Big.of_nat(2n)), data) : String}
    ReturnAbi.string_value(Cli.EventDecode.pairs(NativeString.to_list(hex)))
  , _ => Native.choose(&2, OptionOf(Abi.Codec.Value), Big.is_le(tag, Big.of_nat(159n)), _ =>
    +hex = {Cli.Event.hex(Abi.Codec.word(value)) : String}
    ReturnAbi.string_value(Cli.EventDecode.pairs(NativeString.to_list(Model.segment(Big.of_nat(2n), Big.mul(Big.sub(tag, Big.of_nat(128n)), Big.of_nat(2n)), hex))))
  , _ => None{}))
