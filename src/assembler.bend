# Native Bend source, compiled by dev/build.py.
type Asm.Instruction is Data:
  Asm.Instruction.Op{a0: String}
  Asm.Instruction.Push{a0: String}
  Asm.Instruction.Dup{a0: Big}
  Asm.Instruction.Swap{a0: Big}
type Asm.Halt is Data:
  Asm.Halt.Stop{}
  Asm.Halt.Return{}
  Asm.Halt.Revert{}
  Asm.Halt.Invalid{}
  Asm.Halt.Selfdestruct{}
type Asm.Ending is Data:
  Asm.Ending.Halt{a0: Asm.Halt}
  Asm.Ending.Goto{a0: Big, a1: String}
  Asm.Ending.Branch{a0: Big, a1: String, a2: String}
  Asm.Ending.Next{a0: String}
type Asm.Block is Data:
  MkAsm_Block{label: String, destination: Bool, stack_in: Big, body: List<&2, Asm.Instruction>, ending: Asm.Ending}
type Asm.Operation is Data:
  MkAsm_Operation{byte: Big, name: String, pops: Big, pushes: Big}
type Asm.Error is Data:
  Asm.Error.Empty_program{}
  Asm.Error.Empty_label{}
  Asm.Error.Duplicate_label{a0: String}
  Asm.Error.Unknown_opcode{a0: String}
  Asm.Error.Control_in_body{a0: String}
  Asm.Error.Invalid_push{a0: String}
  Asm.Error.Invalid_depth{a0: String, a1: Big}
  Asm.Error.Invalid_width{a0: Big}
  Asm.Error.Invalid_height{a0: String, a1: Big}
  Asm.Error.Entry_height{a0: Big}
  Asm.Error.Unknown_label{a0: String}
  Asm.Error.Not_destination{a0: String}
  Asm.Error.Label_overflow{a0: String, a1: Big}
  Asm.Error.Invalid_next{a0: String, a1: String}
  Asm.Error.Code_overflow{}
  Asm.Error.Underflow{a0: String, a1: String, a2: Big, a3: Big}
  Asm.Error.Overflow{a0: String, a1: String, a2: Big}
  Asm.Error.Height_mismatch{a0: String, a1: String, a2: Big, a3: Big}
type Asm.Height is Data:
  MkAsm_Height{label: String, incoming: Big, outgoing: Big, peak: Big}
type Asm is Data:
  MkAsm{bytes: String, positions: List<&2, Tuple2<&2, &2, String, Big>>, stacks: List<&2, Asm.Height>}
def Asm.Result(-A: Data) -> Data: Result<&2, &2, Asm.Error, A>
def Asm.Result.pure(-A: Data, value: A) -> Asm.Result(A): Done{value}
def Asm.Result.bind(-A: Data, -B: Data, value: Asm.Result(A), next: A -> Asm.Result(B)) -> Asm.Result(B):
  match value:
    case Done{x}: next(x)
    case Fail{error}: Fail{error}
@unsafe
def Match.Asm_Error(r, -R: Kind(r), value: Asm.Error, on0: (Unit -> R), on1: (Unit -> R), on2: (@+a0:String -> R), on3: (@+a0:String -> R), on4: (@+a0:String -> R), on5: (@+a0:String -> R), on6: (@+a0:String -> @+a1:Big -> R), on7: (@+a0:Big -> R), on8: (@+a0:String -> @+a1:Big -> R), on9: (@+a0:Big -> R), on10: (@+a0:String -> R), on11: (@+a0:String -> R), on12: (@+a0:String -> @+a1:Big -> R), on13: (@+a0:String -> @+a1:String -> R), on14: (Unit -> R), on15: (@+a0:String -> @+a1:String -> @+a2:Big -> @+a3:Big -> R), on16: (@+a0:String -> @+a1:String -> @+a2:Big -> R), on17: (@+a0:String -> @+a1:String -> @+a2:Big -> @+a3:Big -> R)) -> R:
  match value:
    case Asm.Error.Empty_program{}: on0(Unit{})
    case Asm.Error.Empty_label{}: on1(Unit{})
    case Asm.Error.Duplicate_label{a0}: on2(a0)
    case Asm.Error.Unknown_opcode{a0}: on3(a0)
    case Asm.Error.Control_in_body{a0}: on4(a0)
    case Asm.Error.Invalid_push{a0}: on5(a0)
    case Asm.Error.Invalid_depth{a0, a1}: on6(a0, a1)
    case Asm.Error.Invalid_width{a0}: on7(a0)
    case Asm.Error.Invalid_height{a0, a1}: on8(a0, a1)
    case Asm.Error.Entry_height{a0}: on9(a0)
    case Asm.Error.Unknown_label{a0}: on10(a0)
    case Asm.Error.Not_destination{a0}: on11(a0)
    case Asm.Error.Label_overflow{a0, a1}: on12(a0, a1)
    case Asm.Error.Invalid_next{a0, a1}: on13(a0, a1)
    case Asm.Error.Code_overflow{}: on14(Unit{})
    case Asm.Error.Underflow{a0, a1, a2, a3}: on15(a0, a1, a2, a3)
    case Asm.Error.Overflow{a0, a1, a2}: on16(a0, a1, a2)
    case Asm.Error.Height_mismatch{a0, a1, a2, a3}: on17(a0, a1, a2, a3)
@unsafe
def Get.Asm.Block.stack_in(value: Asm.Block) -> Big:
  match value:
    case MkAsm_Block{_, _, field2, _, _}: field2
@unsafe
def Get.Asm.Block.label(value: Asm.Block) -> String:
  match value:
    case MkAsm_Block{field0, _, _, _, _}: field0
@unsafe
def Match.Asm_Instruction(r, -R: Kind(r), value: Asm.Instruction, on0: (@+a0:String -> R), on1: (@+a0:String -> R), on2: (@+a0:Big -> R), on3: (@+a0:Big -> R)) -> R:
  match value:
    case Asm.Instruction.Op{a0}: on0(a0)
    case Asm.Instruction.Push{a0}: on1(a0)
    case Asm.Instruction.Dup{a0}: on2(a0)
    case Asm.Instruction.Swap{a0}: on3(a0)
@unsafe
def Get.Asm.Operation.name(value: Asm.Operation) -> String:
  match value:
    case MkAsm_Operation{_, field1, _, _}: field1
@unsafe
def Get.Asm.Operation.byte(value: Asm.Operation) -> Big:
  match value:
    case MkAsm_Operation{field0, _, _, _}: field0
@unsafe
def Get.Asm.Operation.pops(value: Asm.Operation) -> Big:
  match value:
    case MkAsm_Operation{_, _, field2, _}: field2
@unsafe
def Get.Asm.Operation.pushes(value: Asm.Operation) -> Big:
  match value:
    case MkAsm_Operation{_, _, _, field3}: field3
@unsafe
def Get.Asm.Block.body(value: Asm.Block) -> ListOf(Asm.Instruction):
  match value:
    case MkAsm_Block{_, _, _, field3, _}: field3
@unsafe
def Get.Asm.Block.ending(value: Asm.Block) -> Asm.Ending:
  match value:
    case MkAsm_Block{_, _, _, _, field4}: field4
@unsafe
def Match.Asm_Ending(r, -R: Kind(r), value: Asm.Ending, on0: (@+a0:Asm.Halt -> R), on1: (@+a0:Big -> @+a1:String -> R), on2: (@+a0:Big -> @+a1:String -> @+a2:String -> R), on3: (@+a0:String -> R)) -> R:
  match value:
    case Asm.Ending.Halt{a0}: on0(a0)
    case Asm.Ending.Goto{a0, a1}: on1(a0, a1)
    case Asm.Ending.Branch{a0, a1, a2}: on2(a0, a1, a2)
    case Asm.Ending.Next{a0}: on3(a0)
@unsafe
def Get.Asm.Block.destination(value: Asm.Block) -> Bool:
  match value:
    case MkAsm_Block{_, field1, _, _, _}: field1
@unsafe
def Match.Asm_Halt(r, -R: Kind(r), value: Asm.Halt, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R), on3: (Unit -> R), on4: (Unit -> R)) -> R:
  match value:
    case Asm.Halt.Stop{}: on0(Unit{})
    case Asm.Halt.Return{}: on1(Unit{})
    case Asm.Halt.Revert{}: on2(Unit{})
    case Asm.Halt.Invalid{}: on3(Unit{})
    case Asm.Halt.Selfdestruct{}: on4(Unit{})
@unsafe
def Get.Asm.bytes(value: Asm) -> String:
  match value:
    case MkAsm{field0, _, _}: field0
@unsafe
def Get.Asm.positions(value: Asm) -> ListOf(TupleOf2(String, Big)):
  match value:
    case MkAsm{_, field1, _}: field1
@unsafe
def Get.Asm.stacks(value: Asm) -> ListOf(Asm.Height):
  match value:
    case MkAsm{_, _, field2}: field2
law Local.Asm.encode.f577: for +labels_919: Assoc<&2, String, TupleOf2(Big, Asm.Block)> for +acc_922: ListOf(String) for +stacks_923: ListOf(Asm.Height) for +param_942: ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))) Asm.Result(Asm)
@unsafe
def Asm.error_text(+param_1003: Asm.Error) -> String:
  (+scrut20 = param_1003
  Match.Asm_Error(&2, String, scrut20, _ => ("EMPTY-PROGRAM"), _ => ("EMPTY-LABEL"), +p21 => (String.append("DUPLICATE-LABEL ", p21)), +p22 => (String.append("UNKNOWN-OPCODE ", p22)), +p23 => (String.append("CONTROL-IN-BODY ", p23)), +p24 => (String.append("INVALID-PUSH ", p24)), +p25 => +p26 => (String.concat(["INVALID-DEPTH ", p25, " ", Big.show(p26)])), +p27 => (String.concat(["INVALID-WIDTH ", Big.show(p27)])), +p28 => +p29 => (String.concat(["INVALID-HEIGHT ", p28, " ", Big.show(p29)])), +p30 => (String.concat(["ENTRY-HEIGHT ", Big.show(p30)])), +p31 => (String.append("UNKNOWN-LABEL ", p31)), +p32 => (String.append("NOT-DESTINATION ", p32)), +p33 => +p34 => (String.concat(["LABEL-OVERFLOW ", p33, " PUSH", Big.show(p34)])), +p35 => +p36 => (String.concat(["INVALID-NEXT ", p35, " ", p36])), _ => ("CODE-OVERFLOW"), +p37 => +p38 => +p39 => +p40 => (String.concat(["UNDERFLOW ", p37, " ", p38, " got=", Big.show(p39), " need=", Big.show(p40)])), +p41 => +p42 => +p43 => (String.concat(["OVERFLOW ", p41, " ", p42, " got=", Big.show(p43)])), +p44 => +p45 => +p46 => +p47 => (String.concat(["HEIGHT-MISMATCH ", p44, " ", p45, " got=", Big.show(p46), " want=", Big.show(p47)]))))
@unsafe
def Asm.control(+name_600: String) -> Bool:
  SeqList.exists(&2, String, +item497 => NativeString.equal(name_600, item497), Con{"STOP", Con{"JUMP", Con{"JUMPI", Con{"JUMPDEST", Con{"RETURN", Con{"REVERT", Con{"INVALID", Con{"SELFDESTRUCT", Nil{}}}}}}}}})
@unsafe
def Asm.op(+byte_521: Big, +name_522: String, +pops_523: Big, +pushes_524: Big) -> Asm.Operation:
  MkAsm_Operation{byte_521, name_522, pops_523, pushes_524}
@unsafe
def Asm.table() -> ListOf(Asm.Operation):
  Con{Asm.op(Big.zero(), "STOP", Big.zero(), Big.zero()), Con{Asm.op(Big.one(), "ADD", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(2n), "MUL", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(3n), "SUB", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(4n), "DIV", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(5n), "SDIV", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(6n), "MOD", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(7n), "SMOD", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(8n), "ADDMOD", Big.of_nat(3n), Big.one()), Con{Asm.op(Big.of_nat(9n), "MULMOD", Big.of_nat(3n), Big.one()), Con{Asm.op(Big.of_nat(10n), "EXP", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(11n), "SIGNEXTEND", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(16n), "LT", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(17n), "GT", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(18n), "SLT", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(19n), "SGT", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(20n), "EQ", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(21n), "ISZERO", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(22n), "AND", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(23n), "OR", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(24n), "XOR", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(25n), "NOT", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(26n), "BYTE", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(27n), "SHL", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(28n), "SHR", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(29n), "SAR", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(32n), "KECCAK256", Big.of_nat(2n), Big.one()), Con{Asm.op(Big.of_nat(48n), "ADDRESS", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(49n), "BALANCE", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(50n), "ORIGIN", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(51n), "CALLER", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(52n), "CALLVALUE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(53n), "CALLDATALOAD", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(54n), "CALLDATASIZE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(55n), "CALLDATACOPY", Big.of_nat(3n), Big.zero()), Con{Asm.op(Big.of_nat(56n), "CODESIZE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(57n), "CODECOPY", Big.of_nat(3n), Big.zero()), Con{Asm.op(Big.of_nat(58n), "GASPRICE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(59n), "EXTCODESIZE", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(60n), "EXTCODECOPY", Big.of_nat(4n), Big.zero()), Con{Asm.op(Big.of_nat(61n), "RETURNDATASIZE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(62n), "RETURNDATACOPY", Big.of_nat(3n), Big.zero()), Con{Asm.op(Big.of_nat(63n), "EXTCODEHASH", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(64n), "BLOCKHASH", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(65n), "COINBASE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(66n), "TIMESTAMP", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(67n), "NUMBER", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(68n), "PREVRANDAO", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(69n), "GASLIMIT", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(70n), "CHAINID", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(71n), "SELFBALANCE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(72n), "BASEFEE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(73n), "BLOBHASH", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(74n), "BLOBBASEFEE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(80n), "POP", Big.one(), Big.zero()), Con{Asm.op(Big.of_nat(81n), "MLOAD", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(82n), "MSTORE", Big.of_nat(2n), Big.zero()), Con{Asm.op(Big.of_nat(83n), "MSTORE8", Big.of_nat(2n), Big.zero()), Con{Asm.op(Big.of_nat(84n), "SLOAD", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(85n), "SSTORE", Big.of_nat(2n), Big.zero()), Con{Asm.op(Big.of_nat(86n), "JUMP", Big.one(), Big.zero()), Con{Asm.op(Big.of_nat(87n), "JUMPI", Big.of_nat(2n), Big.zero()), Con{Asm.op(Big.of_nat(88n), "PC", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(89n), "MSIZE", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(90n), "GAS", Big.zero(), Big.one()), Con{Asm.op(Big.of_nat(91n), "JUMPDEST", Big.zero(), Big.zero()), Con{Asm.op(Big.of_nat(92n), "TLOAD", Big.one(), Big.one()), Con{Asm.op(Big.of_nat(93n), "TSTORE", Big.of_nat(2n), Big.zero()), Con{Asm.op(Big.of_nat(94n), "MCOPY", Big.of_nat(3n), Big.zero()), Con{Asm.op(Big.of_nat(160n), "LOG0", Big.of_nat(2n), Big.zero()), Con{Asm.op(Big.of_nat(161n), "LOG1", Big.of_nat(3n), Big.zero()), Con{Asm.op(Big.of_nat(162n), "LOG2", Big.of_nat(4n), Big.zero()), Con{Asm.op(Big.of_nat(163n), "LOG3", Big.of_nat(5n), Big.zero()), Con{Asm.op(Big.of_nat(164n), "LOG4", Big.of_nat(6n), Big.zero()), Con{Asm.op(Big.of_nat(240n), "CREATE", Big.of_nat(3n), Big.one()), Con{Asm.op(Big.of_nat(241n), "CALL", Big.of_nat(7n), Big.one()), Con{Asm.op(Big.of_nat(242n), "CALLCODE", Big.of_nat(7n), Big.one()), Con{Asm.op(Big.of_nat(243n), "RETURN", Big.of_nat(2n), Big.zero()), Con{Asm.op(Big.of_nat(244n), "DELEGATECALL", Big.of_nat(6n), Big.one()), Con{Asm.op(Big.of_nat(245n), "CREATE2", Big.of_nat(4n), Big.one()), Con{Asm.op(Big.of_nat(250n), "STATICCALL", Big.of_nat(6n), Big.one()), Con{Asm.op(Big.of_nat(253n), "REVERT", Big.of_nat(2n), Big.zero()), Con{Asm.op(Big.of_nat(254n), "INVALID", Big.zero(), Big.zero()), Con{Asm.op(Big.of_nat(255n), "SELFDESTRUCT", Big.one(), Big.zero()), Nil{}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
@unsafe
def Asm.byte_hex(+byte_609: Big) -> String:
  String.concat([NativeString.pad(2n, Char.from_u32(48), Big.hex(byte_609, False{}))])
@unsafe
def Asm.hex_char(+c_603: Char) -> Bool:
  Big.when(Bool, Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(48)), Char.to_u32(c_603)), _ => (U32.is_le(Char.to_u32(c_603), Char.to_u32(Char.from_u32(57)))), _ => (False{})), _ => (True{}), _ => (Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(97)), Char.to_u32(c_603)), _ => (U32.is_le(Char.to_u32(c_603), Char.to_u32(Char.from_u32(102)))), _ => (False{}))))
@unsafe
def Asm.valid_hex(+s_606: String) -> Bool:
  Big.when(Bool, Big.is_eq(Big.logand(Big.of_nat(String.length(s_606)), Big.one()), Big.zero()), _ => (NativeString.all(Asm.hex_char, s_606)), _ => (False{}))
@unsafe
def Asm.instruction(+param_675: Asm.Instruction) -> Asm.Result(TupleOf2(Asm.Operation, String)):
  (+scrut495 = param_675
  Match.Asm_Instruction(&2, Asm.Result(TupleOf2(Asm.Operation, String)), scrut495, +p496 => (Native.choose(&2, Asm.Result(TupleOf2(Asm.Operation, String)), Asm.control(p496), _ => (Fail{Asm.Error.Control_in_body{p496}}), _ => (Match.Result(&2, Asm.Operation, &2, Asm.Error, &2, Asm.Result(TupleOf2(Asm.Operation, String)), (+local503 => (Match.Maybe(&2, Asm.Operation, &2, Asm.Result(Asm.Operation), local503, _ => Fail{Asm.Error.Unknown_opcode{p496}}, +x => Done{x})))(SeqList.find(&2, Asm.Operation, (+local500 => (NativeString.equal(Get.Asm.Operation.name(local500), p496))), Asm.table())), +item506 => ((+local505 => (Done{Tup2{local505, Asm.byte_hex(Get.Asm.Operation.byte(local505))}}))(item506)), +item507 => Fail{item507})))), +p508 => (Native.choose(&2, Asm.Result(TupleOf2(Asm.Operation, String)), Big.when(Bool, Big.is_lt(Big.of_nat(64n), Big.of_nat(String.length(p508))), _ => (True{}), _ => (Bool.not(Asm.valid_hex(p508)))), _ => (Fail{Asm.Error.Invalid_push{p508}}), _ => ((+scrut509 = {Big.shift_right(Big.unsigned(63n, Big.of_nat(String.length(p508))), Big.to_nat(Big.unsigned(6n, Big.one()))) : Big}
  (+scrut510 = {Asm.op(NativeInt.add(Big.of_nat(95n), scrut509), String.append("PUSH", Big.show(scrut509)), Big.zero(), Big.one()) : Asm.Operation}
  Done{Tup2{scrut510, String.append(Asm.byte_hex(Get.Asm.Operation.byte(scrut510)), p508)}}))))), +p511 => (Native.choose(&2, Asm.Result(TupleOf2(Asm.Operation, String)), Big.when(Bool, Big.is_lt(p511, Big.one()), _ => (True{}), _ => (Big.is_lt(Big.of_nat(16n), p511))), _ => (Fail{Asm.Error.Invalid_depth{"DUP", p511}}), _ => ((+scrut512 = {Asm.op(NativeInt.add(Big.of_nat(127n), p511), String.append("DUP", Big.show(p511)), p511, NativeInt.add(p511, Big.one())) : Asm.Operation}
  Done{Tup2{scrut512, Asm.byte_hex(Get.Asm.Operation.byte(scrut512))}})))), +p513 => (Native.choose(&2, Asm.Result(TupleOf2(Asm.Operation, String)), Big.when(Bool, Big.is_lt(p513, Big.one()), _ => (True{}), _ => (Big.is_lt(Big.of_nat(16n), p513))), _ => (Fail{Asm.Error.Invalid_depth{"SWAP", p513}}), _ => ((+scrut514 = {Asm.op(NativeInt.add(Big.of_nat(143n), p513), String.append("SWAP", Big.show(p513)), NativeInt.add(p513, Big.one()), NativeInt.add(p513, Big.one())) : Asm.Operation}
  Done{Tup2{scrut514, Asm.byte_hex(Get.Asm.Operation.byte(scrut514))}}))))))
@unsafe
def Asm.step(+label_696: String, +param_701: TupleOf2(Big, Big), +row_699: Asm.Operation) -> Asm.Result(TupleOf2(Big, Big)):
  (+scrut521 = param_701
  Match.Tuple2(&2, Big, &2, Big, &2, Asm.Result(TupleOf2(Big, Big)), scrut521, +p522 => +p523 => (Native.choose(&2, Asm.Result(TupleOf2(Big, Big)), Big.is_lt(p522, Get.Asm.Operation.pops(row_699)), _ => (Fail{Asm.Error.Underflow{label_696, Get.Asm.Operation.name(row_699), p522, Get.Asm.Operation.pops(row_699)}}), _ => ((+scrut524 = {NativeInt.add(NativeInt.sub(p522, Get.Asm.Operation.pops(row_699)), Get.Asm.Operation.pushes(row_699)) : Big}
  Native.choose(&2, Asm.Result(TupleOf2(Big, Big)), Big.is_lt(Big.of_nat(1024n), scrut524), _ => (Fail{Asm.Error.Overflow{label_696, Get.Asm.Operation.name(row_699), scrut524}}), _ => (Done{Tup2{scrut524, Big.maximum(p523, scrut524)}}))))))))
@unsafe
def Asm.body(+block_704: Asm.Block) -> Asm.Result(TupleOf3(TupleOf2(Big, Big), ListOf(String), Big)):
  SeqList.fold(&2, &2, Asm.Instruction, Asm.Result(TupleOf3(TupleOf2(Big, Big), ListOf(String), Big)), (+local484 => +local486 => (Match.Result(&2, TupleOf3(TupleOf2(Big, Big), ListOf(String), Big), &2, Asm.Error, &2, Asm.Result(TupleOf3(TupleOf2(Big, Big), ListOf(String), Big)), local484, +item533 => ((+local489 => ((+scrut490 = local489
  Match.Tuple3(&2, TupleOf2(Big, Big), &2, ListOf(String), &2, Big, &2, Asm.Result(TupleOf3(TupleOf2(Big, Big), ListOf(String), Big)), scrut490, +p491 => +p492 => +p493 => ((Match.Result(&2, TupleOf2(Asm.Operation, String), &2, Asm.Error, &2, Asm.Result(TupleOf3(TupleOf2(Big, Big), ListOf(String), Big)), Asm.instruction(local486), +item530 => ((+local516 => ((+scrut517 = local516
Match.Tuple2(&2, Asm.Operation, &2, String, &2, Asm.Result(TupleOf3(TupleOf2(Big, Big), ListOf(String), Big)), scrut517, +p518 => +p519 => (Match.Result(&2, TupleOf2(Big, Big), &2, Asm.Error, &2, Asm.Result(TupleOf3(TupleOf2(Big, Big), ListOf(String), Big)), Asm.step(Get.Asm.Block.label(block_704), p491, p518), +item528 => ((+local526 => ((+scrut527 = {Big.shift_right(Big.unsigned(63n, Big.of_nat(String.length(p519))), Big.to_nat(Big.unsigned(6n, Big.one()))) : Big}
Native.choose(&2, Asm.Result(TupleOf3(TupleOf2(Big, Big), ListOf(String), Big)), Big.is_lt(NativeInt.sub(Big.pred(Big.shift_left(Big.one(), 62n)), scrut527), p493), _ => (Fail{Asm.Error.Code_overflow{}}), _ => (Done{Tup3{local526, Con{p519, p492}, NativeInt.add(p493, scrut527)}})))))(item528)), +item529 => Fail{item529}))))))(item530)), +item531 => Fail{item531})))))))(item533)), +item534 => Fail{item534}))), Get.Asm.Block.body(block_704), Done{Tup3{Tup2{Get.Asm.Block.stack_in(block_704), Get.Asm.Block.stack_in(block_704)}, Nil{}, Big.zero()}})
@unsafe
def Asm.width(+n_681: Big) -> Asm.Result(Big):
  Native.choose(&2, Asm.Result(Big), Big.when(Bool, Big.is_lt(n_681, Big.one()), _ => (True{}), _ => (Big.is_lt(Big.of_nat(32n), n_681))), _ => (Fail{Asm.Error.Invalid_width{n_681}}), _ => (Done{n_681}))
@unsafe
def Asm.ending_size(+param_693: Asm.Ending) -> Asm.Result(Big):
  (+scrut542 = param_693
  Match.Asm_Ending(&2, Asm.Result(Big), scrut542, +p543 => (Done{Big.one()}), +p544 => +p545 => (Match.Result(&2, Big, &2, Asm.Error, &2, Asm.Result(Big), Asm.width(p544), +item549 => ((+local548 => (Done{NativeInt.add(local548, Big.of_nat(2n))}))(item549)), +item550 => Fail{item550})), +p551 => +p552 => +p553 => (Match.Result(&2, Big, &2, Asm.Error, &2, Asm.Result(Big), Asm.width(p551), +item557 => ((+local556 => (Done{NativeInt.mul(Big.of_nat(2n), NativeInt.add(local556, Big.of_nat(2n)))}))(item557)), +item558 => Fail{item558})), +p559 => (Done{Big.zero()})))
@unsafe
def Asm.layout(+blocks_718: ListOf(Asm.Block)) -> Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))):
  SeqList.fold(&2, &2, Asm.Block, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), (+local471 => +local473 => (Match.Result(&2, TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String)))), &2, Asm.Error, &2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), local471, +item569 => ((+local476 => ((+scrut477 = local476
  Match.Tuple3(&2, Big, &2, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, &2, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))), &2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), scrut477, +p478 => +p479 => +p480 => (((+scrut481 = {Unit{} : Unit}
Native.choose(&2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), NativeString.equal(Get.Asm.Block.label(local473), ""), _ => (Fail{Asm.Error.Empty_label{}}), _ => (Native.choose(&2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), Maybe.is_some(&2, TupleOf2(Big, Asm.Block), Assoc.find(&2, String, TupleOf2(Big, Asm.Block), (+a => +b => NativeString.order(a, b)), Get.Asm.Block.label(local473), p479)), _ => (Fail{Asm.Error.Duplicate_label{Get.Asm.Block.label(local473)}}), _ => (Native.choose(&2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), Big.when(Bool, Big.is_lt(Get.Asm.Block.stack_in(local473), Big.zero()), _ => (True{}), _ => (Big.is_lt(Big.of_nat(1024n), Get.Asm.Block.stack_in(local473)))), _ => (Fail{Asm.Error.Invalid_height{Get.Asm.Block.label(local473), Get.Asm.Block.stack_in(local473)}}), _ => (Match.Result(&2, TupleOf3(TupleOf2(Big, Big), ListOf(String), Big), &2, Asm.Error, &2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), Asm.body(local473), +item566 => ((+local536 => ((+scrut537 = local536
Match.Tuple3(&2, TupleOf2(Big, Big), &2, ListOf(String), &2, Big, &2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), scrut537, +p538 => +p539 => +p540 => ((Match.Result(&2, Big, &2, Asm.Error, &2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), Asm.ending_size(Get.Asm.Block.ending(local473)), +item563 => ((+local561 => ((+scrut562 = {NativeInt.add(local561, Native.choose(&2, Big, Get.Asm.Block.destination(local473), _ => (Big.one()), _ => (Big.zero()))) : Big}
Native.choose(&2, Asm.Result(TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))))), Big.when(Bool, Big.is_lt(NativeInt.sub(Big.pred(Big.shift_left(Big.one(), 62n)), scrut562), p540), _ => (True{}), _ => (Big.is_lt(NativeInt.sub(NativeInt.sub(Big.pred(Big.shift_left(Big.one(), 62n)), p540), scrut562), p478))), _ => (Fail{Asm.Error.Code_overflow{}}), _ => (Done{Tup3{NativeInt.add(NativeInt.add(p478, p540), scrut562), Assoc.add(&2, String, TupleOf2(Big, Asm.Block), (+a => +b => NativeString.order(a, b)), Get.Asm.Block.label(local473), Tup2{p478, local473}, p479), Con{Tup3{local473, p538, List.reverse(&2, String, p539)}, p480}}})))))(item563)), +item564 => Fail{item564})))))))(item566)), +item567 => Fail{item567}))))))))))))))(item569)), +item570 => Fail{item570}))), blocks_718, Done{Tup3{Big.zero(), Assoc.empty(&2, String, TupleOf2(Big, Asm.Block)), Nil{}}})
@unsafe
def Asm.halt(+param_678: Asm.Halt) -> Asm.Operation:
  (+scrut616 = param_678
  Match.Asm_Halt(&2, Asm.Operation, scrut616, _ => (Asm.op(Big.zero(), "STOP", Big.zero(), Big.zero())), _ => (Asm.op(Big.of_nat(243n), "RETURN", Big.of_nat(2n), Big.zero())), _ => (Asm.op(Big.of_nat(253n), "REVERT", Big.of_nat(2n), Big.zero())), _ => (Asm.op(Big.of_nat(254n), "INVALID", Big.zero(), Big.zero())), _ => (Asm.op(Big.of_nat(255n), "SELFDESTRUCT", Big.one(), Big.zero()))))
@unsafe
def Asm.target(-q0: Quant, -A0: Kind(q0), +labels_868: Assoc<q0, String, Tuple2<q0, &2, A0, Asm.Block>>, +source_869: String, +height_870: Big, +name_871: String) -> Result<&2, q0, Asm.Error, Tuple2<q0, &2, A0, Asm.Block>>:
  Match.Result(q0, Tuple2<q0, &2, A0, Asm.Block>, &2, Asm.Error, q0, Result<&2, q0, Asm.Error, Tuple2<q0, &2, A0, Asm.Block>>, (+local636 => (Match.Maybe(q0, Tuple2<q0, &2, A0, Asm.Block>, q0, Result<&2, q0, Asm.Error, Tuple2<q0, &2, A0, Asm.Block>>, local636, _ => Fail{Asm.Error.Unknown_label{name_871}}, +x => Done{x})))(Assoc.find(q0, String, Tuple2<q0, &2, A0, Asm.Block>, (+a => +b => NativeString.order(a, b)), name_871, labels_868)), +item642 => ((+local638 => ((+scrut639 = local638
  Match.Tuple2(q0, A0, &2, Asm.Block, q0, Result<&2, q0, Asm.Error, Tuple2<q0, &2, A0, Asm.Block>>, scrut639, +p640 => +p641 => (Native.choose(q0, Result<&2, q0, Asm.Error, Tuple2<q0, &2, A0, Asm.Block>>, Bool.not(Big.is_eq(height_870, Get.Asm.Block.stack_in(p641))), _ => (Fail{Asm.Error.Height_mismatch{source_869, name_871, height_870, Get.Asm.Block.stack_in(p641)}}), _ => (Done{Tup2{p640, p641}})))))))(item642)), +item643 => Fail{item643})
@unsafe
def Asm.address(+labels_877: Assoc<&2, String, TupleOf2(Big, Asm.Block)>, +source_878: String, +height_879: Big, +n_880: Big, +name_881: String) -> Asm.Result(String):
  Match.Result(&2, TupleOf2(Big, Asm.Block), &2, Asm.Error, &2, Asm.Result(String), Asm.target(&2, Big, labels_877, source_878, height_879, name_881), +item650 => ((+local645 => ((+scrut646 = local645
  Match.Tuple2(&2, Big, &2, Asm.Block, &2, Asm.Result(String), scrut646, +p647 => +p648 => (Native.choose(&2, Asm.Result(String), Bool.not(Get.Asm.Block.destination(p648)), _ => (Fail{Asm.Error.Not_destination{name_881}}), _ => ((+scrut649 = {String.concat([Big.hex(p647, False{})]) : String}
  Native.choose(&2, Asm.Result(String), Big.is_lt(NativeInt.mul(n_880, Big.of_nat(2n)), Big.of_nat(String.length(scrut649))), _ => (Fail{Asm.Error.Label_overflow{name_881, n_880}}), _ => (Done{String.append(Asm.byte_hex(NativeInt.add(Big.of_nat(95n), n_880)), String.append(NativeString.repeat(Big.to_nat(NativeInt.sub(NativeInt.mul(n_880, Big.of_nat(2n)), Big.of_nat(String.length(scrut649)))), Char.from_u32(48)), scrut649))}))))))))))(item650)), +item651 => Fail{item651})
@unsafe
def Asm.finish(+labels_888: Assoc<&2, String, TupleOf2(Big, Asm.Block)>, +block_889: Asm.Block, +state_890: TupleOf2(Big, Big), +next_891: OptionOf(String)) -> Asm.Result(TupleOf2(TupleOf2(Big, Big), String)):
  (+scrut611 = state_890
  Match.Tuple2(&2, Big, &2, Big, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), scrut611, +p612 => +p613 => (((+scrut614 = {Get.Asm.Block.ending(block_889) : Asm.Ending}
Match.Asm_Ending(&2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), scrut614, +p615 => ((+scrut617 = {Asm.halt(p615) : Asm.Operation}
Match.Result(&2, TupleOf2(Big, Big), &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.step(Get.Asm.Block.label(block_889), state_890, scrut617), +item621 => ((+local620 => (Done{Tup2{local620, Asm.byte_hex(Get.Asm.Operation.byte(scrut617))}}))(item621)), +item622 => Fail{item622}))), +p623 => +p624 => ((Match.Result(&2, TupleOf2(Big, Big), &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.step(Get.Asm.Block.label(block_889), state_890, Asm.op(NativeInt.add(Big.of_nat(95n), p623), "PUSH-label", Big.zero(), Big.one())), +item658 => ((+local627 => (Match.Result(&2, TupleOf2(Big, Big), &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.step(Get.Asm.Block.label(block_889), local627, Asm.op(Big.of_nat(86n), "JUMP", Big.one(), Big.zero())), +item656 => ((+local630 => (Match.Result(&2, String, &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.address(labels_888, Get.Asm.Block.label(block_889), p612, p623, p624), +item654 => ((+local653 => (Done{Tup2{local630, String.append(local653, "56")}}))(item654)), +item655 => Fail{item655})))(item656)), +item657 => Fail{item657})))(item658)), +item659 => Fail{item659}))), +p661 => +p662 => +p663 => ((Match.Result(&2, TupleOf2(Big, Big), &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.step(Get.Asm.Block.label(block_889), state_890, Asm.op(NativeInt.add(Big.of_nat(95n), p661), "PUSH-label", Big.zero(), Big.one())), +item685 => ((+local666 => (Match.Result(&2, TupleOf2(Big, Big), &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.step(Get.Asm.Block.label(block_889), local666, Asm.op(Big.of_nat(87n), "JUMPI", Big.of_nat(2n), Big.zero())), +item683 => ((+local669 => ((+scrut670 = local669
Match.Tuple2(&2, Big, &2, Big, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), scrut670, +p671 => +p672 => (Match.Result(&2, String, &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.address(labels_888, Get.Asm.Block.label(block_889), p671, p661, p662), +item681 => ((+local675 => (Match.Result(&2, String, &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.address(labels_888, Get.Asm.Block.label(block_889), p671, p661, p663), +item679 => ((+local678 => (Done{Tup2{local669, String.append(local675, String.append("57", String.append(local678, "56")))}}))(item679)), +item680 => Fail{item680})))(item681)), +item682 => Fail{item682}))))))(item683)), +item684 => Fail{item684})))(item685)), +item686 => Fail{item686}))), +p688 => (Native.choose(&2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Bool.not(Equal.OptionOf_String_(next_891, Some{p688})), _ => (Fail{Asm.Error.Invalid_next{Get.Asm.Block.label(block_889), p688}}), _ => (Match.Result(&2, TupleOf2(Big, Asm.Block), &2, Asm.Error, &2, Asm.Result(TupleOf2(TupleOf2(Big, Big), String)), Asm.target(&2, Big, labels_888, Get.Asm.Block.label(block_889), p612, p688), +item694 => ((+local693 => (Done{Tup2{state_890, ""}}))(item694)), +item695 => Fail{item695}))))))))))
@unsafe
def Local.Asm.encode.f577(labels_919, acc_922, stacks_923, param_942):
  (+scrut587 = param_942
  Match.List(&2, TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String)), &2, Asm.Result(Asm), scrut587, _ => (Done{MkAsm{String.join(List.reverse(&2, String, acc_922), ""), (+local590 => (SeqList.map(&2, &2, TupleOf2(String, TupleOf2(Big, Asm.Block)), TupleOf2(String, Big), (+local592 => ((+scrut593 = local592
  Match.Tuple2(&2, String, &2, TupleOf2(Big, Asm.Block), &2, TupleOf2(String, Big), scrut593, +p594 => +p595 => (Match.Tuple2(&2, Big, &2, Asm.Block, &2, TupleOf2(String, Big), p595, +p596 => +p597 => (Tup2{p594, p596}))))))), local590)))(Assoc.rows(&2, String, TupleOf2(Big, Asm.Block), labels_919)), List.reverse(&2, Asm.Height, stacks_923)}}), +p598 => +p599 => (Match.Tuple3(&2, Asm.Block, &2, TupleOf2(Big, Big), &2, ListOf(String), &2, Asm.Result(Asm), p598, +p600 => +p601 => +p602 => ((+scrut609 = {(+scrut603 = p599
  Match.List(&2, TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String)), &2, OptionOf(String), scrut603, _ => (None{}), +p604 => +p605 => (Match.Tuple3(&2, Asm.Block, &2, TupleOf2(Big, Big), &2, ListOf(String), &2, OptionOf(String), p604, +p606 => +p607 => +p608 => (Some{Get.Asm.Block.label(p606)}))))) : OptionOf(String)}
  (Match.Result(&2, TupleOf2(TupleOf2(Big, Big), String), &2, Asm.Error, &2, Asm.Result(Asm), Asm.finish(labels_919, p600, p601, scrut609), +item714 => ((+local698 => ((+scrut699 = local698
Match.Tuple2(&2, TupleOf2(Big, Big), &2, String, &2, Asm.Result(Asm), scrut699, +p700 => +p701 => (Match.Tuple2(&2, Big, &2, Big, &2, Asm.Result(Asm), p700, +p702 => +p703 => ((+scrut704 = {String.append(Native.choose(&2, String, Get.Asm.Block.destination(p600), _ => ("5b"), _ => ("")), String.append(String.join(p602, ""), p701)) : String}
(+local709 => +local711 => +local713 => (Local.Asm.encode.f577(labels_919, local709, local711, local713)))(Con{scrut704, acc_922}, Con{MkAsm_Height{Get.Asm.Block.label(p600), Get.Asm.Block.stack_in(p600), p702, p703}, stacks_923}, p599)))))))))(item714)), +item715 => Fail{item715}))))))))
@unsafe
def Asm.assemble(+blocks_915: ListOf(Asm.Block)) -> Asm.Result(Asm):
  (+scrut466 = blocks_915
  Match.List(&2, Asm.Block, &2, Asm.Result(Asm), scrut466, _ => (Fail{Asm.Error.Empty_program{}}), +p467 => +p468 => ((Native.choose(&2, Asm.Result(Asm), Bool.not(Big.is_eq(Get.Asm.Block.stack_in(p467), Big.zero())), _ => (Fail{Asm.Error.Entry_height{Get.Asm.Block.stack_in(p467)}}), _ => (Match.Result(&2, TupleOf3(Big, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String)))), &2, Asm.Error, &2, Asm.Result(Asm), Asm.layout(blocks_915), +item717 => ((+local572 => ((+scrut573 = local572
Match.Tuple3(&2, Big, &2, Assoc<&2, String, TupleOf2(Big, Asm.Block)>, &2, ListOf(TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String))), &2, Asm.Result(Asm), scrut573, +p574 => +p575 => +p576 => ((+local582 => +local584 => +local586 => (Local.Asm.encode.f577(p575, local582, local584, local586)))(Nil{}, Nil{}, List.reverse(&2, TupleOf3(Asm.Block, TupleOf2(Big, Big), ListOf(String)), p576)))))))(item717)), +item718 => Fail{item718})))))))
@unsafe
def Asm.hex(+program_967: Asm) -> String:
  Get.Asm.bytes(program_967)
@unsafe
def Asm.decode_opcode(+byte_528: Big) -> OptionOf(Asm.Operation):
  (+scrut8597 = {Unit{} : Unit}
  Native.choose(&2, OptionOf(Asm.Operation), Big.when(Bool, Big.is_le(Big.of_nat(95n), byte_528), _ => (Big.is_le(byte_528, Big.of_nat(127n))), _ => (False{})), _ => (Some{Asm.op(byte_528, String.append("PUSH", Big.show(NativeInt.sub(byte_528, Big.of_nat(95n)))), Big.zero(), Big.one())}), _ => (Native.choose(&2, OptionOf(Asm.Operation), Big.when(Bool, Big.is_le(Big.of_nat(128n), byte_528), _ => (Big.is_le(byte_528, Big.of_nat(143n))), _ => (False{})), _ => ((+scrut8598 = {NativeInt.sub(byte_528, Big.of_nat(127n)) : Big}
  Some{Asm.op(byte_528, String.append("DUP", Big.show(scrut8598)), scrut8598, NativeInt.add(scrut8598, Big.one()))})), _ => (Native.choose(&2, OptionOf(Asm.Operation), Big.when(Bool, Big.is_le(Big.of_nat(144n), byte_528), _ => (Big.is_le(byte_528, Big.of_nat(159n))), _ => (False{})), _ => ((+scrut8599 = {NativeInt.sub(byte_528, Big.of_nat(143n)) : Big}
  Some{Asm.op(byte_528, String.append("SWAP", Big.show(scrut8599)), NativeInt.add(scrut8599, Big.one()), NativeInt.add(scrut8599, Big.one()))})), _ => (SeqList.find(&2, Asm.Operation, (+local8601 => (Big.is_eq(Get.Asm.Operation.byte(local8601), byte_528))), Asm.table()))))))))
@unsafe
def Asm.assemble_compact(+blocks_946: ListOf(Asm.Block)) -> Asm.Result(Asm):
  (+scrut8706 = {SeqList.fold(&2, &2, Asm.Block, TupleOf2(Big, ListOf(Asm.Block)), (+local8677 => +local8679 => ((+scrut8680 = local8677
  Match.Tuple2(&2, Big, &2, ListOf(Asm.Block), &2, TupleOf2(Big, ListOf(Asm.Block)), scrut8680, +p8681 => +p8682 => (((+scrut8692 = {SeqList.fold(&2, &2, Asm.Instruction, Big, (+local8684 => +local8686 => ((+scrut8687 = local8686
Match.Asm_Instruction(&2, Big, scrut8687, +p8688 => (NativeInt.add(local8684, Big.one())), +p8689 => (NativeInt.add(NativeInt.add(local8684, Big.one()), Big.shift_right(Big.unsigned(63n, Big.of_nat(String.length(p8689))), Big.to_nat(Big.unsigned(6n, Big.one()))))), +p8690 => (NativeInt.add(local8684, Big.one())), +p8691 => (NativeInt.add(local8684, Big.one())))))), Get.Asm.Block.body(local8679), NativeInt.add(Native.choose(&2, Big, Get.Asm.Block.destination(local8679), _ => (Big.one()), _ => (Big.zero())), Match.Result(&2, Big, &2, Asm.Error, &2, Big, Asm.ending_size(Get.Asm.Block.ending(local8679)), +x => x, _ => (Big.of_nat(256n))))) : Big}
((+scrut8703 = {(+scrut8693 = {Get.Asm.Block.ending(local8679) : Asm.Ending}
Match.Asm_Ending(&2, Asm.Ending, scrut8693, +p8694 => (Get.Asm.Block.ending(local8679)), +p8695 => +p8696 => ((+otherwise8697 = {_ => (Get.Asm.Block.ending(local8679)) : Unit -> Asm.Ending}
Native.choose(&2, Asm.Ending, Big.is_eq(p8695, Big.of_nat(2n)), _ => (Asm.Ending.Goto{Big.one(), p8696}), _ => (otherwise8697(Unit{}))))), +p8698 => +p8699 => +p8700 => ((+otherwise8701 = {_ => (Get.Asm.Block.ending(local8679)) : Unit -> Asm.Ending}
Native.choose(&2, Asm.Ending, Big.is_eq(p8698, Big.of_nat(2n)), _ => (Asm.Ending.Branch{Big.one(), p8699, p8700}), _ => (otherwise8701(Unit{}))))), +p8702 => (Get.Asm.Block.ending(local8679)))) : Asm.Ending}
Tup2{Big.minimum(Big.of_nat(256n), NativeInt.add(p8681, scrut8692)), Con{MkAsm_Block{Get.Asm.Block.label(local8679), Get.Asm.Block.destination(local8679), Get.Asm.Block.stack_in(local8679), Get.Asm.Block.body(local8679), scrut8703}, p8682}}))))))))), blocks_946, Tup2{Big.zero(), Nil{}}) : TupleOf2(Big, ListOf(Asm.Block))}
  Match.Tuple2(&2, Big, &2, ListOf(Asm.Block), &2, Asm.Result(Asm), scrut8706, +p8707 => +p8708 => ((+scrut8712 = {(+local8710 => ((+scrut8711 = local8710
  Asm.assemble(blocks_946)))) : Reusable(Unit, Asm.Result(Asm))}
  Native.choose(&2, Asm.Result(Asm), Big.is_lt(Big.of_nat(255n), p8707), _ => (scrut8712(Unit{})), _ => ((+local8715 => (Match.Result(&2, Asm, &2, Asm.Error, &2, Asm.Result(Asm), local8715, +x => (+local8718 => (Done{local8718}))(x), +x => (+local8720 => (scrut8712(Unit{})))(x))))(Asm.assemble(List.reverse(&2, Asm.Block, p8708)))))))))
@unsafe
def Asm.let_(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2)) -> Reusable(Result<q1, q2, A1, A2>, Reusable(Reusable(A2, Result<q1, q0, A1, A0>), Result<q1, q0, A1, A0>)):
  (+local10115 => +local10117 => (Match.Result(q2, A2, q1, A1, (q0 <&> q1), Result<q1, q0, A1, A0>, local10115, +item10118 => (local10117(item10118)), +item10119 => Fail{item10119})))
@unsafe
def Asm.labels(+program_970: Asm) -> ListOf(TupleOf2(String, Big)):
  Get.Asm.positions(program_970)
@unsafe
def Asm.heights(+program_973: Asm) -> ListOf(Asm.Height):
  Get.Asm.stacks(program_973)
