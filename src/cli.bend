# Native Bend source, compiled by dev/build.py.
def Cli.Return.word(+result: Result<&2, &2, String, Big>) -> IO(Big):
  match result:
    case Done{value}: IO.pure(Big, value)
    case Fail{error}: Cli.Call.fail(Big, "returndata-encode", error)

def Cli.Return.boolean(+text: String) -> IO(Abi.Codec.Value):
  match text:
    case "true": IO.pure(Abi.Codec.Value, Abi.Codec.Value.Bool{True{}})
    case "false": IO.pure(Abi.Codec.Value, Abi.Codec.Value.Bool{False{}})
    case _: Cli.Call.fail(Abi.Codec.Value, "returndata-encode", "expected true or false")

def Cli.Return.numeric(+text: String) -> IO(Big):
  Cli.Return.word(Recognize.parse_word(&2, String, "expected a decimal or 0x-prefixed uint256", "word exceeds uint256", text))

def Cli.Return.value(+typ: Abi.Schema.Value_type, +text: String) -> IO(Abi.Codec.Value):
  match typ:
    case Abi.Schema.Value_type.Uint8{}: IO.bind(Big, Abi.Codec.Value, Cli.Return.numeric(text), word => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Uint8{word}))
    case Abi.Schema.Value_type.Uint256{}: IO.bind(Big, Abi.Codec.Value, Cli.Return.numeric(text), word => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Uint256{word}))
    case Abi.Schema.Value_type.Address{}: IO.bind(Big, Abi.Codec.Value, Cli.Return.numeric(text), word => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Address{word}))
    case Abi.Schema.Value_type.Bool{}: Cli.Return.boolean(text)
    case Abi.Schema.Value_type.String{}: IO.pure(Abi.Codec.Value, Abi.Codec.Value.String{text})

@unsafe
def Cli.Return.fields(+args: ListOf(String)) -> IO(Cli.Call.Fields):
  match args:
    case Nil{}: IO.pure(Cli.Call.Fields, Cli.Call.Fields{[], []})
    case Con{type_name, Con{text, rest}}:
      IO.bind(Abi.Schema.Value_type, Cli.Call.Fields, Cli.Call.typ("returndata-encode", type_name), +typ =>
        IO.bind(Abi.Codec.Value, Cli.Call.Fields, Cli.Return.value(typ, text), value =>
          IO.bind(Cli.Call.Fields, Cli.Call.Fields, Cli.Return.fields(rest), tail => Cli.Call.prepend(typ, value, tail))))
    case Con{_, Nil{}}: Cli.Call.fail(Cli.Call.Fields, "returndata-encode", "expected TYPE VALUE pairs")

@unsafe
def Cli.Return.types(+args: ListOf(String)) -> IO(ListOf(Abi.Schema.Parameter)):
  match args:
    case Nil{}: IO.pure(ListOf(Abi.Schema.Parameter), [])
    case Con{text, rest}:
      IO.bind(Abi.Schema.Value_type, ListOf(Abi.Schema.Parameter), Cli.Call.typ("returndata-decode", text), +typ =>
        IO.bind(ListOf(Abi.Schema.Parameter), ListOf(Abi.Schema.Parameter), Cli.Return.types(rest), tail => IO.pure(ListOf(Abi.Schema.Parameter), MkAbi_Schema_Parameter{"", typ} <> tail)))

def Cli.Return.schema(+outputs: ListOf(Abi.Schema.Parameter)) -> Abi.Schema.Function_:
  MkAbi_Schema_Function_{"", [], outputs, Abi.Mutability.Nonpayable{}}

def Cli.Return.error(+error: Abi.Return.Error) -> String:
  match error:
    case Abi.Return.Error.Arity{}: "output and value counts differ"
    case Abi.Return.Error.Type_mismatch{}: "output and value types differ"
    case Abi.Return.Error.Codec{error}: Cli.Event.codec_error(error)

def Cli.Return.encoded(+result: Abi.Return.Result(String)) -> IO(Unit):
  match result:
    case Done{bytes}: NativeIO.print(String.concat(["{\u{22}returndata\u{22}:", Abi.quote(String.append("0x", Cli.Event.hex(bytes))), "}"]))
    case Fail{error}: Cli.Call.fail(Unit, "returndata-encode", Cli.Return.error(error))

@unsafe
def Cli.Return.encode_fields(+fields: Cli.Call.Fields) -> IO(Unit):
  match fields:
    case Cli.Call.Fields{outputs, values}: Native.choose(&1, IO(Unit), Big.is_lt(Big.of_nat(131072n), NativeInt.sub(Cli.Call.size(values), Big.of_nat(4n))), _ => Cli.Call.fail(Unit, "returndata-encode", "returndata exceeds 131072 bytes"), _ => Cli.Return.encoded(Abi.Return.encode(Cli.Return.schema(outputs), values)))

@unsafe
def Cli.Return.encode(+args: ListOf(String)) -> IO(Unit):
  IO.bind(Cli.Call.Fields, Unit, Cli.Return.fields(args), fields => Cli.Return.encode_fields(fields))

def Cli.Return.unhex(+result: OptionOf(ListOf(Char))) -> IO(String):
  match result:
    case Some{chars}: IO.pure(String, NativeString.of_list(chars))
    case None{}: Cli.Call.fail(String, "returndata-decode", "expected even-length hexadecimal bytes")

@unsafe
def Cli.Return.bytes(+result: OptionOf(String)) -> IO(String):
  match result:
    case None{}: Cli.Call.fail(String, "returndata-decode", "expected even-length hexadecimal bytes")
    case Some{hex}: Native.choose(&1, IO(String), Big.is_lt(Big.of_nat(262144n), Big.of_nat(String.length(hex))), _ => Cli.Call.fail(String, "returndata-decode", "hexadecimal input exceeds 131072 bytes"), _ => Cli.Return.unhex(Cli.EventDecode.pairs(NativeString.to_list(hex))))

def Cli.Return.decoded(+result: Abi.Return.Result(ListOf(Abi.Codec.Value))) -> IO(Unit):
  match result:
    case Done{values}: NativeIO.print(String.concat(["{\u{22}values\u{22}:[", String.join(Cli.Call.values(values), ","), "]}"]))
    case Fail{error}: Cli.Call.fail(Unit, "returndata-decode", Cli.Return.error(error))

@unsafe
def Cli.Return.decode_args(+hex: String, +types: ListOf(String)) -> IO(Unit):
  IO.bind(ListOf(Abi.Schema.Parameter), Unit, Cli.Return.types(types), +outputs =>
    IO.bind(String, Unit, Cli.Return.bytes(Trace.calldata(hex)), bytes => Cli.Return.decoded(Abi.Return.decode(Cli.Return.schema(outputs), bytes))))

@unsafe
def Cli.Return.decode(+args: ListOf(String)) -> IO(Unit):
  match args:
    case Con{hex, types}: Cli.Return.decode_args(hex, types)
    case Nil{}: Cli.Call.fail(Unit, "returndata-decode", "usage: assay returndata-decode HEX [TYPE]...")

type Cli.Call.Fields is Data:
  Cli.Call.Fields{inputs: ListOf(Abi.Schema.Parameter), values: ListOf(Abi.Codec.Value)}

def Cli.Call.fail(-A: Data, +command: String, +message: String) -> IO(A):
  NativeIO.die(A, 64, String.concat(["assay: ", command, ": ", message]))

def Cli.Call.typ(+command: String, +text: String) -> IO(Abi.Schema.Value_type):
  match text:
    case "uint8": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Uint8{})
    case "uint256": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Uint256{})
    case "address": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Address{})
    case "bool": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Bool{})
    case "string": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.String{})
    case _: Cli.Call.fail(Abi.Schema.Value_type, command, String.append("unsupported input type: ", text))

def Cli.Call.word(+result: Result<&2, &2, String, Big>) -> IO(Big):
  match result:
    case Done{value}: IO.pure(Big, value)
    case Fail{error}: Cli.Call.fail(Big, "calldata-encode", error)

def Cli.Call.boolean(+text: String) -> IO(Abi.Codec.Value):
  match text:
    case "true": IO.pure(Abi.Codec.Value, Abi.Codec.Value.Bool{True{}})
    case "false": IO.pure(Abi.Codec.Value, Abi.Codec.Value.Bool{False{}})
    case _: Cli.Call.fail(Abi.Codec.Value, "calldata-encode", "expected true or false")

def Cli.Call.numeric(+text: String) -> IO(Big):
  Cli.Call.word(Recognize.parse_word(&2, String, "expected a decimal or 0x-prefixed uint256", "word exceeds uint256", text))

def Cli.Call.value(+typ: Abi.Schema.Value_type, +text: String) -> IO(Abi.Codec.Value):
  match typ:
    case Abi.Schema.Value_type.Uint8{}: IO.bind(Big, Abi.Codec.Value, Cli.Call.numeric(text), word => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Uint8{word}))
    case Abi.Schema.Value_type.Uint256{}: IO.bind(Big, Abi.Codec.Value, Cli.Call.numeric(text), word => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Uint256{word}))
    case Abi.Schema.Value_type.Address{}: IO.bind(Big, Abi.Codec.Value, Cli.Call.numeric(text), word => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Address{word}))
    case Abi.Schema.Value_type.Bool{}: Cli.Call.boolean(text)
    case Abi.Schema.Value_type.String{}: IO.pure(Abi.Codec.Value, Abi.Codec.Value.String{text})

def Cli.Call.prepend(+typ: Abi.Schema.Value_type, +value: Abi.Codec.Value, +fields: Cli.Call.Fields) -> IO(Cli.Call.Fields):
  match fields:
    case Cli.Call.Fields{inputs, values}: IO.pure(Cli.Call.Fields, Cli.Call.Fields{MkAbi_Schema_Parameter{"", typ} <> inputs, value <> values})

@unsafe
def Cli.Call.fields(+args: ListOf(String)) -> IO(Cli.Call.Fields):
  match args:
    case Nil{}: IO.pure(Cli.Call.Fields, Cli.Call.Fields{[], []})
    case Con{type_name, Con{text, rest}}:
      IO.bind(Abi.Schema.Value_type, Cli.Call.Fields, Cli.Call.typ("calldata-encode", type_name), +typ =>
        IO.bind(Abi.Codec.Value, Cli.Call.Fields, Cli.Call.value(typ, text), value =>
          IO.bind(Cli.Call.Fields, Cli.Call.Fields, Cli.Call.fields(rest), tail => Cli.Call.prepend(typ, value, tail))))
    case Con{_, Nil{}}: Cli.Call.fail(Cli.Call.Fields, "calldata-encode", "expected TYPE VALUE pairs")

@unsafe
def Cli.Call.types(+args: ListOf(String)) -> IO(ListOf(Abi.Schema.Parameter)):
  match args:
    case Nil{}: IO.pure(ListOf(Abi.Schema.Parameter), [])
    case Con{text, rest}:
      IO.bind(Abi.Schema.Value_type, ListOf(Abi.Schema.Parameter), Cli.Call.typ("calldata-decode", text), +typ =>
        IO.bind(ListOf(Abi.Schema.Parameter), ListOf(Abi.Schema.Parameter), Cli.Call.types(rest), tail => IO.pure(ListOf(Abi.Schema.Parameter), MkAbi_Schema_Parameter{"", typ} <> tail)))

def Cli.Call.schema(+name: String, +inputs: ListOf(Abi.Schema.Parameter)) -> Abi.Schema.Function_:
  MkAbi_Schema_Function_{name, inputs, [], Abi.Mutability.Nonpayable{}}

def Cli.Call.error(+error: Abi.Call.Error) -> String:
  match error:
    case Abi.Call.Error.Arity{}: "input and value counts differ"
    case Abi.Call.Error.Type_mismatch{}: "input and value types differ"
    case Abi.Call.Error.Short_selector{}: "truncated function selector"
    case Abi.Call.Error.Wrong_selector{}: "function selector does not match"
    case Abi.Call.Error.Codec{error}: Cli.Event.codec_error(error)

def Cli.Call.encoded(+result: Abi.Call.Result(String)) -> IO(Unit):
  match result:
    case Done{bytes}: NativeIO.print(String.concat(["{\u{22}calldata\u{22}:", Abi.quote(String.append("0x", Cli.Event.hex(bytes))), "}"]))
    case Fail{error}: Cli.Call.fail(Unit, "calldata-encode", Cli.Call.error(error))

def Cli.Call.width(+value: Abi.Codec.Value) -> Big:
  match value:
    case Abi.Codec.Value.Uint8{_}: Big.of_nat(32n)
    case Abi.Codec.Value.Uint256{_}: Big.of_nat(32n)
    case Abi.Codec.Value.Address{_}: Big.of_nat(32n)
    case Abi.Codec.Value.Bool{_}: Big.of_nat(32n)
    case Abi.Codec.Value.String{text}: NativeInt.add(Big.of_nat(64n), NativeInt.add(Big.of_nat(String.length(text)), Abi.Codec.padding(Big.of_nat(String.length(text)))))

def Cli.Call.size(+values: ListOf(Abi.Codec.Value)) -> Big:
  match values:
    case Nil{}: Big.of_nat(4n)
    case Con{value, rest}: NativeInt.add(Cli.Call.width(value), Cli.Call.size(rest))

@unsafe
def Cli.Call.encode_fields(+name: String, +fields: Cli.Call.Fields) -> IO(Unit):
  match fields:
    case Cli.Call.Fields{inputs, values}: Native.choose(&1, IO(Unit), Big.is_lt(Big.of_nat(131072n), Cli.Call.size(values)), _ => Cli.Call.fail(Unit, "calldata-encode", "calldata exceeds 131072 bytes"), _ => Cli.Call.encoded(Abi.Call.encode(Cli.Call.schema(name, inputs), values)))

@unsafe
def Cli.Call.encode(+args: ListOf(String)) -> IO(Unit):
  match args:
    case Nil{}: Cli.Call.fail(Unit, "calldata-encode", "usage: assay calldata-encode NAME [TYPE VALUE]...")
    case Con{name, rest}: Cli.when(Recognize.identifier(name), _ => IO.bind(Cli.Call.Fields, Unit, Cli.Call.fields(rest), fields => Cli.Call.encode_fields(name, fields)), _ => Cli.Call.fail(Unit, "calldata-encode", "expected an ASCII function identifier"))

def Cli.Call.unhex(+result: OptionOf(ListOf(Char))) -> IO(String):
  match result:
    case Some{chars}: IO.pure(String, NativeString.of_list(chars))
    case None{}: Cli.Call.fail(String, "calldata-decode", "expected even-length hexadecimal bytes")

@unsafe
def Cli.Call.bytes(+result: OptionOf(String)) -> IO(String):
  match result:
    case None{}: Cli.Call.fail(String, "calldata-decode", "expected even-length hexadecimal bytes")
    case Some{hex}: Native.choose(&1, IO(String), Big.is_lt(Big.of_nat(262144n), Big.of_nat(String.length(hex))), _ => Cli.Call.fail(String, "calldata-decode", "hexadecimal input exceeds 131072 bytes"), _ => Cli.Call.unhex(Cli.EventDecode.pairs(NativeString.to_list(hex))))

def Cli.Call.values(+values: ListOf(Abi.Codec.Value)) -> ListOf(String):
  match values:
    case Nil{}: []
    case Con{value, rest}: Cli.EventDecode.value(value) <> Cli.Call.values(rest)

def Cli.Call.decoded(+result: Abi.Call.Result(ListOf(Abi.Codec.Value))) -> IO(Unit):
  match result:
    case Done{values}: NativeIO.print(String.concat(["{\u{22}values\u{22}:[", String.join(Cli.Call.values(values), ","), "]}"]))
    case Fail{error}: Cli.Call.fail(Unit, "calldata-decode", Cli.Call.error(error))

@unsafe
def Cli.Call.decode_args(+name: String, +hex: String, +types: ListOf(String)) -> IO(Unit):
  IO.bind(ListOf(Abi.Schema.Parameter), Unit, Cli.Call.types(types), +inputs =>
    IO.bind(String, Unit, Cli.Call.bytes(Trace.calldata(hex)), bytes => Cli.Call.decoded(Abi.Call.decode(Cli.Call.schema(name, inputs), bytes))))

@unsafe
def Cli.Call.decode(+args: ListOf(String)) -> IO(Unit):
  match args:
    case Con{name, Con{hex, types}}: Cli.when(Recognize.identifier(name), _ => Cli.Call.decode_args(name, hex, types), _ => Cli.Call.fail(Unit, "calldata-decode", "expected an ASCII function identifier"))
    case Con{_, Nil{}}: Cli.Call.fail(Unit, "calldata-decode", "usage: assay calldata-decode NAME HEX [TYPE]...")
    case Nil{}: Cli.Call.fail(Unit, "calldata-decode", "usage: assay calldata-decode NAME HEX [TYPE]...")

type Differential.Error is Data:
  Differential.Error.Invalid_value{a0: String}
  Differential.Error.Invalid_caller{a0: String}
  Differential.Error.Missing_python{}
  Differential.Error.Missing_helper{}
  Differential.Error.Runner_exit{a0: Big}
  Differential.Error.Runner_signal{a0: Big}
  Differential.Error.Runner_stopped{a0: Big}
type Trace.Error is Data:
  Trace.Error.Invalid_value{a0: String}
  Trace.Error.Invalid_caller{a0: String}
  Trace.Error.Missing_tool{}
  Trace.Error.Missing_prestate{a0: String}
  Trace.Error.Executor_exit{a0: Big}
  Trace.Error.Executor_signal{a0: Big}
  Trace.Error.Execution_error{}
def Trace.Result(-A: Data) -> Data: Result<&2, &2, Trace.Error, A>
def Trace.Result.pure(-A: Data, value: A) -> Trace.Result(A): Done{value}
def Trace.Result.bind(-A: Data, -B: Data, value: Trace.Result(A), next: A -> Trace.Result(B)) -> Trace.Result(B):
  match value:
    case Done{x}: next(x)
    case Fail{error}: Fail{error}
def Differential.Result(-A: Data) -> Data: Result<&2, &2, Differential.Error, A>
def Differential.Result.pure(-A: Data, value: A) -> Differential.Result(A): Done{value}
def Differential.Result.bind(-A: Data, -B: Data, value: Differential.Result(A), next: A -> Differential.Result(B)) -> Differential.Result(B):
  match value:
    case Done{x}: next(x)
    case Fail{error}: Fail{error}
# Immutable collections and ordinary higher-order functions.
# Reusable function values use Bend's explicit unrestricted boundary.
@unsafe
def Match.Trace_Error(r, -R: Kind(r), value: Trace.Error, on0: (@+a0:String -> R), on1: (@+a0:String -> R), on2: (Unit -> R), on3: (@+a0:String -> R), on4: (@+a0:Big -> R), on5: (@+a0:Big -> R), on6: (Unit -> R)) -> R:
  match value:
    case Trace.Error.Invalid_value{a0}: on0(a0)
    case Trace.Error.Invalid_caller{a0}: on1(a0)
    case Trace.Error.Missing_tool{}: on2(Unit{})
    case Trace.Error.Missing_prestate{a0}: on3(a0)
    case Trace.Error.Executor_exit{a0}: on4(a0)
    case Trace.Error.Executor_signal{a0}: on5(a0)
    case Trace.Error.Execution_error{}: on6(Unit{})
@unsafe
def Match.Differential_Error(r, -R: Kind(r), value: Differential.Error, on0: (@+a0:String -> R), on1: (@+a0:String -> R), on2: (Unit -> R), on3: (Unit -> R), on4: (@+a0:Big -> R), on5: (@+a0:Big -> R), on6: (@+a0:Big -> R)) -> R:
  match value:
    case Differential.Error.Invalid_value{a0}: on0(a0)
    case Differential.Error.Invalid_caller{a0}: on1(a0)
    case Differential.Error.Missing_python{}: on2(Unit{})
    case Differential.Error.Missing_helper{}: on3(Unit{})
    case Differential.Error.Runner_exit{a0}: on4(a0)
    case Differential.Error.Runner_signal{a0}: on5(a0)
    case Differential.Error.Runner_stopped{a0}: on6(a0)
@unsafe
def Trace.calldata(+text_749: String) -> OptionOf(String):
  (+scrut15957 = {NativeString.lower(text_749) : String}
  ((+scrut15958 = {Native.choose(&2, String, String.starts_with(scrut15957, "0x"), _ => (NativeString.drop(2n, scrut15957)), _ => (scrut15957)) : String}
(+scrut15961 = {NativeString.all((+local15960 => (Big.when(Bool, Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(48)), Char.to_u32(local15960)), _ => (U32.is_le(Char.to_u32(local15960), Char.to_u32(Char.from_u32(57)))), _ => (False{})), _ => (True{}), _ => (Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(97)), Char.to_u32(local15960)), _ => (U32.is_le(Char.to_u32(local15960), Char.to_u32(Char.from_u32(102)))), _ => (False{})))))), scrut15958) : Bool}
Native.choose(&2, OptionOf(String), Big.when(Bool, scrut15961, _ => (Big.is_eq(NativeString.length_parity(scrut15958), Big.zero())), _ => (False{})), _ => (Some{scrut15958}), _ => (None{}))))))
@unsafe
def Trace.value(+text_291: String) -> Trace.Result(String):
  (+local15979 => (Match.Result(&2, String, &2, Model.Error, &2, Trace.Result(String), local15979, +item15986 => Done{item15986}, +item15987 => (Fail{(+local15981 => (Trace.Error.Invalid_value{(+scrut15982 = local15981
  Match.Model_Error(&2, String, scrut15982, +p15983 => (Model.error(local15981)), +p15984 => (p15984), +p15985 => (Model.error(local15981))))}))(item15987)}))))((+local15965 => (Match.Result(&2, Model.Input, &2, Model.Error, &2, Model.Result(String), local15965, +item15975 => (Done{(+local15967 => ((+scrut15968 = {NativeString.lower(text_291) : String}
  Native.choose(&2, String, String.starts_with(scrut15968, "0x"), _ => (scrut15968), _ => ((+scrut15974 = {NativeString.of_list(SeqList.drop_while(&2, Char, (+local15973 => (NativeChar.equal(local15973, Char.from_u32(48)))), NativeString.to_list(scrut15968))) : String}
  Native.choose(&2, String, NativeString.equal(scrut15974, ""), _ => ("0"), _ => (scrut15974))))))))(item15975)}), +item15976 => Fail{item15976})))(Model.inputs("", text_291, Nil{})))
@unsafe
def Trace.caller(+text_600: String) -> Trace.Result(String):
  (+local16003 => (Match.Result(&2, String, &2, Model.Error, &2, Trace.Result(String), local16003, +item16010 => Done{item16010}, +item16011 => (Fail{(+local16005 => (Trace.Error.Invalid_caller{(+scrut16006 = local16005
  Match.Model_Error(&2, String, scrut16006, +p16007 => (Model.error(local16005)), +p16008 => (p16008), +p16009 => (Model.error(local16005))))}))(item16011)}))))((+local15990 => (Match.Result(&2, Model.Input, &2, Model.Error, &2, Model.Result(String), local15990, +item15999 => (Done{(+local15992 => ((+scrut15993 = {NativeString.lower(text_600) : String}
  (+scrut15994 = {String.starts_with(scrut15993, "0x") : Bool}
  (+scrut15998 = {Native.choose(&2, String, scrut15994, _ => (NativeString.drop(2n, scrut15993)), _ => (scrut15993)) : String}
  String.append("0x", NativeString.pad(40n, Char.from_u32(48), Big.hex_natural(Big.read_validated(Native.choose(&2, Big, scrut15994, _ => (Big.of_nat(16n)), _ => (Big.of_nat(10n))), scrut15998)))))))))(item15999)}), +item16000 => Fail{item16000})))(Model.inputs_with_caller("", "0", Nil{}, text_600)))
@unsafe
def Local.Trace.scan.f16021(+compact_1205: Reusable(String, String), +param_1223: ListOf(String)) -> Bool:
  (+scrut16025 = param_1223
  Match.List(&2, String, &2, Bool, scrut16025, _ => (False{}), +p16026 => +p16027 => ((+otherwise16028 = {_ => ((+local16031 => (Local.Trace.scan.f16021(compact_1205, local16031)))(p16027)) : Unit -> Bool}
  Native.choose(&2, Bool, NativeString.equal(p16026, "error"), _ => (Match.List.only_Con(&2, String, &2, Bool, p16027, +p16032 => +p16033 => ((+scrut16034 = {compact_1205(p16032) : String}
  (+scrut16035 = {Unit{} : Unit}
  Native.choose(&2, Bool, NativeString.equal(scrut16034, ":"), _ => (Match.Maybe(&2, String, &2, Bool, SeqList.find(&2, String, (+local16043 => (True{})), p16033), _ => (True{}), +value => ((+local16037 => (Big.when(Bool, Bool.not(NativeString.equal(local16037, "")), _ => (True{}), _ => ((+local16040 => (Local.Trace.scan.f16021(compact_1205, local16040)))(p16033)))))(value)))), _ => (Native.choose(&2, Bool, String.starts_with(scrut16034, ":null"), _ => ((+local16046 => (Local.Trace.scan.f16021(compact_1205, local16046)))(p16033)), _ => (Native.choose(&2, Bool, String.starts_with(scrut16034, ":"), _ => (True{}), _ => ((+local16049 => (Local.Trace.scan.f16021(compact_1205, local16049)))(p16033)))))))))), _ => (otherwise16028(Unit{})))), _ => (otherwise16028(Unit{})))))))
@unsafe
def Trace.has_error(+text_1204: String) -> Bool:
  (+scrut16020 = {(+local16013 => NativeString.of_list(SeqList.filter(&2, Char,
    (+local16018 => Bool.not(SeqList.exists(&2, Char,
      +item16019 => NativeChar.equal(local16018, item16019),
      [Char.from_u32(32), Char.from_u32(10), Char.from_u32(13), Char.from_u32(9)]))),
    NativeString.to_list(local16013)))) : Reusable(String, String)}
  (+local16024 => (Local.Trace.scan.f16021(scrut16020, local16024)))(NativeString.split(Char.from_u32(34), text_1204)))
@unsafe
def Trace.error(+param_288: Trace.Error) -> String:
  (+scrut16050 = param_288
  Match.Trace_Error(&2, String, scrut16050, +p16051 => (String.append("TRACE_VALUE: ", p16051)), +p16052 => (String.append("TRACE_CALLER: ", p16052)), _ => ("TRACE_TOOL: evm is not on PATH"), +p16053 => (String.append("TRACE_PRESTATE: cannot read ", p16053)), +p16054 => (String.append("TRACE_EXECUTOR: exit ", Big.show(p16054))), +p16055 => (String.append("TRACE_EXECUTOR: signal ", Big.show(p16055))), _ => ("TRACE_EXECUTION: geth reported an EVM error")))
@unsafe
def Differential.detail(+other_479: Model.Error) -> String:
  (+scrut16068 = other_479
  Match.Model_Error(&2, String, scrut16068, +p16069 => (Model.error(scrut16068)), +p16070 => (p16070), +p16071 => (Model.error(scrut16068))))
@unsafe
def Differential.value(+text_544: String) -> Differential.Result(String):
  (+local16065 => (Match.Result(&2, String, &2, Model.Error, &2, Differential.Result(String), local16065, +item16072 => Done{item16072}, +item16073 => (Fail{(+local16067 => (Differential.Error.Invalid_value{Differential.detail(local16067)}))(item16073)}))))((+local16058 => (Match.Result(&2, Model.Input, &2, Model.Error, &2, Model.Result(String), local16058, +item16061 => (Done{(+local16060 => (NativeString.lower(text_544)))(item16061)}), +item16062 => Fail{item16062})))(Model.inputs("", text_544, Nil{})))
@unsafe
def Differential.default_caller() -> String:
  "0x7e5f4552091a69125d5dfcb7b8c2659029395bdf"
@unsafe
def Differential.second_caller() -> String:
  "0x2b5ad5c4795c026514f8317c7a215e218dccd6cf"
@unsafe
def Differential.caller(+text_640: String) -> Differential.Result(String):
  (+local16095 => (Match.Result(&2, String, &2, Differential.Error, &2, Differential.Result(String), local16095, +item16098 => ((+local16097 => (Native.choose(&2, Differential.Result(String), Big.when(Bool, NativeString.equal(local16097, Differential.default_caller()), _ => (True{}), _ => (NativeString.equal(local16097, Differential.second_caller()))), _ => (Done{local16097}), _ => (Fail{Differential.Error.Invalid_caller{"expected an offline fixture address (public key 1 or 2)"}}))))(item16098)), +item16099 => Fail{item16099})))((+local16083 => (Match.Result(&2, Model.Input, &2, Differential.Error, &2, Differential.Result(String), local16083, +item16092 => (Done{(+local16085 => ((+scrut16086 = {NativeString.lower(text_640) : String}
  (+scrut16087 = {String.starts_with(scrut16086, "0x") : Bool}
  (+scrut16091 = {Native.choose(&2, String, scrut16087, _ => (NativeString.drop(2n, scrut16086)), _ => (scrut16086)) : String}
  String.append("0x", NativeString.pad(40n, Char.from_u32(48), Big.hex_natural(Big.read_validated(Native.choose(&2, Big, scrut16087, _ => (Big.of_nat(16n)), _ => (Big.of_nat(10n))), scrut16091)))))))))(item16092)}), +item16093 => Fail{item16093})))((+local16076 => (Match.Result(&2, Model.Input, &2, Model.Error, &2, Differential.Result(Model.Input), local16076, +item16079 => Done{item16079}, +item16080 => (Fail{(+local16078 => (Differential.Error.Invalid_caller{Differential.detail(local16078)}))(item16080)}))))(Model.inputs_with_caller("", "0", Nil{}, text_640))))
@unsafe
def Differential.signal_name(+signal_283: Big) -> String:
  (+scrut16105 = {Con{Tup2{Big.neg(Big.of_nat(1n)), "SIGABRT"}, Con{Tup2{Big.neg(Big.of_nat(2n)), "SIGALRM"}, Con{Tup2{Big.neg(Big.of_nat(3n)), "SIGFPE"}, Con{Tup2{Big.neg(Big.of_nat(4n)), "SIGHUP"}, Con{Tup2{Big.neg(Big.of_nat(5n)), "SIGILL"}, Con{Tup2{Big.neg(Big.of_nat(6n)), "SIGINT"}, Con{Tup2{Big.neg(Big.of_nat(7n)), "SIGKILL"}, Con{Tup2{Big.neg(Big.of_nat(8n)), "SIGPIPE"}, Con{Tup2{Big.neg(Big.of_nat(9n)), "SIGQUIT"}, Con{Tup2{Big.neg(Big.of_nat(10n)), "SIGSEGV"}, Con{Tup2{Big.neg(Big.of_nat(11n)), "SIGTERM"}, Con{Tup2{Big.neg(Big.of_nat(12n)), "SIGUSR1"}, Con{Tup2{Big.neg(Big.of_nat(13n)), "SIGUSR2"}, Con{Tup2{Big.neg(Big.of_nat(14n)), "SIGCHLD"}, Con{Tup2{Big.neg(Big.of_nat(15n)), "SIGCONT"}, Con{Tup2{Big.neg(Big.of_nat(16n)), "SIGSTOP"}, Con{Tup2{Big.neg(Big.of_nat(17n)), "SIGTSTP"}, Con{Tup2{Big.neg(Big.of_nat(18n)), "SIGTTIN"}, Con{Tup2{Big.neg(Big.of_nat(19n)), "SIGTTOU"}, Con{Tup2{Big.neg(Big.of_nat(20n)), "SIGVTALRM"}, Con{Tup2{Big.neg(Big.of_nat(21n)), "SIGPROF"}, Con{Tup2{Big.neg(Big.of_nat(22n)), "SIGBUS"}, Con{Tup2{Big.neg(Big.of_nat(23n)), "SIGPOLL"}, Con{Tup2{Big.neg(Big.of_nat(24n)), "SIGSYS"}, Con{Tup2{Big.neg(Big.of_nat(25n)), "SIGTRAP"}, Con{Tup2{Big.neg(Big.of_nat(26n)), "SIGURG"}, Con{Tup2{Big.neg(Big.of_nat(27n)), "SIGXCPU"}, Con{Tup2{Big.neg(Big.of_nat(28n)), "SIGXFSZ"}, Nil{}}}}}}}}}}}}}}}}}}}}}}}}}}}}} : ListOf(TupleOf2(Big, String))}
  (+local16108 => (Maybe.default(&2, String, local16108, String.append("signal ", Big.show(signal_283)))))(SeqList.assoc(&2, &2, Big, String, +x => +y => Big.is_eq(x, y), signal_283, scrut16105)))
@unsafe
def Differential.error(+param_449: Differential.Error) -> String:
  (+scrut16100 = param_449
  Match.Differential_Error(&2, String, scrut16100, +p16101 => (String.append("DIFF_VALUE: ", p16101)), +p16102 => (String.append("DIFF_CALLER: ", p16102)), _ => ("DIFF_TOOL: python3 is not on PATH"), _ => ("DIFF_HELPER: cannot read evm/diff.py"), +p16103 => (String.append("DIFF_RUNNER: exit ", Big.show(p16103))), +p16104 => (String.append("DIFF_RUNNER: killed by ", Differential.signal_name(p16104))), +p16109 => (String.append("DIFF_RUNNER: stopped by ", Differential.signal_name(p16109)))))
def NativeIO.read_bytes(file: File, max: U32) -> IO(File & Result<&1, &1, U32 & String, String>):
  import "./os.js"
def NativeIO.write_bytes(file: File, bytes: String) -> IO(File & Result<&1, &1, U32 & String, Unit>):
  import "./os.js"
def NativeIO.exit(code: U32) -> IO(Unit):
  import "./os.js"
def NativeIO.args() -> IO(List<&1, String>):
  import "./os.js"
def NativeIO.stdout(text: String) -> IO(Unit):
  import "./os.js"
def NativeIO.print(text: String) -> IO(Unit): NativeIO.stdout(String.append(text, "\n"))
def NativeIO.die(-A: Type, code: U32, text: String) -> IO(A):
  import "./os.js"
def NativeIO.open(path: String, mode: String) -> IO(Result<&1, &1, U32 & String, File>):
  import "./os.js"

# File contents are byte strings, matching the source language and ABI.
law NativeIO.read_loop: for file: File for chunks: List<&2, String> IO(Result<&2, &2, String, String>)
@unsafe
def NativeIO.read_chunk(file: File, chunks: List<&2, String>, result: Result<&1, &1, U32 & String, String>) -> IO(Result<&2, &2, String, String>):
  match result:
    case Fail{(code, message)}: IO.bind(Unit, Result<&2, &2, String, String>, File.close(file), _ => IO.pure(Result<&2, &2, String, String>, Fail{message}))
    case Done{SNil{}}: IO.bind(Unit, Result<&2, &2, String, String>, File.close(file), _ => IO.pure(Result<&2, &2, String, String>, Done{String.concat(List.reverse(&2, String, chunks))}))
    case Done{SCon{byte, rest}}: NativeIO.read_loop(file, SCon{byte, rest} <> chunks)
def NativeIO.read_pair(response: File & Result<&1, &1, U32 & String, String>, chunks: List<&2, String>) -> IO(Result<&2, &2, String, String>):
  (file, result) = response
  NativeIO.read_chunk(file, chunks, result)
@unsafe
def NativeIO.read_loop(file, chunks): IO.bind(File & Result<&1, &1, U32 & String, String>, Result<&2, &2, String, String>, NativeIO.read_bytes(file, 65536), response => NativeIO.read_pair(response, chunks))
def NativeIO.read_open(result: Result<&1, &1, U32 & String, File>) -> IO(Result<&2, &2, String, String>):
  match result:
    case Fail{(code, message)}: IO.pure(Result<&2, &2, String, String>, Fail{message})
    case Done{file}: NativeIO.read_loop(file, Nil{})
def NativeIO.read(path: String) -> IO(Result<&2, &2, String, String>): IO.bind(Result<&1, &1, U32 & String, File>, Result<&2, &2, String, String>, NativeIO.open(path, "r"), result => NativeIO.read_open(result))
def NativeIO.write_result(result: Result<&1, &1, U32 & String, Unit>) -> Result<&2, &2, String, Unit>:
  match result:
    case Fail{(code, message)}: Fail{message}
    case Done{unit}: Done{unit}
def NativeIO.write_pair(response: File & Result<&1, &1, U32 & String, Unit>) -> IO(Result<&2, &2, String, Unit>):
  (file, result) = response
  IO.bind(Unit, Result<&2, &2, String, Unit>, File.close(file), _ => IO.pure(Result<&2, &2, String, Unit>, NativeIO.write_result(result)))
def NativeIO.write_open(result: Result<&1, &1, U32 & String, File>, contents: String) -> IO(Result<&2, &2, String, Unit>):
  match result:
    case Fail{(code, message)}: IO.pure(Result<&2, &2, String, Unit>, Fail{message})
    case Done{file}: IO.bind(File & Result<&1, &1, U32 & String, Unit>, Result<&2, &2, String, Unit>, NativeIO.write_bytes(file, contents), response => NativeIO.write_pair(response))
def NativeIO.write(path: String, contents: String) -> IO(Result<&2, &2, String, Unit>): IO.bind(Result<&1, &1, U32 & String, File>, Result<&2, &2, String, Unit>, NativeIO.open(path, "w"), result => NativeIO.write_open(result, contents))
type OS.Process is Data: OS.Process{kind: U32, code: U32, signal: String, output: String}
def OS.regular(path: String) -> IO(Bool):
  import "./os.js"
def OS.mkdir_new(path: String) -> IO(Bool):
  import "./os.js"
def OS.basename(path: String) -> IO(String):
  import "./os.js"
def OS.root() -> IO(String):
  import "./os.js"
def OS.executable(name: String) -> IO(Maybe<&2, String>):
  import "./os.js"
def OS.run(program: String, args: List<&2, String>) -> IO(OS.Process):
  import "./os.js"
def Cli.Rows() -> Data: List<&2, Tuple2<&2, &2, String, Global.Entry>>
def Cli.Erased() -> Data: List<&2, Tuple2<&2, &2, String, Erase.Entry>>
type Cli.Checked is Data: Cli.Checked{contract: String, globals: Global, rows: Cli.Rows()}
type Cli.Program is Data: Cli.Program{contract: String, globals: Global, rows: Cli.Rows(), erased: Cli.Erased()}
type Cli.Options is Data: Cli.Options{entries: List<&2, Tuple2<&2, &2, String, String>>, storage: List<&2, String>}
def Cli.when(test: Bool, yes: Unit -> IO(Unit), no: Unit -> IO(Unit)) -> IO(Unit):
  match test:
    case True{}: yes(Unit{})
    case False{}: no(Unit{})
def Cli.fail(code: U32, message: String) -> IO(Unit): NativeIO.die(Unit, code, message)
def Cli.usage() -> IO(Unit): Cli.fail(64, "usage: assay check [--print|--erased] FILE | axioms FILE | spec-count | emit FILE -o DIR | trace FILE --calldata HEX [--prestate FILE] [--value WORD] [--caller ADDRESS] | diff FILE --calldata HEX [--prestate FILE] [--value WORD] [--caller ADDRESS] | run FILE [--calldata HEX] [--storage SLOT=WORD]... [--value WORD] [--caller ADDRESS] [--address ADDRESS] [--export NAME] | mapping-slot BASE TYPE KEY [TYPE KEY]... | event-encode NAME [--anonymous] [TYPE indexed|data VALUE]... | event-decode NAME [--anonymous] --topics HEX[,HEX]... --data HEX [TYPE indexed|data]... | calldata-encode NAME [TYPE VALUE]... | calldata-decode NAME HEX [TYPE]... | returndata-encode [TYPE VALUE]... | returndata-decode HEX [TYPE]... | mapping-layout FILE | deploy FILE | test FILE")

type Cli.Event.Fields is Data:
  Cli.Event.Fields{inputs: ListOf(Abi.Schema.Event_parameter), values: ListOf(Abi.Codec.Value)}

def Cli.Event.usage() -> IO(Unit): Cli.fail(64, "assay: event-encode: usage: assay event-encode NAME [--anonymous] [TYPE indexed|data VALUE]...")

def Cli.Event.codec_error(+error: Abi.Codec.Error) -> String:
  match error:
    case Abi.Codec.Error.Out_of_range{typ}: String.append("value exceeds ", Abi.Schema.type_name(typ))
    case Abi.Codec.Error.Too_large{}: "encoded value is too large"
    case Abi.Codec.Error.Truncated{}: "truncated value"
    case Abi.Codec.Error.Invalid_bool{}: "invalid boolean value"
    case Abi.Codec.Error.Invalid_offset{}: "invalid offset"
    case Abi.Codec.Error.Nonzero_padding{}: "nonzero padding"
    case Abi.Codec.Error.Trailing_data{}: "trailing data"

def Cli.Event.error(+error: Abi.Event.Error) -> String:
  match error:
    case Abi.Event.Error.Arity{}: "field and value counts differ"
    case Abi.Event.Error.Type_mismatch{}: "field and value types differ"
    case Abi.Event.Error.Too_many_topics{}: "too many indexed fields"
    case Abi.Event.Error.Codec{error}: Cli.Event.codec_error(error)

def Cli.Event.typ(+text: String) -> IO(Abi.Schema.Value_type):
  match text:
    case "uint8": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Uint8{})
    case "uint256": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Uint256{})
    case "address": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Address{})
    case "bool": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Bool{})
    case "string": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.String{})
    case _: NativeIO.die(Abi.Schema.Value_type, 64, String.append("assay: event-encode: unsupported field type: ", text))

def Cli.Event.indexed(+text: String) -> IO(Bool):
  match text:
    case "indexed": IO.pure(Bool, True{})
    case "data": IO.pure(Bool, False{})
    case _: NativeIO.die(Bool, 64, "assay: event-encode: expected indexed or data")

def Cli.Event.word_result(+result: Result<&2, &2, String, Big>) -> IO(Big):
  match result:
    case Done{value}: IO.pure(Big, value)
    case Fail{error}: NativeIO.die(Big, 64, String.append("assay: event-encode: ", error))

def Cli.Event.word(+text: String) -> IO(Big):
  Cli.Event.word_result(Recognize.parse_word(&2, String, "expected a decimal or 0x-prefixed uint256", "word exceeds uint256", text))

def Cli.Event.boolean(+text: String) -> IO(Abi.Codec.Value):
  match text:
    case "true": IO.pure(Abi.Codec.Value, Abi.Codec.Value.Bool{True{}})
    case "false": IO.pure(Abi.Codec.Value, Abi.Codec.Value.Bool{False{}})
    case _: NativeIO.die(Abi.Codec.Value, 64, "assay: event-encode: expected true or false")

def Cli.Event.value(+typ: Abi.Schema.Value_type, +text: String) -> IO(Abi.Codec.Value):
  match typ:
    case Abi.Schema.Value_type.Uint8{}: IO.bind(Big, Abi.Codec.Value, Cli.Event.word(text), value => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Uint8{value}))
    case Abi.Schema.Value_type.Uint256{}: IO.bind(Big, Abi.Codec.Value, Cli.Event.word(text), value => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Uint256{value}))
    case Abi.Schema.Value_type.Address{}: IO.bind(Big, Abi.Codec.Value, Cli.Event.word(text), value => IO.pure(Abi.Codec.Value, Abi.Codec.Value.Address{value}))
    case Abi.Schema.Value_type.Bool{}: Cli.Event.boolean(text)
    case Abi.Schema.Value_type.String{}: IO.pure(Abi.Codec.Value, Abi.Codec.Value.String{text})

def Cli.Event.prepend(+typ: Abi.Schema.Value_type, +indexed: Bool, +value: Abi.Codec.Value, +fields: Cli.Event.Fields) -> IO(Cli.Event.Fields):
  match fields:
    case Cli.Event.Fields{inputs, values}: IO.pure(Cli.Event.Fields, Cli.Event.Fields{Con{MkAbi_Schema_Event_parameter{MkAbi_Schema_Parameter{"", typ}, indexed}, inputs}, Con{value, values}})

@unsafe
def Cli.Event.fields(+args: ListOf(String)) -> IO(Cli.Event.Fields):
  match args:
    case Nil{}: IO.pure(Cli.Event.Fields, Cli.Event.Fields{[], []})
    case Con{type_name, Con{index_text, Con{value_text, rest}}}:
      IO.bind(Abi.Schema.Value_type, Cli.Event.Fields, Cli.Event.typ(type_name), +typ =>
        IO.bind(Bool, Cli.Event.Fields, Cli.Event.indexed(index_text), +indexed =>
          IO.bind(Abi.Codec.Value, Cli.Event.Fields, Cli.Event.value(typ, value_text), value =>
            IO.bind(Cli.Event.Fields, Cli.Event.Fields, Cli.Event.fields(rest), tail =>
              Cli.Event.prepend(typ, indexed, value, tail)))))
    case Con{_, Con{_, Nil{}}}: NativeIO.die(Cli.Event.Fields, 64, "assay: event-encode: expected TYPE indexed|data VALUE triples")
    case Con{_, Nil{}}: NativeIO.die(Cli.Event.Fields, 64, "assay: event-encode: expected TYPE indexed|data VALUE triples")

def Cli.Event.hex(+text: String) -> String:
  String.join(SeqList.map(&2, &2, Char, String, +char => NativeString.pad(2n, Char.from_u32(48), Big.hex(Big.of_nat(U32.to_nat(Char.to_u32(char))), False{})), NativeString.to_list(text)), "")

def Cli.Event.topics(+topics: ListOf(String)) -> ListOf(String):
  match topics:
    case Nil{}: []
    case Con{topic, tail}: Con{Abi.quote(String.append("0x", Cli.Event.hex(topic))), Cli.Event.topics(tail)}

def Cli.Event.output(+result: Abi.Event.Result(Abi.Event.Log)) -> IO(Unit):
  match result:
    case Done{Abi.Event.Log{topics, data}}: NativeIO.print(String.concat(["{\u{22}topics\u{22}:[", String.join(Cli.Event.topics(topics), ","), "],\u{22}data\u{22}:", Abi.quote(String.append("0x", Cli.Event.hex(data))), "}"]))
    case Fail{error}: Cli.fail(64, String.append("assay: event-encode: ", Cli.Event.error(error)))

def Cli.Event.finish(+name: String, +anonymous: Bool, +fields: Cli.Event.Fields) -> IO(Unit):
  match fields:
    case Cli.Event.Fields{inputs, values}: Cli.Event.output(Abi.Event.encode(name, inputs, anonymous, values))

def Cli.Event.encode(+name: String, +anonymous: Bool, +args: ListOf(String)) -> IO(Unit):
  IO.bind(Cli.Event.Fields, Unit, Cli.Event.fields(args), fields => Cli.Event.finish(name, anonymous, fields))

@unsafe
def Cli.Event.options(+name: String, +args: ListOf(String)) -> IO(Unit):
  match args:
    case Nil{}: Cli.Event.encode(name, False{}, [])
    case Con{option, rest}: Cli.when(NativeString.equal(option, "--anonymous"), _ => Cli.Event.encode(name, True{}, rest), _ => Cli.Event.encode(name, False{}, args))

@unsafe
def Cli.Event.run(+args: ListOf(String)) -> IO(Unit):
  match args:
    case Nil{}: Cli.Event.usage()
    case Con{name, rest}: Cli.when(Recognize.identifier(name), _ => Cli.Event.options(name, rest), _ => Cli.fail(64, "assay: event-encode: expected an ASCII event identifier"))

def Cli.EventDecode.usage() -> IO(Unit): Cli.fail(64, "assay: event-decode: usage: assay event-decode NAME [--anonymous] --topics HEX[,HEX]... --data HEX [TYPE indexed|data]...")

def Cli.EventDecode.typ(+text: String) -> IO(Abi.Schema.Value_type):
  match text:
    case "uint8": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Uint8{})
    case "uint256": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Uint256{})
    case "address": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Address{})
    case "bool": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Bool{})
    case "string": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.String{})
    case _: NativeIO.die(Abi.Schema.Value_type, 64, String.append("assay: event-decode: unsupported field type: ", text))

def Cli.EventDecode.indexed(+text: String) -> IO(Bool):
  match text:
    case "indexed": IO.pure(Bool, True{})
    case "data": IO.pure(Bool, False{})
    case _: NativeIO.die(Bool, 64, "assay: event-decode: expected indexed or data")

@unsafe
def Cli.EventDecode.fields(+args: ListOf(String)) -> IO(ListOf(Abi.Schema.Event_parameter)):
  match args:
    case Nil{}: IO.pure(ListOf(Abi.Schema.Event_parameter), [])
    case Con{type_name, Con{index_text, rest}}:
      IO.bind(Abi.Schema.Value_type, ListOf(Abi.Schema.Event_parameter), Cli.EventDecode.typ(type_name), +typ =>
        IO.bind(Bool, ListOf(Abi.Schema.Event_parameter), Cli.EventDecode.indexed(index_text), +indexed =>
          IO.bind(ListOf(Abi.Schema.Event_parameter), ListOf(Abi.Schema.Event_parameter), Cli.EventDecode.fields(rest), tail =>
            IO.pure(ListOf(Abi.Schema.Event_parameter), MkAbi_Schema_Event_parameter{MkAbi_Schema_Parameter{"", typ}, indexed} <> tail))))
    case Con{_, Nil{}}: NativeIO.die(ListOf(Abi.Schema.Event_parameter), 64, "assay: event-decode: expected TYPE indexed|data pairs")

@unsafe
def Cli.EventDecode.digit(+char: Char) -> Big:
  Native.choose(&2, Big, U32.is_le(Char.to_u32(char), 57), _ => NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(char))), Big.of_nat(48n)), _ => NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(char))), Big.of_nat(87n)))

def Cli.EventDecode.prepend(+char: Char, +result: OptionOf(ListOf(Char))) -> OptionOf(ListOf(Char)):
  match result:
    case Some{chars}: Some{char <> chars}
    case None{}: None{}

def Cli.EventDecode.pairs(+chars: ListOf(Char)) -> OptionOf(ListOf(Char)):
  match chars:
    case Nil{}: Some{[]}
    case Con{_, Nil{}}: None{}
    case Con{hi, Con{lo, rest}}: Cli.EventDecode.prepend(Char.from_u32(U32.from_nat(Big.to_nat(NativeInt.add(NativeInt.mul(Cli.EventDecode.digit(hi), Big.of_nat(16n)), Cli.EventDecode.digit(lo))))), Cli.EventDecode.pairs(rest))

def Cli.EventDecode.unhex_result(+result: OptionOf(ListOf(Char))) -> IO(String):
  match result:
    case Some{chars}: IO.pure(String, NativeString.of_list(chars))
    case None{}: NativeIO.die(String, 64, "assay: event-decode: expected even-length hexadecimal bytes")

def Cli.EventDecode.bytes_result(+result: OptionOf(String)) -> IO(String):
  match result:
    case Some{hex}: Cli.EventDecode.sized(hex)
    case None{}: NativeIO.die(String, 64, "assay: event-decode: expected even-length hexadecimal bytes")

@unsafe
def Cli.EventDecode.sized(+hex: String) -> IO(String):
  Native.choose(&1, IO(String), Big.is_lt(Big.of_nat(262144n), Big.of_nat(String.length(hex))), _ => NativeIO.die(String, 64, "assay: event-decode: hexadecimal input exceeds 131072 bytes"), _ => Cli.EventDecode.unhex_result(Cli.EventDecode.pairs(NativeString.to_list(hex))))

def Cli.EventDecode.bytes(+text: String) -> IO(String): Cli.EventDecode.bytes_result(Trace.calldata(text))

@unsafe
def Cli.EventDecode.topic_list(+texts: ListOf(String)) -> IO(ListOf(String)):
  match texts:
    case Nil{}: IO.pure(ListOf(String), [])
    case Con{text, rest}: IO.bind(String, ListOf(String), Cli.EventDecode.bytes(text), +topic => IO.bind(ListOf(String), ListOf(String), Cli.EventDecode.topic_list(rest), tail => IO.pure(ListOf(String), topic <> tail)))

@unsafe
def Cli.EventDecode.topics(+text: String) -> IO(ListOf(String)):
  Native.choose(&1, IO(ListOf(String)), NativeString.equal(text, ""), _ => IO.pure(ListOf(String), []), _ => Cli.EventDecode.topic_list(NativeString.split(Char.from_u32(44), text)))

def Cli.EventDecode.error(+error: Abi.Event.Decode_error) -> String:
  match error:
    case Abi.Event.Decode_error.Too_many_topics{}: "too many indexed fields"
    case Abi.Event.Decode_error.Topic_count{}: "topic count does not match schema"
    case Abi.Event.Decode_error.Topic_size{}: "topics must contain exactly 32 bytes"
    case Abi.Event.Decode_error.Wrong_signature{}: "event signature does not match"
    case Abi.Event.Decode_error.Codec{error}: Cli.Event.codec_error(error)

def Cli.EventDecode.field(+typ: String, +key: String, +value: String) -> String:
  String.concat(["{\u{22}type\u{22}:", Abi.quote(typ), ",", Abi.quote(key), ":", value, "}"])

def Cli.EventDecode.value(+value: Abi.Codec.Value) -> String:
  match value:
    case Abi.Codec.Value.Uint8{word}: Cli.EventDecode.field("uint8", "value", Abi.quote(Big.show(word)))
    case Abi.Codec.Value.Uint256{word}: Cli.EventDecode.field("uint256", "value", Abi.quote(Big.show(word)))
    case Abi.Codec.Value.Address{word}: Cli.EventDecode.field("address", "value", Abi.quote(String.append("0x", NativeString.pad(40n, Char.from_u32(48), Big.hex_natural(word)))))
    case Abi.Codec.Value.Bool{value}: Cli.EventDecode.field("bool", "value", Cli.EventDecode.boolean(value))
    case Abi.Codec.Value.String{bytes}: Cli.EventDecode.field("string", "bytes", Abi.quote(String.append("0x", Cli.Event.hex(bytes))))

@unsafe
def Cli.EventDecode.boolean(+value: Bool) -> String:
  Native.choose(&2, String, value, _ => "true", _ => "false")

def Cli.EventDecode.values(+values: ListOf(Abi.Event.Decoded)) -> ListOf(String):
  match values:
    case Nil{}: []
    case Con{Abi.Event.Decoded.Value{value}, rest}: Cli.EventDecode.value(value) <> Cli.EventDecode.values(rest)
    case Con{Abi.Event.Decoded.Hash{bytes}, rest}: Cli.EventDecode.field("string", "hash", Abi.quote(String.append("0x", Cli.Event.hex(bytes)))) <> Cli.EventDecode.values(rest)

def Cli.EventDecode.output(+result: Abi.Event.Decode_result(ListOf(Abi.Event.Decoded))) -> IO(Unit):
  match result:
    case Done{values}: NativeIO.print(String.concat(["{\u{22}values\u{22}:[", String.join(Cli.EventDecode.values(values), ","), "]}"]))
    case Fail{error}: Cli.fail(64, String.append("assay: event-decode: ", Cli.EventDecode.error(error)))

@unsafe
def Cli.EventDecode.decode(+name: String, +anonymous: Bool, +topic_text: String, +data_text: String, +args: ListOf(String)) -> IO(Unit):
  IO.bind(ListOf(Abi.Schema.Event_parameter), Unit, Cli.EventDecode.fields(args), +inputs =>
    IO.bind(ListOf(String), Unit, Cli.EventDecode.topics(topic_text), +topics =>
      IO.bind(String, Unit, Cli.EventDecode.bytes(data_text), data =>
        Cli.EventDecode.output(Abi.Event.decode(name, inputs, anonymous, Abi.Event.Log{topics, data})))))

@unsafe
def Cli.EventDecode.log(+name: String, +anonymous: Bool, +args: ListOf(String)) -> IO(Unit):
  match args:
    case Con{topic_flag, Con{topics, Con{data_flag, Con{data, fields}}}}:
      Cli.when(NativeString.equal(topic_flag, "--topics"), _ => Cli.when(NativeString.equal(data_flag, "--data"), _ => Cli.EventDecode.decode(name, anonymous, topics, data, fields), _ => Cli.EventDecode.usage()), _ => Cli.EventDecode.usage())
    case _: Cli.EventDecode.usage()

@unsafe
def Cli.EventDecode.options(+name: String, +args: ListOf(String)) -> IO(Unit):
  match args:
    case Nil{}: Cli.EventDecode.usage()
    case Con{option, rest}: Cli.when(NativeString.equal(option, "--anonymous"), _ => Cli.EventDecode.log(name, True{}, rest), _ => Cli.EventDecode.log(name, False{}, args))

@unsafe
def Cli.EventDecode.run(+args: ListOf(String)) -> IO(Unit):
  match args:
    case Nil{}: Cli.EventDecode.usage()
    case Con{name, rest}: Cli.when(Recognize.identifier(name), _ => Cli.EventDecode.options(name, rest), _ => Cli.fail(64, "assay: event-decode: expected an ASCII event identifier"))

def Cli.Mapping.usage() -> IO(Unit): Cli.fail(64, "assay: mapping-slot: usage: assay mapping-slot BASE TYPE KEY [TYPE KEY]...")

def Cli.Mapping.error(+error: Layout.Mapping.Error) -> String:
  match error:
    case Layout.Mapping.Error.Invalid_slot{}: "base slot exceeds uint256"
    case Layout.Mapping.Error.Unsupported_key{}: "unsupported mapping key type"
    case Layout.Mapping.Error.Out_of_range{typ}: String.append("key exceeds ", Abi.Schema.type_name(typ))
    case Layout.Mapping.Error.Empty_path{}: "expected at least one mapping key"

def Cli.Mapping.word_result(+result: Result<&2, &2, String, Big>) -> IO(Big):
  match result:
    case Done{value}: IO.pure(Big, value)
    case Fail{error}: NativeIO.die(Big, 64, String.append("assay: mapping-slot: ", error))

def Cli.Mapping.parse(+invalid: String, +text: String) -> IO(Big):
  Cli.Mapping.word_result(Recognize.parse_word(&2, String, invalid, "word exceeds uint256", text))

def Cli.Mapping.word(+text: String) -> IO(Big): Cli.Mapping.parse("expected a decimal or 0x-prefixed uint256", text)

def Cli.Mapping.typ(+text: String) -> IO(Abi.Schema.Value_type):
  match text:
    case "uint8": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Uint8{})
    case "uint256": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Uint256{})
    case "address": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Address{})
    case "bool": IO.pure(Abi.Schema.Value_type, Abi.Schema.Value_type.Bool{})
    case _: NativeIO.die(Abi.Schema.Value_type, 64, String.append("assay: mapping-slot: unsupported key type: ", text))

def Cli.Mapping.boolean(+text: String) -> IO(Big):
  match text:
    case "true": IO.pure(Big, Big.one())
    case "false": IO.pure(Big, Big.zero())
    case _: Cli.Mapping.parse("expected true, false, a decimal or 0x-prefixed integer", text)

def Cli.Mapping.value(+typ: Abi.Schema.Value_type, +text: String) -> IO(Big):
  match typ:
    case Abi.Schema.Value_type.Uint8{}: Cli.Mapping.word(text)
    case Abi.Schema.Value_type.Uint256{}: Cli.Mapping.word(text)
    case Abi.Schema.Value_type.Address{}: Cli.Mapping.word(text)
    case Abi.Schema.Value_type.Bool{}: Cli.Mapping.boolean(text)
    case Abi.Schema.Value_type.String{}: Cli.Mapping.word(text)

def Cli.Mapping.key_result(+key: Layout.Mapping.Key, +result: Layout.Mapping.Result(String)) -> IO(Layout.Mapping.Key):
  match result:
    case Done{_}: IO.pure(Layout.Mapping.Key, key)
    case Fail{error}: NativeIO.die(Layout.Mapping.Key, 64, String.append("assay: mapping-slot: ", Cli.Mapping.error(error)))

def Cli.Mapping.key(+typ: Abi.Schema.Value_type, +value: Big) -> IO(Layout.Mapping.Key):
  +key = {Layout.Mapping.Key{typ, value} : Layout.Mapping.Key}
  Cli.Mapping.key_result(key, Layout.Mapping.key_word(key))

@unsafe
def Cli.Mapping.keys(+args: ListOf(String)) -> IO(ListOf(Layout.Mapping.Key)):
  match args:
    case Nil{}: IO.pure(ListOf(Layout.Mapping.Key), Nil{})
    case Con{type_name, Con{value_text, rest}}:
      IO.bind(Abi.Schema.Value_type, ListOf(Layout.Mapping.Key), Cli.Mapping.typ(type_name), +typ =>
        IO.bind(Big, ListOf(Layout.Mapping.Key), Cli.Mapping.value(typ, value_text), value =>
          IO.bind(Layout.Mapping.Key, ListOf(Layout.Mapping.Key), Cli.Mapping.key(typ, value), key =>
            IO.bind(ListOf(Layout.Mapping.Key), ListOf(Layout.Mapping.Key), Cli.Mapping.keys(rest), tail =>
              IO.pure(ListOf(Layout.Mapping.Key), Con{key, tail})))))
    case Con{_, Nil{}}: NativeIO.die(ListOf(Layout.Mapping.Key), 64, "assay: mapping-slot: expected TYPE KEY pairs")

def Cli.Mapping.output(+result: Layout.Mapping.Result(Big)) -> IO(Unit):
  match result:
    case Done{slot}: NativeIO.print(Big.show(slot))
    case Fail{error}: Cli.fail(64, String.append("assay: mapping-slot: ", Cli.Mapping.error(error)))

@unsafe
def Cli.Mapping.run(+args: ListOf(String)) -> IO(Unit):
  match args:
    case Con{base_text, Con{type_name, Con{value_text, rest}}}:
      IO.bind(Big, Unit, Cli.Mapping.word(base_text), base =>
        IO.bind(ListOf(Layout.Mapping.Key), Unit, Cli.Mapping.keys(Con{type_name, Con{value_text, rest}}), keys =>
          Cli.Mapping.output(Layout.Mapping.path(base, keys))))
    case Con{_, Con{_, Nil{}}}: Cli.Mapping.usage()
    case Con{_, Nil{}}: Cli.Mapping.usage()
    case Nil{}: Cli.Mapping.usage()
def Cli.require(-A: Data, code: U32, result: Result<&2, &2, String, A>) -> IO(A):
  match result:
    case Fail{message}: NativeIO.die(A, code, message)
    case Done{value}: IO.pure(A, value)
def Cli.kernel(-A: Data, result: Result<&2, &2, Error, A>) -> IO(A):
  match result:
    case Fail{error}: NativeIO.die(A, 1, Error.to_string(error))
    case Done{value}: IO.pure(A, value)
@unsafe
def Cli.checked_rows(+name: String, result: Result<&2, &2, Error, Tuple2<&2, &2, Global, Cli.Rows()>>) -> IO(Cli.Checked):
  match result:
    case Fail{error}: NativeIO.die(Cli.Checked, 1, Error.to_string(error))
    case Done{Tup2{globals, rows}}: IO.pure(Cli.Checked, Cli.Checked{name, globals, rows})
def Cli.lowered(basename: String, result: Result<&2, &2, Error, Tuple2<&2, &2, Maybe<&2, String>, String>>) -> IO(Cli.Checked):
  match result:
    case Fail{error}: NativeIO.die(Cli.Checked, 1, Error.to_string(error))
    case Done{Tup2{name, source}}: Cli.checked_rows(Maybe.default(&2, String, name, basename), Elab.check_in(None{}, Global.initial(), source))
@unsafe
def Cli.read_source(+path: String, exists: Bool) -> IO(Cli.Checked):
  match exists:
    case False{}: NativeIO.die(Cli.Checked, 64, String.append("assay: cannot read ", path))
    case True{}:
      Native.choose(&1, IO(Cli.Checked), Bool.or(String.ends_with(path, ".asy"), String.ends_with(path, ".kan")), _ => (do IO<Cli.Checked>:
        read : Result<&2, &2, String, String> <- NativeIO.read(path)
        source : String <- Cli.require(String, 64, read)
        basename : String <- OS.basename(path)
        Cli.lowered(basename, Contract.lower(source))), _ => NativeIO.die(Cli.Checked, 64, String.concat(["assay: ", path, ": expected a .asy or .kan source"])))
@unsafe
def Cli.checked(+path: String) -> IO(Cli.Checked): IO.bind(Cli.Packed.Checked(), Cli.Checked, Cli.Packed.checked(path), packet => Cli.Packed.checked_value(packet))
@unsafe
def Cli.erase(checked: Cli.Checked) -> IO(Cli.Program):
  match checked:
    case Cli.Checked{contract, +globals, +rows}: do IO<Cli.Program>:
      erased : Cli.Erased() <- Cli.kernel(Cli.Erased(), Erase.program(None{}, globals, rows))
      return Cli.Program{contract, globals, rows, erased}
def Cli.program(path: String) -> IO(Cli.Program): IO.bind(Cli.Checked, Cli.Program, Cli.checked(path), checked => Cli.erase(checked))
def Cli.compiled(command: String, result: Result<&2, &2, Emit.Error, Emit.Output>) -> IO(Emit.Output):
  match result:
    case Fail{error}: NativeIO.die(Emit.Output, 2, String.concat(["assay: ", command, ": ", Emit.error(error)]))
    case Done{out}: IO.pure(Emit.Output, out)
def Cli.compile_program(command: String, export: String, program: Cli.Program) -> IO(Emit.Output):
  match program:
    case Cli.Program{contract, globals, rows, erased}: Cli.compiled(command, Emit.program(contract, export, globals, rows, erased))
def Cli.compile(command: String, path: String, export: String) -> IO(Emit.Output): IO.bind(Cli.Packed.Program(), Emit.Output, Cli.Packed.program(path), packet => Cli.Packed.compile(command, export, packet))
@unsafe
def Cli.show_rows(mode: U32, globals: Global, rows: Cli.Rows()) -> IO(Unit):
  match mode:
    case 0: IO.pure(Unit, Unit{})
    case 1: NativeIO.stdout(Elab.checked_form(rows))
    case 2: do IO<Unit>:
      erased : Cli.Erased() <- Cli.kernel(Cli.Erased(), Erase.program(None{}, globals, rows))
      NativeIO.stdout(Erase.print(erased))
    case _: NativeIO.stdout(String.concat(SeqList.map(&2, &2, String, String, +s => String.append(s, "\n"), Elab.axiom_names(rows))))
def Cli.show_checked(mode: U32, checked: Cli.Checked) -> IO(Unit):
  match checked:
    case Cli.Checked{contract, globals, rows}: Cli.show_rows(mode, globals, rows)
def Cli.check(mode: U32, path: String) -> IO(Unit): IO.bind(Cli.Checked, Unit, Cli.checked(path), checked => Cli.show_checked(mode, checked))
@unsafe
def Cli.write_file(+directory: String, name: String, contents: String) -> IO(Unit): do IO<Unit>:
  result : Result<&2, &2, String, Unit> <- NativeIO.write(String.concat([directory, "/", name]), contents)
  Cli.require(Unit, 64, result)
@unsafe
def Cli.write_output(+directory: String, output: Emit.Output) -> IO(Unit):
  match output:
    case MkEmit_Output{runtime, init, abi, layout, axioms, listing, fields}: do IO<Unit>:
      Cli.write_file(directory, "runtime.hex", String.append(runtime, "\n"))
      Cli.write_file(directory, "init.hex", String.append(init, "\n"))
      Cli.write_file(directory, "abi.json", abi)
      Cli.write_file(directory, "layout.json", layout)
      Cli.write_file(directory, "axioms.txt", axioms)
      return Unit{}
@unsafe
def Cli.emit(+path: String, +directory: String, export: String) -> IO(Unit): do IO<Unit>:
  output : Emit.Output <- Cli.compile("emit", path, export)
  created : Bool <- OS.mkdir_new(directory)
  Cli.when(created, _ => Cli.write_output(directory, output), _ => Cli.fail(64, "assay: emit: OUTPUT_PATH: use a new directory under an existing parent"))
@unsafe
def Cli.option(+name: String, fallback: String, options: Cli.Options) -> String:
  match options:
    case Cli.Options{entries, storage}: Maybe.default(&2, String, SeqList.assoc(&2, &2, String, String, +a => +b => NativeString.equal(a, b), name, entries), fallback)
@unsafe
def Cli.storage(options: Cli.Options) -> List<&2, String>:
  match options:
    case Cli.Options{entries, storage}: storage
@unsafe
def Cli.has(+name: String, entries: List<&2, Tuple2<&2, &2, String, String>>) -> Bool:
  match entries:
    case Nil{}: False{}
    case Con{Tup2{key, value}, rest}: Bool.or(NativeString.equal(name, key), Cli.has(name, rest))
@unsafe
def Cli.member(+name: String, names: List<&2, String>) -> Bool:
  match names:
    case Nil{}: False{}
    case Con{head, rest}: Bool.or(NativeString.equal(name, head), Cli.member(name, rest))
law Cli.options: for +trace: Bool for +args: List<&2, String> for +entries: List<&2, Tuple2<&2, &2, String, String>> for +storage: List<&2, String> Maybe<&2, Cli.Options>
@unsafe
def Cli.flag(+trace: Bool, +flag: String, +value: String, +rest: List<&2, String>, +entries: List<&2, Tuple2<&2, &2, String, String>>, +storage: List<&2, String>) -> Maybe<&2, Cli.Options>:
  Native.choose(&2, Maybe<&2, Cli.Options>, Bool.and(Bool.not(trace), NativeString.equal(flag, "--storage")), _ => Cli.options(trace, rest, entries, value <> storage), _ =>
    Native.choose(&2, Maybe<&2, Cli.Options>, Bool.and(Bool.and(Cli.member(flag, Native.choose(&2, List<&2, String>, trace, _ => ["--calldata", "--prestate", "--value", "--caller"], _ => ["--calldata", "--value", "--caller", "--address", "--export"])), Bool.not(Cli.has(flag, entries))), Bool.not(Bool.and(trace, String.starts_with(value, "-")))), _ => Cli.options(trace, rest, Tup2{flag, value} <> entries, storage), _ => None{}))
@unsafe
def Cli.options(trace, args, entries, storage):
  match args:
    case Nil{}: Some{Cli.Options{entries, storage}}
    case Con{flag, Con{value, rest}}: Cli.flag(trace, flag, value, rest, entries, storage)
    case Con{flag, Nil{}}: None{}
def Cli.model_result(-A: Data, code: U32, result: Result<&2, &2, Model.Error, A>) -> IO(A):
  match result:
    case Fail{error}: NativeIO.die(A, code, String.concat(["assay: run: ", Model.error(error)]))
    case Done{value}: IO.pure(A, value)
def Cli.run_program(export: String, input: Model.Input, source: Cli.Program) -> IO(Unit):
  match source:
    case Cli.Program{contract, globals, rows, erased}: do IO<Unit>:
      program : Model.Program <- Cli.model_result(Model.Program, 2, Model.prepare(export, globals, erased))
      outcome : Model.Outcome <- Cli.model_result(Model.Outcome, 2, Model.run(program, input))
      NativeIO.stdout(Model.print(outcome))
@unsafe
def Cli.run(path: String, +options: Cli.Options) -> IO(Unit): do IO<Unit>:
  input : Model.Input <- Cli.model_result(Model.Input, 64, Model.inputs_with_caller(Cli.option("--calldata", "", options), Cli.option("--value", "0", options), Cli.storage(options), Cli.option("--caller", "0", options)))
  addressed : Model.Input <- Cli.model_result(Model.Input, 64, Model.with_address(input, Cli.option("--address", "0", options)))
  source : Cli.Packed.Program() <- Cli.Packed.program(path)
  Cli.Packed.run(Cli.option("--export", "main", options), addressed, source)
def Cli.trace_value(result: Result<&2, &2, Trace.Error, String>) -> IO(String):
  match result:
    case Fail{error}: NativeIO.die(String, 64, String.concat(["assay: trace: ", Trace.error(error)]))
    case Done{value}: IO.pure(String, value)
def Cli.diff_value(result: Result<&2, &2, Differential.Error, String>) -> IO(String):
  match result:
    case Fail{error}: NativeIO.die(String, 64, String.concat(["assay: diff: ", Differential.error(error)]))
    case Done{value}: IO.pure(String, value)
def Cli.signal_index(index: Maybe<&2, Big>) -> String:
  match index:
    case None{}: "0"
    case Some{index}: Big.show(Big.neg(Big.succ(index)))
@unsafe
def Cli.signal_code(+signal: String) -> String: Cli.signal_index(SeqList.find_index(&2, String, +name => NativeString.equal(name, signal), ["SIGABRT", "SIGALRM", "SIGFPE", "SIGHUP", "SIGILL", "SIGINT", "SIGKILL", "SIGPIPE", "SIGQUIT", "SIGSEGV", "SIGTERM", "SIGUSR1", "SIGUSR2", "SIGCHLD", "SIGCONT", "SIGSTOP", "SIGTSTP", "SIGTTIN", "SIGTTOU", "SIGVTALRM", "SIGPROF", "SIGBUS", "SIGPOLL", "SIGSYS", "SIGTRAP", "SIGURG", "SIGXCPU", "SIGXFSZ"]))
@unsafe
def Cli.process_result(+diff: Bool, result: OS.Process) -> IO(Unit):
  match result:
    case OS.Process{+kind, +code, +signal, +output}:
      +command = Native.choose(&2, String, diff, _ => "diff", _ => "trace")
      +prefix = String.concat(["assay: ", command, ": ", Native.choose(&2, String, diff, _ => "DIFF_RUNNER: ", _ => "TRACE_EXECUTOR: ")])
      do IO<Unit>:
        Cli.when(Bool.or(Bool.not(diff), Bool.and(U32.is_eq(kind, 0), U32.is_eq(code, 0))), _ => NativeIO.stdout(output), _ => IO.pure(Unit, Unit{}))
        Cli.when(U32.is_eq(kind, 1), _ => Cli.fail(2, String.append(prefix, Native.choose(&2, String, diff, _ => String.append("killed by ", signal), _ => String.append("signal ", Cli.signal_code(signal))))), _ => Cli.when(U32.is_eq(code, 0), _ => Cli.when(Bool.and(Bool.not(diff), Trace.has_error(output)), _ => Cli.fail(2, "assay: trace: TRACE_EXECUTION: geth reported an EVM error"), _ => IO.pure(Unit, Unit{})), _ => Cli.fail(2, String.concat([prefix, "exit ", U32.show(code)]))))
def Cli.runtime(output: Emit.Output) -> String:
  match output:
    case MkEmit_Output{runtime, init, abi, layout, axioms, listing, fields}: runtime
@unsafe
def Cli.launch(+diff: Bool, +root: String, +runtime: String, +input: String, +prestate: String, +value: String, +caller: String, tool: Maybe<&2, String>) -> IO(Unit):
  match tool:
    case None{}: Cli.fail(2, Native.choose(&2, String, diff, _ => "assay: diff: DIFF_TOOL: python3 is not on PATH", _ => "assay: trace: TRACE_TOOL: evm is not on PATH"))
    case Some{program}:
      +helper = String.append(root, "/evm/diff.py")
      do IO<Unit>:
        result : OS.Process <- OS.run(program, Native.choose(&2, List<&2, String>, diff, _ => ["-P", helper, "--runtime", runtime, "--calldata", input, "--prestate", prestate, "--value", value, "--caller", caller], _ => ["--verbosity", "0", "run", "--prestate", prestate, "--gas", "16777216", "--sender", caller, "--receiver", "0x0000000000000000000000007265636569766572", "--code", runtime, "--input", input, "--value", value, "--json", "--dump"]))
        Cli.process_result(diff, result)
@unsafe
def Cli.execute(+diff: Bool, +root: String, runtime: String, input: String, +prestate: String, value: String, caller: String, tool: Maybe<&2, String>) -> IO(Unit): do IO<Unit>:
  exists : Bool <- OS.regular(Native.choose(&2, String, diff, _ => String.append(root, "/evm/diff.py"), _ => prestate))
  Cli.when(exists, _ => Cli.launch(diff, root, runtime, input, prestate, value, caller, tool), _ => Cli.fail(2, Native.choose(&2, String, diff, _ => "assay: diff: DIFF_HELPER: cannot read evm/diff.py", _ => String.append("assay: trace: TRACE_PRESTATE: cannot read ", prestate))))
@unsafe
def Cli.execute_root(+diff: Bool, output: Emit.Output, input: String, options: Cli.Options, value: String, caller: String, +root: String) -> IO(Unit): do IO<Unit>:
  tool : Maybe<&2, String> <- OS.executable(Native.choose(&2, String, diff, _ => "python3", _ => "evm"))
  Cli.execute(diff, root, Cli.runtime(output), input, Cli.option("--prestate", String.append(root, "/evm/fixtures/cancun.json"), options), value, caller, tool)
@unsafe
def Cli.trace_input(+diff: Bool, path: String, +options: Cli.Options, input: Maybe<&2, String>) -> IO(Unit):
  match input:
    case None{}: Cli.fail(64, String.concat(["assay: ", Native.choose(&2, String, diff, _ => "diff", _ => "trace"), ": CALLDATA_HEX: expected whole hex bytes"]))
    case Some{input}: do IO<Unit>:
      value : String <- Native.choose(&1, IO(String), diff, _ => Cli.diff_value(Differential.value(Cli.option("--value", "0", options))), _ => Cli.trace_value(Trace.value(Cli.option("--value", "0", options))))
      caller : String <- Native.choose(&1, IO(String), diff, _ => Cli.diff_value(Differential.caller(Cli.option("--caller", "0x7e5f4552091a69125d5dfcb7b8c2659029395bdf", options))), _ => Cli.trace_value(Trace.caller(Cli.option("--caller", "0x000000000000000000000000000073656e646572", options))))
      output : Emit.Output <- Cli.compile(Native.choose(&2, String, diff, _ => "diff", _ => "trace"), path, "main")
      root : String <- OS.root()
      Cli.execute_root(diff, output, input, options, value, caller, root)
def Cli.has_option(name: String, options: Cli.Options) -> Bool:
  match options:
    case Cli.Options{entries, storage}: Cli.has(name, entries)
@unsafe
def Cli.with_options(+command: String, +path: String, result: Maybe<&2, Cli.Options>) -> IO(Unit):
  match result:
    case None{}: Cli.usage()
    case Some{+options}: Cli.when(NativeString.equal(command, "run"), _ => Cli.run(path, options), _ => Cli.when(Cli.has_option("--calldata", options), _ => Cli.trace_input(NativeString.equal(command, "diff"), path, options, Trace.calldata(Cli.option("--calldata", "", options))), _ => Cli.usage()))
@unsafe
def Cli.dispatch_options(+command: String, args: List<&2, String>) -> IO(Unit):
  match args:
    case Nil{}: Cli.usage()
    case Con{+path, rest}: Cli.when(String.starts_with(path, "-"), _ => Cli.usage(), _ => Cli.with_options(command, path, Cli.options(Bool.not(NativeString.equal(command, "run")), rest, Nil{}, Nil{})))
@unsafe
def Cli.dispatch_check(args: List<&2, String>) -> IO(Unit):
  match args:
    case Con{+path, Nil{}}: Cli.when(String.starts_with(path, "-"), _ => Cli.usage(), _ => Cli.check(0, path))
    case Con{+flag, Con{+path, Nil{}}}: Cli.when(NativeString.equal(flag, "--print"), _ => Cli.check(1, path), _ => Cli.when(NativeString.equal(flag, "--erased"), _ => Cli.check(2, path), _ => Cli.usage()))
    case _: Cli.usage()
@unsafe
def Cli.dispatch_emit(args: List<&2, String>) -> IO(Unit):
  match args:
    case Con{path, Con{flag, Con{directory, Nil{}}}}: Cli.when(NativeString.equal(flag, "-o"), _ => Cli.emit(path, directory, "main"), _ => Cli.usage())
    case Con{path, Con{flag, Con{directory, Con{export_flag, Con{export, Nil{}}}}}}: Cli.when(Bool.and(NativeString.equal(flag, "-o"), NativeString.equal(export_flag, "--export")), _ => Cli.emit(path, directory, export), _ => Cli.usage())
    case _: Cli.usage()
def Cli.axioms(args: List<&2, String>) -> IO(Unit):
  match args:
    case Con{path, Nil{}}: Cli.check(3, path)
    case _: Cli.usage()
def Cli.count(args: List<&2, String>) -> IO(Unit):
  match args:
    case Nil{}: NativeIO.stdout(Spec_count.print(Unit{}))
    case _: Cli.usage()
@unsafe
def Cli.dispatch(+command: String, +args: List<&2, String>) -> IO(Unit):
  Cli.when(NativeString.equal(command, "check"), _ => Cli.dispatch_check(args), _ =>
  Cli.when(NativeString.equal(command, "axioms"), _ => Cli.axioms(args), _ =>
  Cli.when(NativeString.equal(command, "spec-count"), _ => Cli.count(args), _ =>
  Cli.when(NativeString.equal(command, "emit"), _ => Cli.dispatch_emit(args), _ =>
  Cli.when(Cli.member(command, ["trace", "diff", "run"]), _ => Cli.dispatch_options(command, args), _ =>
  Cli.when(NativeString.equal(command, "mapping-slot"), _ => Cli.Mapping.run(args), _ =>
  Cli.when(NativeString.equal(command, "mapping-layout"), _ => Cli.MappingSource.run(args), _ =>
  Cli.when(NativeString.equal(command, "event-encode"), _ => Cli.Event.run(args), _ =>
  Cli.when(NativeString.equal(command, "event-decode"), _ => Cli.EventDecode.run(args), _ =>
  Cli.when(NativeString.equal(command, "calldata-encode"), _ => Cli.Call.encode(args), _ =>
  Cli.when(NativeString.equal(command, "calldata-decode"), _ => Cli.Call.decode(args), _ =>
  Cli.when(NativeString.equal(command, "returndata-encode"), _ => Cli.Return.encode(args), _ =>
  Cli.when(NativeString.equal(command, "returndata-decode"), _ => Cli.Return.decode(args), _ =>
  Cli.when(Cli.member(command, ["deploy", "test"]), _ => Cli.fail(3, String.concat(["assay: ", command, ": PENDING (M1)"])), _ => Cli.usage()))))))))))))))
def Cli.main(args: List<&2, String>) -> IO(Unit):
  match args:
    case Nil{}: Cli.usage()
    case Con{command, rest}: Cli.dispatch(command, rest)
def Cli.arguments(args: List<&1, String>) -> List<&2, String>:
  match args:
    case Nil{}: Nil{}
    case Con{head, tail}: head <> Cli.arguments(tail)
def Entry.Cli() -> IO(Unit): IO.bind(List<&1, String>, Unit, NativeIO.args(), args => Cli.main(Cli.arguments(args)))
def Cli.Packed.Checked() -> Data: TupleOf3(Cli.Checked, Packed.Parameters(), Mapping.Runtime.Plan)
def Cli.Packed.Program() -> Data: TupleOf3(Cli.Program, Packed.Parameters(), Mapping.Runtime.Plan)
@unsafe
def Cli.Packed.lowered(+basename: String, +result: CheckResult(Packed.Source.Info())) -> IO(Cli.Packed.Checked()):
  Case.Packed.switch_42(result, basename)
@unsafe
def Cli.Packed.read(+path: String, +exists: Bool) -> IO(Cli.Packed.Checked()):
  Native.choose(&1, IO(Cli.Packed.Checked()), exists, _ => Cli.Packed.read_file(path), _ => NativeIO.die(Cli.Packed.Checked(), 64, String.append("assay: cannot read ", path)))
def Cli.Packed.checked(+path: String) -> IO(Cli.Packed.Checked()): IO.bind(Bool, Cli.Packed.Checked(), OS.regular(path), exists => Cli.Packed.read(path, exists))
def Cli.Packed.checked_value(+packet: Cli.Packed.Checked()) -> IO(Cli.Checked):
  Case.Packed.switch_40(packet)
@unsafe
def Cli.Packed.erase(+packet: Cli.Packed.Checked()) -> IO(Cli.Packed.Program()):
  Case.Packed.switch_39(packet)
def Cli.Packed.program(+path: String) -> IO(Cli.Packed.Program()): IO.bind(Cli.Packed.Checked(), Cli.Packed.Program(), Cli.Packed.checked(path), packet => Cli.Packed.erase(packet))
@unsafe
def Cli.Packed.compile(+command: String, +export: String, +packet: Cli.Packed.Program()) -> IO(Emit.Output):
  Case.Packed.switch_38(packet, command, export)
def Cli.Packed.run(+export: String, +input: Model.Input, +packet: Cli.Packed.Program()) -> IO(Unit):
  Case.Packed.switch_35(packet, export, input)
def Cli.Packed.run_program(export: String, input: Model.Input, source: Cli.Program, parameters: Packed.Parameters()) -> IO(Unit):
  match source:
    case Cli.Program{_, globals, _, erased}: do IO<Unit>:
      fields : Emit.Packed.Fields() <- Cli.model_result(Emit.Packed.Fields(), 2, Model.Packed.fields(parameters))
      program : Model.Program <- Cli.model_result(Model.Program, 2, Model.prepare(export, globals, erased))
      outcome : Model.Outcome <- Cli.model_result(Model.Outcome, 2, Model.Packed.run(fields, program, input))
      NativeIO.stdout(Model.print(outcome))
@unsafe
def Case.Packed.switch_34(+packed_switch_34: Packed.Parameters(), +export: String, +input: Model.Input, +program: Cli.Program) -> IO(Unit):
  match packed_switch_34:
    case Nil{}: Cli.run_program(export, input, program)
    case Con{_, _}: Cli.Packed.run_program(export, input, program, packed_switch_34)
@unsafe
def Case.Packed.switch_35(+packed_switch_35: Cli.Packed.Program(), +export: String, +input: Model.Input) -> IO(Unit):
  match packed_switch_35:
    case Tup3{program, parameters, plan}:
      match plan:
        case Mapping.Runtime.Plan.Plain{}: Case.Packed.switch_34(parameters, export, input, program)
        case Mapping.Runtime.Plan.Mapped{_, cells}: Cli.MappingRuntime.run(export, input, program, cells)
@unsafe
def Case.Packed.switch_36(+packed_switch_36: Cli.Program, +command: String, +export: String, +parameters: Packed.Parameters()) -> IO(Emit.Output):
  match packed_switch_36:
    case Cli.Program{contract, globals, rows, erased}: Cli.compiled(command, Emit.Packed.program(contract, export, globals, rows, erased, parameters))
@unsafe
def Case.Packed.switch_37(+packed_switch_37: Packed.Parameters(), +command: String, +export: String, +parameters: Packed.Parameters(), +program: Cli.Program) -> IO(Emit.Output):
  match packed_switch_37:
    case Nil{}: Cli.compile_program(command, export, program)
    case Con{_, _}:
      Case.Packed.switch_36(program, command, export, parameters)
@unsafe
def Case.Packed.switch_38(+packed_switch_38: Cli.Packed.Program(), +command: String, +export: String) -> IO(Emit.Output):
  match packed_switch_38:
    case Tup3{program, parameters, plan}:
      match plan:
        case Mapping.Runtime.Plan.Plain{}: Case.Packed.switch_37(parameters, command, export, parameters, program)
        case Mapping.Runtime.Plan.Mapped{schema, cells}: Cli.MappingRuntime.compile(command, export, program, schema, cells)
@unsafe
def Case.Packed.switch_39(+packed_switch_39: Cli.Packed.Checked()) -> IO(Cli.Packed.Program()):
  match packed_switch_39:
    case Tup3{checked, parameters, plan}: do IO<Cli.Packed.Program()>:
      program : Cli.Program <- Cli.erase(checked)
      return Tup3{program, parameters, plan}
@unsafe
def Case.Packed.switch_40(+packed_switch_40: Cli.Packed.Checked()) -> IO(Cli.Checked):
  match packed_switch_40:
    case Tup3{checked, _, _}: IO.pure(Cli.Checked, checked)
@unsafe
def Cli.Packed.read_file(+path: String) -> IO(Cli.Packed.Checked()):
  Native.choose(&1, IO(Cli.Packed.Checked()), Bool.or(String.ends_with(path, ".asy"), String.ends_with(path, ".kan")), _ => (do IO<Cli.Packed.Checked()>:
    read : Result<&2, &2, String, String> <- NativeIO.read(path)
    source : String <- Cli.require(String, 64, read)
    basename : String <- OS.basename(path)
    Cli.MappingRuntime.lowered(basename, Mapping.Runtime.lower(source))), _ => NativeIO.die(Cli.Packed.Checked(), 64, String.concat(["assay: ", path, ": expected a .asy or .kan source"])))
@unsafe
def Case.Packed.switch_42(+packed_switch_42: CheckResult(Packed.Source.Info()), +basename: String) -> IO(Cli.Packed.Checked()):
  match packed_switch_42:
    case Fail{error}: NativeIO.die(Cli.Packed.Checked(), 1, Error.to_string(error))
    case Done{Tup3{name, core, parameters}}: do IO<Cli.Packed.Checked()>:
      checked : Cli.Checked <- Cli.lowered(basename, Done{Tup2{name, core}})
      return Tup3{checked, parameters, Mapping.Runtime.Plan.Plain{}}

@unsafe
def Cli.MappingRuntime.lowered(basename: String, result: CheckResult(Mapping.Runtime.Packet())) -> IO(Cli.Packed.Checked()):
  match result:
    case Fail{error}: NativeIO.die(Cli.Packed.Checked(), 1, Error.to_string(error))
    case Done{Tup2{Tup3{name, core, parameters}, plan}}: do IO<Cli.Packed.Checked()>:
      checked : Cli.Checked <- Cli.lowered(basename, Done{Tup2{name, core}})
      return Tup3{checked, parameters, plan}
@unsafe
def Cli.MappingRuntime.compile(command: String, export: String, source: Cli.Program, schema: Mapping.Source.Schema, cells: Mapping.Runtime.Cells()) -> IO(Emit.Output):
  match source:
    case Cli.Program{contract, globals, rows, erased}: Cli.compiled(command, Emit.Mapping.program(contract, export, globals, rows, erased, schema, cells))
@unsafe
def Cli.MappingRuntime.run(export: String, input: Model.Input, source: Cli.Program, +cells: Mapping.Runtime.Cells()) -> IO(Unit):
  match source:
    case Cli.Program{_, globals, _, erased}: do IO<Unit>:
      program : Model.Program <- Cli.model_result(Model.Program, 2, Model.Mapping.prepare(export, globals, erased, cells))
      outcome : Model.Outcome <- Cli.model_result(Model.Outcome, 2, Model.Mapping.run(cells, program, input))
      NativeIO.stdout(Model.print(outcome))

@unsafe
def Cli.MappingSource.output(+result: Layout.Packed.Result(String)) -> IO(Unit):
  match result:
    case Done{json}: NativeIO.stdout(String.append(json, "\n"))
    case Fail{_}: Cli.fail(1, "assay: mapping-layout: invalid storage layout (duplicate field or unsupported type)")
@unsafe
def Cli.MappingSource.read(+path: String, +exists: Bool) -> IO(Unit):
  Native.choose(&1, IO(Unit), exists, _ => (do IO<Unit>:
    read : Result<&2, &2, String, String> <- NativeIO.read(path)
    source : String <- Cli.require(String, 64, read)
    schema : Mapping.Source.Schema <- Cli.kernel(Mapping.Source.Schema, Mapping.Source.parse(source))
    Cli.MappingSource.output(Mapping.Source.print(schema))), _ => Cli.fail(64, String.append("assay: cannot read ", path)))
@unsafe
def Cli.MappingSource.run(+args: ListOf(String)) -> IO(Unit):
  match args:
    case Con{+path, Nil{}}: IO.bind(Bool, Unit, OS.regular(path), exists => Cli.MappingSource.read(path, exists))
    case _: Cli.fail(64, "usage: assay mapping-layout FILE")
