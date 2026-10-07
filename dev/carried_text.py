"""Exact rewrites that later commits made to carried lines of src/tests.bend.

The compatibility checks apply them to a BASE text and then compare it with the current file.
"""

import functools

REWRITES = (
    # fa19053 changed this refusal string.
    ('"a right former at a mu shape arrives at M2"',
     '"a right former at a mu shape is deferred"'),
    # fa19053 changed this refusal string.
    ('"def f : Type 0 := nu", "nu arrives at M2"',
     '"def f : Type 0 := nu", "nu is deferred"'),
    # fa19053 changed this refusal string.
    ('"nu N : Type 0 :=", "nu arrives at M2"',
     '"nu N : Type 0 :=", "nu is deferred"'),
    # D2 adds the spar and snu cases to the Main.kneg dispatch.
    ('  Native.choose(&2, StringResult(Unit), NativeString.equal(name_1042, "smu"), _ => (Main'
     '.kneg_smu(Unit{})), _ => (Native.choose(&2, StringResult(Unit), NativeString.equal(name_'
     '1042, "self"), _ => (Main.kneg_self(Unit{})), _ => (Fail{String.concat(["no kernel negat'
     'ive is named \\u{22}", name_1042, "\\u{22}"])})))))\n',
     '  Native.choose(&2, StringResult(Unit), NativeString.equal(name_1042, "smu"), _ => (Main'
     '.kneg_smu(Unit{})), _ => (Native.choose(&2, StringResult(Unit), NativeString.equal(name_'
     '1042, "self"), _ => (Main.kneg_self(Unit{})), _ => (Native.choose(&2, StringResult(Unit)'
     ', NativeString.equal(name_1042, "spar"), _ => (Main.kneg_shape(Shape.SPar{Term.Univ{Leve'
     'l.zero()}, Term.Univ{Level.zero()}}, "SPar is deferred")), _ => (Native.choose(&2, Strin'
     'gResult(Unit), NativeString.equal(name_1042, "snu"), _ => (Main.kneg_shape(Shape.SNu{"F"'
     ', Con{Term.Univ{Level.zero()}, Nil{}}}, "SNu is deferred")), _ => (Fail{String.concat(["'
     'no kernel negative is named \\u{22}", name_1042, "\\u{22}"])})))))))))\n'),
    # D2 adds the level-variable-refusal case.
    ('  Sl_surface.parse_refusal("nu N : Type 0 :=", "nu is deferred"))))}, Nil{}}}}}}}}}}}}}}'
     '}}}}}}}\n',
     '  Sl_surface.parse_refusal("nu N : Type 0 :=", "nu is deferred"))))}, Con{Tup2{"level-va'
     'riable-refusal", (_ => (Sl_surface.parse_refusal("axiom A : Type u", "level variables ar'
     'e deferred")))}, Nil{}}}}}}}}}}}}}}}}}}}}}}\n'),
    # D2 adds the thunk case to the emit cases.
    ('  ((+scrut17380 = {Con{Emit_cases.good(&2, String, "literal", Recognize.Value.Nat{Big.id'
     'entity(Big.of_nat(7n))}, Emit_cases.lit(Big.of_nat(7n))), Con{Emit_cases.good(&2, String'
     ', "erased", Recognize.Value.Erased{}, Eterm.Ktm.KErased{}), Con{Emit_cases.good(&2, Stri'
     'ng, "let-var", Recognize.Value.Nat{Big.identity(Big.of_nat(9n))}, Eterm.Ktm.KLet{"x", Em'
     'it_cases.lit(Big.of_nat(9n)), Eterm.Ktm.KVar{Big.zero()}}), Con{Emit_cases.good(&2, Stri'
     'ng, "app", Recognize.Value.Nat{Big.identity(Big.of_nat(10n))}, Eterm.Ktm.KApp{Eterm.Ktm.'
     'KGlobal{"f"}, Con{Emit_cases.lit(Big.of_nat(9n)), Nil{}}}), Con{Emit_cases.good(&2, Stri'
     'ng, "tail", Recognize.Value.Nat{Big.identity(Big.of_nat(10n))}, Eterm.Ktm.KTail{Eterm.Kt'
     'm.KGlobal{"f"}, Con{Emit_cases.lit(Big.of_nat(9n)), Nil{}}}), Con{Emit_cases.good(&2, St'
     'ring, "struct", Recognize.Value.Struct{Emit_cases.pair_tid(), Con{Recognize.Value.Nat{Bi'
     'g.identity(Big.of_nat(8n))}, Nil{}}}, Eterm.Ktm.KStruct{Emit_cases.pair_tid(), Con{Emit_'
     'cases.lit(Big.of_nat(8n)), Nil{}}}), Con{Emit_cases.good(&2, String, "projection", Recog'
     'nize.Value.Nat{Big.identity(Big.of_nat(8n))}, Eterm.Ktm.KProj{Emit_cases.pair_tid(), Big'
     '.zero(), Eterm.Ktm.KStruct{Emit_cases.pair_tid(), Con{Emit_cases.lit(Big.of_nat(8n)), Ni'
     'l{}}}}), Con{Emit_cases.good(&2, String, "tag", Recognize.Value.Tag{Emit_cases.pair_tid('
     '), Big.of_nat(2n), Con{Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Nil{}}}, Eterm'
     '.Ktm.KTag{Emit_cases.pair_tid(), Big.of_nat(2n), Con{Emit_cases.lit(Big.of_nat(8n)), Nil'
     '{}}}), Con{Emit_cases.good(&2, String, "case", Recognize.Value.Nat{Big.identity(Big.of_n'
     'at(8n))}, Eterm.Ktm.KCase{Emit_cases.pair_tid(), Eterm.Ktm.KTag{Emit_cases.pair_tid(), B'
     'ig.of_nat(2n), Con{Emit_cases.lit(Big.of_nat(8n)), Nil{}}}, Con{MkEterm_KbranchOf{Big.of'
     '_nat(2n), Big.one(), Eterm.Ktm.KVar{Big.zero()}}, Nil{}}}), Con{Emit_cases.good(&2, Stri'
     'ng, "word-case", Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Eterm.Ktm.KCase{Reco'
     'gnize.word_tid(), Eterm.Ktm.KTag{Recognize.word_tid(), Big.zero(), Con{Emit_cases.lit(Bi'
     'g.of_nat(8n)), Nil{}}}, Con{MkEterm_KbranchOf{Big.zero(), Big.one(), Eterm.Ktm.KVar{Big.'
     'zero()}}, Nil{}}}), Con{Emit_cases.bad(&2, String, "closure", Emit.Error.Higher_order{},'
     ' Eterm.Ktm.KClos{Eterm.Fid.Fid{"f"}, Big.one(), Nil{}}), Con{Emit_cases.bad(&2, String, '
     '"indirect-app", Emit.Error.Higher_order{}, Eterm.Ktm.KApp{Eterm.Ktm.KVar{Big.zero()}, Co'
     'n{Emit_cases.lit(Big.zero()), Nil{}}}), Con{Emit_cases.bad(&2, String, "partial", Emit.E'
     'rror.Higher_order{}, Eterm.Ktm.KGlobal{"f"}), Con{Emit_cases.bad(&2, String, "delay", Em'
     'it.Error.Later{"KDELAY"}, Eterm.Ktm.KDelay{Eterm.Fid.Fid{"f"}, Nil{}}), Con{Emit_cases.b'
     'ad(&2, String, "force", Emit.Error.Later{"KFORCE"}, Eterm.Ktm.KForce{Emit_cases.lit(Big.'
     'zero())}), Con{Emit_cases.bad(&2, String, "string", Emit.Error.Later{"STRING"}, Eterm.Kt'
     'm.KLit{Literal.LString{"x"}}), Con{Emit_cases.bad(&2, String, "bad-index", Emit.Error.In'
     'valid_ir{"index"}, Eterm.Ktm.KVar{Big.neg(Big.of_nat(1n))}), Con{Emit_cases.bad(&2, Stri'
     'ng, "missing", Emit.Error.Missing{"gone"}, Eterm.Ktm.KGlobal{"gone"}), Con{Emit_cases.re'
     'quire(&2, String, "fuel", Equal.Emit_Result_TupleOf2_Recognize_Value__Big__(Emit.eval(Em'
     'it_cases.env(), Nil{}, Big.zero(), Emit_cases.lit(Big.one())), Fail{Emit.Error.Budget{}}'
     ')), Con{Emit_cases.require(&2, String, "runtime-nat", Equal.Emit_Result_Emit_Effect_(Emi'
     't.effect(Big.zero(), Recognize.Value.Nat{Big.zero()}), Fail{Emit.Error.Nat_runtime{}})),'
     ' Con{Emit_cases.good(&2, String, "natSub", Recognize.Value.Nat{Big.zero()}, Eterm.Ktm.KA'
     'pp{Eterm.Ktm.KGlobal{"natSub"}, Con{Emit_cases.lit(Big.of_nat(2n)), Con{Emit_cases.lit(B'
     'ig.of_nat(8n)), Nil{}}}}), Con{Emit_cases.good(&2, String, "natMul", Recognize.Value.Nat'
     '{Big.identity(Big.of_nat(42n))}, Eterm.Ktm.KApp{Eterm.Ktm.KGlobal{"natMul"}, Con{Emit_ca'
     'ses.lit(Big.of_nat(6n)), Con{Emit_cases.lit(Big.of_nat(7n)), Nil{}}}}), Nil{}}}}}}}}}}}}'
     '}}}}}}}}}}} : ListOf(StringResult(Unit))}\n',
     '  ((+scrut17380 = {Con{Emit_cases.good(&2, String, "literal", Recognize.Value.Nat{Big.id'
     'entity(Big.of_nat(7n))}, Emit_cases.lit(Big.of_nat(7n))), Con{Emit_cases.good(&2, String'
     ', "erased", Recognize.Value.Erased{}, Eterm.Ktm.KErased{}), Con{Emit_cases.good(&2, Stri'
     'ng, "let-var", Recognize.Value.Nat{Big.identity(Big.of_nat(9n))}, Eterm.Ktm.KLet{"x", Em'
     'it_cases.lit(Big.of_nat(9n)), Eterm.Ktm.KVar{Big.zero()}}), Con{Emit_cases.good(&2, Stri'
     'ng, "app", Recognize.Value.Nat{Big.identity(Big.of_nat(10n))}, Eterm.Ktm.KApp{Eterm.Ktm.'
     'KGlobal{"f"}, Con{Emit_cases.lit(Big.of_nat(9n)), Nil{}}}), Con{Emit_cases.good(&2, Stri'
     'ng, "tail", Recognize.Value.Nat{Big.identity(Big.of_nat(10n))}, Eterm.Ktm.KTail{Eterm.Kt'
     'm.KGlobal{"f"}, Con{Emit_cases.lit(Big.of_nat(9n)), Nil{}}}), Con{Emit_cases.good(&2, St'
     'ring, "struct", Recognize.Value.Struct{Emit_cases.pair_tid(), Con{Recognize.Value.Nat{Bi'
     'g.identity(Big.of_nat(8n))}, Nil{}}}, Eterm.Ktm.KStruct{Emit_cases.pair_tid(), Con{Emit_'
     'cases.lit(Big.of_nat(8n)), Nil{}}}), Con{Emit_cases.good(&2, String, "projection", Recog'
     'nize.Value.Nat{Big.identity(Big.of_nat(8n))}, Eterm.Ktm.KProj{Emit_cases.pair_tid(), Big'
     '.zero(), Eterm.Ktm.KStruct{Emit_cases.pair_tid(), Con{Emit_cases.lit(Big.of_nat(8n)), Ni'
     'l{}}}}), Con{Emit_cases.good(&2, String, "tag", Recognize.Value.Tag{Emit_cases.pair_tid('
     '), Big.of_nat(2n), Con{Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Nil{}}}, Eterm'
     '.Ktm.KTag{Emit_cases.pair_tid(), Big.of_nat(2n), Con{Emit_cases.lit(Big.of_nat(8n)), Nil'
     '{}}}), Con{Emit_cases.good(&2, String, "case", Recognize.Value.Nat{Big.identity(Big.of_n'
     'at(8n))}, Eterm.Ktm.KCase{Emit_cases.pair_tid(), Eterm.Ktm.KTag{Emit_cases.pair_tid(), B'
     'ig.of_nat(2n), Con{Emit_cases.lit(Big.of_nat(8n)), Nil{}}}, Con{MkEterm_KbranchOf{Big.of'
     '_nat(2n), Big.one(), Eterm.Ktm.KVar{Big.zero()}}, Nil{}}}), Con{Emit_cases.good(&2, Stri'
     'ng, "word-case", Recognize.Value.Nat{Big.identity(Big.of_nat(8n))}, Eterm.Ktm.KCase{Reco'
     'gnize.word_tid(), Eterm.Ktm.KTag{Recognize.word_tid(), Big.zero(), Con{Emit_cases.lit(Bi'
     'g.of_nat(8n)), Nil{}}}, Con{MkEterm_KbranchOf{Big.zero(), Big.one(), Eterm.Ktm.KVar{Big.'
     'zero()}}, Nil{}}}), Con{Emit_cases.bad(&2, String, "closure", Emit.Error.Higher_order{},'
     ' Eterm.Ktm.KClos{Eterm.Fid.Fid{"f"}, Big.one(), Nil{}}), Con{Emit_cases.bad(&2, String, '
     '"indirect-app", Emit.Error.Higher_order{}, Eterm.Ktm.KApp{Eterm.Ktm.KVar{Big.zero()}, Co'
     'n{Emit_cases.lit(Big.zero()), Nil{}}}), Con{Emit_cases.bad(&2, String, "partial", Emit.E'
     'rror.Higher_order{}, Eterm.Ktm.KGlobal{"f"}), Con{Emit_cases.bad(&2, String, "delay", Em'
     'it.Error.Later{"KDELAY"}, Eterm.Ktm.KDelay{Eterm.Fid.Fid{"f"}, Nil{}}), Con{Emit_cases.b'
     'ad(&2, String, "force", Emit.Error.Later{"KFORCE"}, Eterm.Ktm.KForce{Emit_cases.lit(Big.'
     'zero())}), Con{Emit_cases.require(&2, String, "thunk", Match.Result(&2, Unit, &2, Emit.E'
     'rror, &2, Bool, Emit.result_repr(Eterm.Repr.RThunk{Emit_cases.pair_tid()}), +value_d2 =>'
     ' (False{}), +error_d2 => (Equal.Emit_Error(error_d2, Emit.Error.Later{"RTHUNK"})))), Con'
     '{Emit_cases.bad(&2, String, "string", Emit.Error.Later{"STRING"}, Eterm.Ktm.KLit{Literal'
     '.LString{"x"}}), Con{Emit_cases.bad(&2, String, "bad-index", Emit.Error.Invalid_ir{"inde'
     'x"}, Eterm.Ktm.KVar{Big.neg(Big.of_nat(1n))}), Con{Emit_cases.bad(&2, String, "missing",'
     ' Emit.Error.Missing{"gone"}, Eterm.Ktm.KGlobal{"gone"}), Con{Emit_cases.require(&2, Stri'
     'ng, "fuel", Equal.Emit_Result_TupleOf2_Recognize_Value__Big__(Emit.eval(Emit_cases.env()'
     ', Nil{}, Big.zero(), Emit_cases.lit(Big.one())), Fail{Emit.Error.Budget{}})), Con{Emit_c'
     'ases.require(&2, String, "runtime-nat", Equal.Emit_Result_Emit_Effect_(Emit.effect(Big.z'
     'ero(), Recognize.Value.Nat{Big.zero()}), Fail{Emit.Error.Nat_runtime{}})), Con{Emit_case'
     's.good(&2, String, "natSub", Recognize.Value.Nat{Big.zero()}, Eterm.Ktm.KApp{Eterm.Ktm.K'
     'Global{"natSub"}, Con{Emit_cases.lit(Big.of_nat(2n)), Con{Emit_cases.lit(Big.of_nat(8n))'
     ', Nil{}}}}), Con{Emit_cases.good(&2, String, "natMul", Recognize.Value.Nat{Big.identity('
     'Big.of_nat(42n))}, Eterm.Ktm.KApp{Eterm.Ktm.KGlobal{"natMul"}, Con{Emit_cases.lit(Big.of'
     '_nat(6n)), Con{Emit_cases.lit(Big.of_nat(7n)), Nil{}}}}), Nil{}}}}}}}}}}}}}}}}}}}}}}}} :'
     ' ListOf(StringResult(Unit))}\n'),
    # D2 adds the KNEG spar and KNEG snu units.
    ('  Tests.unit("KNEG self", Main.kneg("self"))\n',
     '  Tests.unit("KNEG self", Main.kneg("self"))\n  Tests.unit("KNEG spar", Main.kneg("spar")'
     ')\n  Tests.unit("KNEG snu", Main.kneg("snu"))\n'),
)


def _apply(text, pair):
    old, new = pair
    return None if text is None or text.count(old) > 1 else text.replace(old, new)


def rewrite(text):
    """Apply each pair whose old string occurs once and skip an absent pair.

    Return None when an old string occurs more than once.
    """
    return functools.reduce(_apply, REWRITES, text)
