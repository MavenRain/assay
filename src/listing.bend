# Native Bend source, compiled by dev/build.py.
type Listing.Row is Data:
  MkListing_Row{pc: Big, bytes: String, mnemonic: String, immediate: String}
type Listing.Error is Data:
  Listing.Error.Invalid_hex{}
  Listing.Error.Unknown_opcode{a0: Big, a1: Big}
  Listing.Error.Truncated_push{a0: Big, a1: Big, a2: Big}
@unsafe
def Get.Listing.Row.pc(value: Listing.Row) -> Big:
  match value:
    case MkListing_Row{field0, _, _, _}: field0
@unsafe
def Get.Listing.Row.mnemonic(value: Listing.Row) -> String:
  match value:
    case MkListing_Row{_, _, field2, _}: field2
@unsafe
def Get.Listing.Row.immediate(value: Listing.Row) -> String:
  match value:
    case MkListing_Row{_, _, _, field3}: field3
@unsafe
def Match.Listing_Error(r, -R: Kind(r), value: Listing.Error, on0: (Unit -> R), on1: (@+a0:Big -> @+a1:Big -> R), on2: (@+a0:Big -> @+a1:Big -> @+a2:Big -> R)) -> R:
  match value:
    case Listing.Error.Invalid_hex{}: on0(Unit{})
    case Listing.Error.Unknown_opcode{a0, a1}: on1(a0, a1)
    case Listing.Error.Truncated_push{a0, a1, a2}: on2(a0, a1, a2)
law Local.Listing.walk.f8589: for +pc_589: Big for +acc_590: ListOf(Listing.Row) for +param_634: ListOf(Char) ResultOf(Listing.Error, ListOf(Listing.Row))
@unsafe
def Listing.hex_char(+c_304: Char) -> Bool:
  Big.when(Bool, Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(48)), Char.to_u32(c_304)), _ => (U32.is_le(Char.to_u32(c_304), Char.to_u32(Char.from_u32(57)))), _ => (False{})), _ => (True{}), _ => (Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(97)), Char.to_u32(c_304)), _ => (U32.is_le(Char.to_u32(c_304), Char.to_u32(Char.from_u32(102)))), _ => (False{}))))
@unsafe
def Listing.nibble(+c_307: Char) -> Big:
  Native.choose(&2, Big, U32.is_le(Char.to_u32(c_307), Char.to_u32(Char.from_u32(57))), _ => (NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(c_307))), Big.of_nat(U32.to_nat(Char.to_u32(Char.from_u32(48)))))), _ => (NativeInt.add(NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(c_307))), Big.of_nat(U32.to_nat(Char.to_u32(Char.from_u32(97))))), Big.of_nat(10n))))
@unsafe
def Listing.take(-q0: Quant, -A0: Kind(q0), +count_320: Big, +acc_321: List<q0, A0>, +chars_322: List<q0, A0>) -> Tuple2<q0, q0, List<q0, A0>, List<q0, A0>>:
  Native.choose(q0, Tuple2<q0, q0, List<q0, A0>, List<q0, A0>>, Big.is_eq(count_320, Big.zero()), _ => (Tup2{List.reverse(q0, A0, acc_321), chars_322}), _ => ((+scrut8608 = chars_322
  Match.List(q0, A0, q0, Tuple2<q0, q0, List<q0, A0>, List<q0, A0>>, scrut8608, _ => (Tup2{List.reverse(q0, A0, acc_321), Nil{}}), +p8609 => +p8610 => (Listing.take(q0, A0, NativeInt.sub(count_320, Big.one()), Con{p8609, acc_321}, p8610))))))
@unsafe
def Listing.text(+chars_393: ListOf(Char)) -> String:
  NativeString.of_list(Series.to_list(&2, Char, Series.of_list(&2, Char, chars_393)))
@unsafe
def Local.Listing.walk.f8589(pc_589, acc_590, param_634):
  (+scrut8590 = param_634
  Match.List(&2, Char, &2, ResultOf(Listing.Error, ListOf(Listing.Row)), scrut8590, _ => (Done{List.reverse(&2, Listing.Row, acc_590)}), +p8591 => +p8592 => (Match.List(&2, Char, &2, ResultOf(Listing.Error, ListOf(Listing.Row)), p8592, _ => (Fail{Listing.Error.Invalid_hex{}}), +p8593 => +p8594 => (((+scrut8595 = {NativeInt.add(NativeInt.mul(Big.of_nat(16n), Listing.nibble(p8591)), Listing.nibble(p8593)) : Big}
Match.Result(&2, Asm.Operation, &2, Listing.Error, &2, ResultOf(Listing.Error, ListOf(Listing.Row)), (+local8604 => (Match.Maybe(&2, Asm.Operation, &2, ResultOf(Listing.Error, Asm.Operation), local8604, _ => Fail{Listing.Error.Unknown_opcode{pc_589, scrut8595}}, +x => Done{x})))(Asm.decode_opcode(scrut8595)), +item8617 => ((+local8606 => ((+scrut8607 = {Native.choose(&2, Big, Big.when(Bool, Big.is_le(Big.of_nat(96n), scrut8595), _ => (Big.is_le(scrut8595, Big.of_nat(127n))), _ => (False{})), _ => (NativeInt.sub(scrut8595, Big.of_nat(95n))), _ => (Big.zero())) : Big}
((+scrut8611 = {Listing.take(&2, Char, NativeInt.mul(Big.of_nat(2n), scrut8607), Nil{}, p8594) : TupleOf2(ListOf(Char), ListOf(Char))}
Match.Tuple2(&2, ListOf(Char), &2, ListOf(Char), &2, ResultOf(Listing.Error, ListOf(Listing.Row)), scrut8611, +p8612 => +p8613 => ((+scrut8614 = {Big.shift_right(Big.unsigned(63n, Big.of_nat(List.length(&2, Char, p8612))), Big.to_nat(Big.unsigned(6n, Big.one()))) : Big}
Native.choose(&2, ResultOf(Listing.Error, ListOf(Listing.Row)), Bool.not(Big.is_eq(scrut8614, scrut8607)), _ => (Fail{Listing.Error.Truncated_push{pc_589, scrut8607, scrut8614}}), _ => ((+scrut8615 = {MkListing_Row{pc_589, Listing.text(Con{p8591, Con{p8593, p8612}}), Get.Asm.Operation.name(local8606), Listing.text(p8612)} : Listing.Row}
Local.Listing.walk.f8589(NativeInt.add(NativeInt.add(pc_589, Big.one()), scrut8607), Con{scrut8615, acc_590}, p8613))))))))))))(item8617)), +item8618 => Fail{item8618}))))))))
@unsafe
def Listing.decode(+hex_587: String) -> ResultOf(Listing.Error, ListOf(Listing.Row)):
  Native.choose(&2, ResultOf(Listing.Error, ListOf(Listing.Row)), Big.when(Bool, Bool.not(Big.is_eq(Big.logand(Big.of_nat(String.length(hex_587)), Big.one()), Big.zero())), _ => (True{}), _ => (Bool.not(NativeString.all(Listing.hex_char, hex_587)))), _ => (Fail{Listing.Error.Invalid_hex{}}), _ => (Local.Listing.walk.f8589(Big.zero(), Nil{}, Series.to_list(&2, Char, Series.from_string(hex_587)))))
@unsafe
def Listing.render_row(+row_637: Listing.Row) -> String:
  String.concat([NativeString.pad(8n, Char.from_u32(48), Big.hex(Get.Listing.Row.pc(row_637), False{})), ": ", Get.Listing.Row.mnemonic(row_637), Native.choose(&2, String, NativeString.equal(Get.Listing.Row.immediate(row_637), ""), _ => (""), _ => (String.append(" 0x", Get.Listing.Row.immediate(row_637))))])
@unsafe
def Listing.render(+hex_676: String) -> ResultOf(Listing.Error, String):
  Match.Result(&2, ListOf(Listing.Row), &2, Listing.Error, &2, ResultOf(Listing.Error, String), Listing.decode(hex_676), +item8624 => ((+local8621 => (Done{String.join(SeqList.map(&2, &2, Listing.Row, String, (+local8623 => (String.append(Listing.render_row(local8623), "\u{a}"))), local8621), "")}))(item8624)), +item8625 => Fail{item8625})
@unsafe
def Listing.let_(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2)) -> Reusable(Result<q1, q2, A1, A2>, Reusable(Reusable(A2, Result<q1, q0, A1, A0>), Result<q1, q0, A1, A0>)):
  (+local10239 => +local10241 => (Match.Result(q2, A2, q1, A1, (q0 <&> q1), Result<q1, q0, A1, A0>, local10239, +item10242 => (local10241(item10242)), +item10243 => Fail{item10243})))
@unsafe
def Listing.error_text(+param_686: Listing.Error) -> String:
  (+scrut10244 = param_686
  Match.Listing_Error(&2, String, scrut10244, _ => ("INVALID-HEX"), +p10245 => +p10246 => (String.concat(["UNKNOWN-OPCODE pc=", Big.show(p10245), " byte=", NativeString.pad(2n, Char.from_u32(48), Big.hex(p10246, False{}))])), +p10247 => +p10248 => +p10249 => (String.concat(["TRUNCATED-PUSH pc=", Big.show(p10247), " width=", Big.show(p10248), " got=", Big.show(p10249)]))))
