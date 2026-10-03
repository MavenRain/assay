# Typed source results and errors retain the checked Word core.
def ReturnAbi.Errors() -> Data: ListOf(TupleOf2(String, ListOf(Abi.Schema.Parameter)))
type ReturnAbi.Source is Data:
  ReturnAbi.Source{tokens: ListOf(Contract.Token), functions: FunctionAbi.Functions()}
type ReturnAbi.Rejection is Data:
  ReturnAbi.Rejection{prefix: ListOf(Contract.Token), arguments: ListOf(Contract.Token), rest: ListOf(Contract.Token), fresh: Big}
@unsafe
def ReturnAbi.enabled(+tokens: ListOf(Contract.Token)) -> Bool:
  match tokens:
    case Con{eff, Con{sig, Con{typ, tail}}}:
      Bool.or(Bool.and(FunctionAbi.eq(eff, "error"), FunctionAbi.enabled(sig <> typ <> tail)), Bool.or(Bool.and(FunctionAbi.eq(eff, "Eff"), Bool.and(FunctionAbi.eq(sig, "Sig"), Bool.not(FunctionAbi.eq(typ, "Word")))), ReturnAbi.enabled(sig <> typ <> tail)))
    case Con{token, tail}: Native.choose(&2, Bool, FunctionAbi.eq(token, "error"), _ => FunctionAbi.enabled(tail), _ => ReturnAbi.enabled(tail))
    case Nil{}: False{}
@unsafe
def ReturnAbi.errors(+tokens: ListOf(Contract.Token), +acc: ReturnAbi.Errors()) -> CheckResult(ReturnAbi.Errors()):
  match tokens:
    case Con{token, Con{name, tail}}:
      Native.choose(&2, CheckResult(ReturnAbi.Errors()), FunctionAbi.eq(token, "error"), _ =>
        CheckResult.bind(FunctionAbi.Args, ReturnAbi.Errors(), FunctionAbi.args(tail, [], [], False{}), args => ReturnAbi.errors_args(name, acc, args))
      , _ => ReturnAbi.errors(name <> tail, acc))
    case Con{_, Nil{}}: Done{List.reverse(&2, TupleOf2(String, ListOf(Abi.Schema.Parameter)), acc)}
    case Nil{}: Done{List.reverse(&2, TupleOf2(String, ListOf(Abi.Schema.Parameter)), acc)}
@unsafe
def ReturnAbi.errors_args(+name: Contract.Token, +acc: ReturnAbi.Errors(), +args: FunctionAbi.Args) -> CheckResult(ReturnAbi.Errors()):
  match args:
    case FunctionAbi.Args{inputs, _, rest, _}: ReturnAbi.errors(rest, Tup2{FunctionAbi.text(name), inputs} <> acc)
@unsafe
def ReturnAbi.find_error(+errors: ReturnAbi.Errors(), +name: String) -> OptionOf(TupleOf2(String, ListOf(Abi.Schema.Parameter))):
  SeqList.find(&2, TupleOf2(String, ListOf(Abi.Schema.Parameter)), row => NativeString.equal(Get.Tuple2.v0(&2, String, &2, ListOf(Abi.Schema.Parameter), row), name), errors)
@unsafe
def ReturnAbi.append(+tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token)) -> ListOf(Contract.Token):
  List.append(&2, Contract.Token, List.reverse(&2, Contract.Token, tokens), acc)
@unsafe
def ReturnAbi.scan(+tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big) -> CheckResult(ReturnAbi.Source):
  match tokens:
    case Nil{}: Done{ReturnAbi.Source{List.reverse(&2, Contract.Token, acc), List.reverse(&2, Abi.Schema.Function_, functions)}}
    case Con{token, tail}:
      Native.choose(&2, CheckResult(ReturnAbi.Source), FunctionAbi.eq(token, "entry"), _ => ReturnAbi.entry(token, tail, acc, functions, errors, fresh), _ =>
      Native.choose(&2, CheckResult(ReturnAbi.Source), FunctionAbi.eq(token, "error"), _ => ReturnAbi.error_tokens(token, tail, acc, functions, errors, fresh), _ =>
      Native.choose(&2, CheckResult(ReturnAbi.Source), Bool.and(FunctionAbi.eq(token, "pure"), FunctionAbi.dynamic(result)), _ => ReturnAbi.string_return(token, tail, acc, functions, errors, active, result, fresh), _ =>
      Native.choose(&2, CheckResult(ReturnAbi.Source), FunctionAbi.eq(token, "revert"), _ => ReturnAbi.revert(token, tail, acc, functions, errors, active, result, fresh), _ =>
        ReturnAbi.token(token, tail, acc, functions, errors, active, result, fresh)))))
@unsafe
def ReturnAbi.entry(+entry: Contract.Token, +tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +fresh: Big) -> CheckResult(ReturnAbi.Source):
  match tokens:
    case Nil{}: Contract.fail(&2, ReturnAbi.Source, entry, "ABI", "expected function name")
    case Con{name, tail}:
      CheckResult.bind(FunctionAbi.Args, ReturnAbi.Source, FunctionAbi.args(tail, [], [], False{}), args => ReturnAbi.entry_args(entry, name, tail, acc, functions, errors, fresh, args))
@unsafe
def ReturnAbi.entry_args(+entry: Contract.Token, +name: Contract.Token, +tail: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +fresh: Big, +args: FunctionAbi.Args) -> CheckResult(ReturnAbi.Source):
  match args:
    case FunctionAbi.Args{inputs, _, rest, typed}: ReturnAbi.entry_result(entry, name, tail, inputs, rest, typed, acc, functions, errors, fresh)
@unsafe
def ReturnAbi.entry_result(+entry: Contract.Token, +name: Contract.Token, +tail: ListOf(Contract.Token), +inputs: ListOf(Abi.Schema.Parameter), +rest: ListOf(Contract.Token), +typed: Bool, +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +fresh: Big) -> CheckResult(ReturnAbi.Source):
  match rest:
    case Con{colon, Con{eff, Con{sig, Con{typ, body}}}}:
      Native.choose(&2, CheckResult(ReturnAbi.Source), Bool.and(FunctionAbi.eq(colon, ":"), Bool.and(FunctionAbi.eq(eff, "Eff"), FunctionAbi.eq(sig, "Sig"))), _ =>
        ReturnAbi.entry_type(entry, name, tail, inputs, rest, typed, acc, functions, errors, fresh, colon, eff, sig, typ, body, FunctionAbi.typ(typ))
      , _ => Contract.fail(&2, ReturnAbi.Source, colon, "ABI", "expected Eff Sig result"))
    case Nil{}: Contract.fail(&2, ReturnAbi.Source, name, "ABI", "missing function result")
    case Con{at, _}: Contract.fail(&2, ReturnAbi.Source, at, "ABI", "expected Eff Sig result")
@unsafe
def ReturnAbi.entry_type(+entry: Contract.Token, +name: Contract.Token, +tail: ListOf(Contract.Token), +inputs: ListOf(Abi.Schema.Parameter), +rest: ListOf(Contract.Token), +typed: Bool, +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +fresh: Big, +colon: Contract.Token, +eff: Contract.Token, +sig: Contract.Token, +typ: Contract.Token, +body: ListOf(Contract.Token), +found: OptionOf(Abi.Schema.Value_type)) -> CheckResult(ReturnAbi.Source):
  match found:
    case None{}: Contract.fail(&2, ReturnAbi.Source, typ, "ABI", "unsupported function result type")
    case Some{value}:
      +fn = {MkAbi_Schema_Function_{FunctionAbi.text(name), inputs, [MkAbi_Schema_Parameter{"", value}], Abi.Mutability.Nonpayable{}} : Abi.Schema.Function_}
      +count = {Big.sub(Big.of_nat(List.length(&2, Contract.Token, tail)), Big.of_nat(List.length(&2, Contract.Token, rest))) : Big}
      +header = {List.append(&2, Contract.Token, ReturnAbi.take(tail, count), [colon, eff, sig, Packed.Source.word_token(Get.Contract.Token.line(typ), Get.Contract.Token.col(typ))]) : ListOf(Contract.Token)}
      ReturnAbi.scan(body, ReturnAbi.append(header, name <> entry <> acc), Native.choose(&2, FunctionAbi.Functions(), Bool.or(typed, Bool.not(FunctionAbi.eq(typ, "Word"))), _ => fn <> functions, _ => functions), errors, inputs, value, fresh)
@unsafe
def ReturnAbi.error_tokens(+error: Contract.Token, +tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +fresh: Big) -> CheckResult(ReturnAbi.Source):
  match tokens:
    case Nil{}: Contract.fail(&2, ReturnAbi.Source, error, "ABI", "expected error name")
    case Con{name, tail}:
      CheckResult.bind(FunctionAbi.Args, ReturnAbi.Source, FunctionAbi.args(tail, [], [], False{}), args => ReturnAbi.error_args(error, name, acc, functions, errors, fresh, args))
@unsafe
def ReturnAbi.error_args(+error: Contract.Token, +name: Contract.Token, +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +fresh: Big, +args: FunctionAbi.Args) -> CheckResult(ReturnAbi.Source):
  match args:
    case FunctionAbi.Args{_, normalized, rest, _}: ReturnAbi.scan(rest, ReturnAbi.append(normalized, name <> error <> acc), functions, errors, [], Abi.Schema.Value_type.Uint256{}, fresh)
@unsafe
def ReturnAbi.token(+token: Contract.Token, +tail: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big) -> CheckResult(ReturnAbi.Source):
  ReturnAbi.next(token, tail, acc, functions, errors, active, result, fresh)
@unsafe
def ReturnAbi.take(+tokens: ListOf(Contract.Token), +count: Big) -> ListOf(Contract.Token):
  match tokens:
    case Nil{}: []
    case Con{token, tail}: Native.choose(&2, ListOf(Contract.Token), Big.is_eq(count, Big.zero()), _ => [], _ => token <> ReturnAbi.take(tail, Big.sub(count, Big.one())))
@unsafe
def ReturnAbi.next(+token: Contract.Token, +tail: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big) -> CheckResult(ReturnAbi.Source):
  +reset = {Mapping.Source.declaration(FunctionAbi.text(token)) : Bool}
  ReturnAbi.scan(tail, token <> acc, functions, errors, Native.choose(&2, ListOf(Abi.Schema.Parameter), reset, _ => [], _ => active), Native.choose(&2, Abi.Schema.Value_type, reset, _ => Abi.Schema.Value_type.Uint256{}, _ => result), fresh)
@unsafe
def ReturnAbi.string_alias(+at: Contract.Token, +name: Contract.Token, +fresh: Big) -> TupleOf2(ListOf(Contract.Token), String):
  +cursor = {String.append("assayResultData", Big.show(fresh)) : String}
  +offset = {String.append("assayResultOffset", Big.show(fresh)) : String}
  Tup2{FunctionAbi.tokens(at, [cursor, "<-", "stringdata", FunctionAbi.text(name), ";", offset, "<-", "sub", cursor, "(", "word", "36", ")", ";"]), offset}
@unsafe
def ReturnAbi.string_return(+pure: Contract.Token, +tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big) -> CheckResult(ReturnAbi.Source):
  match tokens:
    case Con{open, Con{name, Con{close, rest}}}:
      Native.choose(&2, CheckResult(ReturnAbi.Source), Bool.and(FunctionAbi.eq(open, "("), FunctionAbi.eq(close, ")")), _ => ReturnAbi.return_name(pure, name, rest, acc, functions, errors, active, result, fresh), _ => ReturnAbi.return_name(pure, open, name <> close <> rest, acc, functions, errors, active, result, fresh))
    case Con{name, rest}: ReturnAbi.return_name(pure, name, rest, acc, functions, errors, active, result, fresh)
    case Nil{}: Contract.fail(&2, ReturnAbi.Source, pure, "ABI", "String results require a String parameter")
@unsafe
def ReturnAbi.return_name(+pure: Contract.Token, +name: Contract.Token, +rest: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big) -> CheckResult(ReturnAbi.Source):
  Native.choose(&2, CheckResult(ReturnAbi.Source), FunctionAbi.is_string(active, name), _ =>
    ReturnAbi.return_alias(pure, rest, acc, functions, errors, active, result, fresh, ReturnAbi.string_alias(pure, name, fresh))
  , _ => Contract.fail(&2, ReturnAbi.Source, name, "ABI", "String results require a String parameter"))
@unsafe
def ReturnAbi.return_alias(+pure: Contract.Token, +rest: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big, +alias: TupleOf2(ListOf(Contract.Token), String)) -> CheckResult(ReturnAbi.Source):
  match alias:
    case Tup2{prefix, offset}: ReturnAbi.scan(rest, ReturnAbi.append(List.append(&2, Contract.Token, prefix, FunctionAbi.tokens(pure, ["pure", offset])), acc), functions, errors, active, result, Big.add(fresh, Big.one()))
@unsafe
def ReturnAbi.group(+at: Contract.Token, +tokens: ListOf(Contract.Token), +depth: Big, +acc: ListOf(Contract.Token)) -> CheckResult(TupleOf2(ListOf(Contract.Token), ListOf(Contract.Token))):
  match tokens:
    case Nil{}: Contract.fail(&2, TupleOf2(ListOf(Contract.Token), ListOf(Contract.Token)), at, "ABI", "unterminated error argument")
    case Con{token, tail}:
      Native.choose(&2, CheckResult(TupleOf2(ListOf(Contract.Token), ListOf(Contract.Token))), FunctionAbi.eq(token, ")"), _ =>
        Native.choose(&2, CheckResult(TupleOf2(ListOf(Contract.Token), ListOf(Contract.Token))), Big.is_eq(depth, Big.one()), _ => Done{Tup2{List.reverse(&2, Contract.Token, token <> acc), tail}}, _ => ReturnAbi.group(at, tail, Big.sub(depth, Big.one()), token <> acc))
      , _ => ReturnAbi.group(at, tail, Native.choose(&2, Big, FunctionAbi.eq(token, "("), _ => Big.add(depth, Big.one()), _ => depth), token <> acc))
@unsafe
def ReturnAbi.revert(+revert: Contract.Token, +tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big) -> CheckResult(ReturnAbi.Source):
  match tokens:
    case Con{name, rest}:
      ReturnAbi.revert_found(revert, name, rest, acc, functions, errors, active, result, fresh, ReturnAbi.find_error(errors, FunctionAbi.text(name)))
    case Nil{}: ReturnAbi.scan(tokens, revert <> acc, functions, errors, active, result, fresh)
@unsafe
def ReturnAbi.revert_found(+revert: Contract.Token, +name: Contract.Token, +rest: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big, +found: OptionOf(TupleOf2(String, ListOf(Abi.Schema.Parameter)))) -> CheckResult(ReturnAbi.Source):
  match found:
    case None{}: ReturnAbi.scan(name <> rest, revert <> acc, functions, errors, active, result, fresh)
    case Some{Tup2{_, parameters}}:
      match parameters:
        case Nil{}: ReturnAbi.scan(name <> rest, revert <> acc, functions, errors, active, result, fresh)
        case Con{_, _}: CheckResult.bind(ReturnAbi.Rejection, ReturnAbi.Source, ReturnAbi.arguments(revert, parameters, rest, active, [], [], fresh), rejection => ReturnAbi.rejection(revert, name, acc, functions, errors, active, result, rejection))
@unsafe
def ReturnAbi.rejection(+revert: Contract.Token, +name: Contract.Token, +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +rejection: ReturnAbi.Rejection) -> CheckResult(ReturnAbi.Source):
  match rejection:
    case ReturnAbi.Rejection{prefix, arguments, tail, next}: ReturnAbi.scan(tail, ReturnAbi.append(List.append(&2, Contract.Token, prefix, revert <> name <> arguments), acc), functions, errors, active, result, next)
@unsafe
def ReturnAbi.arguments(+at: Contract.Token, +parameters: ListOf(Abi.Schema.Parameter), +tokens: ListOf(Contract.Token), +active: ListOf(Abi.Schema.Parameter), +prefix: ListOf(Contract.Token), +arguments: ListOf(Contract.Token), +fresh: Big) -> CheckResult(ReturnAbi.Rejection):
  match parameters:
    case Nil{}: Done{ReturnAbi.Rejection{prefix, arguments, tokens, fresh}}
    case Con{parameter, tail}:
      match tokens:
        case Nil{}: Contract.fail(&2, ReturnAbi.Rejection, at, "ABI", "missing error argument")
        case Con{open, rest}:
          Native.choose(&2, CheckResult(ReturnAbi.Rejection), FunctionAbi.eq(open, "("), _ =>
            CheckResult.bind(TupleOf2(ListOf(Contract.Token), ListOf(Contract.Token)), ReturnAbi.Rejection, ReturnAbi.group(at, rest, Big.one(), [open]), group => ReturnAbi.argument_group(at, parameter, tail, active, prefix, arguments, fresh, group))
          , _ => Contract.fail(&2, ReturnAbi.Rejection, open, "ABI", "error arguments require parentheses"))
@unsafe
def ReturnAbi.argument_group(+at: Contract.Token, +parameter: Abi.Schema.Parameter, +tail: ListOf(Abi.Schema.Parameter), +active: ListOf(Abi.Schema.Parameter), +prefix: ListOf(Contract.Token), +arguments: ListOf(Contract.Token), +fresh: Big, +group: TupleOf2(ListOf(Contract.Token), ListOf(Contract.Token))) -> CheckResult(ReturnAbi.Rejection):
  match group:
    case Tup2{value, after}: ReturnAbi.argument(at, parameter, tail, value, after, active, prefix, arguments, fresh)
@unsafe
def ReturnAbi.argument(+at: Contract.Token, +parameter: Abi.Schema.Parameter, +tail: ListOf(Abi.Schema.Parameter), +value: ListOf(Contract.Token), +rest: ListOf(Contract.Token), +active: ListOf(Abi.Schema.Parameter), +prefix: ListOf(Contract.Token), +arguments: ListOf(Contract.Token), +fresh: Big) -> CheckResult(ReturnAbi.Rejection):
  Native.choose(&2, CheckResult(ReturnAbi.Rejection), FunctionAbi.dynamic(Get.Abi.Schema.Parameter.typ(parameter)), _ => ReturnAbi.string_argument(at, tail, value, rest, active, prefix, arguments, fresh), _ => ReturnAbi.arguments(at, tail, rest, active, prefix, List.append(&2, Contract.Token, arguments, value), fresh))
@unsafe
def ReturnAbi.string_argument(+at: Contract.Token, +tail: ListOf(Abi.Schema.Parameter), +value: ListOf(Contract.Token), +rest: ListOf(Contract.Token), +active: ListOf(Abi.Schema.Parameter), +prefix: ListOf(Contract.Token), +arguments: ListOf(Contract.Token), +fresh: Big) -> CheckResult(ReturnAbi.Rejection):
  match value:
    case Con{_, Con{name, Con{_, Nil{}}}}:
      Native.choose(&2, CheckResult(ReturnAbi.Rejection), FunctionAbi.is_string(active, name), _ => ReturnAbi.argument_alias(at, tail, rest, active, prefix, arguments, fresh, ReturnAbi.string_alias(at, name, fresh)), _ => Contract.fail(&2, ReturnAbi.Rejection, name, "ABI", "String error arguments require a String parameter"))
    case Nil{}: Contract.fail(&2, ReturnAbi.Rejection, at, "ABI", "missing String error argument")
    case Con{_, _}: Contract.fail(&2, ReturnAbi.Rejection, at, "ABI", "String error arguments require a String parameter")
@unsafe
def ReturnAbi.argument_alias(+at: Contract.Token, +tail: ListOf(Abi.Schema.Parameter), +rest: ListOf(Contract.Token), +active: ListOf(Abi.Schema.Parameter), +prefix: ListOf(Contract.Token), +arguments: ListOf(Contract.Token), +fresh: Big, +alias: TupleOf2(ListOf(Contract.Token), String)) -> CheckResult(ReturnAbi.Rejection):
  match alias:
    case Tup2{code, offset}: ReturnAbi.arguments(at, tail, rest, active, List.append(&2, Contract.Token, prefix, code), List.append(&2, Contract.Token, arguments, FunctionAbi.tokens(at, ["(", offset, ")"])), Big.add(fresh, Big.one()))
@unsafe
def ReturnAbi.lower(+source: String) -> CheckResult(Mapping.Runtime.Packet()):
  Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), Packed.Source.contract(source), _ =>
    Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), Big.is_lt(Big.of_nat(65536n), Big.of_nat(String.length(source))), _ => Contract.fail(&2, Mapping.Runtime.Packet(), Contract.here([]), "LIMIT", "contract source exceeds 65536 bytes"), _ =>
      CheckResult.bind(ListOf(Contract.Token), Mapping.Runtime.Packet(), Contract.lex(Series.from_string(source)), +tokens =>
        Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), ReturnAbi.enabled(tokens), _ =>
          Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), SeqList.exists(&2, Contract.Token, token => Bool.or(String.starts_with(FunctionAbi.text(token), "assayResult"), String.starts_with(FunctionAbi.text(token), "assayAbi")), tokens), _ => Contract.fail(&2, Mapping.Runtime.Packet(), Contract.here(tokens), "RESERVED", "assayResult and assayAbi names are reserved for ABI lowering"), _ =>
            CheckResult.bind(ReturnAbi.Errors(), Mapping.Runtime.Packet(), ReturnAbi.errors(tokens, []), +errors =>
              CheckResult.bind(ReturnAbi.Source, Mapping.Runtime.Packet(), ReturnAbi.scan(tokens, [], [], errors, [], Abi.Schema.Value_type.Uint256{}, Big.zero()), normalized => ReturnAbi.normalized(normalized, errors))))
        , _ => FunctionAbi.lower(source))))
  , _ => FunctionAbi.lower(source))
@unsafe
def ReturnAbi.normalized(+source: ReturnAbi.Source, +errors: ReturnAbi.Errors()) -> CheckResult(Mapping.Runtime.Packet()):
  match source:
    case ReturnAbi.Source{tokens, functions}:
      CheckResult.bind(FunctionAbi.Source, Mapping.Runtime.Packet(), FunctionAbi.scan(tokens, [], [], [], Big.zero()), normalized => ReturnAbi.functions_normalized(functions, errors, normalized))
@unsafe
def ReturnAbi.functions_normalized(+functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +normalized: FunctionAbi.Source) -> CheckResult(Mapping.Runtime.Packet()):
  match normalized:
    case FunctionAbi.Source{tokens, _}: CheckResult.bind(Mapping.Runtime.Packet(), Mapping.Runtime.Packet(), Mapping.Runtime.lexed(tokens), packet => ReturnAbi.packet(functions, errors, packet))
def ReturnAbi.packet(+functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +packet: Mapping.Runtime.Packet()) -> CheckResult(Mapping.Runtime.Packet()):
  match packet:
    case Tup2{info, plan}: Done{Tup2{info, Mapping.Runtime.Plan.Outputs{functions, errors, plan}}}

@unsafe
def ReturnAbi.error_declaration(+row: TupleOf2(String, ListOf(Abi.Schema.Parameter))) -> Abi.Schema.Declaration:
  match row:
    case Tup2{name, parameters}: Abi.Schema.Declaration.Error{name, parameters}
@unsafe
def ReturnAbi.error_function(+row: TupleOf2(String, ListOf(Abi.Schema.Parameter))) -> Abi.Schema.Function_:
  match row:
    case Tup2{name, parameters}: MkAbi_Schema_Function_{name, parameters, [], Abi.Mutability.Nonpayable{}}
@unsafe
def ReturnAbi.old_selector(+row: TupleOf2(String, ListOf(Abi.Schema.Parameter))) -> String:
  match row:
    case Tup2{name, parameters}: Keccak.selector(Abi.error_signature(MkAbi_Custom_error{name, SeqList.map(&2, &2, Abi.Schema.Parameter, String, parameter => Get.Abi.Schema.Parameter.name(parameter), parameters)}))
@unsafe
def ReturnAbi.selector(+row: TupleOf2(String, ListOf(Abi.Schema.Parameter))) -> String:
  Keccak.selector(Abi.Schema.function_signature(ReturnAbi.error_function(row)))
@unsafe
def ReturnAbi.abi(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +errors: ReturnAbi.Errors(), +fallback: OptionOf(Emit.Transaction)) -> String:
  +declarations = {SeqList.map(&2, &2, Emit.Entry, Abi.Schema.Declaration, entry => Abi.Schema.Declaration.Function{FunctionAbi.function(Get.Emit.Entry.abi_entry(entry), functions)}, entries) : ListOf(Abi.Schema.Declaration)}
  Abi.Schema.print(Abi.Schema.Declaration.Constructor{[], False{}} <> List.append(&2, Abi.Schema.Declaration, declarations, List.append(&2, Abi.Schema.Declaration, SeqList.map(&2, &2, TupleOf2(String, ListOf(Abi.Schema.Parameter)), Abi.Schema.Declaration, ReturnAbi.error_declaration, errors), Native.choose(&2, ListOf(Abi.Schema.Declaration), Maybe.is_some(&2, Emit.Transaction, fallback), _ => [Abi.Schema.Declaration.Fallback{False{}}], _ => []))))
@unsafe
def ReturnAbi.max(+left: Big, +right: Big) -> Big:
  Native.choose(&2, Big, Big.is_lt(left, right), _ => right, _ => left)
@unsafe
def ReturnAbi.error_high(+errors: ReturnAbi.Errors(), +high: Big) -> Big:
  match errors:
    case Nil{}: high
    case Con{Tup2{_, parameters}, tail}: ReturnAbi.error_high(tail, ReturnAbi.max(high, Big.add(Big.of_nat(32804n), Big.mul(Big.of_nat(List.length(&2, Abi.Schema.Parameter, parameters)), Big.of_nat(32n)))))
@unsafe
def ReturnAbi.body_prefix(+code: ListOf(Asm.Instruction)) -> ListOf(Asm.Instruction):
  match code:
    case Con{_, Con{_, Nil{}}}: []
    case Con{instruction, tail}: instruction <> ReturnAbi.body_prefix(tail)
    case Nil{}: []
@unsafe
def ReturnAbi.maximum(+typ: Abi.Schema.Value_type) -> Big:
  match typ:
    case Abi.Schema.Value_type.Uint8{}: Big.of_nat(255n)
    case Abi.Schema.Value_type.Uint256{}: Big.sub(Big.shift_left(Big.one(), 256n), Big.one())
    case Abi.Schema.Value_type.Address{}: Big.sub(Big.shift_left(Big.one(), 160n), Big.one())
    case Abi.Schema.Value_type.Bool{}: Big.one()
    case Abi.Schema.Value_type.String{}: Big.of_nat(131072n)
@unsafe
def ReturnAbi.label(+root: String, +index: Big, +suffix: String) -> String:
  String.concat([root, "out", Big.show(index), suffix])
@unsafe
def ReturnAbi.encoder(+block: Asm.Block, +parameters: ListOf(Abi.Schema.Parameter), +raw: Big, +base: Big, +selector: OptionOf(String)) -> ListOf(Asm.Block):
  match block:
    case MkAsm_Block{root, destination, stack, body, ending}:
      +prefix = {Native.choose(&2, Big, Maybe.is_some(&2, String, selector), _ => Big.of_nat(4n), _ => Big.zero()) : Big}
      +tuple = {Big.add(base, prefix) : Big}
      +cursor = {Big.add(base, Big.of_nat(131104n)) : Big}
      +header = {Big.add(tuple, Big.mul(Big.of_nat(List.length(&2, Abi.Schema.Parameter, parameters)), Big.of_nat(32n))) : Big}
      +selector_code = {ReturnAbi.selector_code(selector, base) : ListOf(Asm.Instruction)}
      +initial = {List.append(&2, Asm.Instruction, ReturnAbi.body_prefix(body), List.append(&2, Asm.Instruction, selector_code, List.append(&2, Asm.Instruction, [Emit.number(header)], FunctionAbi.save(cursor)))) : ListOf(Asm.Instruction)}
      +limit = {[Emit.number(Big.of_nat(131072n)), Emit.number(Big.sub(header, base)), Asm.Instruction.Op{"GT"}] : ListOf(Asm.Instruction)}
      MkAsm_Block{root, destination, stack, List.append(&2, Asm.Instruction, initial, limit), Emit.branch_to("reject", ReturnAbi.label(root, Big.zero(), "check"))} <>
        ReturnAbi.fields(root, parameters, Big.zero(), raw, tuple, base, cursor, ending)
@unsafe
def ReturnAbi.selector_code(+selector: OptionOf(String), +base: Big) -> ListOf(Asm.Instruction):
  match selector:
    case None{}: []
    case Some{hex}: List.append(&2, Asm.Instruction, [Asm.Instruction.Push{hex}, Emit.number(Big.of_nat(224n)), Asm.Instruction.Op{"SHL"}], FunctionAbi.save(base))
@unsafe
def ReturnAbi.fields(+root: String, +parameters: ListOf(Abi.Schema.Parameter), +index: Big, +raw: Big, +tuple: Big, +base: Big, +cursor: Big, +ending: Asm.Ending) -> ListOf(Asm.Block):
  match parameters:
    case Nil{}:
      +label = {ReturnAbi.label(root, index, "check") : String}
      [Emit.marked(label, List.append(&2, Asm.Instruction, [Emit.number(base)], List.append(&2, Asm.Instruction, FunctionAbi.load(cursor), [Asm.Instruction.Op{"SUB"}, Emit.number(base)])), ending)]
    case Con{parameter, tail}:
      +label = {ReturnAbi.label(root, index, "check") : String}
      +next = {ReturnAbi.label(root, Big.add(index, Big.one()), "check") : String}
      +copy = {ReturnAbi.label(root, index, "copy") : String}
      +source = {Big.add(raw, Big.mul(index, Big.of_nat(32n))) : Big}
      +head = {Big.add(tuple, Big.mul(index, Big.of_nat(32n))) : Big}
      +typ = {Get.Abi.Schema.Parameter.typ(parameter) : Abi.Schema.Value_type}
      List.append(&2, Asm.Block, Native.choose(&2, ListOf(Asm.Block), FunctionAbi.dynamic(typ), _ => ReturnAbi.string_blocks(label, copy, next, source, head, tuple, base, cursor), _ =>
        [FunctionAbi.check(label, List.append(&2, Asm.Instruction, [Emit.number(ReturnAbi.maximum(typ))], List.append(&2, Asm.Instruction, FunctionAbi.load(source), [Asm.Instruction.Op{"GT"}])), copy), Emit.marked(copy, List.append(&2, Asm.Instruction, FunctionAbi.load(source), FunctionAbi.save(head)), Emit.goto(next))]), ReturnAbi.fields(root, tail, Big.add(index, Big.one()), raw, tuple, base, cursor, ending))
@unsafe
def ReturnAbi.string_blocks(+label: String, +copy: String, +next: String, +source: Big, +head: Big, +tuple: Big, +base: Big, +cursor: Big) -> ListOf(Asm.Block):
  +length = {Big.add(cursor, Big.of_nat(32n)) : Big}
  +end = {Big.add(cursor, Big.of_nat(64n)) : Big}
  +read_length = {List.append(&2, Asm.Instruction, FunctionAbi.load(source), [Emit.number(Big.of_nat(4n)), Asm.Instruction.Op{"ADD"}, Asm.Instruction.Op{"CALLDATALOAD"}]) : ListOf(Asm.Instruction)}
  +rounded = {List.append(&2, Asm.Instruction, FunctionAbi.load(length), [Emit.number(Big.of_nat(31n)), Asm.Instruction.Op{"ADD"}, Emit.number(Big.of_nat(5n)), Asm.Instruction.Op{"SHR"}, Emit.number(Big.of_nat(5n)), Asm.Instruction.Op{"SHL"}, Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"ADD"}]) : ListOf(Asm.Instruction)}
  +size = {List.append(&2, Asm.Instruction, rounded, List.append(&2, Asm.Instruction, FunctionAbi.load(cursor), [Asm.Instruction.Op{"ADD"}])) : ListOf(Asm.Instruction)}
  +check = {List.concat(&2, Asm.Instruction, [read_length, FunctionAbi.save(length), size, FunctionAbi.save(end), [Emit.number(Big.of_nat(131072n)), Emit.number(base)], FunctionAbi.load(end), [Asm.Instruction.Op{"SUB"}, Asm.Instruction.Op{"GT"}]]) : ListOf(Asm.Instruction)}
  +offset = {List.concat(&2, Asm.Instruction, [[Emit.number(tuple)], FunctionAbi.load(cursor), [Asm.Instruction.Op{"SUB"}], FunctionAbi.save(head)]) : ListOf(Asm.Instruction)}
  +write_length = {List.concat(&2, Asm.Instruction, [FunctionAbi.load(length), FunctionAbi.load(cursor), [Asm.Instruction.Op{"MSTORE"}]]) : ListOf(Asm.Instruction)}
  +data = {List.concat(&2, Asm.Instruction, [FunctionAbi.load(length), FunctionAbi.load(source), [Emit.number(Big.of_nat(36n)), Asm.Instruction.Op{"ADD"}], FunctionAbi.load(cursor), [Emit.number(Big.of_nat(32n)), Asm.Instruction.Op{"ADD"}, Asm.Instruction.Op{"CALLDATACOPY"}]]) : ListOf(Asm.Instruction)}
  +advance = {List.append(&2, Asm.Instruction, FunctionAbi.load(end), FunctionAbi.save(cursor)) : ListOf(Asm.Instruction)}
  [FunctionAbi.check(label, check, copy), Emit.marked(copy, List.concat(&2, Asm.Instruction, [offset, write_length, data, advance]), Emit.goto(next))]
@unsafe
def ReturnAbi.return_schema(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +label: String) -> OptionOf(Abi.Schema.Function_):
  +rows = {SeqList.mapi(&2, &2, Emit.Entry, TupleOf2(String, OptionOf(Abi.Schema.Function_)), index => entry => Tup2{String.concat(["entry", Big.show(index), "body"]), FunctionAbi.find(functions, Get.Abi.Entry.name(Get.Emit.Entry.abi_entry(entry)))}, entries) : ListOf(TupleOf2(String, OptionOf(Abi.Schema.Function_)))}
  ReturnAbi.return_found(SeqList.find(&2, TupleOf2(String, OptionOf(Abi.Schema.Function_)), row => String.starts_with(label, Get.Tuple2.v0(&2, String, &2, OptionOf(Abi.Schema.Function_), row)), rows))
def ReturnAbi.return_found(+found: OptionOf(TupleOf2(String, OptionOf(Abi.Schema.Function_)))) -> OptionOf(Abi.Schema.Function_):
  match found:
    case None{}: None{}
    case Some{Tup2{_, fn}}: fn
@unsafe
def ReturnAbi.block(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +errors: ReturnAbi.Errors(), +base: Big, +block: Asm.Block) -> ListOf(Asm.Block):
  ReturnAbi.block_ending(functions, entries, errors, base, block, Get.Asm.Block.ending(block))
@unsafe
def ReturnAbi.block_ending(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +errors: ReturnAbi.Errors(), +base: Big, +block: Asm.Block, +ending: Asm.Ending) -> ListOf(Asm.Block):
  match ending:
    case Asm.Ending.Halt{halt}:
      match halt:
        case Asm.Halt.Return{}:
          ReturnAbi.return_block(base, block, ReturnAbi.return_schema(functions, entries, Get.Asm.Block.label(block)))
        case Asm.Halt.Revert{}: ReturnAbi.error_block(errors, base, block, Get.Asm.Block.body(block))
        case Asm.Halt.Stop{}: [block]
        case Asm.Halt.Invalid{}: [block]
        case Asm.Halt.Selfdestruct{}: [block]
    case Asm.Ending.Goto{_, _}: [block]
    case Asm.Ending.Branch{_, _, _}: [block]
    case Asm.Ending.Next{_}: [block]
@unsafe
def ReturnAbi.return_block(+base: Big, +block: Asm.Block, +fn: OptionOf(Abi.Schema.Function_)) -> ListOf(Asm.Block):
  match fn:
    case None{}: [block]
    case Some{fn}: ReturnAbi.encoder(block, Get.Abi.Schema.Function_.outputs(fn), Big.zero(), base, None{})
@unsafe
def ReturnAbi.error_block(+errors: ReturnAbi.Errors(), +base: Big, +block: Asm.Block, +code: ListOf(Asm.Instruction)) -> ListOf(Asm.Block):
  match code:
    case Con{Asm.Instruction.Push{hex}, Con{Asm.Instruction.Push{shift}, Con{Asm.Instruction.Op{op}, _}}}:
      Native.choose(&2, ListOf(Asm.Block), Bool.and(NativeString.equal(op, "SHL"), Big.is_eq(Layout.Mapping.digest_value(shift, Big.zero()), Big.of_nat(224n))), _ =>
        ReturnAbi.error_found(base, block, SeqList.find(&2, TupleOf2(String, ListOf(Abi.Schema.Parameter)), row => NativeString.equal(ReturnAbi.old_selector(row), hex), errors))
      , _ => [block])
    case Nil{}: [block]
    case Con{_, _}: [block]
@unsafe
def ReturnAbi.error_found(+base: Big, +block: Asm.Block, +found: OptionOf(TupleOf2(String, ListOf(Abi.Schema.Parameter)))) -> ListOf(Asm.Block):
  match found:
    case None{}: [block]
    case Some{row}:
      match row:
        case Tup2{_, parameters}: ReturnAbi.encoder(block, parameters, Big.of_nat(32772n), base, Some{ReturnAbi.selector(row)})
@unsafe
def ReturnAbi.blocks(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +errors: ReturnAbi.Errors(), +fallback: OptionOf(Emit.Transaction)) -> ListOf(Asm.Block):
  +original = {Emit.dispatch_blocks(fallback, entries) : ListOf(Asm.Block)}
  +high = {Emit.Mapping.base(original, Emit.Mapping.high(original, Some{Big.zero()})) : Big}
  +base = {Big.add(ReturnAbi.max(ReturnAbi.error_high(errors, Big.of_nat(65536n)), high), Big.of_nat(96n)) : Big}
  +blocks = {List.concat(&2, Asm.Block, SeqList.map(&2, &2, Asm.Block, ListOf(Asm.Block), block => ReturnAbi.block(functions, entries, errors, base, block), original)) : ListOf(Asm.Block)}
  +scratch = {Big.add(Big.of_nat(96n), Emit.Mapping.base(blocks, Emit.Mapping.high(blocks, Some{Big.zero()}))) : Big}
  List.concat(&2, Asm.Block, SeqList.map(&2, &2, Asm.Block, ListOf(Asm.Block), block => FunctionAbi.block(functions, entries, block, scratch), blocks))
@unsafe
def ReturnAbi.program(+contract: String, +export: String, +globals: Global, +rows: ListOf(TupleOf2(String, Global.Entry)), +erased: ListOf(TupleOf2(String, Erase.Entry)), +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +plan: Mapping.Runtime.Plan) -> Emit.Result(Emit.Output):
  Emit.Result.bind(FunctionAbi.Packet(), Emit.Output, FunctionAbi.prepare(export, globals, erased, plan), packet => ReturnAbi.prepared(contract, rows, parameters, functions, errors, plan, packet))
@unsafe
def ReturnAbi.prepared(+contract: String, +rows: ListOf(TupleOf2(String, Global.Entry)), +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +plan: Mapping.Runtime.Plan, +packet: FunctionAbi.Packet()) -> Emit.Result(Emit.Output):
  match packet:
    case Tup5{original, constructor, names, _, fallback}:
      Emit.Result.bind(ListOf(Emit.Entry), Emit.Output, FunctionAbi.entry_table(functions, original), +entries => FunctionAbi.prepared_plan(plan, parameters, contract, constructor, rows, ReturnAbi.abi(functions, entries, errors, fallback), names, ReturnAbi.blocks(functions, entries, errors, fallback)))

@unsafe
def ReturnAbi.value(+typ: Abi.Schema.Value_type, +value: Big, +data: String) -> OptionOf(Abi.Codec.Value):
  match typ:
    case Abi.Schema.Value_type.Uint8{}: Some{Abi.Codec.Value.Uint8{value}}
    case Abi.Schema.Value_type.Uint256{}: Some{Abi.Codec.Value.Uint256{value}}
    case Abi.Schema.Value_type.Address{}: Some{Abi.Codec.Value.Address{value}}
    case Abi.Schema.Value_type.Bool{}: Native.choose(&2, OptionOf(Abi.Codec.Value), Big.is_lt(Big.one(), value), _ => None{}, _ => Some{Abi.Codec.Value.Bool{Big.is_eq(value, Big.one())}})
    case Abi.Schema.Value_type.String{}:
      +length = {Model.calldata_word(data, Big.add(value, Big.of_nat(4n))) : Big}
      +hex = {Model.segment(Big.mul(Big.add(value, Big.of_nat(36n)), Big.of_nat(2n)), Big.mul(length, Big.of_nat(2n)), data) : String}
      ReturnAbi.string_value(Cli.EventDecode.pairs(NativeString.to_list(hex)))
@unsafe
def ReturnAbi.string_value(+bytes: OptionOf(ListOf(Char))) -> OptionOf(Abi.Codec.Value):
  match bytes:
    case None{}: None{}
    case Some{chars}: Some{Abi.Codec.Value.String{NativeString.of_list(chars)}}
@unsafe
def ReturnAbi.values(+parameters: ListOf(Abi.Schema.Parameter), +raw: String, +offset: Big, +data: String) -> OptionOf(ListOf(Abi.Codec.Value)):
  match parameters:
    case Nil{}: Some{[]}
    case Con{parameter, tail}:
      ReturnAbi.value_found(tail, raw, offset, data, ReturnAbi.value(Get.Abi.Schema.Parameter.typ(parameter), Model.calldata_word(raw, offset), data))
@unsafe
def ReturnAbi.value_found(+tail: ListOf(Abi.Schema.Parameter), +raw: String, +offset: Big, +data: String, +value: OptionOf(Abi.Codec.Value)) -> OptionOf(ListOf(Abi.Codec.Value)):
  match value:
    case None{}: None{}
    case Some{value}: ReturnAbi.values_cons(value, ReturnAbi.values(tail, raw, Big.add(offset, Big.of_nat(32n)), data))
def ReturnAbi.values_cons(+value: Abi.Codec.Value, +values: OptionOf(ListOf(Abi.Codec.Value))) -> OptionOf(ListOf(Abi.Codec.Value)):
  match values:
    case None{}: None{}
    case Some{values}: Some{value <> values}
@unsafe
def ReturnAbi.return_encoded(+input: Model.Input, +outcome: Model.Outcome, +encoded: Abi.Return.Result(String)) -> Model.Outcome:
  match encoded:
    case Fail{_}: Model.revert(Get.Model.Input.initial(input))
    case Done{bytes}: Native.choose(&2, Model.Outcome, Big.is_lt(Big.of_nat(131072n), Big.of_nat(String.length(bytes))), _ => Model.revert(Get.Model.Input.initial(input)), _ => MkModel_Outcome{False{}, String.append("0x", Cli.Event.hex(bytes)), Get.Model.Outcome.storage(outcome)})
@unsafe
def ReturnAbi.revert_encoded(+input: Model.Input, +encoded: Abi.Revert.Result(String)) -> Model.Outcome:
  match encoded:
    case Fail{_}: Model.revert(Get.Model.Input.initial(input))
    case Done{bytes}: Native.choose(&2, Model.Outcome, Big.is_lt(Big.of_nat(131072n), Big.of_nat(String.length(bytes))), _ => Model.revert(Get.Model.Input.initial(input)), _ => MkModel_Outcome{True{}, String.append("0x", Cli.Event.hex(bytes)), Get.Model.Input.initial(input)})
@unsafe
def ReturnAbi.model_output(+functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +input: Model.Input, +outcome: Model.Outcome) -> Model.Outcome:
  Native.choose(&2, Model.Outcome, Get.Model.Outcome.reverted(outcome), _ => ReturnAbi.model_error(errors, input, outcome), _ =>
    ReturnAbi.model_return(input, outcome, SeqList.find(&2, Abi.Schema.Function_, fn => NativeString.equal(Keccak.selector(Abi.Schema.function_signature(fn)), Model.segment(Big.zero(), Big.of_nat(8n), Get.Model.Input.data(input))), functions)))
@unsafe
def ReturnAbi.model_return(+input: Model.Input, +outcome: Model.Outcome, +found: OptionOf(Abi.Schema.Function_)) -> Model.Outcome:
  match found:
    case None{}: outcome
    case Some{fn}: ReturnAbi.model_return_values(input, outcome, fn, ReturnAbi.values(Get.Abi.Schema.Function_.outputs(fn), Model.unprefix(Get.Model.Outcome.output(outcome)), Big.zero(), Get.Model.Input.data(input)))
@unsafe
def ReturnAbi.model_return_values(+input: Model.Input, +outcome: Model.Outcome, +fn: Abi.Schema.Function_, +values: OptionOf(ListOf(Abi.Codec.Value))) -> Model.Outcome:
  match values:
    case None{}: Model.revert(Get.Model.Input.initial(input))
    case Some{values}: ReturnAbi.return_encoded(input, outcome, Abi.Return.encode(fn, values))
@unsafe
def ReturnAbi.model_error(+errors: ReturnAbi.Errors(), +input: Model.Input, +outcome: Model.Outcome) -> Model.Outcome:
  +raw = {Model.unprefix(Get.Model.Outcome.output(outcome)) : String}
  +selector = {Model.segment(Big.zero(), Big.of_nat(8n), raw) : String}
  ReturnAbi.model_error_found(input, outcome, raw, SeqList.find(&2, TupleOf2(String, ListOf(Abi.Schema.Parameter)), row => NativeString.equal(ReturnAbi.old_selector(row), selector), errors))
@unsafe
def ReturnAbi.model_error_found(+input: Model.Input, +outcome: Model.Outcome, +raw: String, +found: OptionOf(TupleOf2(String, ListOf(Abi.Schema.Parameter)))) -> Model.Outcome:
  match found:
    case None{}: outcome
    case Some{row}:
      match row:
        case Tup2{_, parameters}:
          ReturnAbi.model_error_values(input, row, ReturnAbi.values(parameters, raw, Big.of_nat(4n), Get.Model.Input.data(input)))
@unsafe
def ReturnAbi.model_error_values(+input: Model.Input, +row: TupleOf2(String, ListOf(Abi.Schema.Parameter)), +values: OptionOf(ListOf(Abi.Codec.Value))) -> Model.Outcome:
  match values:
    case None{}: Model.revert(Get.Model.Input.initial(input))
    case Some{values}: ReturnAbi.revert_encoded(input, Abi.Revert.encode(ReturnAbi.error_declaration(row), values))
@unsafe
def Cli.ReturnAbi.compile(+command: String, +export: String, +source: Cli.Program, +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +plan: Mapping.Runtime.Plan) -> IO(Emit.Output):
  match source:
    case Cli.Program{contract, globals, rows, erased}: Cli.compiled(command, ReturnAbi.program(contract, export, globals, rows, erased, parameters, functions, errors, plan))
@unsafe
def Cli.ReturnAbi.run(+export: String, +input: Model.Input, +source: Cli.Program, +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +plan: Mapping.Runtime.Plan) -> IO(Unit):
  match source:
    case Cli.Program{_, globals, _, erased}: do IO<Unit>:
      program : Model.Program <- Cli.model_result(Model.Program, 2, FunctionAbi.model_prepare(export, globals, erased, plan))
      typed : Model.Program <- Cli.model_result(Model.Program, 2, FunctionAbi.model_program(functions, program))
      outcome : Model.Outcome <- Cli.model_result(Model.Outcome, 2, Native.choose(&2, Model.Result(Model.Outcome), FunctionAbi.valid(functions, input), _ => FunctionAbi.model_run(parameters, plan, typed, input), _ => Done{Model.revert(Get.Model.Input.initial(input))}))
      NativeIO.stdout(Model.print(ReturnAbi.model_output(functions, errors, input, outcome)))
