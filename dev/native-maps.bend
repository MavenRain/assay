def MapTest.compare(+a: Nat, +b: Nat) -> Cmp: Nat.cmp(a, b)
@unsafe
def MapTest.fill(keys: List<&2, Nat>, map: Assoc<&2, Nat, Nat>) -> Assoc<&2, Nat, Nat>:
  match keys:
    case Nil{}: map
    case Con{+key, rest}: MapTest.fill(rest, Assoc.add(&2, Nat, Nat, MapTest.compare, key, (key * 3n: Nat), map))
@unsafe
def MapTest.rows(rows: List<&2, Tuple2<&2, &2, Nat, Nat>>) -> String:
  match rows:
    case Nil{}: ""
    case Con{Tup2{key, value}, rest}: String.append(Nat.show(key), String.append(":", String.append(Nat.show(value), String.append(",", MapTest.rows(rest)))))
@unsafe
def MapTest.lookups(keys: List<&2, Nat>, +map: Assoc<&2, Nat, Nat>) -> String:
  match keys:
    case Nil{}: ""
    case Con{key, rest}: String.append(MapTest.lookup(Assoc.find(&2, Nat, Nat, MapTest.compare, key, map)), MapTest.lookups(rest, map))
def MapTest.lookup(value: Maybe<&2, Nat>) -> String:
  match value:
    case None{}: "none,"
    case Some{value}: String.append(Nat.show(value), ",")
def MapTest.combine(left: Maybe<&2, Nat>, right: Maybe<&2, Nat>) -> Maybe<&2, Nat>:
  match left right:
    case None{} None{}: None{}
    case Some{a} None{}: Some{a}
    case None{} Some{b}: Some{b}
    case Some{a} Some{b}: Some{(a + b: Nat)}
@unsafe
def MapTest.print(+keys: List<&2, Nat>, +map: Assoc<&2, Nat, Nat>) -> IO(Unit):
  NativeIO.print(String.append(Nat.show(Assoc.height(&2, Nat, Nat, map)), String.append("|", String.append(MapTest.rows(Assoc.rows(&2, Nat, Nat, map)), String.append("|", MapTest.lookups(keys, map))))))
@unsafe
def MapTest.run(+keys: List<&2, Nat>) -> IO(Unit):
  +initial = MapTest.fill(keys, Assoc.empty(&2, Nat, Nat))
  +changed = Assoc.add(&2, Nat, Nat, MapTest.compare, 7n, 999n, initial)
  +removed = Assoc.remove(&2, Nat, Nat, MapTest.compare, 8n, changed)
  +mapped = Assoc.map(&2, &2, Nat, Nat, Nat, +n => (n + 5n: Nat), removed)
  +merged = Assoc.merge(&2, &2, &2, Nat, Nat, Nat, Nat, MapTest.compare, +key => +a => +b => MapTest.combine(a, b), mapped, MapTest.fill([3n, 7n, 12n, 1000n], Assoc.empty(&2, Nat, Nat)))
  do IO<Unit>:
    MapTest.print(keys, initial)
    MapTest.print(keys, changed)
    MapTest.print(keys, removed)
    MapTest.print(keys, mapped)
    MapTest.print(keys, merged)
    return Unit{}
