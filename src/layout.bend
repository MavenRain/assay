# Native Bend source, compiled by dev/build.py.
type Layout.Mapping.Key is Data:
  Layout.Mapping.Key{typ: Abi.Schema.Value_type, value: Big}
type Layout.Mapping.Error is Data:
  Layout.Mapping.Error.Invalid_slot{}
  Layout.Mapping.Error.Unsupported_key{}
  Layout.Mapping.Error.Out_of_range{typ: Abi.Schema.Value_type}
  Layout.Mapping.Error.Empty_path{}
def Layout.Mapping.Result(-A: Data) -> Data: Result<&2, &2, Layout.Mapping.Error, A>
def Layout.Mapping.Result.bind(-A: Data, -B: Data, value: Layout.Mapping.Result(A), next: A -> Layout.Mapping.Result(B)) -> Layout.Mapping.Result(B):
  match value:
    case Done{x}: next(x)
    case Fail{error}: Fail{error}
def Layout.Mapping.key_word(key: Layout.Mapping.Key) -> Layout.Mapping.Result(String):
  match key:
    case Layout.Mapping.Key{typ, value}:
      match typ:
        case Abi.Schema.Value_type.String{}: Fail{Layout.Mapping.Error.Unsupported_key{}}
        case Abi.Schema.Value_type.Uint8{}: Layout.Mapping.checked_word(typ, value, 8n)
        case Abi.Schema.Value_type.Uint256{}: Layout.Mapping.checked_word(typ, value, 256n)
        case Abi.Schema.Value_type.Address{}: Layout.Mapping.checked_word(typ, value, 160n)
        case Abi.Schema.Value_type.Bool{}: Layout.Mapping.checked_word(typ, value, 1n)
def Layout.Mapping.checked_word(+typ: Abi.Schema.Value_type, +value: Big, bits: Nat) -> Layout.Mapping.Result(String):
  Big.when(Layout.Mapping.Result(String), Abi.Codec.within(Big.of_nat(bits), value), _ => Done{Abi.Codec.word(value)}, _ => Fail{Layout.Mapping.Error.Out_of_range{typ}})
# This fold consumes the lowercase hexadecimal output of Keccak.keccak256.
@unsafe
def Layout.Mapping.digest_value(text: String, acc: Big) -> Big:
  match text:
    case "": acc
    case SCon{char, tail}:
      +code = U32.to_nat(Char.to_u32(char))
      +digit = Big.when(Nat, Nat.is_lt(code, 58n), _ => (code - 48n: Nat), _ => (code - 87n: Nat))
      Layout.Mapping.digest_value(tail, Big.add(Big.shift_left(acc, 4n), Big.of_nat(digit)))
def Layout.Mapping.slot(+base: Big, key: Layout.Mapping.Key) -> Layout.Mapping.Result(Big):
  Big.when(Layout.Mapping.Result(Big), Abi.Codec.within(Big.of_nat(256n), base), _ =>
    Layout.Mapping.Result.bind(String, Big, Layout.Mapping.key_word(key), word =>
      Done{Layout.Mapping.digest_value(Keccak.keccak256(String.append(word, Abi.Codec.word(base))), Big.zero())}), _ => Fail{Layout.Mapping.Error.Invalid_slot{}})
@unsafe
def Layout.Mapping.walk(base: Big, keys: ListOf(Layout.Mapping.Key)) -> Layout.Mapping.Result(Big):
  match keys:
    case Nil{}: Done{base}
    case Con{key, tail}: Layout.Mapping.Result.bind(Big, Big, Layout.Mapping.slot(base, key), next => Layout.Mapping.walk(next, tail))
def Layout.Mapping.path(base: Big, keys: ListOf(Layout.Mapping.Key)) -> Layout.Mapping.Result(Big):
  match keys:
    case Nil{}: Fail{Layout.Mapping.Error.Empty_path{}}
    case Con{key, tail}: Layout.Mapping.walk(base, key <> tail)

type Layout.Packed.Field is Data:
  Layout.Packed.Field{name: String, typ: Abi.Schema.Value_type, slot: Big, offset: Nat}
type Layout.Packed.Error is Data:
  Layout.Packed.Error.Unsupported_type{}
  Layout.Packed.Error.Empty_name{}
  Layout.Packed.Error.Duplicate_name{name: String}
  Layout.Packed.Error.Invalid_location{}
  Layout.Packed.Error.Invalid_word{}
  Layout.Packed.Error.Out_of_range{typ: Abi.Schema.Value_type}
def Layout.Packed.Result(-A: Data) -> Data: Result<&2, &2, Layout.Packed.Error, A>
def Layout.Packed.Result.bind(-A: Data, -B: Data, value: Layout.Packed.Result(A), next: A -> Layout.Packed.Result(B)) -> Layout.Packed.Result(B):
  match value:
    case Done{x}: next(x)
    case Fail{error}: Fail{error}
def Layout.Packed.width(typ: Abi.Schema.Value_type) -> Nat:
  match typ:
    case Abi.Schema.Value_type.Uint8{}: 1n
    case Abi.Schema.Value_type.Uint256{}: 32n
    case Abi.Schema.Value_type.Address{}: 20n
    case Abi.Schema.Value_type.Bool{}: 1n
    case Abi.Schema.Value_type.String{}: 0n
def Layout.Packed.bits(typ: Abi.Schema.Value_type) -> Nat:
  match typ:
    case Abi.Schema.Value_type.Bool{}: 1n
    case Abi.Schema.Value_type.Uint8{}: 8n
    case Abi.Schema.Value_type.Uint256{}: 256n
    case Abi.Schema.Value_type.Address{}: 160n
    case Abi.Schema.Value_type.String{}: 0n
@unsafe
def Layout.Packed.seen(+name: String, names: ListOf(String)) -> Bool:
  match names:
    case Nil{}: False{}
    case Con{head, tail}: Big.when(Bool, NativeString.equal(name, head), _ => True{}, _ => Layout.Packed.seen(name, tail))
@unsafe
def Layout.Packed.plan_go(+fields: ListOf(Abi.Schema.Parameter), +seen: ListOf(String), +slot: Big, +offset: Nat) -> Layout.Packed.Result(ListOf(Layout.Packed.Field)):
  match fields:
    case Nil{}: Done{[]}
    case Con{MkAbi_Schema_Parameter{name, typ}, tail}:
      Big.when(Layout.Packed.Result(ListOf(Layout.Packed.Field)), NativeString.equal(name, ""), _ => Fail{Layout.Packed.Error.Empty_name{}}, _ =>
        Big.when(Layout.Packed.Result(ListOf(Layout.Packed.Field)), Layout.Packed.seen(name, seen), _ => Fail{Layout.Packed.Error.Duplicate_name{name}}, _ =>
          Big.when(Layout.Packed.Result(ListOf(Layout.Packed.Field)), Big.is_zero(Big.of_nat(Layout.Packed.width(typ))), _ => Fail{Layout.Packed.Error.Unsupported_type{}}, _ =>
            Layout.Packed.place(name, typ, tail, seen, slot, offset))))
@unsafe
def Layout.Packed.place(+name: String, +typ: Abi.Schema.Value_type, tail: ListOf(Abi.Schema.Parameter), seen: ListOf(String), +slot: Big, +offset: Nat) -> Layout.Packed.Result(ListOf(Layout.Packed.Field)):
  +width = Layout.Packed.width(typ)
  +spill = Big.is_lt(Big.of_nat(32n), Big.of_nat((offset + width: Nat)))
  +placed_slot = Big.when(Big, spill, _ => Big.add(slot, Big.one()), _ => slot)
  +placed_offset = Big.when(Nat, spill, _ => 0n, _ => offset)
  +end = (placed_offset + width: Nat)
  +full = Big.is_zero(Big.sub(Big.of_nat(end), Big.of_nat(32n)))
  +next_slot = Big.when(Big, full, _ => Big.add(placed_slot, Big.one()), _ => placed_slot)
  +next_offset = Big.when(Nat, full, _ => 0n, _ => end)
  Layout.Packed.Result.bind(ListOf(Layout.Packed.Field), ListOf(Layout.Packed.Field), Layout.Packed.plan_go(tail, name <> seen, next_slot, next_offset), +rest => Done{Layout.Packed.Field{name, typ, placed_slot, placed_offset} <> rest})
def Layout.Packed.plan(fields: ListOf(Abi.Schema.Parameter)) -> Layout.Packed.Result(ListOf(Layout.Packed.Field)):
  Layout.Packed.plan_go(fields, [], Big.zero(), 0n)
@unsafe
def Layout.Packed.validate(field: Layout.Packed.Field) -> Layout.Packed.Result(Unit):
  match field:
    case Layout.Packed.Field{_, typ, slot, offset}:
      +width = Layout.Packed.width(typ)
      +fits = Big.is_le(Big.of_nat(offset), Big.of_nat((32n - width: Nat)))
      Big.when(Layout.Packed.Result(Unit), Big.is_zero(Big.of_nat(width)), _ => Fail{Layout.Packed.Error.Unsupported_type{}}, _ =>
        Big.when(Layout.Packed.Result(Unit), Bool.and(fits, Abi.Codec.within(Big.of_nat(256n), slot)), _ => Done{Unit{}}, _ => Fail{Layout.Packed.Error.Invalid_location{}}))
def Layout.Packed.word(word: Big) -> Layout.Packed.Result(Unit):
  Big.when(Layout.Packed.Result(Unit), Abi.Codec.within(Big.of_nat(256n), word), _ => Done{Unit{}}, _ => Fail{Layout.Packed.Error.Invalid_word{}})
@unsafe
def Layout.Packed.extract(+word: Big, +width: Nat, +offset: Nat) -> Big:
  Big.logand(Big.shift_right(word, (offset * 8n: Nat)), Big.sub(Big.shift_left(Big.one(), (width * 8n: Nat)), Big.one()))
@unsafe
def Layout.Packed.read(+field: Layout.Packed.Field, +word: Big) -> Layout.Packed.Result(Big):
  Layout.Packed.Result.bind(Unit, Big, Layout.Packed.validate(field), _ =>
    Layout.Packed.Result.bind(Unit, Big, Layout.Packed.word(word), _ => Layout.Packed.read_valid(field, word)))
@unsafe
def Layout.Packed.read_valid(+field: Layout.Packed.Field, word: Big) -> Layout.Packed.Result(Big):
  match field:
    case Layout.Packed.Field{_, typ, _, offset}:
      +value = Layout.Packed.extract(word, Layout.Packed.width(typ), offset)
      Big.when(Layout.Packed.Result(Big), Abi.Codec.within(Big.of_nat(Layout.Packed.bits(typ)), value), _ => Done{value}, _ => Fail{Layout.Packed.Error.Out_of_range{typ}})
@unsafe
def Layout.Packed.write(+field: Layout.Packed.Field, +word: Big, +value: Big) -> Layout.Packed.Result(Big):
  Layout.Packed.Result.bind(Unit, Big, Layout.Packed.validate(field), _ =>
    Layout.Packed.Result.bind(Unit, Big, Layout.Packed.word(word), _ => Layout.Packed.write_valid(field, word, value)))
@unsafe
def Layout.Packed.write_valid(+field: Layout.Packed.Field, +word: Big, +value: Big) -> Layout.Packed.Result(Big):
  match field:
    case Layout.Packed.Field{_, typ, _, offset}:
      +shift = (offset * 8n: Nat)
      Big.when(Layout.Packed.Result(Big), Abi.Codec.within(Big.of_nat(Layout.Packed.bits(typ)), value), _ =>
        Done{Big.add(Big.sub(word, Big.shift_left(Layout.Packed.extract(word, Layout.Packed.width(typ), offset), shift)), Big.shift_left(value, shift))}, _ => Fail{Layout.Packed.Error.Out_of_range{typ}})
@unsafe
def Layout.Packed.field_json(+contract: String, +index: Big, field: Layout.Packed.Field) -> String:
  match field:
    case Layout.Packed.Field{name, typ, slot, offset}:
      String.concat(["{\u{22}astId\u{22}:", Big.show(index), ",\u{22}contract\u{22}:", Abi.quote(contract), ",\u{22}label\u{22}:", Abi.quote(name), ",\u{22}offset\u{22}:", Nat.show(offset), ",\u{22}slot\u{22}:", Abi.quote(Big.show(slot)), ",\u{22}type\u{22}:", Abi.quote(String.append("t_", Abi.Schema.type_name(typ))), "}"])
@unsafe
def Layout.Packed.type_rows(+fields: ListOf(Layout.Packed.Field), +seen: ListOf(String)) -> ListOf(String):
  match fields:
    case Nil{}: []
    case Con{Layout.Packed.Field{_, typ, _, _}, tail}:
      +name = Abi.Schema.type_name(typ)
      Big.when(ListOf(String), Layout.Packed.seen(name, seen), _ => Layout.Packed.type_rows(tail, seen), _ =>
        String.concat([Abi.quote(String.append("t_", name)), ":{\u{22}encoding\u{22}:\u{22}inplace\u{22},\u{22}label\u{22}:", Abi.quote(name), ",\u{22}numberOfBytes\u{22}:", Abi.quote(Nat.show(Layout.Packed.width(typ))), "}"]) <> Layout.Packed.type_rows(tail, name <> seen))
@unsafe
def Layout.Packed.print(+contract: String, fields: ListOf(Abi.Schema.Parameter)) -> Layout.Packed.Result(String):
  Layout.Packed.Result.bind(ListOf(Layout.Packed.Field), String, Layout.Packed.plan(fields), +rows =>
    Done{String.concat(["{\u{22}storage\u{22}:[", String.join(SeqList.mapi(&2, &2, Layout.Packed.Field, String, +index => +field => Layout.Packed.field_json(contract, index, field), rows), ","), "],\u{22}types\u{22}:{", String.join(Layout.Packed.type_rows(rows, []), ","), "}}"])})
@unsafe
def Layout.print(+contract_274: String, +fields_275: ListOf(String)) -> String:
  (+scrut8643 = {SeqList.mapi(&2, &2, String, String, (+local8636 => +local8638 => (String.concat(["{\u{22}astId\u{22}:", Big.show(local8636), ",\u{22}contract\u{22}:", Abi.quote(contract_274), ",\u{22}label\u{22}:", Abi.quote(local8638), ",\u{22}offset\u{22}:0,\u{22}slot\u{22}:", Abi.quote(Big.show(local8636)), ",\u{22}type\u{22}:\u{22}t_uint256\u{22}}"]))), fields_275) : ListOf(String)}
  String.append("{\u{22}storage\u{22}:[", String.append(String.join(scrut8643, ","), "],\u{22}types\u{22}:{\u{22}t_uint256\u{22}:{\u{22}encoding\u{22}:\u{22}inplace\u{22},\u{22}label\u{22}:\u{22}uint256\u{22},\u{22}numberOfBytes\u{22}:\u{22}32\u{22}}}}\u{a}")))
