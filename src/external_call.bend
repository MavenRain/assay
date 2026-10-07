# External calls in entry do blocks (M3 group 1): the surface parse and its refusals.
# `ok <- call TARGET VALUE ;` calls with empty calldata.
# `ok <- call TARGET VALUE 0x12345678 ARG... ;` calls with the selector and at most 8 word arguments.
# `r <- returndata ;` reads the first 32 bytes of the return data of the latest call.
# Checked IR: a contract that uses either form gets `mu Args` and the Tx nodes callraw, call and
# returndata in its prelude (Recognize.m1_protocol_for, calls flag). Empty calldata lowers to callraw.
def ExternalCall.Parsed() -> Data: CheckResult(TupleOf2(Contract.Step, ListOf(Contract.Token)))
def ExternalCall.Words() -> Data: CheckResult(TupleOf2(ListOf(Contract.Word), ListOf(Contract.Token)))

@unsafe
def ExternalCall.ends(+tokens: ListOf(Contract.Token)) -> Bool:
  match tokens:
    case Con{head, _}: NativeString.equal(Get.Contract.Token.text(head), ";")
    case Nil{}: True{}
@unsafe
def ExternalCall.within(+code: Big, +low: Big, +high: Big) -> Bool:
  Bool.and(Big.is_le(low, code), Big.is_le(code, high))
@unsafe
def ExternalCall.hex_digit(+c: Char) -> Bool:
  ExternalCall.hex_code(Big.of_nat(U32.to_nat(Char.to_u32(NativeChar.lower(c)))))
@unsafe
def ExternalCall.hex_code(+code: Big) -> Bool:
  Bool.or(ExternalCall.within(code, Big.of_nat(48n), Big.of_nat(57n)), ExternalCall.within(code, Big.of_nat(97n), Big.of_nat(102n)))
@unsafe
def ExternalCall.is_selector(+text: String) -> Bool:
  Bool.and(Big.is_eq(Big.of_nat(String.length(text)), Big.of_nat(10n)), Bool.and(NativeString.equal(NativeString.take(2n, text), "0x"), NativeString.all(c => ExternalCall.hex_digit(c), NativeString.drop(2n, text))))
@unsafe
def ExternalCall.unbound(+keyword: String) -> String:
  Native.choose(&2, String, NativeString.equal(keyword, "call"), _ => "call must bind its success word", _ => "returndata must bind its word")

@unsafe
def ExternalCall.returndata(+binder: Contract.Token, +tokens: ListOf(Contract.Token)) -> ExternalCall.Parsed():
  Native.choose(&2, ExternalCall.Parsed(), ExternalCall.ends(tokens)
    , _ => Done{Tup2{Contract.Step.Returndata{binder}, tokens}}
    , _ => Contract.fail(&2, TupleOf2(Contract.Step, ListOf(Contract.Token)), Contract.here(tokens), "CALL", "returndata takes no operands"))

@unsafe
def ExternalCall.operand(+keyword: Contract.Token, +tokens: ListOf(Contract.Token)) -> CheckResult(TupleOf2(Contract.Word, ListOf(Contract.Token))):
  Native.choose(&2, CheckResult(TupleOf2(Contract.Word, ListOf(Contract.Token))), ExternalCall.ends(tokens)
    , _ => Contract.fail(&2, TupleOf2(Contract.Word, ListOf(Contract.Token)), keyword, "CALL", "call expects a target and a value")
    , _ => Contract.value(Big.zero(), tokens))
@unsafe
def ExternalCall.call(+binder: Contract.Token, +keyword: Contract.Token, +tokens: ListOf(Contract.Token)) -> ExternalCall.Parsed():
  CheckResult.bind(TupleOf2(Contract.Word, ListOf(Contract.Token)), TupleOf2(Contract.Step, ListOf(Contract.Token)), ExternalCall.operand(keyword, tokens), first =>
    Match.Tuple2(&2, Contract.Word, &2, ListOf(Contract.Token), &2, ExternalCall.Parsed(), first, +target => +after =>
      CheckResult.bind(TupleOf2(Contract.Word, ListOf(Contract.Token)), TupleOf2(Contract.Step, ListOf(Contract.Token)), ExternalCall.operand(keyword, after), second =>
        Match.Tuple2(&2, Contract.Word, &2, ListOf(Contract.Token), &2, ExternalCall.Parsed(), second, +value => +rest =>
          ExternalCall.calldata(binder, keyword, target, value, rest)))))
@unsafe
def ExternalCall.calldata(+binder: Contract.Token, +keyword: Contract.Token, +target: Contract.Word, +value: Contract.Word, +tokens: ListOf(Contract.Token)) -> ExternalCall.Parsed():
  match tokens:
    case Nil{}: Done{Tup2{Contract.Step.Call{binder, target, value, None{}}, Nil{}}}
    case Con{selector, rest}:
      Native.choose(&2, ExternalCall.Parsed(), NativeString.equal(Get.Contract.Token.text(selector), ";")
        , _ => Done{Tup2{Contract.Step.Call{binder, target, value, None{}}, Con{selector, rest}}}
        , _ => Native.choose(&2, ExternalCall.Parsed(), ExternalCall.is_selector(Get.Contract.Token.text(selector))
          , _ => ExternalCall.arguments(binder, keyword, target, value, selector, rest)
          , _ => Contract.fail(&2, TupleOf2(Contract.Step, ListOf(Contract.Token)), selector, "CALL", "call selector must be a 4-byte hex literal")))
@unsafe
def ExternalCall.arguments(+binder: Contract.Token, +keyword: Contract.Token, +target: Contract.Word, +value: Contract.Word, +selector: Contract.Token, +tokens: ListOf(Contract.Token)) -> ExternalCall.Parsed():
  CheckResult.bind(TupleOf2(ListOf(Contract.Word), ListOf(Contract.Token)), TupleOf2(Contract.Step, ListOf(Contract.Token)), ExternalCall.words(tokens), parsed =>
    Match.Tuple2(&2, ListOf(Contract.Word), &2, ListOf(Contract.Token), &2, ExternalCall.Parsed(), parsed, +words => +rest =>
      Native.choose(&2, ExternalCall.Parsed(), Big.is_lt(Big.of_nat(8n), Big.of_nat(List.length(&2, Contract.Word, words)))
        , _ => Contract.fail(&2, TupleOf2(Contract.Step, ListOf(Contract.Token)), keyword, "CALL", "call accepts at most 8 word arguments")
        , _ => Done{Tup2{Contract.Step.Call{binder, target, value, Some{Tup2{selector, words}}}, rest}})))
@unsafe
def ExternalCall.words(+tokens: ListOf(Contract.Token)) -> ExternalCall.Words():
  Native.choose(&2, ExternalCall.Words(), ExternalCall.ends(tokens)
    , _ => Done{Tup2{Nil{}, tokens}}
    , _ => CheckResult.bind(TupleOf2(Contract.Word, ListOf(Contract.Token)), TupleOf2(ListOf(Contract.Word), ListOf(Contract.Token)), Contract.value(Big.zero(), tokens), first =>
      Match.Tuple2(&2, Contract.Word, &2, ListOf(Contract.Token), &2, ExternalCall.Words(), first, +word => +after =>
        CheckResult.bind(TupleOf2(ListOf(Contract.Word), ListOf(Contract.Token)), TupleOf2(ListOf(Contract.Word), ListOf(Contract.Token)), ExternalCall.words(after), more =>
          Match.Tuple2(&2, ListOf(Contract.Word), &2, ListOf(Contract.Token), &2, ExternalCall.Words(), more, +words => +rest =>
            Done{Tup2{Con{word, words}, rest}})))))

@unsafe
def ExternalCall.is_step(+step: Contract.Step) -> Bool:
  Match.Contract_Step(&2, Bool, step, +a => +b => False{}, +a => +b => False{}, +a => False{}, +a => +b => +c => False{}, +a => +b => +c => False{}, +a => +b => False{}, +a => +b => False{}, +a => +b => False{}, +a => +b => +c => +d => False{}, +a => +b => +c => +d => +e => False{}, +a => +b => +c => False{}, +a => +b => +c => +d => True{}, +a => True{})
@unsafe
def ExternalCall.uses(+entries: ListOf(Contract.Entry)) -> Bool:
  SeqList.exists(&2, Contract.Entry, entry => SeqList.exists(&2, Contract.Step, step => ExternalCall.is_step(step), Get.Tuple2.v0(&2, ListOf(Contract.Step), &2, Contract.Ending, Get.Contract.Entry.body(entry))), entries)

@unsafe
def ExternalCall.arguments_term(+env: ListOf(TupleOf2(String, Contract.Binding)), +words: ListOf(Contract.Word)) -> CheckResult(String):
  match words:
    case Nil{}: Done{"nil"}
    case Con{word, rest}:
      CheckResult.bind(String, String, Contract.word(env, word), head =>
        CheckResult.bind(String, String, ExternalCall.arguments_term(env, rest), tail =>
          Done{Contract.app("arg", Con{head, Con{tail, Nil{}}})}))
@unsafe
def ExternalCall.lowered(+env: ListOf(TupleOf2(String, Contract.Binding)), +target: Contract.Word, +value: Contract.Word, +calldata: OptionOf(TupleOf2(Contract.Token, ListOf(Contract.Word)))) -> CheckResult(TupleOf2(String, ListOf(String))):
  CheckResult.bind(String, TupleOf2(String, ListOf(String)), Contract.word(env, target), +t =>
    CheckResult.bind(String, TupleOf2(String, ListOf(String)), Contract.word(env, value), +v =>
      Match.Maybe(&2, TupleOf2(Contract.Token, ListOf(Contract.Word)), &2, CheckResult(TupleOf2(String, ListOf(String))), calldata
        , _ => Done{Tup2{"callraw", Con{t, Con{v, Nil{}}}}}
        , +data => Match.Tuple2(&2, Contract.Token, &2, ListOf(Contract.Word), &2, CheckResult(TupleOf2(String, ListOf(String))), data, +selector => +words =>
          CheckResult.bind(Contract.Word, TupleOf2(String, ListOf(String)), Contract.literal(selector), w =>
            CheckResult.bind(String, TupleOf2(String, ListOf(String)), Contract.word(env, w), s =>
              CheckResult.bind(String, TupleOf2(String, ListOf(String)), ExternalCall.arguments_term(env, words), a =>
                Done{Tup2{"call", Con{t, Con{v, Con{s, Con{a, Nil{}}}}}}})))))))

# Recognizer: the callraw, call and returndata Tx nodes become Emit.Transaction.Call and
# Emit.Transaction.Returndata. Emit.Environment.call_tags maps each node's Tx constructor tag to its
# name. Emit.transaction sends a call tag to Emit.external before its context and payable tests.
def Emit.Recognized() -> Data: Emit.Result(TupleOf3(Emit.Transaction, Big, Big))
def Emit.Continue() -> Type: Reusable(Big, Reusable(Big, Reusable(Recognize.Value, Reusable(Recognize.Value, Emit.Recognized()))))

@unsafe
def Recognize.call_tags(+globals: Global) -> ListOf(TupleOf2(Big, String)):
  SeqList.filter_map(&2, &2, String, TupleOf2(Big, String), +name =>
    Match.Maybe(&2, Big, &2, OptionOf(TupleOf2(Big, String)), Recognize.constructor_tag(globals, "Tx", name)
      , _ => None{}
      , +tag => Some{Tup2{tag, name}}), Con{"callraw", Con{"call", Con{"returndata", Nil{}}}})
@unsafe
def Emit.is_call_tag(+env: Emit.Environment, +tag: Big) -> Bool:
  SeqList.exists(&2, TupleOf2(Big, String), +row => Big.is_eq(Get.Tuple2.v0(&2, Big, &2, String, row), tag), Get.Emit.Environment.call_tags(env))

@unsafe
def Emit.call_shape() -> Emit.Error:
  Emit.Error.M1_shape{"call arguments"}
@unsafe
def Emit.selector(+value: Recognize.Value) -> Emit.Result(Big):
  match value:
    case Recognize.Value.Word{word}: Done{word}
    case Recognize.Value.Nat{_}: Fail{Emit.call_shape()}
    case Recognize.Value.Erased{}: Fail{Emit.call_shape()}
    case Recognize.Value.Runtime_word{_}: Fail{Emit.call_shape()}
    case Recognize.Value.Closure{_, _, _}: Fail{Emit.call_shape()}
    case Recognize.Value.Struct{_, _}: Fail{Emit.call_shape()}
    case Recognize.Value.Tag{_, _, _}: Fail{Emit.call_shape()}
# An Args value is `nil` (no fields) or `arg WORD REST` (two fields).
@unsafe
def Emit.call_arguments(+value: Recognize.Value) -> Emit.Result(ListOf(Emit.Operand)):
  match value:
    case Recognize.Value.Tag{_, _, fields}: Emit.call_argument_fields(fields)
    case Recognize.Value.Nat{_}: Fail{Emit.call_shape()}
    case Recognize.Value.Word{_}: Fail{Emit.call_shape()}
    case Recognize.Value.Erased{}: Fail{Emit.call_shape()}
    case Recognize.Value.Runtime_word{_}: Fail{Emit.call_shape()}
    case Recognize.Value.Closure{_, _, _}: Fail{Emit.call_shape()}
    case Recognize.Value.Struct{_, _}: Fail{Emit.call_shape()}
@unsafe
def Emit.call_argument_fields(+fields: ListOf(Recognize.Value)) -> Emit.Result(ListOf(Emit.Operand)):
  match fields:
    case Nil{}: Done{Nil{}}
    case Con{+word, +rest}:
      match rest:
        case Con{+tail, _}:
          Emit.Result.bind(Emit.Operand, ListOf(Emit.Operand), Emit.operand(word), +head =>
            Emit.Result.bind(ListOf(Emit.Operand), ListOf(Emit.Operand), Emit.call_arguments(tail), +more =>
              Done{Con{head, more}}))
        case Nil{}: Fail{Emit.call_shape()}

# The continuation K gets a fresh runtime word (the success word or the return-data word).
@unsafe
def Emit.resume(+next: Emit.Continue(), +fuel: Big, +fresh: Big, +k: Recognize.Value, +node: Big -> Emit.Transaction -> Emit.Transaction) -> Emit.Recognized():
  Emit.Result.bind(TupleOf3(Emit.Transaction, Big, Big), TupleOf3(Emit.Transaction, Big, Big), next(fuel, NativeInt.add(fresh, Big.one()), k, Recognize.Value.Runtime_word{fresh}), +done =>
    Match.Tuple3(&2, Emit.Transaction, &2, Big, &2, Big, &2, Emit.Recognized(), done, +tx => +fuel2 => +fresh2 =>
      Done{Tup3{node(fresh, tx), fuel2, fresh2}}))
@unsafe
def Emit.resume_last(+values: ListOf(Recognize.Value), +next: Emit.Continue(), +fuel: Big, +fresh: Big, +node: Big -> Emit.Transaction -> Emit.Transaction) -> Emit.Recognized():
  match values:
    case Con{+k, +tail}:
      match tail:
        case Nil{}: Emit.resume(next, fuel, fresh, k, node)
        case Con{_, _}: Fail{Emit.call_shape()}
    case Nil{}: Fail{Emit.call_shape()}
@unsafe
def Emit.take_operand(+values: ListOf(Recognize.Value), +then: Emit.Operand -> ListOf(Recognize.Value) -> Emit.Recognized()) -> Emit.Recognized():
  match values:
    case Con{+head, +tail}: Emit.Result.bind(Emit.Operand, TupleOf3(Emit.Transaction, Big, Big), Emit.operand(head), +operand => then(operand, tail))
    case Nil{}: Fail{Emit.call_shape()}
@unsafe
def Emit.take_calldata(+values: ListOf(Recognize.Value), +then: Big -> ListOf(Emit.Operand) -> ListOf(Recognize.Value) -> Emit.Recognized()) -> Emit.Recognized():
  match values:
    case Con{+selector, +rest}:
      match rest:
        case Con{+words, +tail}:
          Emit.Result.bind(Big, TupleOf3(Emit.Transaction, Big, Big), Emit.selector(selector), +s =>
            Emit.Result.bind(ListOf(Emit.Operand), TupleOf3(Emit.Transaction, Big, Big), Emit.call_arguments(words), +a =>
              then(s, a, tail)))
        case Nil{}: Fail{Emit.call_shape()}
    case Nil{}: Fail{Emit.call_shape()}

# returndata [K]; callraw [TARGET, VALUE, K]; call [TARGET, VALUE, SELECTOR, ARGS, K].
@unsafe
def Emit.external_node(+name: String, +args: ListOf(Recognize.Value), +next: Emit.Continue(), +fuel: Big, +fresh: Big) -> Emit.Recognized():
  Native.choose(&2, Emit.Recognized(), NativeString.equal(name, "returndata")
    , _ => Emit.resume_last(args, next, fuel, fresh, +binder => +tx => Emit.Transaction.Returndata{binder, tx})
    , _ => Emit.take_operand(args, +target => +rest =>
      Emit.take_operand(rest, +value => +more =>
        Native.choose(&2, Emit.Recognized(), NativeString.equal(name, "callraw")
          , _ => Emit.resume_last(more, next, fuel, fresh, +binder => +tx => Emit.Transaction.Call{target, value, None{}, Nil{}, binder, tx})
          , _ => Emit.take_calldata(more, +s => +a => +tail =>
            Emit.resume_last(tail, next, fuel, fresh, +binder => +tx => Emit.Transaction.Call{target, value, Some{s}, a, binder, tx}))))))
@unsafe
def Emit.external(+env: Emit.Environment, +tag: Big, +args: ListOf(Recognize.Value), +next: Emit.Continue(), +fuel: Big, +fresh: Big) -> Emit.Recognized():
  Match.Maybe(&2, String, &2, Emit.Recognized(), SeqList.assoc(&2, &2, Big, String, +x => +y => Big.is_eq(x, y), tag, Get.Emit.Environment.call_tags(env))
    , _ => Fail{Emit.Error.M1_shape{"Tx constructor"}}
    , +name => Emit.external_node(name, args, next, fuel, fresh))

# Checked call nodes precede EVM lowering. Refuse the whole emission packet
# before any assembly or artifact writes, including calls behind a branch.
@unsafe
def Emit.has_external(+tx: Emit.Transaction) -> Bool:
  match tx:
    case Emit.Transaction.Finish{_}: False{}
    case Emit.Transaction.Abort{}: False{}
    case Emit.Transaction.Reject{_, _}: False{}
    case Emit.Transaction.Store{_, _, after}: Emit.has_external(after)
    case Emit.Transaction.Load{_, _, after}: Emit.has_external(after)
    case Emit.Transaction.Context{_, _, after}: Emit.has_external(after)
    case Emit.Transaction.Arithmetic{_, _, _, _, yes, no}: Bool.or(Emit.has_external(yes), Emit.has_external(no))
    case Emit.Transaction.Compute{_, _, _, _, after}: Emit.has_external(after)
    case Emit.Transaction.Compare{_, _, yes, no}: Bool.or(Emit.has_external(yes), Emit.has_external(no))
    case Emit.Transaction.Call{_, _, _, _, _, _}: True{}
    case Emit.Transaction.Returndata{_, _}: True{}

@unsafe
def Emit.require_lowerable(+result: Emit.Result(FunctionAbi.Packet())) -> Emit.Result(FunctionAbi.Packet()):
  Emit.Result.bind(FunctionAbi.Packet(), FunctionAbi.Packet(), result, packet => Emit.lowerable_packet(packet))

@unsafe
def Emit.lowerable_packet(+packet: FunctionAbi.Packet()) -> Emit.Result(FunctionAbi.Packet()):
  match packet:
    case Tup5{entries, constructor, names, errors, fallback}:
      +entry_call = SeqList.exists(&2, Emit.Entry, entry => Emit.has_external(Get.Emit.Entry.tx(entry)), entries)
      +fallback_call = Match.Maybe(&2, Emit.Transaction, &2, Bool, fallback, _ => False{}, tx => Emit.has_external(tx))
      Native.choose(&2, Emit.Result(FunctionAbi.Packet()), Bool.or(entry_call, fallback_call)
        , _ => Fail{Emit.Error.Invalid_ir{"CALL: external call lowering is not available until M3 group 3"}}
        , _ => Done{Tup5{entries, constructor, names, errors, fallback}})
