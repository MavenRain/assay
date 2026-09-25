# Native Bend source, compiled by dev/build.py.
type Big is Data:
  Big{negative: Bool, bits: List<&2, Bool>}
  SmallBig{negative: Bool, magnitude: Nat}
def Big.when(-A: Type, test: Bool, yes: Unit -> A, no: Unit -> A) -> A:
  match test:
    case True{}: yes(Unit{})
    case False{}: no(Unit{})
def Big.bits.cons(bit: Bool, tail: List<&2, Bool>) -> List<&2, Bool>:
  match bit tail:
    case False{} Nil{}: Nil{}
    case b t: b <> t
def Big.bits.trim(bits: List<&2, Bool>) -> List<&2, Bool>:
  match bits:
    case Nil{}: Nil{}
    case Con{bit, tail}: Big.bits.cons(bit, Big.bits.trim(tail))
# Small magnitudes are below 2^24, so their product fits Bend's 48-bit Nat.
@unsafe
def Big.small(+negative: Bool, +value: Nat) -> Big:
  Big.when(Big, Nat.is_lt(value, 16777216n), _ => SmallBig{Bool.and(negative, Bool.not(Nat.is_eq(value, 0n))), value}, _ => Big{negative, Big.bits.of_nat(value)})
@unsafe
def Big.make(+negative: Bool, +bits: List<&2, Bool>) -> Big:
  Big.when(Big, Nat.is_lt(List.length(&2, Bool, bits), 25n), _ => Big.small(negative, Big.bits.to_nat(bits)), _ => Big{negative, bits})
def Big.zero() -> Big: SmallBig{False{}, 0n}
def Big.one() -> Big: SmallBig{False{}, 1n}
def Big.bits(value: Big) -> List<&2, Bool>:
  match value:
    case Big{_, bits}: bits
    case SmallBig{_, value}: Big.bits.of_nat(value)
def Big.negative(value: Big) -> Bool:
  match value:
    case Big{negative, _}: negative
    case SmallBig{negative, _}: negative
def Big.is_zero(value: Big) -> Bool:
  match value:
    case Big{_, bits}: List.is_empty(&2, Bool, bits)
    case SmallBig{_, value}: Nat.is_eq(value, 0n)
def Big.neg(value: Big) -> Big:
  match value:
    case Big{negative, bits}: Big.make(Bool.not(negative), bits)
    case SmallBig{negative, value}: Big.small(Bool.not(negative), value)
def Big.abs(value: Big) -> Big:
  match value:
    case Big{_, bits}: Big{False{}, bits}
    case SmallBig{_, value}: SmallBig{False{}, value}
def Big.bits.carry(carry: U32) -> List<&2, Bool>:
  match carry:
    case 0: Nil{}
    case _: [True{}]
law Big.bits.add: for xs: List<&2, Bool> for ys: List<&2, Bool> for carry: U32 List<&2, Bool>
@unsafe
def Big.bits.add_digit(+sum: U32, xs: List<&2, Bool>, ys: List<&2, Bool>) -> List<&2, Bool>:
  U32.is_eq((sum .&. 1 : U32), 1) <> Big.bits.add(xs, ys, (sum >> 1n : U32))
@unsafe
def Big.bits.add(xs, ys, carry):
  match xs ys:
    case Nil{} Nil{}: Big.bits.carry(carry)
    case Con{x, xt} Nil{}: Big.bits.add_digit((Bool.to_u32(x) + carry : U32), xt, Nil{})
    case Nil{} Con{y, yt}: Big.bits.add_digit((Bool.to_u32(y) + carry : U32), Nil{}, yt)
    case Con{x, xt} Con{y, yt}: Big.bits.add_digit((Bool.to_u32(x) + Bool.to_u32(y) + carry : U32), xt, yt)
law Big.bits.sub: for xs: List<&2, Bool> for ys: List<&2, Bool> for borrow: U32 List<&2, Bool>
@unsafe
def Big.bits.sub_digit(+difference: U32, xs: List<&2, Bool>, ys: List<&2, Bool>) -> List<&2, Bool>:
  Big.bits.cons(U32.is_eq((difference .&. 1 : U32), 1), Big.bits.sub(xs, ys, Bool.to_u32(U32.is_lt(difference, 2))))
@unsafe
def Big.bits.sub(xs, ys, borrow):
  match xs ys:
    case Nil{} _: Nil{}
    case Con{x, xt} Nil{}: Big.bits.sub_digit((2 + Bool.to_u32(x) - borrow : U32), xt, Nil{})
    case Con{x, xt} Con{y, yt}: Big.bits.sub_digit((2 + Bool.to_u32(x) - Bool.to_u32(y) - borrow : U32), xt, yt)
def Big.bits.cmp_digit(a: Bool, b: Bool, tail: Cmp) -> Cmp:
  match tail:
    case EQ{}: Bool.cmp(a, b)
    case other: other
def Big.bits.cmp(xs: List<&2, Bool>, ys: List<&2, Bool>) -> Cmp:
  match xs ys:
    case Nil{} Nil{}: EQ{}
    case Nil{} Con{_, _}: LT{}
    case Con{_, _} Nil{}: GT{}
    case Con{x, xt} Con{y, yt}: Big.bits.cmp_digit(x, y, Big.bits.cmp(xt, yt))
def Big.order.flip(order: Cmp) -> Cmp:
  match order:
    case LT{}: GT{}
    case EQ{}: EQ{}
    case GT{}: LT{}
def Big.cmp_bits(an: Bool, xs: List<&2, Bool>, bn: Bool, ys: List<&2, Bool>) -> Cmp:
  match an bn:
    case False{} False{}: Big.bits.cmp(xs, ys)
    case True{} True{}: Big.order.flip(Big.bits.cmp(xs, ys))
    case True{} False{}: LT{}
    case False{} True{}: GT{}
def Big.cmp_small(an: Bool, a: Nat, bn: Bool, b: Nat) -> Cmp:
  match an bn:
    case False{} False{}: Nat.cmp(a, b)
    case True{} True{}: Nat.cmp(b, a)
    case True{} False{}: LT{}
    case False{} True{}: GT{}
def Big.cmp(a: Big, b: Big) -> Cmp:
  match a b:
    case SmallBig{an, a} SmallBig{bn, b}: Big.cmp_small(an, a, bn, b)
    case SmallBig{an, a} Big{bn, ys}: Big.cmp_bits(an, Big.bits.of_nat(a), bn, ys)
    case Big{an, xs} SmallBig{bn, b}: Big.cmp_bits(an, xs, bn, Big.bits.of_nat(b))
    case Big{an, xs} Big{bn, ys}: Big.cmp_bits(an, xs, bn, ys)
def Big.order.eq(order: Cmp) -> Bool:
  match order:
    case EQ{}: True{}
    case LT{}: False{}
    case GT{}: False{}
def Big.order.lt(order: Cmp) -> Bool:
  match order:
    case LT{}: True{}
    case EQ{}: False{}
    case GT{}: False{}
def Big.is_eq(a: Big, b: Big) -> Bool: Big.order.eq(Big.cmp(a, b))
def Big.is_lt(a: Big, b: Big) -> Bool: Big.order.lt(Big.cmp(a, b))
def Big.is_le(a: Big, b: Big) -> Bool: Bool.not(Big.is_lt(b, a))
def Big.difference(order: Cmp, negative: Bool, xs: List<&2, Bool>, ys: List<&2, Bool>) -> Big:
  match order:
    case EQ{}: Big.zero()
    case GT{}: Big.make(negative, Big.bits.sub(xs, ys, 0))
    case LT{}: Big.make(Bool.not(negative), Big.bits.sub(ys, xs, 0))
def Big.add_bits(an: Bool, +xs: List<&2, Bool>, bn: Bool, +ys: List<&2, Bool>) -> Big:
  match an bn:
    case False{} False{}: Big.make(False{}, Big.bits.add(xs, ys, 0))
    case True{} True{}: Big.make(True{}, Big.bits.add(xs, ys, 0))
    case False{} True{}: Big.difference(Big.bits.cmp(xs, ys), False{}, xs, ys)
    case True{} False{}: Big.difference(Big.bits.cmp(xs, ys), True{}, xs, ys)
@unsafe
def Big.add_small(+an: Bool, +a: Nat, +bn: Bool, +b: Nat) -> Big:
  Big.when(Big, Bool.not(Bool.xor(an, bn)), _ => Big.small(an, (a + b: Nat)), _ => Big.when(Big, Nat.is_lt(a, b), _ => Big.small(bn, (b - a: Nat)), _ => Big.small(an, (a - b: Nat))))
def Big.add(a: Big, b: Big) -> Big:
  match a b:
    case SmallBig{an, a} SmallBig{bn, b}: Big.add_small(an, a, bn, b)
    case SmallBig{an, a} Big{bn, ys}: Big.add_bits(an, Big.bits.of_nat(a), bn, ys)
    case Big{an, xs} SmallBig{bn, b}: Big.add_bits(an, xs, bn, Big.bits.of_nat(b))
    case Big{an, xs} Big{bn, ys}: Big.add_bits(an, xs, bn, ys)
def Big.sub(a: Big, b: Big) -> Big: Big.add(a, Big.neg(b))
def Big.succ(a: Big) -> Big: Big.add(a, Big.one())
def Big.pred(a: Big) -> Big: Big.sub(a, Big.one())
def Big.bits.mul(xs: List<&2, Bool>, +ys: List<&2, Bool>) -> List<&2, Bool>:
  match xs:
    case Nil{}: Nil{}
    case Con{False{}, xt}: Big.bits.cons(False{}, Big.bits.mul(xt, ys))
    case Con{True{}, xt}: Big.bits.add(ys, Big.bits.cons(False{}, Big.bits.mul(xt, ys)), 0)
def Big.mul(a: Big, b: Big) -> Big:
  match a b:
    case SmallBig{an, a} SmallBig{bn, b}: Big.small(Bool.xor(an, bn), (a * b: Nat))
    case SmallBig{an, a} Big{bn, ys}: Big.make(Bool.xor(an, bn), Big.bits.mul(Big.bits.of_nat(a), ys))
    case Big{an, xs} SmallBig{bn, b}: Big.make(Bool.xor(an, bn), Big.bits.mul(Big.bits.of_nat(b), xs))
    case Big{an, xs} Big{bn, ys}: Big.make(Bool.xor(an, bn), Big.bits.mul(xs, ys))
def NativeNat.half(value: Nat) -> Nat: Nat.div.fin(Nat.divmod(value, 2n))
def NativeNat.parity(value: Nat) -> Nat: Nat.mod.fin(Nat.divmod(value, 2n))
law Big.bits.of_nat: for +n: Nat List<&2, Bool>
@unsafe
def Big.bits.of_nat(n):
  match n:
    case 0n: Nil{}
    case 1n+p: Nat.is_eq(NativeNat.parity((1n + p : Nat)), 1n) <> Big.bits.of_nat(NativeNat.half((1n + p : Nat)))
def Big.of_nat(n: Nat) -> Big: Big.small(False{}, n)
def Big.bits.to_nat(bits: List<&2, Bool>) -> Nat:
  match bits:
    case Nil{}: 0n
    case Con{b, tail}: (U32.to_nat(Bool.to_u32(b)) + 2n * Big.bits.to_nat(tail) : Nat)
def Big.to_nat(value: Big) -> Nat:
  match value:
    case SmallBig{_, value}: value
    case Big{_, bits}: Big.bits.to_nat(bits)
def Big.bit_length(value: Big) -> Nat: List.length(&2, Bool, Big.bits(value))
def Big.bits.shl(n: Nat, bits: List<&2, Bool>) -> List<&2, Bool>:
  match n:
    case 0n: bits
    case 1n+p: False{} <> Big.bits.shl(p, bits)
def Big.shift_left(value: Big, n: Nat) -> Big:
  match value:
    case Big{negative, bits}: Big.make(negative, Big.bits.trim(Big.bits.shl(n, bits)))
    case SmallBig{negative, value}: Big.make(negative, Big.bits.trim(Big.bits.shl(n, Big.bits.of_nat(value))))
def Big.bits.drop(n: Nat, bits: List<&2, Bool>) -> List<&2, Bool>:
  match n bits:
    case 0n xs: xs
    case 1n+p Nil{}: Nil{}
    case 1n+p Con{_, tail}: Big.bits.drop(p, tail)
def Big.shift_right(value: Big, n: Nat) -> Big:
  match value:
    case Big{negative, bits}: Big.make(negative, Big.bits.drop(n, bits))
    case SmallBig{negative, value}: Big.small(negative, U32.to_nat((U32.from_nat(value) >> n: U32)))

# Unsigned long division consumes the numerator from its most significant end.
type Big.Quotient is Data:
  Quotient{quotient: List<&2, Bool>, remainder: List<&2, Bool>}
law Big.bits.divide: for bits: List<&2, Bool> for +divisor: List<&2, Bool> for rem: List<&2, Bool> for quot: List<&2, Bool> Big.Quotient
@unsafe
def Big.bits.divide_step(order: Cmp, rest: List<&2, Bool>, +divisor: List<&2, Bool>, rem: List<&2, Bool>, quot: List<&2, Bool>) -> Big.Quotient:
  match order:
    case LT{}: Big.bits.divide(rest, divisor, rem, Big.bits.cons(False{}, quot))
    case EQ{}: Big.bits.divide(rest, divisor, Nil{}, Big.bits.cons(True{}, quot))
    case GT{}: Big.bits.divide(rest, divisor, Big.bits.sub(rem, divisor, 0), Big.bits.cons(True{}, quot))
@unsafe
def Big.bits.divide(bits, divisor, rem, quot):
  match bits:
    case Nil{}: Quotient{quot, rem}
    case Con{b, rest}:
      +next = Big.bits.cons(b, rem)
      Big.bits.divide_step(Big.bits.cmp(next, divisor), rest, divisor, next, quot)
def Big.divmod_bits(a: List<&2, Bool>, b: List<&2, Bool>) -> Maybe<&2, Big.Quotient>:
  match b:
    case Nil{}: None{}
    case Con{b, bs}: Some{Big.bits.divide(List.reverse(&2, Bool, a), b <> bs, Nil{}, Nil{})}
def Big.divmod_unsigned(a: Big, b: Big) -> Maybe<&2, Big.Quotient>: Big.divmod_bits(Big.bits(a), Big.bits(b))
def Big.quotient(negative: Bool, qr: Maybe<&2, Big.Quotient>) -> Maybe<&2, Big>:
  match qr:
    case None{}: None{}
    case Some{Quotient{q, _}}: Some{Big.make(negative, q)}
def Big.remainder(negative: Bool, qr: Maybe<&2, Big.Quotient>) -> Maybe<&2, Big>:
  match qr:
    case None{}: None{}
    case Some{Quotient{_, r}}: Some{Big.make(negative, r)}
def Big.div(+a: Big, +b: Big) -> Maybe<&2, Big>: Big.quotient(Bool.xor(Big.negative(a), Big.negative(b)), Big.divmod_unsigned(a, b))
def Big.rem(+a: Big, b: Big) -> Maybe<&2, Big>: Big.remainder(Big.negative(a), Big.divmod_unsigned(a, b))
law Big.show.bits: for bits: List<&2, Bool> for acc: String String
@unsafe
def Big.show.digit(qr: Big.Quotient, acc: String) -> String:
  match qr:
    case Quotient{q, r}: Big.show.bits(q, SCon{Char.from_u32((48 + U32.from_nat(Big.bits.to_nat(r)) : U32)), acc})
@unsafe
def Big.show.bits(bits, acc):
  match bits:
    case Nil{}: acc
    case Con{b, tail}: Big.show.digit(Big.bits.divide(List.reverse(&2, Bool, b <> tail), [False{}, True{}, False{}, True{}], Nil{}, Nil{}), acc)
def Big.show(value: Big) -> String:
  match value:
    case SmallBig{negative, +value}: Big.when(String, negative, _ => "-" ++ Nat.show(value), _ => Nat.show(value))
    case Big{_, Nil{}}: "0"
    case Big{False{}, Con{b, tail}}: Big.show.bits(b <> tail, "")
    case Big{True{}, Con{b, tail}}: "-" ++ Big.show.bits(b <> tail, "")
def Big.read.digit(c: Char) -> Maybe<&2, Nat>:
  +n = Char.to_u32(c)
  Big.when(Maybe<&2, Nat>, (U32.is_le(48, n) && U32.is_le(n, 57)), _ => Some{U32.to_nat((n - 48 : U32))}, _ => None{})
law Big.read.go: for text: String for value: Big Maybe<&2, Big>
@unsafe
def Big.read.next(digit: Maybe<&2, Nat>, text: String, value: Big) -> Maybe<&2, Big>:
  match digit:
    case None{}: None{}
    case Some{n}: Big.read.go(text, Big.add(Big.mul(value, Big.of_nat(10n)), Big.of_nat(n)))
@unsafe
def Big.read.go(text, value):
  match text:
    case "": Some{value}
    case SCon{c, rest}: Big.read.next(Big.read.digit(c), rest, value)
def Big.read.sign(negative: Bool, value: Maybe<&2, Big>) -> Maybe<&2, Big>:
  match value:
    case None{}: None{}
    case Some{v}: Some{Big.make(negative, Big.bits(v))}
def Big.read.nonempty(negative: Bool, text: String) -> Maybe<&2, Big>:
  match text:
    case "": None{}
    case SCon{c, rest}: Big.read.sign(negative, Big.read.go(SCon{c, rest}, Big.zero()))
def Big.read(text: String) -> Maybe<&2, Big>:
  match text:
    case "": None{}
    case SCon{'-', rest}: Big.read.nonempty(True{}, rest)
    case SCon{'+', rest}: Big.read.nonempty(False{}, rest)
    case SCon{c, rest}: Big.read.go(SCon{c, rest}, Big.zero())

# Integer boundary operations shared by the native modules.
def Big.identity(value: Big) -> Big: value
def Big.order.number(order: Cmp) -> Big:
  match order:
    case LT{}: Big.neg(Big.one())
    case EQ{}: Big.zero()
    case GT{}: Big.one()
def Big.compare(a: Big, b: Big) -> Big: Big.order.number(Big.cmp(a, b))
def Big.sign(value: Big) -> Big: Big.compare(value, Big.zero())
def Big.fits_int(+value: Big) -> Bool:
  +limit = Big.shift_left(Big.one(), 62n)
  Bool.and(Big.is_le(Big.neg(limit), value), Big.is_lt(value, limit))
def Big.low_bits(n: Nat, bits: List<&2, Bool>) -> List<&2, Bool>:
  match n:
    case 0n: Nil{}
    case 1n+p:
      match bits:
        case Nil{}: Nil{}
        case Con{b, rest}: Big.bits.cons(b, Big.low_bits(p, rest))
def Big.unsigned_bits(+width: Nat, +value: Big) -> Big:
  +low = Big.make(False{}, Big.low_bits(width, Big.bits(value)))
  Big.when(Big, Bool.and(Big.negative(value), Bool.not(Big.is_zero(low))), _ => Big.sub(Big.shift_left(Big.one(), width), low), _ => low)
@unsafe
def Big.unsigned(+width: Nat, value: Big) -> Big:
  match value:
    case SmallBig{False{}, +magnitude}: Big.when(Big, Nat.is_lt(width, 24n), _ => Big.of_nat(U32.to_nat((U32.from_nat(magnitude) .&. ((1 << width: U32) - 1: U32): U32))), _ => SmallBig{False{}, magnitude})
    case SmallBig{True{}, magnitude}: Big.unsigned_bits(width, SmallBig{True{}, magnitude})
    case Big{negative, bits}: Big.unsigned_bits(width, Big{negative, bits})
def Big.signed_bits(+width: Nat, +value: Big) -> Big:
  +sign = Big.shift_left(Big.one(), (width - 1n: Nat))
  Big.when(Big, Big.is_lt(value, sign), _ => value, _ => Big.sub(value, Big.shift_left(Big.one(), width)))
@unsafe
def Big.signed(+width: Nat, value: Big) -> Big:
  match value:
    case SmallBig{+negative, +magnitude}: Big.when(Big, Nat.is_lt(width, 25n), _ => Big.signed_bits(width, SmallBig{negative, magnitude}), _ => SmallBig{negative, magnitude})
    case Big{negative, bits}: Big.signed_bits(width, Big{negative, bits})
def Big.wrap(+width: Nat, value: Big) -> Big: Big.signed(width, Big.unsigned(width, value))
@unsafe
def NativeInt.bound(+value: Big) -> Big:
  match value:
    case SmallBig{negative, magnitude}: SmallBig{negative, magnitude}
    case Big{negative, +bits}: Big.when(Big, Nat.is_lt(List.length(&2, Bool, bits), 63n), _ => Big{negative, bits}, _ => Big.wrap(63n, Big{negative, bits}))
def NativeInt.add(a: Big, b: Big) -> Big: NativeInt.bound(Big.add(a, b))
def NativeInt.sub(a: Big, b: Big) -> Big: NativeInt.bound(Big.sub(a, b))
def NativeInt.mul(a: Big, b: Big) -> Big: NativeInt.bound(Big.mul(a, b))
def NativeInt.neg(a: Big) -> Big: NativeInt.bound(Big.neg(a))
def NativeInt.succ(a: Big) -> Big: NativeInt.add(a, Big.one())
def NativeInt.pred(a: Big) -> Big: NativeInt.sub(a, Big.one())
def Big.bits.logic(+mode: U32, xs: List<&2, Bool>, ys: List<&2, Bool>) -> List<&2, Bool>:
  match xs ys:
    case Nil{} Nil{}: Nil{}
    case Con{x, xt} Nil{}: Big.bits.cons(Big.when(Bool, U32.is_eq(mode, 0), _ => False{}, _ => x), Big.bits.logic(mode, xt, Nil{}))
    case Nil{} Con{y, yt}: Big.bits.cons(Big.when(Bool, U32.is_eq(mode, 0), _ => False{}, _ => y), Big.bits.logic(mode, Nil{}, yt))
    case Con{+x, xt} Con{+y, yt}: Big.bits.cons(Big.when(Bool, U32.is_eq(mode, 0), _ => Bool.and(x, y), _ => Big.when(Bool, U32.is_eq(mode, 1), _ => Bool.or(x, y), _ => Bool.xor(x, y))), Big.bits.logic(mode, xt, yt))
def Big.logic(mode: U32, +a: Big, +b: Big) -> Big:
  +na = Big.bit_length(a)
  +nb = Big.bit_length(b)
  +width = (1n + Big.when(Nat, Nat.is_lt(na, nb), _ => nb, _ => na): Nat)
  Big.signed(width, Big.make(False{}, Big.bits.logic(mode, Big.bits(Big.unsigned(width, a)), Big.bits(Big.unsigned(width, b)))))
def Big.logand(a: Big, b: Big) -> Big: Big.logic(0, a, b)
def Big.logor(a: Big, b: Big) -> Big: Big.logic(1, a, b)
def Big.logxor(a: Big, b: Big) -> Big: Big.logic(2, a, b)
def Big.shift_right_floor(+a: Big, +n: Nat) -> Big:
  +shifted = Big.shift_right(a, n)
  Big.when(Big, Bool.and(Big.negative(a), Bool.not(Big.is_zero(Big.make(False{}, Big.low_bits(n, Big.bits(a)))))), _ => Big.pred(shifted), _ => shifted)
@unsafe
def Big.hex_go(+bits: List<&2, Bool>, +upper: Bool, +acc: String) -> String:
  +digit = U32.from_nat(Big.bits.to_nat(Big.low_bits(4n, bits)))
  +base = Big.when(U32, U32.is_lt(digit, 10), _ => 48, _ => Big.when(U32, upper, _ => 55, _ => 87))
  Big.when(String, List.is_empty(&2, Bool, bits), _ => acc, _ => Big.hex_go(Big.bits.drop(4n, bits), upper, SCon{Char.from_u32((base + digit: U32)), acc}))
def Big.hex(+value: Big, upper: Bool) -> String:
  Big.when(String, Big.is_zero(value), _ => "0", _ => Big.hex_go(Big.bits(Big.unsigned(63n, value)), upper, SNil{}))
def Big.hex_natural(+value: Big) -> String:
  Big.when(String, Big.is_zero(value), _ => "0", _ => Big.when(String, Big.negative(value), _ => SCon{Char.from_u32(45), Big.hex_go(Big.bits(value), False{}, SNil{})}, _ => Big.hex_go(Big.bits(value), False{}, SNil{})))
def Big.is_ge(a: Big, b: Big) -> Bool: Big.is_le(b, a)
def Big.is_gt(a: Big, b: Big) -> Bool: Big.is_lt(b, a)
def Big.maximum(+a: Big, +b: Big) -> Big: Big.when(Big, Big.is_lt(a, b), _ => b, _ => a)
def Big.minimum(+a: Big, +b: Big) -> Big: Big.when(Big, Big.is_lt(a, b), _ => a, _ => b)
# These digit folds are called after the protocol and calldata validators.
def Big.validated_digits(+base: Big, text: String, acc: Big) -> Big:
  match text:
    case SNil{}: acc
    case SCon{c, rest}:
      +code = Char.to_u32(c)
      +digit = (code - Big.when(U32, U32.is_le(code, 57), _ => 48, _ => Big.when(U32, U32.is_le(code, 90), _ => 55, _ => 87)): U32)
      Big.validated_digits(base, rest, Big.add(Big.mul(acc, base), Big.of_nat(U32.to_nat(digit))))
def Big.read_validated(base: Big, text: String) -> Big: Big.validated_digits(base, text, Big.zero())
@unsafe
def Big.bytes_go(+bits: List<&2, Bool>) -> String:
  Big.when(String, List.is_empty(&2, Bool, bits), _ => SNil{}, _ => SCon{Char.from_u32(U32.from_nat(Big.bits.to_nat(Big.low_bits(8n, bits)))), Big.bytes_go(Big.bits.drop(8n, bits))})
def Big.to_bytes(value: Big) -> String: Big.bytes_go(Big.bits(value))
def NativeString.half_length(text: String) -> Big: Big.shift_right(Big.of_nat(String.length(text)), 1n)
def NativeString.length_parity(text: String) -> Big: Big.unsigned(1n, Big.of_nat(String.length(text)))


# Keccak-f[1600], rate 136 bytes, capacity 512 bits, suffix 0x01.
# Each lane is two native U32 words. Byte strings carry character codes 0..255.
type Tuple7<q0, q1, q2, q3, q4, q5, q6, -A0: Kind(q0), -A1: Kind(q1), -A2: Kind(q2), -A3: Kind(q3), -A4: Kind(q4), -A5: Kind(q5), -A6: Kind(q6)> is Kind((q0 <&> q1 <&> q2 <&> q3 <&> q4 <&> q5 <&> q6)): Tup7{v0: A0, v1: A1, v2: A2, v3: A3, v4: A4, v5: A5, v6: A6}
type Tuple6<q0, q1, q2, q3, q4, q5, -A0: Kind(q0), -A1: Kind(q1), -A2: Kind(q2), -A3: Kind(q3), -A4: Kind(q4), -A5: Kind(q5)> is Kind((q0 <&> q1 <&> q2 <&> q3 <&> q4 <&> q5)): Tup6{v0: A0, v1: A1, v2: A2, v3: A3, v4: A4, v5: A5}
type Tuple5<q0, q1, q2, q3, q4, -A0: Kind(q0), -A1: Kind(q1), -A2: Kind(q2), -A3: Kind(q3), -A4: Kind(q4)> is Kind((q0 <&> q1 <&> q2 <&> q3 <&> q4)): Tup5{v0: A0, v1: A1, v2: A2, v3: A3, v4: A4}
type Tuple4<q0, q1, q2, q3, -A0: Kind(q0), -A1: Kind(q1), -A2: Kind(q2), -A3: Kind(q3)> is Kind((q0 <&> q1 <&> q2 <&> q3)): Tup4{v0: A0, v1: A1, v2: A2, v3: A3}
type Tuple3<q0, q1, q2, -A0: Kind(q0), -A1: Kind(q1), -A2: Kind(q2)> is Kind((q0 <&> q1 <&> q2)): Tup3{v0: A0, v1: A1, v2: A2}
type Tuple2<q0, q1, -A0: Kind(q0), -A1: Kind(q1)> is Kind((q0 <&> q1)): Tup2{v0: A0, v1: A1}
@unsafe
def Reusable(-A: Type, -B: Type) -> Type: @+_: A -> B
type Assoc<a, -K: Data, -A: Kind(a)> is Kind(a):
  Assoc{items: List<a, Tuple2<&2, a, K, A>>}
  Assoc.Node{height: Nat, left: Assoc<a, K, A>, key: K, value: A, right: Assoc<a, K, A>}
def Bignum() -> Data: Big
type Literal is Data:
  Literal.LString{a0: String}
  Literal.LInt{a0: Bignum}
type Keccak_vec.Error is Data:
  Keccak_vec.Error.Invalid_hex{}
  Keccak_vec.Error.Odd_hex{}
  Keccak_vec.Error.Usage{}
type Budget is Type:
  MkBudget{poll: Reusable(Unit, Bool)}
def Level() -> Data: Big
type Quantity is Data:
  Quantity.Zero{}
  Quantity.One{}
  Quantity.Many{}
type Shape<-q0: Quant, -A0: Kind(q0)> is Kind(q0):
  Shape.SPi{a0: Quantity, a1: String, a2: A0}
  Shape.SColl{a0: Big}
  Shape.SPar{a0: A0, a1: A0}
  Shape.SMu{a0: String, a1: List<q0, A0>}
  Shape.SNu{a0: String, a1: List<q0, A0>}
type Term.AddrOf<-Self: Data> is Data:
  Term.AddrOf.APt{a0: Quantity, a1: Self}
  Term.AddrOf.ALeg{a0: Big}
  Term.AddrOf.ACtor{a0: String}
type Term.LegOf<-Self: Data> is Data:
  MkTerm_LegOf{l_binders: List<&2, Tuple2<&2, &2, Quantity, String>>, l_body: Self}
type Term.MotiveOf<-Self: Data> is Data:
  MkTerm_MotiveOf{m_ind: Maybe<&2, String>, m_idx: List<&2, String>, m_self: String, m_body: Self}
type Term.ElimOf<-Self: Data> is Data:
  MkTerm_ElimOf{e_shape: Shape<&2, Self>, e_scrut: Self, e_scrut_q: Quantity, e_motive: Maybe<&2, Term.MotiveOf<Self>>, e_branches: List<&2, Tuple2<&2, &2, Term.AddrOf<Self>, Term.LegOf<Self>>>}
type Term is Data:
  Term.Var{a0: Big}
  Term.Univ{a0: Level}
  Term.Lan{a0: Shape<&2, Term>, a1: Term}
  Term.Ran{a0: Shape<&2, Term>, a1: Term}
  Term.In{a0: Shape<&2, Term>, a1: Term.AddrOf<Term>, a2: List<&2, Term>}
  Term.Elim{a0: Term.ElimOf<Term>}
  Term.Sec{a0: Shape<&2, Term>, a1: List<&2, Term.LegOf<Term>>}
  Term.Out{a0: Shape<&2, Term>, a1: Term.AddrOf<Term>, a2: Term}
  Term.Let{a0: String, a1: Term, a2: Term, a3: Term}
  Term.Ann{a0: Term, a1: Term}
  Term.Global{a0: String}
  Term.Lit{a0: Literal}
  Term.Auto{}
def Term.Addr() -> Data: Term.AddrOf<Term>
def Term.Leg() -> Data: Term.LegOf<Term>
def Term.Motive() -> Data: Term.MotiveOf<Term>
def Term.Elim() -> Data: Term.ElimOf<Term>
type Global.Axiom_entry is Data:
  MkGlobal_Axiom_entry{ax_ty: Term}
type Global.Def_entry is Data:
  MkGlobal_Def_entry{ty: Term, field_def: Term, reducible: Bool, rec_arg: Maybe<&2, Big>, partial: Bool}
type Prim is Data:
  Prim.Nat_add{}
  Prim.Nat_sub{}
  Prim.Nat_mul{}
  Prim.Nat_eq{}
  Prim.Nat_lt{}
type Global.Prim_entry is Data:
  MkGlobal_Prim_entry{p_ty: Term, prim: Prim}
type Global.Entry is Data:
  Global.Entry.Def{a0: Global.Def_entry}
  Global.Entry.Axiom{a0: Global.Axiom_entry}
  Global.Entry.Prim{a0: Global.Prim_entry}
def Positivity.Telescope() -> Data: List<&2, Tuple3<&2, &2, &2, Quantity, String, Term>>
type Positivity.Ctor is Data:
  MkPositivity_Ctor{c_name: String, c_args: Positivity.Telescope, c_res_idx: List<&2, Term>, c_full_arity: Big, c_self_rec: Bool}
type Positivity.Ctor_status is Data:
  Positivity.Ctor_status.Provisional{}
  Positivity.Ctor_status.Builtin{}
  Positivity.Ctor_status.Complete{a0: List<&2, String>}
type Positivity.Family is Data:
  MkPositivity_Family{f_name: String, f_params: Positivity.Telescope, f_indices: Positivity.Telescope, f_level: Level, f_status: Positivity.Ctor_status, f_ctors: List<&2, Positivity.Ctor>, f_positive: Bool}
type Global is Data:
  MkGlobal{entries: Assoc<&2, String, Global.Entry>, families: Assoc<&2, String, Positivity.Family>}
type Value.Head is Data:
  Value.Head.HLocal{a0: Big}
  Value.Head.HGlobal{a0: String}
type Value.ClosureOf<-Self: Data> is Data:
  MkValue_ClosureOf{env: List<&2, Self>, body: Term}
type Value.Stuck_elimOf<-Self: Data> is Data:
  MkValue_Stuck_elimOf{s_shape: Shape<&2, Self>, s_scrut_q: Quantity, s_motive: Maybe<&2, Term.Motive>, s_branches: List<&2, Tuple2<&2, &2, Term.Addr, Term.Leg>>, s_env: List<&2, Self>}
type Value.VaddrOf<-Self: Data> is Data:
  Value.VaddrOf.VAPt{a0: Quantity, a1: Self}
  Value.VaddrOf.VALeg{a0: Big}
  Value.VaddrOf.VACtor{a0: String}
type Value.SpineOf<-Self: Data> is Data:
  Value.SpineOf.SOut{a0: Shape<&2, Self>, a1: Value.VaddrOf<Self>}
  Value.SpineOf.SElim{a0: Value.Stuck_elimOf<Self>}
type Value.VlegOf<-Self: Data> is Data:
  MkValue_VlegOf{vl_binders: List<&2, Tuple2<&2, &2, Quantity, String>>, vl_clo: Value.ClosureOf<Self>}
type Value is Data:
  Value.VUniv{a0: Level}
  Value.VLan{a0: Shape<&2, Value>, a1: Value.ClosureOf<Value>, a2: Maybe<&2, Level>}
  Value.VRan{a0: Shape<&2, Value>, a1: Value.ClosureOf<Value>, a2: Maybe<&2, Level>}
  Value.VIn{a0: Shape<&2, Value>, a1: Value.VaddrOf<Value>, a2: List<&2, Value>}
  Value.VSec{a0: Shape<&2, Value>, a1: List<&2, Value.VlegOf<Value>>}
  Value.VLit{a0: Literal}
  Value.VNeutral{a0: Value.Head, a1: List<&2, Value.SpineOf<Value>>}
def Value.Closure() -> Data: Value.ClosureOf<Value>
def Value.Stuck_elim() -> Data: Value.Stuck_elimOf<Value>
def Value.Vaddr() -> Data: Value.VaddrOf<Value>
def Value.Spine() -> Data: Value.SpineOf<Value>
def Value.Vleg() -> Data: Value.VlegOf<Value>
type Check.Ctx is Type:
  MkCheck_Ctx{globals: Global, env: List<&2, Value>, locals: List<&2, Tuple3<&2, &2, &2, String, Quantity, Value>>, size: Big, budget: Budget}
type Check.Kind is Data:
  Check.Kind.Definition{}
  Check.Kind.Postulate{}
type Check.Decl is Data:
  MkCheck_Decl{d_name: String, d_kind: Check.Kind, d_ty: Term, d_body: Maybe<&2, Term>}
type Check.Family_decl is Data:
  MkCheck_Family_decl{fam_name: String, fam_params: Positivity.Telescope, fam_indices: Positivity.Telescope, fam_level: Level}
type Check.Ctor_decl is Data:
  MkCheck_Ctor_decl{ct_name: String, ct_args: Positivity.Telescope, ct_res_params: List<&2, Term>, ct_res_idx: List<&2, Term>}
type Conv.Side is Data:
  Conv.Side.Right{}
  Conv.Side.Left{}
type Error is Data:
  Error.Not_yet{a0: String}
  Error.Parse{a0: String, a1: Big, a2: Big}
  Error.Carry{a0: String}
  Error.Unbound{a0: String}
  Error.Mismatch{a0: String}
  Error.Universe{a0: String}
  Error.Quantity{a0: String}
  Error.Wrong_leg{a0: String}
  Error.Missing_branch{a0: String}
  Error.Overflow{a0: String}
  Error.Cannot_infer{a0: String}
  Error.Budget_exhausted{a0: String}
  Error.Index_not_zero{a0: String}
  Error.Index_above_universe{a0: String}
  Error.Termination{a0: String}
def Global.Telescope() -> Data: List<&2, Tuple3<&2, &2, &2, Quantity, String, Term>>
type Order.Rule is Data:
  Order.Rule.Structural{}
type Order.Status is Data:
  Order.Status.Principal{}
  Order.Status.Smaller{}
  Order.Status.Other{}
type Order.Step is Data:
  MkOrder_Step{st_scrut: Big, st_ctor: Maybe<&2, String>}
type Order.Call is Data:
  MkOrder_Call{cl_callee: String, cl_chain: List<&2, Order.Step>}
type Order.Row is Data:
  MkOrder_Row{rw_member: String, rw_calls: List<&2, Order.Call>}
type Order is Data:
  MkOrder{o_group: List<&2, String>, o_arg: Big, o_rows: List<&2, Order.Row>}
def Quantity.Interval() -> Data: Tuple2<&2, &2, Quantity, Quantity>
type Quantity.Usage is Data:
  MkQuantity_Usage{paths: Maybe<&2, Assoc<&2, Big, Quantity.Interval>>, reads: Assoc<&2, Big, Quantity.Interval>}
type Rules.Evaluator is Type:
  MkRules_Evaluator{ev_eval: Reusable(List<&2, Value>, Reusable(Term, Result<&2, &2, Error, Value>))}
type Rules.Ops<-q0: Quant, -A0: Kind(q0)> is Type:
  MkRules_Ops{o_infer: Reusable(A0, Reusable(Quantity, Reusable(Term, Result<&2, &2, Error, Tuple2<&2, &2, Value, Quantity.Usage>>))), o_check: Reusable(A0, Reusable(Quantity, Reusable(Term, Reusable(Value, Result<&2, &2, Error, Quantity.Usage>)))), o_close: Reusable(A0, Reusable(Big, Reusable(Quantity, Reusable(Quantity.Usage, Result<&2, &2, Error, Quantity.Usage>)))), o_infer_univ: Reusable(A0, Reusable(Term, Result<&2, &2, Error, Level>)), o_conv: Reusable(A0, Reusable(Value, Reusable(Value, Reusable(Value, Result<&2, &2, Error, Bool>)))), o_conv_type: Reusable(A0, Reusable(Value, Reusable(Value, Result<&2, &2, Error, Bool>))), o_eval: Reusable(A0, Reusable(Term, Result<&2, &2, Error, Value>)), o_whnf: Reusable(A0, Reusable(Value, Result<&2, &2, Error, Value>)), o_bind: Reusable(String, Reusable(Quantity, Reusable(Value, Reusable(A0, A0)))), o_size: Reusable(A0, Big), o_env: Reusable(A0, List<&2, Value>), o_ev: Reusable(A0, Rules.Evaluator), o_pp: Reusable(A0, Reusable(Value, String)), o_quote: Reusable(A0, Reusable(Value, Result<&2, &2, Error, Term>)), o_head_ty: Reusable(A0, Reusable(Value.Head, Result<&2, &2, Error, Value>)), o_family: Reusable(A0, Reusable(String, Maybe<&2, Positivity.Family>))}
type Rules.Eta_row is Data:
  MkRules_Eta_row{eta_ran: Bool, eta_lan: Bool}
type Rules.Beta_redex is Data:
  Rules.Beta_redex.BOut{a0: Shape<&2, Value>, a1: Value.Vaddr, a2: Value}
  Rules.Beta_redex.BElim{a0: Shape<&2, Value>, a1: List<&2, Tuple2<&2, &2, Term.Addr, Term.Leg>>, a2: List<&2, Value>, a3: Value}
def Rules.Expansion(-q0: Quant, -A0: Kind(q0)) -> Type: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, Reusable(Value.Closure, Reusable(Value, Reusable(Value, Result<&2, &2, Error, Bool>))))))
type Rules.Rule_pack<-q0: Quant, -A0: Kind(q0)> is Type:
  MkRules_Rule_pack{form_lan: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Term>, Reusable(Term, Reusable(Maybe<&2, Level>, Result<&2, &2, Error, Level>))))), form_ran: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Term>, Reusable(Term, Reusable(Maybe<&2, Level>, Result<&2, &2, Error, Level>))))), intro_in: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Quantity, Reusable(Shape<&2, Term>, Reusable(Term.Addr, Reusable(List<&2, Term>, Reusable(Value, Result<&2, &2, Error, Quantity.Usage>))))))), elim_elim: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Quantity, Reusable(Term.Elim, Reusable(Maybe<&2, Value>, Result<&2, &2, Error, Tuple2<&2, &2, Value, Quantity.Usage>>))))), intro_sec: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Quantity, Reusable(Shape<&2, Term>, Reusable(List<&2, Term.Leg>, Reusable(Value, Result<&2, &2, Error, Quantity.Usage>)))))), elim_out: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Quantity, Reusable(Shape<&2, Term>, Reusable(Term.Addr, Reusable(Term, Result<&2, &2, Error, Tuple2<&2, &2, Value, Quantity.Usage>>)))))), beta: Reusable(Rules.Evaluator, Reusable(Rules.Beta_redex, Result<&2, &2, Error, Maybe<&2, Value>>)), eta: Rules.Eta_row, diagram_arity: Reusable(Shape<&2, Value>, Big), spine_ty: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, Reusable(Value.Closure, Reusable(Value.Vaddr, Result<&2, &2, Error, Maybe<&2, Tuple2<&2, &2, Maybe<&2, Value>, Value>>>))))), expand_ran: Maybe<&1, Rules.Expansion(q0, A0)>, expand_lan: Maybe<&1, Rules.Expansion(q0, A0)>, conv_diagram: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, Reusable(Value.Closure, Reusable(Value.Closure, Result<&2, &2, Error, Bool>))))), ann_lvl_eq: Reusable(Shape<&2, Value>, Reusable(Maybe<&2, Level>, Reusable(Maybe<&2, Level>, Bool))), lan_lvl: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, Reusable(List<&2, Level>, Result<&2, &2, Error, Level>)))), ran_lvl: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, Reusable(List<&2, Level>, Result<&2, &2, Error, Level>)))), subsingleton: Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, Result<&2, &2, Error, Bool>)))}
def ListOf(-A: Data) -> Data: List<&2, A>
def OptionOf(-A: Data) -> Data: Maybe<&2, A>
def ResultOf(-E: Data, -A: Data) -> Data: Result<&2, &2, E, A>
def TupleOf2(-A0: Data, -A1: Data) -> Data: Tuple2<&2, &2, A0, A1>
def TupleOf3(-A0: Data, -A1: Data, -A2: Data) -> Data: Tuple3<&2, &2, &2, A0, A1, A2>
def TupleOf4(-A0: Data, -A1: Data, -A2: Data, -A3: Data) -> Data: Tuple4<&2, &2, &2, &2, A0, A1, A2, A3>
def TupleOf5(-A0: Data, -A1: Data, -A2: Data, -A3: Data, -A4: Data) -> Data: Tuple5<&2, &2, &2, &2, &2, A0, A1, A2, A3, A4>
def TupleOf6(-A0: Data, -A1: Data, -A2: Data, -A3: Data, -A4: Data, -A5: Data) -> Data: Tuple6<&2, &2, &2, &2, &2, &2, A0, A1, A2, A3, A4, A5>
def TupleOf7(-A0: Data, -A1: Data, -A2: Data, -A3: Data, -A4: Data, -A5: Data, -A6: Data) -> Data: Tuple7<&2, &2, &2, &2, &2, &2, &2, A0, A1, A2, A3, A4, A5, A6>
def CheckResult(-A: Data) -> Data: Result<&2, &2, Error, A>
def CheckResult.pure(-A: Data, value: A) -> CheckResult(A): Done{value}
def CheckResult.bind(-A: Data, -B: Data, value: CheckResult(A), next: A -> CheckResult(B)) -> CheckResult(B):
  match value:
    case Done{x}: next(x)
    case Fail{error}: Fail{error}
def StringResult(-A: Data) -> Data: Result<&2, &2, String, A>
def StringResult.pure(-A: Data, value: A) -> StringResult(A): Done{value}
def StringResult.bind(-A: Data, -B: Data, value: StringResult(A), next: A -> StringResult(B)) -> StringResult(B):
  match value:
    case Done{x}: next(x)
    case Fail{error}: Fail{error}
type Series<a, -A: Kind(a)> is Type:
  Series.Nil{}
  Series.Cons{head: A, tail: Unit -> Series<a, A>}
def NativeBool.equal(a: Bool, b: Bool) -> Bool:
  match a:
    case True{}: b
    case False{}: Bool.not(b)
def Series.string_node(text: String) -> Series<&2, Char>:
  match text:
    case SNil{}: Series.Nil{}
    case SCon{head, tail}: Series.Cons{head, _ => Series.string_node(tail)}
def Series.from_string(text: String) -> Unit -> Series<&2, Char>: _ => Series.string_node(text)
@unsafe
def Series.list_node(a, -A: Kind(a), xs: List<a, A>) -> Series<a, A>:
  match xs:
    case Nil{}: Series.Nil{}
    case Con{x, rest}: Series.Cons{x, _ => Series.list_node(a, A, rest)}
@unsafe
def Series.of_list(a, -A: Kind(a), xs: List<a, A>) -> Unit -> Series<a, A>: _ => Series.list_node(a, A, xs)
@unsafe
def Series.collect(a, -A: Kind(a), node: Series<a, A>) -> List<a, A>:
  match node:
    case Series.Nil{}: Nil{}
    case Series.Cons{x, tail}: x <> Series.collect(a, A, tail(Unit{}))
@unsafe
def Series.to_list(a, -A: Kind(a), stream: Unit -> Series<a, A>) -> List<a, A>: Series.collect(a, A, stream(Unit{}))
def Series.uncons_node(a, -A: Kind(a), node: Series<a, A>) -> Maybe<&1, Tuple2<a, &1, A, Unit -> Series<a, A>>>:
  match node:
    case Series.Nil{}: None{}
    case Series.Cons{head, tail}: Some{Tup2{head, tail}}
def Series.uncons(a, -A: Kind(a), stream: Unit -> Series<a, A>) -> Maybe<&1, Tuple2<a, &1, A, Unit -> Series<a, A>>>: Series.uncons_node(a, A, stream(Unit{}))
law Series.drop: for -a: Quant for -A: Kind(a) for n: Nat for stream: Unit -> Series<a, A> for u: Unit Series<a, A>
@unsafe
def Series.drop_node(a, -A: Kind(a), n: Nat, node: Series<a, A>) -> Series<a, A>:
  match node:
    case Series.Nil{}: Series.Nil{}
    case Series.Cons{x, tail}: Series.drop(a, A, n, tail, Unit{})
@unsafe
def Series.drop(a, A, n, stream, u):
  match n:
    case 0n: stream(u)
    case 1n+p: Series.drop_node(a, A, p, stream(u))
law Series.take: for -a: Quant for -A: Kind(a) for n: Nat for stream: Unit -> Series<a, A> for u: Unit Series<a, A>
@unsafe
def Series.take_node(a, -A: Kind(a), n: Nat, node: Series<a, A>) -> Series<a, A>:
  match node:
    case Series.Nil{}: Series.Nil{}
    case Series.Cons{x, tail}: Series.Cons{x, u => Series.take(a, A, n, tail, u)}
@unsafe
def Series.take(a, A, n, stream, u):
  match n:
    case 0n: Series.Nil{}
    case 1n+p: Series.take_node(a, A, p, stream(u))
def NativeChar.equal(a: Char, b: Char) -> Bool: U32.is_eq(Char.to_u32(a), Char.to_u32(b))
@unsafe
def NativeString.equal(a: String, b: String) -> Bool:
  match a b:
    case SNil{} SNil{}: True{}
    case SNil{} SCon{_, _}: False{}
    case SCon{_, _} SNil{}: False{}
    case SCon{x, xs} SCon{y, ys}: Native.choose(&2, Bool, NativeChar.equal(x, y), _ => NativeString.equal(xs, ys), _ => False{})
@unsafe
def NativeString.order_step(order: Cmp, a: String, b: String) -> Cmp:
  match order:
    case EQ{}: NativeString.order(a, b)
    case LT{}: LT{}
    case GT{}: GT{}
@unsafe
def NativeString.order(a: String, b: String) -> Cmp:
  match a b:
    case SNil{} SNil{}: EQ{}
    case SNil{} SCon{_, _}: LT{}
    case SCon{_, _} SNil{}: GT{}
    case SCon{x, xs} SCon{y, ys}: NativeString.order_step(U32.cmp(Char.to_u32(x), Char.to_u32(y)), xs, ys)
def NativeString.compare(a: String, b: String) -> Big: Big.order.number(NativeString.order(a, b))
def NativeBool.show(value: Bool) -> String:
  match value:
    case True{}: "true"
    case False{}: "false"
@unsafe
def Native.choose(q, -A: Kind(q), test: Bool, yes: Unit -> A, no: Unit -> A) -> A:
  match test:
    case True{}: yes(Unit{})
    case False{}: no(Unit{})
@unsafe
def NativeString.fold(a, -A: Kind(a), +f: (@+arg0: A -> @+arg1: Char -> A), text: String, acc: A) -> A:
  match text:
    case SNil{}: acc
    case SCon{c, rest}: NativeString.fold(a, A, f, rest, f(acc, c))
def NativeString.repeat(n: Nat, +c: Char) -> String:
  match n:
    case 0n: SNil{}
    case 1n+p: SCon{c, NativeString.repeat(p, c)}
def NativeString.pad(+width: Nat, c: Char, +value: String) -> String:
  +length = String.length(value)
  Native.choose(&2, String, Nat.is_lt(length, width), _ => String.append(NativeString.repeat((width - length: Nat), c), value), _ => value)
def NativeString.slash(c: U32) -> String: SCon{Char.from_u32(92), SCon{Char.from_u32(c), SNil{}}}
def NativeString.escape_char(+c: Char) -> String:
  +n = Char.to_u32(c)
  Native.choose(&2, String, U32.is_eq(n, 34), _ => NativeString.slash(34), _ =>
  Native.choose(&2, String, U32.is_eq(n, 92), _ => NativeString.slash(92), _ =>
  Native.choose(&2, String, U32.is_eq(n, 10), _ => NativeString.slash(110), _ =>
  Native.choose(&2, String, U32.is_eq(n, 13), _ => NativeString.slash(114), _ =>
  Native.choose(&2, String, U32.is_eq(n, 9), _ => NativeString.slash(116), _ =>
  Native.choose(&2, String, U32.is_eq(n, 8), _ => NativeString.slash(98), _ =>
  Native.choose(&2, String, Bool.or(U32.is_lt(n, 32), U32.is_ge(n, 127)), _ => SCon{Char.from_u32(92), NativeString.pad(3n, Char.from_u32(48), Big.show(Big.of_nat(U32.to_nat(n))))}, _ => SCon{c, SNil{}})))))))
def NativeString.escaped(text: String) -> String:
  match text:
    case SNil{}: SNil{}
    case SCon{c, rest}: String.append(NativeString.escape_char(c), NativeString.escaped(rest))
def NativeString.quoted(text: String) -> String: SCon{Char.from_u32(34), String.append(NativeString.escaped(text), SCon{Char.from_u32(34), SNil{}})}
def NativeString.char_quoted(+c: Char) -> String:
  +body = Native.choose(&2, String, U32.is_eq(Char.to_u32(c), 39), _ => NativeString.slash(39), _ => Native.choose(&2, String, U32.is_eq(Char.to_u32(c), 34), _ => SCon{c, SNil{}}, _ => NativeString.escape_char(c)))
  SCon{Char.from_u32(39), String.append(body, SCon{Char.from_u32(39), SNil{}})}
def NativeString.to_list(text: String) -> List<&2, Char>:
  match text:
    case SNil{}: Nil{}
    case SCon{c, rest}: c <> NativeString.to_list(rest)
def NativeString.of_list(chars: List<&2, Char>) -> String:
  match chars:
    case Nil{}: SNil{}
    case Con{c, rest}: SCon{c, NativeString.of_list(rest)}
@unsafe
def NativeString.map_go(+f: (@+arg0: Char -> Char), text: String, acc: String) -> String:
  match text:
    case SNil{}: String.reverse(acc)
    case SCon{c, rest}: NativeString.map_go(f, rest, SCon{f(c), acc})
def NativeString.map(f: (@+arg0: Char -> Char), text: String) -> String: NativeString.map_go(f, text, SNil{})
def NativeChar.lower(+c: Char) -> Char:
  +n = Char.to_u32(c)
  Native.choose(&2, Char, Bool.and(U32.is_ge(n, 65), U32.is_le(n, 90)), _ => Char.from_u32((n + 32: U32)), _ => c)
def NativeChar.upper(+c: Char) -> Char:
  +n = Char.to_u32(c)
  Native.choose(&2, Char, Bool.and(U32.is_ge(n, 97), U32.is_le(n, 122)), _ => Char.from_u32((n - 32: U32)), _ => c)
def NativeString.lower(text: String) -> String: NativeString.map(+c => NativeChar.lower(c), text)
def NativeString.upper(text: String) -> String: NativeString.map(+c => NativeChar.upper(c), text)
@unsafe
def NativeString.all(+f: (@+arg0: Char -> Bool), text: String) -> Bool:
  match text:
    case SNil{}: True{}
    case SCon{c, rest}: Native.choose(&2, Bool, f(c), _ => NativeString.all(f, rest), _ => False{})
def NativeString.drop(n: Nat, text: String) -> String:
  match n:
    case 0n: text
    case 1n+p:
      match text:
        case SNil{}: SNil{}
        case SCon{c, rest}: NativeString.drop(p, rest)
def NativeString.take(n: Nat, text: String) -> String:
  match n:
    case 0n: SNil{}
    case 1n+p:
      match text:
        case SNil{}: SNil{}
        case SCon{c, rest}: SCon{c, NativeString.take(p, rest)}
@unsafe
def NativeString.split_go(+sep: Char, text: String, +current: String, +acc: List<&2, String>) -> List<&2, String>:
  match text:
    case SNil{}: List.reverse(&2, String, String.reverse(current) <> acc)
    case SCon{+c, +rest}: Native.choose(&2, List<&2, String>, NativeChar.equal(c, sep), _ => NativeString.split_go(sep, rest, SNil{}, String.reverse(current) <> acc), _ => NativeString.split_go(sep, rest, SCon{c, current}, acc))
def NativeString.split(sep: Char, text: String) -> List<&2, String>: NativeString.split_go(sep, text, SNil{}, Nil{})
def SeqList.drop(a, -A: Kind(a), n: Nat, xs: List<a, A>) -> List<a, A>:
  match n:
    case 0n: xs
    case 1n+p:
      match xs:
        case Nil{}: Nil{}
        case Con{x, rest}: SeqList.drop(a, A, p, rest)
def SeqList.take(a, -A: Kind(a), n: Nat, xs: List<a, A>) -> List<a, A>:
  match n:
    case 0n: Nil{}
    case 1n+p:
      match xs:
        case Nil{}: Nil{}
        case Con{x, rest}: x <> SeqList.take(a, A, p, rest)
@unsafe
def SeqList.merge_sorted(a, -A: Kind(a), +cmp: (@+arg0: A -> @+arg1: A -> Big), xs: List<a, A>, ys: List<a, A>) -> List<a, A>:
  match xs ys:
    case Nil{} ys: ys
    case Con{x, rest} Nil{}: x <> rest
    case Con{+x, +xt} Con{+y, +yt}: Native.choose(a, List<a, A>, Big.is_le(cmp(x, y), Big.zero()), _ => x <> SeqList.merge_sorted(a, A, cmp, xt, y <> yt), _ => y <> SeqList.merge_sorted(a, A, cmp, x <> xt, yt))
@unsafe
def SeqList.sort(a, -A: Kind(a), +cmp: (@+arg0: A -> @+arg1: A -> Big), xs: List<a, A>) -> List<a, A>:
  match xs:
    case Nil{}: Nil{}
    case Con{x, Nil{}}: [x]
    case Con{x, Con{y, rest}}:
      +all = {x <> y <> rest : List<a, A>}
      +half = NativeNat.half(List.length(a, A, all))
      SeqList.merge_sorted(a, A, cmp, SeqList.sort(a, A, cmp, SeqList.take(a, A, half, all)), SeqList.sort(a, A, cmp, SeqList.drop(a, A, half, all)))
@unsafe
def SeqList.index_go(a, -A: Kind(a), +f: (@+arg0: A -> Bool), xs: List<a, A>, +index: Big) -> Maybe<&2, Big>:
  match xs:
    case Nil{}: None{}
    case Con{x, rest}: Native.choose(&2, Maybe<&2, Big>, f(x), _ => Some{index}, _ => SeqList.index_go(a, A, f, rest, Big.succ(index)))
@unsafe
def SeqList.find_index(a, -A: Kind(a), f: (@+arg0: A -> Bool), xs: List<a, A>) -> Maybe<&2, Big>: SeqList.index_go(a, A, f, xs, Big.zero())
@unsafe
def SeqList.remove_assoc(a, b, -A: Kind(a), -B: Kind(b), +eq: (@+arg0: A -> @+arg1: A -> Bool), +key: A, xs: List<(a <&> b), Tuple2<a, b, A, B>>) -> List<(a <&> b), Tuple2<a, b, A, B>>:
  match xs:
    case Nil{}: Nil{}
    case Con{Tup2{+k, v}, +rest}: Native.choose((a <&> b), List<(a <&> b), Tuple2<a, b, A, B>>, eq(key, k), _ => rest, _ => Tup2{k, v} <> SeqList.remove_assoc(a, b, A, B, eq, key, rest))
@unsafe
def SeqList.assoc(a, b, -A: Kind(a), -B: Kind(b), +eq: (@+arg0: A -> @+arg1: A -> Bool), +key: A, xs: List<(a <&> b), Tuple2<a, b, A, B>>) -> Maybe<b, B>:
  match xs:
    case Nil{}: None{}
    case Con{Tup2{k, v}, rest}: Native.choose(b, Maybe<b, B>, eq(key, k), _ => Some{v}, _ => SeqList.assoc(a, b, A, B, eq, key, rest))
@unsafe
def SeqList.fold_right(a, b, -A: Kind(a), -B: Kind(b), +f: (@+arg0: A -> @+arg1: B -> B), xs: List<a, A>, acc: B) -> B:
  match xs:
    case Nil{}: acc
    case Con{x, rest}: f(x, SeqList.fold_right(a, b, A, B, f, rest, acc))
def SeqList.filter_step(a, -A: Kind(a), yes: Bool, x: A, rest: List<a, A>) -> List<a, A>:
  match yes:
    case True{}: x <> rest
    case False{}: rest
@unsafe
def SeqList.mapi_go(a, b, -A: Kind(a), -B: Kind(b), +f: (@+arg0: Big -> @+arg1: A -> B), xs: List<a, A>, +index: Big) -> List<b, B>:
  match xs:
    case Nil{}: Nil{}
    case Con{x, rest}: f(index, x) <> SeqList.mapi_go(a, b, A, B, f, rest, Big.succ(index))
@unsafe
def SeqList.mapi(a, b, -A: Kind(a), -B: Kind(b), f: (@+arg0: Big -> @+arg1: A -> B), xs: List<a, A>) -> List<b, B>: SeqList.mapi_go(a, b, A, B, f, xs, Big.zero())
@unsafe
def SeqList.filter(a, -A: Kind(a), +f: (@+arg0: A -> Bool), xs: List<a, A>) -> List<a, A>:
  match xs:
    case Nil{}: Nil{}
    case Con{+x, rest}: SeqList.filter_step(a, A, f(x), x, SeqList.filter(a, A, f, rest))
@unsafe
def SeqList.find(a, -A: Kind(a), +f: (@+arg0: A -> Bool), xs: List<a, A>) -> Maybe<a, A>:
  match xs:
    case Nil{}: None{}
    case Con{+x, rest}: Native.choose(a, Maybe<a, A>, f(x), _ => Some{x}, _ => SeqList.find(a, A, f, rest))
def SeqList.keep(a, -A: Kind(a), x: Maybe<a, A>, rest: List<a, A>) -> List<a, A>:
  match x:
    case None{}: rest
    case Some{v}: v <> rest
@unsafe
def SeqList.filter_map(a, b, -A: Kind(a), -B: Kind(b), +f: (@+arg0: A -> Maybe<b, B>), xs: List<a, A>) -> List<b, B>:
  match xs:
    case Nil{}: Nil{}
    case Con{x, rest}: SeqList.keep(b, B, f(x), SeqList.filter_map(a, b, A, B, f, rest))
@unsafe
def SeqList.filteri_go(a, -A: Kind(a), +f: (@+arg0: Big -> @+arg1: A -> Bool), xs: List<a, A>, +i: Big) -> List<a, A>:
  match xs:
    case Nil{}: Nil{}
    case Con{+x, rest}: SeqList.filter_step(a, A, f(i, x), x, SeqList.filteri_go(a, A, f, rest, Big.succ(i)))
@unsafe
def SeqList.filteri(a, -A: Kind(a), f: (@+arg0: Big -> @+arg1: A -> Bool), xs: List<a, A>) -> List<a, A>: SeqList.filteri_go(a, A, f, xs, Big.zero())
@unsafe
def SeqList.insert_unique(a, -A: Kind(a), +cmp: (@+arg0: A -> @+arg1: A -> Big), +value: A, xs: List<a, A>) -> List<a, A>:
  match xs:
    case Nil{}: [value]
    case Con{+x, +rest}:
      +order = cmp(value, x)
      Native.choose(a, List<a, A>, Big.is_lt(order, Big.zero()), _ => value <> x <> rest, _ => Native.choose(a, List<a, A>, Big.is_zero(order), _ => value <> rest, _ => x <> SeqList.insert_unique(a, A, cmp, value, rest)))
@unsafe
def SeqList.sort_uniq(a, -A: Kind(a), +cmp: (@+arg0: A -> @+arg1: A -> Big), xs: List<a, A>) -> List<a, A>:
  match xs:
    case Nil{}: Nil{}
    case Con{x, rest}: SeqList.insert_unique(a, A, cmp, x, SeqList.sort_uniq(a, A, cmp, rest))
@unsafe
def SeqList.init_go(a, -A: Kind(a), +f: (@+arg0: Big -> A), +n: Big, +i: Big) -> List<a, A>: Native.choose(a, List<a, A>, Big.is_lt(i, n), _ => f(i) <> SeqList.init_go(a, A, f, n, Big.succ(i)), _ => Nil{})
@unsafe
def SeqList.init(a, -A: Kind(a), n: Big, f: (@+arg0: Big -> A)) -> List<a, A>: SeqList.init_go(a, A, f, n, Big.zero())
def Assoc.rows(a, -K: Data, -V: Kind(a), map: Assoc<a, K, V>) -> List<a, Tuple2<&2, a, K, V>>:
  match map:
    case Assoc{rows}: rows
    case Assoc.Node{_, left, key, value, right}: List.append(a, Tuple2<&2, a, K, V>, Assoc.rows(a, K, V, left), Tup2{key, value} <> Assoc.rows(a, K, V, right))
@unsafe
def Assoc.fold_rows(a, b, -K: Data, -V: Kind(a), -A: Kind(b), +f: (@+arg0: K -> @+arg1: V -> @+arg2: A -> A), rows: List<a, Tuple2<&2, a, K, V>>, acc: A) -> A:
  match rows:
    case Nil{}: acc
    case Con{Tup2{k, v}, rest}: Assoc.fold_rows(a, b, K, V, A, f, rest, f(k, v, acc))
@unsafe
def Assoc.fold(a, b, -K: Data, -V: Kind(a), -A: Kind(b), f: (@+arg0: K -> @+arg1: V -> @+arg2: A -> A), map: Assoc<a, K, V>, acc: A) -> A: Assoc.fold_rows(a, b, K, V, A, f, Assoc.rows(a, K, V, map), acc)
def Assoc.empty(a, -K: Data, -V: Kind(a)) -> Assoc<a, K, V>: Assoc{Nil{}}
def Assoc.singleton(a, -K: Data, -V: Kind(a), key: K, value: V) -> Assoc<a, K, V>: Assoc.Node{1n, Assoc{Nil{}}, key, value, Assoc{Nil{}}}
@unsafe
def Assoc.find_rows(a, -K: Data, -V: Kind(a), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), +key: K, rows: List<a, Tuple2<&2, a, K, V>>) -> Maybe<a, V>:
  match rows:
    case Nil{}: None{}
    case Con{Tup2{k, v}, rest}: Native.choose(a, Maybe<a, V>, Big.order.eq(cmp(key, k)), _ => Some{v}, _ => Assoc.find_rows(a, K, V, cmp, key, rest))
@unsafe
def Assoc.find(a, -K: Data, -V: Kind(a), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), +key: K, map: Assoc<a, K, V>) -> Maybe<a, V>:
  match map:
    case Assoc{rows}: Assoc.find_rows(a, K, V, cmp, key, rows)
    case Assoc.Node{_, left, k, value, right}: Assoc.find_step(a, K, V, cmp(key, k), cmp, key, left, value, right)
@unsafe
def Assoc.find_step(a, -K: Data, -V: Kind(a), order: Cmp, cmp: (@+arg0: K -> @+arg1: K -> Cmp), key: K, left: Assoc<a, K, V>, value: V, right: Assoc<a, K, V>) -> Maybe<a, V>:
  match order:
    case LT{}: Assoc.find(a, K, V, cmp, key, left)
    case EQ{}: Some{value}
    case GT{}: Assoc.find(a, K, V, cmp, key, right)
@unsafe
def Assoc.add_rows(a, -K: Data, -V: Kind(a), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), +key: K, +value: V, rows: List<a, Tuple2<&2, a, K, V>>) -> List<a, Tuple2<&2, a, K, V>>:
  match rows:
    case Nil{}: [Tup2{key, value}]
    case Con{Tup2{+k, +v}, +rest}:
      +order = cmp(key, k)
      Native.choose(a, List<a, Tuple2<&2, a, K, V>>, Big.order.lt(order), _ => Tup2{key, value} <> Tup2{k, v} <> rest, _ => Native.choose(a, List<a, Tuple2<&2, a, K, V>>, Big.order.eq(order), _ => Tup2{key, value} <> rest, _ => Tup2{k, v} <> Assoc.add_rows(a, K, V, cmp, key, value, rest)))
@unsafe
def Assoc.add(a, -K: Data, -V: Kind(a), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), +key: K, +value: V, map: Assoc<a, K, V>) -> Assoc<a, K, V>:
  match map:
    case Assoc{Nil{}}: Assoc.node(a, K, V, Assoc{Nil{}}, key, value, Assoc{Nil{}})
    case Assoc{Con{pair, rest}}: Assoc.add(a, K, V, cmp, key, value, Assoc.from_rows(a, K, V, cmp, pair <> rest, Assoc{Nil{}}))
    case Assoc.Node{_, left, +k, v, right}: Assoc.add_step(a, K, V, cmp(key, k), cmp, key, value, left, k, v, right)
@unsafe
def Assoc.add_step(a, -K: Data, -V: Kind(a), order: Cmp, cmp: (@+arg0: K -> @+arg1: K -> Cmp), key: K, value: V, left: Assoc<a, K, V>, k: K, v: V, right: Assoc<a, K, V>) -> Assoc<a, K, V>:
  match order:
    case LT{}: Assoc.balance(a, K, V, Assoc.add(a, K, V, cmp, key, value, left), k, v, right)
    case EQ{}: Assoc.node(a, K, V, left, key, value, right)
    case GT{}: Assoc.balance(a, K, V, left, k, v, Assoc.add(a, K, V, cmp, key, value, right))
@unsafe
def Assoc.from_rows(a, -K: Data, -V: Kind(a), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), rows: List<a, Tuple2<&2, a, K, V>>, map: Assoc<a, K, V>) -> Assoc<a, K, V>:
  match rows:
    case Nil{}: map
    case Con{Tup2{k, v}, rest}: Assoc.from_rows(a, K, V, cmp, rest, Assoc.add(a, K, V, cmp, k, v, map))
@unsafe
def Assoc.height(a, -K: Data, -V: Kind(a), map: Assoc<a, K, V>) -> Nat:
  match map:
    case Assoc{_}: 0n
    case Assoc.Node{height, _, _, _, _}: height
@unsafe
def Assoc.node(a, -K: Data, -V: Kind(a), +left: Assoc<a, K, V>, key: K, value: V, +right: Assoc<a, K, V>) -> Assoc<a, K, V>:
  Assoc.Node{(1n + Nat.max(Assoc.height(a, K, V, left), Assoc.height(a, K, V, right)): Nat), left, key, value, right}
@unsafe
def Assoc.rotate_right(a, -K: Data, -V: Kind(a), left: Assoc<a, K, V>, +key: K, +value: V, +right: Assoc<a, K, V>) -> Assoc<a, K, V>:
  match left:
    case Assoc{rows}: Assoc.node(a, K, V, Assoc{rows}, key, value, right)
    case Assoc.Node{_, +ll, +lk, +lv, +lr}:
      Native.choose(a, Assoc<a, K, V>, Nat.is_lt(Assoc.height(a, K, V, ll), Assoc.height(a, K, V, lr)),
        _ => Assoc.rotate_left_right(a, K, V, ll, lk, lv, lr, key, value, right),
        _ => Assoc.node(a, K, V, ll, lk, lv, Assoc.node(a, K, V, lr, key, value, right)))
@unsafe
def Assoc.rotate_left_right(a, -K: Data, -V: Kind(a), ll: Assoc<a, K, V>, lk: K, lv: V, lr: Assoc<a, K, V>, key: K, value: V, right: Assoc<a, K, V>) -> Assoc<a, K, V>:
  match lr:
    case Assoc{rows}: Assoc.node(a, K, V, ll, lk, lv, Assoc.node(a, K, V, Assoc{rows}, key, value, right))
    case Assoc.Node{_, lrl, lrk, lrv, lrr}: Assoc.node(a, K, V, Assoc.node(a, K, V, ll, lk, lv, lrl), lrk, lrv, Assoc.node(a, K, V, lrr, key, value, right))
@unsafe
def Assoc.rotate_left(a, -K: Data, -V: Kind(a), +left: Assoc<a, K, V>, +key: K, +value: V, right: Assoc<a, K, V>) -> Assoc<a, K, V>:
  match right:
    case Assoc{rows}: Assoc.node(a, K, V, left, key, value, Assoc{rows})
    case Assoc.Node{_, +rl, +rk, +rv, +rr}:
      Native.choose(a, Assoc<a, K, V>, Nat.is_lt(Assoc.height(a, K, V, rr), Assoc.height(a, K, V, rl)),
        _ => Assoc.rotate_right_left(a, K, V, left, key, value, rl, rk, rv, rr),
        _ => Assoc.node(a, K, V, Assoc.node(a, K, V, left, key, value, rl), rk, rv, rr))
@unsafe
def Assoc.rotate_right_left(a, -K: Data, -V: Kind(a), left: Assoc<a, K, V>, key: K, value: V, rl: Assoc<a, K, V>, rk: K, rv: V, rr: Assoc<a, K, V>) -> Assoc<a, K, V>:
  match rl:
    case Assoc{rows}: Assoc.node(a, K, V, Assoc.node(a, K, V, left, key, value, Assoc{rows}), rk, rv, rr)
    case Assoc.Node{_, rll, rlk, rlv, rlr}: Assoc.node(a, K, V, Assoc.node(a, K, V, left, key, value, rll), rlk, rlv, Assoc.node(a, K, V, rlr, rk, rv, rr))
@unsafe
def Assoc.balance(a, -K: Data, -V: Kind(a), +left: Assoc<a, K, V>, +key: K, +value: V, +right: Assoc<a, K, V>) -> Assoc<a, K, V>:
  Native.choose(a, Assoc<a, K, V>, Nat.is_lt((Assoc.height(a, K, V, right) + 1n: Nat), Assoc.height(a, K, V, left)),
    _ => Assoc.rotate_right(a, K, V, left, key, value, right),
    _ => Native.choose(a, Assoc<a, K, V>, Nat.is_lt((Assoc.height(a, K, V, left) + 1n: Nat), Assoc.height(a, K, V, right)),
      _ => Assoc.rotate_left(a, K, V, left, key, value, right),
      _ => Assoc.node(a, K, V, left, key, value, right)))
@unsafe
def Assoc.remove_rows(a, -K: Data, -V: Kind(a), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), +key: K, rows: List<a, Tuple2<&2, a, K, V>>) -> List<a, Tuple2<&2, a, K, V>>:
  match rows:
    case Nil{}: Nil{}
    case Con{Tup2{+k, +v}, +rest}: Native.choose(a, List<a, Tuple2<&2, a, K, V>>, Big.order.eq(cmp(key, k)), _ => rest, _ => Tup2{k, v} <> Assoc.remove_rows(a, K, V, cmp, key, rest))
@unsafe
def Assoc.remove(a, -K: Data, -V: Kind(a), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), key: K, map: Assoc<a, K, V>) -> Assoc<a, K, V>: Assoc.from_rows(a, K, V, cmp, Assoc.remove_rows(a, K, V, cmp, key, Assoc.rows(a, K, V, map)), Assoc{Nil{}})
@unsafe
def Assoc.map_rows(a, b, -K: Data, -A: Kind(a), -B: Kind(b), +f: (@+arg0: A -> B), rows: List<a, Tuple2<&2, a, K, A>>) -> List<b, Tuple2<&2, b, K, B>>:
  match rows:
    case Nil{}: Nil{}
    case Con{Tup2{k, v}, rest}: Tup2{k, f(v)} <> Assoc.map_rows(a, b, K, A, B, f, rest)
@unsafe
def Assoc.map(a, b, -K: Data, -A: Kind(a), -B: Kind(b), +f: (@+arg0: A -> B), map: Assoc<a, K, A>) -> Assoc<b, K, B>:
  match map:
    case Assoc{rows}: Assoc{Assoc.map_rows(a, b, K, A, B, f, rows)}
    case Assoc.Node{height, left, key, value, right}: Assoc.Node{height, Assoc.map(a, b, K, A, B, f, left), key, f(value), Assoc.map(a, b, K, A, B, f, right)}
def Assoc.keep(a, -K: Data, -V: Kind(a), key: K, value: Maybe<a, V>, rest: List<a, Tuple2<&2, a, K, V>>) -> List<a, Tuple2<&2, a, K, V>>:
  match value:
    case None{}: rest
    case Some{v}: Tup2{key, v} <> rest
@unsafe
def Assoc.merge_rows(a, b, c, -K: Data, -A: Kind(a), -B: Kind(b), -C: Kind(c), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), +f: (@+arg0: K -> @+arg1: Maybe<a, A> -> @+arg2: Maybe<b, B> -> Maybe<c, C>), xs: List<a, Tuple2<&2, a, K, A>>, ys: List<b, Tuple2<&2, b, K, B>>) -> List<c, Tuple2<&2, c, K, C>>:
  match xs ys:
    case Nil{} Nil{}: Nil{}
    case Con{Tup2{+k, v}, tail} Nil{}: Assoc.keep(c, K, C, k, f(k, Some{v}, None{}), Assoc.merge_rows(a, b, c, K, A, B, C, cmp, f, tail, Nil{}))
    case Nil{} Con{Tup2{+k, v}, tail}: Assoc.keep(c, K, C, k, f(k, None{}, Some{v}), Assoc.merge_rows(a, b, c, K, A, B, C, cmp, f, Nil{}, tail))
    case Con{Tup2{+xk, +xv}, +xt} Con{Tup2{+yk, +yv}, +yt}:
      +order = cmp(xk, yk)
      Native.choose(c, List<c, Tuple2<&2, c, K, C>>, Big.order.lt(order), _ => Assoc.keep(c, K, C, xk, f(xk, Some{xv}, None{}), Assoc.merge_rows(a, b, c, K, A, B, C, cmp, f, xt, Tup2{yk, yv} <> yt)), _ => Native.choose(c, List<c, Tuple2<&2, c, K, C>>, Big.order.eq(order), _ => Assoc.keep(c, K, C, xk, f(xk, Some{xv}, Some{yv}), Assoc.merge_rows(a, b, c, K, A, B, C, cmp, f, xt, yt)), _ => Assoc.keep(c, K, C, yk, f(yk, None{}, Some{yv}), Assoc.merge_rows(a, b, c, K, A, B, C, cmp, f, Tup2{xk, xv} <> xt, yt))))
@unsafe
def Assoc.merge(a, b, c, -K: Data, -A: Kind(a), -B: Kind(b), -C: Kind(c), +cmp: (@+arg0: K -> @+arg1: K -> Cmp), f: (@+arg0: K -> @+arg1: Maybe<a, A> -> @+arg2: Maybe<b, B> -> Maybe<c, C>), xs: Assoc<a, K, A>, ys: Assoc<b, K, B>) -> Assoc<c, K, C>: Assoc.from_rows(c, K, C, cmp, Assoc.merge_rows(a, b, c, K, A, B, C, cmp, f, Assoc.rows(a, K, A, xs), Assoc.rows(b, K, B, ys)), Assoc{Nil{}})
@unsafe
def SeqList.map(a, b, -A: Kind(a), -B: Kind(b), +f: (@+arg0: A -> B), xs: List<a, A>) -> List<b, B>:
  match xs:
    case Nil{}: Nil{}
    case Con{x, tail}: f(x) <> SeqList.map(a, b, A, B, f, tail)
@unsafe
def SeqList.exists(a, -A: Kind(a), +f: (@+arg0: A -> Bool), xs: List<a, A>) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{x, tail}: Big.when(Bool, f(x), _ => True{}, _ => SeqList.exists(a, A, f, tail))
@unsafe
def SeqList.all(a, -A: Kind(a), +f: (@+arg0: A -> Bool), xs: List<a, A>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{x, tail}: Big.when(Bool, f(x), _ => SeqList.all(a, A, f, tail), _ => False{})
@unsafe
def SeqList.fold(a, b, -A: Kind(a), -B: Kind(b), +f: (@+arg0: B -> @+arg1: A -> B), xs: List<a, A>, acc: B) -> B:
  match xs:
    case Nil{}: acc
    case Con{x, tail}: SeqList.fold(a, b, A, B, f, tail, f(acc, x))
@unsafe
def SeqList.drop_while(a, -A: Kind(a), +f: Reusable(A, Bool), xs: List<a, A>) -> List<a, A>:
  match xs:
    case Nil{}: Nil{}
    case Con{+x, +tail}: Native.choose(a, List<a, A>, f(x), _ => SeqList.drop_while(a, A, f, tail), _ => x <> tail)

# Signed machine-integer grammar for the test adapter's stack heights.
law Equal.OptionOf_String_: for +left: OptionOf(String) for +right: OptionOf(String) Bool
law Equal.OptionOf_Global_Entry_: for +left: OptionOf(Global.Entry) for +right: OptionOf(Global.Entry) Bool
law Equal.Global_Entry: for +left: Global.Entry for +right: Global.Entry Bool
law Equal.Global_Def_entry: for +left: Global.Def_entry for +right: Global.Def_entry Bool
law Equal.OptionOf_Big_: for +left: OptionOf(Big) for +right: OptionOf(Big) Bool
law Equal.Term: for +left: Term for +right: Term Bool
law Equal.Shape__2__Term_: for +left: Shape<&2, Term> for +right: Shape<&2, Term> Bool
law Equal.Quantity: for +left: Quantity for +right: Quantity Bool
law Equal.ListOf_Term_: for +left: ListOf(Term) for +right: ListOf(Term) Bool
law Equal.Term_Addr: for +left: Term.Addr for +right: Term.Addr Bool
law Equal.Term_Elim: for +left: Term.Elim for +right: Term.Elim Bool
law Equal.ListOf_TupleOf2_Term_Addr__Term_Leg__: for +left: ListOf(TupleOf2(Term.Addr, Term.Leg)) for +right: ListOf(TupleOf2(Term.Addr, Term.Leg)) Bool
law Equal.TupleOf2_Term_Addr__Term_Leg_: for +left: TupleOf2(Term.Addr, Term.Leg) for +right: TupleOf2(Term.Addr, Term.Leg) Bool
law Equal.Term_Leg: for +left: Term.Leg for +right: Term.Leg Bool
law Equal.ListOf_TupleOf2_Quantity__String__: for +left: ListOf(TupleOf2(Quantity, String)) for +right: ListOf(TupleOf2(Quantity, String)) Bool
law Equal.TupleOf2_Quantity__String_: for +left: TupleOf2(Quantity, String) for +right: TupleOf2(Quantity, String) Bool
law Equal.OptionOf_Term_Motive_: for +left: OptionOf(Term.Motive) for +right: OptionOf(Term.Motive) Bool
law Equal.Term_Motive: for +left: Term.Motive for +right: Term.Motive Bool
law Equal.ListOf_String_: for +left: ListOf(String) for +right: ListOf(String) Bool
law Equal.ListOf_Term_Leg_: for +left: ListOf(Term.Leg) for +right: ListOf(Term.Leg) Bool
law Equal.Literal: for +left: Literal for +right: Literal Bool
law Equal.Global_Axiom_entry: for +left: Global.Axiom_entry for +right: Global.Axiom_entry Bool
law Equal.Global_Prim_entry: for +left: Global.Prim_entry for +right: Global.Prim_entry Bool
law Equal.Prim: for +left: Prim for +right: Prim Bool
law Equal.OptionOf_Positivity_Family_: for +left: OptionOf(Positivity.Family) for +right: OptionOf(Positivity.Family) Bool
law Equal.Positivity_Family: for +left: Positivity.Family for +right: Positivity.Family Bool
law Equal.ListOf_Positivity_Ctor_: for +left: ListOf(Positivity.Ctor) for +right: ListOf(Positivity.Ctor) Bool
law Equal.Positivity_Ctor: for +left: Positivity.Ctor for +right: Positivity.Ctor Bool
law Equal.Positivity_Telescope: for +left: Positivity.Telescope for +right: Positivity.Telescope Bool
law Equal.ListOf_TupleOf3_Quantity__String__Term__: for +left: ListOf(TupleOf3(Quantity, String, Term)) for +right: ListOf(TupleOf3(Quantity, String, Term)) Bool
law Equal.TupleOf3_Quantity__String__Term_: for +left: TupleOf3(Quantity, String, Term) for +right: TupleOf3(Quantity, String, Term) Bool
law Equal.Positivity_Ctor_status: for +left: Positivity.Ctor_status for +right: Positivity.Ctor_status Bool
@unsafe
def Match.Result(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), r, -R: Kind(r), value: Result<q1, q0, A1, A0>, on0: (@+a0:A0 -> R), on1: (@+a0:A1 -> R)) -> R:
  match value:
    case Done{a0}: on0(a0)
    case Fail{a0}: on1(a0)
@unsafe
def Match.Maybe(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: Maybe<q0, A0>, on0: (Unit -> R), on1: (@+a0:A0 -> R)) -> R:
  match value:
    case None{}: on0(Unit{})
    case Some{a0}: on1(a0)
@unsafe
def Match.Tuple2(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), r, -R: Kind(r), value: Tuple2<q0, q1, A0, A1>, on0: (@+a0:A0 -> @+a1:A1 -> R)) -> R:
  match value:
    case Tup2{a0, a1}: on0(a0, a1)
@unsafe
def Match.List(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: List<q0, A0>, on0: (Unit -> R), on1: (@+a0:A0 -> @+a1:List<q0, A0> -> R)) -> R:
  match value:
    case Nil{}: on0(Unit{})
    case Con{a0, a1}: on1(a0, a1)
@unsafe
def Match.Literal(r, -R: Kind(r), value: Literal, on0: (@+a0:String -> R), on1: (@+a0:Bignum -> R)) -> R:
  match value:
    case Literal.LString{a0}: on0(a0)
    case Literal.LInt{a0}: on1(a0)
@unsafe
def Match.List.only_Con(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: List<q0, A0>, on1: (@+a0:A0 -> @+a1:List<q0, A0> -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Con{a0, a1}: on1(a0, a1)
    case _: otherwise(Unit{})
@unsafe
def Match.List.only_Nil(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: List<q0, A0>, on0: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Nil{}: on0(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Tuple3(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2), r, -R: Kind(r), value: Tuple3<q0, q1, q2, A0, A1, A2>, on0: (@+a0:A0 -> @+a1:A1 -> @+a2:A2 -> R)) -> R:
  match value:
    case Tup3{a0, a1, a2}: on0(a0, a1, a2)
@unsafe
def Equal.OptionOf_String_(left, right):
  match left right:
    case None{} None{}: True{}
    case Some{+left689} Some{+right690}: Bool.and(NativeString.equal(left689, right690), True{})
    case _ _: False{}
@unsafe
def Match.Error(r, -R: Kind(r), value: Error, on0: (@+a0:String -> R), on1: (@+a0:String -> @+a1:Big -> @+a2:Big -> R), on2: (@+a0:String -> R), on3: (@+a0:String -> R), on4: (@+a0:String -> R), on5: (@+a0:String -> R), on6: (@+a0:String -> R), on7: (@+a0:String -> R), on8: (@+a0:String -> R), on9: (@+a0:String -> R), on10: (@+a0:String -> R), on11: (@+a0:String -> R), on12: (@+a0:String -> R), on13: (@+a0:String -> R), on14: (@+a0:String -> R)) -> R:
  match value:
    case Error.Not_yet{a0}: on0(a0)
    case Error.Parse{a0, a1, a2}: on1(a0, a1, a2)
    case Error.Carry{a0}: on2(a0)
    case Error.Unbound{a0}: on3(a0)
    case Error.Mismatch{a0}: on4(a0)
    case Error.Universe{a0}: on5(a0)
    case Error.Quantity{a0}: on6(a0)
    case Error.Wrong_leg{a0}: on7(a0)
    case Error.Missing_branch{a0}: on8(a0)
    case Error.Overflow{a0}: on9(a0)
    case Error.Cannot_infer{a0}: on10(a0)
    case Error.Budget_exhausted{a0}: on11(a0)
    case Error.Index_not_zero{a0}: on12(a0)
    case Error.Index_above_universe{a0}: on13(a0)
    case Error.Termination{a0}: on14(a0)
@unsafe
def Match.Prim(r, -R: Kind(r), value: Prim, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R), on3: (Unit -> R), on4: (Unit -> R)) -> R:
  match value:
    case Prim.Nat_add{}: on0(Unit{})
    case Prim.Nat_sub{}: on1(Unit{})
    case Prim.Nat_mul{}: on2(Unit{})
    case Prim.Nat_eq{}: on3(Unit{})
    case Prim.Nat_lt{}: on4(Unit{})
@unsafe
def Get.Global.entries(value: Global) -> Assoc<&2, String, Global.Entry>:
  match value:
    case MkGlobal{field0, _}: field0
@unsafe
def Get.Global.families(value: Global) -> Assoc<&2, String, Positivity.Family>:
  match value:
    case MkGlobal{_, field1}: field1
@unsafe
def Get.Check.Ctx.locals(value: Check.Ctx) -> ListOf(TupleOf3(String, Quantity, Value)):
  match value:
    case MkCheck_Ctx{_, _, field2, _, _}: field2
@unsafe
def Get.Check.Ctx.globals(value: Check.Ctx) -> Global:
  match value:
    case MkCheck_Ctx{field0, _, _, _, _}: field0
@unsafe
def Get.Positivity.Ctor.c_name(value: Positivity.Ctor) -> String:
  match value:
    case MkPositivity_Ctor{field0, _, _, _, _}: field0
@unsafe
def Get.Positivity.Family.f_ctors(value: Positivity.Family) -> ListOf(Positivity.Ctor):
  match value:
    case MkPositivity_Family{_, _, _, _, _, field5, _}: field5
@unsafe
def Get.Positivity.Family.f_params(value: Positivity.Family) -> Positivity.Telescope:
  match value:
    case MkPositivity_Family{_, field1, _, _, _, _, _}: field1
@unsafe
def Get.Positivity.Family.f_name(value: Positivity.Family) -> String:
  match value:
    case MkPositivity_Family{field0, _, _, _, _, _, _}: field0
@unsafe
def Get.Positivity.Family.f_indices(value: Positivity.Family) -> Positivity.Telescope:
  match value:
    case MkPositivity_Family{_, _, field2, _, _, _, _}: field2
@unsafe
def Get.Positivity.Ctor.c_args(value: Positivity.Ctor) -> Positivity.Telescope:
  match value:
    case MkPositivity_Ctor{_, field1, _, _, _}: field1
@unsafe
def Get.Check.Ctx.env(value: Check.Ctx) -> ListOf(Value):
  match value:
    case MkCheck_Ctx{_, field1, _, _, _}: field1
@unsafe
def Match.Term(r, -R: Kind(r), value: Term, on0: (@+a0:Big -> R), on1: (@+a0:Level -> R), on2: (@+a0:Shape<&2, Term> -> @+a1:Term -> R), on3: (@+a0:Shape<&2, Term> -> @+a1:Term -> R), on4: (@+a0:Shape<&2, Term> -> @+a1:Term.Addr -> @+a2:ListOf(Term) -> R), on5: (@+a0:Term.Elim -> R), on6: (@+a0:Shape<&2, Term> -> @+a1:ListOf(Term.Leg) -> R), on7: (@+a0:Shape<&2, Term> -> @+a1:Term.Addr -> @+a2:Term -> R), on8: (@+a0:String -> @+a1:Term -> @+a2:Term -> @+a3:Term -> R), on9: (@+a0:Term -> @+a1:Term -> R), on10: (@+a0:String -> R), on11: (@+a0:Literal -> R), on12: (Unit -> R)) -> R:
  match value:
    case Term.Var{a0}: on0(a0)
    case Term.Univ{a0}: on1(a0)
    case Term.Lan{a0, a1}: on2(a0, a1)
    case Term.Ran{a0, a1}: on3(a0, a1)
    case Term.In{a0, a1, a2}: on4(a0, a1, a2)
    case Term.Elim{a0}: on5(a0)
    case Term.Sec{a0, a1}: on6(a0, a1)
    case Term.Out{a0, a1, a2}: on7(a0, a1, a2)
    case Term.Let{a0, a1, a2, a3}: on8(a0, a1, a2, a3)
    case Term.Ann{a0, a1}: on9(a0, a1)
    case Term.Global{a0}: on10(a0)
    case Term.Lit{a0}: on11(a0)
    case Term.Auto{}: on12(Unit{})
@unsafe
def Match.Shape(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: Shape<q0, A0>, on0: (@+a0:Quantity -> @+a1:String -> @+a2:A0 -> R), on1: (@+a0:Big -> R), on2: (@+a0:A0 -> @+a1:A0 -> R), on3: (@+a0:String -> @+a1:List<q0, A0> -> R), on4: (@+a0:String -> @+a1:List<q0, A0> -> R)) -> R:
  match value:
    case Shape.SPi{a0, a1, a2}: on0(a0, a1, a2)
    case Shape.SColl{a0}: on1(a0)
    case Shape.SPar{a0, a1}: on2(a0, a1)
    case Shape.SMu{a0, a1}: on3(a0, a1)
    case Shape.SNu{a0, a1}: on4(a0, a1)
@unsafe
def Match.Term_Addr(r, -R: Kind(r), value: Term.Addr, on0: (@+a0:Quantity -> @+a1:Term -> R), on1: (@+a0:Big -> R), on2: (@+a0:String -> R)) -> R:
  match value:
    case Term.AddrOf.APt{a0, a1}: on0(a0, a1)
    case Term.AddrOf.ALeg{a0}: on1(a0)
    case Term.AddrOf.ACtor{a0}: on2(a0)
@unsafe
def Get.Term.Elim.e_scrut_q(value: Term.Elim) -> Quantity:
  match value:
    case MkTerm_ElimOf{_, _, field2, _, _}: field2
@unsafe
def Get.Term.Elim.e_motive(value: Term.Elim) -> OptionOf(Term.Motive):
  match value:
    case MkTerm_ElimOf{_, _, _, field3, _}: field3
@unsafe
def Get.Term.Elim.e_branches(value: Term.Elim) -> ListOf(TupleOf2(Term.Addr, Term.Leg)):
  match value:
    case MkTerm_ElimOf{_, _, _, _, field4}: field4
@unsafe
def Get.Rules.Ops.o_bind(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(String, Reusable(Quantity, Reusable(Value, Reusable(A0, A0)))):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, _, field8, _, _, _, _, _, _, _}: field8
@unsafe
def Get.Rules.Ops.o_infer_univ(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Term, CheckResult(Level))):
  match value:
    case MkRules_Ops{_, _, _, field3, _, _, _, _, _, _, _, _, _, _, _, _}: field3
@unsafe
def Get.Rules.Ops.o_eval(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Term, CheckResult(Value))):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, field6, _, _, _, _, _, _, _, _, _}: field6
@unsafe
def Get.Quantity.Usage.paths(value: Quantity.Usage) -> OptionOf(Assoc<&2, Big, Quantity.Interval>):
  match value:
    case MkQuantity_Usage{field0, _}: field0
@unsafe
def Match.Quantity(r, -R: Kind(r), value: Quantity, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R)) -> R:
  match value:
    case Quantity.Zero{}: on0(Unit{})
    case Quantity.One{}: on1(Unit{})
    case Quantity.Many{}: on2(Unit{})
@unsafe
def Get.Quantity.Usage.reads(value: Quantity.Usage) -> Assoc<&2, Big, Quantity.Interval>:
  match value:
    case MkQuantity_Usage{_, field1}: field1
@unsafe
def Get.Rules.Ops.o_check(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Quantity, Reusable(Term, Reusable(Value, CheckResult(Quantity.Usage))))):
  match value:
    case MkRules_Ops{_, field1, _, _, _, _, _, _, _, _, _, _, _, _, _, _}: field1
@unsafe
def Get.Rules.Ops.o_ev(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Rules.Evaluator):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, _, _, _, _, field11, _, _, _, _}: field11
@unsafe
def Get.Value.Closure.env(value: Value.Closure) -> ListOf(Value):
  match value:
    case MkValue_ClosureOf{field0, _}: field0
@unsafe
def Get.Value.Closure.body(value: Value.Closure) -> Term:
  match value:
    case MkValue_ClosureOf{_, field1}: field1
@unsafe
def Get.Rules.Evaluator.ev_eval(value: Rules.Evaluator) -> Reusable(ListOf(Value), Reusable(Term, CheckResult(Value))):
  match value:
    case MkRules_Evaluator{field0}: field0
@unsafe
def Match.Value(r, -R: Kind(r), value: Value, on0: (@+a0:Level -> R), on1: (@+a0:Shape<&2, Value> -> @+a1:Value.Closure -> @+a2:OptionOf(Level) -> R), on2: (@+a0:Shape<&2, Value> -> @+a1:Value.Closure -> @+a2:OptionOf(Level) -> R), on3: (@+a0:Shape<&2, Value> -> @+a1:Value.Vaddr -> @+a2:ListOf(Value) -> R), on4: (@+a0:Shape<&2, Value> -> @+a1:ListOf(Value.Vleg) -> R), on5: (@+a0:Literal -> R), on6: (@+a0:Value.Head -> @+a1:ListOf(Value.Spine) -> R)) -> R:
  match value:
    case Value.VUniv{a0}: on0(a0)
    case Value.VLan{a0, a1, a2}: on1(a0, a1, a2)
    case Value.VRan{a0, a1, a2}: on2(a0, a1, a2)
    case Value.VIn{a0, a1, a2}: on3(a0, a1, a2)
    case Value.VSec{a0, a1}: on4(a0, a1)
    case Value.VLit{a0}: on5(a0)
    case Value.VNeutral{a0, a1}: on6(a0, a1)
@unsafe
def Get.Rules.Ops.o_whnf(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Value, CheckResult(Value))):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, field7, _, _, _, _, _, _, _, _}: field7
@unsafe
def Get.Rules.Ops.o_size(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Big):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, _, _, field9, _, _, _, _, _, _}: field9
@unsafe
def Get.Rules.Ops.o_close(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Big, Reusable(Quantity, Reusable(Quantity.Usage, CheckResult(Quantity.Usage))))):
  match value:
    case MkRules_Ops{_, _, field2, _, _, _, _, _, _, _, _, _, _, _, _, _}: field2
@unsafe
def Get.Term.Leg.l_body(value: Term.Leg) -> Term:
  match value:
    case MkTerm_LegOf{_, field1}: field1
@unsafe
def Get.Rules.Ops.o_env(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, ListOf(Value)):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, _, _, _, field10, _, _, _, _, _}: field10
@unsafe
def Get.Term.Motive.m_body(value: Term.Motive) -> Term:
  match value:
    case MkTerm_MotiveOf{_, _, _, field3}: field3
@unsafe
def Get.Term.Leg.l_binders(value: Term.Leg) -> ListOf(TupleOf2(Quantity, String)):
  match value:
    case MkTerm_LegOf{field0, _}: field0
@unsafe
def Get.Term.Elim.e_scrut(value: Term.Elim) -> Term:
  match value:
    case MkTerm_ElimOf{_, field1, _, _, _}: field1
@unsafe
def Get.Term.Motive.m_self(value: Term.Motive) -> String:
  match value:
    case MkTerm_MotiveOf{_, _, field2, _}: field2
@unsafe
def Get.Rules.Ops.o_infer(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Quantity, Reusable(Term, CheckResult(TupleOf2(Value, Quantity.Usage))))):
  match value:
    case MkRules_Ops{field0, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _}: field0
@unsafe
def Match.Rules_Beta_redex(r, -R: Kind(r), value: Rules.Beta_redex, on0: (@+a0:Shape<&2, Value> -> @+a1:Value.Vaddr -> @+a2:Value -> R), on1: (@+a0:Shape<&2, Value> -> @+a1:ListOf(TupleOf2(Term.Addr, Term.Leg)) -> @+a2:ListOf(Value) -> @+a3:Value -> R)) -> R:
  match value:
    case Rules.Beta_redex.BOut{a0, a1, a2}: on0(a0, a1, a2)
    case Rules.Beta_redex.BElim{a0, a1, a2, a3}: on1(a0, a1, a2, a3)
@unsafe
def Match.Value_Vaddr(r, -R: Kind(r), value: Value.Vaddr, on0: (@+a0:Quantity -> @+a1:Value -> R), on1: (@+a0:Big -> R), on2: (@+a0:String -> R)) -> R:
  match value:
    case Value.VaddrOf.VAPt{a0, a1}: on0(a0, a1)
    case Value.VaddrOf.VALeg{a0}: on1(a0)
    case Value.VaddrOf.VACtor{a0}: on2(a0)
@unsafe
def Get.Value.Vleg.vl_clo(value: Value.Vleg) -> Value.Closure:
  match value:
    case MkValue_VlegOf{_, field1}: field1
@unsafe
def Get.Rules.Ops.o_conv(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Value, Reusable(Value, Reusable(Value, CheckResult(Bool))))):
  match value:
    case MkRules_Ops{_, _, _, _, field4, _, _, _, _, _, _, _, _, _, _, _}: field4
@unsafe
def Get.Rules.Ops.o_quote(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Value, CheckResult(Term))):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, _, _, _, _, _, _, field13, _, _}: field13
@unsafe
def Get.Rules.Ops.o_conv_type(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Value, Reusable(Value, CheckResult(Bool)))):
  match value:
    case MkRules_Ops{_, _, _, _, _, field5, _, _, _, _, _, _, _, _, _, _}: field5
@unsafe
def Get.Positivity.Family.f_level(value: Positivity.Family) -> Level:
  match value:
    case MkPositivity_Family{_, _, _, field3, _, _, _}: field3
@unsafe
def Get.Tuple2.v0(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), value: Tuple2<q0, q1, A0, A1>) -> A0:
  match value:
    case Tup2{field0, _}: field0
@unsafe
def Get.Positivity.Family.f_status(value: Positivity.Family) -> Positivity.Ctor_status:
  match value:
    case MkPositivity_Family{_, _, _, _, field4, _, _}: field4
@unsafe
def Match.Positivity_Ctor_status(r, -R: Kind(r), value: Positivity.Ctor_status, on0: (Unit -> R), on1: (Unit -> R), on2: (@+a0:ListOf(String) -> R)) -> R:
  match value:
    case Positivity.Ctor_status.Provisional{}: on0(Unit{})
    case Positivity.Ctor_status.Builtin{}: on1(Unit{})
    case Positivity.Ctor_status.Complete{a0}: on2(a0)
@unsafe
def Get.Positivity.Family.f_positive(value: Positivity.Family) -> Bool:
  match value:
    case MkPositivity_Family{_, _, _, _, _, _, field6}: field6
@unsafe
def Get.Rules.Ops.o_family(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(String, OptionOf(Positivity.Family))):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, field15}: field15
@unsafe
def Get.Positivity.Ctor.c_res_idx(value: Positivity.Ctor) -> ListOf(Term):
  match value:
    case MkPositivity_Ctor{_, _, field2, _, _}: field2
@unsafe
def Get.Rules.Ops.o_pp(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Value, String)):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, _, _, _, _, _, field12, _, _, _}: field12
@unsafe
def Get.Positivity.Ctor.c_self_rec(value: Positivity.Ctor) -> Bool:
  match value:
    case MkPositivity_Ctor{_, _, _, _, field4}: field4
@unsafe
def Get.Term.Motive.m_idx(value: Term.Motive) -> ListOf(String):
  match value:
    case MkTerm_MotiveOf{_, field1, _, _}: field1
@unsafe
def Get.Term.Motive.m_ind(value: Term.Motive) -> OptionOf(String):
  match value:
    case MkTerm_MotiveOf{field0, _, _, _}: field0
@unsafe
def Get.Rules.Rule_pack.beta(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Evaluator, Reusable(Rules.Beta_redex, CheckResult(OptionOf(Value)))):
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, field6, _, _, _, _, _, _, _, _, _, _}: field6
@unsafe
def Get.Term.Elim.e_shape(value: Term.Elim) -> Shape<&2, Term>:
  match value:
    case MkTerm_ElimOf{field0, _, _, _, _}: field0
@unsafe
def Match.Value_Head(r, -R: Kind(r), value: Value.Head, on0: (@+a0:Big -> R), on1: (@+a0:String -> R)) -> R:
  match value:
    case Value.Head.HLocal{a0}: on0(a0)
    case Value.Head.HGlobal{a0}: on1(a0)
@unsafe
def Match.Global_Entry(r, -R: Kind(r), value: Global.Entry, on0: (@+a0:Global.Def_entry -> R), on1: (@+a0:Global.Axiom_entry -> R), on2: (@+a0:Global.Prim_entry -> R)) -> R:
  match value:
    case Global.Entry.Def{a0}: on0(a0)
    case Global.Entry.Axiom{a0}: on1(a0)
    case Global.Entry.Prim{a0}: on2(a0)
@unsafe
def Get.Global.Def_entry.reducible(value: Global.Def_entry) -> Bool:
  match value:
    case MkGlobal_Def_entry{_, _, field2, _, _}: field2
@unsafe
def Get.Global.Def_entry.def(value: Global.Def_entry) -> Term:
  match value:
    case MkGlobal_Def_entry{_, field1, _, _, _}: field1
@unsafe
def Get.Global.Def_entry.rec_arg(value: Global.Def_entry) -> OptionOf(Big):
  match value:
    case MkGlobal_Def_entry{_, _, _, field3, _}: field3
@unsafe
def Match.Value_Spine(r, -R: Kind(r), value: Value.Spine, on0: (@+a0:Shape<&2, Value> -> @+a1:Value.Vaddr -> R), on1: (@+a0:Value.Stuck_elim -> R)) -> R:
  match value:
    case Value.SpineOf.SOut{a0, a1}: on0(a0, a1)
    case Value.SpineOf.SElim{a0}: on1(a0)
@unsafe
def Get.Value.Stuck_elim.s_shape(value: Value.Stuck_elim) -> Shape<&2, Value>:
  match value:
    case MkValue_Stuck_elimOf{field0, _, _, _, _}: field0
@unsafe
def Get.Value.Stuck_elim.s_scrut_q(value: Value.Stuck_elim) -> Quantity:
  match value:
    case MkValue_Stuck_elimOf{_, field1, _, _, _}: field1
@unsafe
def Get.Value.Stuck_elim.s_motive(value: Value.Stuck_elim) -> OptionOf(Term.Motive):
  match value:
    case MkValue_Stuck_elimOf{_, _, field2, _, _}: field2
@unsafe
def Get.Value.Stuck_elim.s_branches(value: Value.Stuck_elim) -> ListOf(TupleOf2(Term.Addr, Term.Leg)):
  match value:
    case MkValue_Stuck_elimOf{_, _, _, field3, _}: field3
@unsafe
def Get.Value.Stuck_elim.s_env(value: Value.Stuck_elim) -> ListOf(Value):
  match value:
    case MkValue_Stuck_elimOf{_, _, _, _, field4}: field4
@unsafe
def Get.Global.Prim_entry.prim(value: Global.Prim_entry) -> Prim:
  match value:
    case MkGlobal_Prim_entry{_, field1}: field1
@unsafe
def Get.Check.Ctx.size(value: Check.Ctx) -> Big:
  match value:
    case MkCheck_Ctx{_, _, _, field3, _}: field3
@unsafe
def Get.Rules.Rule_pack.diagram_arity(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Shape<&2, Value>, Big):
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, _, _, field8, _, _, _, _, _, _, _, _}: field8
@unsafe
def Get.Value.Vleg.vl_binders(value: Value.Vleg) -> ListOf(TupleOf2(Quantity, String)):
  match value:
    case MkValue_VlegOf{field0, _}: field0
@unsafe
def Get.Check.Ctx.budget(value: Check.Ctx) -> Budget:
  match value:
    case MkCheck_Ctx{_, _, _, _, field4}: field4
@unsafe
def Get.Budget.poll(value: Budget) -> Reusable(Unit, Bool):
  match value:
    case MkBudget{field0}: field0
@unsafe
def Get.Rules.Rule_pack.form_lan(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Term>, Reusable(Term, Reusable(OptionOf(Level), CheckResult(Level)))))):
  match value:
    case MkRules_Rule_pack{field0, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _}: field0
@unsafe
def Get.Rules.Rule_pack.form_ran(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Term>, Reusable(Term, Reusable(OptionOf(Level), CheckResult(Level)))))):
  match value:
    case MkRules_Rule_pack{_, field1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _}: field1
@unsafe
def Get.Rules.Rule_pack.elim_elim(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Quantity, Reusable(Term.Elim, Reusable(OptionOf(Value), CheckResult(TupleOf2(Value, Quantity.Usage))))))):
  match value:
    case MkRules_Rule_pack{_, _, _, field3, _, _, _, _, _, _, _, _, _, _, _, _, _}: field3
@unsafe
def Get.Rules.Rule_pack.elim_out(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Quantity, Reusable(Shape<&2, Term>, Reusable(Term.Addr, Reusable(Term, CheckResult(TupleOf2(Value, Quantity.Usage)))))))):
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, field5, _, _, _, _, _, _, _, _, _, _, _}: field5
@unsafe
def Match.Conv_Side(r, -R: Kind(r), value: Conv.Side, on0: (Unit -> R), on1: (Unit -> R)) -> R:
  match value:
    case Conv.Side.Right{}: on0(Unit{})
    case Conv.Side.Left{}: on1(Unit{})
@unsafe
def Get.Rules.Rule_pack.ann_lvl_eq(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Shape<&2, Value>, Reusable(OptionOf(Level), Reusable(OptionOf(Level), Bool))):
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, _, _, _, _, _, _, _, field13, _, _, _}: field13
@unsafe
def Get.Rules.Rule_pack.conv_diagram(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, Reusable(Value.Closure, Reusable(Value.Closure, CheckResult(Bool)))))):
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, _, _, _, _, _, _, field12, _, _, _, _}: field12
@unsafe
def Get.Tuple2.v1(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), value: Tuple2<q0, q1, A0, A1>) -> A1:
  match value:
    case Tup2{_, field1}: field1
@unsafe
def Get.Rules.Rule_pack.spine_ty(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, Reusable(Value.Closure, Reusable(Value.Vaddr, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value)))))))):
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, _, _, _, field9, _, _, _, _, _, _, _}: field9
@unsafe
def Get.Rules.Ops.o_head_ty(-q0: Quant, -A0: Kind(q0), value: Rules.Ops<q0, A0>) -> Reusable(A0, Reusable(Value.Head, CheckResult(Value))):
  match value:
    case MkRules_Ops{_, _, _, _, _, _, _, _, _, _, _, _, _, _, field14, _}: field14
@unsafe
def Get.Rules.Rule_pack.eta(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Rules.Eta_row:
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, _, field7, _, _, _, _, _, _, _, _, _}: field7
@unsafe
def Get.Rules.Eta_row.eta_ran(value: Rules.Eta_row) -> Bool:
  match value:
    case MkRules_Eta_row{field0, _}: field0
@unsafe
def Get.Rules.Rule_pack.expand_ran(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Maybe<&1, Rules.Expansion(q0, A0)>:
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, _, _, _, _, field10, _, _, _, _, _, _}: field10
@unsafe
def Get.Rules.Eta_row.eta_lan(value: Rules.Eta_row) -> Bool:
  match value:
    case MkRules_Eta_row{_, field1}: field1
@unsafe
def Get.Rules.Rule_pack.expand_lan(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Maybe<&1, Rules.Expansion(q0, A0)>:
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, _, _, _, _, _, field11, _, _, _, _, _}: field11
@unsafe
def Get.Rules.Rule_pack.subsingleton(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Shape<&2, Value>, CheckResult(Bool)))):
  match value:
    case MkRules_Rule_pack{_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, field16}: field16
@unsafe
def Get.Rules.Rule_pack.intro_in(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Quantity, Reusable(Shape<&2, Term>, Reusable(Term.Addr, Reusable(ListOf(Term), Reusable(Value, CheckResult(Quantity.Usage)))))))):
  match value:
    case MkRules_Rule_pack{_, _, field2, _, _, _, _, _, _, _, _, _, _, _, _, _, _}: field2
@unsafe
def Get.Rules.Rule_pack.intro_sec(-q0: Quant, -A0: Kind(q0), value: Rules.Rule_pack<q0, A0>) -> Reusable(Rules.Ops<q0, A0>, Reusable(A0, Reusable(Quantity, Reusable(Shape<&2, Term>, Reusable(ListOf(Term.Leg), Reusable(Value, CheckResult(Quantity.Usage))))))):
  match value:
    case MkRules_Rule_pack{_, _, _, _, field4, _, _, _, _, _, _, _, _, _, _, _, _}: field4
@unsafe
def Get.Global.Def_entry.ty(value: Global.Def_entry) -> Term:
  match value:
    case MkGlobal_Def_entry{field0, _, _, _, _}: field0
@unsafe
def Get.Global.Axiom_entry.ax_ty(value: Global.Axiom_entry) -> Term:
  match value:
    case MkGlobal_Axiom_entry{field0}: field0
@unsafe
def Get.Global.Prim_entry.p_ty(value: Global.Prim_entry) -> Term:
  match value:
    case MkGlobal_Prim_entry{field0, _}: field0
@unsafe
def Match.Tuple4(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2), -q3: Quant, -A3: Kind(q3), r, -R: Kind(r), value: Tuple4<q0, q1, q2, q3, A0, A1, A2, A3>, on0: (@+a0:A0 -> @+a1:A1 -> @+a2:A2 -> @+a3:A3 -> R)) -> R:
  match value:
    case Tup4{a0, a1, a2, a3}: on0(a0, a1, a2, a3)
@unsafe
def Get.Check.Decl.d_name(value: Check.Decl) -> String:
  match value:
    case MkCheck_Decl{field0, _, _, _}: field0
@unsafe
def Get.Check.Decl.d_kind(value: Check.Decl) -> Check.Kind:
  match value:
    case MkCheck_Decl{_, field1, _, _}: field1
@unsafe
def Match.Check_Kind(r, -R: Kind(r), value: Check.Kind, on0: (Unit -> R), on1: (Unit -> R)) -> R:
  match value:
    case Check.Kind.Definition{}: on0(Unit{})
    case Check.Kind.Postulate{}: on1(Unit{})
@unsafe
def Get.Check.Decl.d_ty(value: Check.Decl) -> Term:
  match value:
    case MkCheck_Decl{_, _, field2, _}: field2
@unsafe
def Get.Check.Decl.d_body(value: Check.Decl) -> OptionOf(Term):
  match value:
    case MkCheck_Decl{_, _, _, field3}: field3
@unsafe
def Get.Check.Family_decl.fam_params(value: Check.Family_decl) -> Positivity.Telescope:
  match value:
    case MkCheck_Family_decl{_, field1, _, _}: field1
@unsafe
def Get.Check.Family_decl.fam_name(value: Check.Family_decl) -> String:
  match value:
    case MkCheck_Family_decl{field0, _, _, _}: field0
@unsafe
def Get.Check.Family_decl.fam_level(value: Check.Family_decl) -> Level:
  match value:
    case MkCheck_Family_decl{_, _, _, field3}: field3
@unsafe
def Get.Check.Family_decl.fam_indices(value: Check.Family_decl) -> Positivity.Telescope:
  match value:
    case MkCheck_Family_decl{_, _, field2, _}: field2
@unsafe
def Get.Check.Ctor_decl.ct_name(value: Check.Ctor_decl) -> String:
  match value:
    case MkCheck_Ctor_decl{field0, _, _, _}: field0
@unsafe
def Get.Check.Ctor_decl.ct_args(value: Check.Ctor_decl) -> Positivity.Telescope:
  match value:
    case MkCheck_Ctor_decl{_, field1, _, _}: field1
@unsafe
def Get.Check.Ctor_decl.ct_res_idx(value: Check.Ctor_decl) -> ListOf(Term):
  match value:
    case MkCheck_Ctor_decl{_, _, _, field3}: field3
@unsafe
def Get.Check.Ctor_decl.ct_res_params(value: Check.Ctor_decl) -> ListOf(Term):
  match value:
    case MkCheck_Ctor_decl{_, _, field2, _}: field2
@unsafe
def Match.Order_Status(r, -R: Kind(r), value: Order.Status, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R)) -> R:
  match value:
    case Order.Status.Principal{}: on0(Unit{})
    case Order.Status.Smaller{}: on1(Unit{})
    case Order.Status.Other{}: on2(Unit{})
@unsafe
def Match.Order_Rule(r, -R: Kind(r), value: Order.Rule, on0: (Unit -> R)) -> R:
  match value:
    case Order.Rule.Structural{}: on0(Unit{})
@unsafe
def Get.Order.o_group(value: Order) -> ListOf(String):
  match value:
    case MkOrder{field0, _, _}: field0
@unsafe
def Get.Order.Call.cl_chain(value: Order.Call) -> ListOf(Order.Step):
  match value:
    case MkOrder_Call{_, field1}: field1
@unsafe
def Get.Order.Row.rw_member(value: Order.Row) -> String:
  match value:
    case MkOrder_Row{field0, _}: field0
@unsafe
def Get.Order.Step.st_ctor(value: Order.Step) -> OptionOf(String):
  match value:
    case MkOrder_Step{_, field1}: field1
@unsafe
def Get.Order.Row.rw_calls(value: Order.Row) -> ListOf(Order.Call):
  match value:
    case MkOrder_Row{_, field1}: field1
@unsafe
def Get.Order.o_rows(value: Order) -> ListOf(Order.Row):
  match value:
    case MkOrder{_, _, field2}: field2
@unsafe
def Get.Order.o_arg(value: Order) -> Big:
  match value:
    case MkOrder{_, field1, _}: field1
@unsafe
def Equal.OptionOf_Global_Entry_(left, right):
  match left right:
    case None{} None{}: True{}
    case Some{+left8151} Some{+right8152}: Bool.and(Equal.Global_Entry(left8151, right8152), True{})
    case _ _: False{}
@unsafe
def Equal.Global_Entry(left, right):
  match left right:
    case Global.Entry.Def{+left8153} Global.Entry.Def{+right8154}: Bool.and(Equal.Global_Def_entry(left8153, right8154), True{})
    case Global.Entry.Axiom{+left8297} Global.Entry.Axiom{+right8298}: Bool.and(Equal.Global_Axiom_entry(left8297, right8298), True{})
    case Global.Entry.Prim{+left8301} Global.Entry.Prim{+right8302}: Bool.and(Equal.Global_Prim_entry(left8301, right8302), True{})
    case _ _: False{}
@unsafe
def Equal.Global_Def_entry(left, right):
  match left right:
    case MkGlobal_Def_entry{+left8155, +left8156, +left8157, +left8158, +left8159} MkGlobal_Def_entry{+right8160, +right8161, +right8162, +right8163, +right8164}: Bool.and(Equal.Term(left8155, right8160), Bool.and(Equal.Term(left8156, right8161), Bool.and(Bool.not(Bool.xor(left8157, right8162)), Bool.and(Equal.OptionOf_Big_(left8158, right8163), Bool.and(Bool.not(Bool.xor(left8159, right8164)), True{})))))
@unsafe
def Equal.OptionOf_Big_(left, right):
  match left right:
    case None{} None{}: True{}
    case Some{+left8165} Some{+right8166}: Bool.and(Big.is_eq(left8165, right8166), True{})
    case _ _: False{}
@unsafe
def Equal.Term(left, right):
  match left right:
    case Term.Var{+left8167} Term.Var{+right8168}: Bool.and(Big.is_eq(left8167, right8168), True{})
    case Term.Univ{+left8169} Term.Univ{+right8170}: Bool.and(Big.is_eq(left8169, right8170), True{})
    case Term.Lan{+left8171, +left8172} Term.Lan{+right8173, +right8174}: Bool.and(Equal.Shape__2__Term_(left8171, right8173), Bool.and(Equal.Term(left8172, right8174), True{}))
    case Term.Ran{+left8199, +left8200} Term.Ran{+right8201, +right8202}: Bool.and(Equal.Shape__2__Term_(left8199, right8201), Bool.and(Equal.Term(left8200, right8202), True{}))
    case Term.In{+left8203, +left8204, +left8205} Term.In{+right8206, +right8207, +right8208}: Bool.and(Equal.Shape__2__Term_(left8203, right8206), Bool.and(Equal.Term_Addr(left8204, right8207), Bool.and(Equal.ListOf_Term_(left8205, right8208), True{})))
    case Term.Elim{+left8217} Term.Elim{+right8218}: Bool.and(Equal.Term_Elim(left8217, right8218), True{})
    case Term.Sec{+left8263, +left8264} Term.Sec{+right8265, +right8266}: Bool.and(Equal.Shape__2__Term_(left8263, right8265), Bool.and(Equal.ListOf_Term_Leg_(left8264, right8266), True{}))
    case Term.Out{+left8271, +left8272, +left8273} Term.Out{+right8274, +right8275, +right8276}: Bool.and(Equal.Shape__2__Term_(left8271, right8274), Bool.and(Equal.Term_Addr(left8272, right8275), Bool.and(Equal.Term(left8273, right8276), True{})))
    case Term.Let{+left8277, +left8278, +left8279, +left8280} Term.Let{+right8281, +right8282, +right8283, +right8284}: Bool.and(NativeString.equal(left8277, right8281), Bool.and(Equal.Term(left8278, right8282), Bool.and(Equal.Term(left8279, right8283), Bool.and(Equal.Term(left8280, right8284), True{}))))
    case Term.Ann{+left8285, +left8286} Term.Ann{+right8287, +right8288}: Bool.and(Equal.Term(left8285, right8287), Bool.and(Equal.Term(left8286, right8288), True{}))
    case Term.Global{+left8289} Term.Global{+right8290}: Bool.and(NativeString.equal(left8289, right8290), True{})
    case Term.Lit{+left8291} Term.Lit{+right8292}: Bool.and(Equal.Literal(left8291, right8292), True{})
    case Term.Auto{} Term.Auto{}: True{}
    case _ _: False{}
@unsafe
def Equal.Shape__2__Term_(left, right):
  match left right:
    case Shape.SPi{+left8175, +left8176, +left8177} Shape.SPi{+right8178, +right8179, +right8180}: Bool.and(Equal.Quantity(left8175, right8178), Bool.and(NativeString.equal(left8176, right8179), Bool.and(Equal.Term(left8177, right8180), True{})))
    case Shape.SColl{+left8181} Shape.SColl{+right8182}: Bool.and(Big.is_eq(left8181, right8182), True{})
    case Shape.SPar{+left8183, +left8184} Shape.SPar{+right8185, +right8186}: Bool.and(Equal.Term(left8183, right8185), Bool.and(Equal.Term(left8184, right8186), True{}))
    case Shape.SMu{+left8187, +left8188} Shape.SMu{+right8189, +right8190}: Bool.and(NativeString.equal(left8187, right8189), Bool.and(Equal.ListOf_Term_(left8188, right8190), True{}))
    case Shape.SNu{+left8195, +left8196} Shape.SNu{+right8197, +right8198}: Bool.and(NativeString.equal(left8195, right8197), Bool.and(Equal.ListOf_Term_(left8196, right8198), True{}))
    case _ _: False{}
@unsafe
def Equal.Quantity(left, right):
  match left right:
    case Quantity.Zero{} Quantity.Zero{}: True{}
    case Quantity.One{} Quantity.One{}: True{}
    case Quantity.Many{} Quantity.Many{}: True{}
    case _ _: False{}
@unsafe
def Equal.ListOf_Term_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left8191, +left8192} Con{+right8193, +right8194}: Bool.and(Equal.Term(left8191, right8193), Bool.and(Equal.ListOf_Term_(left8192, right8194), True{}))
    case _ _: False{}
@unsafe
def Equal.Term_Addr(left, right):
  match left right:
    case Term.AddrOf.APt{+left8209, +left8210} Term.AddrOf.APt{+right8211, +right8212}: Bool.and(Equal.Quantity(left8209, right8211), Bool.and(Equal.Term(left8210, right8212), True{}))
    case Term.AddrOf.ALeg{+left8213} Term.AddrOf.ALeg{+right8214}: Bool.and(Big.is_eq(left8213, right8214), True{})
    case Term.AddrOf.ACtor{+left8215} Term.AddrOf.ACtor{+right8216}: Bool.and(NativeString.equal(left8215, right8216), True{})
    case _ _: False{}
@unsafe
def Equal.Term_Elim(left, right):
  match left right:
    case MkTerm_ElimOf{+left8219, +left8220, +left8221, +left8222, +left8223} MkTerm_ElimOf{+right8224, +right8225, +right8226, +right8227, +right8228}: Bool.and(Equal.Shape__2__Term_(left8219, right8224), Bool.and(Equal.Term(left8220, right8225), Bool.and(Equal.Quantity(left8221, right8226), Bool.and(Equal.OptionOf_Term_Motive_(left8222, right8227), Bool.and(Equal.ListOf_TupleOf2_Term_Addr__Term_Leg__(left8223, right8228), True{})))))
@unsafe
def Equal.ListOf_TupleOf2_Term_Addr__Term_Leg__(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left8229, +left8230} Con{+right8231, +right8232}: Bool.and(Equal.TupleOf2_Term_Addr__Term_Leg_(left8229, right8231), Bool.and(Equal.ListOf_TupleOf2_Term_Addr__Term_Leg__(left8230, right8232), True{}))
    case _ _: False{}
@unsafe
def Equal.TupleOf2_Term_Addr__Term_Leg_(left, right):
  match left right:
    case Tup2{+left8233, +left8234} Tup2{+right8235, +right8236}: Bool.and(Equal.Term_Addr(left8233, right8235), Bool.and(Equal.Term_Leg(left8234, right8236), True{}))
@unsafe
def Equal.Term_Leg(left, right):
  match left right:
    case MkTerm_LegOf{+left8237, +left8238} MkTerm_LegOf{+right8239, +right8240}: Bool.and(Equal.ListOf_TupleOf2_Quantity__String__(left8237, right8239), Bool.and(Equal.Term(left8238, right8240), True{}))
@unsafe
def Equal.ListOf_TupleOf2_Quantity__String__(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left8241, +left8242} Con{+right8243, +right8244}: Bool.and(Equal.TupleOf2_Quantity__String_(left8241, right8243), Bool.and(Equal.ListOf_TupleOf2_Quantity__String__(left8242, right8244), True{}))
    case _ _: False{}
@unsafe
def Equal.TupleOf2_Quantity__String_(left, right):
  match left right:
    case Tup2{+left8245, +left8246} Tup2{+right8247, +right8248}: Bool.and(Equal.Quantity(left8245, right8247), Bool.and(NativeString.equal(left8246, right8248), True{}))
@unsafe
def Equal.OptionOf_Term_Motive_(left, right):
  match left right:
    case None{} None{}: True{}
    case Some{+left8249} Some{+right8250}: Bool.and(Equal.Term_Motive(left8249, right8250), True{})
    case _ _: False{}
@unsafe
def Equal.Term_Motive(left, right):
  match left right:
    case MkTerm_MotiveOf{+left8251, +left8252, +left8253, +left8254} MkTerm_MotiveOf{+right8255, +right8256, +right8257, +right8258}: Bool.and(Equal.OptionOf_String_(left8251, right8255), Bool.and(Equal.ListOf_String_(left8252, right8256), Bool.and(NativeString.equal(left8253, right8257), Bool.and(Equal.Term(left8254, right8258), True{}))))
@unsafe
def Equal.ListOf_String_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left8259, +left8260} Con{+right8261, +right8262}: Bool.and(NativeString.equal(left8259, right8261), Bool.and(Equal.ListOf_String_(left8260, right8262), True{}))
    case _ _: False{}
@unsafe
def Equal.ListOf_Term_Leg_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left8267, +left8268} Con{+right8269, +right8270}: Bool.and(Equal.Term_Leg(left8267, right8269), Bool.and(Equal.ListOf_Term_Leg_(left8268, right8270), True{}))
    case _ _: False{}
@unsafe
def Equal.Literal(left, right):
  match left right:
    case Literal.LString{+left8293} Literal.LString{+right8294}: Bool.and(NativeString.equal(left8293, right8294), True{})
    case Literal.LInt{+left8295} Literal.LInt{+right8296}: Bool.and(Big.is_eq(left8295, right8296), True{})
    case _ _: False{}
@unsafe
def Equal.Global_Axiom_entry(left, right):
  match left right:
    case MkGlobal_Axiom_entry{+left8299} MkGlobal_Axiom_entry{+right8300}: Bool.and(Equal.Term(left8299, right8300), True{})
@unsafe
def Equal.Global_Prim_entry(left, right):
  match left right:
    case MkGlobal_Prim_entry{+left8303, +left8304} MkGlobal_Prim_entry{+right8305, +right8306}: Bool.and(Equal.Term(left8303, right8305), Bool.and(Equal.Prim(left8304, right8306), True{}))
@unsafe
def Equal.Prim(left, right):
  match left right:
    case Prim.Nat_add{} Prim.Nat_add{}: True{}
    case Prim.Nat_sub{} Prim.Nat_sub{}: True{}
    case Prim.Nat_mul{} Prim.Nat_mul{}: True{}
    case Prim.Nat_eq{} Prim.Nat_eq{}: True{}
    case Prim.Nat_lt{} Prim.Nat_lt{}: True{}
    case _ _: False{}
@unsafe
def Equal.OptionOf_Positivity_Family_(left, right):
  match left right:
    case None{} None{}: True{}
    case Some{+left8314} Some{+right8315}: Bool.and(Equal.Positivity_Family(left8314, right8315), True{})
    case _ _: False{}
@unsafe
def Equal.Positivity_Family(left, right):
  match left right:
    case MkPositivity_Family{+left8316, +left8317, +left8318, +left8319, +left8320, +left8321, +left8322} MkPositivity_Family{+right8323, +right8324, +right8325, +right8326, +right8327, +right8328, +right8329}: Bool.and(NativeString.equal(left8316, right8323), Bool.and(Equal.Positivity_Telescope(left8317, right8324), Bool.and(Equal.Positivity_Telescope(left8318, right8325), Bool.and(Big.is_eq(left8319, right8326), Bool.and(Equal.Positivity_Ctor_status(left8320, right8327), Bool.and(Equal.ListOf_Positivity_Ctor_(left8321, right8328), Bool.and(Bool.not(Bool.xor(left8322, right8329)), True{})))))))
@unsafe
def Equal.ListOf_Positivity_Ctor_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left8330, +left8331} Con{+right8332, +right8333}: Bool.and(Equal.Positivity_Ctor(left8330, right8332), Bool.and(Equal.ListOf_Positivity_Ctor_(left8331, right8333), True{}))
    case _ _: False{}
@unsafe
def Equal.Positivity_Ctor(left, right):
  match left right:
    case MkPositivity_Ctor{+left8334, +left8335, +left8336, +left8337, +left8338} MkPositivity_Ctor{+right8339, +right8340, +right8341, +right8342, +right8343}: Bool.and(NativeString.equal(left8334, right8339), Bool.and(Equal.Positivity_Telescope(left8335, right8340), Bool.and(Equal.ListOf_Term_(left8336, right8341), Bool.and(Big.is_eq(left8337, right8342), Bool.and(Bool.not(Bool.xor(left8338, right8343)), True{})))))
@unsafe
def Equal.Positivity_Telescope(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left8344, +left8345} Con{+right8346, +right8347}: Bool.and(Equal.TupleOf3_Quantity__String__Term_(left8344, right8346), Bool.and(Equal.ListOf_TupleOf3_Quantity__String__Term__(left8345, right8347), True{}))
    case _ _: False{}
@unsafe
def Equal.ListOf_TupleOf3_Quantity__String__Term__(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left8348, +left8349} Con{+right8350, +right8351}: Bool.and(Equal.TupleOf3_Quantity__String__Term_(left8348, right8350), Bool.and(Equal.ListOf_TupleOf3_Quantity__String__Term__(left8349, right8351), True{}))
    case _ _: False{}
@unsafe
def Equal.TupleOf3_Quantity__String__Term_(left, right):
  match left right:
    case Tup3{+left8352, +left8353, +left8354} Tup3{+right8355, +right8356, +right8357}: Bool.and(Equal.Quantity(left8352, right8355), Bool.and(NativeString.equal(left8353, right8356), Bool.and(Equal.Term(left8354, right8357), True{})))
@unsafe
def Equal.Positivity_Ctor_status(left, right):
  match left right:
    case Positivity.Ctor_status.Provisional{} Positivity.Ctor_status.Provisional{}: True{}
    case Positivity.Ctor_status.Builtin{} Positivity.Ctor_status.Builtin{}: True{}
    case Positivity.Ctor_status.Complete{+left8358} Positivity.Ctor_status.Complete{+right8359}: Bool.and(Equal.ListOf_String_(left8358, right8359), True{})
    case _ _: False{}
@unsafe
def Match.Shape.only_Shape_SColl(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: Shape<q0, A0>, on1: (@+a0:Big -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Shape.SColl{a0}: on1(a0)
    case _: otherwise(Unit{})
@unsafe
def Match.Term.only_Term_Global(r, -R: Kind(r), value: Term, on10: (@+a0:String -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Term.Global{a0}: on10(a0)
    case _: otherwise(Unit{})
@unsafe
def Match.Term.only_Term_Ran(r, -R: Kind(r), value: Term, on3: (@+a0:Shape<&2, Term> -> @+a1:Term -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Term.Ran{a0, a1}: on3(a0, a1)
    case _: otherwise(Unit{})
@unsafe
def Match.Term.only_Term_Sec(r, -R: Kind(r), value: Term, on6: (@+a0:Shape<&2, Term> -> @+a1:ListOf(Term.Leg) -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Term.Sec{a0, a1}: on6(a0, a1)
    case _: otherwise(Unit{})
@unsafe
def Match.Term.only_Term_Univ(r, -R: Kind(r), value: Term, on1: (@+a0:Level -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Term.Univ{a0}: on1(a0)
    case _: otherwise(Unit{})
@unsafe
def Match.Shape.only_Shape_SPi(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: Shape<q0, A0>, on0: (@+a0:Quantity -> @+a1:String -> @+a2:A0 -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Shape.SPi{a0, a1, a2}: on0(a0, a1, a2)
    case _: otherwise(Unit{})
@unsafe
def Match.Quantity.only_Quantity_One_Quantity_Many(r, -R: Kind(r), value: Quantity, on1: (Unit -> R), on2: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Quantity.One{}: on1(Unit{})
    case Quantity.Many{}: on2(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Term.only_Term_Lan(r, -R: Kind(r), value: Term, on2: (@+a0:Shape<&2, Term> -> @+a1:Term -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Term.Lan{a0, a1}: on2(a0, a1)
    case _: otherwise(Unit{})
@unsafe
def Match.Shape.only_Shape_SMu(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: Shape<q0, A0>, on3: (@+a0:String -> @+a1:List<q0, A0> -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Shape.SMu{a0, a1}: on3(a0, a1)
    case _: otherwise(Unit{})
@unsafe
def Match.Tuple5(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2), -q3: Quant, -A3: Kind(q3), -q4: Quant, -A4: Kind(q4), r, -R: Kind(r), value: Tuple5<q0, q1, q2, q3, q4, A0, A1, A2, A3, A4>, on0: (@+a0:A0 -> @+a1:A1 -> @+a2:A2 -> @+a3:A3 -> @+a4:A4 -> R)) -> R:
  match value:
    case Tup5{a0, a1, a2, a3, a4}: on0(a0, a1, a2, a3, a4)
@unsafe
def Match.Series(-q0: Quant, -A0: Kind(q0), r, -R: Kind(r), value: Series<q0, A0>, on0: (Unit -> R), on1: (@+a0:A0 -> @+a1:(Unit -> Series<q0, A0>) -> R)) -> R:
  match value:
    case Series.Nil{}: on0(Unit{})
    case Series.Cons{a0, a1}: on1(a0, a1)
law Eval.eval: for +globals_539: Global for +env_540: ListOf(Value) for +tm_541: Term CheckResult(Value)
law Eval.whnf: for +globals_1056: Global for +v_1057: Value CheckResult(Value)
law Eval.guarded_frame: for +k_1071: Big for +frames_1072: ListOf(Value.Spine) Bool
law Eval.quote: for +globals_1093: Global for +size_1094: Big for +v_1095: Value CheckResult(Term)
law Check.ops: Rules.Ops<&1, Check.Ctx>
law Check.infer_uses: for +c_1009: Check.Ctx for +mode_1010: Quantity for +t_1011: Term CheckResult(TupleOf2(Value, Quantity.Usage))
law Check.let_body: for +c_1324: Check.Ctx for +mode_1325: Quantity for +x_1326: String for +ty_1327: Term for +def_1328: Term for +body_1329: Reusable(Check.Ctx, CheckResult(TupleOf2(Value, Quantity.Usage))) CheckResult(TupleOf2(Value, Quantity.Usage))
law Pp.term: for +names_785: ListOf(String) for +tm_786: Term String
law Conv.conv_type: for -q0: Quant for -A0: Kind(q0) for +ops_828: Rules.Ops<q0, A0> for +ctx_829: A0 for +a_830: Value for +b_831: Value CheckResult(Bool)
law Conv.conv: for -q0: Quant for -A0: Kind(q0) for +ops_764: Rules.Ops<q0, A0> for +ctx_765: A0 for +ty_766: Value for +a_767: Value for +b_768: Value CheckResult(Bool)
law Conv.conv_spine: for -q0: Quant for -A0: Kind(q0) for +ops_909: Rules.Ops<q0, A0> for +ctx_910: A0 for +hty_911: Value for +sp1_912: ListOf(Value.Spine) for +sp2_913: ListOf(Value.Spine) CheckResult(Bool)
law Local.Term.occurs.f6699: for +member_432: Reusable(String, Bool) for +include_families_429: Bool for +tm_575: Term Bool
law Local.Order.ok.f7230: for +group_769: ListOf(String) for +guarded_call_783: Reusable(ListOf(Order.Status), Reusable(ListOf(Term), Bool)) for +principal_or_smaller_at_778: Reusable(ListOf(Order.Status), Reusable(Big, Bool)) for +st_795: ListOf(Order.Status) for +chain_796: ListOf(Order.Step) for +t_797: Term OptionOf(ListOf(Order.Call))
law Totality.spend_all: for +budget_677: Budget for +ts_678: ListOf(Term) CheckResult(Unit)
law Totality.spend: for +budget_346: Budget for +t_347: Term CheckResult(Unit)
@unsafe
def Rules.at(-q0: Quant, -A0: Kind(q0), +n_636: Big, +xs_637: List<q0, A0>) -> Maybe<q0, A0>:
  (+scrut80 = xs_637
  Match.List(q0, A0, q0, Maybe<q0, A0>, scrut80, _ => (None{}), +p81 => +p82 => (Native.choose(q0, Maybe<q0, A0>, Big.is_eq(n_636, Big.zero()), _ => (Some{p81}), _ => (Rules.at(q0, A0, NativeInt.sub(n_636, Big.one()), p82))))))
@unsafe
def Error.termination_msg(+n_310: String) -> String:
  String.concat(["recursive definition ", n_310, " failed the structural termination guard"])
@unsafe
def Error.to_string(+e_367: Error) -> String:
  (+scrut776 = e_367
  Match.Error(&2, String, scrut776, +p777 => (String.append("not yet: ", p777)), +p778 => +p779 => +p780 => (String.concat(["line ", Big.show(p779), ", column ", Big.show(p780), ": ", p778])), +p781 => (String.append("carry: ", p781)), +p782 => (String.append("unbound: ", p782)), +p783 => (String.append("mismatch: ", p783)), +p784 => (String.append("universe: ", p784)), +p785 => (String.append("quantity: ", p785)), +p786 => (String.append("wrong leg: ", p786)), +p787 => (String.append("missing branch: ", p787)), +p788 => (String.append("overflow: ", p788)), +p789 => (String.append("cannot infer: ", p789)), +p790 => (String.append("budget: ", p790)), +p791 => (String.append("index not zero: ", p791)), +p792 => (String.append("index above universe: ", p792)), +p793 => (String.append("termination: ", Error.termination_msg(p793)))))
@unsafe
def Level.one() -> Level:
  Big.one()
@unsafe
def Prim.name(+p_300: Prim) -> String:
  (+scrut800 = p_300
  Match.Prim(&2, String, scrut800, _ => ("natAdd"), _ => ("natSub"), _ => ("natMul"), _ => ("natEq"), _ => ("natLt")))
@unsafe
def Prim.nat_name() -> String:
  "Nat"
@unsafe
def Prim.nat_ty() -> Term:
  Term.Global{Prim.nat_name()}
@unsafe
def Rules.arrow(+q_785: Quantity, +x_786: String, +dom_787: Term, +cod_788: Term) -> Term:
  Term.Ran{Shape.SPi{q_785, x_786, dom_787}, cod_788}
@unsafe
def Rules.leg_of(+body_791: Term) -> Term.Leg:
  MkTerm_LegOf{Nil{}, body_791}
@unsafe
def Rules.diagram_of(+legs_794: ListOf(Term)) -> Term:
  Term.Sec{Shape.SColl{Big.of_nat(List.length(&2, Term, legs_794))}, SeqList.map(&2, &2, Term, Term.Leg, Rules.leg_of, legs_794)}
@unsafe
def Rules.prod_ty(+legs_800: ListOf(Term)) -> Term:
  Term.Ran{Shape.SColl{Big.of_nat(List.length(&2, Term, legs_800))}, Rules.diagram_of(legs_800)}
@unsafe
def Rules.unit_ty(+l_803: Level) -> Term:
  Term.Ann{Rules.prod_ty(Nil{}), Term.Univ{l_803}}
@unsafe
def Rules.sum_ty(+legs_797: ListOf(Term)) -> Term:
  Term.Lan{Shape.SColl{Big.of_nat(List.length(&2, Term, legs_797))}, Rules.diagram_of(legs_797)}
@unsafe
def Rules.bool_ty() -> Term:
  Rules.sum_ty(Con{Rules.unit_ty(Level.one()), Con{Rules.unit_ty(Level.one()), Nil{}}})
@unsafe
def Prim.ty(+p_470: Prim) -> Term:
  (+scrut803 = {(+local802 => (Rules.arrow(Quantity.Many{}, "a", Prim.nat_ty(), Rules.arrow(Quantity.Many{}, "b", Prim.nat_ty(), local802)))) : Reusable(Term, Term)}
  (+scrut804 = p_470
  Match.Prim(&2, Term, scrut804, _ => (scrut803(Prim.nat_ty())), _ => (scrut803(Prim.nat_ty())), _ => (scrut803(Prim.nat_ty())), _ => (scrut803(Rules.bool_ty())), _ => (scrut803(Rules.bool_ty())))))
@unsafe
def Global.add(+name_762: String, +entry_763: Global.Entry, +globals_764: Global) -> Global:
  MkGlobal{Assoc.add(&2, String, Global.Entry, (+a => +b => NativeString.order(a, b)), name_762, entry_763, Get.Global.entries(globals_764)), Get.Global.families(globals_764)}
@unsafe
def Global.empty() -> Global:
  MkGlobal{Assoc.empty(&2, String, Global.Entry), Assoc.empty(&2, String, Positivity.Family)}
@unsafe
def Prim.catalog() -> ListOf(Prim):
  Con{Prim.Nat_add{}, Con{Prim.Nat_sub{}, Con{Prim.Nat_mul{}, Con{Prim.Nat_eq{}, Con{Prim.Nat_lt{}, Nil{}}}}}}
@unsafe
def Global.initial() -> Global:
  (+scrut795 = {Global.Entry.Axiom{MkGlobal_Axiom_entry{Term.Univ{Level.one()}}} : Global.Entry}
  SeqList.fold(&2, &2, Prim, Global, (+local797 => +local799 => (Global.add(Prim.name(local799), Global.Entry.Prim{MkGlobal_Prim_entry{Prim.ty(local799), local799}}, local797))), Prim.catalog(), Global.add(Prim.nat_name(), scrut795, Global.empty())))
@unsafe
def Budget.unlimited() -> Budget:
  MkBudget{(+local808 => ((+scrut809 = local808
  False{})))}
@unsafe
def Bignum.of_int(+value_435: Big) -> Bignum:
  Big.identity(value_435)
@unsafe
def Bignum.mul(+left_454: Bignum, +right_455: Bignum) -> Bignum:
  Big.mul(left_454, right_455)
@unsafe
def Bignum.add(+left_450: Bignum, +right_451: Bignum) -> Bignum:
  Big.add(left_450, right_451)
@unsafe
def Bignum.of_decimal(+source_462: String) -> OptionOf(Bignum):
  (+scrut838 = {(+local831 => +local833 => (Match.Maybe(&2, Bignum, &2, OptionOf(Bignum), local831, _ => None{}, +item837 => ((+local835 => (Native.choose(&2, OptionOf(Bignum), Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(48)), Char.to_u32(local833)), _ => (U32.is_le(Char.to_u32(local833), Char.to_u32(Char.from_u32(57)))), _ => (False{})), _ => (Some{Bignum.add(Bignum.mul(local835, Bignum.of_int(Big.of_nat(10n))), Bignum.of_int(NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(local833))), Big.of_nat(U32.to_nat(Char.to_u32(Char.from_u32(48)))))))}), _ => (None{}))))(item837))))) : Reusable(OptionOf(Bignum), Reusable(Char, OptionOf(Bignum)))}
  Native.choose(&2, OptionOf(Bignum), Big.is_eq(Big.of_nat(String.length(source_462)), Big.zero()), _ => (None{}), _ => (NativeString.fold(&2, OptionOf(Bignum), scrut838, source_462, Some{Big.zero()}))))
@unsafe
def Bignum.to_string(+value_567: Bignum) -> String:
  Big.show(value_567)
@unsafe
def Bignum.equal(+left_440: Bignum, +right_441: Bignum) -> Bool:
  Big.is_eq(left_440, right_441)
@unsafe
def Bignum.sign(+value_447: Bignum) -> Big:
  Big.sign(value_447)
@unsafe
def Bignum.to_int(+value_570: Bignum) -> OptionOf(Big):
  Native.choose(&2, OptionOf(Big), Big.fits_int(value_570), _ => (Some{Big.identity(value_570)}), _ => (None{}))
@unsafe
def Check.make(+globals_463: Global, +budget_464: Budget) -> Check.Ctx:
  MkCheck_Ctx{globals_463, Nil{}, Nil{}, Big.zero(), budget_464}
@unsafe
def Check.names_of(+c_497: Check.Ctx) -> ListOf(String):
  SeqList.map(&2, &2, TupleOf3(String, Quantity, Value), String, (+local1873 => ((+scrut1874 = local1873
  Match.Tuple3(&2, String, &2, Quantity, &2, Value, &2, String, scrut1874, +p1875 => +p1876 => +p1877 => (p1875))))), Get.Check.Ctx.locals(c_497))
@unsafe
def Global.find_family(+name_767: String, +globals_768: Global) -> OptionOf(Positivity.Family):
  Assoc.find(&2, String, Positivity.Family, (+a => +b => NativeString.order(a, b)), name_767, Get.Global.families(globals_768))
@unsafe
def Positivity.ctor_of(+name_429: String, +f_430: Positivity.Family) -> OptionOf(Positivity.Ctor):
  SeqList.find(&2, Positivity.Ctor, (+local1908 => (NativeString.equal(Get.Positivity.Ctor.c_name(local1908), name_429))), Get.Positivity.Family.f_ctors(f_430))
@unsafe
def Rules.all_ok(-q0: Quant, -A0: Kind(q0), +xs_673: List<q0, Result<&2, q0, Error, A0>>) -> Result<&2, q0, Error, List<q0, A0>>:
  SeqList.fold(q0, q0, Result<&2, q0, Error, A0>, Result<&2, q0, Error, List<q0, A0>>, (+local1941 => +local1943 => (Match.Result(q0, List<q0, A0>, &2, Error, q0, Result<&2, q0, Error, List<q0, A0>>, local1941, +item1952 => ((+local1946 => (Match.Result(q0, A0, &2, Error, q0, Result<&2, q0, Error, List<q0, A0>>, local1943, +item1950 => ((+local1949 => (Done{List.append(q0, A0, local1946, Con{local1949, Nil{}})}))(item1950)), +item1951 => Fail{item1951})))(item1952)), +item1953 => Fail{item1953}))), xs_673, Done{Nil{}})
@unsafe
def Value.close(+env_437: ListOf(Value), +body_438: Term) -> Value.Closure:
  MkValue_ClosureOf{env_437, body_438}
@unsafe
def Rules.spar_word() -> String:
  "SPar arrives at M1"
@unsafe
def Rules.snu_word() -> String:
  "SNu arrives at M2"
@unsafe
def Rules.map_shape(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), +f_773: Reusable(A1, Result<&2, q0, Error, A0>), +s_774: Shape<q1, A1>) -> Result<&2, q0, Error, Shape<q0, A0>>:
  (+scrut2008 = s_774
  Match.Shape(q1, A1, q0, Result<&2, q0, Error, Shape<q0, A0>>, scrut2008, +p2009 => +p2010 => +p2011 => (Match.Result(q0, A0, &2, Error, q0, Result<&2, q0, Error, Shape<q0, A0>>, f_773(p2011), +item2014 => (Done{(+local2013 => (Shape.SPi{p2009, p2010, local2013}))(item2014)}), +item2015 => Fail{item2015})), +p2016 => (Done{Shape.SColl{p2016}}), +p2017 => +p2018 => (Fail{Error.Not_yet{Rules.spar_word()}}), +p2019 => +p2020 => (Match.Result(q0, List<q0, A0>, &2, Error, q0, Result<&2, q0, Error, Shape<q0, A0>>, Rules.all_ok(q0, A0, SeqList.map(q1, q0, A1, Result<&2, q0, Error, A0>, f_773, p2020)), +item2023 => (Done{(+local2022 => (Shape.SMu{p2019, local2022}))(item2023)}), +item2024 => Fail{item2024})), +p2025 => +p2026 => (Fail{Error.Not_yet{Rules.snu_word()}})))
@unsafe
def Eval.eval_addr(+globals_948: Global, +env_949: ListOf(Value), +a_950: Term.Addr) -> CheckResult(Value.Vaddr):
  (+scrut2046 = a_950
  Match.Term_Addr(&2, CheckResult(Value.Vaddr), scrut2046, +p2047 => +p2048 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Value.Vaddr), Eval.eval(globals_948, env_949, p2048), +item2051 => (Done{(+local2050 => (Value.VaddrOf.VAPt{p2047, local2050}))(item2051)}), +item2052 => Fail{item2052})), +p2053 => (Done{Value.VaddrOf.VALeg{p2053}}), +p2054 => (Done{Value.VaddrOf.VACtor{p2054}})))
@unsafe
def Eval.ev(+globals_943: Global) -> Rules.Evaluator:
  MkRules_Evaluator{(+local2064 => +local2066 => (Eval.eval(globals_943, local2064, local2066)))}
@unsafe
def Level.max(+a_298: Level, +b_299: Level) -> Level:
  Big.when(Big, Big.is_lt(a_298, b_299), _ => b_299, _ => a_298)
@unsafe
def Level.zero() -> Level:
  Big.zero()
@unsafe
def Rules.max_of(+ls_620: ListOf(Level)) -> Level:
  SeqList.fold(&2, &2, Level, Level, Level.max, ls_620, Level.zero())
@unsafe
def Rules.spi_lan_lvl(+ls_982: ListOf(Level)) -> Level:
  Rules.max_of(ls_982)
@unsafe
def Rules.as_vpi(-q0: Quant, -A0: Kind(q0), +s_811: Shape<q0, A0>) -> Maybe<q0, Tuple3<&2, &2, q0, Quantity, String, A0>>:
  (+scrut2083 = s_811
  Match.Shape(q0, A0, q0, Maybe<q0, Tuple3<&2, &2, q0, Quantity, String, A0>>, scrut2083, +p2084 => +p2085 => +p2086 => (Some{Tup3{p2084, p2085, p2086}}), +p2087 => (None{}), +p2088 => +p2089 => (None{}), +p2090 => +p2091 => (None{}), +p2092 => +p2093 => (None{})))
@unsafe
def Rules.wrong_pack() -> String:
  "the rule pack does not match the shape of the term"
@unsafe
def Rules.spi_levels(-q0: Quant, -A0: Kind(q0), +ops_962: Rules.Ops<q0, A0>, +ctx_963: A0, +s_964: Shape<&2, Term>, +diagram_965: Term) -> CheckResult(ListOf(Level)):
  (+local2099 => ((+local2103 => +local2105 => (Match.Result(&2, TupleOf3(Quantity, String, Term), &2, Error, &2, CheckResult(ListOf(Level)), local2103, +item2106 => (local2105(item2106)), +item2107 => Fail{item2107})))(local2099, (+local2109 => ((+scrut2110 = local2109
  Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, CheckResult(ListOf(Level)), scrut2110, +p2111 => +p2112 => +p2113 => ((do CheckResult<ListOf(Level)>:
    +bound2115 : Level <- Get.Rules.Ops.o_infer_univ(q0, A0, ops_962)(ctx_963, p2113)
    +bound2117 : Value <- Get.Rules.Ops.o_eval(q0, A0, ops_962)(ctx_963, p2113)
    +bound2119 : Level <- Get.Rules.Ops.o_infer_univ(q0, A0, ops_962)(Get.Rules.Ops.o_bind(q0, A0, ops_962)(p2112, p2111, bound2117, ctx_963), diagram_965)
    Done{Con{bound2115, Con{bound2119, Nil{}}}})))))))))((+local2096 => (Match.Maybe(&2, TupleOf3(Quantity, String, Term), &2, CheckResult(TupleOf3(Quantity, String, Term)), local2096, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vpi(&2, Term, s_964)))
@unsafe
def Rules.spi_form(-q0: Quant, -A0: Kind(q0), +level_998: Reusable(ListOf(Level), Level), +ops_999: Rules.Ops<q0, A0>, +ctx_1000: A0, +s_1001: Shape<&2, Term>, +diagram_1002: Term, +_expected_1003: OptionOf(Level)) -> CheckResult(Level):
  Match.Result(&2, ListOf(Level), &2, Error, &2, CheckResult(Level), Rules.spi_levels(q0, A0, ops_999, ctx_1000, s_1001, diagram_1002), +item2120 => (Done{level_998(item2120)}), +item2121 => Fail{item2121})
@unsafe
def Rules.level_pair(+ls_623: ListOf(Level)) -> OptionOf(TupleOf2(Level, Level)):
  (+scrut2132 = ls_623
  Match.List(&2, Level, &2, OptionOf(TupleOf2(Level, Level)), scrut2132, _ => (None{}), +p2133 => +p2134 => (Match.List(&2, Level, &2, OptionOf(TupleOf2(Level, Level)), p2134, _ => (None{}), +p2135 => +p2136 => (Match.List(&2, Level, &2, OptionOf(TupleOf2(Level, Level)), p2136, _ => (Some{Tup2{p2133, p2135}}), +p2137 => +p2138 => (None{})))))))
@unsafe
def Level.equal(+a_333: Level, +b_334: Level) -> Bool:
  Big.is_eq(a_333, b_334)
@unsafe
def Rules.imax(+l_616: Level, +l__617: Level) -> Level:
  Native.choose(&2, Level, Level.equal(l__617, Level.zero()), _ => (Level.zero()), _ => (Level.max(l_616, l__617)))
@unsafe
def Rules.spi_ran_lvl(+ls_985: ListOf(Level)) -> Level:
  (+local2141 => (Match.Maybe(&2, TupleOf2(Level, Level), &2, Level, local2141, _ => (Rules.max_of(ls_985)), +value => ((+local2143 => ((+scrut2144 = local2143
  Match.Tuple2(&2, Level, &2, Level, &2, Level, scrut2144, +p2145 => +p2146 => (Rules.imax(p2145, p2146))))))(value)))))(Rules.level_pair(ls_985))
@unsafe
def Quantity.equal(+a_302: Quantity, +b_303: Quantity) -> Bool:
  (+scrut2178 = {Tup2{a_302, b_303} : TupleOf2(Quantity, Quantity)}
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, Bool, scrut2178, +p2179 => +p2180 => (Match.Quantity(&2, Bool, p2179, _ => (Match.Quantity(&2, Bool, p2180, _ => (True{}), _ => (False{}), _ => (False{}))), _ => (Match.Quantity(&2, Bool, p2180, _ => (False{}), _ => (True{}), _ => (False{}))), _ => (Match.Quantity(&2, Bool, p2180, _ => (False{}), _ => (False{}), _ => (True{})))))))
@unsafe
def Quantity.add(+a_312: Quantity, +b_313: Quantity) -> Quantity:
  Native.choose(&2, Quantity, Quantity.equal(a_312, Quantity.Zero{}), _ => (b_313), _ => (Native.choose(&2, Quantity, Quantity.equal(b_313, Quantity.Zero{}), _ => (a_312), _ => (Quantity.Many{}))))
@unsafe
def Quantity.combine(+f_627: Reusable(Quantity, Reusable(Quantity, Quantity)), +g_628: Reusable(Quantity, Reusable(Quantity, Quantity)), +a_629: Assoc<&2, Big, Quantity.Interval>, +b_630: Assoc<&2, Big, Quantity.Interval>) -> Assoc<&2, Big, Quantity.Interval>:
  Assoc.merge(&2, &2, &2, Big, Quantity.Interval, Quantity.Interval, Quantity.Interval, (+a => +b => Big.cmp(a, b)), (+local2182 => +local2184 => +local2186 => ((+scrut2187 = {Maybe.default(&2, Quantity.Interval, local2184, Tup2{Quantity.Zero{}, Quantity.Zero{}}) : Quantity.Interval}
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, OptionOf(Quantity.Interval), scrut2187, +p2188 => +p2189 => ((+scrut2190 = {Maybe.default(&2, Quantity.Interval, local2186, Tup2{Quantity.Zero{}, Quantity.Zero{}}) : Quantity.Interval}
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, OptionOf(Quantity.Interval), scrut2190, +p2191 => +p2192 => (Some{Tup2{f_627(p2188, p2191), g_628(p2189, p2192)}})))))))), a_629, b_630)
@unsafe
def Quantity.sequence(+a_640: Quantity.Usage, +b_641: Quantity.Usage) -> Quantity.Usage:
  MkQuantity_Usage{Match.Maybe(&2, Assoc<&2, Big, Quantity.Interval>, &2, OptionOf(Assoc<&2, Big, Quantity.Interval>), Get.Quantity.Usage.paths(a_640), _ => None{}, +item2196 => ((+local2174 => (Match.Maybe(&2, Assoc<&2, Big, Quantity.Interval>, &2, OptionOf(Assoc<&2, Big, Quantity.Interval>), Get.Quantity.Usage.paths(b_641), _ => None{}, +item2194 => (Some{(+local2177 => (Quantity.combine(Quantity.add, Quantity.add, local2174, local2177)))(item2194)}))))(item2196))), Quantity.combine(Quantity.add, Quantity.add, Get.Quantity.Usage.reads(a_640), Get.Quantity.Usage.reads(b_641))}
@unsafe
def Rules.open_closure(+ev_391: Rules.Evaluator, +clo_392: Value.Closure, +args_393: ListOf(Value)) -> CheckResult(Value):
  Get.Rules.Evaluator.ev_eval(ev_391)(List.reverse.go(&2, Value, args_393, Get.Value.Closure.env(clo_392)), Get.Value.Closure.body(clo_392))
@unsafe
def Quantity.mul(+a_298: Quantity, +b_299: Quantity) -> Quantity:
  (+scrut2197 = {Tup2{a_298, b_299} : TupleOf2(Quantity, Quantity)}
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, Quantity, scrut2197, +p2198 => +p2199 => (Match.Quantity(&2, Quantity, p2198, _ => (Match.Quantity(&2, Quantity, p2199, _ => (Quantity.Zero{}), _ => (Quantity.Zero{}), _ => (Quantity.Zero{}))), _ => (Match.Quantity(&2, Quantity, p2199, _ => (Quantity.Zero{}), _ => (Quantity.One{}), _ => (Quantity.Many{}))), _ => (Match.Quantity(&2, Quantity, p2199, _ => (Quantity.Zero{}), _ => (Quantity.Many{}), _ => (Quantity.Many{})))))))
@unsafe
def Rules.one_of(-q0: Quant, -A0: Kind(q0), +xs_628: List<q0, A0>) -> Maybe<q0, A0>:
  (+scrut2200 = xs_628
  Match.List(q0, A0, q0, Maybe<q0, A0>, scrut2200, _ => (None{}), +p2201 => +p2202 => (Match.List(q0, A0, q0, Maybe<q0, A0>, p2202, _ => (Some{p2201}), +p2203 => +p2204 => (None{})))))
@unsafe
def Term.as_apt(+a_416: Term.Addr) -> OptionOf(TupleOf2(Quantity, Term)):
  (+scrut2208 = a_416
  Match.Term_Addr(&2, OptionOf(TupleOf2(Quantity, Term)), scrut2208, +p2209 => +p2210 => (Some{Tup2{p2209, p2210}}), +p2211 => (None{}), +p2212 => (None{})))
@unsafe
def Value.as_lan(+v_445: Value) -> OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))):
  (+scrut2220 = v_445
  Match.Value(&2, OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))), scrut2220, +p2221 => (None{}), +p2222 => +p2223 => +p2224 => (Some{Tup3{p2222, p2223, p2224}}), +p2225 => +p2226 => +p2227 => (None{}), +p2228 => +p2229 => +p2230 => (None{}), +p2231 => +p2232 => (None{}), +p2233 => (None{}), +p2234 => +p2235 => (None{})))
@unsafe
def Rules.former_view(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), +ops_855: Rules.Ops<q0, A0>, +ctx_856: A0, +view_857: Reusable(Value, Maybe<q1, A1>), +message_858: String, +ty_859: Value) -> Result<&2, q1, Error, Tuple2<&2, q1, Value, A1>>:
  Match.Result(&2, Value, &2, Error, q1, Result<&2, q1, Error, Tuple2<&2, q1, Value, A1>>, Get.Rules.Ops.o_whnf(q0, A0, ops_855)(ctx_856, ty_859), +item2247 => ((+local2238 => (Match.Result(q1, A1, &2, Error, q1, Result<&2, q1, Error, Tuple2<&2, q1, Value, A1>>, (+local2242 => (Match.Maybe(q1, A1, q1, Result<&2, q1, Error, A1>, local2242, _ => Fail{Error.Mismatch{message_858}}, +x => Done{x})))(view_857(local2238)), +item2245 => ((+local2244 => (Done{Tup2{local2238, local2244}}))(item2245)), +item2246 => Fail{item2246})))(item2247)), +item2248 => Fail{item2248})
@unsafe
def Rules.spi_intro_in(-q0: Quant, -A0: Kind(q0), +ops_1062: Rules.Ops<q0, A0>, +ctx_1063: A0, +mode_1064: Quantity, +_s_1065: Shape<&2, Term>, +addr_1066: Term.Addr, +args_1067: ListOf(Term), +expected_1068: Value) -> CheckResult(Quantity.Usage):
  (do CheckResult<Quantity.Usage>:
    +bound2148 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1062, ctx_1063, Value.as_lan, "a pair needs a left former as its expected type", expected_1068)
    Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(Quantity.Usage), bound2148, +p2149 => +p2150 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Quantity.Usage), p2150, +p2151 => +p2152 => +p2153 => ((do CheckResult<Quantity.Usage>:
      +bound2155 : TupleOf3(Quantity, String, Value) <- (+local2219 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local2219, _ => Fail{Error.Mismatch{"a pair needs a point former"}}, +x => Done{x})))(Rules.as_vpi(&2, Value, p2151))
      Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(Quantity.Usage), bound2155, +p2156 => +p2157 => +p2158 => (((do CheckResult<Quantity.Usage>:
  +bound2160 : TupleOf2(Quantity, Term) <- (+local2215 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, CheckResult(TupleOf2(Quantity, Term)), local2215, _ => Fail{Error.Wrong_leg{"a pair takes the point address"}}, +x => Done{x})))(Term.as_apt(addr_1066))
  Match.Tuple2(&2, Quantity, &2, Term, &2, CheckResult(Quantity.Usage), bound2160, +p2161 => +p2162 => ((do CheckResult<Quantity.Usage>:
    +bound2164 : Term <- (+local2207 => (Match.Maybe(&2, Term, &2, CheckResult(Term), local2207, _ => Fail{Error.Mismatch{"a pair carries one fibre element"}}, +x => Done{x})))(Rules.one_of(&2, Term, args_1067))
    +bound2166 : Quantity.Usage <- Get.Rules.Ops.o_check(q0, A0, ops_1062)(ctx_1063, Quantity.mul(mode_1064, p2156), p2162, p2158)
    +bound2168 : Value <- Get.Rules.Ops.o_eval(q0, A0, ops_1062)(ctx_1063, p2162)
    +bound2170 : Value <- Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1062)(ctx_1063), p2152, Con{bound2168, Nil{}})
    +bound2172 : Quantity.Usage <- Get.Rules.Ops.o_check(q0, A0, ops_1062)(ctx_1063, mode_1064, bound2164, bound2170)
    Done{Quantity.sequence(bound2166, bound2172)})))))))))))))
@unsafe
def Value.var(+lvl_434: Big) -> Value:
  Value.VNeutral{Value.Head.HLocal{lvl_434}, Nil{}}
@unsafe
def Quantity.empty() -> Quantity.Usage:
  MkQuantity_Usage{Some{Assoc.empty(&2, Big, Quantity.Interval)}, Assoc.empty(&2, Big, Quantity.Interval)}
@unsafe
def Quantity.scale_range(+param_660: Quantity.Interval, +uses_655: Quantity.Usage) -> Quantity.Usage:
  (+scrut2302 = param_660
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, Quantity.Usage, scrut2302, +p2303 => +p2304 => ((+scrut2313 = {(+local2307 => (Assoc.map(&2, &2, Big, TupleOf2(Quantity, Quantity), TupleOf2(Quantity, Quantity), (+local2309 => ((+scrut2310 = local2309
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, TupleOf2(Quantity, Quantity), scrut2310, +p2311 => +p2312 => (Tup2{Quantity.mul(p2303, p2311), Quantity.mul(p2304, p2312)}))))), local2307))) : Reusable(Assoc<&2, Big, TupleOf2(Quantity, Quantity)>, Assoc<&2, Big, TupleOf2(Quantity, Quantity)>)}
  MkQuantity_Usage{Match.Maybe(&2, Assoc<&2, Big, Quantity.Interval>, &2, OptionOf(Assoc<&2, Big, Quantity.Interval>), Get.Quantity.Usage.paths(uses_655), _ => None{}, +item2315 => (Some{scrut2313(item2315)})), scrut2313(Get.Quantity.Usage.reads(uses_655))}))))
@unsafe
def Quantity.scale(+q_663: Quantity, +uses_664: Quantity.Usage) -> Quantity.Usage:
  Native.choose(&2, Quantity.Usage, Quantity.equal(q_663, Quantity.Zero{}), _ => (Quantity.empty()), _ => (Quantity.scale_range(Tup2{q_663, q_663}, uses_664)))
@unsafe
def Quantity.runtime(+q_309: Quantity) -> Quantity:
  Native.choose(&2, Quantity, Quantity.equal(q_309, Quantity.Zero{}), _ => (Quantity.Zero{}), _ => (Quantity.One{}))
@unsafe
def Rules.elim_result(-q0: Quant, -A0: Kind(q0), +ops_945: Rules.Ops<q0, A0>, +ctx_946: A0, +mo_947: OptionOf(Term.Motive), +expected_948: OptionOf(Value), +self_949: Value) -> CheckResult(Value):
  (+local2318 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(Value), local2318, _ => ((+local2321 => (Match.Maybe(&2, Value, &2, CheckResult(Value), local2321, _ => Fail{Error.Cannot_infer{"an elimination without a motive needs an expected type"}}, +x => Done{x})))(expected_948)), +value => ((+local2323 => (Get.Rules.Evaluator.ev_eval(Get.Rules.Ops.o_ev(q0, A0, ops_945)(ctx_946))(Con{self_949, Get.Rules.Ops.o_env(q0, A0, ops_945)(ctx_946)}, Get.Term.Motive.m_body(local2323))))(value)))))(mo_947)
@unsafe
def Quantity.to_string(+q_306: Quantity) -> String:
  (+scrut2325 = q_306
  Match.Quantity(&2, String, scrut2325, _ => ("0"), _ => ("1"), _ => ("w")))
@unsafe
def Rules.binder_quantity(+subject_864: String, +source_865: String, +name_866: String, +marked_867: Quantity, +declared_868: Quantity) -> CheckResult(Unit):
  Native.choose(&2, CheckResult(Unit), Quantity.equal(marked_867, declared_868), _ => (Done{Unit{}}), _ => (Fail{Error.Quantity{String.concat(["the ", subject_864, " ", name_866, " is marked ", Quantity.to_string(marked_867), " and the ", source_865, " marks it ", Quantity.to_string(declared_868)])}}))
@unsafe
def Rules.two_of(-q0: Quant, -A0: Kind(q0), +xs_632: List<q0, A0>) -> Maybe<q0, Tuple2<q0, q0, A0, A0>>:
  (+scrut2326 = xs_632
  Match.List(q0, A0, q0, Maybe<q0, Tuple2<q0, q0, A0, A0>>, scrut2326, _ => (None{}), +p2327 => +p2328 => (Match.List(q0, A0, q0, Maybe<q0, Tuple2<q0, q0, A0, A0>>, p2328, _ => (None{}), +p2329 => +p2330 => (Match.List(q0, A0, q0, Maybe<q0, Tuple2<q0, q0, A0, A0>>, p2330, _ => (Some{Tup2{p2327, p2329}}), +p2331 => +p2332 => (None{})))))))
@unsafe
def Rules.leg_msg() -> String:
  "the leg address is outside the collection"
@unsafe
def Term.as_aleg(+a_421: Term.Addr) -> OptionOf(Big):
  (+scrut2337 = a_421
  Match.Term_Addr(&2, OptionOf(Big), scrut2337, +p2338 => +p2339 => (None{}), +p2340 => (Some{p2340}), +p2341 => (None{})))
@unsafe
def Rules.check_motive(-q0: Quant, -A0: Kind(q0), +ops_953: Rules.Ops<q0, A0>, +ctx_954: A0, +mo_955: OptionOf(Term.Motive), +scrut_ty_956: Value) -> CheckResult(Unit):
  (+local2351 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(Unit), local2351, _ => (Done{Unit{}}), +value => ((+local2353 => ((+scrut2354 = {Get.Rules.Ops.o_bind(q0, A0, ops_953)(Get.Term.Motive.m_self(local2353), Quantity.Zero{}, scrut_ty_956, ctx_954) : A0}
  Match.Result(&2, Level, &2, Error, &2, CheckResult(Unit), Get.Rules.Ops.o_infer_univ(q0, A0, ops_953)(scrut2354, Get.Term.Motive.m_body(local2353)), +item2357 => (Done{(+local2356 => (Unit{}))(item2357)}), +item2358 => Fail{item2358}))))(value)))))(mo_955)
@unsafe
def Rules.infer_scrutinee(-q0: Quant, -A0: Kind(q0), +ops_907: Rules.Ops<q0, A0>, +ctx_908: A0, +mode_909: Quantity, +e_910: Term.Elim) -> CheckResult(TupleOf2(Value, Quantity.Usage)):
  Native.choose(&2, CheckResult(TupleOf2(Value, Quantity.Usage)), Big.when(Bool, Bool.not(Quantity.equal(mode_909, Quantity.Zero{})), _ => (Quantity.equal(Get.Term.Elim.e_scrut_q(e_910), Quantity.Zero{})), _ => (False{})), _ => (Fail{Error.Quantity{"an erased scrutinee cannot be eliminated at runtime"}}), _ => (Get.Rules.Ops.o_infer(q0, A0, ops_907)(ctx_908, Quantity.mul(mode_909, Get.Term.Elim.e_scrut_q(e_910)), Get.Term.Elim.e_scrut(e_910))))
@unsafe
def Rules.spi_elim_elim(-q0: Quant, -A0: Kind(q0), +ops_1114: Rules.Ops<q0, A0>, +ctx_1115: A0, +mode_1116: Quantity, +e_1117: Term.Elim, +expected_1118: OptionOf(Value)) -> CheckResult(TupleOf2(Value, Quantity.Usage)):
  (do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2250 : TupleOf2(Value, Quantity.Usage) <- Rules.infer_scrutinee(q0, A0, ops_1114, ctx_1115, mode_1116, e_1117)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2250, +p2251 => +p2252 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
      +bound2254 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1114, ctx_1115, Value.as_lan, "the scrutinee is not a left former", p2251)
      Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2254, +p2255 => +p2256 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), p2256, +p2257 => +p2258 => +p2259 => (((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2261 : TupleOf3(Quantity, String, Value) <- (+local2361 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local2361, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vpi(&2, Value, p2257))
  Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2261, +p2262 => +p2263 => +p2264 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2266 : Unit <- Rules.check_motive(q0, A0, ops_1114, ctx_1115, Get.Term.Elim.e_motive(e_1117), p2255)
    +bound2268 : Value <- Get.Rules.Ops.o_eval(q0, A0, ops_1114)(ctx_1115, Get.Term.Elim.e_scrut(e_1117))
    +bound2270 : Value <- Rules.elim_result(q0, A0, ops_1114, ctx_1115, Get.Term.Elim.e_motive(e_1117), expected_1118, bound2268)
    ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2272 : TupleOf2(Term.Addr, Term.Leg) <- (+local2347 => (Match.Maybe(&2, TupleOf2(Term.Addr, Term.Leg), &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), local2347, _ => Fail{Error.Missing_branch{"an elimination at the point shape has one branch"}}, +x => Done{x})))(Rules.one_of(&2, TupleOf2(Term.Addr, Term.Leg), Get.Term.Elim.e_branches(e_1117)))
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2272, +p2273 => +p2274 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2276 : Big <- (+local2344 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2344, _ => Fail{Error.Wrong_leg{"the branch takes the leg address"}}, +x => Done{x})))(Term.as_aleg(p2273))
    +bound2278 : Unit <- Native.choose(&2, CheckResult(Unit), Big.is_eq(bound2276, Big.zero()), _ => (Done{Unit{}}), _ => (Fail{Error.Wrong_leg{Rules.leg_msg()}}))
    ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2280 : TupleOf2(TupleOf2(Quantity, String), TupleOf2(Quantity, String)) <- (+local2335 => (Match.Maybe(&2, TupleOf2(TupleOf2(Quantity, String), TupleOf2(Quantity, String)), &2, CheckResult(TupleOf2(TupleOf2(Quantity, String), TupleOf2(Quantity, String))), local2335, _ => Fail{Error.Missing_branch{"the branch binds the point and the fibre element (D-M0-3)"}}, +x => Done{x})))(Rules.two_of(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(p2274)))
  Match.Tuple2(&2, TupleOf2(Quantity, String), &2, TupleOf2(Quantity, String), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2280, +p2281 => +p2282 => (Match.Tuple2(&2, Quantity, &2, String, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), p2281, +p2283 => +p2284 => (Match.Tuple2(&2, Quantity, &2, String, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), p2282, +p2285 => +p2286 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2288 : Unit <- Rules.binder_quantity("branch binder", "type", p2284, p2283, p2262)
    (+scrut2289 = {Get.Rules.Ops.o_size(q0, A0, ops_1114)(ctx_1115) : Big}
    (+scrut2290 = {Value.var(scrut2289) : Value}
    (+scrut2291 = {Value.var(NativeInt.add(scrut2289, Big.one())) : Value}
    (do CheckResult<TupleOf2(Value, Quantity.Usage)>:
      +bound2293 : Value <- Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1114)(ctx_1115), p2258, Con{scrut2290, Nil{}})
      ((+scrut2294 = {Get.Rules.Ops.o_bind(q0, A0, ops_1114)(p2286, p2285, bound2293, Get.Rules.Ops.o_bind(q0, A0, ops_1114)(p2284, p2283, p2264, ctx_1115)) : A0}
(+scrut2295 = {Value.VIn{p2257, Value.VaddrOf.VAPt{p2262, scrut2290}, Con{scrut2291, Nil{}}} : Value}
(do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2297 : Value <- Rules.elim_result(q0, A0, ops_1114, ctx_1115, Get.Term.Elim.e_motive(e_1117), expected_1118, scrut2295)
  +bound2299 : Quantity.Usage <- Get.Rules.Ops.o_check(q0, A0, ops_1114)(scrut2294, Quantity.runtime(mode_1116), Get.Term.Leg.l_body(p2274), bound2297)
  +bound2301 : Quantity.Usage <- Get.Rules.Ops.o_close(q0, A0, ops_1114)(scrut2294, Get.Rules.Ops.o_size(q0, A0, ops_1114)(ctx_1115), mode_1116, bound2299)
  Done{Tup2{bound2270, Quantity.sequence(p2252, Quantity.scale(mode_1116, bound2301))}})))))))))))))))))))))))))))))))))))
@unsafe
def Quantity.rank(+q_316: Quantity) -> Big:
  (+scrut2397 = q_316
  Match.Quantity(&2, Big, scrut2397, _ => (Big.zero()), _ => (Big.one()), _ => (Big.of_nat(2n))))
@unsafe
def Quantity.maximum(+a_323: Quantity, +b_324: Quantity) -> Quantity:
  Native.choose(&2, Quantity, Big.is_le(Quantity.rank(b_324), Quantity.rank(a_323)), _ => (a_323), _ => (b_324))
@unsafe
def Quantity.captures(+uses_695: Quantity.Usage) -> Quantity.Usage:
  (+scrut2398 = {Match.Maybe(&2, Assoc<&2, Big, Quantity.Interval>, &2, Assoc<&2, Big, Quantity.Interval>, Get.Quantity.Usage.paths(uses_695), _ => (Get.Quantity.Usage.reads(uses_695)), +value => ((+local2392 => (Quantity.combine((+local2394 => +local2396 => (local2394)), Quantity.maximum, local2392, Get.Quantity.Usage.reads(uses_695))))(value))) : Assoc<&2, Big, Quantity.Interval>}
  MkQuantity_Usage{Some{scrut2398}, Get.Quantity.Usage.reads(uses_695)})
@unsafe
def Value.as_ran(+v_451: Value) -> OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))):
  (+scrut2410 = v_451
  Match.Value(&2, OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))), scrut2410, +p2411 => (None{}), +p2412 => +p2413 => +p2414 => (None{}), +p2415 => +p2416 => +p2417 => (Some{Tup3{p2415, p2416, p2417}}), +p2418 => +p2419 => +p2420 => (None{}), +p2421 => +p2422 => (None{}), +p2423 => (None{}), +p2424 => +p2425 => (None{})))
@unsafe
def Rules.spi_intro_sec(-q0: Quant, -A0: Kind(q0), +ops_1035: Rules.Ops<q0, A0>, +ctx_1036: A0, +mode_1037: Quantity, +_s_1038: Shape<&2, Term>, +legs_1039: ListOf(Term.Leg), +expected_1040: Value) -> CheckResult(Quantity.Usage):
  (do CheckResult<Quantity.Usage>:
    +bound2364 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1035, ctx_1036, Value.as_ran, "a section needs a right former as its expected type", expected_1040)
    Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(Quantity.Usage), bound2364, +p2365 => +p2366 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Quantity.Usage), p2366, +p2367 => +p2368 => +p2369 => ((do CheckResult<Quantity.Usage>:
      +bound2371 : TupleOf3(Quantity, String, Value) <- (+local2409 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local2409, _ => Fail{Error.Mismatch{"a section at the point shape needs a point former"}}, +x => Done{x})))(Rules.as_vpi(&2, Value, p2367))
      Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(Quantity.Usage), bound2371, +p2372 => +p2373 => +p2374 => (((do CheckResult<Quantity.Usage>:
  +bound2376 : Term.Leg <- (+local2405 => (Match.Maybe(&2, Term.Leg, &2, CheckResult(Term.Leg), local2405, _ => Fail{Error.Mismatch{"a section at the point shape has one leg"}}, +x => Done{x})))(Rules.one_of(&2, Term.Leg, legs_1039))
  +bound2378 : TupleOf2(Quantity, String) <- (+local2402 => (Match.Maybe(&2, TupleOf2(Quantity, String), &2, CheckResult(TupleOf2(Quantity, String)), local2402, _ => Fail{Error.Mismatch{"the leg binds the point once"}}, +x => Done{x})))(Rules.one_of(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(bound2376)))
  Match.Tuple2(&2, Quantity, &2, String, &2, CheckResult(Quantity.Usage), bound2378, +p2379 => +p2380 => (((do CheckResult<Quantity.Usage>:
  +bound2382 : Unit <- Rules.binder_quantity("binder", "type", p2380, p2379, p2372)
  (+scrut2383 = {Value.var(Get.Rules.Ops.o_size(q0, A0, ops_1035)(ctx_1036)) : Value}
  (do CheckResult<Quantity.Usage>:
    +bound2385 : Value <- Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1035)(ctx_1036), p2368, Con{scrut2383, Nil{}})
    (+scrut2386 = {Get.Rules.Ops.o_bind(q0, A0, ops_1035)(p2380, p2372, p2374, ctx_1036) : A0}
    (do CheckResult<Quantity.Usage>:
      +bound2388 : Quantity.Usage <- Get.Rules.Ops.o_check(q0, A0, ops_1035)(scrut2386, Quantity.runtime(mode_1037), Get.Term.Leg.l_body(bound2376), bound2385)
      +bound2390 : Quantity.Usage <- Get.Rules.Ops.o_close(q0, A0, ops_1035)(scrut2386, Get.Rules.Ops.o_size(q0, A0, ops_1035)(ctx_1036), mode_1037, bound2388)
      Done{Quantity.scale(mode_1037, Quantity.captures(bound2390))}))))))))))))))))))
@unsafe
def Rules.spi_elim_out(-q0: Quant, -A0: Kind(q0), +ops_1088: Rules.Ops<q0, A0>, +ctx_1089: A0, +mode_1090: Quantity, +_s_1091: Shape<&2, Term>, +addr_1092: Term.Addr, +head_1093: Term) -> CheckResult(TupleOf2(Value, Quantity.Usage)):
  (do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2427 : TupleOf2(Quantity, Term) <- (+local2459 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, CheckResult(TupleOf2(Quantity, Term)), local2459, _ => Fail{Error.Wrong_leg{"an application takes the point address"}}, +x => Done{x})))(Term.as_apt(addr_1092))
    Match.Tuple2(&2, Quantity, &2, Term, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2427, +p2428 => +p2429 => (((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2431 : TupleOf2(Value, Quantity.Usage) <- Get.Rules.Ops.o_infer(q0, A0, ops_1088)(ctx_1089, mode_1090, head_1093)
  Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2431, +p2432 => +p2433 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2435 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1088, ctx_1089, Value.as_ran, "the head of an application is not a function", p2432)
    Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2435, +p2436 => +p2437 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), p2437, +p2438 => +p2439 => +p2440 => (((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2442 : TupleOf3(Quantity, String, Value) <- (+local2454 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local2454, _ => Fail{Error.Mismatch{"the head of an application is not a function"}}, +x => Done{x})))(Rules.as_vpi(&2, Value, p2438))
  Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2442, +p2443 => +p2444 => +p2445 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2447 : Quantity.Usage <- Get.Rules.Ops.o_check(q0, A0, ops_1088)(ctx_1089, Quantity.mul(mode_1090, p2443), p2429, p2445)
    +bound2449 : Value <- Get.Rules.Ops.o_eval(q0, A0, ops_1088)(ctx_1089, p2429)
    +bound2451 : Value <- Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1088)(ctx_1089), p2439, Con{bound2449, Nil{}})
    Done{Tup2{bound2451, Quantity.sequence(p2433, bound2447)}})))))))))))))))))
@unsafe
def Value.as_pt(+a_477: Value.Vaddr) -> OptionOf(TupleOf2(Quantity, Value)):
  (+scrut2465 = a_477
  Match.Value_Vaddr(&2, OptionOf(TupleOf2(Quantity, Value)), scrut2465, +p2466 => +p2467 => (Some{Tup2{p2466, p2467}}), +p2468 => (None{}), +p2469 => (None{})))
@unsafe
def Value.as_sec(+v_463: Value) -> OptionOf(TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg))):
  (+scrut2476 = v_463
  Match.Value(&2, OptionOf(TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg))), scrut2476, +p2477 => (None{}), +p2478 => +p2479 => +p2480 => (None{}), +p2481 => +p2482 => +p2483 => (None{}), +p2484 => +p2485 => +p2486 => (None{}), +p2487 => +p2488 => (Some{Tup2{p2487, p2488}}), +p2489 => (None{}), +p2490 => +p2491 => (None{})))
@unsafe
def Rules.let_(-q0: Quant, -A0: Kind(q0), +o_913: Maybe<q0, A0>, +f_914: Reusable(A0, CheckResult(OptionOf(Value)))) -> CheckResult(OptionOf(Value)):
  Match.Maybe(q0, A0, &2, CheckResult(OptionOf(Value)), o_913, _ => (Done{None{}}), +value => (f_914(value)))
@unsafe
def Value.as_in(+v_457: Value) -> OptionOf(TupleOf3(Shape<&2, Value>, Value.Vaddr, ListOf(Value))):
  (+scrut2510 = v_457
  Match.Value(&2, OptionOf(TupleOf3(Shape<&2, Value>, Value.Vaddr, ListOf(Value))), scrut2510, +p2511 => (None{}), +p2512 => +p2513 => +p2514 => (None{}), +p2515 => +p2516 => +p2517 => (None{}), +p2518 => +p2519 => +p2520 => (Some{Tup3{p2518, p2519, p2520}}), +p2521 => +p2522 => (None{}), +p2523 => (None{}), +p2524 => +p2525 => (None{})))
@unsafe
def Rules.spi_beta(+ev_1006: Rules.Evaluator, +r_1007: Rules.Beta_redex) -> CheckResult(OptionOf(Value)):
  (+scrut2460 = r_1007
  Match.Rules_Beta_redex(&2, CheckResult(OptionOf(Value)), scrut2460, +p2461 => +p2462 => +p2463 => (Rules.let_(&2, TupleOf2(Quantity, Value), Value.as_pt(p2462), (+local2471 => ((+scrut2472 = local2471
  Match.Tuple2(&2, Quantity, &2, Value, &2, CheckResult(OptionOf(Value)), scrut2472, +p2473 => +p2474 => (Rules.let_(&2, TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg)), Value.as_sec(p2463), (+local2493 => ((+scrut2494 = local2493
  Match.Tuple2(&2, Shape<&2, Value>, &2, ListOf(Value.Vleg), &2, CheckResult(OptionOf(Value)), scrut2494, +p2495 => +p2496 => (Rules.let_(&2, Value.Vleg, Rules.one_of(&2, Value.Vleg, p2496), (+local2499 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Rules.open_closure(ev_1006, Get.Value.Vleg.vl_clo(local2499), Con{p2474, Nil{}}), +item2503 => (Done{(+local2502 => (Some{local2502}))(item2503)}), +item2504 => Fail{item2504}))))))))))))))))), +p2505 => +p2506 => +p2507 => +p2508 => (Rules.let_(&2, TupleOf3(Shape<&2, Value>, Value.Vaddr, ListOf(Value)), Value.as_in(p2508), (+local2527 => ((+scrut2528 = local2527
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Vaddr, &2, ListOf(Value), &2, CheckResult(OptionOf(Value)), scrut2528, +p2529 => +p2530 => +p2531 => ((Rules.let_(&2, TupleOf2(Quantity, Value), Value.as_pt(p2530), (+local2534 => ((+scrut2535 = local2534
Match.Tuple2(&2, Quantity, &2, Value, &2, CheckResult(OptionOf(Value)), scrut2535, +p2536 => +p2537 => (Rules.let_(&2, Value, Rules.one_of(&2, Value, p2531), (+local2540 => (Rules.let_(&2, TupleOf2(Term.Addr, Term.Leg), Rules.one_of(&2, TupleOf2(Term.Addr, Term.Leg), p2506), (+local2543 => ((+scrut2544 = local2543
Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(OptionOf(Value)), scrut2544, +p2545 => +p2546 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Get.Rules.Evaluator.ev_eval(ev_1006)(Con{local2540, Con{p2537, p2507}}, Get.Term.Leg.l_body(p2546)), +item2550 => (Done{(+local2549 => (Some{local2549}))(item2550)}), +item2551 => Fail{item2551}))))))))))))))))))))))))))
@unsafe
def Rules.spi_diagram_arity(+_s_1244: Shape<&2, Value>) -> Big:
  Big.one()
@unsafe
def Rules.spi_spine_ty(-q0: Quant, -A0: Kind(q0), +ops_1229: Rules.Ops<q0, A0>, +ctx_1230: A0, +s_1231: Shape<&2, Value>, +dclo_1232: Value.Closure, +addr_1233: Value.Vaddr) -> CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))):
  (+local2555 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), local2555, _ => (Done{None{}}), +value => ((+local2557 => ((+scrut2558 = local2557
  Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), scrut2558, +p2559 => +p2560 => +p2561 => ((+local2564 => (Match.Maybe(&2, TupleOf2(Quantity, Value), &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), local2564, _ => (Done{None{}}), +value => ((+local2566 => ((+scrut2567 = local2566
  Match.Tuple2(&2, Quantity, &2, Value, &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), scrut2567, +p2568 => +p2569 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1229)(ctx_1230), dclo_1232, Con{p2569, Nil{}}), +item2572 => (Done{(+local2571 => (Some{Tup2{Some{p2561}, local2571}}))(item2572)}), +item2573 => Fail{item2573}))))))(value)))))(Value.as_pt(addr_1233)))))))(value)))))(Rules.as_vpi(&2, Value, s_1231))
@unsafe
def Value.as_neutral(+v_472: Value) -> OptionOf(TupleOf2(Value.Head, ListOf(Value.Spine))):
  (+scrut2592 = v_472
  Match.Value(&2, OptionOf(TupleOf2(Value.Head, ListOf(Value.Spine))), scrut2592, +p2593 => (None{}), +p2594 => +p2595 => +p2596 => (None{}), +p2597 => +p2598 => +p2599 => (None{}), +p2600 => +p2601 => +p2602 => (None{}), +p2603 => +p2604 => (None{}), +p2605 => (None{}), +p2606 => +p2607 => (Some{Tup2{p2606, p2607}})))
@unsafe
def Rules.stuck_msg() -> String:
  "an elimination met a value it cannot eliminate"
@unsafe
def Rules.out_with(+beta_917: Reusable(Rules.Evaluator, Reusable(Rules.Beta_redex, CheckResult(OptionOf(Value)))), +ev_918: Rules.Evaluator, +s_919: Shape<&2, Value>, +addr_920: Value.Vaddr, +v_921: Value) -> CheckResult(Value):
  (do CheckResult<Value>:
    +bound2588 : OptionOf(Value) <- beta_917(ev_918, Rules.Beta_redex.BOut{s_919, addr_920, v_921})
    (+local2591 => (Match.Maybe(&2, Value, &2, CheckResult(Value), local2591, _ => ((+local2610 => (Match.Maybe(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), &2, CheckResult(Value), local2610, _ => (Fail{Error.Mismatch{Rules.stuck_msg()}}), +value => ((+local2612 => ((+scrut2613 = local2612
    Match.Tuple2(&2, Value.Head, &2, ListOf(Value.Spine), &2, CheckResult(Value), scrut2613, +p2614 => +p2615 => (Done{Value.VNeutral{p2614, Con{Value.SpineOf.SOut{s_919, addr_920}, p2615}}})))))(value)))))(Value.as_neutral(v_921))), +value => ((+local2617 => (Done{local2617}))(value)))))(bound2588))
@unsafe
def Rules.spi_eta_ran(-q0: Quant, -A0: Kind(q0), +ops_1156: Rules.Ops<q0, A0>, +ctx_1157: A0, +s_1158: Shape<&2, Value>, +dclo_1159: Value.Closure, +a_1160: Value, +b_1161: Value) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound2575 : TupleOf3(Quantity, String, Value) <- (+local2620 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local2620, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vpi(&2, Value, s_1158))
    Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(Bool), bound2575, +p2576 => +p2577 => +p2578 => ((+scrut2579 = {Get.Rules.Ops.o_ev(q0, A0, ops_1156)(ctx_1157) : Rules.Evaluator}
    (+scrut2580 = {Value.var(Get.Rules.Ops.o_size(q0, A0, ops_1156)(ctx_1157)) : Value}
    (do CheckResult<Bool>:
      +bound2582 : Value <- Rules.open_closure(scrut2579, dclo_1159, Con{scrut2580, Nil{}})
      +bound2584 : Value <- Rules.out_with(Rules.spi_beta, scrut2579, s_1158, Value.VaddrOf.VAPt{p2576, scrut2580}, a_1160)
      +bound2586 : Value <- Rules.out_with(Rules.spi_beta, scrut2579, s_1158, Value.VaddrOf.VAPt{p2576, scrut2580}, b_1161)
      Get.Rules.Ops.o_conv(q0, A0, ops_1156)(Get.Rules.Ops.o_bind(q0, A0, ops_1156)(p2577, p2576, p2578, ctx_1157), bound2582, bound2584, bound2586)))))))
@unsafe
def Rules.proj_branch(+q_1173: Quantity, +which_1174: Big) -> ListOf(TupleOf2(Term.Addr, Term.Leg)):
  Con{Tup2{Term.AddrOf.ALeg{Big.zero()}, MkTerm_LegOf{Con{Tup2{q_1173, "x"}, Con{Tup2{Quantity.Many{}, "y"}, Nil{}}}, Term.Var{Native.choose(&2, Big, Big.is_eq(which_1174, Big.zero()), _ => (Big.one()), _ => (Big.zero()))}}}, Nil{}}
@unsafe
def Rules.elim_with(+beta_929: Reusable(Rules.Evaluator, Reusable(Rules.Beta_redex, CheckResult(OptionOf(Value)))), +ev_930: Rules.Evaluator, +s_931: Shape<&2, Value>, +q_932: Quantity, +mo_933: OptionOf(Term.Motive), +branches_934: ListOf(TupleOf2(Term.Addr, Term.Leg)), +env_935: ListOf(Value), +v_936: Value) -> CheckResult(Value):
  (do CheckResult<Value>:
    +bound2645 : OptionOf(Value) <- beta_929(ev_930, Rules.Beta_redex.BElim{s_931, branches_934, env_935, v_936})
    (+local2648 => (Match.Maybe(&2, Value, &2, CheckResult(Value), local2648, _ => ((+local2651 => (Match.Maybe(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), &2, CheckResult(Value), local2651, _ => (Fail{Error.Mismatch{Rules.stuck_msg()}}), +value => ((+local2653 => ((+scrut2654 = local2653
    Match.Tuple2(&2, Value.Head, &2, ListOf(Value.Spine), &2, CheckResult(Value), scrut2654, +p2655 => +p2656 => ((+scrut2657 = {Value.SpineOf.SElim{MkValue_Stuck_elimOf{s_931, q_932, mo_933, branches_934, env_935}} : Value.Spine}
    Done{Value.VNeutral{p2655, Con{scrut2657, p2656}}}))))))(value)))))(Value.as_neutral(v_936))), +value => ((+local2659 => (Done{local2659}))(value)))))(bound2645))
@unsafe
def Rules.proj_motive(-q0: Quant, -A0: Kind(q0), +ops_1177: Rules.Ops<q0, A0>, +ctx_1178: A0, +s_1179: Shape<&2, Value>, +dclo_1180: Value.Closure, +q_1181: Quantity, +x_1182: String, +dom_v_1183: Value, +which_1184: Big) -> CheckResult(OptionOf(Term.Motive)):
  (+scrut2660 = {Get.Rules.Ops.o_ev(q0, A0, ops_1177)(ctx_1178) : Rules.Evaluator}
  (+scrut2661 = {Get.Rules.Ops.o_size(q0, A0, ops_1177)(ctx_1178) : Big}
  (do CheckResult<OptionOf(Term.Motive)>:
    +bound2663 : Value <- Native.choose(&2, CheckResult(Value), Big.is_eq(which_1184, Big.zero()), _ => (Done{dom_v_1183}), _ => ((do CheckResult<Value>:
      +bound2667 : Value <- Rules.elim_with(Rules.spi_beta, scrut2660, s_1179, q_1181, None{}, Rules.proj_branch(q_1181, Big.zero()), Get.Rules.Ops.o_env(q0, A0, ops_1177)(ctx_1178), Value.var(scrut2661))
      Rules.open_closure(scrut2660, dclo_1180, Con{bound2667, Nil{}}))))
    +bound2665 : Term <- Get.Rules.Ops.o_quote(q0, A0, ops_1177)(Get.Rules.Ops.o_bind(q0, A0, ops_1177)(x_1182, q_1181, dom_v_1183, ctx_1178), bound2663)
    Done{Some{MkTerm_MotiveOf{None{}, Nil{}, "self", bound2665}}})))
@unsafe
def Rules.spi_eta_lan(-q0: Quant, -A0: Kind(q0), +ops_1192: Rules.Ops<q0, A0>, +ctx_1193: A0, +s_1194: Shape<&2, Value>, +dclo_1195: Value.Closure, +a_1196: Value, +b_1197: Value) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound2622 : TupleOf3(Quantity, String, Value) <- (+local2671 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local2671, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vpi(&2, Value, s_1194))
    Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(Bool), bound2622, +p2623 => +p2624 => +p2625 => ((+scrut2626 = {Get.Rules.Ops.o_ev(q0, A0, ops_1192)(ctx_1193) : Rules.Evaluator}
    (+scrut2627 = {Get.Rules.Ops.o_env(q0, A0, ops_1192)(ctx_1193) : ListOf(Value)}
    (do CheckResult<Bool>:
      +bound2629 : OptionOf(Term.Motive) <- Rules.proj_motive(q0, A0, ops_1192, ctx_1193, s_1194, dclo_1195, p2623, p2624, p2625, Big.zero())
      +bound2631 : Value <- Rules.elim_with(Rules.spi_beta, scrut2626, s_1194, Quantity.One{}, bound2629, Rules.proj_branch(p2623, Big.zero()), scrut2627, a_1196)
      +bound2633 : Value <- Rules.elim_with(Rules.spi_beta, scrut2626, s_1194, Quantity.One{}, bound2629, Rules.proj_branch(p2623, Big.zero()), scrut2627, b_1197)
      ((do CheckResult<Bool>:
  +bound2635 : Bool <- Get.Rules.Ops.o_conv(q0, A0, ops_1192)(ctx_1193, p2625, bound2631, bound2633)
  Native.choose(&2, CheckResult(Bool), bound2635, _ => ((do CheckResult<Bool>:
    +bound2637 : Value <- Rules.open_closure(scrut2626, dclo_1195, Con{bound2631, Nil{}})
    +bound2639 : OptionOf(Term.Motive) <- Rules.proj_motive(q0, A0, ops_1192, ctx_1193, s_1194, dclo_1195, p2623, p2624, p2625, Big.one())
    +bound2641 : Value <- Rules.elim_with(Rules.spi_beta, scrut2626, s_1194, Quantity.One{}, bound2639, Rules.proj_branch(p2623, Big.one()), scrut2627, a_1196)
    +bound2643 : Value <- Rules.elim_with(Rules.spi_beta, scrut2626, s_1194, Quantity.One{}, bound2639, Rules.proj_branch(p2623, Big.one()), scrut2627, b_1197)
    Get.Rules.Ops.o_conv(q0, A0, ops_1192)(ctx_1193, bound2637, bound2641, bound2643))), _ => (Done{False{}}))))))))))
@unsafe
def Rules.spi_conv_diagram(-q0: Quant, -A0: Kind(q0), +ops_1214: Rules.Ops<q0, A0>, +ctx_1215: A0, +s_1216: Shape<&2, Value>, +d1_1217: Value.Closure, +d2_1218: Value.Closure) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound2673 : TupleOf3(Quantity, String, Value) <- (+local2685 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local2685, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vpi(&2, Value, s_1216))
    Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(Bool), bound2673, +p2674 => +p2675 => +p2676 => ((+scrut2677 = {Get.Rules.Ops.o_ev(q0, A0, ops_1214)(ctx_1215) : Rules.Evaluator}
    (+scrut2678 = {Value.var(Get.Rules.Ops.o_size(q0, A0, ops_1214)(ctx_1215)) : Value}
    (do CheckResult<Bool>:
      +bound2680 : Value <- Rules.open_closure(scrut2677, d1_1217, Con{scrut2678, Nil{}})
      +bound2682 : Value <- Rules.open_closure(scrut2677, d2_1218, Con{scrut2678, Nil{}})
      Get.Rules.Ops.o_conv_type(q0, A0, ops_1214)(Get.Rules.Ops.o_bind(q0, A0, ops_1214)(p2675, p2674, p2676, ctx_1215), bound2680, bound2682)))))))
@unsafe
def Rules.spi_ann_lvl_eq(+_s_1250: Shape<&2, Value>, +_u1_1251: OptionOf(Level), +_u2_1252: OptionOf(Level)) -> Bool:
  True{}
@unsafe
def Rules.payload_lvl(-q0: Quant, -A0: Kind(q0), +f_991: Reusable(ListOf(Level), Level), +_ops_992: Rules.Ops<q0, A0>, +_ctx_993: A0, +_s_994: Shape<&2, Value>, +ls_995: ListOf(Level)) -> CheckResult(Level):
  Done{f_991(ls_995)}
@unsafe
def Rules.no_subsingleton(-q0: Quant, -A0: Kind(q0), +_ops_1255: Rules.Ops<q0, A0>, +_ctx_1256: A0, +_s_1257: Shape<&2, Value>) -> CheckResult(Bool):
  Done{False{}}
@unsafe
def Rules.spi_pack(-q0: Quant, -A0: Kind(q0), +param_1270: Unit) -> Rules.Rule_pack<q0, A0>:
  (+scrut2072 = param_1270
  (MkRules_Rule_pack{(+local2074 => +local2076 => +local2078 => +local2080 => +local2082 => (Rules.spi_form(q0, A0, Rules.spi_lan_lvl, local2074, local2076, local2078, local2080, local2082))), (+local2123 => +local2125 => +local2127 => +local2129 => +local2131 => (Rules.spi_form(q0, A0, Rules.spi_ran_lvl, local2123, local2125, local2127, local2129, local2131))), Rules.spi_intro_in(q0, A0), Rules.spi_elim_elim(q0, A0), Rules.spi_intro_sec(q0, A0), Rules.spi_elim_out(q0, A0), Rules.spi_beta, MkRules_Eta_row{True{}, True{}}, Rules.spi_diagram_arity, Rules.spi_spine_ty(q0, A0), Some{Rules.spi_eta_ran(q0, A0)}, Some{Rules.spi_eta_lan(q0, A0)}, Rules.spi_conv_diagram(q0, A0), Rules.spi_ann_lvl_eq, (+local2691 => +local2693 => +local2695 => +local2697 => (Rules.payload_lvl(q0, A0, Rules.spi_lan_lvl, local2691, local2693, local2695, local2697))), (+local2703 => +local2705 => +local2707 => +local2709 => (Rules.payload_lvl(q0, A0, Rules.spi_ran_lvl, local2703, local2705, local2707, local2709))), Rules.no_subsingleton(q0, A0)}))
@unsafe
def Rules.coll_lvl(+ls_1273: ListOf(Level)) -> Level:
  Rules.max_of(ls_1273)
@unsafe
def Rules.diagram_msg() -> String:
  "the diagram is not a section of the declared width"
@unsafe
def Rules.as_vcoll(-q0: Quant, -A0: Kind(q0), +s_817: Shape<q0, A0>) -> OptionOf(Big):
  (+scrut2732 = s_817
  Match.Shape(q0, A0, &2, OptionOf(Big), scrut2732, +p2733 => +p2734 => +p2735 => (None{}), +p2736 => (Some{p2736}), +p2737 => +p2738 => (None{}), +p2739 => +p2740 => (None{}), +p2741 => +p2742 => (None{})))
@unsafe
def Rules.as_tsec(+t_821: Term) -> OptionOf(TupleOf2(Shape<&2, Term>, ListOf(Term.Leg))):
  (+scrut2746 = t_821
  Match.Term(&2, OptionOf(TupleOf2(Shape<&2, Term>, ListOf(Term.Leg))), scrut2746, +p2747 => (None{}), +p2748 => (None{}), +p2749 => +p2750 => (None{}), +p2751 => +p2752 => (None{}), +p2753 => +p2754 => +p2755 => (None{}), +p2756 => (None{}), +p2757 => +p2758 => (Some{Tup2{p2757, p2758}}), +p2759 => +p2760 => +p2761 => (None{}), +p2762 => +p2763 => +p2764 => +p2765 => (None{}), +p2766 => +p2767 => (None{}), +p2768 => (None{}), +p2769 => (None{}), _ => (None{})))
@unsafe
def Rules.coll_levels(-q0: Quant, -A0: Kind(q0), +ops_1276: Rules.Ops<q0, A0>, +ctx_1277: A0, +s_1278: Shape<&2, Term>, +diagram_1279: Term, +expected_1280: OptionOf(Level)) -> CheckResult(Level):
  (do CheckResult<Level>:
    +bound2714 : Big <- (+local2775 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2775, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vcoll(&2, Term, s_1278))
    +bound2716 : TupleOf2(Shape<&2, Term>, ListOf(Term.Leg)) <- (+local2772 => (Match.Maybe(&2, TupleOf2(Shape<&2, Term>, ListOf(Term.Leg)), &2, CheckResult(TupleOf2(Shape<&2, Term>, ListOf(Term.Leg))), local2772, _ => Fail{Error.Mismatch{Rules.diagram_msg()}}, +x => Done{x})))(Rules.as_tsec(diagram_1279))
    Match.Tuple2(&2, Shape<&2, Term>, &2, ListOf(Term.Leg), &2, CheckResult(Level), bound2716, +p2717 => +p2718 => ((do CheckResult<Level>:
      +bound2720 : Big <- (+local2745 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2745, _ => Fail{Error.Mismatch{Rules.diagram_msg()}}, +x => Done{x})))(Rules.as_vcoll(&2, Term, p2717))
      ((do CheckResult<Level>:
  +bound2722 : Unit <- Native.choose(&2, CheckResult(Unit), Big.when(Bool, Big.is_eq(bound2720, bound2714), _ => (Big.is_eq(Big.of_nat(List.length(&2, Term.Leg, p2718)), bound2714)), _ => (False{})), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{Rules.diagram_msg()}}))
  +bound2724 : Unit <- Native.choose(&2, CheckResult(Unit), SeqList.all(&2, Term.Leg, (+local2730 => (Big.is_eq(Big.of_nat(List.length(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(local2730))), Big.zero()))), p2718), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{"a diagram leg binds nothing"}}))
  +bound2726 : ListOf(Level) <- Rules.all_ok(&2, Level, SeqList.map(&2, &2, Term.Leg, CheckResult(Level), (+local2728 => (Get.Rules.Ops.o_infer_univ(q0, A0, ops_1276)(ctx_1277, Get.Term.Leg.l_body(local2728)))), p2718))
  Native.choose(&2, CheckResult(Level), Big.is_eq(bound2714, Big.zero()), _ => (Done{Maybe.default(&2, Level, expected_1280, Level.zero())}), _ => (Done{Rules.coll_lvl(bound2726)}))))))))
@unsafe
def Rules.coll_leg_ty(-q0: Quant, -A0: Kind(q0), +ops_1302: Rules.Ops<q0, A0>, +ctx_1303: A0, +legs_1304: ListOf(Value.Vleg), +k_1305: Big) -> CheckResult(Value):
  (do CheckResult<Value>:
    +bound2799 : Value.Vleg <- (+local2802 => (Match.Maybe(&2, Value.Vleg, &2, CheckResult(Value.Vleg), local2802, _ => Fail{Error.Wrong_leg{Rules.leg_msg()}}, +x => Done{x})))(Rules.at(&2, Value.Vleg, k_1305, legs_1304))
    Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1302)(ctx_1303), Get.Value.Vleg.vl_clo(bound2799), Nil{}))
@unsafe
def Rules.coll_legs_of(-q0: Quant, -A0: Kind(q0), +ops_1293: Rules.Ops<q0, A0>, +ctx_1294: A0, +dclo_1295: Value.Closure) -> CheckResult(ListOf(Value.Vleg)):
  (do CheckResult<ListOf(Value.Vleg)>:
    +bound2804 : Value <- Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1293)(ctx_1294), dclo_1295, Nil{})
    (+local2810 => (Match.Result(&2, TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg)), &2, Error, &2, CheckResult(ListOf(Value.Vleg)), local2810, +item2816 => (Done{(+local2812 => ((+scrut2813 = local2812
    Match.Tuple2(&2, Shape<&2, Value>, &2, ListOf(Value.Vleg), &2, ListOf(Value.Vleg), scrut2813, +p2814 => +p2815 => (p2815)))))(item2816)}), +item2817 => Fail{item2817})))((+local2807 => (Match.Maybe(&2, TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg)), &2, CheckResult(TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg))), local2807, _ => Fail{Error.Mismatch{Rules.diagram_msg()}}, +x => Done{x})))(Value.as_sec(bound2804))))
@unsafe
def Rules.coll_intro_in(-q0: Quant, -A0: Kind(q0), +ops_1359: Rules.Ops<q0, A0>, +ctx_1360: A0, +mode_1361: Quantity, +_s_1362: Shape<&2, Term>, +addr_1363: Term.Addr, +args_1364: ListOf(Term), +expected_1365: Value) -> CheckResult(Quantity.Usage):
  (do CheckResult<Quantity.Usage>:
    +bound2777 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1359, ctx_1360, Value.as_lan, "an injection needs a left former as its expected type", expected_1365)
    Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(Quantity.Usage), bound2777, +p2778 => +p2779 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Quantity.Usage), p2779, +p2780 => +p2781 => +p2782 => ((do CheckResult<Quantity.Usage>:
      +bound2784 : Big <- (+local2824 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2824, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vcoll(&2, Value, p2780))
      ((do CheckResult<Quantity.Usage>:
  +bound2786 : Big <- (+local2820 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2820, _ => Fail{Error.Wrong_leg{"an injection takes the leg address"}}, +x => Done{x})))(Term.as_aleg(addr_1363))
  +bound2788 : Unit <- Native.choose(&2, CheckResult(Unit), Big.when(Bool, Big.is_le(Big.zero(), bound2786), _ => (Big.is_lt(bound2786, bound2784)), _ => (False{})), _ => (Done{Unit{}}), _ => (Fail{Error.Wrong_leg{Rules.leg_msg()}}))
  +bound2790 : ListOf(Value.Vleg) <- Rules.coll_legs_of(q0, A0, ops_1359, ctx_1360, p2781)
  +bound2792 : Value <- Rules.coll_leg_ty(q0, A0, ops_1359, ctx_1360, bound2790, bound2786)
  +bound2794 : Term <- (+local2797 => (Match.Maybe(&2, Term, &2, CheckResult(Term), local2797, _ => Fail{Error.Mismatch{"an injection carries one payload"}}, +x => Done{x})))(Rules.one_of(&2, Term, args_1364))
  Get.Rules.Ops.o_check(q0, A0, ops_1359)(ctx_1360, mode_1361, bound2794, bound2792)))))))))
@unsafe
def Quantity.minimum(+a_319: Quantity, +b_320: Quantity) -> Quantity:
  Native.choose(&2, Quantity, Big.is_le(Quantity.rank(a_319), Quantity.rank(b_320)), _ => (a_319), _ => (b_320))
@unsafe
def Quantity.alternative(+a_645: Quantity.Usage, +b_646: Quantity.Usage) -> Quantity.Usage:
  (+scrut2854 = {(+local2851 => (Match.Maybe(&2, Assoc<&2, Big, Quantity.Interval>, &2, OptionOf(Assoc<&2, Big, Quantity.Interval>), Get.Quantity.Usage.paths(b_646), _ => (Some{local2851}), +value => ((+local2853 => (Some{Quantity.combine(Quantity.minimum, Quantity.maximum, local2851, local2853)}))(value))))) : Reusable(Assoc<&2, Big, Quantity.Interval>, OptionOf(Assoc<&2, Big, Quantity.Interval>))}
  MkQuantity_Usage{Match.Maybe(&2, Assoc<&2, Big, Quantity.Interval>, &2, OptionOf(Assoc<&2, Big, Quantity.Interval>), Get.Quantity.Usage.paths(a_645), _ => (Get.Quantity.Usage.paths(b_646)), +value => (scrut2854(value))), Quantity.combine(Quantity.maximum, Quantity.maximum, Get.Quantity.Usage.reads(a_645), Get.Quantity.Usage.reads(b_646))})
@unsafe
def Quantity.unreachable() -> Quantity.Usage:
  MkQuantity_Usage{None{}, Assoc.empty(&2, Big, Quantity.Interval)}
@unsafe
def Rules.coll_branch(-q0: Quant, -A0: Kind(q0), +ops_1400: Rules.Ops<q0, A0>, +ctx_1401: A0, +mode_1402: Quantity, +e_1403: Term.Elim, +vs_1404: Shape<&2, Value>, +dlegs_1405: ListOf(Value.Vleg), +expected_1406: OptionOf(Value), +k_1407: Big) -> CheckResult(Quantity.Usage):
  (do CheckResult<Quantity.Usage>:
    +bound2860 : TupleOf2(Term.Addr, Term.Leg) <- (+local2888 => (Match.Maybe(&2, TupleOf2(Term.Addr, Term.Leg), &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), local2888, _ => Fail{Error.Missing_branch{String.concat(["no branch at leg ", Big.show(k_1407)])}}, +x => Done{x})))(SeqList.find(&2, TupleOf2(Term.Addr, Term.Leg), (+local2880 => ((+scrut2881 = local2880
    Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, Bool, scrut2881, +p2882 => +p2883 => (Match.Maybe(&2, Big, &2, Bool, Term.as_aleg(p2882), _ => Bool.not(Maybe.is_some(&2, Big, Some{k_1407})), +x => Match.Maybe(&2, Big, &2, Bool, Some{k_1407}, _ => False{}, +y => (+arg2884 => +arg2885 => Big.is_eq(arg2884, arg2885))(x, y)))))))), Get.Term.Elim.e_branches(e_1403)))
    Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(Quantity.Usage), bound2860, +p2861 => +p2862 => ((do CheckResult<Quantity.Usage>:
      +bound2864 : TupleOf2(Quantity, String) <- (+local2878 => (Match.Maybe(&2, TupleOf2(Quantity, String), &2, CheckResult(TupleOf2(Quantity, String)), local2878, _ => Fail{Error.Missing_branch{"each branch binds its payload once"}}, +x => Done{x})))(Rules.one_of(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(p2862)))
      Match.Tuple2(&2, Quantity, &2, String, &2, CheckResult(Quantity.Usage), bound2864, +p2865 => +p2866 => (((do CheckResult<Quantity.Usage>:
  +bound2868 : Value <- Rules.coll_leg_ty(q0, A0, ops_1400, ctx_1401, dlegs_1405, k_1407)
  (+scrut2869 = {Value.VIn{vs_1404, Value.VaddrOf.VALeg{k_1407}, Con{Value.var(Get.Rules.Ops.o_size(q0, A0, ops_1400)(ctx_1401)), Nil{}}} : Value}
  (do CheckResult<Quantity.Usage>:
    +bound2871 : Value <- Rules.elim_result(q0, A0, ops_1400, ctx_1401, Get.Term.Elim.e_motive(e_1403), expected_1406, scrut2869)
    (+scrut2872 = {Get.Rules.Ops.o_bind(q0, A0, ops_1400)(p2866, p2865, bound2868, ctx_1401) : A0}
    (do CheckResult<Quantity.Usage>:
      +bound2874 : Quantity.Usage <- Get.Rules.Ops.o_check(q0, A0, ops_1400)(scrut2872, Quantity.runtime(mode_1402), Get.Term.Leg.l_body(p2862), bound2871)
      Get.Rules.Ops.o_close(q0, A0, ops_1400)(scrut2872, Get.Rules.Ops.o_size(q0, A0, ops_1400)(ctx_1401), mode_1402, bound2874)))))))))))))
@unsafe
def Rules.coll_elim_elim(-q0: Quant, -A0: Kind(q0), +ops_1424: Rules.Ops<q0, A0>, +ctx_1425: A0, +mode_1426: Quantity, +e_1427: Term.Elim, +expected_1428: OptionOf(Value)) -> CheckResult(TupleOf2(Value, Quantity.Usage)):
  (do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2826 : TupleOf2(Value, Quantity.Usage) <- Rules.infer_scrutinee(q0, A0, ops_1424, ctx_1425, mode_1426, e_1427)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2826, +p2827 => +p2828 => (((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2830 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1424, ctx_1425, Value.as_lan, "the scrutinee is not a left former", p2827)
  Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2830, +p2831 => +p2832 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), p2832, +p2833 => +p2834 => +p2835 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2837 : Big <- (+local2895 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2895, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vcoll(&2, Value, p2833))
    +bound2839 : Unit <- Rules.check_motive(q0, A0, ops_1424, ctx_1425, Get.Term.Elim.e_motive(e_1427), p2831)
    +bound2841 : Value <- Get.Rules.Ops.o_eval(q0, A0, ops_1424)(ctx_1425, Get.Term.Elim.e_scrut(e_1427))
    +bound2843 : Value <- Rules.elim_result(q0, A0, ops_1424, ctx_1425, Get.Term.Elim.e_motive(e_1427), expected_1428, bound2841)
    ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2845 : Unit <- Native.choose(&2, CheckResult(Unit), Big.is_eq(Big.of_nat(List.length(&2, TupleOf2(Term.Addr, Term.Leg), Get.Term.Elim.e_branches(e_1427))), bound2837), _ => (Done{Unit{}}), _ => (Fail{Error.Missing_branch{String.concat(["the case has ", Big.show(Big.of_nat(List.length(&2, TupleOf2(Term.Addr, Term.Leg), Get.Term.Elim.e_branches(e_1427)))), " branches and the type has ", Big.show(bound2837), " legs"])}}))
  +bound2847 : ListOf(Value.Vleg) <- Rules.coll_legs_of(q0, A0, ops_1424, ctx_1425, p2834)
  +bound2849 : ListOf(Quantity.Usage) <- Rules.all_ok(&2, Quantity.Usage, SeqList.map(&2, &2, Big, CheckResult(Quantity.Usage), (+local2858 => (Rules.coll_branch(q0, A0, ops_1424, ctx_1425, mode_1426, e_1427, p2833, bound2847, expected_1428, local2858))), SeqList.init(&2, Big, bound2837, (+local2891 => (local2891)))))
  (+scrut2855 = {SeqList.fold(&2, &2, Quantity.Usage, Quantity.Usage, Quantity.alternative, bound2849, Quantity.unreachable()) : Quantity.Usage}
  Done{Tup2{bound2843, Quantity.sequence(p2828, Quantity.scale(mode_1426, scrut2855))}})))))))))))))
@unsafe
def Rules.zip(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), +xs_825: List<q0, A0>, +ys_826: List<q1, A1>) -> Maybe<(q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>>:
  (+scrut2923 = {Tup2{xs_825, ys_826} : Tuple2<q0, q1, List<q0, A0>, List<q1, A1>>}
  Match.Tuple2(q0, List<q0, A0>, q1, List<q1, A1>, (q0 <&> q1), Maybe<(q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>>, scrut2923, +p2924 => +p2925 => (Match.List(q0, A0, (q0 <&> q1), Maybe<(q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>>, p2924, _ => (Match.List(q1, A1, (q0 <&> q1), Maybe<(q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>>, p2925, _ => (Some{Nil{}}), +p2926 => +p2927 => (None{}))), +p2928 => +p2929 => (Match.List(q1, A1, (q0 <&> q1), Maybe<(q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>>, p2925, _ => (None{}), +p2930 => +p2931 => (Match.Maybe((q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>, (q0 <&> q1), Maybe<(q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>>, Rules.zip(q0, A0, q1, A1, p2929, p2931), _ => None{}, +item2935 => (Some{(+local2933 => (Con{Tup2{p2928, p2930}, local2933}))(item2935)})))))))))
@unsafe
def Rules.coll_intro_sec(-q0: Quant, -A0: Kind(q0), +ops_1336: Rules.Ops<q0, A0>, +ctx_1337: A0, +mode_1338: Quantity, +s_1339: Shape<&2, Term>, +legs_1340: ListOf(Term.Leg), +expected_1341: Value) -> CheckResult(Quantity.Usage):
  (do CheckResult<Quantity.Usage>:
    +bound2898 : Big <- (+local2946 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2946, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vcoll(&2, Term, s_1339))
    ((do CheckResult<Quantity.Usage>:
  +bound2900 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1336, ctx_1337, Value.as_ran, "a tuple needs a right former as its expected type", expected_1341)
  Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(Quantity.Usage), bound2900, +p2901 => +p2902 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Quantity.Usage), p2902, +p2903 => +p2904 => +p2905 => ((do CheckResult<Quantity.Usage>:
    +bound2907 : Big <- (+local2942 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2942, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vcoll(&2, Value, p2903))
    +bound2909 : Unit <- Native.choose(&2, CheckResult(Unit), Big.when(Bool, Big.is_eq(bound2907, bound2898), _ => (Big.is_eq(Big.of_nat(List.length(&2, Term.Leg, legs_1340)), bound2898)), _ => (False{})), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{"the tuple width and the type width differ"}}))
    +bound2911 : ListOf(Value.Vleg) <- Rules.coll_legs_of(q0, A0, ops_1336, ctx_1337, p2904)
    ((do CheckResult<Quantity.Usage>:
  +bound2913 : ListOf(TupleOf2(Term.Leg, Value.Vleg)) <- (+local2938 => (Match.Maybe(&2, ListOf(TupleOf2(Term.Leg, Value.Vleg)), &2, CheckResult(ListOf(TupleOf2(Term.Leg, Value.Vleg))), local2938, _ => Fail{Error.Mismatch{Rules.diagram_msg()}}, +x => Done{x})))(Rules.zip(&2, Term.Leg, &2, Value.Vleg, legs_1340, bound2911))
  +bound2915 : ListOf(Quantity.Usage) <- Rules.all_ok(&2, Quantity.Usage, SeqList.map(&2, &2, TupleOf2(Term.Leg, Value.Vleg), CheckResult(Quantity.Usage), (+local2917 => ((+scrut2918 = local2917
  Match.Tuple2(&2, Term.Leg, &2, Value.Vleg, &2, CheckResult(Quantity.Usage), scrut2918, +p2919 => +p2920 => ((do CheckResult<Quantity.Usage>:
    +bound2922 : Value <- Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1336)(ctx_1337), Get.Value.Vleg.vl_clo(p2920), Nil{})
    Get.Rules.Ops.o_check(q0, A0, ops_1336)(ctx_1337, mode_1338, Get.Term.Leg.l_body(p2919), bound2922))))))), bound2913))
  Done{SeqList.fold(&2, &2, Quantity.Usage, Quantity.Usage, Quantity.sequence, bound2915, Quantity.empty())}))))))))))
@unsafe
def Rules.coll_elim_out(-q0: Quant, -A0: Kind(q0), +ops_1379: Rules.Ops<q0, A0>, +ctx_1380: A0, +mode_1381: Quantity, +_s_1382: Shape<&2, Term>, +addr_1383: Term.Addr, +head_1384: Term) -> CheckResult(TupleOf2(Value, Quantity.Usage)):
  (do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2948 : Big <- (+local2974 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2974, _ => Fail{Error.Wrong_leg{"a projection takes the leg address"}}, +x => Done{x})))(Term.as_aleg(addr_1383))
    +bound2950 : TupleOf2(Value, Quantity.Usage) <- Get.Rules.Ops.o_infer(q0, A0, ops_1379)(ctx_1380, mode_1381, head_1384)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2950, +p2951 => +p2952 => (((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound2954 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1379, ctx_1380, Value.as_ran, "a projection needs a right former", p2951)
  Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound2954, +p2955 => +p2956 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), p2956, +p2957 => +p2958 => +p2959 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound2961 : Big <- (+local2970 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local2970, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vcoll(&2, Value, p2957))
    +bound2963 : Unit <- Native.choose(&2, CheckResult(Unit), Big.when(Bool, Big.is_le(Big.zero(), bound2948), _ => (Big.is_lt(bound2948, bound2961)), _ => (False{})), _ => (Done{Unit{}}), _ => (Fail{Error.Wrong_leg{Rules.leg_msg()}}))
    +bound2965 : ListOf(Value.Vleg) <- Rules.coll_legs_of(q0, A0, ops_1379, ctx_1380, p2958)
    +bound2967 : Value <- Rules.coll_leg_ty(q0, A0, ops_1379, ctx_1380, bound2965, bound2948)
    Done{Tup2{bound2967, p2952}}))))))))))
@unsafe
def Value.as_leg(+a_482: Value.Vaddr) -> OptionOf(Big):
  (+scrut2980 = a_482
  Match.Value_Vaddr(&2, OptionOf(Big), scrut2980, +p2981 => +p2982 => (None{}), +p2983 => (Some{p2983}), +p2984 => (None{})))
@unsafe
def Rules.coll_beta(+ev_1309: Rules.Evaluator, +r_1310: Rules.Beta_redex) -> CheckResult(OptionOf(Value)):
  (+scrut2975 = r_1310
  Match.Rules_Beta_redex(&2, CheckResult(OptionOf(Value)), scrut2975, +p2976 => +p2977 => +p2978 => (Rules.let_(&2, Big, Value.as_leg(p2977), (+local2986 => (Rules.let_(&2, TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg)), Value.as_sec(p2978), (+local2989 => ((+scrut2990 = local2989
  Match.Tuple2(&2, Shape<&2, Value>, &2, ListOf(Value.Vleg), &2, CheckResult(OptionOf(Value)), scrut2990, +p2991 => +p2992 => (Rules.let_(&2, Value.Vleg, Rules.at(&2, Value.Vleg, local2986, p2992), (+local2995 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Rules.open_closure(ev_1309, Get.Value.Vleg.vl_clo(local2995), Nil{}), +item2999 => (Done{(+local2998 => (Some{local2998}))(item2999)}), +item3000 => Fail{item3000})))))))))))))), +p3001 => +p3002 => +p3003 => +p3004 => (Rules.let_(&2, TupleOf3(Shape<&2, Value>, Value.Vaddr, ListOf(Value)), Value.as_in(p3004), (+local3007 => ((+scrut3008 = local3007
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Vaddr, &2, ListOf(Value), &2, CheckResult(OptionOf(Value)), scrut3008, +p3009 => +p3010 => +p3011 => ((Rules.let_(&2, Big, Value.as_leg(p3010), (+local3014 => (Rules.let_(&2, TupleOf2(Term.Addr, Term.Leg), SeqList.find(&2, TupleOf2(Term.Addr, Term.Leg), (+local3017 => ((+scrut3018 = local3017
Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, Bool, scrut3018, +p3019 => +p3020 => (Match.Maybe(&2, Big, &2, Bool, Term.as_aleg(p3019), _ => Bool.not(Maybe.is_some(&2, Big, Some{local3014})), +x => Match.Maybe(&2, Big, &2, Bool, Some{local3014}, _ => False{}, +y => (+arg3021 => +arg3022 => Big.is_eq(arg3021, arg3022))(x, y)))))))), p3002), (+local3024 => ((+scrut3025 = local3024
Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(OptionOf(Value)), scrut3025, +p3026 => +p3027 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Get.Rules.Evaluator.ev_eval(ev_1309)(List.reverse.go(&2, Value, p3011, p3003), Get.Term.Leg.l_body(p3027)), +item3031 => (Done{(+local3030 => (Some{local3030}))(item3031)}), +item3032 => Fail{item3032}))))))))))))))))))))
@unsafe
def Rules.coll_diagram_arity(+_s_1247: Shape<&2, Value>) -> Big:
  Big.zero()
@unsafe
def Rules.coll_spine_ty(-q0: Quant, -A0: Kind(q0), +ops_1474: Rules.Ops<q0, A0>, +ctx_1475: A0, +_s_1476: Shape<&2, Value>, +dclo_1477: Value.Closure, +addr_1478: Value.Vaddr) -> CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))):
  (+local3036 => (Match.Maybe(&2, Big, &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), local3036, _ => (Done{None{}}), +value => ((+local3038 => ((do CheckResult<OptionOf(TupleOf2(OptionOf(Value), Value))>:
    +bound3040 : ListOf(Value.Vleg) <- Rules.coll_legs_of(q0, A0, ops_1474, ctx_1475, dclo_1477)
    (+local3043 => (Match.Maybe(&2, Value.Vleg, &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), local3043, _ => (Done{None{}}), +value => ((+local3045 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), Rules.open_closure(Get.Rules.Ops.o_ev(q0, A0, ops_1474)(ctx_1475), Get.Value.Vleg.vl_clo(local3045), Nil{}), +item3048 => (Done{(+local3047 => (Some{Tup2{None{}, local3047}}))(item3048)}), +item3049 => Fail{item3049})))(value)))))(Rules.at(&2, Value.Vleg, local3038, bound3040)))))(value)))))(Value.as_leg(addr_1478))
@unsafe
def Rules.coll_eta_ran(-q0: Quant, -A0: Kind(q0), +ops_1447: Rules.Ops<q0, A0>, +ctx_1448: A0, +s_1449: Shape<&2, Value>, +dclo_1450: Value.Closure, +a_1451: Value, +b_1452: Value) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound3051 : Big <- (+local3073 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local3073, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vcoll(&2, Value, s_1449))
    +bound3053 : ListOf(Value.Vleg) <- Rules.coll_legs_of(q0, A0, ops_1447, ctx_1448, dclo_1450)
    ((+scrut3054 = {Get.Rules.Ops.o_ev(q0, A0, ops_1447)(ctx_1448) : Rules.Evaluator}
SeqList.fold(&2, &2, Big, CheckResult(Bool), (+local3056 => +local3058 => ((do CheckResult<Bool>:
  +bound3060 : Bool <- local3056
  Native.choose(&2, CheckResult(Bool), bound3060, _ => ((do CheckResult<Bool>:
    +bound3062 : Value <- Rules.coll_leg_ty(q0, A0, ops_1447, ctx_1448, bound3053, local3058)
    +bound3064 : Value <- Rules.out_with(Rules.coll_beta, scrut3054, s_1449, Value.VaddrOf.VALeg{local3058}, a_1451)
    +bound3066 : Value <- Rules.out_with(Rules.coll_beta, scrut3054, s_1449, Value.VaddrOf.VALeg{local3058}, b_1452)
    Get.Rules.Ops.o_conv(q0, A0, ops_1447)(ctx_1448, bound3062, bound3064, bound3066))), _ => (Done{False{}}))))), SeqList.init(&2, Big, bound3051, (+local3069 => (local3069))), Done{True{}}))))
@unsafe
def Rules.coll_conv_diagram(-q0: Quant, -A0: Kind(q0), +ops_1464: Rules.Ops<q0, A0>, +ctx_1465: A0, +_s_1466: Shape<&2, Value>, +d1_1467: Value.Closure, +d2_1468: Value.Closure) -> CheckResult(Bool):
  (+scrut3074 = {Get.Rules.Ops.o_ev(q0, A0, ops_1464)(ctx_1465) : Rules.Evaluator}
  (do CheckResult<Bool>:
    +bound3076 : Value <- Rules.open_closure(scrut3074, d1_1467, Nil{})
    +bound3078 : Value <- Rules.open_closure(scrut3074, d2_1468, Nil{})
    Get.Rules.Ops.o_conv_type(q0, A0, ops_1464)(ctx_1465, bound3076, bound3078)))
@unsafe
def Rules.coll_ann_lvl_eq(+s_1485: Shape<&2, Value>, +u1_1486: OptionOf(Level), +u2_1487: OptionOf(Level)) -> Bool:
  (+local3081 => (Match.Maybe(&2, Big, &2, Bool, local3081, _ => (True{}), +value => ((+local3083 => (Native.choose(&2, Bool, Big.is_eq(local3083, Big.zero()), _ => (Level.equal(Maybe.default(&2, Level, u1_1486, Level.zero()), Maybe.default(&2, Level, u2_1487, Level.zero()))), _ => (True{}))))(value)))))(Rules.as_vcoll(&2, Value, s_1485))
@unsafe
def Rules.coll_pack(-q0: Quant, -A0: Kind(q0), +param_1491: Unit) -> Rules.Rule_pack<q0, A0>:
  (+scrut2712 = param_1491
  MkRules_Rule_pack{Rules.coll_levels(q0, A0), Rules.coll_levels(q0, A0), Rules.coll_intro_in(q0, A0), Rules.coll_elim_elim(q0, A0), Rules.coll_intro_sec(q0, A0), Rules.coll_elim_out(q0, A0), Rules.coll_beta, MkRules_Eta_row{True{}, False{}}, Rules.coll_diagram_arity, Rules.coll_spine_ty(q0, A0), Some{Rules.coll_eta_ran(q0, A0)}, None{}, Rules.coll_conv_diagram(q0, A0), Rules.coll_ann_lvl_eq, (+local3089 => +local3091 => +local3093 => +local3095 => (Rules.payload_lvl(q0, A0, Rules.coll_lvl, local3089, local3091, local3093, local3095))), (+local3101 => +local3103 => +local3105 => +local3107 => (Rules.payload_lvl(q0, A0, Rules.coll_lvl, local3101, local3103, local3105, local3107))), Rules.no_subsingleton(q0, A0)})
@unsafe
def Rules.mu_telescope_uses(-q0: Quant, -A0: Kind(q0), +ops_1534: Rules.Ops<q0, A0>, +ctx_1535: A0, +mode_1536: Quantity, +what_1537: String, +tele_1538: Positivity.Telescope, +args_1539: ListOf(Term), +env_1540: ListOf(Value)) -> CheckResult(TupleOf2(ListOf(Value), Quantity.Usage)):
  (do CheckResult<TupleOf2(ListOf(Value), Quantity.Usage)>:
    +bound3131 : ListOf(TupleOf2(TupleOf3(Quantity, String, Term), Term)) <- (+local3156 => (Match.Maybe(&2, ListOf(TupleOf2(TupleOf3(Quantity, String, Term), Term)), &2, CheckResult(ListOf(TupleOf2(TupleOf3(Quantity, String, Term), Term))), local3156, _ => Fail{Error.Mismatch{String.concat([what_1537, " takes ", Big.show(Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), tele_1538))), " arguments and the term gives ", Big.show(Big.of_nat(List.length(&2, Term, args_1539)))])}}, +x => Done{x})))(Rules.zip(&2, TupleOf3(Quantity, String, Term), &2, Term, tele_1538, args_1539))
    (+scrut3132 = {Get.Rules.Ops.o_ev(q0, A0, ops_1534)(ctx_1535) : Rules.Evaluator}
    (SeqList.fold(&2, &2, TupleOf2(TupleOf3(Quantity, String, Term), Term), CheckResult(TupleOf2(ListOf(Value), Quantity.Usage)), (+local3134 => +local3136 => ((+scrut3137 = local3136
Match.Tuple2(&2, TupleOf3(Quantity, String, Term), &2, Term, &2, CheckResult(TupleOf2(ListOf(Value), Quantity.Usage)), scrut3137, +p3138 => +p3139 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, CheckResult(TupleOf2(ListOf(Value), Quantity.Usage)), p3138, +p3140 => +p3141 => +p3142 => ((do CheckResult<TupleOf2(ListOf(Value), Quantity.Usage)>:
  +bound3144 : TupleOf2(ListOf(Value), Quantity.Usage) <- local3134
  Match.Tuple2(&2, ListOf(Value), &2, Quantity.Usage, &2, CheckResult(TupleOf2(ListOf(Value), Quantity.Usage)), bound3144, +p3145 => +p3146 => ((do CheckResult<TupleOf2(ListOf(Value), Quantity.Usage)>:
    +bound3148 : Value <- Get.Rules.Evaluator.ev_eval(scrut3132)(p3145, p3142)
    +bound3150 : Quantity.Usage <- Get.Rules.Ops.o_check(q0, A0, ops_1534)(ctx_1535, Quantity.mul(mode_1536, p3140), p3139, bound3148)
    +bound3152 : Value <- Get.Rules.Ops.o_eval(q0, A0, ops_1534)(ctx_1535, p3139)
    Done{Tup2{Con{bound3152, p3145}, Quantity.sequence(p3146, bound3150)}}))))))))))), bound3131, Done{Tup2{env_1540, Quantity.empty()}}))))
@unsafe
def Rules.mu_telescope(-q0: Quant, -A0: Kind(q0), +ops_1557: Rules.Ops<q0, A0>, +ctx_1558: A0, +mode_1559: Quantity, +what_1560: String, +tele_1561: Positivity.Telescope, +args_1562: ListOf(Term), +env_1563: ListOf(Value)) -> CheckResult(ListOf(Value)):
  Match.Result(&2, TupleOf2(ListOf(Value), Quantity.Usage), &2, Error, &2, CheckResult(ListOf(Value)), Rules.mu_telescope_uses(q0, A0, ops_1557, ctx_1558, mode_1559, what_1560, tele_1561, args_1562, env_1563), +item3157 => (Done{(+local3129 => (Get.Tuple2.v0(&2, ListOf(Value), &2, Quantity.Usage, local3129)))(item3157)}), +item3158 => Fail{item3158})
@unsafe
def Rules.mu_params_of(+diagram_1527: Term) -> CheckResult(ListOf(Term)):
  (+local3164 => (Match.Result(&2, TupleOf2(Shape<&2, Term>, ListOf(Term.Leg)), &2, Error, &2, CheckResult(ListOf(Term)), local3164, +item3172 => (Done{(+local3166 => ((+scrut3167 = local3166
  Match.Tuple2(&2, Shape<&2, Term>, &2, ListOf(Term.Leg), &2, ListOf(Term), scrut3167, +p3168 => +p3169 => (SeqList.map(&2, &2, Term.Leg, Term, (+local3171 => (Get.Term.Leg.l_body(local3171))), p3169))))))(item3172)}), +item3173 => Fail{item3173})))((+local3161 => (Match.Maybe(&2, TupleOf2(Shape<&2, Term>, ListOf(Term.Leg)), &2, CheckResult(TupleOf2(Shape<&2, Term>, ListOf(Term.Leg))), local3161, _ => Fail{Error.Mismatch{Rules.diagram_msg()}}, +x => Done{x})))(Rules.as_tsec(diagram_1527)))
@unsafe
def Positivity.nonpositive_word() -> String:
  "a family that is not strictly positive arrives at M2"
@unsafe
def Rules.mu_family(-q0: Quant, -A0: Kind(q0), +ops_1511: Rules.Ops<q0, A0>, +ctx_1512: A0, +n_1513: String) -> CheckResult(Positivity.Family):
  (do CheckResult<Positivity.Family>:
    +bound3175 : Positivity.Family <- (+local3180 => (Match.Maybe(&2, Positivity.Family, &2, CheckResult(Positivity.Family), local3180, _ => Fail{Error.Unbound{String.append("the family ", String.append(n_1513, " is not declared"))}}, +x => Done{x})))(Get.Rules.Ops.o_family(q0, A0, ops_1511)(ctx_1512, n_1513))
    (+scrut3176 = {Get.Positivity.Family.f_status(bound3175) : Positivity.Ctor_status}
    Match.Positivity_Ctor_status(&2, CheckResult(Positivity.Family), scrut3176, _ => (Done{bound3175}), _ => (Done{bound3175}), +p3177 => (Native.choose(&2, CheckResult(Positivity.Family), Get.Positivity.Family.f_positive(bound3175), _ => (Done{bound3175}), _ => (Fail{Error.Not_yet{Positivity.nonpositive_word()}}))))))
@unsafe
def Rules.as_vmu(-q0: Quant, -A0: Kind(q0), +s_1497: Shape<q0, A0>) -> Maybe<q0, Tuple2<&2, q0, String, List<q0, A0>>>:
  (+scrut3181 = s_1497
  Match.Shape(q0, A0, q0, Maybe<q0, Tuple2<&2, q0, String, List<q0, A0>>>, scrut3181, +p3182 => +p3183 => +p3184 => (None{}), +p3185 => (None{}), +p3186 => +p3187 => (None{}), +p3188 => +p3189 => (Some{Tup2{p3188, p3189}}), +p3190 => +p3191 => (None{})))
@unsafe
def Rules.mu_form_lan(-q0: Quant, -A0: Kind(q0), +ops_1566: Rules.Ops<q0, A0>, +ctx_1567: A0, +s_1568: Shape<&2, Term>, +diagram_1569: Term, +expected_1570: OptionOf(Level)) -> CheckResult(Level):
  (+scrut3113 = expected_1570
  (+scrut3114 = {Quantity.Zero{} : Quantity}
  ((do CheckResult<Level>:
  +bound3116 : TupleOf2(String, ListOf(Term)) <- (+local3194 => (Match.Maybe(&2, TupleOf2(String, ListOf(Term)), &2, CheckResult(TupleOf2(String, ListOf(Term))), local3194, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vmu(&2, Term, s_1568))
  Match.Tuple2(&2, String, &2, ListOf(Term), &2, CheckResult(Level), bound3116, +p3117 => +p3118 => ((do CheckResult<Level>:
    +bound3120 : Positivity.Family <- Rules.mu_family(q0, A0, ops_1566, ctx_1567, p3117)
    +bound3122 : ListOf(Term) <- Rules.mu_params_of(diagram_1569)
    +bound3124 : ListOf(Value) <- Rules.mu_telescope(q0, A0, ops_1566, ctx_1567, scrut3114, p3117, Get.Positivity.Family.f_params(bound3120), bound3122, Nil{})
    +bound3126 : ListOf(Value) <- Rules.mu_telescope(q0, A0, ops_1566, ctx_1567, scrut3114, String.append("the indices of ", p3117), Get.Positivity.Family.f_indices(bound3120), p3118, bound3124)
    Done{Get.Positivity.Family.f_level(bound3120)})))))))
@unsafe
def Rules.mu_ran_word() -> String:
  "a right former at a mu shape arrives at M2"
@unsafe
def Rules.mu_indices(-q0: Quant, -A0: Kind(q0), +ops_1597: Rules.Ops<q0, A0>, +ctx_1598: A0, +n_1599: String, +ct_1600: Positivity.Ctor, +ixv_1601: ListOf(Value), +env_1602: ListOf(Value)) -> CheckResult(Unit):
  (+scrut3231 = {Big.of_nat(List.length(&2, Term, Get.Positivity.Ctor.c_res_idx(ct_1600))) : Big}
  (do CheckResult<Unit>:
    +bound3233 : ListOf(TupleOf2(Term, Value)) <- (+local3251 => (Match.Maybe(&2, ListOf(TupleOf2(Term, Value)), &2, CheckResult(ListOf(TupleOf2(Term, Value))), local3251, _ => Fail{Error.Mismatch{String.concat([Get.Positivity.Ctor.c_name(ct_1600), " gives ", Big.show(scrut3231), " result indices and ", n_1599, " takes ", Big.show(Big.of_nat(List.length(&2, Value, ixv_1601)))])}}, +x => Done{x})))(Rules.zip(&2, Term, &2, Value, Get.Positivity.Ctor.c_res_idx(ct_1600), ixv_1601))
    (+scrut3234 = {Get.Rules.Ops.o_ev(q0, A0, ops_1597)(ctx_1598) : Rules.Evaluator}
    (SeqList.fold(&2, &2, TupleOf2(Term, Value), CheckResult(Unit), (+local3236 => +local3238 => ((+scrut3239 = local3238
Match.Tuple2(&2, Term, &2, Value, &2, CheckResult(Unit), scrut3239, +p3240 => +p3241 => ((do CheckResult<Unit>:
  +bound3243 : Unit <- local3236
  +bound3245 : Value <- Get.Rules.Evaluator.ev_eval(scrut3234)(env_1602, p3240)
  +bound3247 : Bool <- Get.Rules.Ops.o_conv_type(q0, A0, ops_1597)(ctx_1598, bound3245, p3241)
  Native.choose(&2, CheckResult(Unit), bound3247, _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.concat(["the constructor ", Get.Positivity.Ctor.c_name(ct_1600), " of ", n_1599, " gives the index ", Get.Rules.Ops.o_pp(q0, A0, ops_1597)(ctx_1598, bound3245), " and the type asks for ", Get.Rules.Ops.o_pp(q0, A0, ops_1597)(ctx_1598, p3241)])}})))))))), bound3233, Done{Unit{}})))))
@unsafe
def Rules.mu_param_env(-q0: Quant, -A0: Kind(q0), +ops_1588: Rules.Ops<q0, A0>, +ctx_1589: A0, +dclo_1590: Value.Closure) -> CheckResult(ListOf(Value)):
  (do CheckResult<ListOf(Value)>:
    +bound3253 : ListOf(Value.Vleg) <- Rules.coll_legs_of(q0, A0, ops_1588, ctx_1589, dclo_1590)
    (+scrut3254 = {Get.Rules.Ops.o_ev(q0, A0, ops_1588)(ctx_1589) : Rules.Evaluator}
    (do CheckResult<ListOf(Value)>:
      +bound3256 : ListOf(Value) <- Rules.all_ok(&2, Value, SeqList.map(&2, &2, Value.Vleg, CheckResult(Value), (+local3258 => (Rules.open_closure(scrut3254, Get.Value.Vleg.vl_clo(local3258), Nil{}))), bound3253))
      Done{List.reverse(&2, Value, bound3256)})))
@unsafe
def Term.as_actor(+a_425: Term.Addr) -> OptionOf(String):
  (+scrut3263 = a_425
  Match.Term_Addr(&2, OptionOf(String), scrut3263, +p3264 => +p3265 => (None{}), +p3266 => (None{}), +p3267 => (Some{p3267})))
@unsafe
def Rules.mu_intro_in(-q0: Quant, -A0: Kind(q0), +ops_1615: Rules.Ops<q0, A0>, +ctx_1616: A0, +mode_1617: Quantity, +_s_1618: Shape<&2, Term>, +addr_1619: Term.Addr, +args_1620: ListOf(Term), +expected_1621: Value) -> CheckResult(Quantity.Usage):
  (do CheckResult<Quantity.Usage>:
    +bound3207 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1615, ctx_1616, Value.as_lan, "a constructor needs a left former", expected_1621)
    Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(Quantity.Usage), bound3207, +p3208 => +p3209 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Quantity.Usage), p3209, +p3210 => +p3211 => +p3212 => (((do CheckResult<Quantity.Usage>:
  +bound3214 : TupleOf2(String, ListOf(Value)) <- (+local3273 => (Match.Maybe(&2, TupleOf2(String, ListOf(Value)), &2, CheckResult(TupleOf2(String, ListOf(Value))), local3273, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vmu(&2, Value, p3210))
  Match.Tuple2(&2, String, &2, ListOf(Value), &2, CheckResult(Quantity.Usage), bound3214, +p3215 => +p3216 => ((do CheckResult<Quantity.Usage>:
    +bound3218 : String <- (+local3270 => (Match.Maybe(&2, String, &2, CheckResult(String), local3270, _ => Fail{Error.Wrong_leg{"a constructor takes a constructor address"}}, +x => Done{x})))(Term.as_actor(addr_1619))
    +bound3220 : Positivity.Family <- Rules.mu_family(q0, A0, ops_1615, ctx_1616, p3215)
    ((do CheckResult<Quantity.Usage>:
  +bound3222 : Positivity.Ctor <- (+local3261 => (Match.Maybe(&2, Positivity.Ctor, &2, CheckResult(Positivity.Ctor), local3261, _ => Fail{Error.Unbound{String.append(bound3218, String.append(" is not a constructor of ", p3215))}}, +x => Done{x})))(Positivity.ctor_of(bound3218, bound3220))
  +bound3224 : ListOf(Value) <- Rules.mu_param_env(q0, A0, ops_1615, ctx_1616, p3211)
  +bound3226 : TupleOf2(ListOf(Value), Quantity.Usage) <- Rules.mu_telescope_uses(q0, A0, ops_1615, ctx_1616, mode_1617, bound3218, Get.Positivity.Ctor.c_args(bound3222), args_1620, bound3224)
  Match.Tuple2(&2, ListOf(Value), &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound3226, +p3227 => +p3228 => ((do CheckResult<Quantity.Usage>:
    +bound3230 : Unit <- Rules.mu_indices(q0, A0, ops_1615, ctx_1616, p3215, bound3222, p3216, p3227)
    Done{p3228})))))))))))))))
@unsafe
def Rules.mu_result(-q0: Quant, -A0: Kind(q0), +ops_1650: Rules.Ops<q0, A0>, +ctx_1651: A0, +mo_1652: Term.Motive, +idx_1653: ListOf(Value), +self_1654: Value) -> CheckResult(Value):
  Get.Rules.Evaluator.ev_eval(Get.Rules.Ops.o_ev(q0, A0, ops_1650)(ctx_1651))(Con{self_1654, List.reverse.go(&2, Value, idx_1653, Get.Rules.Ops.o_env(q0, A0, ops_1650)(ctx_1651))}, Get.Term.Motive.m_body(mo_1652))
@unsafe
def Rules.mu_branch(-q0: Quant, -A0: Kind(q0), +ops_1718: Rules.Ops<q0, A0>, +ctx_1719: A0, +mode_1720: Quantity, +n_1721: String, +fam_1722: Positivity.Family, +mo_1723: Term.Motive, +penv_1724: ListOf(Value), +branches_1725: ListOf(TupleOf2(Term.Addr, Term.Leg)), +c_1726: String) -> CheckResult(Quantity.Usage):
  (do CheckResult<Quantity.Usage>:
    +bound3316 : Positivity.Ctor <- (+local3394 => (Match.Maybe(&2, Positivity.Ctor, &2, CheckResult(Positivity.Ctor), local3394, _ => Fail{Error.Unbound{String.append(c_1726, String.append(" is not a constructor of ", n_1721))}}, +x => Done{x})))(Positivity.ctor_of(c_1726, fam_1722))
    ((do CheckResult<Quantity.Usage>:
  +bound3318 : TupleOf2(Term.Addr, Term.Leg) <- (+local3390 => (Match.Maybe(&2, TupleOf2(Term.Addr, Term.Leg), &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), local3390, _ => Fail{Error.Missing_branch{String.concat(["the elimination of ", n_1721, " has no branch at ", c_1726])}}, +x => Done{x})))(SeqList.find(&2, TupleOf2(Term.Addr, Term.Leg), (+local3382 => ((+scrut3383 = local3382
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, Bool, scrut3383, +p3384 => +p3385 => (Match.Maybe(&2, String, &2, Bool, Term.as_actor(p3384), _ => Bool.not(Maybe.is_some(&2, String, Some{c_1726})), +x => Match.Maybe(&2, String, &2, Bool, Some{c_1726}, _ => False{}, +y => (+arg3386 => +arg3387 => NativeString.equal(arg3386, arg3387))(x, y)))))))), branches_1725))
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(Quantity.Usage), bound3318, +p3319 => +p3320 => (((do CheckResult<Quantity.Usage>:
  +bound3322 : ListOf(TupleOf2(TupleOf3(Quantity, String, Term), TupleOf2(Quantity, String))) <- (+local3379 => (Match.Maybe(&2, ListOf(TupleOf2(TupleOf3(Quantity, String, Term), TupleOf2(Quantity, String))), &2, CheckResult(ListOf(TupleOf2(TupleOf3(Quantity, String, Term), TupleOf2(Quantity, String)))), local3379, _ => Fail{Error.Missing_branch{String.concat(["the branch at ", c_1726, " binds ", Big.show(Big.of_nat(List.length(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(p3320)))), " fields and ", c_1726, " takes ", Big.show(Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Ctor.c_args(bound3316))))])}}, +x => Done{x})))(Rules.zip(&2, TupleOf3(Quantity, String, Term), &2, TupleOf2(Quantity, String), Get.Positivity.Ctor.c_args(bound3316), Get.Term.Leg.l_binders(p3320)))
  (+scrut3323 = {Get.Rules.Ops.o_ev(q0, A0, ops_1718)(ctx_1719) : Rules.Evaluator}
  (Match.Result(q0, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>, &2, Error, &2, CheckResult(Quantity.Usage), SeqList.fold(&2, q0, TupleOf2(TupleOf3(Quantity, String, Term), TupleOf2(Quantity, String)), Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, (+local3326 => +local3328 => ((+scrut3329 = local3328
Match.Tuple2(&2, TupleOf3(Quantity, String, Term), &2, TupleOf2(Quantity, String), q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, scrut3329, +p3330 => +p3331 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, p3330, +p3332 => +p3333 => +p3334 => (Match.Tuple2(&2, Quantity, &2, String, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, p3331, +p3335 => +p3336 => ((Match.Result(q0, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>, &2, Error, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, local3326, +item3356 => ((+local3339 => ((+scrut3340 = local3339
Match.Tuple3(q0, A0, &2, ListOf(Value), &2, ListOf(Value), q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, scrut3340, +p3341 => +p3342 => +p3343 => (Match.Result(&2, Value, &2, Error, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, Get.Rules.Evaluator.ev_eval(scrut3323)(p3342, p3334), +item3354 => ((+local3346 => ((+scrut3347 = {Value.var(Get.Rules.Ops.o_size(q0, A0, ops_1718)(p3341)) : Value}
Match.Result(&2, Unit, &2, Error, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, Rules.binder_quantity("branch binder", "field", p3336, p3335, p3332), +item3352 => ((+local3350 => ((+scrut3351 = local3350
Done{Tup3{Get.Rules.Ops.o_bind(q0, A0, ops_1718)(p3336, p3332, local3346, p3341), Con{scrut3347, p3342}, Con{scrut3347, p3343}}})))(item3352)), +item3353 => Fail{item3353}))))(item3354)), +item3355 => Fail{item3355}))))))(item3356)), +item3357 => Fail{item3357}))))))))))), bound3322, Done{Tup3{ctx_1719, penv_1724, Nil{}}}), +item3374 => ((+local3360 => ((+scrut3361 = local3360
Match.Tuple3(q0, A0, &2, ListOf(Value), &2, ListOf(Value), &2, CheckResult(Quantity.Usage), scrut3361, +p3362 => +p3363 => +p3364 => ((do CheckResult<Quantity.Usage>:
  +bound3366 : ListOf(Value) <- Rules.all_ok(&2, Value, SeqList.map(&2, &2, Term, CheckResult(Value), (+local3373 => (Get.Rules.Evaluator.ev_eval(scrut3323)(p3363, local3373))), Get.Positivity.Ctor.c_res_idx(bound3316)))
  (+scrut3367 = {Value.VIn{Shape.SMu{n_1721, bound3366}, Value.VaddrOf.VACtor{c_1726}, List.reverse(&2, Value, p3364)} : Value}
  (do CheckResult<Quantity.Usage>:
    +bound3369 : Value <- Rules.mu_result(q0, A0, ops_1718, ctx_1719, mo_1723, bound3366, scrut3367)
    +bound3371 : Quantity.Usage <- Get.Rules.Ops.o_check(q0, A0, ops_1718)(p3362, Quantity.runtime(mode_1720), Get.Term.Leg.l_body(p3320), bound3369)
    Get.Rules.Ops.o_close(q0, A0, ops_1718)(p3362, Get.Rules.Ops.o_size(q0, A0, ops_1718)(ctx_1719), mode_1720, bound3371)))))))))(item3374)), +item3375 => Fail{item3375}))))))))))
@unsafe
def Rules.mu_count(+x_1696: String, +xs_1697: ListOf(String)) -> Big:
  Big.of_nat(List.length(&2, String, SeqList.filter(&2, String, (+local3422 => (NativeString.equal(x_1696, local3422))), xs_1697)))
@unsafe
def Rules.mu_cover(+n_1700: String, +names_1701: ListOf(String), +branches_1702: ListOf(TupleOf2(Term.Addr, Term.Leg))) -> CheckResult(Unit):
  (+scrut3400 = {SeqList.filter_map(&2, &2, TupleOf2(Term.Addr, Term.Leg), String, (+local3396 => ((+scrut3397 = local3396
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, OptionOf(String), scrut3397, +p3398 => +p3399 => (Term.as_actor(p3398)))))), branches_1702) : ListOf(String)}
  (do CheckResult<Unit>:
    +bound3402 : Unit <- Native.choose(&2, CheckResult(Unit), Big.is_eq(Big.of_nat(List.length(&2, String, scrut3400)), Big.of_nat(List.length(&2, TupleOf2(Term.Addr, Term.Leg), branches_1702))), _ => (Done{Unit{}}), _ => (Fail{Error.Wrong_leg{String.append("a branch of ", String.append(n_1700, " takes the constructor address"))}}))
    ((do CheckResult<Unit>:
  +bound3404 : Unit <- SeqList.fold(&2, &2, String, CheckResult(Unit), (+local3415 => +local3417 => ((do CheckResult<Unit>:
    +bound3419 : Unit <- local3415
    (+scrut3423 = {Rules.mu_count(local3417, scrut3400) : Big}
    (+scrut3424 = {Unit{} : Unit}
    Native.choose(&2, CheckResult(Unit), Big.is_eq(scrut3423, Big.one()), _ => (Done{Unit{}}), _ => (Native.choose(&2, CheckResult(Unit), Big.is_eq(scrut3423, Big.zero()), _ => (Fail{Error.Missing_branch{String.concat(["the elimination of ", n_1700, " has no branch at ", local3417])}}), _ => (Fail{Error.Wrong_leg{String.concat(["the elimination of ", n_1700, " repeats the branch at ", local3417])}}))))))))), names_1701, Done{Unit{}})
  SeqList.fold(&2, &2, String, CheckResult(Unit), (+local3406 => +local3408 => ((do CheckResult<Unit>:
    +bound3410 : Unit <- local3406
    Native.choose(&2, CheckResult(Unit), SeqList.exists(&2, String, (+local3413 => (NativeString.equal(local3408, local3413))), names_1701), _ => (Done{Unit{}}), _ => (Fail{Error.Unbound{String.append(local3408, String.append(" is not a constructor of ", n_1700))}}))))), scrut3400, Done{Unit{}})))))
@unsafe
def Rules.mu_ctor_names(+n_1691: String, +fam_1692: Positivity.Family) -> CheckResult(ListOf(String)):
  (+scrut3427 = {Get.Positivity.Family.f_status(fam_1692) : Positivity.Ctor_status}
  Match.Positivity_Ctor_status(&2, CheckResult(ListOf(String)), scrut3427, _ => (Fail{Error.Unbound{String.append("the family ", String.append(n_1691, " is still under declaration"))}}), _ => (Fail{Error.Mismatch{String.append("the family ", String.append(n_1691, " is a kernel family and has no branches"))}}), +p3428 => (Done{p3428})))
@unsafe
def Rules.mu_zero_eliminable(+fam_1502: Positivity.Family) -> Bool:
  (+scrut3430 = {Get.Positivity.Family.f_status(fam_1502) : Positivity.Ctor_status}
  Match.Positivity_Ctor_status(&2, Bool, scrut3430, _ => (False{}), _ => (False{}), +p3431 => (Match.List(&2, String, &2, Bool, p3431, _ => (True{}), +p3432 => +p3433 => (Match.List(&2, String, &2, Bool, p3433, _ => ((+local3436 => (Match.Maybe(&2, Positivity.Ctor, &2, Bool, local3436, _ => (False{}), +value => ((+local3438 => (Big.when(Bool, SeqList.all(&2, TupleOf3(Quantity, String, Term), (+local3440 => ((+scrut3441 = local3440
  Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, Bool, scrut3441, +p3442 => +p3443 => +p3444 => (Quantity.equal(p3442, Quantity.Zero{})))))), Get.Positivity.Ctor.c_args(local3438)), _ => (Bool.not(Get.Positivity.Ctor.c_self_rec(local3438))), _ => (False{}))))(value)))))(Positivity.ctor_of(p3432, fam_1502))), +p3445 => +p3446 => (False{})))))))
@unsafe
def Rules.mu_large_word() -> String:
  "a large elimination out of a proposition needs a subsingleton family"
@unsafe
def Rules.mu_large(+n_1686: String, +fam_1687: Positivity.Family, +mlvl_1688: Level) -> CheckResult(Unit):
  (+scrut3429 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Unit), Bool.not(Level.equal(Get.Positivity.Family.f_level(fam_1687), Level.zero())), _ => (Done{Unit{}}), _ => (Native.choose(&2, CheckResult(Unit), Level.equal(mlvl_1688, Level.zero()), _ => (Done{Unit{}}), _ => (Native.choose(&2, CheckResult(Unit), Rules.mu_zero_eliminable(fam_1687), _ => (Done{Unit{}}), _ => (Fail{Error.Universe{String.concat([Rules.mu_large_word(), " at ", n_1686])}})))))))
@unsafe
def Rules.mu_motive_lvl(-q0: Quant, -A0: Kind(q0), +ops_1657: Rules.Ops<q0, A0>, +ctx_1658: A0, +n_1659: String, +fam_1660: Positivity.Family, +mo_1661: Term.Motive, +dclo_1662: Value.Closure, +u_1663: OptionOf(Level), +penv_1664: ListOf(Value)) -> CheckResult(Level):
  (do CheckResult<Level>:
    +bound3448 : ListOf(TupleOf2(TupleOf3(Quantity, String, Term), String)) <- (+local3489 => (Match.Maybe(&2, ListOf(TupleOf2(TupleOf3(Quantity, String, Term), String)), &2, CheckResult(ListOf(TupleOf2(TupleOf3(Quantity, String, Term), String))), local3489, _ => Fail{Error.Mismatch{String.append("the motive of ", String.append(n_1659, " does not bind the indices"))}}, +x => Done{x})))(Rules.zip(&2, TupleOf3(Quantity, String, Term), &2, String, Get.Positivity.Family.f_indices(fam_1660), Get.Term.Motive.m_idx(mo_1661)))
    (+scrut3449 = {Get.Rules.Ops.o_ev(q0, A0, ops_1657)(ctx_1658) : Rules.Evaluator}
    (Match.Result(q0, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>, &2, Error, &2, CheckResult(Level), SeqList.fold(&2, q0, TupleOf2(TupleOf3(Quantity, String, Term), String), Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, (+local3452 => +local3454 => ((+scrut3455 = local3454
Match.Tuple2(&2, TupleOf3(Quantity, String, Term), &2, String, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, scrut3455, +p3456 => +p3457 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, p3456, +p3458 => +p3459 => +p3460 => ((Match.Result(q0, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>, &2, Error, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, local3452, +item3474 => ((+local3463 => ((+scrut3464 = local3463
Match.Tuple3(q0, A0, &2, ListOf(Value), &2, ListOf(Value), q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, scrut3464, +p3465 => +p3466 => +p3467 => (Match.Result(&2, Value, &2, Error, q0, Result<&2, q0, Error, Tuple3<q0, &2, &2, A0, ListOf(Value), ListOf(Value)>>, Get.Rules.Evaluator.ev_eval(scrut3449)(p3466, p3460), +item3472 => ((+local3470 => ((+scrut3471 = {Value.var(Get.Rules.Ops.o_size(q0, A0, ops_1657)(p3465)) : Value}
Done{Tup3{Get.Rules.Ops.o_bind(q0, A0, ops_1657)(p3457, Quantity.Zero{}, local3470, p3465), Con{scrut3471, p3466}, Con{scrut3471, p3467}}})))(item3472)), +item3473 => Fail{item3473}))))))(item3474)), +item3475 => Fail{item3475}))))))))), bound3448, Done{Tup3{ctx_1658, penv_1664, Nil{}}}), +item3484 => ((+local3478 => ((+scrut3479 = local3478
Match.Tuple3(q0, A0, &2, ListOf(Value), &2, ListOf(Value), &2, CheckResult(Level), scrut3479, +p3480 => +p3481 => +p3482 => ((+scrut3483 = {Value.VLan{Shape.SMu{n_1659, List.reverse(&2, Value, p3482)}, dclo_1662, u_1663} : Value}
Get.Rules.Ops.o_infer_univ(q0, A0, ops_1657)(Get.Rules.Ops.o_bind(q0, A0, ops_1657)(Get.Term.Motive.m_self(mo_1661), Quantity.Zero{}, scrut3483, p3480), Get.Term.Motive.m_body(mo_1661))))))))(item3484)), +item3485 => Fail{item3485}))))
@unsafe
def Rules.mu_motive_word() -> String:
  "an elimination at a mu shape needs a motive"
@unsafe
def Rules.mu_motive_of(+n_1640: String, +fam_1641: Positivity.Family, +ixv_1642: ListOf(Value), +e_1643: Term.Elim) -> CheckResult(Term.Motive):
  (do CheckResult<Term.Motive>:
    +bound3491 : Term.Motive <- (+local3503 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(Term.Motive), local3503, _ => Fail{Error.Cannot_infer{Rules.mu_motive_word()}}, +x => Done{x})))(Get.Term.Elim.e_motive(e_1643))
    +bound3493 : String <- (+local3500 => (Match.Maybe(&2, String, &2, CheckResult(String), local3500, _ => Fail{Error.Mismatch{String.append("the motive of an elimination at ", String.append(n_1640, " names no family"))}}, +x => Done{x})))(Get.Term.Motive.m_ind(bound3491))
    (+scrut3494 = {Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Family.f_indices(fam_1641))) : Big}
    (+scrut3495 = {Big.of_nat(List.length(&2, String, Get.Term.Motive.m_idx(bound3491))) : Big}
    ((+scrut3496 = {Unit{} : Unit}
Native.choose(&2, CheckResult(Term.Motive), Bool.not(NativeString.equal(bound3493, n_1640)), _ => (Fail{Error.Mismatch{String.concat(["the motive is built for ", bound3493, " and the scrutinee is at ", n_1640])}}), _ => (Native.choose(&2, CheckResult(Term.Motive), Bool.not(Big.is_eq(scrut3495, scrut3494)), _ => (Fail{Error.Mismatch{String.concat(["the motive of ", n_1640, " binds ", Big.show(scrut3495), " indices and the family has ", Big.show(scrut3494)])}}), _ => (Native.choose(&2, CheckResult(Term.Motive), Bool.not(Big.is_eq(Big.of_nat(List.length(&2, Value, ixv_1642)), scrut3494)), _ => (Fail{Error.Mismatch{String.concat([n_1640, " is applied to ", Big.show(Big.of_nat(List.length(&2, Value, ixv_1642))), " indices and the family has ", Big.show(scrut3494)])}}), _ => (Done{bound3491})))))))))))
@unsafe
def Rules.mu_elim_elim(-q0: Quant, -A0: Kind(q0), +ops_1761: Rules.Ops<q0, A0>, +ctx_1762: A0, +mode_1763: Quantity, +e_1764: Term.Elim, +expected_1765: OptionOf(Value)) -> CheckResult(TupleOf2(Value, Quantity.Usage)):
  (+scrut3275 = expected_1765
  ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound3277 : TupleOf2(Value, Quantity.Usage) <- Rules.infer_scrutinee(q0, A0, ops_1761, ctx_1762, mode_1763, e_1764)
  Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound3277, +p3278 => +p3279 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound3281 : TupleOf2(Value, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))) <- Rules.former_view(q0, A0, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), ops_1761, ctx_1762, Value.as_lan, "the scrutinee is not a left former", p3278)
    Match.Tuple2(&2, Value, &2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound3281, +p3282 => +p3283 => (Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), p3283, +p3284 => +p3285 => +p3286 => (((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound3288 : TupleOf2(String, ListOf(Value)) <- (+local3506 => (Match.Maybe(&2, TupleOf2(String, ListOf(Value)), &2, CheckResult(TupleOf2(String, ListOf(Value))), local3506, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vmu(&2, Value, p3284))
  Match.Tuple2(&2, String, &2, ListOf(Value), &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound3288, +p3289 => +p3290 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound3292 : Positivity.Family <- Rules.mu_family(q0, A0, ops_1761, ctx_1762, p3289)
    +bound3294 : Term.Motive <- Rules.mu_motive_of(p3289, bound3292, p3290, e_1764)
    +bound3296 : ListOf(Value) <- Rules.mu_param_env(q0, A0, ops_1761, ctx_1762, p3285)
    +bound3298 : Level <- Rules.mu_motive_lvl(q0, A0, ops_1761, ctx_1762, p3289, bound3292, bound3294, p3285, p3286, bound3296)
    +bound3300 : Unit <- Rules.mu_large(p3289, bound3292, bound3298)
    +bound3302 : ListOf(String) <- Rules.mu_ctor_names(p3289, bound3292)
    ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound3304 : Unit <- Rules.mu_cover(p3289, bound3302, Get.Term.Elim.e_branches(e_1764))
  +bound3306 : ListOf(Quantity.Usage) <- Rules.all_ok(&2, Quantity.Usage, SeqList.map(&2, &2, String, CheckResult(Quantity.Usage), (+local3314 => (Rules.mu_branch(q0, A0, ops_1761, ctx_1762, mode_1763, p3289, bound3292, bound3294, bound3296, Get.Term.Elim.e_branches(e_1764), local3314))), bound3302))
  +bound3308 : Value <- Get.Rules.Ops.o_eval(q0, A0, ops_1761)(ctx_1762, Get.Term.Elim.e_scrut(e_1764))
  +bound3310 : Value <- Rules.mu_result(q0, A0, ops_1761, ctx_1762, bound3294, p3290, bound3308)
  (+scrut3311 = {SeqList.fold(&2, &2, Quantity.Usage, Quantity.Usage, Quantity.alternative, bound3306, Quantity.unreachable()) : Quantity.Usage}
  Done{Tup2{bound3310, Quantity.sequence(p3279, Quantity.scale(mode_1763, scrut3311))}}))))))))))))))))))
@unsafe
def Value.as_ctor(+a_486: Value.Vaddr) -> OptionOf(String):
  (+scrut3549 = a_486
  Match.Value_Vaddr(&2, OptionOf(String), scrut3549, +p3550 => +p3551 => (None{}), +p3552 => (None{}), +p3553 => (Some{p3553})))
@unsafe
def Rules.mu_beta(+ev_1790: Rules.Evaluator, +r_1791: Rules.Beta_redex) -> CheckResult(OptionOf(Value)):
  (+scrut3533 = r_1791
  Match.Rules_Beta_redex(&2, CheckResult(OptionOf(Value)), scrut3533, +p3534 => +p3535 => +p3536 => (Fail{Error.Not_yet{Rules.mu_ran_word()}}), +p3537 => +p3538 => +p3539 => +p3540 => (Rules.let_(&2, TupleOf3(Shape<&2, Value>, Value.Vaddr, ListOf(Value)), Value.as_in(p3540), (+local3543 => ((+scrut3544 = local3543
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Vaddr, &2, ListOf(Value), &2, CheckResult(OptionOf(Value)), scrut3544, +p3545 => +p3546 => +p3547 => ((Rules.let_(&2, String, Value.as_ctor(p3546), (+local3555 => (Rules.let_(&2, TupleOf2(Term.Addr, Term.Leg), SeqList.find(&2, TupleOf2(Term.Addr, Term.Leg), (+local3558 => ((+scrut3559 = local3558
Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, Bool, scrut3559, +p3560 => +p3561 => (Match.Maybe(&2, String, &2, Bool, Term.as_actor(p3560), _ => Bool.not(Maybe.is_some(&2, String, Some{local3555})), +x => Match.Maybe(&2, String, &2, Bool, Some{local3555}, _ => False{}, +y => (+arg3562 => +arg3563 => NativeString.equal(arg3562, arg3563))(x, y)))))))), p3538), (+local3565 => ((+scrut3566 = local3565
Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(OptionOf(Value)), scrut3566, +p3567 => +p3568 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Get.Rules.Evaluator.ev_eval(ev_1790)(List.reverse.go(&2, Value, p3547, p3539), Get.Term.Leg.l_body(p3568)), +item3572 => (Done{(+local3571 => (Some{local3571}))(item3572)}), +item3573 => Fail{item3573}))))))))))))))))))))
@unsafe
def Rules.mu_lan_lvl(-q0: Quant, -A0: Kind(q0), +ops_1809: Rules.Ops<q0, A0>, +ctx_1810: A0, +s_1811: Shape<&2, Value>, +_ls_1812: ListOf(Level)) -> CheckResult(Level):
  (do CheckResult<Level>:
    +bound3586 : TupleOf2(String, ListOf(Value)) <- (+local3593 => (Match.Maybe(&2, TupleOf2(String, ListOf(Value)), &2, CheckResult(TupleOf2(String, ListOf(Value))), local3593, _ => Fail{Error.Mismatch{Rules.wrong_pack()}}, +x => Done{x})))(Rules.as_vmu(&2, Value, s_1811))
    Match.Tuple2(&2, String, &2, ListOf(Value), &2, CheckResult(Level), bound3586, +p3587 => +p3588 => ((do CheckResult<Level>:
      +bound3590 : Positivity.Family <- Rules.mu_family(q0, A0, ops_1809, ctx_1810, p3587)
      Done{Get.Positivity.Family.f_level(bound3590)}))))
@unsafe
def Rules.mu_subsingleton(-q0: Quant, -A0: Kind(q0), +ops_1517: Rules.Ops<q0, A0>, +ctx_1518: A0, +s_1519: Shape<&2, Value>) -> CheckResult(Bool):
  (+local3604 => (Match.Maybe(&2, TupleOf2(String, ListOf(Value)), &2, CheckResult(Bool), local3604, _ => (Done{False{}}), +value => ((+local3606 => ((+scrut3607 = local3606
  Match.Tuple2(&2, String, &2, ListOf(Value), &2, CheckResult(Bool), scrut3607, +p3608 => +p3609 => ((+local3612 => (Match.Result(&2, Positivity.Family, &2, Error, &2, CheckResult(Bool), local3612, +x => (+local3614 => (Done{Big.when(Bool, Level.equal(Get.Positivity.Family.f_level(local3614), Level.zero()), _ => (Rules.mu_zero_eliminable(local3614)), _ => (False{}))}))(x), +x => (+local3616 => (Done{False{}}))(x))))(Rules.mu_family(q0, A0, ops_1517, ctx_1518, p3608)))))))(value)))))(Rules.as_vmu(&2, Value, s_1519))
@unsafe
def Rules.mu_pack(-q0: Quant, -A0: Kind(q0), +param_1845: Unit) -> Rules.Rule_pack<q0, A0>:
  (+scrut3112 = param_1845
  (MkRules_Rule_pack{Rules.mu_form_lan(q0, A0), (+local3197 => +local3199 => +local3201 => +local3203 => +local3205 => (Fail{Error.Not_yet{Rules.mu_ran_word()}})), Rules.mu_intro_in(q0, A0), Rules.mu_elim_elim(q0, A0), (+local3510 => +local3512 => +local3514 => +local3516 => +local3518 => +local3520 => (Fail{Error.Not_yet{Rules.mu_ran_word()}})), (+local3522 => +local3524 => +local3526 => +local3528 => +local3530 => +local3532 => (Fail{Error.Not_yet{Rules.mu_ran_word()}})), Rules.mu_beta, MkRules_Eta_row{False{}, False{}}, Rules.coll_diagram_arity, (+local3576 => +local3578 => +local3580 => +local3582 => +local3584 => (Done{None{}})), None{}, None{}, Rules.coll_conv_diagram(q0, A0), Rules.spi_ann_lvl_eq, Rules.mu_lan_lvl(q0, A0), (+local3595 => +local3597 => +local3599 => +local3601 => (Fail{Error.Not_yet{Rules.mu_ran_word()}})), Rules.mu_subsingleton(q0, A0)}))
@unsafe
def Rules.rules(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), +s_1848: Shape<q0, A0>) -> Result<&2, &1, Error, Rules.Rule_pack<q1, A1>>:
  (+scrut2068 = s_1848
  Match.Shape(q0, A0, &1, Result<&2, &1, Error, Rules.Rule_pack<q1, A1>>, scrut2068, +p2069 => +p2070 => +p2071 => (Done{Rules.spi_pack(q1, A1, Unit{})}), +p2711 => (Done{Rules.coll_pack(q1, A1, Unit{})}), +p3108 => +p3109 => (Fail{Error.Not_yet{Rules.spar_word()}}), +p3110 => +p3111 => (Done{Rules.mu_pack(q1, A1, Unit{})}), +p3618 => +p3619 => (Fail{Error.Not_yet{Rules.snu_word()}})))
@unsafe
def Rules.elim_value(+ev_1858: Rules.Evaluator, +s_1859: Shape<&2, Value>, +q_1860: Quantity, +mo_1861: OptionOf(Term.Motive), +branches_1862: ListOf(TupleOf2(Term.Addr, Term.Leg)), +env_1863: ListOf(Value), +v_1864: Value) -> CheckResult(Value):
  Match.Result(&1, Rules.Rule_pack<&2, Unit>, &2, Error, &2, CheckResult(Value), Rules.rules(&2, Value, &2, Unit, s_1859), +item3622 => ((+local3621 => (Rules.elim_with(Get.Rules.Rule_pack.beta(&2, Unit, local3621), ev_1858, s_1859, q_1860, mo_1861, branches_1862, env_1863, v_1864)))(item3622)), +item3623 => Fail{item3623})
@unsafe
def Eval.leg_closure(+env_946: ListOf(Value), +lg_947: Term.Leg) -> Value.Vleg:
  MkValue_VlegOf{Get.Term.Leg.l_binders(lg_947), Value.close(env_946, Get.Term.Leg.l_body(lg_947))}
@unsafe
def Global.find(+name_758: String, +globals_759: Global) -> OptionOf(Global.Entry):
  Assoc.find(&2, String, Global.Entry, (+a => +b => NativeString.order(a, b)), name_758, Get.Global.entries(globals_759))
@unsafe
def Global.def_of(+e_782: Global.Entry) -> OptionOf(Global.Def_entry):
  (+scrut3680 = e_782
  Match.Global_Entry(&2, OptionOf(Global.Def_entry), scrut3680, +p3681 => (Some{p3681}), +p3682 => (None{}), +p3683 => (None{})))
@unsafe
def Eval.guarded_frame(k_1071, frames_1072):
  (+scrut3712 = frames_1072
  Match.List(&2, Value.Spine, &2, Bool, scrut3712, _ => (False{}), +p3713 => +p3714 => (Match.Value_Spine(&2, Bool, p3713, +p3715 => +p3716 => (((+local3719 => (Match.Maybe(&2, TupleOf2(Quantity, Value), &2, Bool, local3719, _ => (False{}), +value => ((+local3721 => ((+scrut3722 = local3721
Match.Tuple2(&2, Quantity, &2, Value, &2, Bool, scrut3722, +p3723 => +p3724 => (Native.choose(&2, Bool, Big.is_lt(Big.zero(), k_1071), _ => (Eval.guarded_frame(NativeInt.sub(k_1071, Big.one()), p3714)), _ => (Native.choose(&2, Bool, Big.is_lt(k_1071, Big.zero()), _ => (False{}), _ => (Maybe.is_some(&2, String, (+local3727 => ((+local3731 => +local3733 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Vaddr, ListOf(Value)), &2, OptionOf(String), local3731, _ => None{}, +item3735 => (local3733(item3735)))))(local3727, (+local3737 => ((+scrut3738 = local3737
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Vaddr, &2, ListOf(Value), &2, OptionOf(String), scrut3738, +p3739 => +p3740 => +p3741 => (Value.as_ctor(p3740)))))))))(Value.as_in(p3724))))))))))))(value)))))(Value.as_pt(p3716)))), +p3743 => (False{})))))
@unsafe
def Rules.out_value(+ev_1851: Rules.Evaluator, +s_1852: Shape<&2, Value>, +addr_1853: Value.Vaddr, +v_1854: Value) -> CheckResult(Value):
  Match.Result(&1, Rules.Rule_pack<&2, Unit>, &2, Error, &2, CheckResult(Value), Rules.rules(&2, Value, &2, Unit, s_1852), +item3760 => ((+local3759 => (Rules.out_with(Get.Rules.Rule_pack.beta(&2, Unit, local3759), ev_1851, s_1852, addr_1853, v_1854)))(item3760)), +item3761 => Fail{item3761})
@unsafe
def Eval.replay(+globals_1083: Global, +head_1084: Value, +frames_1085: ListOf(Value.Spine)) -> CheckResult(Value):
  SeqList.fold(&2, &2, Value.Spine, CheckResult(Value), (+local3747 => +local3749 => ((do CheckResult<Value>:
    +bound3751 : Value <- local3747
    (+scrut3752 = local3749
    Match.Value_Spine(&2, CheckResult(Value), scrut3752, +p3753 => +p3754 => ((do CheckResult<Value>:
      +bound3756 : Value <- Rules.out_value(Eval.ev(globals_1083), p3753, p3754, bound3751)
      Eval.whnf(globals_1083, bound3756))), +p3762 => (Rules.elim_value(Eval.ev(globals_1083), Get.Value.Stuck_elim.s_shape(p3762), Get.Value.Stuck_elim.s_scrut_q(p3762), Get.Value.Stuck_elim.s_motive(p3762), Get.Value.Stuck_elim.s_branches(p3762), Get.Value.Stuck_elim.s_env(p3762), bound3751))))))), frames_1085, Done{head_1084})
@unsafe
def Global.prim_of(+e_790: Global.Entry) -> OptionOf(Global.Prim_entry):
  (+scrut3777 = e_790
  Match.Global_Entry(&2, OptionOf(Global.Prim_entry), scrut3777, +p3778 => (None{}), +p3779 => (None{}), +p3780 => (Some{p3780})))
@unsafe
def Global.find_prim(+name_819: String, +globals_820: Global) -> OptionOf(Global.Prim_entry):
  Match.Maybe(&2, Global.Entry, &2, OptionOf(Global.Prim_entry), Global.find(name_819, globals_820), _ => None{}, +item3782 => (Global.prim_of(item3782)))
@unsafe
def Eval.head_prim(+globals_1042: Global, +h_1043: Value.Head) -> OptionOf(Prim):
  (+scrut3772 = h_1043
  Match.Value_Head(&2, OptionOf(Prim), scrut3772, +p3773 => (None{}), +p3774 => (Match.Maybe(&2, Global.Prim_entry, &2, OptionOf(Prim), Global.find_prim(p3774, globals_1042), _ => None{}, +item3784 => (Some{(+local3776 => (Get.Global.Prim_entry.prim(local3776)))(item3784)})))))
@unsafe
def Value.as_lit(+v_468: Value) -> OptionOf(Literal):
  (+scrut3817 = v_468
  Match.Value(&2, OptionOf(Literal), scrut3817, +p3818 => (None{}), +p3819 => +p3820 => +p3821 => (None{}), +p3822 => +p3823 => +p3824 => (None{}), +p3825 => +p3826 => +p3827 => (None{}), +p3828 => +p3829 => (None{}), +p3830 => (Some{p3830}), +p3831 => +p3832 => (None{})))
@unsafe
def Eval.spine_literals(+sp_1046: ListOf(Value.Spine)) -> OptionOf(ListOf(Literal)):
  SeqList.fold(&2, &2, Value.Spine, OptionOf(ListOf(Literal)), (+local3791 => +local3793 => (Match.Maybe(&2, ListOf(Literal), &2, OptionOf(ListOf(Literal)), local3791, _ => None{}, +item3837 => ((+local3795 => ((+scrut3796 = local3793
  Match.Value_Spine(&2, OptionOf(ListOf(Literal)), scrut3796, +p3797 => +p3798 => ((+local3801 => ((+local3805 => +local3807 => (Match.Maybe(&2, TupleOf2(Quantity, Value), &2, OptionOf(ListOf(Literal)), local3805, _ => None{}, +item3809 => (local3807(item3809)))))(local3801, (+local3811 => ((+scrut3812 = local3811
  Match.Tuple2(&2, Quantity, &2, Value, &2, OptionOf(ListOf(Literal)), scrut3812, +p3813 => +p3814 => (Match.Maybe(&2, Literal, &2, OptionOf(ListOf(Literal)), Value.as_lit(p3814), _ => None{}, +item3834 => (Some{(+local3816 => (Con{local3816, local3795}))(item3834)}))))))))))(Value.as_pt(p3798))), +p3835 => (None{})))))(item3837))))), sp_1046, Some{Nil{}})
@unsafe
def Prim.arity(+p_303: Prim) -> Big:
  (+scrut3843 = p_303
  Match.Prim(&2, Big, scrut3843, _ => (Big.of_nat(2n)), _ => (Big.of_nat(2n)), _ => (Big.of_nat(2n)), _ => (Big.of_nat(2n)), _ => (Big.of_nat(2n))))
@unsafe
def Prim.as_nat(+l_651: Literal) -> OptionOf(Bignum):
  (+scrut3863 = l_651
  Match.Literal(&2, OptionOf(Bignum), scrut3863, +p3864 => (None{}), +p3865 => (Native.choose(&2, OptionOf(Bignum), Big.is_lt(Bignum.sign(p3865), Big.zero()), _ => (None{}), _ => (Some{p3865})))))
@unsafe
def Prim.two_nats(+args_837: ListOf(Literal)) -> OptionOf(TupleOf2(Bignum, Bignum)):
  (+local3849 => ((+local3853 => +local3855 => (Match.Maybe(&2, TupleOf2(Literal, Literal), &2, OptionOf(TupleOf2(Bignum, Bignum)), local3853, _ => None{}, +item3857 => (local3855(item3857)))))(local3849, (+local3859 => ((+scrut3860 = local3859
  Match.Tuple2(&2, Literal, &2, Literal, &2, OptionOf(TupleOf2(Bignum, Bignum)), scrut3860, +p3861 => +p3862 => (Match.Maybe(&2, Bignum, &2, OptionOf(TupleOf2(Bignum, Bignum)), Prim.as_nat(p3861), _ => None{}, +item3873 => ((+local3867 => (Match.Maybe(&2, Bignum, &2, OptionOf(TupleOf2(Bignum, Bignum)), Prim.as_nat(p3862), _ => None{}, +item3871 => (Some{(+local3869 => (Tup2{local3867, local3869}))(item3871)}))))(item3873)))))))))))(Rules.two_of(&2, Literal, args_837))
@unsafe
def Rules.bool_value(+b_808: Bool) -> Value:
  Value.VIn{Shape.SColl{Big.of_nat(2n)}, Value.VaddrOf.VALeg{Native.choose(&2, Big, b_808, _ => (Big.one()), _ => (Big.zero()))}, Con{Value.VSec{Shape.SColl{Big.zero()}, Nil{}}, Nil{}}}
@unsafe
def Bignum.compare(+left_443: Bignum, +right_444: Bignum) -> Big:
  Big.compare(left_443, right_444)
@unsafe
def Prim.compare_op(+p_832: Prim) -> Maybe<&1, Reusable(Bignum, Reusable(Bignum, Bool))>:
  (+scrut3892 = p_832
  Match.Prim(&1, Maybe<&1, Reusable(Bignum, Reusable(Bignum, Bool))>, scrut3892, _ => (None{}), _ => (None{}), _ => (None{}), _ => (Some{Bignum.equal}), _ => (Some{(+local3894 => +local3896 => (Big.is_lt(Bignum.compare(local3894, local3896), Big.zero())))})))
@unsafe
def Prim.add(+a_813: Bignum, +b_814: Bignum) -> CheckResult(Bignum):
  Done{Bignum.add(a_813, b_814)}
@unsafe
def Bignum.sub(+left_458: Bignum, +right_459: Bignum) -> Bignum:
  Native.choose(&2, Bignum, Big.is_le(Bignum.compare(left_458, right_459), Big.zero()), _ => (Big.zero()), _ => (Big.sub(left_458, right_459)))
@unsafe
def Prim.sub(+a_821: Bignum, +b_822: Bignum) -> CheckResult(Bignum):
  Done{Bignum.sub(a_821, b_822)}
@unsafe
def Prim.mul(+a_825: Bignum, +b_826: Bignum) -> CheckResult(Bignum):
  Done{Bignum.mul(a_825, b_826)}
@unsafe
def Prim.arith(+p_829: Prim) -> Maybe<&1, Reusable(Bignum, Reusable(Bignum, CheckResult(Bignum)))>:
  (+scrut3910 = p_829
  Match.Prim(&1, Maybe<&1, Reusable(Bignum, Reusable(Bignum, CheckResult(Bignum)))>, scrut3910, _ => (Some{Prim.add}), _ => (Some{Prim.sub}), _ => (Some{Prim.mul}), _ => (None{}), _ => (None{})))
@unsafe
def Prim.reduce(+p_869: Prim, +args_870: ListOf(Literal)) -> CheckResult(OptionOf(Literal)):
  (+local3915 => (Match.Maybe(&2, CheckResult(Bignum), &2, CheckResult(OptionOf(Literal)), local3915, _ => (Done{None{}}), +value => ((+local3917 => (Match.Result(&2, Bignum, &2, Error, &2, CheckResult(OptionOf(Literal)), local3917, +item3920 => (Done{(+local3919 => (Some{Literal.LInt{local3919}}))(item3920)}), +item3921 => Fail{item3921})))(value)))))((+local3902 => (Match.Maybe(&2, TupleOf2(Bignum, Bignum), &2, OptionOf(CheckResult(Bignum)), local3902, _ => (None{}), +value => ((+local3904 => ((+scrut3905 = local3904
  Match.Tuple2(&2, Bignum, &2, Bignum, &2, OptionOf(CheckResult(Bignum)), scrut3905, +p3906 => +p3907 => (Match.Maybe(&1, Reusable(Bignum, Reusable(Bignum, CheckResult(Bignum))), &2, OptionOf(CheckResult(Bignum)), Prim.arith(p_869), _ => None{}, +item3912 => (Some{(+local3909 => (local3909(p3906, p3907)))(item3912)})))))))(value)))))(Prim.two_nats(args_870)))
@unsafe
def Prim.apply(+p_899: Prim, +args_900: ListOf(Literal)) -> CheckResult(OptionOf(Value)):
  (+scrut3899 = {(+local3876 => ((+local3880 => +local3882 => (Match.Maybe(&2, TupleOf2(Bignum, Bignum), &2, OptionOf(Value), local3880, _ => None{}, +item3884 => (local3882(item3884)))))(local3876, (+local3886 => ((+scrut3887 = local3886
  Match.Tuple2(&2, Bignum, &2, Bignum, &2, OptionOf(Value), scrut3887, +p3888 => +p3889 => (Match.Maybe(&1, Reusable(Bignum, Reusable(Bignum, Bool)), &2, OptionOf(Value), Prim.compare_op(p_899), _ => None{}, +item3898 => (Some{(+local3891 => (Rules.bool_value(local3891(p3888, p3889))))(item3898)}))))))))))(Prim.two_nats(args_900)) : OptionOf(Value)}
  (+local3924 => (Match.Result(&2, OptionOf(Literal), &2, Error, &2, CheckResult(OptionOf(Value)), local3924, +item3929 => (Done{(+local3926 => (Match.Maybe(&2, Literal, &2, OptionOf(Value), local3926, _ => (scrut3899), +value => ((+local3928 => (Some{Value.VLit{local3928}}))(value)))))(item3929)}), +item3930 => Fail{item3930})))(Prim.reduce(p_899, args_900)))
@unsafe
def Eval.prim_step(+globals_987: Global, +v_988: Value) -> CheckResult(Value):
  (+local3766 => (Match.Maybe(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), &2, CheckResult(Value), local3766, _ => (Done{v_988}), +value => ((+local3768 => ((+scrut3769 = local3768
  Match.Tuple2(&2, Value.Head, &2, ListOf(Value.Spine), &2, CheckResult(Value), scrut3769, +p3770 => +p3771 => ((+local3787 => (Match.Maybe(&2, Prim, &2, CheckResult(Value), local3787, _ => (Done{v_988}), +value => ((+local3789 => ((+local3840 => (Match.Maybe(&2, ListOf(Literal), &2, CheckResult(Value), local3840, _ => (Done{v_988}), +value => ((+local3842 => (Native.choose(&2, CheckResult(Value), Big.is_eq(Big.of_nat(List.length(&2, Literal, local3842)), Prim.arity(local3789)), _ => (Match.Result(&2, OptionOf(Value), &2, Error, &2, CheckResult(Value), Prim.apply(local3789, local3842), +item3931 => (Done{(+local3846 => (Maybe.default(&2, Value, local3846, v_988)))(item3931)}), +item3932 => Fail{item3932})), _ => (Done{v_988}))))(value)))))(Eval.spine_literals(p3771))))(value)))))(Eval.head_prim(globals_987, p3770)))))))(value)))))(Value.as_neutral(v_988))
@unsafe
def Eval.whnf(globals_1056, v_1057):
  (do CheckResult<Value>:
    +bound3649 : Value <- Eval.prim_step(globals_1056, v_1057)
    ((+scrut3702 = {(+local3652 => ((+local3656 => +local3658 => (Match.Maybe(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), &2, OptionOf(TupleOf3(Term, Big, ListOf(Value.Spine))), local3656, _ => None{}, +item3660 => (local3658(item3660)))))(local3652, (+local3662 => ((+scrut3663 = local3662
Match.Tuple2(&2, Value.Head, &2, ListOf(Value.Spine), &2, OptionOf(TupleOf3(Term, Big, ListOf(Value.Spine))), scrut3663, +p3664 => +p3665 => ((+scrut3666 = p3664
Match.Value_Head(&2, OptionOf(TupleOf3(Term, Big, ListOf(Value.Spine))), scrut3666, +p3667 => (None{}), +p3668 => (((+local3686 => ((+local3690 => +local3692 => (Match.Maybe(&2, Global.Def_entry, &2, OptionOf(TupleOf3(Term, Big, ListOf(Value.Spine))), local3690, _ => None{}, +item3694 => (local3692(item3694)))))(local3686, (+local3696 => (Native.choose(&2, OptionOf(TupleOf3(Term, Big, ListOf(Value.Spine))), Get.Global.Def_entry.reducible(local3696), _ => (Match.Maybe(&2, Big, &2, OptionOf(TupleOf3(Term, Big, ListOf(Value.Spine))), Get.Global.Def_entry.rec_arg(local3696), _ => None{}, +item3700 => (Some{(+local3698 => (Tup3{Get.Global.Def_entry.def(local3696), local3698, List.reverse(&2, Value.Spine, p3665)}))(item3700)}))), _ => (None{})))))))((+local3671 => ((+local3675 => +local3677 => (Match.Maybe(&2, Global.Entry, &2, OptionOf(Global.Def_entry), local3675, _ => None{}, +item3679 => (local3677(item3679)))))(local3671, Global.def_of)))(Global.find(p3668, globals_1056)))))))))))))))(Value.as_neutral(bound3649)) : OptionOf(TupleOf3(Term, Big, ListOf(Value.Spine)))}
(+local3705 => (Match.Maybe(&2, TupleOf3(Term, Big, ListOf(Value.Spine)), &2, CheckResult(Value), local3705, _ => (Done{bound3649}), +value => ((+local3707 => ((+scrut3708 = local3707
Match.Tuple3(&2, Term, &2, Big, &2, ListOf(Value.Spine), &2, CheckResult(Value), scrut3708, +p3709 => +p3710 => +p3711 => (Native.choose(&2, CheckResult(Value), Eval.guarded_frame(p3710, p3711), _ => ((do CheckResult<Value>:
  +bound3745 : Value <- Eval.eval(globals_1056, Nil{}, p3709)
  Eval.replay(globals_1056, bound3745, p3711))), _ => (Done{bound3649})))))))(value)))))(scrut3702))))
@unsafe
def Value.as_univ(+v_441: Value) -> OptionOf(Level):
  (+scrut3962 = v_441
  Match.Value(&2, OptionOf(Level), scrut3962, +p3963 => (Some{p3963}), +p3964 => +p3965 => +p3966 => (None{}), +p3967 => +p3968 => +p3969 => (None{}), +p3970 => +p3971 => +p3972 => (None{}), +p3973 => +p3974 => (None{}), +p3975 => (None{}), +p3976 => +p3977 => (None{})))
@unsafe
def Eval.level_of_ann(+globals_984: Global, +env_985: ListOf(Value), +ty_986: Term) -> OptionOf(Level):
  (+local3953 => ((+local3957 => +local3959 => (Match.Maybe(&2, Value, &2, OptionOf(Level), local3957, _ => None{}, +item3961 => (local3959(item3961)))))(local3953, Value.as_univ)))(Match.Result(&2, Value, &2, Error, &2, OptionOf(Value), Eval.eval(globals_984, env_985, ty_986), +x => Some{x}, _ => None{}))
@unsafe
def Eval.annotate(+globals_968: Global, +env_969: ListOf(Value), +v_970: Value, +ty_971: Term) -> Value:
  (+scrut3981 = {(+local3947 => ((+local3950 => (Match.Maybe(&2, Level, &2, OptionOf(Level), local3950, _ => (Eval.level_of_ann(globals_968, env_969, ty_971)), +value => ((+local3980 => (Some{local3980}))(value)))))(local3947))) : Reusable(OptionOf(Level), OptionOf(Level))}
  ((+local3995 => (Match.Maybe(&2, Value, &2, Value, local3995, _ => ((+local4009 => (Maybe.default(&2, Value, local4009, v_970)))((+local3998 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, OptionOf(Value), local3998, _ => None{}, +item4006 => (Some{(+local4000 => ((+scrut4001 = local4000
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, Value, scrut4001, +p4002 => +p4003 => +p4004 => (Value.VRan{p4002, p4003, scrut3981(p4004)})))))(item4006)}))))(Value.as_ran(v_970)))), +value => ((+local4011 => (local4011))(value)))))((+local3984 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, OptionOf(Value), local3984, _ => None{}, +item3992 => (Some{(+local3986 => ((+scrut3987 = local3986
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, Value, scrut3987, +p3988 => +p3989 => +p3990 => (Value.VLan{p3988, p3989, scrut3981(p3990)})))))(item3992)}))))(Value.as_lan(v_970)))))
@unsafe
def Eval.eval_global(+globals_956: Global, +n_957: String) -> CheckResult(Value):
  (+scrut4014 = {Value.VNeutral{Value.Head.HGlobal{n_957}, Nil{}} : Value}
  ((+local4020 => ((+local4024 => +local4026 => (Match.Result(&2, Global.Entry, &2, Error, &2, CheckResult(Value), local4024, +item4027 => (local4026(item4027)), +item4028 => Fail{item4028})))(local4020, (+local4030 => ((+local4033 => (Match.Maybe(&2, Global.Def_entry, &2, CheckResult(Value), local4033, _ => (Done{scrut4014}), +value => ((+local4035 => (Native.choose(&2, CheckResult(Value), Big.when(Bool, Get.Global.Def_entry.reducible(local4035), _ => (Bool.not(Maybe.is_some(&2, Big, Get.Global.Def_entry.rec_arg(local4035)))), _ => (False{})), _ => (Eval.eval(globals_956, Nil{}, Get.Global.Def_entry.def(local4035))), _ => (Done{scrut4014}))))(value)))))(Global.def_of(local4030)))))))((+local4017 => (Match.Maybe(&2, Global.Entry, &2, CheckResult(Global.Entry), local4017, _ => Fail{Error.Unbound{n_957}}, +x => Done{x})))(Global.find(n_957, globals_956)))))
@unsafe
def Rules.auto_word() -> String:
  "instances arrive at M2"
@unsafe
def Eval.eval(globals_539, env_540, tm_541):
  (+scrut1995 = tm_541
  Match.Term(&2, CheckResult(Value), scrut1995, +p1996 => ((+local1999 => (Match.Maybe(&2, Value, &2, CheckResult(Value), local1999, _ => Fail{Error.Unbound{String.concat(["de Bruijn index ", Big.show(p1996), " is outside the environment"])}}, +x => Done{x})))(Rules.at(&2, Value, p1996, env_540))), +p2000 => (Done{Value.VUniv{p2000}}), +p2001 => +p2002 => ((do CheckResult<Value>:
    +bound2004 : Shape<&2, Value> <- Rules.map_shape(&2, Value, &2, Term, (+local2007 => (Eval.eval(globals_539, env_540, local2007))), p2001)
    Done{Value.VLan{bound2004, Value.close(env_540, p2002), None{}}})), +p2027 => +p2028 => ((do CheckResult<Value>:
    +bound2030 : Shape<&2, Value> <- Rules.map_shape(&2, Value, &2, Term, (+local2033 => (Eval.eval(globals_539, env_540, local2033))), p2027)
    Done{Value.VRan{bound2030, Value.close(env_540, p2028), None{}}})), +p2034 => +p2035 => +p2036 => ((do CheckResult<Value>:
    +bound2038 : Shape<&2, Value> <- Rules.map_shape(&2, Value, &2, Term, (+local2057 => (Eval.eval(globals_539, env_540, local2057))), p2034)
    +bound2040 : Value.Vaddr <- Eval.eval_addr(globals_539, env_540, p2035)
    +bound2042 : ListOf(Value) <- Rules.all_ok(&2, Value, SeqList.map(&2, &2, Term, CheckResult(Value), (+local2045 => (Eval.eval(globals_539, env_540, local2045))), p2036))
    Done{Value.VIn{bound2038, bound2040, bound2042}})), +p2058 => ((do CheckResult<Value>:
    +bound2060 : Shape<&2, Value> <- Rules.map_shape(&2, Value, &2, Term, (+local3626 => (Eval.eval(globals_539, env_540, local3626))), Get.Term.Elim.e_shape(p2058))
    +bound2062 : Value <- Eval.eval(globals_539, env_540, Get.Term.Elim.e_scrut(p2058))
    Rules.elim_value(Eval.ev(globals_539), bound2060, Get.Term.Elim.e_scrut_q(p2058), Get.Term.Elim.e_motive(p2058), Get.Term.Elim.e_branches(p2058), env_540, bound2062))), +p3627 => +p3628 => ((do CheckResult<Value>:
    +bound3630 : Shape<&2, Value> <- Rules.map_shape(&2, Value, &2, Term, (+local3636 => (Eval.eval(globals_539, env_540, local3636))), p3627)
    Done{Value.VSec{bound3630, SeqList.map(&2, &2, Term.Leg, Value.Vleg, (+local3633 => (Eval.leg_closure(env_540, local3633))), p3628)}})), +p3637 => +p3638 => +p3639 => ((do CheckResult<Value>:
    +bound3641 : Shape<&2, Value> <- Rules.map_shape(&2, Value, &2, Term, (+local3935 => (Eval.eval(globals_539, env_540, local3935))), p3637)
    +bound3643 : Value.Vaddr <- Eval.eval_addr(globals_539, env_540, p3638)
    +bound3645 : Value <- Eval.eval(globals_539, env_540, p3639)
    +bound3647 : Value <- Rules.out_value(Eval.ev(globals_539), bound3641, bound3643, bound3645)
    Eval.whnf(globals_539, bound3647))), +p3936 => +p3937 => +p3938 => +p3939 => ((do CheckResult<Value>:
    +bound3941 : Value <- Eval.eval(globals_539, env_540, p3938)
    Eval.eval(globals_539, Con{bound3941, env_540}, p3939))), +p3942 => +p3943 => ((do CheckResult<Value>:
    +bound3945 : Value <- Eval.eval(globals_539, env_540, p3942)
    Done{Eval.annotate(globals_539, env_540, bound3945, p3943)})), +p4013 => (Eval.eval_global(globals_539, p4013)), +p4037 => (Done{Value.VLit{p4037}}), _ => (Fail{Error.Not_yet{Rules.auto_word()}})))
@unsafe
def Eval.quote_former(+globals_1122: Global, +size_1123: Big, +s_1124: Shape<&2, Value>, +dclo_1125: Value.Closure, +u_1126: OptionOf(Level), +build_1127: Reusable(TupleOf2(Shape<&2, Term>, Term), Term)) -> CheckResult(Term):
  (do CheckResult<Term>:
    +bound4059 : Shape<&2, Term> <- Rules.map_shape(&2, Term, &2, Value, (+local4082 => (Eval.quote(globals_1122, size_1123, local4082))), s_1124)
    (Match.Result(&1, Rules.Rule_pack<&2, Unit>, &2, Error, &2, CheckResult(Term), Rules.rules(&2, Value, &2, Unit, s_1124), +item4077 => ((+local4062 => ((+scrut4063 = {Get.Rules.Rule_pack.diagram_arity(&2, Unit, local4062)(s_1124) : Big}
(+scrut4066 = {SeqList.init(&2, Value, scrut4063, (+local4065 => (Value.var(NativeInt.add(size_1123, local4065))))) : ListOf(Value)}
(do CheckResult<Term>:
  +bound4068 : Value <- Rules.open_closure(Eval.ev(globals_1122), dclo_1125, scrut4066)
  +bound4070 : Term <- Eval.quote(globals_1122, NativeInt.add(size_1123, scrut4063), bound4068)
  (+scrut4071 = {build_1127(Tup2{bound4059, bound4070}) : Term}
  Done{(+local4074 => (Match.Maybe(&2, Level, &2, Term, local4074, _ => (scrut4071), +value => ((+local4076 => (Term.Ann{scrut4071, Term.Univ{local4076}}))(value)))))(u_1126)}))))))(item4077)), +item4078 => Fail{item4078})))
@unsafe
def Eval.quote_addr(+globals_1145: Global, +size_1146: Big, +a_1147: Value.Vaddr) -> CheckResult(Term.Addr):
  (+scrut4103 = a_1147
  Match.Value_Vaddr(&2, CheckResult(Term.Addr), scrut4103, +p4104 => +p4105 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term.Addr), Eval.quote(globals_1145, size_1146, p4105), +item4108 => (Done{(+local4107 => (Term.AddrOf.APt{p4104, local4107}))(item4108)}), +item4109 => Fail{item4109})), +p4110 => (Done{Term.AddrOf.ALeg{p4110}}), +p4111 => (Done{Term.AddrOf.ACtor{p4111}})))
@unsafe
def Eval.quote_leg(+globals_1137: Global, +size_1138: Big, +lg_1139: Value.Vleg) -> CheckResult(Term.Leg):
  (+scrut4124 = {Big.of_nat(List.length(&2, TupleOf2(Quantity, String), Get.Value.Vleg.vl_binders(lg_1139))) : Big}
  (+scrut4127 = {SeqList.init(&2, Value, scrut4124, (+local4126 => (Value.var(NativeInt.add(size_1138, local4126))))) : ListOf(Value)}
  (do CheckResult<Term.Leg>:
    +bound4129 : Value <- Rules.open_closure(Eval.ev(globals_1137), Get.Value.Vleg.vl_clo(lg_1139), scrut4127)
    +bound4131 : Term <- Eval.quote(globals_1137, NativeInt.add(size_1138, scrut4124), bound4129)
    Done{MkTerm_LegOf{Get.Value.Vleg.vl_binders(lg_1139), bound4131}})))
@unsafe
def Eval.quote_neutral(+globals_1153: Global, +size_1154: Big, +h_1155: Value.Head, +sp_1156: ListOf(Value.Spine)) -> CheckResult(Term):
  (+scrut4141 = {(+scrut4138 = h_1155
  Match.Value_Head(&2, Term, scrut4138, +p4139 => (Term.Var{NativeInt.sub(NativeInt.sub(size_1154, p4139), Big.one())}), +p4140 => (Term.Global{p4140}))) : Term}
  (SeqList.fold(&2, &2, Value.Spine, CheckResult(Term), (+local4143 => +local4145 => ((do CheckResult<Term>:
  +bound4147 : Term <- local4143
  (+scrut4148 = local4145
  Match.Value_Spine(&2, CheckResult(Term), scrut4148, +p4149 => +p4150 => ((do CheckResult<Term>:
    +bound4152 : Shape<&2, Term> <- Rules.map_shape(&2, Term, &2, Value, (+local4157 => (Eval.quote(globals_1153, size_1154, local4157))), p4149)
    +bound4154 : Term.Addr <- Eval.quote_addr(globals_1153, size_1154, p4150)
    Done{Term.Out{bound4152, bound4154, bound4147}})), +p4158 => ((do CheckResult<Term>:
    +bound4160 : Shape<&2, Term> <- Rules.map_shape(&2, Term, &2, Value, (+local4163 => (Eval.quote(globals_1153, size_1154, local4163))), Get.Value.Stuck_elim.s_shape(p4158))
    Done{Term.Elim{MkTerm_ElimOf{bound4160, bound4147, Get.Value.Stuck_elim.s_scrut_q(p4158), Get.Value.Stuck_elim.s_motive(p4158), Get.Value.Stuck_elim.s_branches(p4158)}}}))))))), List.reverse(&2, Value.Spine, sp_1156), Done{scrut4141})))
@unsafe
def Eval.quote(globals_1093, size_1094, v_1095):
  (+scrut4048 = v_1095
  Match.Value(&2, CheckResult(Term), scrut4048, +p4049 => (Done{Term.Univ{p4049}}), +p4050 => +p4051 => +p4052 => (Eval.quote_former(globals_1093, size_1094, p4050, p4051, p4052, (+local4054 => ((+scrut4055 = local4054
  Match.Tuple2(&2, Shape<&2, Term>, &2, Term, &2, Term, scrut4055, +p4056 => +p4057 => (Term.Lan{p4056, p4057}))))))), +p4083 => +p4084 => +p4085 => (Eval.quote_former(globals_1093, size_1094, p4083, p4084, p4085, (+local4087 => ((+scrut4088 = local4087
  Match.Tuple2(&2, Shape<&2, Term>, &2, Term, &2, Term, scrut4088, +p4089 => +p4090 => (Term.Ran{p4089, p4090}))))))), +p4091 => +p4092 => +p4093 => ((do CheckResult<Term>:
    +bound4095 : Shape<&2, Term> <- Rules.map_shape(&2, Term, &2, Value, (+local4114 => (Eval.quote(globals_1093, size_1094, local4114))), p4091)
    +bound4097 : Term.Addr <- Eval.quote_addr(globals_1093, size_1094, p4092)
    +bound4099 : ListOf(Term) <- Rules.all_ok(&2, Term, SeqList.map(&2, &2, Value, CheckResult(Term), (+local4102 => (Eval.quote(globals_1093, size_1094, local4102))), p4093))
    Done{Term.In{bound4095, bound4097, bound4099}})), +p4115 => +p4116 => ((do CheckResult<Term>:
    +bound4118 : Shape<&2, Term> <- Rules.map_shape(&2, Term, &2, Value, (+local4134 => (Eval.quote(globals_1093, size_1094, local4134))), p4115)
    +bound4120 : ListOf(Term.Leg) <- Rules.all_ok(&2, Term.Leg, SeqList.map(&2, &2, Value.Vleg, CheckResult(Term.Leg), (+local4123 => (Eval.quote_leg(globals_1093, size_1094, local4123))), p4116))
    Done{Term.Sec{bound4118, bound4120}})), +p4135 => (Done{Term.Lit{p4135}}), +p4136 => +p4137 => (Eval.quote_neutral(globals_1093, size_1094, p4136, p4137))))
@unsafe
def Level.of_int(+n_341: Big) -> OptionOf(Level):
  Native.choose(&2, OptionOf(Level), Big.is_le(Big.zero(), n_341), _ => (Some{n_341}), _ => (None{}))
@unsafe
def Rules.unit_val() -> Term:
  Term.Sec{Shape.SColl{Big.zero()}, Nil{}}
@unsafe
def Budget.exhausted(+b_301: Budget) -> Bool:
  Get.Budget.poll(b_301)(Unit{})
@unsafe
def Check.budget_msg() -> String:
  "the check budget is exhausted"
@unsafe
def Check.readable(+mode_493: Quantity, +q_494: Quantity) -> Bool:
  Big.when(Bool, Quantity.equal(mode_493, Quantity.Zero{}), _ => (True{}), _ => (Bool.not(Quantity.equal(q_494, Quantity.Zero{}))))
@unsafe
def Quantity.occurrence(+level_622: Big, +q_623: Quantity) -> Quantity.Usage:
  (+scrut4302 = {Assoc.singleton(&2, Big, TupleOf2(Quantity, Quantity), level_622, Tup2{q_623, q_623}) : Assoc<&2, Big, TupleOf2(Quantity, Quantity)>}
  MkQuantity_Usage{Some{scrut4302}, scrut4302})
@unsafe
def Level.succ(+l_296: Level) -> Level:
  NativeInt.add(l_296, Big.one())
@unsafe
def Check.no_infer(+what_482: String) -> Error:
  Error.Cannot_infer{String.append(what_482, " has no type of its own;  it needs an expected type")}
@unsafe
def Quantity.interval(+level_601: Big, +uses_602: Assoc<&2, Big, Quantity.Interval>) -> Quantity.Interval:
  Maybe.default(&2, Quantity.Interval, Assoc.find(&2, Big, Quantity.Interval, (+a => +b => Big.cmp(a, b)), level_601, uses_602), Tup2{Quantity.Zero{}, Quantity.Zero{}})
@unsafe
def Quantity.used(+level_683: Big, +uses_684: Quantity.Usage) -> Bool:
  (+scrut4367 = {Quantity.interval(level_683, Get.Quantity.Usage.reads(uses_684)) : Quantity.Interval}
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, Bool, scrut4367, +p4368 => +p4369 => (Bool.not(Quantity.equal(p4369, Quantity.Zero{})))))
@unsafe
def Check.define(+x_473: String, +q_474: Quantity, +ty_475: Value, +v_476: Value, +c_477: Check.Ctx) -> Check.Ctx:
  MkCheck_Ctx{Get.Check.Ctx.globals(c_477), Con{v_476, Get.Check.Ctx.env(c_477)}, Con{Tup3{x_473, q_474, ty_475}, Get.Check.Ctx.locals(c_477)}, NativeInt.add(Get.Check.Ctx.size(c_477), Big.one()), Get.Check.Ctx.budget(c_477)}
@unsafe
def Quantity.get(+level_667: Big, +uses_668: Quantity.Usage) -> Quantity.Interval:
  (+scrut4399 = {Quantity.interval(level_667, Get.Quantity.Usage.reads(uses_668)) : Quantity.Interval}
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, Quantity.Interval, scrut4399, +p4400 => +p4401 => (Match.Maybe(&2, Assoc<&2, Big, Quantity.Interval>, &2, Quantity.Interval, Get.Quantity.Usage.paths(uses_668), _ => (Tup2{Quantity.One{}, Quantity.maximum(Quantity.One{}, p4401)}), +value => ((+local4404 => (Quantity.interval(level_667, local4404)))(value))))))
@unsafe
def Quantity.at_most_once(+level_689: Big, +uses_690: Quantity.Usage) -> Bool:
  (+scrut4405 = {Quantity.get(level_689, uses_690) : Quantity.Interval}
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, Bool, scrut4405, +p4406 => +p4407 => (Bool.not(Quantity.equal(p4407, Quantity.Many{})))))
@unsafe
def Quantity.exactly_once(+level_677: Big, +uses_678: Quantity.Usage) -> Bool:
  (+scrut4408 = {Quantity.get(level_677, uses_678) : Quantity.Interval}
  Match.Tuple2(&2, Quantity, &2, Quantity, &2, Bool, scrut4408, +p4409 => +p4410 => (Big.when(Bool, Quantity.equal(p4409, Quantity.One{}), _ => (Quantity.equal(p4410, Quantity.One{})), _ => (False{})))))
@unsafe
def Quantity.remove(+level_673: Big, +uses_674: Quantity.Usage) -> Quantity.Usage:
  MkQuantity_Usage{Match.Maybe(&2, Assoc<&2, Big, Quantity.Interval>, &2, OptionOf(Assoc<&2, Big, Quantity.Interval>), Get.Quantity.Usage.paths(uses_674), _ => None{}, +item4416 => (Some{(+local4414 => (Assoc.remove(&2, Big, Quantity.Interval, (+a => +b => Big.cmp(a, b)), level_673, local4414)))(item4416)})), Assoc.remove(&2, Big, Quantity.Interval, (+a => +b => Big.cmp(a, b)), level_673, Get.Quantity.Usage.reads(uses_674))}
@unsafe
def Check.close(+_opt__585: OptionOf(Bool), +c_571: Check.Ctx, +size_572: Big, +mode_573: Quantity, +uses_574: Quantity.Usage) -> CheckResult(Quantity.Usage):
  (+scrut4386 = {(+scrut4384 = _opt__585
  Match.Maybe(&2, Bool, &2, Bool, scrut4384, _ => (False{}), +p4385 => (p4385))) : Bool}
  (SeqList.fold(&2, &2, TupleOf2(Big, TupleOf3(String, Quantity, Value)), CheckResult(Quantity.Usage), (+local4388 => +local4390 => ((+scrut4391 = local4390
Match.Tuple2(&2, Big, &2, TupleOf3(String, Quantity, Value), &2, CheckResult(Quantity.Usage), scrut4391, +p4392 => +p4393 => (Match.Tuple3(&2, String, &2, Quantity, &2, Value, &2, CheckResult(Quantity.Usage), p4393, +p4394 => +p4395 => +p4396 => ((do CheckResult<Quantity.Usage>:
  +bound4398 : Quantity.Usage <- local4388
  (Native.choose(&2, CheckResult(Quantity.Usage), Big.is_lt(p4392, size_572), _ => (Done{bound4398}), _ => (Native.choose(&2, CheckResult(Quantity.Usage), Big.when(Bool, Bool.not(Quantity.equal(mode_573, Quantity.Zero{})), _ => (Big.when(Bool, Quantity.equal(p4395, Quantity.One{}), _ => (Bool.not(Native.choose(&1, Reusable(Big, Reusable(Quantity.Usage, Bool)), scrut4386, _ => (Quantity.at_most_once), _ => (Quantity.exactly_once))(p4392, bound4398))), _ => (False{}))), _ => (False{})), _ => ((+scrut4411 = {Native.choose(&2, String, scrut4386, _ => (String.append("the linear alias ", String.append(p4394, " may be used at most once"))), _ => (String.append("the linear binder ", String.append(p4394, " must be used exactly once on every runtime path")))) : String}
Fail{Error.Quantity{scrut4411}})), _ => (Done{Quantity.remove(p4392, bound4398)}))))))))))))), SeqList.mapi(&2, &2, TupleOf3(String, Quantity, Value), TupleOf2(Big, TupleOf3(String, Quantity, Value)), (+local4419 => +local4421 => (Tup2{NativeInt.sub(NativeInt.sub(Get.Check.Ctx.size(c_571), local4419), Big.one()), local4421})), Get.Check.Ctx.locals(c_571)), Done{uses_574})))
@unsafe
def Pp.nth_name(+n_293: Big, +names_294: ListOf(String)) -> OptionOf(String):
  (+scrut4443 = names_294
  Match.List(&2, String, &2, OptionOf(String), scrut4443, _ => (None{}), +p4444 => +p4445 => (Native.choose(&2, OptionOf(String), Big.is_eq(n_293, Big.zero()), _ => (Some{p4444}), _ => (Pp.nth_name(NativeInt.sub(n_293, Big.one()), p4445))))))
@unsafe
def Level.to_string(+l_344: Level) -> String:
  Big.show(l_344)
@unsafe
def Pp.shape(+names_690: ListOf(String), +s_697: Shape<&2, Term>) -> String:
  (+scrut4452 = s_697
  Match.Shape(&2, Term, &2, String, scrut4452, +p4453 => +p4454 => +p4455 => (String.concat(["SPi ", Quantity.to_string(p4453), " ", p4454, " ", Pp.term(names_690, p4455)])), +p4456 => (String.concat(["SColl ", Big.show(p4456)])), +p4457 => +p4458 => (String.concat(["SPar ", Pp.term(names_690, p4457), " ", Pp.term(names_690, p4458)])), +p4459 => +p4460 => (String.concat(["SMu ", p4459, " [", String.join(SeqList.map(&2, &2, Term, String, (+local4463 => (Pp.term(names_690, local4463))), p4460), "; "), "]"])), +p4464 => +p4465 => (String.concat(["SNu ", p4464, " [", String.join(SeqList.map(&2, &2, Term, String, (+local4468 => (Pp.term(names_690, local4468))), p4465), "; "), "]"]))))
@unsafe
def Pp.under(+s_782: Shape<&2, Term>, +names_783: ListOf(String)) -> ListOf(String):
  (+scrut4469 = s_782
  Match.Shape(&2, Term, &2, ListOf(String), scrut4469, +p4470 => +p4471 => +p4472 => (Con{p4471, names_783}), +p4473 => (names_783), +p4474 => +p4475 => (names_783), +p4476 => +p4477 => (names_783), +p4478 => +p4479 => (names_783)))
@unsafe
def Pp.addr(+names_845: ListOf(String), +a_846: Term.Addr) -> String:
  (+scrut4485 = a_846
  Match.Term_Addr(&2, String, scrut4485, +p4486 => +p4487 => (String.concat(["(APt ", Quantity.to_string(p4486), " ", Pp.term(names_845, p4487), ")"])), +p4488 => (String.concat(["(ALeg ", Big.show(p4488), ")"])), +p4489 => (String.concat(["(ACtor ", p4489, ")"]))))
@unsafe
def Pp.binder_names(+bs_591: ListOf(TupleOf2(Quantity, String))) -> ListOf(String):
  SeqList.map(&2, &2, TupleOf2(Quantity, String), String, (+local4507 => ((+scrut4508 = local4507
  Match.Tuple2(&2, Quantity, &2, String, &2, String, scrut4508, +p4509 => +p4510 => (p4510))))), bs_591)
@unsafe
def Pp.push(+names_663: ListOf(String), +added_664: ListOf(String)) -> ListOf(String):
  SeqList.fold(&2, &2, String, ListOf(String), (+local4513 => +local4515 => (Con{local4515, local4513})), added_664, names_663)
@unsafe
def Pp.leg(+names_851: ListOf(String), +lg_852: Term.Leg) -> String:
  (+scrut4511 = {Pp.binder_names(Get.Term.Leg.l_binders(lg_852)) : ListOf(String)}
  String.concat([String.join(scrut4511, " "), " => ", Pp.term(Pp.push(names_851, scrut4511), Get.Term.Leg.l_body(lg_852))]))
@unsafe
def Pp.elim(+names_854: ListOf(String), +e_855: Term.Elim) -> String:
  (+scrut4500 = {(+local4496 => (Match.Maybe(&2, Term.Motive, &2, String, local4496, _ => (""), +value => ((+local4498 => ((+scrut4499 = {List.append(&2, String, Con{Get.Term.Motive.m_self(local4498), List.reverse(&2, String, Get.Term.Motive.m_idx(local4498))}, names_854) : ListOf(String)}
  String.concat([" as ", Get.Term.Motive.m_self(local4498), " return ", Pp.term(scrut4499, Get.Term.Motive.m_body(local4498))]))))(value)))))(Get.Term.Elim.e_motive(e_855)) : String}
  (+scrut4516 = {(+local4502 => ((+scrut4503 = local4502
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, String, scrut4503, +p4504 => +p4505 => (String.concat([" | ", Pp.addr(names_854, p4504), " ", Pp.leg(names_854, p4505)])))))) : Reusable(TupleOf2(Term.Addr, Term.Leg), String)}
  String.concat(["(Elim ", Pp.shape(names_854, Get.Term.Elim.e_shape(e_855)), " ", Pp.term(names_854, Get.Term.Elim.e_scrut(e_855)), scrut4500, " with", String.join(SeqList.map(&2, &2, TupleOf2(Term.Addr, Term.Leg), String, scrut4516, Get.Term.Elim.e_branches(e_855)), ""), ")"])))
@unsafe
def Pp.literal(+l_332: Literal) -> String:
  (+scrut4533 = l_332
  Match.Literal(&2, String, scrut4533, +p4534 => (String.append("\u{22}", String.append(NativeString.escaped(p4534), "\u{22}"))), +p4535 => (Bignum.to_string(p4535))))
@unsafe
def Pp.term(names_785, tm_786):
  (+scrut4441 = tm_786
  Match.Term(&2, String, scrut4441, +p4442 => ((+local4448 => (Maybe.default(&2, String, local4448, String.concat(["#", Big.show(p4442)]))))(Pp.nth_name(p4442, names_785))), +p4449 => (String.append("Type ", Level.to_string(p4449))), +p4450 => +p4451 => (String.concat(["(Lan ", Pp.shape(names_785, p4450), " ", Pp.term(Pp.under(p4450, names_785), p4451), ")"])), +p4480 => +p4481 => (String.concat(["(Ran ", Pp.shape(names_785, p4480), " ", Pp.term(Pp.under(p4480, names_785), p4481), ")"])), +p4482 => +p4483 => +p4484 => (String.concat(["(In ", Pp.shape(names_785, p4482), " ", Pp.addr(names_785, p4483), " [", String.join(SeqList.map(&2, &2, Term, String, (+local4492 => (Pp.term(names_785, local4492))), p4484), "; "), "])"])), +p4493 => (Pp.elim(names_785, p4493)), +p4517 => +p4518 => (String.concat(["(Sec ", Pp.shape(names_785, p4517), " [", String.join(SeqList.map(&2, &2, Term.Leg, String, (+local4521 => (Pp.leg(names_785, local4521))), p4518), "; "), "])"])), +p4522 => +p4523 => +p4524 => (String.concat(["(Out ", Pp.shape(names_785, p4522), " ", Pp.addr(names_785, p4523), " ", Pp.term(names_785, p4524), ")"])), +p4525 => +p4526 => +p4527 => +p4528 => (String.concat(["let ", p4525, " : ", Pp.term(names_785, p4526), " := ", Pp.term(names_785, p4527), " in ", Pp.term(Con{p4525, names_785}, p4528)])), +p4529 => +p4530 => (String.concat(["(", Pp.term(names_785, p4529), " : ", Pp.term(names_785, p4530), ")"])), +p4531 => (p4531), +p4532 => (Pp.literal(p4532)), _ => ("auto")))
@unsafe
def Check.pp_value(+c_958: Check.Ctx, +v_959: Value) -> String:
  (+local4540 => (Match.Result(&2, String, &2, Error, &2, String, local4540, +x => x, _ => ("a value that does not read back"))))((+local4437 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(String), local4437, +item4536 => (Done{(+local4440 => (Pp.term(Check.names_of(c_958), local4440)))(item4536)}), +item4537 => Fail{item4537})))(Eval.quote(Get.Check.Ctx.globals(c_958), Get.Check.Ctx.size(c_958), v_959)))
@unsafe
def Conv.placeholder() -> Value:
  Value.VUniv{Level.zero()}
@unsafe
def Conv.is_prop(-q0: Quant, -A0: Kind(q0), +ops_774: Rules.Ops<q0, A0>, +ctx_775: A0, +ty_776: Value) -> Bool:
  (+local4557 => (Match.Maybe(&2, Level, &2, Bool, local4557, _ => (False{}), +value => ((+local4559 => (Level.equal(local4559, Level.zero())))(value)))))(Match.Result(&2, Level, &2, Error, &2, OptionOf(Level), (+local4544 => ((+local4548 => +local4550 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Level), local4548, +item4551 => (local4550(item4551)), +item4552 => Fail{item4552})))(local4544, (+local4554 => (Get.Rules.Ops.o_infer_univ(q0, A0, ops_774)(ctx_775, local4554))))))(Get.Rules.Ops.o_quote(q0, A0, ops_774)(ctx_775, ty_776)), +x => Some{x}, _ => None{}))
@unsafe
def Conv.univ_case(+a_845: Value, +b_846: Value) -> OptionOf(CheckResult(Bool)):
  Match.Maybe(&2, Level, &2, OptionOf(CheckResult(Bool)), Value.as_univ(a_845), _ => None{}, +item4583 => ((+local4577 => (Match.Maybe(&2, Level, &2, OptionOf(CheckResult(Bool)), Value.as_univ(b_846), _ => None{}, +item4581 => (Some{(+local4579 => (Done{Level.equal(local4577, local4579)}))(item4581)}))))(item4583)))
@unsafe
def Literal.equal(+a_453: Literal, +b_454: Literal) -> Bool:
  (+scrut4591 = {Tup2{a_453, b_454} : TupleOf2(Literal, Literal)}
  Match.Tuple2(&2, Literal, &2, Literal, &2, Bool, scrut4591, +p4592 => +p4593 => (Match.Literal(&2, Bool, p4592, +p4594 => (Match.Literal(&2, Bool, p4593, +p4595 => (NativeString.equal(p4594, p4595)), +p4596 => (False{}))), +p4597 => (Match.Literal(&2, Bool, p4593, +p4598 => (False{}), +p4599 => (Bignum.equal(p4597, p4599))))))))
@unsafe
def Conv.lit_case(+a_849: Value, +b_850: Value) -> OptionOf(CheckResult(Bool)):
  Match.Maybe(&2, Literal, &2, OptionOf(CheckResult(Bool)), Value.as_lit(a_849), _ => None{}, +item4603 => ((+local4588 => (Match.Maybe(&2, Literal, &2, OptionOf(CheckResult(Bool)), Value.as_lit(b_850), _ => None{}, +item4601 => (Some{(+local4590 => (Done{Literal.equal(local4588, local4590)}))(item4601)}))))(item4603)))
@unsafe
def Rules.payload_eq(-q0: Quant, -A0: Kind(q0), +eq_679: Reusable(A0, Reusable(A0, CheckResult(Bool))), +xs_680: List<q0, A0>, +ys_681: List<q0, A0>) -> CheckResult(Bool):
  (+scrut4682 = {Tup2{xs_680, ys_681} : Tuple2<q0, q0, List<q0, A0>, List<q0, A0>>}
  Match.Tuple2(q0, List<q0, A0>, q0, List<q0, A0>, &2, CheckResult(Bool), scrut4682, +p4683 => +p4684 => (Match.List(q0, A0, &2, CheckResult(Bool), p4683, _ => (Match.List(q0, A0, &2, CheckResult(Bool), p4684, _ => (Done{True{}}), +p4685 => +p4686 => (Done{False{}}))), +p4687 => +p4688 => (Match.List(q0, A0, &2, CheckResult(Bool), p4684, _ => (Done{False{}}), +p4689 => +p4690 => ((do CheckResult<Bool>:
    +bound4692 : Bool <- eq_679(p4687, p4689)
    Native.choose(&2, CheckResult(Bool), bound4692, _ => (Rules.payload_eq(q0, A0, eq_679, p4688, p4690)), _ => (Done{False{}}))))))))))
@unsafe
def Rules.shape_eq(+eq_689: Reusable(Value, Reusable(Value, CheckResult(Bool))), +a_690: Shape<&2, Value>, +b_691: Shape<&2, Value>) -> CheckResult(Bool):
  (+scrut4633 = {Tup2{a_690, b_691} : TupleOf2(Shape<&2, Value>, Shape<&2, Value>)}
  Match.Tuple2(&2, Shape<&2, Value>, &2, Shape<&2, Value>, &2, CheckResult(Bool), scrut4633, +p4634 => +p4635 => (Match.Shape(&2, Value, &2, CheckResult(Bool), p4634, +p4636 => +p4637 => +p4638 => (Match.Shape(&2, Value, &2, CheckResult(Bool), p4635, +p4639 => +p4640 => +p4641 => (Native.choose(&2, CheckResult(Bool), Quantity.equal(p4636, p4639), _ => (eq_689(p4638, p4641)), _ => (Done{False{}}))), +p4642 => (Done{False{}}), +p4643 => +p4644 => (Done{False{}}), +p4645 => +p4646 => (Done{False{}}), +p4647 => +p4648 => (Done{False{}}))), +p4649 => (Match.Shape(&2, Value, &2, CheckResult(Bool), p4635, +p4650 => +p4651 => +p4652 => (Done{False{}}), +p4653 => (Done{Big.is_eq(p4649, p4653)}), +p4654 => +p4655 => (Done{False{}}), +p4656 => +p4657 => (Done{False{}}), +p4658 => +p4659 => (Done{False{}}))), +p4660 => +p4661 => (Match.Shape(&2, Value, &2, CheckResult(Bool), p4635, +p4662 => +p4663 => +p4664 => (Done{False{}}), +p4665 => (Done{False{}}), +p4666 => +p4667 => (Fail{Error.Not_yet{Rules.spar_word()}}), +p4668 => +p4669 => (Done{False{}}), +p4670 => +p4671 => (Done{False{}}))), +p4672 => +p4673 => (Match.Shape(&2, Value, &2, CheckResult(Bool), p4635, +p4674 => +p4675 => +p4676 => (Done{False{}}), +p4677 => (Done{False{}}), +p4678 => +p4679 => (Done{False{}}), +p4680 => +p4681 => (Native.choose(&2, CheckResult(Bool), NativeString.equal(p4672, p4680), _ => (Rules.payload_eq(&2, Value, eq_689, p4673, p4681)), _ => (Done{False{}}))), +p4693 => +p4694 => (Done{False{}}))), +p4695 => +p4696 => (Match.Shape(&2, Value, &2, CheckResult(Bool), p4635, +p4697 => +p4698 => +p4699 => (Done{False{}}), +p4700 => (Done{False{}}), +p4701 => +p4702 => (Done{False{}}), +p4703 => +p4704 => (Done{False{}}), +p4705 => +p4706 => (Fail{Error.Not_yet{Rules.snu_word()}})))))))
@unsafe
def Conv.former_case(-q0: Quant, -A0: Kind(q0), +ops_857: Rules.Ops<q0, A0>, +ctx_858: A0, +sd_859: Conv.Side, +a_860: Value, +b_861: Value) -> OptionOf(CheckResult(Bool)):
  (+scrut4608 = {(+scrut4607 = sd_859
  Match.Conv_Side(&1, Reusable(Value, OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)))), scrut4607, _ => (Value.as_ran), _ => (Value.as_lan))) : Reusable(Value, OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))))}
  Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, OptionOf(CheckResult(Bool)), scrut4608(a_860), _ => None{}, +item4713 => ((+local4610 => ((+scrut4611 = local4610
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, OptionOf(CheckResult(Bool)), scrut4611, +p4612 => +p4613 => +p4614 => ((Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, OptionOf(CheckResult(Bool)), scrut4608(b_861), _ => None{}, +item4710 => (Some{(+local4616 => ((+scrut4617 = local4616
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Bool), scrut4617, +p4618 => +p4619 => +p4620 => (Match.Result(&1, Rules.Rule_pack<q0, A0>, &2, Error, &2, CheckResult(Bool), Rules.rules(&2, Value, q0, A0, p4612), +item4707 => ((+local4623 => ((do CheckResult<Bool>:
  +bound4625 : Bool <- Rules.shape_eq((+local4630 => +local4632 => (Conv.conv_type(q0, A0, ops_857, ctx_858, local4630, local4632))), p4612, p4618)
  (+scrut4626 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Bool), Bool.not(bound4625), _ => (Done{False{}}), _ => (Native.choose(&2, CheckResult(Bool), Bool.not(Get.Rules.Rule_pack.ann_lvl_eq(q0, A0, local4623)(p4612, p4614, p4620)), _ => (Done{False{}}), _ => (Get.Rules.Rule_pack.conv_diagram(q0, A0, local4623)(ops_857, ctx_858, p4612, p4613, p4619)))))))))(item4707)), +item4708 => Fail{item4708}))))))(item4710)}))))))))(item4713))))
@unsafe
def Conv.conv_list(-q0: Quant, -A0: Kind(q0), +ops_1091: Rules.Ops<q0, A0>, +ctx_1092: A0, +xs_1093: ListOf(Value), +ys_1094: ListOf(Value)) -> CheckResult(Bool):
  Rules.payload_eq(&2, Value, (+local4740 => +local4742 => (Conv.conv_type(q0, A0, ops_1091, ctx_1092, local4740, local4742))), xs_1093, ys_1094)
@unsafe
def Conv.opt_else(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), +o_315: Maybe<q0, A0>, +dflt_316: Reusable(Unit, A1), +f_317: Reusable(A0, A1)) -> A1:
  Match.Maybe(q0, A0, &1, Reusable(Unit, A1), o_315, _ => (dflt_316), +value => ((+local4762 => +local4764 => ((+scrut4765 = local4764
  f_317(local4762))))(value)))(Unit{})
@unsafe
def Conv.first_of(+xs_343: List<&1, Reusable(Unit, OptionOf(CheckResult(Bool)))>) -> CheckResult(Bool):
  (+local4804 => (Maybe.default(&2, CheckResult(Bool), local4804, Done{False{}})))(SeqList.fold(&1, &2, Reusable(Unit, OptionOf(CheckResult(Bool))), OptionOf(CheckResult(Bool)), (+local4794 => +local4796 => (Conv.opt_else(&2, CheckResult(Bool), &2, OptionOf(CheckResult(Bool)), local4794, (+local4798 => ((+scrut4799 = local4798
  local4796(Unit{})))), (+local4801 => (Some{local4801}))))), xs_343, None{}))
@unsafe
def Conv.conv_addr(-q0: Quant, -A0: Kind(q0), +ops_971: Rules.Ops<q0, A0>, +ctx_972: A0, +arg_ty_973: OptionOf(Value), +a1_974: Value.Vaddr, +a2_975: Value.Vaddr) -> CheckResult(Bool):
  Conv.first_of(Con{(+local4744 => ((+scrut4745 = local4744
  (Match.Maybe(&2, TupleOf2(Quantity, Value), &2, OptionOf(CheckResult(Bool)), Value.as_pt(a1_974), _ => None{}, +item4769 => ((+local4747 => ((+scrut4748 = local4747
Match.Tuple2(&2, Quantity, &2, Value, &2, OptionOf(CheckResult(Bool)), scrut4748, +p4749 => +p4750 => (Match.Maybe(&2, TupleOf2(Quantity, Value), &2, OptionOf(CheckResult(Bool)), Value.as_pt(a2_975), _ => None{}, +item4767 => (Some{(+local4752 => ((+scrut4753 = local4752
Match.Tuple2(&2, Quantity, &2, Value, &2, CheckResult(Bool), scrut4753, +p4754 => +p4755 => (Conv.opt_else(&2, Value, &2, CheckResult(Bool), arg_ty_973, (+local4757 => ((+scrut4758 = local4757
Conv.conv_type(q0, A0, ops_971, ctx_972, p4750, p4755)))), (+local4760 => (Conv.conv(q0, A0, ops_971, ctx_972, local4760, p4750, p4755)))))))))(item4767)})))))))(item4769))))))), Con{(+local4772 => ((+scrut4773 = local4772
  Match.Maybe(&2, Big, &2, OptionOf(CheckResult(Bool)), Value.as_leg(a1_974), _ => None{}, +item4781 => ((+local4775 => (Match.Maybe(&2, Big, &2, OptionOf(CheckResult(Bool)), Value.as_leg(a2_975), _ => None{}, +item4779 => (Some{(+local4777 => (Done{Big.is_eq(local4775, local4777)}))(item4779)}))))(item4781)))))), Con{(+local4783 => ((+scrut4784 = local4783
  Match.Maybe(&2, String, &2, OptionOf(CheckResult(Bool)), Value.as_ctor(a1_974), _ => None{}, +item4792 => ((+local4786 => (Match.Maybe(&2, String, &2, OptionOf(CheckResult(Bool)), Value.as_ctor(a2_975), _ => None{}, +item4790 => (Some{(+local4788 => (Done{NativeString.equal(local4786, local4788)}))(item4790)}))))(item4792)))))), Nil{}}}})
@unsafe
def Conv.in_case(-q0: Quant, -A0: Kind(q0), +ops_873: Rules.Ops<q0, A0>, +ctx_874: A0, +a_875: Value, +b_876: Value) -> OptionOf(CheckResult(Bool)):
  Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Vaddr, ListOf(Value)), &2, OptionOf(CheckResult(Bool)), Value.as_in(a_875), _ => None{}, +item4815 => ((+local4721 => ((+scrut4722 = local4721
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Vaddr, &2, ListOf(Value), &2, OptionOf(CheckResult(Bool)), scrut4722, +p4723 => +p4724 => +p4725 => ((Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Vaddr, ListOf(Value)), &2, OptionOf(CheckResult(Bool)), Value.as_in(b_876), _ => None{}, +item4812 => (Some{(+local4727 => ((+scrut4728 = local4727
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Vaddr, &2, ListOf(Value), &2, CheckResult(Bool), scrut4728, +p4729 => +p4730 => +p4731 => ((do CheckResult<Bool>:
  +bound4733 : Bool <- Rules.shape_eq((+local4808 => +local4810 => (Conv.conv_type(q0, A0, ops_873, ctx_874, local4808, local4810))), p4723, p4729)
  +bound4735 : Bool <- Conv.conv_addr(q0, A0, ops_873, ctx_874, None{}, p4724, p4730)
  (+scrut4736 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Bool), Bool.not(bound4733), _ => (Done{False{}}), _ => (Native.choose(&2, CheckResult(Bool), Bool.not(bound4735), _ => (Done{False{}}), _ => (Conv.conv_list(q0, A0, ops_873, ctx_874, p4725, p4731))))))))))))(item4812)}))))))))(item4815)))
@unsafe
def Conv.grow(-q0: Quant, -A0: Kind(q0), +ops_1196: Rules.Ops<q0, A0>, +ctx_1197: A0, +n_1198: Big) -> A0:
  SeqList.fold(&2, q0, Big, A0, (+local4846 => +local4848 => (Get.Rules.Ops.o_bind(q0, A0, ops_1196)("_", Quantity.Many{}, Conv.placeholder(), local4846))), SeqList.init(&2, Big, n_1198, (+local4850 => (local4850))), ctx_1197)
@unsafe
def Conv.conv_closures(-q0: Quant, -A0: Kind(q0), +ops_1101: Rules.Ops<q0, A0>, +ctx_1102: A0, +arity_1103: Big, +x_1104: Value.Closure, +other_arity_1105: Big, +y_1106: Value.Closure) -> CheckResult(Bool):
  Native.choose(&2, CheckResult(Bool), Bool.not(Big.is_eq(arity_1103, other_arity_1105)), _ => (Done{False{}}), _ => ((+scrut4836 = {Get.Rules.Ops.o_size(q0, A0, ops_1101)(ctx_1102) : Big}
  (+scrut4839 = {SeqList.init(&2, Value, arity_1103, (+local4838 => (Value.var(NativeInt.sub(NativeInt.sub(NativeInt.add(scrut4836, arity_1103), Big.one()), local4838))))) : ListOf(Value)}
  (+scrut4840 = {Get.Rules.Ops.o_ev(q0, A0, ops_1101)(ctx_1102) : Rules.Evaluator}
  (do CheckResult<Bool>:
    +bound4842 : Value <- Get.Rules.Evaluator.ev_eval(scrut4840)(List.append(&2, Value, scrut4839, Get.Value.Closure.env(x_1104)), Get.Value.Closure.body(x_1104))
    +bound4844 : Value <- Get.Rules.Evaluator.ev_eval(scrut4840)(List.append(&2, Value, scrut4839, Get.Value.Closure.env(y_1106)), Get.Value.Closure.body(y_1106))
    Conv.conv_type(q0, A0, ops_1101, Conv.grow(q0, A0, ops_1101, ctx_1102, arity_1103), bound4842, bound4844)))))))
@unsafe
def Conv.conv_legs(-q0: Quant, -A0: Kind(q0), +ops_1095: Rules.Ops<q0, A0>, +ctx_1096: A0, +xs_1097: ListOf(Value.Vleg), +ys_1098: ListOf(Value.Vleg)) -> CheckResult(Bool):
  Rules.payload_eq(&2, Value.Vleg, (+local4833 => +local4835 => (Conv.conv_closures(q0, A0, ops_1095, ctx_1096, Big.of_nat(List.length(&2, TupleOf2(Quantity, String), Get.Value.Vleg.vl_binders(local4833))), Get.Value.Vleg.vl_clo(local4833), Big.of_nat(List.length(&2, TupleOf2(Quantity, String), Get.Value.Vleg.vl_binders(local4835))), Get.Value.Vleg.vl_clo(local4835)))), xs_1097, ys_1098)
@unsafe
def Conv.sec_case(-q0: Quant, -A0: Kind(q0), +ops_887: Rules.Ops<q0, A0>, +ctx_888: A0, +a_889: Value, +b_890: Value) -> OptionOf(CheckResult(Bool)):
  Match.Maybe(&2, TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg)), &2, OptionOf(CheckResult(Bool)), Value.as_sec(a_889), _ => None{}, +item4860 => ((+local4820 => ((+scrut4821 = local4820
  Match.Tuple2(&2, Shape<&2, Value>, &2, ListOf(Value.Vleg), &2, OptionOf(CheckResult(Bool)), scrut4821, +p4822 => +p4823 => (Match.Maybe(&2, TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg)), &2, OptionOf(CheckResult(Bool)), Value.as_sec(b_890), _ => None{}, +item4858 => (Some{(+local4825 => ((+scrut4826 = local4825
  Match.Tuple2(&2, Shape<&2, Value>, &2, ListOf(Value.Vleg), &2, CheckResult(Bool), scrut4826, +p4827 => +p4828 => ((do CheckResult<Bool>:
    +bound4830 : Bool <- Rules.shape_eq((+local4854 => +local4856 => (Conv.conv_type(q0, A0, ops_887, ctx_888, local4854, local4856))), p4822, p4827)
    (+scrut4831 = {Unit{} : Unit}
    Native.choose(&2, CheckResult(Bool), Bool.not(bound4830), _ => (Done{False{}}), _ => (Conv.conv_legs(q0, A0, ops_887, ctx_888, p4823, p4828))))))))))(item4858)})))))))(item4860)))
@unsafe
def Value.head_equal(+a_490: Value.Head, +b_491: Value.Head) -> Bool:
  (+scrut4875 = {Tup2{a_490, b_491} : TupleOf2(Value.Head, Value.Head)}
  Match.Tuple2(&2, Value.Head, &2, Value.Head, &2, Bool, scrut4875, +p4876 => +p4877 => (Match.Value_Head(&2, Bool, p4876, +p4878 => (Match.Value_Head(&2, Bool, p4877, +p4879 => (Big.is_eq(p4878, p4879)), +p4880 => (False{}))), +p4881 => (Match.Value_Head(&2, Bool, p4877, +p4882 => (False{}), +p4883 => (NativeString.equal(p4881, p4883))))))))
@unsafe
def Conv.spine_step(-q0: Quant, -A0: Kind(q0), +ops_959: Rules.Ops<q0, A0>, +ctx_960: A0, +hty_961: Value, +s_962: Shape<&2, Value>, +addr_963: Value.Vaddr) -> CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))):
  (do CheckResult<OptionOf(TupleOf2(OptionOf(Value), Value))>:
    +bound4921 : Value <- Get.Rules.Ops.o_whnf(q0, A0, ops_959)(ctx_960, hty_961)
    Conv.opt_else(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), Value.as_ran(bound4921), (+local4923 => ((+scrut4924 = local4923
    Done{None{}}))), (+local4926 => ((+scrut4927 = local4926
    Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), scrut4927, +p4928 => +p4929 => +p4930 => (Match.Result(&1, Rules.Rule_pack<q0, A0>, &2, Error, &2, CheckResult(OptionOf(TupleOf2(OptionOf(Value), Value))), Rules.rules(&2, Value, q0, A0, s_962), +item4934 => ((+local4933 => (Get.Rules.Rule_pack.spine_ty(q0, A0, local4933)(ops_959, ctx_960, s_962, p4929, addr_963)))(item4934)), +item4935 => Fail{item4935}))))))))
@unsafe
def Conv.branch_addr(-q0: Quant, -A0: Kind(q0), +ops_1174: Rules.Ops<q0, A0>, +ctx_1175: A0, +env1_1176: ListOf(Value), +env2_1177: ListOf(Value), +a1_1178: Term.Addr, +a2_1179: Term.Addr) -> CheckResult(Bool):
  (+scrut4968 = {Get.Rules.Ops.o_ev(q0, A0, ops_1174)(ctx_1175) : Rules.Evaluator}
  (Conv.first_of(Con{(+local4970 => ((+scrut4971 = local4970
(Match.Maybe(&2, TupleOf2(Quantity, Term), &2, OptionOf(CheckResult(Bool)), Term.as_apt(a1_1178), _ => None{}, +item4989 => ((+local4973 => ((+scrut4974 = local4973
Match.Tuple2(&2, Quantity, &2, Term, &2, OptionOf(CheckResult(Bool)), scrut4974, +p4975 => +p4976 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, OptionOf(CheckResult(Bool)), Term.as_apt(a2_1179), _ => None{}, +item4987 => (Some{(+local4978 => ((+scrut4979 = local4978
Match.Tuple2(&2, Quantity, &2, Term, &2, CheckResult(Bool), scrut4979, +p4980 => +p4981 => ((do CheckResult<Bool>:
  +bound4983 : Value <- Get.Rules.Evaluator.ev_eval(scrut4968)(env1_1176, p4976)
  +bound4985 : Value <- Get.Rules.Evaluator.ev_eval(scrut4968)(env2_1177, p4981)
  Conv.conv_type(q0, A0, ops_1174, ctx_1175, bound4983, bound4985)))))))(item4987)})))))))(item4989))))))), Con{(+local4992 => ((+scrut4993 = local4992
Match.Maybe(&2, Big, &2, OptionOf(CheckResult(Bool)), Term.as_aleg(a1_1178), _ => None{}, +item5001 => ((+local4995 => (Match.Maybe(&2, Big, &2, OptionOf(CheckResult(Bool)), Term.as_aleg(a2_1179), _ => None{}, +item4999 => (Some{(+local4997 => (Done{Big.is_eq(local4995, local4997)}))(item4999)}))))(item5001)))))), Con{(+local5003 => ((+scrut5004 = local5003
Match.Maybe(&2, String, &2, OptionOf(CheckResult(Bool)), Term.as_actor(a1_1178), _ => None{}, +item5012 => ((+local5006 => (Match.Maybe(&2, String, &2, OptionOf(CheckResult(Bool)), Term.as_actor(a2_1179), _ => None{}, +item5010 => (Some{(+local5008 => (Done{NativeString.equal(local5006, local5008)}))(item5010)}))))(item5012)))))), Nil{}}}})))
@unsafe
def Conv.conv_branches(-q0: Quant, -A0: Kind(q0), +ops_1161: Rules.Ops<q0, A0>, +ctx_1162: A0, +env1_1163: ListOf(Value), +env2_1164: ListOf(Value), +bs1_1165: ListOf(TupleOf2(Term.Addr, Term.Leg)), +bs2_1166: ListOf(TupleOf2(Term.Addr, Term.Leg))) -> CheckResult(Bool):
  Rules.payload_eq(&2, TupleOf2(Term.Addr, Term.Leg), (+local4957 => +local4959 => ((+scrut4960 = local4957
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(Bool), scrut4960, +p4961 => +p4962 => ((+scrut4963 = local4959
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(Bool), scrut4963, +p4964 => +p4965 => ((do CheckResult<Bool>:
    +bound4967 : Bool <- Conv.branch_addr(q0, A0, ops_1161, ctx_1162, env1_1163, env2_1164, p4961, p4964)
    Native.choose(&2, CheckResult(Bool), Bool.not(bound4967), _ => (Done{False{}}), _ => (Conv.conv_closures(q0, A0, ops_1161, ctx_1162, Big.of_nat(List.length(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(p4962))), MkValue_ClosureOf{env1_1163, Get.Term.Leg.l_body(p4962)}, Big.of_nat(List.length(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(p4965))), MkValue_ClosureOf{env2_1164, Get.Term.Leg.l_body(p4965)})))))))))))), bs1_1165, bs2_1166)
@unsafe
def Conv.conv_motive(-q0: Quant, -A0: Kind(q0), +ops_1146: Rules.Ops<q0, A0>, +ctx_1147: A0, +m1_1148: Value.Stuck_elim, +m2_1149: Value.Stuck_elim) -> CheckResult(Bool):
  (+local5016 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(Bool), local5016, _ => (Done{Bool.not(Maybe.is_some(&2, Term.Motive, Get.Value.Stuck_elim.s_motive(m2_1149)))}), +value => ((+local5018 => ((+local5021 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(Bool), local5021, _ => (Done{False{}}), +value => ((+local5023 => ((+scrut5024 = {Big.of_nat(List.length(&2, String, Get.Term.Motive.m_idx(local5018))) : Big}
  (+scrut5025 = {Big.of_nat(List.length(&2, String, Get.Term.Motive.m_idx(local5023))) : Big}
  (+scrut5026 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Bool), Bool.not(Big.is_eq(scrut5024, scrut5025)), _ => (Done{False{}}), _ => ((+scrut5027 = {Get.Rules.Ops.o_size(q0, A0, ops_1146)(ctx_1147) : Big}
  ((+scrut5030 = {SeqList.init(&2, Value, scrut5024, (+local5029 => (Value.var(NativeInt.sub(NativeInt.sub(NativeInt.add(scrut5027, scrut5024), Big.one()), local5029))))) : ListOf(Value)}
(+scrut5031 = {Value.var(NativeInt.add(scrut5027, scrut5024)) : Value}
(+scrut5032 = {Get.Rules.Ops.o_ev(q0, A0, ops_1146)(ctx_1147) : Rules.Evaluator}
(do CheckResult<Bool>:
  +bound5034 : Value <- Get.Rules.Evaluator.ev_eval(scrut5032)(Con{scrut5031, List.append(&2, Value, scrut5030, Get.Value.Stuck_elim.s_env(m1_1148))}, Get.Term.Motive.m_body(local5018))
  +bound5036 : Value <- Get.Rules.Evaluator.ev_eval(scrut5032)(Con{scrut5031, List.append(&2, Value, scrut5030, Get.Value.Stuck_elim.s_env(m2_1149))}, Get.Term.Motive.m_body(local5023))
  Conv.conv_type(q0, A0, ops_1146, Conv.grow(q0, A0, ops_1146, ctx_1147, NativeInt.add(scrut5024, Big.one())), bound5034, bound5036))))))))))))))(value)))))(Get.Value.Stuck_elim.s_motive(m2_1149))))(value)))))(Get.Value.Stuck_elim.s_motive(m1_1148))
@unsafe
def Conv.conv_stuck(-q0: Quant, -A0: Kind(q0), +ops_1113: Rules.Ops<q0, A0>, +ctx_1114: A0, +m1_1115: Value.Stuck_elim, +m2_1116: Value.Stuck_elim) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound4952 : Bool <- Rules.shape_eq((+local5041 => +local5043 => (Conv.conv_type(q0, A0, ops_1113, ctx_1114, local5041, local5043))), Get.Value.Stuck_elim.s_shape(m1_1115), Get.Value.Stuck_elim.s_shape(m2_1116))
    +bound4954 : Bool <- Conv.conv_motive(q0, A0, ops_1113, ctx_1114, m1_1115, m2_1116)
    (+scrut4955 = {Unit{} : Unit}
    Native.choose(&2, CheckResult(Bool), Bool.not(bound4952), _ => (Done{False{}}), _ => (Native.choose(&2, CheckResult(Bool), Bool.not(Quantity.equal(Get.Value.Stuck_elim.s_scrut_q(m1_1115), Get.Value.Stuck_elim.s_scrut_q(m2_1116))), _ => (Done{False{}}), _ => (Native.choose(&2, CheckResult(Bool), Bool.not(bound4954), _ => (Done{False{}}), _ => (Conv.conv_branches(q0, A0, ops_1113, ctx_1114, Get.Value.Stuck_elim.s_env(m1_1115), Get.Value.Stuck_elim.s_env(m2_1116), Get.Value.Stuck_elim.s_branches(m1_1115), Get.Value.Stuck_elim.s_branches(m2_1116))))))))))
@unsafe
def Conv.conv_spine(q0, A0, ops_909, ctx_910, hty_911, sp1_912, sp2_913):
  (+scrut4886 = {Tup2{sp1_912, sp2_913} : TupleOf2(ListOf(Value.Spine), ListOf(Value.Spine))}
  Match.Tuple2(&2, ListOf(Value.Spine), &2, ListOf(Value.Spine), &2, CheckResult(Bool), scrut4886, +p4887 => +p4888 => (Match.List(&2, Value.Spine, &2, CheckResult(Bool), p4887, _ => (Match.List(&2, Value.Spine, &2, CheckResult(Bool), p4888, _ => (Done{True{}}), +p4889 => +p4890 => (Done{False{}}))), +p4891 => +p4892 => (Match.Value_Spine(&2, CheckResult(Bool), p4891, +p4893 => +p4894 => (Match.List(&2, Value.Spine, &2, CheckResult(Bool), p4888, _ => (Done{False{}}), +p4895 => +p4896 => (Match.Value_Spine(&2, CheckResult(Bool), p4895, +p4897 => +p4898 => ((do CheckResult<Bool>:
    +bound4900 : Bool <- Rules.shape_eq((+local4939 => +local4941 => (Conv.conv_type(q0, A0, ops_909, ctx_910, local4939, local4941))), p4893, p4897)
    +bound4902 : OptionOf(TupleOf2(OptionOf(Value), Value)) <- Conv.spine_step(q0, A0, ops_909, ctx_910, hty_911, p4893, p4894)
    ((+scrut4908 = {Match.Maybe(&2, TupleOf2(OptionOf(Value), Value), &2, OptionOf(Value), bound4902, _ => None{}, +item4907 => ((+local4905 => (Get.Tuple2.v0(&2, OptionOf(Value), &2, Value, local4905)))(item4907))) : OptionOf(Value)}
(+scrut4915 = {(+local4911 => (Match.Maybe(&2, TupleOf2(OptionOf(Value), Value), &2, Value, local4911, _ => (Conv.placeholder()), +value => ((+local4914 => (Get.Tuple2.v1(&2, OptionOf(Value), &2, Value, local4914)))(value)))))(bound4902) : Value}
(do CheckResult<Bool>:
  +bound4917 : Bool <- Conv.conv_addr(q0, A0, ops_909, ctx_910, scrut4908, p4894, p4898)
  (+scrut4918 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Bool), Bool.not(bound4900), _ => (Done{False{}}), _ => (Native.choose(&2, CheckResult(Bool), Bool.not(bound4917), _ => (Done{False{}}), _ => (Conv.conv_spine(q0, A0, ops_909, ctx_910, scrut4915, p4892, p4896)))))))))))), +p4942 => (Done{False{}}))))), +p4943 => (Match.List(&2, Value.Spine, &2, CheckResult(Bool), p4888, _ => (Done{False{}}), +p4944 => +p4945 => (Match.Value_Spine(&2, CheckResult(Bool), p4944, +p4946 => +p4947 => (Done{False{}}), +p4948 => ((do CheckResult<Bool>:
    +bound4950 : Bool <- Conv.conv_stuck(q0, A0, ops_909, ctx_910, p4943, p4948)
    Native.choose(&2, CheckResult(Bool), bound4950, _ => (Conv.conv_spine(q0, A0, ops_909, ctx_910, Conv.placeholder(), p4892, p4945)), _ => (Done{False{}}))))))))))))))
@unsafe
def Conv.neutral_case(-q0: Quant, -A0: Kind(q0), +ops_898: Rules.Ops<q0, A0>, +ctx_899: A0, +a_900: Value, +b_901: Value) -> OptionOf(CheckResult(Bool)):
  Match.Maybe(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), &2, OptionOf(CheckResult(Bool)), Value.as_neutral(a_900), _ => None{}, +item5047 => ((+local4865 => ((+scrut4866 = local4865
  Match.Tuple2(&2, Value.Head, &2, ListOf(Value.Spine), &2, OptionOf(CheckResult(Bool)), scrut4866, +p4867 => +p4868 => (Match.Maybe(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), &2, OptionOf(CheckResult(Bool)), Value.as_neutral(b_901), _ => None{}, +item5045 => (Some{(+local4870 => ((+scrut4871 = local4870
  Match.Tuple2(&2, Value.Head, &2, ListOf(Value.Spine), &2, CheckResult(Bool), scrut4871, +p4872 => +p4873 => ((+scrut4874 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Bool), Bool.not(Value.head_equal(p4867, p4872)), _ => (Done{False{}}), _ => ((do CheckResult<Bool>:
    +bound4885 : Value <- Get.Rules.Ops.o_head_ty(q0, A0, ops_898)(ctx_899, p4867)
    Conv.conv_spine(q0, A0, ops_898, ctx_899, bound4885, List.reverse(&2, Value.Spine, p4868), List.reverse(&2, Value.Spine, p4873)))))))))))(item5045)})))))))(item5047)))
@unsafe
def Conv.structural(-q0: Quant, -A0: Kind(q0), +ops_832: Rules.Ops<q0, A0>, +ctx_833: A0, +a_834: Value, +b_835: Value) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound4570 : Value <- Get.Rules.Ops.o_whnf(q0, A0, ops_832)(ctx_833, a_834)
    ((do CheckResult<Bool>:
  +bound4572 : Value <- Get.Rules.Ops.o_whnf(q0, A0, ops_832)(ctx_833, b_835)
  Conv.first_of(Con{(+local4574 => ((+scrut4575 = local4574
  Conv.univ_case(bound4570, bound4572)))), Con{(+local4585 => ((+scrut4586 = local4585
  Conv.lit_case(bound4570, bound4572)))), Con{(+local4605 => ((+scrut4606 = local4605
  Conv.former_case(q0, A0, ops_832, ctx_833, Conv.Side.Right{}, bound4570, bound4572)))), Con{(+local4715 => ((+scrut4716 = local4715
  Conv.former_case(q0, A0, ops_832, ctx_833, Conv.Side.Left{}, bound4570, bound4572)))), Con{(+local4718 => ((+scrut4719 = local4718
  Conv.in_case(q0, A0, ops_832, ctx_833, bound4570, bound4572)))), Con{(+local4817 => ((+scrut4818 = local4817
  Conv.sec_case(q0, A0, ops_832, ctx_833, bound4570, bound4572)))), Con{(+local4862 => ((+scrut4863 = local4862
  Conv.neutral_case(q0, A0, ops_832, ctx_833, bound4570, bound4572)))), Nil{}}}}}}}}))))
@unsafe
def Conv.expansion_of(-q0: Quant, -A0: Kind(q0), +pack_597: Rules.Rule_pack<q0, A0>, +sd_598: Conv.Side) -> Maybe<&1, Rules.Expansion(q0, A0)>:
  (+scrut5092 = sd_598
  Match.Conv_Side(&1, Maybe<&1, Rules.Expansion(q0, A0)>, scrut5092, _ => (Native.choose(&1, Maybe<&1, Rules.Expansion(q0, A0)>, Get.Rules.Eta_row.eta_ran(Get.Rules.Rule_pack.eta(q0, A0, pack_597)), _ => (Get.Rules.Rule_pack.expand_ran(q0, A0, pack_597)), _ => (None{}))), _ => (Native.choose(&1, Maybe<&1, Rules.Expansion(q0, A0)>, Get.Rules.Eta_row.eta_lan(Get.Rules.Rule_pack.eta(q0, A0, pack_597)), _ => (Get.Rules.Rule_pack.expand_lan(q0, A0, pack_597)), _ => (None{})))))
@unsafe
def Conv.eta_step(-q0: Quant, -A0: Kind(q0), +ops_806: Rules.Ops<q0, A0>, +ctx_807: A0, +w_808: Value, +a_809: Value, +b_810: Value) -> CheckResult(OptionOf(Bool)):
  (+scrut5079 = {(+local5064 => (Match.Maybe(&2, TupleOf3(Conv.Side, Shape<&2, Value>, Value.Closure), &2, OptionOf(TupleOf3(Conv.Side, Shape<&2, Value>, Value.Closure)), local5064, _ => ((+local5067 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, OptionOf(TupleOf3(Conv.Side, Shape<&2, Value>, Value.Closure)), local5067, _ => None{}, +item5075 => (Some{(+local5069 => ((+scrut5070 = local5069
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, TupleOf3(Conv.Side, Shape<&2, Value>, Value.Closure), scrut5070, +p5071 => +p5072 => +p5073 => (Tup3{Conv.Side.Left{}, p5071, p5072})))))(item5075)}))))(Value.as_lan(w_808))), +value => ((+local5078 => (Some{local5078}))(value)))))((+local5053 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, OptionOf(TupleOf3(Conv.Side, Shape<&2, Value>, Value.Closure)), local5053, _ => None{}, +item5061 => (Some{(+local5055 => ((+scrut5056 = local5055
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, TupleOf3(Conv.Side, Shape<&2, Value>, Value.Closure), scrut5056, +p5057 => +p5058 => +p5059 => (Tup3{Conv.Side.Right{}, p5057, p5058})))))(item5061)}))))(Value.as_ran(w_808))) : OptionOf(TupleOf3(Conv.Side, Shape<&2, Value>, Value.Closure))}
  (Conv.opt_else(&2, TupleOf3(Conv.Side, Shape<&2, Value>, Value.Closure), &2, CheckResult(OptionOf(Bool)), scrut5079, (+local5081 => ((+scrut5082 = local5081
Done{None{}}))), (+local5084 => ((+scrut5085 = local5084
Match.Tuple3(&2, Conv.Side, &2, Shape<&2, Value>, &2, Value.Closure, &2, CheckResult(OptionOf(Bool)), scrut5085, +p5086 => +p5087 => +p5088 => (Match.Result(&1, Rules.Rule_pack<q0, A0>, &2, Error, &2, CheckResult(OptionOf(Bool)), Rules.rules(&2, Value, q0, A0, p5087), +item5103 => ((+local5091 => (Conv.opt_else(&1, Rules.Expansion(q0, A0), &2, CheckResult(OptionOf(Bool)), Conv.expansion_of(q0, A0, local5091, p5086), (+local5094 => ((+scrut5095 = local5094
Done{None{}}))), (+local5097 => (Match.Result(&2, Bool, &2, Error, &2, CheckResult(OptionOf(Bool)), local5097(ops_806, ctx_807, p5087, p5088, a_809, b_810), +item5101 => (Done{(+local5100 => (Some{local5100}))(item5101)}), +item5102 => Fail{item5102}))))))(item5103)), +item5104 => Fail{item5104})))))))))
@unsafe
def Conv.subsingleton_step(-q0: Quant, -A0: Kind(q0), +ops_797: Rules.Ops<q0, A0>, +ctx_798: A0, +w_799: Value) -> CheckResult(Bool):
  Conv.opt_else(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(Bool), Value.as_lan(w_799), (+local5107 => ((+scrut5108 = local5107
  Done{False{}}))), (+local5110 => ((+scrut5111 = local5110
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Bool), scrut5111, +p5112 => +p5113 => +p5114 => (Match.Result(&1, Rules.Rule_pack<q0, A0>, &2, Error, &2, CheckResult(Bool), Rules.rules(&2, Value, q0, A0, p5112), +item5118 => ((+local5117 => (Get.Rules.Rule_pack.subsingleton(q0, A0, local5117)(ops_797, ctx_798, p5112)))(item5118)), +item5119 => Fail{item5119})))))))
@unsafe
def Conv.conv(q0, A0, ops_764, ctx_765, ty_766, a_767, b_768):
  (+scrut4541 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Bool), Conv.is_prop(q0, A0, ops_764, ctx_765, ty_766), _ => (Done{True{}}), _ => ((do CheckResult<Bool>:
    +bound4561 : Value <- Get.Rules.Ops.o_whnf(q0, A0, ops_764)(ctx_765, ty_766)
    +bound4563 : Bool <- Conv.subsingleton_step(q0, A0, ops_764, ctx_765, bound4561)
    Native.choose(&2, CheckResult(Bool), bound4563, _ => (Done{True{}}), _ => ((do CheckResult<Bool>:
      +bound4565 : OptionOf(Bool) <- Conv.eta_step(q0, A0, ops_764, ctx_765, bound4561, a_767, b_768)
      Conv.opt_else(&2, Bool, &2, CheckResult(Bool), bound4565, (+local4567 => ((+scrut4568 = local4567
      Conv.structural(q0, A0, ops_764, ctx_765, a_767, b_768)))), (+local5050 => (Done{local5050}))))))))))
@unsafe
def Conv.conv_type(q0, A0, ops_828, ctx_829, a_830, b_831):
  Conv.conv(q0, A0, ops_828, ctx_829, Conv.placeholder(), a_830, b_831)
@unsafe
def Check.ensure(+c_1320: Check.Ctx, +got_1321: Value, +expected_1322: Value) -> CheckResult(Unit):
  (do CheckResult<Unit>:
    +bound4434 : Bool <- Conv.conv_type(&1, Check.Ctx, Check.ops(), c_1320, got_1321, expected_1322)
    Native.choose(&2, CheckResult(Unit), bound4434, _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.concat(["the term has type ", Check.pp_value(c_1320, got_1321), " and the expected type is ", Check.pp_value(c_1320, expected_1322)])}})))
@unsafe
def Check.check_former(+c_1310: Check.Ctx, +s_1311: Shape<&2, Term>, +diagram_1312: Term, +expected_1313: Value, +left_1314: Bool) -> CheckResult(Unit):
  (do CheckResult<Unit>:
    +bound5133 : Value <- Eval.whnf(Get.Check.Ctx.globals(c_1310), expected_1313)
    +bound5135 : Level <- (+local5147 => (Match.Maybe(&2, Level, &2, CheckResult(Level), local5147, _ => Fail{Error.Universe{String.append("a type former is checked against a type that is not a universe:  ", Check.pp_value(c_1310, bound5133))}}, +x => Done{x})))(Value.as_univ(bound5133))
    (Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(Unit), Rules.rules(&2, Term, &1, Check.Ctx, s_1311), +item5142 => ((+local5138 => ((+scrut5139 = {Native.choose(&1, Reusable(Rules.Ops<&1, Check.Ctx>, Reusable(Check.Ctx, Reusable(Shape<&2, Term>, Reusable(Term, Reusable(OptionOf(Level), CheckResult(Level)))))), left_1314, _ => (Get.Rules.Rule_pack.form_lan(&1, Check.Ctx, local5138)), _ => (Get.Rules.Rule_pack.form_ran(&1, Check.Ctx, local5138))) : Reusable(Rules.Ops<&1, Check.Ctx>, Reusable(Check.Ctx, Reusable(Shape<&2, Term>, Reusable(Term, Reusable(OptionOf(Level), CheckResult(Level))))))}
(do CheckResult<Unit>:
  +bound5141 : Level <- scrut5139(Check.ops(), c_1310, s_1311, diagram_1312, Some{bound5135})
  Native.choose(&2, CheckResult(Unit), Level.equal(bound5141, bound5135), _ => (Done{Unit{}}), _ => (Fail{Error.Universe{String.concat(["the former lives at ", Level.to_string(bound5141), " and the expected universe is ", Level.to_string(bound5135)])}}))))))(item5142)), +item5143 => Fail{item5143})))
@unsafe
def Check.check_uses(+c_1277: Check.Ctx, +mode_1278: Quantity, +t_1279: Term, +expected_1280: Value) -> CheckResult(Quantity.Usage):
  (+scrut4425 = t_1279
  Match.Term(&2, CheckResult(Quantity.Usage), scrut4425, +p4426 => ((do CheckResult<Quantity.Usage>:
    +bound4428 : TupleOf2(Value, Quantity.Usage) <- Check.infer_uses(c_1277, mode_1278, t_1279)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound4428, +p4429 => +p4430 => ((do CheckResult<Quantity.Usage>:
      +bound4432 : Unit <- Check.ensure(c_1277, p4429, expected_1280)
      Done{p4430}))))), +p5120 => ((do CheckResult<Quantity.Usage>:
    +bound5122 : TupleOf2(Value, Quantity.Usage) <- Check.infer_uses(c_1277, mode_1278, t_1279)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound5122, +p5123 => +p5124 => ((do CheckResult<Quantity.Usage>:
      +bound5126 : Unit <- Check.ensure(c_1277, p5123, expected_1280)
      Done{p5124}))))), +p5127 => +p5128 => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(Quantity.Usage), Check.check_former(c_1277, p5127, p5128, expected_1280, True{}), +item5148 => (Done{(+local5130 => ((+scrut5131 = local5130
  Quantity.empty())))(item5148)}), +item5149 => Fail{item5149})), +p5150 => +p5151 => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(Quantity.Usage), Check.check_former(c_1277, p5150, p5151, expected_1280, False{}), +item5155 => (Done{(+local5153 => ((+scrut5154 = local5153
  Quantity.empty())))(item5155)}), +item5156 => Fail{item5156})), +p5157 => +p5158 => +p5159 => (Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(Quantity.Usage), Rules.rules(&2, Term, &1, Check.Ctx, p5157), +item5163 => ((+local5162 => (Get.Rules.Rule_pack.intro_in(&1, Check.Ctx, local5162)(Check.ops(), c_1277, mode_1278, p5157, p5158, p5159, expected_1280)))(item5163)), +item5164 => Fail{item5164})), +p5165 => (Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(Quantity.Usage), Rules.rules(&2, Term, &1, Check.Ctx, Get.Term.Elim.e_shape(p5165)), +item5175 => ((+local5168 => ((do CheckResult<Quantity.Usage>:
    +bound5170 : TupleOf2(Value, Quantity.Usage) <- Get.Rules.Rule_pack.elim_elim(&1, Check.Ctx, local5168)(Check.ops(), c_1277, mode_1278, p5165, Some{expected_1280})
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound5170, +p5171 => +p5172 => ((do CheckResult<Quantity.Usage>:
      +bound5174 : Unit <- Check.ensure(c_1277, p5171, expected_1280)
      Done{p5172}))))))(item5175)), +item5176 => Fail{item5176})), +p5177 => +p5178 => (Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(Quantity.Usage), Rules.rules(&2, Term, &1, Check.Ctx, p5177), +item5182 => ((+local5181 => (Get.Rules.Rule_pack.intro_sec(&1, Check.Ctx, local5181)(Check.ops(), c_1277, mode_1278, p5177, p5178, expected_1280)))(item5182)), +item5183 => Fail{item5183})), +p5184 => +p5185 => +p5186 => ((do CheckResult<Quantity.Usage>:
    +bound5188 : TupleOf2(Value, Quantity.Usage) <- Check.infer_uses(c_1277, mode_1278, t_1279)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound5188, +p5189 => +p5190 => ((do CheckResult<Quantity.Usage>:
      +bound5192 : Unit <- Check.ensure(c_1277, p5189, expected_1280)
      Done{p5190}))))), +p5193 => +p5194 => +p5195 => +p5196 => (Match.Result(&2, TupleOf2(Value, Quantity.Usage), &2, Error, &2, CheckResult(Quantity.Usage), Check.let_body(c_1277, mode_1278, p5193, p5194, p5195, (+local5201 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound5203 : Quantity.Usage <- Check.check_uses(local5201, mode_1278, p5196, expected_1280)
    Done{Tup2{expected_1280, bound5203}})))), +item5204 => (Done{(+local5199 => (Get.Tuple2.v1(&2, Value, &2, Quantity.Usage, local5199)))(item5204)}), +item5205 => Fail{item5205})), +p5206 => +p5207 => ((do CheckResult<Quantity.Usage>:
    +bound5209 : TupleOf2(Value, Quantity.Usage) <- Check.infer_uses(c_1277, mode_1278, t_1279)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound5209, +p5210 => +p5211 => ((do CheckResult<Quantity.Usage>:
      +bound5213 : Unit <- Check.ensure(c_1277, p5210, expected_1280)
      Done{p5211}))))), +p5214 => ((do CheckResult<Quantity.Usage>:
    +bound5216 : TupleOf2(Value, Quantity.Usage) <- Check.infer_uses(c_1277, mode_1278, t_1279)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound5216, +p5217 => +p5218 => ((do CheckResult<Quantity.Usage>:
      +bound5220 : Unit <- Check.ensure(c_1277, p5217, expected_1280)
      Done{p5218}))))), +p5221 => ((do CheckResult<Quantity.Usage>:
    +bound5223 : TupleOf2(Value, Quantity.Usage) <- Check.infer_uses(c_1277, mode_1278, t_1279)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound5223, +p5224 => +p5225 => ((do CheckResult<Quantity.Usage>:
      +bound5227 : Unit <- Check.ensure(c_1277, p5224, expected_1280)
      Done{p5225}))))), _ => ((do CheckResult<Quantity.Usage>:
    +bound5229 : TupleOf2(Value, Quantity.Usage) <- Check.infer_uses(c_1277, mode_1278, t_1279)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Quantity.Usage), bound5229, +p5230 => +p5231 => ((do CheckResult<Quantity.Usage>:
      +bound5233 : Unit <- Check.ensure(c_1277, p5230, expected_1280)
      Done{p5231})))))))
@unsafe
def Check.infer_univ(+c_1003: Check.Ctx, +t_1004: Term) -> CheckResult(Level):
  (do CheckResult<Level>:
    +bound5235 : TupleOf2(Value, Quantity.Usage) <- Check.infer_uses(c_1003, Quantity.Zero{}, t_1004)
    Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(Level), bound5235, +p5236 => +p5237 => ((do CheckResult<Level>:
      +bound5239 : Value <- Eval.whnf(Get.Check.Ctx.globals(c_1003), p5236)
      (+local5242 => (Match.Maybe(&2, Level, &2, CheckResult(Level), local5242, _ => Fail{Error.Universe{String.append("a term used as a type is not a universe:  ", Check.pp_value(c_1003, bound5239))}}, +x => Done{x})))(Value.as_univ(bound5239))))))
@unsafe
def Check.let_body(c_1324, mode_1325, x_1326, ty_1327, def_1328, body_1329):
  (do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound4352 : Level <- Check.infer_univ(c_1324, ty_1327)
    +bound4354 : Value <- Eval.eval(Get.Check.Ctx.globals(c_1324), Get.Check.Ctx.env(c_1324), ty_1327)
    +bound4356 : Quantity.Usage <- Check.check_uses(c_1324, Quantity.runtime(mode_1325), def_1328, bound4354)
    +bound4358 : Value <- Eval.eval(Get.Check.Ctx.globals(c_1324), Get.Check.Ctx.env(c_1324), def_1328)
    ((+scrut4374 = {SeqList.exists(&2, TupleOf2(Big, TupleOf3(String, Quantity, Value)), (+local4360 => ((+scrut4361 = local4360
Match.Tuple2(&2, Big, &2, TupleOf3(String, Quantity, Value), &2, Bool, scrut4361, +p4362 => +p4363 => (Match.Tuple3(&2, String, &2, Quantity, &2, Value, &2, Bool, p4363, +p4364 => +p4365 => +p4366 => (Big.when(Bool, Quantity.equal(p4365, Quantity.One{}), _ => (Quantity.used(NativeInt.sub(NativeInt.sub(Get.Check.Ctx.size(c_1324), p4362), Big.one()), bound4356)), _ => (False{}))))))))), SeqList.mapi(&2, &2, TupleOf3(String, Quantity, Value), TupleOf2(Big, TupleOf3(String, Quantity, Value)), (+local4371 => +local4373 => (Tup2{local4371, local4373})), Get.Check.Ctx.locals(c_1324))) : Bool}
((+scrut4375 = {Native.choose(&2, Quantity, Quantity.equal(mode_1325, Quantity.Zero{}), _ => (Quantity.Zero{}), _ => (Native.choose(&2, Quantity, scrut4374, _ => (Quantity.One{}), _ => (Quantity.Many{})))) : Quantity}
(+scrut4376 = {Check.define(x_1326, scrut4375, bound4354, bound4358, c_1324) : Check.Ctx}
(do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound4378 : TupleOf2(Value, Quantity.Usage) <- body_1329(scrut4376)
  Match.Tuple2(&2, Value, &2, Quantity.Usage, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound4378, +p4379 => +p4380 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound4382 : Quantity.Usage <- Check.close(Some{scrut4374}, scrut4376, Get.Check.Ctx.size(c_1324), mode_1325, p4380)
    Done{Tup2{p4379, Quantity.sequence(Quantity.scale(mode_1325, bound4356), bound4382)}}))))))))))
@unsafe
def Global.entry_ty(+e_776: Global.Entry) -> Term:
  (+scrut5287 = e_776
  Match.Global_Entry(&2, Term, scrut5287, +p5288 => (Get.Global.Def_entry.ty(p5288)), +p5289 => (Get.Global.Axiom_entry.ax_ty(p5289)), +p5290 => (Get.Global.Prim_entry.p_ty(p5290))))
@unsafe
def Check.head_ty(+c_970: Check.Ctx, +h_971: Value.Head) -> CheckResult(Value):
  (+scrut5254 = h_971
  Match.Value_Head(&2, CheckResult(Value), scrut5254, +p5255 => ((+local5261 => (Match.Result(&2, TupleOf3(String, Quantity, Value), &2, Error, &2, CheckResult(Value), local5261, +item5268 => (Done{(+local5263 => ((+scrut5264 = local5263
  Match.Tuple3(&2, String, &2, Quantity, &2, Value, &2, Value, scrut5264, +p5265 => +p5266 => +p5267 => (p5267)))))(item5268)}), +item5269 => Fail{item5269})))((+local5258 => (Match.Maybe(&2, TupleOf3(String, Quantity, Value), &2, CheckResult(TupleOf3(String, Quantity, Value)), local5258, _ => Fail{Error.Unbound{"a local level is outside the context"}}, +x => Done{x})))(Rules.at(&2, TupleOf3(String, Quantity, Value), NativeInt.sub(NativeInt.sub(Get.Check.Ctx.size(c_970), p5255), Big.one()), Get.Check.Ctx.locals(c_970))))), +p5270 => ((+local5276 => ((+local5280 => +local5282 => (Match.Result(&2, Global.Entry, &2, Error, &2, CheckResult(Value), local5280, +item5283 => (local5282(item5283)), +item5284 => Fail{item5284})))(local5276, (+local5286 => (Eval.eval(Get.Check.Ctx.globals(c_970), Nil{}, Global.entry_ty(local5286)))))))((+local5273 => (Match.Maybe(&2, Global.Entry, &2, CheckResult(Global.Entry), local5273, _ => Fail{Error.Unbound{p5270}}, +x => Done{x})))(Global.find(p5270, Get.Check.Ctx.globals(c_970)))))))
@unsafe
def Check.string_word() -> String:
  "string types arrive at M1"
@unsafe
def Check.infer_node(+c_1012: Check.Ctx, +mode_1013: Quantity, +t_1014: Term) -> CheckResult(TupleOf2(Value, Quantity.Usage)):
  (+scrut4295 = t_1014
  Match.Term(&2, CheckResult(TupleOf2(Value, Quantity.Usage)), scrut4295, +p4296 => (((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
  +bound4298 : TupleOf3(String, Quantity, Value) <- (+local4305 => (Match.Maybe(&2, TupleOf3(String, Quantity, Value), &2, CheckResult(TupleOf3(String, Quantity, Value)), local4305, _ => Fail{Error.Unbound{String.concat(["de Bruijn index ", Big.show(p4296), " is outside the context"])}}, +x => Done{x})))(Rules.at(&2, TupleOf3(String, Quantity, Value), p4296, Get.Check.Ctx.locals(c_1012)))
  Match.Tuple3(&2, String, &2, Quantity, &2, Value, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), bound4298, +p4299 => +p4300 => +p4301 => (Native.choose(&2, CheckResult(TupleOf2(Value, Quantity.Usage)), Check.readable(mode_1013, p4300), _ => (Done{Tup2{p4301, Quantity.occurrence(NativeInt.sub(NativeInt.sub(Get.Check.Ctx.size(c_1012), p4296), Big.one()), mode_1013)}}), _ => (Fail{Error.Quantity{String.concat(["the erased binder ", p4299, " is read in a runtime position"])}}))))))), +p4307 => (Done{Tup2{Value.VUniv{Level.succ(p4307)}, Quantity.empty()}}), +p4308 => +p4309 => (Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), Rules.rules(&2, Term, &1, Check.Ctx, p4308), +item4315 => ((+local4312 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound4314 : Level <- Get.Rules.Rule_pack.form_lan(&1, Check.Ctx, local4312)(Check.ops(), c_1012, p4308, p4309, None{})
    Done{Tup2{Value.VUniv{bound4314}, Quantity.empty()}})))(item4315)), +item4316 => Fail{item4316})), +p4317 => +p4318 => (Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), Rules.rules(&2, Term, &1, Check.Ctx, p4317), +item4324 => ((+local4321 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound4323 : Level <- Get.Rules.Rule_pack.form_ran(&1, Check.Ctx, local4321)(Check.ops(), c_1012, p4317, p4318, None{})
    Done{Tup2{Value.VUniv{bound4323}, Quantity.empty()}})))(item4324)), +item4325 => Fail{item4325})), +p4326 => +p4327 => +p4328 => (Fail{Check.no_infer("an injection")}), +p4329 => (Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), Rules.rules(&2, Term, &1, Check.Ctx, Get.Term.Elim.e_shape(p4329)), +item4333 => ((+local4332 => (Get.Rules.Rule_pack.elim_elim(&1, Check.Ctx, local4332)(Check.ops(), c_1012, mode_1013, p4329, None{})))(item4333)), +item4334 => Fail{item4334})), +p4335 => +p4336 => (Fail{Check.no_infer("a section")}), +p4337 => +p4338 => +p4339 => (Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(TupleOf2(Value, Quantity.Usage)), Rules.rules(&2, Term, &1, Check.Ctx, p4337), +item4343 => ((+local4342 => (Get.Rules.Rule_pack.elim_out(&1, Check.Ctx, local4342)(Check.ops(), c_1012, mode_1013, p4337, p4338, p4339)))(item4343)), +item4344 => Fail{item4344})), +p4345 => +p4346 => +p4347 => +p4348 => (Check.let_body(c_1012, mode_1013, p4345, p4346, p4347, (+local4350 => (Check.infer_uses(local4350, mode_1013, p4348))))), +p5243 => +p5244 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound5246 : Level <- Check.infer_univ(c_1012, p5244)
    +bound5248 : Value <- Eval.eval(Get.Check.Ctx.globals(c_1012), Get.Check.Ctx.env(c_1012), p5244)
    +bound5250 : Quantity.Usage <- Check.check_uses(c_1012, mode_1013, p5243, bound5248)
    Done{Tup2{bound5248, bound5250}})), +p5251 => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound5253 : Value <- Check.head_ty(c_1012, Value.Head.HGlobal{p5251})
    Done{Tup2{bound5253, Quantity.empty()}})), +p5291 => (Match.Literal(&2, CheckResult(TupleOf2(Value, Quantity.Usage)), p5291, +p5292 => (Fail{Error.Not_yet{Check.string_word()}}), +p5293 => (Native.choose(&2, CheckResult(TupleOf2(Value, Quantity.Usage)), Big.is_lt(Bignum.sign(p5293), Big.zero()), _ => (Fail{Error.Mismatch{"a Nat literal must be nonnegative"}}), _ => ((do CheckResult<TupleOf2(Value, Quantity.Usage)>:
    +bound5295 : Value <- Eval.eval(Get.Check.Ctx.globals(c_1012), Nil{}, Prim.nat_ty())
    Done{Tup2{bound5295, Quantity.empty()}})))))), _ => (Fail{Error.Not_yet{Rules.auto_word()}})))
@unsafe
def Check.infer_uses(c_1009, mode_1010, t_1011):
  Native.choose(&2, CheckResult(TupleOf2(Value, Quantity.Usage)), Budget.exhausted(Get.Check.Ctx.budget(c_1009)), _ => (Fail{Error.Budget_exhausted{Check.budget_msg()}}), _ => (Check.infer_node(c_1009, mode_1010, t_1011)))
@unsafe
def Check.bind(+x_467: String, +q_468: Quantity, +ty_469: Value, +c_470: Check.Ctx) -> Check.Ctx:
  MkCheck_Ctx{Get.Check.Ctx.globals(c_470), Con{Value.var(Get.Check.Ctx.size(c_470)), Get.Check.Ctx.env(c_470)}, Con{Tup3{x_467, q_468, ty_469}, Get.Check.Ctx.locals(c_470)}, NativeInt.add(Get.Check.Ctx.size(c_470), Big.one()), Get.Check.Ctx.budget(c_470)}
@unsafe
def Check.ops():
  MkRules_Ops{(+local4290 => +local4292 => +local4294 => (Check.infer_uses(local4290, local4292, local4294))), (+local5297 => +local5299 => +local5301 => +local5303 => (Check.check_uses(local5297, local5299, local5301, local5303))), (+local5305 => +local5307 => +local5309 => +local5311 => (Check.close(None{}, local5305, local5307, local5309, local5311))), (+local5313 => +local5315 => (Check.infer_univ(local5313, local5315))), (+local5317 => +local5319 => +local5321 => +local5323 => (Conv.conv(&1, Check.Ctx, Check.ops(), local5317, local5319, local5321, local5323))), (+local5325 => +local5327 => +local5329 => (Conv.conv_type(&1, Check.Ctx, Check.ops(), local5325, local5327, local5329))), (+local5331 => +local5333 => (Eval.eval(Get.Check.Ctx.globals(local5331), Get.Check.Ctx.env(local5331), local5333))), (+local5335 => +local5337 => (Eval.whnf(Get.Check.Ctx.globals(local5335), local5337))), (+local5339 => +local5341 => +local5343 => +local5345 => (Check.bind(local5339, local5341, local5343, local5345))), (+local5347 => (Get.Check.Ctx.size(local5347))), (+local5349 => (Get.Check.Ctx.env(local5349))), (+local5351 => (Eval.ev(Get.Check.Ctx.globals(local5351)))), (+local5353 => +local5355 => (Check.pp_value(local5353, local5355))), (+local5357 => +local5359 => (Eval.quote(Get.Check.Ctx.globals(local5357), Get.Check.Ctx.size(local5357), local5359))), (+local5361 => +local5363 => (Check.head_ty(local5361, local5363))), (+local5365 => +local5367 => (Global.find_family(local5367, Get.Check.Ctx.globals(local5365))))}
@unsafe
def Check.infer(+c_1350: Check.Ctx, +mode_1351: Quantity, +t_1352: Term) -> CheckResult(Value):
  Match.Result(&2, TupleOf2(Value, Quantity.Usage), &2, Error, &2, CheckResult(Value), Check.infer_uses(c_1350, Quantity.runtime(mode_1351), t_1352), +item5432 => (Done{(+local5431 => (Get.Tuple2.v0(&2, Value, &2, Quantity.Usage, local5431)))(item5432)}), +item5433 => Fail{item5433})
@unsafe
def Check.check(+c_1355: Check.Ctx, +mode_1356: Quantity, +t_1357: Term, +expected_1358: Value) -> CheckResult(Unit):
  Match.Result(&2, Quantity.Usage, &2, Error, &2, CheckResult(Unit), Check.check_uses(c_1355, Quantity.runtime(mode_1356), t_1357, expected_1358), +item6286 => (Done{(+local6285 => (Unit{}))(item6286)}), +item6287 => Fail{item6287})
@unsafe
def Check.missing_body(+n_1370: String) -> Error:
  Error.Cannot_infer{String.append("the definition ", String.append(n_1370, " has no body"))}
@unsafe
def Check.check_decl(+globals_1373: Global, +budget_1374: Budget, +d_1375: Check.Decl) -> CheckResult(Global.Entry):
  (+scrut6274 = {Check.make(globals_1373, budget_1374) : Check.Ctx}
  ((do CheckResult<Global.Entry>:
  +bound6276 : Level <- Check.infer_univ(scrut6274, Get.Check.Decl.d_ty(d_1375))
  +bound6278 : Value <- Eval.eval(globals_1373, Nil{}, Get.Check.Decl.d_ty(d_1375))
  (+scrut6279 = {Get.Check.Decl.d_kind(d_1375) : Check.Kind}
  Match.Check_Kind(&2, CheckResult(Global.Entry), scrut6279, _ => ((do CheckResult<Global.Entry>:
    +bound6281 : Term <- (+local6290 => (Match.Maybe(&2, Term, &2, CheckResult(Term), local6290, _ => Fail{Check.missing_body(Get.Check.Decl.d_name(d_1375))}, +x => Done{x})))(Get.Check.Decl.d_body(d_1375))
    +bound6283 : Unit <- Check.check(scrut6274, Quantity.Many{}, bound6281, bound6278)
    Done{Global.Entry.Def{MkGlobal_Def_entry{Get.Check.Decl.d_ty(d_1375), bound6281, True{}, None{}, False{}}}})), _ => (Done{Global.Entry.Axiom{MkGlobal_Axiom_entry{Get.Check.Decl.d_ty(d_1375)}}}))))))
@unsafe
def Check.check_decls(+_opt__1395: Maybe<&1, Budget>, +globals_1384: Global, +ds_1385: ListOf(Check.Decl)) -> CheckResult(ListOf(TupleOf2(String, Global.Entry))):
  (+scrut6263 = {(+scrut6261 = _opt__1395
  Match.Maybe(&1, Budget, &1, Budget, scrut6261, _ => (Budget.unlimited()), +p6262 => (p6262))) : Budget}
  ((+local6294 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, CheckResult(ListOf(TupleOf2(String, Global.Entry))), local6294, +item6300 => (Done{(+local6296 => ((+scrut6297 = local6296
Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, ListOf(TupleOf2(String, Global.Entry)), scrut6297, +p6298 => +p6299 => (List.reverse(&2, TupleOf2(String, Global.Entry), p6299))))))(item6300)}), +item6301 => Fail{item6301})))(SeqList.fold(&2, &2, Check.Decl, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), (+local6265 => +local6267 => ((do CheckResult<TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))>:
  +bound6269 : TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))) <- local6265
  Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), bound6269, +p6270 => +p6271 => ((do CheckResult<TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))>:
    +bound6273 : Global.Entry <- Check.check_decl(p6270, scrut6263, local6267)
    Done{Tup2{Global.add(Get.Check.Decl.d_name(local6267), bound6273, p6270), Con{Tup2{Get.Check.Decl.d_name(local6267), bound6273}, p6271}}})))))), ds_1385, Done{Tup2{globals_1384, Nil{}}}))))
@unsafe
def Check.check_telescope(+c_1422: Check.Ctx, +tele_1423: Positivity.Telescope) -> Result<&2, &1, Error, Check.Ctx>:
  SeqList.fold(&2, &1, TupleOf3(Quantity, String, Term), Result<&2, &1, Error, Check.Ctx>, (+local6480 => +local6482 => ((+scrut6483 = local6482
  Match.Tuple3(&2, Quantity, &2, String, &2, Term, &1, Result<&2, &1, Error, Check.Ctx>, scrut6483, +p6484 => +p6485 => +p6486 => (Match.Result(&1, Check.Ctx, &2, Error, &1, Result<&2, &1, Error, Check.Ctx>, local6480, +item6500 => ((+local6489 => (Match.Result(&2, Level, &2, Error, &1, Result<&2, &1, Error, Check.Ctx>, Check.infer_univ(local6489, p6486), +item6498 => ((+local6492 => (Match.Result(&2, Value, &2, Error, &1, Result<&2, &1, Error, Check.Ctx>, Eval.eval(Get.Check.Ctx.globals(local6489), Get.Check.Ctx.env(local6489), p6486), +item6496 => ((+local6495 => (Done{Check.bind(p6485, p6484, local6495, local6489)}))(item6496)), +item6497 => Fail{item6497})))(item6498)), +item6499 => Fail{item6499})))(item6500)), +item6501 => Fail{item6501})))))), tele_1423, Done{c_1422})
@unsafe
def Level.le(+a_337: Level, +b_338: Level) -> Bool:
  Big.is_le(a_337, b_338)
@unsafe
def Check.index_rules(+c_1434: Check.Ctx, +name_1435: String, +level_1436: Level, +param_1442: TupleOf3(Quantity, String, Term)) -> CheckResult(Unit):
  (+scrut6513 = param_1442
  Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, CheckResult(Unit), scrut6513, +p6514 => +p6515 => +p6516 => ((do CheckResult<Unit>:
    +bound6518 : Unit <- Native.choose(&2, CheckResult(Unit), Quantity.equal(p6514, Quantity.Zero{}), _ => (Done{Unit{}}), _ => (Fail{Error.Index_not_zero{String.concat(["the index ", p6515, " of ", name_1435, " is at quantity ", Quantity.to_string(p6514), " and every index binder is at 0"])}}))
    +bound6520 : Level <- Check.infer_univ(c_1434, p6516)
    Native.choose(&2, CheckResult(Unit), Level.le(bound6520, level_1436), _ => (Done{Unit{}}), _ => (Fail{Error.Index_above_universe{String.concat(["the index ", p6515, " of ", name_1435, " lives at ", Level.to_string(bound6520), " and ", name_1435, " is declared at ", Level.to_string(level_1436)])}}))))))
@unsafe
def Check.check_index_telescope(+c_1445: Check.Ctx, +name_1446: String, +level_1447: Level, +tele_1448: Positivity.Telescope) -> Result<&2, &1, Error, Check.Ctx>:
  SeqList.fold(&2, &1, TupleOf3(Quantity, String, Term), Result<&2, &1, Error, Check.Ctx>, (+local6506 => +local6508 => (Match.Result(&1, Check.Ctx, &2, Error, &1, Result<&2, &1, Error, Check.Ctx>, local6506, +item6526 => ((+local6511 => (Match.Result(&2, Unit, &2, Error, &1, Result<&2, &1, Error, Check.Ctx>, Check.index_rules(local6511, name_1446, level_1447, local6508), +item6524 => ((+local6522 => ((+scrut6523 = local6522
  Check.check_telescope(local6511, Con{local6508, Nil{}}))))(item6524)), +item6525 => Fail{item6525})))(item6526)), +item6527 => Fail{item6527}))), tele_1448, Done{c_1445})
@unsafe
def Global.add_family(+name_771: String, +fam_772: Positivity.Family, +globals_773: Global) -> Global:
  MkGlobal{Get.Global.entries(globals_773), Assoc.add(&2, String, Positivity.Family, (+a => +b => NativeString.order(a, b)), name_771, fam_772, Get.Global.families(globals_773))}
@unsafe
def Check.declare_family(+_opt__1476: Maybe<&1, Budget>, +globals_1456: Global, +d_1457: Check.Family_decl) -> CheckResult(Global):
  (+scrut6474 = {(+scrut6472 = _opt__1476
  Match.Maybe(&1, Budget, &1, Budget, scrut6472, _ => (Budget.unlimited()), +p6473 => (p6473))) : Budget}
  (do CheckResult<Global>:
    +bound6476 : Unit <- Native.choose(&2, CheckResult(Unit), Maybe.is_some(&2, Positivity.Family, Global.find_family(Get.Check.Family_decl.fam_name(d_1457), globals_1456)), _ => (Fail{Error.Mismatch{String.append("the family ", String.append(Get.Check.Family_decl.fam_name(d_1457), " is already declared"))}}), _ => (Done{Unit{}}))
    (+scrut6477 = {Check.make(globals_1456, scrut6474) : Check.Ctx}
    (Match.Result(&1, Check.Ctx, &2, Error, &2, CheckResult(Global), Check.check_telescope(scrut6477, Get.Check.Family_decl.fam_params(d_1457)), +item6532 => ((+local6503 => (Match.Result(&1, Check.Ctx, &2, Error, &2, CheckResult(Global), Check.check_index_telescope(local6503, Get.Check.Family_decl.fam_name(d_1457), Get.Check.Family_decl.fam_level(d_1457), Get.Check.Family_decl.fam_indices(d_1457)), +item6530 => ((+local6529 => (Done{Global.add_family(Get.Check.Family_decl.fam_name(d_1457), MkPositivity_Family{Get.Check.Family_decl.fam_name(d_1457), Get.Check.Family_decl.fam_params(d_1457), Get.Check.Family_decl.fam_indices(d_1457), Get.Check.Family_decl.fam_level(d_1457), Positivity.Ctor_status.Provisional{}, Nil{}, False{}}, globals_1456)}))(item6530)), +item6531 => Fail{item6531})))(item6532)), +item6533 => Fail{item6533})))))
@unsafe
def Shape.family(-q0: Quant, -A0: Kind(q0), +s_367: Shape<q0, A0>) -> OptionOf(String):
  (+scrut6715 = s_367
  Match.Shape(q0, A0, &2, OptionOf(String), scrut6715, +p6716 => +p6717 => +p6718 => (None{}), +p6719 => (None{}), +p6720 => +p6721 => (None{}), +p6722 => +p6723 => (Some{p6722}), +p6724 => +p6725 => (Some{p6724})))
@unsafe
def Shape.payload(-q0: Quant, -A0: Kind(q0), +s_355: Shape<q0, A0>) -> List<q0, A0>:
  (+scrut6729 = s_355
  Match.Shape(q0, A0, q0, List<q0, A0>, scrut6729, +p6730 => +p6731 => +p6732 => (Con{p6732, Nil{}}), +p6733 => (Nil{}), +p6734 => +p6735 => (Con{p6734, Con{p6735, Nil{}}}), +p6736 => +p6737 => (p6737), +p6738 => +p6739 => (p6739)))
@unsafe
def Local.Term.occurs_shape.f6700(+member_432: Reusable(String, Bool), +include_families_429: Bool, +s_598: Shape<&2, Term>) -> Bool:
  Big.when(Bool, Big.when(Bool, include_families_429, _ => (Match.Maybe(&2, String, &2, Bool, Shape.family(&2, Term, s_598), _ => (False{}), +value => (member_432(value)))), _ => (False{})), _ => (True{}), _ => (SeqList.exists(&2, Term, (+local6728 => (Local.Term.occurs.f6699(member_432, include_families_429, local6728))), Shape.payload(&2, Term, s_598))))
@unsafe
def Local.Term.occurs_addr.f6701(+member_432: Reusable(String, Bool), +include_families_429: Bool, +a_616: Term.Addr) -> Bool:
  (+local6762 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, Bool, local6762, _ => (False{}), +value => ((+local6764 => ((+scrut6765 = local6764
  Match.Tuple2(&2, Quantity, &2, Term, &2, Bool, scrut6765, +p6766 => +p6767 => ((+local6770 => (Local.Term.occurs.f6699(member_432, include_families_429, local6770)))(p6767))))))(value)))))(Term.as_apt(a_616))
@unsafe
def Local.Term.occurs_motive.f6703(+member_432: Reusable(String, Bool), +include_families_429: Bool, +mo_621: OptionOf(Term.Motive)) -> Bool:
  (+local6786 => (Match.Maybe(&2, Term.Motive, &2, Bool, local6786, _ => (False{}), +value => ((+local6788 => ((+local6791 => (Local.Term.occurs.f6699(member_432, include_families_429, local6791)))(Get.Term.Motive.m_body(local6788))))(value)))))(mo_621)
@unsafe
def Local.Term.occurs_leg.f6702(+member_432: Reusable(String, Bool), +include_families_429: Bool, +lg_620: Term.Leg) -> Bool:
  (+local6805 => (Local.Term.occurs.f6699(member_432, include_families_429, local6805)))(Get.Term.Leg.l_body(lg_620))
@unsafe
def Local.Term.occurs.f6699(member_432, include_families_429, tm_575):
  (+scrut6707 = tm_575
  Match.Term(&2, Bool, scrut6707, +p6708 => (False{}), +p6709 => (False{}), +p6710 => +p6711 => (Big.when(Bool, (+local6714 => (Local.Term.occurs_shape.f6700(member_432, include_families_429, local6714)))(p6710), _ => (True{}), _ => ((+local6742 => (Local.Term.occurs.f6699(member_432, include_families_429, local6742)))(p6711)))), +p6743 => +p6744 => (Big.when(Bool, (+local6747 => (Local.Term.occurs_shape.f6700(member_432, include_families_429, local6747)))(p6743), _ => (True{}), _ => ((+local6750 => (Local.Term.occurs.f6699(member_432, include_families_429, local6750)))(p6744)))), +p6751 => +p6752 => +p6753 => (Big.when(Bool, (+local6756 => (Local.Term.occurs_shape.f6700(member_432, include_families_429, local6756)))(p6751), _ => (True{}), _ => (Big.when(Bool, (+local6759 => (Local.Term.occurs_addr.f6701(member_432, include_families_429, local6759)))(p6752), _ => (True{}), _ => (SeqList.exists(&2, Term, (+local6773 => (Local.Term.occurs.f6699(member_432, include_families_429, local6773))), p6753)))))), +p6774 => ((Big.when(Bool, (+local6777 => (Local.Term.occurs_shape.f6700(member_432, include_families_429, local6777)))(Get.Term.Elim.e_shape(p6774)), _ => (True{}), _ => (Big.when(Bool, (+local6780 => (Local.Term.occurs.f6699(member_432, include_families_429, local6780)))(Get.Term.Elim.e_scrut(p6774)), _ => (True{}), _ => (Big.when(Bool, (+local6783 => (Local.Term.occurs_motive.f6703(member_432, include_families_429, local6783)))(Get.Term.Elim.e_motive(p6774)), _ => (True{}), _ => (SeqList.exists(&2, TupleOf2(Term.Addr, Term.Leg), (+local6793 => ((+scrut6794 = local6793
Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, Bool, scrut6794, +p6795 => +p6796 => (Big.when(Bool, (+local6799 => (Local.Term.occurs_addr.f6701(member_432, include_families_429, local6799)))(p6795), _ => (True{}), _ => ((+local6802 => (Local.Term.occurs_leg.f6702(member_432, include_families_429, local6802)))(p6796)))))))), Get.Term.Elim.e_branches(p6774)))))))))), +p6807 => +p6808 => (Big.when(Bool, (+local6811 => (Local.Term.occurs_shape.f6700(member_432, include_families_429, local6811)))(p6807), _ => (True{}), _ => (SeqList.exists(&2, Term.Leg, (+local6814 => (Local.Term.occurs_leg.f6702(member_432, include_families_429, local6814))), p6808)))), +p6815 => +p6816 => +p6817 => (Big.when(Bool, (+local6820 => (Local.Term.occurs_shape.f6700(member_432, include_families_429, local6820)))(p6815), _ => (True{}), _ => (Big.when(Bool, (+local6823 => (Local.Term.occurs_addr.f6701(member_432, include_families_429, local6823)))(p6816), _ => (True{}), _ => ((+local6826 => (Local.Term.occurs.f6699(member_432, include_families_429, local6826)))(p6817)))))), +p6827 => +p6828 => +p6829 => +p6830 => (Big.when(Bool, (+local6833 => (Local.Term.occurs.f6699(member_432, include_families_429, local6833)))(p6828), _ => (True{}), _ => (Big.when(Bool, (+local6836 => (Local.Term.occurs.f6699(member_432, include_families_429, local6836)))(p6829), _ => (True{}), _ => ((+local6839 => (Local.Term.occurs.f6699(member_432, include_families_429, local6839)))(p6830)))))), +p6840 => +p6841 => (Big.when(Bool, (+local6844 => (Local.Term.occurs.f6699(member_432, include_families_429, local6844)))(p6840), _ => (True{}), _ => ((+local6847 => (Local.Term.occurs.f6699(member_432, include_families_429, local6847)))(p6841)))), +p6848 => (member_432(p6848)), +p6849 => (False{}), _ => (False{})))
@unsafe
def Term.exists_name(+include_families_429: Bool, +names_430: ListOf(String), +term_431: Term) -> Bool:
  (+scrut6698 = {(+local6694 => (SeqList.exists(&2, String, (+local6697 => (NativeString.equal(local6694, local6697))), names_430))) : Reusable(String, Bool)}
  (+local6706 => (Local.Term.occurs.f6699(scrut6698, include_families_429, local6706)))(term_431))
@unsafe
def Positivity.occurs(+names_569: ListOf(String), +t_570: Term) -> Bool:
  Term.exists_name(True{}, names_569, t_570)
@unsafe
def Positivity.self_rec(+names_651: ListOf(String), +args_652: Positivity.Telescope) -> Bool:
  SeqList.exists(&2, TupleOf3(Quantity, String, Term), (+local6688 => ((+scrut6689 = local6688
  Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, Bool, scrut6689, +p6690 => +p6691 => +p6692 => (Positivity.occurs(names_651, p6692)))))), args_652)
@unsafe
def Check.parameter_at(+index_1478: Big, +tm_1479: Term) -> Bool:
  (+scrut6858 = tm_1479
  Match.Term(&2, Bool, scrut6858, +p6859 => (Big.is_eq(p6859, index_1478)), +p6860 => (False{}), +p6861 => +p6862 => (False{}), +p6863 => +p6864 => (False{}), +p6865 => +p6866 => +p6867 => (False{}), +p6868 => (False{}), +p6869 => +p6870 => (False{}), +p6871 => +p6872 => +p6873 => (False{}), +p6874 => +p6875 => +p6876 => +p6877 => (False{}), +p6878 => +p6879 => (Check.parameter_at(index_1478, p6878)), +p6880 => (False{}), +p6881 => (False{}), _ => (False{})))
@unsafe
def Positivity.absent(+names_595: ListOf(String), +t_596: Term) -> CheckResult(Unit):
  Native.choose(&2, CheckResult(Unit), Positivity.occurs(names_595, t_596), _ => (Fail{Error.Not_yet{Positivity.nonpositive_word()}}), _ => (Done{Unit{}}))
@unsafe
def Positivity.is_member(+names_573: ListOf(String), +n_574: OptionOf(String)) -> Bool:
  (+local6900 => (Match.Maybe(&2, String, &2, Bool, local6900, _ => (False{}), +value => ((+local6902 => (SeqList.exists(&2, String, (+local6905 => (NativeString.equal(local6902, local6905))), names_573)))(value)))))(n_574)
@unsafe
def Positivity.absent_list(+names_607: ListOf(String), +ts_608: ListOf(Term)) -> CheckResult(Unit):
  Native.choose(&2, CheckResult(Unit), SeqList.exists(&2, Term, (+local6908 => (Positivity.occurs(names_607, local6908))), ts_608), _ => (Fail{Error.Not_yet{Positivity.nonpositive_word()}}), _ => (Done{Unit{}}))
@unsafe
def Shape.point_dom(-q0: Quant, -A0: Kind(q0), +s_363: Shape<q0, A0>) -> Maybe<q0, A0>:
  (+scrut6916 = s_363
  Match.Shape(q0, A0, q0, Maybe<q0, A0>, scrut6916, +p6917 => +p6918 => +p6919 => (Some{p6919}), +p6920 => (None{}), +p6921 => +p6922 => (None{}), +p6923 => +p6924 => (None{}), +p6925 => +p6926 => (None{})))
@unsafe
def Positivity.positive(+names_610: ListOf(String), +t_611: Term) -> CheckResult(Unit):
  (+scrut6893 = t_611
  Match.Term(&2, CheckResult(Unit), scrut6893, +p6894 => (Positivity.absent(names_610, t_611)), +p6895 => (Positivity.absent(names_610, t_611)), +p6896 => +p6897 => (Native.choose(&2, CheckResult(Unit), Positivity.is_member(names_610, Shape.family(&2, Term, p6896)), _ => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(Unit), Positivity.absent_list(names_610, Shape.payload(&2, Term, p6896)), +item6912 => ((+local6910 => ((+scrut6911 = local6910
  Positivity.absent(names_610, p6897))))(item6912)), +item6913 => Fail{item6913})), _ => (Positivity.absent(names_610, t_611)))), +p6914 => +p6915 => ((+local6929 => (Match.Maybe(&2, Term, &2, CheckResult(Unit), local6929, _ => (Positivity.absent(names_610, t_611)), +value => ((+local6931 => ((do CheckResult<Unit>:
    +bound6933 : Unit <- Positivity.absent(names_610, local6931)
    Positivity.positive(names_610, p6915))))(value)))))(Shape.point_dom(&2, Term, p6914))), +p6934 => +p6935 => +p6936 => (Positivity.absent(names_610, t_611)), +p6937 => (Positivity.absent(names_610, t_611)), +p6938 => +p6939 => (Positivity.absent(names_610, t_611)), +p6940 => +p6941 => +p6942 => ((+local6949 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, CheckResult(Unit), local6949, _ => (Positivity.absent(names_610, t_611)), +value => ((+local6951 => ((+scrut6952 = local6951
  Match.Tuple2(&2, Quantity, &2, Term, &2, CheckResult(Unit), scrut6952, +p6953 => +p6954 => ((do CheckResult<Unit>:
    +bound6956 : Unit <- Positivity.absent(names_610, p6954)
    Positivity.positive(names_610, p6942)))))))(value)))))(Match.Maybe(&2, Term, &2, OptionOf(TupleOf2(Quantity, Term)), Shape.point_dom(&2, Term, p6940), _ => None{}, +item6946 => ((+local6944 => (Term.as_apt(p6941)))(item6946))))), +p6957 => +p6958 => +p6959 => +p6960 => (Positivity.absent(names_610, t_611)), +p6961 => +p6962 => (Positivity.absent(names_610, t_611)), +p6963 => (Done{Unit{}}), +p6964 => (Positivity.absent(names_610, t_611)), _ => (Positivity.absent(names_610, t_611))))
@unsafe
def Positivity.ctor_fields(+names_641: ListOf(String), +args_642: Positivity.Telescope) -> CheckResult(Unit):
  SeqList.fold(&2, &2, TupleOf3(Quantity, String, Term), CheckResult(Unit), (+local6884 => +local6886 => ((+scrut6887 = local6886
  Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, CheckResult(Unit), scrut6887, +p6888 => +p6889 => +p6890 => ((do CheckResult<Unit>:
    +bound6892 : Unit <- local6884
    Positivity.positive(names_641, p6890))))))), args_642, Done{Unit{}})
@unsafe
def Check.check_ctor(+c_1516: Check.Ctx, +fam_1517: Positivity.Family, +group_1518: ListOf(String), +cd_1519: Check.Ctor_decl) -> CheckResult(Positivity.Ctor):
  Match.Result(&1, Check.Ctx, &2, Error, &2, CheckResult(Positivity.Ctor), SeqList.fold(&2, &1, TupleOf3(Quantity, String, Term), Result<&2, &1, Error, Check.Ctx>, (+local6648 => +local6650 => ((+scrut6651 = local6650
  Match.Tuple3(&2, Quantity, &2, String, &2, Term, &1, Result<&2, &1, Error, Check.Ctx>, scrut6651, +p6652 => +p6653 => +p6654 => ((Match.Result(&1, Check.Ctx, &2, Error, &1, Result<&2, &1, Error, Check.Ctx>, local6648, +item6669 => ((+local6657 => (Match.Result(&2, Level, &2, Error, &1, Result<&2, &1, Error, Check.Ctx>, Check.infer_univ(local6657, p6654), +item6667 => ((+local6660 => (Match.Result(&2, Unit, &2, Error, &1, Result<&2, &1, Error, Check.Ctx>, Native.choose(&2, CheckResult(Unit), Level.le(local6660, Get.Positivity.Family.f_level(fam_1517)), _ => (Done{Unit{}}), _ => (Fail{Error.Universe{String.append("a field of ", String.append(Get.Check.Ctor_decl.ct_name(cd_1519), " exceeds its family universe"))}})), +item6665 => ((+local6663 => ((+scrut6664 = local6663
Check.check_telescope(local6657, Con{Tup3{p6652, p6653, p6654}, Nil{}}))))(item6665)), +item6666 => Fail{item6666})))(item6667)), +item6668 => Fail{item6668})))(item6669)), +item6670 => Fail{item6670}))))))), Get.Check.Ctor_decl.ct_args(cd_1519), Done{c_1516}), +item6965 => ((+local6673 => ((do CheckResult<Positivity.Ctor>:
    +bound6675 : Unit <- Positivity.ctor_fields(group_1518, Get.Check.Ctor_decl.ct_args(cd_1519))
    (+scrut6676 = {Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Family.f_params(fam_1517))) : Big}
    (+scrut6677 = {Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Check.Ctor_decl.ct_args(cd_1519))) : Big}
    ((do CheckResult<Positivity.Ctor>:
  +bound6679 : Unit <- Native.choose(&2, CheckResult(Unit), Big.when(Bool, Big.is_eq(Big.of_nat(List.length(&2, Term, Get.Check.Ctor_decl.ct_res_params(cd_1519))), scrut6676), _ => (SeqList.all(&2, Bool, (+local6853 => (local6853)), SeqList.mapi(&2, &2, Term, Bool, (+local6855 => +local6857 => (Check.parameter_at(NativeInt.sub(NativeInt.sub(NativeInt.add(scrut6677, scrut6676), local6855), Big.one()), local6857))), Get.Check.Ctor_decl.ct_res_params(cd_1519)))), _ => (False{})), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.append("the constructor ", String.append(Get.Check.Ctor_decl.ct_name(cd_1519), " must preserve its family parameters"))}}))
  +bound6681 : ListOf(Value) <- Rules.mu_telescope(&1, Check.Ctx, Check.ops(), local6673, Quantity.Zero{}, String.append("the parameters of ", Get.Check.Ctor_decl.ct_name(cd_1519)), Get.Positivity.Family.f_params(fam_1517), Get.Check.Ctor_decl.ct_res_params(cd_1519), Nil{})
  (+scrut6682 = {Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Family.f_indices(fam_1517))) : Big}
  ((do CheckResult<Positivity.Ctor>:
  +bound6684 : Unit <- Native.choose(&2, CheckResult(Unit), Big.is_eq(Big.of_nat(List.length(&2, Term, Get.Check.Ctor_decl.ct_res_idx(cd_1519))), scrut6682), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.concat([Get.Check.Ctor_decl.ct_name(cd_1519), " gives ", Big.show(Big.of_nat(List.length(&2, Term, Get.Check.Ctor_decl.ct_res_idx(cd_1519)))), " result indices and ", Get.Positivity.Family.f_name(fam_1517), " takes ", Big.show(scrut6682)])}}))
  +bound6686 : ListOf(Value) <- Rules.mu_telescope(&1, Check.Ctx, Check.ops(), local6673, Quantity.Zero{}, String.append("the result indices of ", Get.Check.Ctor_decl.ct_name(cd_1519)), Get.Positivity.Family.f_indices(fam_1517), Get.Check.Ctor_decl.ct_res_idx(cd_1519), bound6681)
  Done{MkPositivity_Ctor{Get.Check.Ctor_decl.ct_name(cd_1519), Get.Check.Ctor_decl.ct_args(cd_1519), Get.Check.Ctor_decl.ct_res_idx(cd_1519), NativeInt.add(Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Family.f_params(fam_1517))), Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Check.Ctor_decl.ct_args(cd_1519)))), Positivity.self_rec(group_1518, Get.Check.Ctor_decl.ct_args(cd_1519))}}))))))))))(item6965)), +item6966 => Fail{item6966})
@unsafe
def Check.define_ctors(+_opt__1556: Maybe<&1, Budget>, +globals_1542: Global, +group_1543: ListOf(String), +name_1544: String, +cds_1545: ListOf(Check.Ctor_decl)) -> CheckResult(Global):
  (+scrut6625 = {(+scrut6623 = _opt__1556
  Match.Maybe(&1, Budget, &1, Budget, scrut6623, _ => (Budget.unlimited()), +p6624 => (p6624))) : Budget}
  ((do CheckResult<Global>:
  +bound6627 : Positivity.Family <- (+local6974 => (Match.Maybe(&2, Positivity.Family, &2, CheckResult(Positivity.Family), local6974, _ => Fail{Error.Unbound{String.append("the family ", String.append(name_1544, " is not declared"))}}, +x => Done{x})))(Global.find_family(name_1544, globals_1542))
  +bound6629 : Unit <- (+scrut6970 = {Get.Positivity.Family.f_status(bound6627) : Positivity.Ctor_status}
  Match.Positivity_Ctor_status(&2, CheckResult(Unit), scrut6970, _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.append("the constructors of ", String.append(name_1544, " are already installed"))}}), +p6971 => (Fail{Error.Mismatch{String.append("the constructors of ", String.append(name_1544, " are already installed"))}})))
  (+scrut6630 = {Check.make(globals_1542, scrut6625) : Check.Ctx}
  (Match.Result(&1, Check.Ctx, &2, Error, &2, CheckResult(Global), Check.check_telescope(scrut6630, Get.Positivity.Family.f_params(bound6627)), +item6967 => ((+local6633 => ((do CheckResult<Global>:
  +bound6635 : ListOf(Positivity.Ctor) <- SeqList.fold(&2, &2, Check.Ctor_decl, CheckResult(ListOf(Positivity.Ctor)), (+local6639 => +local6641 => ((do CheckResult<ListOf(Positivity.Ctor)>:
    +bound6643 : ListOf(Positivity.Ctor) <- local6639
    +bound6645 : Positivity.Ctor <- Check.check_ctor(local6633, bound6627, group_1543, local6641)
    Done{List.append(&2, Positivity.Ctor, bound6643, Con{bound6645, Nil{}})}))), cds_1545, Done{Nil{}})
  Done{Global.add_family(name_1544, MkPositivity_Family{Get.Positivity.Family.f_name(bound6627), Get.Positivity.Family.f_params(bound6627), Get.Positivity.Family.f_indices(bound6627), Get.Positivity.Family.f_level(bound6627), Positivity.Ctor_status.Complete{SeqList.map(&2, &2, Check.Ctor_decl, String, (+local6637 => (Get.Check.Ctor_decl.ct_name(local6637))), cds_1545)}, bound6635, True{}}, globals_1542)})))(item6967)), +item6968 => Fail{item6968}))))))
@unsafe
def Order.as_lam(+t_484: Term) -> OptionOf(TupleOf2(Shape<&2, Term>, Term.Leg)):
  (+scrut7085 = t_484
  Match.Term(&2, OptionOf(TupleOf2(Shape<&2, Term>, Term.Leg)), scrut7085, +p7086 => (None{}), +p7087 => (None{}), +p7088 => +p7089 => (None{}), +p7090 => +p7091 => (None{}), +p7092 => +p7093 => +p7094 => (None{}), +p7095 => (None{}), +p7096 => +p7097 => ((Match.Maybe(&2, Term.Leg, &2, OptionOf(TupleOf2(Shape<&2, Term>, Term.Leg)), Match.Maybe(&2, TupleOf3(Quantity, String, Term), &2, OptionOf(Term.Leg), Rules.as_vpi(&2, Term, p7096), _ => None{}, +item7105 => ((+local7099 => ((+scrut7100 = local7099
Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, OptionOf(Term.Leg), scrut7100, +p7101 => +p7102 => +p7103 => (Rules.one_of(&2, Term.Leg, p7097))))))(item7105))), _ => None{}, +item7119 => ((+local7107 => ((+local7110 => (Match.Maybe(&2, TupleOf2(Quantity, String), &2, OptionOf(TupleOf2(Shape<&2, Term>, Term.Leg)), local7110, _ => None{}, +item7117 => (Some{(+local7112 => ((+scrut7113 = local7112
Match.Tuple2(&2, Quantity, &2, String, &2, TupleOf2(Shape<&2, Term>, Term.Leg), scrut7113, +p7114 => +p7115 => (Tup2{p7096, local7107})))))(item7117)}))))(Rules.one_of(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(local7107)))))(item7119))))), +p7121 => +p7122 => +p7123 => (None{}), +p7124 => +p7125 => +p7126 => +p7127 => (None{}), +p7128 => +p7129 => (None{}), +p7130 => (None{}), +p7131 => (None{}), _ => (None{})))
@unsafe
def Order.peel(+n_708: Big, +t_709: Term) -> TupleOf2(Big, Term):
  (+local7134 => (Match.Maybe(&2, TupleOf2(Shape<&2, Term>, Term.Leg), &2, TupleOf2(Big, Term), local7134, _ => (Tup2{n_708, t_709}), +value => ((+local7136 => ((+scrut7137 = local7136
  Match.Tuple2(&2, Shape<&2, Term>, &2, Term.Leg, &2, TupleOf2(Big, Term), scrut7137, +p7138 => +p7139 => (Order.peel(NativeInt.add(n_708, Big.one()), Get.Term.Leg.l_body(p7139)))))))(value)))))(Order.as_lam(t_709))
@unsafe
def Order.mentions(+group_739: ListOf(String), +t_740: Term) -> Bool:
  Term.exists_name(False{}, group_739, t_740)
@unsafe
def Order.status_at(+st_743: ListOf(Order.Status), +ix_744: Big) -> OptionOf(Order.Status):
  Rules.at(&2, Order.Status, ix_744, st_743)
@unsafe
def Order.ok_both(+a_747: OptionOf(ListOf(Order.Call)), +b_748: OptionOf(ListOf(Order.Call))) -> OptionOf(ListOf(Order.Call)):
  Match.Maybe(&2, ListOf(Order.Call), &2, OptionOf(ListOf(Order.Call)), a_747, _ => None{}, +item7281 => ((+local7275 => (Match.Maybe(&2, ListOf(Order.Call), &2, OptionOf(ListOf(Order.Call)), b_748, _ => None{}, +item7279 => (Some{(+local7277 => (List.append(&2, Order.Call, local7275, local7277)))(item7279)}))))(item7281)))
@unsafe
def Order.ok_all(+xs_753: ListOf(OptionOf(ListOf(Order.Call)))) -> OptionOf(ListOf(Order.Call)):
  SeqList.fold(&2, &2, OptionOf(ListOf(Order.Call)), OptionOf(ListOf(Order.Call)), Order.ok_both, xs_753, Some{Nil{}})
@unsafe
def Local.Order.shape_ok.f7231(+group_769: ListOf(String), +guarded_call_783: Reusable(ListOf(Order.Status), Reusable(ListOf(Term), Bool)), +principal_or_smaller_at_778: Reusable(ListOf(Order.Status), Reusable(Big, Bool)), +st_817: ListOf(Order.Status), +chain_818: ListOf(Order.Step), +s_819: Shape<&2, Term>) -> OptionOf(ListOf(Order.Call)):
  Order.ok_all(SeqList.map(&2, &2, Term, OptionOf(ListOf(Order.Call)), (+local7264 => ((+local7269 => +local7271 => +local7273 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7269, local7271, local7273)))(st_817, chain_818, local7264))), Shape.payload(&2, Term, s_819)))
@unsafe
def Order.under_point(+s_763: Shape<&2, Term>, +st_764: ListOf(Order.Status)) -> ListOf(Order.Status):
  (+local7284 => (Match.Maybe(&2, Term, &2, ListOf(Order.Status), local7284, _ => (st_764), +value => ((+local7286 => (Con{Order.Status.Other{}, st_764}))(value)))))(Shape.point_dom(&2, Term, s_763))
@unsafe
def Local.Order.addr_ok.f7232(+group_769: ListOf(String), +guarded_call_783: Reusable(ListOf(Order.Status), Reusable(ListOf(Term), Bool)), +principal_or_smaller_at_778: Reusable(ListOf(Order.Status), Reusable(Big, Bool)), +st_820: ListOf(Order.Status), +chain_821: ListOf(Order.Step), +a_822: Term.Addr) -> OptionOf(ListOf(Order.Call)):
  (+local7339 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, OptionOf(ListOf(Order.Call)), local7339, _ => (Some{Nil{}}), +value => ((+local7341 => ((+scrut7342 = local7341
  Match.Tuple2(&2, Quantity, &2, Term, &2, OptionOf(ListOf(Order.Call)), scrut7342, +p7343 => +p7344 => ((+local7349 => +local7351 => +local7353 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7349, local7351, local7353)))(st_820, chain_821, p7344))))))(value)))))(Term.as_apt(a_822))
@unsafe
def Order.as_var(+t_687: Term) -> OptionOf(Big):
  (+scrut7376 = t_687
  Match.Term(&2, OptionOf(Big), scrut7376, +p7377 => (Some{p7377}), +p7378 => (None{}), +p7379 => +p7380 => (None{}), +p7381 => +p7382 => (None{}), +p7383 => +p7384 => +p7385 => (None{}), +p7386 => (None{}), +p7387 => +p7388 => (None{}), +p7389 => +p7390 => +p7391 => (None{}), +p7392 => +p7393 => +p7394 => +p7395 => (None{}), +p7396 => +p7397 => (None{}), +p7398 => (None{}), +p7399 => (None{}), _ => (None{})))
@unsafe
def Order.under(+s_756: Order.Status, +bs_757: ListOf(TupleOf2(Quantity, String)), +st_758: ListOf(Order.Status)) -> ListOf(Order.Status):
  SeqList.fold(&2, &2, TupleOf2(Quantity, String), ListOf(Order.Status), (+local7452 => +local7454 => (Con{s_756, local7452})), bs_757, st_758)
@unsafe
def Local.Order.elim_ok.f7235(+group_769: ListOf(String), +guarded_call_783: Reusable(ListOf(Order.Status), Reusable(ListOf(Term), Bool)), +principal_or_smaller_at_778: Reusable(ListOf(Order.Status), Reusable(Big, Bool)), +st_840: ListOf(Order.Status), +chain_841: ListOf(Order.Step), +e_842: Term.Elim) -> OptionOf(ListOf(Order.Call)):
  (+scrut7400 = {Order.as_var(Get.Term.Elim.e_scrut(e_842)) : OptionOf(Big)}
  ((+scrut7406 = {(+local7403 => (Match.Maybe(&2, Big, &2, Bool, local7403, _ => (False{}), +value => ((+local7405 => (principal_or_smaller_at_778(st_840, local7405)))(value)))))(scrut7400) : Bool}
(+scrut7407 = {Native.choose(&2, Order.Status, scrut7406, _ => (Order.Status.Smaller{}), _ => (Order.Status.Other{})) : Order.Status}
(+scrut7416 = {(+local7409 => ((+local7412 => (Match.Maybe(&2, Big, &2, ListOf(Order.Step), local7412, _ => (chain_841), +value => ((+local7414 => ((+scrut7415 = {Unit{} : Unit}
Native.choose(&2, ListOf(Order.Step), scrut7406, _ => (Con{MkOrder_Step{local7414, Term.as_actor(local7409)}, chain_841}), _ => (chain_841)))))(value)))))(scrut7400))) : Reusable(Term.Addr, ListOf(Order.Step))}
((+scrut7436 = {(+local7419 => (Match.Maybe(&2, Term.Motive, &2, OptionOf(ListOf(Order.Call)), local7419, _ => (Some{Nil{}}), +value => ((+local7421 => ((+scrut7426 = {SeqList.fold(&2, &2, String, ListOf(Order.Status), (+local7423 => +local7425 => (Con{Order.Status.Other{}, local7423})), Get.Term.Motive.m_idx(local7421), Con{Order.Status.Other{}, st_840}) : ListOf(Order.Status)}
(+local7431 => +local7433 => +local7435 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7431, local7433, local7435)))(scrut7426, chain_841, Get.Term.Motive.m_body(local7421)))))(value)))))(Get.Term.Elim.e_motive(e_842)) : OptionOf(ListOf(Order.Call))}
((+scrut7464 = {(+local7438 => ((+scrut7439 = local7438
Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, OptionOf(ListOf(Order.Call)), scrut7439, +p7440 => +p7441 => (Order.ok_all(Con{(+local7446 => +local7448 => +local7450 => (Local.Order.addr_ok.f7232(group_769, guarded_call_783, principal_or_smaller_at_778, local7446, local7448, local7450)))(st_840, chain_841, p7440), Con{(+local7459 => +local7461 => +local7463 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7459, local7461, local7463)))(Order.under(scrut7407, Get.Term.Leg.l_binders(p7441), st_840), scrut7416(p7440), Get.Term.Leg.l_body(p7441)), Nil{}}})))))) : Reusable(TupleOf2(Term.Addr, Term.Leg), OptionOf(ListOf(Order.Call)))}
Order.ok_all(Con{(+local7469 => +local7471 => +local7473 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7469, local7471, local7473)))(st_840, chain_841, Get.Term.Elim.e_scrut(e_842)), Con{(+local7478 => +local7480 => +local7482 => (Local.Order.shape_ok.f7231(group_769, guarded_call_783, principal_or_smaller_at_778, local7478, local7480, local7482)))(st_840, chain_841, Get.Term.Elim.e_shape(e_842)), Con{scrut7436, SeqList.map(&2, &2, TupleOf2(Term.Addr, Term.Leg), OptionOf(ListOf(Order.Call)), scrut7464, Get.Term.Elim.e_branches(e_842))}}}))))))))))
@unsafe
def Local.Order.leg_ok.f7233(+group_769: ListOf(String), +guarded_call_783: Reusable(ListOf(Order.Status), Reusable(ListOf(Term), Bool)), +principal_or_smaller_at_778: Reusable(ListOf(Order.Status), Reusable(Big, Bool)), +st_826: ListOf(Order.Status), +chain_827: ListOf(Order.Step), +lg_828: Term.Leg) -> OptionOf(ListOf(Order.Call)):
  (+local7513 => +local7515 => +local7517 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7513, local7515, local7517)))(Order.under(Order.Status.Other{}, Get.Term.Leg.l_binders(lg_828), st_826), chain_827, Get.Term.Leg.l_body(lg_828))
@unsafe
def Order.spine(+t_728: Term, +args_729: ListOf(Term), +shapes_730: ListOf(Shape<&2, Term>)) -> TupleOf3(Term, ListOf(Term), ListOf(Shape<&2, Term>)):
  (+scrut7530 = t_728
  Match.Term(&2, TupleOf3(Term, ListOf(Term), ListOf(Shape<&2, Term>)), scrut7530, +p7531 => (Tup3{t_728, args_729, shapes_730}), +p7532 => (Tup3{t_728, args_729, shapes_730}), +p7533 => +p7534 => (Tup3{t_728, args_729, shapes_730}), +p7535 => +p7536 => (Tup3{t_728, args_729, shapes_730}), +p7537 => +p7538 => +p7539 => (Tup3{t_728, args_729, shapes_730}), +p7540 => (Tup3{t_728, args_729, shapes_730}), +p7541 => +p7542 => (Tup3{t_728, args_729, shapes_730}), +p7543 => +p7544 => +p7545 => ((+local7548 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, TupleOf3(Term, ListOf(Term), ListOf(Shape<&2, Term>)), local7548, _ => (Tup3{t_728, args_729, shapes_730}), +value => ((+local7550 => ((+scrut7551 = local7550
  Match.Tuple2(&2, Quantity, &2, Term, &2, TupleOf3(Term, ListOf(Term), ListOf(Shape<&2, Term>)), scrut7551, +p7552 => +p7553 => (Order.spine(p7545, Con{p7553, args_729}, Con{p7543, shapes_730}))))))(value)))))(Term.as_apt(p7544))), +p7554 => +p7555 => +p7556 => +p7557 => (Tup3{t_728, args_729, shapes_730}), +p7558 => +p7559 => (Tup3{t_728, args_729, shapes_730}), +p7560 => (Tup3{t_728, args_729, shapes_730}), +p7561 => (Tup3{t_728, args_729, shapes_730}), _ => (Tup3{t_728, args_729, shapes_730})))
@unsafe
def Order.member(+group_334: ListOf(String), +n_335: String) -> Bool:
  SeqList.exists(&2, String, (+local7682 => (NativeString.equal(n_335, local7682))), group_334)
@unsafe
def Local.Order.spine_ok.f7234(+group_769: ListOf(String), +guarded_call_783: Reusable(ListOf(Order.Status), Reusable(ListOf(Term), Bool)), +principal_or_smaller_at_778: Reusable(ListOf(Order.Status), Reusable(Big, Bool)), +st_829: ListOf(Order.Status), +chain_830: ListOf(Order.Step), +t_831: Term) -> OptionOf(ListOf(Order.Call)):
  (+scrut7562 = {Order.spine(t_831, Nil{}, Nil{}) : TupleOf3(Term, ListOf(Term), ListOf(Shape<&2, Term>))}
  Match.Tuple3(&2, Term, &2, ListOf(Term), &2, ListOf(Shape<&2, Term>), &2, OptionOf(ListOf(Order.Call)), scrut7562, +p7563 => +p7564 => +p7565 => (((+scrut7684 = {(+scrut7566 = p7563
Match.Term(&2, OptionOf(ListOf(Order.Call)), scrut7566, +p7567 => (Some{Nil{}}), +p7568 => (Some{Nil{}}), +p7569 => +p7570 => ((+local7575 => +local7577 => +local7579 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7575, local7577, local7579)))(st_829, chain_830, p7563)), +p7580 => +p7581 => ((+local7586 => +local7588 => +local7590 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7586, local7588, local7590)))(st_829, chain_830, p7563)), +p7591 => +p7592 => +p7593 => ((+local7598 => +local7600 => +local7602 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7598, local7600, local7602)))(st_829, chain_830, p7563)), +p7603 => ((+local7608 => +local7610 => +local7612 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7608, local7610, local7612)))(st_829, chain_830, p7563)), +p7613 => +p7614 => ((+local7619 => +local7621 => +local7623 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7619, local7621, local7623)))(st_829, chain_830, p7563)), +p7624 => +p7625 => +p7626 => (Order.ok_all(Con{(+local7631 => +local7633 => +local7635 => (Local.Order.shape_ok.f7231(group_769, guarded_call_783, principal_or_smaller_at_778, local7631, local7633, local7635)))(st_829, chain_830, p7624), Con{(+local7640 => +local7642 => +local7644 => (Local.Order.addr_ok.f7232(group_769, guarded_call_783, principal_or_smaller_at_778, local7640, local7642, local7644)))(st_829, chain_830, p7625), Con{(+local7649 => +local7651 => +local7653 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7649, local7651, local7653)))(st_829, chain_830, p7626), Nil{}}}})), +p7654 => +p7655 => +p7656 => +p7657 => ((+local7662 => +local7664 => +local7666 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7662, local7664, local7666)))(st_829, chain_830, p7563)), +p7667 => +p7668 => ((+local7673 => +local7675 => +local7677 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7673, local7675, local7677)))(st_829, chain_830, p7563)), +p7678 => ((+scrut7679 = {Unit{} : Unit}
Native.choose(&2, OptionOf(ListOf(Order.Call)), Big.when(Bool, Order.member(group_769, p7678), _ => (guarded_call_783(st_829, p7564)), _ => (False{})), _ => (Some{Con{MkOrder_Call{p7678, chain_830}, Nil{}}}), _ => (Native.choose(&2, OptionOf(ListOf(Order.Call)), Order.member(group_769, p7678), _ => (None{}), _ => (Some{Nil{}})))))), +p7683 => (Some{Nil{}}), _ => (Some{Nil{}}))) : OptionOf(ListOf(Order.Call))}
Order.ok_all(Con{scrut7684, List.append(&2, OptionOf(ListOf(Order.Call)), SeqList.map(&2, &2, Shape<&2, Term>, OptionOf(ListOf(Order.Call)), (+local7687 => ((+local7692 => +local7694 => +local7696 => (Local.Order.shape_ok.f7231(group_769, guarded_call_783, principal_or_smaller_at_778, local7692, local7694, local7696)))(st_829, chain_830, local7687))), p7565), SeqList.map(&2, &2, Term, OptionOf(ListOf(Order.Call)), (+local7699 => ((+local7704 => +local7706 => +local7708 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7704, local7706, local7708)))(st_829, chain_830, local7699))), p7564))}))))))
@unsafe
def Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, st_795, chain_796, t_797):
  (+scrut7248 = t_797
  Match.Term(&2, OptionOf(ListOf(Order.Call)), scrut7248, +p7249 => (Some{Nil{}}), +p7250 => (Some{Nil{}}), +p7251 => +p7252 => (Order.ok_all(Con{(+local7257 => +local7259 => +local7261 => (Local.Order.shape_ok.f7231(group_769, guarded_call_783, principal_or_smaller_at_778, local7257, local7259, local7261)))(st_795, chain_796, p7251), Con{(+local7291 => +local7293 => +local7295 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7291, local7293, local7295)))(Order.under_point(p7251, st_795), chain_796, p7252), Nil{}}})), +p7296 => +p7297 => (Order.ok_all(Con{(+local7302 => +local7304 => +local7306 => (Local.Order.shape_ok.f7231(group_769, guarded_call_783, principal_or_smaller_at_778, local7302, local7304, local7306)))(st_795, chain_796, p7296), Con{(+local7311 => +local7313 => +local7315 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7311, local7313, local7315)))(Order.under_point(p7296, st_795), chain_796, p7297), Nil{}}})), +p7316 => +p7317 => +p7318 => (Order.ok_all(Con{(+local7323 => +local7325 => +local7327 => (Local.Order.shape_ok.f7231(group_769, guarded_call_783, principal_or_smaller_at_778, local7323, local7325, local7327)))(st_795, chain_796, p7316), Con{(+local7332 => +local7334 => +local7336 => (Local.Order.addr_ok.f7232(group_769, guarded_call_783, principal_or_smaller_at_778, local7332, local7334, local7336)))(st_795, chain_796, p7317), SeqList.map(&2, &2, Term, OptionOf(ListOf(Order.Call)), (+local7356 => ((+local7361 => +local7363 => +local7365 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7361, local7363, local7365)))(st_795, chain_796, local7356))), p7318)}})), +p7366 => ((+local7371 => +local7373 => +local7375 => (Local.Order.elim_ok.f7235(group_769, guarded_call_783, principal_or_smaller_at_778, local7371, local7373, local7375)))(st_795, chain_796, p7366)), +p7486 => +p7487 => (Order.ok_all(Con{(+local7492 => +local7494 => +local7496 => (Local.Order.shape_ok.f7231(group_769, guarded_call_783, principal_or_smaller_at_778, local7492, local7494, local7496)))(st_795, chain_796, p7486), SeqList.map(&2, &2, Term.Leg, OptionOf(ListOf(Order.Call)), (+local7499 => ((+local7504 => +local7506 => +local7508 => (Local.Order.leg_ok.f7233(group_769, guarded_call_783, principal_or_smaller_at_778, local7504, local7506, local7508)))(st_795, chain_796, local7499))), p7487)})), +p7518 => +p7519 => +p7520 => ((+local7525 => +local7527 => +local7529 => (Local.Order.spine_ok.f7234(group_769, guarded_call_783, principal_or_smaller_at_778, local7525, local7527, local7529)))(st_795, chain_796, t_797)), +p7710 => +p7711 => +p7712 => +p7713 => (Order.ok_all(Con{(+local7718 => +local7720 => +local7722 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7718, local7720, local7722)))(st_795, chain_796, p7711), Con{(+local7727 => +local7729 => +local7731 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7727, local7729, local7731)))(st_795, chain_796, p7712), Con{(+local7736 => +local7738 => +local7740 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7736, local7738, local7740)))(Con{Order.Status.Other{}, st_795}, chain_796, p7713), Nil{}}}})), +p7741 => +p7742 => (Order.ok_all(Con{(+local7747 => +local7749 => +local7751 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7747, local7749, local7751)))(st_795, chain_796, p7741), Con{(+local7756 => +local7758 => +local7760 => (Local.Order.ok.f7230(group_769, guarded_call_783, principal_or_smaller_at_778, local7756, local7758, local7760)))(st_795, chain_796, p7742), Nil{}}})), +p7761 => (Native.choose(&2, OptionOf(ListOf(Order.Call)), Order.member(group_769, p7761), _ => (None{}), _ => (Some{Nil{}}))), +p7762 => (Some{Nil{}}), _ => (Some{Nil{}})))
@unsafe
def Order.passes(+rule_768: Order.Rule, +group_769: ListOf(String), +k_770: Big, +formals_771: Big, +body_772: Term) -> OptionOf(ListOf(Order.Call)):
  (+scrut7183 = {(+local7174 => +local7176 => ((+local7179 => (Match.Maybe(&2, Order.Status, &2, Bool, local7179, _ => (False{}), +value => ((+local7181 => ((+scrut7182 = local7181
  Match.Order_Status(&2, Bool, scrut7182, _ => (False{}), _ => (True{}), _ => (False{})))))(value)))))(Order.status_at(local7174, local7176)))) : Reusable(ListOf(Order.Status), Reusable(Big, Bool))}
  (+scrut7194 = {(+local7185 => +local7187 => ((+local7190 => (Match.Maybe(&2, Order.Status, &2, Bool, local7190, _ => (False{}), +value => ((+local7192 => ((+scrut7193 = local7192
  Match.Order_Status(&2, Bool, scrut7193, _ => (True{}), _ => (True{}), _ => (False{})))))(value)))))(Order.status_at(local7185, local7187)))) : Reusable(ListOf(Order.Status), Reusable(Big, Bool))}
  ((+scrut7229 = {(+local7196 => +local7198 => ((+local7201 => (Match.Maybe(&2, Term, &2, Bool, local7201, _ => (False{}), +value => ((+local7203 => ((+scrut7204 = local7203
Match.Term(&2, Bool, scrut7204, +p7205 => (scrut7183(local7196, p7205)), +p7206 => (False{}), +p7207 => +p7208 => (False{}), +p7209 => +p7210 => (False{}), +p7211 => +p7212 => +p7213 => (False{}), +p7214 => (False{}), +p7215 => +p7216 => (False{}), +p7217 => +p7218 => +p7219 => ((+scrut7220 = rule_768
Match.Order_Rule(&2, Bool, scrut7220, _ => (False{})))), +p7221 => +p7222 => +p7223 => +p7224 => (False{}), +p7225 => +p7226 => (False{}), +p7227 => (False{}), +p7228 => (False{}), _ => (False{})))))(value)))))(Rules.at(&2, Term, k_770, local7198)))) : Reusable(ListOf(Order.Status), Reusable(ListOf(Term), Bool))}
(+scrut7238 = {SeqList.init(&2, Order.Status, formals_771, (+local7237 => (Native.choose(&2, Order.Status, Big.is_eq(local7237, NativeInt.sub(NativeInt.sub(formals_771, Big.one()), k_770)), _ => (Order.Status.Principal{}), _ => (Order.Status.Other{}))))) : ListOf(Order.Status)}
(+local7243 => +local7245 => +local7247 => (Local.Order.ok.f7230(group_769, scrut7229, scrut7194, local7243, local7245, local7247)))(scrut7238, Nil{}, body_772))))))
@unsafe
def Order.refusal(+members_896: ListOf(TupleOf2(String, Term))) -> Error:
  (+local7797 => (Error.Termination{local7797}))((+local7795 => (Maybe.default(&2, String, local7795, "")))(SeqList.fold(&2, &2, TupleOf2(String, Term), OptionOf(String), (+local7784 => +local7786 => ((+scrut7787 = local7786
  Match.Tuple2(&2, String, &2, Term, &2, OptionOf(String), scrut7787, +p7788 => +p7789 => (Match.Maybe(&2, String, &2, OptionOf(String), local7784, _ => (Some{p7788}), +value => ((+local7792 => (Some{local7792}))(value)))))))), members_896, None{})))
@unsafe
def Local.Order.first_fit.f7774(+bound_921: Big, +members_913: ListOf(TupleOf2(String, Term)), +group_914: ListOf(String), +rows_at_928: Reusable(Big, OptionOf(ListOf(Order.Row))), +k_939: Big) -> CheckResult(Order):
  (+scrut7782 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Order), Big.is_le(bound_921, k_939), _ => (Fail{Order.refusal(members_913)}), _ => ((+local7817 => (local7817(Unit{})))((+local7800 => ((+local7804 => +local7806 => (Match.Maybe(&2, ListOf(Order.Row), &1, Reusable(Unit, CheckResult(Order)), local7804, _ => ((+local7808 => ((+local7811 => (Local.Order.first_fit.f7774(bound_921, members_913, group_914, rows_at_928, local7811)))(NativeInt.add(k_939, Big.one()))))), +value => ((+local7813 => +local7815 => (Done{MkOrder{group_914, k_939, local7813}}))(value)))(local7806)))(rows_at_928(k_939), local7800)))))))
@unsafe
def Order.certify(+_opt__947: OptionOf(Order.Rule), +members_913: ListOf(TupleOf2(String, Term))) -> CheckResult(OptionOf(Order)):
  (+scrut7075 = {(+scrut7073 = _opt__947
  Match.Maybe(&2, Order.Rule, &2, Order.Rule, scrut7073, _ => (Order.Rule.Structural{}), +p7074 => (p7074))) : Order.Rule}
  (+scrut7079 = {SeqList.map(&2, &2, TupleOf2(String, Term), String, (+local7078 => (Get.Tuple2.v0(&2, String, &2, Term, local7078))), members_913) : ListOf(String)}
  ((+scrut7143 = {SeqList.map(&2, &2, TupleOf2(String, Term), TupleOf3(String, Big, Term), (+local7081 => ((+scrut7082 = local7081
Match.Tuple2(&2, String, &2, Term, &2, TupleOf3(String, Big, Term), scrut7082, +p7083 => +p7084 => ((+scrut7140 = {Order.peel(Big.zero(), p7084) : TupleOf2(Big, Term)}
Match.Tuple2(&2, Big, &2, Term, &2, TupleOf3(String, Big, Term), scrut7140, +p7141 => +p7142 => (Tup3{p7083, p7141, p7142})))))))), members_913) : ListOf(TupleOf3(String, Big, Term))}
(+scrut7160 = {(+local7159 => (Maybe.default(&2, Big, local7159, Big.zero())))(SeqList.fold(&2, &2, TupleOf3(String, Big, Term), OptionOf(Big), (+local7145 => +local7147 => ((+scrut7148 = local7147
Match.Tuple3(&2, String, &2, Big, &2, Term, &2, OptionOf(Big), scrut7148, +p7149 => +p7150 => +p7151 => (Native.choose(&2, OptionOf(Big), Bool.not(Order.mentions(scrut7079, p7151)), _ => (local7145), _ => ((+local7154 => (Match.Maybe(&2, Big, &2, OptionOf(Big), local7154, _ => (Some{p7150}), +value => ((+local7156 => (Some{Big.when(Big, Big.is_lt(local7156, p7150), _ => local7156, _ => p7150)}))(value)))))(local7145)))))))), scrut7143, None{})) : Big}
((+scrut7773 = {(+local7162 => (SeqList.fold(&2, &2, TupleOf3(String, Big, Term), OptionOf(ListOf(Order.Row)), (+local7164 => +local7166 => ((+scrut7167 = local7166
Match.Tuple3(&2, String, &2, Big, &2, Term, &2, OptionOf(ListOf(Order.Row)), scrut7167, +p7168 => +p7169 => +p7170 => (Match.Maybe(&2, ListOf(Order.Row), &2, OptionOf(ListOf(Order.Row)), local7164, _ => None{}, +item7772 => ((+local7172 => ((+local7766 => (Match.Maybe(&2, ListOf(Order.Call), &2, OptionOf(ListOf(Order.Row)), local7766, _ => None{}, +item7770 => (Some{(+local7768 => (List.append(&2, Order.Row, local7172, Con{MkOrder_Row{p7168, local7768}, Nil{}})))(item7770)}))))(Order.passes(scrut7075, scrut7079, local7162, p7169, p7170))))(item7772)))))))), scrut7143, Some{Nil{}}))) : Reusable(Big, OptionOf(ListOf(Order.Row)))}
(+scrut7775 = {Unit{} : Unit}
Native.choose(&2, CheckResult(OptionOf(Order)), SeqList.exists(&2, TupleOf2(String, Term), (+local7821 => ((+scrut7822 = local7821
Match.Tuple2(&2, String, &2, Term, &2, Bool, scrut7822, +p7823 => +p7824 => (Order.mentions(scrut7079, p7824)))))), members_913), _ => (Match.Result(&2, Order, &2, Error, &2, CheckResult(OptionOf(Order)), (+local7781 => (Local.Order.first_fit.f7774(scrut7160, members_913, scrut7079, scrut7773, local7781)))(Big.zero()), +item7818 => (Done{(+local7778 => (Some{local7778}))(item7818)}), +item7819 => Fail{item7819})), _ => (Done{None{}}))))))))))
@unsafe
def Totality.budget_msg() -> String:
  "the totality budget is exhausted"
@unsafe
def Totality.spend_shape(+budget_520: Budget, +s_521: Shape<&2, Term>) -> CheckResult(Unit):
  (+local7852 => (Match.Result(&2, Shape<&2, Term>, &2, Error, &2, CheckResult(Unit), local7852, +item7855 => (Done{(+local7854 => (Unit{}))(item7855)}), +item7856 => Fail{item7856})))(Rules.map_shape(&2, Term, &2, Term, (+local7844 => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(Term), Totality.spend(budget_520, local7844), +item7848 => (Done{(+local7846 => ((+scrut7847 = local7846
  local7844)))(item7848)}), +item7849 => Fail{item7849}))), s_521))
@unsafe
def Totality.spend_addr(+budget_644: Budget, +a_645: Term.Addr) -> CheckResult(Unit):
  (+local7870 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, CheckResult(Unit), local7870, _ => (Done{Unit{}}), +value => ((+local7872 => ((+scrut7873 = local7872
  Match.Tuple2(&2, Quantity, &2, Term, &2, CheckResult(Unit), scrut7873, +p7874 => +p7875 => (Totality.spend(budget_644, p7875))))))(value)))))(Term.as_apt(a_645))
@unsafe
def Totality.spend_branches(+budget_669: Budget, +brs_670: ListOf(TupleOf2(Term.Addr, Term.Leg))) -> CheckResult(Unit):
  SeqList.fold(&2, &2, TupleOf2(Term.Addr, Term.Leg), CheckResult(Unit), (+local7884 => +local7886 => ((+scrut7887 = local7886
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(Unit), scrut7887, +p7888 => +p7889 => ((do CheckResult<Unit>:
    +bound7891 : Unit <- local7884
    +bound7893 : Unit <- Totality.spend_addr(budget_669, p7888)
    Totality.spend(budget_669, Get.Term.Leg.l_body(p7889)))))))), brs_670, Done{Unit{}})
@unsafe
def Totality.spend_motive(+budget_666: Budget, +mo_667: OptionOf(Term.Motive)) -> CheckResult(Unit):
  (+local7896 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(Unit), local7896, _ => (Done{Unit{}}), +value => ((+local7898 => (Totality.spend(budget_666, Get.Term.Motive.m_body(local7898))))(value)))))(mo_667)
@unsafe
def Totality.spend_node(+budget_367: Budget, +t_368: Term) -> CheckResult(Unit):
  (+scrut7836 = t_368
  Match.Term(&2, CheckResult(Unit), scrut7836, +p7837 => (Done{Unit{}}), +p7838 => (Done{Unit{}}), +p7839 => +p7840 => ((do CheckResult<Unit>:
    +bound7842 : Unit <- Totality.spend_shape(budget_367, p7839)
    Totality.spend(budget_367, p7840))), +p7857 => +p7858 => ((do CheckResult<Unit>:
    +bound7860 : Unit <- Totality.spend_shape(budget_367, p7857)
    Totality.spend(budget_367, p7858))), +p7861 => +p7862 => +p7863 => ((do CheckResult<Unit>:
    +bound7865 : Unit <- Totality.spend_shape(budget_367, p7861)
    +bound7867 : Unit <- Totality.spend_addr(budget_367, p7862)
    Totality.spend_all(budget_367, p7863))), +p7876 => ((do CheckResult<Unit>:
    +bound7878 : Unit <- Totality.spend_shape(budget_367, Get.Term.Elim.e_shape(p7876))
    +bound7880 : Unit <- Totality.spend(budget_367, Get.Term.Elim.e_scrut(p7876))
    +bound7882 : Unit <- Totality.spend_motive(budget_367, Get.Term.Elim.e_motive(p7876))
    Totality.spend_branches(budget_367, Get.Term.Elim.e_branches(p7876)))), +p7899 => +p7900 => ((do CheckResult<Unit>:
    +bound7902 : Unit <- Totality.spend_shape(budget_367, p7899)
    Totality.spend_all(budget_367, SeqList.map(&2, &2, Term.Leg, Term, (+local7904 => (Get.Term.Leg.l_body(local7904))), p7900)))), +p7905 => +p7906 => +p7907 => ((do CheckResult<Unit>:
    +bound7909 : Unit <- Totality.spend_shape(budget_367, p7905)
    +bound7911 : Unit <- Totality.spend_addr(budget_367, p7906)
    Totality.spend(budget_367, p7907))), +p7912 => +p7913 => +p7914 => +p7915 => ((do CheckResult<Unit>:
    +bound7917 : Unit <- Totality.spend(budget_367, p7913)
    +bound7919 : Unit <- Totality.spend(budget_367, p7914)
    Totality.spend(budget_367, p7915))), +p7920 => +p7921 => ((do CheckResult<Unit>:
    +bound7923 : Unit <- Totality.spend(budget_367, p7920)
    Totality.spend(budget_367, p7921))), +p7924 => (Done{Unit{}}), +p7925 => (Done{Unit{}}), _ => (Done{Unit{}})))
@unsafe
def Totality.spend(budget_346, t_347):
  Native.choose(&2, CheckResult(Unit), Budget.exhausted(budget_346), _ => (Fail{Error.Budget_exhausted{Totality.budget_msg()}}), _ => (Totality.spend_node(budget_346, t_347)))
@unsafe
def Totality.spend_all(budget_677, ts_678):
  SeqList.fold(&2, &2, Term, CheckResult(Unit), (+local7831 => +local7833 => ((do CheckResult<Unit>:
    +bound7835 : Unit <- local7831
    Totality.spend(budget_677, local7833)))), ts_678, Done{Unit{}})
@unsafe
def Totality.guard_group(+_opt__757: Maybe<&1, Budget>, +globals_705: Global, +members_706: ListOf(TupleOf2(String, Term))) -> CheckResult(OptionOf(Order)):
  (+scrut7068 = {(+scrut7066 = _opt__757
  Match.Maybe(&1, Budget, &1, Budget, scrut7066, _ => (Budget.unlimited()), +p7067 => (p7067))) : Budget}
  (+scrut7069 = globals_705
  (do CheckResult<OptionOf(Order)>:
    +bound7071 : Unit <- Totality.spend_all(scrut7068, SeqList.map(&2, &2, TupleOf2(String, Term), Term, (+local7829 => (Get.Tuple2.v1(&2, String, &2, Term, local7829))), members_706))
    Order.certify(None{}, members_706))))
@unsafe
def Order.unwrap(+acc_714: ListOf(TupleOf2(Shape<&2, Term>, Term.Leg)), +t_715: Term) -> TupleOf2(ListOf(TupleOf2(Shape<&2, Term>, Term.Leg)), Term):
  (+local7957 => (Match.Maybe(&2, TupleOf2(Shape<&2, Term>, Term.Leg), &2, TupleOf2(ListOf(TupleOf2(Shape<&2, Term>, Term.Leg)), Term), local7957, _ => (Tup2{List.reverse(&2, TupleOf2(Shape<&2, Term>, Term.Leg), acc_714), t_715}), +value => ((+local7959 => ((+scrut7960 = local7959
  Match.Tuple2(&2, Shape<&2, Term>, &2, Term.Leg, &2, TupleOf2(ListOf(TupleOf2(Shape<&2, Term>, Term.Leg)), Term), scrut7960, +p7961 => +p7962 => (Order.unwrap(Con{Tup2{p7961, p7962}, acc_714}, Get.Term.Leg.l_body(p7962)))))))(value)))))(Order.as_lam(t_715))
@unsafe
def Order.rewrap(+ws_721: ListOf(TupleOf2(Shape<&2, Term>, Term.Leg)), +inner_722: Term) -> Term:
  SeqList.fold(&2, &2, TupleOf2(Shape<&2, Term>, Term.Leg), Term, (+local7980 => +local7982 => ((+scrut7983 = local7982
  Match.Tuple2(&2, Shape<&2, Term>, &2, Term.Leg, &2, Term, scrut7983, +p7984 => +p7985 => (Term.Sec{p7984, Con{MkTerm_LegOf{Get.Term.Leg.l_binders(p7985), local7980}, Nil{}}}))))), List.reverse(&2, TupleOf2(Shape<&2, Term>, Term.Leg), ws_721), inner_722)
@unsafe
def Order.ctor_key_msg() -> String:
  "every branch of the elimination of a structurally recursive definition keys a constructor"
@unsafe
def Order.motive_msg() -> String:
  "the elimination of a structurally recursive definition carries its motive"
@unsafe
def Order.one_elim_msg() -> String:
  "a structurally recursive definition eliminates its recursive argument at the head of its body"
@unsafe
def Order.as_elim(+t_683: Term) -> OptionOf(Term.Elim):
  (+scrut8031 = t_683
  Match.Term(&2, OptionOf(Term.Elim), scrut8031, +p8032 => (None{}), +p8033 => (None{}), +p8034 => +p8035 => (None{}), +p8036 => +p8037 => (None{}), +p8038 => +p8039 => +p8040 => (None{}), +p8041 => (Some{p8041}), +p8042 => +p8043 => (None{}), +p8044 => +p8045 => +p8046 => (None{}), +p8047 => +p8048 => +p8049 => +p8050 => (None{}), +p8051 => +p8052 => (None{}), +p8053 => (None{}), +p8054 => (None{}), _ => (None{})))
@unsafe
def Order.translate_recursive(+cert_955: Order, +body_956: Term) -> CheckResult(Term):
  (+scrut7963 = {Order.unwrap(Nil{}, body_956) : TupleOf2(ListOf(TupleOf2(Shape<&2, Term>, Term.Leg)), Term)}
  Match.Tuple2(&2, ListOf(TupleOf2(Shape<&2, Term>, Term.Leg)), &2, Term, &2, CheckResult(Term), scrut7963, +p7964 => +p7965 => (((+scrut7966 = {Big.of_nat(List.length(&2, TupleOf2(Shape<&2, Term>, Term.Leg), p7964)) : Big}
(do CheckResult<Term>:
  +bound7968 : Term.Elim <- (+local8057 => (Match.Maybe(&2, Term.Elim, &2, CheckResult(Term.Elim), local8057, _ => Fail{Error.Mismatch{Order.one_elim_msg()}}, +x => Done{x})))(Order.as_elim(p7965))
  +bound7970 : Big <- (+local8030 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local8030, _ => Fail{Error.Mismatch{Order.one_elim_msg()}}, +x => Done{x})))(Order.as_var(Get.Term.Elim.e_scrut(bound7968)))
  +bound7972 : Unit <- (+scrut8027 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(Unit), Big.is_eq(bound7970, NativeInt.sub(NativeInt.sub(scrut7966, Big.one()), Get.Order.o_arg(cert_955))), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{Order.one_elim_msg()}})))
  ((do CheckResult<Term>:
  +bound7974 : Term.Motive <- (+local8025 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(Term.Motive), local8025, _ => Fail{Error.Missing_branch{Order.motive_msg()}}, +x => Done{x})))(Get.Term.Elim.e_motive(bound7968))
  +bound7976 : Unit <- SeqList.fold(&2, &2, TupleOf2(Term.Addr, Term.Leg), CheckResult(Unit), (+local8010 => +local8012 => ((+scrut8013 = local8012
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(Unit), scrut8013, +p8014 => +p8015 => ((do CheckResult<Unit>:
    +bound8017 : Unit <- local8010
    (+local8020 => (Match.Maybe(&2, String, &2, CheckResult(Unit), local8020, _ => (Fail{Error.Wrong_leg{Order.ctor_key_msg()}}), +value => ((+local8022 => (Done{Unit{}}))(value)))))(Term.as_actor(p8014)))))))), Get.Term.Elim.e_branches(bound7968), Done{Unit{}})
  ((do CheckResult<Term>:
  +bound7978 : Unit <- SeqList.fold(&2, &2, Order.Row, CheckResult(Unit), (+local7987 => +local7989 => ((do CheckResult<Unit>:
    +bound7991 : Unit <- local7987
    SeqList.fold(&2, &2, Order.Call, CheckResult(Unit), (+local7993 => +local7995 => ((do CheckResult<Unit>:
      +bound7997 : Unit <- local7993
      (+local8000 => (Match.Maybe(&2, Order.Step, &2, CheckResult(Unit), local8000, _ => (Fail{Error.Termination{Get.Order.Row.rw_member(local7989)}}), +value => ((+local8002 => ((+local8005 => (Match.Maybe(&2, String, &2, CheckResult(Unit), local8005, _ => (Fail{Error.Termination{Get.Order.Row.rw_member(local7989)}}), +value => ((+local8007 => (Done{Unit{}}))(value)))))(Get.Order.Step.st_ctor(local8002))))(value)))))(Rules.at(&2, Order.Step, Big.zero(), Get.Order.Call.cl_chain(local7995)))))), Get.Order.Row.rw_calls(local7989), Done{Unit{}})))), Get.Order.o_rows(cert_955), Done{Unit{}})
  Done{Order.rewrap(p7964, Term.Elim{bound7968})}))))))))))
@unsafe
def Order.translate(+cert_953: Order, +body_954: Term) -> CheckResult(Term):
  Native.choose(&2, CheckResult(Term), Bool.not(Order.mentions(Get.Order.o_group(cert_953), body_954)), _ => (Done{body_954}), _ => (Order.translate_recursive(cert_953, body_954)))
@unsafe
def Check.check_term(+_opt__1569: Maybe<&1, Budget>, +globals_1566: Global, +t_1567: Term, +ty_1568: Value) -> CheckResult(Unit):
  (+scrut8065 = {(+scrut8063 = _opt__1569
  Match.Maybe(&1, Budget, &1, Budget, scrut8063, _ => (Budget.unlimited()), +p8064 => (p8064))) : Budget}
  Check.check(Check.make(globals_1566, scrut8065), Quantity.Many{}, t_1567, ty_1568))
@unsafe
def Global.find_def(+name_794: String, +globals_795: Global) -> OptionOf(Global.Def_entry):
  Match.Maybe(&2, Global.Entry, &2, OptionOf(Global.Def_entry), Global.find(name_794, globals_795), _ => None{}, +item8490 => (Global.def_of(item8490)))
@unsafe
def Global.axiom_of(+e_786: Global.Entry) -> OptionOf(Global.Axiom_entry):
  (+scrut8651 = e_786
  Match.Global_Entry(&2, OptionOf(Global.Axiom_entry), scrut8651, +p8652 => (None{}), +p8653 => (Some{p8653}), +p8654 => (None{})))
@unsafe
def Term.formers() -> ListOf(String):
  Con{"Lan", Con{"Ran", Nil{}}}
@unsafe
def Term.schema() -> ListOf(String):
  Con{"In", Con{"Elim", Con{"Sec", Con{"Out", Nil{}}}}}
@unsafe
def Shape.declared() -> ListOf(String):
  Con{"SPi", Con{"SColl", Con{"SPar", Con{"SMu", Con{"SNu", Nil{}}}}}}
@unsafe
def Shape.name(-q0: Quant, -A0: Kind(q0), +s_372: Shape<q0, A0>) -> String:
  (+scrut15923 = s_372
  Match.Shape(q0, A0, &2, String, scrut15923, +p15924 => +p15925 => +p15926 => ("SPi"), +p15927 => ("SColl"), +p15928 => +p15929 => ("SPar"), +p15930 => +p15931 => ("SMu"), +p15932 => +p15933 => ("SNu")))
@unsafe
def Rules.samples() -> ListOf(Shape<&2, Term>):
  Con{Shape.SPi{Quantity.Many{}, "x", Term.Univ{Level.zero()}}, Con{Shape.SColl{Big.zero()}, Con{Shape.SPar{Term.Univ{Level.zero()}, Term.Univ{Level.zero()}}, Con{Shape.SMu{"x", Nil{}}, Con{Shape.SNu{"x", Nil{}}, Nil{}}}}}}
@unsafe
def Rules.packs() -> List<&1, Tuple2<&2, &1, String, Rules.Rule_pack<&2, Unit>>>:
  SeqList.filter_map(&2, &1, Shape<&2, Term>, Tuple2<&2, &1, String, Rules.Rule_pack<&2, Unit>>, (+local15917 => ((+local15920 => (Match.Maybe(&1, Rules.Rule_pack<&2, Unit>, &1, Maybe<&1, Tuple2<&2, &1, String, Rules.Rule_pack<&2, Unit>>>, local15920, _ => None{}, +item15935 => (Some{(+local15922 => (Tup2{Shape.name(&2, Term, local15917), local15922}))(item15935)}))))(Match.Result(&1, Rules.Rule_pack<&2, Unit>, &2, Error, &1, Maybe<&1, Rules.Rule_pack<&2, Unit>>, Rules.rules(&2, Term, &2, Unit, local15917), +x => Some{x}, _ => None{})))), Rules.samples())
@unsafe
def Rules.admitted() -> ListOf(String):
  SeqList.map(&1, &2, Tuple2<&2, &1, String, Rules.Rule_pack<&2, Unit>>, String, (+local15915 => (Get.Tuple2.v0(&2, String, &1, Rules.Rule_pack<&2, Unit>, local15915))), Rules.packs())
@unsafe
def Rules.named_declared() -> ListOf(String):
  Con{"proof-irrelevance", Con{"subsingleton-large-elimination", Con{"literal-fast-path", Nil{}}}}
@unsafe
def Rules.named_present() -> ListOf(String):
  Con{"proof-irrelevance", Con{"subsingleton-large-elimination", Con{"literal-fast-path", Nil{}}}}
@unsafe
def Rules.eta_table() -> ListOf(TupleOf2(String, Rules.Eta_row)):
  SeqList.map(&1, &2, Tuple2<&2, &1, String, Rules.Rule_pack<&2, Unit>>, TupleOf2(String, Rules.Eta_row), (+local15953 => ((+scrut15954 = local15953
  Match.Tuple2(&2, String, &1, Rules.Rule_pack<&2, Unit>, &2, TupleOf2(String, Rules.Eta_row), scrut15954, +p15955 => +p15956 => (Tup2{p15955, Get.Rules.Rule_pack.eta(&2, Unit, p15956)}))))), Rules.packs())
