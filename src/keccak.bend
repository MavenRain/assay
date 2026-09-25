# Native Bend source, compiled by dev/build.py.
type K.Index is Data: K.I0{} K.I1{} K.I2{} K.I3{} K.I4{}
type K.Five<-A: Data> is Data: K.Five{a: A, b: A, c: A, d: A, e: A}
type K.Lane is Data: K.Lane{hi: U32, lo: U32}
def K.State() -> Data: K.Five<K.Five<K.Lane>>
def K.next(i: K.Index) -> K.Index:
  match i:
    case K.I0{}: K.I1{}
    case K.I1{}: K.I2{}
    case K.I2{}: K.I3{}
    case K.I3{}: K.I4{}
    case K.I4{}: K.I0{}
def K.prev(i: K.Index) -> K.Index:
  match i:
    case K.I0{}: K.I4{}
    case K.I1{}: K.I0{}
    case K.I2{}: K.I1{}
    case K.I3{}: K.I2{}
    case K.I4{}: K.I3{}
def K.number(i: K.Index) -> U32:
  match i:
    case K.I0{}: 0
    case K.I1{}: 1
    case K.I2{}: 2
    case K.I3{}: 3
    case K.I4{}: 4
def K.get(-A: Data, row: K.Five<A>, i: K.Index) -> A:
  match row i:
    case K.Five{a, _, _, _, _} K.I0{}: a
    case K.Five{_, b, _, _, _} K.I1{}: b
    case K.Five{_, _, c, _, _} K.I2{}: c
    case K.Five{_, _, _, d, _} K.I3{}: d
    case K.Five{_, _, _, _, e} K.I4{}: e
def K.tab(~E: Data, ~f: E -> K.Index -> K.Lane, +env: E) -> K.Five<K.Lane>:
  K.Five{f(env, K.I0{}), f(env, K.I1{}), f(env, K.I2{}), f(env, K.I3{}), f(env, K.I4{})}
def K.row(~E: Data, ~f: E -> K.Index -> K.Index -> K.Lane, +env: E, +y: K.Index) -> K.Five<K.Lane>:
  K.Five{f(env, K.I0{}, y), f(env, K.I1{}, y), f(env, K.I2{}, y), f(env, K.I3{}, y), f(env, K.I4{}, y)}
def K.grid(~E: Data, ~f: E -> K.Index -> K.Index -> K.Lane, +env: E) -> K.State:
  K.Five{K.row(~E, ~f, env, K.I0{}), K.row(~E, ~f, env, K.I1{}), K.row(~E, ~f, env, K.I2{}), K.row(~E, ~f, env, K.I3{}), K.row(~E, ~f, env, K.I4{})}
def K.at(-A: Data, matrix: K.Five<K.Five<A>>, x: K.Index, y: K.Index) -> A:
  K.get(A, K.get(K.Five<A>, matrix, y), x)
def K.xor(a: K.Lane, b: K.Lane) -> K.Lane:
  match a b:
    case K.Lane{ah, al} K.Lane{bh, bl}: K.Lane{(ah .^. bh : U32), (al .^. bl : U32)}
def K.and_not(a: K.Lane, b: K.Lane) -> K.Lane:
  match a b:
    case K.Lane{ah, al} K.Lane{bh, bl}: K.Lane{((ah .^. 4294967295) .&. bh : U32), ((al .^. 4294967295) .&. bl : U32)}
def K.rot_small(+hi: U32, +lo: U32, +n: Nat) -> K.Lane:
  K.Lane{((hi << n) .|. (lo >> (32n - n : Nat)) : U32), ((lo << n) .|. (hi >> (32n - n : Nat)) : U32)}
def K.rot(+n: Nat, lane: K.Lane) -> K.Lane:
  match n lane:
    case 0n w: w
    case 32n K.Lane{hi, lo}: K.Lane{lo, hi}
    case p K.Lane{+hi, +lo}: Bool.pick(K.Lane, Nat.is_lt(p, 32n), K.rot_small(hi, lo, p), K.rot_small(lo, hi, (p - 32n : Nat)))
def K.zero() -> K.State: K.grid(~Unit, ~(_ => _ => _ => K.Lane{0, 0}), Unit{})
def K.offsets() -> K.Five<K.Five<Nat>>:
  K.Five{K.Five{0n, 1n, 62n, 28n, 27n}, K.Five{36n, 44n, 6n, 55n, 20n}, K.Five{3n, 10n, 43n, 25n, 39n}, K.Five{41n, 45n, 15n, 21n, 8n}, K.Five{18n, 2n, 61n, 56n, 14n}}
def K.constants() -> List<&2, K.Lane>:
  [K.Lane{0, 1},
   K.Lane{0, 32898},
   K.Lane{2147483648, 32906},
   K.Lane{2147483648, 2147516416},
   K.Lane{0, 32907},
   K.Lane{0, 2147483649},
   K.Lane{2147483648, 2147516545},
   K.Lane{2147483648, 32777},
   K.Lane{0, 138},
   K.Lane{0, 136},
   K.Lane{0, 2147516425},
   K.Lane{0, 2147483658},
   K.Lane{0, 2147516555},
   K.Lane{2147483648, 139},
   K.Lane{2147483648, 32905},
   K.Lane{2147483648, 32771},
   K.Lane{2147483648, 32770},
   K.Lane{2147483648, 128},
   K.Lane{0, 32778},
   K.Lane{2147483648, 2147483658},
   K.Lane{2147483648, 2147516545},
   K.Lane{2147483648, 32896},
   K.Lane{0, 2147483649},
   K.Lane{2147483648, 2147516424}]
def K.column(+state: K.State, +x: K.Index) -> K.Lane:
  K.xor(K.at(K.Lane, state, x, K.I0{}), K.xor(K.at(K.Lane, state, x, K.I1{}), K.xor(K.at(K.Lane, state, x, K.I2{}), K.xor(K.at(K.Lane, state, x, K.I3{}), K.at(K.Lane, state, x, K.I4{})))))
def K.delta(+columns: K.Five<K.Lane>, +x: K.Index) -> K.Lane:
  K.xor(K.get(K.Lane, columns, K.prev(x)), K.rot(1n, K.get(K.Lane, columns, K.next(x))))
def K.times3(i: K.Index) -> K.Index:
  match i:
    case K.I0{}: K.I0{}
    case K.I1{}: K.I3{}
    case K.I2{}: K.I1{}
    case K.I3{}: K.I4{}
    case K.I4{}: K.I2{}
def K.add(x: K.Index, y: K.Index) -> K.Index:
  match y:
    case K.I0{}: x
    case K.I1{}: K.next(x)
    case K.I2{}: K.next(K.next(x))
    case K.I3{}: K.prev(K.prev(x))
    case K.I4{}: K.prev(x)
def K.pi(theta: K.State, +x: K.Index, y: K.Index) -> K.Lane:
  +sx = K.add(x, K.times3(y))
  K.rot(K.at(Nat, K.offsets(), sx, x), K.at(K.Lane, theta, sx, x))
def K.chi(+state: K.State, +x: K.Index, +y: K.Index) -> K.Lane:
  K.xor(K.at(K.Lane, state, x, y), K.and_not(K.at(K.Lane, state, K.next(x), y), K.at(K.Lane, state, K.next(K.next(x)), y)))
type K.Theta is Data: K.Theta{state: K.State, columns: K.Five<K.Lane>}
def K.theta(env: K.Theta, +x: K.Index, y: K.Index) -> K.Lane:
  match env:
    case K.Theta{state, columns}: K.xor(K.at(K.Lane, state, x, y), K.delta(columns, x))
type K.Iota is Data: K.Iota{state: K.State, rc: K.Lane}
def K.iota(env: K.Iota, x: K.Index, y: K.Index) -> K.Lane:
  match env x y:
    case K.Iota{state, rc} K.I0{} K.I0{}: K.xor(K.at(K.Lane, state, K.I0{}, K.I0{}), rc)
    case K.Iota{state, _} p q: K.at(K.Lane, state, p, q)
def K.round(+state: K.State, +rc: K.Lane) -> K.State:
  columns = K.tab(~K.State, ~(e => x => K.column(e, x)), state)
  theta = K.grid(~K.Theta, ~(e => x => y => K.theta(e, x, y)), K.Theta{state, columns})
  pi = K.grid(~K.State, ~(e => x => y => K.pi(e, x, y)), theta)
  chi = K.grid(~K.State, ~(e => x => y => K.chi(e, x, y)), pi)
  K.grid(~K.Iota, ~(e => x => y => K.iota(e, x, y)), K.Iota{chi, rc})
def K.permute(constants: List<&2, K.Lane>, state: K.State) -> K.State:
  match constants:
    case Nil{}: state
    case Con{rc, rest}: K.permute(rest, K.round(state, rc))
def K.byte(+byte: U32, +shift: Nat) -> K.Lane:
  Bool.pick(K.Lane, Nat.is_lt(shift, 32n), K.Lane{0, (byte << shift : U32)}, K.Lane{(byte << (shift - 32n : Nat) : U32), 0})
type K.Absorb is Data: K.Absorb{state: K.State, lane: K.Lane, x: K.Index, y: K.Index}
def K.absorb_lane(env: K.Absorb, +i: K.Index, +j: K.Index) -> K.Lane:
  match env:
    case K.Absorb{+state, lane, x, y}: Bool.pick(K.Lane, (U32.is_eq(K.number(x), K.number(i)) && U32.is_eq(K.number(y), K.number(j))), K.xor(K.at(K.Lane, state, i, j), lane), K.at(K.Lane, state, i, j))
def K.absorb(bytes: List<&2, U32>, +state: K.State, +x: K.Index, +y: K.Index, +shift: Nat) -> K.State:
  match bytes:
    case Nil{}: K.permute(K.constants(), state)
    case Con{byte, rest}:
      lane = K.byte(byte, shift)
      next = K.grid(~K.Absorb, ~(e => i => j => K.absorb_lane(e, i, j)), K.Absorb{state, lane, x, y})
      +full = Nat.is_eq(shift, 56n)
      K.absorb(rest, next, Bool.pick(K.Index, full, K.next(x), x), Bool.pick(K.Index, (full && U32.is_eq(K.number(x), 4)), K.next(y), y), Bool.pick(Nat, full, 0n, (shift + 8n : Nat)))
type K.Block is Data: K.Block{bytes: List<&2, U32>, count: Nat, rest: String}
def K.take(left: Nat, count: Nat, acc: List<&2, U32>, input: String) -> K.Block:
  match left input:
    case 0n text: K.Block{List.reverse(&2, U32, acc), count, text}
    case 1n+p "": K.Block{List.reverse(&2, U32, acc), count, ""}
    case 1n+p SCon{c, rest}: K.take(p, (count + 1n : Nat), Char.to_u32(c) <> acc, rest)
def K.padding(left: Nat, first: Bool) -> List<&2, U32>:
  match left:
    case 0n: Nil{}
    case 1n+ +p: (Bool.pick(U32, first, 1, 0) .|. Bool.pick(U32, Nat.is_eq(p, 0n), 128, 0) : U32) <> K.padding(p, False{})
law K.sponge: for input: String for state: K.State K.State
@unsafe
def K.block(block: K.Block, state: K.State) -> K.State:
  match block:
    case K.Block{bytes, 136n, rest}: K.sponge(rest, K.absorb(bytes, state, K.I0{}, K.I0{}, 0n))
    case K.Block{bytes, count, _}: K.absorb(List.append(&2, U32, bytes, K.padding((136n - count : Nat), True{})), state, K.I0{}, K.I0{}, 0n)
@unsafe
def K.sponge(input, state): K.block(K.take(136n, 0n, Nil{}, input), state)
def K.hex_digit(+value: U32) -> Char:
  Char.from_u32(Bool.pick(U32, U32.is_lt(value, 10), (48 + value : U32), (87 + value : U32)))
def K.hex_word(left: Nat, +word: U32) -> String:
  match left:
    case 0n: ""
    case 1n+p: SCon{K.hex_digit(((word >> 4n) .&. 15 : U32)), SCon{K.hex_digit((word .&. 15 : U32)), K.hex_word(p, (word >> 8n : U32))}}
def K.lane_hex(lane: K.Lane) -> String:
  match lane:
    case K.Lane{hi, lo}: K.hex_word(4n, lo) ++ K.hex_word(4n, hi)
def K.digest(row: K.Five<K.Lane>) -> String:
  match row:
    case K.Five{a, b, c, d, _}: K.lane_hex(a) ++ K.lane_hex(b) ++ K.lane_hex(c) ++ K.lane_hex(d)
def Keccak.keccak256(input: String) -> String: K.digest(K.get(K.Five<K.Lane>, K.sponge(input, K.zero()), K.I0{}))
def K.prefix(left: Nat, text: String) -> String:
  match left text:
    case 0n _: ""
    case 1n+p "": ""
    case 1n+p SCon{c, rest}: SCon{c, K.prefix(p, rest)}
def Keccak.selector(signature: String) -> String: K.prefix(8n, Keccak.keccak256(signature))
type Keccak.Index is Data:
  Keccak.Index.I0{}
  Keccak.Index.I1{}
  Keccak.Index.I2{}
  Keccak.Index.I3{}
  Keccak.Index.I4{}
