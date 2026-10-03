# Source function ABI integration. Word entries retain the carried ABI behavior.
type FunctionAbi.Args is Data:
  FunctionAbi.Args{inputs: ListOf(Abi.Schema.Parameter), tokens: ListOf(Contract.Token), rest: ListOf(Contract.Token), typed: Bool}
type FunctionAbi.Source is Data:
  FunctionAbi.Source{tokens: ListOf(Contract.Token), functions: ListOf(Abi.Schema.Function_)}
def FunctionAbi.Functions() -> Data: ListOf(Abi.Schema.Function_)
def FunctionAbi.Packet() -> Data: TupleOf5(ListOf(Emit.Entry), Emit.Effect, ListOf(String), ListOf(TupleOf2(Abi.Custom_error, String)), OptionOf(Emit.Transaction))
@unsafe
def FunctionAbi.text(+token: Contract.Token) -> String: Get.Contract.Token.text(token)
@unsafe
def FunctionAbi.eq(+token: Contract.Token, +text: String) -> Bool: NativeString.equal(FunctionAbi.text(token), text)
@unsafe
def FunctionAbi.tokens(+at: Contract.Token, +texts: ListOf(String)) -> ListOf(Contract.Token):
  SeqList.map(&2, &2, String, Contract.Token, text => MkContract_Token{text, Get.Contract.Token.line(at), Get.Contract.Token.col(at)}, texts)
@unsafe
def FunctionAbi.typ(+token: Contract.Token) -> OptionOf(Abi.Schema.Value_type):
  Native.choose(&2, OptionOf(Abi.Schema.Value_type), FunctionAbi.eq(token, "String"), _ => Some{Abi.Schema.Value_type.String{}}, _ => Packed.Source.typ(FunctionAbi.text(token)))
@unsafe
def FunctionAbi.enabled(+tokens: ListOf(Contract.Token)) -> Bool:
  match tokens:
    case Con{open, Con{name, Con{colon, Con{typ, Con{close, rest}}}}}:
      Bool.or(Bool.and(Bool.and(FunctionAbi.eq(open, "("), FunctionAbi.eq(colon, ":")), Bool.and(FunctionAbi.eq(close, ")"), Bool.and(Bool.not(FunctionAbi.eq(typ, "Word")), Maybe.is_some(&2, Abi.Schema.Value_type, FunctionAbi.typ(typ))))), FunctionAbi.enabled(name <> colon <> typ <> close <> rest))
    case Nil{}: False{}
    case Con{_, tail}: FunctionAbi.enabled(tail)
@unsafe
def FunctionAbi.args(+tokens: ListOf(Contract.Token), +inputs: ListOf(Abi.Schema.Parameter), +acc: ListOf(Contract.Token), +typed: Bool) -> CheckResult(FunctionAbi.Args):
  match tokens:
    case Con{open, Con{name, Con{colon, Con{typ, Con{close, rest}}}}}:
      Native.choose(&2, CheckResult(FunctionAbi.Args), FunctionAbi.eq(open, "("), _ =>
        Native.choose(&2, CheckResult(FunctionAbi.Args), FunctionAbi.eq(name, ")"), _ =>
          Done{FunctionAbi.Args{List.reverse(&2, Abi.Schema.Parameter, inputs), List.reverse(&2, Contract.Token, name <> open <> acc), colon <> typ <> close <> rest, typed}}
        , _ => Native.choose(&2, CheckResult(FunctionAbi.Args), Bool.and(FunctionAbi.eq(colon, ":"), FunctionAbi.eq(close, ")")), _ =>
          FunctionAbi.arg_type(open, name, colon, typ, close, rest, inputs, acc, typed, FunctionAbi.typ(typ))
        , _ => Contract.fail(&2, FunctionAbi.Args, open, "ABI", "expected (name : ABI type)")))
      , _ => Done{FunctionAbi.Args{List.reverse(&2, Abi.Schema.Parameter, inputs), List.reverse(&2, Contract.Token, acc), tokens, typed}})
    case Con{open, Con{close, rest}}:
      Native.choose(&2, CheckResult(FunctionAbi.Args), Bool.and(FunctionAbi.eq(open, "("), FunctionAbi.eq(close, ")")), _ =>
        Done{FunctionAbi.Args{List.reverse(&2, Abi.Schema.Parameter, inputs), List.reverse(&2, Contract.Token, close <> open <> acc), rest, typed}}
      , _ => Done{FunctionAbi.Args{List.reverse(&2, Abi.Schema.Parameter, inputs), List.reverse(&2, Contract.Token, acc), tokens, typed}})
    case Nil{}: Done{FunctionAbi.Args{List.reverse(&2, Abi.Schema.Parameter, inputs), List.reverse(&2, Contract.Token, acc), [], typed}}
    case Con{_, Nil{}}: Done{FunctionAbi.Args{List.reverse(&2, Abi.Schema.Parameter, inputs), List.reverse(&2, Contract.Token, acc), tokens, typed}}
@unsafe
def FunctionAbi.arg_type(+open: Contract.Token, +name: Contract.Token, +colon: Contract.Token, +typ: Contract.Token, +close: Contract.Token, +rest: ListOf(Contract.Token), +inputs: ListOf(Abi.Schema.Parameter), +acc: ListOf(Contract.Token), +typed: Bool, +value: OptionOf(Abi.Schema.Value_type)) -> CheckResult(FunctionAbi.Args):
  match value:
    case None{}: Contract.fail(&2, FunctionAbi.Args, typ, "ABI", "unsupported function parameter type")
    case Some{value}:
      FunctionAbi.args(rest, MkAbi_Schema_Parameter{FunctionAbi.text(name), value} <> inputs, close <> Packed.Source.word_token(Get.Contract.Token.line(typ), Get.Contract.Token.col(typ)) <> colon <> name <> open <> acc, Bool.or(typed, Bool.not(FunctionAbi.eq(typ, "Word"))))
@unsafe
def FunctionAbi.is_string(+inputs: ListOf(Abi.Schema.Parameter), +name: Contract.Token) -> Bool:
  SeqList.exists(&2, Abi.Schema.Parameter, parameter =>
    Bool.and(NativeString.equal(Get.Abi.Schema.Parameter.name(parameter), FunctionAbi.text(name)), FunctionAbi.dynamic(Get.Abi.Schema.Parameter.typ(parameter))), inputs)
def FunctionAbi.dynamic(+typ: Abi.Schema.Value_type) -> Bool:
  match typ:
    case Abi.Schema.Value_type.String{}: True{}
    case Abi.Schema.Value_type.Uint8{}: False{}
    case Abi.Schema.Value_type.Uint256{}: False{}
    case Abi.Schema.Value_type.Address{}: False{}
    case Abi.Schema.Value_type.Bool{}: False{}
@unsafe
def FunctionAbi.scan(+tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +active: ListOf(Abi.Schema.Parameter), +fresh: Big) -> CheckResult(FunctionAbi.Source):
  match tokens:
    case Nil{}: Done{FunctionAbi.Source{List.reverse(&2, Contract.Token, acc), List.reverse(&2, Abi.Schema.Function_, functions)}}
    case Con{target, Con{bind, Con{operation, Con{argument, tail}}}}:
      Native.choose(&2, CheckResult(FunctionAbi.Source), Bool.and(FunctionAbi.eq(bind, "<-"), Bool.or(FunctionAbi.eq(operation, "stringlength"), FunctionAbi.eq(operation, "stringdata"))), _ =>
        Native.choose(&2, CheckResult(FunctionAbi.Source), Bool.and(FunctionAbi.is_string(active, argument), Bool.not(FunctionAbi.is_string(active, target))), _ =>
          FunctionAbi.string_op(target, operation, argument, tail, acc, functions, active, fresh)
        , _ => Contract.fail(&2, FunctionAbi.Source, argument, "ABI", "string operation requires a String parameter"))
      , _ => FunctionAbi.scan_token(target, bind <> operation <> argument <> tail, acc, functions, active, fresh))
    case Con{token, tail}: FunctionAbi.scan_token(token, tail, acc, functions, active, fresh)
@unsafe
def FunctionAbi.string_op(+target: Contract.Token, +operation: Contract.Token, +argument: Contract.Token, +tail: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +active: ListOf(Abi.Schema.Parameter), +fresh: Big) -> CheckResult(FunctionAbi.Source):
  +scratch = String.append("assayAbiCursor", Big.show(fresh))
  +prefix = {[scratch, "<-", "add", FunctionAbi.text(argument), "(", "word", "4", ")", ";", FunctionAbi.text(target), "<-", "calldataload", scratch] : ListOf(String)}
  +data = {[FunctionAbi.text(target), "<-", "add", FunctionAbi.text(argument), "(", "word", "36", ")"] : ListOf(String)}
  +replacement = Native.choose(&2, ListOf(String), FunctionAbi.eq(operation, "stringlength"), _ => prefix, _ => data)
  FunctionAbi.scan(tail, List.append(&2, Contract.Token, List.reverse(&2, Contract.Token, FunctionAbi.tokens(target, replacement)), acc), functions, active, Big.add(fresh, Big.one()))
@unsafe
def FunctionAbi.scan_token(+token: Contract.Token, +tail: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +active: ListOf(Abi.Schema.Parameter), +fresh: Big) -> CheckResult(FunctionAbi.Source):
  Native.choose(&2, CheckResult(FunctionAbi.Source), FunctionAbi.eq(token, "entry"), _ =>
    FunctionAbi.entry_start(token, tail, acc, functions, fresh)
  , _ => Native.choose(&2, CheckResult(FunctionAbi.Source), FunctionAbi.is_string(active, token), _ =>
    Contract.fail(&2, FunctionAbi.Source, token, "ABI", "String parameters require stringlength or stringdata")
  , _ => FunctionAbi.scan(tail, token <> acc, functions, Native.choose(&2, ListOf(Abi.Schema.Parameter), Mapping.Source.declaration(FunctionAbi.text(token)), _ => [], _ => active), fresh)))
@unsafe
def FunctionAbi.entry_start(+token: Contract.Token, +tail: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +fresh: Big) -> CheckResult(FunctionAbi.Source):
  match tail:
    case Con{name, rest}: CheckResult.bind(FunctionAbi.Args, FunctionAbi.Source, FunctionAbi.args(rest, [], [], False{}), args => FunctionAbi.entry(token, name, args, acc, functions, fresh))
    case Nil{}: Contract.fail(&2, FunctionAbi.Source, token, "ABI", "expected function name")
@unsafe
def FunctionAbi.entry(+entry: Contract.Token, +name: Contract.Token, +args: FunctionAbi.Args, +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +fresh: Big) -> CheckResult(FunctionAbi.Source):
  match args:
    case FunctionAbi.Args{inputs, tokens, rest, typed}:
      +fn = {MkAbi_Schema_Function_{FunctionAbi.text(name), inputs, [Abi.word("")], Abi.Mutability.Nonpayable{}} : Abi.Schema.Function_}
      FunctionAbi.scan(rest, List.append(&2, Contract.Token, List.reverse(&2, Contract.Token, tokens), name <> entry <> acc), Native.choose(&2, FunctionAbi.Functions(), typed, _ => fn <> functions, _ => functions), inputs, fresh)
@unsafe
def FunctionAbi.lower(+source: String) -> CheckResult(Mapping.Runtime.Packet()):
  Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), Packed.Source.contract(source), _ =>
    Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), Big.is_lt(Big.of_nat(65536n), Big.of_nat(String.length(source))), _ =>
      Contract.fail(&2, Mapping.Runtime.Packet(), Contract.here([]), "LIMIT", "contract source exceeds 65536 bytes")
    , _ => CheckResult.bind(ListOf(Contract.Token), Mapping.Runtime.Packet(), Contract.lex(Series.from_string(source)), +tokens =>
      Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), FunctionAbi.enabled(tokens), _ => Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), SeqList.exists(&2, Contract.Token, token => String.starts_with(FunctionAbi.text(token), "assayAbi"), tokens), _ =>
        Contract.fail(&2, Mapping.Runtime.Packet(), Contract.here(tokens), "RESERVED", "assayAbi names are reserved for ABI lowering")
      , _ => CheckResult.bind(FunctionAbi.Source, Mapping.Runtime.Packet(), FunctionAbi.scan(tokens, [], [], [], Big.zero()), normalized => FunctionAbi.normalized(source, normalized))), _ => Mapping.Runtime.lower(source))))
  , _ => Mapping.Runtime.lower(source))
@unsafe
def FunctionAbi.normalized(+original: String, +source: FunctionAbi.Source) -> CheckResult(Mapping.Runtime.Packet()):
  match source:
    case FunctionAbi.Source{tokens, functions}:
      match functions:
        case Nil{}: Mapping.Runtime.lower(original)
        case Con{_, _}:
          CheckResult.bind(Mapping.Runtime.Packet(), Mapping.Runtime.Packet(), Mapping.Runtime.lexed(tokens), packet => FunctionAbi.wrap(functions, packet))
def FunctionAbi.wrap(+functions: FunctionAbi.Functions(), +packet: Mapping.Runtime.Packet()) -> CheckResult(Mapping.Runtime.Packet()):
  match packet:
    case Tup2{info, plan}: Done{Tup2{info, Mapping.Runtime.Plan.Functions{functions, plan}}}
@unsafe
def FunctionAbi.find(+functions: FunctionAbi.Functions(), +name: String) -> OptionOf(Abi.Schema.Function_):
  SeqList.find(&2, Abi.Schema.Function_, fn => NativeString.equal(Get.Abi.Schema.Function_.name(fn), name), functions)
@unsafe
def FunctionAbi.function(+entry: Abi.Entry, +functions: FunctionAbi.Functions()) -> Abi.Schema.Function_:
  FunctionAbi.function_found(entry, FunctionAbi.find(functions, Get.Abi.Entry.name(entry)))
@unsafe
def FunctionAbi.function_found(+entry: Abi.Entry, +found: OptionOf(Abi.Schema.Function_)) -> Abi.Schema.Function_:
  match found:
    case None{}: MkAbi_Schema_Function_{Get.Abi.Entry.name(entry), SeqList.map(&2, &2, String, Abi.Schema.Parameter, Abi.word, Get.Abi.Entry.inputs(entry)), [Abi.word("")], Get.Abi.Entry.mutability(entry)}
    case Some{fn}: MkAbi_Schema_Function_{Get.Abi.Entry.name(entry), Get.Abi.Schema.Function_.inputs(fn), [Abi.word("")], Get.Abi.Entry.mutability(entry)}
@unsafe
def FunctionAbi.entries(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry)) -> ListOf(Emit.Entry):
  SeqList.map(&2, &2, Emit.Entry, Emit.Entry, entry => FunctionAbi.entry_value(functions, entry), entries)
@unsafe
def FunctionAbi.entry_value(+functions: FunctionAbi.Functions(), +entry: Emit.Entry) -> Emit.Entry:
  match entry:
    case MkEmit_Entry{abi, selector, tx}:
      MkEmit_Entry{abi, Native.choose(&2, String, Maybe.is_some(&2, Abi.Schema.Function_, FunctionAbi.find(functions, Get.Abi.Entry.name(abi))), _ => Keccak.selector(Abi.Schema.function_signature(FunctionAbi.function(abi, functions))), _ => selector), tx}
@unsafe
def FunctionAbi.entry_table(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry)) -> Emit.Result(ListOf(Emit.Entry)):
  +typed = FunctionAbi.entries(functions, entries)
  +selectors = SeqList.map(&2, &2, Emit.Entry, String, entry => Get.Emit.Entry.selector(entry), typed)
  +unique = SeqList.sort_uniq(&2, String, left => right => NativeString.compare(left, right), selectors)
  Native.choose(&2, Emit.Result(ListOf(Emit.Entry)), Big.is_eq(Big.of_nat(List.length(&2, String, selectors)), Big.of_nat(List.length(&2, String, unique))), _ => Done{typed}, _ => Fail{Emit.Error.Invalid_ir{"ABI: function selector collision"}})
@unsafe
def FunctionAbi.abi(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +errors: ListOf(TupleOf2(Abi.Custom_error, String)), +fallback: OptionOf(Emit.Transaction)) -> String:
  +declarations = SeqList.map(&2, &2, Emit.Entry, Abi.Schema.Declaration, entry => Abi.Schema.Declaration.Function{FunctionAbi.function(Get.Emit.Entry.abi_entry(entry), functions)}, entries)
  +error_rows = SeqList.map(&2, &2, TupleOf2(Abi.Custom_error, String), Abi.Schema.Declaration, FunctionAbi.error_declaration, errors)
  Abi.Schema.print(Abi.Schema.Declaration.Constructor{[], False{}} <> List.append(&2, Abi.Schema.Declaration, declarations, List.append(&2, Abi.Schema.Declaration, error_rows, Native.choose(&2, ListOf(Abi.Schema.Declaration), Maybe.is_some(&2, Emit.Transaction, fallback), _ => [Abi.Schema.Declaration.Fallback{False{}}], _ => []))))
@unsafe
def FunctionAbi.error_declaration(+row: TupleOf2(Abi.Custom_error, String)) -> Abi.Schema.Declaration:
  match row:
    case Tup2{error, _}: Abi.Schema.Declaration.Error{Get.Abi.Custom_error.error_name(error), SeqList.map(&2, &2, String, Abi.Schema.Parameter, Abi.word, Get.Abi.Custom_error.arguments(error))}
@unsafe
def FunctionAbi.load(+address: Big) -> ListOf(Asm.Instruction): [Emit.number(address), Asm.Instruction.Op{"MLOAD"}]
@unsafe
def FunctionAbi.save(+address: Big) -> ListOf(Asm.Instruction): [Emit.number(address), Asm.Instruction.Op{"MSTORE"}]
@unsafe
def FunctionAbi.head(+index: Big) -> ListOf(Asm.Instruction): [Emit.number(Big.add(Big.of_nat(4n), Big.mul(index, Big.of_nat(32n)))), Asm.Instruction.Op{"CALLDATALOAD"}]
@unsafe
def FunctionAbi.check(+label: String, +code: ListOf(Asm.Instruction), +next: String) -> Asm.Block:
  Emit.marked(label, code, Emit.branch_to("reject", next))
@unsafe
def FunctionAbi.label(+root: String, +index: Big) -> String: String.concat([root, "abi", Big.show(index)])
@unsafe
def FunctionAbi.constraints(+parameters: ListOf(Abi.Schema.Parameter), +index: Big, +root: String, +cursor: Big, +length: Big) -> ListOf(TupleOf2(String, ListOf(Asm.Instruction))):
  match parameters:
    case Nil{}:
      [Tup2{FunctionAbi.label(root, index), List.append(&2, Asm.Instruction, FunctionAbi.load(cursor), [Emit.number(Big.of_nat(4n)), Asm.Instruction.Op{"ADD"}, Asm.Instruction.Op{"CALLDATASIZE"}, Asm.Instruction.Op{"EQ"}, Asm.Instruction.Op{"ISZERO"}])}]
    case Con{parameter, tail}:
      +typ = Get.Abi.Schema.Parameter.typ(parameter)
      +checks = Native.choose(&2, ListOf(TupleOf2(String, ListOf(Asm.Instruction))), FunctionAbi.dynamic(typ), _ => FunctionAbi.string_checks(root, index, cursor, length), _ =>
        FunctionAbi.bound_check(root, index, FunctionAbi.bound(typ)))
      List.append(&2, TupleOf2(String, ListOf(Asm.Instruction)), checks, FunctionAbi.constraints(tail, Big.add(index, Big.one()), root, cursor, length))
@unsafe
def FunctionAbi.bound(+typ: Abi.Schema.Value_type) -> OptionOf(Big):
  match typ:
    case Abi.Schema.Value_type.Uint8{}: Some{Big.of_nat(255n)}
    case Abi.Schema.Value_type.Address{}: Some{Big.sub(Big.shift_left(Big.one(), 160n), Big.one())}
    case Abi.Schema.Value_type.Bool{}: Some{Big.one()}
    case Abi.Schema.Value_type.Uint256{}: None{}
    case Abi.Schema.Value_type.String{}: None{}
@unsafe
def FunctionAbi.bound_check(+root: String, +index: Big, +value: OptionOf(Big)) -> ListOf(TupleOf2(String, ListOf(Asm.Instruction))):
  match value:
    case None{}: []
    case Some{bound}: [Tup2{FunctionAbi.label(root, index), Emit.number(bound) <> List.append(&2, Asm.Instruction, FunctionAbi.head(index), [Asm.Instruction.Op{"GT"}])}]
@unsafe
def FunctionAbi.string_checks(+root: String, +index: Big, +cursor: Big, +length: Big) -> ListOf(TupleOf2(String, ListOf(Asm.Instruction))):
  +label = FunctionAbi.label(root, index)
  +offset = List.append(&2, Asm.Instruction, FunctionAbi.head(index), List.append(&2, Asm.Instruction, FunctionAbi.load(cursor), [Asm.Instruction.Op{"EQ"}, Asm.Instruction.Op{"ISZERO"}]))
  +size = List.append(&2, Asm.Instruction, FunctionAbi.load(cursor), List.append(&2, Asm.Instruction, [Emit.number(Big.of_nat(4n)), Asm.Instruction.Op{"ADD"}, Asm.Instruction.Op{"CALLDATALOAD"}, Asm.Instruction.Dup{Big.one()}], List.append(&2, Asm.Instruction, FunctionAbi.save(length), [Emit.number(Big.of_nat(131072n)), Asm.Instruction.Swap{Big.one()}, Asm.Instruction.Op{"GT"}])))
  +advance = List.append(&2, Asm.Instruction, FunctionAbi.load(length), List.append(&2, Asm.Instruction, [Emit.number(Big.of_nat(31n)), Asm.Instruction.Op{"ADD"}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Swap{Big.one()}, Asm.Instruction.Op{"DIV"}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"MUL"}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"ADD"}], List.append(&2, Asm.Instruction, FunctionAbi.load(cursor), List.append(&2, Asm.Instruction, [Asm.Instruction.Op{"ADD"}, Asm.Instruction.Dup{Big.one()}], List.append(&2, Asm.Instruction, FunctionAbi.save(cursor), [Emit.number(Big.of_nat(4n)), Asm.Instruction.Op{"ADD"}, Asm.Instruction.Op{"CALLDATASIZE"}, Asm.Instruction.Op{"LT"}])))))
  +padding = List.append(&2, Asm.Instruction, FunctionAbi.load(length), List.append(&2, Asm.Instruction, [Emit.number(Big.of_nat(32n)), Asm.Instruction.Swap{Big.one()}, Asm.Instruction.Op{"MOD"}, Asm.Instruction.Dup{Big.one()}, Asm.Instruction.Op{"ISZERO"}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"MUL"}, Asm.Instruction.Op{"ADD"}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"SUB"}, Asm.Instruction.Dup{Big.one()}], List.append(&2, Asm.Instruction, FunctionAbi.load(cursor), [Emit.number(Big.of_nat(4n)), Asm.Instruction.Op{"ADD"}, Asm.Instruction.Op{"SUB"}, Asm.Instruction.Op{"CALLDATALOAD"}, Asm.Instruction.Swap{Big.one()}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"SUB"}, Emit.number(Big.of_nat(8n)), Asm.Instruction.Op{"MUL"}, Asm.Instruction.Op{"SHR"}])))
  [Tup2{label, offset}, Tup2{String.append(label, "size"), size}, Tup2{String.append(label, "range"), advance}, Tup2{String.append(label, "padding"), padding}]
@unsafe
def FunctionAbi.chain(+checks: ListOf(TupleOf2(String, ListOf(Asm.Instruction))), +next: String) -> ListOf(Asm.Block):
  match checks:
    case Nil{}: []
    case Con{Tup2{label, code}, tail}:
      +destination = FunctionAbi.first_label(tail, next)
      FunctionAbi.check(label, code, destination) <> FunctionAbi.chain(tail, next)
def FunctionAbi.first_label(+checks: ListOf(TupleOf2(String, ListOf(Asm.Instruction))), +next: String) -> String:
  match checks:
    case Nil{}: next
    case Con{Tup2{label, _}, _}: label
@unsafe
def FunctionAbi.validation(+root: String, +fn: Abi.Schema.Function_, +scratch: Big) -> ListOf(Asm.Block):
  +inputs = Get.Abi.Schema.Function_.inputs(fn)
  +initial = {[Emit.number(Big.mul(Big.of_nat(List.length(&2, Abi.Schema.Parameter, inputs)), Big.of_nat(32n)))] : ListOf(Asm.Instruction)}
  +code = List.append(&2, Asm.Instruction, initial, List.append(&2, Asm.Instruction, FunctionAbi.save(scratch), [Emit.number(Big.of_nat(131072n)), Asm.Instruction.Op{"CALLDATASIZE"}, Asm.Instruction.Op{"GT"}]))
  +checks = FunctionAbi.constraints(inputs, Big.zero(), root, scratch, Big.add(scratch, Big.of_nat(32n)))
  FunctionAbi.check(root, code, FunctionAbi.first_label(checks, String.append(root, "impl"))) <> FunctionAbi.chain(checks, String.append(root, "impl"))
@unsafe
def FunctionAbi.block(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +block: Asm.Block, +scratch: Big) -> ListOf(Asm.Block):
  +schemas = SeqList.mapi(&2, &2, Emit.Entry, TupleOf2(String, OptionOf(Abi.Schema.Function_)), index => entry => Tup2{String.concat(["entry", Big.show(index), "body"]), FunctionAbi.find(functions, Get.Abi.Entry.name(Get.Emit.Entry.abi_entry(entry)))}, entries)
  +schema = SeqList.find(&2, TupleOf2(String, OptionOf(Abi.Schema.Function_)), row => NativeString.equal(Get.Tuple2.v0(&2, String, &2, OptionOf(Abi.Schema.Function_), row), Get.Asm.Block.label(block)), schemas)
  FunctionAbi.block_found(schema, block, scratch)
@unsafe
def FunctionAbi.block_found(+schema: OptionOf(TupleOf2(String, OptionOf(Abi.Schema.Function_))), +block: Asm.Block, +scratch: Big) -> ListOf(Asm.Block):
  match schema:
    case Some{Tup2{root, Some{fn}}}:
      FunctionAbi.renamed(root, fn, block, scratch)
    case Some{Tup2{_, None{}}}: [block]
    case None{}: [block]
@unsafe
def FunctionAbi.renamed(+root: String, +fn: Abi.Schema.Function_, +block: Asm.Block, +scratch: Big) -> ListOf(Asm.Block):
  match block:
    case MkAsm_Block{_, destination, stack, code, ending}: List.append(&2, Asm.Block, FunctionAbi.validation(root, fn, scratch), [MkAsm_Block{String.append(root, "impl"), destination, stack, code, ending}])
@unsafe
def FunctionAbi.blocks(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +fallback: OptionOf(Emit.Transaction)) -> ListOf(Asm.Block):
  +blocks = Emit.dispatch_blocks(fallback, entries)
  +scratch = Big.add(Big.of_nat(96n), Emit.Mapping.base(blocks, Emit.Mapping.high(blocks, Some{Big.zero()})))
  List.concat(&2, Asm.Block, SeqList.map(&2, &2, Asm.Block, ListOf(Asm.Block), block => FunctionAbi.block(functions, entries, block, scratch), blocks))
@unsafe
def FunctionAbi.prepare(+export: String, +globals: Global, +erased: ListOf(TupleOf2(String, Erase.Entry)), +plan: Mapping.Runtime.Plan) -> Emit.Result(FunctionAbi.Packet()):
  match plan:
    case Mapping.Runtime.Plan.Mapped{_, cells}: Emit.Mapping.prepare_m1(export, globals, erased, cells)
    case Mapping.Runtime.Plan.Plain{}: Emit.prepare_m1(export, globals, erased)
    case Mapping.Runtime.Plan.Functions{_, inner}: FunctionAbi.prepare(export, globals, erased, inner)
@unsafe
def FunctionAbi.program(+contract: String, +export: String, +globals: Global, +rows: ListOf(TupleOf2(String, Global.Entry)), +erased: ListOf(TupleOf2(String, Erase.Entry)), +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +plan: Mapping.Runtime.Plan) -> Emit.Result(Emit.Output):
  Emit.Result.bind(FunctionAbi.Packet(), Emit.Output, FunctionAbi.prepare(export, globals, erased, plan), packet => FunctionAbi.prepared(contract, rows, parameters, functions, plan, packet))
@unsafe
def FunctionAbi.prepared(+contract: String, +rows: ListOf(TupleOf2(String, Global.Entry)), +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +plan: Mapping.Runtime.Plan, +packet: FunctionAbi.Packet()) -> Emit.Result(Emit.Output):
  match packet:
    case Tup5{original, constructor, names, errors, fallback}:
      Emit.Result.bind(ListOf(Emit.Entry), Emit.Output, FunctionAbi.entry_table(functions, original), entries => FunctionAbi.prepared_entries(entries, contract, rows, parameters, functions, plan, constructor, names, errors, fallback))
@unsafe
def FunctionAbi.prepared_entries(+entries: ListOf(Emit.Entry), +contract: String, +rows: ListOf(TupleOf2(String, Global.Entry)), +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +plan: Mapping.Runtime.Plan, +constructor: Emit.Effect, +names: ListOf(String), +errors: ListOf(TupleOf2(Abi.Custom_error, String)), +fallback: OptionOf(Emit.Transaction)) -> Emit.Result(Emit.Output):
  +blocks = FunctionAbi.blocks(functions, entries, fallback)
  +abi = FunctionAbi.abi(functions, entries, errors, fallback)
  FunctionAbi.prepared_plan(plan, parameters, contract, constructor, rows, abi, names, blocks)
@unsafe
def FunctionAbi.prepared_plan(+plan: Mapping.Runtime.Plan, +parameters: Packed.Parameters(), +contract: String, +constructor: Emit.Effect, +rows: ListOf(TupleOf2(String, Global.Entry)), +abi: String, +names: ListOf(String), +blocks: ListOf(Asm.Block)) -> Emit.Result(Emit.Output):
  match plan:
    case Mapping.Runtime.Plan.Mapped{schema, cells}:
      Emit.Result.bind(Asm, Emit.Output, Emit.Mapping.assemble(blocks, cells), program => Emit.Result.bind(Emit.Output, Emit.Output, Emit.output(contract, "generated function ABI listing", runtime => Emit.Mapping.init(runtime, constructor, cells), abi, names, rows, program), output => Emit.Mapping.output(schema, output)))
    case Mapping.Runtime.Plan.Plain{}: FunctionAbi.plain(parameters, contract, constructor, rows, abi, names, blocks)
    case Mapping.Runtime.Plan.Functions{_, inner}: FunctionAbi.prepared_plan(inner, parameters, contract, constructor, rows, abi, names, blocks)
@unsafe
def FunctionAbi.plain(+parameters: Packed.Parameters(), +contract: String, +constructor: Emit.Effect, +rows: ListOf(TupleOf2(String, Global.Entry)), +abi: String, +names: ListOf(String), +blocks: ListOf(Asm.Block)) -> Emit.Result(Emit.Output):
  match parameters:
    case Nil{}: Emit.Result.bind(Asm, Emit.Output, Emit.assemble(blocks), program => Emit.output(contract, "generated function ABI listing", runtime => Emit.init_m1(runtime, constructor), abi, names, rows, program))
    case Con{_, _}: FunctionAbi.packed(contract, constructor, rows, parameters, abi, names, blocks, Layout.Packed.plan(parameters))
@unsafe
def FunctionAbi.packed(+contract: String, +constructor: Emit.Effect, +rows: ListOf(TupleOf2(String, Global.Entry)), +parameters: Packed.Parameters(), +abi: String, +names: ListOf(String), +blocks: ListOf(Asm.Block), +fields: Layout.Packed.Result(ListOf(Layout.Packed.Field))) -> Emit.Result(Emit.Output):
  match fields:
    case Fail{_}: Fail{Emit.Error.Invalid_ir{"ABI: invalid packed layout"}}
    case Done{fields}:
      Native.choose(&2, Emit.Result(Emit.Output), Emit.Packed.names(fields, names), _ => Emit.Result.bind(Asm, Emit.Output, Emit.Packed.assemble(blocks, fields), program => Emit.Packed.output(contract, constructor, fields, parameters, abi, names, rows, program)), _ => Fail{Emit.Error.Invalid_ir{"ABI: source layout differs from checked core"}})
@unsafe
def FunctionAbi.model_program(+functions: FunctionAbi.Functions(), +program: Model.Program) -> Model.Result(Model.Program):
  match program:
    case Model.Program.Closed{effect}: Done{Model.Program.Closed{effect}}
    case Model.Program.Entries{entries, fallback}: FunctionAbi.model_entries(fallback, FunctionAbi.entry_table(functions, entries))
def FunctionAbi.model_entries(+fallback: Emit.Transaction, +entries: Emit.Result(ListOf(Emit.Entry))) -> Model.Result(Model.Program):
  match entries:
    case Done{entries}: Done{Model.Program.Entries{entries, fallback}}
    case Fail{error}: Fail{Model.Error.Source{error}}
@unsafe
def FunctionAbi.valid(+functions: FunctionAbi.Functions(), +input: Model.Input) -> Bool:
  +data = Get.Model.Input.data(input)
  +selector = Model.segment(Big.zero(), Big.of_nat(8n), data)
  +fn = SeqList.find(&2, Abi.Schema.Function_, fn => NativeString.equal(Keccak.selector(Abi.Schema.function_signature(fn)), selector), functions)
  FunctionAbi.valid_fn(fn, data)
@unsafe
def FunctionAbi.valid_fn(+fn: OptionOf(Abi.Schema.Function_), +data: String) -> Bool:
  match fn:
    case None{}: True{}
    case Some{fn}: FunctionAbi.valid_bytes(fn, Cli.EventDecode.pairs(NativeString.to_list(data)))
@unsafe
def FunctionAbi.valid_bytes(+fn: Abi.Schema.Function_, +bytes: OptionOf(ListOf(Char))) -> Bool:
  match bytes:
    case None{}: False{}
    case Some{chars}: FunctionAbi.valid_decode(Abi.Call.decode(fn, NativeString.of_list(chars)))
def FunctionAbi.valid_decode(+decoded: Abi.Call.Result(ListOf(Abi.Codec.Value))) -> Bool:
  match decoded:
    case Done{_}: True{}
    case Fail{_}: False{}
@unsafe
def Cli.FunctionAbi.compile(+command: String, +export: String, +source: Cli.Program, +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +plan: Mapping.Runtime.Plan) -> IO(Emit.Output):
  match source:
    case Cli.Program{contract, globals, rows, erased}: Cli.compiled(command, FunctionAbi.program(contract, export, globals, rows, erased, parameters, functions, plan))
@unsafe
def Cli.FunctionAbi.run(+export: String, +input: Model.Input, +source: Cli.Program, +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +plan: Mapping.Runtime.Plan) -> IO(Unit):
  match source:
    case Cli.Program{_, globals, _, erased}: do IO<Unit>:
      program : Model.Program <- Cli.model_result(Model.Program, 2, FunctionAbi.model_prepare(export, globals, erased, plan))
      typed : Model.Program <- Cli.model_result(Model.Program, 2, FunctionAbi.model_program(functions, program))
      outcome : Model.Outcome <- Cli.model_result(Model.Outcome, 2, Native.choose(&2, Model.Result(Model.Outcome), FunctionAbi.valid(functions, input), _ => FunctionAbi.model_run(parameters, plan, typed, input), _ => Done{MkModel_Outcome{True{}, "0x", Get.Model.Input.initial(input)}}))
      NativeIO.stdout(Model.print(outcome))
@unsafe
def FunctionAbi.model_prepare(+export: String, +globals: Global, +erased: ListOf(TupleOf2(String, Erase.Entry)), +plan: Mapping.Runtime.Plan) -> Model.Result(Model.Program):
  match plan:
    case Mapping.Runtime.Plan.Mapped{_, cells}: Model.Mapping.prepare(export, globals, erased, cells)
    case Mapping.Runtime.Plan.Plain{}: Model.prepare(export, globals, erased)
    case Mapping.Runtime.Plan.Functions{_, inner}: FunctionAbi.model_prepare(export, globals, erased, inner)
@unsafe
def FunctionAbi.model_run(+parameters: Packed.Parameters(), +plan: Mapping.Runtime.Plan, +program: Model.Program, +input: Model.Input) -> Model.Result(Model.Outcome):
  match plan:
    case Mapping.Runtime.Plan.Mapped{_, cells}: Model.Mapping.run(cells, program, input)
    case Mapping.Runtime.Plan.Plain{}: FunctionAbi.model_plain(parameters, program, input)
    case Mapping.Runtime.Plan.Functions{_, inner}: FunctionAbi.model_run(parameters, inner, program, input)
@unsafe
def FunctionAbi.model_plain(+parameters: Packed.Parameters(), +program: Model.Program, +input: Model.Input) -> Model.Result(Model.Outcome):
  match parameters:
    case Nil{}: Model.run(program, input)
    case Con{_, _}: Model.Result.bind(Emit.Packed.Fields(), Model.Outcome, Model.Packed.fields(parameters), fields => Model.Packed.run(fields, program, input))
@unsafe
def Cli.FunctionAbi.input(+options: Cli.Options, +source: Cli.Packed.Program()) -> Model.Result(Model.Input):
  match source:
    case Tup3{_, _, plan}: Cli.FunctionAbi.input_plan(plan, options)
@unsafe
def Cli.FunctionAbi.input_plan(+plan: Mapping.Runtime.Plan, +options: Cli.Options) -> Model.Result(Model.Input):
  match plan:
    case Mapping.Runtime.Plan.Functions{_, _}:
      Model.Result.bind(Model.Input, Model.Input, Model.inputs_with_caller("", Cli.option("--value", "0", options), Cli.storage(options), Cli.option("--caller", "0", options)), input => FunctionAbi.input_data(input, Trace.calldata(Cli.option("--calldata", "", options))))
    case Mapping.Runtime.Plan.Plain{}: Cli.FunctionAbi.legacy_input(options)
    case Mapping.Runtime.Plan.Mapped{_, _}: Cli.FunctionAbi.legacy_input(options)
@unsafe
def Cli.FunctionAbi.legacy_input(+options: Cli.Options) -> Model.Result(Model.Input):
  Model.inputs_with_caller(Cli.option("--calldata", "", options), Cli.option("--value", "0", options), Cli.storage(options), Cli.option("--caller", "0", options))
@unsafe
def FunctionAbi.input_data(+input: Model.Input, +data: OptionOf(String)) -> Model.Result(Model.Input):
  match data:
    case None{}: Fail{Model.Error.Input{"calldata requires whole hexadecimal bytes"}}
    case Some{hex}:
      Native.choose(&2, Model.Result(Model.Input), Big.is_lt(Big.of_nat(262144n), Big.of_nat(String.length(hex))), _ => Fail{Model.Error.Input{"calldata requires at most 131072 whole hex bytes"}}, _ => FunctionAbi.with_data(input, hex))
def FunctionAbi.with_data(+input: Model.Input, +data: String) -> Model.Result(Model.Input):
  match input:
    case MkModel_Input{_, value, caller, address, initial}: Done{MkModel_Input{data, value, caller, address, initial}}
