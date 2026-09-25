# Native Bend source, compiled by dev/build.py.
type Abi.Mutability is Data:
  Abi.Mutability.View{}
  Abi.Mutability.Nonpayable{}
  Abi.Mutability.Payable{}
type Abi.Entry is Data:
  MkAbi_Entry{name: String, inputs: List<&2, String>, mutability: Abi.Mutability}
type Abi.Custom_error is Data:
  MkAbi_Custom_error{error_name: String, arguments: List<&2, String>}
type Abi.Schema.Value_type is Data:
  Abi.Schema.Value_type.Uint8{}
  Abi.Schema.Value_type.Uint256{}
  Abi.Schema.Value_type.Address{}
  Abi.Schema.Value_type.Bool{}
  Abi.Schema.Value_type.String{}
type Abi.Schema.Parameter is Data:
  MkAbi_Schema_Parameter{name: String, typ: Abi.Schema.Value_type}
type Abi.Schema.Function_ is Data:
  MkAbi_Schema_Function_{name: String, inputs: List<&2, Abi.Schema.Parameter>, outputs: List<&2, Abi.Schema.Parameter>, mutability: Abi.Mutability}
type Abi.Schema.Event_parameter is Data:
  MkAbi_Schema_Event_parameter{parameter: Abi.Schema.Parameter, indexed: Bool}
type Abi.Schema.Declaration is Data:
  Abi.Schema.Declaration.Constructor{a0: List<&2, Abi.Schema.Parameter>, a1: Bool}
  Abi.Schema.Declaration.Function{a0: Abi.Schema.Function_}
  Abi.Schema.Declaration.Error{a0: String, a1: List<&2, Abi.Schema.Parameter>}
  Abi.Schema.Declaration.Event{a0: String, a1: List<&2, Abi.Schema.Event_parameter>, a2: Bool}
  Abi.Schema.Declaration.Fallback{a0: Bool}
type Abi.Codec.Value is Data:
  Abi.Codec.Value.Uint8{a0: Big}
  Abi.Codec.Value.Uint256{a0: Big}
  Abi.Codec.Value.Address{a0: Big}
  Abi.Codec.Value.Bool{a0: Bool}
  Abi.Codec.Value.String{a0: String}
type Abi.Codec.Error is Data:
  Abi.Codec.Error.Out_of_range{a0: Abi.Schema.Value_type}
  Abi.Codec.Error.Too_large{}
  Abi.Codec.Error.Truncated{}
  Abi.Codec.Error.Invalid_bool{}
  Abi.Codec.Error.Invalid_offset{}
  Abi.Codec.Error.Nonzero_padding{}
  Abi.Codec.Error.Trailing_data{}
def Abi.Codec.Result(-A: Data) -> Data: Result<&2, &2, Abi.Codec.Error, A>
def Abi.Codec.Result.pure(-A: Data, value: A) -> Abi.Codec.Result(A): Done{value}
def Abi.Codec.Result.bind(-A: Data, -B: Data, value: Abi.Codec.Result(A), next: A -> Abi.Codec.Result(B)) -> Abi.Codec.Result(B):
  match value:
    case Done{x}: next(x)
    case Fail{error}: Fail{error}
@unsafe
def Get.Abi.Custom_error.error_name(value: Abi.Custom_error) -> String:
  match value:
    case MkAbi_Custom_error{field0, _}: field0
@unsafe
def Get.Abi.Custom_error.arguments(value: Abi.Custom_error) -> ListOf(String):
  match value:
    case MkAbi_Custom_error{_, field1}: field1
@unsafe
def Get.Abi.Schema.Parameter.typ(value: Abi.Schema.Parameter) -> Abi.Schema.Value_type:
  match value:
    case MkAbi_Schema_Parameter{_, field1}: field1
@unsafe
def Match.Abi_Schema_Value_type(r, -R: Kind(r), value: Abi.Schema.Value_type, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R), on3: (Unit -> R), on4: (Unit -> R)) -> R:
  match value:
    case Abi.Schema.Value_type.Uint8{}: on0(Unit{})
    case Abi.Schema.Value_type.Uint256{}: on1(Unit{})
    case Abi.Schema.Value_type.Address{}: on2(Unit{})
    case Abi.Schema.Value_type.Bool{}: on3(Unit{})
    case Abi.Schema.Value_type.String{}: on4(Unit{})
@unsafe
def Get.Abi.Entry.name(value: Abi.Entry) -> String:
  match value:
    case MkAbi_Entry{field0, _, _}: field0
@unsafe
def Get.Abi.Entry.inputs(value: Abi.Entry) -> ListOf(String):
  match value:
    case MkAbi_Entry{_, field1, _}: field1
@unsafe
def Get.Abi.Entry.mutability(value: Abi.Entry) -> Abi.Mutability:
  match value:
    case MkAbi_Entry{_, _, field2}: field2
@unsafe
def Match.Abi_Mutability(r, -R: Kind(r), value: Abi.Mutability, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R)) -> R:
  match value:
    case Abi.Mutability.View{}: on0(Unit{})
    case Abi.Mutability.Nonpayable{}: on1(Unit{})
    case Abi.Mutability.Payable{}: on2(Unit{})
@unsafe
def Match.Abi_Schema_Declaration(r, -R: Kind(r), value: Abi.Schema.Declaration, on0: (@+a0:ListOf(Abi.Schema.Parameter) -> @+a1:Bool -> R), on1: (@+a0:Abi.Schema.Function_ -> R), on2: (@+a0:String -> @+a1:ListOf(Abi.Schema.Parameter) -> R), on3: (@+a0:String -> @+a1:ListOf(Abi.Schema.Event_parameter) -> @+a2:Bool -> R), on4: (@+a0:Bool -> R)) -> R:
  match value:
    case Abi.Schema.Declaration.Constructor{a0, a1}: on0(a0, a1)
    case Abi.Schema.Declaration.Function{a0}: on1(a0)
    case Abi.Schema.Declaration.Error{a0, a1}: on2(a0, a1)
    case Abi.Schema.Declaration.Event{a0, a1, a2}: on3(a0, a1, a2)
    case Abi.Schema.Declaration.Fallback{a0}: on4(a0)
@unsafe
def Get.Abi.Schema.Parameter.name(value: Abi.Schema.Parameter) -> String:
  match value:
    case MkAbi_Schema_Parameter{field0, _}: field0
@unsafe
def Get.Abi.Schema.Function_.name(value: Abi.Schema.Function_) -> String:
  match value:
    case MkAbi_Schema_Function_{field0, _, _, _}: field0
@unsafe
def Get.Abi.Schema.Function_.inputs(value: Abi.Schema.Function_) -> ListOf(Abi.Schema.Parameter):
  match value:
    case MkAbi_Schema_Function_{_, field1, _, _}: field1
@unsafe
def Get.Abi.Schema.Function_.outputs(value: Abi.Schema.Function_) -> ListOf(Abi.Schema.Parameter):
  match value:
    case MkAbi_Schema_Function_{_, _, field2, _}: field2
@unsafe
def Get.Abi.Schema.Function_.mutability(value: Abi.Schema.Function_) -> Abi.Mutability:
  match value:
    case MkAbi_Schema_Function_{_, _, _, field3}: field3
@unsafe
def Get.Abi.Schema.Event_parameter.parameter(value: Abi.Schema.Event_parameter) -> Abi.Schema.Parameter:
  match value:
    case MkAbi_Schema_Event_parameter{field0, _}: field0
@unsafe
def Get.Abi.Schema.Event_parameter.indexed(value: Abi.Schema.Event_parameter) -> Bool:
  match value:
    case MkAbi_Schema_Event_parameter{_, field1}: field1
@unsafe
def Match.Abi_Codec_Value(r, -R: Kind(r), value: Abi.Codec.Value, on0: (@+a0:Big -> R), on1: (@+a0:Big -> R), on2: (@+a0:Big -> R), on3: (@+a0:Bool -> R), on4: (@+a0:String -> R)) -> R:
  match value:
    case Abi.Codec.Value.Uint8{a0}: on0(a0)
    case Abi.Codec.Value.Uint256{a0}: on1(a0)
    case Abi.Codec.Value.Address{a0}: on2(a0)
    case Abi.Codec.Value.Bool{a0}: on3(a0)
    case Abi.Codec.Value.String{a0}: on4(a0)
law Local.Abi.build.f10144: for +offset_950: Big for +heads_951: ListOf(String) for +tails_952: ListOf(String) for +param_968: ListOf(Abi.Codec.Value) Abi.Codec.Result(String)
law Local.Abi.read.f10170: for +size_973: Big for +data_972: String for +head_976: Big for +tail_977: Big for +values_978: ListOf(Abi.Codec.Value) for +param_992: ListOf(Abi.Schema.Value_type) Abi.Codec.Result(ListOf(Abi.Codec.Value))
@unsafe
def Abi.quote(+text_274: String) -> String:
  (+scrut8642 = {(+local8640 => ((+scrut8641 = {Unit{} : Unit}
  Native.choose(&2, String, NativeChar.equal(local8640, Char.from_u32(34)), _ => ("\u{5c}\u{22}"), _ => (Native.choose(&2, String, NativeChar.equal(local8640, Char.from_u32(92)), _ => ("\u{5c}\u{5c}"), _ => (Native.choose(&2, String, Big.is_lt(Big.of_nat(U32.to_nat(Char.to_u32(local8640))), Big.of_nat(32n)), _ => (String.concat(["\u{5c}u", NativeString.pad(4n, Char.from_u32(48), Big.hex(Big.of_nat(U32.to_nat(Char.to_u32(local8640))), False{}))])), _ => (NativeString.repeat(Big.to_nat(Big.one()), local8640)))))))))) : Reusable(Char, String)}
  String.append("\u{22}", String.append(String.join(SeqList.map(&2, &2, Char, String, scrut8642, Series.to_list(&2, Char, Series.from_string(text_274))), ""), "\u{22}")))
@unsafe
def Abi.empty() -> String:
  "[]\u{a}"
@unsafe
def Abi.word(+name_1012: String) -> Abi.Schema.Parameter:
  MkAbi_Schema_Parameter{name_1012, Abi.Schema.Value_type.Uint256{}}
@unsafe
def Abi.Schema.type_name(+param_622: Abi.Schema.Value_type) -> String:
  (+scrut8788 = param_622
  Match.Abi_Schema_Value_type(&2, String, scrut8788, _ => ("uint8"), _ => ("uint256"), _ => ("address"), _ => ("bool"), _ => ("string")))
@unsafe
def Abi.Schema.signature(+name_625: String, +parameters_626: ListOf(Abi.Schema.Parameter)) -> String:
  String.append(name_625, String.append("(", String.append(String.join(SeqList.map(&2, &2, Abi.Schema.Parameter, String, (+local8787 => (Abi.Schema.type_name(Get.Abi.Schema.Parameter.typ(local8787)))), parameters_626), ","), ")")))
@unsafe
def Abi.error_signature(+row_1021: Abi.Custom_error) -> String:
  Abi.Schema.signature(Get.Abi.Custom_error.error_name(row_1021), SeqList.map(&2, &2, String, Abi.Schema.Parameter, Abi.word, Get.Abi.Custom_error.arguments(row_1021)))
@unsafe
def Abi.signature(+entry_1018: Abi.Entry) -> String:
  Abi.Schema.signature(Get.Abi.Entry.name(entry_1018), SeqList.map(&2, &2, String, Abi.Schema.Parameter, Abi.word, Get.Abi.Entry.inputs(entry_1018)))
@unsafe
def Abi.accepts_value(+entry_1015: Abi.Entry) -> Bool:
  (+scrut9488 = {Get.Abi.Entry.mutability(entry_1015) : Abi.Mutability}
  Match.Abi_Mutability(&2, Bool, scrut9488, _ => (False{}), _ => (False{}), _ => (True{})))
@unsafe
def Abi.Schema.parameter_fields(+p_638: Abi.Schema.Parameter) -> String:
  String.append("\u{22}name\u{22}:", String.append(Abi.quote(Get.Abi.Schema.Parameter.name(p_638)), String.append(",\u{22}type\u{22}:", Abi.quote(Abi.Schema.type_name(Get.Abi.Schema.Parameter.typ(p_638))))))
@unsafe
def Abi.Schema.parameter(+p_641: Abi.Schema.Parameter) -> String:
  String.append("{", String.append(Abi.Schema.parameter_fields(p_641), "}"))
@unsafe
def Abi.Schema.parameters(+ps_644: ListOf(Abi.Schema.Parameter)) -> String:
  String.append("[", String.append(String.join(SeqList.map(&2, &2, Abi.Schema.Parameter, String, Abi.Schema.parameter, ps_644), ","), "]"))
@unsafe
def Abi.Schema.value_mutability(+payable_647: Bool) -> Abi.Mutability:
  Native.choose(&2, Abi.Mutability, payable_647, _ => (Abi.Mutability.Payable{}), _ => (Abi.Mutability.Nonpayable{}))
@unsafe
def Abi.mutability_name(+param_596: Abi.Mutability) -> String:
  (+scrut10090 = param_596
  Match.Abi_Mutability(&2, String, scrut10090, _ => ("view"), _ => ("nonpayable"), _ => ("payable")))
@unsafe
def Abi.Schema.print(+declarations_650: ListOf(Abi.Schema.Declaration)) -> String:
  (+scrut10101 = {(+local10086 => ((+scrut10087 = local10086
  Match.Abi_Schema_Declaration(&2, String, scrut10087, +p10088 => +p10089 => (String.append("{\u{22}type\u{22}:\u{22}constructor\u{22},\u{22}inputs\u{22}:", String.append(Abi.Schema.parameters(p10088), String.append(",\u{22}stateMutability\u{22}:", String.append(Abi.quote(Abi.mutability_name(Abi.Schema.value_mutability(p10089))), "}"))))), +p10091 => (String.append("{\u{22}type\u{22}:\u{22}function\u{22},\u{22}name\u{22}:", String.append(Abi.quote(Get.Abi.Schema.Function_.name(p10091)), String.append(",\u{22}inputs\u{22}:", String.append(Abi.Schema.parameters(Get.Abi.Schema.Function_.inputs(p10091)), String.append(",\u{22}outputs\u{22}:", String.append(Abi.Schema.parameters(Get.Abi.Schema.Function_.outputs(p10091)), String.append(",\u{22}stateMutability\u{22}:", String.append(Abi.quote(Abi.mutability_name(Get.Abi.Schema.Function_.mutability(p10091))), "}"))))))))), +p10092 => +p10093 => (String.append("{\u{22}type\u{22}:\u{22}error\u{22},\u{22}name\u{22}:", String.append(Abi.quote(p10092), String.append(",\u{22}inputs\u{22}:", String.append(Abi.Schema.parameters(p10093), "}"))))), +p10094 => +p10095 => +p10096 => ((+scrut10099 = {(+local10098 => (String.append("{", String.append(Abi.Schema.parameter_fields(Get.Abi.Schema.Event_parameter.parameter(local10098)), String.append(",\u{22}indexed\u{22}:", String.append(NativeBool.show(Get.Abi.Schema.Event_parameter.indexed(local10098)), "}")))))) : Reusable(Abi.Schema.Event_parameter, String)}
  String.append("{\u{22}type\u{22}:\u{22}event\u{22},\u{22}name\u{22}:", String.append(Abi.quote(p10094), String.append(",\u{22}anonymous\u{22}:", String.append(NativeBool.show(p10096), String.append(",\u{22}inputs\u{22}:[", String.append(String.join(SeqList.map(&2, &2, Abi.Schema.Event_parameter, String, scrut10099, p10095), ","), "]}")))))))), +p10100 => (String.append("{\u{22}type\u{22}:\u{22}fallback\u{22},\u{22}stateMutability\u{22}:", String.append(Abi.quote(Abi.mutability_name(Abi.Schema.value_mutability(p10100))), "}"))))))) : Reusable(Abi.Schema.Declaration, String)}
  String.append("[", String.append(String.join(SeqList.map(&2, &2, Abi.Schema.Declaration, String, scrut10101, declarations_650), ","), "]\u{a}")))
@unsafe
def Abi.print(+_opt__1035: OptionOf(ListOf(Abi.Custom_error)), +_opt__1034: OptionOf(Bool), +entries_1026: ListOf(Abi.Entry)) -> String:
  (+scrut10074 = {(+scrut10072 = _opt__1035
  Match.Maybe(&2, ListOf(Abi.Custom_error), &2, ListOf(Abi.Custom_error), scrut10072, _ => (Nil{}), +p10073 => (p10073))) : ListOf(Abi.Custom_error)}
  (+scrut10077 = {(+scrut10075 = _opt__1034
  Match.Maybe(&2, Bool, &2, Bool, scrut10075, _ => (False{}), +p10076 => (p10076))) : Bool}
  ((+scrut10080 = {(+local10079 => (Abi.Schema.Declaration.Function{MkAbi_Schema_Function_{Get.Abi.Entry.name(local10079), SeqList.map(&2, &2, String, Abi.Schema.Parameter, Abi.word, Get.Abi.Entry.inputs(local10079)), Con{Abi.word(""), Nil{}}, Get.Abi.Entry.mutability(local10079)}})) : Reusable(Abi.Entry, Abi.Schema.Declaration)}
(+scrut10083 = {(+local10082 => (Abi.Schema.Declaration.Error{Get.Abi.Custom_error.error_name(local10082), SeqList.map(&2, &2, String, Abi.Schema.Parameter, Abi.word, Get.Abi.Custom_error.arguments(local10082))})) : Reusable(Abi.Custom_error, Abi.Schema.Declaration)}
(+scrut10084 = {Native.choose(&2, ListOf(Abi.Schema.Declaration), scrut10077, _ => (Con{Abi.Schema.Declaration.Fallback{False{}}, Nil{}}), _ => (Nil{})) : ListOf(Abi.Schema.Declaration)}
Abi.Schema.print(List.append(&2, Abi.Schema.Declaration, Con{Abi.Schema.Declaration.Constructor{Nil{}, False{}}, SeqList.map(&2, &2, Abi.Entry, Abi.Schema.Declaration, scrut10080, entries_1026)}, List.append(&2, Abi.Schema.Declaration, SeqList.map(&2, &2, Abi.Custom_error, Abi.Schema.Declaration, scrut10083, scrut10074), scrut10084)))))))))
@unsafe
def Abi.Schema.function_signature(+fn_630: Abi.Schema.Function_) -> String:
  Abi.Schema.signature(Get.Abi.Schema.Function_.name(fn_630), Get.Abi.Schema.Function_.inputs(fn_630))
@unsafe
def Abi.Schema.event_signature(+name_633: String, +inputs_634: ListOf(Abi.Schema.Event_parameter)) -> String:
  Abi.Schema.signature(name_633, SeqList.map(&2, &2, Abi.Schema.Event_parameter, Abi.Schema.Parameter, (+local10121 => (Get.Abi.Schema.Event_parameter.parameter(local10121))), inputs_634))
@unsafe
def Abi.Codec.let_(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2)) -> Reusable(Result<q1, q2, A1, A2>, Reusable(Reusable(A2, Result<q1, q0, A1, A0>), Result<q1, q0, A1, A0>)):
  (+local10127 => +local10129 => (Match.Result(q2, A2, q1, A1, (q0 <&> q1), Result<q1, q0, A1, A0>, local10127, +item10130 => (local10129(item10130)), +item10131 => Fail{item10131})))
@unsafe
def Abi.Codec.within(+bits_844: Big, +n_845: Big) -> Bool:
  Big.when(Bool, Big.is_le(Big.zero(), Big.sign(n_845)), _ => (Big.is_lt(Big.compare(n_845, Big.shift_left(Big.one(), Big.to_nat(bits_844))), Big.zero())), _ => (False{}))
@unsafe
def Abi.Codec.word(+n_848: Big) -> String:
  (+scrut10132 = {Big.to_bytes(n_848) : String}
  (+scrut10133 = {NativeString.of_list(Series.to_list(&2, Char, Series.of_list(&2, Char, List.reverse(&2, Char, Series.to_list(&2, Char, Series.from_string(scrut10132)))))) : String}
  String.append(NativeString.repeat(Big.to_nat(NativeInt.sub(Big.of_nat(32n), Big.of_nat(String.length(scrut10132)))), Char.from_u32(0)), scrut10133)))
@unsafe
def Abi.Codec.slice(+data_853: String, +pos_854: Big, +length_855: Big) -> Abi.Codec.Result(String):
  Native.choose(&2, Abi.Codec.Result(String), Big.when(Bool, Big.is_lt(pos_854, Big.zero()), _ => (True{}), _ => (Big.when(Bool, Big.is_lt(length_855, Big.zero()), _ => (True{}), _ => (Big.when(Bool, Big.is_lt(Big.of_nat(String.length(data_853)), pos_854), _ => (True{}), _ => (Big.is_lt(NativeInt.sub(Big.of_nat(String.length(data_853)), pos_854), length_855))))))), _ => (Fail{Abi.Codec.Error.Truncated{}}), _ => (Done{NativeString.take(Big.to_nat(length_855), NativeString.drop(Big.to_nat(pos_854), data_853))}))
@unsafe
def Abi.Codec.read_word(+data_858: String, +offset_859: Big) -> Abi.Codec.Result(Big):
  Match.Result(&2, String, &2, Abi.Codec.Error, &2, Abi.Codec.Result(Big), Abi.Codec.slice(data_858, offset_859, Big.of_nat(32n)), +item10141 => ((+local10136 => (Done{NativeString.fold(&2, Big, (+local10138 => +local10140 => (Big.add(Big.shift_left(local10138, Big.to_nat(Big.of_nat(8n))), Big.identity(Big.of_nat(U32.to_nat(Char.to_u32(local10140))))))), local10136, Big.zero())}))(item10141)), +item10142 => Fail{item10142})
@unsafe
def Abi.Codec.padding(+length_865: Big) -> Big:
  Big.logand(NativeInt.sub(Big.of_nat(32n), Big.logand(length_865, Big.of_nat(31n))), Big.of_nat(31n))
@unsafe
def Abi.Codec.scalar(+typ_868: Abi.Schema.Value_type, +bits_869: Big, +n_870: Big) -> Abi.Codec.Result(String):
  Native.choose(&2, Abi.Codec.Result(String), Abi.Codec.within(bits_869, n_870), _ => (Done{Abi.Codec.word(n_870)}), _ => (Fail{Abi.Codec.Error.Out_of_range{typ_868}}))
@unsafe
def Local.Abi.build.f10144(offset_950, heads_951, tails_952, param_968):
  (+scrut10145 = param_968
  Match.List(&2, Abi.Codec.Value, &2, Abi.Codec.Result(String), scrut10145, _ => (Done{String.join(List.append(&2, String, List.reverse(&2, String, heads_951), List.reverse(&2, String, tails_952)), "")}), +p10146 => +p10147 => (((+scrut10155 = {(+local10149 => (Match.Result(&2, String, &2, Abi.Codec.Error, &2, Abi.Codec.Result(String), local10149, +item10153 => ((+local10152 => (Local.Abi.build.f10144(offset_950, Con{local10152, heads_951}, tails_952, p10147)))(item10153)), +item10154 => Fail{item10154}))) : Reusable(Abi.Codec.Result(String), Abi.Codec.Result(String))}
(+scrut10156 = p10146
Match.Abi_Codec_Value(&2, Abi.Codec.Result(String), scrut10156, +p10157 => (scrut10155(Abi.Codec.scalar(Abi.Schema.Value_type.Uint8{}, Big.of_nat(8n), Big.identity(p10157)))), +p10158 => (scrut10155(Abi.Codec.scalar(Abi.Schema.Value_type.Uint256{}, Big.of_nat(256n), p10158))), +p10159 => (scrut10155(Abi.Codec.scalar(Abi.Schema.Value_type.Address{}, Big.of_nat(160n), p10159))), +p10160 => (scrut10155(Done{Abi.Codec.word(Native.choose(&2, Big, p10160, _ => (Big.one()), _ => (Big.zero())))})), +p10161 => ((+scrut10162 = {Big.of_nat(String.length(p10161)) : Big}
(+scrut10163 = {Abi.Codec.padding(scrut10162) : Big}
((+scrut10164 = {NativeInt.sub(Big{False{}, [True{}, True{}, True{}, False{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}]}, offset_950) : Big}
Native.choose(&2, Abi.Codec.Result(String), Big.when(Bool, Big.is_lt(scrut10164, Big.of_nat(32n)), _ => (True{}), _ => (Big.when(Bool, Big.is_lt(NativeInt.sub(scrut10164, Big.of_nat(32n)), scrut10162), _ => (True{}), _ => (Big.is_lt(NativeInt.sub(NativeInt.sub(scrut10164, Big.of_nat(32n)), scrut10162), scrut10163))))), _ => (Fail{Abi.Codec.Error.Too_large{}}), _ => ((+scrut10165 = {String.append(Abi.Codec.word(Big.identity(scrut10162)), String.append(p10161, NativeString.repeat(Big.to_nat(scrut10163), Char.from_u32(0)))) : String}
Local.Abi.build.f10144(NativeInt.add(NativeInt.add(NativeInt.add(offset_950, Big.of_nat(32n)), scrut10162), scrut10163), Con{Abi.Codec.word(Big.identity(offset_950)), heads_951}, Con{scrut10165, tails_952}, p10147))))))))))))))))
@unsafe
def Abi.Codec.encode(+values_873: ListOf(Abi.Codec.Value)) -> Abi.Codec.Result(String):
  (+scrut10143 = {Big.of_nat(List.length(&2, Abi.Codec.Value, values_873)) : Big}
  Native.choose(&2, Abi.Codec.Result(String), Big.is_lt(Big.shift_right(Big.unsigned(63n, Big{False{}, [True{}, True{}, True{}, False{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}, True{}]}), Big.to_nat(Big.unsigned(6n, Big.of_nat(5n)))), scrut10143), _ => (Fail{Abi.Codec.Error.Too_large{}}), _ => (Local.Abi.build.f10144(NativeInt.mul(scrut10143, Big.of_nat(32n)), Nil{}, Nil{}, values_873))))
@unsafe
def Local.Abi.read.f10170(size_973, data_972, head_976, tail_977, values_978, param_992):
  (+scrut10183 = param_992
  Match.List(&2, Abi.Schema.Value_type, &2, Abi.Codec.Result(ListOf(Abi.Codec.Value)), scrut10183, _ => (Native.choose(&2, Abi.Codec.Result(ListOf(Abi.Codec.Value)), Big.is_eq(tail_977, size_973), _ => (Done{List.reverse(&2, Abi.Codec.Value, values_978)}), _ => (Fail{Abi.Codec.Error.Trailing_data{}}))), +p10184 => +p10185 => ((Match.Result(&2, Big, &2, Abi.Codec.Error, &2, Abi.Codec.Result(ListOf(Abi.Codec.Value)), Abi.Codec.read_word(data_972, head_976), +item10231 => ((+local10188 => (Match.Result(&2, TupleOf2(Abi.Codec.Value, Big), &2, Abi.Codec.Error, &2, Abi.Codec.Result(ListOf(Abi.Codec.Value)), (+scrut10190 = p10184
Match.Abi_Schema_Value_type(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), scrut10190, _ => (Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Abi.Codec.within(Big.of_nat(8n), local10188), _ => (Done{Tup2{Abi.Codec.Value.Uint8{Big.identity(local10188)}, tail_977}}), _ => (Fail{Abi.Codec.Error.Out_of_range{Abi.Schema.Value_type.Uint8{}}}))), _ => (Done{Tup2{Abi.Codec.Value.Uint256{local10188}, tail_977}}), _ => (Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Abi.Codec.within(Big.of_nat(160n), local10188), _ => (Done{Tup2{Abi.Codec.Value.Address{local10188}, tail_977}}), _ => (Fail{Abi.Codec.Error.Out_of_range{Abi.Schema.Value_type.Address{}}}))), _ => (Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Big.is_eq(local10188, Big.zero()), _ => (Done{Tup2{Abi.Codec.Value.Bool{False{}}, tail_977}}), _ => (Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Big.is_eq(local10188, Big.one()), _ => (Done{Tup2{Abi.Codec.Value.Bool{True{}}, tail_977}}), _ => (Fail{Abi.Codec.Error.Invalid_bool{}}))))), _ => ((Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Bool.not(Big.is_eq(local10188, Big.identity(tail_977))), _ => (Fail{Abi.Codec.Error.Invalid_offset{}}), _ => (Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Big.is_lt(NativeInt.sub(size_973, tail_977), Big.of_nat(32n)), _ => (Fail{Abi.Codec.Error.Truncated{}}), _ => (Match.Result(&2, Big, &2, Abi.Codec.Error, &2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Abi.Codec.read_word(data_972, tail_977), +item10209 => ((+local10193 => ((+scrut10194 = {NativeInt.sub(NativeInt.sub(size_973, tail_977), Big.of_nat(32n)) : Big}
Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Big.is_lt(Big.zero(), Big.compare(local10193, Big.identity(scrut10194))), _ => (Fail{Abi.Codec.Error.Truncated{}}), _ => ((+scrut10195 = {Big.identity(local10193) : Big}
(+scrut10196 = {Abi.Codec.padding(scrut10195) : Big}
Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Big.is_lt(NativeInt.sub(scrut10194, scrut10195), scrut10196), _ => (Fail{Abi.Codec.Error.Truncated{}}), _ => ((+scrut10197 = {NativeInt.add(tail_977, Big.of_nat(32n)) : Big}
(Match.Result(&2, String, &2, Abi.Codec.Error, &2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Abi.Codec.slice(data_972, NativeInt.add(scrut10197, scrut10195), scrut10196), +item10206 => ((+local10200 => (Native.choose(&2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Bool.not(NativeString.equal(local10200, NativeString.repeat(Big.to_nat(scrut10196), Char.from_u32(0)))), _ => (Fail{Abi.Codec.Error.Nonzero_padding{}}), _ => (Match.Result(&2, String, &2, Abi.Codec.Error, &2, Abi.Codec.Result(TupleOf2(Abi.Codec.Value, Big)), Abi.Codec.slice(data_972, scrut10197, scrut10195), +item10204 => ((+local10203 => (Done{Tup2{Abi.Codec.Value.String{local10203}, NativeInt.add(NativeInt.add(scrut10197, scrut10195), scrut10196)}}))(item10204)), +item10205 => Fail{item10205})))))(item10206)), +item10207 => Fail{item10207}))))))))))))(item10209)), +item10210 => Fail{item10210}))))))))), +item10229 => ((+local10213 => ((+scrut10214 = local10213
Match.Tuple2(&2, Abi.Codec.Value, &2, Big, &2, Abi.Codec.Result(ListOf(Abi.Codec.Value)), scrut10214, +p10215 => +p10216 => ((+local10222 => +local10224 => +local10226 => +local10228 => (Local.Abi.read.f10170(size_973, data_972, local10222, local10224, local10226, local10228)))(NativeInt.add(head_976, Big.of_nat(32n)), p10216, Con{p10215, values_978}, p10185))))))(item10229)), +item10230 => Fail{item10230})))(item10231)), +item10232 => Fail{item10232})))))
@unsafe
def Abi.Codec.decode(+types_971: ListOf(Abi.Schema.Value_type), +data_972: String) -> Abi.Codec.Result(ListOf(Abi.Codec.Value)):
  (+scrut10168 = {Big.of_nat(String.length(data_972)) : Big}
  (+scrut10169 = {Big.of_nat(List.length(&2, Abi.Schema.Value_type, types_971)) : Big}
  Native.choose(&2, Abi.Codec.Result(ListOf(Abi.Codec.Value)), Big.is_lt(Big.shift_right(Big.unsigned(63n, scrut10168), Big.to_nat(Big.unsigned(6n, Big.of_nat(5n)))), scrut10169), _ => (Fail{Abi.Codec.Error.Truncated{}}), _ => ((+local10176 => +local10178 => +local10180 => +local10182 => (Local.Abi.read.f10170(scrut10168, data_972, local10176, local10178, local10180, local10182)))(Big.zero(), NativeInt.mul(scrut10169, Big.of_nat(32n)), Nil{}, types_971)))))
