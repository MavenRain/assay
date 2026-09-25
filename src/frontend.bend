# Native Bend source, compiled by dev/build.py.
type Eterm.Fid is Data:
  Eterm.Fid.Fid{a0: String}
type Eterm.Tid is Data:
  Eterm.Tid.Tid{a0: String}
type Eterm.KbranchOf<-Self: Data> is Data:
  MkEterm_KbranchOf{tag: Big, arity: Big, body: Self}
type Eterm.Ktm is Data:
  Eterm.Ktm.KVar{a0: Big}
  Eterm.Ktm.KLit{a0: Literal}
  Eterm.Ktm.KGlobal{a0: String}
  Eterm.Ktm.KErased{}
  Eterm.Ktm.KLet{a0: String, a1: Eterm.Ktm, a2: Eterm.Ktm}
  Eterm.Ktm.KClos{a0: Eterm.Fid, a1: Big, a2: List<&2, Eterm.Ktm>}
  Eterm.Ktm.KApp{a0: Eterm.Ktm, a1: List<&2, Eterm.Ktm>}
  Eterm.Ktm.KTail{a0: Eterm.Ktm, a1: List<&2, Eterm.Ktm>}
  Eterm.Ktm.KStruct{a0: Eterm.Tid, a1: List<&2, Eterm.Ktm>}
  Eterm.Ktm.KProj{a0: Eterm.Tid, a1: Big, a2: Eterm.Ktm}
  Eterm.Ktm.KTag{a0: Eterm.Tid, a1: Big, a2: List<&2, Eterm.Ktm>}
  Eterm.Ktm.KCase{a0: Eterm.Tid, a1: Eterm.Ktm, a2: List<&2, Eterm.KbranchOf<Eterm.Ktm>>}
  Eterm.Ktm.KDelay{a0: Eterm.Fid, a1: List<&2, Eterm.Ktm>}
  Eterm.Ktm.KForce{a0: Eterm.Ktm}
def Eterm.Kbranch() -> Data: Eterm.KbranchOf<Eterm.Ktm>
type Eterm.Repr is Data:
  Eterm.Repr.RI31{}
  Eterm.Repr.RStruct{a0: Eterm.Tid}
  Eterm.Repr.RUnion{a0: Eterm.Tid}
  Eterm.Repr.RFunc{a0: Eterm.Tid}
  Eterm.Repr.RThunk{a0: Eterm.Tid}
type Eterm.Kdecl is Data:
  Eterm.Kdecl.KFun{a0: Eterm.Fid, a1: List<&2, Eterm.Repr>, a2: Eterm.Repr, a3: Eterm.Ktm}
  Eterm.Kdecl.KRec{a0: List<&2, Eterm.Tid>}
type Erase.Entry is Data:
  Erase.Entry.Dropped{}
  Erase.Entry.Postulate{a0: Eterm.Repr}
  Erase.Entry.Code{a0: List<&2, Eterm.Kdecl>}
type Erase.Slot is Data:
  Erase.Slot.SDrop{}
  Erase.Slot.SKeep{}
  Erase.Slot.SExtra{}
type Erase.Ectx is Type:
  MkErase_Ectx{c: Check.Ctx, slots: List<&2, Erase.Slot>, self: String}
type Erase.Acc is Data:
  MkErase_Acc{next: Big, lifted: List<&2, Eterm.Kdecl>, groups: List<&2, Eterm.Tid>}
type Erase.Found is Data:
  Erase.Found.LKeep{a0: Big}
  Erase.Found.LDrop{}
  Erase.Found.LOut{}
type Erase.Form is Data:
  Erase.Form.FUniv{}
  Erase.Form.FLan{a0: Shape<&2, Value>, a1: Value.Closure}
  Erase.Form.FRan{a0: Shape<&2, Value>, a1: Value.Closure}
  Erase.Form.FNat{}
  Erase.Form.FOther{}
type Erase.Point is Data:
  Erase.Point.PPoint{a0: Quantity, a1: String, a2: Value}
  Erase.Point.PColl{a0: Big}
  Erase.Point.POther{}
type Elab.Mu_ref is Data:
  Elab.Mu_ref.RFam{a0: Positivity.Family}
  Elab.Mu_ref.RCtor{a0: Positivity.Family, a1: Positivity.Ctor}
type Parser.Elimination is Data:
  Parser.Elimination.LegacyCase{}
  Parser.Elimination.FiberedMatch{}
type Syntax.Prim is Data:
  Syntax.Prim.PAdd{}
  Syntax.Prim.PSub{}
  Syntax.Prim.PMul{}
  Syntax.Prim.PEq{}
  Syntax.Prim.PLt{}
type Syntax.BinderOf<-Self: Data> is Data:
  MkSyntax_BinderOf{b_q: Quantity, b_name: String, b_ty: Self}
type Syntax.FieldOf<-Self: Data> is Data:
  MkSyntax_FieldOf{fd_q: Quantity, fd_name: String, fd_ty: Maybe<&2, Self>}
type Syntax.MotiveOf<-Self: Data> is Data:
  MkSyntax_MotiveOf{mo_self: String, mo_ind: Maybe<&2, String>, mo_idx: List<&2, String>, mo_body: Self}
type Syntax.BranchOf<-Self: Data> is Data:
  Syntax.BranchOf.BrLeg{a0: Big, a1: List<&2, Syntax.BinderOf<Self>>, a2: Self}
  Syntax.BranchOf.BrCtor{a0: String, a1: List<&2, Syntax.FieldOf<Self>>, a2: Self}
type Syntax is Data:
  Syntax.SVar{a0: String}
  Syntax.SNat{a0: Bignum}
  Syntax.SProp{}
  Syntax.SType{a0: Big}
  Syntax.SPrim{a0: Syntax.Prim}
  Syntax.SUnit{}
  Syntax.SAuto{}
  Syntax.SPair{a0: Syntax, a1: Syntax}
  Syntax.STuple{a0: List<&2, Syntax>}
  Syntax.SSum{a0: List<&2, Syntax>}
  Syntax.SProd{a0: List<&2, Syntax>}
  Syntax.SProj{a0: Syntax, a1: Big}
  Syntax.SInj{a0: Big, a1: Big, a2: Syntax}
  Syntax.SAbsurd{a0: Syntax}
  Syntax.SApp{a0: Syntax, a1: Syntax}
  Syntax.SFun{a0: List<&2, Syntax.BinderOf<Syntax>>, a1: Syntax}
  Syntax.SArrow{a0: Syntax.BinderOf<Syntax>, a1: Syntax}
  Syntax.SStar{a0: Syntax.BinderOf<Syntax>, a1: Syntax}
  Syntax.SLet{a0: String, a1: Syntax, a2: Syntax, a3: Syntax}
  Syntax.SAnn{a0: Syntax, a1: Syntax}
  Syntax.SCase{a0: Syntax, a1: Maybe<&2, Syntax.MotiveOf<Syntax>>, a2: List<&2, Syntax.BranchOf<Syntax>>}
  Syntax.SMatch{a0: Syntax, a1: Maybe<&2, Syntax.MotiveOf<Syntax>>, a2: List<&2, Syntax.BranchOf<Syntax>>}
def Syntax.Binder() -> Data: Syntax.BinderOf<Syntax>
def Syntax.Field() -> Data: Syntax.FieldOf<Syntax>
def Syntax.Motive() -> Data: Syntax.MotiveOf<Syntax>
def Syntax.Branch() -> Data: Syntax.BranchOf<Syntax>
type Syntax.Fam_ctor is Data:
  MkSyntax_Fam_ctor{fc_name: String, fc_ty: Syntax}
type Syntax.Fam is Data:
  MkSyntax_Fam{fm_name: String, fm_params: List<&2, Syntax.Binder>, fm_ty: Syntax, fm_ctors: List<&2, Syntax.Fam_ctor>}
type Syntax.Rec_def is Data:
  MkSyntax_Rec_def{rd_name: String, rd_ty: Syntax, rd_body: Syntax}
type Syntax.Decl is Data:
  Syntax.Decl.DDef{a0: String, a1: Syntax, a2: Syntax}
  Syntax.Decl.DAxiom{a0: String, a1: Syntax}
  Syntax.Decl.DMu{a0: List<&2, Syntax.Fam>}
  Syntax.Decl.DRec{a0: List<&2, Syntax.Rec_def>}
type Token.Loc is Data:
  MkToken_Loc{line: Big, col: Big}
type Token.Kind is Data:
  Token.Kind.LParen{}
  Token.Kind.RParen{}
  Token.Kind.Colon{}
  Token.Kind.ColonEq{}
  Token.Kind.Arrow{}
  Token.Kind.DArrow{}
  Token.Kind.Star{}
  Token.Kind.Comma{}
  Token.Kind.Dot{}
  Token.Kind.Dot1{}
  Token.Kind.Dot2{}
  Token.Kind.Pipe{}
  Token.Kind.Unit{}
  Token.Kind.KDef{}
  Token.Kind.KAxiom{}
  Token.Kind.KFun{}
  Token.Kind.KInj{}
  Token.Kind.KOf{}
  Token.Kind.KCase{}
  Token.Kind.KMatch{}
  Token.Kind.KAs{}
  Token.Kind.KReturn{}
  Token.Kind.KWith{}
  Token.Kind.KTuple{}
  Token.Kind.KSum{}
  Token.Kind.KProd{}
  Token.Kind.KAbsurd{}
  Token.Kind.KProp{}
  Token.Kind.KType{}
  Token.Kind.KLet{}
  Token.Kind.KIn{}
  Token.Kind.KAuto{}
  Token.Kind.KMu{}
  Token.Kind.KMutual{}
  Token.Kind.KEnd{}
  Token.Kind.KNu{}
  Token.Kind.KAnd{}
  Token.Kind.KRec{}
  Token.Kind.KNatAdd{}
  Token.Kind.KNatSub{}
  Token.Kind.KNatMul{}
  Token.Kind.KNatEq{}
  Token.Kind.KNatLt{}
  Token.Kind.Ident{a0: String}
  Token.Kind.Nat{a0: Bignum}
  Token.Kind.Bytes{a0: List<&2, Big>}
  Token.Kind.Eof{}
type Token is Data:
  MkToken{kind: Token.Kind, loc: Token.Loc}
law Equal.Eterm_Tid: for +left: Eterm.Tid for +right: Eterm.Tid Bool
law Equal.ListOf_Eterm_Repr_: for +left: ListOf(Eterm.Repr) for +right: ListOf(Eterm.Repr) Bool
law Equal.Eterm_Repr: for +left: Eterm.Repr for +right: Eterm.Repr Bool
@unsafe
def Match.Erase_Entry(r, -R: Kind(r), value: Erase.Entry, on0: (Unit -> R), on1: (@+a0:Eterm.Repr -> R), on2: (@+a0:ListOf(Eterm.Kdecl) -> R)) -> R:
  match value:
    case Erase.Entry.Dropped{}: on0(Unit{})
    case Erase.Entry.Postulate{a0}: on1(a0)
    case Erase.Entry.Code{a0}: on2(a0)
@unsafe
def Match.Eterm_Kdecl(r, -R: Kind(r), value: Eterm.Kdecl, on0: (@+a0:Eterm.Fid -> @+a1:ListOf(Eterm.Repr) -> @+a2:Eterm.Repr -> @+a3:Eterm.Ktm -> R), on1: (@+a0:ListOf(Eterm.Tid) -> R)) -> R:
  match value:
    case Eterm.Kdecl.KFun{a0, a1, a2, a3}: on0(a0, a1, a2, a3)
    case Eterm.Kdecl.KRec{a0}: on1(a0)
@unsafe
def Match.Eterm_Fid(r, -R: Kind(r), value: Eterm.Fid, on0: (@+a0:String -> R)) -> R:
  match value:
    case Eterm.Fid.Fid{a0}: on0(a0)
@unsafe
def Match.Eterm_Repr(r, -R: Kind(r), value: Eterm.Repr, on0: (Unit -> R), on1: (@+a0:Eterm.Tid -> R), on2: (@+a0:Eterm.Tid -> R), on3: (@+a0:Eterm.Tid -> R), on4: (@+a0:Eterm.Tid -> R)) -> R:
  match value:
    case Eterm.Repr.RI31{}: on0(Unit{})
    case Eterm.Repr.RStruct{a0}: on1(a0)
    case Eterm.Repr.RUnion{a0}: on2(a0)
    case Eterm.Repr.RFunc{a0}: on3(a0)
    case Eterm.Repr.RThunk{a0}: on4(a0)
@unsafe
def Match.Eterm_Ktm(r, -R: Kind(r), value: Eterm.Ktm, on0: (@+a0:Big -> R), on1: (@+a0:Literal -> R), on2: (@+a0:String -> R), on3: (Unit -> R), on4: (@+a0:String -> @+a1:Eterm.Ktm -> @+a2:Eterm.Ktm -> R), on5: (@+a0:Eterm.Fid -> @+a1:Big -> @+a2:ListOf(Eterm.Ktm) -> R), on6: (@+a0:Eterm.Ktm -> @+a1:ListOf(Eterm.Ktm) -> R), on7: (@+a0:Eterm.Ktm -> @+a1:ListOf(Eterm.Ktm) -> R), on8: (@+a0:Eterm.Tid -> @+a1:ListOf(Eterm.Ktm) -> R), on9: (@+a0:Eterm.Tid -> @+a1:Big -> @+a2:Eterm.Ktm -> R), on10: (@+a0:Eterm.Tid -> @+a1:Big -> @+a2:ListOf(Eterm.Ktm) -> R), on11: (@+a0:Eterm.Tid -> @+a1:Eterm.Ktm -> @+a2:ListOf(Eterm.Kbranch) -> R), on12: (@+a0:Eterm.Fid -> @+a1:ListOf(Eterm.Ktm) -> R), on13: (@+a0:Eterm.Ktm -> R)) -> R:
  match value:
    case Eterm.Ktm.KVar{a0}: on0(a0)
    case Eterm.Ktm.KLit{a0}: on1(a0)
    case Eterm.Ktm.KGlobal{a0}: on2(a0)
    case Eterm.Ktm.KErased{}: on3(Unit{})
    case Eterm.Ktm.KLet{a0, a1, a2}: on4(a0, a1, a2)
    case Eterm.Ktm.KClos{a0, a1, a2}: on5(a0, a1, a2)
    case Eterm.Ktm.KApp{a0, a1}: on6(a0, a1)
    case Eterm.Ktm.KTail{a0, a1}: on7(a0, a1)
    case Eterm.Ktm.KStruct{a0, a1}: on8(a0, a1)
    case Eterm.Ktm.KProj{a0, a1, a2}: on9(a0, a1, a2)
    case Eterm.Ktm.KTag{a0, a1, a2}: on10(a0, a1, a2)
    case Eterm.Ktm.KCase{a0, a1, a2}: on11(a0, a1, a2)
    case Eterm.Ktm.KDelay{a0, a1}: on12(a0, a1)
    case Eterm.Ktm.KForce{a0}: on13(a0)
@unsafe
def Equal.Eterm_Tid(left, right):
  match left right:
    case Eterm.Tid.Tid{+left291} Eterm.Tid.Tid{+right292}: Bool.and(NativeString.equal(left291, right292), True{})
@unsafe
def Get.Eterm.Kbranch.tag(value: Eterm.Kbranch) -> Big:
  match value:
    case MkEterm_KbranchOf{field0, _, _}: field0
@unsafe
def Get.Eterm.Kbranch.arity(value: Eterm.Kbranch) -> Big:
  match value:
    case MkEterm_KbranchOf{_, field1, _}: field1
@unsafe
def Get.Eterm.Kbranch.body(value: Eterm.Kbranch) -> Eterm.Ktm:
  match value:
    case MkEterm_KbranchOf{_, _, field2}: field2
@unsafe
def Get.Token.Loc.line(value: Token.Loc) -> Big:
  match value:
    case MkToken_Loc{field0, _}: field0
@unsafe
def Get.Token.Loc.col(value: Token.Loc) -> Big:
  match value:
    case MkToken_Loc{_, field1}: field1
@unsafe
def Match.Token(r, -R: Kind(r), value: Token, on0: (@+a0:Token.Kind -> @+a1:Token.Loc -> R)) -> R:
  match value:
    case MkToken{a0, a1}: on0(a0, a1)
@unsafe
def Match.Token_Kind(r, -R: Kind(r), value: Token.Kind, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R), on3: (Unit -> R), on4: (Unit -> R), on5: (Unit -> R), on6: (Unit -> R), on7: (Unit -> R), on8: (Unit -> R), on9: (Unit -> R), on10: (Unit -> R), on11: (Unit -> R), on12: (Unit -> R), on13: (Unit -> R), on14: (Unit -> R), on15: (Unit -> R), on16: (Unit -> R), on17: (Unit -> R), on18: (Unit -> R), on19: (Unit -> R), on20: (Unit -> R), on21: (Unit -> R), on22: (Unit -> R), on23: (Unit -> R), on24: (Unit -> R), on25: (Unit -> R), on26: (Unit -> R), on27: (Unit -> R), on28: (Unit -> R), on29: (Unit -> R), on30: (Unit -> R), on31: (Unit -> R), on32: (Unit -> R), on33: (Unit -> R), on34: (Unit -> R), on35: (Unit -> R), on36: (Unit -> R), on37: (Unit -> R), on38: (Unit -> R), on39: (Unit -> R), on40: (Unit -> R), on41: (Unit -> R), on42: (Unit -> R), on43: (@+a0:String -> R), on44: (@+a0:Bignum -> R), on45: (@+a0:ListOf(Big) -> R), on46: (Unit -> R)) -> R:
  match value:
    case Token.Kind.LParen{}: on0(Unit{})
    case Token.Kind.RParen{}: on1(Unit{})
    case Token.Kind.Colon{}: on2(Unit{})
    case Token.Kind.ColonEq{}: on3(Unit{})
    case Token.Kind.Arrow{}: on4(Unit{})
    case Token.Kind.DArrow{}: on5(Unit{})
    case Token.Kind.Star{}: on6(Unit{})
    case Token.Kind.Comma{}: on7(Unit{})
    case Token.Kind.Dot{}: on8(Unit{})
    case Token.Kind.Dot1{}: on9(Unit{})
    case Token.Kind.Dot2{}: on10(Unit{})
    case Token.Kind.Pipe{}: on11(Unit{})
    case Token.Kind.Unit{}: on12(Unit{})
    case Token.Kind.KDef{}: on13(Unit{})
    case Token.Kind.KAxiom{}: on14(Unit{})
    case Token.Kind.KFun{}: on15(Unit{})
    case Token.Kind.KInj{}: on16(Unit{})
    case Token.Kind.KOf{}: on17(Unit{})
    case Token.Kind.KCase{}: on18(Unit{})
    case Token.Kind.KMatch{}: on19(Unit{})
    case Token.Kind.KAs{}: on20(Unit{})
    case Token.Kind.KReturn{}: on21(Unit{})
    case Token.Kind.KWith{}: on22(Unit{})
    case Token.Kind.KTuple{}: on23(Unit{})
    case Token.Kind.KSum{}: on24(Unit{})
    case Token.Kind.KProd{}: on25(Unit{})
    case Token.Kind.KAbsurd{}: on26(Unit{})
    case Token.Kind.KProp{}: on27(Unit{})
    case Token.Kind.KType{}: on28(Unit{})
    case Token.Kind.KLet{}: on29(Unit{})
    case Token.Kind.KIn{}: on30(Unit{})
    case Token.Kind.KAuto{}: on31(Unit{})
    case Token.Kind.KMu{}: on32(Unit{})
    case Token.Kind.KMutual{}: on33(Unit{})
    case Token.Kind.KEnd{}: on34(Unit{})
    case Token.Kind.KNu{}: on35(Unit{})
    case Token.Kind.KAnd{}: on36(Unit{})
    case Token.Kind.KRec{}: on37(Unit{})
    case Token.Kind.KNatAdd{}: on38(Unit{})
    case Token.Kind.KNatSub{}: on39(Unit{})
    case Token.Kind.KNatMul{}: on40(Unit{})
    case Token.Kind.KNatEq{}: on41(Unit{})
    case Token.Kind.KNatLt{}: on42(Unit{})
    case Token.Kind.Ident{a0}: on43(a0)
    case Token.Kind.Nat{a0}: on44(a0)
    case Token.Kind.Bytes{a0}: on45(a0)
    case Token.Kind.Eof{}: on46(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KDef_Token_Kind_KAxiom_Token_Kind_KMu_Token_Kind_KMutual_Token_Kind_KNu(r, -R: Kind(r), value: Token.Kind, on13: (Unit -> R), on14: (Unit -> R), on32: (Unit -> R), on33: (Unit -> R), on35: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KDef{}: on13(Unit{})
    case Token.Kind.KAxiom{}: on14(Unit{})
    case Token.Kind.KMu{}: on32(Unit{})
    case Token.Kind.KMutual{}: on33(Unit{})
    case Token.Kind.KNu{}: on35(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KRec_Token_Kind_Ident(r, -R: Kind(r), value: Token.Kind, on37: (Unit -> R), on43: (@+a0:String -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KRec{}: on37(Unit{})
    case Token.Kind.Ident{a0}: on43(a0)
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_Ident(r, -R: Kind(r), value: Token.Kind, on43: (@+a0:String -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.Ident{a0}: on43(a0)
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_Colon(r, -R: Kind(r), value: Token.Kind, on2: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.Colon{}: on2(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_LParen(r, -R: Kind(r), value: Token.Kind, on0: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.LParen{}: on0(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_Nat(r, -R: Kind(r), value: Token.Kind, on44: (@+a0:Bignum -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.Nat{a0}: on44(a0)
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_RParen(r, -R: Kind(r), value: Token.Kind, on1: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.RParen{}: on1(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_Arrow_Token_Kind_Star(r, -R: Kind(r), value: Token.Kind, on4: (Unit -> R), on6: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.Arrow{}: on4(Unit{})
    case Token.Kind.Star{}: on6(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_LParen_Token_Kind_Unit_Token_Kind_KTuple_Token_Kind_KSum_Token_Kind_KProd_Token_Kind_KProp_Token_Kind_KType_Token_Kind_KAuto_Token_Kind_KMu_Token_Kind_KNu_Token_Kind_KAnd_Token_Kind_KNatAdd_Token_Kind_KNatSub_Token_Kind_KNatMul_Token_Kind_KNatEq_Token_Kind_KNatLt_Token_Kind_Ident_Token_Kind_Nat_Token_Kind_Bytes(r, -R: Kind(r), value: Token.Kind, on0: (Unit -> R), on12: (Unit -> R), on23: (Unit -> R), on24: (Unit -> R), on25: (Unit -> R), on27: (Unit -> R), on28: (Unit -> R), on31: (Unit -> R), on32: (Unit -> R), on35: (Unit -> R), on36: (Unit -> R), on38: (Unit -> R), on39: (Unit -> R), on40: (Unit -> R), on41: (Unit -> R), on42: (Unit -> R), on43: (@+a0:String -> R), on44: (@+a0:Bignum -> R), on45: (@+a0:ListOf(Big) -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.LParen{}: on0(Unit{})
    case Token.Kind.Unit{}: on12(Unit{})
    case Token.Kind.KTuple{}: on23(Unit{})
    case Token.Kind.KSum{}: on24(Unit{})
    case Token.Kind.KProd{}: on25(Unit{})
    case Token.Kind.KProp{}: on27(Unit{})
    case Token.Kind.KType{}: on28(Unit{})
    case Token.Kind.KAuto{}: on31(Unit{})
    case Token.Kind.KMu{}: on32(Unit{})
    case Token.Kind.KNu{}: on35(Unit{})
    case Token.Kind.KAnd{}: on36(Unit{})
    case Token.Kind.KNatAdd{}: on38(Unit{})
    case Token.Kind.KNatSub{}: on39(Unit{})
    case Token.Kind.KNatMul{}: on40(Unit{})
    case Token.Kind.KNatEq{}: on41(Unit{})
    case Token.Kind.KNatLt{}: on42(Unit{})
    case Token.Kind.Ident{a0}: on43(a0)
    case Token.Kind.Nat{a0}: on44(a0)
    case Token.Kind.Bytes{a0}: on45(a0)
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_RParen_Token_Kind_Colon_Token_Kind_Comma(r, -R: Kind(r), value: Token.Kind, on1: (Unit -> R), on2: (Unit -> R), on7: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.RParen{}: on1(Unit{})
    case Token.Kind.Colon{}: on2(Unit{})
    case Token.Kind.Comma{}: on7(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_LParen_Token_Kind_Unit(r, -R: Kind(r), value: Token.Kind, on0: (Unit -> R), on12: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.LParen{}: on0(Unit{})
    case Token.Kind.Unit{}: on12(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_RParen_Token_Kind_Comma(r, -R: Kind(r), value: Token.Kind, on1: (Unit -> R), on7: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.RParen{}: on1(Unit{})
    case Token.Kind.Comma{}: on7(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_Dot_Token_Kind_Dot1_Token_Kind_Dot2(r, -R: Kind(r), value: Token.Kind, on8: (Unit -> R), on9: (Unit -> R), on10: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.Dot{}: on8(Unit{})
    case Token.Kind.Dot1{}: on9(Unit{})
    case Token.Kind.Dot2{}: on10(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KInj_Token_Kind_KAbsurd(r, -R: Kind(r), value: Token.Kind, on16: (Unit -> R), on26: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KInj{}: on16(Unit{})
    case Token.Kind.KAbsurd{}: on26(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KOf(r, -R: Kind(r), value: Token.Kind, on17: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KOf{}: on17(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KFun_Token_Kind_KCase_Token_Kind_KMatch_Token_Kind_KLet(r, -R: Kind(r), value: Token.Kind, on15: (Unit -> R), on18: (Unit -> R), on19: (Unit -> R), on29: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KFun{}: on15(Unit{})
    case Token.Kind.KCase{}: on18(Unit{})
    case Token.Kind.KMatch{}: on19(Unit{})
    case Token.Kind.KLet{}: on29(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_DArrow(r, -R: Kind(r), value: Token.Kind, on5: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.DArrow{}: on5(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KAs_Token_Kind_KWith(r, -R: Kind(r), value: Token.Kind, on20: (Unit -> R), on22: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KAs{}: on20(Unit{})
    case Token.Kind.KWith{}: on22(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KIn(r, -R: Kind(r), value: Token.Kind, on30: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KIn{}: on30(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KReturn(r, -R: Kind(r), value: Token.Kind, on21: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KReturn{}: on21(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KWith(r, -R: Kind(r), value: Token.Kind, on22: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KWith{}: on22(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_Pipe(r, -R: Kind(r), value: Token.Kind, on11: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.Pipe{}: on11(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_Ident_Token_Kind_Nat(r, -R: Kind(r), value: Token.Kind, on43: (@+a0:String -> R), on44: (@+a0:Bignum -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.Ident{a0}: on43(a0)
    case Token.Kind.Nat{a0}: on44(a0)
    case _: otherwise(Unit{})
@unsafe
def Get.Syntax.Binder.b_q(value: Syntax.Binder) -> Quantity:
  match value:
    case MkSyntax_BinderOf{field0, _, _}: field0
@unsafe
def Get.Syntax.Binder.b_name(value: Syntax.Binder) -> String:
  match value:
    case MkSyntax_BinderOf{_, field1, _}: field1
@unsafe
def Get.Syntax.Binder.b_ty(value: Syntax.Binder) -> Syntax:
  match value:
    case MkSyntax_BinderOf{_, _, field2}: field2
@unsafe
def Match.Parser_Elimination(r, -R: Kind(r), value: Parser.Elimination, on0: (Unit -> R), on1: (Unit -> R)) -> R:
  match value:
    case Parser.Elimination.LegacyCase{}: on0(Unit{})
    case Parser.Elimination.FiberedMatch{}: on1(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_ColonEq(r, -R: Kind(r), value: Token.Kind, on3: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.ColonEq{}: on3(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KAnd(r, -R: Kind(r), value: Token.Kind, on36: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KAnd{}: on36(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_ColonEq_Token_Kind_KWith(r, -R: Kind(r), value: Token.Kind, on3: (Unit -> R), on22: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.ColonEq{}: on3(Unit{})
    case Token.Kind.KWith{}: on22(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_KMu_Token_Kind_KEnd(r, -R: Kind(r), value: Token.Kind, on32: (Unit -> R), on34: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.KMu{}: on32(Unit{})
    case Token.Kind.KEnd{}: on34(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Token_Kind.only_Token_Kind_Eof(r, -R: Kind(r), value: Token.Kind, on46: (Unit -> R), otherwise: (Unit -> R)) -> R:
  match value:
    case Token.Kind.Eof{}: on46(Unit{})
    case _: otherwise(Unit{})
@unsafe
def Match.Syntax_Decl(r, -R: Kind(r), value: Syntax.Decl, on0: (@+a0:String -> @+a1:Syntax -> @+a2:Syntax -> R), on1: (@+a0:String -> @+a1:Syntax -> R), on2: (@+a0:ListOf(Syntax.Fam) -> R), on3: (@+a0:ListOf(Syntax.Rec_def) -> R)) -> R:
  match value:
    case Syntax.Decl.DDef{a0, a1, a2}: on0(a0, a1, a2)
    case Syntax.Decl.DAxiom{a0, a1}: on1(a0, a1)
    case Syntax.Decl.DMu{a0}: on2(a0)
    case Syntax.Decl.DRec{a0}: on3(a0)
@unsafe
def Match.Syntax(r, -R: Kind(r), value: Syntax, on0: (@+a0:String -> R), on1: (@+a0:Bignum -> R), on2: (Unit -> R), on3: (@+a0:Big -> R), on4: (@+a0:Syntax.Prim -> R), on5: (Unit -> R), on6: (Unit -> R), on7: (@+a0:Syntax -> @+a1:Syntax -> R), on8: (@+a0:ListOf(Syntax) -> R), on9: (@+a0:ListOf(Syntax) -> R), on10: (@+a0:ListOf(Syntax) -> R), on11: (@+a0:Syntax -> @+a1:Big -> R), on12: (@+a0:Big -> @+a1:Big -> @+a2:Syntax -> R), on13: (@+a0:Syntax -> R), on14: (@+a0:Syntax -> @+a1:Syntax -> R), on15: (@+a0:ListOf(Syntax.Binder) -> @+a1:Syntax -> R), on16: (@+a0:Syntax.Binder -> @+a1:Syntax -> R), on17: (@+a0:Syntax.Binder -> @+a1:Syntax -> R), on18: (@+a0:String -> @+a1:Syntax -> @+a2:Syntax -> @+a3:Syntax -> R), on19: (@+a0:Syntax -> @+a1:Syntax -> R), on20: (@+a0:Syntax -> @+a1:OptionOf(Syntax.Motive) -> @+a2:ListOf(Syntax.Branch) -> R), on21: (@+a0:Syntax -> @+a1:OptionOf(Syntax.Motive) -> @+a2:ListOf(Syntax.Branch) -> R)) -> R:
  match value:
    case Syntax.SVar{a0}: on0(a0)
    case Syntax.SNat{a0}: on1(a0)
    case Syntax.SProp{}: on2(Unit{})
    case Syntax.SType{a0}: on3(a0)
    case Syntax.SPrim{a0}: on4(a0)
    case Syntax.SUnit{}: on5(Unit{})
    case Syntax.SAuto{}: on6(Unit{})
    case Syntax.SPair{a0, a1}: on7(a0, a1)
    case Syntax.STuple{a0}: on8(a0)
    case Syntax.SSum{a0}: on9(a0)
    case Syntax.SProd{a0}: on10(a0)
    case Syntax.SProj{a0, a1}: on11(a0, a1)
    case Syntax.SInj{a0, a1, a2}: on12(a0, a1, a2)
    case Syntax.SAbsurd{a0}: on13(a0)
    case Syntax.SApp{a0, a1}: on14(a0, a1)
    case Syntax.SFun{a0, a1}: on15(a0, a1)
    case Syntax.SArrow{a0, a1}: on16(a0, a1)
    case Syntax.SStar{a0, a1}: on17(a0, a1)
    case Syntax.SLet{a0, a1, a2, a3}: on18(a0, a1, a2, a3)
    case Syntax.SAnn{a0, a1}: on19(a0, a1)
    case Syntax.SCase{a0, a1, a2}: on20(a0, a1, a2)
    case Syntax.SMatch{a0, a1, a2}: on21(a0, a1, a2)
@unsafe
def Match.Elab_Mu_ref(r, -R: Kind(r), value: Elab.Mu_ref, on0: (@+a0:Positivity.Family -> R), on1: (@+a0:Positivity.Family -> @+a1:Positivity.Ctor -> R)) -> R:
  match value:
    case Elab.Mu_ref.RFam{a0}: on0(a0)
    case Elab.Mu_ref.RCtor{a0, a1}: on1(a0, a1)
@unsafe
def Match.Syntax_Prim(r, -R: Kind(r), value: Syntax.Prim, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R), on3: (Unit -> R), on4: (Unit -> R)) -> R:
  match value:
    case Syntax.Prim.PAdd{}: on0(Unit{})
    case Syntax.Prim.PSub{}: on1(Unit{})
    case Syntax.Prim.PMul{}: on2(Unit{})
    case Syntax.Prim.PEq{}: on3(Unit{})
    case Syntax.Prim.PLt{}: on4(Unit{})
@unsafe
def Get.Syntax.Motive.mo_ind(value: Syntax.Motive) -> OptionOf(String):
  match value:
    case MkSyntax_MotiveOf{_, field1, _, _}: field1
@unsafe
def Get.Syntax.Motive.mo_self(value: Syntax.Motive) -> String:
  match value:
    case MkSyntax_MotiveOf{field0, _, _, _}: field0
@unsafe
def Get.Syntax.Motive.mo_body(value: Syntax.Motive) -> Syntax:
  match value:
    case MkSyntax_MotiveOf{_, _, _, field3}: field3
@unsafe
def Match.Syntax_Branch(r, -R: Kind(r), value: Syntax.Branch, on0: (@+a0:Big -> @+a1:ListOf(Syntax.Binder) -> @+a2:Syntax -> R), on1: (@+a0:String -> @+a1:ListOf(Syntax.Field) -> @+a2:Syntax -> R)) -> R:
  match value:
    case Syntax.BranchOf.BrLeg{a0, a1, a2}: on0(a0, a1, a2)
    case Syntax.BranchOf.BrCtor{a0, a1, a2}: on1(a0, a1, a2)
@unsafe
def Get.Syntax.Motive.mo_idx(value: Syntax.Motive) -> ListOf(String):
  match value:
    case MkSyntax_MotiveOf{_, _, field2, _}: field2
@unsafe
def Get.Syntax.Field.fd_ty(value: Syntax.Field) -> OptionOf(Syntax):
  match value:
    case MkSyntax_FieldOf{_, _, field2}: field2
@unsafe
def Get.Syntax.Field.fd_name(value: Syntax.Field) -> String:
  match value:
    case MkSyntax_FieldOf{_, field1, _}: field1
@unsafe
def Get.Syntax.Field.fd_q(value: Syntax.Field) -> Quantity:
  match value:
    case MkSyntax_FieldOf{field0, _, _}: field0
@unsafe
def Get.Syntax.Fam.fm_name(value: Syntax.Fam) -> String:
  match value:
    case MkSyntax_Fam{field0, _, _, _}: field0
@unsafe
def Get.Syntax.Fam.fm_params(value: Syntax.Fam) -> ListOf(Syntax.Binder):
  match value:
    case MkSyntax_Fam{_, field1, _, _}: field1
@unsafe
def Get.Syntax.Fam.fm_ty(value: Syntax.Fam) -> Syntax:
  match value:
    case MkSyntax_Fam{_, _, field2, _}: field2
@unsafe
def Get.Syntax.Fam_ctor.fc_ty(value: Syntax.Fam_ctor) -> Syntax:
  match value:
    case MkSyntax_Fam_ctor{_, field1}: field1
@unsafe
def Get.Syntax.Fam_ctor.fc_name(value: Syntax.Fam_ctor) -> String:
  match value:
    case MkSyntax_Fam_ctor{field0, _}: field0
@unsafe
def Get.Syntax.Fam.fm_ctors(value: Syntax.Fam) -> ListOf(Syntax.Fam_ctor):
  match value:
    case MkSyntax_Fam{_, _, _, field3}: field3
@unsafe
def Get.Syntax.Rec_def.rd_ty(value: Syntax.Rec_def) -> Syntax:
  match value:
    case MkSyntax_Rec_def{_, field1, _}: field1
@unsafe
def Get.Syntax.Rec_def.rd_name(value: Syntax.Rec_def) -> String:
  match value:
    case MkSyntax_Rec_def{field0, _, _}: field0
@unsafe
def Get.Syntax.Rec_def.rd_body(value: Syntax.Rec_def) -> Syntax:
  match value:
    case MkSyntax_Rec_def{_, _, field2}: field2
@unsafe
def Match.Eterm_Tid(r, -R: Kind(r), value: Eterm.Tid, on0: (@+a0:String -> R)) -> R:
  match value:
    case Eterm.Tid.Tid{a0}: on0(a0)
@unsafe
def Equal.ListOf_Eterm_Repr_(left, right):
  match left right:
    case Nil{} Nil{}: True{}
    case Con{+left9392, +left9393} Con{+right9394, +right9395}: Bool.and(Equal.Eterm_Repr(left9392, right9394), Bool.and(Equal.ListOf_Eterm_Repr_(left9393, right9395), True{}))
    case _ _: False{}
@unsafe
def Equal.Eterm_Repr(left, right):
  match left right:
    case Eterm.Repr.RI31{} Eterm.Repr.RI31{}: True{}
    case Eterm.Repr.RStruct{+left9396} Eterm.Repr.RStruct{+right9397}: Bool.and(Equal.Eterm_Tid(left9396, right9397), True{})
    case Eterm.Repr.RUnion{+left9398} Eterm.Repr.RUnion{+right9399}: Bool.and(Equal.Eterm_Tid(left9398, right9399), True{})
    case Eterm.Repr.RFunc{+left9400} Eterm.Repr.RFunc{+right9401}: Bool.and(Equal.Eterm_Tid(left9400, right9401), True{})
    case Eterm.Repr.RThunk{+left9402} Eterm.Repr.RThunk{+right9403}: Bool.and(Equal.Eterm_Tid(left9402, right9403), True{})
    case _ _: False{}
@unsafe
def Get.Erase.Ectx.c(value: Erase.Ectx) -> Check.Ctx:
  match value:
    case MkErase_Ectx{field0, _, _}: field0
@unsafe
def Match.Erase_Slot(r, -R: Kind(r), value: Erase.Slot, on0: (Unit -> R), on1: (Unit -> R), on2: (Unit -> R)) -> R:
  match value:
    case Erase.Slot.SDrop{}: on0(Unit{})
    case Erase.Slot.SKeep{}: on1(Unit{})
    case Erase.Slot.SExtra{}: on2(Unit{})
@unsafe
def Match.Erase_Form(r, -R: Kind(r), value: Erase.Form, on0: (Unit -> R), on1: (@+a0:Shape<&2, Value> -> @+a1:Value.Closure -> R), on2: (@+a0:Shape<&2, Value> -> @+a1:Value.Closure -> R), on3: (Unit -> R), on4: (Unit -> R)) -> R:
  match value:
    case Erase.Form.FUniv{}: on0(Unit{})
    case Erase.Form.FLan{a0, a1}: on1(a0, a1)
    case Erase.Form.FRan{a0, a1}: on2(a0, a1)
    case Erase.Form.FNat{}: on3(Unit{})
    case Erase.Form.FOther{}: on4(Unit{})
@unsafe
def Match.Erase_Point(r, -R: Kind(r), value: Erase.Point, on0: (@+a0:Quantity -> @+a1:String -> @+a2:Value -> R), on1: (@+a0:Big -> R), on2: (Unit -> R)) -> R:
  match value:
    case Erase.Point.PPoint{a0, a1, a2}: on0(a0, a1, a2)
    case Erase.Point.PColl{a0}: on1(a0)
    case Erase.Point.POther{}: on2(Unit{})
@unsafe
def Get.Erase.Ectx.slots(value: Erase.Ectx) -> ListOf(Erase.Slot):
  match value:
    case MkErase_Ectx{_, field1, _}: field1
@unsafe
def Get.Erase.Ectx.self(value: Erase.Ectx) -> String:
  match value:
    case MkErase_Ectx{_, _, field2}: field2
@unsafe
def Match.Erase_Found(r, -R: Kind(r), value: Erase.Found, on0: (@+a0:Big -> R), on1: (Unit -> R), on2: (Unit -> R)) -> R:
  match value:
    case Erase.Found.LKeep{a0}: on0(a0)
    case Erase.Found.LDrop{}: on1(Unit{})
    case Erase.Found.LOut{}: on2(Unit{})
@unsafe
def Get.Erase.Acc.next(value: Erase.Acc) -> Big:
  match value:
    case MkErase_Acc{field0, _, _}: field0
@unsafe
def Get.Erase.Acc.lifted(value: Erase.Acc) -> ListOf(Eterm.Kdecl):
  match value:
    case MkErase_Acc{_, field1, _}: field1
@unsafe
def Get.Erase.Acc.groups(value: Erase.Acc) -> ListOf(Eterm.Tid):
  match value:
    case MkErase_Acc{_, _, field2}: field2
law Lexer.go: for +loc_881: Token.Loc for +cs_882: ListOf(Char) for +acc_883: ListOf(Token) CheckResult(ListOf(Token))
law Parser.parse_term: for +ts_791: ListOf(Token) CheckResult(TupleOf2(Syntax, ListOf(Token)))
law Parser.parse_app: for +ts_1009: ListOf(Token) CheckResult(TupleOf2(Syntax, ListOf(Token)))
law Parser.parse_branches: for +form_937: Parser.Elimination for +ts_938: ListOf(Token) for +acc_939: ListOf(Syntax.Branch) CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token)))
law Parser.parse_fields: for +ts_963: ListOf(Token) for +acc_964: ListOf(Syntax.Field) CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token)))
law Parser.parse_fam_ctors: for +ts_1207: ListOf(Token) for +acc_1208: ListOf(Syntax.Fam_ctor) CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)))
law Elab.elab: for +c_1622: Check.Ctx for +expected_1623: OptionOf(Value) for +s_1624: Syntax CheckResult(Term)
law Elab.elab_fun: for +c_1836: Check.Ctx for +expected_1837: OptionOf(Value) for +bs_1838: ListOf(Syntax.Binder) for +body_1839: Syntax CheckResult(Term)
law Erase.repr_of: for +ec_1128: Erase.Ectx for +v_1129: Value CheckResult(Eterm.Repr)
law Erase.arity_of: for +ec_1160: Erase.Ectx for +n_1161: Big for +s_1162: Shape<&2, Value> for +d_1163: Value.Closure CheckResult(Big)
law Erase.mu_leg_reprs: for +ec_1374: Erase.Ectx for +env_1375: ListOf(Value) for +tele_1376: Positivity.Telescope CheckResult(ListOf(OptionOf(Eterm.Repr)))
law Erase.free_vars: for +depth_1447: Big for +t_1448: Term ListOf(Big)
law Erase.reindex_runtime: for +index_1487: Reusable(Big, Big) for +depth_1488: Big for +t_1489: Eterm.Ktm Eterm.Ktm
law Erase.runtime_vars: for +depth_1524: Big for +t_1525: Eterm.Ktm ListOf(Big)
law Erase.term: for +ec_1622: Erase.Ectx for +ac_1623: Erase.Acc for +tail_1624: Bool for +expected_1625: OptionOf(Value) for +t_1626: Term CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc))
law Erase.mu_fields: for +ec_1898: Erase.Ectx for +ac_1899: Erase.Acc for +env_1900: ListOf(Value) for +tele_1901: Positivity.Telescope for +args_1902: ListOf(Term) for +layout_1903: ListOf(OptionOf(Eterm.Repr)) CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc))
law Erase.mu_binders: for +ec_1995: Erase.Ectx for +st_1996: TupleOf3(ListOf(Value), ListOf(Value), Big) for +tele_1997: Positivity.Telescope for +binders_1998: ListOf(TupleOf2(Quantity, String)) for +layout_1999: ListOf(OptionOf(Eterm.Repr)) Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>
law Erase.chain: for +ec_1736: Erase.Ectx for +ac_1737: Erase.Acc for +params_1738: ListOf(Eterm.Repr) for +ty_1739: Value for +t_1740: Term CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc))
law Erase.remaining_signature: for +ec_1775: Erase.Ectx for +s_1776: Shape<&2, Value> for +d_1777: Value.Closure CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr))
law Eterm.print_ktm: for +t_576: Eterm.Ktm String
@unsafe
def Token.start() -> Token.Loc:
  MkToken_Loc{Big.one(), Big.one()}
@unsafe
def Lexer.is_digit(+c_327: Char) -> Bool:
  Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(48)), Char.to_u32(c_327)), _ => (U32.is_le(Char.to_u32(c_327), Char.to_u32(Char.from_u32(57)))), _ => (False{}))
@unsafe
def Token.next_col(+l_281: Token.Loc) -> Token.Loc:
  MkToken_Loc{Get.Token.Loc.line(l_281), NativeInt.add(Get.Token.Loc.col(l_281), Big.one())}
@unsafe
def Lexer.span(+p_433: Reusable(Char, Bool), +loc_434: Token.Loc, +cs_435: ListOf(Char)) -> TupleOf3(ListOf(Char), Token.Loc, ListOf(Char)):
  (+scrut818 = cs_435
  Match.List(&2, Char, &2, TupleOf3(ListOf(Char), Token.Loc, ListOf(Char)), scrut818, _ => (Tup3{Nil{}, loc_434, scrut818}), +p819 => +p820 => (Native.choose(&2, TupleOf3(ListOf(Char), Token.Loc, ListOf(Char)), p_433(p819), _ => ((+scrut821 = {Lexer.span(p_433, Token.next_col(loc_434), p820) : TupleOf3(ListOf(Char), Token.Loc, ListOf(Char))}
  Match.Tuple3(&2, ListOf(Char), &2, Token.Loc, &2, ListOf(Char), &2, TupleOf3(ListOf(Char), Token.Loc, ListOf(Char)), scrut821, +p822 => +p823 => +p824 => (Tup3{Con{p819, p822}, p823, p824})))), _ => (Tup3{Nil{}, loc_434, scrut818})))))
@unsafe
def Lexer.nat_of_digits(+loc_444: Token.Loc, +digits_445: ListOf(Char)) -> CheckResult(Bignum):
  (+local841 => (Match.Maybe(&2, Bignum, &2, CheckResult(Bignum), local841, _ => Fail{Error.Parse{"invalid natural literal", Get.Token.Loc.line(loc_444), Get.Token.Loc.col(loc_444)}}, +x => Done{x})))(Bignum.of_decimal(NativeString.of_list(Series.to_list(&2, Char, Series.of_list(&2, Char, digits_445)))))
@unsafe
def Lexer.is_ident_start(+c_330: Char) -> Bool:
  Big.when(Bool, Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(97)), Char.to_u32(c_330)), _ => (U32.is_le(Char.to_u32(c_330), Char.to_u32(Char.from_u32(122)))), _ => (False{})), _ => (True{}), _ => (Big.when(Bool, Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(65)), Char.to_u32(c_330)), _ => (U32.is_le(Char.to_u32(c_330), Char.to_u32(Char.from_u32(90)))), _ => (False{})), _ => (True{}), _ => (NativeChar.equal(c_330, Char.from_u32(95))))))
@unsafe
def Lexer.is_ident_char(+c_344: Char) -> Bool:
  Big.when(Bool, Lexer.is_ident_start(c_344), _ => (True{}), _ => (Big.when(Bool, Lexer.is_digit(c_344), _ => (True{}), _ => (NativeChar.equal(c_344, Char.from_u32(39))))))
@unsafe
def Lexer.keywords() -> ListOf(TupleOf2(String, Token.Kind)):
  Con{Tup2{"def", Token.Kind.KDef{}}, Con{Tup2{"axiom", Token.Kind.KAxiom{}}, Con{Tup2{"fun", Token.Kind.KFun{}}, Con{Tup2{"inj", Token.Kind.KInj{}}, Con{Tup2{"of", Token.Kind.KOf{}}, Con{Tup2{"case", Token.Kind.KCase{}}, Con{Tup2{"match", Token.Kind.KMatch{}}, Con{Tup2{"as", Token.Kind.KAs{}}, Con{Tup2{"return", Token.Kind.KReturn{}}, Con{Tup2{"with", Token.Kind.KWith{}}, Con{Tup2{"tuple", Token.Kind.KTuple{}}, Con{Tup2{"sum", Token.Kind.KSum{}}, Con{Tup2{"prod", Token.Kind.KProd{}}, Con{Tup2{"absurd", Token.Kind.KAbsurd{}}, Con{Tup2{"Prop", Token.Kind.KProp{}}, Con{Tup2{"Type", Token.Kind.KType{}}, Con{Tup2{"let", Token.Kind.KLet{}}, Con{Tup2{"in", Token.Kind.KIn{}}, Con{Tup2{"natAdd", Token.Kind.KNatAdd{}}, Con{Tup2{"natSub", Token.Kind.KNatSub{}}, Con{Tup2{"natMul", Token.Kind.KNatMul{}}, Con{Tup2{"natEq", Token.Kind.KNatEq{}}, Con{Tup2{"natLt", Token.Kind.KNatLt{}}, Con{Tup2{"auto", Token.Kind.KAuto{}}, Con{Tup2{"mu", Token.Kind.KMu{}}, Con{Tup2{"mutual", Token.Kind.KMutual{}}, Con{Tup2{"end", Token.Kind.KEnd{}}, Con{Tup2{"nu", Token.Kind.KNu{}}, Con{Tup2{"and", Token.Kind.KAnd{}}, Con{Tup2{"rec", Token.Kind.KRec{}}, Nil{}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
@unsafe
def Lexer.ident_kind(+s_348: String) -> Token.Kind:
  (+local853 => (Maybe.default(&2, Token.Kind, local853, Token.Kind.Ident{s_348})))(SeqList.assoc(&2, &2, String, Token.Kind, +x => +y => NativeString.equal(x, y), s_348, Lexer.keywords()))
@unsafe
def Lexer.lex_err(-q0: Quant, -A0: Kind(q0), +loc_307: Token.Loc, +msg_308: String) -> Result<&2, q0, Error, A0>:
  Fail{Error.Parse{msg_308, Get.Token.Loc.line(loc_307), Get.Token.Loc.col(loc_307)}}
@unsafe
def Token.advance(+l_284: Token.Loc, +n_285: Big) -> Token.Loc:
  MkToken_Loc{Get.Token.Loc.line(l_284), NativeInt.add(Get.Token.Loc.col(l_284), n_285)}
@unsafe
def Lexer.hex_digit(+c_822: Char) -> OptionOf(Big):
  (+scrut870 = {Unit{} : Unit}
  Native.choose(&2, OptionOf(Big), Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(48)), Char.to_u32(c_822)), _ => (U32.is_le(Char.to_u32(c_822), Char.to_u32(Char.from_u32(57)))), _ => (False{})), _ => (Some{NativeInt.sub(Big.of_nat(U32.to_nat(Char.to_u32(c_822))), Big.of_nat(U32.to_nat(Char.to_u32(Char.from_u32(48)))))}), _ => (Native.choose(&2, OptionOf(Big), Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(97)), Char.to_u32(c_822)), _ => (U32.is_le(Char.to_u32(c_822), Char.to_u32(Char.from_u32(102)))), _ => (False{})), _ => (Some{NativeInt.sub(NativeInt.add(Big.of_nat(10n), Big.of_nat(U32.to_nat(Char.to_u32(c_822)))), Big.of_nat(U32.to_nat(Char.to_u32(Char.from_u32(97)))))}), _ => (Native.choose(&2, OptionOf(Big), Big.when(Bool, U32.is_le(Char.to_u32(Char.from_u32(65)), Char.to_u32(c_822)), _ => (U32.is_le(Char.to_u32(c_822), Char.to_u32(Char.from_u32(70)))), _ => (False{})), _ => (Some{NativeInt.sub(NativeInt.add(Big.of_nat(10n), Big.of_nat(U32.to_nat(Char.to_u32(c_822)))), Big.of_nat(U32.to_nat(Char.to_u32(Char.from_u32(65)))))}), _ => (None{})))))))
@unsafe
def Lexer.byte_literal(+loc_824: Token.Loc, +cs_825: ListOf(Char), +acc_826: ListOf(Big)) -> CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))):
  (+scrut856 = cs_825
  Match.List(&2, Char, &2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), scrut856, _ => (Lexer.lex_err(&2, TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)), loc_824, "unterminated byte literal")), +p857 => +p858 => ((+otherwise859 = {_ => (Lexer.byte_literal(Token.next_col(loc_824), p858, Con{Big.of_nat(U32.to_nat(Char.to_u32(p857))), acc_826})) : Unit -> CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)))}
  Native.choose(&2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), NativeChar.equal(p857, Char.from_u32(34)), _ => (Done{Tup3{List.reverse(&2, Big, acc_826), Token.next_col(loc_824), p858}}), _ => (Native.choose(&2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), NativeChar.equal(p857, Char.from_u32(10)), _ => (Lexer.lex_err(&2, TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)), loc_824, "unescaped newline in byte literal")), _ => (Native.choose(&2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), NativeChar.equal(p857, Char.from_u32(13)), _ => (Lexer.lex_err(&2, TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)), loc_824, "unescaped newline in byte literal")), _ => (Native.choose(&2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), NativeChar.equal(p857, Char.from_u32(92)), _ => (Match.List(&2, Char, &2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), p858, _ => (Lexer.lex_err(&2, TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)), loc_824, "unterminated byte escape")), +p860 => +p861 => ((+otherwise862 = {_ => ((+scrut863 = {SeqList.assoc(&2, &2, Char, Big, +x => +y => NativeChar.equal(x, y), p860, Con{Tup2{Char.from_u32(110), Big.of_nat(10n)}, Con{Tup2{Char.from_u32(114), Big.of_nat(13n)}, Con{Tup2{Char.from_u32(116), Big.of_nat(9n)}, Con{Tup2{Char.from_u32(48), Big.zero()}, Con{Tup2{Char.from_u32(92), Big.of_nat(92n)}, Con{Tup2{Char.from_u32(34), Big.of_nat(34n)}, Nil{}}}}}}}) : OptionOf(Big)}
  Match.Maybe(&2, Big, &2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), scrut863, _ => (Lexer.lex_err(&2, TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)), loc_824, String.concat(["invalid byte escape \u{5c}", SCon{p860, SNil{}}]))), +value => ((+local865 => (Lexer.byte_literal(Token.advance(loc_824, Big.of_nat(2n)), p861, Con{local865, acc_826})))(value))))) : Unit -> CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)))}
  Native.choose(&2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), NativeChar.equal(p860, Char.from_u32(120)), _ => (Match.List.only_Con(&2, Char, &2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), p861, +p866 => +p867 => (Match.List.only_Con(&2, Char, &2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), p867, +p868 => +p869 => ((+scrut879 = {Match.Maybe(&2, Big, &2, OptionOf(Big), Lexer.hex_digit(p866), _ => None{}, +item878 => ((+local872 => (Match.Maybe(&2, Big, &2, OptionOf(Big), Lexer.hex_digit(p868), _ => None{}, +item876 => (Some{(+local874 => (NativeInt.add(NativeInt.mul(local872, Big.of_nat(16n)), local874)))(item876)}))))(item878))) : OptionOf(Big)}
  Match.Maybe(&2, Big, &2, CheckResult(TupleOf3(ListOf(Big), Token.Loc, ListOf(Char))), scrut879, _ => (Lexer.lex_err(&2, TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)), loc_824, "byte escape requires two hexadecimal digits")), +value => ((+local881 => (Lexer.byte_literal(Token.advance(loc_824, Big.of_nat(4n)), p869, Con{local881, acc_826})))(value))))), _ => (otherwise862(Unit{})))), _ => (otherwise862(Unit{})))), _ => (otherwise862(Unit{}))))))), _ => (otherwise859(Unit{})))))))))))))
@unsafe
def Token.next_line(+l_288: Token.Loc) -> Token.Loc:
  MkToken_Loc{NativeInt.add(Get.Token.Loc.line(l_288), Big.one()), Big.one()}
@unsafe
def Lexer.skip_comment(+loc_924: Token.Loc, +cs_925: ListOf(Char), +acc_926: ListOf(Token)) -> CheckResult(ListOf(Token)):
  (+scrut892 = cs_925
  Match.List(&2, Char, &2, CheckResult(ListOf(Token)), scrut892, _ => (Lexer.go(loc_924, Nil{}, acc_926)), +p893 => +p894 => ((+otherwise895 = {_ => (Lexer.skip_comment(Token.next_col(loc_924), p894, acc_926)) : Unit -> CheckResult(ListOf(Token))}
  Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p893, Char.from_u32(10)), _ => (Lexer.go(Token.next_line(loc_924), p894, acc_926)), _ => (otherwise895(Unit{})))))))
@unsafe
def Lexer.dot_tokens(+loc_655: Token.Loc, +digits_656: ListOf(Char)) -> CheckResult(ListOf(Token)):
  (+scrut908 = digits_656
  Match.List(&2, Char, &2, CheckResult(ListOf(Token)), scrut908, _ => (Done{Con{MkToken{Token.Kind.Dot{}, loc_655}, Nil{}}}), +p909 => +p910 => ((+otherwise911 = {_ => ((+local914 => (Match.Result(&2, Bignum, &2, Error, &2, CheckResult(ListOf(Token)), local914, +item917 => (Done{(+local916 => (Con{MkToken{Token.Kind.Dot{}, loc_655}, Con{MkToken{Token.Kind.Nat{local916}, Token.next_col(loc_655)}, Nil{}}}))(item917)}), +item918 => Fail{item918})))(Lexer.nat_of_digits(loc_655, digits_656))) : Unit -> CheckResult(ListOf(Token))}
  Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p909, Char.from_u32(49)), _ => (Match.List.only_Nil(&2, Char, &2, CheckResult(ListOf(Token)), p910, _ => (Done{Con{MkToken{Token.Kind.Dot1{}, loc_655}, Nil{}}}), _ => (otherwise911(Unit{})))), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p909, Char.from_u32(50)), _ => (Match.List.only_Nil(&2, Char, &2, CheckResult(ListOf(Token)), p910, _ => (Done{Con{MkToken{Token.Kind.Dot2{}, loc_655}, Nil{}}}), _ => (otherwise911(Unit{})))), _ => (otherwise911(Unit{})))))))))
@unsafe
def Lexer.go(loc_881, cs_882, acc_883):
  (+scrut814 = cs_882
  Match.List(&2, Char, &2, CheckResult(ListOf(Token)), scrut814, _ => (Done{List.reverse(&2, Token, Con{MkToken{Token.Kind.Eof{}, loc_881}, acc_883})}), +p815 => +p816 => ((+otherwise817 = {_ => (Native.choose(&2, CheckResult(ListOf(Token)), Lexer.is_digit(p815), _ => ((+scrut825 = {Lexer.span(Lexer.is_digit, Token.next_col(loc_881), p816) : TupleOf3(ListOf(Char), Token.Loc, ListOf(Char))}
  Match.Tuple3(&2, ListOf(Char), &2, Token.Loc, &2, ListOf(Char), &2, CheckResult(ListOf(Token)), scrut825, +p826 => +p827 => +p828 => ((+scrut829 = {Con{p815, p826} : ListOf(Char)}
  Match.Result(&2, Bignum, &2, Error, &2, CheckResult(ListOf(Token)), Lexer.nat_of_digits(loc_881, scrut829), +item844 => ((+local843 => (Lexer.go(p827, p828, Con{MkToken{Token.Kind.Nat{local843}, loc_881}, acc_883})))(item844)), +item845 => Fail{item845})))))), _ => (Native.choose(&2, CheckResult(ListOf(Token)), Lexer.is_ident_start(p815), _ => ((+scrut846 = {Lexer.span(Lexer.is_ident_char, Token.next_col(loc_881), p816) : TupleOf3(ListOf(Char), Token.Loc, ListOf(Char))}
  Match.Tuple3(&2, ListOf(Char), &2, Token.Loc, &2, ListOf(Char), &2, CheckResult(ListOf(Token)), scrut846, +p847 => +p848 => +p849 => ((+scrut850 = {NativeString.of_list(Series.to_list(&2, Char, Series.of_list(&2, Char, Con{p815, p847}))) : String}
  Lexer.go(p848, p849, Con{MkToken{Lexer.ident_kind(scrut850), loc_881}, acc_883})))))), _ => (Lexer.lex_err(&2, ListOf(Token), loc_881, String.concat(["unexpected character ", NativeString.char_quoted(p815)]))))))) : Unit -> CheckResult(ListOf(Token))}
  Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(98)), _ => (Match.List.only_Con(&2, Char, &2, CheckResult(ListOf(Token)), p816, +p854 => +p855 => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p854, Char.from_u32(34)), _ => (Match.Result(&2, TupleOf3(ListOf(Big), Token.Loc, ListOf(Char)), &2, Error, &2, CheckResult(ListOf(Token)), Lexer.byte_literal(Token.advance(loc_881, Big.of_nat(2n)), p855, Nil{}), +item888 => ((+local883 => ((+scrut884 = local883
  Match.Tuple3(&2, ListOf(Big), &2, Token.Loc, &2, ListOf(Char), &2, CheckResult(ListOf(Token)), scrut884, +p885 => +p886 => +p887 => (Lexer.go(p886, p887, Con{MkToken{Token.Kind.Bytes{p885}, loc_881}, acc_883}))))))(item888)), +item889 => Fail{item889})), _ => (otherwise817(Unit{})))), _ => (otherwise817(Unit{})))), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(32)), _ => (Lexer.go(Token.next_col(loc_881), p816, acc_883)), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(9)), _ => (Lexer.go(Token.next_col(loc_881), p816, acc_883)), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(13)), _ => (Lexer.go(Token.next_col(loc_881), p816, acc_883)), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(10)), _ => (Lexer.go(Token.next_line(loc_881), p816, acc_883)), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(45)), _ => (Match.List.only_Con(&2, Char, &2, CheckResult(ListOf(Token)), p816, +p890 => +p891 => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p890, Char.from_u32(45)), _ => (Lexer.skip_comment(Token.advance(loc_881, Big.of_nat(2n)), p891, acc_883)), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p890, Char.from_u32(62)), _ => (Lexer.go(Token.advance(loc_881, Big.of_nat(2n)), p891, Con{MkToken{Token.Kind.Arrow{}, loc_881}, acc_883})), _ => (otherwise817(Unit{})))))), _ => (otherwise817(Unit{})))), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(61)), _ => (Match.List.only_Con(&2, Char, &2, CheckResult(ListOf(Token)), p816, +p896 => +p897 => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p896, Char.from_u32(62)), _ => (Lexer.go(Token.advance(loc_881, Big.of_nat(2n)), p897, Con{MkToken{Token.Kind.DArrow{}, loc_881}, acc_883})), _ => (otherwise817(Unit{})))), _ => (otherwise817(Unit{})))), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(58)), _ => ((+otherwise898 = {_ => (Lexer.go(Token.next_col(loc_881), p816, Con{MkToken{Token.Kind.Colon{}, loc_881}, acc_883})) : Unit -> CheckResult(ListOf(Token))}
  Match.List.only_Con(&2, Char, &2, CheckResult(ListOf(Token)), p816, +p899 => +p900 => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p899, Char.from_u32(61)), _ => (Lexer.go(Token.advance(loc_881, Big.of_nat(2n)), p900, Con{MkToken{Token.Kind.ColonEq{}, loc_881}, acc_883})), _ => (otherwise898(Unit{})))), _ => (otherwise898(Unit{}))))), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(40)), _ => ((+otherwise901 = {_ => (Lexer.go(Token.next_col(loc_881), p816, Con{MkToken{Token.Kind.LParen{}, loc_881}, acc_883})) : Unit -> CheckResult(ListOf(Token))}
  Match.List.only_Con(&2, Char, &2, CheckResult(ListOf(Token)), p816, +p902 => +p903 => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p902, Char.from_u32(41)), _ => (Lexer.go(Token.advance(loc_881, Big.of_nat(2n)), p903, Con{MkToken{Token.Kind.Unit{}, loc_881}, acc_883})), _ => (otherwise901(Unit{})))), _ => (otherwise901(Unit{}))))), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(41)), _ => (Lexer.go(Token.next_col(loc_881), p816, Con{MkToken{Token.Kind.RParen{}, loc_881}, acc_883})), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(42)), _ => (Lexer.go(Token.next_col(loc_881), p816, Con{MkToken{Token.Kind.Star{}, loc_881}, acc_883})), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(44)), _ => (Lexer.go(Token.next_col(loc_881), p816, Con{MkToken{Token.Kind.Comma{}, loc_881}, acc_883})), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(124)), _ => (Lexer.go(Token.next_col(loc_881), p816, Con{MkToken{Token.Kind.Pipe{}, loc_881}, acc_883})), _ => (Native.choose(&2, CheckResult(ListOf(Token)), NativeChar.equal(p815, Char.from_u32(46)), _ => ((+scrut904 = {Lexer.span(Lexer.is_digit, Token.next_col(loc_881), p816) : TupleOf3(ListOf(Char), Token.Loc, ListOf(Char))}
  Match.Tuple3(&2, ListOf(Char), &2, Token.Loc, &2, ListOf(Char), &2, CheckResult(ListOf(Token)), scrut904, +p905 => +p906 => +p907 => (Match.Result(&2, ListOf(Token), &2, Error, &2, CheckResult(ListOf(Token)), Lexer.dot_tokens(loc_881, p905), +item921 => ((+local920 => (Lexer.go(p906, p907, List.reverse.go(&2, Token, local920, acc_883))))(item921)), +item922 => Fail{item922}))))), _ => (otherwise817(Unit{})))))))))))))))))))))))))))))))))
@unsafe
def Lexer.lex(+src_932: String) -> CheckResult(ListOf(Token)):
  Lexer.go(Token.start(), Series.to_list(&2, Char, Series.from_string(src_932)), Nil{})
@unsafe
def Parser.parse_err(-q0: Quant, -A0: Kind(q0), +loc_328: Token.Loc, +msg_329: String) -> Result<&2, q0, Error, A0>:
  Fail{Error.Parse{msg_329, Get.Token.Loc.line(loc_328), Get.Token.Loc.col(loc_328)}}
@unsafe
def Parser.eof_err(-q0: Quant, -A0: Kind(q0)) -> Result<&2, q0, Error, A0>:
  Parser.parse_err(q0, A0, Token.start(), "unexpected end of input")
@unsafe
def Token.describe(+k_520: Token.Kind) -> String:
  (+scrut933 = k_520
  Match.Token_Kind(&2, String, scrut933, _ => ("'('"), _ => ("')'"), _ => ("':'"), _ => ("':='"), _ => ("'->'"), _ => ("'=>'"), _ => ("'*'"), _ => ("','"), _ => ("'.'"), _ => ("'.1'"), _ => ("'.2'"), _ => ("'|'"), _ => ("'()'"), _ => ("'def'"), _ => ("'axiom'"), _ => ("'fun'"), _ => ("'inj'"), _ => ("'of'"), _ => ("'case'"), _ => ("'match'"), _ => ("'as'"), _ => ("'return'"), _ => ("'with'"), _ => ("'tuple'"), _ => ("'sum'"), _ => ("'prod'"), _ => ("'absurd'"), _ => ("'Prop'"), _ => ("'Type'"), _ => ("'let'"), _ => ("'in'"), _ => ("'auto'"), _ => ("'mu'"), _ => ("'mutual'"), _ => ("'end'"), _ => ("'nu'"), _ => ("'and'"), _ => ("'rec'"), _ => ("'natAdd'"), _ => ("'natSub'"), _ => ("'natMul'"), _ => ("'natEq'"), _ => ("'natLt'"), +p934 => (String.concat(["identifier ", p934])), +p935 => (String.append("number ", Bignum.to_string(p935))), +p936 => ("byte literal"), _ => ("end of input")))
@unsafe
def Parser.expected(-q0: Quant, -A0: Kind(q0), +what_349: String, +ts_350: ListOf(Token)) -> Result<&2, q0, Error, A0>:
  (+scrut928 = ts_350
  Match.List(&2, Token, q0, Result<&2, q0, Error, A0>, scrut928, _ => (Parser.eof_err(q0, A0)), +p929 => +p930 => (Match.Token(q0, Result<&2, q0, Error, A0>, p929, +p931 => +p932 => (Parser.parse_err(q0, A0, p932, String.concat(["expected ", what_349, ", found ", Token.describe(p931)])))))))
@unsafe
def Parser.mark_prefix(+ts_400: ListOf(Token)) -> TupleOf2(Quantity, ListOf(Token)):
  (+scrut976 = ts_400
  Match.List(&2, Token, &2, TupleOf2(Quantity, ListOf(Token)), scrut976, _ => (Tup2{Quantity.Many{}, scrut976}), +p977 => +p978 => (Match.Token(&2, TupleOf2(Quantity, ListOf(Token)), p977, +p979 => +p980 => ((+otherwise981 = {_ => (Tup2{Quantity.Many{}, scrut976}) : Unit -> TupleOf2(Quantity, ListOf(Token))}
  Match.Token_Kind.only_Token_Kind_Nat(&2, TupleOf2(Quantity, ListOf(Token)), p979, +p982 => (Native.choose(&2, TupleOf2(Quantity, ListOf(Token)), Bignum.equal(p982, Big.zero()), _ => (Tup2{Quantity.Zero{}, p978}), _ => (Native.choose(&2, TupleOf2(Quantity, ListOf(Token)), Bignum.equal(p982, Big.one()), _ => (Tup2{Quantity.One{}, p978}), _ => (otherwise981(Unit{})))))), _ => (otherwise981(Unit{})))))))))
@unsafe
def Parser.parse_binder(+ts_879: ListOf(Token)) -> CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))):
  (+scrut970 = ts_879
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), scrut970, _ => (Parser.expected(&2, TupleOf2(Syntax.Binder, ListOf(Token)), "'('", ts_879)), +p971 => +p972 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p971, +p973 => +p974 => ((+otherwise975 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Binder, ListOf(Token)), "'('", ts_879)) : Unit -> CheckResult(TupleOf2(Syntax.Binder, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_LParen(&2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p973, _ => ((+scrut983 = {Parser.mark_prefix(p972) : TupleOf2(Quantity, ListOf(Token))}
  Match.Tuple2(&2, Quantity, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), scrut983, +p984 => +p985 => (((+scrut986 = p985
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), scrut986, _ => (Parser.expected(&2, TupleOf2(Syntax.Binder, ListOf(Token)), "a binder name and ':'", p985)), +p987 => +p988 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p987, +p989 => +p990 => ((+otherwise991 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Binder, ListOf(Token)), "a binder name and ':'", p985)) : Unit -> CheckResult(TupleOf2(Syntax.Binder, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_Ident(&2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p989, +p992 => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p988, +p993 => +p994 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p993, +p995 => +p996 => (Match.Token_Kind.only_Token_Kind_Colon(&2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p995, _ => ((Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), Parser.parse_term(p994), +item1009 => ((+local999 => ((+scrut1000 = local999
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), scrut1000, +p1001 => +p1002 => ((+scrut1003 = p1002
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), scrut1003, _ => (Parser.expected(&2, TupleOf2(Syntax.Binder, ListOf(Token)), "')'", p1002)), +p1004 => +p1005 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p1004, +p1006 => +p1007 => ((+otherwise1008 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Binder, ListOf(Token)), "')'", p1002)) : Unit -> CheckResult(TupleOf2(Syntax.Binder, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_RParen(&2, CheckResult(TupleOf2(Syntax.Binder, ListOf(Token))), p1006, _ => (Done{Tup2{MkSyntax_BinderOf{p984, p992, p1001}, p1005}}), _ => (otherwise1008(Unit{}))))))))))))))(item1009)), +item1010 => Fail{item1010}))), _ => (otherwise991(Unit{})))))), _ => (otherwise991(Unit{})))), _ => (otherwise991(Unit{})))))))))))))), _ => (otherwise975(Unit{})))))))))
@unsafe
def Parser.binder_group_attempt(+ts_979: ListOf(Token)) -> OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))):
  (+scrut964 = ts_979
  Match.List(&2, Token, &2, OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))), scrut964, _ => (None{}), +p965 => +p966 => (Match.Token(&2, OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))), p965, +p967 => +p968 => ((+otherwise969 = {_ => (None{}) : Unit -> OptionOf(TupleOf2(Syntax.Binder, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_LParen(&2, OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))), p967, _ => (((+local1015 => (Match.Result(&2, TupleOf2(Syntax.Binder, ListOf(Token)), &2, Error, &2, OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))), local1015, +x => (+local1017 => ((+scrut1018 = local1017
Match.Tuple2(&2, Syntax.Binder, &2, ListOf(Token), &2, OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))), scrut1018, +p1019 => +p1020 => ((+scrut1021 = p1020
Match.List(&2, Token, &2, OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))), scrut1021, _ => (None{}), +p1022 => +p1023 => (Match.Token(&2, OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))), p1022, +p1024 => +p1025 => ((+otherwise1026 = {_ => (None{}) : Unit -> OptionOf(TupleOf2(Syntax.Binder, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_Arrow_Token_Kind_Star(&2, OptionOf(TupleOf2(Syntax.Binder, ListOf(Token))), p1024, _ => (Some{Tup2{p1019, p1020}}), _ => (Some{Tup2{p1019, p1020}}), _ => (otherwise1026(Unit{}))))))))))))))(x), +x => (+local1028 => (None{}))(x))))(Parser.parse_binder(ts_979)))), _ => (otherwise969(Unit{})))))))))
@unsafe
def Parser.parse_paren(+ts_1084: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(ts_1084), +item1088 => ((+local1048 => ((+scrut1049 = local1048
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1049, +p1050 => +p1051 => ((+scrut1052 = p1051
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1052, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "')', ',' or ':'", p1051)), +p1053 => +p1054 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1053, +p1055 => +p1056 => ((+otherwise1057 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "')', ',' or ':'", p1051)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_RParen_Token_Kind_Colon_Token_Kind_Comma(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1055, _ => (Done{Tup2{p1050, p1054}}), _ => ((Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1054), +item1070 => ((+local1060 => ((+scrut1061 = local1060
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1061, +p1062 => +p1063 => ((+scrut1064 = p1063
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1064, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "')'", p1063)), +p1065 => +p1066 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1065, +p1067 => +p1068 => ((+otherwise1069 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "')'", p1063)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_RParen(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1067, _ => (Done{Tup2{Syntax.SAnn{p1050, p1062}, p1066}}), _ => (otherwise1069(Unit{}))))))))))))))(item1070)), +item1071 => Fail{item1071}))), _ => ((Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1054), +item1085 => ((+local1075 => ((+scrut1076 = local1075
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1076, +p1077 => +p1078 => ((+scrut1079 = p1078
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1079, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "')'", p1078)), +p1080 => +p1081 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1080, +p1082 => +p1083 => ((+otherwise1084 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "')'", p1078)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_RParen(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1082, _ => (Done{Tup2{Syntax.SPair{p1050, p1077}, p1081}}), _ => (otherwise1084(Unit{}))))))))))))))(item1085)), +item1086 => Fail{item1086}))), _ => (otherwise1057(Unit{}))))))))))))))(item1088)), +item1089 => Fail{item1089})
@unsafe
def Parser.parse_items_rest(+word_1108: String, +build_1109: Reusable(ListOf(Syntax), Syntax), +ts_1110: ListOf(Token), +acc_1111: ListOf(Syntax)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(ts_1110), +item1111 => ((+local1101 => ((+scrut1102 = local1101
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1102, +p1103 => +p1104 => ((+scrut1105 = p1104
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1105, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "',' or ')'", p1104)), +p1106 => +p1107 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1106, +p1108 => +p1109 => ((+otherwise1110 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "',' or ')'", p1104)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_RParen_Token_Kind_Comma(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1108, _ => (Done{Tup2{build_1109(List.reverse(&2, Syntax, Con{p1103, acc_1111})), p1107}}), _ => (Parser.parse_items_rest(word_1108, build_1109, p1107, Con{p1103, acc_1111})), _ => (otherwise1110(Unit{}))))))))))))))(item1111)), +item1112 => Fail{item1112})
@unsafe
def Parser.parse_items_body(+word_1104: String, +build_1105: Reusable(ListOf(Syntax), Syntax), +ts_1106: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+scrut1098 = ts_1106
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1098, _ => (Parser.parse_items_rest(word_1104, build_1105, ts_1106, Nil{})), +p1113 => +p1114 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1113, +p1115 => +p1116 => ((+otherwise1117 = {_ => (Parser.parse_items_rest(word_1104, build_1105, ts_1106, Nil{})) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_RParen(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1115, _ => (Done{Tup2{build_1105(Nil{}), p1114}}), _ => (otherwise1117(Unit{})))))))))
@unsafe
def Parser.parse_items(+word_1099: String, +build_1100: Reusable(ListOf(Syntax), Syntax), +ts_1101: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+scrut1092 = ts_1101
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1092, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), String.concat(["'(' after '", word_1099, "'"]), ts_1101)), +p1093 => +p1094 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1093, +p1095 => +p1096 => ((+otherwise1097 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), String.concat(["'(' after '", word_1099, "'"]), ts_1101)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_LParen_Token_Kind_Unit(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1095, _ => (Parser.parse_items_body(word_1099, build_1100, p1094)), _ => (Done{Tup2{build_1100(Nil{}), p1094}}), _ => (otherwise1097(Unit{})))))))))
@unsafe
def Parser.bounded_nat(+loc_618: Token.Loc, +n_619: Bignum) -> CheckResult(Big):
  Native.choose(&2, CheckResult(Big), Big.when(Bool, Big.is_lt(Bignum.sign(n_619), Big.zero()), _ => (True{}), _ => (Big.is_lt(Big.of_nat(18n), Big.of_nat(String.length(Bignum.to_string(n_619)))))), _ => (Parser.parse_err(&2, Big, loc_618, "numeric literal too long")), _ => ((+local1131 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local1131, _ => Fail{Error.Parse{"numeric literal too long", Get.Token.Loc.line(loc_618), Get.Token.Loc.col(loc_618)}}, +x => Done{x})))(Bignum.to_int(n_619))))
@unsafe
def Parser.parse_atom_head(+ts_1048: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+scrut1040 = ts_1048
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1040, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "a term", ts_1048)), +p1041 => +p1042 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1041, +p1043 => +p1044 => ((+otherwise1045 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "a term", ts_1048)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_LParen_Token_Kind_Unit_Token_Kind_KTuple_Token_Kind_KSum_Token_Kind_KProd_Token_Kind_KProp_Token_Kind_KType_Token_Kind_KAuto_Token_Kind_KMu_Token_Kind_KNu_Token_Kind_KAnd_Token_Kind_KNatAdd_Token_Kind_KNatSub_Token_Kind_KNatMul_Token_Kind_KNatEq_Token_Kind_KNatLt_Token_Kind_Ident_Token_Kind_Nat_Token_Kind_Bytes(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1043, _ => (Parser.parse_paren(p1042)), _ => (Done{Tup2{Syntax.SUnit{}, p1042}}), _ => (Parser.parse_items("tuple", (+local1091 => (Syntax.STuple{local1091})), p1042)), _ => (Parser.parse_items("sum", (+local1119 => (Syntax.SSum{local1119})), p1042)), _ => (Parser.parse_items("prod", (+local1121 => (Syntax.SProd{local1121})), p1042)), _ => (Done{Tup2{Syntax.SProp{}, p1042}}), _ => ((+otherwise1122 = {_ => (Done{Tup2{Syntax.SType{Big.zero()}, p1042}}) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1042, +p1123 => +p1124 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1123, +p1125 => +p1126 => (Match.Token_Kind.only_Token_Kind_Nat(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1125, +p1127 => (Match.Result(&2, Big, &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.bounded_nat(p1126, p1127), +item1134 => ((+local1133 => (Done{Tup2{Syntax.SType{local1133}, p1124}}))(item1134)), +item1135 => Fail{item1135})), _ => (otherwise1122(Unit{})))))), _ => (otherwise1122(Unit{}))))), _ => (Done{Tup2{Syntax.SAuto{}, p1042}}), _ => (Parser.parse_err(&2, TupleOf2(Syntax, ListOf(Token)), p1044, "a mu group is a declaration and not a term")), _ => (Parser.parse_err(&2, TupleOf2(Syntax, ListOf(Token)), p1044, "nu arrives at M2")), _ => (Parser.parse_err(&2, TupleOf2(Syntax, ListOf(Token)), p1044, "'and' joins two members of a mu group and is not a term")), _ => (Done{Tup2{Syntax.SPrim{Syntax.Prim.PAdd{}}, p1042}}), _ => (Done{Tup2{Syntax.SPrim{Syntax.Prim.PSub{}}, p1042}}), _ => (Done{Tup2{Syntax.SPrim{Syntax.Prim.PMul{}}, p1042}}), _ => (Done{Tup2{Syntax.SPrim{Syntax.Prim.PEq{}}, p1042}}), _ => (Done{Tup2{Syntax.SPrim{Syntax.Prim.PLt{}}, p1042}}), +p1136 => (Done{Tup2{Syntax.SVar{p1136}, p1042}}), +p1137 => (Done{Tup2{Syntax.SNat{p1137}, p1042}}), +p1138 => ((+scrut1143 = {SeqList.fold(&2, &2, Big, Syntax, (+local1140 => +local1142 => (Syntax.SApp{Syntax.SApp{Syntax.SVar{"bytesCons"}, Syntax.SNat{Bignum.of_int(local1142)}}, local1140})), List.reverse(&2, Big, p1138), Syntax.SVar{"bytesNil"}) : Syntax}
  Done{Tup2{scrut1143, p1042}})), _ => (otherwise1045(Unit{})))))))))
@unsafe
def Parser.parse_postfix(+a_1038: Syntax, +ts_1039: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+scrut1149 = ts_1039
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1149, _ => (Done{Tup2{a_1038, ts_1039}}), +p1150 => +p1151 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1150, +p1152 => +p1153 => ((+otherwise1154 = {_ => (Done{Tup2{a_1038, ts_1039}}) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Dot_Token_Kind_Dot1_Token_Kind_Dot2(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1152, _ => ((+otherwise1155 = {_ => (Parser.parse_err(&2, TupleOf2(Syntax, ListOf(Token)), p1153, "expected a leg number after '.'")) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1151, +p1156 => +p1157 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1156, +p1158 => +p1159 => (Match.Token_Kind.only_Token_Kind_Nat(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1158, +p1160 => (Match.Result(&2, Big, &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.bounded_nat(p1159, p1160), +item1164 => ((+local1163 => (Parser.parse_postfix(Syntax.SProj{a_1038, local1163}, p1157)))(item1164)), +item1165 => Fail{item1165})), _ => (otherwise1155(Unit{})))))), _ => (otherwise1155(Unit{}))))), _ => (Parser.parse_postfix(Syntax.SProj{a_1038, Big.one()}, p1151)), _ => (Parser.parse_postfix(Syntax.SProj{a_1038, Big.of_nat(2n)}, p1151)), _ => (otherwise1154(Unit{})))))))))
@unsafe
def Parser.parse_atom(+ts_1034: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_atom_head(ts_1034), +item1166 => ((+local1145 => ((+scrut1146 = local1145
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1146, +p1147 => +p1148 => (Parser.parse_postfix(p1147, p1148))))))(item1166)), +item1167 => Fail{item1167})
@unsafe
def Parser.kind_starts_atom(+k_392: Token.Kind) -> Bool:
  (+scrut1187 = k_392
  Match.Token_Kind(&2, Bool, scrut1187, _ => (True{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (True{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (True{}), _ => (True{}), _ => (True{}), _ => (False{}), _ => (True{}), _ => (True{}), _ => (False{}), _ => (False{}), _ => (True{}), _ => (False{}), _ => (False{}), _ => (False{}), _ => (True{}), _ => (False{}), _ => (False{}), _ => (True{}), _ => (True{}), _ => (True{}), _ => (True{}), _ => (True{}), +p1188 => (True{}), +p1189 => (True{}), +p1190 => (True{}), _ => (False{})))
@unsafe
def Parser.starts_atom(+ts_395: ListOf(Token)) -> Bool:
  (+scrut1182 = ts_395
  Match.List(&2, Token, &2, Bool, scrut1182, _ => (False{}), +p1183 => +p1184 => (Match.Token(&2, Bool, p1183, +p1185 => +p1186 => (Parser.kind_starts_atom(p1185))))))
@unsafe
def Parser.parse_app_rest(+head_1029: Syntax, +ts_1030: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+scrut1173 = {Unit{} : Unit}
  Native.choose(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.starts_atom(ts_1030), _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_atom(ts_1030), +item1180 => ((+local1176 => ((+scrut1177 = local1176
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1177, +p1178 => +p1179 => (Parser.parse_app_rest(Syntax.SApp{head_1029, p1178}, p1179))))))(item1180)), +item1181 => Fail{item1181})), _ => (Done{Tup2{head_1029, ts_1030}})))
@unsafe
def Parser.parse_inj(+ts_1018: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+scrut1206 = ts_1018
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1206, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'K of N' after 'inj'", ts_1018)), +p1207 => +p1208 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1207, +p1209 => +p1210 => ((+otherwise1211 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'K of N' after 'inj'", ts_1018)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Nat(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1209, +p1212 => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1208, +p1213 => +p1214 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1213, +p1215 => +p1216 => (Match.Token_Kind.only_Token_Kind_KOf(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1215, _ => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1214, +p1217 => +p1218 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1217, +p1219 => +p1220 => (Match.Token_Kind.only_Token_Kind_Nat(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1219, +p1221 => ((Match.Result(&2, Big, &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.bounded_nat(p1210, p1212), +item1238 => ((+local1224 => (Match.Result(&2, Big, &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.bounded_nat(p1220, p1221), +item1236 => ((+local1227 => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_app(p1218), +item1234 => ((+local1230 => ((+scrut1231 = local1230
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1231, +p1232 => +p1233 => (Done{Tup2{Syntax.SInj{local1224, local1227, p1232}, p1233}})))))(item1234)), +item1235 => Fail{item1235})))(item1236)), +item1237 => Fail{item1237})))(item1238)), +item1239 => Fail{item1239}))), _ => (otherwise1211(Unit{})))))), _ => (otherwise1211(Unit{})))), _ => (otherwise1211(Unit{})))))), _ => (otherwise1211(Unit{})))), _ => (otherwise1211(Unit{})))))))))
@unsafe
def Parser.parse_app(ts_1009):
  (+scrut1037 = ts_1009
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1037, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_atom(ts_1009), +item1191 => ((+local1169 => ((+scrut1170 = local1169
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1170, +p1171 => +p1172 => (Parser.parse_app_rest(p1171, p1172))))))(item1191)), +item1192 => Fail{item1192})), +p1193 => +p1194 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1193, +p1195 => +p1196 => ((+otherwise1197 = {_ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_atom(ts_1009), +item1204 => ((+local1200 => ((+scrut1201 = local1200
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1201, +p1202 => +p1203 => (Parser.parse_app_rest(p1202, p1203))))))(item1204)), +item1205 => Fail{item1205})) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_KInj_Token_Kind_KAbsurd(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1195, _ => (Parser.parse_inj(p1194)), _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_app(p1194), +item1247 => ((+local1243 => ((+scrut1244 = local1243
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1244, +p1245 => +p1246 => (Done{Tup2{Syntax.SAbsurd{p1245}, p1246}})))))(item1247)), +item1248 => Fail{item1248})), _ => (otherwise1197(Unit{})))))))))
@unsafe
def Parser.parse_arrow_plain(+ts_997: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_app(ts_997), +item1277 => ((+local1250 => ((+scrut1251 = local1250
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1251, +p1252 => +p1253 => (((+scrut1254 = p1253
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1254, _ => (Done{Tup2{p1252, p1253}}), +p1255 => +p1256 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1255, +p1257 => +p1258 => ((+otherwise1259 = {_ => (Done{Tup2{p1252, p1253}}) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_Arrow_Token_Kind_Star(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1257, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1256), +item1266 => ((+local1262 => ((+scrut1263 = local1262
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1263, +p1264 => +p1265 => (Done{Tup2{Syntax.SArrow{MkSyntax_BinderOf{Quantity.Many{}, "_", p1252}, p1264}, p1265}})))))(item1266)), +item1267 => Fail{item1267})), _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1256), +item1274 => ((+local1270 => ((+scrut1271 = local1270
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1271, +p1272 => +p1273 => (Done{Tup2{Syntax.SStar{MkSyntax_BinderOf{Quantity.Many{}, "_", p1252}, p1272}, p1273}})))))(item1274)), +item1275 => Fail{item1275})), _ => (otherwise1259(Unit{})))))))))))))))(item1277)), +item1278 => Fail{item1278})
@unsafe
def Parser.parse_group_op(+b_987: Syntax.Binder, +ts_988: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+scrut1286 = ts_988
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1286, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'->' or '*'", ts_988)), +p1287 => +p1288 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1287, +p1289 => +p1290 => ((+otherwise1291 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'->' or '*'", ts_988)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Arrow_Token_Kind_Star(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1289, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1288), +item1298 => ((+local1294 => ((+scrut1295 = local1294
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1295, +p1296 => +p1297 => (Done{Tup2{Syntax.SArrow{b_987, p1296}, p1297}})))))(item1298)), +item1299 => Fail{item1299})), _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1288), +item1306 => ((+local1302 => ((+scrut1303 = local1302
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1303, +p1304 => +p1305 => (Done{Tup2{Syntax.SStar{b_987, p1304}, p1305}})))))(item1306)), +item1307 => Fail{item1307})), _ => (otherwise1291(Unit{})))))))))
@unsafe
def Parser.parse_arrow(+ts_973: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+local1309 => (local1309(ts_973)))((+local963 => ((+local1033 => +local1035 => (Match.Maybe(&2, TupleOf2(Syntax.Binder, ListOf(Token)), &1, Reusable(ListOf(Token), CheckResult(TupleOf2(Syntax, ListOf(Token)))), local1033, _ => (Parser.parse_arrow_plain), +value => ((+local1280 => ((+scrut1281 = local1280
  Match.Tuple2(&2, Syntax.Binder, &2, ListOf(Token), &1, Reusable(ListOf(Token), CheckResult(TupleOf2(Syntax, ListOf(Token)))), scrut1281, +p1282 => +p1283 => ((+local1285 => (Parser.parse_group_op(p1282, p1283))))))))(value)))(local1035)))(Parser.binder_group_attempt(ts_973), local963))))
@unsafe
def Parser.parse_binders(+ts_807: ListOf(Token), +acc_808: ListOf(Syntax.Binder)) -> CheckResult(TupleOf2(ListOf(Syntax.Binder), ListOf(Token))):
  (+scrut1322 = ts_807
  Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Binder), ListOf(Token))), scrut1322, _ => (Done{Tup2{List.reverse(&2, Syntax.Binder, acc_808), ts_807}}), +p1323 => +p1324 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Binder), ListOf(Token))), p1323, +p1325 => +p1326 => ((+otherwise1327 = {_ => (Done{Tup2{List.reverse(&2, Syntax.Binder, acc_808), ts_807}}) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Binder), ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_LParen(&2, CheckResult(TupleOf2(ListOf(Syntax.Binder), ListOf(Token))), p1325, _ => (Match.Result(&2, TupleOf2(Syntax.Binder, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Binder), ListOf(Token))), Parser.parse_binder(ts_807), +item1334 => ((+local1330 => ((+scrut1331 = local1330
  Match.Tuple2(&2, Syntax.Binder, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Binder), ListOf(Token))), scrut1331, +p1332 => +p1333 => (Parser.parse_binders(p1333, Con{p1332, acc_808}))))))(item1334)), +item1335 => Fail{item1335})), _ => (otherwise1327(Unit{})))))))))
@unsafe
def Parser.parse_fun(+ts_796: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  Match.Result(&2, TupleOf2(Syntax.Binder, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_binder(ts_796), +item1358 => ((+local1317 => ((+scrut1318 = local1317
  Match.Tuple2(&2, Syntax.Binder, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1318, +p1319 => +p1320 => (Match.Result(&2, TupleOf2(ListOf(Syntax.Binder), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_binders(p1320, Con{p1319, Nil{}}), +item1356 => ((+local1337 => ((+scrut1338 = local1337
  Match.Tuple2(&2, ListOf(Syntax.Binder), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1338, +p1339 => +p1340 => (((+scrut1341 = p1340
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1341, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'=>'", p1340)), +p1342 => +p1343 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1342, +p1344 => +p1345 => ((+otherwise1346 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'=>'", p1340)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_DArrow(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1344, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1343), +item1353 => ((+local1349 => ((+scrut1350 = local1349
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1350, +p1351 => +p1352 => (Done{Tup2{Syntax.SFun{p1339, p1351}, p1352}})))))(item1353)), +item1354 => Fail{item1354})), _ => (otherwise1346(Unit{})))))))))))))))(item1356)), +item1357 => Fail{item1357}))))))(item1358)), +item1359 => Fail{item1359})
@unsafe
def Parser.parse_names(+ts_933: ListOf(Token), +acc_934: ListOf(String)) -> TupleOf2(ListOf(String), ListOf(Token)):
  (+scrut1389 = ts_933
  Match.List(&2, Token, &2, TupleOf2(ListOf(String), ListOf(Token)), scrut1389, _ => (Tup2{List.reverse(&2, String, acc_934), ts_933}), +p1390 => +p1391 => (Match.Token(&2, TupleOf2(ListOf(String), ListOf(Token)), p1390, +p1392 => +p1393 => ((+otherwise1394 = {_ => (Tup2{List.reverse(&2, String, acc_934), ts_933}) : Unit -> TupleOf2(ListOf(String), ListOf(Token))}
  Match.Token_Kind.only_Token_Kind_Ident(&2, TupleOf2(ListOf(String), ListOf(Token)), p1392, +p1395 => (Parser.parse_names(p1391, Con{p1395, acc_934})), _ => (otherwise1394(Unit{})))))))))
@unsafe
def Parser.parse_index_clause(+ts_928: ListOf(Token)) -> TupleOf3(OptionOf(String), ListOf(String), ListOf(Token)):
  (+scrut1378 = ts_928
  Match.List(&2, Token, &2, TupleOf3(OptionOf(String), ListOf(String), ListOf(Token)), scrut1378, _ => (Tup3{None{}, Nil{}, ts_928}), +p1379 => +p1380 => (Match.Token(&2, TupleOf3(OptionOf(String), ListOf(String), ListOf(Token)), p1379, +p1381 => +p1382 => ((+otherwise1383 = {_ => (Tup3{None{}, Nil{}, ts_928}) : Unit -> TupleOf3(OptionOf(String), ListOf(String), ListOf(Token))}
  Match.Token_Kind.only_Token_Kind_KIn(&2, TupleOf3(OptionOf(String), ListOf(String), ListOf(Token)), p1381, _ => (Match.List.only_Con(&2, Token, &2, TupleOf3(OptionOf(String), ListOf(String), ListOf(Token)), p1380, +p1384 => +p1385 => (Match.Token(&2, TupleOf3(OptionOf(String), ListOf(String), ListOf(Token)), p1384, +p1386 => +p1387 => (Match.Token_Kind.only_Token_Kind_Ident(&2, TupleOf3(OptionOf(String), ListOf(String), ListOf(Token)), p1386, +p1388 => ((+scrut1396 = {Parser.parse_names(p1385, Nil{}) : TupleOf2(ListOf(String), ListOf(Token))}
  Match.Tuple2(&2, ListOf(String), &2, ListOf(Token), &2, TupleOf3(OptionOf(String), ListOf(String), ListOf(Token)), scrut1396, +p1397 => +p1398 => (Tup3{Some{p1388}, p1397, p1398})))), _ => (otherwise1383(Unit{})))))), _ => (otherwise1383(Unit{})))), _ => (otherwise1383(Unit{})))))))))
@unsafe
def Case.Parser.branch1446(+ts_963: ListOf(Token), +acc_964: ListOf(Syntax.Field)) -> CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))):
  (+scrut1436 = {Parser.mark_prefix(ts_963) : TupleOf2(Quantity, ListOf(Token))}
  Match.Tuple2(&2, Quantity, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), scrut1436, +p1437 => +p1438 => ((+scrut1439 = p1438
  Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), scrut1439, _ => (Done{Tup2{List.reverse(&2, Syntax.Field, acc_964), ts_963}}), +p1440 => +p1441 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), p1440, +p1442 => +p1443 => ((+otherwise1444 = {_ => (Done{Tup2{List.reverse(&2, Syntax.Field, acc_964), ts_963}}) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Ident(&2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), p1442, +p1445 => (Parser.parse_fields(p1441, Con{MkSyntax_FieldOf{p1437, p1445, None{}}, acc_964})), _ => (otherwise1444(Unit{}))))))))))))
@unsafe
def Parser.parse_fields(ts_963, acc_964):
  (+scrut1435 = ts_963
  Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), scrut1435, _ => (Case.Parser.branch1446(ts_963, acc_964)), +p1447 => +p1448 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), p1447, +p1449 => +p1450 => ((+otherwise1451 = {_ => (Case.Parser.branch1446(ts_963, acc_964)) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_LParen(&2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), p1449, _ => (Match.Result(&2, TupleOf2(Syntax.Binder, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), Parser.parse_binder(ts_963), +item1458 => ((+local1454 => ((+scrut1455 = local1454
  Match.Tuple2(&2, Syntax.Binder, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Field), ListOf(Token))), scrut1455, +p1456 => +p1457 => (Parser.parse_fields(p1457, Con{MkSyntax_FieldOf{Get.Syntax.Binder.b_q(p1456), Get.Syntax.Binder.b_name(p1456), Some{Get.Syntax.Binder.b_ty(p1456)}}, acc_964}))))))(item1458)), +item1459 => Fail{item1459})), _ => (otherwise1451(Unit{})))))))))
@unsafe
def Parser.numeric_key(+form_765: Parser.Elimination, +loc_766: Token.Loc) -> CheckResult(Unit):
  (+scrut1484 = form_765
  Match.Parser_Elimination(&2, CheckResult(Unit), scrut1484, _ => (Done{Unit{}}), _ => (Parser.parse_err(&2, Unit, loc_766, "a match branch keys a constructor, not a leg number"))))
@unsafe
def Parser.parse_branches(form_937, ts_938, acc_939):
  (+scrut1422 = ts_938
  Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), scrut1422, _ => (Done{Tup2{List.reverse(&2, Syntax.Branch, acc_939), ts_938}}), +p1423 => +p1424 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1423, +p1425 => +p1426 => ((+otherwise1427 = {_ => (Done{Tup2{List.reverse(&2, Syntax.Branch, acc_939), ts_938}}) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Pipe(&2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1425, _ => ((+otherwise1428 = {_ => (Parser.parse_err(&2, TupleOf2(ListOf(Syntax.Branch), ListOf(Token)), p1426, "expected a leg number or a constructor name after '|'")) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token)))}
  Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1424, +p1429 => +p1430 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1429, +p1431 => +p1432 => (Match.Token_Kind.only_Token_Kind_Ident_Token_Kind_Nat(&2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1431, +p1433 => (Match.Result(&2, TupleOf2(ListOf(Syntax.Field), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), Parser.parse_fields(p1430, Nil{}), +item1480 => ((+local1461 => ((+scrut1462 = local1461
  Match.Tuple2(&2, ListOf(Syntax.Field), &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), scrut1462, +p1463 => +p1464 => (((+scrut1465 = p1464
Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), scrut1465, _ => (Parser.expected(&2, TupleOf2(ListOf(Syntax.Branch), ListOf(Token)), "'=>'", p1464)), +p1466 => +p1467 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1466, +p1468 => +p1469 => ((+otherwise1470 = {_ => (Parser.expected(&2, TupleOf2(ListOf(Syntax.Branch), ListOf(Token)), "'=>'", p1464)) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_DArrow(&2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1468, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), Parser.parse_term(p1467), +item1477 => ((+local1473 => ((+scrut1474 = local1473
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), scrut1474, +p1475 => +p1476 => (Parser.parse_branches(form_937, p1476, Con{Syntax.BranchOf.BrCtor{p1433, p1463, p1475}, acc_939}))))))(item1477)), +item1478 => Fail{item1478})), _ => (otherwise1470(Unit{})))))))))))))))(item1480)), +item1481 => Fail{item1481})), +p1482 => ((Match.Result(&2, Unit, &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), Parser.numeric_key(form_937, p1432), +item1516 => ((+local1486 => ((+scrut1487 = local1486
Match.Result(&2, Big, &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), Parser.bounded_nat(p1432, p1482), +item1514 => ((+local1490 => (Match.Result(&2, TupleOf2(ListOf(Syntax.Binder), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), Parser.parse_binders(p1430, Nil{}), +item1512 => ((+local1493 => ((+scrut1494 = local1493
Match.Tuple2(&2, ListOf(Syntax.Binder), &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), scrut1494, +p1495 => +p1496 => (((+scrut1497 = p1496
Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), scrut1497, _ => (Parser.expected(&2, TupleOf2(ListOf(Syntax.Branch), ListOf(Token)), "'=>'", p1496)), +p1498 => +p1499 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1498, +p1500 => +p1501 => ((+otherwise1502 = {_ => (Parser.expected(&2, TupleOf2(ListOf(Syntax.Branch), ListOf(Token)), "'=>'", p1496)) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_DArrow(&2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), p1500, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), Parser.parse_term(p1499), +item1509 => ((+local1505 => ((+scrut1506 = local1505
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Branch), ListOf(Token))), scrut1506, +p1507 => +p1508 => (Parser.parse_branches(form_937, p1508, Con{Syntax.BranchOf.BrLeg{local1490, p1495, p1507}, acc_939}))))))(item1509)), +item1510 => Fail{item1510})), _ => (otherwise1502(Unit{})))))))))))))))(item1512)), +item1513 => Fail{item1513})))(item1514)), +item1515 => Fail{item1515}))))(item1516)), +item1517 => Fail{item1517}))), _ => (otherwise1428(Unit{})))))), _ => (otherwise1428(Unit{}))))), _ => (otherwise1427(Unit{})))))))))
@unsafe
def Parser.elimination_node(+form_711: Parser.Elimination, +scrut_736: Syntax, +mo_737: OptionOf(Syntax.Motive), +branches_738: ListOf(Syntax.Branch)) -> Syntax:
  (+scrut1525 = form_711
  Match.Parser_Elimination(&2, Syntax, scrut1525, _ => (Syntax.SCase{scrut_736, mo_737, branches_738}), _ => (Syntax.SMatch{scrut_736, mo_737, branches_738})))
@unsafe
def Parser.parse_case(+form_903: Parser.Elimination, +ts_904: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(ts_904), +item1541 => ((+local1362 => ((+scrut1363 = local1362
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1363, +p1364 => +p1365 => (((+scrut1366 = p1365
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1366, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'as' or 'with'", p1365)), +p1367 => +p1368 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1367, +p1369 => +p1370 => ((+otherwise1371 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'as' or 'with'", p1365)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_KAs_Token_Kind_KWith(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1369, _ => ((+otherwise1372 = {_ => (Parser.parse_err(&2, TupleOf2(Syntax, ListOf(Token)), p1370, "expected 'NAME [in FAMILY IDX..] return TYPE' after 'as'")) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1368, +p1373 => +p1374 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1373, +p1375 => +p1376 => (Match.Token_Kind.only_Token_Kind_Ident(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1375, +p1377 => ((+scrut1399 = {Parser.parse_index_clause(p1374) : TupleOf3(OptionOf(String), ListOf(String), ListOf(Token))}
Match.Tuple3(&2, OptionOf(String), &2, ListOf(String), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1399, +p1400 => +p1401 => +p1402 => (((+scrut1403 = p1402
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1403, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'return'", p1402)), +p1404 => +p1405 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1404, +p1406 => +p1407 => ((+otherwise1408 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'return'", p1402)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_KReturn(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1406, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1405), +item1529 => ((+local1411 => ((+scrut1412 = local1411
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1412, +p1413 => +p1414 => (((+scrut1415 = p1414
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1415, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'with'", p1414)), +p1416 => +p1417 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1416, +p1418 => +p1419 => ((+otherwise1420 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'with'", p1414)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_KWith(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1418, _ => (Match.Result(&2, TupleOf2(ListOf(Syntax.Branch), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_branches(form_903, p1417, Nil{}), +item1526 => ((+local1520 => ((+scrut1521 = local1520
Match.Tuple2(&2, ListOf(Syntax.Branch), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1521, +p1522 => +p1523 => ((+scrut1524 = {MkSyntax_MotiveOf{p1377, p1400, p1401, p1413} : Syntax.Motive}
Done{Tup2{Parser.elimination_node(form_903, p1364, Some{scrut1524}, p1522), p1523}}))))))(item1526)), +item1527 => Fail{item1527})), _ => (otherwise1420(Unit{})))))))))))))))(item1529)), +item1530 => Fail{item1530})), _ => (otherwise1408(Unit{})))))))))))))), _ => (otherwise1372(Unit{})))))), _ => (otherwise1372(Unit{}))))), _ => (Match.Result(&2, TupleOf2(ListOf(Syntax.Branch), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_branches(form_903, p1368, Nil{}), +item1538 => ((+local1534 => ((+scrut1535 = local1534
Match.Tuple2(&2, ListOf(Syntax.Branch), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1535, +p1536 => +p1537 => (Done{Tup2{Parser.elimination_node(form_903, p1364, None{}, p1536), p1537}})))))(item1538)), +item1539 => Fail{item1539})), _ => (otherwise1371(Unit{})))))))))))))))(item1541)), +item1542 => Fail{item1542})
@unsafe
def Parser.parse_let(+ts_889: ListOf(Token)) -> CheckResult(TupleOf2(Syntax, ListOf(Token))):
  (+scrut1543 = ts_889
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1543, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "a name and ':' after 'let'", ts_889)), +p1544 => +p1545 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1544, +p1546 => +p1547 => ((+otherwise1548 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "a name and ':' after 'let'", ts_889)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Ident(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1546, +p1549 => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1545, +p1550 => +p1551 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1550, +p1552 => +p1553 => (Match.Token_Kind.only_Token_Kind_Colon(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1552, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1551), +item1590 => ((+local1556 => ((+scrut1557 = local1556
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1557, +p1558 => +p1559 => (((+scrut1560 = p1559
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1560, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "':='", p1559)), +p1561 => +p1562 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1561, +p1563 => +p1564 => ((+otherwise1565 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "':='", p1559)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_ColonEq(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1563, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1562), +item1587 => ((+local1568 => ((+scrut1569 = local1568
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1569, +p1570 => +p1571 => (((+scrut1572 = p1571
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1572, _ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'in'", p1571)), +p1573 => +p1574 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1573, +p1575 => +p1576 => ((+otherwise1577 = {_ => (Parser.expected(&2, TupleOf2(Syntax, ListOf(Token)), "'in'", p1571)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_KIn(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1575, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), Parser.parse_term(p1574), +item1584 => ((+local1580 => ((+scrut1581 = local1580
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut1581, +p1582 => +p1583 => (Done{Tup2{Syntax.SLet{p1549, p1558, p1570, p1582}, p1583}})))))(item1584)), +item1585 => Fail{item1585})), _ => (otherwise1577(Unit{})))))))))))))))(item1587)), +item1588 => Fail{item1588})), _ => (otherwise1565(Unit{})))))))))))))))(item1590)), +item1591 => Fail{item1591})), _ => (otherwise1548(Unit{})))))), _ => (otherwise1548(Unit{})))), _ => (otherwise1548(Unit{})))))))))
@unsafe
def Parser.parse_term(ts_791):
  (+scrut960 = ts_791
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax, ListOf(Token))), scrut960, _ => (Parser.parse_arrow(ts_791)), +p1310 => +p1311 => (Match.Token(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1310, +p1312 => +p1313 => ((+otherwise1314 = {_ => (Parser.parse_arrow(ts_791)) : Unit -> CheckResult(TupleOf2(Syntax, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_KFun_Token_Kind_KCase_Token_Kind_KMatch_Token_Kind_KLet(&2, CheckResult(TupleOf2(Syntax, ListOf(Token))), p1312, _ => (Parser.parse_fun(p1311)), _ => (Parser.parse_case(Parser.Elimination.LegacyCase{}, p1311)), _ => (Parser.parse_case(Parser.Elimination.FiberedMatch{}, p1311)), _ => (Parser.parse_let(p1311)), _ => (otherwise1314(Unit{})))))))))
@unsafe
def Parser.parse_rec_member(+ts_1166: ListOf(Token)) -> CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))):
  (+scrut948 = ts_1166
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), scrut948, _ => (Parser.expected(&2, TupleOf2(Syntax.Rec_def, ListOf(Token)), "a definition name and ':'", ts_1166)), +p949 => +p950 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), p949, +p951 => +p952 => ((+otherwise953 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Rec_def, ListOf(Token)), "a definition name and ':'", ts_1166)) : Unit -> CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Ident(&2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), p951, +p954 => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), p950, +p955 => +p956 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), p955, +p957 => +p958 => (Match.Token_Kind.only_Token_Kind_Colon(&2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), p957, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), Parser.parse_term(p956), +item1612 => ((+local1593 => ((+scrut1594 = local1593
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), scrut1594, +p1595 => +p1596 => (((+scrut1597 = p1596
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), scrut1597, _ => (Parser.expected(&2, TupleOf2(Syntax.Rec_def, ListOf(Token)), "':='", p1596)), +p1598 => +p1599 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), p1598, +p1600 => +p1601 => ((+otherwise1602 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Rec_def, ListOf(Token)), "':='", p1596)) : Unit -> CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_ColonEq(&2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), p1600, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), Parser.parse_term(p1599), +item1609 => ((+local1605 => ((+scrut1606 = local1605
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Rec_def, ListOf(Token))), scrut1606, +p1607 => +p1608 => (Done{Tup2{MkSyntax_Rec_def{p954, p1595, p1607}, p1608}})))))(item1609)), +item1610 => Fail{item1610})), _ => (otherwise1602(Unit{})))))))))))))))(item1612)), +item1613 => Fail{item1613})), _ => (otherwise953(Unit{})))))), _ => (otherwise953(Unit{})))), _ => (otherwise953(Unit{})))))))))
@unsafe
def Parser.parse_rec_group(+ts_1160: ListOf(Token), +acc_1161: ListOf(Syntax.Rec_def)) -> CheckResult(TupleOf2(ListOf(Syntax.Rec_def), ListOf(Token))):
  Match.Result(&2, TupleOf2(Syntax.Rec_def, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Rec_def), ListOf(Token))), Parser.parse_rec_member(ts_1160), +item1625 => ((+local1615 => ((+scrut1616 = local1615
  Match.Tuple2(&2, Syntax.Rec_def, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Rec_def), ListOf(Token))), scrut1616, +p1617 => +p1618 => ((+scrut1619 = p1618
  Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Rec_def), ListOf(Token))), scrut1619, _ => (Done{Tup2{List.reverse(&2, Syntax.Rec_def, Con{p1617, acc_1161}), p1618}}), +p1620 => +p1621 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Rec_def), ListOf(Token))), p1620, +p1622 => +p1623 => ((+otherwise1624 = {_ => (Done{Tup2{List.reverse(&2, Syntax.Rec_def, Con{p1617, acc_1161}), p1618}}) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Rec_def), ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_KAnd(&2, CheckResult(TupleOf2(ListOf(Syntax.Rec_def), ListOf(Token))), p1622, _ => (Parser.parse_rec_group(p1621, Con{p1617, acc_1161})), _ => (otherwise1624(Unit{}))))))))))))))(item1625)), +item1626 => Fail{item1626})
@unsafe
def Parser.parse_fam_ctors(ts_1207, acc_1208):
  (+scrut1713 = ts_1207
  Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), scrut1713, _ => (Done{Tup2{List.reverse(&2, Syntax.Fam_ctor, acc_1208), ts_1207}}), +p1714 => +p1715 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), p1714, +p1716 => +p1717 => ((+otherwise1718 = {_ => (Done{Tup2{List.reverse(&2, Syntax.Fam_ctor, acc_1208), ts_1207}}) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Pipe(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), p1716, _ => ((+otherwise1719 = {_ => (Parser.parse_err(&2, TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)), p1717, "expected a constructor name and ':' after '|'")) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)))}
  Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), p1715, +p1720 => +p1721 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), p1720, +p1722 => +p1723 => (Match.Token_Kind.only_Token_Kind_Ident(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), p1722, +p1724 => (Match.Result(&2, TupleOf2(ListOf(Syntax.Binder), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), Parser.parse_binders(p1721, Nil{}), +item1751 => ((+local1727 => ((+scrut1728 = local1727
  Match.Tuple2(&2, ListOf(Syntax.Binder), &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), scrut1728, +p1729 => +p1730 => (((+scrut1731 = p1730
Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), scrut1731, _ => (Parser.expected(&2, TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)), "':' after constructor binders", p1730)), +p1732 => +p1733 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), p1732, +p1734 => +p1735 => ((+otherwise1736 = {_ => (Parser.expected(&2, TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)), "':' after constructor binders", p1730)) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_Colon(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), p1734, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), Parser.parse_term(p1733), +item1748 => ((+local1739 => ((+scrut1740 = local1739
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token))), scrut1740, +p1741 => +p1742 => ((+scrut1747 = {SeqList.fold_right(&2, &2, Syntax.Binder, Syntax, (+local1744 => +local1746 => (Syntax.SArrow{local1744, local1746})), p1729, p1741) : Syntax}
Parser.parse_fam_ctors(p1742, Con{MkSyntax_Fam_ctor{p1724, scrut1747}, acc_1208})))))))(item1748)), +item1749 => Fail{item1749})), _ => (otherwise1736(Unit{})))))))))))))))(item1751)), +item1752 => Fail{item1752})), _ => (otherwise1719(Unit{})))))), _ => (otherwise1719(Unit{}))))), _ => (otherwise1718(Unit{})))))))))
@unsafe
def Parser.parse_fam(+ts_1193: ListOf(Token)) -> CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))):
  (+scrut1681 = ts_1193
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), scrut1681, _ => (Parser.expected(&2, TupleOf2(Syntax.Fam, ListOf(Token)), "a family name", ts_1193)), +p1682 => +p1683 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), p1682, +p1684 => +p1685 => ((+otherwise1686 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Fam, ListOf(Token)), "a family name", ts_1193)) : Unit -> CheckResult(TupleOf2(Syntax.Fam, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_Ident(&2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), p1684, +p1687 => (Match.Result(&2, TupleOf2(ListOf(Syntax.Binder), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), Parser.parse_binders(p1683, Nil{}), +item1772 => ((+local1690 => ((+scrut1691 = local1690
  Match.Tuple2(&2, ListOf(Syntax.Binder), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), scrut1691, +p1692 => +p1693 => (((+scrut1694 = p1693
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), scrut1694, _ => (Parser.expected(&2, TupleOf2(Syntax.Fam, ListOf(Token)), "':'", p1693)), +p1695 => +p1696 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), p1695, +p1697 => +p1698 => ((+otherwise1699 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Fam, ListOf(Token)), "':'", p1693)) : Unit -> CheckResult(TupleOf2(Syntax.Fam, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_Colon(&2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), p1697, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), Parser.parse_term(p1696), +item1769 => ((+local1702 => ((+scrut1703 = local1702
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), scrut1703, +p1704 => +p1705 => (((+scrut1706 = p1705
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), scrut1706, _ => (Parser.expected(&2, TupleOf2(Syntax.Fam, ListOf(Token)), "':=' or 'with'", p1705)), +p1707 => +p1708 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), p1707, +p1709 => +p1710 => ((+otherwise1711 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Fam, ListOf(Token)), "':=' or 'with'", p1705)) : Unit -> CheckResult(TupleOf2(Syntax.Fam, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_ColonEq_Token_Kind_KWith(&2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), p1709, _ => (Match.Result(&2, TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), Parser.parse_fam_ctors(p1708, Nil{}), +item1758 => ((+local1754 => ((+scrut1755 = local1754
Match.Tuple2(&2, ListOf(Syntax.Fam_ctor), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), scrut1755, +p1756 => +p1757 => (Done{Tup2{MkSyntax_Fam{p1687, p1692, p1704, p1756}, p1757}})))))(item1758)), +item1759 => Fail{item1759})), _ => (Match.Result(&2, TupleOf2(ListOf(Syntax.Fam_ctor), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), Parser.parse_fam_ctors(p1708, Nil{}), +item1766 => ((+local1762 => ((+scrut1763 = local1762
Match.Tuple2(&2, ListOf(Syntax.Fam_ctor), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Fam, ListOf(Token))), scrut1763, +p1764 => +p1765 => (Done{Tup2{MkSyntax_Fam{p1687, p1692, p1704, p1764}, p1765}})))))(item1766)), +item1767 => Fail{item1767})), _ => (otherwise1711(Unit{})))))))))))))))(item1769)), +item1770 => Fail{item1770})), _ => (otherwise1699(Unit{})))))))))))))))(item1772)), +item1773 => Fail{item1773})), _ => (otherwise1686(Unit{})))))))))
@unsafe
def Parser.parse_fam_group(+ts_1176: ListOf(Token), +acc_1177: ListOf(Syntax.Fam)) -> CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))):
  Match.Result(&2, TupleOf2(Syntax.Fam, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), Parser.parse_fam(ts_1176), +item1785 => ((+local1775 => ((+scrut1776 = local1775
  Match.Tuple2(&2, Syntax.Fam, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), scrut1776, +p1777 => +p1778 => ((+scrut1779 = p1778
  Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), scrut1779, _ => (Done{Tup2{List.reverse(&2, Syntax.Fam, Con{p1777, acc_1177}), p1778}}), +p1780 => +p1781 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), p1780, +p1782 => +p1783 => ((+otherwise1784 = {_ => (Done{Tup2{List.reverse(&2, Syntax.Fam, Con{p1777, acc_1177}), p1778}}) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_KAnd(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), p1782, _ => (Parser.parse_fam_group(p1781, Con{p1777, acc_1177})), _ => (otherwise1784(Unit{}))))))))))))))(item1785)), +item1786 => Fail{item1786})
@unsafe
def Parser.parse_mutual_group(+ts_1182: ListOf(Token), +acc_1183: ListOf(Syntax.Fam)) -> CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))):
  (+scrut1795 = ts_1182
  Match.List(&2, Token, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), scrut1795, _ => (Parser.expected(&2, TupleOf2(ListOf(Syntax.Fam), ListOf(Token)), "'mu' or 'end' in a mutual group", ts_1182)), +p1796 => +p1797 => (Match.Token(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), p1796, +p1798 => +p1799 => ((+otherwise1800 = {_ => (Parser.expected(&2, TupleOf2(ListOf(Syntax.Fam), ListOf(Token)), "'mu' or 'end' in a mutual group", ts_1182)) : Unit -> CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_KMu_Token_Kind_KEnd(&2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), p1798, _ => (Match.Result(&2, TupleOf2(Syntax.Fam, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), Parser.parse_fam(p1797), +item1807 => ((+local1803 => ((+scrut1804 = local1803
  Match.Tuple2(&2, Syntax.Fam, &2, ListOf(Token), &2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), scrut1804, +p1805 => +p1806 => (Parser.parse_mutual_group(p1806, Con{p1805, acc_1183}))))))(item1807)), +item1808 => Fail{item1808})), _ => ((+scrut1809 = acc_1183
  Match.List(&2, Syntax.Fam, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), scrut1809, _ => (Parser.parse_err(&2, TupleOf2(ListOf(Syntax.Fam), ListOf(Token)), p1799, "a mutual group needs at least two mu declarations")), +p1810 => +p1811 => (Match.List(&2, Syntax.Fam, &2, CheckResult(TupleOf2(ListOf(Syntax.Fam), ListOf(Token))), p1811, _ => (Parser.parse_err(&2, TupleOf2(ListOf(Syntax.Fam), ListOf(Token)), p1799, "a mutual group needs at least two mu declarations")), +p1812 => +p1813 => (Done{Tup2{List.reverse(&2, Syntax.Fam, acc_1183), p1797}})))))), _ => (otherwise1800(Unit{})))))))))
@unsafe
def Parser.parse_decl(+ts_1131: ListOf(Token)) -> CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))):
  (+scrut927 = ts_1131
  Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), scrut927, _ => (Parser.expected(&2, TupleOf2(Syntax.Decl, ListOf(Token)), "'def NAME :', 'def rec NAME :', 'axiom NAME :', 'mu NAME' or 'mutual'", ts_1131)), +p937 => +p938 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p937, +p939 => +p940 => ((+otherwise941 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Decl, ListOf(Token)), "'def NAME :', 'def rec NAME :', 'axiom NAME :', 'mu NAME' or 'mutual'", ts_1131)) : Unit -> CheckResult(TupleOf2(Syntax.Decl, ListOf(Token)))}
  Match.Token_Kind.only_Token_Kind_KDef_Token_Kind_KAxiom_Token_Kind_KMu_Token_Kind_KMutual_Token_Kind_KNu(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p939, _ => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p938, +p942 => +p943 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p942, +p944 => +p945 => (Match.Token_Kind.only_Token_Kind_KRec_Token_Kind_Ident(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p944, _ => (Match.Result(&2, TupleOf2(ListOf(Syntax.Rec_def), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), Parser.parse_rec_group(p943, Nil{}), +item1632 => ((+local1628 => ((+scrut1629 = local1628
  Match.Tuple2(&2, ListOf(Syntax.Rec_def), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), scrut1629, +p1630 => +p1631 => (Done{Tup2{Syntax.Decl.DRec{p1630}, p1631}})))))(item1632)), +item1633 => Fail{item1633})), +p1634 => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p943, +p1635 => +p1636 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1635, +p1637 => +p1638 => (Match.Token_Kind.only_Token_Kind_Colon(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1637, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), Parser.parse_term(p1636), +item1660 => ((+local1641 => ((+scrut1642 = local1641
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), scrut1642, +p1643 => +p1644 => (((+scrut1645 = p1644
Match.List(&2, Token, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), scrut1645, _ => (Parser.expected(&2, TupleOf2(Syntax.Decl, ListOf(Token)), "':='", p1644)), +p1646 => +p1647 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1646, +p1648 => +p1649 => ((+otherwise1650 = {_ => (Parser.expected(&2, TupleOf2(Syntax.Decl, ListOf(Token)), "':='", p1644)) : Unit -> CheckResult(TupleOf2(Syntax.Decl, ListOf(Token)))}
Match.Token_Kind.only_Token_Kind_ColonEq(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1648, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), Parser.parse_term(p1647), +item1657 => ((+local1653 => ((+scrut1654 = local1653
Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), scrut1654, +p1655 => +p1656 => (Done{Tup2{Syntax.Decl.DDef{p1634, p1643, p1655}, p1656}})))))(item1657)), +item1658 => Fail{item1658})), _ => (otherwise1650(Unit{})))))))))))))))(item1660)), +item1661 => Fail{item1661})), _ => (otherwise941(Unit{})))))), _ => (otherwise941(Unit{})))), _ => (otherwise941(Unit{})))))), _ => (otherwise941(Unit{})))), _ => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p938, +p1662 => +p1663 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1662, +p1664 => +p1665 => (Match.Token_Kind.only_Token_Kind_Ident(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1664, +p1666 => (Match.List.only_Con(&2, Token, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1663, +p1667 => +p1668 => (Match.Token(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1667, +p1669 => +p1670 => (Match.Token_Kind.only_Token_Kind_Colon(&2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), p1669, _ => (Match.Result(&2, TupleOf2(Syntax, ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), Parser.parse_term(p1668), +item1677 => ((+local1673 => ((+scrut1674 = local1673
  Match.Tuple2(&2, Syntax, &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), scrut1674, +p1675 => +p1676 => (Done{Tup2{Syntax.Decl.DAxiom{p1666, p1675}, p1676}})))))(item1677)), +item1678 => Fail{item1678})), _ => (otherwise941(Unit{})))))), _ => (otherwise941(Unit{})))), _ => (otherwise941(Unit{})))))), _ => (otherwise941(Unit{})))), _ => (Match.Result(&2, TupleOf2(ListOf(Syntax.Fam), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), Parser.parse_fam_group(p938, Nil{}), +item1792 => ((+local1788 => ((+scrut1789 = local1788
  Match.Tuple2(&2, ListOf(Syntax.Fam), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), scrut1789, +p1790 => +p1791 => (Done{Tup2{Syntax.Decl.DMu{p1790}, p1791}})))))(item1792)), +item1793 => Fail{item1793})), _ => (Match.Result(&2, TupleOf2(ListOf(Syntax.Fam), ListOf(Token)), &2, Error, &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), Parser.parse_mutual_group(p938, Nil{}), +item1819 => ((+local1815 => ((+scrut1816 = local1815
  Match.Tuple2(&2, ListOf(Syntax.Fam), &2, ListOf(Token), &2, CheckResult(TupleOf2(Syntax.Decl, ListOf(Token))), scrut1816, +p1817 => +p1818 => (Done{Tup2{Syntax.Decl.DMu{p1817}, p1818}})))))(item1819)), +item1820 => Fail{item1820})), _ => (Parser.parse_err(&2, TupleOf2(Syntax.Decl, ListOf(Token)), p940, "nu arrives at M2")), _ => (otherwise941(Unit{})))))))))
@unsafe
def Parser.parse_decls(+ts_1125: ListOf(Token), +acc_1126: ListOf(Syntax.Decl)) -> CheckResult(ListOf(Syntax.Decl)):
  (+scrut925 = ts_1125
  Match.List(&2, Token, &2, CheckResult(ListOf(Syntax.Decl)), scrut925, _ => (Match.Result(&2, TupleOf2(Syntax.Decl, ListOf(Token)), &2, Error, &2, CheckResult(ListOf(Syntax.Decl)), Parser.parse_decl(ts_1125), +item1826 => ((+local1822 => ((+scrut1823 = local1822
  Match.Tuple2(&2, Syntax.Decl, &2, ListOf(Token), &2, CheckResult(ListOf(Syntax.Decl)), scrut1823, +p1824 => +p1825 => (Parser.parse_decls(p1825, Con{p1824, acc_1126}))))))(item1826)), +item1827 => Fail{item1827})), +p1828 => +p1829 => (Match.Token(&2, CheckResult(ListOf(Syntax.Decl)), p1828, +p1830 => +p1831 => ((+otherwise1832 = {_ => (Match.Result(&2, TupleOf2(Syntax.Decl, ListOf(Token)), &2, Error, &2, CheckResult(ListOf(Syntax.Decl)), Parser.parse_decl(ts_1125), +item1839 => ((+local1835 => ((+scrut1836 = local1835
  Match.Tuple2(&2, Syntax.Decl, &2, ListOf(Token), &2, CheckResult(ListOf(Syntax.Decl)), scrut1836, +p1837 => +p1838 => (Parser.parse_decls(p1838, Con{p1837, acc_1126}))))))(item1839)), +item1840 => Fail{item1840})) : Unit -> CheckResult(ListOf(Syntax.Decl))}
  Match.Token_Kind.only_Token_Kind_Eof(&2, CheckResult(ListOf(Syntax.Decl)), p1830, _ => (Done{List.reverse(&2, Syntax.Decl, acc_1126)}), _ => (otherwise1832(Unit{})))))))))
@unsafe
def Parser.parse(+src_1225: String) -> CheckResult(ListOf(Syntax.Decl)):
  Match.Result(&2, ListOf(Token), &2, Error, &2, CheckResult(ListOf(Syntax.Decl)), Lexer.lex(src_1225), +item1841 => ((+local924 => (Parser.parse_decls(local924, Nil{})))(item1841)), +item1842 => Fail{item1842})
@unsafe
def Elab.index_of(+x_330: String, +names_331: ListOf(String)) -> OptionOf(Big):
  (+scrut1878 = names_331
  Match.List(&2, String, &2, OptionOf(Big), scrut1878, _ => (None{}), +p1879 => +p1880 => (Native.choose(&2, OptionOf(Big), NativeString.equal(x_330, p1879), _ => (Some{Big.zero()}), _ => (Match.Maybe(&2, Big, &2, OptionOf(Big), Elab.index_of(x_330, p1880), _ => None{}, +item1883 => (Some{(+arg1881 => NativeInt.succ(arg1881))(item1883)})))))))
@unsafe
def Elab.globals_of(+c_461: Check.Ctx) -> Global:
  Get.Check.Ctx.globals(c_461)
@unsafe
def Elab.find_ctor(+x_1386: String, +g_1387: Global) -> OptionOf(TupleOf2(Positivity.Family, Positivity.Ctor)):
  Assoc.fold(&2, &2, String, Positivity.Family, OptionOf(TupleOf2(Positivity.Family, Positivity.Ctor)), (+local1900 => +local1902 => +local1904 => (Match.Maybe(&2, TupleOf2(Positivity.Family, Positivity.Ctor), &2, OptionOf(TupleOf2(Positivity.Family, Positivity.Ctor)), local1904, _ => (Match.Maybe(&2, Positivity.Ctor, &2, OptionOf(TupleOf2(Positivity.Family, Positivity.Ctor)), Positivity.ctor_of(x_1386, local1902), _ => None{}, +item1910 => (Some{(+local1906 => (Tup2{local1902, local1906}))(item1910)}))), +value => ((+local1913 => (Some{local1913}))(value))))), Get.Global.families(g_1387), None{})
@unsafe
def Elab.mu_ref_of(+c_1579: Check.Ctx, +x_1580: String) -> OptionOf(Elab.Mu_ref):
  (+scrut1871 = {Unit{} : Unit}
  Native.choose(&2, OptionOf(Elab.Mu_ref), Maybe.is_some(&2, Big, Elab.index_of(x_1580, Check.names_of(c_1579))), _ => (None{}), _ => ((+local1893 => (Match.Maybe(&2, Elab.Mu_ref, &2, OptionOf(Elab.Mu_ref), local1893, _ => (Match.Maybe(&2, TupleOf2(Positivity.Family, Positivity.Ctor), &2, OptionOf(Elab.Mu_ref), Elab.find_ctor(x_1580, Elab.globals_of(c_1579)), _ => None{}, +item1915 => (Some{(+local1895 => ((+scrut1896 = local1895
  Match.Tuple2(&2, Positivity.Family, &2, Positivity.Ctor, &2, Elab.Mu_ref, scrut1896, +p1897 => +p1898 => (Elab.Mu_ref.RCtor{p1897, p1898})))))(item1915)}))), +value => ((+local1918 => (Some{local1918}))(value)))))((+local1886 => (Match.Maybe(&2, Positivity.Family, &2, OptionOf(Elab.Mu_ref), local1886, _ => None{}, +item1890 => (Some{(+local1888 => (Elab.Mu_ref.RFam{local1888}))(item1890)}))))(Global.find_family(x_1580, Elab.globals_of(c_1579)))))))
@unsafe
def Elab.arity_is(+what_1780: String, +want_1781: Big, +got_1782: Big) -> CheckResult(Unit):
  Native.choose(&2, CheckResult(Unit), Big.is_eq(want_1781, got_1782), _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.concat([what_1780, " takes ", Big.show(want_1781), " arguments and the term gives ", Big.show(got_1782)])}}))
@unsafe
def Elab.split_at(-q0: Quant, -A0: Kind(q0), +n_1347: Big, +xs_1348: List<q0, A0>) -> Tuple2<q0, q0, List<q0, A0>, List<q0, A0>>:
  Tup2{SeqList.filteri(q0, A0, (+local1957 => +local1959 => (Big.is_lt(local1957, n_1347))), xs_1348), SeqList.filteri(q0, A0, (+local1961 => +local1963 => (Big.is_le(n_1347, local1961))), xs_1348)}
@unsafe
def Elab.elab_fam_ref(+c_1783: Check.Ctx, +f_1784: Positivity.Family, +args_1785: ListOf(Syntax)) -> CheckResult(Term):
  (+scrut1931 = {Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Family.f_params(f_1784))) : Big}
  (Match.Result(&2, Unit, &2, Error, &2, CheckResult(Term), Elab.arity_is(Get.Positivity.Family.f_name(f_1784), NativeInt.add(scrut1931, Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Family.f_indices(f_1784)))), Big.of_nat(List.length(&2, Syntax, args_1785))), +item1969 => ((+local1934 => ((+scrut1935 = local1934
Match.Result(&2, ListOf(Term), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, Term, SeqList.map(&2, &2, Syntax, CheckResult(Term), (+local1939 => (Elab.elab(c_1783, None{}, local1939))), args_1785)), +item1967 => ((+local1955 => ((+scrut1964 = {Elab.split_at(&2, Term, scrut1931, local1955) : TupleOf2(ListOf(Term), ListOf(Term))}
Match.Tuple2(&2, ListOf(Term), &2, ListOf(Term), &2, CheckResult(Term), scrut1964, +p1965 => +p1966 => (Done{Term.Lan{Shape.SMu{Get.Positivity.Family.f_name(f_1784), p1966}, Term.Sec{Shape.SColl{scrut1931}, SeqList.map(&2, &2, Term, Term.Leg, Rules.leg_of, p1965)}}})))))(item1967)), +item1968 => Fail{item1968}))))(item1969)), +item1970 => Fail{item1970})))
@unsafe
def Elab.no_expect(+what_320: String) -> Error:
  Error.Cannot_infer{String.append(what_320, " needs an expected type")}
@unsafe
def Elab.env_of(+c_543: Check.Ctx) -> ListOf(Value):
  Get.Check.Ctx.env(c_543)
@unsafe
def Elab.eval_in(+c_569: Check.Ctx, +t_581: Term) -> CheckResult(Value):
  Eval.eval(Elab.globals_of(c_569), Elab.env_of(c_569), t_581)
@unsafe
def Elab.size_of(+c_566: Check.Ctx) -> Big:
  Get.Check.Ctx.size(c_566)
@unsafe
def Elab.elab_ctor_ref(+c_1791: Check.Ctx, +f_1792: Positivity.Family, +ct_1793: Positivity.Ctor, +args_1794: ListOf(Syntax)) -> CheckResult(Term):
  Match.Result(&2, Unit, &2, Error, &2, CheckResult(Term), Elab.arity_is(Get.Positivity.Ctor.c_name(ct_1793), Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Ctor.c_args(ct_1793))), Big.of_nat(List.length(&2, Syntax, args_1794))), +item4178 => ((+local1976 => ((+scrut1977 = local1976
  Match.Result(&2, Unit, &2, Error, &2, CheckResult(Term), (+scrut1979 = {Get.Positivity.Family.f_params(f_1792) : Positivity.Telescope}
  Match.List(&2, TupleOf3(Quantity, String, Term), &2, CheckResult(Unit), scrut1979, _ => (Done{Unit{}}), +p1980 => +p1981 => (Fail{Elab.no_expect(String.append("the constructor ", Get.Positivity.Ctor.c_name(ct_1793)))}))), +item4176 => ((+local1983 => ((+scrut1984 = local1983
  (Match.Result(&2, ListOf(Term), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, Term, SeqList.map(&2, &2, Syntax, CheckResult(Term), (+local1988 => (Elab.elab(c_1791, None{}, local1988))), args_1794)), +item4173 => ((+local1990 => (Match.Result(&2, ListOf(Value), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, Value, SeqList.map(&2, &2, Term, CheckResult(Value), (+local1994 => (Elab.eval_in(c_1791, local1994))), local1990)), +item4171 => ((+local4039 => (Match.Result(&2, ListOf(Value), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, Value, SeqList.map(&2, &2, Term, CheckResult(Value), (+local4042 => (Eval.eval(Elab.globals_of(c_1791), List.reverse(&2, Value, local4039), local4042))), Get.Positivity.Ctor.c_res_idx(ct_1793))), +item4169 => ((+local4044 => (Match.Result(&2, ListOf(Term), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, Term, SeqList.map(&2, &2, Value, CheckResult(Term), (+local4047 => (Eval.quote(Elab.globals_of(c_1791), Elab.size_of(c_1791), local4047))), local4044)), +item4167 => ((+local4166 => (Done{Term.In{Shape.SMu{Get.Positivity.Family.f_name(f_1792), local4166}, Term.AddrOf.ACtor{Get.Positivity.Ctor.c_name(ct_1793)}, local1990}}))(item4167)), +item4168 => Fail{item4168})))(item4169)), +item4170 => Fail{item4170})))(item4171)), +item4172 => Fail{item4172})))(item4173)), +item4174 => Fail{item4174})))))(item4176)), +item4177 => Fail{item4177}))))(item4178)), +item4179 => Fail{item4179})
@unsafe
def Elab.elab_mu_ref(+c_1774: Check.Ctx, +r_1775: Elab.Mu_ref, +args_1776: ListOf(Syntax)) -> CheckResult(Term):
  (+scrut1929 = r_1775
  Match.Elab_Mu_ref(&2, CheckResult(Term), scrut1929, +p1930 => (Elab.elab_fam_ref(c_1774, p1930, args_1776)), +p1972 => +p1973 => (Elab.elab_ctor_ref(c_1774, p1972, p1973, args_1776))))
@unsafe
def Elab.univ_of_int(+n_697: Big) -> CheckResult(Term):
  (+local4187 => (Match.Result(&2, Level, &2, Error, &2, CheckResult(Term), local4187, +item4190 => (Done{(+local4189 => (Term.Univ{local4189}))(item4190)}), +item4191 => Fail{item4191})))((+local4184 => (Match.Maybe(&2, Level, &2, CheckResult(Level), local4184, _ => Fail{Error.Universe{String.concat(["the universe level ", Big.show(n_697), " is not a level"])}}, +x => Done{x})))(Level.of_int(n_697)))
@unsafe
def Syntax.prim_name(+p_571: Syntax.Prim) -> String:
  (+scrut4193 = p_571
  Match.Syntax_Prim(&2, String, scrut4193, _ => ("natAdd"), _ => ("natSub"), _ => ("natMul"), _ => ("natEq"), _ => ("natLt")))
@unsafe
def Elab.whnf_in(+c_614: Check.Ctx, +v_615: Value) -> CheckResult(Value):
  Eval.whnf(Elab.globals_of(c_614), v_615)
@unsafe
def Elab.point_of(+s_761: Shape<&2, Value>) -> OptionOf(TupleOf3(Quantity, String, Value)):
  Rules.as_vpi(&2, Value, s_761)
@unsafe
def Elab.elab_pair(+c_1690: Check.Ctx, +expected_1691: OptionOf(Value), +a_1692: Syntax, +b_1693: Syntax) -> CheckResult(Term):
  Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), (+local4199 => (Match.Maybe(&2, Value, &2, CheckResult(Value), local4199, _ => Fail{Elab.no_expect("a pair")}, +x => Done{x})))(expected_1691), +item4257 => ((+local4201 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.whnf_in(c_1690, local4201), +item4255 => ((+local4204 => (Match.Result(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, Error, &2, CheckResult(Term), (+local4208 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))), local4208, _ => Fail{Error.Mismatch{"a pair needs a left former as its expected type"}}, +x => Done{x})))(Value.as_lan(local4204)), +item4253 => ((+local4210 => ((+scrut4211 = local4210
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Term), scrut4211, +p4212 => +p4213 => +p4214 => (Match.Result(&2, TupleOf3(Quantity, String, Value), &2, Error, &2, CheckResult(Term), (+local4218 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local4218, _ => Fail{Error.Mismatch{"a pair needs a point former"}}, +x => Done{x})))(Elab.point_of(p4212)), +item4251 => ((+local4220 => ((+scrut4221 = local4220
  Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(Term), scrut4221, +p4222 => +p4223 => +p4224 => ((Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1690, Some{p4224}, a_1692), +item4248 => ((+local4227 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.eval_in(c_1690, local4227), +item4246 => ((+local4230 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Rules.open_closure(Eval.ev(Elab.globals_of(c_1690)), p4213, Con{local4230, Nil{}}), +item4244 => ((+local4233 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1690, Some{local4233}, b_1693), +item4242 => ((+local4236 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Eval.quote(Elab.globals_of(c_1690), Elab.size_of(c_1690), p4224), +item4240 => ((+local4239 => (Done{Term.In{Shape.SPi{p4222, p4223, local4239}, Term.AddrOf.APt{p4222, local4227}, Con{local4236, Nil{}}}}))(item4240)), +item4241 => Fail{item4241})))(item4242)), +item4243 => Fail{item4243})))(item4244)), +item4245 => Fail{item4245})))(item4246)), +item4247 => Fail{item4247})))(item4248)), +item4249 => Fail{item4249})))))))(item4251)), +item4252 => Fail{item4252}))))))(item4253)), +item4254 => Fail{item4254})))(item4255)), +item4256 => Fail{item4256})))(item4257)), +item4258 => Fail{item4258})
@unsafe
def Elab.leg_expectations(+c_889: Check.Ctx, +expected_890: OptionOf(Value), +n_891: Big, +left_892: Bool) -> CheckResult(ListOf(OptionOf(Value))):
  (+scrut4264 = {SeqList.init(&2, OptionOf(Value), n_891, (+local4263 => (None{}))) : ListOf(OptionOf(Value))}
  (+scrut4265 = {Native.choose(&1, Reusable(Value, OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)))), left_892, _ => (Value.as_lan), _ => (Value.as_ran)) : Reusable(Value, OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))))}
  ((+local4268 => (Match.Maybe(&2, Value, &2, CheckResult(ListOf(OptionOf(Value))), local4268, _ => (Done{scrut4264}), +value => ((+local4270 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(ListOf(OptionOf(Value))), Elab.whnf_in(c_889, local4270), +item5380 => ((+local4273 => ((+local4276 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(ListOf(OptionOf(Value))), local4276, _ => (Done{scrut4264}), +value => ((+local4278 => ((+scrut4279 = local4278
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(ListOf(OptionOf(Value))), scrut4279, +p4280 => +p4281 => +p4282 => (((+local4285 => (Match.Maybe(&2, Big, &2, CheckResult(ListOf(OptionOf(Value))), local4285, _ => (Done{scrut4264}), +value => ((+local4287 => (Native.choose(&2, CheckResult(ListOf(OptionOf(Value))), Big.is_eq(local4287, n_891), _ => (Match.Result(&2, ListOf(Value.Vleg), &2, Error, &2, CheckResult(ListOf(OptionOf(Value))), Rules.coll_legs_of(&1, Check.Ctx, Check.ops(), c_889, p4281), +item5377 => ((+local5369 => (Rules.all_ok(&2, OptionOf(Value), SeqList.init(&2, CheckResult(OptionOf(Value)), n_891, (+local5371 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Rules.coll_leg_ty(&1, Check.Ctx, Check.ops(), c_889, local5369, local5371), +item5375 => (Done{(+local5374 => (Some{local5374}))(item5375)}), +item5376 => Fail{item5376})))))))(item5377)), +item5378 => Fail{item5378})), _ => (Done{scrut4264}))))(value)))))(Rules.as_vcoll(&2, Value, p4280))))))))(value)))))(scrut4265(local4273))))(item5380)), +item5381 => Fail{item5381})))(value)))))(expected_890))))
@unsafe
def Elab.elab_items(+c_1681: Check.Ctx, +expected_1682: OptionOf(Value), +items_1683: ListOf(Syntax), +left_1684: Bool) -> CheckResult(ListOf(Term)):
  Match.Result(&2, ListOf(OptionOf(Value)), &2, Error, &2, CheckResult(ListOf(Term)), Elab.leg_expectations(c_1681, expected_1682, Big.of_nat(List.length(&2, Syntax, items_1683)), left_1684), +item5398 => ((+local5384 => (Match.Result(&2, ListOf(TupleOf2(Syntax, OptionOf(Value))), &2, Error, &2, CheckResult(ListOf(Term)), (+local5388 => (Match.Maybe(&2, ListOf(TupleOf2(Syntax, OptionOf(Value))), &2, CheckResult(ListOf(TupleOf2(Syntax, OptionOf(Value)))), local5388, _ => Fail{Error.Mismatch{"the item count and the leg count differ"}}, +x => Done{x})))(Rules.zip(&2, Syntax, &2, OptionOf(Value), items_1683, local5384)), +item5396 => ((+local5390 => (Rules.all_ok(&2, Term, SeqList.map(&2, &2, TupleOf2(Syntax, OptionOf(Value)), CheckResult(Term), (+local5392 => ((+scrut5393 = local5392
  Match.Tuple2(&2, Syntax, &2, OptionOf(Value), &2, CheckResult(Term), scrut5393, +p5394 => +p5395 => (Elab.elab(c_1681, p5395, p5394)))))), local5390))))(item5396)), +item5397 => Fail{item5397})))(item5398)), +item5399 => Fail{item5399})
@unsafe
def Elab.type_of(+c_638: Check.Ctx, +t_639: Term) -> CheckResult(Value):
  Match.Result(&2, Value, &2, Error, &2, CheckResult(Value), Check.infer(c_638, Quantity.Zero{}, t_639), +item5436 => ((+local5435 => (Elab.whnf_in(c_638, local5435)))(item5436)), +item5437 => Fail{item5437})
@unsafe
def Elab.elab_pair_proj(+c_1729: Check.Ctx, +scrut_1730: Term, +vs_1731: Shape<&2, Value>, +dclo_1732: Value.Closure, +k_1733: Big) -> CheckResult(Term):
  Match.Result(&2, TupleOf3(Quantity, String, Value), &2, Error, &2, CheckResult(Term), (+local5455 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local5455, _ => Fail{Error.Mismatch{"a pair projection needs a point former"}}, +x => Done{x})))(Elab.point_of(vs_1731)), +item5493 => ((+local5457 => ((+scrut5458 = local5457
  Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(Term), scrut5458, +p5459 => +p5460 => +p5461 => (Match.Result(&2, Big, &2, Error, &2, CheckResult(Term), (+local5465 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local5465, _ => Fail{Error.Wrong_leg{"a pair carries the projections .1 and .2 only"}}, +x => Done{x})))(Native.choose(&2, OptionOf(Big), Big.is_eq(k_1733, Big.one()), _ => (Some{Big.zero()}), _ => (Native.choose(&2, OptionOf(Big), Big.is_eq(k_1733, Big.of_nat(2n)), _ => (Some{Big.one()}), _ => (None{}))))), +item5491 => ((+local5467 => ((+scrut5468 = {Elab.size_of(c_1729) : Big}
  (+scrut5469 = {Eval.ev(Elab.globals_of(c_1729)) : Rules.Evaluator}
  (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Native.choose(&2, CheckResult(Value), Big.is_eq(local5467, Big.zero()), _ => (Done{p5461}), _ => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Value), Rules.elim_value(scrut5469, vs_1731, p5459, None{}, Rules.proj_branch(p5459, Big.zero()), Elab.env_of(c_1729), Value.var(scrut5468)), +item5474 => ((+local5473 => (Rules.open_closure(scrut5469, dclo_1732, Con{local5473, Nil{}})))(item5474)), +item5475 => Fail{item5475}))), +item5488 => ((+local5477 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Eval.quote(Elab.globals_of(c_1729), NativeInt.add(scrut5468, Big.one()), local5477), +item5486 => ((+local5480 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Eval.quote(Elab.globals_of(c_1729), scrut5468, p5461), +item5484 => ((+local5483 => (Done{Term.Elim{MkTerm_ElimOf{Shape.SPi{p5459, p5460, local5483}, scrut_1730, Quantity.One{}, Some{MkTerm_MotiveOf{None{}, Nil{}, "self", local5480}}, Rules.proj_branch(p5459, local5467)}}}))(item5484)), +item5485 => Fail{item5485})))(item5486)), +item5487 => Fail{item5487})))(item5488)), +item5489 => Fail{item5489}))))))(item5491)), +item5492 => Fail{item5492}))))))(item5493)), +item5494 => Fail{item5494})
@unsafe
def Elab.elab_leg_proj(+c_1745: Check.Ctx, +scrut_1746: Term, +vs_1747: Shape<&2, Value>, +k_1748: Big) -> CheckResult(Term):
  (+scrut5509 = c_1745
  Match.Result(&2, Big, &2, Error, &2, CheckResult(Term), (+local5513 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local5513, _ => Fail{Error.Mismatch{"a leg projection needs a collection former"}}, +x => Done{x})))(Rules.as_vcoll(&2, Value, vs_1747)), +item5516 => ((+local5515 => (Done{Term.Out{Shape.SColl{local5515}, Term.AddrOf.ALeg{k_1748}, scrut_1746}}))(item5516)), +item5517 => Fail{item5517}))
@unsafe
def Elab.first_some(+xs_1709: List<&1, Maybe<&1, Reusable(Unit, CheckResult(Term))>>) -> Maybe<&1, Reusable(Unit, CheckResult(Term))>:
  SeqList.fold(&1, &1, Maybe<&1, Reusable(Unit, CheckResult(Term))>, Maybe<&1, Reusable(Unit, CheckResult(Term))>, (+local5523 => +local5525 => (Match.Maybe(&1, Reusable(Unit, CheckResult(Term)), &1, Maybe<&1, Reusable(Unit, CheckResult(Term))>, local5523, _ => (local5525), +value => ((+local5528 => (Some{local5528}))(value))))), xs_1709, None{})
@unsafe
def Elab.elab_proj(+c_1712: Check.Ctx, +a_1713: Syntax, +k_1714: Big) -> CheckResult(Term):
  Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1712, None{}, a_1713), +item5538 => ((+local5426 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.type_of(c_1712, local5426), +item5536 => ((+local5439 => ((+scrut5520 = {Con{(+local5442 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &1, Maybe<&1, Reusable(Unit, CheckResult(Term))>, local5442, _ => None{}, +item5496 => (Some{(+local5444 => ((+scrut5445 = local5444
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &1, Reusable(Unit, CheckResult(Term)), scrut5445, +p5446 => +p5447 => +p5448 => ((+local5450 => ((+scrut5451 = local5450
  Elab.elab_pair_proj(c_1712, local5426, p5446, p5447, k_1714)))))))))(item5496)}))))(Value.as_lan(local5439)), Con{(+local5499 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &1, Maybe<&1, Reusable(Unit, CheckResult(Term))>, local5499, _ => None{}, +item5519 => (Some{(+local5501 => ((+scrut5502 = local5501
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &1, Reusable(Unit, CheckResult(Term)), scrut5502, +p5503 => +p5504 => +p5505 => ((+local5507 => ((+scrut5508 = local5507
  Elab.elab_leg_proj(c_1712, local5426, p5503, k_1714)))))))))(item5519)}))))(Value.as_ran(local5439)), Nil{}}} : List<&1, Maybe<&1, Reusable(Unit, CheckResult(Term))>>}
  Match.Result(&1, Reusable(Unit, CheckResult(Term)), &2, Error, &2, CheckResult(Term), (+local5531 => (Match.Maybe(&1, Reusable(Unit, CheckResult(Term)), &1, Result<&2, &1, Error, Reusable(Unit, CheckResult(Term))>, local5531, _ => Fail{Error.Mismatch{"a projection reads a pair or a tuple, and this scrutinee is neither"}}, +x => Done{x})))(Elab.first_some(scrut5520)), +item5534 => ((+local5533 => (local5533(Unit{})))(item5534)), +item5535 => Fail{item5535}))))(item5536)), +item5537 => Fail{item5537})))(item5538)), +item5539 => Fail{item5539})
@unsafe
def Elab.app_split(+s_1147: Syntax) -> OptionOf(TupleOf2(Syntax, Syntax)):
  (+scrut5561 = s_1147
  Match.Syntax(&2, OptionOf(TupleOf2(Syntax, Syntax)), scrut5561, +p5562 => (None{}), +p5563 => (None{}), _ => (None{}), +p5564 => (None{}), +p5565 => (None{}), _ => (None{}), _ => (None{}), +p5566 => +p5567 => (None{}), +p5568 => (None{}), +p5569 => (None{}), +p5570 => (None{}), +p5571 => +p5572 => (None{}), +p5573 => +p5574 => +p5575 => (None{}), +p5576 => (None{}), +p5577 => +p5578 => (Some{Tup2{p5577, p5578}}), +p5579 => +p5580 => (None{}), +p5581 => +p5582 => (None{}), +p5583 => +p5584 => (None{}), +p5585 => +p5586 => +p5587 => +p5588 => (None{}), +p5589 => +p5590 => (None{}), +p5591 => +p5592 => +p5593 => (None{}), +p5594 => +p5595 => +p5596 => (None{})))
@unsafe
def Elab.spine_of(+s_1340: Syntax, +acc_1341: ListOf(Syntax)) -> TupleOf2(Syntax, ListOf(Syntax)):
  (+local5599 => (Match.Maybe(&2, TupleOf2(Syntax, Syntax), &2, TupleOf2(Syntax, ListOf(Syntax)), local5599, _ => (Tup2{s_1340, acc_1341}), +value => ((+local5601 => ((+scrut5602 = local5601
  Match.Tuple2(&2, Syntax, &2, Syntax, &2, TupleOf2(Syntax, ListOf(Syntax)), scrut5602, +p5603 => +p5604 => (Elab.spine_of(p5603, Con{p5604, acc_1341}))))))(value)))))(Elab.app_split(s_1340))
@unsafe
def Elab.var_name(+s_1181: Syntax) -> OptionOf(String):
  (+scrut5611 = s_1181
  Match.Syntax(&2, OptionOf(String), scrut5611, +p5612 => (Some{p5612}), +p5613 => (None{}), _ => (None{}), +p5614 => (None{}), +p5615 => (None{}), _ => (None{}), _ => (None{}), +p5616 => +p5617 => (None{}), +p5618 => (None{}), +p5619 => (None{}), +p5620 => (None{}), +p5621 => +p5622 => (None{}), +p5623 => +p5624 => +p5625 => (None{}), +p5626 => (None{}), +p5627 => +p5628 => (None{}), +p5629 => +p5630 => (None{}), +p5631 => +p5632 => (None{}), +p5633 => +p5634 => (None{}), +p5635 => +p5636 => +p5637 => +p5638 => (None{}), +p5639 => +p5640 => (None{}), +p5641 => +p5642 => +p5643 => (None{}), +p5644 => +p5645 => +p5646 => (None{})))
@unsafe
def Elab.elab_app_point(+c_1805: Check.Ctx, +f_1806: Syntax, +a_1807: Syntax) -> CheckResult(Term):
  Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1805, None{}, f_1806), +item5704 => ((+local5663 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.type_of(c_1805, local5663), +item5702 => ((+local5666 => (Match.Result(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, Error, &2, CheckResult(Term), (+local5670 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))), local5670, _ => Fail{Error.Mismatch{"the head of an application is not a function"}}, +x => Done{x})))(Value.as_ran(local5666)), +item5700 => ((+local5672 => ((+scrut5673 = local5672
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Term), scrut5673, +p5674 => +p5675 => +p5676 => ((Match.Result(&2, TupleOf3(Quantity, String, Value), &2, Error, &2, CheckResult(Term), (+local5680 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(TupleOf3(Quantity, String, Value)), local5680, _ => Fail{Error.Mismatch{"the head of an application is not a function"}}, +x => Done{x})))(Elab.point_of(p5674)), +item5697 => ((+local5682 => ((+scrut5683 = local5682
Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(Term), scrut5683, +p5684 => +p5685 => +p5686 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1805, Some{p5686}, a_1807), +item5695 => ((+local5689 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Eval.quote(Elab.globals_of(c_1805), Elab.size_of(c_1805), p5686), +item5693 => ((+local5692 => (Done{Term.Out{Shape.SPi{p5684, p5685, local5692}, Term.AddrOf.APt{p5684, local5689}, local5663}}))(item5693)), +item5694 => Fail{item5694})))(item5695)), +item5696 => Fail{item5696}))))))(item5697)), +item5698 => Fail{item5698})))))))(item5700)), +item5701 => Fail{item5701})))(item5702)), +item5703 => Fail{item5703})))(item5704)), +item5705 => Fail{item5705})
@unsafe
def Elab.elab_app(+c_1750: Check.Ctx, +f_1751: Syntax, +a_1752: Syntax) -> CheckResult(Term):
  (+scrut5605 = {Elab.spine_of(Syntax.SApp{f_1751, a_1752}, Nil{}) : TupleOf2(Syntax, ListOf(Syntax))}
  Match.Tuple2(&2, Syntax, &2, ListOf(Syntax), &2, CheckResult(Term), scrut5605, +p5606 => +p5607 => ((+local5712 => (local5712(Unit{})))((+local5610 => ((+local5655 => +local5657 => (Match.Maybe(&2, Elab.Mu_ref, &1, Reusable(Unit, CheckResult(Term)), local5655, _ => ((+local5659 => ((+scrut5660 = local5659
  Elab.elab_app_point(c_1750, f_1751, a_1752))))), +value => ((+local5707 => ((+local5709 => ((+scrut5710 = local5709
  Elab.elab_mu_ref(c_1750, local5707, p5607))))))(value)))(local5657)))(Match.Maybe(&2, String, &2, OptionOf(Elab.Mu_ref), Elab.var_name(p5606), _ => None{}, +item5651 => ((+local5649 => (Elab.mu_ref_of(c_1750, local5649)))(item5651))), local5610)))))))
@unsafe
def Elab.elab_binder(+c_1820: Check.Ctx, +b_1821: Syntax.Binder) -> Result<&2, &1, Error, Tuple4<&2, &2, &2, &1, Quantity, String, Term, Check.Ctx>>:
  Match.Result(&2, Term, &2, Error, &1, Result<&2, &1, Error, Tuple4<&2, &2, &2, &1, Quantity, String, Term, Check.Ctx>>, Elab.elab(c_1820, None{}, Get.Syntax.Binder.b_ty(b_1821)), +item5727 => ((+local5721 => (Match.Result(&2, Value, &2, Error, &1, Result<&2, &1, Error, Tuple4<&2, &2, &2, &1, Quantity, String, Term, Check.Ctx>>, Elab.eval_in(c_1820, local5721), +item5725 => ((+local5724 => (Done{Tup4{Get.Syntax.Binder.b_q(b_1821), Get.Syntax.Binder.b_name(b_1821), local5721, Check.bind(Get.Syntax.Binder.b_name(b_1821), Get.Syntax.Binder.b_q(b_1821), local5724, c_1820)}}))(item5725)), +item5726 => Fail{item5726})))(item5727)), +item5728 => Fail{item5728})
@unsafe
def Elab.cod_of(+c_1824: Check.Ctx, +expected_1825: OptionOf(Value)) -> CheckResult(OptionOf(Value)):
  (+local5739 => (Match.Maybe(&2, Value, &2, CheckResult(OptionOf(Value)), local5739, _ => (Done{None{}}), +value => ((+local5741 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Elab.whnf_in(c_1824, local5741), +item5768 => ((+local5744 => ((+local5747 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(OptionOf(Value)), local5747, _ => (Done{None{}}), +value => ((+local5749 => ((+scrut5750 = local5749
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(OptionOf(Value)), scrut5750, +p5751 => +p5752 => +p5753 => ((+local5756 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, CheckResult(OptionOf(Value)), local5756, _ => (Done{None{}}), +value => ((+local5758 => ((+scrut5759 = local5758
  Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, CheckResult(OptionOf(Value)), scrut5759, +p5760 => +p5761 => +p5762 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Rules.open_closure(Eval.ev(Elab.globals_of(c_1824)), p5752, Con{Value.var(Elab.size_of(c_1824)), Nil{}}), +item5766 => (Done{(+local5765 => (Some{local5765}))(item5766)}), +item5767 => Fail{item5767}))))))(value)))))(Elab.point_of(p5751)))))))(value)))))(Value.as_ran(local5744))))(item5768)), +item5769 => Fail{item5769})))(value)))))(expected_1825)
@unsafe
def Elab.elab_fun(c_1836, expected_1837, bs_1838, body_1839):
  (+scrut5715 = bs_1838
  Match.List(&2, Syntax.Binder, &2, CheckResult(Term), scrut5715, _ => (Elab.elab(c_1836, expected_1837, body_1839)), +p5716 => +p5717 => ((Match.Result(&1, Tuple4<&2, &2, &2, &1, Quantity, String, Term, Check.Ctx>, &2, Error, &2, CheckResult(Term), Elab.elab_binder(c_1836, p5716), +item5779 => ((+local5730 => ((+scrut5731 = local5730
Match.Tuple4(&2, Quantity, &2, String, &2, Term, &1, Check.Ctx, &2, CheckResult(Term), scrut5731, +p5732 => +p5733 => +p5734 => +p5735 => (Match.Result(&2, OptionOf(Value), &2, Error, &2, CheckResult(Term), Elab.cod_of(c_1836, expected_1837), +item5777 => ((+local5771 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab_fun(p5735, local5771, p5717, body_1839), +item5775 => ((+local5774 => (Done{Term.Sec{Shape.SPi{p5732, p5733, p5734}, Con{MkTerm_LegOf{Con{Tup2{p5732, p5733}, Nil{}}, local5774}, Nil{}}}}))(item5775)), +item5776 => Fail{item5776})))(item5777)), +item5778 => Fail{item5778}))))))(item5779)), +item5780 => Fail{item5780})))))
@unsafe
def Elab.elab_group(+c_1849: Check.Ctx, +b_1850: Syntax.Binder, +cod_1851: Syntax, +left_1852: Bool) -> CheckResult(Term):
  Match.Result(&1, Tuple4<&2, &2, &2, &1, Quantity, String, Term, Check.Ctx>, &2, Error, &2, CheckResult(Term), Elab.elab_binder(c_1849, b_1850), +item5798 => ((+local5786 => ((+scrut5787 = local5786
  Match.Tuple4(&2, Quantity, &2, String, &2, Term, &1, Check.Ctx, &2, CheckResult(Term), scrut5787, +p5788 => +p5789 => +p5790 => +p5791 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(p5791, None{}, cod_1851), +item5796 => ((+local5794 => ((+scrut5795 = {Shape.SPi{p5788, p5789, p5790} : Shape<&2, Term>}
  Done{Native.choose(&2, Term, left_1852, _ => (Term.Lan{scrut5795, local5794}), _ => (Term.Ran{scrut5795, local5794}))})))(item5796)), +item5797 => Fail{item5797}))))))(item5798)), +item5799 => Fail{item5799})
@unsafe
def Elab.coll_motive_plain(+m_1896: Syntax.Motive) -> CheckResult(Unit):
  (+local5899 => (Match.Maybe(&2, String, &2, CheckResult(Unit), local5899, _ => (Done{Unit{}}), +value => ((+local5901 => (Fail{Error.Mismatch{String.append("a case at a collection takes no index clause and its motive names ", local5901)}}))(value)))))(Get.Syntax.Motive.mo_ind(m_1896))
@unsafe
def Elab.elab_motive(+c_1889: Check.Ctx, +mo_1890: OptionOf(Syntax.Motive), +scrut_ty_1891: Value) -> CheckResult(OptionOf(Term.Motive)):
  (+local5893 => (Match.Maybe(&2, Syntax.Motive, &2, CheckResult(OptionOf(Term.Motive)), local5893, _ => (Done{None{}}), +value => ((+local5895 => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(OptionOf(Term.Motive)), Elab.coll_motive_plain(local5895), +item5911 => ((+local5903 => ((+scrut5904 = local5903
  (+scrut5905 = {Check.bind(Get.Syntax.Motive.mo_self(local5895), Quantity.Zero{}, scrut_ty_1891, c_1889) : Check.Ctx}
  Match.Result(&2, Term, &2, Error, &2, CheckResult(OptionOf(Term.Motive)), Elab.elab(scrut5905, None{}, Get.Syntax.Motive.mo_body(local5895)), +item5909 => ((+local5908 => (Done{Some{MkTerm_MotiveOf{None{}, Nil{}, Get.Syntax.Motive.mo_self(local5895), local5908}}}))(item5909)), +item5910 => Fail{item5910})))))(item5911)), +item5912 => Fail{item5912})))(value)))))(mo_1890)
@unsafe
def Elab.branch_target(+c_2046: Check.Ctx, +motive_2047: OptionOf(Term.Motive), +expected_2048: OptionOf(Value), +self_2049: Value) -> CheckResult(OptionOf(Value)):
  (+local5936 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(OptionOf(Value)), local5936, _ => (Done{expected_2048}), +value => ((+local5938 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Rules.elim_result(&1, Check.Ctx, Check.ops(), c_2046, motive_2047, expected_2048, self_2049), +item5942 => (Done{(+local5941 => (Some{local5941}))(item5942)}), +item5943 => Fail{item5943})))(value)))))(motive_2047)
@unsafe
def Elab.elab_branch(+c_1898: Check.Ctx, +vs_1899: Shape<&2, Value>, +dlegs_1900: ListOf(Value.Vleg), +motive_1901: OptionOf(Term.Motive), +expected_1902: OptionOf(Value), +br_1903: Syntax.Branch) -> CheckResult(TupleOf2(Term.Addr, Term.Leg)):
  (+scrut5919 = br_1903
  Match.Syntax_Branch(&2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), scrut5919, +p5920 => +p5921 => +p5922 => ((Match.Result(&2, Syntax.Binder, &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), (+local5926 => (Match.Maybe(&2, Syntax.Binder, &2, CheckResult(Syntax.Binder), local5926, _ => Fail{Error.Missing_branch{"each branch binds its payload once"}}, +x => Done{x})))(Rules.one_of(&2, Syntax.Binder, p5921)), +item5956 => ((+local5928 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), Rules.coll_leg_ty(&1, Check.Ctx, Check.ops(), c_1898, dlegs_1900, p5920), +item5954 => ((+local5931 => ((+scrut5932 = {Value.VIn{vs_1899, Value.VaddrOf.VALeg{p5920}, Con{Value.var(Elab.size_of(c_1898)), Nil{}}} : Value}
Match.Result(&2, OptionOf(Value), &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), Elab.branch_target(c_1898, motive_1901, expected_1902, scrut5932), +item5952 => ((+local5945 => ((+scrut5946 = {Check.bind(Get.Syntax.Binder.b_name(local5928), Get.Syntax.Binder.b_q(local5928), local5931, c_1898) : Check.Ctx}
Match.Result(&2, Term, &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), Elab.elab(scrut5946, local5945, p5922), +item5950 => ((+local5949 => (Done{Tup2{Term.AddrOf.ALeg{p5920}, MkTerm_LegOf{Con{Tup2{Get.Syntax.Binder.b_q(local5928), Get.Syntax.Binder.b_name(local5928)}, Nil{}}, local5949}}}))(item5950)), +item5951 => Fail{item5951}))))(item5952)), +item5953 => Fail{item5953}))))(item5954)), +item5955 => Fail{item5955})))(item5956)), +item5957 => Fail{item5957}))), +p5959 => +p5960 => +p5961 => (Fail{Error.Wrong_leg{String.append("the branch at ", String.append(p5959, " keys a constructor and a case at a collection keys a leg"))}})))
@unsafe
def Elab.elab_coll_case(+c_1877: Check.Ctx, +expected_1878: OptionOf(Value), +scrut__1879: Term, +w_1880: Value, +vs_1881: Shape<&2, Value>, +dclo_1882: Value.Closure, +mo_1883: OptionOf(Syntax.Motive), +brs_1884: ListOf(Syntax.Branch)) -> CheckResult(Term):
  Match.Result(&2, Big, &2, Error, &2, CheckResult(Term), (+local5884 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local5884, _ => Fail{Error.Mismatch{"a case eliminates a collection"}}, +x => Done{x})))(Rules.as_vcoll(&2, Value, vs_1881)), +item5970 => ((+local5886 => (Match.Result(&2, ListOf(Value.Vleg), &2, Error, &2, CheckResult(Term), Rules.coll_legs_of(&1, Check.Ctx, Check.ops(), c_1877, dclo_1882), +item5968 => ((+local5889 => (Match.Result(&2, OptionOf(Term.Motive), &2, Error, &2, CheckResult(Term), Elab.elab_motive(c_1877, mo_1883, w_1880), +item5966 => ((+local5914 => (Match.Result(&2, ListOf(TupleOf2(Term.Addr, Term.Leg)), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, TupleOf2(Term.Addr, Term.Leg), SeqList.map(&2, &2, Syntax.Branch, CheckResult(TupleOf2(Term.Addr, Term.Leg)), (+local5918 => (Elab.elab_branch(c_1877, vs_1881, local5889, local5914, expected_1878, local5918))), brs_1884)), +item5964 => ((+local5963 => (Done{Term.Elim{MkTerm_ElimOf{Shape.SColl{local5886}, scrut__1879, Quantity.One{}, local5914, local5963}}}))(item5964)), +item5965 => Fail{item5965})))(item5966)), +item5967 => Fail{item5967})))(item5968)), +item5969 => Fail{item5969})))(item5970)), +item5971 => Fail{item5971})
@unsafe
def Elab.bind_indices(+c_1947: Check.Ctx, +penv_1948: ListOf(Value), +pairs_1949: ListOf(TupleOf2(TupleOf3(Quantity, String, Term), String))) -> Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>:
  SeqList.fold(&2, &1, TupleOf2(TupleOf3(Quantity, String, Term), String), Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, (+local6002 => +local6004 => ((+scrut6005 = local6004
  Match.Tuple2(&2, TupleOf3(Quantity, String, Term), &2, String, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, scrut6005, +p6006 => +p6007 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, p6006, +p6008 => +p6009 => +p6010 => ((Match.Result(&1, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>, &2, Error, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, local6002, +item6024 => ((+local6013 => ((+scrut6014 = local6013
Match.Tuple3(&1, Check.Ctx, &2, ListOf(Value), &2, ListOf(Value), &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, scrut6014, +p6015 => +p6016 => +p6017 => (Match.Result(&2, Value, &2, Error, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, Eval.eval(Elab.globals_of(p6015), p6016, p6010), +item6022 => ((+local6020 => ((+scrut6021 = {Value.var(Elab.size_of(p6015)) : Value}
Done{Tup3{Check.bind(p6007, Quantity.Zero{}, local6020, p6015), Con{scrut6021, p6016}, Con{scrut6021, p6017}}})))(item6022)), +item6023 => Fail{item6023}))))))(item6024)), +item6025 => Fail{item6025}))))))))), pairs_1949, Done{Tup3{c_1947, penv_1948, Nil{}}})
@unsafe
def Elab.elab_mu_motive(+c_1931: Check.Ctx, +n_1932: String, +fam_1933: Positivity.Family, +dclo_1934: Value.Closure, +u_1935: OptionOf(Level), +penv_1936: ListOf(Value), +mo_1937: OptionOf(Syntax.Motive)) -> CheckResult(OptionOf(Term.Motive)):
  (+local5991 => (Match.Maybe(&2, Syntax.Motive, &2, CheckResult(OptionOf(Term.Motive)), local5991, _ => (Done{None{}}), +value => ((+local5993 => (Match.Result(&2, ListOf(TupleOf2(TupleOf3(Quantity, String, Term), String)), &2, Error, &2, CheckResult(OptionOf(Term.Motive)), (+local5997 => (Match.Maybe(&2, ListOf(TupleOf2(TupleOf3(Quantity, String, Term), String)), &2, CheckResult(ListOf(TupleOf2(TupleOf3(Quantity, String, Term), String))), local5997, _ => Fail{Error.Mismatch{String.concat(["the motive of ", n_1932, " binds ", Big.show(Big.of_nat(List.length(&2, String, Get.Syntax.Motive.mo_idx(local5993)))), " index names and the family has ", Big.show(Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Family.f_indices(fam_1933))))])}}, +x => Done{x})))(Rules.zip(&2, TupleOf3(Quantity, String, Term), &2, String, Get.Positivity.Family.f_indices(fam_1933), Get.Syntax.Motive.mo_idx(local5993))), +item6042 => ((+local5999 => (Match.Result(&1, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>, &2, Error, &2, CheckResult(OptionOf(Term.Motive)), Elab.bind_indices(c_1931, penv_1936, local5999), +item6040 => ((+local6028 => ((+scrut6029 = local6028
  Match.Tuple3(&1, Check.Ctx, &2, ListOf(Value), &2, ListOf(Value), &2, CheckResult(OptionOf(Term.Motive)), scrut6029, +p6030 => +p6031 => +p6032 => ((+scrut6033 = {Value.VLan{Shape.SMu{n_1932, List.reverse(&2, Value, p6032)}, dclo_1934, u_1935} : Value}
  (+scrut6034 = {Check.bind(Get.Syntax.Motive.mo_self(local5993), Quantity.Zero{}, scrut6033, p6030) : Check.Ctx}
  Match.Result(&2, Term, &2, Error, &2, CheckResult(OptionOf(Term.Motive)), Elab.elab(scrut6034, None{}, Get.Syntax.Motive.mo_body(local5993)), +item6038 => ((+local6037 => (Done{Some{MkTerm_MotiveOf{Get.Syntax.Motive.mo_ind(local5993), Get.Syntax.Motive.mo_idx(local5993), Get.Syntax.Motive.mo_self(local5993), local6037}}}))(item6038)), +item6039 => Fail{item6039}))))))))(item6040)), +item6041 => Fail{item6041})))(item6042)), +item6043 => Fail{item6043})))(value)))))(mo_1937)
@unsafe
def Elab.check_field_annotation(+c_1962: Check.Ctx, +expected_1963: Value, +f_1964: Syntax.Field) -> CheckResult(Unit):
  (+local6093 => (Match.Maybe(&2, Syntax, &2, CheckResult(Unit), local6093, _ => (Done{Unit{}}), +value => ((+local6095 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Unit), Elab.elab(c_1962, None{}, local6095), +item6114 => ((+local6098 => (Match.Result(&2, Level, &2, Error, &2, CheckResult(Unit), Check.infer_univ(c_1962, local6098), +item6112 => ((+local6101 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Unit), Elab.eval_in(c_1962, local6098), +item6110 => ((+local6104 => (Match.Result(&2, Bool, &2, Error, &2, CheckResult(Unit), Conv.conv_type(&1, Check.Ctx, Check.ops(), c_1962, local6104, expected_1963), +item6108 => ((+local6107 => (Native.choose(&2, CheckResult(Unit), local6107, _ => (Done{Unit{}}), _ => (Fail{Error.Mismatch{String.append("the annotation of constructor field ", String.append(Get.Syntax.Field.fd_name(f_1964), " differs from its declared type"))}}))))(item6108)), +item6109 => Fail{item6109})))(item6110)), +item6111 => Fail{item6111})))(item6112)), +item6113 => Fail{item6113})))(item6114)), +item6115 => Fail{item6115})))(value)))))(Get.Syntax.Field.fd_ty(f_1964))
@unsafe
def Elab.bind_fields(+c_2024: Check.Ctx, +penv_2025: ListOf(Value), +pairs_2026: ListOf(TupleOf2(TupleOf3(Quantity, String, Term), Syntax.Field))) -> Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>:
  SeqList.fold(&2, &1, TupleOf2(TupleOf3(Quantity, String, Term), Syntax.Field), Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, (+local6071 => +local6073 => ((+scrut6074 = local6073
  Match.Tuple2(&2, TupleOf3(Quantity, String, Term), &2, Syntax.Field, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, scrut6074, +p6075 => +p6076 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, p6075, +p6077 => +p6078 => +p6079 => ((Match.Result(&1, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>, &2, Error, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, local6071, +item6124 => ((+local6082 => ((+scrut6083 = local6082
Match.Tuple3(&1, Check.Ctx, &2, ListOf(Value), &2, ListOf(Value), &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, scrut6083, +p6084 => +p6085 => +p6086 => (Match.Result(&2, Value, &2, Error, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, Eval.eval(Elab.globals_of(p6084), p6085, p6079), +item6122 => ((+local6089 => (Match.Result(&2, Unit, &2, Error, &1, Result<&2, &1, Error, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>>, Elab.check_field_annotation(p6084, local6089, p6076), +item6120 => ((+local6117 => ((+scrut6118 = local6117
(+scrut6119 = {Value.var(Elab.size_of(p6084)) : Value}
Done{Tup3{Check.bind(Get.Syntax.Field.fd_name(p6076), Get.Syntax.Field.fd_q(p6076), local6089, p6084), Con{scrut6119, p6085}, Con{scrut6119, p6086}}}))))(item6120)), +item6121 => Fail{item6121})))(item6122)), +item6123 => Fail{item6123}))))))(item6124)), +item6125 => Fail{item6125}))))))))), pairs_2026, Done{Tup3{c_2024, penv_2025, Nil{}}})
@unsafe
def Elab.mu_branch_target(+c_2040: Check.Ctx, +motive_2041: OptionOf(Term.Motive), +expected_2042: OptionOf(Value), +idx_2043: ListOf(Value), +self_2044: Value) -> CheckResult(OptionOf(Value)):
  (+local6142 => (Match.Maybe(&2, Term.Motive, &2, CheckResult(OptionOf(Value)), local6142, _ => (Done{expected_2042}), +value => ((+local6144 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(OptionOf(Value)), Rules.mu_result(&1, Check.Ctx, Check.ops(), c_2040, local6144, idx_2043, self_2044), +item6148 => (Done{(+local6147 => (Some{local6147}))(item6148)}), +item6149 => Fail{item6149})))(value)))))(motive_2041)
@unsafe
def Elab.elab_mu_branch(+c_1999: Check.Ctx, +n_2000: String, +fam_2001: Positivity.Family, +motive_2002: OptionOf(Term.Motive), +penv_2003: ListOf(Value), +expected_2004: OptionOf(Value), +br_2005: Syntax.Branch) -> CheckResult(TupleOf2(Term.Addr, Term.Leg)):
  (+scrut6050 = br_2005
  Match.Syntax_Branch(&2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), scrut6050, +p6051 => +p6052 => +p6053 => (Fail{Error.Wrong_leg{String.concat(["the branch ", Big.show(p6051), " keys a leg and a case at ", n_2000, " keys a constructor"])}}), +p6054 => +p6055 => +p6056 => ((Match.Result(&2, Positivity.Ctor, &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), (+local6060 => (Match.Maybe(&2, Positivity.Ctor, &2, CheckResult(Positivity.Ctor), local6060, _ => Fail{Error.Unbound{String.append(p6054, String.append(" is not a constructor of ", n_2000))}}, +x => Done{x})))(Positivity.ctor_of(p6054, fam_2001)), +item6168 => ((+local6062 => (Match.Result(&2, ListOf(TupleOf2(TupleOf3(Quantity, String, Term), Syntax.Field)), &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), (+local6066 => (Match.Maybe(&2, ListOf(TupleOf2(TupleOf3(Quantity, String, Term), Syntax.Field)), &2, CheckResult(ListOf(TupleOf2(TupleOf3(Quantity, String, Term), Syntax.Field))), local6066, _ => Fail{Error.Missing_branch{String.concat(["the branch at ", p6054, " binds ", Big.show(Big.of_nat(List.length(&2, Syntax.Field, p6055))), " fields and ", p6054, " takes ", Big.show(Big.of_nat(List.length(&2, TupleOf3(Quantity, String, Term), Get.Positivity.Ctor.c_args(local6062))))])}}, +x => Done{x})))(Rules.zip(&2, TupleOf3(Quantity, String, Term), &2, Syntax.Field, Get.Positivity.Ctor.c_args(local6062), p6055)), +item6166 => ((+local6068 => (Match.Result(&1, Tuple3<&1, &2, &2, Check.Ctx, ListOf(Value), ListOf(Value)>, &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), Elab.bind_fields(c_1999, penv_2003, local6068), +item6164 => ((+local6128 => ((+scrut6129 = local6128
Match.Tuple3(&1, Check.Ctx, &2, ListOf(Value), &2, ListOf(Value), &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), scrut6129, +p6130 => +p6131 => +p6132 => ((Match.Result(&2, ListOf(Value), &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), Rules.all_ok(&2, Value, SeqList.map(&2, &2, Term, CheckResult(Value), (+local6135 => (Eval.eval(Elab.globals_of(c_1999), p6131, local6135))), Get.Positivity.Ctor.c_res_idx(local6062))), +item6161 => ((+local6137 => ((+scrut6138 = {Value.VIn{Shape.SMu{n_2000, local6137}, Value.VaddrOf.VACtor{p6054}, List.reverse(&2, Value, p6132)} : Value}
Match.Result(&2, OptionOf(Value), &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), Elab.mu_branch_target(c_1999, motive_2002, expected_2004, local6137, scrut6138), +item6159 => ((+local6151 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), Elab.elab(p6130, local6151, p6056), +item6157 => ((+local6154 => (Done{Tup2{Term.AddrOf.ACtor{p6054}, MkTerm_LegOf{SeqList.map(&2, &2, Syntax.Field, TupleOf2(Quantity, String), (+local6156 => (Tup2{Get.Syntax.Field.fd_q(local6156), Get.Syntax.Field.fd_name(local6156)})), p6055), local6154}}}))(item6157)), +item6158 => Fail{item6158})))(item6159)), +item6160 => Fail{item6160}))))(item6161)), +item6162 => Fail{item6162})))))))(item6164)), +item6165 => Fail{item6165})))(item6166)), +item6167 => Fail{item6167})))(item6168)), +item6169 => Fail{item6169})))))
@unsafe
def Elab.elab_mu_case(+c_1916: Check.Ctx, +expected_1917: OptionOf(Value), +scrut__1918: Term, +n_1919: String, +ixv_1920: ListOf(Value), +dclo_1921: Value.Closure, +u_1922: OptionOf(Level), +mo_1923: OptionOf(Syntax.Motive), +brs_1924: ListOf(Syntax.Branch)) -> CheckResult(Term):
  Match.Result(&2, Positivity.Family, &2, Error, &2, CheckResult(Term), (+local5982 => (Match.Maybe(&2, Positivity.Family, &2, CheckResult(Positivity.Family), local5982, _ => Fail{Error.Unbound{String.append("the family ", String.append(n_1919, " is not declared"))}}, +x => Done{x})))(Global.find_family(n_1919, Elab.globals_of(c_1916))), +item6186 => ((+local5984 => (Match.Result(&2, ListOf(Value), &2, Error, &2, CheckResult(Term), Rules.mu_param_env(&1, Check.Ctx, Check.ops(), c_1916, dclo_1921), +item6184 => ((+local5987 => (Match.Result(&2, OptionOf(Term.Motive), &2, Error, &2, CheckResult(Term), Elab.elab_mu_motive(c_1916, n_1919, local5984, dclo_1921, u_1922, local5987, mo_1923), +item6182 => ((+local6045 => (Match.Result(&2, ListOf(TupleOf2(Term.Addr, Term.Leg)), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, TupleOf2(Term.Addr, Term.Leg), SeqList.map(&2, &2, Syntax.Branch, CheckResult(TupleOf2(Term.Addr, Term.Leg)), (+local6049 => (Elab.elab_mu_branch(c_1916, n_1919, local5984, local6045, local5987, expected_1917, local6049))), brs_1924)), +item6180 => ((+local6172 => (Match.Result(&2, ListOf(Term), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, Term, SeqList.map(&2, &2, Value, CheckResult(Term), (+local6175 => (Eval.quote(Elab.globals_of(c_1916), Elab.size_of(c_1916), local6175))), ixv_1920)), +item6178 => ((+local6177 => (Done{Term.Elim{MkTerm_ElimOf{Shape.SMu{n_1919, local6177}, scrut__1918, Quantity.One{}, local6045, local6172}}}))(item6178)), +item6179 => Fail{item6179})))(item6180)), +item6181 => Fail{item6181})))(item6182)), +item6183 => Fail{item6183})))(item6184)), +item6185 => Fail{item6185})))(item6186)), +item6187 => Fail{item6187})
@unsafe
def Elab.elab_case(+c_1860: Check.Ctx, +expected_1861: OptionOf(Value), +scrut_1862: Syntax, +mo_1863: OptionOf(Syntax.Motive), +brs_1864: ListOf(Syntax.Branch)) -> CheckResult(Term):
  Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1860, None{}, scrut_1862), +item6194 => ((+local5855 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.type_of(c_1860, local5855), +item6192 => ((+local5858 => (Match.Result(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, Error, &2, CheckResult(Term), (+local5862 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))), local5862, _ => Fail{Error.Mismatch{"a case needs a left former as the type of its scrutinee"}}, +x => Done{x})))(Value.as_lan(local5858)), +item6190 => ((+local5864 => ((+scrut5865 = local5864
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Term), scrut5865, +p5866 => +p5867 => +p5868 => ((+local6189 => (local6189(Unit{})))((+local5871 => ((+local5875 => +local5877 => (Match.Maybe(&2, TupleOf2(String, ListOf(Value)), &1, Reusable(Unit, CheckResult(Term)), local5875, _ => ((+local5879 => ((+scrut5880 = local5879
  Elab.elab_coll_case(c_1860, expected_1861, local5855, local5858, p5866, p5867, mo_1863, brs_1864))))), +value => ((+local5973 => ((+scrut5974 = local5973
  Match.Tuple2(&2, String, &2, ListOf(Value), &1, Reusable(Unit, CheckResult(Term)), scrut5974, +p5975 => +p5976 => ((+local5978 => (Elab.elab_mu_case(c_1860, expected_1861, local5855, p5975, p5976, p5867, p5868, mo_1863, brs_1864))))))))(value)))(local5877)))(Rules.as_vmu(&2, Value, p5866), local5871)))))))))(item6190)), +item6191 => Fail{item6191})))(item6192)), +item6193 => Fail{item6193})))(item6194)), +item6195 => Fail{item6195})
@unsafe
def Elab.elab_match(+c_1759: Check.Ctx, +expected_1760: OptionOf(Value), +scrut_1761: Syntax, +mo_1762: OptionOf(Syntax.Motive), +brs_1763: ListOf(Syntax.Branch)) -> CheckResult(Term):
  (+scrut6199 = {Error.Mismatch{"a match needs a mu family as the type of its scrutinee"} : Error}
  (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1759, None{}, scrut_1761), +item6231 => ((+local6202 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.type_of(c_1759, local6202), +item6229 => ((+local6205 => (Match.Result(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, Error, &2, CheckResult(Term), (+local6209 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, CheckResult(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))), local6209, _ => Fail{scrut6199}, +x => Done{x})))(Value.as_lan(local6205)), +item6227 => ((+local6211 => ((+scrut6212 = local6211
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, CheckResult(Term), scrut6212, +p6213 => +p6214 => +p6215 => (Match.Result(&2, TupleOf2(String, ListOf(Value)), &2, Error, &2, CheckResult(Term), (+local6219 => (Match.Maybe(&2, TupleOf2(String, ListOf(Value)), &2, CheckResult(TupleOf2(String, ListOf(Value))), local6219, _ => Fail{scrut6199}, +x => Done{x})))(Rules.as_vmu(&2, Value, p6213)), +item6225 => ((+local6221 => ((+scrut6222 = local6221
Match.Tuple2(&2, String, &2, ListOf(Value), &2, CheckResult(Term), scrut6222, +p6223 => +p6224 => (Elab.elab_mu_case(c_1759, expected_1760, local6202, p6223, p6224, p6214, p6215, mo_1762, brs_1763))))))(item6225)), +item6226 => Fail{item6226}))))))(item6227)), +item6228 => Fail{item6228})))(item6229)), +item6230 => Fail{item6230})))(item6231)), +item6232 => Fail{item6232})))
@unsafe
def Elab.elab(c_1622, expected_1623, s_1624):
  (+scrut1869 = s_1624
  Match.Syntax(&2, CheckResult(Term), scrut1869, +p1870 => ((+local1921 => (Match.Maybe(&2, Elab.Mu_ref, &2, CheckResult(Term), local1921, _ => (Done{(+local1924 => (Match.Maybe(&2, Big, &2, Term, local1924, _ => (Term.Global{p1870}), +value => ((+local1926 => (Term.Var{local1926}))(value)))))(Elab.index_of(p1870, Check.names_of(c_1622)))}), +value => ((+local1928 => (Elab.elab_mu_ref(c_1622, local1928, Nil{})))(value)))))(Elab.mu_ref_of(c_1622, p1870))), +p4180 => (Done{Term.Lit{Literal.LInt{p4180}}}), _ => (Done{Term.Univ{Level.zero()}}), +p4181 => (Elab.univ_of_int(NativeInt.add(p4181, Big.one()))), +p4192 => (Done{Term.Global{Syntax.prim_name(p4192)}}), _ => (Done{Rules.unit_val()}), _ => (Done{Term.Auto{}}), +p4194 => +p4195 => (Elab.elab_pair(c_1622, expected_1623, p4194, p4195)), +p4259 => (Match.Result(&2, ListOf(Term), &2, Error, &2, CheckResult(Term), Elab.elab_items(c_1622, expected_1623, p4259, False{}), +item5402 => ((+local5401 => (Done{Term.Sec{Shape.SColl{Big.of_nat(List.length(&2, Syntax, p4259))}, SeqList.map(&2, &2, Term, Term.Leg, Rules.leg_of, local5401)}}))(item5402)), +item5403 => Fail{item5403})), +p5404 => (Match.Result(&2, ListOf(Term), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, Term, SeqList.map(&2, &2, Syntax, CheckResult(Term), (+local5408 => (Elab.elab(c_1622, None{}, local5408))), p5404)), +item5411 => ((+local5410 => (Done{Rules.sum_ty(local5410)}))(item5411)), +item5412 => Fail{item5412})), +p5413 => (Match.Result(&2, ListOf(Term), &2, Error, &2, CheckResult(Term), Rules.all_ok(&2, Term, SeqList.map(&2, &2, Syntax, CheckResult(Term), (+local5417 => (Elab.elab(c_1622, None{}, local5417))), p5413)), +item5420 => ((+local5419 => (Done{Rules.prod_ty(local5419)}))(item5420)), +item5421 => Fail{item5421})), +p5422 => +p5423 => (Elab.elab_proj(c_1622, p5422, p5423)), +p5540 => +p5541 => +p5542 => (Match.Result(&2, ListOf(OptionOf(Value)), &2, Error, &2, CheckResult(Term), Elab.leg_expectations(c_1622, expected_1623, p5541, True{}), +item5551 => ((+local5545 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1622, Match.Maybe(&2, OptionOf(Value), &2, OptionOf(Value), Rules.at(&2, OptionOf(Value), p5540, local5545), _ => None{}, +x => x), p5542), +item5549 => ((+local5548 => (Done{Term.In{Shape.SColl{p5541}, Term.AddrOf.ALeg{p5540}, Con{local5548, Nil{}}}}))(item5549)), +item5550 => Fail{item5550})))(item5551)), +item5552 => Fail{item5552})), +p5553 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1622, None{}, p5553), +item5557 => ((+local5556 => (Done{Term.Elim{MkTerm_ElimOf{Shape.SColl{Big.zero()}, local5556, Quantity.One{}, None{}, Nil{}}}}))(item5557)), +item5558 => Fail{item5558})), +p5559 => +p5560 => (Elab.elab_app(c_1622, p5559, p5560)), +p5713 => +p5714 => (Elab.elab_fun(c_1622, expected_1623, p5713, p5714)), +p5782 => +p5783 => (Elab.elab_group(c_1622, p5782, p5783, False{})), +p5800 => +p5801 => (Elab.elab_group(c_1622, p5800, p5801, True{})), +p5802 => +p5803 => +p5804 => +p5805 => ((Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1622, None{}, p5803), +item5830 => ((+local5808 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.eval_in(c_1622, local5808), +item5828 => ((+local5811 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1622, Some{local5811}, p5804), +item5826 => ((+local5814 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.eval_in(c_1622, local5814), +item5824 => ((+local5817 => ((+scrut5818 = {Check.define(p5802, Quantity.Many{}, local5811, local5817, c_1622) : Check.Ctx}
Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(scrut5818, expected_1623, p5805), +item5822 => ((+local5821 => (Done{Term.Let{p5802, local5808, local5814, local5821}}))(item5822)), +item5823 => Fail{item5823}))))(item5824)), +item5825 => Fail{item5825})))(item5826)), +item5827 => Fail{item5827})))(item5828)), +item5829 => Fail{item5829})))(item5830)), +item5831 => Fail{item5831}))), +p5833 => +p5834 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1622, None{}, p5834), +item5848 => ((+local5837 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Term), Elab.eval_in(c_1622, local5837), +item5846 => ((+local5840 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Term), Elab.elab(c_1622, Some{local5840}, p5833), +item5844 => ((+local5843 => (Done{Term.Ann{local5843, local5837}}))(item5844)), +item5845 => Fail{item5845})))(item5846)), +item5847 => Fail{item5847})))(item5848)), +item5849 => Fail{item5849})), +p5850 => +p5851 => +p5852 => (Elab.elab_case(c_1622, expected_1623, p5850, p5851, p5852)), +p6196 => +p6197 => +p6198 => (Elab.elab_match(c_1622, expected_1623, p6196, p6197, p6198))))
@unsafe
def Elab.elab_decl(+c_2136: Check.Ctx, +d_2137: Syntax.Decl) -> CheckResult(Check.Decl):
  (+scrut1864 = d_2137
  Match.Syntax_Decl(&2, CheckResult(Check.Decl), scrut1864, +p1865 => +p1866 => +p1867 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Check.Decl), Elab.elab(c_2136, None{}, p1866), +item6246 => ((+local6235 => (Match.Result(&2, Value, &2, Error, &2, CheckResult(Check.Decl), Elab.eval_in(c_2136, local6235), +item6244 => ((+local6238 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Check.Decl), Elab.elab(c_2136, Some{local6238}, p1867), +item6242 => ((+local6241 => (Done{MkCheck_Decl{p1865, Check.Kind.Definition{}, local6235, Some{local6241}}}))(item6242)), +item6243 => Fail{item6243})))(item6244)), +item6245 => Fail{item6245})))(item6246)), +item6247 => Fail{item6247})), +p6248 => +p6249 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Check.Decl), Elab.elab(c_2136, None{}, p6249), +item6253 => ((+local6252 => (Done{MkCheck_Decl{p6248, Check.Kind.Postulate{}, local6252, None{}}}))(item6253)), +item6254 => Fail{item6254})), +p6255 => (Fail{Error.Mismatch{"a mu group declares no entry of its own"}}), +p6256 => (Fail{Error.Mismatch{"a recursive group is elaborated as a group"}})))
@unsafe
def Case.Elab.branch6320(+p1857: Global, +scrut1848: Budget, +local1852: Syntax.Decl, +p1858: ListOf(TupleOf2(String, Global.Entry))) -> CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))):
  Match.Result(&2, Check.Decl, &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), Elab.elab_decl(Check.make(p1857, scrut1848), local1852), +item6318 => ((+local6258 => (Match.Result(&2, ListOf(TupleOf2(String, Global.Entry)), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), Check.check_decls(Some{scrut1848}, p1857, Con{local6258, Nil{}}), +item6316 => ((+local6304 => (Match.Result(&2, TupleOf2(String, Global.Entry), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), (+local6308 => (Match.Maybe(&2, TupleOf2(String, Global.Entry), &2, CheckResult(TupleOf2(String, Global.Entry)), local6308, _ => Fail{Error.Cannot_infer{"the checker answered no entry for a declaration"}}, +x => Done{x})))(Rules.one_of(&2, TupleOf2(String, Global.Entry), local6304)), +item6314 => ((+local6310 => ((+scrut6311 = local6310
  Match.Tuple2(&2, String, &2, Global.Entry, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), scrut6311, +p6312 => +p6313 => (Done{Tup2{Global.add(p6312, p6313, p1857), Con{Tup2{p6312, p6313}, p1858}}})))))(item6314)), +item6315 => Fail{item6315})))(item6316)), +item6317 => Fail{item6317})))(item6318)), +item6319 => Fail{item6319})
@unsafe
def Elab.elab_telescope(+c_2051: Check.Ctx, +bs_2052: ListOf(Syntax.Binder)) -> Result<&2, &1, Error, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>>:
  SeqList.fold(&2, &1, Syntax.Binder, Result<&2, &1, Error, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>>, (+local6344 => +local6346 => (Match.Result(&1, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>, &2, Error, &1, Result<&2, &1, Error, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>>, local6344, +item6363 => ((+local6349 => ((+scrut6350 = local6349
  Match.Tuple2(&2, Positivity.Telescope, &1, Check.Ctx, &1, Result<&2, &1, Error, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>>, scrut6350, +p6351 => +p6352 => (Match.Result(&1, Tuple4<&2, &2, &2, &1, Quantity, String, Term, Check.Ctx>, &2, Error, &1, Result<&2, &1, Error, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>>, Elab.elab_binder(p6352, local6346), +item6361 => ((+local6355 => ((+scrut6356 = local6355
  Match.Tuple4(&2, Quantity, &2, String, &2, Term, &1, Check.Ctx, &1, Result<&2, &1, Error, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>>, scrut6356, +p6357 => +p6358 => +p6359 => +p6360 => (Done{Tup2{List.append(&2, TupleOf3(Quantity, String, Term), p6351, Con{Tup3{p6357, p6358, p6359}, Nil{}}), p6360}})))))(item6361)), +item6362 => Fail{item6362}))))))(item6363)), +item6364 => Fail{item6364}))), bs_2052, Done{Tup2{Nil{}, c_2051}})
@unsafe
def Elab.arrow_split(+s_1176: Syntax) -> OptionOf(TupleOf2(Syntax.Binder, Syntax)):
  (+scrut6371 = s_1176
  Match.Syntax(&2, OptionOf(TupleOf2(Syntax.Binder, Syntax)), scrut6371, +p6372 => (None{}), +p6373 => (None{}), _ => (None{}), +p6374 => (None{}), +p6375 => (None{}), _ => (None{}), _ => (None{}), +p6376 => +p6377 => (None{}), +p6378 => (None{}), +p6379 => (None{}), +p6380 => (None{}), +p6381 => +p6382 => (None{}), +p6383 => +p6384 => +p6385 => (None{}), +p6386 => (None{}), +p6387 => +p6388 => (None{}), +p6389 => +p6390 => (None{}), +p6391 => +p6392 => (Some{Tup2{p6391, p6392}}), +p6393 => +p6394 => (None{}), +p6395 => +p6396 => +p6397 => +p6398 => (None{}), +p6399 => +p6400 => (None{}), +p6401 => +p6402 => +p6403 => (None{}), +p6404 => +p6405 => +p6406 => (None{})))
@unsafe
def Elab.elab_chain(+c_2063: Check.Ctx, +acc_2064: Positivity.Telescope, +s_2065: Syntax) -> Result<&2, &1, Error, Tuple3<&2, &2, &1, Positivity.Telescope, Syntax, Check.Ctx>>:
  (+local6409 => (Match.Maybe(&2, TupleOf2(Syntax.Binder, Syntax), &1, Result<&2, &1, Error, Tuple3<&2, &2, &1, Positivity.Telescope, Syntax, Check.Ctx>>, local6409, _ => (Done{Tup3{acc_2064, s_2065, c_2063}}), +value => ((+local6411 => ((+scrut6412 = local6411
  Match.Tuple2(&2, Syntax.Binder, &2, Syntax, &1, Result<&2, &1, Error, Tuple3<&2, &2, &1, Positivity.Telescope, Syntax, Check.Ctx>>, scrut6412, +p6413 => +p6414 => (Match.Result(&1, Tuple4<&2, &2, &2, &1, Quantity, String, Term, Check.Ctx>, &2, Error, &1, Result<&2, &1, Error, Tuple3<&2, &2, &1, Positivity.Telescope, Syntax, Check.Ctx>>, Elab.elab_binder(c_2063, p6413), +item6423 => ((+local6417 => ((+scrut6418 = local6417
  Match.Tuple4(&2, Quantity, &2, String, &2, Term, &1, Check.Ctx, &1, Result<&2, &1, Error, Tuple3<&2, &2, &1, Positivity.Telescope, Syntax, Check.Ctx>>, scrut6418, +p6419 => +p6420 => +p6421 => +p6422 => (Elab.elab_chain(p6422, List.append(&2, TupleOf3(Quantity, String, Term), acc_2064, Con{Tup3{p6419, p6420, p6421}, Nil{}}), p6414))))))(item6423)), +item6424 => Fail{item6424}))))))(value)))))(Elab.arrow_split(s_2065))
@unsafe
def Elab.elab_univ(+c_2074: Check.Ctx, +s_2075: Syntax) -> CheckResult(Level):
  Match.Result(&2, Term, &2, Error, &2, CheckResult(Level), Elab.elab(c_2074, None{}, s_2075), +item6459 => ((+local6434 => ((+scrut6435 = local6434
  Match.Term(&2, CheckResult(Level), scrut6435, +p6436 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6437 => (Done{p6437}), +p6438 => +p6439 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6440 => +p6441 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6442 => +p6443 => +p6444 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6445 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6446 => +p6447 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6448 => +p6449 => +p6450 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6451 => +p6452 => +p6453 => +p6454 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6455 => +p6456 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6457 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), +p6458 => (Fail{Error.Universe{"the header of a family ends in a universe"}}), _ => (Fail{Error.Universe{"the header of a family ends in a universe"}})))))(item6459)), +item6460 => Fail{item6460})
@unsafe
def Elab.elab_fam_decl(+c_2078: Check.Ctx, +fm_2079: Syntax.Fam) -> CheckResult(Check.Family_decl):
  Match.Result(&1, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>, &2, Error, &2, CheckResult(Check.Family_decl), Elab.elab_telescope(c_2078, Get.Syntax.Fam.fm_params(fm_2079)), +item6467 => ((+local6366 => ((+scrut6367 = local6366
  Match.Tuple2(&2, Positivity.Telescope, &1, Check.Ctx, &2, CheckResult(Check.Family_decl), scrut6367, +p6368 => +p6369 => (Match.Result(&1, Tuple3<&2, &2, &1, Positivity.Telescope, Syntax, Check.Ctx>, &2, Error, &2, CheckResult(Check.Family_decl), Elab.elab_chain(p6369, Nil{}, Get.Syntax.Fam.fm_ty(fm_2079)), +item6465 => ((+local6426 => ((+scrut6427 = local6426
  Match.Tuple3(&2, Positivity.Telescope, &2, Syntax, &1, Check.Ctx, &2, CheckResult(Check.Family_decl), scrut6427, +p6428 => +p6429 => +p6430 => (Match.Result(&2, Level, &2, Error, &2, CheckResult(Check.Family_decl), Elab.elab_univ(p6430, p6429), +item6463 => ((+local6462 => (Done{MkCheck_Family_decl{Get.Syntax.Fam.fm_name(fm_2079), p6368, p6428, local6462}}))(item6463)), +item6464 => Fail{item6464}))))))(item6465)), +item6466 => Fail{item6466}))))))(item6467)), +item6468 => Fail{item6468})
@unsafe
def Elab.mu_result(+name_2099: String, +t_2100: Term) -> CheckResult(TupleOf2(ListOf(Term), ListOf(Term))):
  (+scrut6569 = {Fail{Error.Mismatch{String.append("a constructor of ", String.append(name_2099, " ends at another type"))}} : CheckResult(TupleOf2(ListOf(Term), ListOf(Term)))}
  ((+scrut6570 = t_2100
Match.Term(&2, CheckResult(TupleOf2(ListOf(Term), ListOf(Term))), scrut6570, +p6571 => (scrut6569), +p6572 => (scrut6569), +p6573 => +p6574 => (Match.Shape(&2, Term, &2, CheckResult(TupleOf2(ListOf(Term), ListOf(Term))), p6573, +p6575 => +p6576 => +p6577 => (scrut6569), +p6578 => (scrut6569), +p6579 => +p6580 => (scrut6569), +p6581 => +p6582 => (Native.choose(&2, CheckResult(TupleOf2(ListOf(Term), ListOf(Term))), NativeString.equal(p6581, name_2099), _ => (Match.Result(&2, ListOf(Term), &2, Error, &2, CheckResult(TupleOf2(ListOf(Term), ListOf(Term))), Rules.mu_params_of(p6574), +item6585 => (Done{(+local6584 => (Tup2{local6584, p6582}))(item6585)}), +item6586 => Fail{item6586})), _ => (scrut6569))), +p6587 => +p6588 => (scrut6569))), +p6589 => +p6590 => (scrut6569), +p6591 => +p6592 => +p6593 => (scrut6569), +p6594 => (scrut6569), +p6595 => +p6596 => (scrut6569), +p6597 => +p6598 => +p6599 => (scrut6569), +p6600 => +p6601 => +p6602 => +p6603 => (scrut6569), +p6604 => +p6605 => (scrut6569), +p6606 => (scrut6569), +p6607 => (scrut6569), _ => (scrut6569)))))
@unsafe
def Elab.elab_ctor_decl(+c_2088: Check.Ctx, +name_2089: String, +fc_2090: Syntax.Fam_ctor) -> CheckResult(Check.Ctor_decl):
  Match.Result(&1, Tuple3<&2, &2, &1, Positivity.Telescope, Syntax, Check.Ctx>, &2, Error, &2, CheckResult(Check.Ctor_decl), Elab.elab_chain(c_2088, Nil{}, Get.Syntax.Fam_ctor.fc_ty(fc_2090)), +item6618 => ((+local6560 => ((+scrut6561 = local6560
  Match.Tuple3(&2, Positivity.Telescope, &2, Syntax, &1, Check.Ctx, &2, CheckResult(Check.Ctor_decl), scrut6561, +p6562 => +p6563 => +p6564 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(Check.Ctor_decl), Elab.elab(p6564, None{}, p6563), +item6616 => ((+local6567 => (Match.Result(&2, TupleOf2(ListOf(Term), ListOf(Term)), &2, Error, &2, CheckResult(Check.Ctor_decl), Elab.mu_result(name_2089, local6567), +item6614 => ((+local6610 => ((+scrut6611 = local6610
  Match.Tuple2(&2, ListOf(Term), &2, ListOf(Term), &2, CheckResult(Check.Ctor_decl), scrut6611, +p6612 => +p6613 => (Done{MkCheck_Ctor_decl{Get.Syntax.Fam_ctor.fc_name(fc_2090), p6562, p6612, p6613}})))))(item6614)), +item6615 => Fail{item6615})))(item6616)), +item6617 => Fail{item6617}))))))(item6618)), +item6619 => Fail{item6619})
@unsafe
def Elab.elab_mu_group(+_opt__2133: Maybe<&1, Budget>, +globals_2117: Global, +fams_2118: ListOf(Syntax.Fam)) -> CheckResult(Global):
  (+scrut6329 = {(+scrut6327 = _opt__2133
  Match.Maybe(&1, Budget, &1, Budget, scrut6327, _ => (Budget.unlimited()), +p6328 => (p6328))) : Budget}
  (+scrut6332 = {SeqList.map(&2, &2, Syntax.Fam, String, (+local6331 => (Get.Syntax.Fam.fm_name(local6331))), fams_2118) : ListOf(String)}
  (Match.Result(&2, Global, &2, Error, &2, CheckResult(Global), SeqList.fold(&2, &2, Syntax.Fam, CheckResult(Global), (+local6335 => +local6337 => (Match.Result(&2, Global, &2, Error, &2, CheckResult(Global), local6335, +item6537 => ((+local6340 => (Match.Result(&2, Check.Family_decl, &2, Error, &2, CheckResult(Global), Elab.elab_fam_decl(Check.make(local6340, scrut6329), local6337), +item6535 => ((+local6470 => (Check.declare_family(Some{scrut6329}, local6340, local6470)))(item6535)), +item6536 => Fail{item6536})))(item6537)), +item6538 => Fail{item6538}))), fams_2118, Done{globals_2117}), +item6982 => ((+local6540 => (SeqList.fold(&2, &2, Syntax.Fam, CheckResult(Global), (+local6542 => +local6544 => (Match.Result(&2, Global, &2, Error, &2, CheckResult(Global), local6542, +item6980 => ((+local6547 => (Match.Result(&1, Tuple2<&2, &1, Positivity.Telescope, Check.Ctx>, &2, Error, &2, CheckResult(Global), Elab.elab_telescope(Check.make(local6547, scrut6329), Get.Syntax.Fam.fm_params(local6544)), +item6978 => ((+local6550 => ((+scrut6551 = local6550
Match.Tuple2(&2, Positivity.Telescope, &1, Check.Ctx, &2, CheckResult(Global), scrut6551, +p6552 => +p6553 => (Match.Result(&2, ListOf(Check.Ctor_decl), &2, Error, &2, CheckResult(Global), Rules.all_ok(&2, Check.Ctor_decl, SeqList.map(&2, &2, Syntax.Fam_ctor, CheckResult(Check.Ctor_decl), (+local6557 => (Elab.elab_ctor_decl(p6553, Get.Syntax.Fam.fm_name(local6544), local6557))), Get.Syntax.Fam.fm_ctors(local6544))), +item6976 => ((+local6621 => (Check.define_ctors(Some{scrut6329}, local6547, scrut6332, Get.Syntax.Fam.fm_name(local6544), local6621)))(item6976)), +item6977 => Fail{item6977}))))))(item6978)), +item6979 => Fail{item6979})))(item6980)), +item6981 => Fail{item6981}))), fams_2118, Done{local6540})))(item6982)), +item6983 => Fail{item6983}))))
@unsafe
def Elab.elab_rec_group(+_opt__2279: Maybe<&1, Budget>, +globals_2152: Global, +ms_2153: ListOf(Syntax.Rec_def)) -> CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))):
  (+scrut6996 = {(+scrut6994 = _opt__2279
  Match.Maybe(&1, Budget, &1, Budget, scrut6994, _ => (Budget.unlimited()), +p6995 => (p6995))) : Budget}
  (Match.Result(&2, ListOf(TupleOf2(Syntax.Rec_def, Term)), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), SeqList.fold(&2, &2, Syntax.Rec_def, CheckResult(ListOf(TupleOf2(Syntax.Rec_def, Term))), (+local6999 => +local7001 => (Match.Result(&2, ListOf(TupleOf2(Syntax.Rec_def, Term)), &2, Error, &2, CheckResult(ListOf(TupleOf2(Syntax.Rec_def, Term))), local6999, +item7010 => ((+local7004 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(ListOf(TupleOf2(Syntax.Rec_def, Term))), Elab.elab(Check.make(globals_2152, scrut6996), None{}, Get.Syntax.Rec_def.rd_ty(local7001)), +item7008 => ((+local7007 => (Done{List.append(&2, TupleOf2(Syntax.Rec_def, Term), local7004, Con{Tup2{local7001, local7007}, Nil{}})}))(item7008)), +item7009 => Fail{item7009})))(item7010)), +item7011 => Fail{item7011}))), ms_2153, Done{Nil{}}), +item8108 => ((+local7013 => (Match.Result(&2, ListOf(TupleOf2(String, Global.Entry)), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), Check.check_decls(Some{scrut6996}, globals_2152, SeqList.map(&2, &2, TupleOf2(Syntax.Rec_def, Term), Check.Decl, (+local7016 => ((+scrut7017 = local7016
Match.Tuple2(&2, Syntax.Rec_def, &2, Term, &2, Check.Decl, scrut7017, +p7018 => +p7019 => (MkCheck_Decl{Get.Syntax.Rec_def.rd_name(p7018), Check.Kind.Postulate{}, p7019, None{}}))))), local7013)), +item8106 => ((+local7021 => ((+scrut7029 = {SeqList.fold(&2, &2, TupleOf2(String, Global.Entry), Global, (+local7023 => +local7025 => ((+scrut7026 = local7025
Match.Tuple2(&2, String, &2, Global.Entry, &2, Global, scrut7026, +p7027 => +p7028 => (Global.add(p7027, p7028, local7023)))))), local7021, globals_2152) : Global}
(Match.Result(&2, ListOf(TupleOf4(String, Term, Value, Term)), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), SeqList.fold(&2, &2, TupleOf2(Syntax.Rec_def, Term), CheckResult(ListOf(TupleOf4(String, Term, Value, Term))), (+local7032 => +local7034 => ((+scrut7035 = local7034
Match.Tuple2(&2, Syntax.Rec_def, &2, Term, &2, CheckResult(ListOf(TupleOf4(String, Term, Value, Term))), scrut7035, +p7036 => +p7037 => ((Match.Result(&2, ListOf(TupleOf4(String, Term, Value, Term)), &2, Error, &2, CheckResult(ListOf(TupleOf4(String, Term, Value, Term))), local7032, +item7052 => ((+local7040 => ((+scrut7041 = {Check.make(scrut7029, scrut6996) : Check.Ctx}
Match.Result(&2, Value, &2, Error, &2, CheckResult(ListOf(TupleOf4(String, Term, Value, Term))), Elab.eval_in(scrut7041, p7037), +item7050 => ((+local7044 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(ListOf(TupleOf4(String, Term, Value, Term))), Elab.elab(scrut7041, Some{local7044}, Get.Syntax.Rec_def.rd_body(p7036)), +item7048 => ((+local7047 => (Done{List.append(&2, TupleOf4(String, Term, Value, Term), local7040, Con{Tup4{Get.Syntax.Rec_def.rd_name(p7036), p7037, local7044, local7047}, Nil{}})}))(item7048)), +item7049 => Fail{item7049})))(item7050)), +item7051 => Fail{item7051}))))(item7052)), +item7053 => Fail{item7053}))))))), local7013, Done{Nil{}}), +item8103 => ((+local7056 => (Match.Result(&2, OptionOf(Order), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), Totality.guard_group(Some{scrut6996}, scrut7029, SeqList.map(&2, &2, TupleOf4(String, Term, Value, Term), TupleOf2(String, Term), (+local7059 => ((+scrut7060 = local7059
Match.Tuple4(&2, String, &2, Term, &2, Value, &2, Term, &2, TupleOf2(String, Term), scrut7060, +p7061 => +p7062 => +p7063 => +p7064 => (Tup2{p7061, p7064}))))), local7056)), +item8101 => ((+local7927 => ((+scrut7937 = {(+local7929 => (Check.check_decls(Some{scrut6996}, globals_2152, SeqList.map(&2, &2, TupleOf4(String, Term, Value, Term), Check.Decl, (+local7931 => ((+scrut7932 = local7931
Match.Tuple4(&2, String, &2, Term, &2, Value, &2, Term, &2, Check.Decl, scrut7932, +p7933 => +p7934 => +p7935 => +p7936 => (MkCheck_Decl{p7933, Check.Kind.Definition{}, p7934, Some{p7936}}))))), local7056)))) : Reusable(Unit, CheckResult(ListOf(TupleOf2(String, Global.Entry))))}
((+scrut8076 = {(+local7939 => +local7941 => (SeqList.fold(&2, &2, TupleOf4(String, Term, Value, Term), CheckResult(ListOf(TupleOf2(String, Global.Entry))), (+local7943 => +local7945 => ((+scrut7946 = local7945
Match.Tuple4(&2, String, &2, Term, &2, Value, &2, Term, &2, CheckResult(ListOf(TupleOf2(String, Global.Entry))), scrut7946, +p7947 => +p7948 => +p7949 => +p7950 => ((Match.Result(&2, ListOf(TupleOf2(String, Global.Entry)), &2, Error, &2, CheckResult(ListOf(TupleOf2(String, Global.Entry))), local7943, +item8073 => ((+local7953 => (Match.Result(&2, Term, &2, Error, &2, CheckResult(ListOf(TupleOf2(String, Global.Entry))), Order.translate(local7939, p7950), +item8071 => ((+local8060 => (Match.Result(&2, Unit, &2, Error, &2, CheckResult(ListOf(TupleOf2(String, Global.Entry))), Check.check_term(Some{scrut6996}, scrut7029, local8060, p7949), +item8069 => ((+local8067 => ((+scrut8068 = local8067
Done{List.append(&2, TupleOf2(String, Global.Entry), local7953, Con{Tup2{p7947, Global.Entry.Def{MkGlobal_Def_entry{p7948, local8060, True{}, Native.choose(&2, OptionOf(Big), Order.mentions(Get.Order.o_group(local7939), p7950), _ => (Some{Get.Order.o_arg(local7939)}), _ => (None{})), False{}}}}, Nil{}})})))(item8069)), +item8070 => Fail{item8070})))(item8071)), +item8072 => Fail{item8072})))(item8073)), +item8074 => Fail{item8074}))))))), local7056, Done{Nil{}}))) : Reusable(Order, Reusable(Unit, CheckResult(ListOf(TupleOf2(String, Global.Entry)))))}
Match.Result(&2, ListOf(TupleOf2(String, Global.Entry)), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), (+local8088 => (local8088(Unit{})))((+local8080 => ((+local8084 => +local8086 => (Match.Maybe(&2, Order, &1, Reusable(Unit, CheckResult(ListOf(TupleOf2(String, Global.Entry)))), local8084, _ => (scrut7937), +value => (scrut8076(value)))(local8086)))(local7927, local8080)))), +item8098 => ((+local8090 => (Done{Tup2{SeqList.fold(&2, &2, TupleOf2(String, Global.Entry), Global, (+local8092 => +local8094 => ((+scrut8095 = local8094
Match.Tuple2(&2, String, &2, Global.Entry, &2, Global, scrut8095, +p8096 => +p8097 => (Global.add(p8096, p8097, local8092)))))), local8090, globals_2152), local8090}}))(item8098)), +item8099 => Fail{item8099}))))))(item8101)), +item8102 => Fail{item8102})))(item8103)), +item8104 => Fail{item8104})))))(item8106)), +item8107 => Fail{item8107})))(item8108)), +item8109 => Fail{item8109})))
@unsafe
def Elab.elab_program_in(+_opt__2304: Maybe<&1, Budget>, +globals_2283: Global, +ds_2284: ListOf(Syntax.Decl)) -> CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))):
  (+scrut1848 = {(+scrut1846 = _opt__2304
  Match.Maybe(&1, Budget, &1, Budget, scrut1846, _ => (Budget.unlimited()), +p1847 => (p1847))) : Budget}
  ((+local8118 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), local8118, +item8124 => (Done{(+local8120 => ((+scrut8121 = local8120
Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), scrut8121, +p8122 => +p8123 => (Tup2{p8122, List.reverse(&2, TupleOf2(String, Global.Entry), p8123)})))))(item8124)}), +item8125 => Fail{item8125})))(SeqList.fold(&2, &2, Syntax.Decl, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), (+local1850 => +local1852 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), local1850, +item8114 => ((+local1855 => ((+scrut1856 = local1855
Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), scrut1856, +p1857 => +p1858 => (((+scrut1859 = local1852
Match.Syntax_Decl(&2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), scrut1859, +p1860 => +p1861 => +p1862 => (Case.Elab.branch6320(p1857, scrut1848, local1852, p1858)), +p6321 => +p6322 => (Case.Elab.branch6320(p1857, scrut1848, local1852, p1858)), +p6323 => (Match.Result(&2, Global, &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), Elab.elab_mu_group(Some{scrut1848}, p1857, p6323), +item6985 => (Done{(+local6325 => (Tup2{local6325, p1858}))(item6985)}), +item6986 => Fail{item6986})), +p6987 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), Elab.elab_rec_group(Some{scrut1848}, p1857, p6987), +item8111 => (Done{(+local6989 => ((+scrut6990 = local6989
Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), &2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), scrut6990, +p6991 => +p6992 => (Tup2{p6991, List.reverse.go(&2, TupleOf2(String, Global.Entry), p6992, p1858)})))))(item8111)}), +item8112 => Fail{item8112}))))))))))(item8114)), +item8115 => Fail{item8115}))), ds_2284, Done{Tup2{globals_2283, Nil{}}}))))
@unsafe
def Elab.check_in(+_opt__2406: Maybe<&1, Budget>, +globals_2359: Global, +src_2360: String) -> CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))):
  (+scrut811 = {(+scrut806 = _opt__2406
  Match.Maybe(&1, Budget, &1, Budget, scrut806, _ => (Budget.unlimited()), +p810 => (p810))) : Budget}
  Match.Result(&2, ListOf(Syntax.Decl), &2, Error, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry)))), Parser.parse(src_2360), +item8127 => ((+local1844 => (Elab.elab_program_in(Some{scrut811}, globals_2359, local1844)))(item8127)), +item8128 => Fail{item8128}))
@unsafe
def Elab.axiom_names(+rows_2351: ListOf(TupleOf2(String, Global.Entry))) -> ListOf(String):
  SeqList.filter_map(&2, &2, TupleOf2(String, Global.Entry), String, (+local8647 => ((+scrut8648 = local8647
  Match.Tuple2(&2, String, &2, Global.Entry, &2, OptionOf(String), scrut8648, +p8649 => +p8650 => ((+local8657 => (Match.Maybe(&2, Global.Axiom_entry, &2, OptionOf(String), local8657, _ => None{}, +item8661 => (Some{(+local8659 => (p8649))(item8661)}))))(Global.axiom_of(p8650))))))), rows_2351)
@unsafe
def Eterm.tid_text(+t_330: Eterm.Tid) -> String:
  (+scrut8773 = t_330
  Match.Eterm_Tid(&2, String, scrut8773, +p8774 => (p8774)))
@unsafe
def Erase.let_(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2)) -> Reusable(Result<q1, q2, A1, A2>, Reusable(Reusable(A2, Result<q1, q0, A1, A0>), Result<q1, q0, A1, A0>)):
  (+local14378 => +local14380 => (Match.Result(q2, A2, q1, A1, (q0 <&> q1), Result<q1, q0, A1, A0>, local14378, +item14381 => (local14380(item14381)), +item14382 => Fail{item14382})))
@unsafe
def Erase.globals_of(+ec_437: Erase.Ectx) -> Global:
  Get.Check.Ctx.globals(Get.Erase.Ectx.c(ec_437))
@unsafe
def Erase.size_of(+ec_480: Erase.Ectx) -> Big:
  Get.Check.Ctx.size(Get.Erase.Ectx.c(ec_480))
@unsafe
def Erase.env_of(+ec_483: Erase.Ectx) -> ListOf(Value):
  Get.Check.Ctx.env(Get.Erase.Ectx.c(ec_483))
@unsafe
def Erase.lazy_fold(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), +o_506: Maybe<q0, A0>, +none_507: Reusable(Unit, A1), +some_508: Reusable(A0, A1)) -> A1:
  Match.Maybe(q0, A0, &1, Reusable(Unit, A1), o_506, _ => (none_507), +value => ((+local14384 => +local14386 => ((+scrut14387 = local14386
  some_508(local14384))))(value)))(Unit{})
@unsafe
def Erase.lookup(+ix_533: Big, +slots_534: ListOf(Erase.Slot), +seen_535: Big) -> Erase.Found:
  (+scrut14388 = slots_534
  Match.List(&2, Erase.Slot, &2, Erase.Found, scrut14388, _ => (Erase.Found.LOut{}), +p14389 => +p14390 => (Match.Erase_Slot(&2, Erase.Found, p14389, _ => (Native.choose(&2, Erase.Found, Big.is_eq(ix_533, Big.zero()), _ => (Erase.Found.LDrop{}), _ => (Erase.lookup(NativeInt.sub(ix_533, Big.one()), p14390, seen_535)))), _ => (Native.choose(&2, Erase.Found, Big.is_eq(ix_533, Big.zero()), _ => (Erase.Found.LKeep{seen_535}), _ => (Erase.lookup(NativeInt.sub(ix_533, Big.one()), p14390, NativeInt.add(seen_535, Big.one()))))), _ => (Erase.lookup(ix_533, p14390, NativeInt.add(seen_535, Big.one())))))))
@unsafe
def Erase.quantity_runtime(+q_599: Quantity) -> Bool:
  Bool.not(Quantity.equal(q_599, Quantity.Zero{}))
@unsafe
def Erase.form_of(+w_671: Value) -> Erase.Form:
  (+scrut14402 = {(+local14392 => ((+scrut14393 = local14392
  (+local14396 => (Match.Maybe(&2, TupleOf2(Value.Head, ListOf(Value.Spine)), &2, Erase.Form, local14396, _ => (Erase.Form.FOther{}), +value => ((+local14398 => ((+scrut14399 = local14398
  Match.Tuple2(&2, Value.Head, &2, ListOf(Value.Spine), &2, Erase.Form, scrut14399, +p14400 => +p14401 => (Native.choose(&2, Erase.Form, Big.when(Bool, Value.head_equal(p14400, Value.Head.HGlobal{Prim.nat_name()}), _ => (List.is_empty(&2, Value.Spine, p14401)), _ => (False{})), _ => (Erase.Form.FNat{}), _ => (Erase.Form.FOther{})))))))(value)))))(Value.as_neutral(w_671))))) : Reusable(Unit, Erase.Form)}
  ((+local14405 => (Match.Maybe(&2, Level, &2, Erase.Form, local14405, _ => ((+local14408 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, Erase.Form, local14408, _ => ((+local14411 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, Erase.Form, local14411, _ => (scrut14402(Unit{})), +value => ((+local14413 => ((+scrut14414 = local14413
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, Erase.Form, scrut14414, +p14415 => +p14416 => +p14417 => (Erase.Form.FRan{p14415, p14416})))))(value)))))(Value.as_ran(w_671))), +value => ((+local14419 => ((+scrut14420 = local14419
Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, Erase.Form, scrut14420, +p14421 => +p14422 => +p14423 => (Erase.Form.FLan{p14421, p14422})))))(value)))))(Value.as_lan(w_671))), +value => ((+local14425 => (Erase.Form.FUniv{}))(value)))))(Value.as_univ(w_671))))
@unsafe
def Erase.point_of(+s_781: Shape<&2, Value>) -> Erase.Point:
  (+local14429 => (Match.Maybe(&2, TupleOf3(Quantity, String, Value), &2, Erase.Point, local14429, _ => ((+local14432 => (Match.Maybe(&2, Big, &2, Erase.Point, local14432, _ => (Erase.Point.POther{}), +value => ((+local14434 => (Erase.Point.PColl{local14434}))(value)))))(Rules.as_vcoll(&2, Value, s_781))), +value => ((+local14436 => ((+scrut14437 = local14436
  Match.Tuple3(&2, Quantity, &2, String, &2, Value, &2, Erase.Point, scrut14437, +p14438 => +p14439 => +p14440 => (Erase.Point.PPoint{p14438, p14439, p14440})))))(value)))))(Rules.as_vpi(&2, Value, s_781))
@unsafe
def Erase.width_zero(+w_908: Value) -> Bool:
  (+scrut14454 = {(+local14442 => ((+local14445 => (Match.Maybe(&2, TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level)), &2, Bool, local14445, _ => (False{}), +value => ((+local14447 => ((+scrut14448 = local14447
  Match.Tuple3(&2, Shape<&2, Value>, &2, Value.Closure, &2, OptionOf(Level), &2, Bool, scrut14448, +p14449 => +p14450 => +p14451 => (Match.Maybe(&2, Big, &2, Bool, Rules.as_vcoll(&2, Value, p14449), _ => Bool.not(Maybe.is_some(&2, Big, Some{Big.zero()})), +x => Match.Maybe(&2, Big, &2, Bool, Some{Big.zero()}, _ => False{}, +y => (+arg14452 => +arg14453 => Big.is_eq(arg14452, arg14453))(x, y))))))))(value)))))(local14442))) : Reusable(OptionOf(TupleOf3(Shape<&2, Value>, Value.Closure, OptionOf(Level))), Bool)}
  Big.when(Bool, scrut14454(Value.as_lan(w_908)), _ => (True{}), _ => (scrut14454(Value.as_ran(w_908)))))
@unsafe
def Erase.proof_free(+ec_918: Erase.Ectx, +w_919: Value) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound14456 : Term <- Eval.quote(Erase.globals_of(ec_918), Erase.size_of(ec_918), w_919)
    +bound14458 : Level <- Check.infer_univ(Get.Erase.Ectx.c(ec_918), bound14456)
    Done{Bool.not(Level.equal(bound14458, Level.zero()))})
@unsafe
def Erase.runtime_ty(+ec_978: Erase.Ectx, +ty_979: Value) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound14460 : Value <- Eval.whnf(Erase.globals_of(ec_978), ty_979)
    (+scrut14461 = {Unit{} : Unit}
    Native.choose(&2, CheckResult(Bool), Maybe.is_some(&2, Level, Value.as_univ(bound14460)), _ => (Done{False{}}), _ => (Native.choose(&2, CheckResult(Bool), Erase.width_zero(bound14460), _ => (Done{False{}}), _ => (Erase.proof_free(ec_978, bound14460)))))))
@unsafe
def Erase.point_runtime(+ec_983: Erase.Ectx, +q_984: Quantity, +dom_985: Value) -> CheckResult(Bool):
  Native.choose(&2, CheckResult(Bool), Erase.quantity_runtime(q_984), _ => (Erase.runtime_ty(ec_983, dom_985)), _ => (Done{False{}}))
@unsafe
def Erase.any_repr() -> Eterm.Repr:
  Eterm.Repr.RUnion{Eterm.Tid.Tid{"any"}}
@unsafe
def Erase.unit_leg() -> String:
  "unit"
@unsafe
def Erase.scrut_name() -> String:
  "scrut"
@unsafe
def Erase.mu_tid(+n_991: String) -> Eterm.Tid:
  Eterm.Tid.Tid{String.append("mu<", String.append(n_991, ">"))}
@unsafe
def Eterm.print_repr(+r_568: Eterm.Repr) -> String:
  (+scrut14464 = r_568
  Match.Eterm_Repr(&2, String, scrut14464, _ => ("i31"), +p14465 => (String.append("struct ", Eterm.tid_text(p14465))), +p14466 => (String.append("union ", Eterm.tid_text(p14466))), +p14467 => (String.append("func ", Eterm.tid_text(p14467))), +p14468 => (String.append("thunk ", Eterm.tid_text(p14468)))))
@unsafe
def Erase.mu_leg_tid(+n_994: String, +k_995: Big, +rs_996: ListOf(Eterm.Repr)) -> Eterm.Tid:
  Eterm.Tid.Tid{String.concat(["leg<", Eterm.tid_text(Erase.mu_tid(n_994)), ",", Big.show(k_995), String.join(SeqList.map(&2, &2, Eterm.Repr, String, (+local14463 => (String.append(",", Eterm.print_repr(local14463)))), rs_996), ""), ">"])}
@unsafe
def Erase.position(+x_1105: String, +xs_1106: ListOf(String)) -> OptionOf(Big):
  Get.Tuple2.v1(&2, Big, &2, OptionOf(Big), SeqList.fold(&2, &2, String, TupleOf2(Big, OptionOf(Big)), (+local14470 => +local14472 => ((+scrut14473 = local14470
  Match.Tuple2(&2, Big, &2, OptionOf(Big), &2, TupleOf2(Big, OptionOf(Big)), scrut14473, +p14474 => +p14475 => (Tup2{NativeInt.add(p14474, Big.one()), Erase.lazy_fold(&2, Big, &2, OptionOf(Big), p14475, (+local14477 => ((+scrut14478 = local14477
  Native.choose(&2, OptionOf(Big), NativeString.equal(x_1105, local14472), _ => (Some{p14474}), _ => (None{}))))), (+local14480 => (Some{local14480})))}))))), xs_1106, Tup2{Big.zero(), None{}}))
@unsafe
def Erase.branch_arity_word() -> String:
  "a branch binds a different number of fields than its constructor takes"
@unsafe
def Erase.under_point(+ec_1177: Erase.Ectx, +x_1178: String, +q_1179: Quantity, +dom_1180: Value, +d_1181: Value.Closure) -> Result<&2, &1, Error, Tuple2<&1, &2, Erase.Ectx, Value>>:
  Match.Result(&2, Value, &2, Error, &1, Result<&2, &1, Error, Tuple2<&1, &2, Erase.Ectx, Value>>, Rules.open_closure(Eval.ev(Erase.globals_of(ec_1177)), d_1181, Con{Value.var(Erase.size_of(ec_1177)), Nil{}}), +item14503 => ((+local14502 => (Done{Tup2{MkErase_Ectx{Check.bind(x_1178, q_1179, dom_1180, Get.Erase.Ectx.c(ec_1177)), Con{Erase.Slot.SDrop{}, Get.Erase.Ectx.slots(ec_1177)}, Get.Erase.Ectx.self(ec_1177)}, local14502}}))(item14503)), +item14504 => Fail{item14504})
@unsafe
def Erase.repr_text(+ec_1314: Erase.Ectx, +keep_1315: Bool, +ty_1316: Value) -> CheckResult(ListOf(String)):
  Native.choose(&2, CheckResult(ListOf(String)), keep_1315, _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(ListOf(String)), Erase.repr_of(ec_1314, ty_1316), +item14516 => (Done{(+local14515 => (Con{Eterm.print_repr(local14515), Nil{}}))(item14516)}), +item14517 => Fail{item14517})), _ => (Done{Nil{}}))
@unsafe
def Erase.pair_texts(+ec_1302: Erase.Ectx, +q_1303: Quantity, +x_1304: String, +dom_1305: Value, +d_1306: Value.Closure) -> CheckResult(ListOf(String)):
  (do CheckResult<ListOf(String)>:
    +bound14496 : Bool <- Erase.point_runtime(ec_1302, q_1303, dom_1305)
    +bound14498 : ListOf(String) <- Erase.repr_text(ec_1302, bound14496, dom_1305)
    Match.Result(&1, Tuple2<&1, &2, Erase.Ectx, Value>, &2, Error, &2, CheckResult(ListOf(String)), Erase.under_point(ec_1302, x_1304, q_1303, dom_1305, d_1306), +item14518 => ((+local14506 => ((+scrut14507 = local14506
    Match.Tuple2(&1, Erase.Ectx, &2, Value, &2, CheckResult(ListOf(String)), scrut14507, +p14508 => +p14509 => ((do CheckResult<ListOf(String)>:
      +bound14511 : Bool <- Erase.runtime_ty(p14508, p14509)
      +bound14513 : ListOf(String) <- Erase.repr_text(p14508, bound14511, p14509)
      Done{List.append(&2, String, bound14498, bound14513)}))))))(item14518)), +item14519 => Fail{item14519}))
@unsafe
def Erase.leg_types(+ec_1318: Erase.Ectx, +n_1319: Big, +d_1320: Value.Closure) -> CheckResult(ListOf(Value)):
  (do CheckResult<ListOf(Value)>:
    +bound14532 : ListOf(Value.Vleg) <- Rules.coll_legs_of(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_1318), d_1320)
    Rules.all_ok(&2, Value, SeqList.map(&2, &2, Big, CheckResult(Value), (+local14534 => (Rules.coll_leg_ty(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_1318), bound14532, local14534))), SeqList.init(&2, Big, n_1319, (+local14537 => (local14537))))))
@unsafe
def Erase.sum_texts(+ec_1335: Erase.Ectx, +n_1336: Big, +d_1337: Value.Closure) -> CheckResult(ListOf(String)):
  (do CheckResult<ListOf(String)>:
    +bound14524 : ListOf(Value) <- Erase.leg_types(ec_1335, n_1336, d_1337)
    Rules.all_ok(&2, String, SeqList.map(&2, &2, Value, CheckResult(String), (+local14526 => ((do CheckResult<String>:
      +bound14528 : Bool <- Erase.runtime_ty(ec_1335, local14526)
      Native.choose(&2, CheckResult(String), bound14528, _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(String), Erase.repr_of(ec_1335, local14526), +item14529 => (Done{Eterm.print_repr(item14529)}), +item14530 => Fail{item14530})), _ => (Done{Erase.unit_leg()}))))), bound14524)))
@unsafe
def Erase.lan_point_repr(+ec_1151: Erase.Ectx, +s_1152: Shape<&2, Value>, +d_1153: Value.Closure) -> CheckResult(Eterm.Repr):
  (+scrut14489 = {Erase.point_of(s_1152) : Erase.Point}
  Match.Erase_Point(&2, CheckResult(Eterm.Repr), scrut14489, +p14490 => +p14491 => +p14492 => ((do CheckResult<Eterm.Repr>:
    +bound14494 : ListOf(String) <- Erase.pair_texts(ec_1151, p14490, p14491, p14492, d_1153)
    Done{Eterm.Repr.RStruct{Eterm.Tid.Tid{String.append("pair<", String.append(String.join(bound14494, ","), ">"))}}})), +p14520 => (Native.choose(&2, CheckResult(Eterm.Repr), Big.is_eq(p14520, Big.zero()), _ => (Done{Erase.any_repr()}), _ => ((do CheckResult<Eterm.Repr>:
    +bound14522 : ListOf(String) <- Erase.sum_texts(ec_1151, p14520, d_1153)
    Done{Eterm.Repr.RUnion{Eterm.Tid.Tid{String.append("sum<", String.append(String.join(bound14522, "|"), ">"))}}})))), _ => (Done{Erase.any_repr()})))
@unsafe
def Erase.lan_repr(+ec_1144: Erase.Ectx, +s_1145: Shape<&2, Value>, +d_1146: Value.Closure) -> CheckResult(Eterm.Repr):
  Erase.lazy_fold(&2, TupleOf2(String, ListOf(Value)), &2, CheckResult(Eterm.Repr), Rules.as_vmu(&2, Value, s_1145), (+local14487 => ((+scrut14488 = local14487
  Erase.lan_point_repr(ec_1144, s_1145, d_1146)))), (+local14539 => ((+scrut14540 = local14539
  Match.Tuple2(&2, String, &2, ListOf(Value), &2, CheckResult(Eterm.Repr), scrut14540, +p14541 => +p14542 => (Done{Eterm.Repr.RUnion{Erase.mu_tid(p14541)}}))))))
@unsafe
def Erase.arity_rest(+ec_1172: Erase.Ectx, +n_1173: Big, +w_1174: Value) -> CheckResult(Big):
  (+scrut14565 = {Erase.form_of(w_1174) : Erase.Form}
  Match.Erase_Form(&2, CheckResult(Big), scrut14565, _ => (Done{n_1173}), +p14566 => +p14567 => (Done{n_1173}), +p14568 => +p14569 => (Erase.arity_of(ec_1172, n_1173, p14568, p14569)), _ => (Done{n_1173}), _ => (Done{n_1173})))
@unsafe
def Erase.arity_of(ec_1160, n_1161, s_1162, d_1163):
  (+scrut14551 = {Erase.point_of(s_1162) : Erase.Point}
  Match.Erase_Point(&2, CheckResult(Big), scrut14551, +p14552 => +p14553 => +p14554 => ((do CheckResult<Big>:
    +bound14556 : Bool <- Erase.point_runtime(ec_1160, p14552, p14554)
    Match.Result(&1, Tuple2<&1, &2, Erase.Ectx, Value>, &2, Error, &2, CheckResult(Big), Erase.under_point(ec_1160, p14553, p14552, p14554, d_1163), +item14570 => ((+local14559 => ((+scrut14560 = local14559
    Match.Tuple2(&1, Erase.Ectx, &2, Value, &2, CheckResult(Big), scrut14560, +p14561 => +p14562 => ((do CheckResult<Big>:
      +bound14564 : Value <- Eval.whnf(Erase.globals_of(p14561), p14562)
      Erase.arity_rest(p14561, Native.choose(&2, Big, bound14556, _ => (NativeInt.add(n_1161, Big.one())), _ => (n_1161)), bound14564)))))))(item14570)), +item14571 => Fail{item14571}))), +p14572 => (Done{n_1161}), _ => (Done{n_1161})))
@unsafe
def Erase.tuple_texts(+ec_1341: Erase.Ectx, +n_1342: Big, +d_1343: Value.Closure) -> CheckResult(ListOf(String)):
  (do CheckResult<ListOf(String)>:
    +bound14577 : ListOf(Value) <- Erase.leg_types(ec_1341, n_1342, d_1343)
    +bound14579 : ListOf(ListOf(String)) <- Rules.all_ok(&2, ListOf(String), SeqList.map(&2, &2, Value, CheckResult(ListOf(String)), (+local14581 => ((do CheckResult<ListOf(String)>:
      +bound14583 : Bool <- Erase.runtime_ty(ec_1341, local14581)
      Erase.repr_text(ec_1341, bound14583, local14581)))), bound14577))
    Done{List.concat(&2, String, bound14579)})
@unsafe
def Erase.ran_repr(+ec_1135: Erase.Ectx, +s_1136: Shape<&2, Value>, +d_1137: Value.Closure) -> CheckResult(Eterm.Repr):
  (+scrut14545 = {Erase.point_of(s_1136) : Erase.Point}
  Match.Erase_Point(&2, CheckResult(Eterm.Repr), scrut14545, +p14546 => +p14547 => +p14548 => ((do CheckResult<Eterm.Repr>:
    +bound14550 : Big <- Erase.arity_of(ec_1135, Big.zero(), s_1136, d_1137)
    Done{Eterm.Repr.RFunc{Eterm.Tid.Tid{String.concat(["fn<", Big.show(bound14550), ">"])}}})), +p14573 => (Native.choose(&2, CheckResult(Eterm.Repr), Big.is_eq(p14573, Big.zero()), _ => (Done{Erase.any_repr()}), _ => ((do CheckResult<Eterm.Repr>:
    +bound14575 : ListOf(String) <- Erase.tuple_texts(ec_1135, p14573, d_1137)
    Done{Eterm.Repr.RStruct{Eterm.Tid.Tid{String.append("tuple<", String.append(String.join(bound14575, ","), ">"))}}})))), _ => (Done{Erase.any_repr()})))
@unsafe
def Erase.repr_of(ec_1128, v_1129):
  (do CheckResult<Eterm.Repr>:
    +bound14482 : Value <- Eval.whnf(Erase.globals_of(ec_1128), v_1129)
    (+scrut14483 = {Erase.form_of(bound14482) : Erase.Form}
    Match.Erase_Form(&2, CheckResult(Eterm.Repr), scrut14483, _ => (Done{Erase.any_repr()}), +p14484 => +p14485 => (Erase.lan_repr(ec_1128, p14484, p14485)), +p14543 => +p14544 => (Erase.ran_repr(ec_1128, p14543, p14544)), _ => (Done{Eterm.Repr.RUnion{Eterm.Tid.Tid{"nat"}}}), _ => (Done{Erase.any_repr()}))))
@unsafe
def Erase.leg_flags(+ec_1330: Erase.Ectx, +n_1331: Big, +d_1332: Value.Closure) -> CheckResult(ListOf(Bool)):
  (do CheckResult<ListOf(Bool)>:
    +bound14585 : ListOf(Value) <- Erase.leg_types(ec_1330, n_1331, d_1332)
    Rules.all_ok(&2, Bool, SeqList.map(&2, &2, Value, CheckResult(Bool), (+local14587 => (Erase.runtime_ty(ec_1330, local14587))), bound14585)))
@unsafe
def Erase.tid_of(+ec_1348: Erase.Ectx, +ty_1349: Value) -> CheckResult(Eterm.Tid):
  (do CheckResult<Eterm.Tid>:
    +bound14589 : Eterm.Repr <- Erase.repr_of(ec_1348, ty_1349)
    (+scrut14590 = bound14589
    Match.Eterm_Repr(&2, CheckResult(Eterm.Tid), scrut14590, _ => (Fail{Error.Mismatch{"a structured value stands at a type whose repr is i31"}}), +p14591 => (Done{p14591}), +p14592 => (Done{p14592}), +p14593 => (Done{p14593}), +p14594 => (Done{p14594}))))
@unsafe
def Erase.mu_leg_reprs(ec_1374, env_1375, tele_1376):
  (+scrut14595 = tele_1376
  Match.List(&2, TupleOf3(Quantity, String, Term), &2, CheckResult(ListOf(OptionOf(Eterm.Repr))), scrut14595, _ => (Done{Nil{}}), +p14596 => +p14597 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, CheckResult(ListOf(OptionOf(Eterm.Repr))), p14596, +p14598 => +p14599 => +p14600 => ((do CheckResult<ListOf(OptionOf(Eterm.Repr))>:
    +bound14602 : Value <- Eval.eval(Erase.globals_of(ec_1374), env_1375, p14600)
    +bound14604 : Bool <- Erase.point_runtime(ec_1374, p14598, bound14602)
    ((do CheckResult<ListOf(OptionOf(Eterm.Repr))>:
  +bound14606 : OptionOf(Eterm.Repr) <- Native.choose(&2, CheckResult(OptionOf(Eterm.Repr)), bound14604, _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(OptionOf(Eterm.Repr)), Erase.repr_of(ec_1374, bound14602), +item14613 => (Done{(+local14612 => (Some{local14612}))(item14613)}), +item14614 => Fail{item14614})), _ => (Done{None{}}))
  (+scrut14607 = {MkErase_Ectx{Check.bind(p14599, p14598, bound14602, Get.Erase.Ectx.c(ec_1374)), Con{Erase.Slot.SDrop{}, Get.Erase.Ectx.slots(ec_1374)}, Get.Erase.Ectx.self(ec_1374)} : Erase.Ectx}
  (do CheckResult<ListOf(OptionOf(Eterm.Repr))>:
    +bound14609 : ListOf(OptionOf(Eterm.Repr)) <- Erase.mu_leg_reprs(scrut14607, Con{Value.var(Erase.size_of(ec_1374)), env_1375}, p14597)
    Done{Con{bound14606, bound14609}}))))))))))
@unsafe
def Erase.mu_parameters(+ec_1387: Erase.Ectx, +tele_1388: Positivity.Telescope) -> Result<&2, &1, Error, Erase.Ectx>:
  (+scrut14616 = tele_1388
  Match.List(&2, TupleOf3(Quantity, String, Term), &1, Result<&2, &1, Error, Erase.Ectx>, scrut14616, _ => (Done{ec_1387}), +p14617 => +p14618 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, &1, Result<&2, &1, Error, Erase.Ectx>, p14617, +p14619 => +p14620 => +p14621 => (Match.Result(&2, Value, &2, Error, &1, Result<&2, &1, Error, Erase.Ectx>, Eval.eval(Erase.globals_of(ec_1387), Erase.env_of(ec_1387), p14621), +item14625 => ((+local14624 => (Erase.mu_parameters(MkErase_Ectx{Check.bind(p14620, p14619, local14624, Get.Erase.Ectx.c(ec_1387)), Con{Erase.Slot.SDrop{}, Get.Erase.Ectx.slots(ec_1387)}, Get.Erase.Ectx.self(ec_1387)}, p14618)))(item14625)), +item14626 => Fail{item14626}))))))
@unsafe
def Erase.mu_layout(+ec_1396: Erase.Ectx, +fam_1397: Positivity.Family, +ct_1398: Positivity.Ctor) -> CheckResult(ListOf(OptionOf(Eterm.Repr))):
  (+scrut14627 = {MkErase_Ectx{Check.make(Erase.globals_of(ec_1396), Get.Check.Ctx.budget(Get.Erase.Ectx.c(ec_1396))), Nil{}, Get.Erase.Ectx.self(ec_1396)} : Erase.Ectx}
  Match.Result(&1, Erase.Ectx, &2, Error, &2, CheckResult(ListOf(OptionOf(Eterm.Repr))), Erase.mu_parameters(scrut14627, Get.Positivity.Family.f_params(fam_1397)), +item14631 => ((+local14630 => (Erase.mu_leg_reprs(local14630, Erase.env_of(local14630), Get.Positivity.Ctor.c_args(ct_1398))))(item14631)), +item14632 => Fail{item14632}))
@unsafe
def Erase.mu_group_tids(+ec_1425: Erase.Ectx, +n_1426: String, +fam_1427: Positivity.Family) -> CheckResult(ListOf(Eterm.Tid)):
  (do CheckResult<ListOf(Eterm.Tid)>:
    +bound14634 : ListOf(String) <- Rules.mu_ctor_names(n_1426, fam_1427)
    Rules.all_ok(&2, Eterm.Tid, SeqList.mapi(&2, &2, String, CheckResult(Eterm.Tid), (+local14636 => +local14638 => ((do CheckResult<Eterm.Tid>:
      +bound14640 : Positivity.Ctor <- (+local14648 => (Match.Maybe(&2, Positivity.Ctor, &2, CheckResult(Positivity.Ctor), local14648, _ => Fail{Error.Unbound{String.append(local14638, String.append(" is not a constructor of ", n_1426))}}, +x => Done{x})))(Positivity.ctor_of(local14638, fam_1427))
      +bound14642 : ListOf(OptionOf(Eterm.Repr)) <- Erase.mu_layout(ec_1425, fam_1427, bound14640)
      Done{Erase.mu_leg_tid(n_1426, local14636, SeqList.filter_map(&2, &2, OptionOf(Eterm.Repr), Eterm.Repr, (+local14645 => (local14645)), bound14642))}))), bound14634)))
@unsafe
def Erase.zip(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), +xs_1434: List<q0, A0>, +ys_1435: List<q1, A1>) -> List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>:
  (+scrut14649 = {Tup2{xs_1434, ys_1435} : Tuple2<q0, q1, List<q0, A0>, List<q1, A1>>}
  Match.Tuple2(q0, List<q0, A0>, q1, List<q1, A1>, (q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>, scrut14649, +p14650 => +p14651 => (Match.List(q0, A0, (q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>, p14650, _ => (Match.List(q1, A1, (q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>, p14651, _ => (Nil{}), +p14652 => +p14653 => (Nil{}))), +p14654 => +p14655 => (Match.List(q1, A1, (q0 <&> q1), List<(q0 <&> q1), Tuple2<q0, q1, A0, A1>>, p14651, _ => (Nil{}), +p14656 => +p14657 => (Con{Tup2{p14654, p14656}, Erase.zip(q0, A0, q1, A1, p14655, p14657)})))))))
@unsafe
def Erase.free_addr(+depth_1474: Big, +a_1475: Term.Addr) -> ListOf(Big):
  (+local14670 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, ListOf(Big), local14670, _ => (Nil{}), +value => ((+local14672 => ((+scrut14673 = local14672
  Match.Tuple2(&2, Quantity, &2, Term, &2, ListOf(Big), scrut14673, +p14674 => +p14675 => (Erase.free_vars(depth_1474, p14675))))))(value)))))(Term.as_apt(a_1475))
@unsafe
def Erase.free_leg(+depth_1479: Big, +lg_1480: Term.Leg) -> ListOf(Big):
  Erase.free_vars(NativeInt.add(depth_1479, Big.of_nat(List.length(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(lg_1480)))), Get.Term.Leg.l_body(lg_1480))
@unsafe
def Erase.free_vars(depth_1447, t_1448):
  (+scrut14658 = t_1448
  Match.Term(&2, ListOf(Big), scrut14658, +p14659 => (Native.choose(&2, ListOf(Big), Big.is_le(depth_1447, p14659), _ => (Con{NativeInt.sub(p14659, depth_1447), Nil{}}), _ => (Nil{}))), +p14660 => (Nil{}), +p14661 => +p14662 => (Nil{}), +p14663 => +p14664 => (Nil{}), +p14665 => +p14666 => +p14667 => (List.append(&2, Big, Erase.free_addr(depth_1447, p14666), List.concat(&2, Big, SeqList.map(&2, &2, Term, ListOf(Big), (+local14678 => (Erase.free_vars(depth_1447, local14678))), p14667)))), +p14679 => (List.append(&2, Big, Erase.free_vars(depth_1447, Get.Term.Elim.e_scrut(p14679)), List.concat(&2, Big, SeqList.map(&2, &2, TupleOf2(Term.Addr, Term.Leg), ListOf(Big), (+local14681 => ((+scrut14682 = local14681
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, ListOf(Big), scrut14682, +p14683 => +p14684 => (Erase.free_leg(depth_1447, p14684)))))), Get.Term.Elim.e_branches(p14679))))), +p14685 => +p14686 => (List.concat(&2, Big, SeqList.map(&2, &2, Term.Leg, ListOf(Big), (+local14689 => (Erase.free_leg(depth_1447, local14689))), p14686))), +p14690 => +p14691 => +p14692 => (List.append(&2, Big, Erase.free_addr(depth_1447, p14691), Erase.free_vars(depth_1447, p14692))), +p14693 => +p14694 => +p14695 => +p14696 => (List.append(&2, Big, Erase.free_vars(depth_1447, p14695), Erase.free_vars(NativeInt.add(depth_1447, Big.one()), p14696))), +p14697 => +p14698 => (Erase.free_vars(depth_1447, p14697)), +p14699 => (Nil{}), +p14700 => (Nil{}), _ => (Nil{})))
@unsafe
def Erase.captures_of(+ec_1483: Erase.Ectx, +t_1484: Term) -> ListOf(Big):
  SeqList.sort_uniq(&2, Big, (+arg14701 => +arg14702 => Big.compare(arg14701, arg14702)), SeqList.filter(&2, Big, (+local14704 => ((+scrut14705 = {Erase.lookup(local14704, Get.Erase.Ectx.slots(ec_1483), Big.zero()) : Erase.Found}
  Match.Erase_Found(&2, Bool, scrut14705, +p14706 => (True{}), _ => (False{}), _ => (False{}))))), Erase.free_vars(Big.zero(), t_1484)))
@unsafe
def Erase.reindex_runtime(index_1487, depth_1488, t_1489):
  (+scrut14710 = {(+local14709 => (Erase.reindex_runtime(index_1487, depth_1488, local14709))) : Reusable(Eterm.Ktm, Eterm.Ktm)}
  ((+scrut14711 = t_1489
Match.Eterm_Ktm(&2, Eterm.Ktm, scrut14711, +p14712 => (Eterm.Ktm.KVar{Native.choose(&2, Big, Big.is_le(depth_1488, p14712), _ => (NativeInt.add(depth_1488, index_1487(NativeInt.sub(p14712, depth_1488)))), _ => (p14712))}), +p14713 => (t_1489), +p14714 => (t_1489), _ => (t_1489), +p14715 => +p14716 => +p14717 => (Eterm.Ktm.KLet{p14715, scrut14710(p14716), Erase.reindex_runtime(index_1487, NativeInt.add(depth_1488, Big.one()), p14717)}), +p14718 => +p14719 => +p14720 => (Eterm.Ktm.KClos{p14718, p14719, SeqList.map(&2, &2, Eterm.Ktm, Eterm.Ktm, scrut14710, p14720)}), +p14721 => +p14722 => (Eterm.Ktm.KApp{scrut14710(p14721), SeqList.map(&2, &2, Eterm.Ktm, Eterm.Ktm, scrut14710, p14722)}), +p14723 => +p14724 => (Eterm.Ktm.KTail{scrut14710(p14723), SeqList.map(&2, &2, Eterm.Ktm, Eterm.Ktm, scrut14710, p14724)}), +p14725 => +p14726 => (Eterm.Ktm.KStruct{p14725, SeqList.map(&2, &2, Eterm.Ktm, Eterm.Ktm, scrut14710, p14726)}), +p14727 => +p14728 => +p14729 => (Eterm.Ktm.KProj{p14727, p14728, scrut14710(p14729)}), +p14730 => +p14731 => +p14732 => (Eterm.Ktm.KTag{p14730, p14731, SeqList.map(&2, &2, Eterm.Ktm, Eterm.Ktm, scrut14710, p14732)}), +p14733 => +p14734 => +p14735 => (Eterm.Ktm.KCase{p14733, scrut14710(p14734), SeqList.map(&2, &2, Eterm.Kbranch, Eterm.Kbranch, (+local14737 => (MkEterm_KbranchOf{Get.Eterm.Kbranch.tag(local14737), Get.Eterm.Kbranch.arity(local14737), Erase.reindex_runtime(index_1487, NativeInt.add(depth_1488, Get.Eterm.Kbranch.arity(local14737)), Get.Eterm.Kbranch.body(local14737))})), p14735)}), +p14738 => +p14739 => (Eterm.Ktm.KDelay{p14738, SeqList.map(&2, &2, Eterm.Ktm, Eterm.Ktm, scrut14710, p14739)}), +p14740 => (Eterm.Ktm.KForce{scrut14710(p14740)})))))
@unsafe
def Erase.shift_runtime(+by_1519: Big, +depth_1520: Big, +t_1521: Eterm.Ktm) -> Eterm.Ktm:
  Erase.reindex_runtime((+local14743 => (NativeInt.add(local14743, by_1519))), depth_1520, t_1521)
@unsafe
def Erase.runtime_vars(depth_1524, t_1525):
  (+scrut14747 = {(+local14746 => (Erase.runtime_vars(depth_1524, local14746))) : Reusable(Eterm.Ktm, ListOf(Big))}
  ((+scrut14748 = t_1525
Match.Eterm_Ktm(&2, ListOf(Big), scrut14748, +p14749 => (Native.choose(&2, ListOf(Big), Big.is_le(depth_1524, p14749), _ => (Con{NativeInt.sub(p14749, depth_1524), Nil{}}), _ => (Nil{}))), +p14750 => (Nil{}), +p14751 => (Nil{}), _ => (Nil{}), +p14752 => +p14753 => +p14754 => (List.append(&2, Big, scrut14747(p14753), Erase.runtime_vars(NativeInt.add(depth_1524, Big.one()), p14754))), +p14755 => +p14756 => +p14757 => (List.concat(&2, Big, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Big), scrut14747, p14757))), +p14758 => +p14759 => (List.append(&2, Big, scrut14747(p14758), List.concat(&2, Big, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Big), scrut14747, p14759)))), +p14760 => +p14761 => (List.append(&2, Big, scrut14747(p14760), List.concat(&2, Big, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Big), scrut14747, p14761)))), +p14762 => +p14763 => (List.concat(&2, Big, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Big), scrut14747, p14763))), +p14764 => +p14765 => +p14766 => (scrut14747(p14766)), +p14767 => +p14768 => +p14769 => (List.concat(&2, Big, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Big), scrut14747, p14769))), +p14770 => +p14771 => +p14772 => (List.append(&2, Big, scrut14747(p14771), List.concat(&2, Big, SeqList.map(&2, &2, Eterm.Kbranch, ListOf(Big), (+local14774 => (Erase.runtime_vars(NativeInt.add(depth_1524, Get.Eterm.Kbranch.arity(local14774)), Get.Eterm.Kbranch.body(local14774)))), p14772)))), +p14775 => +p14776 => (List.concat(&2, Big, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Big), scrut14747, p14776))), +p14777 => (scrut14747(p14777))))))
@unsafe
def Erase.prune_captures(+ps_1547: ListOf(Eterm.Repr), +args_1548: ListOf(Eterm.Ktm), +params_1549: Big, +body_1550: Eterm.Ktm) -> TupleOf3(ListOf(Eterm.Repr), ListOf(Eterm.Ktm), Eterm.Ktm):
  (+scrut14779 = {Big.of_nat(List.length(&2, Eterm.Repr, ps_1547)) : Big}
  ((+scrut14784 = {SeqList.sort_uniq(&2, Big, (+arg14780 => +arg14781 => Big.compare(arg14780, arg14781)), SeqList.filter_map(&2, &2, Big, Big, (+local14783 => (Native.choose(&2, OptionOf(Big), Big.when(Bool, Big.is_le(params_1549, local14783), _ => (Big.is_lt(local14783, NativeInt.add(params_1549, scrut14779))), _ => (False{})), _ => (Some{NativeInt.sub(local14783, params_1549)}), _ => (None{})))), Erase.runtime_vars(Big.zero(), body_1550))) : ListOf(Big)}
(+scrut14788 = {(+local14786 => (SeqList.exists(&2, Big, +item14787 => Big.is_eq(NativeInt.sub(NativeInt.sub(scrut14779, local14786), Big.one()), item14787), scrut14784))) : Reusable(Big, Bool)}
(+scrut14793 = {(+local14790 => (Native.choose(&2, Big, Big.is_lt(local14790, params_1549), _ => (local14790), _ => (NativeInt.add(params_1549, Big.of_nat(List.length(&2, Big, SeqList.filter(&2, Big, (+local14792 => (Big.is_lt(local14792, NativeInt.sub(local14790, params_1549)))), scrut14784)))))))) : Reusable(Big, Big)}
Tup3{SeqList.filteri(&2, Eterm.Repr, (+local14795 => +local14797 => (scrut14788(local14795))), ps_1547), SeqList.filteri(&2, Eterm.Ktm, (+local14799 => +local14801 => (scrut14788(local14799))), args_1548), Erase.reindex_runtime(scrut14793, Big.zero(), body_1550)})))))
@unsafe
def Erase.refused(+s_1567: Shape<&2, Term>) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  Match.Result(&1, Rules.Rule_pack<&1, Check.Ctx>, &2, Error, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), Rules.rules(&2, Term, &1, Check.Ctx, s_1567), +item14806 => ((+local14805 => (Fail{Error.Not_yet{"an erasure at a shape past M0"}}))(item14806)), +item14807 => Fail{item14807})
@unsafe
def Erase.as_app(+t_1571: Term) -> OptionOf(TupleOf4(Quantity, Term, Term, Term)):
  (+scrut14808 = t_1571
  Match.Term(&2, OptionOf(TupleOf4(Quantity, Term, Term, Term)), scrut14808, +p14809 => (None{}), +p14810 => (None{}), +p14811 => +p14812 => (None{}), +p14813 => +p14814 => (None{}), +p14815 => +p14816 => +p14817 => (None{}), +p14818 => (None{}), +p14819 => +p14820 => (None{}), +p14821 => +p14822 => +p14823 => (Match.Shape(&2, Term, &2, OptionOf(TupleOf4(Quantity, Term, Term, Term)), p14821, +p14824 => +p14825 => +p14826 => (Match.Term_Addr(&2, OptionOf(TupleOf4(Quantity, Term, Term, Term)), p14822, +p14827 => +p14828 => (Some{Tup4{p14827, p14826, p14828, p14823}}), +p14829 => (None{}), +p14830 => (None{}))), +p14831 => (None{}), +p14832 => +p14833 => (None{}), +p14834 => +p14835 => (None{}), +p14836 => +p14837 => (None{}))), +p14838 => +p14839 => +p14840 => +p14841 => (None{}), +p14842 => +p14843 => (None{}), +p14844 => (None{}), +p14845 => (None{}), _ => (None{})))
@unsafe
def Erase.spine(+t_1579: Term, +args_1580: ListOf(TupleOf3(Quantity, Term, Term))) -> TupleOf2(Term, ListOf(TupleOf3(Quantity, Term, Term))):
  Erase.lazy_fold(&2, TupleOf4(Quantity, Term, Term, Term), &2, TupleOf2(Term, ListOf(TupleOf3(Quantity, Term, Term))), Erase.as_app(t_1579), (+local14847 => ((+scrut14848 = local14847
  Tup2{t_1579, args_1580}))), (+local14850 => ((+scrut14851 = local14850
  Match.Tuple4(&2, Quantity, &2, Term, &2, Term, &2, Term, &2, TupleOf2(Term, ListOf(TupleOf3(Quantity, Term, Term))), scrut14851, +p14852 => +p14853 => +p14854 => +p14855 => (Erase.spine(p14855, Con{Tup3{p14852, p14853, p14854}, args_1580})))))))
@unsafe
def Erase.var_arm(+ec_1659: Erase.Ectx, +ac_1660: Erase.Acc, +ix_1661: Big) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (+scrut14862 = {Erase.lookup(ix_1661, Get.Erase.Ectx.slots(ec_1659), Big.zero()) : Erase.Found}
  Match.Erase_Found(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut14862, +p14863 => (Done{Tup2{Eterm.Ktm.KVar{p14863}, ac_1660}}), _ => (Done{Tup2{Eterm.Ktm.KErased{}, ac_1660}}), _ => (Fail{Error.Unbound{String.concat(["the erasure context has no binder at index ", Big.show(ix_1661)])}})))
@unsafe
def Erase.erase_fold(+ec_1663: Erase.Ectx, +ac_1664: Erase.Acc, +jobs_1665: ListOf(TupleOf2(OptionOf(Value), Term))) -> CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)):
  SeqList.fold(&2, &2, TupleOf2(OptionOf(Value), Term), CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), (+local14911 => +local14913 => ((+scrut14914 = local14913
  Match.Tuple2(&2, OptionOf(Value), &2, Term, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), scrut14914, +p14915 => +p14916 => ((do CheckResult<TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)>:
    +bound14918 : TupleOf2(ListOf(Eterm.Ktm), Erase.Acc) <- local14911
    Match.Tuple2(&2, ListOf(Eterm.Ktm), &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), bound14918, +p14919 => +p14920 => ((do CheckResult<TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)>:
      +bound14922 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_1663, p14920, False{}, p14915, p14916)
      Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), bound14922, +p14923 => +p14924 => (Done{Tup2{List.append(&2, Eterm.Ktm, p14919, Con{p14923, Nil{}}), p14924}}))))))))))), jobs_1665, Done{Tup2{Nil{}, ac_1664}})
@unsafe
def Erase.pair_intro(+ec_1828: Erase.Ectx, +ac_1829: Erase.Acc, +ty_1830: Value, +q_1831: Quantity, +x_1832: String, +dom_1833: Value, +d_1834: Value.Closure, +a_1835: Term.Addr, +args_1836: ListOf(Term)) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound14886 : Term <- (+local14944 => (Match.Maybe(&2, Term, &2, CheckResult(Term), local14944, _ => Fail{Error.Mismatch{"a pair takes a point address"}}, +x => Done{x})))((+local14934 => (Match.Maybe(&2, TupleOf2(Quantity, Term), &2, OptionOf(Term), local14934, _ => None{}, +item14941 => (Some{(+local14936 => ((+scrut14937 = local14936
    Match.Tuple2(&2, Quantity, &2, Term, &2, Term, scrut14937, +p14938 => +p14939 => (p14939)))))(item14941)}))))(Term.as_apt(a_1835)))
    +bound14888 : Term <- (+local14931 => (Match.Maybe(&2, Term, &2, CheckResult(Term), local14931, _ => Fail{Error.Mismatch{"a pair takes one fibre"}}, +x => Done{x})))(Rules.one_of(&2, Term, args_1836))
    +bound14890 : Bool <- Erase.point_runtime(ec_1828, q_1831, dom_1833)
    (Match.Result(&1, Tuple2<&1, &2, Erase.Ectx, Value>, &2, Error, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), Erase.under_point(ec_1828, x_1832, q_1831, dom_1833, d_1834), +item14926 => ((+local14893 => ((+scrut14894 = local14893
Match.Tuple2(&1, Erase.Ectx, &2, Value, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut14894, +p14895 => +p14896 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound14898 : Bool <- Erase.runtime_ty(p14895, p14896)
  +bound14900 : Value <- Eval.eval(Erase.globals_of(ec_1828), Erase.env_of(ec_1828), bound14886)
  +bound14902 : Value <- Rules.open_closure(Eval.ev(Erase.globals_of(ec_1828)), d_1834, Con{bound14900, Nil{}})
  ((+scrut14903 = {List.append(&2, TupleOf2(OptionOf(Value), Term), Native.choose(&2, ListOf(TupleOf2(OptionOf(Value), Term)), bound14890, _ => (Con{Tup2{Some{dom_1833}, bound14886}, Nil{}}), _ => (Nil{})), Native.choose(&2, ListOf(TupleOf2(OptionOf(Value), Term)), bound14898, _ => (Con{Tup2{Some{bound14902}, bound14888}, Nil{}}), _ => (Nil{}))) : ListOf(TupleOf2(OptionOf(Value), Term))}
(do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound14905 : TupleOf2(ListOf(Eterm.Ktm), Erase.Acc) <- Erase.erase_fold(ec_1828, ac_1829, scrut14903)
  Match.Tuple2(&2, ListOf(Eterm.Ktm), &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound14905, +p14906 => +p14907 => (Native.choose(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), List.is_empty(&2, Eterm.Ktm, p14906), _ => (Done{Tup2{Eterm.Ktm.KErased{}, p14907}}), _ => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound14909 : Eterm.Tid <- Erase.tid_of(ec_1828, ty_1830)
    Done{Tup2{Eterm.Ktm.KStruct{bound14909, p14906}, p14907}}))))))))))))))(item14926)), +item14927 => Fail{item14927})))
@unsafe
def Erase.tag_intro(+ec_1854: Erase.Ectx, +ac_1855: Erase.Acc, +ty_1856: Value, +n_1857: Big, +d_1858: Value.Closure, +a_1859: Term.Addr, +args_1860: ListOf(Term)) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound14947 : Big <- (+local14971 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local14971, _ => Fail{Error.Mismatch{"an injection takes a leg address"}}, +x => Done{x})))(Term.as_aleg(a_1859))
    +bound14949 : ListOf(Value) <- Erase.leg_types(ec_1854, n_1857, d_1858)
    +bound14951 : Value <- (+local14968 => (Match.Maybe(&2, Value, &2, CheckResult(Value), local14968, _ => Fail{Error.Mismatch{"the leg address is outside the collection"}}, +x => Done{x})))(Rules.at(&2, Value, bound14947, bound14949))
    +bound14953 : Bool <- Erase.runtime_ty(ec_1854, bound14951)
    ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound14955 : Term <- (+local14964 => (Match.Maybe(&2, Term, &2, CheckResult(Term), local14964, _ => Fail{Error.Mismatch{"an injection takes one payload"}}, +x => Done{x})))(Rules.one_of(&2, Term, args_1860))
  +bound14957 : TupleOf2(ListOf(Eterm.Ktm), Erase.Acc) <- Erase.erase_fold(ec_1854, ac_1855, Native.choose(&2, ListOf(TupleOf2(OptionOf(Value), Term)), bound14953, _ => (Con{Tup2{Some{bound14951}, bound14955}, Nil{}}), _ => (Nil{})))
  Match.Tuple2(&2, ListOf(Eterm.Ktm), &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound14957, +p14958 => +p14959 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound14961 : Eterm.Tid <- Erase.tid_of(ec_1854, ty_1856)
    Done{Tup2{Eterm.Ktm.KTag{bound14961, bound14947, p14958}, p14959}}))))))
@unsafe
def Erase.in_typed(+ec_1816: Erase.Ectx, +ac_1817: Erase.Acc, +ty_1818: Value, +a_1819: Term.Addr, +args_1820: ListOf(Term)) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound14877 : Value <- Eval.whnf(Erase.globals_of(ec_1816), ty_1818)
    ((+scrut14878 = {Erase.form_of(bound14877) : Erase.Form}
Match.Erase_Form(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut14878, _ => (Fail{Error.Mismatch{"an introduction stands at a type that is not a left former"}}), +p14879 => +p14880 => ((+scrut14881 = {Erase.point_of(p14879) : Erase.Point}
Match.Erase_Point(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut14881, +p14882 => +p14883 => +p14884 => (Erase.pair_intro(ec_1816, ac_1817, ty_1818, p14882, p14883, p14884, p14880, a_1819, args_1820)), +p14945 => (Erase.tag_intro(ec_1816, ac_1817, ty_1818, p14945, p14880, a_1819, args_1820)), _ => (Fail{Error.Mismatch{"an introduction at a shape past M0"}})))), +p14972 => +p14973 => (Fail{Error.Mismatch{"an introduction stands at a type that is not a left former"}}), _ => (Fail{Error.Mismatch{"an introduction stands at a type that is not a left former"}}), _ => (Fail{Error.Mismatch{"an introduction stands at a type that is not a left former"}})))))
@unsafe
def Erase.mu_fields(ec_1898, ac_1899, env_1900, tele_1901, args_1902, layout_1903):
  (+scrut15009 = {Tup3{tele_1901, args_1902, layout_1903} : TupleOf3(Positivity.Telescope, ListOf(Term), ListOf(OptionOf(Eterm.Repr)))}
  Match.Tuple3(&2, Positivity.Telescope, &2, ListOf(Term), &2, ListOf(OptionOf(Eterm.Repr)), &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), scrut15009, +p15010 => +p15011 => +p15012 => (Match.List(&2, TupleOf3(Quantity, String, Term), &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), p15010, _ => (Match.List(&2, Term, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), p15011, _ => (Match.List(&2, OptionOf(Eterm.Repr), &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), p15012, _ => (Done{Tup2{Nil{}, ac_1899}}), +p15013 => +p15014 => (Fail{Error.Mismatch{Erase.branch_arity_word()}}))), +p15015 => +p15016 => (Fail{Error.Mismatch{Erase.branch_arity_word()}}))), +p15017 => +p15018 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), p15017, +p15019 => +p15020 => +p15021 => (Match.List(&2, Term, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), p15011, _ => (Fail{Error.Mismatch{Erase.branch_arity_word()}}), +p15022 => +p15023 => (Match.List(&2, OptionOf(Eterm.Repr), &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), p15012, _ => (Fail{Error.Mismatch{Erase.branch_arity_word()}}), +p15024 => +p15025 => ((do CheckResult<TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)>:
    +bound15027 : Value <- Eval.eval(Erase.globals_of(ec_1898), env_1900, p15021)
    ((do CheckResult<TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)>:
  +bound15029 : TupleOf2(ListOf(Eterm.Ktm), Erase.Acc) <- Native.choose(&2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), Maybe.is_some(&2, Eterm.Repr, p15024), _ => ((do CheckResult<TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)>:
    +bound15039 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_1898, ac_1899, False{}, Some{bound15027}, p15022)
    Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), bound15039, +p15040 => +p15041 => (Done{Tup2{Con{p15040, Nil{}}, p15041}})))), _ => (Done{Tup2{Nil{}, ac_1899}}))
  Match.Tuple2(&2, ListOf(Eterm.Ktm), &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), bound15029, +p15030 => +p15031 => ((do CheckResult<TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)>:
    +bound15033 : Value <- Eval.eval(Erase.globals_of(ec_1898), Erase.env_of(ec_1898), p15022)
    +bound15035 : TupleOf2(ListOf(Eterm.Ktm), Erase.Acc) <- Erase.mu_fields(ec_1898, p15031, Con{bound15033, env_1900}, p15018, p15023, p15025)
    Match.Tuple2(&2, ListOf(Eterm.Ktm), &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Ktm), Erase.Acc)), bound15035, +p15036 => +p15037 => (Done{Tup2{List.append(&2, Eterm.Ktm, p15030, p15036), p15037}})))))))))))))))))))
@unsafe
def Erase.mu_tag(+ec_1881: Erase.Ectx, +ac_1882: Erase.Acc, +n_1883: String, +d_1884: Value.Closure, +a_1885: Term.Addr, +args_1886: ListOf(Term)) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound14990 : String <- (+local15053 => (Match.Maybe(&2, String, &2, CheckResult(String), local15053, _ => Fail{Error.Mismatch{"a constructor takes a constructor address"}}, +x => Done{x})))(Term.as_actor(a_1885))
    +bound14992 : Positivity.Family <- Rules.mu_family(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_1881), n_1883)
    +bound14994 : ListOf(String) <- Rules.mu_ctor_names(n_1883, bound14992)
    ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound14996 : Big <- (+local15049 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local15049, _ => Fail{Error.Unbound{String.append(bound14990, String.append(" is not a constructor of ", n_1883))}}, +x => Done{x})))(Erase.position(bound14990, bound14994))
  +bound14998 : Positivity.Ctor <- (+local15046 => (Match.Maybe(&2, Positivity.Ctor, &2, CheckResult(Positivity.Ctor), local15046, _ => Fail{Error.Unbound{String.append(bound14990, String.append(" is not a constructor of ", n_1883))}}, +x => Done{x})))(Positivity.ctor_of(bound14990, bound14992))
  +bound15000 : ListOf(Value) <- Rules.mu_param_env(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_1881), d_1884)
  ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15002 : ListOf(OptionOf(Eterm.Repr)) <- Erase.mu_layout(ec_1881, bound14992, bound14998)
  +bound15004 : TupleOf2(ListOf(Eterm.Ktm), Erase.Acc) <- Erase.mu_fields(ec_1881, ac_1882, bound15000, Get.Positivity.Ctor.c_args(bound14998), args_1886, bound15002)
  Match.Tuple2(&2, ListOf(Eterm.Ktm), &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15004, +p15005 => +p15006 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15008 : ListOf(Eterm.Tid) <- Erase.mu_group_tids(ec_1881, n_1883, bound14992)
    Done{Tup2{Eterm.Ktm.KTag{Erase.mu_tid(n_1883), bound14996, p15005}, MkErase_Acc{Get.Erase.Acc.next(p15006), Get.Erase.Acc.lifted(p15006), List.append(&2, Eterm.Tid, Get.Erase.Acc.groups(p15006), bound15008)}}}))))))))
@unsafe
def Erase.mu_intro(+ec_1870: Erase.Ectx, +ac_1871: Erase.Acc, +ty_1872: Value, +a_1873: Term.Addr, +args_1874: ListOf(Term)) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound14981 : Value <- Eval.whnf(Erase.globals_of(ec_1870), ty_1872)
    ((+scrut14982 = {Erase.form_of(bound14981) : Erase.Form}
Match.Erase_Form(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut14982, _ => (Fail{Error.Mismatch{"an introduction stands at a type that is not a left former"}}), +p14983 => +p14984 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound14986 : TupleOf2(String, ListOf(Value)) <- (+local15056 => (Match.Maybe(&2, TupleOf2(String, ListOf(Value)), &2, CheckResult(TupleOf2(String, ListOf(Value))), local15056, _ => Fail{Error.Mismatch{"an introduction at a shape past M0"}}, +x => Done{x})))(Rules.as_vmu(&2, Value, p14983))
  Match.Tuple2(&2, String, &2, ListOf(Value), &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound14986, +p14987 => +p14988 => (Erase.mu_tag(ec_1870, ac_1871, p14987, p14984, a_1873, args_1874))))), +p15057 => +p15058 => (Fail{Error.Mismatch{"an introduction stands at a type that is not a left former"}}), _ => (Fail{Error.Mismatch{"an introduction stands at a type that is not a left former"}}), _ => (Fail{Error.Mismatch{"an introduction stands at a type that is not a left former"}})))))
@unsafe
def Erase.in_arm(+ec_1810: Erase.Ectx, +ac_1811: Erase.Acc, +ty_1812: Value, +s_1813: Shape<&2, Term>, +a_1814: Term.Addr, +args_1815: ListOf(Term)) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (+scrut14872 = s_1813
  Match.Shape(&2, Term, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut14872, +p14873 => +p14874 => +p14875 => (Erase.in_typed(ec_1810, ac_1811, ty_1812, a_1814, args_1815)), +p14975 => (Erase.in_typed(ec_1810, ac_1811, ty_1812, a_1814, args_1815)), +p14976 => +p14977 => (Erase.refused(s_1813)), +p14978 => +p14979 => (Erase.mu_intro(ec_1810, ac_1811, ty_1812, a_1814, args_1815)), +p15060 => +p15061 => (Erase.refused(s_1813))))
@unsafe
def Erase.pair_elim(+ec_2106: Erase.Ectx, +ac_2107: Erase.Acc, +tail_2108: Bool, +ty_2109: Value, +sty_2110: Value, +e_2111: Term.Elim, +q_2112: Quantity, +x_2113: String, +dom_2114: Value, +d_2115: Value.Closure) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15079 : TupleOf2(Term.Addr, Term.Leg) <- (+local15127 => (Match.Maybe(&2, TupleOf2(Term.Addr, Term.Leg), &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), local15127, _ => Fail{Error.Mismatch{"a pair elimination takes one branch"}}, +x => Done{x})))(Rules.one_of(&2, TupleOf2(Term.Addr, Term.Leg), Get.Term.Elim.e_branches(e_2111)))
    Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15079, +p15080 => +p15081 => (((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15083 : TupleOf2(TupleOf2(Quantity, String), TupleOf2(Quantity, String)) <- (+local15123 => (Match.Maybe(&2, TupleOf2(TupleOf2(Quantity, String), TupleOf2(Quantity, String)), &2, CheckResult(TupleOf2(TupleOf2(Quantity, String), TupleOf2(Quantity, String))), local15123, _ => Fail{Error.Mismatch{"a pair branch takes two binders"}}, +x => Done{x})))(Rules.two_of(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(p15081)))
  Match.Tuple2(&2, TupleOf2(Quantity, String), &2, TupleOf2(Quantity, String), &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15083, +p15084 => +p15085 => ((+scrut15086 = p15084
  (+scrut15087 = p15085
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15089 : Bool <- Erase.point_runtime(ec_2106, q_2112, dom_2114)
    +bound15091 : Value <- Rules.open_closure(Eval.ev(Erase.globals_of(ec_2106)), d_2115, Con{Value.var(Erase.size_of(ec_2106)), Nil{}})
    ((+scrut15092 = {MkErase_Ectx{Check.bind(x_2113, q_2112, dom_2114, Get.Erase.Ectx.c(ec_2106)), Con{Native.choose(&2, Erase.Slot, bound15089, _ => (Erase.Slot.SKeep{}), _ => (Erase.Slot.SDrop{})), Con{Erase.Slot.SExtra{}, Get.Erase.Ectx.slots(ec_2106)}}, Get.Erase.Ectx.self(ec_2106)} : Erase.Ectx}
(do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15094 : Bool <- Erase.runtime_ty(scrut15092, bound15091)
  (+scrut15095 = {Get.Tuple2.v1(&2, Quantity, &2, String, p15085) : String}
  (+scrut15096 = {MkErase_Ectx{Check.bind(scrut15095, Quantity.Many{}, bound15091, Get.Erase.Ectx.c(scrut15092)), Con{Native.choose(&2, Erase.Slot, bound15094, _ => (Erase.Slot.SKeep{}), _ => (Erase.Slot.SDrop{})), Get.Erase.Ectx.slots(scrut15092)}, Get.Erase.Ectx.self(scrut15092)} : Erase.Ectx}
  ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15098 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_2106, ac_2107, False{}, Some{sty_2110}, Get.Term.Elim.e_scrut(e_2111))
  Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15098, +p15099 => +p15100 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15102 : Shape<&2, Value> <- Rules.map_shape(&2, Value, &2, Term, (+local15118 => (Eval.eval(Erase.globals_of(ec_2106), Erase.env_of(ec_2106), local15118))), Get.Term.Elim.e_shape(e_2111))
    (+scrut15103 = {Value.VIn{bound15102, Value.VaddrOf.VAPt{q_2112, Value.var(Erase.size_of(ec_2106))}, Con{Value.var(NativeInt.add(Erase.size_of(ec_2106), Big.one())), Nil{}}} : Value}
    (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
      +bound15105 : Value <- Rules.elim_result(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_2106), Get.Term.Elim.e_motive(e_2111), Some{ty_2109}, scrut15103)
      ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15107 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(scrut15096, p15100, tail_2108, Some{bound15105}, Get.Term.Leg.l_body(p15081))
  Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15107, +p15108 => +p15109 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15111 : Eterm.Tid <- Erase.tid_of(ec_2106, sty_2110)
    (+scrut15112 = {Native.choose(&2, Big, bound15089, _ => (Big.one()), _ => (Big.zero())) : Big}
    (+scrut15113 = {Native.choose(&2, Eterm.Ktm, bound15094, _ => (Eterm.Ktm.KLet{scrut15095, Eterm.Ktm.KProj{bound15111, scrut15112, Eterm.Ktm.KVar{scrut15112}}, p15108}), _ => (p15108)) : Eterm.Ktm}
    (+scrut15114 = {Native.choose(&2, Eterm.Ktm, bound15089, _ => (Eterm.Ktm.KLet{x_2113, Eterm.Ktm.KProj{bound15111, Big.zero(), Eterm.Ktm.KVar{Big.zero()}}, scrut15113}), _ => (scrut15113)) : Eterm.Ktm}
    Done{Tup2{Eterm.Ktm.KLet{Erase.scrut_name(), p15099, scrut15114}, p15109}}))))))))))))))))))))))))))))))
@unsafe
def Erase.branch_of(+ec_2165: Erase.Ectx, +ac_2166: Erase.Acc, +tail_2167: Bool, +ty_2168: Value, +tys_2169: ListOf(Value), +e_2170: Term.Elim, +k_2171: Big) -> CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
    +bound15154 : Value <- (+local15190 => (Match.Maybe(&2, Value, &2, CheckResult(Value), local15190, _ => Fail{Error.Mismatch{"a leg number is outside the collection"}}, +x => Done{x})))(Rules.at(&2, Value, k_2171, tys_2169))
    ((do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
  +bound15156 : TupleOf2(Term.Addr, Term.Leg) <- (+local15186 => (Match.Maybe(&2, TupleOf2(Term.Addr, Term.Leg), &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), local15186, _ => Fail{Error.Mismatch{"a case is missing a branch"}}, +x => Done{x})))(SeqList.find(&2, TupleOf2(Term.Addr, Term.Leg), (+local15178 => ((+scrut15179 = local15178
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, Bool, scrut15179, +p15180 => +p15181 => (Match.Maybe(&2, Big, &2, Bool, Term.as_aleg(p15180), _ => Bool.not(Maybe.is_some(&2, Big, Some{k_2171})), +x => Match.Maybe(&2, Big, &2, Bool, Some{k_2171}, _ => False{}, +y => (+arg15182 => +arg15183 => Big.is_eq(arg15182, arg15183))(x, y)))))))), Get.Term.Elim.e_branches(e_2170)))
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)), bound15156, +p15157 => +p15158 => ((do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
    +bound15160 : TupleOf2(Quantity, String) <- (+local15176 => (Match.Maybe(&2, TupleOf2(Quantity, String), &2, CheckResult(TupleOf2(Quantity, String)), local15176, _ => Fail{Error.Mismatch{"a case branch takes one binder"}}, +x => Done{x})))(Rules.one_of(&2, TupleOf2(Quantity, String), Get.Term.Leg.l_binders(p15158)))
    Match.Tuple2(&2, Quantity, &2, String, &2, CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)), bound15160, +p15161 => +p15162 => ((do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
      +bound15164 : Bool <- Erase.point_runtime(ec_2165, p15161, bound15154)
      ((+scrut15165 = {MkErase_Ectx{Check.bind(p15162, p15161, bound15154, Get.Erase.Ectx.c(ec_2165)), Con{Native.choose(&2, Erase.Slot, bound15164, _ => (Erase.Slot.SKeep{}), _ => (Erase.Slot.SDrop{})), Get.Erase.Ectx.slots(ec_2165)}, Get.Erase.Ectx.self(ec_2165)} : Erase.Ectx}
(+scrut15166 = {Value.VIn{Shape.SColl{Big.of_nat(List.length(&2, Value, tys_2169))}, Value.VaddrOf.VALeg{k_2171}, Con{Value.var(Erase.size_of(ec_2165)), Nil{}}} : Value}
(do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
  +bound15168 : Value <- Rules.elim_result(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_2165), Get.Term.Elim.e_motive(e_2170), Some{ty_2168}, scrut15166)
  +bound15170 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(scrut15165, ac_2166, tail_2167, Some{bound15168}, Get.Term.Leg.l_body(p15158))
  Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)), bound15170, +p15171 => +p15172 => (Done{Tup2{MkEterm_KbranchOf{k_2171, Native.choose(&2, Big, bound15164, _ => (Big.one()), _ => (Big.zero())), p15171}, p15172}})))))))))))))))
@unsafe
def Erase.case_elim(+ec_2141: Erase.Ectx, +ac_2142: Erase.Acc, +tail_2143: Bool, +ty_2144: Value, +sty_2145: Value, +e_2146: Term.Elim, +n_2147: Big, +d_2148: Value.Closure) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15130 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_2141, ac_2142, False{}, Some{sty_2145}, Get.Term.Elim.e_scrut(e_2146))
    Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15130, +p15131 => +p15132 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
      +bound15134 : ListOf(Value) <- Erase.leg_types(ec_2141, n_2147, d_2148)
      ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15136 : TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc) <- SeqList.fold(&2, &2, Big, CheckResult(TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)), (+local15142 => +local15144 => ((do CheckResult<TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)>:
    +bound15146 : TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc) <- local15142
    Match.Tuple2(&2, ListOf(Eterm.Kbranch), &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)), bound15146, +p15147 => +p15148 => ((do CheckResult<TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)>:
      +bound15150 : TupleOf2(Eterm.Kbranch, Erase.Acc) <- Erase.branch_of(ec_2141, p15148, tail_2143, ty_2144, bound15134, e_2146, local15144)
      Match.Tuple2(&2, Eterm.Kbranch, &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)), bound15150, +p15151 => +p15152 => (Done{Tup2{List.append(&2, Eterm.Kbranch, p15147, Con{p15151, Nil{}}), p15152}})))))))), SeqList.init(&2, Big, n_2147, (+local15193 => (local15193))), Done{Tup2{Nil{}, p15132}})
  Match.Tuple2(&2, ListOf(Eterm.Kbranch), &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15136, +p15137 => +p15138 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15140 : Eterm.Tid <- Erase.tid_of(ec_2141, sty_2145)
    Done{Tup2{Eterm.Ktm.KCase{bound15140, p15131, p15137}, p15138}})))))))))
@unsafe
def Erase.elim_typed(+ec_2093: Erase.Ectx, +ac_2094: Erase.Acc, +tail_2095: Bool, +ty_2096: Value, +e_2097: Term.Elim) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15068 : Value <- Check.infer(Get.Erase.Ectx.c(ec_2093), Quantity.Many{}, Get.Term.Elim.e_scrut(e_2097))
    +bound15070 : Value <- Eval.whnf(Erase.globals_of(ec_2093), bound15068)
    ((+scrut15071 = {Erase.form_of(bound15070) : Erase.Form}
Match.Erase_Form(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15071, _ => (Fail{Error.Mismatch{"an elimination stands on a value that is not a left former"}}), +p15072 => +p15073 => ((+scrut15074 = {Erase.point_of(p15072) : Erase.Point}
Match.Erase_Point(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15074, +p15075 => +p15076 => +p15077 => (Erase.pair_elim(ec_2093, ac_2094, tail_2095, ty_2096, bound15068, e_2097, p15075, p15076, p15077, p15073)), +p15128 => (Erase.case_elim(ec_2093, ac_2094, tail_2095, ty_2096, bound15068, e_2097, p15128, p15073)), _ => (Fail{Error.Mismatch{"an elimination at a shape past M0"}})))), +p15195 => +p15196 => (Fail{Error.Mismatch{"an elimination stands on a value that is not a left former"}}), _ => (Fail{Error.Mismatch{"an elimination stands on a value that is not a left former"}}), _ => (Fail{Error.Mismatch{"an elimination stands on a value that is not a left former"}})))))
@unsafe
def Erase.mu_binders(ec_1995, st_1996, tele_1997, binders_1998, layout_1999):
  (+scrut15256 = st_1996
  Match.Tuple3(&2, ListOf(Value), &2, ListOf(Value), &2, Big, &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, scrut15256, +p15257 => +p15258 => +p15259 => (((+scrut15260 = {Tup3{tele_1997, binders_1998, layout_1999} : TupleOf3(Positivity.Telescope, ListOf(TupleOf2(Quantity, String)), ListOf(OptionOf(Eterm.Repr)))}
Match.Tuple3(&2, Positivity.Telescope, &2, ListOf(TupleOf2(Quantity, String)), &2, ListOf(OptionOf(Eterm.Repr)), &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, scrut15260, +p15261 => +p15262 => +p15263 => (Match.List(&2, TupleOf3(Quantity, String, Term), &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, p15261, _ => (Match.List(&2, TupleOf2(Quantity, String), &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, p15262, _ => (Match.List(&2, OptionOf(Eterm.Repr), &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, p15263, _ => (Done{Tup4{ec_1995, p15257, p15258, p15259}}), +p15264 => +p15265 => (Fail{Error.Missing_branch{Erase.branch_arity_word()}}))), +p15266 => +p15267 => (Fail{Error.Missing_branch{Erase.branch_arity_word()}}))), +p15268 => +p15269 => (Match.Tuple3(&2, Quantity, &2, String, &2, Term, &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, p15268, +p15270 => +p15271 => +p15272 => (Match.List(&2, TupleOf2(Quantity, String), &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, p15262, _ => (Fail{Error.Missing_branch{Erase.branch_arity_word()}}), +p15273 => +p15274 => (Match.Tuple2(&2, Quantity, &2, String, &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, p15273, +p15275 => +p15276 => (Match.List(&2, OptionOf(Eterm.Repr), &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, p15263, _ => (Fail{Error.Missing_branch{Erase.branch_arity_word()}}), +p15277 => +p15278 => ((Match.Result(&2, Value, &2, Error, &1, Result<&2, &1, Error, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>>, Eval.eval(Erase.globals_of(ec_1995), p15257, p15272), +item15285 => ((+local15281 => ((+scrut15282 = {Maybe.is_some(&2, Eterm.Repr, p15277) : Bool}
(+scrut15283 = {Value.var(Erase.size_of(ec_1995)) : Value}
(+scrut15284 = {MkErase_Ectx{Check.bind(p15276, p15270, local15281, Get.Erase.Ectx.c(ec_1995)), Con{Native.choose(&2, Erase.Slot, scrut15282, _ => (Erase.Slot.SKeep{}), _ => (Erase.Slot.SDrop{})), Get.Erase.Ectx.slots(ec_1995)}, Get.Erase.Ectx.self(ec_1995)} : Erase.Ectx}
Erase.mu_binders(scrut15284, Tup3{Con{scrut15283, p15257}, Con{scrut15283, p15258}, Native.choose(&2, Big, scrut15282, _ => (NativeInt.add(p15259, Big.one())), _ => (p15259))}, p15269, p15274, p15278))))))(item15285)), +item15286 => Fail{item15286})))))))))))))))))))
@unsafe
def Erase.mu_branch_of(+ec_1965: Erase.Ectx, +ac_1966: Erase.Acc, +tail_1967: Bool, +n_1968: String, +fam_1969: Positivity.Family, +mo_1970: Term.Motive, +penv_1971: ListOf(Value), +branches_1972: ListOf(TupleOf2(Term.Addr, Term.Leg)), +k_1973: Big, +c_1974: String) -> CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
    +bound15248 : Positivity.Ctor <- (+local15324 => (Match.Maybe(&2, Positivity.Ctor, &2, CheckResult(Positivity.Ctor), local15324, _ => Fail{Error.Unbound{String.append(c_1974, String.append(" is not a constructor of ", n_1968))}}, +x => Done{x})))(Positivity.ctor_of(c_1974, fam_1969))
    ((do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
  +bound15250 : TupleOf2(Term.Addr, Term.Leg) <- (+local15320 => (Match.Maybe(&2, TupleOf2(Term.Addr, Term.Leg), &2, CheckResult(TupleOf2(Term.Addr, Term.Leg)), local15320, _ => Fail{Error.Missing_branch{String.concat(["the elimination of ", n_1968, " has no branch at ", c_1974])}}, +x => Done{x})))(SeqList.find(&2, TupleOf2(Term.Addr, Term.Leg), (+local15312 => ((+scrut15313 = local15312
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, Bool, scrut15313, +p15314 => +p15315 => (Match.Maybe(&2, String, &2, Bool, Term.as_actor(p15314), _ => Bool.not(Maybe.is_some(&2, String, Some{c_1974})), +x => Match.Maybe(&2, String, &2, Bool, Some{c_1974}, _ => False{}, +y => (+arg15316 => +arg15317 => NativeString.equal(arg15316, arg15317))(x, y)))))))), branches_1972))
  Match.Tuple2(&2, Term.Addr, &2, Term.Leg, &2, CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)), bound15250, +p15251 => +p15252 => (((do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
  +bound15254 : ListOf(OptionOf(Eterm.Repr)) <- Erase.mu_layout(ec_1965, fam_1969, bound15248)
  Match.Result(&1, Tuple4<&1, &2, &2, &2, Erase.Ectx, ListOf(Value), ListOf(Value), Big>, &2, Error, &2, CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)), Erase.mu_binders(ec_1965, Tup3{penv_1971, Nil{}, Big.zero()}, Get.Positivity.Ctor.c_args(bound15248), Get.Term.Leg.l_binders(p15252), bound15254), +item15308 => ((+local15290 => ((+scrut15291 = local15290
  Match.Tuple4(&1, Erase.Ectx, &2, ListOf(Value), &2, ListOf(Value), &2, Big, &2, CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)), scrut15291, +p15292 => +p15293 => +p15294 => +p15295 => (((do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
  +bound15297 : ListOf(Value) <- Rules.all_ok(&2, Value, SeqList.map(&2, &2, Term, CheckResult(Value), (+local15306 => (Eval.eval(Erase.globals_of(ec_1965), p15293, local15306))), Get.Positivity.Ctor.c_res_idx(bound15248)))
  (+scrut15298 = {Value.VIn{Shape.SMu{n_1968, bound15297}, Value.VaddrOf.VACtor{c_1974}, List.reverse(&2, Value, p15294)} : Value}
  (do CheckResult<TupleOf2(Eterm.Kbranch, Erase.Acc)>:
    +bound15300 : Value <- Rules.mu_result(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_1965), mo_1970, bound15297, scrut15298)
    +bound15302 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(p15292, ac_1966, tail_1967, Some{bound15300}, Get.Term.Leg.l_body(p15252))
    Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Kbranch, Erase.Acc)), bound15302, +p15303 => +p15304 => (Done{Tup2{MkEterm_KbranchOf{k_1973, p15295, p15303}, p15304}})))))))))))(item15308)), +item15309 => Fail{item15309}))))))))
@unsafe
def Erase.mu_case(+ec_1934: Erase.Ectx, +ac_1935: Erase.Acc, +tail_1936: Bool, +sty_1937: Value, +e_1938: Term.Elim, +n_1939: String, +ixv_1940: ListOf(Value), +d_1941: Value.Closure) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15215 : Positivity.Family <- Rules.mu_family(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_1934), n_1939)
    +bound15217 : Term.Motive <- Rules.mu_motive_of(n_1939, bound15215, ixv_1940, e_1938)
    +bound15219 : ListOf(String) <- Rules.mu_ctor_names(n_1939, bound15215)
    +bound15221 : ListOf(Value) <- Rules.mu_param_env(&1, Check.Ctx, Check.ops(), Get.Erase.Ectx.c(ec_1934), d_1941)
    +bound15223 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_1934, ac_1935, False{}, Some{sty_1937}, Get.Term.Elim.e_scrut(e_1938))
    Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15223, +p15224 => +p15225 => (((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15227 : TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc) <- SeqList.fold(&2, &2, TupleOf2(Big, String), CheckResult(TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)), (+local15233 => +local15235 => ((+scrut15236 = local15235
  Match.Tuple2(&2, Big, &2, String, &2, CheckResult(TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)), scrut15236, +p15237 => +p15238 => ((do CheckResult<TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)>:
    +bound15240 : TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc) <- local15233
    Match.Tuple2(&2, ListOf(Eterm.Kbranch), &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)), bound15240, +p15241 => +p15242 => ((do CheckResult<TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)>:
      +bound15244 : TupleOf2(Eterm.Kbranch, Erase.Acc) <- Erase.mu_branch_of(ec_1934, p15242, tail_1936, n_1939, bound15215, bound15217, bound15221, Get.Term.Elim.e_branches(e_1938), p15237, p15238)
      Match.Tuple2(&2, Eterm.Kbranch, &2, Erase.Acc, &2, CheckResult(TupleOf2(ListOf(Eterm.Kbranch), Erase.Acc)), bound15244, +p15245 => +p15246 => (Done{Tup2{List.append(&2, Eterm.Kbranch, p15241, Con{p15245, Nil{}}), p15246}}))))))))))), SeqList.mapi(&2, &2, String, TupleOf2(Big, String), (+local15326 => +local15328 => (Tup2{local15326, local15328})), bound15219), Done{Tup2{Nil{}, p15225}})
  Match.Tuple2(&2, ListOf(Eterm.Kbranch), &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15227, +p15228 => +p15229 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15231 : ListOf(Eterm.Tid) <- Erase.mu_group_tids(ec_1934, n_1939, bound15215)
    Done{Tup2{Eterm.Ktm.KCase{Erase.mu_tid(n_1939), p15224, p15228}, MkErase_Acc{Get.Erase.Acc.next(p15229), Get.Erase.Acc.lifted(p15229), List.append(&2, Eterm.Tid, Get.Erase.Acc.groups(p15229), bound15231)}}}))))))))
@unsafe
def Erase.mu_elim(+ec_1923: Erase.Ectx, +ac_1924: Erase.Acc, +tail_1925: Bool, +e_1926: Term.Elim) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15204 : Value <- Check.infer(Get.Erase.Ectx.c(ec_1923), Quantity.Many{}, Get.Term.Elim.e_scrut(e_1926))
    +bound15206 : Value <- Eval.whnf(Erase.globals_of(ec_1923), bound15204)
    ((+scrut15207 = {Erase.form_of(bound15206) : Erase.Form}
Match.Erase_Form(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15207, _ => (Fail{Error.Mismatch{"an elimination stands on a value that is not a left former"}}), +p15208 => +p15209 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15211 : TupleOf2(String, ListOf(Value)) <- (+local15332 => (Match.Maybe(&2, TupleOf2(String, ListOf(Value)), &2, CheckResult(TupleOf2(String, ListOf(Value))), local15332, _ => Fail{Error.Mismatch{"an elimination at a shape past M0"}}, +x => Done{x})))(Rules.as_vmu(&2, Value, p15208))
  Match.Tuple2(&2, String, &2, ListOf(Value), &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15211, +p15212 => +p15213 => (Erase.mu_case(ec_1923, ac_1924, tail_1925, bound15204, e_1926, p15212, p15213, p15209))))), +p15333 => +p15334 => (Fail{Error.Mismatch{"an elimination stands on a value that is not a left former"}}), _ => (Fail{Error.Mismatch{"an elimination stands on a value that is not a left former"}}), _ => (Fail{Error.Mismatch{"an elimination stands on a value that is not a left former"}})))))
@unsafe
def Erase.elim_arm(+ec_2088: Erase.Ectx, +ac_2089: Erase.Acc, +tail_2090: Bool, +ty_2091: Value, +e_2092: Term.Elim) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (+scrut15063 = {Get.Term.Elim.e_shape(e_2092) : Shape<&2, Term>}
  Match.Shape(&2, Term, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15063, +p15064 => +p15065 => +p15066 => (Erase.elim_typed(ec_2088, ac_2089, tail_2090, ty_2091, e_2092)), +p15198 => (Erase.elim_typed(ec_2088, ac_2089, tail_2090, ty_2091, e_2092)), +p15199 => +p15200 => (Erase.refused(Get.Term.Elim.e_shape(e_2092))), +p15201 => +p15202 => (Erase.mu_elim(ec_2088, ac_2089, tail_2090, e_2092)), +p15336 => +p15337 => (Erase.refused(Get.Term.Elim.e_shape(e_2092)))))
@unsafe
def Erase.frame(+slots_1731: ListOf(Erase.Slot), +caps_1732: ListOf(Big)) -> ListOf(Erase.Slot):
  SeqList.mapi(&2, &2, Erase.Slot, Erase.Slot, (+local15354 => +local15356 => ((+scrut15357 = local15356
  Match.Erase_Slot(&2, Erase.Slot, scrut15357, _ => (Erase.Slot.SDrop{}), _ => (Native.choose(&2, Erase.Slot, SeqList.exists(&2, Big, (+local15360 => (Big.is_eq(local15354, local15360))), caps_1732), _ => (Erase.Slot.SKeep{}), _ => (Erase.Slot.SDrop{}))), _ => (Erase.Slot.SDrop{}))))), SeqList.filter(&2, Erase.Slot, (+local15362 => ((+scrut15363 = local15362
  Match.Erase_Slot(&2, Bool, scrut15363, _ => (True{}), _ => (True{}), _ => (False{}))))), slots_1731))
@unsafe
def Erase.as_lam(+t_1676: Term) -> OptionOf(Term.Leg):
  (+scrut15388 = t_1676
  Match.Term(&2, OptionOf(Term.Leg), scrut15388, +p15389 => (None{}), +p15390 => (None{}), +p15391 => +p15392 => (None{}), +p15393 => +p15394 => (None{}), +p15395 => +p15396 => +p15397 => (None{}), +p15398 => (None{}), +p15399 => +p15400 => (Match.Shape(&2, Term, &2, OptionOf(Term.Leg), p15399, +p15401 => +p15402 => +p15403 => (Match.List(&2, Term.Leg, &2, OptionOf(Term.Leg), p15400, _ => (None{}), +p15404 => +p15405 => (Match.List(&2, Term.Leg, &2, OptionOf(Term.Leg), p15405, _ => (Some{p15404}), +p15406 => +p15407 => (None{}))))), +p15408 => (None{}), +p15409 => +p15410 => (None{}), +p15411 => +p15412 => (None{}), +p15413 => +p15414 => (None{}))), +p15415 => +p15416 => +p15417 => (None{}), +p15418 => +p15419 => +p15420 => +p15421 => (None{}), +p15422 => +p15423 => (None{}), +p15424 => (None{}), +p15425 => (None{}), _ => (None{})))
@unsafe
def Erase.remaining_signature(ec_1775, s_1776, d_1777):
  (+scrut15450 = {Erase.point_of(s_1776) : Erase.Point}
  Match.Erase_Point(&2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), scrut15450, +p15451 => +p15452 => +p15453 => ((do CheckResult<TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)>:
    +bound15455 : Bool <- Erase.point_runtime(ec_1775, p15451, p15453)
    ((do CheckResult<TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)>:
  +bound15457 : ListOf(Eterm.Repr) <- Native.choose(&2, CheckResult(ListOf(Eterm.Repr)), bound15455, _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(ListOf(Eterm.Repr)), Erase.repr_of(ec_1775, p15453), +item15496 => (Done{(+local15495 => (Con{local15495, Nil{}}))(item15496)}), +item15497 => Fail{item15497})), _ => (Done{Nil{}}))
  Match.Result(&1, Tuple2<&1, &2, Erase.Ectx, Value>, &2, Error, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), Erase.under_point(ec_1775, p15452, p15451, p15453, d_1777), +item15492 => ((+local15460 => ((+scrut15461 = local15460
  Match.Tuple2(&1, Erase.Ectx, &2, Value, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), scrut15461, +p15462 => +p15463 => ((do CheckResult<TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)>:
    +bound15465 : Value <- Eval.whnf(Erase.globals_of(p15462), p15463)
    ((do CheckResult<TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)>:
  +bound15467 : TupleOf2(ListOf(Eterm.Repr), Eterm.Repr) <- (+scrut15470 = {Erase.form_of(bound15465) : Erase.Form}
  Match.Erase_Form(&2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), scrut15470, _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), Erase.repr_of(p15462, p15463), +item15473 => (Done{(+local15472 => (Tup2{Nil{}, local15472}))(item15473)}), +item15474 => Fail{item15474})), +p15475 => +p15476 => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), Erase.repr_of(p15462, p15463), +item15479 => (Done{(+local15478 => (Tup2{Nil{}, local15478}))(item15479)}), +item15480 => Fail{item15480})), +p15481 => +p15482 => (Erase.remaining_signature(p15462, p15481, p15482)), _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), Erase.repr_of(p15462, p15463), +item15485 => (Done{(+local15484 => (Tup2{Nil{}, local15484}))(item15485)}), +item15486 => Fail{item15486})), _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), Erase.repr_of(p15462, p15463), +item15489 => (Done{(+local15488 => (Tup2{Nil{}, local15488}))(item15489)}), +item15490 => Fail{item15490}))))
  Match.Tuple2(&2, ListOf(Eterm.Repr), &2, Eterm.Repr, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), bound15467, +p15468 => +p15469 => (Done{Tup2{List.append(&2, Eterm.Repr, bound15457, p15468), p15469}}))))))))))(item15492)), +item15493 => Fail{item15493}))))), +p15499 => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), Erase.ran_repr(ec_1775, s_1776, d_1777), +item15502 => (Done{(+local15501 => (Tup2{Nil{}, local15501}))(item15502)}), +item15503 => Fail{item15503})), _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(TupleOf2(ListOf(Eterm.Repr), Eterm.Repr)), Erase.ran_repr(ec_1775, s_1776, d_1777), +item15506 => (Done{(+local15505 => (Tup2{Nil{}, local15505}))(item15506)}), +item15507 => Fail{item15507}))))
@unsafe
def Erase.eta_chain(+ec_1758: Erase.Ectx, +ac_1759: Erase.Acc, +params_1760: ListOf(Eterm.Repr), +ty_1761: Value, +t_1762: Term, +s_1763: Shape<&2, Value>, +d_1764: Value.Closure) -> CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)>:
    +bound15438 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_1758, ac_1759, False{}, Some{ty_1761}, t_1762)
    Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), bound15438, +p15439 => +p15440 => (((do CheckResult<TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)>:
  +bound15442 : TupleOf2(ListOf(Eterm.Repr), Eterm.Repr) <- Erase.remaining_signature(ec_1758, s_1763, d_1764)
  Match.Tuple2(&2, ListOf(Eterm.Repr), &2, Eterm.Repr, &2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), bound15442, +p15443 => +p15444 => ((+scrut15445 = {Big.of_nat(List.length(&2, Eterm.Repr, p15443)) : Big}
  (+scrut15448 = {SeqList.init(&2, Eterm.Ktm, scrut15445, (+local15447 => (Eterm.Ktm.KVar{NativeInt.sub(NativeInt.sub(scrut15445, local15447), Big.one())}))) : ListOf(Eterm.Ktm)}
  (+scrut15449 = {Eterm.Ktm.KTail{Erase.shift_runtime(scrut15445, Big.zero(), p15439), scrut15448} : Eterm.Ktm}
  Done{Tup4{List.append(&2, Eterm.Repr, params_1760, p15443), p15444, scrut15449, p15440}}))))))))))
@unsafe
def Erase.chain_step(+ec_1795: Erase.Ectx, +ac_1796: Erase.Acc, +params_1797: ListOf(Eterm.Repr), +stop_1798: Reusable(Unit, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc))), +lg_1799: Term.Leg, +s_1800: Shape<&2, Value>, +d_1801: Value.Closure) -> CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)):
  (+scrut15515 = {Erase.point_of(s_1800) : Erase.Point}
  Match.Erase_Point(&2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), scrut15515, +p15516 => +p15517 => +p15518 => ((do CheckResult<TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)>:
    +bound15520 : Bool <- Erase.point_runtime(ec_1795, p15516, p15518)
    ((do CheckResult<TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)>:
  +bound15522 : ListOf(Eterm.Repr) <- Native.choose(&2, CheckResult(ListOf(Eterm.Repr)), bound15520, _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(ListOf(Eterm.Repr)), Erase.repr_of(ec_1795, p15518), +item15528 => (Done{(+local15527 => (List.append(&2, Eterm.Repr, params_1797, Con{local15527, Nil{}})))(item15528)}), +item15529 => Fail{item15529})), _ => (Done{params_1797}))
  +bound15524 : Value <- Rules.open_closure(Eval.ev(Erase.globals_of(ec_1795)), d_1801, Con{Value.var(Erase.size_of(ec_1795)), Nil{}})
  (+scrut15525 = {MkErase_Ectx{Check.bind(p15517, p15516, p15518, Get.Erase.Ectx.c(ec_1795)), Con{Native.choose(&2, Erase.Slot, bound15520, _ => (Erase.Slot.SKeep{}), _ => (Erase.Slot.SDrop{})), Get.Erase.Ectx.slots(ec_1795)}, Get.Erase.Ectx.self(ec_1795)} : Erase.Ectx}
  Erase.chain(scrut15525, ac_1796, bound15522, bound15524, Get.Term.Leg.l_body(lg_1799))))))), +p15531 => (stop_1798(Unit{})), _ => (stop_1798(Unit{}))))
@unsafe
def Erase.chain(ec_1736, ac_1737, params_1738, ty_1739, t_1740):
  (do CheckResult<TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)>:
    +bound15377 : Value <- Eval.whnf(Erase.globals_of(ec_1736), ty_1739)
    (+scrut15387 = {(+local15379 => ((+scrut15380 = local15379
    (do CheckResult<TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)>:
      +bound15382 : Eterm.Repr <- Erase.repr_of(ec_1736, ty_1739)
      +bound15384 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_1736, ac_1737, True{}, Some{ty_1739}, t_1740)
      Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), bound15384, +p15385 => +p15386 => (Done{Tup4{params_1738, bound15382, p15385, p15386}})))))) : Reusable(Unit, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)))}
    ((+scrut15426 = {Tup2{Erase.as_lam(t_1740), Erase.form_of(bound15377)} : TupleOf2(OptionOf(Term.Leg), Erase.Form)}
Match.Tuple2(&2, OptionOf(Term.Leg), &2, Erase.Form, &2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), scrut15426, +p15427 => +p15428 => (Match.Maybe(&2, Term.Leg, &2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), p15427, _ => (Match.Erase_Form(&2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), p15428, _ => (scrut15387(Unit{})), +p15429 => +p15430 => (scrut15387(Unit{})), +p15431 => +p15432 => ((+scrut15433 = {Erase.point_of(p15431) : Erase.Point}
Match.Erase_Point(&2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), scrut15433, +p15434 => +p15435 => +p15436 => (Erase.eta_chain(ec_1736, ac_1737, params_1738, ty_1739, t_1740, p15431, p15432)), +p15509 => (scrut15387(Unit{})), _ => (scrut15387(Unit{}))))), _ => (scrut15387(Unit{})), _ => (scrut15387(Unit{})))), +p15510 => (Match.Erase_Form(&2, CheckResult(TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc)), p15428, _ => (scrut15387(Unit{})), +p15511 => +p15512 => (scrut15387(Unit{})), +p15513 => +p15514 => (Erase.chain_step(ec_1736, ac_1737, params_1738, scrut15387, p15510, p15513, p15514)), _ => (scrut15387(Unit{})), _ => (scrut15387(Unit{})))))))))))
@unsafe
def Erase.lift_arm(+ec_1705: Erase.Ectx, +ac_1706: Erase.Acc, +ty_1707: Value, +t_1708: Term) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (+scrut15344 = {Erase.captures_of(ec_1705, t_1708) : ListOf(Big)}
  (+scrut15345 = {List.reverse(&2, Big, scrut15344) : ListOf(Big)}
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15347 : ListOf(Value) <- Rules.all_ok(&2, Value, SeqList.map(&2, &2, Big, CheckResult(Value), (+local15547 => (Check.infer(Get.Erase.Ectx.c(ec_1705), Quantity.Many{}, Term.Var{local15547}))), scrut15345))
    +bound15349 : ListOf(Eterm.Repr) <- Rules.all_ok(&2, Eterm.Repr, SeqList.map(&2, &2, Value, CheckResult(Eterm.Repr), (+local15545 => (Erase.repr_of(ec_1705, local15545))), bound15347))
    ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15351 : ListOf(Eterm.Ktm) <- Rules.all_ok(&2, Eterm.Ktm, SeqList.map(&2, &2, Big, CheckResult(Eterm.Ktm), (+local15535 => (Match.Result(&2, TupleOf2(Eterm.Ktm, Erase.Acc), &2, Error, &2, CheckResult(Eterm.Ktm), Erase.var_arm(ec_1705, ac_1706, local15535), +item15541 => (Done{(+local15537 => ((+scrut15538 = local15537
  Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, Eterm.Ktm, scrut15538, +p15539 => +p15540 => (p15539)))))(item15541)}), +item15542 => Fail{item15542}))), scrut15345))
  (+scrut15352 = {Eterm.Fid.Fid{String.concat([Get.Erase.Ectx.self(ec_1705), "$", Big.show(Get.Erase.Acc.next(ac_1706))])} : Eterm.Fid}
  (+scrut15364 = {MkErase_Ectx{Get.Erase.Ectx.c(ec_1705), Erase.frame(Get.Erase.Ectx.slots(ec_1705), scrut15344), Get.Erase.Ectx.self(ec_1705)} : Erase.Ectx}
  ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15366 : TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc) <- Erase.chain(scrut15364, MkErase_Acc{NativeInt.add(Get.Erase.Acc.next(ac_1706), Big.one()), Get.Erase.Acc.lifted(ac_1706), Get.Erase.Acc.groups(ac_1706)}, Nil{}, ty_1707, t_1708)
  Match.Tuple4(&2, ListOf(Eterm.Repr), &2, Eterm.Repr, &2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15366, +p15367 => +p15368 => +p15369 => +p15370 => ((+scrut15371 = {Erase.prune_captures(bound15349, bound15351, Big.of_nat(List.length(&2, Eterm.Repr, p15367)), p15369) : TupleOf3(ListOf(Eterm.Repr), ListOf(Eterm.Ktm), Eterm.Ktm)}
  Match.Tuple3(&2, ListOf(Eterm.Repr), &2, ListOf(Eterm.Ktm), &2, Eterm.Ktm, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15371, +p15372 => +p15373 => +p15374 => ((+scrut15375 = {Eterm.Kdecl.KFun{scrut15352, List.append(&2, Eterm.Repr, p15372, p15367), p15368, p15374} : Eterm.Kdecl}
  Done{Tup2{Eterm.Ktm.KClos{scrut15352, Big.of_nat(List.length(&2, Eterm.Repr, p15367)), p15373}, MkErase_Acc{Get.Erase.Acc.next(p15370), List.append(&2, Eterm.Kdecl, Get.Erase.Acc.lifted(p15370), Con{scrut15375, Nil{}}), Get.Erase.Acc.groups(p15370)}}})))))))))))))))
@unsafe
def Erase.tuple_arm(+ec_1685: Erase.Ectx, +ac_1686: Erase.Acc, +ty_1687: Value, +n_1688: Big, +legs_1689: ListOf(Term.Leg)) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15550 : Value <- Eval.whnf(Erase.globals_of(ec_1685), ty_1687)
    ((+scrut15551 = {Erase.form_of(bound15550) : Erase.Form}
Match.Erase_Form(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15551, _ => (Fail{Error.Mismatch{"a tuple stands at a type that is not a right former"}}), +p15552 => +p15553 => (Fail{Error.Mismatch{"a tuple stands at a type that is not a right former"}}), +p15554 => +p15555 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15557 : ListOf(Value) <- Erase.leg_types(ec_1685, n_1688, p15555)
  +bound15559 : ListOf(Bool) <- Rules.all_ok(&2, Bool, SeqList.map(&2, &2, Value, CheckResult(Bool), (+local15576 => (Erase.runtime_ty(ec_1685, local15576))), bound15557))
  ((+scrut15567 = {SeqList.filter_map(&2, &2, TupleOf2(TupleOf2(Term.Leg, Value), Bool), TupleOf2(OptionOf(Value), Term), (+local15561 => ((+scrut15562 = local15561
Match.Tuple2(&2, TupleOf2(Term.Leg, Value), &2, Bool, &2, OptionOf(TupleOf2(OptionOf(Value), Term)), scrut15562, +p15563 => +p15564 => (Match.Tuple2(&2, Term.Leg, &2, Value, &2, OptionOf(TupleOf2(OptionOf(Value), Term)), p15563, +p15565 => +p15566 => (Native.choose(&2, OptionOf(TupleOf2(OptionOf(Value), Term)), p15564, _ => (Some{Tup2{Some{p15566}, Get.Term.Leg.l_body(p15565)}}), _ => (None{}))))))))), Erase.zip(&2, TupleOf2(Term.Leg, Value), &2, Bool, Erase.zip(&2, Term.Leg, &2, Value, legs_1689, bound15557), bound15559)) : ListOf(TupleOf2(OptionOf(Value), Term))}
(do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15569 : TupleOf2(ListOf(Eterm.Ktm), Erase.Acc) <- Erase.erase_fold(ec_1685, ac_1686, scrut15567)
  Match.Tuple2(&2, ListOf(Eterm.Ktm), &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15569, +p15570 => +p15571 => (Native.choose(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), List.is_empty(&2, Eterm.Ktm, p15570), _ => (Done{Tup2{Eterm.Ktm.KErased{}, p15571}}), _ => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15573 : Eterm.Tid <- Erase.tid_of(ec_1685, ty_1687)
    Done{Tup2{Eterm.Ktm.KStruct{bound15573, p15570}, p15571}})))))))))), _ => (Fail{Error.Mismatch{"a tuple stands at a type that is not a right former"}}), _ => (Fail{Error.Mismatch{"a tuple stands at a type that is not a right former"}})))))
@unsafe
def Erase.sec_arm(+ec_1678: Erase.Ectx, +ac_1679: Erase.Acc, +ty_1680: Value, +s_1681: Shape<&2, Term>, +legs_1682: ListOf(Term.Leg), +t_1683: Term) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (+scrut15340 = s_1681
  Match.Shape(&2, Term, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15340, +p15341 => +p15342 => +p15343 => (Erase.lift_arm(ec_1678, ac_1679, ty_1680, t_1683)), +p15548 => (Erase.tuple_arm(ec_1678, ac_1679, ty_1680, p15548, legs_1682)), +p15578 => +p15579 => (Erase.refused(s_1681)), +p15580 => +p15581 => (Fail{Error.Not_yet{Rules.mu_ran_word()}}), +p15582 => +p15583 => (Erase.refused(s_1681))))
@unsafe
def Erase.function_result(+ec_2025: Erase.Ectx, +ty_2026: Value) -> CheckResult(Bool):
  (do CheckResult<Bool>:
    +bound15615 : Value <- Eval.whnf(Erase.globals_of(ec_2025), ty_2026)
    (+scrut15616 = {Erase.form_of(bound15615) : Erase.Form}
    Match.Erase_Form(&2, CheckResult(Bool), scrut15616, _ => (Done{False{}}), +p15617 => +p15618 => (Done{False{}}), +p15619 => +p15620 => (Done{Maybe.is_some(&2, TupleOf3(Quantity, String, Value), Rules.as_vpi(&2, Value, p15619))}), _ => (Done{False{}}), _ => (Done{False{}}))))
@unsafe
def Erase.app_arm(+ec_2030: Erase.Ectx, +ac_2031: Erase.Acc, +tail_2032: Bool, +ty_2033: Value, +t_2034: Term) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (+scrut15591 = {Erase.spine(t_2034, Nil{}) : TupleOf2(Term, ListOf(TupleOf3(Quantity, Term, Term)))}
  Match.Tuple2(&2, Term, &2, ListOf(TupleOf3(Quantity, Term, Term)), &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15591, +p15592 => +p15593 => ((+scrut15594 = p15593
  Match.List(&2, TupleOf3(Quantity, Term, Term), &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15594, _ => (Fail{Error.Mismatch{"an application at a point shape with no point address"}}), +p15595 => +p15596 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15598 : Value <- Check.infer(Get.Erase.Ectx.c(ec_2030), Quantity.Many{}, p15592)
    ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15600 : TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value) <- SeqList.fold(&2, &2, TupleOf3(Quantity, Term, Term), CheckResult(TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value)), (+local15623 => +local15625 => ((+scrut15626 = local15625
  Match.Tuple3(&2, Quantity, &2, Term, &2, Term, &2, CheckResult(TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value)), scrut15626, +p15627 => +p15628 => +p15629 => ((do CheckResult<TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value)>:
    +bound15631 : TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value) <- local15623
    Match.Tuple2(&2, ListOf(TupleOf2(OptionOf(Value), Term)), &2, Value, &2, CheckResult(TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value)), bound15631, +p15632 => +p15633 => ((do CheckResult<TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value)>:
      +bound15635 : Value <- Eval.whnf(Erase.globals_of(ec_2030), p15633)
      ((do CheckResult<TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value)>:
  +bound15637 : TupleOf3(Quantity, Value, Value.Closure) <- (+scrut15647 = {Erase.form_of(bound15635) : Erase.Form}
  Match.Erase_Form(&2, CheckResult(TupleOf3(Quantity, Value, Value.Closure)), scrut15647, _ => (Fail{Error.Mismatch{"an application needs a point function type"}}), +p15648 => +p15649 => (Fail{Error.Mismatch{"an application needs a point function type"}}), +p15650 => +p15651 => ((+scrut15652 = {Erase.point_of(p15650) : Erase.Point}
  Match.Erase_Point(&2, CheckResult(TupleOf3(Quantity, Value, Value.Closure)), scrut15652, +p15653 => +p15654 => +p15655 => (Done{Tup3{p15653, p15655, p15651}}), +p15656 => (Fail{Error.Mismatch{"an application needs a point function type"}}), _ => (Fail{Error.Mismatch{"an application needs a point function type"}})))), _ => (Fail{Error.Mismatch{"an application needs a point function type"}}), _ => (Fail{Error.Mismatch{"an application needs a point function type"}})))
  Match.Tuple3(&2, Quantity, &2, Value, &2, Value.Closure, &2, CheckResult(TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value)), bound15637, +p15638 => +p15639 => +p15640 => ((do CheckResult<TupleOf2(ListOf(TupleOf2(OptionOf(Value), Term)), Value)>:
    +bound15642 : Bool <- Erase.point_runtime(ec_2030, p15638, p15639)
    +bound15644 : Value <- Eval.eval(Erase.globals_of(ec_2030), Erase.env_of(ec_2030), p15629)
    +bound15646 : Value <- Rules.open_closure(Eval.ev(Erase.globals_of(ec_2030)), p15640, Con{bound15644, Nil{}})
    Done{Tup2{Native.choose(&2, ListOf(TupleOf2(OptionOf(Value), Term)), bound15642, _ => (List.append(&2, TupleOf2(OptionOf(Value), Term), p15632, Con{Tup2{Some{p15639}, p15629}, Nil{}})), _ => (p15632)), bound15646}})))))))))))))), p15593, Done{Tup2{Nil{}, bound15598}})
  Match.Tuple2(&2, ListOf(TupleOf2(OptionOf(Value), Term)), &2, Value, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15600, +p15601 => +p15602 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15604 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_2030, ac_2031, False{}, Some{bound15598}, p15592)
    Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15604, +p15605 => +p15606 => (((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15608 : TupleOf2(ListOf(Eterm.Ktm), Erase.Acc) <- Erase.erase_fold(ec_2030, p15606, p15601)
  Match.Tuple2(&2, ListOf(Eterm.Ktm), &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15608, +p15609 => +p15610 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15612 : Bool <- Native.choose(&2, CheckResult(Bool), List.is_empty(&2, Eterm.Ktm, p15609), _ => (Erase.function_result(ec_2030, ty_2033)), _ => (Done{False{}}))
    (+scrut15613 = {Unit{} : Unit}
    Native.choose(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15612, _ => (Done{Tup2{p15605, p15610}}), _ => (Native.choose(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), tail_2032, _ => (Done{Tup2{Eterm.Ktm.KTail{p15605, p15609}, p15610}}), _ => (Done{Tup2{Eterm.Ktm.KApp{p15605, p15609}, p15610}}))))))))))))))))))))))))
@unsafe
def Erase.proj_arm(+ec_2070: Erase.Ectx, +ac_2071: Erase.Acc, +n_2072: Big, +a_2073: Term.Addr, +head_2074: Term) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15661 : Big <- (+local15691 => (Match.Maybe(&2, Big, &2, CheckResult(Big), local15691, _ => Fail{Error.Mismatch{"a projection takes a leg address"}}, +x => Done{x})))(Term.as_aleg(a_2073))
    ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15663 : Value <- Check.infer(Get.Erase.Ectx.c(ec_2070), Quantity.Many{}, head_2074)
  +bound15665 : Value <- Eval.whnf(Erase.globals_of(ec_2070), bound15663)
  (+scrut15666 = {Erase.form_of(bound15665) : Erase.Form}
  Match.Erase_Form(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15666, _ => (Fail{Error.Mismatch{"a projection stands on a value that is not a right former"}}), +p15667 => +p15668 => (Fail{Error.Mismatch{"a projection stands on a value that is not a right former"}}), +p15669 => +p15670 => (((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15672 : ListOf(Bool) <- Erase.leg_flags(ec_2070, n_2072, p15670)
  (+scrut15680 = {Big.of_nat(List.length(&2, Bool, SeqList.filter(&2, Bool, (+local15675 => (local15675)), SeqList.filteri(&2, Bool, (+local15677 => +local15679 => (Big.is_lt(local15677, bound15661))), bound15672)))) : Big}
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15682 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_2070, ac_2071, False{}, Some{bound15663}, head_2074)
    Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15682, +p15683 => +p15684 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
      +bound15686 : Eterm.Tid <- Erase.tid_of(ec_2070, bound15663)
      Done{Tup2{Eterm.Ktm.KProj{bound15686, scrut15680, p15683}, p15684}})))))))), _ => (Fail{Error.Mismatch{"a projection stands on a value that is not a right former"}}), _ => (Fail{Error.Mismatch{"a projection stands on a value that is not a right former"}}))))))
@unsafe
def Erase.out_arm(+ec_2016: Erase.Ectx, +ac_2017: Erase.Acc, +tail_2018: Bool, +ty_2019: Value, +s_2020: Shape<&2, Term>, +a_2021: Term.Addr, +head_2022: Term, +t_2023: Term) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (+scrut15587 = s_2020
  Match.Shape(&2, Term, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut15587, +p15588 => +p15589 => +p15590 => (Erase.app_arm(ec_2016, ac_2017, tail_2018, ty_2019, t_2023)), +p15659 => (Erase.proj_arm(ec_2016, ac_2017, p15659, a_2021, head_2022)), +p15692 => +p15693 => (Erase.refused(s_2020)), +p15694 => +p15695 => (Fail{Error.Not_yet{Rules.mu_ran_word()}}), +p15696 => +p15697 => (Erase.refused(s_2020))))
@unsafe
def Erase.let_arm(+ec_2189: Erase.Ectx, +ac_2190: Erase.Acc, +tail_2191: Bool, +ty_2192: Value, +x_2193: String, +lty_2194: Term, +v_2195: Term, +body_2196: Term) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15703 : Value <- Eval.eval(Erase.globals_of(ec_2189), Erase.env_of(ec_2189), lty_2194)
    +bound15705 : Bool <- Erase.runtime_ty(ec_2189, bound15703)
    +bound15707 : Value <- Eval.eval(Erase.globals_of(ec_2189), Erase.env_of(ec_2189), v_2195)
    (+scrut15708 = {MkErase_Ectx{Check.define(x_2193, Quantity.Many{}, bound15703, bound15707, Get.Erase.Ectx.c(ec_2189)), Con{Native.choose(&2, Erase.Slot, bound15705, _ => (Erase.Slot.SKeep{}), _ => (Erase.Slot.SDrop{})), Get.Erase.Ectx.slots(ec_2189)}, Get.Erase.Ectx.self(ec_2189)} : Erase.Ectx}
    (Native.choose(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15705, _ => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
  +bound15710 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(ec_2189, ac_2190, False{}, Some{bound15703}, v_2195)
  Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15710, +p15711 => +p15712 => ((do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound15714 : TupleOf2(Eterm.Ktm, Erase.Acc) <- Erase.term(scrut15708, p15712, tail_2191, Some{ty_2192}, body_2196)
    Match.Tuple2(&2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound15714, +p15715 => +p15716 => (Done{Tup2{Eterm.Ktm.KLet{x_2193, p15711, p15715}, p15716}}))))))), _ => (Erase.term(scrut15708, ac_2190, tail_2191, Some{ty_2192}, body_2196))))))
@unsafe
def Erase.node(+ec_1634: Erase.Ectx, +ac_1635: Erase.Acc, +tail_1636: Bool, +ty_1637: Value, +t_1638: Term) -> CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)):
  (+scrut14860 = t_1638
  Match.Term(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), scrut14860, +p14861 => (Erase.var_arm(ec_1634, ac_1635, p14861)), +p14864 => (Done{Tup2{Eterm.Ktm.KErased{}, ac_1635}}), +p14865 => +p14866 => (Done{Tup2{Eterm.Ktm.KErased{}, ac_1635}}), +p14867 => +p14868 => (Done{Tup2{Eterm.Ktm.KErased{}, ac_1635}}), +p14869 => +p14870 => +p14871 => (Erase.in_arm(ec_1634, ac_1635, ty_1637, p14869, p14870, p14871)), +p15062 => (Erase.elim_arm(ec_1634, ac_1635, tail_1636, ty_1637, p15062)), +p15338 => +p15339 => (Erase.sec_arm(ec_1634, ac_1635, ty_1637, p15338, p15339, t_1638)), +p15584 => +p15585 => +p15586 => (Erase.out_arm(ec_1634, ac_1635, tail_1636, ty_1637, p15584, p15585, p15586, t_1638)), +p15698 => +p15699 => +p15700 => +p15701 => (Erase.let_arm(ec_1634, ac_1635, tail_1636, ty_1637, p15698, p15699, p15700, p15701)), +p15718 => +p15719 => (Erase.term(ec_1634, ac_1635, tail_1636, Some{ty_1637}, p15718)), +p15720 => (Done{Tup2{Eterm.Ktm.KGlobal{p15720}, ac_1635}}), +p15721 => (Done{Tup2{Eterm.Ktm.KLit{p15721}, ac_1635}}), _ => (Fail{Error.Not_yet{Rules.auto_word()}})))
@unsafe
def Erase.position_ty(+ec_1629: Erase.Ectx, +expected_1630: OptionOf(Value), +t_1631: Term) -> CheckResult(Value):
  Erase.lazy_fold(&2, Value, &2, CheckResult(Value), expected_1630, (+local15723 => ((+scrut15724 = local15723
  Check.infer(Get.Erase.Ectx.c(ec_1629), Quantity.Many{}, t_1631)))), (+local15726 => (Done{local15726})))
@unsafe
def Erase.term(ec_1622, ac_1623, tail_1624, expected_1625, t_1626):
  (do CheckResult<TupleOf2(Eterm.Ktm, Erase.Acc)>:
    +bound14857 : Value <- Erase.position_ty(ec_1622, expected_1625, t_1626)
    +bound14859 : Bool <- Erase.runtime_ty(ec_1622, bound14857)
    Native.choose(&2, CheckResult(TupleOf2(Eterm.Ktm, Erase.Acc)), bound14859, _ => (Erase.node(ec_1622, ac_1623, tail_1624, bound14857, t_1626)), _ => (Done{Tup2{Eterm.Ktm.KErased{}, ac_1623}})))
@unsafe
def Erase.tids_ktm(+t_2208: Eterm.Ktm) -> ListOf(Eterm.Tid):
  (+scrut15727 = t_2208
  Match.Eterm_Ktm(&2, ListOf(Eterm.Tid), scrut15727, +p15728 => (Nil{}), +p15729 => (Nil{}), +p15730 => (Nil{}), _ => (Nil{}), +p15731 => +p15732 => +p15733 => (List.append(&2, Eterm.Tid, Erase.tids_ktm(p15732), Erase.tids_ktm(p15733))), +p15734 => +p15735 => +p15736 => (List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Eterm.Tid), Erase.tids_ktm, p15736))), +p15737 => +p15738 => (List.append(&2, Eterm.Tid, Erase.tids_ktm(p15737), List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Eterm.Tid), Erase.tids_ktm, p15738)))), +p15739 => +p15740 => (List.append(&2, Eterm.Tid, Erase.tids_ktm(p15739), List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Eterm.Tid), Erase.tids_ktm, p15740)))), +p15741 => +p15742 => (Con{p15741, List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Eterm.Tid), Erase.tids_ktm, p15742))}), +p15743 => +p15744 => +p15745 => (Con{p15743, Erase.tids_ktm(p15745)}), +p15746 => +p15747 => +p15748 => (Con{p15746, List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Eterm.Tid), Erase.tids_ktm, p15748))}), +p15749 => +p15750 => +p15751 => (List.append(&2, Eterm.Tid, Con{p15749, Erase.tids_ktm(p15750)}, List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Kbranch, ListOf(Eterm.Tid), (+local15753 => (Erase.tids_ktm(Get.Eterm.Kbranch.body(local15753)))), p15751)))), +p15754 => +p15755 => (List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Ktm, ListOf(Eterm.Tid), Erase.tids_ktm, p15755))), +p15756 => (Erase.tids_ktm(p15756))))
@unsafe
def Erase.tids_repr(+r_2236: Eterm.Repr) -> ListOf(Eterm.Tid):
  (+scrut15757 = r_2236
  Match.Eterm_Repr(&2, ListOf(Eterm.Tid), scrut15757, _ => (Nil{}), +p15758 => (Con{p15758, Nil{}}), +p15759 => (Con{p15759, Nil{}}), +p15760 => (Con{p15760, Nil{}}), +p15761 => (Con{p15761, Nil{}})))
@unsafe
def Erase.tids_decl(+d_2243: Eterm.Kdecl) -> ListOf(Eterm.Tid):
  (+scrut15762 = d_2243
  Match.Eterm_Kdecl(&2, ListOf(Eterm.Tid), scrut15762, +p15763 => +p15764 => +p15765 => +p15766 => (List.append(&2, Eterm.Tid, List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Repr, ListOf(Eterm.Tid), Erase.tids_repr, p15764)), List.append(&2, Eterm.Tid, Erase.tids_repr(p15765), Erase.tids_ktm(p15766)))), +p15767 => (p15767)))
@unsafe
def Erase.dedup_tids(+ts_2251: ListOf(Eterm.Tid)) -> ListOf(Eterm.Tid):
  SeqList.fold(&2, &2, Eterm.Tid, ListOf(Eterm.Tid), (+local15769 => +local15771 => (Native.choose(&2, ListOf(Eterm.Tid), SeqList.exists(&2, Eterm.Tid, (+local15773 => (NativeString.equal(Eterm.tid_text(local15773), Eterm.tid_text(local15771)))), local15769), _ => (local15769), _ => (List.append(&2, Eterm.Tid, local15769, Con{local15771, Nil{}}))))), ts_2251, Nil{})
@unsafe
def Erase.def_code(+ec_2269: Erase.Ectx, +name_2270: String, +ty_v_2271: Value, +body_2272: Term) -> CheckResult(Erase.Entry):
  (do CheckResult<Erase.Entry>:
    +bound15782 : TupleOf4(ListOf(Eterm.Repr), Eterm.Repr, Eterm.Ktm, Erase.Acc) <- Erase.chain(ec_2269, MkErase_Acc{Big.zero(), Nil{}, Nil{}}, Nil{}, ty_v_2271, body_2272)
    Match.Tuple4(&2, ListOf(Eterm.Repr), &2, Eterm.Repr, &2, Eterm.Ktm, &2, Erase.Acc, &2, CheckResult(Erase.Entry), bound15782, +p15783 => +p15784 => +p15785 => +p15786 => ((+scrut15787 = {Eterm.Kdecl.KFun{Eterm.Fid.Fid{name_2270}, p15783, p15784, p15785} : Eterm.Kdecl}
    (+scrut15788 = {List.append(&2, Eterm.Kdecl, Get.Erase.Acc.lifted(p15786), Con{scrut15787, Nil{}}) : ListOf(Eterm.Kdecl)}
    Done{Erase.Entry.Code{Con{Eterm.Kdecl.KRec{Erase.dedup_tids(List.append(&2, Eterm.Tid, List.concat(&2, Eterm.Tid, SeqList.map(&2, &2, Eterm.Kdecl, ListOf(Eterm.Tid), Erase.tids_decl, scrut15788)), Get.Erase.Acc.groups(p15786)))}, scrut15788}}})))))
@unsafe
def Erase.decl(+g_2257: Global, +budget_2258: Budget, +name_2259: String, +en_2260: Global.Entry) -> CheckResult(Erase.Entry):
  (+scrut15774 = {MkErase_Ectx{Check.make(g_2257, budget_2258), Nil{}, name_2259} : Erase.Ectx}
  ((+scrut15775 = en_2260
Match.Global_Entry(&2, CheckResult(Erase.Entry), scrut15775, +p15776 => ((do CheckResult<Erase.Entry>:
  +bound15778 : Value <- Eval.eval(g_2257, Nil{}, Get.Global.Def_entry.ty(p15776))
  +bound15780 : Bool <- Erase.runtime_ty(scrut15774, bound15778)
  Native.choose(&2, CheckResult(Erase.Entry), bound15780, _ => (Erase.def_code(scrut15774, name_2259, bound15778, Get.Global.Def_entry.def(p15776))), _ => (Done{Erase.Entry.Dropped{}})))), +p15789 => ((do CheckResult<Erase.Entry>:
  +bound15791 : Value <- Eval.eval(g_2257, Nil{}, Get.Global.Axiom_entry.ax_ty(p15789))
  +bound15793 : Bool <- Erase.runtime_ty(scrut15774, bound15791)
  Native.choose(&2, CheckResult(Erase.Entry), bound15793, _ => (Match.Result(&2, Eterm.Repr, &2, Error, &2, CheckResult(Erase.Entry), Erase.repr_of(scrut15774, bound15791), +item15796 => (Done{(+local15795 => (Erase.Entry.Postulate{local15795}))(item15796)}), +item15797 => Fail{item15797})), _ => (Done{Erase.Entry.Dropped{}})))), +p15798 => (Done{Erase.Entry.Dropped{}})))))
@unsafe
def Erase.program(+_opt__2296: Maybe<&1, Budget>, +globals_2283: Global, +rows_2284: ListOf(TupleOf2(String, Global.Entry))) -> CheckResult(ListOf(TupleOf2(String, Erase.Entry))):
  (+scrut15803 = {(+scrut15801 = _opt__2296
  Match.Maybe(&1, Budget, &1, Budget, scrut15801, _ => (Budget.unlimited()), +p15802 => (p15802))) : Budget}
  ((+local15819 => (Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Erase.Entry))), &2, Error, &2, CheckResult(ListOf(TupleOf2(String, Erase.Entry))), local15819, +item15825 => (Done{(+local15821 => ((+scrut15822 = local15821
Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Erase.Entry)), &2, ListOf(TupleOf2(String, Erase.Entry)), scrut15822, +p15823 => +p15824 => (p15824)))))(item15825)}), +item15826 => Fail{item15826})))(SeqList.fold(&2, &2, TupleOf2(String, Global.Entry), CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Erase.Entry)))), (+local15805 => +local15807 => ((+scrut15808 = local15807
Match.Tuple2(&2, String, &2, Global.Entry, &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Erase.Entry)))), scrut15808, +p15809 => +p15810 => ((do CheckResult<TupleOf2(Global, ListOf(TupleOf2(String, Erase.Entry)))>:
  +bound15812 : TupleOf2(Global, ListOf(TupleOf2(String, Erase.Entry))) <- local15805
  Match.Tuple2(&2, Global, &2, ListOf(TupleOf2(String, Erase.Entry)), &2, CheckResult(TupleOf2(Global, ListOf(TupleOf2(String, Erase.Entry)))), bound15812, +p15813 => +p15814 => ((do CheckResult<TupleOf2(Global, ListOf(TupleOf2(String, Erase.Entry)))>:
    +bound15816 : Erase.Entry <- Erase.decl(p15813, scrut15803, p15809, p15810)
    Done{Tup2{Global.add(p15809, p15810, p15813), List.append(&2, TupleOf2(String, Erase.Entry), p15814, Con{Tup2{p15809, bound15816}, Nil{}})}}))))))))), rows_2284, Done{Tup2{globals_2283, Nil{}}}))))
@unsafe
def Eterm.fid_text(+f_334: Eterm.Fid) -> String:
  (+scrut15843 = f_334
  Match.Eterm_Fid(&2, String, scrut15843, +p15844 => (p15844)))
@unsafe
def Eterm.literal_text(+l_338: Literal) -> String:
  (+scrut15848 = l_338
  Match.Literal(&2, String, scrut15848, +p15849 => (String.append("\u{22}", String.append(NativeString.escaped(p15849), "\u{22}"))), +p15850 => (Bignum.to_string(p15850))))
@unsafe
def Eterm.ktm_list(+xs_706: ListOf(Eterm.Ktm)) -> String:
  String.append("[", String.append(String.join(SeqList.map(&2, &2, Eterm.Ktm, String, Eterm.print_ktm, xs_706), "; "), "]"))
@unsafe
def Eterm.print_branch(+b_707: Eterm.Kbranch) -> String:
  String.concat(["{", Big.show(Get.Eterm.Kbranch.tag(b_707)), " ", Big.show(Get.Eterm.Kbranch.arity(b_707)), " (", Eterm.print_ktm(Get.Eterm.Kbranch.body(b_707)), ")}"])
@unsafe
def Eterm.print_ktm(t_576):
  (+scrut15845 = t_576
  Match.Eterm_Ktm(&2, String, scrut15845, +p15846 => (String.concat(["KVar ", Big.show(p15846)])), +p15847 => (String.append("KLit ", Eterm.literal_text(p15847))), +p15851 => (String.append("KGlobal ", p15851)), _ => ("KErased"), +p15852 => +p15853 => +p15854 => (String.concat(["KLet ", p15852, " (", Eterm.print_ktm(p15853), ") (", Eterm.print_ktm(p15854), ")"])), +p15855 => +p15856 => +p15857 => (String.concat(["KClos ", Eterm.fid_text(p15855), " ", Big.show(p15856), " ", Eterm.ktm_list(p15857)])), +p15858 => +p15859 => (String.concat(["KApp (", Eterm.print_ktm(p15858), ") ", Eterm.ktm_list(p15859)])), +p15860 => +p15861 => (String.concat(["KTail (", Eterm.print_ktm(p15860), ") ", Eterm.ktm_list(p15861)])), +p15862 => +p15863 => (String.concat(["KStruct ", Eterm.tid_text(p15862), " ", Eterm.ktm_list(p15863)])), +p15864 => +p15865 => +p15866 => (String.concat(["KProj ", Eterm.tid_text(p15864), " ", Big.show(p15865), " (", Eterm.print_ktm(p15866), ")"])), +p15867 => +p15868 => +p15869 => (String.concat(["KTag ", Eterm.tid_text(p15867), " ", Big.show(p15868), " ", Eterm.ktm_list(p15869)])), +p15870 => +p15871 => +p15872 => (String.concat(["KCase ", Eterm.tid_text(p15870), " (", Eterm.print_ktm(p15871), ") [", String.join(SeqList.map(&2, &2, Eterm.Kbranch, String, Eterm.print_branch, p15872), "; "), "]"])), +p15873 => +p15874 => (String.concat(["KDelay ", Eterm.fid_text(p15873), " ", Eterm.ktm_list(p15874)])), +p15875 => (String.concat(["KForce (", Eterm.print_ktm(p15875), ")"]))))
@unsafe
def Eterm.print_decl(+d_710: Eterm.Kdecl) -> String:
  (+scrut15838 = d_710
  Match.Eterm_Kdecl(&2, String, scrut15838, +p15839 => +p15840 => +p15841 => +p15842 => (String.concat(["fun ", Eterm.fid_text(p15839), " (", String.join(SeqList.map(&2, &2, Eterm.Repr, String, Eterm.print_repr, p15840), ", "), ") : ", Eterm.print_repr(p15841), " := ", Eterm.print_ktm(p15842)])), +p15876 => (String.concat(["rec [", String.join(SeqList.map(&2, &2, Eterm.Tid, String, Eterm.tid_text, p15876), "; "), "]"]))))
@unsafe
def Erase.print(+rows_2299: ListOf(TupleOf2(String, Erase.Entry))) -> String:
  String.join(SeqList.map(&2, &2, TupleOf2(String, Erase.Entry), String, (+local15829 => ((+scrut15830 = local15829
  Match.Tuple2(&2, String, &2, Erase.Entry, &2, String, scrut15830, +p15831 => +p15832 => ((+scrut15833 = p15832
  Match.Erase_Entry(&2, String, scrut15833, _ => (String.concat(["erased ", p15831, "\u{a}"])), +p15834 => (String.concat(["axiom ", p15831, " : ", Eterm.print_repr(p15834), "\u{a}"])), +p15835 => (String.join(SeqList.map(&2, &2, Eterm.Kdecl, String, (+local15837 => (String.append(Eterm.print_decl(local15837), "\u{a}"))), p15835), ""))))))))), rows_2299), "")
@unsafe
def Elab.let_(-q0: Quant, -A0: Kind(q0), -q1: Quant, -A1: Kind(q1), -q2: Quant, -A2: Kind(q2)) -> Reusable(Result<q1, q2, A1, A2>, Reusable(Reusable(A2, Result<q1, q0, A1, A0>), Result<q1, q0, A1, A0>)):
  (+local15882 => +local15884 => (Match.Result(q2, A2, q1, A1, (q0 <&> q1), Result<q1, q0, A1, A0>, local15882, +item15885 => (local15884(item15885)), +item15886 => Fail{item15886})))
@unsafe
def Elab.elab_program(+_opt__2310: Maybe<&1, Budget>, +globals_2308: Global, +ds_2309: ListOf(Syntax.Decl)) -> CheckResult(ListOf(TupleOf2(String, Global.Entry))):
  (+scrut15890 = {(+scrut15888 = _opt__2310
  Match.Maybe(&1, Budget, &1, Budget, scrut15888, _ => (Budget.unlimited()), +p15889 => (p15889))) : Budget}
  Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, CheckResult(ListOf(TupleOf2(String, Global.Entry))), Elab.elab_program_in(Some{scrut15890}, globals_2308, ds_2309), +item15894 => (Done{(+local15893 => (Get.Tuple2.v1(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), local15893)))(item15894)}), +item15895 => Fail{item15895}))
@unsafe
def Elab.entry_text(+param_2345: TupleOf2(String, Global.Entry)) -> String:
  (+scrut15896 = param_2345
  Match.Tuple2(&2, String, &2, Global.Entry, &2, String, scrut15896, +p15897 => +p15898 => ((+scrut15899 = p15898
  Match.Global_Entry(&2, String, scrut15899, +p15900 => (String.concat(["def ", p15897, " : ", Pp.term(Nil{}, Get.Global.Def_entry.ty(p15900)), " := ", Pp.term(Nil{}, Get.Global.Def_entry.def(p15900)), "\u{a}"])), +p15901 => (String.concat(["axiom ", p15897, " : ", Pp.term(Nil{}, Get.Global.Axiom_entry.ax_ty(p15901)), "\u{a}"])), +p15902 => (String.concat(["prim ", p15897, " : ", Pp.term(Nil{}, Get.Global.Prim_entry.p_ty(p15902)), "\u{a}"])))))))
@unsafe
def Elab.checked_form(+rows_2348: ListOf(TupleOf2(String, Global.Entry))) -> String:
  String.join(SeqList.map(&2, &2, TupleOf2(String, Global.Entry), String, Elab.entry_text, rows_2348), "")
@unsafe
def Elab.check_text(+_opt__2412: Maybe<&1, Budget>, +globals_2410: Global, +src_2411: String) -> CheckResult(ListOf(TupleOf2(String, Global.Entry))):
  (+scrut15906 = {(+scrut15904 = _opt__2412
  Match.Maybe(&1, Budget, &1, Budget, scrut15904, _ => (Budget.unlimited()), +p15905 => (p15905))) : Budget}
  Match.Result(&2, TupleOf2(Global, ListOf(TupleOf2(String, Global.Entry))), &2, Error, &2, CheckResult(ListOf(TupleOf2(String, Global.Entry))), Elab.check_in(Some{scrut15906}, globals_2410, src_2411), +item15910 => (Done{(+local15909 => (Get.Tuple2.v1(&2, Global, &2, ListOf(TupleOf2(String, Global.Entry)), local15909)))(item15910)}), +item15911 => Fail{item15911}))
@unsafe
def Spec_count.row(+label_693: String, +items_694: ListOf(String)) -> String:
  String.concat([label_693, " ", Big.show(Big.of_nat(List.length(&2, String, items_694))), ": ", String.join(items_694, " "), "\u{a}"])
@unsafe
def Spec_count.at(+n_414: Big, +xs_415: ListOf(String)) -> OptionOf(String):
  (+scrut15946 = xs_415
  Match.List(&2, String, &2, OptionOf(String), scrut15946, _ => (None{}), +p15947 => +p15948 => (Native.choose(&2, OptionOf(String), Big.is_eq(n_414, Big.zero()), _ => (Some{p15947}), _ => (Spec_count.at(NativeInt.sub(n_414, Big.one()), p15948))))))
@unsafe
def Spec_count.pick(+n_451: Big, +xs_452: ListOf(String)) -> String:
  (+local15951 => (Maybe.default(&2, String, local15951, "?")))(Spec_count.at(n_451, xs_452))
@unsafe
def Spec_count.ran() -> String:
  Spec_count.pick(Big.one(), Term.formers())
@unsafe
def Spec_count.lan() -> String:
  Spec_count.pick(Big.zero(), Term.formers())
@unsafe
def Spec_count.eta_of(+keep_486: Bool) -> ListOf(String):
  List.concat(&2, String, SeqList.map(&2, &2, TupleOf2(String, Rules.Eta_row), ListOf(String), (+local15937 => ((+scrut15938 = local15937
  Match.Tuple2(&2, String, &2, Rules.Eta_row, &2, ListOf(String), scrut15938, +p15939 => +p15940 => (SeqList.filter_map(&2, &2, TupleOf2(String, Bool), String, (+local15942 => ((+scrut15943 = local15942
  Match.Tuple2(&2, String, &2, Bool, &2, OptionOf(String), scrut15943, +p15944 => +p15945 => (Native.choose(&2, OptionOf(String), NativeBool.equal(p15945, keep_486), _ => (Some{String.append(p15944, String.append("-", p15939))}), _ => (None{}))))))), Con{Tup2{Spec_count.ran(), Get.Rules.Eta_row.eta_ran(p15940)}, Con{Tup2{Spec_count.lan(), Get.Rules.Eta_row.eta_lan(p15940)}, Nil{}}})))))), Rules.eta_table()))
@unsafe
def Spec_count.eta_rows() -> ListOf(String):
  Spec_count.eta_of(True{})
@unsafe
def Spec_count.no_eta() -> ListOf(String):
  Spec_count.eta_of(False{})
@unsafe
def Spec_count.print(+param_808: Unit) -> String:
  (+scrut15912 = param_808
  String.join(Con{Spec_count.row("formers", Term.formers()), Con{Spec_count.row("schema constructors", Term.schema()), Con{Spec_count.row("shapes declared", Shape.declared()), Con{Spec_count.row("shapes admitted", Rules.admitted()), Con{Spec_count.row("named rules declared", Rules.named_declared()), Con{Spec_count.row("named rules present", Rules.named_present()), Con{Spec_count.row("eta rows", Spec_count.eta_rows()), Con{Spec_count.row("no eta", Spec_count.no_eta()), Nil{}}}}}}}}}, ""))
