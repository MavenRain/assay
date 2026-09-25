# Native Bend source, compiled by dev/build.py.
type One_paths.Expectation is Data:
  One_paths.Expectation.Accept{}
  One_paths.Expectation.Quantity_error{}
  One_paths.Expectation.Negative_literal{}
@unsafe
def TestNumber.digit(+c: Char) -> Nat:
  +n = Char.to_u32(NativeChar.lower(c))
  Native.choose(&2, Nat, Bool.and(U32.is_le(48, n), U32.is_le(n, 57)), _ => U32.to_nat((n - 48: U32)), _ => Native.choose(&2, Nat, Bool.and(U32.is_le(97, n), U32.is_le(n, 102)), _ => U32.to_nat((n - 87: U32)), _ => 16n))
@unsafe
def TestNumber.finish(negative: Bool, +value: Big) -> Maybe<&2, Big>: Some{Big.wrap(63n, Native.choose(&2, Big, negative, _ => Big.neg(value), _ => value))}
law TestNumber.digits: for +negative: Bool for +base: Nat for +limit: Big for +value: Big for +seen: Bool for text: String Maybe<&2, Big>
@unsafe
def TestNumber.next(+negative: Bool, +base: Nat, +limit: Big, +value: Big, +digit: Nat, rest: String) -> Maybe<&2, Big>:
  +next = Big.add(Big.mul(value, Big.of_nat(base)), Big.of_nat(digit))
  Native.choose(&2, Maybe<&2, Big>, Bool.and(Nat.is_lt(digit, base), Big.is_le(next, limit)), _ => TestNumber.digits(negative, base, limit, next, True{}, rest), _ => None{})
@unsafe
def TestNumber.digits(negative, base, limit, value, seen, text):
  match text:
    case SNil{}: Native.choose(&2, Maybe<&2, Big>, seen, _ => TestNumber.finish(negative, value), _ => None{})
    case SCon{'_', rest}: Native.choose(&2, Maybe<&2, Big>, seen, _ => TestNumber.digits(negative, base, limit, value, seen, rest), _ => None{})
    case SCon{c, rest}: TestNumber.next(negative, base, limit, value, TestNumber.digit(c), rest)
@unsafe
def TestNumber.base(negative: Bool, base: Nat, digits: String) -> Maybe<&2, Big>: TestNumber.digits(negative, base, Big.pred(Big.shift_left(Big.one(), 63n)), Big.zero(), False{}, digits)
@unsafe
def TestNumber.unsigned(+negative: Bool, +text: String) -> Maybe<&2, Big>:
  match text:
    case SCon{'0', SCon{'x', rest}}: TestNumber.base(negative, 16n, rest)
    case SCon{'0', SCon{'X', rest}}: TestNumber.base(negative, 16n, rest)
    case SCon{'0', SCon{'o', rest}}: TestNumber.base(negative, 8n, rest)
    case SCon{'0', SCon{'O', rest}}: TestNumber.base(negative, 8n, rest)
    case SCon{'0', SCon{'b', rest}}: TestNumber.base(negative, 2n, rest)
    case SCon{'0', SCon{'B', rest}}: TestNumber.base(negative, 2n, rest)
    case SCon{'0', SCon{'u', rest}}: TestNumber.base(negative, 10n, rest)
    case SCon{'0', SCon{'U', rest}}: TestNumber.base(negative, 10n, rest)
    case _: TestNumber.digits(negative, 10n, Native.choose(&2, Big, negative, _ => Big.shift_left(Big.one(), 62n), _ => Big.pred(Big.shift_left(Big.one(), 62n))), Big.zero(), False{}, text)
@unsafe
def TestNumber.read(+text: String) -> Maybe<&2, Big>:
  match text:
    case SCon{'-', rest}: TestNumber.unsigned(True{}, rest)
    case SCon{'+', rest}: TestNumber.unsigned(False{}, rest)
    case _: TestNumber.unsigned(False{}, text)
law Equal.ListOf_Syntax_Decl_: for +left: ListOf(Syntax.Decl) for +right: ListOf(Syntax.Decl) Bool
law Equal.Syntax_Decl: for +left: Syntax.Decl for +right: Syntax.Decl Bool
law Equal.Syntax: for +left: Syntax for +right: Syntax Bool
law Equal.Syntax_Prim: for +left: Syntax.Prim for +right: Syntax.Prim Bool
law Equal.ListOf_Syntax_: for +left: ListOf(Syntax) for +right: ListOf(Syntax) Bool
law Equal.ListOf_Syntax_Binder_: for +left: ListOf(Syntax.Binder) for +right: ListOf(Syntax.Binder) Bool
law Equal.Syntax_Binder: for +left: Syntax.Binder for +right: Syntax.Binder Bool
law Equal.ListOf_Syntax_Branch_: for +left: ListOf(Syntax.Branch) for +right: ListOf(Syntax.Branch) Bool
law Equal.Syntax_Branch: for +left: Syntax.Branch for +right: Syntax.Branch Bool
law Equal.ListOf_Syntax_Field_: for +left: ListOf(Syntax.Field) for +right: ListOf(Syntax.Field) Bool
law Equal.Syntax_Field: for +left: Syntax.Field for +right: Syntax.Field Bool
law Equal.OptionOf_Syntax_: for +left: OptionOf(Syntax) for +right: OptionOf(Syntax) Bool
law Equal.OptionOf_Syntax_Motive_: for +left: OptionOf(Syntax.Motive) for +right: OptionOf(Syntax.Motive) Bool
law Equal.Syntax_Motive: for +left: Syntax.Motive for +right: Syntax.Motive Bool
law Equal.ListOf_Syntax_Fam_: for +left: ListOf(Syntax.Fam) for +right: ListOf(Syntax.Fam) Bool
law Equal.Syntax_Fam: for +left: Syntax.Fam for +right: Syntax.Fam Bool
law Equal.ListOf_Syntax_Fam_ctor_: for +left: ListOf(Syntax.Fam_ctor) for +right: ListOf(Syntax.Fam_ctor) Bool
law Equal.Syntax_Fam_ctor: for +left: Syntax.Fam_ctor for +right: Syntax.Fam_ctor Bool
law Equal.ListOf_Syntax_Rec_def_: for +left: ListOf(Syntax.Rec_def) for +right: ListOf(Syntax.Rec_def) Bool
law Equal.Syntax_Rec_def: for +left: Syntax.Rec_def for +right: Syntax.Rec_def Bool
law Equal.Asm_Result_TupleOf3_String__ListOf_TupleOf2_String__Big____ListOf_Asm_Height___: for +left: Asm.Result(TupleOf3(String, ListOf(TupleOf2(String, Big)), ListOf(Asm.Height))) for +right: Asm.Result(TupleOf3(String, ListOf(TupleOf2(String, Big)), ListOf(Asm.Height))) Bool
law Equal.TupleOf3_String__ListOf_TupleOf2_String__Big____ListOf_Asm_Height__: for +left: TupleOf3(String, ListOf(TupleOf2(String, Big)), ListOf(Asm.Height)) for +right: TupleOf3(String, ListOf(TupleOf2(String, Big)), ListOf(Asm.Height)) Bool
law Equal.ListOf_Asm_Height_: for +left: ListOf(Asm.Height) for +right: ListOf(Asm.Height) Bool
law Equal.Asm_Height: for +left: Asm.Height for +right: Asm.Height Bool
law Equal.ListOf_TupleOf2_String__Big__: for +left: ListOf(TupleOf2(String, Big)) for +right: ListOf(TupleOf2(String, Big)) Bool
law Equal.TupleOf2_String__Big_: for +left: TupleOf2(String, Big) for +right: TupleOf2(String, Big) Bool
law Equal.Asm_Error: for +left: Asm.Error for +right: Asm.Error Bool
law Equal.ListOf_TupleOf3_Big__Big__Big__: for +left: ListOf(TupleOf3(Big, Big, Big)) for +right: ListOf(TupleOf3(Big, Big, Big)) Bool
law Equal.TupleOf3_Big__Big__Big_: for +left: TupleOf3(Big, Big, Big) for +right: TupleOf3(Big, Big, Big) Bool
law Equal.Emit_Result_Recognize_Value_: for +left: Emit.Result(Recognize.Value) for +right: Emit.Result(Recognize.Value) Bool
law Equal.Recognize_Value: for +left: Recognize.Value for +right: Recognize.Value Bool
law Equal.ListOf_Recognize_Value_: for +left: ListOf(Recognize.Value) for +right: ListOf(Recognize.Value) Bool
law Equal.Emit_Error: for +left: Emit.Error for +right: Emit.Error Bool
law Equal.Recognize_Error: for +left: Recognize.Error for +right: Recognize.Error Bool
law Equal.Emit_Result_TupleOf2_Recognize_Value__Big__: for +left: Emit.Result(TupleOf2(Recognize.Value, Big)) for +right: Emit.Result(TupleOf2(Recognize.Value, Big)) Bool
law Equal.TupleOf2_Recognize_Value__Big_: for +left: TupleOf2(Recognize.Value, Big) for +right: TupleOf2(Recognize.Value, Big) Bool
law Equal.Emit_Result_Emit_Effect_: for +left: Emit.Result(Emit.Effect) for +right: Emit.Result(Emit.Effect) Bool
law Equal.Emit_Effect: for +left: Emit.Effect for +right: Emit.Effect Bool
law Equal.ResultOf_Recognize_Error__Recognize_Value_: for +left: ResultOf(Recognize.Error, Recognize.Value) for +right: ResultOf(Recognize.Error, Recognize.Value) Bool
law Equal.ResultOf_Recognize_Error__Unit_: for +left: ResultOf(Recognize.Error, Unit) for +right: ResultOf(Recognize.Error, Unit) Bool
law Equal.Unit: for +left: Unit for +right: Unit Bool
law Equal.ResultOf_Recognize_Error__ListOf_String__: for +left: ResultOf(Recognize.Error, ListOf(String)) for +right: ResultOf(Recognize.Error, ListOf(String)) Bool
@unsafe
def Get.Global.Def_entry.partial(value: Global.Def_entry) -> Bool:
  match value:
    case MkGlobal_Def_entry{_, _, _, _, field4}: field4
@unsafe
def Equal.ListOf_Syntax_Decl_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left16347, +left16348} Con{+right16349, +right16350}: Bool.and(Equal.Syntax_Decl(left16347, right16349), Bool.and(Equal.ListOf_Syntax_Decl_(left16348, right16350), True{}))
    case _ _: False{}
@unsafe
def Equal.Syntax_Decl(left, right):
  match left right:
    case Syntax.Decl.DDef{+left16351, +left16352, +left16353} Syntax.Decl.DDef{+right16354, +right16355, +right16356}: Bool.and(NativeString.equal(left16351, right16354), Bool.and(Equal.Syntax(left16352, right16355), Bool.and(Equal.Syntax(left16353, right16356), True{})))
    case Syntax.Decl.DAxiom{+left16479, +left16480} Syntax.Decl.DAxiom{+right16481, +right16482}: Bool.and(NativeString.equal(left16479, right16481), Bool.and(Equal.Syntax(left16480, right16482), True{}))
    case Syntax.Decl.DMu{+left16483} Syntax.Decl.DMu{+right16484}: Bool.and(Equal.ListOf_Syntax_Fam_(left16483, right16484), True{})
    case Syntax.Decl.DRec{+left16505} Syntax.Decl.DRec{+right16506}: Bool.and(Equal.ListOf_Syntax_Rec_def_(left16505, right16506), True{})
    case _ _: False{}
@unsafe
def Equal.Syntax(left, right):
  match left right:
    case Syntax.SVar{+left16357} Syntax.SVar{+right16358}: Bool.and(NativeString.equal(left16357, right16358), True{})
    case Syntax.SNat{+left16359} Syntax.SNat{+right16360}: Bool.and(Big.is_eq(left16359, right16360), True{})
    case Syntax.SProp{} Syntax.SProp{}: True{}
    case Syntax.SType{+left16361} Syntax.SType{+right16362}: Bool.and(Big.is_eq(left16361, right16362), True{})
    case Syntax.SPrim{+left16363} Syntax.SPrim{+right16364}: Bool.and(Equal.Syntax_Prim(left16363, right16364), True{})
    case Syntax.SUnit{} Syntax.SUnit{}: True{}
    case Syntax.SAuto{} Syntax.SAuto{}: True{}
    case Syntax.SPair{+left16365, +left16366} Syntax.SPair{+right16367, +right16368}: Bool.and(Equal.Syntax(left16365, right16367), Bool.and(Equal.Syntax(left16366, right16368), True{}))
    case Syntax.STuple{+left16369} Syntax.STuple{+right16370}: Bool.and(Equal.ListOf_Syntax_(left16369, right16370), True{})
    case Syntax.SSum{+left16375} Syntax.SSum{+right16376}: Bool.and(Equal.ListOf_Syntax_(left16375, right16376), True{})
    case Syntax.SProd{+left16377} Syntax.SProd{+right16378}: Bool.and(Equal.ListOf_Syntax_(left16377, right16378), True{})
    case Syntax.SProj{+left16379, +left16380} Syntax.SProj{+right16381, +right16382}: Bool.and(Equal.Syntax(left16379, right16381), Bool.and(Big.is_eq(left16380, right16382), True{}))
    case Syntax.SInj{+left16383, +left16384, +left16385} Syntax.SInj{+right16386, +right16387, +right16388}: Bool.and(Big.is_eq(left16383, right16386), Bool.and(Big.is_eq(left16384, right16387), Bool.and(Equal.Syntax(left16385, right16388), True{})))
    case Syntax.SAbsurd{+left16389} Syntax.SAbsurd{+right16390}: Bool.and(Equal.Syntax(left16389, right16390), True{})
    case Syntax.SApp{+left16391, +left16392} Syntax.SApp{+right16393, +right16394}: Bool.and(Equal.Syntax(left16391, right16393), Bool.and(Equal.Syntax(left16392, right16394), True{}))
    case Syntax.SFun{+left16395, +left16396} Syntax.SFun{+right16397, +right16398}: Bool.and(Equal.ListOf_Syntax_Binder_(left16395, right16397), Bool.and(Equal.Syntax(left16396, right16398), True{}))
    case Syntax.SArrow{+left16409, +left16410} Syntax.SArrow{+right16411, +right16412}: Bool.and(Equal.Syntax_Binder(left16409, right16411), Bool.and(Equal.Syntax(left16410, right16412), True{}))
    case Syntax.SStar{+left16413, +left16414} Syntax.SStar{+right16415, +right16416}: Bool.and(Equal.Syntax_Binder(left16413, right16415), Bool.and(Equal.Syntax(left16414, right16416), True{}))
    case Syntax.SLet{+left16417, +left16418, +left16419, +left16420} Syntax.SLet{+right16421, +right16422, +right16423, +right16424}: Bool.and(NativeString.equal(left16417, right16421), Bool.and(Equal.Syntax(left16418, right16422), Bool.and(Equal.Syntax(left16419, right16423), Bool.and(Equal.Syntax(left16420, right16424), True{}))))
    case Syntax.SAnn{+left16425, +left16426} Syntax.SAnn{+right16427, +right16428}: Bool.and(Equal.Syntax(left16425, right16427), Bool.and(Equal.Syntax(left16426, right16428), True{}))
    case Syntax.SCase{+left16429, +left16430, +left16431} Syntax.SCase{+right16432, +right16433, +right16434}: Bool.and(Equal.Syntax(left16429, right16432), Bool.and(Equal.OptionOf_Syntax_Motive_(left16430, right16433), Bool.and(Equal.ListOf_Syntax_Branch_(left16431, right16434), True{})))
    case Syntax.SMatch{+left16473, +left16474, +left16475} Syntax.SMatch{+right16476, +right16477, +right16478}: Bool.and(Equal.Syntax(left16473, right16476), Bool.and(Equal.OptionOf_Syntax_Motive_(left16474, right16477), Bool.and(Equal.ListOf_Syntax_Branch_(left16475, right16478), True{})))
    case _ _: False{}
@unsafe
def Equal.Syntax_Prim(left, right):
  match left right:
    case Syntax.Prim.PAdd{} Syntax.Prim.PAdd{}: True{}
    case Syntax.Prim.PSub{} Syntax.Prim.PSub{}: True{}
    case Syntax.Prim.PMul{} Syntax.Prim.PMul{}: True{}
    case Syntax.Prim.PEq{} Syntax.Prim.PEq{}: True{}
    case Syntax.Prim.PLt{} Syntax.Prim.PLt{}: True{}
    case _ _: False{}
@unsafe
def Equal.ListOf_Syntax_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left16371, +left16372} Con{+right16373, +right16374}: Bool.and(Equal.Syntax(left16371, right16373), Bool.and(Equal.ListOf_Syntax_(left16372, right16374), True{}))
    case _ _: False{}
@unsafe
def Equal.ListOf_Syntax_Binder_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left16399, +left16400} Con{+right16401, +right16402}: Bool.and(Equal.Syntax_Binder(left16399, right16401), Bool.and(Equal.ListOf_Syntax_Binder_(left16400, right16402), True{}))
    case _ _: False{}
@unsafe
def Equal.Syntax_Binder(left, right):
  match left right:
    case MkSyntax_BinderOf{+left16403, +left16404, +left16405} MkSyntax_BinderOf{+right16406, +right16407, +right16408}: Bool.and(Equal.Quantity(left16403, right16406), Bool.and(NativeString.equal(left16404, right16407), Bool.and(Equal.Syntax(left16405, right16408), True{})))
@unsafe
def Equal.ListOf_Syntax_Branch_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left16435, +left16436} Con{+right16437, +right16438}: Bool.and(Equal.Syntax_Branch(left16435, right16437), Bool.and(Equal.ListOf_Syntax_Branch_(left16436, right16438), True{}))
    case _ _: False{}
@unsafe
def Equal.Syntax_Branch(left, right):
  match left right:
    case Syntax.BranchOf.BrLeg{+left16439, +left16440, +left16441} Syntax.BranchOf.BrLeg{+right16442, +right16443, +right16444}: Bool.and(Big.is_eq(left16439, right16442), Bool.and(Equal.ListOf_Syntax_Binder_(left16440, right16443), Bool.and(Equal.Syntax(left16441, right16444), True{})))
    case Syntax.BranchOf.BrCtor{+left16445, +left16446, +left16447} Syntax.BranchOf.BrCtor{+right16448, +right16449, +right16450}: Bool.and(NativeString.equal(left16445, right16448), Bool.and(Equal.ListOf_Syntax_Field_(left16446, right16449), Bool.and(Equal.Syntax(left16447, right16450), True{})))
    case _ _: False{}
@unsafe
def Equal.ListOf_Syntax_Field_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left16451, +left16452} Con{+right16453, +right16454}: Bool.and(Equal.Syntax_Field(left16451, right16453), Bool.and(Equal.ListOf_Syntax_Field_(left16452, right16454), True{}))
    case _ _: False{}
@unsafe
def Equal.Syntax_Field(left, right):
  match left right:
    case MkSyntax_FieldOf{+left16455, +left16456, +left16457} MkSyntax_FieldOf{+right16458, +right16459, +right16460}: Bool.and(Equal.Quantity(left16455, right16458), Bool.and(NativeString.equal(left16456, right16459), Bool.and(Equal.OptionOf_Syntax_(left16457, right16460), True{})))
@unsafe
def Equal.OptionOf_Syntax_(left, right):
  match left right:
    case None{} None{}: True{}
    case Some{+left16461} Some{+right16462}: Bool.and(Equal.Syntax(left16461, right16462), True{})
    case _ _: False{}
@unsafe
def Equal.OptionOf_Syntax_Motive_(left, right):
  match left right:
    case None{} None{}: True{}
    case Some{+left16463} Some{+right16464}: Bool.and(Equal.Syntax_Motive(left16463, right16464), True{})
    case _ _: False{}
@unsafe
def Equal.Syntax_Motive(left, right):
  match left right:
    case MkSyntax_MotiveOf{+left16465, +left16466, +left16467, +left16468} MkSyntax_MotiveOf{+right16469, +right16470, +right16471, +right16472}: Bool.and(NativeString.equal(left16465, right16469), Bool.and(Equal.OptionOf_String_(left16466, right16470), Bool.and(Equal.ListOf_String_(left16467, right16471), Bool.and(Equal.Syntax(left16468, right16472), True{}))))
@unsafe
def Equal.ListOf_Syntax_Fam_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left16485, +left16486} Con{+right16487, +right16488}: Bool.and(Equal.Syntax_Fam(left16485, right16487), Bool.and(Equal.ListOf_Syntax_Fam_(left16486, right16488), True{}))
    case _ _: False{}
@unsafe
def Equal.Syntax_Fam(left, right):
  match left right:
    case MkSyntax_Fam{+left16489, +left16490, +left16491, +left16492} MkSyntax_Fam{+right16493, +right16494, +right16495, +right16496}: Bool.and(NativeString.equal(left16489, right16493), Bool.and(Equal.ListOf_Syntax_Binder_(left16490, right16494), Bool.and(Equal.Syntax(left16491, right16495), Bool.and(Equal.ListOf_Syntax_Fam_ctor_(left16492, right16496), True{}))))
@unsafe
def Equal.ListOf_Syntax_Fam_ctor_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left16497, +left16498} Con{+right16499, +right16500}: Bool.and(Equal.Syntax_Fam_ctor(left16497, right16499), Bool.and(Equal.ListOf_Syntax_Fam_ctor_(left16498, right16500), True{}))
    case _ _: False{}
@unsafe
def Equal.Syntax_Fam_ctor(left, right):
  match left right:
    case MkSyntax_Fam_ctor{+left16501, +left16502} MkSyntax_Fam_ctor{+right16503, +right16504}: Bool.and(NativeString.equal(left16501, right16503), Bool.and(Equal.Syntax(left16502, right16504), True{}))
@unsafe
def Equal.ListOf_Syntax_Rec_def_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left16507, +left16508} Con{+right16509, +right16510}: Bool.and(Equal.Syntax_Rec_def(left16507, right16509), Bool.and(Equal.ListOf_Syntax_Rec_def_(left16508, right16510), True{}))
    case _ _: False{}
@unsafe
def Equal.Syntax_Rec_def(left, right):
  match left right:
    case MkSyntax_Rec_def{+left16511, +left16512, +left16513} MkSyntax_Rec_def{+right16514, +right16515, +right16516}: Bool.and(NativeString.equal(left16511, right16514), Bool.and(Equal.Syntax(left16512, right16515), Bool.and(Equal.Syntax(left16513, right16516), True{})))
@unsafe
def Match.Abi_Codec_Error(r, -R: Kind(r), value: Abi.Codec.Error, on0: (@+a0:Abi.Schema.Value_type -> R), on1: (Unit -> R), on2: (Unit -> R), on3: (Unit -> R), on4: (Unit -> R), on5: (Unit -> R), on6: (Unit -> R)) -> R:
  match value:
    case Abi.Codec.Error.Out_of_range{a0}: on0(a0)
    case Abi.Codec.Error.Too_large{}: on1(Unit{})
    case Abi.Codec.Error.Truncated{}: on2(Unit{})
    case Abi.Codec.Error.Invalid_bool{}: on3(Unit{})
    case Abi.Codec.Error.Invalid_offset{}: on4(Unit{})
    case Abi.Codec.Error.Nonzero_padding{}: on5(Unit{})
    case Abi.Codec.Error.Trailing_data{}: on6(Unit{})
@unsafe
def Equal.Asm_Result_TupleOf3_String__ListOf_TupleOf2_String__Big____ListOf_Asm_Height___(left, right):
  match left right:
    case Done{+left17000} Done{+right17001}: Bool.and(Equal.TupleOf3_String__ListOf_TupleOf2_String__Big____ListOf_Asm_Height__(left17000, right17001), True{})
    case Fail{+left17028} Fail{+right17029}: Bool.and(Equal.Asm_Error(left17028, right17029), True{})
    case _ _: False{}
@unsafe
def Equal.TupleOf3_String__ListOf_TupleOf2_String__Big____ListOf_Asm_Height__(left, right):
  match left right:
    case Tup3{+left17002, +left17003, +left17004} Tup3{+right17005, +right17006, +right17007}: Bool.and(NativeString.equal(left17002, right17005), Bool.and(Equal.ListOf_TupleOf2_String__Big__(left17003, right17006), Bool.and(Equal.ListOf_Asm_Height_(left17004, right17007), True{})))
@unsafe
def Equal.ListOf_Asm_Height_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left17008, +left17009} Con{+right17010, +right17011}: Bool.and(Equal.Asm_Height(left17008, right17010), Bool.and(Equal.ListOf_Asm_Height_(left17009, right17011), True{}))
    case _ _: False{}
@unsafe
def Equal.Asm_Height(left, right):
  match left right:
    case MkAsm_Height{+left17012, +left17013, +left17014, +left17015} MkAsm_Height{+right17016, +right17017, +right17018, +right17019}: Bool.and(NativeString.equal(left17012, right17016), Bool.and(Big.is_eq(left17013, right17017), Bool.and(Big.is_eq(left17014, right17018), Bool.and(Big.is_eq(left17015, right17019), True{}))))
@unsafe
def Equal.ListOf_TupleOf2_String__Big__(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left17020, +left17021} Con{+right17022, +right17023}: Bool.and(Equal.TupleOf2_String__Big_(left17020, right17022), Bool.and(Equal.ListOf_TupleOf2_String__Big__(left17021, right17023), True{}))
    case _ _: False{}
@unsafe
def Equal.TupleOf2_String__Big_(left, right):
  match left right:
    case Tup2{+left17024, +left17025} Tup2{+right17026, +right17027}: Bool.and(NativeString.equal(left17024, right17026), Bool.and(Big.is_eq(left17025, right17027), True{}))
@unsafe
def Equal.Asm_Error(left, right):
  match left right:
    case Asm.Error.Empty_program{} Asm.Error.Empty_program{}: True{}
    case Asm.Error.Empty_label{} Asm.Error.Empty_label{}: True{}
    case Asm.Error.Duplicate_label{+left17030} Asm.Error.Duplicate_label{+right17031}: Bool.and(NativeString.equal(left17030, right17031), True{})
    case Asm.Error.Unknown_opcode{+left17032} Asm.Error.Unknown_opcode{+right17033}: Bool.and(NativeString.equal(left17032, right17033), True{})
    case Asm.Error.Control_in_body{+left17034} Asm.Error.Control_in_body{+right17035}: Bool.and(NativeString.equal(left17034, right17035), True{})
    case Asm.Error.Invalid_push{+left17036} Asm.Error.Invalid_push{+right17037}: Bool.and(NativeString.equal(left17036, right17037), True{})
    case Asm.Error.Invalid_depth{+left17038, +left17039} Asm.Error.Invalid_depth{+right17040, +right17041}: Bool.and(NativeString.equal(left17038, right17040), Bool.and(Big.is_eq(left17039, right17041), True{}))
    case Asm.Error.Invalid_width{+left17042} Asm.Error.Invalid_width{+right17043}: Bool.and(Big.is_eq(left17042, right17043), True{})
    case Asm.Error.Invalid_height{+left17044, +left17045} Asm.Error.Invalid_height{+right17046, +right17047}: Bool.and(NativeString.equal(left17044, right17046), Bool.and(Big.is_eq(left17045, right17047), True{}))
    case Asm.Error.Entry_height{+left17048} Asm.Error.Entry_height{+right17049}: Bool.and(Big.is_eq(left17048, right17049), True{})
    case Asm.Error.Unknown_label{+left17050} Asm.Error.Unknown_label{+right17051}: Bool.and(NativeString.equal(left17050, right17051), True{})
    case Asm.Error.Not_destination{+left17052} Asm.Error.Not_destination{+right17053}: Bool.and(NativeString.equal(left17052, right17053), True{})
    case Asm.Error.Label_overflow{+left17054, +left17055} Asm.Error.Label_overflow{+right17056, +right17057}: Bool.and(NativeString.equal(left17054, right17056), Bool.and(Big.is_eq(left17055, right17057), True{}))
    case Asm.Error.Invalid_next{+left17058, +left17059} Asm.Error.Invalid_next{+right17060, +right17061}: Bool.and(NativeString.equal(left17058, right17060), Bool.and(NativeString.equal(left17059, right17061), True{}))
    case Asm.Error.Code_overflow{} Asm.Error.Code_overflow{}: True{}
    case Asm.Error.Underflow{+left17062, +left17063, +left17064, +left17065} Asm.Error.Underflow{+right17066, +right17067, +right17068, +right17069}: Bool.and(NativeString.equal(left17062, right17066), Bool.and(NativeString.equal(left17063, right17067), Bool.and(Big.is_eq(left17064, right17068), Bool.and(Big.is_eq(left17065, right17069), True{}))))
    case Asm.Error.Overflow{+left17070, +left17071, +left17072} Asm.Error.Overflow{+right17073, +right17074, +right17075}: Bool.and(NativeString.equal(left17070, right17073), Bool.and(NativeString.equal(left17071, right17074), Bool.and(Big.is_eq(left17072, right17075), True{})))
    case Asm.Error.Height_mismatch{+left17076, +left17077, +left17078, +left17079} Asm.Error.Height_mismatch{+right17080, +right17081, +right17082, +right17083}: Bool.and(NativeString.equal(left17076, right17080), Bool.and(NativeString.equal(left17077, right17081), Bool.and(Big.is_eq(left17078, right17082), Bool.and(Big.is_eq(left17079, right17083), True{}))))
    case _ _: False{}
@unsafe
def Get.Asm.Height.incoming(value: Asm.Height) -> Big:
  match value:
    case MkAsm_Height{_, field1, _, _}: field1
@unsafe
def Get.Asm.Height.outgoing(value: Asm.Height) -> Big:
  match value:
    case MkAsm_Height{_, _, field2, _}: field2
@unsafe
def Get.Asm.Height.peak(value: Asm.Height) -> Big:
  match value:
    case MkAsm_Height{_, _, _, field3}: field3
@unsafe
def Equal.ListOf_TupleOf3_Big__Big__Big__(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left17224, +left17225} Con{+right17226, +right17227}: Bool.and(Equal.TupleOf3_Big__Big__Big_(left17224, right17226), Bool.and(Equal.ListOf_TupleOf3_Big__Big__Big__(left17225, right17227), True{}))
    case _ _: False{}
@unsafe
def Equal.TupleOf3_Big__Big__Big_(left, right):
  match left right:
    case Tup3{+left17228, +left17229, +left17230} Tup3{+right17231, +right17232, +right17233}: Bool.and(Big.is_eq(left17228, right17231), Bool.and(Big.is_eq(left17229, right17232), Bool.and(Big.is_eq(left17230, right17233), True{})))
@unsafe
def Equal.Emit_Result_Recognize_Value_(left, right):
  match left right:
    case Done{+left17306} Done{+right17307}: Bool.and(Equal.Recognize_Value(left17306, right17307), True{})
    case Fail{+left17334} Fail{+right17335}: Bool.and(Equal.Emit_Error(left17334, right17335), True{})
    case _ _: False{}
@unsafe
def Equal.Recognize_Value(left, right):
  match left right:
    case Recognize.Value.Nat{+left17308} Recognize.Value.Nat{+right17309}: Bool.and(Big.is_eq(left17308, right17309), True{})
    case Recognize.Value.Word{+left17310} Recognize.Value.Word{+right17311}: Bool.and(Big.is_eq(left17310, right17311), True{})
    case Recognize.Value.Erased{} Recognize.Value.Erased{}: True{}
    case Recognize.Value.Runtime_word{+left17312} Recognize.Value.Runtime_word{+right17313}: Bool.and(Big.is_eq(left17312, right17313), True{})
    case Recognize.Value.Closure{+left17314, +left17315, +left17316} Recognize.Value.Closure{+right17317, +right17318, +right17319}: Bool.and(NativeString.equal(left17314, right17317), Bool.and(Big.is_eq(left17315, right17318), Bool.and(Equal.ListOf_Recognize_Value_(left17316, right17319), True{})))
    case Recognize.Value.Struct{+left17324, +left17325} Recognize.Value.Struct{+right17326, +right17327}: Bool.and(Equal.Eterm_Tid(left17324, right17326), Bool.and(Equal.ListOf_Recognize_Value_(left17325, right17327), True{}))
    case Recognize.Value.Tag{+left17328, +left17329, +left17330} Recognize.Value.Tag{+right17331, +right17332, +right17333}: Bool.and(Equal.Eterm_Tid(left17328, right17331), Bool.and(Big.is_eq(left17329, right17332), Bool.and(Equal.ListOf_Recognize_Value_(left17330, right17333), True{})))
    case _ _: False{}
@unsafe
def Equal.ListOf_Recognize_Value_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left17320, +left17321} Con{+right17322, +right17323}: Bool.and(Equal.Recognize_Value(left17320, right17322), Bool.and(Equal.ListOf_Recognize_Value_(left17321, right17323), True{}))
    case _ _: False{}
@unsafe
def Equal.Emit_Error(left, right):
  match left right:
    case Emit.Error.Recognizer{+left17336} Emit.Error.Recognizer{+right17337}: Bool.and(Equal.Recognize_Error(left17336, right17337), True{})
    case Emit.Error.Missing{+left17340} Emit.Error.Missing{+right17341}: Bool.and(NativeString.equal(left17340, right17341), True{})
    case Emit.Error.Postulate{+left17342} Emit.Error.Postulate{+right17343}: Bool.and(NativeString.equal(left17342, right17343), True{})
    case Emit.Error.Higher_order{} Emit.Error.Higher_order{}: True{}
    case Emit.Error.Later{+left17344} Emit.Error.Later{+right17345}: Bool.and(NativeString.equal(left17344, right17345), True{})
    case Emit.Error.Invalid_ir{+left17346} Emit.Error.Invalid_ir{+right17347}: Bool.and(NativeString.equal(left17346, right17347), True{})
    case Emit.Error.Nat_runtime{} Emit.Error.Nat_runtime{}: True{}
    case Emit.Error.Budget{} Emit.Error.Budget{}: True{}
    case Emit.Error.Effect_shape{} Emit.Error.Effect_shape{}: True{}
    case Emit.Error.Unknown_slot{} Emit.Error.Unknown_slot{}: True{}
    case Emit.Error.Assembly{+left17348} Emit.Error.Assembly{+right17349}: Bool.and(Equal.Asm_Error(left17348, right17349), True{})
    case Emit.Error.M1_shape{+left17350} Emit.Error.M1_shape{+right17351}: Bool.and(NativeString.equal(left17350, right17351), True{})
    case Emit.Error.Selector_collision{+left17352} Emit.Error.Selector_collision{+right17353}: Bool.and(NativeString.equal(left17352, right17353), True{})
    case _ _: False{}
@unsafe
def Equal.Recognize_Error(left, right):
  match left right:
    case Recognize.Error.Protocol{+left17338} Recognize.Error.Protocol{+right17339}: Bool.and(NativeString.equal(left17338, right17339), True{})
    case Recognize.Error.Word_shape{} Recognize.Error.Word_shape{}: True{}
    case Recognize.Error.Word_range{} Recognize.Error.Word_range{}: True{}
    case Recognize.Error.Word_boxed{} Recognize.Error.Word_boxed{}: True{}
    case Recognize.Error.Storage_closure{} Recognize.Error.Storage_closure{}: True{}
    case Recognize.Error.Storage_shape{} Recognize.Error.Storage_shape{}: True{}
    case Recognize.Error.Storage_slot{} Recognize.Error.Storage_slot{}: True{}
    case _ _: False{}
@unsafe
def Equal.Emit_Result_TupleOf2_Recognize_Value__Big__(left, right):
  match left right:
    case Done{+left17354} Done{+right17355}: Bool.and(Equal.TupleOf2_Recognize_Value__Big_(left17354, right17355), True{})
    case Fail{+left17360} Fail{+right17361}: Bool.and(Equal.Emit_Error(left17360, right17361), True{})
    case _ _: False{}
@unsafe
def Equal.TupleOf2_Recognize_Value__Big_(left, right):
  match left right:
    case Tup2{+left17356, +left17357} Tup2{+right17358, +right17359}: Bool.and(Equal.Recognize_Value(left17356, right17358), Bool.and(Big.is_eq(left17357, right17359), True{}))
@unsafe
def Equal.Emit_Result_Emit_Effect_(left, right):
  match left right:
    case Done{+left17362} Done{+right17363}: Bool.and(Equal.Emit_Effect(left17362, right17363), True{})
    case Fail{+left17378} Fail{+right17379}: Bool.and(Equal.Emit_Error(left17378, right17379), True{})
    case _ _: False{}
@unsafe
def Equal.Emit_Effect(left, right):
  match left right:
    case Emit.Effect.Return{+left17364} Emit.Effect.Return{+right17365}: Bool.and(Big.is_eq(left17364, right17365), True{})
    case Emit.Effect.Read{+left17366} Emit.Effect.Read{+right17367}: Bool.and(Big.is_eq(left17366, right17367), True{})
    case Emit.Effect.Put{+left17368, +left17369, +left17370} Emit.Effect.Put{+right17371, +right17372, +right17373}: Bool.and(Big.is_eq(left17368, right17371), Bool.and(Big.is_eq(left17369, right17372), Bool.and(Equal.Emit_Effect(left17370, right17373), True{})))
    case Emit.Effect.Deployer{+left17374, +left17375} Emit.Effect.Deployer{+right17376, +right17377}: Bool.and(Big.is_eq(left17374, right17376), Bool.and(Equal.Emit_Effect(left17375, right17377), True{}))
    case _ _: False{}
@unsafe
def Equal.ResultOf_Recognize_Error__Recognize_Value_(left, right):
  match left right:
    case Done{+left17400} Done{+right17401}: Bool.and(Equal.Recognize_Value(left17400, right17401), True{})
    case Fail{+left17402} Fail{+right17403}: Bool.and(Equal.Recognize_Error(left17402, right17403), True{})
    case _ _: False{}
@unsafe
def Equal.ResultOf_Recognize_Error__Unit_(left, right):
  match left right:
    case Done{+left17404} Done{+right17405}: Bool.and(Equal.Unit(left17404, right17405), True{})
    case Fail{+left17406} Fail{+right17407}: Bool.and(Equal.Recognize_Error(left17406, right17407), True{})
    case _ _: False{}
@unsafe
def Equal.Unit(left, right):
  match left right:
    case Unit{} Unit{}: True{}
@unsafe
def Equal.ResultOf_Recognize_Error__ListOf_String__(left, right):
  match left right:
    case Done{+left17464} Done{+right17465}: Bool.and(Equal.ListOf_String_(left17464, right17465), True{})
    case Fail{+left17466} Fail{+right17467}: Bool.and(Equal.Recognize_Error(left17466, right17467), True{})
    case _ _: False{}
@unsafe
def Match.One_paths_Expectation(r, -R: Kind(r), value: One_paths.Expectation, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R)) -> R:
  match value:
    case One_paths.Expectation.Accept{}: on0(Unit{})
    case One_paths.Expectation.Quantity_error{}: on1(Unit{})
    case One_paths.Expectation.Negative_literal{}: on2(Unit{})
@unsafe
def Get.Positivity.Ctor.c_full_arity(value: Positivity.Ctor) -> Big:
  match value:
    case MkPositivity_Ctor{_, _, _, field3, _}: field3
law Syntax.at: for +lvl_585: Big for +s_586: Syntax String
law Local.Abi_codec.parse.f16754: for +result_806: ListOf(Abi.Schema.Value_type) for +param_851: ListOf(String) StringResult(ListOf(Abi.Schema.Value_type))
law Local.Abi_codec.pairs.f16814: for +digit_620: Reusable(Char, StringResult(Big)) for +result_624: ListOf(Char) for +param_789: ListOf(Char) StringResult(String)
law Local.Keccak_vec.go.f16910: for +acc_293: ListOf(Char) for +input_294: (Unit -> Series<&2, Char>) ResultOf(Keccak_vec.Error, String)
law Export_mu.term: for +t_560: Term StringResult(String)
@unsafe
def Check.infer_term(+_opt__1562: Maybe<&1, Budget>, +globals_1560: Global, +t_1561: Term) -> CheckResult(Value):
  (+scrut16117 = {(+scrut16115 = _opt__1562
  Match.Maybe(&1, Budget, &1, Budget, scrut16115, _ => (Budget.unlimited()), +p16116 => (p16116))) : Budget}
  Check.infer(Check.make(globals_1560, scrut16117), Quantity.Many{}, t_1561))
@unsafe
def Error.message(+e_349: Error) -> String:
  (+scrut16125 = e_349
  Match.Error(&2, String, scrut16125, +p16126 => (p16126), +p16127 => +p16128 => +p16129 => (p16127), +p16130 => (p16130), +p16131 => (p16131), +p16132 => (p16132), +p16133 => (p16133), +p16134 => (p16134), +p16135 => (p16135), +p16136 => (p16136), +p16137 => (p16137), +p16138 => (p16138), +p16139 => (p16139), +p16140 => (p16140), +p16141 => (p16141), +p16142 => (Error.termination_msg(p16142))))
@unsafe
def Main.kneg_smu(+param_911: Unit) -> StringResult(Unit):
  (+scrut16111 = param_911
  (+scrut16112 = {Shape.SMu{"F", Con{Term.Univ{Level.zero()}, Nil{}}} : Shape<&2, Term>}
  (+scrut16113 = {Term.Sec{Shape.SColl{Big.zero()}, Nil{}} : Term}
  (+local16120 => (Match.Result(&2, Value, &2, Error, &2, StringResult(Unit), local16120, +x => (+local16122 => (Fail{"the right former at a mu shape is admitted at M1"}))(x), +x => (+local16124 => ((+scrut16143 = {Error.message(local16124) : String}
  Native.choose(&2, StringResult(Unit), NativeString.equal(scrut16143, "a right former at a mu shape arrives at M2"), _ => (Done{Unit{}}), _ => (Fail{String.concat(["the message is \u{22}", scrut16143, "\u{22}"])})))))(x))))(Check.infer_term(None{}, Global.initial(), Term.Ran{scrut16112, scrut16113})))))
@unsafe
def Totality.guard(+_opt__795: Maybe<&1, Budget>, +globals_761: Global, +name_762: String, +ty_763: Term, +body_764: Term) -> CheckResult(OptionOf(Big)):
  (+scrut16149 = {(+scrut16147 = _opt__795
  Match.Maybe(&1, Budget, &1, Budget, scrut16147, _ => (Budget.unlimited()), +p16148 => (p16148))) : Budget}
  (+scrut16150 = ty_763
  (+local16153 => (Match.Result(&2, OptionOf(Order), &2, Error, &2, CheckResult(OptionOf(Big)), local16153, +item16161 => (Done{(+local16156 => (Match.Maybe(&2, Order, &2, OptionOf(Big), local16156, _ => None{}, +item16160 => (Some{(+local16158 => (Get.Order.o_arg(local16158)))(item16160)}))))(item16161)}), +item16162 => Fail{item16162})))(Totality.guard_group(Some{scrut16149}, globals_761, Con{Tup2{name_762, body_764}, Nil{}}))))
@unsafe
def Main.guarded_self() -> Term:
  (+scrut16174 = {Shape.SPi{Quantity.Many{}, "n", Term.Global{"N"}} : Shape<&2, Term>}
  (+scrut16175 = {Term.Out{scrut16174, Term.AddrOf.APt{Quantity.Many{}, Term.Var{Big.zero()}}, Term.Global{"self"}} : Term}
  (+scrut16176 = {Tup2{Term.AddrOf.ACtor{"succ"}, MkTerm_LegOf{Con{Tup2{Quantity.Many{}, "m"}, Nil{}}, scrut16175}} : TupleOf2(Term.Addr, Term.Leg)}
  (+scrut16177 = {Term.Elim{MkTerm_ElimOf{Shape.SMu{"N", Nil{}}, Term.Var{Big.zero()}, Quantity.Many{}, Some{MkTerm_MotiveOf{Some{"N"}, Nil{}, "x", Term.Global{"N"}}}, Con{scrut16176, Nil{}}}} : Term}
  Term.Sec{scrut16174, Con{MkTerm_LegOf{Con{Tup2{Quantity.Many{}, "n"}, Nil{}}, scrut16177}, Nil{}}}))))
@unsafe
def Main.kneg_self(+param_1039: Unit) -> StringResult(Unit):
  (+scrut16144 = param_1039
  (Match.Result(&2, Unit, &2, String, &2, StringResult(Unit), (+local16165 => (Match.Result(&2, OptionOf(Big), &2, Error, &2, StringResult(Unit), local16165, +x => (+local16167 => (Fail{"the unguarded self reference is admitted at M1"}))(x), +x => (+local16169 => ((+scrut16170 = {Error.message(local16169) : String}
Native.choose(&2, StringResult(Unit), NativeString.equal(scrut16170, "recursive definition self failed the structural termination guard"), _ => (Done{Unit{}}), _ => (Fail{String.concat(["the message is \u{22}", scrut16170, "\u{22}"])})))))(x))))(Totality.guard(None{}, Global.initial(), "self", Term.Global{"Nat"}, Term.Global{"self"})), +item16190 => ((+local16172 => ((+scrut16173 = local16172
(+local16180 => (Match.Result(&2, OptionOf(Big), &2, Error, &2, StringResult(Unit), local16180, +x => (+local16182 => ((+local16185 => (Match.Maybe(&2, Big, &2, StringResult(Unit), local16185, _ => (Fail{"the guarded self reference answers no position"}), +value => ((+local16187 => (Native.choose(&2, StringResult(Unit), Big.is_eq(local16187, Big.zero()), _ => (Done{Unit{}}), _ => (Fail{String.concat(["the guarded position is ", Big.show(local16187)])}))))(value)))))(local16182)))(x), +x => (+local16189 => (Fail{String.concat(["the message is \u{22}", Error.message(local16189), "\u{22}"])}))(x))))(Totality.guard(None{}, Global.initial(), "self", Term.Global{"Nat"}, Main.guarded_self())))))(item16190)), +item16191 => Fail{item16191})))
@unsafe
def Main.kneg(+name_1042: String) -> StringResult(Unit):
  (+scrut16110 = {Unit{} : Unit}
  Native.choose(&2, StringResult(Unit), NativeString.equal(name_1042, "smu"), _ => (Main.kneg_smu(Unit{})), _ => (Native.choose(&2, StringResult(Unit), NativeString.equal(name_1042, "self"), _ => (Main.kneg_self(Unit{})), _ => (Fail{String.concat(["no kernel negative is named \u{22}", name_1042, "\u{22}"])})))))
@unsafe
def Main.recursive_values(+_name_1144: String) -> StringResult(Unit):
  (+scrut16193 = {"\u{a}mu N : Type 0 with | zero : N | succ : N -> N\u{a}mu A : Type 0 with | leaf : A | node : B -> A\u{a}and B : Type 0 with | cons : A -> B\u{a}mu V : (0 i : N) -> Type 0 with\u{a}| vz : V zero\u{a}| vs : (0 i : N) -> V i -> V (succ i)\u{a}def rec length : (0 i : N) -> V i -> N := fun (0 i : N) (v : V i) => case v as x in V j return N with | vz => zero | vs 0 j w => succ (length j w)\u{a}def rec double : N -> N := fun (n : N) => case n as x in N return N with | zero => zero | succ m => succ (succ (double m))\u{a}def rec sizeA : A -> Nat := fun (a : A) => case a as x in A return Nat with | leaf => 0 | node b => natAdd 1 (sizeB b)\u{a}and sizeB : B -> Nat := fun (b : B) => case b as x in B return Nat with | cons a => natAdd 1 (sizeA a)\u{a}def rec f : N -> N := fun (n : N) => case n as x in N return N with | zero => zero | succ m => g m\u{a}and g : N -> N := fun (n : N) => zero\u{a}and spare : N := zero\u{a}def rec keep : Nat -> N -> Nat := fun (a : Nat) => fun (n : N) => case n as x in N return Nat with | zero => a | succ m => keep a m\u{a}def rec choose : N -> Nat -> Nat := fun (n : N) => case n as x in N return (Nat -> Nat) with | zero => fun (a : Nat) => a | succ m => choose m\u{a}def doubled : N := double (succ (succ zero))\u{a}def four : N := succ (succ (succ (succ zero)))\u{a}def z : N := zero\u{a}def mutualValue : Nat := sizeA (node (cons leaf))\u{a}def two : Nat := 2\u{a}def helper : N := f (succ zero)\u{a}def helperDirect : N := g zero\u{a}def kept : Nat := keep 7 (succ (succ zero))\u{a}def seven : Nat := 7\u{a}def chosen : Nat := choose (succ (succ zero)) 7\u{a}def indexed : N := length (succ zero) (vs zero vz)\u{a}def one : N := succ zero\u{a}def partial : N -> Nat := keep 7\u{a}def neutral : N -> Nat := fun (n : N) => keep 7 n\u{a}" : String}
  (+scrut16330 = {(+local16195 => ((+scrut16196 = local16195
  (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, CheckResult(Unit), Elab.check_in(None{}, Global.initial(), scrut16193), +item16327 => ((+local16199 => ((+scrut16200 = local16199
Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, CheckResult(Unit), scrut16200, +p16201 => +p16202 => ((+scrut16215 = {(+local16204 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(String), Eval.eval(p16201, Nil{}, Term.Global{local16204}), +item16213 => ((+local16207 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(String), Eval.quote(p16201, Big.zero(), local16207), +item16211 => ((+local16210 => (Done{Pp.term(Nil{}, local16210)}))(item16211)), +item16212 => Fail{item16212})))(item16213)), +item16214 => Fail{item16214}))) : Reusable(String, CheckResult(String))}
(Match.Result(&2, Unit, &2, Error, &2, CheckResult(Unit), SeqList.fold(&2, &2, TupleOf2(String, String), CheckResult(Unit), (+local16218 => +local16220 => ((+scrut16221 = local16220
Match.Tuple2(&2, String, &2, String, &2, CheckResult(Unit), scrut16221, +p16222 => +p16223 => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(Unit), local16218, +item16238 => ((+local16226 => ((+scrut16227 = local16226
Match.Result(&2, String, &2, Error, &2, CheckResult(Unit), scrut16215(p16222), +item16236 => ((+local16230 => (Match.Result(&2, String, &2, Error, &2, CheckResult(Unit), scrut16215(p16223), +item16234 => ((+local16233 => (Native.choose(&2, CheckResult(Unit), NativeString.equal(local16230, local16233), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.append(p16222, String.append(" did not compute: ", local16230))}}))))(item16234)), +item16235 => Fail{item16235})))(item16236)), +item16237 => Fail{item16237}))))(item16238)), +item16239 => Fail{item16239})))))), Con{Tup2{"doubled", "four"}, Con{Tup2{"mutualValue", "two"}, Con{Tup2{"helper", "z"}, Con{Tup2{"helperDirect", "z"}, Con{Tup2{"spare", "z"}, Con{Tup2{"kept", "seven"}, Con{Tup2{"chosen", "seven"}, Con{Tup2{"indexed", "one"}, Nil{}}}}}}}}}, Done{Unit{}}), +item16324 => ((+local16241 => ((+scrut16242 = local16241
(Match.Result(&2, Unit, &2, Error, &2, CheckResult(Unit), SeqList.fold(&2, &2, String, CheckResult(Unit), (+local16245 => +local16247 => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(Unit), local16245, +item16257 => ((+local16250 => ((+scrut16251 = local16250
Match.Result(&2, Value, &2, Error, &2, CheckResult(Unit), Eval.eval(p16201, Nil{}, Term.Global{local16247}), +item16255 => ((+local16254 => (Native.choose(&2, CheckResult(Unit), Maybe.is_some(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), Value.as_neutral(local16254)), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.append(local16247, " unfolded before its guarded argument")}}))))(item16255)), +item16256 => Fail{item16256}))))(item16257)), +item16258 => Fail{item16258}))), Con{"double", Con{"keep", Con{"partial", Nil{}}}}, Done{Unit{}}), +item16321 => ((+local16260 => ((+scrut16261 = local16260
Match.Result(&2, Value, &2, Error, &2, CheckResult(Unit), Eval.eval(p16201, Nil{}, Term.Global{"neutral"}), +item16319 => ((+local16264 => (Match.Result(&2, TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg)), &2, Error, &2, CheckResult(Unit), (+local16268 => (Match.Maybe(&2, TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg)), &2, CheckResult(TupleOf2(Shape<&2, Value>, ListOf(Value.Vleg))), local16268, _ => Fail{Error.Mismatch{"neutral lambda"}}, +x => Done{x})))(Value.as_sec(local16264)), +item16317 => ((+local16270 => ((+scrut16271 = local16270
Match.Tuple2(&2, Shape<&2, Value>, &2, ListOf(Value.Vleg), &2, CheckResult(Unit), scrut16271, +p16272 => +p16273 => ((Match.Result(&2, Value.Vleg, &2, Error, &2, CheckResult(Unit), (+local16277 => (Match.Maybe(&2, Value.Vleg, &2, CheckResult(Value.Vleg), local16277, _ => Fail{Error.Mismatch{"neutral leg"}}, +x => Done{x})))(Rules.one_of(&2, Value.Vleg, p16273)), +item16314 => ((+local16279 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Unit), Rules.open_closure(Eval.ev(p16201), Get.Value.Vleg.vl_clo(local16279), Con{Value.var(Big.zero()), Nil{}}), +item16312 => ((+local16282 => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(Unit), Native.choose(&2, CheckResult(Unit), Maybe.is_some(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), Value.as_neutral(local16282)), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{"recursive call unfolded on a neutral argument"}})), +item16310 => ((+local16285 => ((+scrut16286 = local16285
(Match.Result(&2, Global.Entry, &2, Error, &2, CheckResult(Unit), (+local16290 => (Match.Maybe(&2, Global.Entry, &2, CheckResult(Global.Entry), local16290, _ => Fail{Error.Unbound{"double"}}, +x => Done{x})))(Global.find("double", p16201)), +item16307 => ((+local16292 => (Match.Result(&2, Global.Def_entry, &2, Error, &2, CheckResult(Unit), (+local16296 => (Match.Maybe(&2, Global.Def_entry, &2, CheckResult(Global.Def_entry), local16296, _ => Fail{Error.Mismatch{"double definition"}}, +x => Done{x})))(Global.def_of(local16292)), +item16305 => ((+local16298 => ((+scrut16299 = {Global.add("double", Global.Entry.Def{MkGlobal_Def_entry{Get.Global.Def_entry.ty(local16298), Get.Global.Def_entry.def(local16298), False{}, Get.Global.Def_entry.rec_arg(local16298), Get.Global.Def_entry.partial(local16298)}}, p16201) : Global}
Match.Result(&2, Value, &2, Error, &2, CheckResult(Unit), Eval.eval(scrut16299, Nil{}, Term.Global{"doubled"}), +item16303 => ((+local16302 => (Native.choose(&2, CheckResult(Unit), Maybe.is_some(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), Value.as_neutral(local16302)), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{"an explicitly opaque recursive definition unfolded"}}))))(item16303)), +item16304 => Fail{item16304}))))(item16305)), +item16306 => Fail{item16306})))(item16307)), +item16308 => Fail{item16308})))))(item16310)), +item16311 => Fail{item16311})))(item16312)), +item16313 => Fail{item16313})))(item16314)), +item16315 => Fail{item16315})))))))(item16317)), +item16318 => Fail{item16318})))(item16319)), +item16320 => Fail{item16320}))))(item16321)), +item16322 => Fail{item16322})))))(item16324)), +item16325 => Fail{item16325}))))))))(item16327)), +item16328 => Fail{item16328}))))) : Reusable(Unit, CheckResult(Unit))}
  Match.Result(&2, Unit, &2, Error, &2, StringResult(Unit), scrut16330(Unit{}), +item16331 => Done{item16331}, +item16332 => (Fail{Error.to_string(item16332)}))))
@unsafe
def Sl_surface.family() -> String:
  "mu N : Type 0 := | zero : N | succ (n : N) : N\u{a}"
@unsafe
def Sl_surface.legacy_family() -> String:
  "mu N : Type 0 with | zero : N | succ : (n : N) -> N\u{a}"
@unsafe
def Sl_surface.parse(+source_325: String) -> StringResult(ListOf(Syntax.Decl)):
  (+local16339 => (Match.Result(&2, ListOf(Syntax.Decl), &2, Error, &2, StringResult(ListOf(Syntax.Decl)), local16339, +item16340 => Done{item16340}, +item16341 => (Fail{Error.to_string(item16341)}))))(Parser.parse(source_325))
@unsafe
def Sl_surface.same_tree(+first_484: String, +second_485: String) -> StringResult(Unit):
  Match.Result(&2, ListOf(Syntax.Decl), &2, String, &2, StringResult(Unit), Sl_surface.parse(first_484), +item16519 => ((+local16343 => (Match.Result(&2, ListOf(Syntax.Decl), &2, String, &2, StringResult(Unit), Sl_surface.parse(second_485), +item16517 => ((+local16346 => (Native.choose(&2, StringResult(Unit), Equal.ListOf_Syntax_Decl_(local16343, local16346), _ => (Done{Unit{}}), _ => (Fail{"sugar changed the family tree"}))))(item16517)), +item16518 => Fail{item16518})))(item16519)), +item16520 => Fail{item16520})
@unsafe
def Sl_surface.mutual() -> String:
  "mutual mu A : Type 0 := | a (b : B) : A mu B : Type 0 := | b : B end"
@unsafe
def Sl_surface.legacy_mutual() -> String:
  "mu A : Type 0 with | a : (b : B) -> A and B : Type 0 with | b : B"
@unsafe
def Sl_surface.matched() -> String:
  String.append(Sl_surface.family(), "def pred : N -> N := fun (n : N) => match n as x in N return N with | zero => zero | succ (p : N) => p")
@unsafe
def Sl_surface.cased() -> String:
  String.append(Sl_surface.legacy_family(), "def pred : N -> N := fun (n : N) => case n as x in N return N with | zero => zero | succ p => p")
@unsafe
def Sl_surface.checked(+source_490: String) -> StringResult(String):
  (+local16535 => (Match.Result(&2, String, &2, Error, &2, StringResult(String), local16535, +item16536 => Done{item16536}, +item16537 => (Fail{Error.to_string(item16537)}))))((+local16530 => (Match.Result(&2, ListOf(TupleOf2(String, Global.Entry)), &2, Error, &2, CheckResult(String), local16530, +item16531 => (Done{Elab.checked_form(item16531)}), +item16532 => Fail{item16532})))(Elab.check_text(None{}, Global.initial(), source_490)))
@unsafe
def Sl_surface.same_checked(+first_600: String, +second_601: String) -> StringResult(Unit):
  Match.Result(&2, String, &2, String, &2, StringResult(Unit), Sl_surface.checked(first_600), +item16545 => ((+local16539 => (Match.Result(&2, String, &2, String, &2, StringResult(Unit), Sl_surface.checked(second_601), +item16543 => ((+local16542 => (Native.choose(&2, StringResult(Unit), NativeString.equal(local16539, local16542), _ => (Done{Unit{}}), _ => (Fail{"match changed checked elimination"}))))(item16543)), +item16544 => Fail{item16544})))(item16545)), +item16546 => Fail{item16546})
@unsafe
def Syntax.mark(+q_577: Quantity) -> String:
  (+scrut16587 = q_577
  Match.Quantity(&2, String, scrut16587, _ => ("0 "), _ => ("1 "), _ => ("")))
@unsafe
def Syntax.binder_text(+b_588: Syntax.Binder) -> String:
  String.concat(["(", Syntax.mark(Get.Syntax.Binder.b_q(b_588)), Get.Syntax.Binder.b_name(b_588), " : ", Syntax.at(Big.zero(), Get.Syntax.Binder.b_ty(b_588)), ")"])
@unsafe
def Syntax.ind_text(+mo_788: Syntax.Motive) -> String:
  (+local16606 => (Match.Maybe(&2, String, &2, String, local16606, _ => (""), +value => ((+local16608 => (String.append(" in ", String.append(local16608, String.join(SeqList.map(&2, &2, String, String, (+local16610 => (String.append(" ", local16610))), Get.Syntax.Motive.mo_idx(mo_788)), "")))))(value)))))(Get.Syntax.Motive.mo_ind(mo_788))
@unsafe
def Syntax.motive_text(+mo_787: Syntax.Motive) -> String:
  String.concat([" as ", Get.Syntax.Motive.mo_self(mo_787), Syntax.ind_text(mo_787), " return ", Syntax.at(Big.one(), Get.Syntax.Motive.mo_body(mo_787))])
@unsafe
def Syntax.field_text(+f_768: Syntax.Field) -> String:
  (+local16622 => (Match.Maybe(&2, Syntax, &2, String, local16622, _ => (String.append(" ", String.append(Syntax.mark(Get.Syntax.Field.fd_q(f_768)), Get.Syntax.Field.fd_name(f_768)))), +value => ((+local16624 => (String.append(" ", Syntax.binder_text(MkSyntax_BinderOf{Get.Syntax.Field.fd_q(f_768), Get.Syntax.Field.fd_name(f_768), local16624}))))(value)))))(Get.Syntax.Field.fd_ty(f_768))
@unsafe
def Syntax.branch_text(+br_625: Syntax.Branch) -> String:
  (+scrut16611 = br_625
  Match.Syntax_Branch(&2, String, scrut16611, +p16612 => +p16613 => +p16614 => (String.concat([" | ", Big.show(p16612), String.join(SeqList.map(&2, &2, Syntax.Binder, String, (+local16616 => (String.append(" ", Syntax.binder_text(local16616)))), p16613), ""), " => ", Syntax.at(Big.one(), p16614)])), +p16617 => +p16618 => +p16619 => (String.concat([" | ", p16617, String.join(SeqList.map(&2, &2, Syntax.Field, String, Syntax.field_text, p16618), ""), " => ", Syntax.at(Big.one(), p16619)]))))
@unsafe
def Syntax.raw(+s_791: Syntax) -> String:
  (+scrut16558 = s_791
  Match.Syntax(&2, String, scrut16558, +p16559 => (p16559), +p16560 => (Bignum.to_string(p16560)), _ => ("Prop"), +p16561 => (String.append("Type ", Big.show(p16561))), +p16562 => (Syntax.prim_name(p16562)), _ => ("()"), _ => ("auto"), +p16563 => +p16564 => (String.concat(["(", Syntax.at(Big.zero(), p16563), ", ", Syntax.at(Big.zero(), p16564), ")"])), +p16565 => (String.concat(["tuple (", String.join(SeqList.map(&2, &2, Syntax, String, (+local16568 => (Syntax.at(Big.zero(), local16568))), p16565), ", "), ")"])), +p16569 => (String.concat(["sum (", String.join(SeqList.map(&2, &2, Syntax, String, (+local16572 => (Syntax.at(Big.zero(), local16572))), p16569), ", "), ")"])), +p16573 => (String.concat(["prod (", String.join(SeqList.map(&2, &2, Syntax, String, (+local16576 => (Syntax.at(Big.zero(), local16576))), p16573), ", "), ")"])), +p16577 => +p16578 => (String.concat([Syntax.at(Big.of_nat(2n), p16577), ".", Big.show(p16578)])), +p16579 => +p16580 => +p16581 => (String.concat(["inj ", Big.show(p16579), " of ", Big.show(p16580), " ", Syntax.at(Big.one(), p16581)])), +p16582 => (String.append("absurd ", Syntax.at(Big.one(), p16582))), +p16583 => +p16584 => (String.append(Syntax.at(Big.one(), p16583), String.append(" ", Syntax.at(Big.of_nat(2n), p16584)))), +p16585 => +p16586 => (String.concat(["fun ", String.join(SeqList.map(&2, &2, Syntax.Binder, String, Syntax.binder_text, p16585), " "), " => ", Syntax.at(Big.zero(), p16586)])), +p16588 => +p16589 => (String.append(Syntax.binder_text(p16588), String.append(" -> ", Syntax.at(Big.zero(), p16589)))), +p16590 => +p16591 => (String.append(Syntax.binder_text(p16590), String.append(" * ", Syntax.at(Big.zero(), p16591)))), +p16592 => +p16593 => +p16594 => +p16595 => (String.concat(["let ", p16592, " : ", Syntax.at(Big.one(), p16593), " := ", Syntax.at(Big.one(), p16594), " in ", Syntax.at(Big.zero(), p16595)])), +p16596 => +p16597 => (String.concat(["(", Syntax.at(Big.zero(), p16596), " : ", Syntax.at(Big.zero(), p16597), ")"])), +p16598 => +p16599 => +p16600 => (String.concat(["case ", Syntax.at(Big.one(), p16598), (+local16603 => (Match.Maybe(&2, Syntax.Motive, &2, String, local16603, _ => (""), +value => (Syntax.motive_text(value)))))(p16599), " with", String.join(SeqList.map(&2, &2, Syntax.Branch, String, Syntax.branch_text, p16600), "")])), +p16625 => +p16626 => +p16627 => (String.concat(["match ", Syntax.at(Big.one(), p16625), (+local16630 => (Match.Maybe(&2, Syntax.Motive, &2, String, local16630, _ => (""), +value => (Syntax.motive_text(value)))))(p16626), " with", String.join(SeqList.map(&2, &2, Syntax.Branch, String, Syntax.branch_text, p16627), "")]))))
@unsafe
def Syntax.level_of(+s_574: Syntax) -> Big:
  (+scrut16632 = s_574
  Match.Syntax(&2, Big, scrut16632, +p16633 => (Big.of_nat(2n)), +p16634 => (Big.of_nat(2n)), _ => (Big.of_nat(2n)), +p16635 => (Big.of_nat(2n)), +p16636 => (Big.of_nat(2n)), _ => (Big.of_nat(2n)), _ => (Big.of_nat(2n)), +p16637 => +p16638 => (Big.of_nat(2n)), +p16639 => (Big.of_nat(2n)), +p16640 => (Big.of_nat(2n)), +p16641 => (Big.of_nat(2n)), +p16642 => +p16643 => (Big.of_nat(2n)), +p16644 => +p16645 => +p16646 => (Big.one()), +p16647 => (Big.one()), +p16648 => +p16649 => (Big.one()), +p16650 => +p16651 => (Big.zero()), +p16652 => +p16653 => (Big.zero()), +p16654 => +p16655 => (Big.zero()), +p16656 => +p16657 => +p16658 => +p16659 => (Big.zero()), +p16660 => +p16661 => (Big.of_nat(2n)), +p16662 => +p16663 => +p16664 => (Big.zero()), +p16665 => +p16666 => +p16667 => (Big.zero())))
@unsafe
def Syntax.at(lvl_585, s_586):
  (+scrut16631 = {Syntax.raw(s_586) : String}
  Native.choose(&2, String, Big.is_le(lvl_585, Syntax.level_of(s_586)), _ => (scrut16631), _ => (String.append("(", String.append(scrut16631, ")")))))
@unsafe
def Syntax.fam_ctor_text(+fc_829: Syntax.Fam_ctor) -> String:
  String.concat(["| ", Get.Syntax.Fam_ctor.fc_name(fc_829), " : ", Syntax.at(Big.zero(), Get.Syntax.Fam_ctor.fc_ty(fc_829)), "\u{a}"])
@unsafe
def Syntax.fam_text(+word_832: String, +fm_833: Syntax.Fam) -> String:
  String.concat([word_832, " ", Get.Syntax.Fam.fm_name(fm_833), String.join(SeqList.map(&2, &2, Syntax.Binder, String, (+local16674 => (String.append(" ", Syntax.binder_text(local16674)))), Get.Syntax.Fam.fm_params(fm_833)), ""), " : ", Syntax.at(Big.zero(), Get.Syntax.Fam.fm_ty(fm_833)), " :=\u{a}", String.join(SeqList.map(&2, &2, Syntax.Fam_ctor, String, Syntax.fam_ctor_text, Get.Syntax.Fam.fm_ctors(fm_833)), "")])
@unsafe
def Syntax.decl_text(+d_837: Syntax.Decl) -> String:
  (+scrut16554 = d_837
  Match.Syntax_Decl(&2, String, scrut16554, +p16555 => +p16556 => +p16557 => (String.concat(["def ", p16555, " : ", Syntax.at(Big.zero(), p16556), " := ", Syntax.at(Big.zero(), p16557), "\u{a}"])), +p16668 => +p16669 => (String.concat(["axiom ", p16668, " : ", Syntax.at(Big.zero(), p16669), "\u{a}"])), +p16670 => (Match.List(&2, Syntax.Fam, &2, String, p16670, _ => (""), +p16671 => +p16672 => (Match.List(&2, Syntax.Fam, &2, String, p16672, _ => (Syntax.fam_text("mu", p16671)), +p16675 => +p16676 => (String.append("mutual\u{a}", String.append(String.join(SeqList.map(&2, &2, Syntax.Fam, String, (+local16679 => (Syntax.fam_text("mu", local16679))), p16670), ""), "end\u{a}"))))))), +p16680 => (String.join(SeqList.mapi(&2, &2, Syntax.Rec_def, String, (+local16682 => +local16684 => (String.concat([Native.choose(&2, String, Big.is_eq(local16682, Big.zero()), _ => ("def rec"), _ => ("and")), " ", Get.Syntax.Rec_def.rd_name(local16684), " : ", Syntax.at(Big.zero(), Get.Syntax.Rec_def.rd_ty(local16684)), " := ", Syntax.at(Big.zero(), Get.Syntax.Rec_def.rd_body(local16684)), "\u{a}"]))), p16680), ""))))
@unsafe
def Syntax.print(+ds_884: ListOf(Syntax.Decl)) -> String:
  String.join(SeqList.map(&2, &2, Syntax.Decl, String, Syntax.decl_text, ds_884), "")
@unsafe
def Sl_surface.round_trip(+source_400: String) -> StringResult(Unit):
  Match.Result(&2, ListOf(Syntax.Decl), &2, String, &2, StringResult(Unit), Sl_surface.parse(source_400), +item16689 => ((+local16552 => (Match.Result(&2, ListOf(Syntax.Decl), &2, String, &2, StringResult(Unit), Sl_surface.parse(Syntax.print(local16552)), +item16687 => ((+local16686 => (Native.choose(&2, StringResult(Unit), Equal.ListOf_Syntax_Decl_(local16552, local16686), _ => (Done{Unit{}}), _ => (Fail{"printed tree changed"}))))(item16687)), +item16688 => Fail{item16688})))(item16689)), +item16690 => Fail{item16690})
@unsafe
def Sl_surface.parse_refusal(+source_405: String, +message_406: String) -> StringResult(Unit):
  (+local16723 => (Match.Result(&2, ListOf(Syntax.Decl), &2, Error, &2, StringResult(Unit), local16723, +x => (+local16725 => (Fail{"invalid source parsed"}))(x), +x => (+local16727 => (Native.choose(&2, StringResult(Unit), NativeString.equal(Error.message(local16727), message_406), _ => (Done{Unit{}}), _ => (Fail{Error.to_string(local16727)}))))(x))))(Parser.parse(source_405))
@unsafe
def Sl_surface.cases() -> List<&1, Tuple2<&2, &1, String, Reusable(Unit, StringResult(Unit))>>:
  Con{Tup2{"constructor-sugar", (+local16334 => ((+scrut16335 = local16334
  Sl_surface.same_tree(Sl_surface.family(), Sl_surface.legacy_family()))))}, Con{Tup2{"mutual-sugar", (+local16522 => ((+scrut16523 = local16522
  Sl_surface.same_tree(Sl_surface.mutual(), Sl_surface.legacy_mutual()))))}, Con{Tup2{"match-elaboration", (+local16525 => ((+scrut16526 = local16525
  Sl_surface.same_checked(Sl_surface.matched(), Sl_surface.cased()))))}, Con{Tup2{"mu-roundtrip", (+local16548 => ((+scrut16549 = local16548
  Sl_surface.round_trip(Sl_surface.family()))))}, Con{Tup2{"legacy-mu-roundtrip", (+local16692 => ((+scrut16693 = local16692
  Sl_surface.round_trip(Sl_surface.legacy_family()))))}, Con{Tup2{"mutual-roundtrip", (+local16695 => ((+scrut16696 = local16695
  Sl_surface.round_trip(Sl_surface.mutual()))))}, Con{Tup2{"legacy-mutual-roundtrip", (+local16698 => ((+scrut16699 = local16698
  Sl_surface.round_trip(Sl_surface.legacy_mutual()))))}, Con{Tup2{"match-roundtrip", (+local16701 => ((+scrut16702 = local16701
  Sl_surface.round_trip(Sl_surface.matched()))))}, Con{Tup2{"case-roundtrip", (+local16704 => ((+scrut16705 = local16704
  Sl_surface.round_trip(Sl_surface.cased()))))}, Con{Tup2{"mixed-fields-roundtrip", (+local16707 => ((+scrut16708 = local16707
  Sl_surface.round_trip("def f : Nat := match n as x in N return Nat with | c (0 i : N) x (1 y : Nat) => y"))))}, Con{Tup2{"nested-match-roundtrip", (+local16710 => ((+scrut16711 = local16710
  Sl_surface.round_trip("def f : Nat := match n as x in N return Nat with | z => 0 | s p => (match p as y in N return Nat with | z => 1 | s q => 2)"))))}, Con{Tup2{"empty-match-roundtrip", (+local16713 => ((+scrut16714 = local16713
  Sl_surface.round_trip("mu Void : Prop := def exFalso : Void -> Type 0 := fun (v : Void) => match v as x in Void return Type 0 with"))))}, Con{Tup2{"case-numeric-roundtrip", (+local16716 => ((+scrut16717 = local16716
  Sl_surface.round_trip("def f : Nat := case b with | 0 (x : Nat) => x | 1 (x : Nat) => x"))))}, Con{Tup2{"match-numeric-refusal", (+local16719 => ((+scrut16720 = local16719
  Sl_surface.parse_refusal("def f : Nat := match n with | 0 (x : Nat) => x", "a match branch keys a constructor, not a leg number"))))}, Con{Tup2{"mutual-empty-refusal", (+local16729 => ((+scrut16730 = local16729
  Sl_surface.parse_refusal("mutual end", "a mutual group needs at least two mu declarations"))))}, Con{Tup2{"mutual-singleton-refusal", (+local16732 => ((+scrut16733 = local16732
  Sl_surface.parse_refusal("mutual mu N : Type 0 := end", "a mutual group needs at least two mu declarations"))))}, Con{Tup2{"mutual-unclosed-refusal", (+local16735 => ((+scrut16736 = local16735
  Sl_surface.parse_refusal("mutual mu A : Type 0 := mu B : Type 0 :=", "expected 'mu' or 'end' in a mutual group, found end of input"))))}, Con{Tup2{"mutual-and-refusal", (+local16738 => ((+scrut16739 = local16738
  Sl_surface.parse_refusal("mutual mu A : Type 0 := and B : Type 0 := end", "expected 'mu' or 'end' in a mutual group, found 'and'"))))}, Con{Tup2{"nu-term-refusal", (+local16741 => ((+scrut16742 = local16741
  Sl_surface.parse_refusal("def f : Type 0 := nu", "nu arrives at M2"))))}, Con{Tup2{"nu-declaration-refusal", (+local16744 => ((+scrut16745 = local16744
  Sl_surface.parse_refusal("nu N : Type 0 :=", "nu arrives at M2"))))}, Nil{}}}}}}}}}}}}}}}}}}}}}
@unsafe
def Local.Abi_codec.parse.f16754(result_806, param_851):
  (+scrut16755 = param_851
  Match.List(&2, String, &2, StringResult(ListOf(Abi.Schema.Value_type)), scrut16755, _ => (Done{List.reverse(&2, Abi.Schema.Value_type, result_806)}), +p16756 => +p16757 => ((Match.Result(&2, Abi.Schema.Value_type, &2, String, &2, StringResult(ListOf(Abi.Schema.Value_type)), (+scrut16759 = {Unit{} : Unit}
Native.choose(&2, StringResult(Abi.Schema.Value_type), NativeString.equal(p16756, "uint8"), _ => (Done{Abi.Schema.Value_type.Uint8{}}), _ => (Native.choose(&2, StringResult(Abi.Schema.Value_type), NativeString.equal(p16756, "uint256"), _ => (Done{Abi.Schema.Value_type.Uint256{}}), _ => (Native.choose(&2, StringResult(Abi.Schema.Value_type), NativeString.equal(p16756, "address"), _ => (Done{Abi.Schema.Value_type.Address{}}), _ => (Native.choose(&2, StringResult(Abi.Schema.Value_type), NativeString.equal(p16756, "bool"), _ => (Done{Abi.Schema.Value_type.Bool{}}), _ => (Native.choose(&2, StringResult(Abi.Schema.Value_type), NativeString.equal(p16756, "string"), _ => (Done{Abi.Schema.Value_type.String{}}), _ => (Fail{"ADAPTER-TYPE"}))))))))))), +item16762 => ((+local16761 => (Local.Abi_codec.parse.f16754(Con{local16761, result_806}, p16757)))(item16762)), +item16763 => Fail{item16763})))))
@unsafe
def Abi_codec.types(+text_804: String) -> StringResult(ListOf(Abi.Schema.Value_type)):
  Local.Abi_codec.parse.f16754(Nil{}, Native.choose(&2, ListOf(String), NativeString.equal(text_804, "-"), _ => (Nil{}), _ => (NativeString.split(Char.from_u32(44), text_804))))
@unsafe
def Local.Abi_codec.digits.f16781(+n_794: Big, +param_797: ListOf(Char)) -> StringResult(Big):
  (+scrut16786 = param_797
  Match.List(&2, Char, &2, StringResult(Big), scrut16786, _ => (Done{n_794}), +p16787 => +p16788 => (Native.choose(&2, StringResult(Big), Big.when(Bool, U32.is_lt(Char.to_u32(p16787), Char.to_u32(Char.from_u32(48))), _ => (True{}), _ => (U32.is_lt(Char.to_u32(Char.from_u32(57)), Char.to_u32(p16787)))), _ => (Fail{"ADAPTER-NUMBER"}), _ => (Local.Abi_codec.digits.f16781(Big.add(Big.mul(n_794, Big.identity(Big.of_nat(10n))), Big.identity(NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(p16787))), Big.of_nat(48n)))), p16788))))))
@unsafe
def Abi_codec.number(+text_792: String) -> StringResult(Big):
  (+scrut16782 = {Series.to_list(&2, Char, Series.from_string(text_792)) : ListOf(Char)}
  Match.List(&2, Char, &2, StringResult(Big), scrut16782, _ => (Fail{"ADAPTER-NUMBER"}), +p16783 => +p16784 => ((+otherwise16785 = {_ => (Local.Abi_codec.digits.f16781(Big.zero(), Con{p16783, p16784})) : Unit -> StringResult(Big)}
  Native.choose(&2, StringResult(Big), NativeChar.equal(p16783, Char.from_u32(45)), _ => ((+otherwise16789 = {_ => (Match.Result(&2, Big, &2, String, &2, StringResult(Big), Local.Abi_codec.digits.f16781(Big.zero(), p16784), +item16793 => ((+local16792 => (Done{Big.neg(local16792)}))(item16793)), +item16794 => Fail{item16794})) : Unit -> StringResult(Big)}
  Match.List.only_Nil(&2, Char, &2, StringResult(Big), p16784, _ => (Fail{"ADAPTER-NUMBER"}), _ => (otherwise16789(Unit{}))))), _ => (otherwise16785(Unit{})))))))
@unsafe
def Local.Abi_codec.pairs.f16814(digit_620, result_624, param_789):
  (+scrut16821 = param_789
  Match.List(&2, Char, &2, StringResult(String), scrut16821, _ => (Done{NativeString.of_list(Series.to_list(&2, Char, Series.of_list(&2, Char, List.reverse(&2, Char, result_624))))}), +p16822 => +p16823 => (Match.List(&2, Char, &2, StringResult(String), p16823, _ => (Fail{"ADAPTER-HEX"}), +p16824 => +p16825 => ((Match.Result(&2, Big, &2, String, &2, StringResult(String), digit_620(p16822), +item16845 => ((+local16828 => (Match.Result(&2, Big, &2, String, &2, StringResult(String), digit_620(p16824), +item16843 => ((+local16831 => ((+scrut16832 = {Series.from_string(Big.to_bytes(Big.identity(NativeInt.add(NativeInt.mul(local16828, Big.of_nat(16n)), local16831)))) : (Unit -> Series<&2, Char>)}
(+scrut16836 = {Match.Maybe(&1, Tuple2<&2, &1, Char, (Unit -> Series<&2, Char>)>, &2, Char, Series.uncons(&2, Char, scrut16832), _ => (Char.from_u32(0)), +value => ((+local16835 => (Get.Tuple2.v0(&2, Char, &1, (Unit -> Series<&2, Char>), local16835)))(value))) : Char}
(+local16840 => +local16842 => (Local.Abi_codec.pairs.f16814(digit_620, local16840, local16842)))(Con{scrut16836, result_624}, p16825)))))(item16843)), +item16844 => Fail{item16844})))(item16845)), +item16846 => Fail{item16846})))))))
@unsafe
def Abi_codec.unhex(+text_619: String) -> StringResult(String):
  (+scrut16813 = {(+local16812 => (Native.choose(&2, StringResult(Big), Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(48)), Char.to_u32(local16812)), _ => (U32.is_le(Char.to_u32(local16812), Char.to_u32(Char.from_u32(57)))), _ => (False{})), _ => (Done{NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(local16812))), Big.of_nat(48n))}), _ => (Native.choose(&2, StringResult(Big), Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(97)), Char.to_u32(local16812)), _ => (U32.is_le(Char.to_u32(local16812), Char.to_u32(Char.from_u32(102)))), _ => (False{})), _ => (Done{NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(local16812))), Big.of_nat(87n))}), _ => (Fail{"ADAPTER-HEX"})))))) : Reusable(Char, StringResult(Big))}
  (+local16818 => +local16820 => (Local.Abi_codec.pairs.f16814(scrut16813, local16818, local16820)))(Nil{}, Series.to_list(&2, Char, Series.from_string(text_619))))
@unsafe
def Abi_codec.value(+typ_854: Abi.Schema.Value_type, +text_855: String) -> StringResult(Abi.Codec.Value):
  (+scrut16779 = typ_854
  Match.Abi_Schema_Value_type(&2, StringResult(Abi.Codec.Value), scrut16779, _ => (Match.Result(&2, Big, &2, String, &2, StringResult(Abi.Codec.Value), Abi_codec.number(text_855), +item16797 => ((+local16796 => (Native.choose(&2, StringResult(Abi.Codec.Value), Big.fits_int(local16796), _ => (Done{Abi.Codec.Value.Uint8{Big.identity(local16796)}}), _ => (Fail{"ADAPTER-UINT8"}))))(item16797)), +item16798 => Fail{item16798})), _ => (Match.Result(&2, Big, &2, String, &2, StringResult(Abi.Codec.Value), Abi_codec.number(text_855), +item16802 => ((+local16801 => (Done{Abi.Codec.Value.Uint256{local16801}}))(item16802)), +item16803 => Fail{item16803})), _ => (Match.Result(&2, Big, &2, String, &2, StringResult(Abi.Codec.Value), Abi_codec.number(text_855), +item16807 => ((+local16806 => (Done{Abi.Codec.Value.Address{local16806}}))(item16807)), +item16808 => Fail{item16808})), _ => ((+scrut16809 = {Unit{} : Unit}
  Native.choose(&2, StringResult(Abi.Codec.Value), NativeString.equal(text_855, "true"), _ => (Done{Abi.Codec.Value.Bool{True{}}}), _ => (Native.choose(&2, StringResult(Abi.Codec.Value), NativeString.equal(text_855, "false"), _ => (Done{Abi.Codec.Value.Bool{False{}}}), _ => (Fail{"ADAPTER-BOOL"})))))), _ => (Match.Result(&2, String, &2, String, &2, StringResult(Abi.Codec.Value), Abi_codec.unhex(text_855), +item16850 => ((+local16849 => (Done{Abi.Codec.Value.String{local16849}}))(item16850)), +item16851 => Fail{item16851}))))
@unsafe
def Abi_codec.values(+ts_869: ListOf(Abi.Schema.Value_type), +args_870: ListOf(String)) -> StringResult(ListOf(Abi.Codec.Value)):
  (+scrut16769 = {Tup2{ts_869, args_870} : TupleOf2(ListOf(Abi.Schema.Value_type), ListOf(String))}
  Match.Tuple2(&2, ListOf(Abi.Schema.Value_type), &2, ListOf(String), &2, StringResult(ListOf(Abi.Codec.Value)), scrut16769, +p16770 => +p16771 => (Match.List(&2, Abi.Schema.Value_type, &2, StringResult(ListOf(Abi.Codec.Value)), p16770, _ => (Match.List(&2, String, &2, StringResult(ListOf(Abi.Codec.Value)), p16771, _ => (Done{Nil{}}), +p16772 => +p16773 => (Fail{"ADAPTER-ARITY"}))), +p16774 => +p16775 => (Match.List(&2, String, &2, StringResult(ListOf(Abi.Codec.Value)), p16771, _ => (Fail{"ADAPTER-ARITY"}), +p16776 => +p16777 => (Match.Result(&2, Abi.Codec.Value, &2, String, &2, StringResult(ListOf(Abi.Codec.Value)), Abi_codec.value(p16774, p16776), +item16859 => ((+local16853 => (Match.Result(&2, ListOf(Abi.Codec.Value), &2, String, &2, StringResult(ListOf(Abi.Codec.Value)), Abi_codec.values(p16775, p16777), +item16857 => ((+local16856 => (Done{Con{local16853, local16856}}))(item16857)), +item16858 => Fail{item16858})))(item16859)), +item16860 => Fail{item16860}))))))))
@unsafe
def Abi_codec.hex(+text_311: String) -> String:
  String.join(SeqList.map(&2, &2, Char, String, (+local16864 => (String.concat([NativeString.pad(2n, Char.from_u32(48), Big.hex(Big.of_nat(U32.to_nat(Char.to_u32(local16864))), False{}))]))), Series.to_list(&2, Char, Series.from_string(text_311))), "")
@unsafe
def Abi_codec.error(+param_880: Abi.Codec.Error) -> String:
  (+scrut16873 = param_880
  Match.Abi_Codec_Error(&2, String, scrut16873, +p16874 => (String.append("RANGE-", Abi.Schema.type_name(p16874))), _ => ("TOO-LARGE"), _ => ("TRUNCATED"), _ => ("INVALID-BOOL"), _ => ("INVALID-OFFSET"), _ => ("NONZERO-PADDING"), _ => ("TRAILING-DATA")))
@unsafe
def Abi_codec.output(-q0: Quant, -A0: Kind(q0), +show_890: Reusable(A0, String)) -> Reusable(Result<&2, q0, Abi.Codec.Error, A0>, String):
  (+local16868 => (Match.Result(q0, A0, &2, Abi.Codec.Error, &2, String, local16868, +x => (+local16870 => (String.append("OK ", show_890(local16870))))(x), +x => (+local16872 => (String.append("ERROR ", Abi_codec.error(local16872))))(x))))
@unsafe
def Abi_codec.show_value(+param_888: Abi.Codec.Value) -> String:
  (+scrut16887 = param_888
  Match.Abi_Codec_Value(&2, String, scrut16887, +p16888 => (Big.show(p16888)), +p16889 => (Big.show(p16889)), +p16890 => (Big.show(p16890)), +p16891 => (NativeBool.show(p16891)), +p16892 => (Abi_codec.hex(p16892))))
@unsafe
def Abi_codec.main(+param_904: ListOf(String)) -> StringResult(String):
  (+scrut16746 = param_904
  Match.List(&2, String, &2, StringResult(String), scrut16746, _ => (Fail{"ADAPTER-USAGE"}), +p16747 => +p16748 => (Match.List(&2, String, &2, StringResult(String), p16748, _ => (Fail{"ADAPTER-USAGE"}), +p16749 => +p16750 => (Match.List(&2, String, &2, StringResult(String), p16750, _ => (Fail{"ADAPTER-USAGE"}), +p16751 => +p16752 => ((Match.Result(&2, ListOf(Abi.Schema.Value_type), &2, String, &2, StringResult(String), Abi_codec.types(p16751), +item16897 => ((+local16766 => ((+scrut16767 = {Unit{} : Unit}
Native.choose(&2, StringResult(String), NativeString.equal(p16749, "encode"), _ => (Match.Result(&2, ListOf(Abi.Codec.Value), &2, String, &2, StringResult(String), Abi_codec.values(local16766, p16752), +item16875 => ((+local16862 => (Done{Abi_codec.output(&2, String, Abi_codec.hex, Abi.Codec.encode(local16862))}))(item16875)), +item16876 => Fail{item16876})), _ => (Native.choose(&2, StringResult(String), NativeString.equal(p16749, "decode"), _ => ((+scrut16877 = p16752
Match.List(&2, String, &2, StringResult(String), scrut16877, _ => (Fail{"ADAPTER-USAGE"}), +p16878 => +p16879 => (Match.List(&2, String, &2, StringResult(String), p16879, _ => (Match.Result(&2, String, &2, String, &2, StringResult(String), Abi_codec.unhex(p16878), +item16893 => ((+local16882 => (Done{Abi_codec.output(&2, ListOf(Abi.Codec.Value), (+local16884 => (String.append("[", String.append(String.join(SeqList.map(&2, &2, Abi.Codec.Value, String, (+local16886 => (Abi.quote(Abi_codec.show_value(local16886)))), local16884), ","), "]")))), Abi.Codec.decode(local16766, local16882))}))(item16893)), +item16894 => Fail{item16894})), +p16895 => +p16896 => (Fail{"ADAPTER-USAGE"})))))), _ => (Fail{"ADAPTER-USAGE"})))))))(item16897)), +item16898 => Fail{item16898})))))))))
@unsafe
def Keccak_vec.digit(+c_277: Char) -> ResultOf(Keccak_vec.Error, Big):
  Native.choose(&2, ResultOf(Keccak_vec.Error, Big), Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(48)), Char.to_u32(c_277)), _ => (U32.is_le(Char.to_u32(c_277), Char.to_u32(Char.from_u32(57)))), _ => (False{})), _ => (Done{NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(c_277))), Big.of_nat(U32.to_nat(Char.to_u32(Char.from_u32(48)))))}), _ => (Native.choose(&2, ResultOf(Keccak_vec.Error, Big), Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(97)), Char.to_u32(c_277)), _ => (U32.is_le(Char.to_u32(c_277), Char.to_u32(Char.from_u32(102)))), _ => (False{})), _ => (Done{NativeInt.sub(NativeInt.add(Big.of_nat(10n), Big.of_nat(U32.to_nat(Char.to_u32(c_277)))), Big.of_nat(U32.to_nat(Char.to_u32(Char.from_u32(97)))))}), _ => (Fail{Keccak_vec.Error.Invalid_hex{}}))))
@unsafe
def Keccak_vec.alphabet() -> String:
  String.append("\u{0}\u{1}\u{2}\u{3}\u{4}\u{5}\u{6}\u{7}\u{8}\u{9}\u{a}\u{b}\u{c}\u{d}\u{e}\u{f}", String.append("\u{10}\u{11}\u{12}\u{13}\u{14}\u{15}\u{16}\u{17}\u{18}\u{19}\u{1a}\u{1b}\u{1c}\u{1d}\u{1e}\u{1f}", String.append(" !\u{22}#$%&'()*+,-./", String.append("0123456789:;<=>?", String.append("@ABCDEFGHIJKLMNO", String.append("PQRSTUVWXYZ[\u{5c}]^_", String.append("`abcdefghijklmno", String.append("pqrstuvwxyz{|}~\u{7f}", String.append("\u{80}\u{81}\u{82}\u{83}\u{84}\u{85}\u{86}\u{87}\u{88}\u{89}\u{8a}\u{8b}\u{8c}\u{8d}\u{8e}\u{8f}", String.append("\u{90}\u{91}\u{92}\u{93}\u{94}\u{95}\u{96}\u{97}\u{98}\u{99}\u{9a}\u{9b}\u{9c}\u{9d}\u{9e}\u{9f}", String.append("\u{a0}\u{a1}\u{a2}\u{a3}\u{a4}\u{a5}\u{a6}\u{a7}\u{a8}\u{a9}\u{aa}\u{ab}\u{ac}\u{ad}\u{ae}\u{af}", String.append("\u{b0}\u{b1}\u{b2}\u{b3}\u{b4}\u{b5}\u{b6}\u{b7}\u{b8}\u{b9}\u{ba}\u{bb}\u{bc}\u{bd}\u{be}\u{bf}", String.append("\u{c0}\u{c1}\u{c2}\u{c3}\u{c4}\u{c5}\u{c6}\u{c7}\u{c8}\u{c9}\u{ca}\u{cb}\u{cc}\u{cd}\u{ce}\u{cf}", String.append("\u{d0}\u{d1}\u{d2}\u{d3}\u{d4}\u{d5}\u{d6}\u{d7}\u{d8}\u{d9}\u{da}\u{db}\u{dc}\u{dd}\u{de}\u{df}", String.append("\u{e0}\u{e1}\u{e2}\u{e3}\u{e4}\u{e5}\u{e6}\u{e7}\u{e8}\u{e9}\u{ea}\u{eb}\u{ec}\u{ed}\u{ee}\u{ef}", "\u{f0}\u{f1}\u{f2}\u{f3}\u{f4}\u{f5}\u{f6}\u{f7}\u{f8}\u{f9}\u{fa}\u{fb}\u{fc}\u{fd}\u{fe}\u{ff}")))))))))))))))
@unsafe
def Local.Keccak_vec.go.f16910(acc_293, input_294):
  (+scrut16911 = {input_294(Unit{}) : Series<&2, Char>}
  Match.Series(&2, Char, &2, ResultOf(Keccak_vec.Error, String), scrut16911, _ => (Done{NativeString.of_list(Series.to_list(&2, Char, Series.of_list(&2, Char, List.reverse(&2, Char, acc_293))))}), +p16912 => +p16913 => ((+scrut16914 = {p16913(Unit{}) : Series<&2, Char>}
  Match.Series(&2, Char, &2, ResultOf(Keccak_vec.Error, String), scrut16914, _ => (Fail{Keccak_vec.Error.Odd_hex{}}), +p16915 => +p16916 => ((Match.Result(&2, Big, &2, Keccak_vec.Error, &2, ResultOf(Keccak_vec.Error, String), Keccak_vec.digit(p16912), +item16936 => ((+local16918 => (Match.Result(&2, Big, &2, Keccak_vec.Error, &2, ResultOf(Keccak_vec.Error, String), Keccak_vec.digit(p16915), +item16934 => ((+local16920 => ((+scrut16929 = {(+local16928 => (Match.Maybe(&2, Char, &2, ResultOf(Keccak_vec.Error, Char), local16928, _ => Fail{Keccak_vec.Error.Invalid_hex{}}, +x => Done{x})))((+local16923 => (SeqList.find(&2, Char, (+local16925 => (Big.is_eq(Big.of_nat(U32.to_nat(Char.to_u32(local16925))), NativeInt.add(NativeInt.mul(local16918, Big.of_nat(16n)), local16920)))), Series.to_list(&2, Char, local16923))))(Series.from_string(Keccak_vec.alphabet()))) : ResultOf(Keccak_vec.Error, Char)}
Match.Result(&2, Char, &2, Keccak_vec.Error, &2, ResultOf(Keccak_vec.Error, String), scrut16929, +item16932 => ((+local16931 => (Local.Keccak_vec.go.f16910(Con{local16931, acc_293}, p16916)))(item16932)), +item16933 => Fail{item16933}))))(item16934)), +item16935 => Fail{item16935})))(item16936)), +item16937 => Fail{item16937}))))))))
@unsafe
def Keccak_vec.decode(+text_291: String) -> ResultOf(Keccak_vec.Error, String):
  Local.Keccak_vec.go.f16910(Nil{}, Series.from_string(text_291))
@unsafe
def Keccak_vec.dispatch(+args_600: ListOf(String)) -> ResultOf(Keccak_vec.Error, String):
  (+scrut16900 = args_600
  Match.List(&2, String, &2, ResultOf(Keccak_vec.Error, String), scrut16900, _ => (Fail{Keccak_vec.Error.Usage{}}), +p16901 => +p16902 => ((+otherwise16903 = {_ => (Fail{Keccak_vec.Error.Usage{}}) : Unit -> ResultOf(Keccak_vec.Error, String)}
  Match.List.only_Con(&2, String, &2, ResultOf(Keccak_vec.Error, String), p16902, +p16904 => +p16905 => (Match.List.only_Con(&2, String, &2, ResultOf(Keccak_vec.Error, String), p16905, +p16906 => +p16907 => (Match.List.only_Nil(&2, String, &2, ResultOf(Keccak_vec.Error, String), p16907, _ => (Native.choose(&2, ResultOf(Keccak_vec.Error, String), Big.when(Bool, NativeString.equal(p16904, "hash"), _ => (True{}), _ => (NativeString.equal(p16904, "selector"))), _ => (Match.Result(&2, String, &2, Keccak_vec.Error, &2, ResultOf(Keccak_vec.Error, String), Keccak_vec.decode(p16906), +item16939 => (Done{(+local16909 => (Native.choose(&2, String, NativeString.equal(p16904, "hash"), _ => (Keccak.keccak256(local16909)), _ => (Keccak.selector(local16909)))))(item16939)}), +item16940 => Fail{item16940})), _ => (otherwise16903(Unit{})))), _ => (otherwise16903(Unit{})))), _ => (otherwise16903(Unit{})))), _ => (otherwise16903(Unit{})))))))
@unsafe
def Abi_schema.p(+typ_291: Abi.Schema.Value_type, +name_292: String) -> Abi.Schema.Parameter:
  MkAbi_Schema_Parameter{name_292, typ_291}
@unsafe
def Abi_schema.fn(+name_338: String, +inputs_339: ListOf(Abi.Schema.Parameter), +outputs_340: ListOf(Abi.Schema.Parameter), +mutability_341: Abi.Mutability) -> Abi.Schema.Function_:
  MkAbi_Schema_Function_{name_338, inputs_339, outputs_340, mutability_341}
@unsafe
def Abi_schema.uint() -> Reusable(String, Abi.Schema.Parameter):
  (+local16946 => (Abi_schema.p(Abi.Schema.Value_type.Uint256{}, local16946)))
@unsafe
def Abi_schema.address() -> Reusable(String, Abi.Schema.Parameter):
  (+local16950 => (Abi_schema.p(Abi.Schema.Value_type.Address{}, local16950)))
@unsafe
def Abi_schema.functions() -> ListOf(Abi.Schema.Function_):
  Con{Abi_schema.fn("name", Nil{}, Con{Abi_schema.p(Abi.Schema.Value_type.String{}, ""), Nil{}}, Abi.Mutability.View{}), Con{Abi_schema.fn("symbol", Nil{}, Con{Abi_schema.p(Abi.Schema.Value_type.String{}, ""), Nil{}}, Abi.Mutability.View{}), Con{Abi_schema.fn("decimals", Nil{}, Con{Abi_schema.p(Abi.Schema.Value_type.Uint8{}, ""), Nil{}}, Abi.Mutability.View{}), Con{Abi_schema.fn("totalSupply", Nil{}, Con{Abi_schema.uint()(""), Nil{}}, Abi.Mutability.View{}), Con{Abi_schema.fn("balanceOf", Con{Abi_schema.address()("owner"), Nil{}}, Con{Abi_schema.uint()(""), Nil{}}, Abi.Mutability.View{}), Con{Abi_schema.fn("allowance", Con{Abi_schema.address()("owner"), Con{Abi_schema.address()("spender"), Nil{}}}, Con{Abi_schema.uint()(""), Nil{}}, Abi.Mutability.View{}), Con{Abi_schema.fn("transfer", Con{Abi_schema.address()("to"), Con{Abi_schema.uint()("value"), Nil{}}}, Con{Abi_schema.p(Abi.Schema.Value_type.Bool{}, ""), Nil{}}, Abi.Mutability.Nonpayable{}), Con{Abi_schema.fn("approve", Con{Abi_schema.address()("spender"), Con{Abi_schema.uint()("value"), Nil{}}}, Con{Abi_schema.p(Abi.Schema.Value_type.Bool{}, ""), Nil{}}, Abi.Mutability.Nonpayable{}), Con{Abi_schema.fn("transferFrom", Con{Abi_schema.address()("from"), Con{Abi_schema.address()("to"), Con{Abi_schema.uint()("value"), Nil{}}}}, Con{Abi_schema.p(Abi.Schema.Value_type.Bool{}, ""), Nil{}}, Abi.Mutability.Nonpayable{}), Nil{}}}}}}}}}}
@unsafe
def Abi_schema.indexed(+parameter_345: Abi.Schema.Parameter) -> Abi.Schema.Event_parameter:
  MkAbi_Schema_Event_parameter{parameter_345, True{}}
@unsafe
def Abi_schema.data(+parameter_348: Abi.Schema.Parameter) -> Abi.Schema.Event_parameter:
  MkAbi_Schema_Event_parameter{parameter_348, False{}}
@unsafe
def Abi_schema.events() -> ListOf(TupleOf2(String, ListOf(Abi.Schema.Event_parameter))):
  Con{Tup2{"Transfer", Con{Abi_schema.indexed(Abi_schema.address()("from")), Con{Abi_schema.indexed(Abi_schema.address()("to")), Con{Abi_schema.data(Abi_schema.uint()("value")), Nil{}}}}}, Con{Tup2{"Approval", Con{Abi_schema.indexed(Abi_schema.address()("owner")), Con{Abi_schema.indexed(Abi_schema.address()("spender")), Con{Abi_schema.data(Abi_schema.uint()("value")), Nil{}}}}}, Nil{}}}
@unsafe
def Abi_schema.erc20() -> ListOf(Abi.Schema.Declaration):
  List.append(&2, Abi.Schema.Declaration, Con{Abi.Schema.Declaration.Constructor{Nil{}, False{}}, SeqList.map(&2, &2, Abi.Schema.Function_, Abi.Schema.Declaration, (+local16942 => (Abi.Schema.Declaration.Function{local16942})), Abi_schema.functions())}, SeqList.map(&2, &2, TupleOf2(String, ListOf(Abi.Schema.Event_parameter)), Abi.Schema.Declaration, (+local16952 => ((+scrut16953 = local16952
  Match.Tuple2(&2, String, &2, ListOf(Abi.Schema.Event_parameter), &2, Abi.Schema.Declaration, scrut16953, +p16954 => +p16955 => (Abi.Schema.Declaration.Event{p16954, p16955, False{}}))))), Abi_schema.events()))
@unsafe
def Abi_schema.signatures() -> ListOf(TupleOf2(String, String)):
  SeqList.map(&2, &2, Abi.Schema.Function_, TupleOf2(String, String), (+local16957 => ((+scrut16958 = {Abi.Schema.function_signature(local16957) : String}
  Tup2{scrut16958, Abi.quote(Keccak.selector(scrut16958))}))), Abi_schema.functions())
@unsafe
def Abi_schema.object_(+rows_426: ListOf(TupleOf2(String, String))) -> String:
  String.append("{", String.append(String.join(SeqList.map(&2, &2, TupleOf2(String, String), String, (+local16960 => ((+scrut16961 = local16960
  Match.Tuple2(&2, String, &2, String, &2, String, scrut16961, +p16962 => +p16963 => (String.append(Abi.quote(p16962), String.append(":", p16963))))))), rows_426), ","), "}"))
@unsafe
def Abi_schema.topics() -> ListOf(TupleOf2(String, String)):
  SeqList.map(&2, &2, TupleOf2(String, ListOf(Abi.Schema.Event_parameter)), TupleOf2(String, String), (+local16965 => ((+scrut16966 = local16965
  Match.Tuple2(&2, String, &2, ListOf(Abi.Schema.Event_parameter), &2, TupleOf2(String, String), scrut16966, +p16967 => +p16968 => (Tup2{p16967, Abi.quote(String.append("0x", Keccak.keccak256(Abi.Schema.event_signature(p16967, p16968))))}))))), Abi_schema.events())
@unsafe
def Abi_schema.edge() -> ListOf(Abi.Schema.Declaration):
  Con{Abi.Schema.Declaration.Constructor{Con{Abi_schema.address()("owner"), Nil{}}, True{}}, Con{Abi.Schema.Declaration.Function{Abi_schema.fn("write", Con{Abi_schema.p(Abi.Schema.Value_type.Uint8{}, "a"), Con{Abi_schema.uint()("b"), Con{Abi_schema.address()("c"), Con{Abi_schema.p(Abi.Schema.Value_type.Bool{}, "d"), Con{Abi_schema.p(Abi.Schema.Value_type.String{}, "line\u{a}\u{22}\u{5c}\u{1}"), Nil{}}}}}}, Nil{}, Abi.Mutability.Payable{})}, Con{Abi.Schema.Declaration.Function{Abi_schema.fn("pair", Nil{}, Con{Abi_schema.address()("owner"), Con{Abi_schema.p(Abi.Schema.Value_type.Uint8{}, "count"), Nil{}}}, Abi.Mutability.View{})}, Con{Abi.Schema.Declaration.Error{"Rejected", Con{Abi_schema.p(Abi.Schema.Value_type.Bool{}, "reason"), Con{Abi_schema.address()("caller"), Nil{}}}}, Con{Abi.Schema.Declaration.Event{"Anonymous", Con{Abi_schema.data(Abi_schema.p(Abi.Schema.Value_type.String{}, "text")), Con{Abi_schema.indexed(Abi_schema.uint()("key")), Nil{}}}, True{}}, Con{Abi.Schema.Declaration.Fallback{True{}}, Con{Abi.Schema.Declaration.Fallback{False{}}, Nil{}}}}}}}}
@unsafe
def Abi_schema.legacy_errors() -> ListOf(Abi.Custom_error):
  Con{MkAbi_Custom_error{"Stopped", Nil{}}, Con{MkAbi_Custom_error{"Bounds", Con{"actual", Con{"limit", Nil{}}}}, Nil{}}}
@unsafe
def Abi_schema.legacy_entries() -> ListOf(Abi.Entry):
  Con{MkAbi_Entry{"read", Nil{}, Abi.Mutability.View{}}, Con{MkAbi_Entry{"write", Con{"amount", Con{"to", Nil{}}}, Abi.Mutability.Nonpayable{}}, Con{MkAbi_Entry{"pay", Con{"line\u{a}\u{22}\u{5c}\u{1}", Nil{}}, Abi.Mutability.Payable{}}, Nil{}}}}
@unsafe
def Abi_schema.invariant() -> Abi.Schema.Function_:
  Abi_schema.fn("same", Con{Abi_schema.address()("before"), Con{Abi_schema.uint()("value"), Nil{}}}, Con{Abi_schema.uint()(""), Nil{}}, Abi.Mutability.View{})
@unsafe
def Abi_schema.changed() -> Abi.Schema.Function_:
  Abi_schema.fn("same", Con{Abi_schema.address()("after"), Con{Abi_schema.uint()("renamed"), Nil{}}}, Nil{}, Abi.Mutability.Payable{})
@unsafe
def Abi_schema.output() -> String:
  Abi_schema.object_(Con{Tup2{"erc20", Abi.Schema.print(Abi_schema.erc20())}, Con{Tup2{"selectors", Abi_schema.object_(Abi_schema.signatures())}, Con{Tup2{"topics", Abi_schema.object_(Abi_schema.topics())}, Con{Tup2{"edge", Abi.Schema.print(Abi_schema.edge())}, Con{Tup2{"empty", Abi.quote(Abi.Schema.print(Nil{}))}, Con{Tup2{"legacy", Abi.quote(Abi.print(Some{Abi_schema.legacy_errors()}, Some{True{}}, Abi_schema.legacy_entries()))}, Con{Tup2{"legacy_empty", Abi.quote(Abi.print(None{}, None{}, Nil{}))}, Con{Tup2{"legacy_signatures", Abi_schema.object_(SeqList.map(&2, &2, Abi.Entry, TupleOf2(String, String), (+local16970 => (Tup2{Get.Abi.Entry.name(local16970), Abi.quote(Abi.signature(local16970))})), Abi_schema.legacy_entries()))}, Con{Tup2{"error_signatures", Abi_schema.object_(SeqList.map(&2, &2, Abi.Custom_error, TupleOf2(String, String), (+local16972 => (Tup2{Get.Abi.Custom_error.error_name(local16972), Abi.quote(Abi.error_signature(local16972))})), Abi_schema.legacy_errors()))}, Con{Tup2{"invariant", Abi.quote(Abi.Schema.function_signature(Abi_schema.invariant()))}, Con{Tup2{"changed", Abi.quote(Abi.Schema.function_signature(Abi_schema.changed()))}, Nil{}}}}}}}}}}}})
@unsafe
def Asm_compact.block(+_opt__310: OptionOf(Bool), +_opt__309: OptionOf(ListOf(Asm.Instruction)), +label_277: String, +ending_278: Asm.Ending) -> Asm.Block:
  (+scrut16981 = {(+scrut16979 = _opt__310
  Match.Maybe(&2, Bool, &2, Bool, scrut16979, _ => (False{}), +p16980 => (p16980))) : Bool}
  (+scrut16984 = {(+scrut16982 = _opt__309
  Match.Maybe(&2, ListOf(Asm.Instruction), &2, ListOf(Asm.Instruction), scrut16982, _ => (Nil{}), +p16983 => (p16983))) : ListOf(Asm.Instruction)}
  MkAsm_Block{label_277, scrut16981, Big.zero(), scrut16984, ending_278}))
@unsafe
def Asm_compact.padding(+count_313: Big) -> ListOf(Asm.Block):
  SeqList.init(&2, Asm.Block, count_313, (+local16986 => (Asm_compact.block(None{}, None{}, String.append("padding", Big.show(local16986)), Asm.Ending.Halt{Asm.Halt.Invalid{}}))))
@unsafe
def Asm_compact.jump(+width_383: Big, +count_384: Big) -> ListOf(Asm.Block):
  List.append(&2, Asm.Block, Con{Asm_compact.block(None{}, None{}, "start", Asm.Ending.Goto{width_383, "finish"}), Asm_compact.padding(count_384)}, Con{Asm_compact.block(Some{True{}}, None{}, "finish", Asm.Ending.Halt{Asm.Halt.Stop{}}), Nil{}})
@unsafe
def Asm_compact.observe() -> Reusable(Asm.Result(Asm), Asm.Result(TupleOf3(String, ListOf(TupleOf2(String, Big)), ListOf(Asm.Height)))):
  (+local16995 => (Match.Result(&2, Asm, &2, Asm.Error, &2, Asm.Result(TupleOf3(String, ListOf(TupleOf2(String, Big)), ListOf(Asm.Height))), local16995, +item16998 => (Done{(+local16997 => (Tup3{Asm.hex(local16997), Asm.labels(local16997), Asm.heights(local16997)}))(item16998)}), +item16999 => Fail{item16999})))
@unsafe
def Asm_compact.check(+name_413: String, +wide_414: ListOf(Asm.Block), +narrow_415: ListOf(Asm.Block)) -> Big:
  (+scrut16991 = {Match.Result(&2, Asm, &2, Asm.Error, &2, Asm.Result(Asm), Asm.assemble(wide_414), +item16989 => ((+local16988 => (Native.choose(&2, Asm.Result(Asm), Big.is_le(Big.of_nat(String.length(Asm.hex(local16988))), Big.of_nat(510n)), _ => (Asm.assemble(narrow_415)), _ => (Done{local16988}))))(item16989)), +item16990 => Fail{item16990}) : Asm.Result(Asm)}
  Native.choose(&2, Big, Equal.Asm_Result_TupleOf3_String__ListOf_TupleOf2_String__Big____ListOf_Asm_Height___(Asm_compact.observe()(Asm.assemble_compact(wide_414)), Asm_compact.observe()(scrut16991)), _ => (Big.one()), _ => ((+discard17084 = {Unit{} : Unit}
  Big.zero()))))
@unsafe
def Asm_compact.branch(+width_387: Big, +count_388: Big) -> ListOf(Asm.Block):
  List.append(&2, Asm.Block, Con{Asm_compact.block(None{}, Some{Con{Asm.Instruction.Push{""}, Nil{}}}, "start", Asm.Ending.Branch{width_387, "yes", "no"}), Asm_compact.padding(count_388)}, Con{Asm_compact.block(Some{True{}}, None{}, "yes", Asm.Ending.Halt{Asm.Halt.Stop{}}), Con{Asm_compact.block(Some{True{}}, None{}, "no", Asm.Ending.Halt{Asm.Halt.Stop{}}), Nil{}}})
@unsafe
def Asm_compact.payload(+width_492: Big, +count_493: Big, +bytes_494: Big) -> ListOf(Asm.Block):
  List.append(&2, Asm.Block, Con{Asm_compact.block(None{}, Some{Con{Asm.Instruction.Push{NativeString.repeat(Big.to_nat(NativeInt.mul(Big.of_nat(2n), bytes_494)), Char.from_u32(97))}, Con{Asm.Instruction.Op{"POP"}, Nil{}}}}, "start", Asm.Ending.Goto{width_492, "finish"}), Asm_compact.padding(count_493)}, Con{Asm_compact.block(Some{True{}}, None{}, "finish", Asm.Ending.Halt{Asm.Halt.Stop{}}), Nil{}})
@unsafe
def Asm_compact.mixed(+width_489: Big) -> ListOf(Asm.Block):
  Con{Asm_compact.block(None{}, None{}, "start", Asm.Ending.Goto{Big.of_nat(3n), "middle"}), Con{Asm_compact.block(Some{True{}}, None{}, "middle", Asm.Ending.Goto{width_489, "finish"}), Con{Asm_compact.block(Some{True{}}, None{}, "finish", Asm.Ending.Halt{Asm.Halt.Stop{}}), Nil{}}}}
@unsafe
def Asm_compact.output() -> String:
  (+scrut17088 = {SeqList.fold(&2, &2, Big, Big, (+local16974 => +local16976 => (NativeInt.add(NativeInt.add(local16974, Asm_compact.check(String.append("jump-", Big.show(local16976)), Asm_compact.jump(Big.of_nat(2n), local16976), Asm_compact.jump(Big.one(), local16976))), Asm_compact.check(String.append("branch-", Big.show(local16976)), Asm_compact.branch(Big.of_nat(2n), local16976), Asm_compact.branch(Big.one(), local16976))))), SeqList.init(&2, Big, Big.of_nat(271n), (+local17087 => (local17087))), Big.zero()) : Big}
  ((+scrut17096 = {SeqList.fold(&2, &2, Big, Big, (+local17090 => +local17092 => (NativeInt.add(NativeInt.add(local17090, Asm_compact.check(String.append("payload-255-", Big.show(local17092)), Asm_compact.payload(Big.of_nat(2n), NativeInt.sub(Big.of_nat(247n), local17092), local17092), Asm_compact.payload(Big.one(), NativeInt.sub(Big.of_nat(247n), local17092), local17092))), Asm_compact.check(String.append("payload-256-", Big.show(local17092)), Asm_compact.payload(Big.of_nat(2n), NativeInt.sub(Big.of_nat(248n), local17092), local17092), Asm_compact.payload(Big.one(), NativeInt.sub(Big.of_nat(248n), local17092), local17092))))), SeqList.init(&2, Big, Big.of_nat(33n), (+local17095 => (local17095))), scrut17088) : Big}
(+scrut17097 = {Asm_compact.block(None{}, None{}, "stop", Asm.Ending.Halt{Asm.Halt.Stop{}}) : Asm.Block}
((+scrut17126 = {Con{(+local17099 => +local17101 => (Tup3{local17099, local17101, local17101}))("empty", Nil{}), Con{(+local17103 => +local17105 => (Tup3{local17103, local17105, local17105}))("unknown-opcode", Con{MkAsm_Block{Get.Asm.Block.label(scrut17097), Get.Asm.Block.destination(scrut17097), Get.Asm.Block.stack_in(scrut17097), Con{Asm.Instruction.Op{"NOPE"}, Nil{}}, Get.Asm.Block.ending(scrut17097)}, Nil{}}), Con{(+local17107 => +local17109 => (Tup3{local17107, local17109, local17109}))("duplicate", Con{scrut17097, Con{scrut17097, Nil{}}}), Con{Tup3{"missing-label", Con{Asm_compact.block(None{}, None{}, "start", Asm.Ending.Goto{Big.of_nat(2n), "missing"}), Nil{}}, Con{Asm_compact.block(None{}, None{}, "start", Asm.Ending.Goto{Big.one(), "missing"}), Nil{}}}, Con{Tup3{"not-destination", Con{Asm_compact.block(None{}, None{}, "start", Asm.Ending.Goto{Big.of_nat(2n), "stop"}), Con{scrut17097, Nil{}}}, Con{Asm_compact.block(None{}, None{}, "start", Asm.Ending.Goto{Big.one(), "stop"}), Con{scrut17097, Nil{}}}}, Con{(+local17111 => +local17113 => (Tup3{local17111, local17113, local17113}))("entry-height", Con{MkAsm_Block{Get.Asm.Block.label(scrut17097), Get.Asm.Block.destination(scrut17097), Big.one(), Get.Asm.Block.body(scrut17097), Get.Asm.Block.ending(scrut17097)}, Nil{}}), Con{(+local17115 => +local17117 => (Tup3{local17115, local17117, local17117}))("invalid-width", Con{Asm_compact.block(Some{True{}}, None{}, "start", Asm.Ending.Goto{Big.zero(), "start"}), Nil{}}), Con{(+local17119 => +local17121 => (Tup3{local17119, local17121, local17121}))("underflow", Con{MkAsm_Block{Get.Asm.Block.label(scrut17097), Get.Asm.Block.destination(scrut17097), Get.Asm.Block.stack_in(scrut17097), Con{Asm.Instruction.Op{"POP"}, Nil{}}, Get.Asm.Block.ending(scrut17097)}, Nil{}}), Con{(+local17123 => +local17125 => (Tup3{local17123, local17125, local17125}))("invalid-next", Con{Asm_compact.block(None{}, None{}, "start", Asm.Ending.Next{"missing"}), Con{scrut17097, Nil{}}}), Con{Tup3{"mixed", Asm_compact.mixed(Big.of_nat(2n)), Asm_compact.mixed(Big.one())}, Nil{}}}}}}}}}}} : ListOf(TupleOf3(String, ListOf(Asm.Block), ListOf(Asm.Block)))}
(+scrut17135 = {SeqList.fold(&2, &2, TupleOf3(String, ListOf(Asm.Block), ListOf(Asm.Block)), Big, (+local17128 => +local17130 => ((+scrut17131 = local17130
Match.Tuple3(&2, String, &2, ListOf(Asm.Block), &2, ListOf(Asm.Block), &2, Big, scrut17131, +p17132 => +p17133 => +p17134 => (NativeInt.add(local17128, Asm_compact.check(p17132, p17133, p17134))))))), scrut17126, scrut17096) : Big}
String.concat(["ASM-COMPACT cases=", Big.show(scrut17135), " OK\u{a}"]))))))))
@unsafe
def Asm_cases.block(+_opt__310: OptionOf(Bool), +_opt__309: OptionOf(Big), +label_291: String, +body_292: ListOf(Asm.Instruction), +ending_293: Asm.Ending) -> Asm.Block:
  (+scrut17143 = {(+scrut17141 = _opt__310
  Match.Maybe(&2, Bool, &2, Bool, scrut17141, _ => (False{}), +p17142 => (p17142))) : Bool}
  (+scrut17146 = {(+scrut17144 = _opt__309
  Match.Maybe(&2, Big, &2, Big, scrut17144, _ => (Big.zero()), +p17145 => (p17145))) : Big}
  MkAsm_Block{label_291, scrut17143, scrut17146, body_292, ending_293}))
@unsafe
def Asm_cases.stop(+label_313: String, +body_314: ListOf(Asm.Instruction)) -> Asm.Block:
  Asm_cases.block(None{}, None{}, label_313, body_314, Asm.Ending.Halt{Asm.Halt.Stop{}})
@unsafe
def Asm_cases.target(+_opt__389: OptionOf(Big), +label_388: String) -> Asm.Block:
  (+scrut17150 = {(+scrut17148 = _opt__389
  Match.Maybe(&2, Big, &2, Big, scrut17148, _ => (Big.zero()), +p17149 => (p17149))) : Big}
  Asm_cases.block(Some{True{}}, Some{scrut17150}, label_388, Nil{}, Asm.Ending.Halt{Asm.Halt.Stop{}}))
@unsafe
def Asm_cases.zeros(+n_317: Big) -> ListOf(Asm.Instruction):
  SeqList.init(&2, Asm.Instruction, n_317, (+local17152 => (Asm.Instruction.Push{""})))
@unsafe
def Asm_cases.report(+name_469: String, +good_470: Bool, +detail_471: String) -> Bool:
  (+discard17185 = {Unit{} : Unit}
  good_470)
@unsafe
def Asm_cases.rejection(+name_510: String, +program_511: ListOf(Asm.Block), +expected_512: String) -> Bool:
  (+local17182 => (Match.Result(&2, Asm, &2, Asm.Error, &2, Bool, local17182, +x => (+local17184 => (Asm_cases.report(name_510, False{}, String.append("accepted; want=", expected_512))))(x), +x => (+local17187 => ((+scrut17188 = {Asm.error_text(local17187) : String}
  Asm_cases.report(name_510, NativeString.equal(scrut17188, expected_512), scrut17188))))(x))))(Asm.assemble(program_511))
@unsafe
def Asm_cases.ref20() -> ListOf(Asm.Block):
  List.append(&2, Asm.Block, Con{Asm_cases.block(None{}, None{}, "write", Con{Asm.Instruction.Push{"2a"}, Con{Asm.Instruction.Push{""}, Con{Asm.Instruction.Op{"SSTORE"}, Nil{}}}}, Asm.Ending.Goto{Big.one(), "read"}), Nil{}}, List.append(&2, Asm.Block, SeqList.init(&2, Asm.Block, Big.of_nat(4n), (+local17191 => (Asm_cases.block(None{}, None{}, String.append("guard", Big.show(local17191)), Nil{}, Asm.Ending.Halt{Asm.Halt.Invalid{}})))), Con{Asm_cases.block(Some{True{}}, None{}, "read", Con{Asm.Instruction.Push{""}, Con{Asm.Instruction.Op{"SLOAD"}, Con{Asm.Instruction.Push{""}, Con{Asm.Instruction.Op{"MSTORE"}, Con{Asm.Instruction.Push{"20"}, Con{Asm.Instruction.Push{""}, Nil{}}}}}}}, Asm.Ending.Halt{Asm.Halt.Return{}}), Nil{}}))
@unsafe
def Asm_cases.diamond() -> ListOf(Asm.Block):
  Con{Asm_cases.block(None{}, None{}, "entry", Con{Asm.Instruction.Push{"01"}, Nil{}}, Asm.Ending.Branch{Big.one(), "yes", "no"}), Con{Asm_cases.block(Some{True{}}, None{}, "yes", Con{Asm.Instruction.Push{"2a"}, Nil{}}, Asm.Ending.Goto{Big.one(), "join"}), Con{Asm_cases.block(Some{True{}}, None{}, "no", Con{Asm.Instruction.Push{"2b"}, Nil{}}, Asm.Ending.Next{"join"}), Con{Asm_cases.block(Some{True{}}, Some{Big.one()}, "join", Con{Asm.Instruction.Op{"POP"}, Nil{}}, Asm.Ending.Halt{Asm.Halt.Stop{}}), Nil{}}}}}
@unsafe
def Asm_cases.loop() -> ListOf(Asm.Block):
  Con{Asm_cases.block(Some{True{}}, None{}, "loop", Con{Asm.Instruction.Push{"01"}, Nil{}}, Asm.Ending.Branch{Big.of_nat(2n), "loop", "done"}), Con{Asm_cases.target(None{}, "done"), Nil{}}}
@unsafe
def Asm_cases.blocks_of(+p_538: Asm) -> Big:
  Big.of_nat(List.length(&2, Asm.Height, Asm.heights(p_538)))
@unsafe
def Asm_cases.acceptance(+name_545: String, +program_546: ListOf(Asm.Block), +expected_547: String) -> TupleOf2(Bool, Big):
  (+local17203 => (Match.Result(&2, Asm, &2, Asm.Error, &2, TupleOf2(Bool, Big), local17203, +x => (+local17205 => (Tup2{Asm_cases.report(name_545, NativeString.equal(Asm.hex(local17205), expected_547), Native.choose(&2, String, Big.is_lt(Big.of_nat(160n), Big.of_nat(String.length(expected_547))), _ => (String.append("bytes=", Big.show(Big.shift_right(Big.unsigned(63n, Big.of_nat(String.length(Asm.hex(local17205)))), Big.to_nat(Big.unsigned(6n, Big.one())))))), _ => (Asm.hex(local17205)))), Asm_cases.blocks_of(local17205)}))(x), +x => (+local17207 => (Tup2{Asm_cases.report(name_545, False{}, Asm.error_text(local17207)), Big.zero()}))(x))))(Asm.assemble(program_546))
@unsafe
def Asm_cases.record(+p_541: Asm) -> ListOf(TupleOf3(Big, Big, Big)):
  SeqList.map(&2, &2, Asm.Height, TupleOf3(Big, Big, Big), (+local17223 => (Tup3{Get.Asm.Height.incoming(local17223), Get.Asm.Height.outgoing(local17223), Get.Asm.Height.peak(local17223)})), Asm.heights(p_541))
@unsafe
def Asm_cases.suite(+param_595: Unit) -> TupleOf4(Big, Big, Big, Big):
  (+scrut17138 = param_595
  ((+scrut17153 = {Con{Tup3{"empty", Nil{}, "EMPTY-PROGRAM"}, Con{Tup3{"empty-label", Con{Asm_cases.stop("", Nil{}), Nil{}}, "EMPTY-LABEL"}, Con{Tup3{"duplicate", Con{Asm_cases.stop("x", Nil{}), Con{Asm_cases.stop("x", Nil{}), Nil{}}}, "DUPLICATE-LABEL x"}, Con{Tup3{"entry", Con{Asm_cases.block(None{}, Some{Big.one()}, "x", Nil{}, Asm.Ending.Halt{Asm.Halt.Stop{}}), Nil{}}, "ENTRY-HEIGHT 1"}, Con{Tup3{"height-negative", Con{Asm_cases.stop("x", Nil{}), Con{Asm_cases.target(Some{Big.neg(Big.of_nat(1n))}, "y"), Nil{}}}, "INVALID-HEIGHT y -1"}, Con{Tup3{"height-large", Con{Asm_cases.stop("x", Nil{}), Con{Asm_cases.target(Some{Big.of_nat(1025n)}, "y"), Nil{}}}, "INVALID-HEIGHT y 1025"}, Con{Tup3{"add-underflow", Con{Asm_cases.stop("x", Con{Asm.Instruction.Push{""}, Con{Asm.Instruction.Op{"ADD"}, Nil{}}}), Nil{}}, "UNDERFLOW x ADD got=1 need=2"}, Con{Tup3{"sstore-underflow", Con{Asm_cases.stop("x", Con{Asm.Instruction.Push{""}, Con{Asm.Instruction.Op{"SSTORE"}, Nil{}}}), Nil{}}, "UNDERFLOW x SSTORE got=1 need=2"}, Con{Tup3{"dup-underflow", Con{Asm_cases.stop("x", Con{Asm.Instruction.Dup{Big.one()}, Nil{}}), Nil{}}, "UNDERFLOW x DUP1 got=0 need=1"}, Con{Tup3{"swap-underflow", Con{Asm_cases.stop("x", Con{Asm.Instruction.Push{""}, Con{Asm.Instruction.Swap{Big.one()}, Nil{}}}), Nil{}}, "UNDERFLOW x SWAP1 got=1 need=2"}, Con{Tup3{"push-overflow", Con{Asm_cases.stop("x", Asm_cases.zeros(Big.of_nat(1025n))), Nil{}}, "OVERFLOW x PUSH0 got=1025"}, Con{Tup3{"dup-overflow", Con{Asm_cases.stop("x", List.append(&2, Asm.Instruction, Asm_cases.zeros(Big.of_nat(1024n)), Con{Asm.Instruction.Dup{Big.one()}, Nil{}})), Nil{}}, "OVERFLOW x DUP1 got=1025"}, Con{Tup3{"goto-overflow", Con{Asm_cases.block(None{}, None{}, "x", Asm_cases.zeros(Big.of_nat(1024n)), Asm.Ending.Goto{Big.one(), "y"}), Con{Asm_cases.target(Some{Big.of_nat(1024n)}, "y"), Nil{}}}, "OVERFLOW x PUSH-label got=1025"}, Con{Tup3{"branch-overflow", Con{Asm_cases.block(None{}, None{}, "x", Asm_cases.zeros(Big.of_nat(1024n)), Asm.Ending.Branch{Big.one(), "y", "y"}), Con{Asm_cases.target(Some{Big.of_nat(1023n)}, "y"), Nil{}}}, "OVERFLOW x PUSH-label got=1025"}, Con{Tup3{"branch-underflow", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Branch{Big.one(), "y", "y"}), Con{Asm_cases.target(None{}, "y"), Nil{}}}, "UNDERFLOW x JUMPI got=1 need=2"}, Con{Tup3{"return-underflow", Con{Asm_cases.block(None{}, None{}, "x", Con{Asm.Instruction.Push{""}, Nil{}}, Asm.Ending.Halt{Asm.Halt.Return{}}), Nil{}}, "UNDERFLOW x RETURN got=1 need=2"}, Con{Tup3{"revert-underflow", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Halt{Asm.Halt.Revert{}}), Nil{}}, "UNDERFLOW x REVERT got=0 need=2"}, Con{Tup3{"selfdestruct-underflow", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Halt{Asm.Halt.Selfdestruct{}}), Nil{}}, "UNDERFLOW x SELFDESTRUCT got=0 need=1"}, Con{Tup3{"unknown-label", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Goto{Big.one(), "y"}), Nil{}}, "UNKNOWN-LABEL y"}, Con{Tup3{"not-destination", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Goto{Big.one(), "y"}), Con{Asm_cases.stop("y", Nil{}), Nil{}}}, "NOT-DESTINATION y"}, Con{Tup3{"goto-height", Con{Asm_cases.block(None{}, None{}, "x", Con{Asm.Instruction.Push{""}, Nil{}}, Asm.Ending.Goto{Big.one(), "y"}), Con{Asm_cases.target(None{}, "y"), Nil{}}}, "HEIGHT-MISMATCH x y got=1 want=0"}, Con{Tup3{"branch-yes-height", Con{Asm_cases.block(None{}, None{}, "x", Con{Asm.Instruction.Push{""}, Nil{}}, Asm.Ending.Branch{Big.one(), "y", "z"}), Con{Asm_cases.target(Some{Big.one()}, "y"), Con{Asm_cases.target(None{}, "z"), Nil{}}}}, "HEIGHT-MISMATCH x y got=0 want=1"}, Con{Tup3{"branch-no-height", Con{Asm_cases.block(None{}, None{}, "x", Con{Asm.Instruction.Push{""}, Nil{}}, Asm.Ending.Branch{Big.one(), "y", "z"}), Con{Asm_cases.target(None{}, "y"), Con{Asm_cases.target(Some{Big.one()}, "z"), Nil{}}}}, "HEIGHT-MISMATCH x z got=0 want=1"}, Con{Tup3{"next-height", Con{Asm_cases.block(None{}, None{}, "x", Con{Asm.Instruction.Push{""}, Nil{}}, Asm.Ending.Next{"y"}), Con{Asm_cases.target(None{}, "y"), Nil{}}}, "HEIGHT-MISMATCH x y got=1 want=0"}, Con{Tup3{"next-order", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Next{"z"}), Con{Asm_cases.stop("y", Nil{}), Con{Asm_cases.stop("z", Nil{}), Nil{}}}}, "INVALID-NEXT x z"}, Con{Tup3{"next-last", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Next{"x"}), Nil{}}, "INVALID-NEXT x x"}, Con{Tup3{"unreachable-underflow", Con{Asm_cases.stop("x", Nil{}), Con{Asm_cases.stop("y", Con{Asm.Instruction.Op{"ADD"}, Nil{}}), Nil{}}}, "UNDERFLOW y ADD got=0 need=2"}, Con{Tup3{"clz", Con{Asm_cases.stop("x", Con{Asm.Instruction.Op{"CLZ"}, Nil{}}), Nil{}}, "UNKNOWN-OPCODE CLZ"}, Con{Tup3{"opcode-case", Con{Asm_cases.stop("x", Con{Asm.Instruction.Op{"add"}, Nil{}}), Nil{}}, "UNKNOWN-OPCODE add"}, Con{Tup3{"opcode-push", Con{Asm_cases.stop("x", Con{Asm.Instruction.Op{"PUSH0"}, Nil{}}), Nil{}}, "UNKNOWN-OPCODE PUSH0"}, Con{Tup3{"label-width-small", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Goto{Big.zero(), "x"}), Nil{}}, "INVALID-WIDTH 0"}, Con{Tup3{"label-width-large", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Branch{Big.of_nat(33n), "x", "x"}), Nil{}}, "INVALID-WIDTH 33"}, Con{Tup3{"label-overflow", Con{Asm_cases.block(None{}, None{}, "x", Asm_cases.zeros(Big.of_nat(253n)), Asm.Ending.Goto{Big.one(), "y"}), Con{Asm_cases.target(Some{Big.of_nat(253n)}, "y"), Nil{}}}, "LABEL-OVERFLOW y PUSH1"}, Nil{}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}} : ListOf(TupleOf3(String, ListOf(Asm.Block), String))}
(+scrut17161 = {(+local17156 => (SeqList.mapi(&2, &2, String, TupleOf3(String, ListOf(Asm.Block), String), (+local17158 => +local17160 => (Tup3{String.append("push-bad-", Big.show(local17158)), Con{Asm_cases.stop("x", Con{Asm.Instruction.Push{local17160}, Nil{}}), Nil{}}, String.append("INVALID-PUSH ", local17160)})), local17156)))(Con{"0", Con{"gg", Con{"AA", Con{"0x00", Con{NativeString.repeat(Big.to_nat(Big.of_nat(66n)), Char.from_u32(48)), Nil{}}}}}}) : ListOf(TupleOf3(String, ListOf(Asm.Block), String))}
((+scrut17167 = {(+local17164 => (List.concat(&2, TupleOf3(String, ListOf(Asm.Block), String), SeqList.map(&2, &2, Big, ListOf(TupleOf3(String, ListOf(Asm.Block), String)), (+local17166 => (Con{Tup3{String.append("dup-bad-", Big.show(local17166)), Con{Asm_cases.stop("x", Con{Asm.Instruction.Dup{local17166}, Nil{}}), Nil{}}, String.concat(["INVALID-DEPTH DUP ", Big.show(local17166)])}, Con{Tup3{String.append("swap-bad-", Big.show(local17166)), Con{Asm_cases.stop("x", Con{Asm.Instruction.Swap{local17166}, Nil{}}), Nil{}}, String.concat(["INVALID-DEPTH SWAP ", Big.show(local17166)])}, Nil{}}})), local17164))))(Con{Big.neg(Big.of_nat(1n)), Con{Big.zero(), Con{Big.of_nat(17n), Con{Big.pred(Big.shift_left(Big.one(), 62n)), Nil{}}}}}) : ListOf(TupleOf3(String, ListOf(Asm.Block), String))}
((+scrut17173 = {(+local17170 => (SeqList.map(&2, &2, String, TupleOf3(String, ListOf(Asm.Block), String), (+local17172 => (Tup3{String.append("body-", local17172), Con{Asm_cases.stop("x", Con{Asm.Instruction.Op{local17172}, Nil{}}), Nil{}}, String.append("CONTROL-IN-BODY ", local17172)})), local17170)))(Con{"STOP", Con{"JUMP", Con{"JUMPI", Con{"JUMPDEST", Con{"RETURN", Con{"REVERT", Con{"INVALID", Con{"SELFDESTRUCT", Nil{}}}}}}}}}) : ListOf(TupleOf3(String, ListOf(Asm.Block), String))}
(+scrut17189 = {SeqList.map(&2, &2, TupleOf3(String, ListOf(Asm.Block), String), TupleOf2(Bool, Big), (+local17175 => ((+scrut17176 = local17175
Match.Tuple3(&2, String, &2, ListOf(Asm.Block), &2, String, &2, TupleOf2(Bool, Big), scrut17176, +p17177 => +p17178 => +p17179 => (Tup2{Asm_cases.rejection(p17177, p17178, p17179), Big.zero()}))))), List.append(&2, TupleOf3(String, ListOf(Asm.Block), String), scrut17153, List.append(&2, TupleOf3(String, ListOf(Asm.Block), String), scrut17161, List.append(&2, TupleOf3(String, ListOf(Asm.Block), String), scrut17167, scrut17173)))) : ListOf(TupleOf2(Bool, Big))}
((+scrut17194 = {Con{Tup3{"ref20", Asm_cases.ref20(), "602a5f55600b56fefefefe5b5f545f5260205ff3"}, Con{Tup3{"diamond", Asm_cases.diamond(), "6001600857600e565b602a6011565b602b5b5000"}, Con{Tup3{"loop", Asm_cases.loop(), "5b60016100005761000b565b00"}, Con{Tup3{"push-zero", Con{Asm_cases.stop("x", Con{Asm.Instruction.Push{""}, Con{Asm.Instruction.Push{"00"}, Nil{}}}), Nil{}}, "5f600000"}, Con{Tup3{"stack-limit", Con{Asm_cases.stop("x", List.append(&2, Asm.Instruction, Asm_cases.zeros(Big.of_nat(1024n)), Con{Asm.Instruction.Swap{Big.of_nat(16n)}, Nil{}})), Nil{}}, String.append(String.join(SeqList.init(&2, String, Big.of_nat(1024n), (+local17193 => ("5f"))), ""), "9f00")}, Con{Tup3{"label-32", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Goto{Big.of_nat(32n), "y"}), Con{Asm_cases.target(None{}, "y"), Nil{}}}, String.append("7f", String.append(NativeString.repeat(Big.to_nat(Big.of_nat(62n)), Char.from_u32(48)), "22565b00"))}, Con{Tup3{"revert", Con{Asm_cases.block(None{}, None{}, "x", Asm_cases.zeros(Big.of_nat(2n)), Asm.Ending.Halt{Asm.Halt.Revert{}}), Nil{}}, "5f5ffd"}, Con{Tup3{"selfdestruct", Con{Asm_cases.block(None{}, None{}, "x", Con{Asm.Instruction.Push{""}, Nil{}}, Asm.Ending.Halt{Asm.Halt.Selfdestruct{}}), Nil{}}, "5fff"}, Con{Tup3{"next-unmarked", Con{Asm_cases.block(None{}, None{}, "x", Nil{}, Asm.Ending.Next{"y"}), Con{Asm_cases.stop("y", Nil{}), Nil{}}}, "00"}, Nil{}}}}}}}}}} : ListOf(TupleOf3(String, ListOf(Asm.Block), String))}
((+scrut17208 = {SeqList.map(&2, &2, TupleOf3(String, ListOf(Asm.Block), String), TupleOf2(Bool, Big), (+local17196 => ((+scrut17197 = local17196
Match.Tuple3(&2, String, &2, ListOf(Asm.Block), &2, String, &2, TupleOf2(Bool, Big), scrut17197, +p17198 => +p17199 => +p17200 => (Asm_cases.acceptance(p17198, p17199, p17200)))))), scrut17194) : ListOf(TupleOf2(Bool, Big))}
(+scrut17236 = {(+local17210 => +local17212 => +local17214 => +local17216 => ((+local17219 => (Match.Result(&2, Asm, &2, Asm.Error, &2, TupleOf2(Bool, Big), local17219, +x => (+local17221 => (Tup2{Big.when(Bool, Equal.OptionOf_Big_(SeqList.assoc(&2, &2, String, Big, +x => +y => NativeString.equal(x, y), local17212, Asm.labels(local17221)), Some{local17214}), _ => (Equal.ListOf_TupleOf3_Big__Big__Big__(Asm_cases.record(local17221), local17216)), _ => (False{})), Asm_cases.blocks_of(local17221)}))(x), +x => (+local17235 => (Tup2{False{}, Big.zero()}))(x))))(Asm.assemble(local17210)))) : Reusable(ListOf(Asm.Block), Reusable(String, Reusable(Big, Reusable(ListOf(TupleOf3(Big, Big, Big)), TupleOf2(Bool, Big)))))}
((+scrut17237 = {scrut17236(Asm_cases.ref20(), "read", Big.of_nat(11n), Con{Tup3{Big.zero(), Big.zero(), Big.of_nat(2n)}, Con{Tup3{Big.zero(), Big.zero(), Big.zero()}, Con{Tup3{Big.zero(), Big.zero(), Big.zero()}, Con{Tup3{Big.zero(), Big.zero(), Big.zero()}, Con{Tup3{Big.zero(), Big.zero(), Big.zero()}, Con{Tup3{Big.zero(), Big.zero(), Big.of_nat(2n)}, Nil{}}}}}}}) : TupleOf2(Bool, Big)}
Match.Tuple2(&2, Bool, &2, Big, &2, TupleOf4(Big, Big, Big, Big), scrut17237, +p17238 => +p17239 => ((+scrut17240 = {scrut17236(Asm_cases.diamond(), "join", Big.of_nat(17n), Con{Tup3{Big.zero(), Big.zero(), Big.of_nat(2n)}, Con{Tup3{Big.zero(), Big.one(), Big.of_nat(2n)}, Con{Tup3{Big.zero(), Big.one(), Big.one()}, Con{Tup3{Big.one(), Big.zero(), Big.one()}, Nil{}}}}}) : TupleOf2(Bool, Big)}
Match.Tuple2(&2, Bool, &2, Big, &2, TupleOf4(Big, Big, Big, Big), scrut17240, +p17241 => +p17242 => ((+scrut17243 = {Tup2{Asm_cases.report("labels-and-heights", Big.when(Bool, p17238, _ => (p17241), _ => (False{})), "ref20 diamond"), NativeInt.add(p17239, p17242)} : TupleOf2(Bool, Big)}
(+scrut17244 = {List.append(&2, TupleOf2(Bool, Big), Con{scrut17243, scrut17189}, scrut17208) : ListOf(TupleOf2(Bool, Big))}
((+scrut17248 = {SeqList.all(&2, TupleOf2(Bool, Big), (+local17247 => (Get.Tuple2.v0(&2, Bool, &2, Big, local17247))), scrut17244) : Bool}
(+scrut17256 = {SeqList.fold(&2, &2, TupleOf2(Bool, Big), Big, (+local17250 => +local17252 => ((+scrut17253 = local17252
Match.Tuple2(&2, Bool, &2, Big, &2, Big, scrut17253, +p17254 => +p17255 => (NativeInt.add(local17250, p17255)))))), scrut17244, Big.zero()) : Big}
Tup4{Native.choose(&2, Big, scrut17248, _ => (Big.zero()), _ => (Big.one())), scrut17256, Big.of_nat(List.length(&2, TupleOf2(Bool, Big), SeqList.filter(&2, TupleOf2(Bool, Big), (+local17258 => ((+scrut17259 = local17258
Match.Tuple2(&2, Bool, &2, Big, &2, Bool, scrut17259, +p17260 => +p17261 => (Bool.not(p17260)))))), scrut17244))), Big.of_nat(List.length(&2, TupleOf2(Bool, Big), scrut17244))}))))))))))))))))))))))))))
@unsafe
def Asm_cases.effect(+name_629: String, +count_630: String) -> StringResult(Asm):
  (+scrut17275 = {List.append(&2, TupleOf2(String, Asm.Instruction), SeqList.init(&2, TupleOf2(String, Asm.Instruction), Big.of_nat(33n), (+local17270 => (Tup2{String.append("PUSH", Big.show(local17270)), Asm.Instruction.Push{NativeString.repeat(Big.to_nat(NativeInt.mul(Big.of_nat(2n), local17270)), Char.from_u32(48))}}))), List.append(&2, TupleOf2(String, Asm.Instruction), SeqList.init(&2, TupleOf2(String, Asm.Instruction), Big.of_nat(16n), (+local17272 => (Tup2{String.append("DUP", Big.show(NativeInt.add(local17272, Big.one()))), Asm.Instruction.Dup{NativeInt.add(local17272, Big.one())}}))), SeqList.init(&2, TupleOf2(String, Asm.Instruction), Big.of_nat(16n), (+local17274 => (Tup2{String.append("SWAP", Big.show(NativeInt.add(local17274, Big.one()))), Asm.Instruction.Swap{NativeInt.add(local17274, Big.one())}}))))) : ListOf(TupleOf2(String, Asm.Instruction))}
  (+scrut17279 = {(+local17278 => (Maybe.default(&2, Asm.Instruction, local17278, Asm.Instruction.Op{name_629})))(SeqList.assoc(&2, &2, String, Asm.Instruction, +x => +y => NativeString.equal(x, y), name_629, scrut17275)) : Asm.Instruction}
  ((+scrut17292 = {Match.Result(&2, Big, &2, String, &2, StringResult(Asm), (+local17282 => (Match.Maybe(&2, Big, &2, StringResult(Big), local17282, _ => Fail{"invalid count"}, +x => Done{x})))(TestNumber.read(count_630)), +item17290 => ((+local17284 => (Native.choose(&2, StringResult(Asm), Big.when(Bool, Big.is_lt(local17284, Big.zero()), _ => (True{}), _ => (Big.is_lt(Big.of_nat(1024n), local17284))), _ => (Fail{"invalid count"}), _ => ((+local17287 => (Match.Result(&2, Asm, &2, Asm.Error, &2, StringResult(Asm), local17287, +item17288 => Done{item17288}, +item17289 => (Fail{Asm.error_text(item17289)}))))(Asm.assemble(Con{Asm_cases.stop("effect", List.append(&2, Asm.Instruction, Asm_cases.zeros(local17284), Con{scrut17279, Nil{}})), Nil{}}))))))(item17290)), +item17291 => Fail{item17291}) : StringResult(Asm)}
scrut17292))))
@unsafe
def Asm_cases.fixtures() -> ListOf(TupleOf2(String, ListOf(Asm.Block))):
  Con{Tup2{"ref20", Asm_cases.ref20()}, Con{Tup2{"diamond", Asm_cases.diamond()}, Con{Tup2{"loop", Asm_cases.loop()}, Con{Tup2{"pushes", Con{Asm_cases.stop("pushes", SeqList.init(&2, Asm.Instruction, Big.of_nat(33n), (+local17295 => (Asm.Instruction.Push{NativeString.repeat(Big.to_nat(NativeInt.mul(Big.of_nat(2n), local17295)), Char.from_u32(102))})))), Nil{}}}, Con{Tup2{"depths", Con{Asm_cases.stop("depths", List.append(&2, Asm.Instruction, Asm_cases.zeros(Big.of_nat(17n)), List.append(&2, Asm.Instruction, SeqList.init(&2, Asm.Instruction, Big.of_nat(16n), (+local17297 => (Asm.Instruction.Dup{NativeInt.add(local17297, Big.one())}))), SeqList.init(&2, Asm.Instruction, Big.of_nat(16n), (+local17299 => (Asm.Instruction.Swap{NativeInt.add(local17299, Big.one())})))))), Nil{}}}, Nil{}}}}}}
@unsafe
def Emit_cases.lit(+n_325: Big) -> Eterm.Ktm:
  Eterm.Ktm.KLit{Literal.LInt{Big.identity(n_325)}}
@unsafe
def Emit_cases.env() -> Emit.Environment:
  Emit.environment(None{}, Con{Tup2{"f", Erase.Entry.Code{Con{Eterm.Kdecl.KFun{Eterm.Fid.Fid{"f"}, Con{Eterm.Repr.RI31{}, Nil{}}, Eterm.Repr.RI31{}, Eterm.Ktm.KApp{Eterm.Ktm.KGlobal{"natAdd"}, Con{Eterm.Ktm.KVar{Big.zero()}, Con{Emit_cases.lit(Big.one()), Nil{}}}}}, Nil{}}}}, Nil{}})
@unsafe
def Emit_cases.value(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2), +result_502: Result<q1, (q0 <&> q2), A1, Tuple2<q0, q2, A0, A2>>) -> Result<q1, q0, A1, A0>:
  Match.Result((q0 <&> q2), Tuple2<q0, q2, A0, A2>, q1, A1, (q0 <&> q1), Result<q1, q0, A1, A0>, result_502, +item17304 => (Done{(+local17303 => (Get.Tuple2.v0(q0, A0, q2, A2, local17303)))(item17304)}), +item17305 => Fail{item17305})
@unsafe
def Emit_cases.eval(+term_844: Eterm.Ktm) -> Emit.Result(Recognize.Value):
  Emit_cases.value(&2, Recognize.Value, &2, Emit.Error, &2, Big, Emit.eval(Emit_cases.env(), Nil{}, Big.of_nat(1000n), term_844))
@unsafe
def Emit_cases.require(-q0: Quant, -A0: Kind(q0), +label_321: A0, +yes_322: Bool) -> Result<q0, &2, A0, Unit>:
  Native.choose(q0, Result<q0, &2, A0, Unit>, yes_322, _ => (Done{Unit{}}), _ => (Fail{label_321}))
@unsafe
def Emit_cases.good(-q0: Quant, -A0: Kind(q0), +label_847: A0, +expected_848: Recognize.Value, +term_849: Eterm.Ktm) -> Result<q0, &2, A0, Unit>:
  Emit_cases.require(q0, A0, label_847, Equal.Emit_Result_Recognize_Value_(Emit_cases.eval(term_849), Done{expected_848}))
@unsafe
def Emit_cases.pair_tid() -> Eterm.Tid:
  Eterm.Tid.Tid{"pair-test"}
@unsafe
def Emit_cases.bad(-q0: Quant, -A0: Kind(q0), +label_934: A0, +expected_935: Emit.Error, +term_936: Eterm.Ktm) -> Result<q0, &2, A0, Unit>:
  Emit_cases.require(q0, A0, label_934, Equal.Emit_Result_Recognize_Value_(Emit_cases.eval(term_936), Fail{expected_935}))
@unsafe
def Emit_cases.constructors(+param_1048: Unit) -> StringResult(String):
  (+scrut17300 = param_1048
  ((+scrut17380 = {Con{Emit_cases.good(&2, String, "literal", Recognize.Value.Nat{Big.identity(Big.of_nat(7n))}, Emit_cases.lit(Big.of_nat(7n))), Con{Emit_cases.good(&2, String, "erased", Recognize.Value.Erased{}, Eterm.Ktm.KErased{}), Con{Emit_cases.good(&2, String, "let-var", Recognize.Value.Nat{Big.identity(Big.of_nat(9n))}, Eterm.Ktm.KLet{"x", Emit_cases.lit(Big.of_nat(9n)), Eterm.Ktm.KVar{Big.zero()}}), Con{Emit_cases.good(&2, String, "app", Recognize.Value.Nat{Big.identity(Big.of_nat(10n))}, Eterm.Ktm.KApp{Eterm.Ktm.KGlobal{"f"}, Con{Emit_cases.lit(Big.of_nat(9n)), Nil{}}}), Con{Emit_cases.good(&2, String, "tail", Recognize.Value.Nat{Big.identity(Big.of_nat(10n))}, Eterm.Ktm.KTail{Eterm.Ktm.KGlobal{"f"}, Con{Emit_cases.lit(Big.of_nat(9n)), Nil{}}}), Con{Emit_cases.good(&2, String, "struct", Recognize.Value.Struct{Emit_cases.pair_tid(), Con{Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Nil{}}}, Eterm.Ktm.KStruct{Emit_cases.pair_tid(), Con{Emit_cases.lit(Big.of_nat(8n)), Nil{}}}), Con{Emit_cases.good(&2, String, "projection", Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Eterm.Ktm.KProj{Emit_cases.pair_tid(), Big.zero(), Eterm.Ktm.KStruct{Emit_cases.pair_tid(), Con{Emit_cases.lit(Big.of_nat(8n)), Nil{}}}}), Con{Emit_cases.good(&2, String, "tag", Recognize.Value.Tag{Emit_cases.pair_tid(), Big.of_nat(2n), Con{Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Nil{}}}, Eterm.Ktm.KTag{Emit_cases.pair_tid(), Big.of_nat(2n), Con{Emit_cases.lit(Big.of_nat(8n)), Nil{}}}), Con{Emit_cases.good(&2, String, "case", Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Eterm.Ktm.KCase{Emit_cases.pair_tid(), Eterm.Ktm.KTag{Emit_cases.pair_tid(), Big.of_nat(2n), Con{Emit_cases.lit(Big.of_nat(8n)), Nil{}}}, Con{MkEterm_KbranchOf{Big.of_nat(2n), Big.one(), Eterm.Ktm.KVar{Big.zero()}}, Nil{}}}), Con{Emit_cases.good(&2, String, "word-case", Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Eterm.Ktm.KCase{Recognize.word_tid(), Eterm.Ktm.KTag{Recognize.word_tid(), Big.zero(), Con{Emit_cases.lit(Big.of_nat(8n)), Nil{}}}, Con{MkEterm_KbranchOf{Big.zero(), Big.one(), Eterm.Ktm.KVar{Big.zero()}}, Nil{}}}), Con{Emit_cases.bad(&2, String, "closure", Emit.Error.Higher_order{}, Eterm.Ktm.KClos{Eterm.Fid.Fid{"f"}, Big.one(), Nil{}}), Con{Emit_cases.bad(&2, String, "indirect-app", Emit.Error.Higher_order{}, Eterm.Ktm.KApp{Eterm.Ktm.KVar{Big.zero()}, Con{Emit_cases.lit(Big.zero()), Nil{}}}), Con{Emit_cases.bad(&2, String, "partial", Emit.Error.Higher_order{}, Eterm.Ktm.KGlobal{"f"}), Con{Emit_cases.bad(&2, String, "delay", Emit.Error.Later{"KDELAY"}, Eterm.Ktm.KDelay{Eterm.Fid.Fid{"f"}, Nil{}}), Con{Emit_cases.bad(&2, String, "force", Emit.Error.Later{"KFORCE"}, Eterm.Ktm.KForce{Emit_cases.lit(Big.zero())}), Con{Emit_cases.bad(&2, String, "string", Emit.Error.Later{"STRING"}, Eterm.Ktm.KLit{Literal.LString{"x"}}), Con{Emit_cases.bad(&2, String, "bad-index", Emit.Error.Invalid_ir{"index"}, Eterm.Ktm.KVar{Big.neg(Big.of_nat(1n))}), Con{Emit_cases.bad(&2, String, "missing", Emit.Error.Missing{"gone"}, Eterm.Ktm.KGlobal{"gone"}), Con{Emit_cases.require(&2, String, "fuel", Equal.Emit_Result_TupleOf2_Recognize_Value__Big__(Emit.eval(Emit_cases.env(), Nil{}, Big.zero(), Emit_cases.lit(Big.one())), Fail{Emit.Error.Budget{}})), Con{Emit_cases.require(&2, String, "runtime-nat", Equal.Emit_Result_Emit_Effect_(Emit.effect(Big.zero(), Recognize.Value.Nat{Big.zero()}), Fail{Emit.Error.Nat_runtime{}})), Con{Emit_cases.good(&2, String, "natSub", Recognize.Value.Nat{Big.zero()}, Eterm.Ktm.KApp{Eterm.Ktm.KGlobal{"natSub"}, Con{Emit_cases.lit(Big.of_nat(2n)), Con{Emit_cases.lit(Big.of_nat(8n)), Nil{}}}}), Con{Emit_cases.good(&2, String, "natMul", Recognize.Value.Nat{Big.identity(Big.of_nat(42n))}, Eterm.Ktm.KApp{Eterm.Ktm.KGlobal{"natMul"}, Con{Emit_cases.lit(Big.of_nat(6n)), Con{Emit_cases.lit(Big.of_nat(7n)), Nil{}}}}), Nil{}}}}}}}}}}}}}}}}}}}}}}} : ListOf(StringResult(Unit))}
Match.Result(&2, Unit, &2, String, &2, StringResult(String), SeqList.fold(&2, &2, StringResult(Unit), StringResult(Unit), (+local17383 => +local17385 => (Match.Result(&2, Unit, &2, String, &2, StringResult(Unit), local17383, +item17390 => ((+local17388 => ((+scrut17389 = local17388
local17385)))(item17390)), +item17391 => Fail{item17391}))), scrut17380, Done{Unit{}}), +item17395 => ((+local17393 => ((+scrut17394 = local17393
Done{String.concat(["EMIT-CONSTRUCTORS cases=", Big.show(Big.of_nat(List.length(&2, StringResult(Unit), scrut17380))), " OK\u{a}"])})))(item17395)), +item17396 => Fail{item17396}))))
@unsafe
def Emit_cases.unit_tid() -> Eterm.Tid:
  Eterm.Tid.Tid{"tuple<>"}
@unsafe
def Emit_cases.leak(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), +result_1051: Result<q1, q0, A1, A0>) -> Big:
  Match.Result(q0, A0, q1, A1, &2, Big, result_1051, +x => (+local17429 => (Big.one()))(x), +x => (+local17431 => (Big.zero()))(x))
@unsafe
def Emit_cases.is_word(+value_1056: Recognize.Value) -> Bool:
  (+scrut17434 = value_1056
  Match.Recognize_Value(&2, Bool, scrut17434, +p17435 => (False{}), +p17436 => (True{}), _ => (False{}), +p17437 => (False{}), +p17438 => +p17439 => +p17440 => (False{}), +p17441 => +p17442 => (False{}), +p17443 => +p17444 => +p17445 => (False{})))
@unsafe
def Emit_cases.words(+param_1087: Unit) -> StringResult(String):
  (+scrut17398 = param_1087
  (+scrut17399 = {Big.pred(Big.shift_left(Big.one(), Big.to_nat(Big.of_nat(256n)))) : Big}
  ((+scrut17408 = {Con{Emit_cases.require(&2, String, "word-zero", Equal.ResultOf_Recognize_Error__Recognize_Value_(Recognize.tag(Recognize.word_tid(), Big.zero(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}), Done{Recognize.Value.Word{Big.zero()}})), Con{Emit_cases.require(&2, String, "word-max", Equal.ResultOf_Recognize_Error__Recognize_Value_(Recognize.tag(Recognize.word_tid(), Big.zero(), Con{Recognize.Value.Nat{scrut17399}, Nil{}}), Done{Recognize.Value.Word{scrut17399}})), Con{Emit_cases.require(&2, String, "word-overflow", Equal.ResultOf_Recognize_Error__Recognize_Value_(Recognize.tag(Recognize.word_tid(), Big.zero(), Con{Recognize.Value.Nat{Big.succ(scrut17399)}, Nil{}}), Fail{Recognize.Error.Word_range{}})), Con{Emit_cases.require(&2, String, "word-negative", Equal.ResultOf_Recognize_Error__Recognize_Value_(Recognize.tag(Recognize.word_tid(), Big.zero(), Con{Recognize.Value.Nat{Big.neg(Big.one())}, Nil{}}), Fail{Recognize.Error.Word_range{}})), Con{Emit_cases.require(&2, String, "word-shape", Equal.ResultOf_Recognize_Error__Recognize_Value_(Recognize.tag(Recognize.word_tid(), Big.one(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}), Fail{Recognize.Error.Word_shape{}})), Con{Emit_cases.require(&2, String, "word-struct", Equal.ResultOf_Recognize_Error__Recognize_Value_(Recognize.struct_value(Recognize.word_tid(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}), Fail{Recognize.Error.Word_boxed{}})), Con{Emit_cases.require(&2, String, "word-leaked-tag", Equal.ResultOf_Recognize_Error__Unit_(Recognize.unboxed(Recognize.Value.Tag{Recognize.word_tid(), Big.zero(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}}), Fail{Recognize.Error.Word_boxed{}})), Con{Emit_cases.require(&2, String, "word-leaked-struct", Equal.ResultOf_Recognize_Error__Unit_(Recognize.unboxed(Recognize.Value.Struct{Emit_cases.unit_tid(), Con{Recognize.Value.Struct{Recognize.word_tid(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}}, Nil{}}}), Fail{Recognize.Error.Word_boxed{}})), Con{Emit_cases.good(&2, String, "word-unbox", Recognize.Value.Word{Big.identity(Big.of_nat(42n))}, Eterm.Ktm.KTag{Recognize.word_tid(), Big.zero(), Con{Emit_cases.lit(Big.of_nat(42n)), Nil{}}}), Nil{}}}}}}}}}} : ListOf(StringResult(Unit))}
Match.Result(&2, Unit, &2, String, &2, StringResult(String), SeqList.fold(&2, &2, StringResult(Unit), StringResult(Unit), (+local17411 => +local17413 => (Match.Result(&2, Unit, &2, String, &2, StringResult(Unit), local17411, +item17418 => ((+local17416 => ((+scrut17417 = local17416
local17413)))(item17418)), +item17419 => Fail{item17419}))), scrut17408, Done{Unit{}}), +item17449 => ((+local17421 => ((+scrut17422 = local17421
((+scrut17426 = {SeqList.filter_map(&2, &2, ResultOf(Recognize.Error, Recognize.Value), Recognize.Value, (+local17425 => (Match.Result(&2, Recognize.Value, &2, Recognize.Error, &2, OptionOf(Recognize.Value), local17425, +x => Some{x}, _ => None{}))), Con{Recognize.tag(Recognize.word_tid(), Big.zero(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}), Con{Recognize.tag(Recognize.word_tid(), Big.zero(), Con{Recognize.Value.Nat{scrut17399}, Nil{}}), Nil{}}}) : ListOf(Recognize.Value)}
(+scrut17427 = {Match.Maybe(&2, Recognize.Value, &2, ListOf(Recognize.Value), Match.Result(&2, Recognize.Value, &2, Emit.Error, &2, OptionOf(Recognize.Value), Emit_cases.eval(Eterm.Ktm.KTag{Recognize.word_tid(), Big.zero(), Con{Emit_cases.lit(Big.of_nat(42n)), Nil{}}}), +x => Some{x}, _ => None{}), _ => Nil{}, +item => item <> Nil{}) : ListOf(Recognize.Value)}
(+scrut17432 = {Emit_cases.leak(&2, Unit, &2, Recognize.Error, Recognize.unboxed(Recognize.Value.Tag{Recognize.word_tid(), Big.zero(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}})) : Big}
((+scrut17433 = {NativeInt.add(Emit_cases.leak(&2, Recognize.Value, &2, Recognize.Error, Recognize.struct_value(Recognize.word_tid(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}})), Emit_cases.leak(&2, Unit, &2, Recognize.Error, Recognize.unboxed(Recognize.Value.Struct{Emit_cases.unit_tid(), Con{Recognize.Value.Struct{Recognize.word_tid(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}}, Nil{}}}))) : Big}
(+scrut17446 = {Big.of_nat(List.length(&2, Recognize.Value, SeqList.filter(&2, Recognize.Value, Emit_cases.is_word, List.append(&2, Recognize.Value, scrut17426, scrut17427)))) : Big}
Done{String.concat(["WORD-UNBOX ktag=", Big.show(scrut17432), " kstruct=", Big.show(scrut17433), " words=", Big.show(scrut17446), " cases=", Big.show(Big.of_nat(List.length(&2, StringResult(Unit), scrut17408))), " OK\u{a}"])}))))))))))(item17449)), +item17450 => Fail{item17450})))))
@unsafe
def Emit_cases.storage(+param_1109: Unit) -> StringResult(String):
  (+scrut17452 = param_1109
  (+scrut17453 = {Eterm.Ktm.KClos{Eterm.Fid.Fid{"f"}, Big.one(), Nil{}} : Eterm.Ktm}
  ((+scrut17456 = {(+local17455 => (Native.choose(&2, OptionOf(Eterm.Ktm), NativeString.equal(local17455, "hidden"), _ => (Some{scrut17453}), _ => (None{})))) : Reusable(String, OptionOf(Eterm.Ktm))}
(+scrut17457 = {Eterm.Ktm.KStruct{Emit_cases.pair_tid(), Con{Eterm.Ktm.KTag{Recognize.word_tid(), Big.zero(), Con{Emit_cases.lit(Big.zero()), Nil{}}}, Nil{}}} : Eterm.Ktm}
(+scrut17458 = {Eterm.Ktm.KStruct{Emit_cases.pair_tid(), Con{scrut17453, Nil{}}} : Eterm.Ktm}
(+scrut17459 = {Eterm.Ktm.KTail{Eterm.Ktm.KGlobal{"f"}, Nil{}} : Eterm.Ktm}
(+scrut17460 = {Eterm.Ktm.KGlobal{"hidden"} : Eterm.Ktm}
(+scrut17461 = {Recognize.Value.Struct{Emit_cases.pair_tid(), Con{Recognize.Value.Word{Big.zero()}, Con{Recognize.Value.Word{Big.one()}, Nil{}}}} : Recognize.Value}
((+scrut17468 = {Con{Emit_cases.require(&2, String, "storage-clean", Equal.ResultOf_Recognize_Error__Unit_(Recognize.no_closure(scrut17456, Nil{}, scrut17457), Done{Unit{}})), Con{Emit_cases.require(&2, String, "storage-closure", Equal.ResultOf_Recognize_Error__Unit_(Recognize.no_closure(scrut17456, Nil{}, scrut17458), Fail{Recognize.Error.Storage_closure{}})), Con{Emit_cases.require(&2, String, "storage-tail", Equal.ResultOf_Recognize_Error__Unit_(Recognize.no_closure(scrut17456, Nil{}, scrut17459), Fail{Recognize.Error.Storage_closure{}})), Con{Emit_cases.require(&2, String, "storage-hidden", Equal.ResultOf_Recognize_Error__Unit_(Recognize.no_closure(scrut17456, Nil{}, scrut17460), Fail{Recognize.Error.Storage_closure{}})), Con{Emit_cases.require(&2, String, "storage-cycle", Equal.ResultOf_Recognize_Error__Unit_(Recognize.no_closure((+local17463 => (Some{Eterm.Ktm.KGlobal{local17463}})), Nil{}, Eterm.Ktm.KGlobal{"loop"}), Fail{Recognize.Error.Storage_closure{}})), Con{Emit_cases.require(&2, String, "storage-slots", Equal.ResultOf_Recognize_Error__ListOf_String__(Recognize.storage(scrut17461), Done{Con{"field0", Con{"field1", Nil{}}}})), Con{Emit_cases.require(&2, String, "storage-gap", Equal.ResultOf_Recognize_Error__ListOf_String__(Recognize.storage(Recognize.Value.Struct{Emit_cases.pair_tid(), Con{Recognize.Value.Word{Big.one()}, Nil{}}}), Fail{Recognize.Error.Storage_slot{}})), Con{Emit_cases.require(&2, String, "storage-nat", Equal.ResultOf_Recognize_Error__ListOf_String__(Recognize.storage(Recognize.Value.Struct{Emit_cases.pair_tid(), Con{Recognize.Value.Nat{Big.zero()}, Nil{}}}), Fail{Recognize.Error.Storage_shape{}})), Con{Emit_cases.require(&2, String, "effect-slot", Equal.Emit_Result_Emit_Effect_(Emit.effect(Big.one(), Recognize.Value.Tag{Recognize.eff_tid(), Big.of_nat(2n), Con{Recognize.Value.Word{Big.one()}, Nil{}}}), Fail{Emit.Error.Unknown_slot{}})), Nil{}}}}}}}}}} : ListOf(StringResult(Unit))}
Match.Result(&2, Unit, &2, String, &2, StringResult(String), SeqList.fold(&2, &2, StringResult(Unit), StringResult(Unit), (+local17471 => +local17473 => (Match.Result(&2, Unit, &2, String, &2, StringResult(Unit), local17471, +item17478 => ((+local17476 => ((+scrut17477 = local17476
local17473)))(item17478)), +item17479 => Fail{item17479}))), scrut17468, Done{Unit{}}), +item17492 => ((+local17481 => ((+scrut17482 = local17481
((+scrut17483 = {NativeInt.add(Emit_cases.leak(&2, Unit, &2, Recognize.Error, Recognize.no_closure(scrut17456, Nil{}, scrut17458)), Emit_cases.leak(&2, Unit, &2, Recognize.Error, Recognize.no_closure(scrut17456, Nil{}, scrut17460))) : Big}
(+scrut17484 = {Emit_cases.leak(&2, Unit, &2, Recognize.Error, Recognize.no_closure(scrut17456, Nil{}, scrut17459)) : Big}
(+scrut17490 = {Match.Result(&2, ListOf(String), &2, Recognize.Error, &2, Big, Recognize.storage(scrut17461), +x => (+local17487 => (Big.of_nat(List.length(&2, String, local17487))))(x), +x => (+local17489 => (Big.zero()))(x)) : Big}
Done{String.concat(["STORAGE-NOCLOS kclos=", Big.show(scrut17483), " ktail=", Big.show(scrut17484), " fields=", Big.show(scrut17490), " cases=", Big.show(Big.of_nat(List.length(&2, StringResult(Unit), scrut17468))), " OK\u{a}"])})))))))(item17492)), +item17493 => Fail{item17493}))))))))))))
@unsafe
def One_paths.postulate(+globals_883: Global, +name_884: String, +ty_885: Term) -> CheckResult(Global):
  Match.Result(&2, Global.Entry, &2, Error, &2, CheckResult(Global), Check.check_decl(globals_883, Budget.unlimited(), MkCheck_Decl{name_884, Check.Kind.Postulate{}, ty_885, None{}}), +item17501 => ((+local17500 => (Done{Global.add(name_884, local17500, globals_883)}))(item17501)), +item17502 => Fail{item17502})
@unsafe
def One_paths.void() -> Term:
  Rules.sum_ty(Nil{})
@unsafe
def One_paths.lambda(+q_656: Quantity, +name_657: String, +dom_658: Term, +body_659: Term) -> Term:
  Term.Sec{Shape.SPi{q_656, name_657, dom_658}, Con{MkTerm_LegOf{Con{Tup2{q_656, name_657}, Nil{}}, body_659}, Nil{}}}
@unsafe
def One_paths.check(+globals_733: Global, +term_734: Term, +ty_735: Term) -> CheckResult(Unit):
  Match.Result(&2, Value, &2, Error, &2, CheckResult(Unit), Eval.eval(globals_733, Nil{}, ty_735), +item17520 => ((+local17519 => (Check.check_term(None{}, globals_733, term_734, local17519)))(item17520)), +item17521 => Fail{item17521})
@unsafe
def One_paths.linear(+globals_877: Global, +dom_878: Term, +cod_879: Term, +body_880: Term) -> CheckResult(Unit):
  One_paths.check(globals_877, One_paths.lambda(Quantity.One{}, "x", dom_878, body_880), Rules.arrow(Quantity.One{}, "x", dom_878, cod_879))
@unsafe
def One_paths.both() -> Term:
  Rules.sum_ty(Con{Prim.nat_ty(), Con{Prim.nat_ty(), Nil{}}})
@unsafe
def One_paths.branch(+index_936: Big, +body_937: Term) -> TupleOf2(Term.Addr, Term.Leg):
  Tup2{Term.AddrOf.ALeg{index_936}, MkTerm_LegOf{Con{Tup2{Quantity.Many{}, "payload"}, Nil{}}, body_937}}
@unsafe
def One_paths.elimination(+shape_940: Shape<&2, Term>, +scrut_941: Term, +quantity_942: Quantity, +branches_943: ListOf(TupleOf2(Term.Addr, Term.Leg))) -> Term:
  Term.Elim{MkTerm_ElimOf{shape_940, scrut_941, quantity_942, None{}, branches_943}}
@unsafe
def One_paths.case(+scrut_946: Term, +quantity_947: Quantity, +body0_948: Term, +body1_949: Term) -> Term:
  One_paths.elimination(Shape.SColl{Big.of_nat(2n)}, scrut_946, quantity_947, Con{One_paths.branch(Big.zero(), body0_948), Con{One_paths.branch(Big.one(), body1_949), Nil{}}})
@unsafe
def One_paths.zero() -> Term:
  Term.Lit{Literal.LInt{Big.zero()}}
@unsafe
def One_paths.app(+stamp_728: Quantity, +name_729: String, +argument_730: Term) -> Term:
  Term.Out{Shape.SPi{stamp_728, "arg", Prim.nat_ty()}, Term.AddrOf.APt{stamp_728, argument_730}, Term.Global{name_729}}
@unsafe
def One_paths.absurd(+scrut_952: Term) -> Term:
  One_paths.elimination(Shape.SColl{Big.zero()}, scrut_952, Quantity.One{}, Nil{})
@unsafe
def One_paths.cases(+globals_1043: Global) -> ListOf(TupleOf3(String, One_paths.Expectation, CheckResult(Unit))):
  (+scrut17522 = {(+local17516 => (One_paths.linear(globals_1043, Prim.nat_ty(), Prim.nat_ty(), local17516))) : Reusable(Term, CheckResult(Unit))}
  ((+scrut17527 = {(+local17524 => +local17526 => (One_paths.linear(globals_1043, Prim.nat_ty(), Rules.arrow(Quantity.Many{}, "tag", One_paths.both(), Prim.nat_ty()), One_paths.lambda(Quantity.Many{}, "tag", One_paths.both(), One_paths.case(Term.Var{Big.zero()}, Quantity.One{}, local17524, local17526))))) : Reusable(Term, Reusable(Term, CheckResult(Unit)))}
(+scrut17532 = {(+local17529 => +local17531 => (Term.Sec{Shape.SColl{Big.of_nat(2n)}, Con{Rules.leg_of(local17529), Con{Rules.leg_of(local17531), Nil{}}}})) : Reusable(Term, Reusable(Term, Term))}
(+scrut17533 = {Rules.arrow(Quantity.Many{}, "ignored", Prim.nat_ty(), Prim.nat_ty()) : Term}
(+scrut17534 = {One_paths.lambda(Quantity.Many{}, "ignored", Prim.nat_ty(), Term.Var{Big.one()}) : Term}
(+scrut17537 = {(+local17536 => (Term.Out{Shape.SPi{Quantity.Many{}, "arg", Prim.nat_ty()}, Term.AddrOf.APt{Quantity.Many{}, One_paths.zero()}, Term.Var{local17536}})) : Reusable(Big, Term)}
(Con{Tup3{"kernel-linear-identity", One_paths.Expectation.Accept{}, scrut17522(Term.Var{Big.zero()})}, Con{Tup3{"kernel-unused", One_paths.Expectation.Quantity_error{}, scrut17522(One_paths.zero())}, Con{Tup3{"kernel-zero-only", One_paths.Expectation.Quantity_error{}, scrut17522(One_paths.app(Quantity.One{}, "ghost", Term.Var{Big.zero()}))}, Con{Tup3{"kernel-apt-zero-stamp-many-type", One_paths.Expectation.Quantity_error{}, scrut17522(One_paths.app(Quantity.Zero{}, "consume", Term.Var{Big.zero()}))}, Con{Tup3{"kernel-apt-one-stamp-many-type", One_paths.Expectation.Quantity_error{}, scrut17522(One_paths.app(Quantity.One{}, "consume", Term.Var{Big.zero()}))}, Con{Tup3{"kernel-apt-many-stamp-one-type", One_paths.Expectation.Accept{}, scrut17522(One_paths.app(Quantity.Many{}, "identity", Term.Var{Big.zero()}))}, Con{Tup3{"kernel-apt-zero-stamp-one-type", One_paths.Expectation.Accept{}, scrut17522(One_paths.app(Quantity.Zero{}, "identity", Term.Var{Big.zero()}))}, Con{Tup3{"kernel-once-per-branch", One_paths.Expectation.Accept{}, scrut17527(Term.Var{Big.of_nat(2n)}, Term.Var{Big.of_nat(2n)})}, Con{Tup3{"kernel-asymmetric-branches", One_paths.Expectation.Quantity_error{}, scrut17527(Term.Var{Big.of_nat(2n)}, One_paths.zero())}, Con{Tup3{"kernel-scrutinee-once", One_paths.Expectation.Accept{}, One_paths.linear(globals_1043, One_paths.both(), Prim.nat_ty(), One_paths.case(Term.Var{Big.zero()}, Quantity.One{}, Term.Var{Big.zero()}, Term.Var{Big.zero()}))}, Con{Tup3{"kernel-scrutinee-many", One_paths.Expectation.Quantity_error{}, One_paths.linear(globals_1043, One_paths.both(), Prim.nat_ty(), One_paths.case(Term.Var{Big.zero()}, Quantity.Many{}, Term.Var{Big.zero()}, Term.Var{Big.zero()}))}, Con{Tup3{"kernel-scrutinee-zero", One_paths.Expectation.Quantity_error{}, One_paths.linear(globals_1043, One_paths.both(), Prim.nat_ty(), One_paths.case(Term.Var{Big.zero()}, Quantity.Zero{}, Term.Var{Big.zero()}, Term.Var{Big.zero()}))}, Con{Tup3{"kernel-scrutinee-plus-branch", One_paths.Expectation.Quantity_error{}, One_paths.linear(globals_1043, One_paths.both(), One_paths.both(), One_paths.case(Term.Var{Big.zero()}, Quantity.One{}, Term.Var{Big.one()}, Term.Var{Big.one()}))}, Con{Tup3{"kernel-sequential-tuple", One_paths.Expectation.Quantity_error{}, One_paths.linear(globals_1043, Prim.nat_ty(), Rules.prod_ty(Con{Prim.nat_ty(), Con{Prim.nat_ty(), Nil{}}}), scrut17532(Term.Var{Big.zero()}, Term.Var{Big.zero()}))}, Con{Tup3{"kernel-let-once", One_paths.Expectation.Accept{}, scrut17522(Term.Let{"alias", Prim.nat_ty(), Term.Var{Big.zero()}, Term.Var{Big.zero()}})}, Con{Tup3{"kernel-let-unused", One_paths.Expectation.Accept{}, scrut17522(Term.Let{"alias", Prim.nat_ty(), Term.Var{Big.zero()}, One_paths.zero()})}, Con{Tup3{"kernel-let-eager-duplicate", One_paths.Expectation.Quantity_error{}, scrut17522(Term.Let{"alias", Prim.nat_ty(), Term.Var{Big.zero()}, Term.Var{Big.one()}})}, Con{Tup3{"kernel-let-twice", One_paths.Expectation.Quantity_error{}, One_paths.linear(globals_1043, Prim.nat_ty(), Rules.prod_ty(Con{Prim.nat_ty(), Con{Prim.nat_ty(), Nil{}}}), Term.Let{"alias", Prim.nat_ty(), Term.Var{Big.zero()}, scrut17532(Term.Var{Big.zero()}, Term.Var{Big.zero()})})}, Con{Tup3{"kernel-shadowed-name-unused", One_paths.Expectation.Quantity_error{}, scrut17522(Term.Let{"x", Prim.nat_ty(), One_paths.zero(), Term.Var{Big.zero()}})}, Con{Tup3{"kernel-capture-once", One_paths.Expectation.Accept{}, scrut17522(Term.Let{"closure", scrut17533, scrut17534, scrut17537(Big.zero())})}, Con{Tup3{"kernel-capture-twice", One_paths.Expectation.Quantity_error{}, One_paths.linear(globals_1043, Prim.nat_ty(), Rules.prod_ty(Con{Prim.nat_ty(), Con{Prim.nat_ty(), Nil{}}}), Term.Let{"closure", scrut17533, scrut17534, scrut17532(scrut17537(Big.zero()), scrut17537(Big.zero()))})}, Con{Tup3{"kernel-empty-elimination", One_paths.Expectation.Accept{}, One_paths.linear(globals_1043, One_paths.void(), Prim.nat_ty(), One_paths.absurd(Term.Var{Big.zero()}))}, Con{Tup3{"kernel-unreachable-body", One_paths.Expectation.Accept{}, scrut17522(One_paths.absurd(Term.Global{"impossible"}))}, Con{Tup3{"kernel-unreachable-unused-let", One_paths.Expectation.Accept{}, scrut17522(Term.Let{"dead", Prim.nat_ty(), One_paths.absurd(Term.Global{"impossible"}), One_paths.zero()})}, Con{Tup3{"kernel-unreachable-alternative", One_paths.Expectation.Accept{}, scrut17527(One_paths.absurd(Term.Global{"impossible"}), Term.Var{Big.of_nat(2n)})}, Con{Tup3{"kernel-nested-branches", One_paths.Expectation.Accept{}, scrut17527(One_paths.case(Term.Var{Big.one()}, Quantity.One{}, Term.Var{Big.of_nat(3n)}, Term.Var{Big.of_nat(3n)}), Term.Var{Big.of_nat(2n)})}, Con{Tup3{"kernel-negative-literal", One_paths.Expectation.Negative_literal{}, Match.Result(&2, Value, &2, Error, &2, CheckResult(Unit), Check.infer_term(None{}, globals_1043, Term.Lit{Literal.LInt{Bignum.of_int(Big.neg(Big.of_nat(1n)))}}), +item17540 => (Done{(+local17539 => (Unit{}))(item17540)}), +item17541 => Fail{item17541})}, Nil{}}}}}}}}}}}}}}}}}}}}}}}}}}}}))))))))
@unsafe
def One_paths.observed(+expected_959: One_paths.Expectation, +result_960: CheckResult(Unit)) -> Bool:
  (+scrut17553 = {Tup2{expected_959, result_960} : TupleOf2(One_paths.Expectation, CheckResult(Unit))}
  Match.Tuple2(&2, One_paths.Expectation, &2, CheckResult(Unit), &2, Bool, scrut17553, +p17554 => +p17555 => (Match.One_paths_Expectation(&2, Bool, p17554, _ => (Match.Result(&2, Unit, &2, Error, &2, Bool, p17555, +p17556 => (True{}), +p17557 => (False{}))), _ => (Match.Result(&2, Unit, &2, Error, &2, Bool, p17555, +p17558 => (False{}), +p17559 => (String.starts_with(Error.to_string(p17559), "quantity: ")))), _ => (Match.Result(&2, Unit, &2, Error, &2, Bool, p17555, +p17560 => (False{}), +p17561 => (NativeString.equal(Error.to_string(p17561), "mismatch: a Nat literal must be nonnegative"))))))))
@unsafe
def One_paths.run(+param_1208: Unit) -> CheckResult(Bool):
  (+scrut17496 = param_1208
  (Match.Result(&2, Global, &2, Error, &2, CheckResult(Bool), One_paths.postulate(Global.initial(), "consume", Rules.arrow(Quantity.Many{}, "arg", Prim.nat_ty(), Prim.nat_ty())), +item17577 => ((+local17504 => (Match.Result(&2, Global, &2, Error, &2, CheckResult(Bool), One_paths.postulate(local17504, "identity", Rules.arrow(Quantity.One{}, "arg", Prim.nat_ty(), Prim.nat_ty())), +item17575 => ((+local17507 => (Match.Result(&2, Global, &2, Error, &2, CheckResult(Bool), One_paths.postulate(local17507, "ghost", Rules.arrow(Quantity.Zero{}, "arg", Prim.nat_ty(), Prim.nat_ty())), +item17573 => ((+local17510 => (Match.Result(&2, Global, &2, Error, &2, CheckResult(Bool), One_paths.postulate(local17510, "impossible", One_paths.void()), +item17571 => ((+local17513 => ((+scrut17544 = {One_paths.cases(local17513) : ListOf(TupleOf3(String, One_paths.Expectation, CheckResult(Unit)))}
((+scrut17568 = {SeqList.fold(&2, &2, TupleOf3(String, One_paths.Expectation, CheckResult(Unit)), Big, (+local17546 => +local17548 => ((+scrut17549 = local17548
Match.Tuple3(&2, String, &2, One_paths.Expectation, &2, CheckResult(Unit), &2, Big, scrut17549, +p17550 => +p17551 => +p17552 => ((+scrut17562 = {One_paths.observed(p17551, p17552) : Bool}
(+scrut17566 = {Match.Result(&2, Unit, &2, Error, &2, String, p17552, +x => (+local17564 => ((+scrut17565 = local17564
"accepted")))(x), +x => Error.to_string(x)) : String}
(+discard17567 = {Unit{} : Unit}
NativeInt.add(local17546, Native.choose(&2, Big, scrut17562, _ => (Big.one()), _ => (Big.zero()))))))))))), scrut17544, Big.zero()) : Big}
(+discard17569 = {Unit{} : Unit}
Done{Big.is_eq(scrut17568, Big.of_nat(List.length(&2, TupleOf3(String, One_paths.Expectation, CheckResult(Unit)), scrut17544)))}))))))(item17571)), +item17572 => Fail{item17572})))(item17573)), +item17574 => Fail{item17574})))(item17575)), +item17576 => Fail{item17576})))(item17577)), +item17578 => Fail{item17578})))
@unsafe
def Export_mu.quoted(+s_317: String) -> StringResult(String):
  Native.choose(&2, StringResult(String), NativeString.all((+local17600 => (Big.when(Bool, Big.is_le(Big.of_nat(32n), Big.of_nat(U32.to_nat(Char.to_u32(local17600)))), _ => (Big.is_le(Big.of_nat(U32.to_nat(Char.to_u32(local17600))), Big.of_nat(126n))), _ => (False{})))), s_317), _ => (Done{String.concat([NativeString.quoted(s_317)])}), _ => (Fail{"the bridge exporter requires printable ASCII names"}))
@unsafe
def Export_mu.natural(+n_437: Big) -> StringResult(String):
  Native.choose(&2, StringResult(String), Big.is_le(Big.zero(), n_437), _ => (Done{Big.show(n_437)}), _ => (Fail{"negative raw index or arity"}))
@unsafe
def Export_mu.quantity(+q_467: Quantity) -> String:
  (+scrut17632 = q_467
  Match.Quantity(&2, String, scrut17632, _ => (".zero"), _ => (".one"), _ => (".many")))
@unsafe
def Export_mu.sequence(-q0: Quant, -A0: Kind(q0), +f_496: Reusable(A0, StringResult(String)), +xs_497: List<q0, A0>) -> StringResult(ListOf(String)):
  (+scrut17652 = xs_497
  Match.List(q0, A0, &2, StringResult(ListOf(String)), scrut17652, _ => (Done{Nil{}}), +p17653 => +p17654 => (Match.Result(&2, String, &2, String, &2, StringResult(ListOf(String)), f_496(p17653), +item17663 => ((+local17657 => (Match.Result(&2, ListOf(String), &2, String, &2, StringResult(ListOf(String)), Export_mu.sequence(q0, A0, f_496, p17654), +item17661 => ((+local17660 => (Done{Con{local17657, local17660}}))(item17661)), +item17662 => Fail{item17662})))(item17663)), +item17664 => Fail{item17664}))))
@unsafe
def Export_mu.list(-q0: Quant, -A0: Kind(q0), +f_504: Reusable(A0, StringResult(String)), +xs_505: List<q0, A0>) -> StringResult(String):
  Match.Result(&2, ListOf(String), &2, String, &2, StringResult(String), Export_mu.sequence(q0, A0, f_504, xs_505), +item17665 => (Done{(+local17651 => (String.append("[", String.append(String.join(local17651, ", "), "]"))))(item17665)}), +item17666 => Fail{item17666})
@unsafe
def Export_mu.shape(+s_804: Shape<&2, Term>) -> StringResult(String):
  (+scrut17622 = s_804
  Match.Shape(&2, Term, &2, StringResult(String), scrut17622, +p17623 => +p17624 => +p17625 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(p17624), +item17635 => ((+local17628 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17625), +item17633 => ((+local17631 => (Done{String.append("(.SPi ", String.append(Export_mu.quantity(p17623), String.append(" ", String.append(local17628, String.append(" ", String.append(local17631, ")"))))))}))(item17633)), +item17634 => Fail{item17634})))(item17635)), +item17636 => Fail{item17636})), +p17637 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.natural(p17637), +item17640 => (Done{(+local17639 => (String.append("(.SColl ", String.append(local17639, ")"))))(item17640)}), +item17641 => Fail{item17641})), +p17642 => +p17643 => (Fail{"SPar has no raw mirror"}), +p17644 => +p17645 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(p17644), +item17671 => ((+local17648 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, Term, Export_mu.term, p17645), +item17669 => ((+local17668 => (Done{String.append("(.SMu ", String.append(local17648, String.append(" ", String.append(local17668, ")"))))}))(item17669)), +item17670 => Fail{item17670})))(item17671)), +item17672 => Fail{item17672})), +p17673 => +p17674 => (Fail{"SNu has no raw mirror"})))
@unsafe
def Export_mu.former(+tag_799: String, +s_800: Shape<&2, Term>, +body_801: Term) -> StringResult(String):
  Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.shape(s_800), +item17682 => ((+local17676 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(body_801), +item17680 => ((+local17679 => (Done{String.append("(.", String.append(tag_799, String.append(" ", String.append(local17676, String.append(" ", String.append(local17679, ")"))))))}))(item17680)), +item17681 => Fail{item17681})))(item17682)), +item17683 => Fail{item17683})
@unsafe
def Export_mu.address(+a_816: Term.Addr) -> StringResult(String):
  (+scrut17693 = a_816
  Match.Term_Addr(&2, StringResult(String), scrut17693, +p17694 => +p17695 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17695), +item17699 => ((+local17698 => (Done{String.append("(.apt ", String.append(Export_mu.quantity(p17694), String.append(" ", String.append(local17698, ")"))))}))(item17699)), +item17700 => Fail{item17700})), +p17701 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.natural(p17701), +item17704 => (Done{(+local17703 => (String.append("(.aleg ", String.append(local17703, ")"))))(item17704)}), +item17705 => Fail{item17705})), +p17706 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(p17706), +item17709 => (Done{(+local17708 => (String.append("(.actor ", String.append(local17708, ")"))))(item17709)}), +item17710 => Fail{item17710}))))
@unsafe
def Export_mu.optional(-q0: Quant, -A0: Kind(q0), +f_509: Reusable(A0, StringResult(String)), +x_510: Maybe<q0, A0>) -> StringResult(String):
  Match.Maybe(q0, A0, &2, StringResult(String), x_510, _ => (Done{"none"}), +value => ((+local17732 => (Match.Result(&2, String, &2, String, &2, StringResult(String), f_509(local17732), +item17735 => (Done{(+local17734 => (String.append("(some ", String.append(local17734, ")"))))(item17735)}), +item17736 => Fail{item17736})))(value)))
@unsafe
def Export_mu.motive(+m_832: Term.Motive) -> StringResult(String):
  Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.optional(&2, String, Export_mu.quoted, Get.Term.Motive.m_ind(m_832)), +item17754 => ((+local17738 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, String, Export_mu.quoted, Get.Term.Motive.m_idx(m_832)), +item17752 => ((+local17741 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(Get.Term.Motive.m_self(m_832)), +item17750 => ((+local17744 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(Get.Term.Motive.m_body(m_832)), +item17748 => ((+local17747 => (Done{String.append("(.mk ", String.append(local17738, String.append(" ", String.append(local17741, String.append(" ", String.append(local17744, String.append(" ", String.append(local17747, ")"))))))))}))(item17748)), +item17749 => Fail{item17749})))(item17750)), +item17751 => Fail{item17751})))(item17752)), +item17753 => Fail{item17753})))(item17754)), +item17755 => Fail{item17755})
@unsafe
def Export_mu.binder(+param_535: TupleOf2(Quantity, String)) -> StringResult(String):
  (+scrut17767 = param_535
  Match.Tuple2(&2, Quantity, &2, String, &2, StringResult(String), scrut17767, +p17768 => +p17769 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(p17769), +item17773 => ((+local17772 => (Done{String.append("(", String.append(Export_mu.quantity(p17768), String.append(", ", String.append(local17772, ")"))))}))(item17773)), +item17774 => Fail{item17774}))))
@unsafe
def Export_mu.leg(+l_824: Term.Leg) -> StringResult(String):
  Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, TupleOf2(Quantity, String), Export_mu.binder, Get.Term.Leg.l_binders(l_824)), +item17782 => ((+local17776 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(Get.Term.Leg.l_body(l_824)), +item17780 => ((+local17779 => (Done{String.append("(.mk ", String.append(local17776, String.append(" ", String.append(local17779, ")"))))}))(item17780)), +item17781 => Fail{item17781})))(item17782)), +item17783 => Fail{item17783})
@unsafe
def Export_mu.branch(+param_831: TupleOf2(Term.Addr, Term.Leg)) -> StringResult(String):
  (+scrut17759 = param_831
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, StringResult(String), scrut17759, +p17760 => +p17761 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.address(p17760), +item17788 => ((+local17764 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.leg(p17761), +item17786 => ((+local17785 => (Done{String.append("(", String.append(local17764, String.append(", ", String.append(local17785, ")"))))}))(item17786)), +item17787 => Fail{item17787})))(item17788)), +item17789 => Fail{item17789}))))
@unsafe
def Export_mu.term(t_560):
  (+scrut17612 = t_560
  Match.Term(&2, StringResult(String), scrut17612, +p17613 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.natural(p17613), +item17616 => (Done{(+local17615 => (String.append("(.var ", String.append(local17615, ")"))))(item17616)}), +item17617 => Fail{item17617})), +p17618 => (Done{String.append("(.univ ", String.append(Level.to_string(p17618), ")"))}), +p17619 => +p17620 => (Export_mu.former("lan", p17619, p17620)), +p17684 => +p17685 => (Export_mu.former("ran", p17684, p17685)), +p17686 => +p17687 => +p17688 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.shape(p17686), +item17720 => ((+local17691 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.address(p17687), +item17718 => ((+local17712 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, Term, Export_mu.term, p17688), +item17716 => ((+local17715 => (Done{String.append("(.intro ", String.append(local17691, String.append(" ", String.append(local17712, String.append(" ", String.append(local17715, ")"))))))}))(item17716)), +item17717 => Fail{item17717})))(item17718)), +item17719 => Fail{item17719})))(item17720)), +item17721 => Fail{item17721})), +p17722 => ((Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.shape(Get.Term.Elim.e_shape(p17722)), +item17798 => ((+local17725 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(Get.Term.Elim.e_scrut(p17722)), +item17796 => ((+local17728 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.optional(&2, Term.Motive, Export_mu.motive, Get.Term.Elim.e_motive(p17722)), +item17794 => ((+local17757 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, TupleOf2(Term.Addr, Term.Leg), Export_mu.branch, Get.Term.Elim.e_branches(p17722)), +item17792 => ((+local17791 => (Done{String.append("(.elim ", String.append(local17725, String.append(" ", String.append(local17728, String.append(" ", String.append(Export_mu.quantity(Get.Term.Elim.e_scrut_q(p17722)), String.append(" ", String.append(local17757, String.append(" ", String.append(local17791, ")"))))))))))}))(item17792)), +item17793 => Fail{item17793})))(item17794)), +item17795 => Fail{item17795})))(item17796)), +item17797 => Fail{item17797})))(item17798)), +item17799 => Fail{item17799}))), +p17801 => +p17802 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.shape(p17801), +item17811 => ((+local17805 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, Term.Leg, Export_mu.leg, p17802), +item17809 => ((+local17808 => (Done{String.append("(.sec ", String.append(local17805, String.append(" ", String.append(local17808, ")"))))}))(item17809)), +item17810 => Fail{item17810})))(item17811)), +item17812 => Fail{item17812})), +p17813 => +p17814 => +p17815 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.shape(p17813), +item17829 => ((+local17818 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.address(p17814), +item17827 => ((+local17821 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17815), +item17825 => ((+local17824 => (Done{String.append("(.out ", String.append(local17818, String.append(" ", String.append(local17821, String.append(" ", String.append(local17824, ")"))))))}))(item17825)), +item17826 => Fail{item17826})))(item17827)), +item17828 => Fail{item17828})))(item17829)), +item17830 => Fail{item17830})), +p17831 => +p17832 => +p17833 => +p17834 => ((Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(p17831), +item17853 => ((+local17837 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17832), +item17851 => ((+local17840 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17833), +item17849 => ((+local17843 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17834), +item17847 => ((+local17846 => (Done{String.append("(.letIn ", String.append(local17837, String.append(" ", String.append(local17840, String.append(" ", String.append(local17843, String.append(" ", String.append(local17846, ")"))))))))}))(item17847)), +item17848 => Fail{item17848})))(item17849)), +item17850 => Fail{item17850})))(item17851)), +item17852 => Fail{item17852})))(item17853)), +item17854 => Fail{item17854}))), +p17856 => +p17857 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17856), +item17866 => ((+local17860 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17857), +item17864 => ((+local17863 => (Done{String.append("(.ann ", String.append(local17860, String.append(" ", String.append(local17863, ")"))))}))(item17864)), +item17865 => Fail{item17865})))(item17866)), +item17867 => Fail{item17867})), +p17868 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(p17868), +item17871 => (Done{(+local17870 => (String.append("(.global ", String.append(local17870, ")"))))(item17871)}), +item17872 => Fail{item17872})), +p17873 => (Match.Literal(&2, StringResult(String), p17873, +p17874 => (Fail{"string literal has no raw mirror"}), +p17875 => (Native.choose(&2, StringResult(String), Big.is_le(Big.zero(), Bignum.sign(p17875)), _ => (Done{String.append("(.lit ", String.append(Bignum.to_string(p17875), ")"))}), _ => (Fail{"negative literal has no natural-number mirror"}))))), _ => (Fail{"Auto has no raw mirror"})))
@unsafe
def Export_mu.field(+param_844: TupleOf3(Quantity, String, Term)) -> StringResult(String):
  (+scrut17604 = param_844
  Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, StringResult(String), scrut17604, +p17605 => +p17606 => +p17607 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(p17606), +item17880 => ((+local17610 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(p17607), +item17878 => ((+local17877 => (Done{String.append("(", String.append(Export_mu.quantity(p17605), String.append(", ", String.append(local17610, String.append(", ", String.append(local17877, ")"))))))}))(item17878)), +item17879 => Fail{item17879})))(item17880)), +item17881 => Fail{item17881}))))
@unsafe
def Export_mu.status(+s_868: Positivity.Ctor_status) -> StringResult(String):
  (+scrut17888 = s_868
  Match.Positivity_Ctor_status(&2, StringResult(String), scrut17888, _ => (Done{".provisional"}), _ => (Done{".builtin"}), +p17889 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, String, Export_mu.quoted, p17889), +item17892 => (Done{(+local17891 => (String.append("(.complete ", String.append(local17891, ")"))))(item17892)}), +item17893 => Fail{item17893}))))
@unsafe
def Export_mu.constructor(+c_861: Positivity.Ctor) -> StringResult(String):
  Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(Get.Positivity.Ctor.c_name(c_861)), +item17915 => ((+local17899 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, TupleOf3(Quantity, String, Term), Export_mu.field, Get.Positivity.Ctor.c_args(c_861)), +item17913 => ((+local17902 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, Term, Export_mu.term, Get.Positivity.Ctor.c_res_idx(c_861)), +item17911 => ((+local17905 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.natural(Get.Positivity.Ctor.c_full_arity(c_861)), +item17909 => ((+local17908 => (Done{String.append("{ name := ", String.append(local17899, String.append(", args := ", String.append(local17902, String.append(", resultIndices := ", String.append(local17905, String.append(", fullArity := ", String.append(local17908, String.append(", selfRecursive := ", String.append(NativeBool.show(Get.Positivity.Ctor.c_self_rec(c_861)), " }"))))))))))}))(item17909)), +item17910 => Fail{item17910})))(item17911)), +item17912 => Fail{item17912})))(item17913)), +item17914 => Fail{item17914})))(item17915)), +item17916 => Fail{item17916})
@unsafe
def Export_mu.declaration(+f_887: Positivity.Family) -> StringResult(String):
  Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.quoted(Get.Positivity.Family.f_name(f_887)), +item17927 => ((+local17602 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, TupleOf3(Quantity, String, Term), Export_mu.field, Get.Positivity.Family.f_params(f_887)), +item17925 => ((+local17883 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, TupleOf3(Quantity, String, Term), Export_mu.field, Get.Positivity.Family.f_indices(f_887)), +item17923 => ((+local17886 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.status(Get.Positivity.Family.f_status(f_887)), +item17921 => ((+local17895 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.list(&2, Positivity.Ctor, Export_mu.constructor, Get.Positivity.Family.f_ctors(f_887)), +item17919 => ((+local17918 => (Done{String.append("{ name := ", String.append(local17602, String.append(", params := ", String.append(local17883, String.append(", indices := ", String.append(local17886, String.append(", level := ", String.append(Level.to_string(Get.Positivity.Family.f_level(f_887)), String.append(", status := ", String.append(local17895, String.append(", constructors := ", String.append(local17918, String.append(", positive := ", String.append(NativeBool.show(Get.Positivity.Family.f_positive(f_887)), " }"))))))))))))))}))(item17919)), +item17920 => Fail{item17920})))(item17921)), +item17922 => Fail{item17922})))(item17923)), +item17924 => Fail{item17924})))(item17925)), +item17926 => Fail{item17926})))(item17927)), +item17928 => Fail{item17928})
@unsafe
def Export_mu.definition(+rows_915: ListOf(TupleOf2(String, Global.Entry)), +name_916: String) -> StringResult(String):
  Match.Result(&2, Global.Entry, &2, String, &2, StringResult(String), (+local17938 => (Match.Maybe(&2, Global.Entry, &2, StringResult(Global.Entry), local17938, _ => Fail{String.append("missing checked definition ", name_916)}, +x => Done{x})))(SeqList.assoc(&2, &2, String, Global.Entry, +x => +y => NativeString.equal(x, y), name_916, rows_915)), +item17961 => ((+local17940 => ((+scrut17941 = local17940
  Match.Global_Entry(&2, StringResult(String), scrut17941, +p17942 => ((Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(Get.Global.Def_entry.def(p17942)), +item17956 => ((+local17945 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.term(Get.Global.Def_entry.ty(p17942)), +item17954 => ((+local17948 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.optional(&2, Big, Export_mu.natural, Get.Global.Def_entry.rec_arg(p17942)), +item17952 => ((+local17951 => (Done{String.append("def ", String.append(name_916, String.append(" : Term :=\u{a}  ", String.append(local17945, String.append("\u{a}\u{a}", String.append("def ", String.append(name_916, String.append("Type : Term :=\u{a}  ", String.append(local17948, String.append("\u{a}\u{a}", String.append("def ", String.append(name_916, String.append("RecArg : Option Nat := ", String.append(local17951, String.append("\u{a}", String.append("def ", String.append(name_916, String.append("Partial : Bool := ", String.append(NativeBool.show(Get.Global.Def_entry.partial(p17942)), String.append("\u{a}", String.append("def ", String.append(name_916, String.append("Reducible : Bool := ", String.append(NativeBool.show(Get.Global.Def_entry.reducible(p17942)), "\u{a}"))))))))))))))))))))))))}))(item17952)), +item17953 => Fail{item17953})))(item17954)), +item17955 => Fail{item17955})))(item17956)), +item17957 => Fail{item17957}))), +p17959 => (Fail{String.append("not a definition: ", name_916)}), +p17960 => (Fail{String.append("not a definition: ", name_916)})))))(item17961)), +item17962 => Fail{item17962})
@unsafe
def Export_mu.export(+source_1010: String) -> StringResult(String):
  Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, String, &2, StringResult(String), (+local17583 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, StringResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), local17583, +item17584 => Done{item17584}, +item17585 => (Fail{Error.to_string(item17585)}))))(Elab.check_in(None{}, Global.initial(), source_1010)), +item17972 => ((+local17587 => ((+scrut17588 = local17587
  Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, StringResult(String), scrut17588, +p17589 => +p17590 => ((Match.Result(&2, Positivity.Family, &2, String, &2, StringResult(String), (+local17594 => (Match.Maybe(&2, Positivity.Family, &2, StringResult(Positivity.Family), local17594, _ => Fail{"the checked fixture has no N family"}, +x => Done{x})))(Global.find_family("N", p17589)), +item17969 => ((+local17596 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.declaration(local17596), +item17967 => ((+local17930 => (Match.Result(&2, ListOf(String), &2, String, &2, StringResult(String), Export_mu.sequence(&2, String, (+local17934 => (Export_mu.definition(p17590, local17934))), Con{"three", Con{"double", Nil{}}}), +item17965 => ((+local17964 => (Done{String.append("/- Generated by dev/mu-bridge/export_mu.ml from the checked fixture. -/\u{a}", String.append("import KanonMeta.MuNat\u{a}\u{a}namespace KanonMeta.MuNat.Generated\u{a}\u{a}", String.append("def declaration : Declaration :=\u{a}  ", String.append(local17930, String.append("\u{a}\u{a}", String.append(String.join(local17964, "\u{a}"), "\u{a}end KanonMeta.MuNat.Generated\u{a}"))))))}))(item17965)), +item17966 => Fail{item17966})))(item17967)), +item17968 => Fail{item17968})))(item17969)), +item17970 => Fail{item17970})))))))(item17972)), +item17973 => Fail{item17973})
@unsafe
def Export_mu.export_tree(+source_1095: String) -> StringResult(String):
  Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, String, &2, StringResult(String), (+local17977 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, StringResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), local17977, +item17978 => Done{item17978}, +item17979 => (Fail{Error.to_string(item17979)}))))(Elab.check_in(None{}, Global.initial(), source_1095)), +item18007 => ((+local17981 => ((+scrut17982 = local17981
  Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, StringResult(String), scrut17982, +p17983 => +p17984 => ((Match.Result(&2, Positivity.Family, &2, String, &2, StringResult(String), (+local17988 => (Match.Maybe(&2, Positivity.Family, &2, StringResult(Positivity.Family), local17988, _ => Fail{"the checked fixture has no Tree family"}, +x => Done{x})))(Global.find_family("Tree", p17983)), +item18004 => ((+local17990 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.declaration(local17990), +item18002 => ((+local17993 => (Match.Result(&2, ListOf(String), &2, String, &2, StringResult(String), Export_mu.sequence(&2, String, (+local17997 => (Export_mu.definition(p17984, local17997))), Con{"sample", Con{"mirror", Nil{}}}), +item18000 => ((+local17999 => (Done{String.append("/- Generated by dev/mu-bridge/export_mu.ml from the checked fixture. -/\u{a}", String.append("import KanonMeta.MuTree\u{a}\u{a}namespace KanonMeta.MuTree.Generated\u{a}\u{a}", String.append("def declaration : MuNat.Declaration :=\u{a}  ", String.append(local17993, String.append("\u{a}\u{a}", String.append(String.join(local17999, "\u{a}"), "\u{a}end KanonMeta.MuTree.Generated\u{a}"))))))}))(item18000)), +item18001 => Fail{item18001})))(item18002)), +item18003 => Fail{item18003})))(item18004)), +item18005 => Fail{item18005})))))))(item18007)), +item18008 => Fail{item18008})
@unsafe
def Export_mu.export_vector(+source_1104: String) -> StringResult(String):
  Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, String, &2, StringResult(String), (+local18012 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, StringResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), local18012, +item18013 => Done{item18013}, +item18014 => (Fail{Error.to_string(item18014)}))))(Elab.check_in(None{}, Global.initial(), source_1104)), +item18055 => ((+local18016 => ((+scrut18017 = local18016
  Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, StringResult(String), scrut18017, +p18018 => +p18019 => ((Match.Result(&2, Positivity.Family, &2, String, &2, StringResult(String), (+local18023 => (Match.Maybe(&2, Positivity.Family, &2, StringResult(Positivity.Family), local18023, _ => Fail{"the checked fixture has no N family"}, +x => Done{x})))(Global.find_family("N", p18018)), +item18052 => ((+local18025 => (Match.Result(&2, Positivity.Family, &2, String, &2, StringResult(String), (+local18029 => (Match.Maybe(&2, Positivity.Family, &2, StringResult(Positivity.Family), local18029, _ => Fail{"the checked fixture has no V family"}, +x => Done{x})))(Global.find_family("V", p18018)), +item18050 => ((+local18031 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.declaration(local18025), +item18048 => ((+local18034 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.declaration(local18031), +item18046 => ((+local18037 => (Match.Result(&2, ListOf(String), &2, String, &2, StringResult(String), Export_mu.sequence(&2, String, (+local18041 => (Export_mu.definition(p18019, local18041))), Con{"sample", Con{"copy", Nil{}}}), +item18044 => ((+local18043 => (Done{String.append("/- Generated by dev/mu-bridge/export_mu.ml from the checked fixture. -/\u{a}", String.append("import KanonMeta.MuVector\u{a}\u{a}namespace KanonMeta.MuVector.Generated\u{a}\u{a}", String.append("def naturalDeclaration : MuNat.Declaration :=\u{a}  ", String.append(local18034, String.append("\u{a}\u{a}", String.append("def declaration : MuNat.Declaration :=\u{a}  ", String.append(local18037, String.append("\u{a}\u{a}", String.append(String.join(local18043, "\u{a}"), "\u{a}end KanonMeta.MuVector.Generated\u{a}")))))))))}))(item18044)), +item18045 => Fail{item18045})))(item18046)), +item18047 => Fail{item18047})))(item18048)), +item18049 => Fail{item18049})))(item18050)), +item18051 => Fail{item18051})))(item18052)), +item18053 => Fail{item18053})))))))(item18055)), +item18056 => Fail{item18056})
@unsafe
def Export_mu.export_finitary(+name_1115: String, +source_1116: String) -> StringResult(String):
  Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, String, &2, StringResult(String), (+local18060 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, StringResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), local18060, +item18061 => Done{item18061}, +item18062 => (Fail{Error.to_string(item18062)}))))(Elab.check_in(None{}, Global.initial(), source_1116)), +item18087 => ((+local18064 => ((+scrut18065 = local18064
  Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, StringResult(String), scrut18065, +p18066 => +p18067 => ((Match.Result(&2, Positivity.Family, &2, String, &2, StringResult(String), (+local18071 => (Match.Maybe(&2, Positivity.Family, &2, StringResult(Positivity.Family), local18071, _ => Fail{String.append("the checked fixture has no ", String.append(name_1115, " family"))}, +x => Done{x})))(Global.find_family(name_1115, p18066)), +item18084 => ((+local18073 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.declaration(local18073), +item18082 => ((+local18076 => (Match.Result(&2, String, &2, String, &2, StringResult(String), Export_mu.definition(p18067, "sample"), +item18080 => ((+local18079 => (Done{String.append("/- Generated by dev/mu-bridge/export_mu.ml from the checked fixture. -/\u{a}", String.append("import KanonMeta.MuFinitary\u{a}\u{a}namespace KanonMeta.MuFinitary.Generated\u{a}\u{a}", String.append("def declaration : MuNat.Declaration :=\u{a}  ", String.append(local18076, String.append("\u{a}\u{a}", String.append(local18079, "\u{a}end KanonMeta.MuFinitary.Generated\u{a}"))))))}))(item18080)), +item18081 => Fail{item18081})))(item18082)), +item18083 => Fail{item18083})))(item18084)), +item18085 => Fail{item18085})))))))(item18087)), +item18088 => Fail{item18088})
def Tests.unit(name: String, result: Result<&2, &2, String, Unit>) -> IO(Unit):
  match result:
    case Fail{message}: NativeIO.die(Unit, 1, String.concat([name, " FAIL: ", message]))
    case Done{unit}: NativeIO.print(String.append(name, " OK"))
def Tests.message(result: Result<&2, &2, String, String>) -> IO(Unit):
  match result:
    case Fail{message}: NativeIO.die(Unit, 1, message)
    case Done{message}: NativeIO.stdout(message)
def Tests.adapter(result: Result<&2, &2, String, String>) -> IO(Unit):
  match result:
    case Fail{message}: NativeIO.die(Unit, 64, message)
    case Done{message}: NativeIO.print(message)
def Tests.kernel() -> IO(Unit): do IO<Unit>:
  Tests.unit("KNEG smu", Main.kneg("smu"))
  Tests.unit("KNEG self", Main.kneg("self"))
  Tests.unit("REC values", Main.recursive_values("values"))
  NativeIO.print("SUITE-KERNEL CORE OK")
@unsafe
def Tests.surface(cases: List<&1, Tuple2<&2, &1, String, Reusable(Unit, Result<&2, &2, String, Unit>)>>, +count: Nat) -> IO(Unit):
  match cases:
    case Nil{}: do IO<Unit>:
      NativeIO.print(String.concat(["SL-SURFACE-OK ", Nat.show(count), "/", Nat.show(count)]))
      NativeIO.print("SL-SURFACE OK")
    case Con{Tup2{name, test}, rest}: do IO<Unit>:
      Tests.unit(String.append("SL-SURFACE ", name), test(Unit{}))
      Tests.surface(rest, (count + 1n: Nat))
def Tests.keccak(result: Result<&2, &2, Keccak_vec.Error, String>) -> IO(Unit):
  match result:
    case Done{hex}: NativeIO.print(String.append("0x", hex))
    case Fail{Keccak_vec.Error.Invalid_hex{}}: NativeIO.die(Unit, 64, "keccak-vec: invalid hex")
    case Fail{Keccak_vec.Error.Odd_hex{}}: NativeIO.die(Unit, 64, "keccak-vec: odd hex")
    case Fail{Keccak_vec.Error.Usage{}}: NativeIO.die(Unit, 64, "keccak-vec: usage")
@unsafe
def Tests.suite(result: Tuple4<&2, &2, &2, &2, Big, Big, Big, Big>) -> IO(Unit):
  match result:
    case Tup4{status, blocks, +mismatch, cases}:
      +ok = Big.is_eq(status, Big.zero())
      +message = String.concat(["STACK-HEIGHT blocks=", Big.show(blocks), " mismatch=", Big.show(mismatch), " cases=", Big.show(cases), Native.choose(&2, String, ok, _ => " OK", _ => " FAIL")])
      Native.choose(&1, IO(Unit), ok, _ => NativeIO.print(message), _ => NativeIO.die(Unit, 1, message))
def Tests.fixture_result(name: String, result: Result<&2, &2, Asm.Error, Asm>) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, Asm.error_text(error))
    case Done{program}: NativeIO.print(String.concat([name, " ", Asm.hex(program)]))
def Tests.asm_fixtures(fixtures: List<&2, Tuple2<&2, &2, String, List<&2, Asm.Block>>>) -> IO(Unit):
  match fixtures:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{Tup2{name, blocks}, rest}: do IO<Unit>:
      Tests.fixture_result(name, Asm.assemble(blocks))
      Tests.asm_fixtures(rest)
def Tests.listing(result: Result<&2, &2, Listing.Error, String>) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 2, Listing.error_text(error))
    case Done{listing}: NativeIO.stdout(listing)
def Tests.heights(rows: List<&2, Asm.Height>) -> IO(Unit):
  match rows:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{MkAsm_Height{label, incoming, outgoing, peak}, rest}: do IO<Unit>:
      NativeIO.print(String.concat([Big.show(outgoing), " ", Big.show(peak)]))
      Tests.heights(rest)
def Tests.effect(result: Result<&2, &2, String, Asm>) -> IO(Unit):
  match result:
    case Fail{error}: do IO<Unit>:
      NativeIO.print(error)
      NativeIO.exit(2)
    case Done{program}: Tests.heights(Asm.heights(program))
@unsafe
def Tests.effect_heights(rows: ListOf(Asm.Height)) -> String:
  match rows:
    case Nil{}: ""
    case Con{MkAsm_Height{_, _, outgoing, peak}, rest}: String.concat([Big.show(outgoing), " ", Big.show(peak), "\n", Tests.effect_heights(rest)])
def Tests.effect_output(result: StringResult(Asm)) -> String:
  match result:
    case Fail{error}: String.concat(["2\n", error, "\n"])
    case Done{program}: String.append("0\n", Tests.effect_heights(Asm.heights(program)))
@unsafe
def Tests.effect_emit(rest: ListOf(String), +text: String) -> IO(Unit): do IO<Unit>:
  NativeIO.stdout(String.concat([Nat.show(String.length(text)), ":", text]))
  Tests.effect_batch(rest)
  return Unit{}
@unsafe
def Tests.effect_batch(fields: ListOf(String)) -> IO(Unit):
  match fields:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{"", Nil{}}: IO.pure(Unit, Unit{})
    case Con{name, Con{height, rest}}: Tests.effect_emit(rest, Tests.effect_output(Asm_cases.effect(name, height)))
    case _: NativeIO.die(Unit, 64, "invalid effect manifest")
def Tests.effect_manifest(result: StringResult(String)) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, error)
    case Done{text}: Tests.effect_batch(NativeString.split(Char.from_u32(0), text))
def Tests.opcode(row: Maybe<&2, Asm.Operation>) -> IO(Unit):
  match row:
    case None{}: IO.pure(Unit, Unit{})
    case Some{MkAsm_Operation{byte, name, pops, pushes}}: NativeIO.print(String.concat([NativeString.pad(2n, '0', Big.hex(byte, False{})), " ", name, " ", Big.show(pops), " ", Big.show(pushes)]))
@unsafe
def Tests.metadata(+n: Nat) -> IO(Unit):
  Native.choose(&1, IO(Unit), Nat.is_lt(n, 256n), _ => (do IO<Unit>:
    Tests.opcode(Asm.decode_opcode(Big.of_nat(n)))
    Tests.metadata((n + 1n: Nat))), _ => IO.pure(Unit, Unit{}))
@unsafe
def Tests.asm_cases(args: List<&2, String>) -> IO(Unit):
  match args:
    case Con{+mode, Nil{}}:
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "suite"), _ => (do IO<Unit>:
        Tests.asm_witnesses()
        Tests.suite(Asm_cases.suite(Unit{}))), _ =>
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "fixtures"), _ => Tests.asm_fixtures(Asm_cases.fixtures()), _ =>
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "metadata"), _ => Tests.metadata(0n), _ => NativeIO.die(Unit, 64, "usage: asm_cases suite | fixtures | listing HEX | effect OPCODE HEIGHT"))))
    case Con{+mode, Con{+hex, Nil{}}}: Native.choose(&1, IO(Unit), NativeString.equal(mode, "listing"), _ => Tests.listing(Listing.render(hex)), _ => Native.choose(&1, IO(Unit), NativeString.equal(mode, "effect-batch"), _ => IO.bind(StringResult(String), Unit, NativeIO.read(hex), result => Tests.effect_manifest(result)), _ => NativeIO.die(Unit, 64, "usage: asm_cases suite | fixtures | listing HEX | effect OPCODE HEIGHT | effect-batch FILE")))
    case Con{mode, Con{name, Con{count, Nil{}}}}: Native.choose(&1, IO(Unit), NativeString.equal(mode, "effect"), _ => Tests.effect(Asm_cases.effect(name, count)), _ => NativeIO.die(Unit, 64, "usage: asm_cases suite | fixtures | listing HEX | effect OPCODE HEIGHT"))
    case _: NativeIO.die(Unit, 64, "usage: asm_cases suite | fixtures | listing HEX | effect OPCODE HEIGHT")
@unsafe
def Tests.compact_hex(result: Result<&2, &2, Asm.Error, Asm>) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, Asm.error_text(error))
    case Done{program}: Native.choose(&1, IO(Unit), NativeString.equal(Asm.hex(program), "6003565b00"), _ => IO.pure(Unit, Unit{}), _ => NativeIO.die(Unit, 1, "ASM-COMPACT FAIL jump bytes"))
@unsafe
def Tests.compact(+message: String) -> IO(Unit):
  Native.choose(&1, IO(Unit), NativeString.equal(message, "ASM-COMPACT cases=618 OK\n"), _ => (do IO<Unit>:
    Tests.compact_hex(Asm.assemble_compact(Asm_compact.jump(Big.of_nat(2n), Big.zero())))
    NativeIO.stdout(message)), _ => NativeIO.die(Unit, 1, String.append("ASM-COMPACT FAIL: ", message)))
@unsafe
def Tests.asm_witness(+name: String, good: Bool) -> IO(Unit):
  Native.choose(&1, IO(Unit), good, _ => IO.pure(Unit, Unit{}), _ => NativeIO.print(String.concat(["ASM-CASE ", name, " FAIL"])))
def Tests.asm_accept(result: TupleOf2(Bool, Big)) -> IO(Unit):
  match result:
    case Tup2{good, _}: Tests.asm_witness("ref20", good)
@unsafe
def Tests.asm_witnesses() -> IO(Unit):
  do IO<Unit>:
    Tests.asm_witness("add-underflow", Asm_cases.rejection("add-underflow", [Asm_cases.stop("x", [Asm.Instruction.Push{""}, Asm.Instruction.Op{"ADD"}])], "UNDERFLOW x ADD got=1 need=2"))
    Tests.asm_witness("goto-height", Asm_cases.rejection("goto-height", [Asm_cases.block(None{}, None{}, "x", [Asm.Instruction.Push{""}], Asm.Ending.Goto{Big.one(), "y"}), Asm_cases.target(None{}, "y")], "HEIGHT-MISMATCH x y got=1 want=0"))
    Tests.asm_witness("branch-overflow", Asm_cases.rejection("branch-overflow", [Asm_cases.block(None{}, None{}, "x", Asm_cases.zeros(Big.of_nat(1024n)), Asm.Ending.Branch{Big.one(), "y", "y"}), Asm_cases.target(Some{Big.of_nat(1023n)}, "y")], "OVERFLOW x PUSH-label got=1025"))
    Tests.asm_accept(Asm_cases.acceptance("ref20", Asm_cases.ref20(), "602a5f55600b56fefefefe5b5f545f5260205ff3"))
@unsafe
def Tests.compact_witness(+name: String, +wide: ListOf(Asm.Block), +narrow: ListOf(Asm.Block)) -> IO(Unit):
  Native.choose(&1, IO(Unit), Big.is_eq(Asm_compact.check(name, wide, narrow), Big.one()), _ => IO.pure(Unit, Unit{}), _ => NativeIO.die(Unit, 1, String.append("ASM-COMPACT FAIL ", name)))
@unsafe
def Tests.compact_all() -> IO(Unit):
  do IO<Unit>:
    Tests.compact_witness("branch-243", Asm_compact.branch(Big.of_nat(2n), Big.of_nat(243n)), Asm_compact.branch(Big.one(), Big.of_nat(243n)))
    Tests.compact_witness("payload-256-1", Asm_compact.payload(Big.of_nat(2n), Big.of_nat(247n), Big.one()), Asm_compact.payload(Big.one(), Big.of_nat(247n), Big.one()))
    Tests.compact_witness("branch-0", Asm_compact.branch(Big.of_nat(2n), Big.zero()), Asm_compact.branch(Big.one(), Big.zero()))
    Tests.compact(Asm_compact.output())
@unsafe
def Tests.emit_result(result: StringResult(String)) -> IO(Unit):
  match result:
    case Fail{message}: do IO<Unit>:
      NativeIO.print(String.append("EMIT-CASES FAIL ", message))
      NativeIO.exit(1)
    case Done{message}: NativeIO.stdout(message)
@unsafe
def Tests.emit_cases(args: List<&2, String>) -> IO(Unit):
  match args:
    case Con{+mode, Nil{}}:
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "constructors"), _ => Tests.emit_result(Emit_cases.constructors(Unit{})), _ =>
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "words"), _ => Tests.emit_result(Emit_cases.words(Unit{})), _ =>
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "storage"), _ => Tests.emit_result(Emit_cases.storage(Unit{})), _ =>
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "layout"), _ => NativeIO.stdout(Layout.print("Q\"\\\n", ["a\t", "b"])), _ => NativeIO.die(Unit, 64, "usage: emit_cases constructors | words | storage | layout")))))
    case _: NativeIO.die(Unit, 64, "usage: emit_cases constructors | words | storage | layout")
def Tests.read_result(result: Result<&2, &2, String, String>) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, error)
    case Done{source}: Tests.unit("ROUNDTRIP", Sl_surface.round_trip(source))
def Tests.roundtrip(args: List<&2, String>) -> IO(Unit):
  match args:
    case Con{path, Nil{}}: IO.bind(Result<&2, &2, String, String>, Unit, NativeIO.read(path), result => Tests.read_result(result))
    case _: NativeIO.die(Unit, 64, "roundtrip FILE")
@unsafe
def Tests.dispatch(+name: String, +args: List<&2, String>) -> IO(Unit):
  Native.choose(&1, IO(Unit), NativeString.equal(name, "contract_route"), _ => Tests.contract_route(args), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "fixture"), _ => Tests.fixture(args), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "one_paths"), _ => Tests.one_paths(One_paths.run(Unit{})), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "export_mu"), _ => Tests.export_mu(args), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "kernel"), _ => Tests.kernel(), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "surface"), _ => Tests.surface(Sl_surface.cases(), 0n), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "abi_codec"), _ => Tests.adapter(Abi_codec.main("abi_codec" <> args)), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "keccak_vec"), _ => Tests.keccak(Keccak_vec.dispatch("keccak_vec" <> args)), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "abi_schema"), _ => NativeIO.print(Abi_schema.output()), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "asm_cases"), _ => Tests.asm_cases(args), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "asm_compact"), _ => Tests.compact_all(), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "emit_cases"), _ => Tests.emit_cases(args), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(name, "roundtrip"), _ => Tests.roundtrip(args), _ => NativeIO.die(Unit, 64, "unknown test adapter"))))))))))))))
def Tests.arguments(args: List<&1, String>) -> List<&2, String>:
  match args:
    case Nil{}: Nil{}
    case Con{head, tail}: head <> Tests.arguments(tail)
def Tests.main(args: List<&2, String>) -> IO(Unit):
  match args:
    case Nil{}: NativeIO.die(Unit, 64, "expected test adapter")
    case Con{"batch", Con{path, Nil{}}}: IO.bind(StringResult(String), Unit, NativeIO.read(path), result => Fixture.batch_manifest(result))
    case Con{name, rest}: Tests.dispatch(name, rest)
def Entry.Tests() -> IO(Unit): IO.bind(List<&1, String>, Unit, NativeIO.args(), args => Tests.main(Tests.arguments(args)))

def Tests.one_paths(result: CheckResult(Bool)) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, Error.to_string(error))
    case Done{True{}}: NativeIO.print("ONE-DIRECT OK")
    case Done{False{}}: NativeIO.die(Unit, 1, "ONE-DIRECT FAIL")

def Fixture.checked(result: CheckResult(ListOf(TupleOf2(String, Global.Entry)))) -> String:
  match result:
    case Fail{error}: String.append("ERR\n", Error.message(error))
    case Done{rows}: String.append("OK\n", Elab.checked_form(rows))
def Fixture.erased(result: CheckResult(ListOf(TupleOf2(String, Erase.Entry)))) -> String:
  match result:
    case Fail{error}: String.append("ERR\n", Error.message(error))
    case Done{rows}: String.append("OK\n", Erase.print(rows))
def Fixture.erase(result: CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))))) -> String:
  match result:
    case Fail{error}: String.append("CHECK_ERR\n", Error.message(error))
    case Done{Tup2{globals, rows}}: Fixture.erased(Erase.program(None{}, globals, rows))
@unsafe
def Fixture.run(+mode: String, +source: String) -> IO(Unit):
  Native.choose(&1, IO(Unit), NativeString.equal(mode, "check"), _ => NativeIO.stdout(Fixture.checked(Elab.check_text(None{}, Global.initial(), source))), _ =>
  Native.choose(&1, IO(Unit), NativeString.equal(mode, "erase"), _ => NativeIO.stdout(Fixture.erase(Elab.check_in(None{}, Global.initial(), source))), _ =>
  NativeIO.die(Unit, 64, "fixture MODE FILE")))
def Fixture.read(mode: String, result: StringResult(String)) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, error)
    case Done{source}: Fixture.run(mode, source)
def Tests.fixture(args: ListOf(String)) -> IO(Unit):
  match args:
    case Con{mode, Con{path, Nil{}}}: IO.bind(StringResult(String), Unit, NativeIO.read(path), result => Fixture.read(mode, result))
    case _: NativeIO.die(Unit, 64, "fixture MODE FILE")

def Fixture.batch_roundtrip(result: StringResult(Unit)) -> String:
  match result:
    case Done{_}: "ROUNDTRIP OK\n"
    case Fail{message}: String.append("ROUNDTRIP FAIL: ", message)
@unsafe
def Fixture.batch_output(+mode: String, +source: String) -> String:
  Native.choose(&2, String, NativeString.equal(mode, "parse"), _ => Fixture.batch_roundtrip(Sl_surface.round_trip(source)), _ =>
  Native.choose(&2, String, NativeString.equal(mode, "check"), _ => Fixture.checked(Elab.check_text(None{}, Global.initial(), source)), _ =>
  Native.choose(&2, String, NativeString.equal(mode, "erase"), _ => Fixture.erase(Elab.check_in(None{}, Global.initial(), source)), _ => "INVALID FIXTURE MODE")))
@unsafe
def Fixture.batch_emit(rest: ListOf(String), +text: String) -> IO(Unit):
  do IO<Unit>:
    NativeIO.stdout(String.append(Nat.show(String.length(text)), String.append(":", text)))
    Fixture.batch(rest)
    return Unit{}
def Fixture.batch_received(mode: String, rest: ListOf(String), result: StringResult(String)) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, error)
    case Done{source}: Fixture.batch_emit(rest, Fixture.batch_output(mode, source))
@unsafe
def Fixture.batch(fields: ListOf(String)) -> IO(Unit):
  match fields:
    case Nil{}: IO.pure(Unit, Unit{})
    case Con{"", Nil{}}: IO.pure(Unit, Unit{})
    case Con{mode, Con{path, rest}}: IO.bind(StringResult(String), Unit, NativeIO.read(path), result => Fixture.batch_received(mode, rest, result))
    case _: NativeIO.die(Unit, 64, "invalid fixture manifest")
def Fixture.batch_manifest(result: StringResult(String)) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, error)
    case Done{text}: Fixture.batch(NativeString.split(Char.from_u32(0), text))

def Tests.export_output(result: StringResult(String)) -> IO(Unit):
  match result:
    case Fail{error}: NativeIO.die(Unit, 1, error)
    case Done{text}: NativeIO.stdout(text)
def Tests.export_read(exporter: Reusable(String, StringResult(String)), path: String, result: StringResult(String)) -> IO(Unit):
  match result:
    case Fail{_}: NativeIO.die(Unit, 1, String.append("cannot read fixture ", path))
    case Done{source}: Tests.export_output(exporter(source))
@unsafe
def Tests.export_file(exporter: Reusable(String, StringResult(String)), +path: String) -> IO(Unit):
  do IO<Unit>:
    regular : Bool <- OS.regular(path)
    Native.choose(&1, IO(Unit), regular, _ => IO.bind(StringResult(String), Unit, NativeIO.read(path), result => Tests.export_read(exporter, path, result)), _ => NativeIO.die(Unit, 1, String.append("cannot read fixture ", path)))
def Tests.export_usage() -> IO(Unit): NativeIO.die(Unit, 1, "usage: export_mu [--tree|--vector] FIXTURE.kan | --finitary FAMILY FIXTURE.kan")
@unsafe
def Tests.export_mu(args: ListOf(String)) -> IO(Unit):
  match args:
    case Con{+path, Nil{}}:
      Native.choose(&1, IO(Unit), Bool.or(NativeString.equal(path, "--tree"), Bool.or(NativeString.equal(path, "--vector"), NativeString.equal(path, "--finitary"))), _ => Tests.export_usage(), _ => Tests.export_file(+source => Export_mu.export(source), path))
    case Con{+mode, Con{path, Nil{}}}:
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "--tree"), _ => Tests.export_file(+source => Export_mu.export_tree(source), path), _ =>
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "--vector"), _ => Tests.export_file(+source => Export_mu.export_vector(source), path), _ => Tests.export_usage()))
    case Con{mode, Con{+family, Con{path, Nil{}}}}:
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "--finitary"), _ => Tests.export_file(+source => Export_mu.export_finitary(family, source), path), _ => Tests.export_usage())
    case _: Tests.export_usage()

type TestPerf.Observation is Data:
  TestPerf.Observation{ok: Bool, source: String, output: String, allocation: ListOf(String)}
type TestPerf.Measurement is Data:
  TestPerf.Measurement{ok: Bool, bytes: U32}
def TestPerf.measure(inputs: ListOf(String), route: Reusable(String, TestPerf.Observation)) -> IO(TestPerf.Measurement):
  import "./test-os.js"
@unsafe
def Tests.large_text(+text: String, count: Nat) -> String:
  match count:
    case 0n: text
    case 1n+rest: Tests.large_text(String.append(text, text), rest)
@unsafe
def Tests.route_result(+source: String, result: CheckResult(TupleOf2(OptionOf(String), String))) -> TestPerf.Observation:
  match result:
    case Fail{_}: TestPerf.Observation{False{}, source, source, Nil{}}
    case Done{Tup2{None{}, output}}: TestPerf.Observation{True{}, source, output, Nil{}}
    case Done{Tup2{Some{_}, output}}: TestPerf.Observation{False{}, source, output, Nil{}}
@unsafe
def Tests.route(+source: String) -> TestPerf.Observation: Tests.route_result(source, Contract.lower(source))
@unsafe
def Tests.route_measurement(result: TestPerf.Measurement) -> IO(Unit):
  match result:
    case TestPerf.Measurement{ok, +bytes}:
      Native.choose(&1, IO(Unit), Bool.and(ok, U32.is_lt(bytes, 131072)),
        _ => NativeIO.print(String.append("CONTRACT-ROUTE core=3 identity=true sampled_bytes=", String.append(U32.show(bytes), " bound=131072 OK"))),
        _ => NativeIO.die(Unit, 1, String.append("CONTRACT-ROUTE FAIL sampled_bytes=", U32.show(bytes))))
@unsafe
def Tests.route_copy(+source: String) -> TestPerf.Observation: Tests.route_result(source, Contract.lower(String.append(source, "")))
def Tests.allocated_observation(observed: TestPerf.Observation, allocation: ListOf(String)) -> TestPerf.Observation:
  match observed:
    case TestPerf.Observation{ok, source, output, _}: TestPerf.Observation{ok, source, output, allocation}
@unsafe
def Tests.route_allocate(+source: String) -> TestPerf.Observation:
  Tests.allocated_observation(Tests.route(source), List.replicate(String, 10000n, source))
def Tests.route_probe(route: Reusable(String, TestPerf.Observation)) -> IO(Unit):
  do IO<Unit>:
    measured : TestPerf.Measurement <- TestPerf.measure([
      String.append("axiom Core : Prop\n--", Tests.large_text("x", 20n)),
      Tests.large_text("a", 20n),
      String.append("contract", Tests.large_text("a", 20n))], route)
    Tests.route_measurement(measured)
@unsafe
def Tests.contract_route(args: ListOf(String)) -> IO(Unit):
  match args:
    case Nil{}: Tests.route_probe(+source => Tests.route(source))
    case Con{+mode, Nil{}}:
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "copy"), _ => Tests.route_probe(+source => Tests.route_copy(source)), _ =>
      Native.choose(&1, IO(Unit), NativeString.equal(mode, "allocate"), _ => Tests.route_probe(+source => Tests.route_allocate(source)), _ => NativeIO.die(Unit, 64, "contract_route [copy|allocate]")))
    case _: NativeIO.die(Unit, 64, "contract_route [copy|allocate]")
