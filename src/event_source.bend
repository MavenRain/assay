# Checked source events share the typed ABI codecs and the transaction dispatcher.
type EventSource.Event is Data:
  EventSource.Event{name: String, inputs: ListOf(Abi.Schema.Event_parameter), anonymous: Bool}
def EventSource.Events() -> Data: ListOf(EventSource.Event)
type EventSource.Source is Data:
  EventSource.Source{tokens: ListOf(Contract.Token), events: EventSource.Events()}
type EventSource.Args is Data:
  EventSource.Args{inputs: ListOf(Abi.Schema.Event_parameter), tokens: ListOf(Contract.Token), rest: ListOf(Contract.Token)}
type EventSource.Outcome is Data:
  EventSource.Outcome{outcome: Model.Outcome, logs: ListOf(Abi.Event.Log)}

@unsafe
def EventSource.internal(+name: String) -> String: String.append("assayEvent", name)
@unsafe
def EventSource.parameters(+event: EventSource.Event) -> ListOf(Abi.Schema.Parameter):
  match event:
    case EventSource.Event{_, inputs, _}: SeqList.map(&2, &2, Abi.Schema.Event_parameter, Abi.Schema.Parameter, +input => Get.Abi.Schema.Event_parameter.parameter(input), inputs)
@unsafe
def EventSource.error(+event: EventSource.Event) -> TupleOf2(String, ListOf(Abi.Schema.Parameter)):
  match event:
    case EventSource.Event{name, _, _}: Tup2{EventSource.internal(name), EventSource.parameters(event)}
@unsafe
def EventSource.declaration(+event: EventSource.Event) -> Abi.Schema.Declaration:
  match event:
    case EventSource.Event{name, inputs, anonymous}: Abi.Schema.Declaration.Event{name, inputs, anonymous}
@unsafe
def EventSource.find(+events: EventSource.Events(), +name: String) -> OptionOf(EventSource.Event):
  SeqList.find(&2, EventSource.Event, event => EventSource.named(event, name), events)
@unsafe
def EventSource.named(+event: EventSource.Event, +name: String) -> Bool:
  match event:
    case EventSource.Event{found, _, _}: NativeString.equal(found, name)
@unsafe
def EventSource.selector(+events: EventSource.Events(), +selector: String) -> OptionOf(EventSource.Event):
  SeqList.find(&2, EventSource.Event, event => NativeString.equal(ReturnAbi.old_selector(EventSource.error(event)), selector), events)

@unsafe
def EventSource.args(+tokens: ListOf(Contract.Token), +inputs: ListOf(Abi.Schema.Event_parameter), +acc: ListOf(Contract.Token)) -> CheckResult(EventSource.Args):
  match tokens:
    case Con{open, Con{name, Con{colon, Con{typ, Con{close, rest}}}}}:
      Native.choose(&2, CheckResult(EventSource.Args), FunctionAbi.eq(open, "("), _ =>
        Native.choose(&2, CheckResult(EventSource.Args), FunctionAbi.eq(name, ")"), _ =>
          Done{EventSource.Args{List.reverse(&2, Abi.Schema.Event_parameter, inputs), List.reverse(&2, Contract.Token, name <> open <> acc), colon <> typ <> close <> rest}}
        , _ => Native.choose(&2, CheckResult(EventSource.Args), FunctionAbi.eq(colon, ":"), _ =>
          EventSource.arg_type(open, name, typ, close <> rest, inputs, acc, FunctionAbi.typ(typ))
        , _ => Contract.fail(&2, EventSource.Args, open, "EVENT", "expected (name : ABI type indexed?)")))
      , _ => Done{EventSource.Args{List.reverse(&2, Abi.Schema.Event_parameter, inputs), List.reverse(&2, Contract.Token, acc), tokens}})
    case Con{open, Con{close, rest}}:
      Native.choose(&2, CheckResult(EventSource.Args), Bool.and(FunctionAbi.eq(open, "("), FunctionAbi.eq(close, ")")), _ =>
        Done{EventSource.Args{List.reverse(&2, Abi.Schema.Event_parameter, inputs), List.reverse(&2, Contract.Token, close <> open <> acc), rest}}
      , _ => Done{EventSource.Args{List.reverse(&2, Abi.Schema.Event_parameter, inputs), List.reverse(&2, Contract.Token, acc), tokens}})
    case Nil{}: Done{EventSource.Args{List.reverse(&2, Abi.Schema.Event_parameter, inputs), List.reverse(&2, Contract.Token, acc), []}}
    case Con{_, Nil{}}: Done{EventSource.Args{List.reverse(&2, Abi.Schema.Event_parameter, inputs), List.reverse(&2, Contract.Token, acc), tokens}}
@unsafe
def EventSource.arg_type(+open: Contract.Token, +name: Contract.Token, +typ: Contract.Token, +tokens: ListOf(Contract.Token), +inputs: ListOf(Abi.Schema.Event_parameter), +acc: ListOf(Contract.Token), +found: OptionOf(Abi.Schema.Value_type)) -> CheckResult(EventSource.Args):
  match found:
    case None{}: Contract.fail(&2, EventSource.Args, typ, "EVENT", "unsupported event parameter type")
    case Some{value}: EventSource.arg_tokens(open, name, typ, tokens, inputs, acc, value)
@unsafe
def EventSource.arg_tokens(+open: Contract.Token, +name: Contract.Token, +typ: Contract.Token, +tokens: ListOf(Contract.Token), +inputs: ListOf(Abi.Schema.Event_parameter), +acc: ListOf(Contract.Token), +value: Abi.Schema.Value_type) -> CheckResult(EventSource.Args):
      match tokens:
        case Con{indexed, Con{close, rest}}:
          Native.choose(&2, CheckResult(EventSource.Args), FunctionAbi.eq(indexed, "indexed"), _ =>
            EventSource.arg_close(open, name, typ, close, rest, inputs, acc, value, True{})
          , _ => EventSource.arg_close(open, name, typ, indexed, close <> rest, inputs, acc, value, False{}))
        case Con{close, Nil{}}: EventSource.arg_close(open, name, typ, close, [], inputs, acc, value, False{})
        case Nil{}: Contract.fail(&2, EventSource.Args, open, "EVENT", "unterminated event parameter")
@unsafe
def EventSource.arg_close(+open: Contract.Token, +name: Contract.Token, +typ: Contract.Token, +close: Contract.Token, +rest: ListOf(Contract.Token), +inputs: ListOf(Abi.Schema.Event_parameter), +acc: ListOf(Contract.Token), +value: Abi.Schema.Value_type, +indexed: Bool) -> CheckResult(EventSource.Args):
  Native.choose(&2, CheckResult(EventSource.Args), FunctionAbi.eq(close, ")"), _ =>
    EventSource.args(rest, MkAbi_Schema_Event_parameter{MkAbi_Schema_Parameter{FunctionAbi.text(name), value}, indexed} <> inputs, ReturnAbi.append(FunctionAbi.tokens(open, ["(", FunctionAbi.text(name), ":", FunctionAbi.text(typ), ")"]), acc))
  , _ => Contract.fail(&2, EventSource.Args, close, "EVENT", "expected closing event parenthesis"))
@unsafe
def EventSource.collect(+tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +events: EventSource.Events()) -> CheckResult(EventSource.Source):
  match tokens:
    case Nil{}: Done{EventSource.Source{List.reverse(&2, Contract.Token, acc), List.reverse(&2, EventSource.Event, events)}}
    case Con{token, tail}:
      Native.choose(&2, CheckResult(EventSource.Source), FunctionAbi.eq(token, "event"), _ =>
        CheckResult.bind(TupleOf2(Contract.Token, ListOf(Contract.Token)), EventSource.Source, Contract.identifier(tail), row => EventSource.collect_name(token, acc, events, row))
      , _ => EventSource.collect(tail, token <> acc, events))
@unsafe
def EventSource.collect_name(+at: Contract.Token, +acc: ListOf(Contract.Token), +events: EventSource.Events(), +row: TupleOf2(Contract.Token, ListOf(Contract.Token))) -> CheckResult(EventSource.Source):
  match row:
    case Tup2{name, rest}:
      Native.choose(&2, CheckResult(EventSource.Source), Maybe.is_some(&2, EventSource.Event, EventSource.find(events, FunctionAbi.text(name))), _ => Contract.fail(&2, EventSource.Source, name, "EVENT", "duplicate event name"), _ =>
        CheckResult.bind(EventSource.Args, EventSource.Source, EventSource.args(rest, [], []), args => EventSource.collect_args(at, name, acc, events, args)))
@unsafe
def EventSource.collect_args(+at: Contract.Token, +name: Contract.Token, +acc: ListOf(Contract.Token), +events: EventSource.Events(), +args: EventSource.Args) -> CheckResult(EventSource.Source):
  match args:
    case EventSource.Args{inputs, tokens, rest}:
      match tokens:
        case Nil{}: Contract.fail(&2, EventSource.Source, name, "EVENT", "expected (name : ABI type indexed?) or ()")
        case Con{_, _}:
          match rest:
            case Nil{}: EventSource.collected(at, name, acc, events, inputs, tokens, [], False{})
            case Con{token, tail}: Native.choose(&2, CheckResult(EventSource.Source), FunctionAbi.eq(token, "anonymous"), _ => EventSource.collected(at, name, acc, events, inputs, tokens, tail, True{}), _ => EventSource.collected(at, name, acc, events, inputs, tokens, rest, False{}))
@unsafe
def EventSource.collected(+at: Contract.Token, +name: Contract.Token, +acc: ListOf(Contract.Token), +events: EventSource.Events(), +inputs: ListOf(Abi.Schema.Event_parameter), +tokens: ListOf(Contract.Token), +rest: ListOf(Contract.Token), +anonymous: Bool) -> CheckResult(EventSource.Source):
  +indexed = {List.length(&2, Abi.Schema.Event_parameter, SeqList.filter(&2, Abi.Schema.Event_parameter, +input => Get.Abi.Schema.Event_parameter.indexed(input), inputs)) : Nat}
  +names = {SeqList.map(&2, &2, Abi.Schema.Event_parameter, String, input => Get.Abi.Schema.Parameter.name(Get.Abi.Schema.Event_parameter.parameter(input)), inputs) : ListOf(String)}
  +limit = {Native.choose(&2, Nat, anonymous, _ => 4n, _ => 3n) : Nat}
  Native.choose(&2, CheckResult(EventSource.Source), Bool.or(Big.is_lt(Big.of_nat(limit), Big.of_nat(indexed)), Bool.not(Big.is_eq(Big.of_nat(List.length(&2, String, names)), Big.of_nat(List.length(&2, String, SeqList.sort_uniq(&2, String, +a => +b => NativeString.compare(a, b), names)))))), _ => Contract.fail(&2, EventSource.Source, at, "EVENT", "too many indexed fields or duplicate parameter names"), _ =>
    EventSource.collect(rest, ReturnAbi.append(List.append(&2, Contract.Token, FunctionAbi.tokens(at, ["error", EventSource.internal(FunctionAbi.text(name))]), tokens), acc), EventSource.Event{FunctionAbi.text(name), inputs, anonymous} <> events))
# An internal guard carries operands through the checked core. The event handler
# replaces its failure branch with a log followed by the success continuation.
@unsafe
def EventSource.emissions(+tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +events: EventSource.Events(), +constructor: Bool) -> CheckResult(ListOf(Contract.Token)):
  match tokens:
    case Nil{}: Done{List.reverse(&2, Contract.Token, acc)}
    case Con{token, tail}:
      Native.choose(&2, CheckResult(ListOf(Contract.Token)), FunctionAbi.eq(token, "emit"), _ =>
        Native.choose(&2, CheckResult(ListOf(Contract.Token)), constructor, _ => Contract.fail(&2, ListOf(Contract.Token), token, "EVENT", "constructor event emission is not supported"), _ =>
          CheckResult.bind(TupleOf2(Contract.Token, ListOf(Contract.Token)), ListOf(Contract.Token), Contract.identifier(tail), row => EventSource.emission(token, acc, events, row)))
      , _ => EventSource.emissions(tail, token <> acc, events, Native.choose(&2, Bool, Bool.or(FunctionAbi.eq(token, "entry"), FunctionAbi.eq(token, "fallback")), _ => False{}, _ => Bool.or(constructor, FunctionAbi.eq(token, "constructor")))))
@unsafe
def EventSource.emission(+at: Contract.Token, +acc: ListOf(Contract.Token), +events: EventSource.Events(), +row: TupleOf2(Contract.Token, ListOf(Contract.Token))) -> CheckResult(ListOf(Contract.Token)):
  match row:
    case Tup2{name, rest}: EventSource.emission_found(at, name, rest, acc, events, EventSource.find(events, FunctionAbi.text(name)))
@unsafe
def EventSource.emission_found(+at: Contract.Token, +name: Contract.Token, +rest: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +events: EventSource.Events(), +found: OptionOf(EventSource.Event)) -> CheckResult(ListOf(Contract.Token)):
  match found:
    case None{}: Contract.fail(&2, ListOf(Contract.Token), name, "EVENT", "unknown event")
    case Some{event}: EventSource.emit_args(at, rest, ReturnAbi.append(FunctionAbi.tokens(at, ["guard", EventSource.internal(FunctionAbi.text(name))]), acc), events, Big.zero(), EventSource.arity(event), Big.zero())
@unsafe
def EventSource.arity(+event: EventSource.Event) -> Big:
  match event:
    case EventSource.Event{_, inputs, _}: Big.of_nat(List.length(&2, Abi.Schema.Event_parameter, inputs))
# Every depth-zero group is one event argument. The empty group () carries none.
@unsafe
def EventSource.emit_count(+token: Contract.Token, +tail: ListOf(Contract.Token), +depth: Big, +count: Big) -> Big:
  match tail:
    case Nil{}: count
    case Con{next, _}: Native.choose(&2, Big, Bool.and(Bool.and(Big.is_eq(depth, Big.zero()), FunctionAbi.eq(token, "(")), Bool.not(FunctionAbi.eq(next, ")"))), _ => Big.add(count, Big.one()), _ => count)
@unsafe
def EventSource.emit_args(+at: Contract.Token, +tokens: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +events: EventSource.Events(), +depth: Big, +expected: Big, +count: Big) -> CheckResult(ListOf(Contract.Token)):
  match tokens:
    case Nil{}: Contract.fail(&2, ListOf(Contract.Token), at, "EVENT", "event emission requires a semicolon")
    case Con{token, tail}:
      Native.choose(&2, CheckResult(ListOf(Contract.Token)), Bool.and(Big.is_eq(depth, Big.zero()), FunctionAbi.eq(token, ";")), _ =>
        EventSource.emit_close(at, tail, acc, events, expected, count)
      , _ => Native.choose(&2, CheckResult(ListOf(Contract.Token)), Bool.and(Big.is_eq(depth, Big.zero()), Mapping.Source.declaration(FunctionAbi.text(token))), _ => Contract.fail(&2, ListOf(Contract.Token), at, "EVENT", "event emission requires a semicolon"), _ =>
        EventSource.emit_args(at, tail, token <> acc, events, Native.choose(&2, Big, FunctionAbi.eq(token, "("), _ => Big.add(depth, Big.one()), _ => Native.choose(&2, Big, FunctionAbi.eq(token, ")"), _ => Big.sub(depth, Big.one()), _ => depth)), expected, EventSource.emit_count(token, tail, depth, count))))
@unsafe
def EventSource.emit_close(+at: Contract.Token, +tail: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +events: EventSource.Events(), +expected: Big, +count: Big) -> CheckResult(ListOf(Contract.Token)):
  Native.choose(&2, CheckResult(ListOf(Contract.Token)), Big.is_eq(count, expected), _ =>
    EventSource.emissions(tail, ReturnAbi.append(FunctionAbi.tokens(at, ["(", "leWord", "(", "word", "0", ")", "(", "word", "0", ")", ")", ";"]), acc), events, False{})
  , _ => Contract.fail(&2, ListOf(Contract.Token), at, "EVENT", "wrong event argument count"))
@unsafe
def EventSource.lower(+source: String) -> CheckResult(Mapping.Runtime.Packet()):
  Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), Bool.and(Packed.Source.contract(source), Bool.not(Big.is_lt(Big.of_nat(65536n), Big.of_nat(String.length(source))))), _ =>
    CheckResult.bind(ListOf(Contract.Token), Mapping.Runtime.Packet(), Contract.lex(Series.from_string(source)), +tokens =>
      Native.choose(&2, CheckResult(Mapping.Runtime.Packet()), SeqList.exists(&2, Contract.Token, token => Bool.or(FunctionAbi.eq(token, "event"), FunctionAbi.eq(token, "emit")), tokens), _ =>
        EventSource.checked(tokens, EventSource.reserved(tokens))
      , _ => ReturnAbi.lower(source)))
  , _ => ReturnAbi.lower(source))
# The first reserved token carries the refusal position.
@unsafe
def EventSource.reserved(+tokens: ListOf(Contract.Token)) -> OptionOf(Contract.Token):
  SeqList.find(&2, Contract.Token, token => Bool.or(String.starts_with(FunctionAbi.text(token), "assayEvent"), Bool.or(String.starts_with(FunctionAbi.text(token), "assayResult"), String.starts_with(FunctionAbi.text(token), "assayAbi"))), tokens)
@unsafe
def EventSource.checked(+tokens: ListOf(Contract.Token), +reserved: OptionOf(Contract.Token)) -> CheckResult(Mapping.Runtime.Packet()):
  match reserved:
    case Some{token}: Contract.fail(&2, Mapping.Runtime.Packet(), token, "RESERVED", "assayEvent, assayResult and assayAbi names are reserved for lowering")
    case None{}: CheckResult.bind(EventSource.Source, Mapping.Runtime.Packet(), EventSource.collect(tokens, [], []), normalized => EventSource.normalized(normalized))
@unsafe
def EventSource.normalized(+source: EventSource.Source) -> CheckResult(Mapping.Runtime.Packet()):
  match source:
    case EventSource.Source{tokens, events}:
      CheckResult.bind(ListOf(Contract.Token), Mapping.Runtime.Packet(), EventSource.emissions(tokens, [], events, False{}), +lowered =>
        CheckResult.bind(ReturnAbi.Errors(), Mapping.Runtime.Packet(), ReturnAbi.errors(lowered, []), +errors =>
          CheckResult.bind(ReturnAbi.Source, Mapping.Runtime.Packet(), ReturnAbi.scan(lowered, [], [], errors, [], Abi.Schema.Value_type.Uint256{}, Big.zero()), +normalized =>
            CheckResult.bind(Mapping.Runtime.Packet(), Mapping.Runtime.Packet(), ReturnAbi.normalized(normalized, errors), packet => EventSource.packet(events, packet)))))
@unsafe
def EventSource.packet(+events: EventSource.Events(), +packet: Mapping.Runtime.Packet()) -> CheckResult(Mapping.Runtime.Packet()):
  match packet:
    case Tup2{info, plan}: Done{Tup2{info, Mapping.Runtime.Plan.Events{events, plan}}}
@unsafe
def ReturnAbi.event_guard(+guard: Contract.Token, +tail: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big) -> CheckResult(ReturnAbi.Source):
  match tail:
    case Nil{}: ReturnAbi.token(guard, tail, acc, functions, errors, active, result, fresh)
    case Con{name, rest}:
      Native.choose(&2, CheckResult(ReturnAbi.Source), String.starts_with(FunctionAbi.text(name), "assayEvent"), _ =>
        ReturnAbi.event_guard_found(guard, name, rest, acc, functions, errors, active, result, fresh, ReturnAbi.find_error(errors, FunctionAbi.text(name)))
      , _ => ReturnAbi.token(guard, tail, acc, functions, errors, active, result, fresh))
@unsafe
def ReturnAbi.event_guard_found(+guard: Contract.Token, +name: Contract.Token, +rest: ListOf(Contract.Token), +acc: ListOf(Contract.Token), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +active: ListOf(Abi.Schema.Parameter), +result: Abi.Schema.Value_type, +fresh: Big, +found: OptionOf(TupleOf2(String, ListOf(Abi.Schema.Parameter)))) -> CheckResult(ReturnAbi.Source):
  match found:
    case None{}: Contract.fail(&2, ReturnAbi.Source, name, "EVENT", "unknown internal event")
    case Some{Tup2{_, parameters}}:
      CheckResult.bind(ReturnAbi.Rejection, ReturnAbi.Source, ReturnAbi.arguments(guard, parameters, rest, active, [], [], fresh, "EVENT", "event"), rejection => ReturnAbi.rejection(guard, name, acc, functions, errors, active, result, rejection))

@unsafe
def EventSource.errors(+errors: ReturnAbi.Errors()) -> ReturnAbi.Errors():
  SeqList.filter(&2, TupleOf2(String, ListOf(Abi.Schema.Parameter)), row => EventSource.public_error(row), errors)
@unsafe
def EventSource.public_error(+row: TupleOf2(String, ListOf(Abi.Schema.Parameter))) -> Bool:
  match row:
    case Tup2{name, _}: Bool.not(String.starts_with(name, "assayEvent"))
@unsafe
def EventSource.abi(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +errors: ReturnAbi.Errors(), +events: EventSource.Events(), +fallback: OptionOf(Emit.Transaction)) -> String:
  +declarations = {SeqList.map(&2, &2, Emit.Entry, Abi.Schema.Declaration, entry => Abi.Schema.Declaration.Function{FunctionAbi.function(Get.Emit.Entry.abi_entry(entry), functions)}, entries) : ListOf(Abi.Schema.Declaration)}
  Abi.Schema.print(Abi.Schema.Declaration.Constructor{[], False{}} <> List.concat(&2, Abi.Schema.Declaration, [declarations, SeqList.map(&2, &2, TupleOf2(String, ListOf(Abi.Schema.Parameter)), Abi.Schema.Declaration, ReturnAbi.error_declaration, EventSource.errors(errors)), SeqList.map(&2, &2, EventSource.Event, Abi.Schema.Declaration, EventSource.declaration, events), Native.choose(&2, ListOf(Abi.Schema.Declaration), Maybe.is_some(&2, Emit.Transaction, fallback), _ => [Abi.Schema.Declaration.Fallback{False{}}], _ => [])]))
@unsafe
def EventSource.emits(+events: EventSource.Events(), +tx: Emit.Transaction) -> Bool:
  match tx:
    case Emit.Transaction.Finish{_}: False{}
    case Emit.Transaction.Abort{}: False{}
    case Emit.Transaction.Reject{_, _}: False{}
    case Emit.Transaction.Store{_, _, next}: EventSource.emits(events, next)
    case Emit.Transaction.Load{_, _, next}: EventSource.emits(events, next)
    case Emit.Transaction.Context{_, _, next}: EventSource.emits(events, next)
    case Emit.Transaction.Arithmetic{_, _, _, _, yes, no}: Bool.or(EventSource.emits(events, yes), EventSource.emits(events, no))
    case Emit.Transaction.Compute{_, _, _, _, next}: EventSource.emits(events, next)
    case Emit.Transaction.Compare{_, _, yes, no}: Bool.or(EventSource.reject_event(events, no), Bool.or(EventSource.emits(events, yes), EventSource.emits(events, no)))
@unsafe
def EventSource.reject_event(+events: EventSource.Events(), +tx: Emit.Transaction) -> Bool:
  match tx:
    case Emit.Transaction.Reject{selector, _}: Maybe.is_some(&2, EventSource.Event, EventSource.selector(events, selector))
    case Emit.Transaction.Finish{_}: False{}
    case Emit.Transaction.Abort{}: False{}
    case Emit.Transaction.Store{_, _, _}: False{}
    case Emit.Transaction.Load{_, _, _}: False{}
    case Emit.Transaction.Context{_, _, _}: False{}
    case Emit.Transaction.Arithmetic{_, _, _, _, _, _}: False{}
    case Emit.Transaction.Compute{_, _, _, _, _}: False{}
    case Emit.Transaction.Compare{_, _, _, _}: False{}
@unsafe
def EventSource.entry(+events: EventSource.Events(), +entry: Emit.Entry) -> Emit.Entry:
  match entry:
    case MkEmit_Entry{MkAbi_Entry{name, inputs, mutability}, selector, tx}:
      MkEmit_Entry{MkAbi_Entry{name, inputs, Native.choose(&2, Abi.Mutability, EventSource.emits(events, tx), _ => EventSource.mutability(mutability), _ => mutability)}, selector, tx}
def EventSource.mutability(+mutability: Abi.Mutability) -> Abi.Mutability:
  match mutability:
    case Abi.Mutability.Payable{}: Abi.Mutability.Payable{}
    case Abi.Mutability.Nonpayable{}: Abi.Mutability.Nonpayable{}
    case Abi.Mutability.View{}: Abi.Mutability.Nonpayable{}
@unsafe
def EventSource.program(+contract: String, +export: String, +globals: Global, +rows: ListOf(TupleOf2(String, Global.Entry)), +erased: ListOf(TupleOf2(String, Erase.Entry)), +parameters: Packed.Parameters(), +events: EventSource.Events(), +plan: Mapping.Runtime.Plan) -> Emit.Result(Emit.Output):
  match plan:
    case Mapping.Runtime.Plan.Outputs{functions, errors, inner}:
      Emit.Result.bind(FunctionAbi.Packet(), Emit.Output, FunctionAbi.prepare(export, globals, erased, inner), packet => EventSource.prepared(contract, rows, parameters, functions, errors, events, inner, packet))
    case Mapping.Runtime.Plan.Plain{}: Fail{Emit.Error.Invalid_ir{"EVENT: missing output schema"}}
    case Mapping.Runtime.Plan.Mapped{_, _}: Fail{Emit.Error.Invalid_ir{"EVENT: missing output schema"}}
    case Mapping.Runtime.Plan.Functions{_, _}: Fail{Emit.Error.Invalid_ir{"EVENT: missing output schema"}}
    case Mapping.Runtime.Plan.Events{_, _}: Fail{Emit.Error.Invalid_ir{"EVENT: nested event schema"}}
@unsafe
def EventSource.prepared(+contract: String, +rows: ListOf(TupleOf2(String, Global.Entry)), +parameters: Packed.Parameters(), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +events: EventSource.Events(), +plan: Mapping.Runtime.Plan, +packet: FunctionAbi.Packet()) -> Emit.Result(Emit.Output):
  match packet:
    case Tup5{original, constructor, names, _, fallback}:
      Emit.Result.bind(ListOf(Emit.Entry), Emit.Output, FunctionAbi.entry_table(functions, original), +typed =>
        +entries = {SeqList.map(&2, &2, Emit.Entry, Emit.Entry, entry => EventSource.entry(events, entry), typed) : ListOf(Emit.Entry)}
        FunctionAbi.prepared_plan(plan, parameters, contract, constructor, rows, EventSource.abi(functions, entries, errors, events, fallback), names, EventSource.blocks(functions, entries, errors, events, fallback)))
@unsafe
def EventSource.continuation(+blocks: ListOf(Asm.Block), +label: String) -> OptionOf(String):
  match blocks:
    case Nil{}: None{}
    case Con{MkAsm_Block{_, _, _, _, ending}, tail}:
      match ending:
        case Asm.Ending.Branch{_, yes, no}: Native.choose(&2, OptionOf(String), NativeString.equal(yes, label), _ => Some{no}, _ => EventSource.continuation(tail, label))
        case Asm.Ending.Goto{_, _}: EventSource.continuation(tail, label)
        case Asm.Ending.Next{_}: EventSource.continuation(tail, label)
        case Asm.Ending.Halt{_}: EventSource.continuation(tail, label)
@unsafe
def EventSource.block(+events: EventSource.Events(), +original: ListOf(Asm.Block), +base: Big, +block: Asm.Block) -> ListOf(Asm.Block):
  EventSource.block_body(events, original, base, EventSource.redirect(events, original, block), Get.Asm.Block.body(block))
@unsafe
def EventSource.log_target(+events: EventSource.Events(), +blocks: ListOf(Asm.Block), +label: String) -> Bool:
  match blocks:
    case Nil{}: False{}
    case Con{block, tail}:
      Native.choose(&2, Bool, NativeString.equal(Get.Asm.Block.label(block), label), _ => EventSource.log_body(events, Get.Asm.Block.body(block)), _ => EventSource.log_target(events, tail, label))
@unsafe
def EventSource.log_body(+events: EventSource.Events(), +body: ListOf(Asm.Instruction)) -> Bool:
  match body:
    case Con{Asm.Instruction.Push{hex}, Con{Asm.Instruction.Push{shift}, Con{Asm.Instruction.Op{op}, _}}}:
      Bool.and(Bool.and(NativeString.equal(op, "SHL"), Big.is_eq(Layout.Mapping.digest_value(shift, Big.zero()), Big.of_nat(224n))), Maybe.is_some(&2, EventSource.Event, EventSource.selector(events, hex)))
    case Nil{}: False{}
    case Con{_, _}: False{}
@unsafe
def EventSource.redirect(+events: EventSource.Events(), +original: ListOf(Asm.Block), +block: Asm.Block) -> Asm.Block:
  match block:
    case MkAsm_Block{label, destination, height, body, ending}:
      match ending:
        case Asm.Ending.Branch{stack, yes, no}:
          MkAsm_Block{label, destination, height, body, Asm.Ending.Branch{stack, yes, Native.choose(&2, String, EventSource.log_target(events, original, yes), _ => yes, _ => no)}}
        case Asm.Ending.Goto{stack, target}: MkAsm_Block{label, destination, height, body, Asm.Ending.Goto{stack, target}}
        case Asm.Ending.Next{stack}: MkAsm_Block{label, destination, height, body, Asm.Ending.Next{stack}}
        case Asm.Ending.Halt{stack}: MkAsm_Block{label, destination, height, body, Asm.Ending.Halt{stack}}
@unsafe
def EventSource.block_body(+events: EventSource.Events(), +original: ListOf(Asm.Block), +base: Big, +block: Asm.Block, +body: ListOf(Asm.Instruction)) -> ListOf(Asm.Block):
  match body:
    case Con{Asm.Instruction.Push{hex}, Con{Asm.Instruction.Push{shift}, Con{Asm.Instruction.Op{op}, _}}}:
      Native.choose(&2, ListOf(Asm.Block), Bool.and(NativeString.equal(op, "SHL"), Big.is_eq(Layout.Mapping.digest_value(shift, Big.zero()), Big.of_nat(224n))), _ =>
        EventSource.block_found(base, block, EventSource.selector(events, hex), EventSource.continuation(original, Get.Asm.Block.label(block)))
      , _ => [block])
    case Nil{}: [block]
    case Con{_, _}: [block]
@unsafe
def EventSource.block_found(+base: Big, +block: Asm.Block, +event: OptionOf(EventSource.Event), +next: OptionOf(String)) -> ListOf(Asm.Block):
  match event:
    case None{}: [block]
    case Some{event}: EventSource.block_next(base, block, event, next)
@unsafe
def EventSource.block_next(+base: Big, +block: Asm.Block, +event: EventSource.Event, +next: OptionOf(String)) -> ListOf(Asm.Block):
      match next:
        case None{}: [block]
        case Some{next}: EventSource.encoder(base, block, event, next)
@unsafe
def EventSource.data_parameters(+event: EventSource.Event) -> ListOf(Abi.Schema.Parameter):
  match event:
    case EventSource.Event{_, inputs, _}:
      SeqList.map(&2, &2, Abi.Schema.Event_parameter, Abi.Schema.Parameter, +input => Get.Abi.Schema.Event_parameter.parameter(input), SeqList.filter(&2, Abi.Schema.Event_parameter, input => Bool.not(Get.Abi.Schema.Event_parameter.indexed(input)), inputs))
@unsafe
def EventSource.stage(+inputs: ListOf(Abi.Schema.Event_parameter), +index: Big, +data: Big, +raw: Big) -> ListOf(Asm.Instruction):
  match inputs:
    case Nil{}: []
    case Con{input, tail}:
      Native.choose(&2, ListOf(Asm.Instruction), Get.Abi.Schema.Event_parameter.indexed(input), _ => EventSource.stage(tail, Big.add(index, Big.one()), data, raw), _ =>
        List.concat(&2, Asm.Instruction, [FunctionAbi.load(Big.add(Big.of_nat(32772n), Big.mul(index, Big.of_nat(32n)))), FunctionAbi.save(Big.add(raw, Big.mul(data, Big.of_nat(32n)))), EventSource.stage(tail, Big.add(index, Big.one()), Big.add(data, Big.one()), raw)]))
@unsafe
def EventSource.bound_label(+root: String, +index: Big) -> String: String.concat([root, ".event.bound.", Big.show(index)])
@unsafe
def EventSource.bounds(+root: String, +parameters: ListOf(Abi.Schema.Parameter), +index: Big, +payload: String) -> ListOf(Asm.Block):
  match parameters:
    case Nil{}: [Emit.marked(EventSource.bound_label(root, index), [], Emit.goto(payload))]
    case Con{parameter, tail}:
      +label = {EventSource.bound_label(root, index) : String}
      +next = {EventSource.bound_label(root, Big.add(index, Big.one())) : String}
      +typ = {Get.Abi.Schema.Parameter.typ(parameter) : Abi.Schema.Value_type}
      Native.choose(&2, Asm.Block, FunctionAbi.dynamic(typ), _ => Emit.marked(label, [], Emit.goto(next)), _ => FunctionAbi.check(label, List.concat(&2, Asm.Instruction, [[Emit.number(ReturnAbi.maximum(typ))], FunctionAbi.load(Big.add(Big.of_nat(32772n), Big.mul(index, Big.of_nat(32n)))), [Asm.Instruction.Op{"GT"}]]), next)) <> EventSource.bounds(root, tail, Big.add(index, Big.one()), payload)
@unsafe
def EventSource.topics(+event: EventSource.Event, +scratch: Big) -> ListOf(Asm.Instruction):
  match event:
    case EventSource.Event{name, inputs, anonymous}:
      +indexed = {EventSource.indexed_topics(inputs, Big.zero(), scratch) : ListOf(ListOf(Asm.Instruction))}
      List.concat(&2, Asm.Instruction, List.reverse(&2, ListOf(Asm.Instruction), List.append(&2, ListOf(Asm.Instruction), Native.choose(&2, ListOf(ListOf(Asm.Instruction)), anonymous, _ => [], _ => [[Asm.Instruction.Push{Cli.Event.hex(Abi.Event.hash(Abi.Schema.event_signature(name, inputs)))}]]), indexed)))
@unsafe
def EventSource.indexed_topics(+inputs: ListOf(Abi.Schema.Event_parameter), +index: Big, +scratch: Big) -> ListOf(ListOf(Asm.Instruction)):
  match inputs:
    case Nil{}: []
    case Con{input, tail}:
      Native.choose(&2, ListOf(ListOf(Asm.Instruction)), Get.Abi.Schema.Event_parameter.indexed(input), _ => EventSource.topic(Get.Abi.Schema.Parameter.typ(Get.Abi.Schema.Event_parameter.parameter(input)), Big.add(Big.of_nat(32772n), Big.mul(index, Big.of_nat(32n))), scratch) <> EventSource.indexed_topics(tail, Big.add(index, Big.one()), scratch), _ => EventSource.indexed_topics(tail, Big.add(index, Big.one()), scratch))
@unsafe
def EventSource.topic(+typ: Abi.Schema.Value_type, +source: Big, +scratch: Big) -> ListOf(Asm.Instruction):
  Native.choose(&2, ListOf(Asm.Instruction), FunctionAbi.dynamic(typ), _ =>
    +length = {List.append(&2, Asm.Instruction, FunctionAbi.load(source), [Emit.number(Big.of_nat(4n)), Asm.Instruction.Op{"ADD"}, Asm.Instruction.Op{"CALLDATALOAD"}]) : ListOf(Asm.Instruction)}
    List.concat(&2, Asm.Instruction, [length, FunctionAbi.load(source), [Emit.number(Big.of_nat(36n)), Asm.Instruction.Op{"ADD"}, Emit.number(scratch), Asm.Instruction.Op{"CALLDATACOPY"}], length, [Emit.number(scratch), Asm.Instruction.Op{"KECCAK256"}]])
  , _ => FunctionAbi.load(source))
@unsafe
def EventSource.finish(+blocks: ListOf(Asm.Block), +topics: ListOf(Asm.Instruction), +count: Nat, +next: String) -> ListOf(Asm.Block):
  match blocks:
    case Nil{}: []
    case Con{MkAsm_Block{label, destination, stack, body, ending}, tail}:
      match ending:
        case Asm.Ending.Halt{Asm.Halt.Return{}}:
          MkAsm_Block{label, destination, stack, List.concat(&2, Asm.Instruction, [topics, body, [Asm.Instruction.Op{String.append("LOG", Big.show(Big.of_nat(count)))}]]), Emit.goto(next)} <> EventSource.finish(tail, topics, count, next)
        case Asm.Ending.Halt{Asm.Halt.Revert{}}: MkAsm_Block{label, destination, stack, body, ending} <> EventSource.finish(tail, topics, count, next)
        case Asm.Ending.Halt{Asm.Halt.Stop{}}: MkAsm_Block{label, destination, stack, body, ending} <> EventSource.finish(tail, topics, count, next)
        case Asm.Ending.Halt{Asm.Halt.Invalid{}}: MkAsm_Block{label, destination, stack, body, ending} <> EventSource.finish(tail, topics, count, next)
        case Asm.Ending.Halt{Asm.Halt.Selfdestruct{}}: MkAsm_Block{label, destination, stack, body, ending} <> EventSource.finish(tail, topics, count, next)
        case Asm.Ending.Goto{_, _}: MkAsm_Block{label, destination, stack, body, ending} <> EventSource.finish(tail, topics, count, next)
        case Asm.Ending.Branch{_, _, _}: MkAsm_Block{label, destination, stack, body, ending} <> EventSource.finish(tail, topics, count, next)
        case Asm.Ending.Next{_}: MkAsm_Block{label, destination, stack, body, ending} <> EventSource.finish(tail, topics, count, next)
@unsafe
def EventSource.encoder(+base: Big, +block: Asm.Block, +event: EventSource.Event, +next: String) -> ListOf(Asm.Block):
  match block:
    case MkAsm_Block{root, destination, stack, body, _}:
      EventSource.encoder_event(base, root, destination, stack, body, event, next)
@unsafe
def EventSource.encoder_event(+base: Big, +root: String, +destination: Bool, +stack: Big, +body: ListOf(Asm.Instruction), +event: EventSource.Event, +next: String) -> ListOf(Asm.Block):
      match event:
        case EventSource.Event{_, inputs, anonymous}:
          +raw = {Big.add(base, Big.of_nat(131200n)) : Big}
          +payload = {String.append(root, ".event.payload") : String}
          +count = {(List.length(&2, Abi.Schema.Event_parameter, SeqList.filter(&2, Abi.Schema.Event_parameter, +input => Get.Abi.Schema.Event_parameter.indexed(input), inputs)) + Native.choose(&2, Nat, anonymous, _ => 0n, _ => 1n) : Nat) : Nat}
          List.concat(&2, Asm.Block, [[MkAsm_Block{root, destination, stack, List.append(&2, Asm.Instruction, ReturnAbi.body_prefix(body), EventSource.stage(inputs, Big.zero(), Big.zero(), raw)), Emit.goto(EventSource.bound_label(root, Big.zero()))}], EventSource.bounds(root, EventSource.parameters(event), Big.zero(), payload), EventSource.finish(ReturnAbi.encoder(Emit.marked(payload, [Emit.number(Big.zero()), Emit.number(Big.zero())], Asm.Ending.Halt{Asm.Halt.Return{}}), EventSource.data_parameters(event), raw, base, None{}), EventSource.topics(event, Big.add(base, Big.of_nat(262144n))), count, next)])
@unsafe
def EventSource.blocks(+functions: FunctionAbi.Functions(), +entries: ListOf(Emit.Entry), +errors: ReturnAbi.Errors(), +events: EventSource.Events(), +fallback: OptionOf(Emit.Transaction)) -> ListOf(Asm.Block):
  +original = {Emit.dispatch_blocks(fallback, entries) : ListOf(Asm.Block)}
  +high = {Emit.Mapping.base(original, Emit.Mapping.high(original, Some{Big.zero()})) : Big}
  +base = {Big.add(ReturnAbi.max(ReturnAbi.error_high(errors, Big.of_nat(65536n)), high), Big.of_nat(96n)) : Big}
  +event_blocks = {List.concat(&2, Asm.Block, SeqList.map(&2, &2, Asm.Block, ListOf(Asm.Block), block => EventSource.block(events, original, base, block), original)) : ListOf(Asm.Block)}
  +returned = {List.concat(&2, Asm.Block, SeqList.map(&2, &2, Asm.Block, ListOf(Asm.Block), block => ReturnAbi.block(functions, entries, EventSource.errors(errors), base, block), event_blocks)) : ListOf(Asm.Block)}
  +scratch = {Big.add(Big.of_nat(96n), Emit.Mapping.base(returned, Emit.Mapping.high(returned, Some{Big.zero()}))) : Big}
  List.concat(&2, Asm.Block, SeqList.map(&2, &2, Asm.Block, ListOf(Asm.Block), block => FunctionAbi.block(functions, entries, block, scratch), returned))

def EventSource.Environment() -> Data: TupleOf3(EventSource.Events(), Packed.Parameters(), Mapping.Runtime.Plan)
@unsafe
def EventSource.wrap(+outcome: Model.Outcome) -> EventSource.Outcome: EventSource.Outcome{outcome, []}
@unsafe
def EventSource.revert(+input: Model.Input) -> Model.Result(EventSource.Outcome): Done{EventSource.wrap(Model.revert(Get.Model.Input.initial(input)))}
@unsafe
def EventSource.physical(+parameters: Packed.Parameters(), +plan: Mapping.Runtime.Plan, +memory: Model.Storage, +slot: Big) -> Model.Result(Layout.Packed.Field):
  match plan:
    case Mapping.Runtime.Plan.Mapped{_, cells}: Model.Mapping.physical(Mapping.Runtime.find(slot, cells), memory)
    case Mapping.Runtime.Plan.Plain{}: EventSource.physical_plain(parameters, slot)
    case Mapping.Runtime.Plan.Functions{_, inner}: EventSource.physical(parameters, inner, memory, slot)
    case Mapping.Runtime.Plan.Outputs{_, _, inner}: EventSource.physical(parameters, inner, memory, slot)
    case Mapping.Runtime.Plan.Events{_, inner}: EventSource.physical(parameters, inner, memory, slot)
@unsafe
def EventSource.physical_plain(+parameters: Packed.Parameters(), +slot: Big) -> Model.Result(Layout.Packed.Field):
  match parameters:
    case Nil{}: Done{Layout.Packed.Field{"", Abi.Schema.Value_type.Uint256{}, slot, 0n}}
    case Con{_, _}: Model.Result.bind(Emit.Packed.Fields(), Layout.Packed.Field, Model.Packed.fields(parameters), fields => Model.Packed.field(fields, slot))
@unsafe
def EventSource.cell(+plan: Mapping.Runtime.Plan, +slot: Big) -> OptionOf(Mapping.Runtime.Cell):
  match plan:
    case Mapping.Runtime.Plan.Mapped{_, cells}: Mapping.Runtime.find(slot, cells)
    case Mapping.Runtime.Plan.Plain{}: None{}
    case Mapping.Runtime.Plan.Functions{_, inner}: EventSource.cell(inner, slot)
    case Mapping.Runtime.Plan.Outputs{_, _, inner}: EventSource.cell(inner, slot)
    case Mapping.Runtime.Plan.Events{_, inner}: EventSource.cell(inner, slot)
@unsafe
def EventSource.store(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +slot: Big, +value: Big, +next: Emit.Transaction) -> Model.Result(EventSource.Outcome):
  match env:
    case Tup3{_, parameters, plan}:
      EventSource.store_cell(env, input, storage, memory, slot, value, next, parameters, plan, EventSource.cell(plan, slot))
@unsafe
def EventSource.store_cell(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +slot: Big, +value: Big, +next: Emit.Transaction, +parameters: Packed.Parameters(), +plan: Mapping.Runtime.Plan, +cell: OptionOf(Mapping.Runtime.Cell)) -> Model.Result(EventSource.Outcome):
      match cell:
        case Some{Mapping.Runtime.Cell.Key{typ, index}}:
          Native.choose(&2, Model.Result(EventSource.Outcome), Abi.Codec.within(Big.of_nat(Layout.Packed.bits(typ)), value), _ => EventSource.transaction(env, input, storage, Tup2{Model.Mapping.key(index), value} <> memory, next), _ => EventSource.revert(input))
        case Some{Mapping.Runtime.Cell.Scalar{_}}: EventSource.store_field(env, input, storage, memory, slot, value, next, parameters, plan)
        case Some{Mapping.Runtime.Cell.Access{_, _, _, _}}: EventSource.store_field(env, input, storage, memory, slot, value, next, parameters, plan)
        case Some{Mapping.Runtime.Cell.Reserved{_}}: EventSource.store_field(env, input, storage, memory, slot, value, next, parameters, plan)
        case None{}: EventSource.store_field(env, input, storage, memory, slot, value, next, parameters, plan)
@unsafe
def EventSource.store_field(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +slot: Big, +value: Big, +next: Emit.Transaction, +parameters: Packed.Parameters(), +plan: Mapping.Runtime.Plan) -> Model.Result(EventSource.Outcome):
  Model.Result.bind(Layout.Packed.Field, EventSource.Outcome, EventSource.physical(parameters, plan, memory, slot), +field =>
    Model.Result.bind(OptionOf(Model.Storage), EventSource.Outcome, Model.Packed.write_field(field, storage, value), written => EventSource.stored(env, input, memory, next, written)))
@unsafe
def EventSource.stored(+env: EventSource.Environment(), +input: Model.Input, +memory: Model.Storage, +next: Emit.Transaction, +written: OptionOf(Model.Storage)) -> Model.Result(EventSource.Outcome):
  match written:
    case None{}: EventSource.revert(input)
    case Some{storage}: EventSource.transaction(env, input, storage, memory, next)
@unsafe
def EventSource.loaded(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +target: Big, +next: Emit.Transaction, +loaded: OptionOf(Big)) -> Model.Result(EventSource.Outcome):
  match loaded:
    case None{}: EventSource.revert(input)
    case Some{value}: EventSource.transaction(env, input, storage, Tup2{target, value} <> memory, next)
@unsafe
def EventSource.transaction(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +tx: Emit.Transaction) -> Model.Result(EventSource.Outcome):
  match tx:
    case Emit.Transaction.Finish{_}: Model.Result.bind(Model.Outcome, EventSource.Outcome, Model.transaction(input, storage, memory, tx), outcome => Done{EventSource.wrap(outcome)})
    case Emit.Transaction.Abort{}: Model.Result.bind(Model.Outcome, EventSource.Outcome, Model.transaction(input, storage, memory, tx), outcome => Done{EventSource.wrap(outcome)})
    case Emit.Transaction.Reject{_, _}: Model.Result.bind(Model.Outcome, EventSource.Outcome, Model.transaction(input, storage, memory, tx), outcome => Done{EventSource.wrap(outcome)})
    case Emit.Transaction.Store{slot, operand, next}:
      Model.Result.bind(Big, EventSource.Outcome, Model.operand(memory, operand), value => EventSource.store(env, input, storage, memory, slot, value, next))
    case Emit.Transaction.Load{slot, target, next}:
      EventSource.load(env, input, storage, memory, slot, target, next)
    case Emit.Transaction.Context{context, target, next}:
      Model.Result.bind(Big, EventSource.Outcome, Model.Packed.context(input, memory, context), value => EventSource.transaction(env, input, storage, Tup2{target, value} <> memory, next))
    case Emit.Transaction.Arithmetic{operation, left, right, target, success, failure}:
      Model.Result.bind(Big, EventSource.Outcome, Model.operand(memory, left), +a =>
        Model.Result.bind(Big, EventSource.Outcome, Model.operand(memory, right), +b =>
          +value = Model.Packed.arithmetic(operation, a, b)
          Native.choose(&2, Model.Result(EventSource.Outcome), Abi.Codec.within(Big.of_nat(256n), value), _ => EventSource.transaction(env, input, storage, Tup2{target, value} <> memory, success), _ => EventSource.transaction(env, input, storage, memory, failure))))
    case Emit.Transaction.Compute{operation, left, right, target, next}:
      Model.Result.bind(Big, EventSource.Outcome, Model.operand(memory, left), +a =>
        Model.Result.bind(Big, EventSource.Outcome, Model.operand(memory, right), +b =>
          +value = Model.Packed.arithmetic(operation, a, b)
          Native.choose(&2, Model.Result(EventSource.Outcome), Abi.Codec.within(Big.of_nat(256n), value), _ => EventSource.transaction(env, input, storage, Tup2{target, value} <> memory, next), _ => Fail{Model.Error.Source{Emit.Error.M1_shape{"proved arithmetic bound"}}})))
    case Emit.Transaction.Compare{left, right, yes, no}: EventSource.compare(env, input, storage, memory, left, right, yes, no)
@unsafe
def EventSource.load(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +slot: Big, +target: Big, +next: Emit.Transaction) -> Model.Result(EventSource.Outcome):
  match env:
    case Tup3{_, parameters, plan}:
      Model.Result.bind(Layout.Packed.Field, EventSource.Outcome, EventSource.physical(parameters, plan, memory, slot), +field =>
        Model.Result.bind(OptionOf(Big), EventSource.Outcome, Model.Packed.read_field(field, storage), loaded => EventSource.loaded(env, input, storage, memory, target, next, loaded)))
@unsafe
def EventSource.compare(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +left: Emit.Operand, +right: Emit.Operand, +yes: Emit.Transaction, +no: Emit.Transaction) -> Model.Result(EventSource.Outcome):
  match no:
    case Emit.Transaction.Reject{selector, operands}:
      EventSource.compare_reject(env, input, storage, memory, left, right, yes, no, selector, operands)
    case Emit.Transaction.Finish{_}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
    case Emit.Transaction.Abort{}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
    case Emit.Transaction.Store{_, _, _}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
    case Emit.Transaction.Load{_, _, _}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
    case Emit.Transaction.Context{_, _, _}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
    case Emit.Transaction.Arithmetic{_, _, _, _, _, _}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
    case Emit.Transaction.Compute{_, _, _, _, _}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
    case Emit.Transaction.Compare{_, _, _, _}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
@unsafe
def EventSource.compare_reject(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +left: Emit.Operand, +right: Emit.Operand, +yes: Emit.Transaction, +no: Emit.Transaction, +selector: String, +operands: ListOf(Emit.Operand)) -> Model.Result(EventSource.Outcome):
  match env:
    case Tup3{events, _, _}: EventSource.compare_event(env, input, storage, memory, left, right, yes, no, operands, EventSource.selector(events, selector))
@unsafe
def EventSource.compare_plain(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +left: Emit.Operand, +right: Emit.Operand, +yes: Emit.Transaction, +no: Emit.Transaction) -> Model.Result(EventSource.Outcome):
  Model.Result.bind(Big, EventSource.Outcome, Model.operand(memory, left), +a =>
    Model.Result.bind(Big, EventSource.Outcome, Model.operand(memory, right), +b =>
      Native.choose(&2, Model.Result(EventSource.Outcome), Big.is_le(a, b), _ => EventSource.transaction(env, input, storage, memory, yes), _ => EventSource.transaction(env, input, storage, memory, no))))
@unsafe
def EventSource.compare_event(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +left: Emit.Operand, +right: Emit.Operand, +yes: Emit.Transaction, +no: Emit.Transaction, +operands: ListOf(Emit.Operand), +found: OptionOf(EventSource.Event)) -> Model.Result(EventSource.Outcome):
  match found:
    case None{}: EventSource.compare_plain(env, input, storage, memory, left, right, yes, no)
    case Some{event}:
      Model.Result.bind(OptionOf(ListOf(Abi.Codec.Value)), EventSource.Outcome, EventSource.values(EventSource.parameters(event), operands, memory, Get.Model.Input.data(input)), values => EventSource.emit_model(env, input, storage, memory, yes, event, values))
@unsafe
def EventSource.values(+parameters: ListOf(Abi.Schema.Parameter), +operands: ListOf(Emit.Operand), +memory: Model.Storage, +data: String) -> Model.Result(OptionOf(ListOf(Abi.Codec.Value))):
  match parameters:
    case Nil{}: EventSource.values_empty(operands)
    case Con{parameter, tail}: EventSource.values_head(parameter, tail, operands, memory, data)
def EventSource.values_empty(+operands: ListOf(Emit.Operand)) -> Model.Result(OptionOf(ListOf(Abi.Codec.Value))):
  match operands:
    case Nil{}: Done{Some{[]}}
    case Con{_, _}: Done{None{}}
@unsafe
def EventSource.values_head(+parameter: Abi.Schema.Parameter, +tail: ListOf(Abi.Schema.Parameter), +operands: ListOf(Emit.Operand), +memory: Model.Storage, +data: String) -> Model.Result(OptionOf(ListOf(Abi.Codec.Value))):
      match operands:
        case Nil{}: Done{None{}}
        case Con{operand, rest}:
          Model.Result.bind(Big, OptionOf(ListOf(Abi.Codec.Value)), Model.operand(memory, operand), +value =>
            Model.Result.bind(OptionOf(ListOf(Abi.Codec.Value)), OptionOf(ListOf(Abi.Codec.Value)), EventSource.values(tail, rest, memory, data), values => Done{EventSource.value_cons(ReturnAbi.value(Get.Abi.Schema.Parameter.typ(parameter), value, data), values)}))
@unsafe
def EventSource.value_cons(+value: OptionOf(Abi.Codec.Value), +values: OptionOf(ListOf(Abi.Codec.Value))) -> OptionOf(ListOf(Abi.Codec.Value)):
  match value:
    case None{}: None{}
    case Some{value}: ReturnAbi.values_cons(value, values)
@unsafe
def EventSource.emit_model(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +next: Emit.Transaction, +event: EventSource.Event, +values: OptionOf(ListOf(Abi.Codec.Value))) -> Model.Result(EventSource.Outcome):
  match values:
    case None{}: EventSource.revert(input)
    case Some{values}: EventSource.emit_values(env, input, storage, memory, next, event, values)
@unsafe
def EventSource.emit_values(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +next: Emit.Transaction, +event: EventSource.Event, +values: ListOf(Abi.Codec.Value)) -> Model.Result(EventSource.Outcome):
      match event:
        case EventSource.Event{name, inputs, anonymous}: EventSource.encoded_model(env, input, storage, memory, next, Abi.Event.encode(name, inputs, anonymous, values))
@unsafe
def EventSource.encoded_model(+env: EventSource.Environment(), +input: Model.Input, +storage: Model.Storage, +memory: Model.Storage, +next: Emit.Transaction, +encoded: Abi.Event.Result(Abi.Event.Log)) -> Model.Result(EventSource.Outcome):
  match encoded:
    case Fail{_}: EventSource.revert(input)
    case Done{Abi.Event.Log{topics, data}}:
      Native.choose(&2, Model.Result(EventSource.Outcome), Big.is_lt(Big.of_nat(131072n), Big.of_nat(String.length(data))), _ => EventSource.revert(input), _ =>
        Model.Result.bind(EventSource.Outcome, EventSource.Outcome, EventSource.transaction(env, input, storage, memory, next), outcome => Done{EventSource.prepend(Abi.Event.Log{topics, data}, outcome)}))
@unsafe
def EventSource.prepend(+log: Abi.Event.Log, +outcome: EventSource.Outcome) -> EventSource.Outcome:
  match outcome:
    case EventSource.Outcome{result, logs}: EventSource.Outcome{result, Native.choose(&2, ListOf(Abi.Event.Log), Get.Model.Outcome.reverted(result), _ => [], _ => log <> logs)}
@unsafe
def EventSource.model_entry(+env: EventSource.Environment(), +input: Model.Input, +entry: OptionOf(Emit.Entry), +fallback: Emit.Transaction) -> Model.Result(EventSource.Outcome):
  match entry:
    case None{}: Native.choose(&2, Model.Result(EventSource.Outcome), Big.is_eq(Get.Model.Input.value(input), Big.zero()), _ => EventSource.transaction(env, input, Get.Model.Input.initial(input), [], fallback), _ => EventSource.revert(input))
    case Some{entry}:
      +arity = {Big.of_nat(List.length(&2, String, Get.Abi.Entry.inputs(Get.Emit.Entry.abi_entry(entry)))) : Big}
      +unpaid = {Bool.and(Bool.not(Big.is_eq(Get.Model.Input.value(input), Big.zero())), Bool.not(Abi.accepts_value(Get.Emit.Entry.abi_entry(entry)))) : Bool}
      Native.choose(&2, Model.Result(EventSource.Outcome), unpaid, _ => EventSource.revert(input), _ =>
        +memory = {SeqList.init(&2, TupleOf2(Big, Big), arity, index => Tup2{Big.add(index, Big.one()), Model.calldata_word(Get.Model.Input.data(input), Big.add(Big.of_nat(4n), Big.mul(index, Big.of_nat(32n))))}) : Model.Storage}
        EventSource.transaction(env, input, Get.Model.Input.initial(input), memory, Get.Emit.Entry.tx(entry)))
@unsafe
def EventSource.model_run(+env: EventSource.Environment(), +program: Model.Program, +input: Model.Input) -> Model.Result(EventSource.Outcome):
  match program:
    case Model.Program.Closed{_}: Fail{Model.Error.Source{Emit.Error.Invalid_ir{"EVENT: expected entries"}}}
    case Model.Program.Entries{entries, fallback}:
      EventSource.model_entry(env, input, SeqList.find(&2, Emit.Entry, entry => NativeString.equal(Get.Emit.Entry.selector(entry), Model.segment(Big.zero(), Big.of_nat(8n), Get.Model.Input.data(input))), entries), fallback)
@unsafe
def EventSource.log_json(+log: Abi.Event.Log) -> String:
  match log:
    case Abi.Event.Log{topics, data}: String.concat(["{\u{22}topics\u{22}:[", String.join(Cli.Event.topics(topics), ","), "],\u{22}data\u{22}:", Abi.quote(String.append("0x", Cli.Event.hex(data))), "}"])
@unsafe
def EventSource.print(+functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +input: Model.Input, +outcome: EventSource.Outcome) -> String:
  match outcome:
    case EventSource.Outcome{result, logs}:
      +encoded = {ReturnAbi.model_output(functions, EventSource.errors(errors), input, result) : Model.Outcome}
      +text = {Model.print(encoded) : String}
      String.concat([Model.segment(Big.zero(), Big.of_nat((String.length(text) - 2n : Nat)), text), ",\u{22}logs\u{22}:[", String.join(SeqList.map(&2, &2, Abi.Event.Log, String, EventSource.log_json, Native.choose(&2, ListOf(Abi.Event.Log), Get.Model.Outcome.reverted(encoded), _ => [], _ => logs)), ","), "]}\u{a}"])
@unsafe
def Cli.EventSource.compile(+command: String, +export: String, +source: Cli.Program, +parameters: Packed.Parameters(), +events: EventSource.Events(), +plan: Mapping.Runtime.Plan) -> IO(Emit.Output):
  match source:
    case Cli.Program{contract, globals, rows, erased}: Cli.compiled(command, EventSource.program(contract, export, globals, rows, erased, parameters, events, plan))
@unsafe
def Cli.EventSource.run(+export: String, +input: Model.Input, +source: Cli.Program, +parameters: Packed.Parameters(), +events: EventSource.Events(), +plan: Mapping.Runtime.Plan) -> IO(Unit):
  match plan:
    case Mapping.Runtime.Plan.Outputs{functions, errors, inner}:
      Cli.EventSource.run_outputs(export, input, source, parameters, events, functions, errors, inner)
    case Mapping.Runtime.Plan.Plain{}: NativeIO.die(Unit, 2, "EVENT: missing output schema")
    case Mapping.Runtime.Plan.Mapped{_, _}: NativeIO.die(Unit, 2, "EVENT: missing output schema")
    case Mapping.Runtime.Plan.Functions{_, _}: NativeIO.die(Unit, 2, "EVENT: missing output schema")
    case Mapping.Runtime.Plan.Events{_, _}: NativeIO.die(Unit, 2, "EVENT: nested event schema")
@unsafe
def Cli.EventSource.run_outputs(+export: String, +input: Model.Input, +source: Cli.Program, +parameters: Packed.Parameters(), +events: EventSource.Events(), +functions: FunctionAbi.Functions(), +errors: ReturnAbi.Errors(), +inner: Mapping.Runtime.Plan) -> IO(Unit):
  match source:
    case Cli.Program{_, globals, _, erased}: do IO<Unit>:
      program : Model.Program <- Cli.model_result(Model.Program, 2, FunctionAbi.model_prepare(export, globals, erased, inner))
      typed : Model.Program <- Cli.model_result(Model.Program, 2, FunctionAbi.model_program(functions, program))
      outcome : EventSource.Outcome <- Cli.model_result(EventSource.Outcome, 2, Native.choose(&2, Model.Result(EventSource.Outcome), FunctionAbi.valid(functions, input), _ => EventSource.model_run(Tup3{events, parameters, inner}, typed, input), _ => EventSource.revert(input)))
      NativeIO.stdout(EventSource.print(functions, errors, input, outcome))
