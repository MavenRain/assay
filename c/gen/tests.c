/* generated from src/tests.bend */
#include "assay_gen.h"

static V kc_0; static int kc_0_ok;
static V kc_1; static int kc_1_ok;
static V kc_2; static int kc_2_ok;
static V kc_3; static int kc_3_ok;
static Str S_0 = {TAG_STR, 1, {(const uint8_t *)"F"}};
static Str S_1 = {TAG_STR, 48, {(const uint8_t *)"the right former at a mu shape is admitted at M1"}};
static Str S_2 = {TAG_STR, 40, {(const uint8_t *)"a right former at a mu shape is deferred"}};
static Str S_3 = {TAG_STR, 16, {(const uint8_t *)"the message is \042"}};
static Str S_4 = {TAG_STR, 1, {(const uint8_t *)"\042"}};
static Str S_5 = {TAG_STR, 1, {(const uint8_t *)"n"}};
static Str S_6 = {TAG_STR, 1, {(const uint8_t *)"N"}};
static Str S_7 = {TAG_STR, 4, {(const uint8_t *)"self"}};
static Str S_8 = {TAG_STR, 4, {(const uint8_t *)"succ"}};
static Str S_9 = {TAG_STR, 1, {(const uint8_t *)"m"}};
static Str S_10 = {TAG_STR, 1, {(const uint8_t *)"x"}};
static Str S_11 = {TAG_STR, 3, {(const uint8_t *)"Nat"}};
static Str S_12 = {TAG_STR, 46, {(const uint8_t *)"the unguarded self reference is admitted at M1"}};
static Str S_13 = {TAG_STR, 65, {(const uint8_t *)"recursive definition self failed the structural termination guard"}};
static Str S_14 = {TAG_STR, 46, {(const uint8_t *)"the guarded self reference answers no position"}};
static Str S_15 = {TAG_STR, 24, {(const uint8_t *)"the guarded position is "}};
static Str S_16 = {TAG_STR, 3, {(const uint8_t *)"smu"}};
static Str S_17 = {TAG_STR, 4, {(const uint8_t *)"spar"}};
static Str S_18 = {TAG_STR, 16, {(const uint8_t *)"SPar is deferred"}};
static Str S_19 = {TAG_STR, 3, {(const uint8_t *)"snu"}};
static Str S_20 = {TAG_STR, 15, {(const uint8_t *)"SNu is deferred"}};
static Str S_21 = {TAG_STR, 29, {(const uint8_t *)"no kernel negative is named \042"}};
static Str S_22 = {TAG_STR, 1653, {(const uint8_t *)"\012mu N : Type 0 with | zero : N | succ : N -> N\012mu A : Type 0 with | leaf : A | node : B -> A\012and B : Type 0 with | cons : A -> B\012mu V : (0 i : N) -> Type 0 with\012| vz : V zero\012| vs : (0 i : N) -> V i -> V (succ i)\012def rec length : (0 i : N) -> V i -> N := fun (0 i : N) (v : V i) => case v as x in V j return N with | vz => zero | vs 0 j w => succ (length j w)\012def rec double : N -> N := fun (n : N) => case n as x in N return N with | zero => zero | succ m => succ (succ (double m))\012def rec sizeA : A -> Nat := fun (a : A) => case a as x in A return Nat with | leaf => 0 | node b => natAdd 1 (sizeB b)\012and sizeB : B -> Nat := fun (b : B) => case b as x in B return Nat with | cons a => natAdd 1 (sizeA a)\012def rec f : N -> N := fun (n : N) => case n as x in N return N with | zero => zero | succ m => g m\012and g : N -> N := fun (n : N) => zero\012and spare : N := zero\012def rec keep : Nat -> N -> Nat := fun (a : Nat) => fun (n : N) => case n as x in N return Nat with | zero => a | succ m => keep a m\012def rec choose : N -> Nat -> Nat := fun (n : N) => case n as x in N return (Nat -> Nat) with | zero => fun (a : Nat) => a | succ m => choose m\012def doubled : N := double (succ (succ zero))\012def four : N := succ (succ (succ (succ zero)))\012def z : N := zero\012def mutualValue : Nat := sizeA (node (cons leaf))\012def two : Nat := 2\012def helper : N := f (succ zero)\012def helperDirect : N := g zero\012def kept : Nat := keep 7 (succ (succ zero))\012def seven : Nat := 7\012def chosen : Nat := choose (succ (succ zero)) 7\012def indexed : N := length (succ zero) (vs zero vz)\012def one : N := succ zero\012def partial : N -> Nat := keep 7\012def neutral : N -> Nat := fun (n : N) => keep 7 n\012"}};
static V lam_751(V *env, V *args) {
  (void)env; (void)args;
  V local16204_738 = args[0];
  return ({ V _r = 0; V m_739 = d_Eval_deval(env[0], NIL, rt_ctor1(10, local16204_738)); switch (tag_of(m_739)) { case 1: { V _m_739_a0_740 = FLD(m_739, 0); _r = ({ V item16213_741 = _m_739_a0_740; ({ V local16207_742 = item16213_741; ({ V _r = 0; V m_743 = d_Eval_dquote(env[0], d_Big_dzero(), local16207_742); switch (tag_of(m_743)) { case 1: { V _m_743_a0_744 = FLD(m_743, 0); _r = ({ V item16211_745 = _m_743_a0_744; ({ V local16210_746 = item16211_745; DONE(d_Pp_dterm(NIL, local16210_746)); }); }); break; } case 0: { V _m_743_a0_747 = FLD(m_743, 0); _r = ({ V item16212_748 = _m_743_a0_747; FAIL(item16212_748); }); break; } default: rt_panic("match: no case at tests:462"); } _r; }); }); }); break; } case 0: { V _m_739_a0_749 = FLD(m_739, 0); _r = ({ V item16214_750 = _m_739_a0_749; FAIL(item16214_750); }); break; } default: rt_panic("match: no case at tests:462"); } _r; });
}
static Str S_23 = {TAG_STR, 18, {(const uint8_t *)" did not compute: "}};
static V lam_780(V *env, V *args) {
  (void)env; (void)args;
  V local16218_753 = args[0];
  V local16220_754 = args[1];
  return ({ V scrut16221_755 = local16220_754; ({ V _r = 0; V m_756 = scrut16221_755; if ((tag_of(m_756) == 0)) { V _m_756_a0_757 = FLD(m_756, 0); V _m_756_a1_758 = FLD(m_756, 1); _r = ({ V p16222_759 = _m_756_a0_757; ({ V p16223_760 = _m_756_a1_758; ({ V _r = 0; V m_761 = local16218_753; switch (tag_of(m_761)) { case 1: { V _m_761_a0_762 = FLD(m_761, 0); _r = ({ V item16238_763 = _m_761_a0_762; ({ V local16226_764 = item16238_763; ({ V scrut16227_765 = local16226_764; ({ V _r = 0; V m_766 = ap(env[0], p16222_759); switch (tag_of(m_766)) { case 1: { V _m_766_a0_767 = FLD(m_766, 0); _r = ({ V item16236_768 = _m_766_a0_767; ({ V local16230_769 = item16236_768; ({ V _r = 0; V m_770 = ap(env[0], p16223_760); switch (tag_of(m_770)) { case 1: { V _m_770_a0_771 = FLD(m_770, 0); _r = ({ V item16234_772 = _m_770_a0_771; ({ V local16233_773 = item16234_772; ((d_NativeString_dequal(local16230_769, local16233_773)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, str_append(p16222_759, str_append(((V)&S_23), local16230_769))))); }); }); break; } case 0: { V _m_770_a0_774 = FLD(m_770, 0); _r = ({ V item16235_775 = _m_770_a0_774; FAIL(item16235_775); }); break; } default: rt_panic("match: no case at tests:465"); } _r; }); }); }); break; } case 0: { V _m_766_a0_776 = FLD(m_766, 0); _r = ({ V item16237_777 = _m_766_a0_776; FAIL(item16237_777); }); break; } default: rt_panic("match: no case at tests:465"); } _r; }); }); }); }); break; } case 0: { V _m_761_a0_778 = FLD(m_761, 0); _r = ({ V item16239_779 = _m_761_a0_778; FAIL(item16239_779); }); break; } default: rt_panic("match: no case at tests:464"); } _r; }); }); }); } else rt_panic("match: no case at tests:464"); _r; }); });
}
static Str S_24 = {TAG_STR, 7, {(const uint8_t *)"doubled"}};
static Str S_25 = {TAG_STR, 4, {(const uint8_t *)"four"}};
static Str S_26 = {TAG_STR, 11, {(const uint8_t *)"mutualValue"}};
static Str S_27 = {TAG_STR, 3, {(const uint8_t *)"two"}};
static Str S_28 = {TAG_STR, 6, {(const uint8_t *)"helper"}};
static Str S_29 = {TAG_STR, 1, {(const uint8_t *)"z"}};
static Str S_30 = {TAG_STR, 12, {(const uint8_t *)"helperDirect"}};
static Str S_31 = {TAG_STR, 5, {(const uint8_t *)"spare"}};
static Str S_32 = {TAG_STR, 4, {(const uint8_t *)"kept"}};
static Str S_33 = {TAG_STR, 5, {(const uint8_t *)"seven"}};
static Str S_34 = {TAG_STR, 6, {(const uint8_t *)"chosen"}};
static Str S_35 = {TAG_STR, 7, {(const uint8_t *)"indexed"}};
static Str S_36 = {TAG_STR, 3, {(const uint8_t *)"one"}};
static Str S_37 = {TAG_STR, 37, {(const uint8_t *)" unfolded before its guarded argument"}};
static V lam_801(V *env, V *args) {
  (void)env; (void)args;
  V local16245_786 = args[0];
  V local16247_787 = args[1];
  return ({ V _r = 0; V m_788 = local16245_786; switch (tag_of(m_788)) { case 1: { V _m_788_a0_789 = FLD(m_788, 0); _r = ({ V item16257_790 = _m_788_a0_789; ({ V local16250_791 = item16257_790; ({ V scrut16251_792 = local16250_791; ({ V _r = 0; V m_793 = d_Eval_deval(env[0], NIL, rt_ctor1(10, local16247_787)); switch (tag_of(m_793)) { case 1: { V _m_793_a0_794 = FLD(m_793, 0); _r = ({ V item16255_795 = _m_793_a0_794; ({ V local16254_796 = item16255_795; ((((V)maybe_is_some(d_Value_das_uneutral(local16254_796)))) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, str_append(local16247_787, ((V)&S_37))))); }); }); break; } case 0: { V _m_793_a0_797 = FLD(m_793, 0); _r = ({ V item16256_798 = _m_793_a0_797; FAIL(item16256_798); }); break; } default: rt_panic("match: no case at tests:467"); } _r; }); }); }); }); break; } case 0: { V _m_788_a0_799 = FLD(m_788, 0); _r = ({ V item16258_800 = _m_788_a0_799; FAIL(item16258_800); }); break; } default: rt_panic("match: no case at tests:466"); } _r; });
}
static Str S_38 = {TAG_STR, 6, {(const uint8_t *)"double"}};
static Str S_39 = {TAG_STR, 4, {(const uint8_t *)"keep"}};
static Str S_40 = {TAG_STR, 7, {(const uint8_t *)"partial"}};
static Str S_41 = {TAG_STR, 7, {(const uint8_t *)"neutral"}};
static Str S_42 = {TAG_STR, 14, {(const uint8_t *)"neutral lambda"}};
static Str S_43 = {TAG_STR, 11, {(const uint8_t *)"neutral leg"}};
static Str S_44 = {TAG_STR, 45, {(const uint8_t *)"recursive call unfolded on a neutral argument"}};
static Str S_45 = {TAG_STR, 17, {(const uint8_t *)"double definition"}};
static Str S_46 = {TAG_STR, 50, {(const uint8_t *)"an explicitly opaque recursive definition unfolded"}};
static V lam_888(V *env, V *args) {
  (void)env; (void)args;
  V local16195_725 = args[0];
  return ({ V scrut16196_726 = local16195_725; ({ V _r = 0; V m_727 = d_Elab_dcheck_uin(NONE, d_Global_dinitial(), env[0]); switch (tag_of(m_727)) { case 1: { V _m_727_a0_728 = FLD(m_727, 0); _r = ({ V item16327_729 = _m_727_a0_728; ({ V local16199_730 = item16327_729; ({ V scrut16200_731 = local16199_730; ({ V _r = 0; V m_732 = scrut16200_731; if ((tag_of(m_732) == 0)) { V _m_732_a0_733 = FLD(m_732, 0); V _m_732_a1_734 = FLD(m_732, 1); _r = ({ V p16201_735 = _m_732_a0_733; ({ V p16202_736 = _m_732_a1_734; ({ V scrut16215_737 = ({ V _c = clo_new(lam_751, 1, 1); CLO_ENV(_c)[0] = p16201_735; _c; }); ({ V _r = 0; V m_752 = d_SeqList_dfold(({ V _c = clo_new(lam_780, 2, 1); CLO_ENV(_c)[0] = scrut16215_737; _c; }), CON(rt_ctor2(0, ((V)&S_24), ((V)&S_25)), CON(rt_ctor2(0, ((V)&S_26), ((V)&S_27)), CON(rt_ctor2(0, ((V)&S_28), ((V)&S_29)), CON(rt_ctor2(0, ((V)&S_30), ((V)&S_29)), CON(rt_ctor2(0, ((V)&S_31), ((V)&S_29)), CON(rt_ctor2(0, ((V)&S_32), ((V)&S_33)), CON(rt_ctor2(0, ((V)&S_34), ((V)&S_33)), CON(rt_ctor2(0, ((V)&S_35), ((V)&S_36)), NIL)))))))), DONE(UNIT)); switch (tag_of(m_752)) { case 1: { V _m_752_a0_781 = FLD(m_752, 0); _r = ({ V item16324_782 = _m_752_a0_781; ({ V local16241_783 = item16324_782; ({ V scrut16242_784 = local16241_783; ({ V _r = 0; V m_785 = d_SeqList_dfold(({ V _c = clo_new(lam_801, 2, 1); CLO_ENV(_c)[0] = p16201_735; _c; }), CON(((V)&S_38), CON(((V)&S_39), CON(((V)&S_40), NIL))), DONE(UNIT)); switch (tag_of(m_785)) { case 1: { V _m_785_a0_802 = FLD(m_785, 0); _r = ({ V item16321_803 = _m_785_a0_802; ({ V local16260_804 = item16321_803; ({ V scrut16261_805 = local16260_804; ({ V _r = 0; V m_806 = d_Eval_deval(p16201_735, NIL, rt_ctor1(10, ((V)&S_41))); switch (tag_of(m_806)) { case 1: { V _m_806_a0_807 = FLD(m_806, 0); _r = ({ V item16319_808 = _m_806_a0_807; ({ V local16264_809 = item16319_808; ({ V _r = 0; V m_810 = ({ V local16268_811 = d_Value_das_usec(local16264_809); ({ V _r = 0; V m_812 = local16268_811; if (((m_812) == NONE)) {  _r = ({ V __813 = UNIT; FAIL(rt_ctor1(4, ((V)&S_42))); }); } else if (((m_812) != NONE)) { V _m_812_a0_814 = FLD(m_812, 0); _r = ({ V x_815 = _m_812_a0_814; DONE(x_815); }); } else rt_panic("match: no case at tests:468"); _r; }); }); switch (tag_of(m_810)) { case 1: { V _m_810_a0_816 = FLD(m_810, 0); _r = ({ V item16317_817 = _m_810_a0_816; ({ V local16270_818 = item16317_817; ({ V scrut16271_819 = local16270_818; ({ V _r = 0; V m_820 = scrut16271_819; if ((tag_of(m_820) == 0)) { V _m_820_a0_821 = FLD(m_820, 0); V _m_820_a1_822 = FLD(m_820, 1); _r = ({ V p16272_823 = _m_820_a0_821; ({ V p16273_824 = _m_820_a1_822; ({ V _r = 0; V m_825 = ({ V local16277_826 = d_Rules_done_uof(p16273_824); ({ V _r = 0; V m_827 = local16277_826; if (((m_827) == NONE)) {  _r = ({ V __828 = UNIT; FAIL(rt_ctor1(4, ((V)&S_43))); }); } else if (((m_827) != NONE)) { V _m_827_a0_829 = FLD(m_827, 0); _r = ({ V x_830 = _m_827_a0_829; DONE(x_830); }); } else rt_panic("match: no case at tests:469"); _r; }); }); switch (tag_of(m_825)) { case 1: { V _m_825_a0_831 = FLD(m_825, 0); _r = ({ V item16314_832 = _m_825_a0_831; ({ V local16279_833 = item16314_832; ({ V _r = 0; V m_834 = d_Rules_dopen_uclosure(d_Eval_dev(p16201_735), d_Get_dValue_dVleg_dvl_uclo(local16279_833), CON(d_Value_dvar(d_Big_dzero()), NIL)); switch (tag_of(m_834)) { case 1: { V _m_834_a0_835 = FLD(m_834, 0); _r = ({ V item16312_836 = _m_834_a0_835; ({ V local16282_837 = item16312_836; ({ V _r = 0; V m_838 = ((((V)maybe_is_some(d_Value_das_uneutral(local16282_837)))) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, ((V)&S_44)))); switch (tag_of(m_838)) { case 1: { V _m_838_a0_839 = FLD(m_838, 0); _r = ({ V item16310_840 = _m_838_a0_839; ({ V local16285_841 = item16310_840; ({ V scrut16286_842 = local16285_841; ({ V _r = 0; V m_843 = ({ V local16290_844 = d_Global_dfind(((V)&S_38), p16201_735); ({ V _r = 0; V m_845 = local16290_844; if (((m_845) == NONE)) {  _r = ({ V __846 = UNIT; FAIL(rt_ctor1(3, ((V)&S_38))); }); } else if (((m_845) != NONE)) { V _m_845_a0_847 = FLD(m_845, 0); _r = ({ V x_848 = _m_845_a0_847; DONE(x_848); }); } else rt_panic("match: no case at tests:470"); _r; }); }); switch (tag_of(m_843)) { case 1: { V _m_843_a0_849 = FLD(m_843, 0); _r = ({ V item16307_850 = _m_843_a0_849; ({ V local16292_851 = item16307_850; ({ V _r = 0; V m_852 = ({ V local16296_853 = d_Global_ddef_uof(local16292_851); ({ V _r = 0; V m_854 = local16296_853; if (((m_854) == NONE)) {  _r = ({ V __855 = UNIT; FAIL(rt_ctor1(4, ((V)&S_45))); }); } else if (((m_854) != NONE)) { V _m_854_a0_856 = FLD(m_854, 0); _r = ({ V x_857 = _m_854_a0_856; DONE(x_857); }); } else rt_panic("match: no case at tests:470"); _r; }); }); switch (tag_of(m_852)) { case 1: { V _m_852_a0_858 = FLD(m_852, 0); _r = ({ V item16305_859 = _m_852_a0_858; ({ V local16298_860 = item16305_859; ({ V scrut16299_861 = d_Global_dadd(((V)&S_38), rt_ctor1(0, ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dGlobal_dDef_uentry_dty(local16298_860); _o->f[1] = d_Get_dGlobal_dDef_uentry_ddef(local16298_860); _o->f[2] = FALSE_V; _o->f[3] = d_Get_dGlobal_dDef_uentry_drec_uarg(local16298_860); _o->f[4] = d_Get_dGlobal_dDef_uentry_dpartial(local16298_860); (V)_o; })), p16201_735); ({ V _r = 0; V m_862 = d_Eval_deval(scrut16299_861, NIL, rt_ctor1(10, ((V)&S_24))); switch (tag_of(m_862)) { case 1: { V _m_862_a0_863 = FLD(m_862, 0); _r = ({ V item16303_864 = _m_862_a0_863; ({ V local16302_865 = item16303_864; ((((V)maybe_is_some(d_Value_das_uneutral(local16302_865)))) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, ((V)&S_46)))); }); }); break; } case 0: { V _m_862_a0_866 = FLD(m_862, 0); _r = ({ V item16304_867 = _m_862_a0_866; FAIL(item16304_867); }); break; } default: rt_panic("match: no case at tests:471"); } _r; }); }); }); }); break; } case 0: { V _m_852_a0_868 = FLD(m_852, 0); _r = ({ V item16306_869 = _m_852_a0_868; FAIL(item16306_869); }); break; } default: rt_panic("match: no case at tests:470"); } _r; }); }); }); break; } case 0: { V _m_843_a0_870 = FLD(m_843, 0); _r = ({ V item16308_871 = _m_843_a0_870; FAIL(item16308_871); }); break; } default: rt_panic("match: no case at tests:470"); } _r; }); }); }); }); break; } case 0: { V _m_838_a0_872 = FLD(m_838, 0); _r = ({ V item16311_873 = _m_838_a0_872; FAIL(item16311_873); }); break; } default: rt_panic("match: no case at tests:469"); } _r; }); }); }); break; } case 0: { V _m_834_a0_874 = FLD(m_834, 0); _r = ({ V item16313_875 = _m_834_a0_874; FAIL(item16313_875); }); break; } default: rt_panic("match: no case at tests:469"); } _r; }); }); }); break; } case 0: { V _m_825_a0_876 = FLD(m_825, 0); _r = ({ V item16315_877 = _m_825_a0_876; FAIL(item16315_877); }); break; } default: rt_panic("match: no case at tests:469"); } _r; }); }); }); } else rt_panic("match: no case at tests:469"); _r; }); }); }); }); break; } case 0: { V _m_810_a0_878 = FLD(m_810, 0); _r = ({ V item16318_879 = _m_810_a0_878; FAIL(item16318_879); }); break; } default: rt_panic("match: no case at tests:468"); } _r; }); }); }); break; } case 0: { V _m_806_a0_880 = FLD(m_806, 0); _r = ({ V item16320_881 = _m_806_a0_880; FAIL(item16320_881); }); break; } default: rt_panic("match: no case at tests:468"); } _r; }); }); }); }); break; } case 0: { V _m_785_a0_882 = FLD(m_785, 0); _r = ({ V item16322_883 = _m_785_a0_882; FAIL(item16322_883); }); break; } default: rt_panic("match: no case at tests:466"); } _r; }); }); }); }); break; } case 0: { V _m_752_a0_884 = FLD(m_752, 0); _r = ({ V item16325_885 = _m_752_a0_884; FAIL(item16325_885); }); break; } default: rt_panic("match: no case at tests:463"); } _r; }); }); }); }); } else rt_panic("match: no case at tests:462"); _r; }); }); }); }); break; } case 0: { V _m_727_a0_886 = FLD(m_727, 0); _r = ({ V item16328_887 = _m_727_a0_886; FAIL(item16328_887); }); break; } default: rt_panic("match: no case at tests:461"); } _r; }); });
}
static Str S_47 = {TAG_STR, 47, {(const uint8_t *)"mu N : Type 0 := | zero : N | succ (n : N) : N\012"}};
static Str S_48 = {TAG_STR, 52, {(const uint8_t *)"mu N : Type 0 with | zero : N | succ : (n : N) -> N\012"}};
static Str S_49 = {TAG_STR, 29, {(const uint8_t *)"sugar changed the family tree"}};
static Str S_50 = {TAG_STR, 68, {(const uint8_t *)"mutual mu A : Type 0 := | a (b : B) : A mu B : Type 0 := | b : B end"}};
static Str S_51 = {TAG_STR, 65, {(const uint8_t *)"mu A : Type 0 with | a : (b : B) -> A and B : Type 0 with | b : B"}};
static Str S_52 = {TAG_STR, 102, {(const uint8_t *)"def pred : N -> N := fun (n : N) => match n as x in N return N with | zero => zero | succ (p : N) => p"}};
static Str S_53 = {TAG_STR, 95, {(const uint8_t *)"def pred : N -> N := fun (n : N) => case n as x in N return N with | zero => zero | succ p => p"}};
static Str S_54 = {TAG_STR, 33, {(const uint8_t *)"match changed checked elimination"}};
static Str S_55 = {TAG_STR, 2, {(const uint8_t *)"0 "}};
static Str S_56 = {TAG_STR, 2, {(const uint8_t *)"1 "}};
static Str S_57 = {TAG_STR, 1, {(const uint8_t *)"("}};
static Str S_58 = {TAG_STR, 3, {(const uint8_t *)" : "}};
static Str S_59 = {TAG_STR, 1, {(const uint8_t *)")"}};
static Str S_60 = {TAG_STR, 4, {(const uint8_t *)" in "}};
static Str S_61 = {TAG_STR, 1, {(const uint8_t *)" "}};
static V lam_957(V *env, V *args) {
  (void)env; (void)args;
  V local16610_956 = args[0];
  return str_append(((V)&S_61), local16610_956);
}
static Str S_62 = {TAG_STR, 4, {(const uint8_t *)" as "}};
static Str S_63 = {TAG_STR, 8, {(const uint8_t *)" return "}};
static Str S_64 = {TAG_STR, 3, {(const uint8_t *)" | "}};
static V lam_976(V *env, V *args) {
  (void)env; (void)args;
  V local16616_975 = args[0];
  return str_append(((V)&S_61), d_Syntax_dbinder_utext(local16616_975));
}
static Str S_65 = {TAG_STR, 4, {(const uint8_t *)" => "}};
static V w_Syntax_dfield_utext(V *env, V *args) {
  (void)env; (void)args;
  return d_Syntax_dfield_utext(args[0]);
}
static Str S_66 = {TAG_STR, 4, {(const uint8_t *)"Prop"}};
static Str S_67 = {TAG_STR, 5, {(const uint8_t *)"Type "}};
static Str S_68 = {TAG_STR, 2, {(const uint8_t *)"()"}};
static Str S_69 = {TAG_STR, 4, {(const uint8_t *)"auto"}};
static Str S_70 = {TAG_STR, 2, {(const uint8_t *)", "}};
static Str S_71 = {TAG_STR, 7, {(const uint8_t *)"tuple ("}};
static V lam_1004(V *env, V *args) {
  (void)env; (void)args;
  V local16568_1003 = args[0];
  return d_Syntax_dat(d_Big_dzero(), local16568_1003);
}
static Str S_72 = {TAG_STR, 5, {(const uint8_t *)"sum ("}};
static V lam_1008(V *env, V *args) {
  (void)env; (void)args;
  V local16572_1007 = args[0];
  return d_Syntax_dat(d_Big_dzero(), local16572_1007);
}
static Str S_73 = {TAG_STR, 6, {(const uint8_t *)"prod ("}};
static V lam_1012(V *env, V *args) {
  (void)env; (void)args;
  V local16576_1011 = args[0];
  return d_Syntax_dat(d_Big_dzero(), local16576_1011);
}
static Str S_74 = {TAG_STR, 1, {(const uint8_t *)"."}};
static Str S_75 = {TAG_STR, 4, {(const uint8_t *)"inj "}};
static Str S_76 = {TAG_STR, 4, {(const uint8_t *)" of "}};
static Str S_77 = {TAG_STR, 7, {(const uint8_t *)"absurd "}};
static Str S_78 = {TAG_STR, 4, {(const uint8_t *)"fun "}};
static V w_Syntax_dbinder_utext(V *env, V *args) {
  (void)env; (void)args;
  return d_Syntax_dbinder_utext(args[0]);
}
static Str S_79 = {TAG_STR, 4, {(const uint8_t *)" -> "}};
static Str S_80 = {TAG_STR, 3, {(const uint8_t *)" * "}};
static Str S_81 = {TAG_STR, 4, {(const uint8_t *)"let "}};
static Str S_82 = {TAG_STR, 4, {(const uint8_t *)" := "}};
static Str S_83 = {TAG_STR, 5, {(const uint8_t *)"case "}};
static Str S_84 = {TAG_STR, 5, {(const uint8_t *)" with"}};
static V w_Syntax_dbranch_utext(V *env, V *args) {
  (void)env; (void)args;
  return d_Syntax_dbranch_utext(args[0]);
}
static Str S_85 = {TAG_STR, 6, {(const uint8_t *)"match "}};
static Str S_86 = {TAG_STR, 2, {(const uint8_t *)"| "}};
static Str S_87 = {TAG_STR, 1, {(const uint8_t *)"\012"}};
static V lam_1158(V *env, V *args) {
  (void)env; (void)args;
  V local16674_1157 = args[0];
  return str_append(((V)&S_61), d_Syntax_dbinder_utext(local16674_1157));
}
static Str S_88 = {TAG_STR, 4, {(const uint8_t *)" :=\012"}};
static V w_Syntax_dfam_uctor_utext(V *env, V *args) {
  (void)env; (void)args;
  return d_Syntax_dfam_uctor_utext(args[0]);
}
static Str S_89 = {TAG_STR, 4, {(const uint8_t *)"def "}};
static Str S_90 = {TAG_STR, 6, {(const uint8_t *)"axiom "}};
static Str S_91 = {TAG_STR, 2, {(const uint8_t *)"mu"}};
static Str S_92 = {TAG_STR, 7, {(const uint8_t *)"mutual\012"}};
static V lam_1187(V *env, V *args) {
  (void)env; (void)args;
  V local16679_1186 = args[0];
  return d_Syntax_dfam_utext(((V)&S_91), local16679_1186);
}
static Str S_93 = {TAG_STR, 4, {(const uint8_t *)"end\012"}};
static Str S_94 = {TAG_STR, 7, {(const uint8_t *)"def rec"}};
static Str S_95 = {TAG_STR, 3, {(const uint8_t *)"and"}};
static V lam_1192(V *env, V *args) {
  (void)env; (void)args;
  V local16682_1190 = args[0];
  V local16684_1191 = args[1];
  return str_concat(CON(((d_Big_dis_ueq(local16682_1190, d_Big_dzero())) != FALSE_V ? ((V)&S_94) : ((V)&S_95)), CON(((V)&S_61), CON(d_Get_dSyntax_dRec_udef_drd_uname(local16684_1191), CON(((V)&S_58), CON(d_Syntax_dat(d_Big_dzero(), d_Get_dSyntax_dRec_udef_drd_uty(local16684_1191)), CON(((V)&S_82), CON(d_Syntax_dat(d_Big_dzero(), d_Get_dSyntax_dRec_udef_drd_ubody(local16684_1191)), CON(((V)&S_87), NIL)))))))));
}
static V w_Syntax_ddecl_utext(V *env, V *args) {
  (void)env; (void)args;
  return d_Syntax_ddecl_utext(args[0]);
}
static Str S_96 = {TAG_STR, 20, {(const uint8_t *)"printed tree changed"}};
static Str S_97 = {TAG_STR, 21, {(const uint8_t *)"invalid source parsed"}};
static Str S_98 = {TAG_STR, 17, {(const uint8_t *)"constructor-sugar"}};
static V lam_1219(V *env, V *args) {
  (void)env; (void)args;
  V local16334_1217 = args[0];
  return ({ V scrut16335_1218 = local16334_1217; d_Sl_usurface_dsame_utree(d_Sl_usurface_dfamily(), d_Sl_usurface_dlegacy_ufamily()); });
}
static Str S_99 = {TAG_STR, 12, {(const uint8_t *)"mutual-sugar"}};
static V lam_1222(V *env, V *args) {
  (void)env; (void)args;
  V local16522_1220 = args[0];
  return ({ V scrut16523_1221 = local16522_1220; d_Sl_usurface_dsame_utree(d_Sl_usurface_dmutual(), d_Sl_usurface_dlegacy_umutual()); });
}
static Str S_100 = {TAG_STR, 17, {(const uint8_t *)"match-elaboration"}};
static V lam_1225(V *env, V *args) {
  (void)env; (void)args;
  V local16525_1223 = args[0];
  return ({ V scrut16526_1224 = local16525_1223; d_Sl_usurface_dsame_uchecked(d_Sl_usurface_dmatched(), d_Sl_usurface_dcased()); });
}
static Str S_101 = {TAG_STR, 12, {(const uint8_t *)"mu-roundtrip"}};
static V lam_1228(V *env, V *args) {
  (void)env; (void)args;
  V local16548_1226 = args[0];
  return ({ V scrut16549_1227 = local16548_1226; d_Sl_usurface_dround_utrip(d_Sl_usurface_dfamily()); });
}
static Str S_102 = {TAG_STR, 19, {(const uint8_t *)"legacy-mu-roundtrip"}};
static V lam_1231(V *env, V *args) {
  (void)env; (void)args;
  V local16692_1229 = args[0];
  return ({ V scrut16693_1230 = local16692_1229; d_Sl_usurface_dround_utrip(d_Sl_usurface_dlegacy_ufamily()); });
}
static Str S_103 = {TAG_STR, 16, {(const uint8_t *)"mutual-roundtrip"}};
static V lam_1234(V *env, V *args) {
  (void)env; (void)args;
  V local16695_1232 = args[0];
  return ({ V scrut16696_1233 = local16695_1232; d_Sl_usurface_dround_utrip(d_Sl_usurface_dmutual()); });
}
static Str S_104 = {TAG_STR, 23, {(const uint8_t *)"legacy-mutual-roundtrip"}};
static V lam_1237(V *env, V *args) {
  (void)env; (void)args;
  V local16698_1235 = args[0];
  return ({ V scrut16699_1236 = local16698_1235; d_Sl_usurface_dround_utrip(d_Sl_usurface_dlegacy_umutual()); });
}
static Str S_105 = {TAG_STR, 15, {(const uint8_t *)"match-roundtrip"}};
static V lam_1240(V *env, V *args) {
  (void)env; (void)args;
  V local16701_1238 = args[0];
  return ({ V scrut16702_1239 = local16701_1238; d_Sl_usurface_dround_utrip(d_Sl_usurface_dmatched()); });
}
static Str S_106 = {TAG_STR, 14, {(const uint8_t *)"case-roundtrip"}};
static V lam_1243(V *env, V *args) {
  (void)env; (void)args;
  V local16704_1241 = args[0];
  return ({ V scrut16705_1242 = local16704_1241; d_Sl_usurface_dround_utrip(d_Sl_usurface_dcased()); });
}
static Str S_107 = {TAG_STR, 22, {(const uint8_t *)"mixed-fields-roundtrip"}};
static Str S_108 = {TAG_STR, 81, {(const uint8_t *)"def f : Nat := match n as x in N return Nat with | c (0 i : N) x (1 y : Nat) => y"}};
static V lam_1246(V *env, V *args) {
  (void)env; (void)args;
  V local16707_1244 = args[0];
  return ({ V scrut16708_1245 = local16707_1244; d_Sl_usurface_dround_utrip(((V)&S_108)); });
}
static Str S_109 = {TAG_STR, 22, {(const uint8_t *)"nested-match-roundtrip"}};
static Str S_110 = {TAG_STR, 122, {(const uint8_t *)"def f : Nat := match n as x in N return Nat with | z => 0 | s p => (match p as y in N return Nat with | z => 1 | s q => 2)"}};
static V lam_1249(V *env, V *args) {
  (void)env; (void)args;
  V local16710_1247 = args[0];
  return ({ V scrut16711_1248 = local16710_1247; d_Sl_usurface_dround_utrip(((V)&S_110)); });
}
static Str S_111 = {TAG_STR, 21, {(const uint8_t *)"empty-match-roundtrip"}};
static Str S_112 = {TAG_STR, 107, {(const uint8_t *)"mu Void : Prop := def exFalso : Void -> Type 0 := fun (v : Void) => match v as x in Void return Type 0 with"}};
static V lam_1252(V *env, V *args) {
  (void)env; (void)args;
  V local16713_1250 = args[0];
  return ({ V scrut16714_1251 = local16713_1250; d_Sl_usurface_dround_utrip(((V)&S_112)); });
}
static Str S_113 = {TAG_STR, 22, {(const uint8_t *)"case-numeric-roundtrip"}};
static Str S_114 = {TAG_STR, 64, {(const uint8_t *)"def f : Nat := case b with | 0 (x : Nat) => x | 1 (x : Nat) => x"}};
static V lam_1255(V *env, V *args) {
  (void)env; (void)args;
  V local16716_1253 = args[0];
  return ({ V scrut16717_1254 = local16716_1253; d_Sl_usurface_dround_utrip(((V)&S_114)); });
}
static Str S_115 = {TAG_STR, 21, {(const uint8_t *)"match-numeric-refusal"}};
static Str S_116 = {TAG_STR, 46, {(const uint8_t *)"def f : Nat := match n with | 0 (x : Nat) => x"}};
static Str S_117 = {TAG_STR, 51, {(const uint8_t *)"a match branch keys a constructor, not a leg number"}};
static V lam_1258(V *env, V *args) {
  (void)env; (void)args;
  V local16719_1256 = args[0];
  return ({ V scrut16720_1257 = local16719_1256; d_Sl_usurface_dparse_urefusal(((V)&S_116), ((V)&S_117)); });
}
static Str S_118 = {TAG_STR, 20, {(const uint8_t *)"mutual-empty-refusal"}};
static Str S_119 = {TAG_STR, 10, {(const uint8_t *)"mutual end"}};
static Str S_120 = {TAG_STR, 49, {(const uint8_t *)"a mutual group needs at least two mu declarations"}};
static V lam_1261(V *env, V *args) {
  (void)env; (void)args;
  V local16729_1259 = args[0];
  return ({ V scrut16730_1260 = local16729_1259; d_Sl_usurface_dparse_urefusal(((V)&S_119), ((V)&S_120)); });
}
static Str S_121 = {TAG_STR, 24, {(const uint8_t *)"mutual-singleton-refusal"}};
static Str S_122 = {TAG_STR, 27, {(const uint8_t *)"mutual mu N : Type 0 := end"}};
static V lam_1264(V *env, V *args) {
  (void)env; (void)args;
  V local16732_1262 = args[0];
  return ({ V scrut16733_1263 = local16732_1262; d_Sl_usurface_dparse_urefusal(((V)&S_122), ((V)&S_120)); });
}
static Str S_123 = {TAG_STR, 23, {(const uint8_t *)"mutual-unclosed-refusal"}};
static Str S_124 = {TAG_STR, 40, {(const uint8_t *)"mutual mu A : Type 0 := mu B : Type 0 :="}};
static Str S_125 = {TAG_STR, 60, {(const uint8_t *)"expected 'mu' or 'end' in a mutual group, found end of input"}};
static V lam_1267(V *env, V *args) {
  (void)env; (void)args;
  V local16735_1265 = args[0];
  return ({ V scrut16736_1266 = local16735_1265; d_Sl_usurface_dparse_urefusal(((V)&S_124), ((V)&S_125)); });
}
static Str S_126 = {TAG_STR, 18, {(const uint8_t *)"mutual-and-refusal"}};
static Str S_127 = {TAG_STR, 45, {(const uint8_t *)"mutual mu A : Type 0 := and B : Type 0 := end"}};
static Str S_128 = {TAG_STR, 53, {(const uint8_t *)"expected 'mu' or 'end' in a mutual group, found 'and'"}};
static V lam_1270(V *env, V *args) {
  (void)env; (void)args;
  V local16738_1268 = args[0];
  return ({ V scrut16739_1269 = local16738_1268; d_Sl_usurface_dparse_urefusal(((V)&S_127), ((V)&S_128)); });
}
static Str S_129 = {TAG_STR, 15, {(const uint8_t *)"nu-term-refusal"}};
static Str S_130 = {TAG_STR, 20, {(const uint8_t *)"def f : Type 0 := nu"}};
static Str S_131 = {TAG_STR, 14, {(const uint8_t *)"nu is deferred"}};
static V lam_1273(V *env, V *args) {
  (void)env; (void)args;
  V local16741_1271 = args[0];
  return ({ V scrut16742_1272 = local16741_1271; d_Sl_usurface_dparse_urefusal(((V)&S_130), ((V)&S_131)); });
}
static Str S_132 = {TAG_STR, 22, {(const uint8_t *)"nu-declaration-refusal"}};
static Str S_133 = {TAG_STR, 16, {(const uint8_t *)"nu N : Type 0 :="}};
static V lam_1276(V *env, V *args) {
  (void)env; (void)args;
  V local16744_1274 = args[0];
  return ({ V scrut16745_1275 = local16744_1274; d_Sl_usurface_dparse_urefusal(((V)&S_133), ((V)&S_131)); });
}
static Str S_134 = {TAG_STR, 22, {(const uint8_t *)"level-variable-refusal"}};
static Str S_135 = {TAG_STR, 16, {(const uint8_t *)"axiom A : Type u"}};
static Str S_136 = {TAG_STR, 28, {(const uint8_t *)"level variables are deferred"}};
static V lam_1277(V *env, V *args) {
  (void)env; (void)args;
  return d_Sl_usurface_dparse_urefusal(((V)&S_135), ((V)&S_136));
}
static Str S_137 = {TAG_STR, 5, {(const uint8_t *)"uint8"}};
static Str S_138 = {TAG_STR, 7, {(const uint8_t *)"uint256"}};
static Str S_139 = {TAG_STR, 7, {(const uint8_t *)"address"}};
static Str S_140 = {TAG_STR, 4, {(const uint8_t *)"bool"}};
static Str S_141 = {TAG_STR, 6, {(const uint8_t *)"string"}};
static Str S_142 = {TAG_STR, 12, {(const uint8_t *)"ADAPTER-TYPE"}};
static Str S_143 = {TAG_STR, 1, {(const uint8_t *)"-"}};
static Str S_144 = {TAG_STR, 14, {(const uint8_t *)"ADAPTER-NUMBER"}};
static V lam_1317(V *env, V *args) {
  (void)env; (void)args;
  return d_Local_dAbi_ucodec_ddigits_df16781(d_Big_dzero(), CON(env[0], env[1]));
}
static V lam_1325(V *env, V *args) {
  (void)env; (void)args;
  return ({ V _r = 0; V m_1319 = d_Local_dAbi_ucodec_ddigits_df16781(d_Big_dzero(), env[0]); switch (tag_of(m_1319)) { case 1: { V _m_1319_a0_1320 = FLD(m_1319, 0); _r = ({ V item16793_1321 = _m_1319_a0_1320; ({ V local16792_1322 = item16793_1321; DONE(d_Big_dneg(local16792_1322)); }); }); break; } case 0: { V _m_1319_a0_1323 = FLD(m_1319, 0); _r = ({ V item16794_1324 = _m_1319_a0_1323; FAIL(item16794_1324); }); break; } default: rt_panic("match: no case at tests:593"); } _r; });
}
static Str S_145 = {TAG_STR, 11, {(const uint8_t *)"ADAPTER-HEX"}};
static V lam_1371(V *env, V *args) {
  (void)env; (void)args;
  V local16812_1370 = args[0];
  return ((((((V)((((((V)48u)))) <= ((local16812_1370))))) != FALSE_V ? ((V)(((local16812_1370)) <= (((((V)57u)))))) : FALSE_V)) != FALSE_V ? DONE(d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL((local16812_1370))), d_Big_dof_unat(NAT_SMALL(48ull)))) : ((((((V)((((((V)97u)))) <= ((local16812_1370))))) != FALSE_V ? ((V)(((local16812_1370)) <= (((((V)102u)))))) : FALSE_V)) != FALSE_V ? DONE(d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL((local16812_1370))), d_Big_dof_unat(NAT_SMALL(87ull)))) : FAIL(((V)&S_145))));
}
static Str S_146 = {TAG_STR, 13, {(const uint8_t *)"ADAPTER-UINT8"}};
static Str S_147 = {TAG_STR, 4, {(const uint8_t *)"true"}};
static Str S_148 = {TAG_STR, 5, {(const uint8_t *)"false"}};
static Str S_149 = {TAG_STR, 12, {(const uint8_t *)"ADAPTER-BOOL"}};
static Str S_150 = {TAG_STR, 13, {(const uint8_t *)"ADAPTER-ARITY"}};
static V lam_1448(V *env, V *args) {
  (void)env; (void)args;
  V local16864_1447 = args[0];
  return str_concat(CON(d_NativeString_dpad(NAT_SMALL(2ull), (((V)48u)), d_Big_dhex(d_Big_dof_unat(NAT_SMALL((local16864_1447))), FALSE_V)), NIL));
}
static Str S_151 = {TAG_STR, 6, {(const uint8_t *)"RANGE-"}};
static Str S_152 = {TAG_STR, 9, {(const uint8_t *)"TOO-LARGE"}};
static Str S_153 = {TAG_STR, 9, {(const uint8_t *)"TRUNCATED"}};
static Str S_154 = {TAG_STR, 12, {(const uint8_t *)"INVALID-BOOL"}};
static Str S_155 = {TAG_STR, 14, {(const uint8_t *)"INVALID-OFFSET"}};
static Str S_156 = {TAG_STR, 15, {(const uint8_t *)"NONZERO-PADDING"}};
static Str S_157 = {TAG_STR, 13, {(const uint8_t *)"TRAILING-DATA"}};
static Str S_158 = {TAG_STR, 3, {(const uint8_t *)"OK "}};
static Str S_159 = {TAG_STR, 6, {(const uint8_t *)"ERROR "}};
static V lam_1469(V *env, V *args) {
  (void)env; (void)args;
  V local16868_1461 = args[0];
  return ({ V _r = 0; V m_1462 = local16868_1461; switch (tag_of(m_1462)) { case 1: { V _m_1462_a0_1463 = FLD(m_1462, 0); _r = ({ V x_1464 = _m_1462_a0_1463; ({ V local16870_1465 = x_1464; str_append(((V)&S_158), ap(env[0], local16870_1465)); }); }); break; } case 0: { V _m_1462_a0_1466 = FLD(m_1462, 0); _r = ({ V x_1467 = _m_1462_a0_1466; ({ V local16872_1468 = x_1467; str_append(((V)&S_159), d_Abi_ucodec_derror(local16872_1468)); }); }); break; } default: rt_panic("match: no case at tests:623"); } _r; });
}
static Str S_160 = {TAG_STR, 13, {(const uint8_t *)"ADAPTER-USAGE"}};
static Str S_161 = {TAG_STR, 6, {(const uint8_t *)"encode"}};
static V w_Abi_ucodec_dhex(V *env, V *args) {
  (void)env; (void)args;
  return d_Abi_ucodec_dhex(args[0]);
}
static Str S_162 = {TAG_STR, 6, {(const uint8_t *)"decode"}};
static Str S_163 = {TAG_STR, 1, {(const uint8_t *)"["}};
static V lam_1529(V *env, V *args) {
  (void)env; (void)args;
  V local16886_1528 = args[0];
  return d_Abi_dquote(d_Abi_ucodec_dshow_uvalue(local16886_1528));
}
static Str S_164 = {TAG_STR, 1, {(const uint8_t *)","}};
static Str S_165 = {TAG_STR, 1, {(const uint8_t *)"]"}};
static V lam_1530(V *env, V *args) {
  (void)env; (void)args;
  V local16884_1527 = args[0];
  return str_append(((V)&S_163), str_append(str_join(d_SeqList_dmap(clo_new(lam_1529, 1, 0), local16884_1527), ((V)&S_164)), ((V)&S_165)));
}
static Str S_166 = {TAG_STR, 16, {(const uint8_t *)"\000\001\002\003\004\005\006\007\010\011\012\013\014\015\016\017"}};
static Str S_167 = {TAG_STR, 16, {(const uint8_t *)"\020\021\022\023\024\025\026\027\030\031\032\033\034\035\036\037"}};
static Str S_168 = {TAG_STR, 16, {(const uint8_t *)" !\042#$%&'()*+,-./"}};
static Str S_169 = {TAG_STR, 16, {(const uint8_t *)"0123456789:;<=>\077"}};
static Str S_170 = {TAG_STR, 16, {(const uint8_t *)"@ABCDEFGHIJKLMNO"}};
static Str S_171 = {TAG_STR, 16, {(const uint8_t *)"PQRSTUVWXYZ[\134]^_"}};
static Str S_172 = {TAG_STR, 16, {(const uint8_t *)"`abcdefghijklmno"}};
static Str S_173 = {TAG_STR, 16, {(const uint8_t *)"pqrstuvwxyz{|}~\177"}};
static Str S_174 = {TAG_STR, 16, {(const uint8_t *)"\200\201\202\203\204\205\206\207\210\211\212\213\214\215\216\217"}};
static Str S_175 = {TAG_STR, 16, {(const uint8_t *)"\220\221\222\223\224\225\226\227\230\231\232\233\234\235\236\237"}};
static Str S_176 = {TAG_STR, 16, {(const uint8_t *)"\240\241\242\243\244\245\246\247\250\251\252\253\254\255\256\257"}};
static Str S_177 = {TAG_STR, 16, {(const uint8_t *)"\260\261\262\263\264\265\266\267\270\271\272\273\274\275\276\277"}};
static Str S_178 = {TAG_STR, 16, {(const uint8_t *)"\300\301\302\303\304\305\306\307\310\311\312\313\314\315\316\317"}};
static Str S_179 = {TAG_STR, 16, {(const uint8_t *)"\320\321\322\323\324\325\326\327\330\331\332\333\334\335\336\337"}};
static Str S_180 = {TAG_STR, 16, {(const uint8_t *)"\340\341\342\343\344\345\346\347\350\351\352\353\354\355\356\357"}};
static Str S_181 = {TAG_STR, 16, {(const uint8_t *)"\360\361\362\363\364\365\366\367\370\371\372\373\374\375\376\377"}};
static V lam_1568(V *env, V *args) {
  (void)env; (void)args;
  V local16925_1567 = args[0];
  return d_Big_dis_ueq(d_Big_dof_unat(NAT_SMALL((local16925_1567))), d_NativeInt_dadd(d_NativeInt_dmul(env[0], d_Big_dof_unat(NAT_SMALL(16ull))), env[1]));
}
static V lam_1595(V *env, V *args) {
  (void)env; (void)args;
  return FAIL(((V)2));
}
static Str S_182 = {TAG_STR, 4, {(const uint8_t *)"hash"}};
static Str S_183 = {TAG_STR, 8, {(const uint8_t *)"selector"}};
static V lam_1624(V *env, V *args) {
  (void)env; (void)args;
  V local16946_1623 = args[0];
  return d_Abi_uschema_dp(((V)1), local16946_1623);
}
static V lam_1626(V *env, V *args) {
  (void)env; (void)args;
  V local16950_1625 = args[0];
  return d_Abi_uschema_dp(((V)2), local16950_1625);
}
static Str S_184 = {TAG_STR, 4, {(const uint8_t *)"name"}};
static Str S_185 = {TAG_STR, 6, {(const uint8_t *)"symbol"}};
static Str S_186 = {TAG_STR, 8, {(const uint8_t *)"decimals"}};
static Str S_187 = {TAG_STR, 11, {(const uint8_t *)"totalSupply"}};
static Str S_188 = {TAG_STR, 9, {(const uint8_t *)"balanceOf"}};
static Str S_189 = {TAG_STR, 5, {(const uint8_t *)"owner"}};
static Str S_190 = {TAG_STR, 9, {(const uint8_t *)"allowance"}};
static Str S_191 = {TAG_STR, 7, {(const uint8_t *)"spender"}};
static Str S_192 = {TAG_STR, 8, {(const uint8_t *)"transfer"}};
static Str S_193 = {TAG_STR, 2, {(const uint8_t *)"to"}};
static Str S_194 = {TAG_STR, 5, {(const uint8_t *)"value"}};
static Str S_195 = {TAG_STR, 7, {(const uint8_t *)"approve"}};
static Str S_196 = {TAG_STR, 12, {(const uint8_t *)"transferFrom"}};
static Str S_197 = {TAG_STR, 4, {(const uint8_t *)"from"}};
static Str S_198 = {TAG_STR, 8, {(const uint8_t *)"Transfer"}};
static Str S_199 = {TAG_STR, 8, {(const uint8_t *)"Approval"}};
static V lam_1630(V *env, V *args) {
  (void)env; (void)args;
  V local16942_1629 = args[0];
  return rt_ctor1(1, local16942_1629);
}
static V lam_1638(V *env, V *args) {
  (void)env; (void)args;
  V local16952_1631 = args[0];
  return ({ V scrut16953_1632 = local16952_1631; ({ V _r = 0; V m_1633 = scrut16953_1632; if ((tag_of(m_1633) == 0)) { V _m_1633_a0_1634 = FLD(m_1633, 0); V _m_1633_a1_1635 = FLD(m_1633, 1); _r = ({ V p16954_1636 = _m_1633_a0_1634; ({ V p16955_1637 = _m_1633_a1_1635; rt_ctor3(3, p16954_1636, p16955_1637, FALSE_V); }); }); } else rt_panic("match: no case at tests:681"); _r; }); });
}
static V lam_1641(V *env, V *args) {
  (void)env; (void)args;
  V local16957_1639 = args[0];
  return ({ V scrut16958_1640 = d_Abi_dSchema_dfunction_usignature(local16957_1639); rt_ctor2(0, scrut16958_1640, d_Abi_dquote(d_Keccak_dselector(scrut16958_1640))); });
}
static Str S_200 = {TAG_STR, 1, {(const uint8_t *)"{"}};
static Str S_201 = {TAG_STR, 1, {(const uint8_t *)":"}};
static V lam_1650(V *env, V *args) {
  (void)env; (void)args;
  V local16960_1643 = args[0];
  return ({ V scrut16961_1644 = local16960_1643; ({ V _r = 0; V m_1645 = scrut16961_1644; if ((tag_of(m_1645) == 0)) { V _m_1645_a0_1646 = FLD(m_1645, 0); V _m_1645_a1_1647 = FLD(m_1645, 1); _r = ({ V p16962_1648 = _m_1645_a0_1646; ({ V p16963_1649 = _m_1645_a1_1647; str_append(d_Abi_dquote(p16962_1648), str_append(((V)&S_201), p16963_1649)); }); }); } else rt_panic("match: no case at tests:689"); _r; }); });
}
static Str S_202 = {TAG_STR, 1, {(const uint8_t *)"}"}};
static Str S_203 = {TAG_STR, 2, {(const uint8_t *)"0x"}};
static V lam_1658(V *env, V *args) {
  (void)env; (void)args;
  V local16965_1651 = args[0];
  return ({ V scrut16966_1652 = local16965_1651; ({ V _r = 0; V m_1653 = scrut16966_1652; if ((tag_of(m_1653) == 0)) { V _m_1653_a0_1654 = FLD(m_1653, 0); V _m_1653_a1_1655 = FLD(m_1653, 1); _r = ({ V p16967_1656 = _m_1653_a0_1654; ({ V p16968_1657 = _m_1653_a1_1655; rt_ctor2(0, p16967_1656, d_Abi_dquote(str_append(((V)&S_203), d_Keccak_dkeccak256(d_Abi_dSchema_devent_usignature(p16967_1656, p16968_1657))))); }); }); } else rt_panic("match: no case at tests:693"); _r; }); });
}
static Str S_204 = {TAG_STR, 5, {(const uint8_t *)"write"}};
static Str S_205 = {TAG_STR, 1, {(const uint8_t *)"a"}};
static Str S_206 = {TAG_STR, 1, {(const uint8_t *)"b"}};
static Str S_207 = {TAG_STR, 1, {(const uint8_t *)"c"}};
static Str S_208 = {TAG_STR, 1, {(const uint8_t *)"d"}};
static Str S_209 = {TAG_STR, 8, {(const uint8_t *)"line\012\042\134\001"}};
static Str S_210 = {TAG_STR, 4, {(const uint8_t *)"pair"}};
static Str S_211 = {TAG_STR, 5, {(const uint8_t *)"count"}};
static Str S_212 = {TAG_STR, 8, {(const uint8_t *)"Rejected"}};
static Str S_213 = {TAG_STR, 6, {(const uint8_t *)"reason"}};
static Str S_214 = {TAG_STR, 6, {(const uint8_t *)"caller"}};
static Str S_215 = {TAG_STR, 9, {(const uint8_t *)"Anonymous"}};
static Str S_216 = {TAG_STR, 4, {(const uint8_t *)"text"}};
static Str S_217 = {TAG_STR, 3, {(const uint8_t *)"key"}};
static Str S_218 = {TAG_STR, 7, {(const uint8_t *)"Stopped"}};
static Str S_219 = {TAG_STR, 6, {(const uint8_t *)"Bounds"}};
static Str S_220 = {TAG_STR, 6, {(const uint8_t *)"actual"}};
static Str S_221 = {TAG_STR, 5, {(const uint8_t *)"limit"}};
static Str S_222 = {TAG_STR, 4, {(const uint8_t *)"read"}};
static Str S_223 = {TAG_STR, 6, {(const uint8_t *)"amount"}};
static Str S_224 = {TAG_STR, 3, {(const uint8_t *)"pay"}};
static Str S_225 = {TAG_STR, 4, {(const uint8_t *)"same"}};
static Str S_226 = {TAG_STR, 6, {(const uint8_t *)"before"}};
static Str S_227 = {TAG_STR, 5, {(const uint8_t *)"after"}};
static Str S_228 = {TAG_STR, 7, {(const uint8_t *)"renamed"}};
static Str S_229 = {TAG_STR, 5, {(const uint8_t *)"erc20"}};
static Str S_230 = {TAG_STR, 9, {(const uint8_t *)"selectors"}};
static Str S_231 = {TAG_STR, 6, {(const uint8_t *)"topics"}};
static Str S_232 = {TAG_STR, 4, {(const uint8_t *)"edge"}};
static Str S_233 = {TAG_STR, 5, {(const uint8_t *)"empty"}};
static Str S_234 = {TAG_STR, 6, {(const uint8_t *)"legacy"}};
static Str S_235 = {TAG_STR, 12, {(const uint8_t *)"legacy_empty"}};
static Str S_236 = {TAG_STR, 17, {(const uint8_t *)"legacy_signatures"}};
static V lam_1660(V *env, V *args) {
  (void)env; (void)args;
  V local16970_1659 = args[0];
  return rt_ctor2(0, d_Get_dAbi_dEntry_dname(local16970_1659), d_Abi_dquote(d_Abi_dsignature(local16970_1659)));
}
static Str S_237 = {TAG_STR, 16, {(const uint8_t *)"error_signatures"}};
static V lam_1662(V *env, V *args) {
  (void)env; (void)args;
  V local16972_1661 = args[0];
  return rt_ctor2(0, d_Get_dAbi_dCustom_uerror_derror_uname(local16972_1661), d_Abi_dquote(d_Abi_derror_usignature(local16972_1661)));
}
static Str S_238 = {TAG_STR, 9, {(const uint8_t *)"invariant"}};
static Str S_239 = {TAG_STR, 7, {(const uint8_t *)"changed"}};
static Str S_240 = {TAG_STR, 7, {(const uint8_t *)"padding"}};
static V lam_1681(V *env, V *args) {
  (void)env; (void)args;
  V local16986_1680 = args[0];
  return d_Asm_ucompact_dblock(NONE, NONE, str_append(((V)&S_240), d_Big_dshow(local16986_1680)), rt_ctor1(0, ((V)3)));
}
static Str S_241 = {TAG_STR, 5, {(const uint8_t *)"start"}};
static Str S_242 = {TAG_STR, 6, {(const uint8_t *)"finish"}};
static V lam_1691(V *env, V *args) {
  (void)env; (void)args;
  V local16995_1684 = args[0];
  return ({ V _r = 0; V m_1685 = local16995_1684; switch (tag_of(m_1685)) { case 1: { V _m_1685_a0_1686 = FLD(m_1685, 0); _r = ({ V item16998_1687 = _m_1685_a0_1686; DONE(({ V local16997_1688 = item16998_1687; rt_ctor3(0, d_Asm_dhex(local16997_1688), d_Asm_dlabels(local16997_1688), d_Asm_dheights(local16997_1688)); })); }); break; } case 0: { V _m_1685_a0_1689 = FLD(m_1685, 0); _r = ({ V item16999_1690 = _m_1685_a0_1689; FAIL(item16999_1690); }); break; } default: rt_panic("match: no case at tests:727"); } _r; });
}
static Str S_243 = {TAG_STR, 3, {(const uint8_t *)"yes"}};
static Str S_244 = {TAG_STR, 2, {(const uint8_t *)"no"}};
static Str S_245 = {TAG_STR, 3, {(const uint8_t *)"POP"}};
static Str S_246 = {TAG_STR, 6, {(const uint8_t *)"middle"}};
static Str S_247 = {TAG_STR, 5, {(const uint8_t *)"jump-"}};
static Str S_248 = {TAG_STR, 7, {(const uint8_t *)"branch-"}};
static V lam_1712(V *env, V *args) {
  (void)env; (void)args;
  V local16974_1710 = args[0];
  V local16976_1711 = args[1];
  return d_NativeInt_dadd(d_NativeInt_dadd(local16974_1710, d_Asm_ucompact_dcheck(str_append(((V)&S_247), d_Big_dshow(local16976_1711)), d_Asm_ucompact_djump(d_Big_dof_unat(NAT_SMALL(2ull)), local16976_1711), d_Asm_ucompact_djump(d_Big_done(), local16976_1711))), d_Asm_ucompact_dcheck(str_append(((V)&S_248), d_Big_dshow(local16976_1711)), d_Asm_ucompact_dbranch(d_Big_dof_unat(NAT_SMALL(2ull)), local16976_1711), d_Asm_ucompact_dbranch(d_Big_done(), local16976_1711)));
}
static V lam_1714(V *env, V *args) {
  (void)env; (void)args;
  V local17087_1713 = args[0];
  return local17087_1713;
}
static Str S_249 = {TAG_STR, 12, {(const uint8_t *)"payload-255-"}};
static Str S_250 = {TAG_STR, 12, {(const uint8_t *)"payload-256-"}};
static V lam_1718(V *env, V *args) {
  (void)env; (void)args;
  V local17090_1716 = args[0];
  V local17092_1717 = args[1];
  return d_NativeInt_dadd(d_NativeInt_dadd(local17090_1716, d_Asm_ucompact_dcheck(str_append(((V)&S_249), d_Big_dshow(local17092_1717)), d_Asm_ucompact_dpayload(d_Big_dof_unat(NAT_SMALL(2ull)), d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL(247ull)), local17092_1717), local17092_1717), d_Asm_ucompact_dpayload(d_Big_done(), d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL(247ull)), local17092_1717), local17092_1717))), d_Asm_ucompact_dcheck(str_append(((V)&S_250), d_Big_dshow(local17092_1717)), d_Asm_ucompact_dpayload(d_Big_dof_unat(NAT_SMALL(2ull)), d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL(248ull)), local17092_1717), local17092_1717), d_Asm_ucompact_dpayload(d_Big_done(), d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL(248ull)), local17092_1717), local17092_1717)));
}
static V lam_1720(V *env, V *args) {
  (void)env; (void)args;
  V local17095_1719 = args[0];
  return local17095_1719;
}
static Str S_251 = {TAG_STR, 4, {(const uint8_t *)"stop"}};
static Str S_252 = {TAG_STR, 14, {(const uint8_t *)"unknown-opcode"}};
static Str S_253 = {TAG_STR, 4, {(const uint8_t *)"NOPE"}};
static Str S_254 = {TAG_STR, 9, {(const uint8_t *)"duplicate"}};
static Str S_255 = {TAG_STR, 13, {(const uint8_t *)"missing-label"}};
static Str S_256 = {TAG_STR, 7, {(const uint8_t *)"missing"}};
static Str S_257 = {TAG_STR, 15, {(const uint8_t *)"not-destination"}};
static Str S_258 = {TAG_STR, 12, {(const uint8_t *)"entry-height"}};
static Str S_259 = {TAG_STR, 13, {(const uint8_t *)"invalid-width"}};
static Str S_260 = {TAG_STR, 9, {(const uint8_t *)"underflow"}};
static Str S_261 = {TAG_STR, 12, {(const uint8_t *)"invalid-next"}};
static Str S_262 = {TAG_STR, 5, {(const uint8_t *)"mixed"}};
static V lam_1748(V *env, V *args) {
  (void)env; (void)args;
  V local17128_1738 = args[0];
  V local17130_1739 = args[1];
  return ({ V scrut17131_1740 = local17130_1739; ({ V _r = 0; V m_1741 = scrut17131_1740; if ((tag_of(m_1741) == 0)) { V _m_1741_a0_1742 = FLD(m_1741, 0); V _m_1741_a1_1743 = FLD(m_1741, 1); V _m_1741_a2_1744 = FLD(m_1741, 2); _r = ({ V p17132_1745 = _m_1741_a0_1742; ({ V p17133_1746 = _m_1741_a1_1743; ({ V p17134_1747 = _m_1741_a2_1744; d_NativeInt_dadd(local17128_1738, d_Asm_ucompact_dcheck(p17132_1745, p17133_1746, p17134_1747)); }); }); }); } else rt_panic("match: no case at tests:749"); _r; }); });
}
static Str S_263 = {TAG_STR, 18, {(const uint8_t *)"ASM-COMPACT cases="}};
static Str S_264 = {TAG_STR, 4, {(const uint8_t *)" OK\012"}};
static V lam_1778(V *env, V *args) {
  (void)env; (void)args;
  V local17152_1777 = args[0];
  return rt_ctor1(1, SNIL);
}
static Str S_265 = {TAG_STR, 15, {(const uint8_t *)"accepted; want="}};
static Str S_266 = {TAG_STR, 2, {(const uint8_t *)"2a"}};
static Str S_267 = {TAG_STR, 6, {(const uint8_t *)"SSTORE"}};
static Str S_268 = {TAG_STR, 5, {(const uint8_t *)"guard"}};
static V lam_1796(V *env, V *args) {
  (void)env; (void)args;
  V local17191_1795 = args[0];
  return d_Asm_ucases_dblock(NONE, NONE, str_append(((V)&S_268), d_Big_dshow(local17191_1795)), NIL, rt_ctor1(0, ((V)3)));
}
static Str S_269 = {TAG_STR, 5, {(const uint8_t *)"SLOAD"}};
static Str S_270 = {TAG_STR, 6, {(const uint8_t *)"MSTORE"}};
static Str S_271 = {TAG_STR, 2, {(const uint8_t *)"20"}};
static Str S_272 = {TAG_STR, 5, {(const uint8_t *)"entry"}};
static Str S_273 = {TAG_STR, 2, {(const uint8_t *)"01"}};
static Str S_274 = {TAG_STR, 4, {(const uint8_t *)"join"}};
static Str S_275 = {TAG_STR, 2, {(const uint8_t *)"2b"}};
static Str S_276 = {TAG_STR, 4, {(const uint8_t *)"loop"}};
static Str S_277 = {TAG_STR, 4, {(const uint8_t *)"done"}};
static Str S_278 = {TAG_STR, 6, {(const uint8_t *)"bytes="}};
static V lam_1811(V *env, V *args) {
  (void)env; (void)args;
  V local17223_1810 = args[0];
  return rt_ctor3(0, d_Get_dAsm_dHeight_dincoming(local17223_1810), d_Get_dAsm_dHeight_doutgoing(local17223_1810), d_Get_dAsm_dHeight_dpeak(local17223_1810));
}
static Str S_279 = {TAG_STR, 13, {(const uint8_t *)"EMPTY-PROGRAM"}};
static Str S_280 = {TAG_STR, 11, {(const uint8_t *)"empty-label"}};
static Str S_281 = {TAG_STR, 11, {(const uint8_t *)"EMPTY-LABEL"}};
static Str S_282 = {TAG_STR, 17, {(const uint8_t *)"DUPLICATE-LABEL x"}};
static Str S_283 = {TAG_STR, 14, {(const uint8_t *)"ENTRY-HEIGHT 1"}};
static Str S_284 = {TAG_STR, 15, {(const uint8_t *)"height-negative"}};
static Str S_285 = {TAG_STR, 1, {(const uint8_t *)"y"}};
static Str S_286 = {TAG_STR, 19, {(const uint8_t *)"INVALID-HEIGHT y -1"}};
static Str S_287 = {TAG_STR, 12, {(const uint8_t *)"height-large"}};
static Str S_288 = {TAG_STR, 21, {(const uint8_t *)"INVALID-HEIGHT y 1025"}};
static Str S_289 = {TAG_STR, 13, {(const uint8_t *)"add-underflow"}};
static Str S_290 = {TAG_STR, 3, {(const uint8_t *)"ADD"}};
static Str S_291 = {TAG_STR, 28, {(const uint8_t *)"UNDERFLOW x ADD got=1 need=2"}};
static Str S_292 = {TAG_STR, 16, {(const uint8_t *)"sstore-underflow"}};
static Str S_293 = {TAG_STR, 31, {(const uint8_t *)"UNDERFLOW x SSTORE got=1 need=2"}};
static Str S_294 = {TAG_STR, 13, {(const uint8_t *)"dup-underflow"}};
static Str S_295 = {TAG_STR, 29, {(const uint8_t *)"UNDERFLOW x DUP1 got=0 need=1"}};
static Str S_296 = {TAG_STR, 14, {(const uint8_t *)"swap-underflow"}};
static Str S_297 = {TAG_STR, 30, {(const uint8_t *)"UNDERFLOW x SWAP1 got=1 need=2"}};
static Str S_298 = {TAG_STR, 13, {(const uint8_t *)"push-overflow"}};
static Str S_299 = {TAG_STR, 25, {(const uint8_t *)"OVERFLOW x PUSH0 got=1025"}};
static Str S_300 = {TAG_STR, 12, {(const uint8_t *)"dup-overflow"}};
static Str S_301 = {TAG_STR, 24, {(const uint8_t *)"OVERFLOW x DUP1 got=1025"}};
static Str S_302 = {TAG_STR, 13, {(const uint8_t *)"goto-overflow"}};
static Str S_303 = {TAG_STR, 30, {(const uint8_t *)"OVERFLOW x PUSH-label got=1025"}};
static Str S_304 = {TAG_STR, 15, {(const uint8_t *)"branch-overflow"}};
static Str S_305 = {TAG_STR, 16, {(const uint8_t *)"branch-underflow"}};
static Str S_306 = {TAG_STR, 30, {(const uint8_t *)"UNDERFLOW x JUMPI got=1 need=2"}};
static Str S_307 = {TAG_STR, 16, {(const uint8_t *)"return-underflow"}};
static Str S_308 = {TAG_STR, 31, {(const uint8_t *)"UNDERFLOW x RETURN got=1 need=2"}};
static Str S_309 = {TAG_STR, 16, {(const uint8_t *)"revert-underflow"}};
static Str S_310 = {TAG_STR, 31, {(const uint8_t *)"UNDERFLOW x REVERT got=0 need=2"}};
static Str S_311 = {TAG_STR, 22, {(const uint8_t *)"selfdestruct-underflow"}};
static Str S_312 = {TAG_STR, 37, {(const uint8_t *)"UNDERFLOW x SELFDESTRUCT got=0 need=1"}};
static Str S_313 = {TAG_STR, 13, {(const uint8_t *)"unknown-label"}};
static Str S_314 = {TAG_STR, 15, {(const uint8_t *)"UNKNOWN-LABEL y"}};
static Str S_315 = {TAG_STR, 17, {(const uint8_t *)"NOT-DESTINATION y"}};
static Str S_316 = {TAG_STR, 11, {(const uint8_t *)"goto-height"}};
static Str S_317 = {TAG_STR, 32, {(const uint8_t *)"HEIGHT-MISMATCH x y got=1 want=0"}};
static Str S_318 = {TAG_STR, 17, {(const uint8_t *)"branch-yes-height"}};
static Str S_319 = {TAG_STR, 32, {(const uint8_t *)"HEIGHT-MISMATCH x y got=0 want=1"}};
static Str S_320 = {TAG_STR, 16, {(const uint8_t *)"branch-no-height"}};
static Str S_321 = {TAG_STR, 32, {(const uint8_t *)"HEIGHT-MISMATCH x z got=0 want=1"}};
static Str S_322 = {TAG_STR, 11, {(const uint8_t *)"next-height"}};
static Str S_323 = {TAG_STR, 10, {(const uint8_t *)"next-order"}};
static Str S_324 = {TAG_STR, 16, {(const uint8_t *)"INVALID-NEXT x z"}};
static Str S_325 = {TAG_STR, 9, {(const uint8_t *)"next-last"}};
static Str S_326 = {TAG_STR, 16, {(const uint8_t *)"INVALID-NEXT x x"}};
static Str S_327 = {TAG_STR, 21, {(const uint8_t *)"unreachable-underflow"}};
static Str S_328 = {TAG_STR, 28, {(const uint8_t *)"UNDERFLOW y ADD got=0 need=2"}};
static Str S_329 = {TAG_STR, 3, {(const uint8_t *)"clz"}};
static Str S_330 = {TAG_STR, 3, {(const uint8_t *)"CLZ"}};
static Str S_331 = {TAG_STR, 18, {(const uint8_t *)"UNKNOWN-OPCODE CLZ"}};
static Str S_332 = {TAG_STR, 11, {(const uint8_t *)"opcode-case"}};
static Str S_333 = {TAG_STR, 3, {(const uint8_t *)"add"}};
static Str S_334 = {TAG_STR, 18, {(const uint8_t *)"UNKNOWN-OPCODE add"}};
static Str S_335 = {TAG_STR, 11, {(const uint8_t *)"opcode-push"}};
static Str S_336 = {TAG_STR, 5, {(const uint8_t *)"PUSH0"}};
static Str S_337 = {TAG_STR, 20, {(const uint8_t *)"UNKNOWN-OPCODE PUSH0"}};
static Str S_338 = {TAG_STR, 17, {(const uint8_t *)"label-width-small"}};
static Str S_339 = {TAG_STR, 15, {(const uint8_t *)"INVALID-WIDTH 0"}};
static Str S_340 = {TAG_STR, 17, {(const uint8_t *)"label-width-large"}};
static Str S_341 = {TAG_STR, 16, {(const uint8_t *)"INVALID-WIDTH 33"}};
static Str S_342 = {TAG_STR, 14, {(const uint8_t *)"label-overflow"}};
static Str S_343 = {TAG_STR, 22, {(const uint8_t *)"LABEL-OVERFLOW y PUSH1"}};
static Str S_344 = {TAG_STR, 1, {(const uint8_t *)"0"}};
static Str S_345 = {TAG_STR, 2, {(const uint8_t *)"gg"}};
static Str S_346 = {TAG_STR, 2, {(const uint8_t *)"AA"}};
static Str S_347 = {TAG_STR, 4, {(const uint8_t *)"0x00"}};
static Str S_348 = {TAG_STR, 9, {(const uint8_t *)"push-bad-"}};
static Str S_349 = {TAG_STR, 13, {(const uint8_t *)"INVALID-PUSH "}};
static V lam_1819(V *env, V *args) {
  (void)env; (void)args;
  V local17158_1817 = args[0];
  V local17160_1818 = args[1];
  return rt_ctor3(0, str_append(((V)&S_348), d_Big_dshow(local17158_1817)), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(1, local17160_1818), NIL)), NIL), str_append(((V)&S_349), local17160_1818));
}
static Str S_350 = {TAG_STR, 8, {(const uint8_t *)"dup-bad-"}};
static Str S_351 = {TAG_STR, 18, {(const uint8_t *)"INVALID-DEPTH DUP "}};
static Str S_352 = {TAG_STR, 9, {(const uint8_t *)"swap-bad-"}};
static Str S_353 = {TAG_STR, 19, {(const uint8_t *)"INVALID-DEPTH SWAP "}};
static V lam_1823(V *env, V *args) {
  (void)env; (void)args;
  V local17166_1822 = args[0];
  return CON(rt_ctor3(0, str_append(((V)&S_350), d_Big_dshow(local17166_1822)), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(2, local17166_1822), NIL)), NIL), str_concat(CON(((V)&S_351), CON(d_Big_dshow(local17166_1822), NIL)))), CON(rt_ctor3(0, str_append(((V)&S_352), d_Big_dshow(local17166_1822)), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(3, local17166_1822), NIL)), NIL), str_concat(CON(((V)&S_353), CON(d_Big_dshow(local17166_1822), NIL)))), NIL));
}
static Str S_354 = {TAG_STR, 4, {(const uint8_t *)"STOP"}};
static Str S_355 = {TAG_STR, 4, {(const uint8_t *)"JUMP"}};
static Str S_356 = {TAG_STR, 5, {(const uint8_t *)"JUMPI"}};
static Str S_357 = {TAG_STR, 8, {(const uint8_t *)"JUMPDEST"}};
static Str S_358 = {TAG_STR, 6, {(const uint8_t *)"RETURN"}};
static Str S_359 = {TAG_STR, 6, {(const uint8_t *)"REVERT"}};
static Str S_360 = {TAG_STR, 7, {(const uint8_t *)"INVALID"}};
static Str S_361 = {TAG_STR, 12, {(const uint8_t *)"SELFDESTRUCT"}};
static Str S_362 = {TAG_STR, 5, {(const uint8_t *)"body-"}};
static Str S_363 = {TAG_STR, 16, {(const uint8_t *)"CONTROL-IN-BODY "}};
static V lam_1827(V *env, V *args) {
  (void)env; (void)args;
  V local17172_1826 = args[0];
  return rt_ctor3(0, str_append(((V)&S_362), local17172_1826), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(0, local17172_1826), NIL)), NIL), str_append(((V)&S_363), local17172_1826));
}
static V lam_1838(V *env, V *args) {
  (void)env; (void)args;
  V local17175_1829 = args[0];
  return ({ V scrut17176_1830 = local17175_1829; ({ V _r = 0; V m_1831 = scrut17176_1830; if ((tag_of(m_1831) == 0)) { V _m_1831_a0_1832 = FLD(m_1831, 0); V _m_1831_a1_1833 = FLD(m_1831, 1); V _m_1831_a2_1834 = FLD(m_1831, 2); _r = ({ V p17177_1835 = _m_1831_a0_1832; ({ V p17178_1836 = _m_1831_a1_1833; ({ V p17179_1837 = _m_1831_a2_1834; rt_ctor2(0, d_Asm_ucases_drejection(p17177_1835, p17178_1836, p17179_1837), d_Big_dzero()); }); }); }); } else rt_panic("match: no case at tests:803"); _r; }); });
}
static Str S_364 = {TAG_STR, 5, {(const uint8_t *)"ref20"}};
static Str S_365 = {TAG_STR, 40, {(const uint8_t *)"602a5f55600b56fefefefe5b5f545f5260205ff3"}};
static Str S_366 = {TAG_STR, 7, {(const uint8_t *)"diamond"}};
static Str S_367 = {TAG_STR, 40, {(const uint8_t *)"6001600857600e565b602a6011565b602b5b5000"}};
static Str S_368 = {TAG_STR, 26, {(const uint8_t *)"5b60016100005761000b565b00"}};
static Str S_369 = {TAG_STR, 9, {(const uint8_t *)"push-zero"}};
static Str S_370 = {TAG_STR, 2, {(const uint8_t *)"00"}};
static Str S_371 = {TAG_STR, 8, {(const uint8_t *)"5f600000"}};
static Str S_372 = {TAG_STR, 11, {(const uint8_t *)"stack-limit"}};
static Str S_373 = {TAG_STR, 2, {(const uint8_t *)"5f"}};
static V lam_1841(V *env, V *args) {
  (void)env; (void)args;
  V local17193_1840 = args[0];
  return ((V)&S_373);
}
static Str S_374 = {TAG_STR, 4, {(const uint8_t *)"9f00"}};
static Str S_375 = {TAG_STR, 8, {(const uint8_t *)"label-32"}};
static Str S_376 = {TAG_STR, 2, {(const uint8_t *)"7f"}};
static Str S_377 = {TAG_STR, 8, {(const uint8_t *)"22565b00"}};
static Str S_378 = {TAG_STR, 6, {(const uint8_t *)"revert"}};
static Str S_379 = {TAG_STR, 6, {(const uint8_t *)"5f5ffd"}};
static Str S_380 = {TAG_STR, 12, {(const uint8_t *)"selfdestruct"}};
static Str S_381 = {TAG_STR, 4, {(const uint8_t *)"5fff"}};
static Str S_382 = {TAG_STR, 13, {(const uint8_t *)"next-unmarked"}};
static V lam_1852(V *env, V *args) {
  (void)env; (void)args;
  V local17196_1843 = args[0];
  return ({ V scrut17197_1844 = local17196_1843; ({ V _r = 0; V m_1845 = scrut17197_1844; if ((tag_of(m_1845) == 0)) { V _m_1845_a0_1846 = FLD(m_1845, 0); V _m_1845_a1_1847 = FLD(m_1845, 1); V _m_1845_a2_1848 = FLD(m_1845, 2); _r = ({ V p17198_1849 = _m_1845_a0_1846; ({ V p17199_1850 = _m_1845_a1_1847; ({ V p17200_1851 = _m_1845_a2_1848; d_Asm_ucases_dacceptance(p17198_1849, p17199_1850, p17200_1851); }); }); }); } else rt_panic("match: no case at tests:806"); _r; }); });
}
static V lam_1865(V *env, V *args) {
  (void)env; (void)args;
  V x_1863 = args[0];
  V y_1864 = args[1];
  return d_NativeString_dequal(x_1863, y_1864);
}
static V lam_1869(V *env, V *args) {
  (void)env; (void)args;
  V local17210_1854 = args[0];
  V local17212_1855 = args[1];
  V local17214_1856 = args[2];
  V local17216_1857 = args[3];
  return ({ V local17219_1858 = d_Asm_dassemble(local17210_1854); ({ V _r = 0; V m_1859 = local17219_1858; switch (tag_of(m_1859)) { case 1: { V _m_1859_a0_1860 = FLD(m_1859, 0); _r = ({ V x_1861 = _m_1859_a0_1860; ({ V local17221_1862 = x_1861; rt_ctor2(0, ((d_Equal_dOptionOf_uBig_u(d_SeqList_dassoc(clo_new(lam_1865, 2, 0), local17212_1855, d_Asm_dlabels(local17221_1862)), SOME(local17214_1856))) != FALSE_V ? d_Equal_dListOf_uTupleOf3_uBig_u_uBig_u_uBig_u_u(d_Asm_ucases_drecord(local17221_1862), local17216_1857) : FALSE_V), d_Asm_ucases_dblocks_uof(local17221_1862)); }); }); break; } case 0: { V _m_1859_a0_1866 = FLD(m_1859, 0); _r = ({ V x_1867 = _m_1859_a0_1866; ({ V local17235_1868 = x_1867; rt_ctor2(0, FALSE_V, d_Big_dzero()); }); }); break; } default: rt_panic("match: no case at tests:807"); } _r; }); });
}
static Str S_383 = {TAG_STR, 18, {(const uint8_t *)"labels-and-heights"}};
static Str S_384 = {TAG_STR, 13, {(const uint8_t *)"ref20 diamond"}};
static V lam_1886(V *env, V *args) {
  (void)env; (void)args;
  V local17247_1885 = args[0];
  return d_Get_dTuple2_dv0(local17247_1885);
}
static V lam_1896(V *env, V *args) {
  (void)env; (void)args;
  V local17250_1888 = args[0];
  V local17252_1889 = args[1];
  return ({ V scrut17253_1890 = local17252_1889; ({ V _r = 0; V m_1891 = scrut17253_1890; if ((tag_of(m_1891) == 0)) { V _m_1891_a0_1892 = FLD(m_1891, 0); V _m_1891_a1_1893 = FLD(m_1891, 1); _r = ({ V p17254_1894 = _m_1891_a0_1892; ({ V p17255_1895 = _m_1891_a1_1893; d_NativeInt_dadd(local17250_1888, p17255_1895); }); }); } else rt_panic("match: no case at tests:814"); _r; }); });
}
static V lam_1904(V *env, V *args) {
  (void)env; (void)args;
  V local17258_1897 = args[0];
  return ({ V scrut17259_1898 = local17258_1897; ({ V _r = 0; V m_1899 = scrut17259_1898; if ((tag_of(m_1899) == 0)) { V _m_1899_a0_1900 = FLD(m_1899, 0); V _m_1899_a1_1901 = FLD(m_1899, 1); _r = ({ V p17260_1902 = _m_1899_a0_1900; ({ V p17261_1903 = _m_1899_a1_1901; ((p17260_1902) ^ 1u); }); }); } else rt_panic("match: no case at tests:816"); _r; }); });
}
static Str S_385 = {TAG_STR, 4, {(const uint8_t *)"PUSH"}};
static V lam_1909(V *env, V *args) {
  (void)env; (void)args;
  V local17270_1908 = args[0];
  return rt_ctor2(0, str_append(((V)&S_385), d_Big_dshow(local17270_1908)), rt_ctor1(1, d_NativeString_drepeat(d_Big_dto_unat(d_NativeInt_dmul(d_Big_dof_unat(NAT_SMALL(2ull)), local17270_1908)), (((V)48u)))));
}
static Str S_386 = {TAG_STR, 3, {(const uint8_t *)"DUP"}};
static V lam_1911(V *env, V *args) {
  (void)env; (void)args;
  V local17272_1910 = args[0];
  return rt_ctor2(0, str_append(((V)&S_386), d_Big_dshow(d_NativeInt_dadd(local17272_1910, d_Big_done()))), rt_ctor1(2, d_NativeInt_dadd(local17272_1910, d_Big_done())));
}
static Str S_387 = {TAG_STR, 4, {(const uint8_t *)"SWAP"}};
static V lam_1913(V *env, V *args) {
  (void)env; (void)args;
  V local17274_1912 = args[0];
  return rt_ctor2(0, str_append(((V)&S_387), d_Big_dshow(d_NativeInt_dadd(local17274_1912, d_Big_done()))), rt_ctor1(3, d_NativeInt_dadd(local17274_1912, d_Big_done())));
}
static V lam_1918(V *env, V *args) {
  (void)env; (void)args;
  V x_1916 = args[0];
  V y_1917 = args[1];
  return d_NativeString_dequal(x_1916, y_1917);
}
static Str S_388 = {TAG_STR, 13, {(const uint8_t *)"invalid count"}};
static Str S_389 = {TAG_STR, 6, {(const uint8_t *)"effect"}};
static Str S_390 = {TAG_STR, 6, {(const uint8_t *)"pushes"}};
static V lam_1938(V *env, V *args) {
  (void)env; (void)args;
  V local17295_1937 = args[0];
  return rt_ctor1(1, d_NativeString_drepeat(d_Big_dto_unat(d_NativeInt_dmul(d_Big_dof_unat(NAT_SMALL(2ull)), local17295_1937)), (((V)102u))));
}
static Str S_391 = {TAG_STR, 6, {(const uint8_t *)"depths"}};
static V lam_1940(V *env, V *args) {
  (void)env; (void)args;
  V local17297_1939 = args[0];
  return rt_ctor1(2, d_NativeInt_dadd(local17297_1939, d_Big_done()));
}
static V lam_1942(V *env, V *args) {
  (void)env; (void)args;
  V local17299_1941 = args[0];
  return rt_ctor1(3, d_NativeInt_dadd(local17299_1941, d_Big_done()));
}
static Str S_392 = {TAG_STR, 1, {(const uint8_t *)"f"}};
static Str S_393 = {TAG_STR, 6, {(const uint8_t *)"natAdd"}};
static Str S_394 = {TAG_STR, 9, {(const uint8_t *)"pair-test"}};
static Str S_395 = {TAG_STR, 7, {(const uint8_t *)"literal"}};
static Str S_396 = {TAG_STR, 6, {(const uint8_t *)"erased"}};
static Str S_397 = {TAG_STR, 7, {(const uint8_t *)"let-var"}};
static Str S_398 = {TAG_STR, 3, {(const uint8_t *)"app"}};
static Str S_399 = {TAG_STR, 4, {(const uint8_t *)"tail"}};
static Str S_400 = {TAG_STR, 6, {(const uint8_t *)"struct"}};
static Str S_401 = {TAG_STR, 10, {(const uint8_t *)"projection"}};
static Str S_402 = {TAG_STR, 3, {(const uint8_t *)"tag"}};
static Str S_403 = {TAG_STR, 4, {(const uint8_t *)"case"}};
static Str S_404 = {TAG_STR, 9, {(const uint8_t *)"word-case"}};
static Str S_405 = {TAG_STR, 7, {(const uint8_t *)"closure"}};
static Str S_406 = {TAG_STR, 12, {(const uint8_t *)"indirect-app"}};
static Str S_407 = {TAG_STR, 5, {(const uint8_t *)"delay"}};
static Str S_408 = {TAG_STR, 6, {(const uint8_t *)"KDELAY"}};
static Str S_409 = {TAG_STR, 5, {(const uint8_t *)"force"}};
static Str S_410 = {TAG_STR, 6, {(const uint8_t *)"KFORCE"}};
static Str S_411 = {TAG_STR, 5, {(const uint8_t *)"thunk"}};
static Str S_412 = {TAG_STR, 6, {(const uint8_t *)"RTHUNK"}};
static Str S_413 = {TAG_STR, 6, {(const uint8_t *)"STRING"}};
static Str S_414 = {TAG_STR, 9, {(const uint8_t *)"bad-index"}};
static Str S_415 = {TAG_STR, 5, {(const uint8_t *)"index"}};
static Str S_416 = {TAG_STR, 4, {(const uint8_t *)"gone"}};
static Str S_417 = {TAG_STR, 4, {(const uint8_t *)"fuel"}};
static Str S_418 = {TAG_STR, 11, {(const uint8_t *)"runtime-nat"}};
static Str S_419 = {TAG_STR, 6, {(const uint8_t *)"natSub"}};
static Str S_420 = {TAG_STR, 6, {(const uint8_t *)"natMul"}};
static V lam_1978(V *env, V *args) {
  (void)env; (void)args;
  V local17383_1969 = args[0];
  V local17385_1970 = args[1];
  return ({ V _r = 0; V m_1971 = local17383_1969; switch (tag_of(m_1971)) { case 1: { V _m_1971_a0_1972 = FLD(m_1971, 0); _r = ({ V item17390_1973 = _m_1971_a0_1972; ({ V local17388_1974 = item17390_1973; ({ V scrut17389_1975 = local17388_1974; local17385_1970; }); }); }); break; } case 0: { V _m_1971_a0_1976 = FLD(m_1971, 0); _r = ({ V item17391_1977 = _m_1971_a0_1976; FAIL(item17391_1977); }); break; } default: rt_panic("match: no case at tests:854"); } _r; });
}
static Str S_421 = {TAG_STR, 24, {(const uint8_t *)"EMIT-CONSTRUCTORS cases="}};
static Str S_422 = {TAG_STR, 7, {(const uint8_t *)"tuple<>"}};
static Str S_423 = {TAG_STR, 9, {(const uint8_t *)"word-zero"}};
static Str S_424 = {TAG_STR, 8, {(const uint8_t *)"word-max"}};
static Str S_425 = {TAG_STR, 13, {(const uint8_t *)"word-overflow"}};
static Str S_426 = {TAG_STR, 13, {(const uint8_t *)"word-negative"}};
static Str S_427 = {TAG_STR, 10, {(const uint8_t *)"word-shape"}};
static Str S_428 = {TAG_STR, 11, {(const uint8_t *)"word-struct"}};
static Str S_429 = {TAG_STR, 15, {(const uint8_t *)"word-leaked-tag"}};
static Str S_430 = {TAG_STR, 18, {(const uint8_t *)"word-leaked-struct"}};
static Str S_431 = {TAG_STR, 10, {(const uint8_t *)"word-unbox"}};
static V lam_2033(V *env, V *args) {
  (void)env; (void)args;
  V local17411_2024 = args[0];
  V local17413_2025 = args[1];
  return ({ V _r = 0; V m_2026 = local17411_2024; switch (tag_of(m_2026)) { case 1: { V _m_2026_a0_2027 = FLD(m_2026, 0); _r = ({ V item17418_2028 = _m_2026_a0_2027; ({ V local17416_2029 = item17418_2028; ({ V scrut17417_2030 = local17416_2029; local17413_2025; }); }); }); break; } case 0: { V _m_2026_a0_2031 = FLD(m_2026, 0); _r = ({ V item17419_2032 = _m_2026_a0_2031; FAIL(item17419_2032); }); break; } default: rt_panic("match: no case at tests:872"); } _r; });
}
static V lam_2045(V *env, V *args) {
  (void)env; (void)args;
  V local17425_2039 = args[0];
  return ({ V _r = 0; V m_2040 = local17425_2039; switch (tag_of(m_2040)) { case 1: { V _m_2040_a0_2041 = FLD(m_2040, 0); _r = ({ V x_2042 = _m_2040_a0_2041; SOME(x_2042); }); break; } case 0: { V _m_2040_a0_2043 = FLD(m_2040, 0); _r = ({ V __2044 = _m_2040_a0_2043; NONE; }); break; } default: rt_panic("match: no case at tests:874"); } _r; });
}
static V w_Emit_ucases_dis_uword(V *env, V *args) {
  (void)env; (void)args;
  return d_Emit_ucases_dis_uword(args[0]);
}
static Str S_432 = {TAG_STR, 16, {(const uint8_t *)"WORD-UNBOX ktag="}};
static Str S_433 = {TAG_STR, 9, {(const uint8_t *)" kstruct="}};
static Str S_434 = {TAG_STR, 7, {(const uint8_t *)" words="}};
static Str S_435 = {TAG_STR, 7, {(const uint8_t *)" cases="}};
static Str S_436 = {TAG_STR, 6, {(const uint8_t *)"hidden"}};
static V lam_2066(V *env, V *args) {
  (void)env; (void)args;
  V local17455_2065 = args[0];
  return ((d_NativeString_dequal(local17455_2065, ((V)&S_436))) != FALSE_V ? SOME(env[0]) : NONE);
}
static Str S_437 = {TAG_STR, 13, {(const uint8_t *)"storage-clean"}};
static Str S_438 = {TAG_STR, 15, {(const uint8_t *)"storage-closure"}};
static Str S_439 = {TAG_STR, 12, {(const uint8_t *)"storage-tail"}};
static Str S_440 = {TAG_STR, 14, {(const uint8_t *)"storage-hidden"}};
static Str S_441 = {TAG_STR, 13, {(const uint8_t *)"storage-cycle"}};
static V lam_2074(V *env, V *args) {
  (void)env; (void)args;
  V local17463_2073 = args[0];
  return SOME(rt_ctor1(2, local17463_2073));
}
static Str S_442 = {TAG_STR, 13, {(const uint8_t *)"storage-slots"}};
static Str S_443 = {TAG_STR, 6, {(const uint8_t *)"field0"}};
static Str S_444 = {TAG_STR, 6, {(const uint8_t *)"field1"}};
static Str S_445 = {TAG_STR, 11, {(const uint8_t *)"storage-gap"}};
static Str S_446 = {TAG_STR, 11, {(const uint8_t *)"storage-nat"}};
static Str S_447 = {TAG_STR, 11, {(const uint8_t *)"effect-slot"}};
static V lam_2085(V *env, V *args) {
  (void)env; (void)args;
  V local17471_2076 = args[0];
  V local17473_2077 = args[1];
  return ({ V _r = 0; V m_2078 = local17471_2076; switch (tag_of(m_2078)) { case 1: { V _m_2078_a0_2079 = FLD(m_2078, 0); _r = ({ V item17478_2080 = _m_2078_a0_2079; ({ V local17476_2081 = item17478_2080; ({ V scrut17477_2082 = local17476_2081; local17473_2077; }); }); }); break; } case 0: { V _m_2078_a0_2083 = FLD(m_2078, 0); _r = ({ V item17479_2084 = _m_2078_a0_2083; FAIL(item17479_2084); }); break; } default: rt_panic("match: no case at tests:891"); } _r; });
}
static Str S_448 = {TAG_STR, 21, {(const uint8_t *)"STORAGE-NOCLOS kclos="}};
static Str S_449 = {TAG_STR, 7, {(const uint8_t *)" ktail="}};
static Str S_450 = {TAG_STR, 8, {(const uint8_t *)" fields="}};
static Str S_451 = {TAG_STR, 7, {(const uint8_t *)"payload"}};
static Str S_452 = {TAG_STR, 3, {(const uint8_t *)"arg"}};
static V lam_2145(V *env, V *args) {
  (void)env; (void)args;
  V local17516_2144 = args[0];
  return d_One_upaths_dlinear(env[0], d_Prim_dnat_uty(), d_Prim_dnat_uty(), local17516_2144);
}
static V lam_2149(V *env, V *args) {
  (void)env; (void)args;
  V local17524_2147 = args[0];
  V local17526_2148 = args[1];
  return d_One_upaths_dlinear(env[0], d_Prim_dnat_uty(), d_Rules_darrow(((V)2), ((V)&S_402), d_One_upaths_dboth(), d_Prim_dnat_uty()), d_One_upaths_dlambda(((V)2), ((V)&S_402), d_One_upaths_dboth(), d_One_upaths_dcase(rt_ctor1(0, d_Big_dzero()), ((V)1), local17524_2147, local17526_2148)));
}
static V lam_2153(V *env, V *args) {
  (void)env; (void)args;
  V local17529_2151 = args[0];
  V local17531_2152 = args[1];
  return rt_ctor2(6, rt_ctor1(1, d_Big_dof_unat(NAT_SMALL(2ull))), CON(d_Rules_dleg_uof(local17529_2151), CON(d_Rules_dleg_uof(local17531_2152), NIL)));
}
static Str S_453 = {TAG_STR, 7, {(const uint8_t *)"ignored"}};
static V lam_2158(V *env, V *args) {
  (void)env; (void)args;
  V local17536_2157 = args[0];
  return rt_ctor3(7, rt_ctor3(0, ((V)2), ((V)&S_452), d_Prim_dnat_uty()), rt_ctor2(0, ((V)2), d_One_upaths_dzero()), rt_ctor1(0, local17536_2157));
}
static Str S_454 = {TAG_STR, 22, {(const uint8_t *)"kernel-linear-identity"}};
static Str S_455 = {TAG_STR, 13, {(const uint8_t *)"kernel-unused"}};
static Str S_456 = {TAG_STR, 16, {(const uint8_t *)"kernel-zero-only"}};
static Str S_457 = {TAG_STR, 5, {(const uint8_t *)"ghost"}};
static Str S_458 = {TAG_STR, 31, {(const uint8_t *)"kernel-apt-zero-stamp-many-type"}};
static Str S_459 = {TAG_STR, 7, {(const uint8_t *)"consume"}};
static Str S_460 = {TAG_STR, 30, {(const uint8_t *)"kernel-apt-one-stamp-many-type"}};
static Str S_461 = {TAG_STR, 30, {(const uint8_t *)"kernel-apt-many-stamp-one-type"}};
static Str S_462 = {TAG_STR, 8, {(const uint8_t *)"identity"}};
static Str S_463 = {TAG_STR, 30, {(const uint8_t *)"kernel-apt-zero-stamp-one-type"}};
static Str S_464 = {TAG_STR, 22, {(const uint8_t *)"kernel-once-per-branch"}};
static Str S_465 = {TAG_STR, 26, {(const uint8_t *)"kernel-asymmetric-branches"}};
static Str S_466 = {TAG_STR, 21, {(const uint8_t *)"kernel-scrutinee-once"}};
static Str S_467 = {TAG_STR, 21, {(const uint8_t *)"kernel-scrutinee-many"}};
static Str S_468 = {TAG_STR, 21, {(const uint8_t *)"kernel-scrutinee-zero"}};
static Str S_469 = {TAG_STR, 28, {(const uint8_t *)"kernel-scrutinee-plus-branch"}};
static Str S_470 = {TAG_STR, 23, {(const uint8_t *)"kernel-sequential-tuple"}};
static Str S_471 = {TAG_STR, 15, {(const uint8_t *)"kernel-let-once"}};
static Str S_472 = {TAG_STR, 5, {(const uint8_t *)"alias"}};
static Str S_473 = {TAG_STR, 17, {(const uint8_t *)"kernel-let-unused"}};
static Str S_474 = {TAG_STR, 26, {(const uint8_t *)"kernel-let-eager-duplicate"}};
static Str S_475 = {TAG_STR, 16, {(const uint8_t *)"kernel-let-twice"}};
static Str S_476 = {TAG_STR, 27, {(const uint8_t *)"kernel-shadowed-name-unused"}};
static Str S_477 = {TAG_STR, 19, {(const uint8_t *)"kernel-capture-once"}};
static Str S_478 = {TAG_STR, 20, {(const uint8_t *)"kernel-capture-twice"}};
static Str S_479 = {TAG_STR, 24, {(const uint8_t *)"kernel-empty-elimination"}};
static Str S_480 = {TAG_STR, 23, {(const uint8_t *)"kernel-unreachable-body"}};
static Str S_481 = {TAG_STR, 10, {(const uint8_t *)"impossible"}};
static Str S_482 = {TAG_STR, 29, {(const uint8_t *)"kernel-unreachable-unused-let"}};
static Str S_483 = {TAG_STR, 4, {(const uint8_t *)"dead"}};
static Str S_484 = {TAG_STR, 30, {(const uint8_t *)"kernel-unreachable-alternative"}};
static Str S_485 = {TAG_STR, 22, {(const uint8_t *)"kernel-nested-branches"}};
static Str S_486 = {TAG_STR, 23, {(const uint8_t *)"kernel-negative-literal"}};
static Str S_487 = {TAG_STR, 10, {(const uint8_t *)"quantity: "}};
static Str S_488 = {TAG_STR, 43, {(const uint8_t *)"mismatch: a Nat literal must be nonnegative"}};
static Str S_489 = {TAG_STR, 8, {(const uint8_t *)"accepted"}};
static V lam_2232(V *env, V *args) {
  (void)env; (void)args;
  V local17546_2212 = args[0];
  V local17548_2213 = args[1];
  return ({ V scrut17549_2214 = local17548_2213; ({ V _r = 0; V m_2215 = scrut17549_2214; if ((tag_of(m_2215) == 0)) { V _m_2215_a0_2216 = FLD(m_2215, 0); V _m_2215_a1_2217 = FLD(m_2215, 1); V _m_2215_a2_2218 = FLD(m_2215, 2); _r = ({ V p17550_2219 = _m_2215_a0_2216; ({ V p17551_2220 = _m_2215_a1_2217; ({ V p17552_2221 = _m_2215_a2_2218; ({ V scrut17562_2222 = d_One_upaths_dobserved(p17551_2220, p17552_2221); ({ V scrut17566_2223 = ({ V _r = 0; V m_2224 = p17552_2221; switch (tag_of(m_2224)) { case 1: { V _m_2224_a0_2225 = FLD(m_2224, 0); _r = ({ V x_2226 = _m_2224_a0_2225; ({ V local17564_2227 = x_2226; ({ V scrut17565_2228 = local17564_2227; ((V)&S_489); }); }); }); break; } case 0: { V _m_2224_a0_2229 = FLD(m_2224, 0); _r = ({ V x_2230 = _m_2224_a0_2229; d_Error_dto_ustring(x_2230); }); break; } default: rt_panic("match: no case at tests:952"); } _r; }); ({ V discard17567_2231 = UNIT; d_NativeInt_dadd(local17546_2212, ((scrut17562_2222) != FALSE_V ? d_Big_done() : d_Big_dzero())); }); }); }); }); }); }); } else rt_panic("match: no case at tests:951"); _r; }); });
}
static V lam_2244(V *env, V *args) {
  (void)env; (void)args;
  V local17600_2243 = args[0];
  return ((d_Big_dis_ule(d_Big_dof_unat(NAT_SMALL(32ull)), d_Big_dof_unat(NAT_SMALL((local17600_2243))))) != FALSE_V ? d_Big_dis_ule(d_Big_dof_unat(NAT_SMALL((local17600_2243))), d_Big_dof_unat(NAT_SMALL(126ull))) : FALSE_V);
}
static Str S_490 = {TAG_STR, 50, {(const uint8_t *)"the bridge exporter requires printable ASCII names"}};
static Str S_491 = {TAG_STR, 27, {(const uint8_t *)"negative raw index or arity"}};
static Str S_492 = {TAG_STR, 5, {(const uint8_t *)".zero"}};
static Str S_493 = {TAG_STR, 4, {(const uint8_t *)".one"}};
static Str S_494 = {TAG_STR, 5, {(const uint8_t *)".many"}};
static Str S_495 = {TAG_STR, 6, {(const uint8_t *)"(.SPi "}};
static Str S_496 = {TAG_STR, 8, {(const uint8_t *)"(.SColl "}};
static Str S_497 = {TAG_STR, 22, {(const uint8_t *)"SPar has no raw mirror"}};
static V w_Export_umu_dterm(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dterm(args[0]);
}
static Str S_498 = {TAG_STR, 6, {(const uint8_t *)"(.SMu "}};
static Str S_499 = {TAG_STR, 21, {(const uint8_t *)"SNu has no raw mirror"}};
static Str S_500 = {TAG_STR, 2, {(const uint8_t *)"(."}};
static Str S_501 = {TAG_STR, 6, {(const uint8_t *)"(.apt "}};
static Str S_502 = {TAG_STR, 7, {(const uint8_t *)"(.aleg "}};
static Str S_503 = {TAG_STR, 8, {(const uint8_t *)"(.actor "}};
static Str S_504 = {TAG_STR, 4, {(const uint8_t *)"none"}};
static Str S_505 = {TAG_STR, 6, {(const uint8_t *)"(some "}};
static V w_Export_umu_dquoted(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dquoted(args[0]);
}
static Str S_506 = {TAG_STR, 5, {(const uint8_t *)"(.mk "}};
static V w_Export_umu_dbinder(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dbinder(args[0]);
}
static Str S_507 = {TAG_STR, 6, {(const uint8_t *)"(.var "}};
static Str S_508 = {TAG_STR, 7, {(const uint8_t *)"(.univ "}};
static Str S_509 = {TAG_STR, 3, {(const uint8_t *)"lan"}};
static Str S_510 = {TAG_STR, 3, {(const uint8_t *)"ran"}};
static Str S_511 = {TAG_STR, 8, {(const uint8_t *)"(.intro "}};
static V w_Export_umu_dmotive(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dmotive(args[0]);
}
static V w_Export_umu_dbranch(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dbranch(args[0]);
}
static Str S_512 = {TAG_STR, 7, {(const uint8_t *)"(.elim "}};
static V w_Export_umu_dleg(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dleg(args[0]);
}
static Str S_513 = {TAG_STR, 6, {(const uint8_t *)"(.sec "}};
static Str S_514 = {TAG_STR, 6, {(const uint8_t *)"(.out "}};
static Str S_515 = {TAG_STR, 8, {(const uint8_t *)"(.letIn "}};
static Str S_516 = {TAG_STR, 6, {(const uint8_t *)"(.ann "}};
static Str S_517 = {TAG_STR, 9, {(const uint8_t *)"(.global "}};
static Str S_518 = {TAG_STR, 32, {(const uint8_t *)"string literal has no raw mirror"}};
static Str S_519 = {TAG_STR, 6, {(const uint8_t *)"(.lit "}};
static Str S_520 = {TAG_STR, 45, {(const uint8_t *)"negative literal has no natural-number mirror"}};
static Str S_521 = {TAG_STR, 22, {(const uint8_t *)"Auto has no raw mirror"}};
static Str S_522 = {TAG_STR, 12, {(const uint8_t *)".provisional"}};
static Str S_523 = {TAG_STR, 8, {(const uint8_t *)".builtin"}};
static Str S_524 = {TAG_STR, 11, {(const uint8_t *)"(.complete "}};
static V w_Export_umu_dfield(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dfield(args[0]);
}
static Str S_525 = {TAG_STR, 10, {(const uint8_t *)"{ name := "}};
static Str S_526 = {TAG_STR, 10, {(const uint8_t *)", args := "}};
static Str S_527 = {TAG_STR, 19, {(const uint8_t *)", resultIndices := "}};
static Str S_528 = {TAG_STR, 15, {(const uint8_t *)", fullArity := "}};
static Str S_529 = {TAG_STR, 19, {(const uint8_t *)", selfRecursive := "}};
static Str S_530 = {TAG_STR, 2, {(const uint8_t *)" }"}};
static V w_Export_umu_dconstructor(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dconstructor(args[0]);
}
static Str S_531 = {TAG_STR, 12, {(const uint8_t *)", params := "}};
static Str S_532 = {TAG_STR, 13, {(const uint8_t *)", indices := "}};
static Str S_533 = {TAG_STR, 11, {(const uint8_t *)", level := "}};
static Str S_534 = {TAG_STR, 12, {(const uint8_t *)", status := "}};
static Str S_535 = {TAG_STR, 18, {(const uint8_t *)", constructors := "}};
static Str S_536 = {TAG_STR, 14, {(const uint8_t *)", positive := "}};
static V lam_2732(V *env, V *args) {
  (void)env; (void)args;
  V x_2730 = args[0];
  V y_2731 = args[1];
  return d_NativeString_dequal(x_2730, y_2731);
}
static Str S_537 = {TAG_STR, 27, {(const uint8_t *)"missing checked definition "}};
static V w_Export_umu_dnatural(V *env, V *args) {
  (void)env; (void)args;
  return d_Export_umu_dnatural(args[0]);
}
static Str S_538 = {TAG_STR, 13, {(const uint8_t *)" : Term :=\012  "}};
static Str S_539 = {TAG_STR, 2, {(const uint8_t *)"\012\012"}};
static Str S_540 = {TAG_STR, 17, {(const uint8_t *)"Type : Term :=\012  "}};
static Str S_541 = {TAG_STR, 23, {(const uint8_t *)"RecArg : Option Nat := "}};
static Str S_542 = {TAG_STR, 18, {(const uint8_t *)"Partial : Bool := "}};
static Str S_543 = {TAG_STR, 20, {(const uint8_t *)"Reducible : Bool := "}};
static Str S_544 = {TAG_STR, 18, {(const uint8_t *)"not a definition: "}};
static Str S_545 = {TAG_STR, 35, {(const uint8_t *)"the checked fixture has no N family"}};
static V lam_2800(V *env, V *args) {
  (void)env; (void)args;
  V local17934_2799 = args[0];
  return d_Export_umu_ddefinition(env[0], local17934_2799);
}
static Str S_546 = {TAG_STR, 5, {(const uint8_t *)"three"}};
static Str S_547 = {TAG_STR, 72, {(const uint8_t *)"/- Generated by dev/mu-bridge/export_mu.ml from the checked fixture. -/\012"}};
static Str S_548 = {TAG_STR, 61, {(const uint8_t *)"import KanonMeta.MuNat\012\012namespace KanonMeta.MuNat.Generated\012\012"}};
static Str S_549 = {TAG_STR, 35, {(const uint8_t *)"def declaration : Declaration :=\012  "}};
static Str S_550 = {TAG_STR, 31, {(const uint8_t *)"\012end KanonMeta.MuNat.Generated\012"}};
static Str S_551 = {TAG_STR, 4, {(const uint8_t *)"Tree"}};
static Str S_552 = {TAG_STR, 38, {(const uint8_t *)"the checked fixture has no Tree family"}};
static V lam_2844(V *env, V *args) {
  (void)env; (void)args;
  V local17997_2843 = args[0];
  return d_Export_umu_ddefinition(env[0], local17997_2843);
}
static Str S_553 = {TAG_STR, 6, {(const uint8_t *)"sample"}};
static Str S_554 = {TAG_STR, 6, {(const uint8_t *)"mirror"}};
static Str S_555 = {TAG_STR, 63, {(const uint8_t *)"import KanonMeta.MuTree\012\012namespace KanonMeta.MuTree.Generated\012\012"}};
static Str S_556 = {TAG_STR, 41, {(const uint8_t *)"def declaration : MuNat.Declaration :=\012  "}};
static Str S_557 = {TAG_STR, 32, {(const uint8_t *)"\012end KanonMeta.MuTree.Generated\012"}};
static Str S_558 = {TAG_STR, 1, {(const uint8_t *)"V"}};
static Str S_559 = {TAG_STR, 35, {(const uint8_t *)"the checked fixture has no V family"}};
static V lam_2901(V *env, V *args) {
  (void)env; (void)args;
  V local18041_2900 = args[0];
  return d_Export_umu_ddefinition(env[0], local18041_2900);
}
static Str S_560 = {TAG_STR, 4, {(const uint8_t *)"copy"}};
static Str S_561 = {TAG_STR, 67, {(const uint8_t *)"import KanonMeta.MuVector\012\012namespace KanonMeta.MuVector.Generated\012\012"}};
static Str S_562 = {TAG_STR, 48, {(const uint8_t *)"def naturalDeclaration : MuNat.Declaration :=\012  "}};
static Str S_563 = {TAG_STR, 34, {(const uint8_t *)"\012end KanonMeta.MuVector.Generated\012"}};
static Str S_564 = {TAG_STR, 27, {(const uint8_t *)"the checked fixture has no "}};
static Str S_565 = {TAG_STR, 7, {(const uint8_t *)" family"}};
static Str S_566 = {TAG_STR, 71, {(const uint8_t *)"import KanonMeta.MuFinitary\012\012namespace KanonMeta.MuFinitary.Generated\012\012"}};
static Str S_567 = {TAG_STR, 36, {(const uint8_t *)"\012end KanonMeta.MuFinitary.Generated\012"}};
static Str S_568 = {TAG_STR, 7, {(const uint8_t *)" FAIL: "}};
static Str S_569 = {TAG_STR, 3, {(const uint8_t *)" OK"}};
static Str S_570 = {TAG_STR, 8, {(const uint8_t *)"KNEG smu"}};
static Str S_571 = {TAG_STR, 9, {(const uint8_t *)"KNEG self"}};
static Str S_572 = {TAG_STR, 9, {(const uint8_t *)"KNEG spar"}};
static Str S_573 = {TAG_STR, 8, {(const uint8_t *)"KNEG snu"}};
static Str S_574 = {TAG_STR, 10, {(const uint8_t *)"REC values"}};
static Str S_575 = {TAG_STR, 6, {(const uint8_t *)"values"}};
static Str S_576 = {TAG_STR, 20, {(const uint8_t *)"SUITE-KERNEL CORE OK"}};
static V io_2973(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_Tests_dunit(((V)&S_570), d_Main_dkneg(((V)&S_16))));
  io_run(d_Tests_dunit(((V)&S_571), d_Main_dkneg(((V)&S_7))));
  io_run(d_Tests_dunit(((V)&S_572), d_Main_dkneg(((V)&S_17))));
  io_run(d_Tests_dunit(((V)&S_573), d_Main_dkneg(((V)&S_19))));
  io_run(d_Tests_dunit(((V)&S_574), d_Main_drecursive_uvalues(((V)&S_575))));
  return io_run(d_NativeIO_dprint(((V)&S_576)));
}
static Str S_577 = {TAG_STR, 14, {(const uint8_t *)"SL-SURFACE-OK "}};
static Str S_578 = {TAG_STR, 1, {(const uint8_t *)"/"}};
static Str S_579 = {TAG_STR, 13, {(const uint8_t *)"SL-SURFACE OK"}};
static V io_2977(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_NativeIO_dprint(str_concat(CON(((V)&S_577), CON(nat_show(env[0]), CON(((V)&S_578), CON(nat_show(env[0]), NIL)))))));
  return io_run(d_NativeIO_dprint(((V)&S_579)));
}
static Str S_580 = {TAG_STR, 11, {(const uint8_t *)"SL-SURFACE "}};
static V io_2981(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_Tests_dunit(str_append(((V)&S_580), env[0]), ap(env[1], UNIT)));
  return io_run(d_Tests_dsurface(env[2], nat_add(env[3], NAT_SMALL(1ull))));
}
static Str S_581 = {TAG_STR, 23, {(const uint8_t *)"keccak-vec: invalid hex"}};
static Str S_582 = {TAG_STR, 19, {(const uint8_t *)"keccak-vec: odd hex"}};
static Str S_583 = {TAG_STR, 17, {(const uint8_t *)"keccak-vec: usage"}};
static Str S_584 = {TAG_STR, 20, {(const uint8_t *)"STACK-HEIGHT blocks="}};
static Str S_585 = {TAG_STR, 10, {(const uint8_t *)" mismatch="}};
static Str S_586 = {TAG_STR, 5, {(const uint8_t *)" FAIL"}};
static V io_3003(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_Tests_dfixture_uresult(env[0], d_Asm_dassemble(env[1])));
  return io_run(d_Tests_dasm_ufixtures(env[2]));
}
static V io_3015(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_NativeIO_dprint(str_concat(CON(d_Big_dshow(env[0]), CON(((V)&S_61), CON(d_Big_dshow(env[1]), NIL))))));
  return io_run(d_Tests_dheights(env[2]));
}
static V io_3019(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_NativeIO_dprint(env[0]));
  return io_run(d_NativeIO_dexit(((V)2u)));
}
static Str S_587 = {TAG_STR, 2, {(const uint8_t *)"2\012"}};
static Str S_588 = {TAG_STR, 2, {(const uint8_t *)"0\012"}};
static V io_3032(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_NativeIO_dstdout(str_concat(CON(nat_show(str_length(env[0])), CON(((V)&S_201), CON(env[0], NIL))))));
  io_run(d_Tests_deffect_ubatch(env[1]));
  return UNIT;
}
static Str S_589 = {TAG_STR, 23, {(const uint8_t *)"invalid effect manifest"}};
static V io_3049(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_Tests_dopcode(d_Asm_ddecode_uopcode(d_Big_dof_unat(env[0]))));
  return io_run(d_Tests_dmetadata(nat_add(env[0], NAT_SMALL(1ull))));
}
static Str S_590 = {TAG_STR, 5, {(const uint8_t *)"suite"}};
static V io_3053(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_Tests_dasm_uwitnesses());
  return io_run(d_Tests_dsuite(d_Asm_ucases_dsuite(UNIT)));
}
static Str S_591 = {TAG_STR, 8, {(const uint8_t *)"fixtures"}};
static Str S_592 = {TAG_STR, 8, {(const uint8_t *)"metadata"}};
static Str S_593 = {TAG_STR, 70, {(const uint8_t *)"usage: asm_cases suite | fixtures | listing HEX | effect OPCODE HEIGHT"}};
static Str S_594 = {TAG_STR, 7, {(const uint8_t *)"listing"}};
static Str S_595 = {TAG_STR, 12, {(const uint8_t *)"effect-batch"}};
static V lam_3057(V *env, V *args) {
  (void)env; (void)args;
  V result_3056 = args[0];
  return d_Tests_deffect_umanifest(result_3056);
}
static Str S_596 = {TAG_STR, 90, {(const uint8_t *)"usage: asm_cases suite | fixtures | listing HEX | effect OPCODE HEIGHT | effect-batch FILE"}};
static Str S_597 = {TAG_STR, 10, {(const uint8_t *)"6003565b00"}};
static Str S_598 = {TAG_STR, 27, {(const uint8_t *)"ASM-COMPACT FAIL jump bytes"}};
static Str S_599 = {TAG_STR, 25, {(const uint8_t *)"ASM-COMPACT cases=618 OK\012"}};
static V io_3066(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_Tests_dcompact_uhex(d_Asm_dassemble_ucompact(d_Asm_ucompact_djump(d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()))));
  return io_run(d_NativeIO_dstdout(env[0]));
}
static Str S_600 = {TAG_STR, 18, {(const uint8_t *)"ASM-COMPACT FAIL: "}};
static Str S_601 = {TAG_STR, 9, {(const uint8_t *)"ASM-CASE "}};
static V io_3072(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_Tests_dasm_uwitness(((V)&S_289), d_Asm_ucases_drejection(((V)&S_289), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(1, SNIL), CON(rt_ctor1(0, ((V)&S_290)), NIL))), NIL), ((V)&S_291))));
  io_run(d_Tests_dasm_uwitness(((V)&S_316), d_Asm_ucases_drejection(((V)&S_316), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), CON(rt_ctor1(1, SNIL), NIL), rt_ctor2(1, d_Big_done(), ((V)&S_285))), CON(d_Asm_ucases_dtarget(NONE, ((V)&S_285)), NIL)), ((V)&S_317))));
  io_run(d_Tests_dasm_uwitness(((V)&S_304), d_Asm_ucases_drejection(((V)&S_304), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(1024ull))), rt_ctor3(2, d_Big_done(), ((V)&S_285), ((V)&S_285))), CON(d_Asm_ucases_dtarget(SOME(d_Big_dof_unat(NAT_SMALL(1023ull))), ((V)&S_285)), NIL)), ((V)&S_303))));
  return io_run(d_Tests_dasm_uaccept(d_Asm_ucases_dacceptance(((V)&S_364), d_Asm_ucases_dref20(), ((V)&S_365))));
}
static Str S_602 = {TAG_STR, 17, {(const uint8_t *)"ASM-COMPACT FAIL "}};
static Str S_603 = {TAG_STR, 10, {(const uint8_t *)"branch-243"}};
static Str S_604 = {TAG_STR, 13, {(const uint8_t *)"payload-256-1"}};
static Str S_605 = {TAG_STR, 8, {(const uint8_t *)"branch-0"}};
static V io_3076(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_Tests_dcompact_uwitness(((V)&S_603), d_Asm_ucompact_dbranch(d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dof_unat(NAT_SMALL(243ull))), d_Asm_ucompact_dbranch(d_Big_done(), d_Big_dof_unat(NAT_SMALL(243ull)))));
  io_run(d_Tests_dcompact_uwitness(((V)&S_604), d_Asm_ucompact_dpayload(d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dof_unat(NAT_SMALL(247ull)), d_Big_done()), d_Asm_ucompact_dpayload(d_Big_done(), d_Big_dof_unat(NAT_SMALL(247ull)), d_Big_done())));
  io_run(d_Tests_dcompact_uwitness(((V)&S_605), d_Asm_ucompact_dbranch(d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), d_Asm_ucompact_dbranch(d_Big_done(), d_Big_dzero())));
  return io_run(d_Tests_dcompact(d_Asm_ucompact_doutput()));
}
static Str S_606 = {TAG_STR, 16, {(const uint8_t *)"EMIT-CASES FAIL "}};
static V io_3080(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_NativeIO_dprint(str_append(((V)&S_606), env[0])));
  return io_run(d_NativeIO_dexit(((V)1u)));
}
static Str S_607 = {TAG_STR, 12, {(const uint8_t *)"constructors"}};
static Str S_608 = {TAG_STR, 5, {(const uint8_t *)"words"}};
static Str S_609 = {TAG_STR, 7, {(const uint8_t *)"storage"}};
static Str S_610 = {TAG_STR, 6, {(const uint8_t *)"layout"}};
static Str S_611 = {TAG_STR, 4, {(const uint8_t *)"Q\042\134\012"}};
static Str S_612 = {TAG_STR, 2, {(const uint8_t *)"a\011"}};
static Str S_613 = {TAG_STR, 57, {(const uint8_t *)"usage: emit_cases constructors | words | storage | layout"}};
static Str S_614 = {TAG_STR, 9, {(const uint8_t *)"ROUNDTRIP"}};
static V lam_3093(V *env, V *args) {
  (void)env; (void)args;
  V result_3092 = args[0];
  return d_Tests_dread_uresult(result_3092);
}
static Str S_615 = {TAG_STR, 14, {(const uint8_t *)"roundtrip FILE"}};
static Str S_616 = {TAG_STR, 14, {(const uint8_t *)"contract_route"}};
static Str S_617 = {TAG_STR, 7, {(const uint8_t *)"fixture"}};
static Str S_618 = {TAG_STR, 9, {(const uint8_t *)"one_paths"}};
static Str S_619 = {TAG_STR, 9, {(const uint8_t *)"export_mu"}};
static Str S_620 = {TAG_STR, 6, {(const uint8_t *)"kernel"}};
static Str S_621 = {TAG_STR, 7, {(const uint8_t *)"surface"}};
static Str S_622 = {TAG_STR, 9, {(const uint8_t *)"abi_codec"}};
static Str S_623 = {TAG_STR, 10, {(const uint8_t *)"keccak_vec"}};
static Str S_624 = {TAG_STR, 10, {(const uint8_t *)"abi_schema"}};
static Str S_625 = {TAG_STR, 9, {(const uint8_t *)"asm_cases"}};
static Str S_626 = {TAG_STR, 11, {(const uint8_t *)"asm_compact"}};
static Str S_627 = {TAG_STR, 10, {(const uint8_t *)"emit_cases"}};
static Str S_628 = {TAG_STR, 9, {(const uint8_t *)"roundtrip"}};
static Str S_629 = {TAG_STR, 20, {(const uint8_t *)"unknown test adapter"}};
static Str S_630 = {TAG_STR, 21, {(const uint8_t *)"expected test adapter"}};
static V lam_3104(V *env, V *args) {
  (void)env; (void)args;
  V result_3103 = args[0];
  return d_Fixture_dbatch_umanifest(result_3103);
}
static V lam_3108(V *env, V *args) {
  (void)env; (void)args;
  V args_3107 = args[0];
  return d_Tests_dmain(d_Tests_darguments(args_3107));
}
static Str S_631 = {TAG_STR, 13, {(const uint8_t *)"ONE-DIRECT OK"}};
static Str S_632 = {TAG_STR, 15, {(const uint8_t *)"ONE-DIRECT FAIL"}};
static Str S_633 = {TAG_STR, 4, {(const uint8_t *)"ERR\012"}};
static Str S_634 = {TAG_STR, 3, {(const uint8_t *)"OK\012"}};
static Str S_635 = {TAG_STR, 10, {(const uint8_t *)"CHECK_ERR\012"}};
static Str S_636 = {TAG_STR, 5, {(const uint8_t *)"check"}};
static Str S_637 = {TAG_STR, 5, {(const uint8_t *)"erase"}};
static Str S_638 = {TAG_STR, 17, {(const uint8_t *)"fixture MODE FILE"}};
static V lam_3137(V *env, V *args) {
  (void)env; (void)args;
  V result_3136 = args[0];
  return d_Fixture_dread(env[0], result_3136);
}
static Str S_639 = {TAG_STR, 13, {(const uint8_t *)"ROUNDTRIP OK\012"}};
static Str S_640 = {TAG_STR, 16, {(const uint8_t *)"ROUNDTRIP FAIL: "}};
static Str S_641 = {TAG_STR, 5, {(const uint8_t *)"parse"}};
static Str S_642 = {TAG_STR, 20, {(const uint8_t *)"INVALID FIXTURE MODE"}};
static V io_3145(V *env, V *args) {
  (void)env; (void)args;
  io_run(d_NativeIO_dstdout(str_append(nat_show(str_length(env[0])), str_append(((V)&S_201), env[0]))));
  io_run(d_Fixture_dbatch(env[1]));
  return UNIT;
}
static V lam_3158(V *env, V *args) {
  (void)env; (void)args;
  V result_3157 = args[0];
  return d_Fixture_dbatch_ureceived(env[0], env[1], result_3157);
}
static Str S_643 = {TAG_STR, 24, {(const uint8_t *)"invalid fixture manifest"}};
static Str S_644 = {TAG_STR, 20, {(const uint8_t *)"cannot read fixture "}};
static V lam_3177(V *env, V *args) {
  (void)env; (void)args;
  V result_3176 = args[0];
  return d_Tests_dexport_uread(env[0], env[1], result_3176);
}
static V io_3178(V *env, V *args) {
  (void)env; (void)args;
  V x_3174 = io_run(d_OS_dregular(env[0]));
  V regular_3175 = x_3174;
  return io_run(((regular_3175) != FALSE_V ? io_bind(d_NativeIO_dread(env[0]), ({ V _c = clo_new(lam_3177, 1, 2); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[0]; _c; })) : d_NativeIO_ddie(((V)1u), str_append(((V)&S_644), env[0]))));
}
static Str S_645 = {TAG_STR, 78, {(const uint8_t *)"usage: export_mu [--tree|--vector] FIXTURE.kan | --finitary FAMILY FIXTURE.kan"}};
static Str S_646 = {TAG_STR, 6, {(const uint8_t *)"--tree"}};
static Str S_647 = {TAG_STR, 8, {(const uint8_t *)"--vector"}};
static Str S_648 = {TAG_STR, 10, {(const uint8_t *)"--finitary"}};
static V lam_3183(V *env, V *args) {
  (void)env; (void)args;
  V source_3182 = args[0];
  return d_Export_umu_dexport(source_3182);
}
static V lam_3187(V *env, V *args) {
  (void)env; (void)args;
  V source_3186 = args[0];
  return d_Export_umu_dexport_utree(source_3186);
}
static V lam_3189(V *env, V *args) {
  (void)env; (void)args;
  V source_3188 = args[0];
  return d_Export_umu_dexport_uvector(source_3188);
}
static V lam_3194(V *env, V *args) {
  (void)env; (void)args;
  V source_3193 = args[0];
  return d_Export_umu_dexport_ufinitary(env[0], source_3193);
}
static Str S_649 = {TAG_STR, 50, {(const uint8_t *)"CONTRACT-ROUTE core=3 identity=true sampled_bytes="}};
static Str S_650 = {TAG_STR, 16, {(const uint8_t *)" bound=131072 OK"}};
static Str S_651 = {TAG_STR, 34, {(const uint8_t *)"CONTRACT-ROUTE FAIL sampled_bytes="}};
static Str S_652 = {TAG_STR, 20, {(const uint8_t *)"axiom Core : Prop\012--"}};
static Str S_653 = {TAG_STR, 8, {(const uint8_t *)"contract"}};
static V io_3224(V *env, V *args) {
  (void)env; (void)args;
  V x_3222 = io_run(d_TestPerf_dmeasure(CON(str_append(((V)&S_652), d_Tests_dlarge_utext(((V)&S_10), NAT_SMALL(20ull))), CON(d_Tests_dlarge_utext(((V)&S_205), NAT_SMALL(20ull)), CON(str_append(((V)&S_653), d_Tests_dlarge_utext(((V)&S_205), NAT_SMALL(20ull))), NIL))), env[0]));
  V measured_3223 = x_3222;
  return io_run(d_Tests_droute_umeasurement(measured_3223));
}
static V lam_3228(V *env, V *args) {
  (void)env; (void)args;
  V source_3227 = args[0];
  return d_Tests_droute(source_3227);
}
static V lam_3231(V *env, V *args) {
  (void)env; (void)args;
  V source_3230 = args[0];
  return d_Tests_droute_ucopy(source_3230);
}
static Str S_654 = {TAG_STR, 8, {(const uint8_t *)"allocate"}};
static V lam_3233(V *env, V *args) {
  (void)env; (void)args;
  V source_3232 = args[0];
  return d_Tests_droute_uallocate(source_3232);
}
static Str S_655 = {TAG_STR, 30, {(const uint8_t *)"contract_route [copy|allocate]"}};
static Str S_656 = {TAG_STR, 16, {(const uint8_t *)"unsupported-type"}};
static Str S_657 = {TAG_STR, 10, {(const uint8_t *)"empty-name"}};
static Str S_658 = {TAG_STR, 15, {(const uint8_t *)"duplicate-name:"}};
static Str S_659 = {TAG_STR, 16, {(const uint8_t *)"invalid-location"}};
static Str S_660 = {TAG_STR, 12, {(const uint8_t *)"invalid-word"}};
static Str S_661 = {TAG_STR, 13, {(const uint8_t *)"out-of-range:"}};
static Str S_662 = {TAG_STR, 4, {(const uint8_t *)"ERR "}};
static V lam_3251(V *env, V *args) {
  (void)env; (void)args;
  V rest_3250 = args[0];
  return DONE(CON(rt_ctor2(0, env[0], env[1]), rest_3250));
}
static V lam_3258(V *env, V *args) {
  (void)env; (void)args;
  V rest_3257 = args[0];
  return DONE(CON(env[0], rest_3257));
}
static V lam_3259(V *env, V *args) {
  (void)env; (void)args;
  V number_3256 = args[0];
  return d_StringResult_dbind(d_Packed_ulayout_dnumbers(env[0]), ({ V _c = clo_new(lam_3258, 1, 1); CLO_ENV(_c)[0] = number_3256; _c; }));
}
static Str S_663 = {TAG_STR, 20, {(const uint8_t *)"ERR invalid-location"}};
static Str S_664 = {TAG_STR, 5, {(const uint8_t *)"field"}};
static V lam_3301(V *env, V *args) {
  (void)env; (void)args;
  V fields_3300 = args[0];
  return d_Packed_ulayout_dprint_uresult(d_Layout_dPacked_dprint(env[0], fields_3300));
}
static V lam_3308(V *env, V *args) {
  (void)env; (void)args;
  V ts_3307 = args[0];
  return d_Packed_ulayout_dschema_utypes(env[0], env[1], ts_3307);
}
static V lam_3317(V *env, V *args) {
  (void)env; (void)args;
  V values_3316 = args[0];
  return d_Packed_ulayout_daccess(env[0], env[1], values_3316);
}
static V lam_3318(V *env, V *args) {
  (void)env; (void)args;
  V types_3315 = args[0];
  return d_StringResult_dbind(d_Packed_ulayout_dnumbers(CON(env[0], env[1])), ({ V _c = clo_new(lam_3317, 1, 2); CLO_ENV(_c)[0] = env[2]; CLO_ENV(_c)[1] = types_3315; _c; }));
}
static V lam_3325(V *env, V *args) {
  (void)env; (void)args;
  V rows_3324 = args[0];
  return DONE(str_concat(CON(env[0], CON(((V)&S_87), CON(rows_3324, NIL)))));
}
static V lam_3331(V *env, V *args) {
  (void)env; (void)args;
  V row_3330 = args[0];
  return d_Packed_ulayout_djoin(row_3330, env[0]);
}
static Str S_665 = {TAG_STR, 12, {(const uint8_t *)"invalid-slot"}};
static Str S_666 = {TAG_STR, 15, {(const uint8_t *)"unsupported-key"}};
static Str S_667 = {TAG_STR, 10, {(const uint8_t *)"empty-path"}};
static V lam_3349(V *env, V *args) {
  (void)env; (void)args;
  V tail_3348 = args[0];
  return DONE(CON(rt_ctor2(0, env[0], env[1]), tail_3348));
}
static V lam_3350(V *env, V *args) {
  (void)env; (void)args;
  V value_3347 = args[0];
  return d_StringResult_dbind(d_Mapping_ulayout_dkeys(env[0], env[1]), ({ V _c = clo_new(lam_3349, 1, 2); CLO_ENV(_c)[0] = env[2]; CLO_ENV(_c)[1] = value_3347; _c; }));
}
static Str S_668 = {TAG_STR, 4, {(const uint8_t *)"slot"}};
static Str S_669 = {TAG_STR, 4, {(const uint8_t *)"path"}};
static V lam_3368(V *env, V *args) {
  (void)env; (void)args;
  V keys_3367 = args[0];
  return d_Mapping_ulayout_ddispatch(env[0], env[1], keys_3367);
}
static V lam_3369(V *env, V *args) {
  (void)env; (void)args;
  V ts_3366 = args[0];
  return d_StringResult_dbind(d_Mapping_ulayout_dkeys(ts_3366, env[0]), ({ V _c = clo_new(lam_3368, 1, 2); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; _c; }));
}
static V lam_3370(V *env, V *args) {
  (void)env; (void)args;
  V slot_3365 = args[0];
  return d_StringResult_dbind(d_Mapping_ulayout_dtypes(env[0]), ({ V _c = clo_new(lam_3369, 1, 3); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = slot_3365; _c; }));
}
static V lam_3377(V *env, V *args) {
  (void)env; (void)args;
  V rows_3376 = args[0];
  return DONE(str_concat(CON(env[0], CON(((V)&S_87), CON(rows_3376, NIL)))));
}
static V lam_3383(V *env, V *args) {
  (void)env; (void)args;
  V row_3382 = args[0];
  return d_Mapping_ulayout_djoin(row_3382, env[0]);
}
static Str S_670 = {TAG_STR, 5, {(const uint8_t *)"arity"}};
static Str S_671 = {TAG_STR, 13, {(const uint8_t *)"type-mismatch"}};
static Str S_672 = {TAG_STR, 15, {(const uint8_t *)"too-many-topics"}};
static Str S_673 = {TAG_STR, 1, {(const uint8_t *)"|"}};
static Str S_674 = {TAG_STR, 1, {(const uint8_t *)"1"}};
static Str S_675 = {TAG_STR, 12, {(const uint8_t *)"ADAPTER-FLAG"}};
static V lam_3403(V *env, V *args) {
  (void)env; (void)args;
  V tail_3402 = args[0];
  return DONE(CON(rt_ctor2(0, rt_ctor2(0, SNIL, env[0]), env[1]), tail_3402));
}
static V lam_3404(V *env, V *args) {
  (void)env; (void)args;
  V indexed_3401 = args[0];
  return d_StringResult_dbind(d_Event_ucodec_dparameters(env[0], env[1]), ({ V _c = clo_new(lam_3403, 1, 2); CLO_ENV(_c)[0] = env[2]; CLO_ENV(_c)[1] = indexed_3401; _c; }));
}
static V lam_3419(V *env, V *args) {
  (void)env; (void)args;
  V values_3418 = args[0];
  return DONE(d_Event_ucodec_dshow(d_Abi_dEvent_dencode(env[0], env[1], env[2], values_3418)));
}
static V lam_3420(V *env, V *args) {
  (void)env; (void)args;
  V vs_3417 = args[0];
  return d_StringResult_dbind(d_Abi_ucodec_dvalues(vs_3417, env[0]), ({ V _c = clo_new(lam_3419, 1, 3); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; _c; }));
}
static V lam_3421(V *env, V *args) {
  (void)env; (void)args;
  V ps_3416 = args[0];
  return d_StringResult_dbind(d_Mapping_ulayout_dtypes(env[0]), ({ V _c = clo_new(lam_3420, 1, 4); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = ps_3416; CLO_ENV(_c)[3] = env[3]; _c; }));
}
static V lam_3422(V *env, V *args) {
  (void)env; (void)args;
  V ts_3415 = args[0];
  return d_StringResult_dbind(d_Event_ucodec_dparameters(ts_3415, d_Event_ucodec_dflags(env[0])), ({ V _c = clo_new(lam_3421, 1, 4); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; CLO_ENV(_c)[3] = env[4]; _c; }));
}
static V lam_3423(V *env, V *args) {
  (void)env; (void)args;
  V anon_3414 = args[0];
  return d_StringResult_dbind(d_Mapping_ulayout_dtypes(env[0]), ({ V _c = clo_new(lam_3422, 1, 5); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; CLO_ENV(_c)[3] = env[4]; CLO_ENV(_c)[4] = anon_3414; _c; }));
}
static V lam_3429(V *env, V *args) {
  (void)env; (void)args;
  V row_3428 = args[0];
  return d_Event_ucodec_djoin(row_3428, env[0]);
}
static V lam_3436(V *env, V *args) {
  (void)env; (void)args;
  V rows_3435 = args[0];
  return DONE(str_concat(CON(env[0], CON(((V)&S_87), CON(rows_3435, NIL)))));
}
static Str S_676 = {TAG_STR, 5, {(const uint8_t *)"ARITY"}};
static Str S_677 = {TAG_STR, 4, {(const uint8_t *)"TYPE"}};
static Str S_678 = {TAG_STR, 14, {(const uint8_t *)"SHORT-SELECTOR"}};
static Str S_679 = {TAG_STR, 14, {(const uint8_t *)"WRONG-SELECTOR"}};
static V lam_3445(V *env, V *args) {
  (void)env; (void)args;
  V typ_3444 = args[0];
  return rt_ctor2(0, ((env[0]) != FALSE_V ? ((V)&S_228) : SNIL), typ_3444);
}
static Str S_680 = {TAG_STR, 6, {(const uint8_t *)"result"}};
static V lam_3468(V *env, V *args) {
  (void)env; (void)args;
  V ts_3467 = args[0];
  return d_Call_ucodec_ddispatch(env[0], env[1], ts_3467, env[2], env[3]);
}
static Str S_681 = {TAG_STR, 12, {(const uint8_t *)"ADAPTER-MODE"}};
static V lam_3481(V *env, V *args) {
  (void)env; (void)args;
  V values_3480 = args[0];
  return DONE(d_Call_ucodec_dshow_uencode(d_Abi_dCall_dencode(d_Call_ucodec_dfunction(env[0], env[1], env[2]), values_3480)));
}
static V lam_3482(V *env, V *args) {
  (void)env; (void)args;
  V vs_3479 = args[0];
  return d_StringResult_dbind(d_Abi_ucodec_dvalues(vs_3479, env[0]), ({ V _c = clo_new(lam_3481, 1, 3); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; _c; }));
}
static V lam_3489(V *env, V *args) {
  (void)env; (void)args;
  V bytes_3488 = args[0];
  return DONE(d_Call_ucodec_dshow_udecode(d_Abi_dCall_ddecode(d_Call_ucodec_dfunction(env[0], env[1], FALSE_V), bytes_3488)));
}
static V lam_3495(V *env, V *args) {
  (void)env; (void)args;
  V row_3494 = args[0];
  return d_Call_ucodec_djoin(row_3494, env[0]);
}
static V lam_3502(V *env, V *args) {
  (void)env; (void)args;
  V rows_3501 = args[0];
  return DONE(str_concat(CON(env[0], CON(((V)&S_87), CON(rows_3501, NIL)))));
}
static V lam_3511(V *env, V *args) {
  (void)env; (void)args;
  V typ_3510 = args[0];
  return rt_ctor2(0, ((env[0]) != FALSE_V ? ((V)&S_228) : SNIL), typ_3510);
}
static Str S_682 = {TAG_STR, 13, {(const uint8_t *)"differentName"}};
static Str S_683 = {TAG_STR, 5, {(const uint8_t *)"input"}};
static V lam_3528(V *env, V *args) {
  (void)env; (void)args;
  V ts_3527 = args[0];
  return d_Return_ucodec_ddispatch(env[0], env[1], ts_3527, env[2], env[3]);
}
static Str S_684 = {TAG_STR, 15, {(const uint8_t *)"decode-metadata"}};
static V lam_3541(V *env, V *args) {
  (void)env; (void)args;
  V values_3540 = args[0];
  return DONE(d_Return_ucodec_dshow_uencode(d_Abi_dReturn_dencode(d_Return_ucodec_dfunction(env[0], env[1], env[2]), values_3540)));
}
static V lam_3542(V *env, V *args) {
  (void)env; (void)args;
  V vs_3539 = args[0];
  return d_StringResult_dbind(d_Abi_ucodec_dvalues(vs_3539, env[0]), ({ V _c = clo_new(lam_3541, 1, 3); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; _c; }));
}
static V lam_3550(V *env, V *args) {
  (void)env; (void)args;
  V bytes_3549 = args[0];
  return DONE(d_Return_ucodec_dshow_udecode(d_Abi_dReturn_ddecode(d_Return_ucodec_dfunction(env[0], env[1], env[2]), bytes_3549)));
}
static V lam_3556(V *env, V *args) {
  (void)env; (void)args;
  V row_3555 = args[0];
  return d_Return_ucodec_djoin(row_3555, env[0]);
}
static V lam_3563(V *env, V *args) {
  (void)env; (void)args;
  V rows_3562 = args[0];
  return DONE(str_concat(CON(env[0], CON(((V)&S_87), CON(rows_3562, NIL)))));
}
static Str S_685 = {TAG_STR, 9, {(const uint8_t *)"NOT-ERROR"}};
static V lam_3573(V *env, V *args) {
  (void)env; (void)args;
  V typ_3572 = args[0];
  return rt_ctor2(0, ((env[0]) != FALSE_V ? ((V)&S_228) : SNIL), typ_3572);
}
static Str S_686 = {TAG_STR, 5, {(const uint8_t *)"error"}};
static Str S_687 = {TAG_STR, 11, {(const uint8_t *)"constructor"}};
static Str S_688 = {TAG_STR, 8, {(const uint8_t *)"function"}};
static Str S_689 = {TAG_STR, 5, {(const uint8_t *)"event"}};
static Str S_690 = {TAG_STR, 8, {(const uint8_t *)"fallback"}};
static Str S_691 = {TAG_STR, 12, {(const uint8_t *)"ADAPTER-KIND"}};
static V lam_3591(V *env, V *args) {
  (void)env; (void)args;
  V ts_3590 = args[0];
  return d_Revert_ucodec_dprepare(env[0], env[1], env[2], ts_3590, env[3], env[4]);
}
static V lam_3600(V *env, V *args) {
  (void)env; (void)args;
  V declaration_3599 = args[0];
  return d_Revert_ucodec_ddispatch(env[0], declaration_3599, env[1], env[2]);
}
static V lam_3610(V *env, V *args) {
  (void)env; (void)args;
  V values_3609 = args[0];
  return DONE(d_Revert_ucodec_dshow_uencode(d_Abi_dRevert_dencode(env[0], values_3609)));
}
static V lam_3611(V *env, V *args) {
  (void)env; (void)args;
  V vs_3608 = args[0];
  return d_StringResult_dbind(d_Abi_ucodec_dvalues(vs_3608, env[0]), ({ V _c = clo_new(lam_3610, 1, 1); CLO_ENV(_c)[0] = env[1]; _c; }));
}
static V lam_3617(V *env, V *args) {
  (void)env; (void)args;
  V bytes_3616 = args[0];
  return DONE(d_Revert_ucodec_dshow_udecode(d_Abi_dRevert_ddecode(env[0], bytes_3616)));
}
static V lam_3623(V *env, V *args) {
  (void)env; (void)args;
  V row_3622 = args[0];
  return d_Revert_ucodec_djoin(row_3622, env[0]);
}
static V lam_3630(V *env, V *args) {
  (void)env; (void)args;
  V rows_3629 = args[0];
  return DONE(str_concat(CON(env[0], CON(((V)&S_87), CON(rows_3629, NIL)))));
}
static Str S_692 = {TAG_STR, 15, {(const uint8_t *)"Too_many_topics"}};
static Str S_693 = {TAG_STR, 11, {(const uint8_t *)"Topic_count"}};
static Str S_694 = {TAG_STR, 10, {(const uint8_t *)"Topic_size"}};
static Str S_695 = {TAG_STR, 15, {(const uint8_t *)"Wrong_signature"}};
static Str S_696 = {TAG_STR, 5, {(const uint8_t *)"hash:"}};
static V lam_3642(V *env, V *args) {
  (void)env; (void)args;
  V value_3641 = args[0];
  return d_Event_udecode_dvalue(value_3641);
}
static V lam_3650(V *env, V *args) {
  (void)env; (void)args;
  V rest_3649 = args[0];
  return DONE(CON(env[0], rest_3649));
}
static V lam_3651(V *env, V *args) {
  (void)env; (void)args;
  V bytes_3648 = args[0];
  return d_StringResult_dbind(d_Event_udecode_dtopics(env[0]), ({ V _c = clo_new(lam_3650, 1, 1); CLO_ENV(_c)[0] = bytes_3648; _c; }));
}
static V lam_3665(V *env, V *args) {
  (void)env; (void)args;
  V bytes_3664 = args[0];
  return DONE(d_Event_udecode_dshow(d_Abi_dEvent_ddecode(env[0], env[1], env[2], rt_ctor2(0, env[3], bytes_3664))));
}
static V lam_3666(V *env, V *args) {
  (void)env; (void)args;
  V ts_3663 = args[0];
  return d_StringResult_dbind(d_Abi_ucodec_dunhex(env[0]), ({ V _c = clo_new(lam_3665, 1, 4); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; CLO_ENV(_c)[3] = ts_3663; _c; }));
}
static V lam_3667(V *env, V *args) {
  (void)env; (void)args;
  V ps_3662 = args[0];
  return d_StringResult_dbind(d_Event_udecode_dtopics(d_Event_ucodec_dflags(env[0])), ({ V _c = clo_new(lam_3666, 1, 4); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = ps_3662; CLO_ENV(_c)[3] = env[3]; _c; }));
}
static V lam_3668(V *env, V *args) {
  (void)env; (void)args;
  V ts_3661 = args[0];
  return d_StringResult_dbind(d_Event_ucodec_dparameters(ts_3661, d_Event_ucodec_dflags(env[0])), ({ V _c = clo_new(lam_3667, 1, 4); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; CLO_ENV(_c)[3] = env[4]; _c; }));
}
static V lam_3669(V *env, V *args) {
  (void)env; (void)args;
  V anon_3660 = args[0];
  return d_StringResult_dbind(d_Mapping_ulayout_dtypes(env[0]), ({ V _c = clo_new(lam_3668, 1, 5); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; CLO_ENV(_c)[3] = env[4]; CLO_ENV(_c)[4] = anon_3660; _c; }));
}
static V lam_3675(V *env, V *args) {
  (void)env; (void)args;
  V row_3674 = args[0];
  return d_Event_udecode_djoin(row_3674, env[0]);
}
static V lam_3682(V *env, V *args) {
  (void)env; (void)args;
  V rows_3681 = args[0];
  return DONE(str_concat(CON(env[0], CON(((V)&S_87), CON(rows_3681, NIL)))));
}
static Str S_697 = {TAG_STR, 12, {(const uint8_t *)" is admitted"}};

V d_TestNumber_ddigit(V c_1) {
  return ({ V n_2 = (d_NativeChar_dlower(c_1)); ((((((V)((((V)48u)) <= (n_2)))) & (((V)((n_2) <= (((V)57u))))))) != FALSE_V ? NAT_SMALL(((V)(uint32_t)((n_2) - (((V)48u))))) : ((((((V)((((V)97u)) <= (n_2)))) & (((V)((n_2) <= (((V)102u))))))) != FALSE_V ? NAT_SMALL(((V)(uint32_t)((n_2) - (((V)87u))))) : NAT_SMALL(16ull))); });
}
V d_TestNumber_dfinish(V negative_3, V value_4) {
  return SOME(d_Big_dwrap(NAT_SMALL(63ull), ((negative_3) != FALSE_V ? d_Big_dneg(value_4) : value_4)));
}
V scc_35(uint32_t w, V *a) {
  V negative_5;
  V base_6;
  V limit_7;
  V value_8;
  V digit_9;
  V rest_10;
  V negative_11;
  V base_12;
  V limit_13;
  V value_14;
  V seen_15;
  V text_16;
  switch (w) {
  default: negative_5 = a[0]; base_6 = a[1]; limit_7 = a[2]; value_8 = a[3]; digit_9 = a[4]; rest_10 = a[5]; goto _m0;
  case 1: negative_11 = a[0]; base_12 = a[1]; limit_13 = a[2]; value_14 = a[3]; seen_15 = a[4]; text_16 = a[5]; goto _m1;
  }
_m0: ;
  return ({ V next_17 = d_Big_dadd(d_Big_dmul(value_8, d_Big_dof_unat(base_6)), d_Big_dof_unat(digit_9)); ((((((V)(nat_cmp(digit_9, base_6) < 0))) & (d_Big_dis_ule(next_17, limit_7)))) != FALSE_V ? ({ V a_18 = negative_5; V a_19 = base_6; V a_20 = limit_7; V a_21 = next_17; V a_22 = TRUE_V; V a_23 = rest_10; negative_11 = a_18; base_12 = a_19; limit_13 = a_20; value_14 = a_21; seen_15 = a_22; text_16 = a_23;  goto _m1; (V)0; }) : NONE); });
_m1: ;
  return ({ V _r = 0; V m_24 = text_16; if ((str_is_nil(m_24))) {  _r = ((seen_15) != FALSE_V ? d_TestNumber_dfinish(negative_11, value_14) : NONE); } else if ((!str_is_nil(m_24)) && ((str_head(m_24)) == 95)) { V rest_25 = str_tail(m_24); _r = ((seen_15) != FALSE_V ? ({ V a_26 = rest_25; text_16 = a_26;  goto _m1; (V)0; }) : NONE); } else if ((!str_is_nil(m_24))) { V c_27 = str_head(m_24); V rest_28 = str_tail(m_24); _r = ({ V a_29 = negative_11; V a_30 = base_12; V a_31 = limit_13; V a_32 = value_14; V a_33 = d_TestNumber_ddigit(c_27); V a_34 = rest_28; negative_5 = a_29; base_6 = a_30; limit_7 = a_31; value_8 = a_32; digit_9 = a_33; rest_10 = a_34;  goto _m0; (V)0; }); } else rt_panic("match: no case at tests:19"); _r; });
}
V scc_35(uint32_t w, V *a);
V d_TestNumber_dnext(V negative_5, V base_6, V limit_7, V value_8, V digit_9, V rest_10) {
  V w_a[] = {negative_5, base_6, limit_7, value_8, digit_9, rest_10};
  return scc_35(0, w_a);
}
V scc_35(uint32_t w, V *a);
V d_TestNumber_ddigits(V negative_11, V base_12, V limit_13, V value_14, V seen_15, V text_16) {
  V w_a[] = {negative_11, base_12, limit_13, value_14, seen_15, text_16};
  return scc_35(1, w_a);
}
V d_TestNumber_dbase(V negative_35, V base_36, V digits_37) {
  return d_TestNumber_ddigits(negative_35, base_36, (kc_0_ok ? kc_0 : (kc_0 = d_Big_dpred(d_Big_dshift_uleft(d_Big_done(), NAT_SMALL(63ull))), rt_root(&kc_0), kc_0_ok = 1, kc_0)), d_Big_dzero(), FALSE_V, digits_37);
}
V d_TestNumber_dunsigned(V negative_38, V text_39) {
  return ({ V _r = 0; V m_40 = text_39; if ((!str_is_nil(m_40)) && ((str_head(m_40)) == 48) && (!str_is_nil(str_tail(m_40))) && ((str_head(str_tail(m_40))) == 120)) { V rest_41 = str_tail(str_tail(m_40)); _r = d_TestNumber_dbase(negative_38, NAT_SMALL(16ull), rest_41); } else if ((!str_is_nil(m_40)) && ((str_head(m_40)) == 48) && (!str_is_nil(str_tail(m_40))) && ((str_head(str_tail(m_40))) == 88)) { V rest_42 = str_tail(str_tail(m_40)); _r = d_TestNumber_dbase(negative_38, NAT_SMALL(16ull), rest_42); } else if ((!str_is_nil(m_40)) && ((str_head(m_40)) == 48) && (!str_is_nil(str_tail(m_40))) && ((str_head(str_tail(m_40))) == 111)) { V rest_43 = str_tail(str_tail(m_40)); _r = d_TestNumber_dbase(negative_38, NAT_SMALL(8ull), rest_43); } else if ((!str_is_nil(m_40)) && ((str_head(m_40)) == 48) && (!str_is_nil(str_tail(m_40))) && ((str_head(str_tail(m_40))) == 79)) { V rest_44 = str_tail(str_tail(m_40)); _r = d_TestNumber_dbase(negative_38, NAT_SMALL(8ull), rest_44); } else if ((!str_is_nil(m_40)) && ((str_head(m_40)) == 48) && (!str_is_nil(str_tail(m_40))) && ((str_head(str_tail(m_40))) == 98)) { V rest_45 = str_tail(str_tail(m_40)); _r = d_TestNumber_dbase(negative_38, NAT_SMALL(2ull), rest_45); } else if ((!str_is_nil(m_40)) && ((str_head(m_40)) == 48) && (!str_is_nil(str_tail(m_40))) && ((str_head(str_tail(m_40))) == 66)) { V rest_46 = str_tail(str_tail(m_40)); _r = d_TestNumber_dbase(negative_38, NAT_SMALL(2ull), rest_46); } else if ((!str_is_nil(m_40)) && ((str_head(m_40)) == 48) && (!str_is_nil(str_tail(m_40))) && ((str_head(str_tail(m_40))) == 117)) { V rest_47 = str_tail(str_tail(m_40)); _r = d_TestNumber_dbase(negative_38, NAT_SMALL(10ull), rest_47); } else if ((!str_is_nil(m_40)) && ((str_head(m_40)) == 48) && (!str_is_nil(str_tail(m_40))) && ((str_head(str_tail(m_40))) == 85)) { V rest_48 = str_tail(str_tail(m_40)); _r = d_TestNumber_dbase(negative_38, NAT_SMALL(10ull), rest_48); } else if (1) {  _r = d_TestNumber_ddigits(negative_38, NAT_SMALL(10ull), ((negative_38) != FALSE_V ? (kc_1_ok ? kc_1 : (kc_1 = d_Big_dshift_uleft(d_Big_done(), NAT_SMALL(62ull)), rt_root(&kc_1), kc_1_ok = 1, kc_1)) : (kc_2_ok ? kc_2 : (kc_2 = d_Big_dpred(d_Big_dshift_uleft(d_Big_done(), NAT_SMALL(62ull))), rt_root(&kc_2), kc_2_ok = 1, kc_2))), d_Big_dzero(), FALSE_V, text_39); } else rt_panic("match: no case at tests:27"); _r; });
}
V d_TestNumber_dread(V text_49) {
  return ({ V _r = 0; V m_50 = text_49; if ((!str_is_nil(m_50)) && ((str_head(m_50)) == 45)) { V rest_51 = str_tail(m_50); _r = d_TestNumber_dunsigned(TRUE_V, rest_51); } else if ((!str_is_nil(m_50)) && ((str_head(m_50)) == 43)) { V rest_52 = str_tail(m_50); _r = d_TestNumber_dunsigned(FALSE_V, rest_52); } else if (1) {  _r = d_TestNumber_dunsigned(FALSE_V, text_49); } else rt_panic("match: no case at tests:39"); _r; });
}
V d_Get_dGlobal_dDef_uentry_dpartial(V value_53) {
  return ({ V _r = 0; V m_54 = value_53; if ((tag_of(m_54) == 0)) { V field4_55 = FLD(m_54, 4); _r = field4_55; } else rt_panic("match: no case at tests:87"); _r; });
}
V d_Equal_dListOf_uSyntax_uDecl_u(V left_56, V right_57) {
  return ({ V _r = 0; V m_58 = left_56; V m_59 = right_57; if (((m_58) == NIL) && ((m_59) == NIL)) {  _r = TRUE_V; } else if (((m_58) != NIL) && ((m_59) != NIL)) { V left16347_60 = FLD(m_58, 0); V left16348_61 = FLD(m_58, 1); V right16349_62 = FLD(m_59, 0); V right16350_63 = FLD(m_59, 1); _r = ((d_Equal_dSyntax_uDecl(left16347_60, right16349_62)) & (((d_Equal_dListOf_uSyntax_uDecl_u(left16348_61, right16350_63)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:91"); _r; });
}
V d_Equal_dSyntax_uDecl(V left_64, V right_65) {
  return ({ V _r = 0; V m_66 = left_64; V m_67 = right_65; if ((tag_of(m_66) == 0) && (tag_of(m_67) == 0)) { V left16351_68 = FLD(m_66, 0); V left16352_69 = FLD(m_66, 1); V left16353_70 = FLD(m_66, 2); V right16354_71 = FLD(m_67, 0); V right16355_72 = FLD(m_67, 1); V right16356_73 = FLD(m_67, 2); _r = ((d_NativeString_dequal(left16351_68, right16354_71)) & (((d_Equal_dSyntax(left16352_69, right16355_72)) & (((d_Equal_dSyntax(left16353_70, right16356_73)) & (TRUE_V)))))); } else if ((tag_of(m_66) == 1) && (tag_of(m_67) == 1)) { V left16479_74 = FLD(m_66, 0); V left16480_75 = FLD(m_66, 1); V right16481_76 = FLD(m_67, 0); V right16482_77 = FLD(m_67, 1); _r = ((d_NativeString_dequal(left16479_74, right16481_76)) & (((d_Equal_dSyntax(left16480_75, right16482_77)) & (TRUE_V)))); } else if ((tag_of(m_66) == 2) && (tag_of(m_67) == 2)) { V left16483_78 = FLD(m_66, 0); V right16484_79 = FLD(m_67, 0); _r = ((d_Equal_dListOf_uSyntax_uFam_u(left16483_78, right16484_79)) & (TRUE_V)); } else if ((tag_of(m_66) == 3) && (tag_of(m_67) == 3)) { V left16505_80 = FLD(m_66, 0); V right16506_81 = FLD(m_67, 0); _r = ((d_Equal_dListOf_uSyntax_uRec_udef_u(left16505_80, right16506_81)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:97"); _r; });
}
V d_Equal_dSyntax(V left_82, V right_83) {
  return ({ V _r = 0; V m_84 = left_82; V m_85 = right_83; if ((tag_of(m_84) == 0) && (tag_of(m_85) == 0)) { V left16357_86 = FLD(m_84, 0); V right16358_87 = FLD(m_85, 0); _r = ((d_NativeString_dequal(left16357_86, right16358_87)) & (TRUE_V)); } else if ((tag_of(m_84) == 1) && (tag_of(m_85) == 1)) { V left16359_88 = FLD(m_84, 0); V right16360_89 = FLD(m_85, 0); _r = ((d_Big_dis_ueq(left16359_88, right16360_89)) & (TRUE_V)); } else if ((tag_of(m_84) == 2) && (tag_of(m_85) == 2)) {  _r = TRUE_V; } else if ((tag_of(m_84) == 3) && (tag_of(m_85) == 3)) { V left16361_90 = FLD(m_84, 0); V right16362_91 = FLD(m_85, 0); _r = ((d_Big_dis_ueq(left16361_90, right16362_91)) & (TRUE_V)); } else if ((tag_of(m_84) == 4) && (tag_of(m_85) == 4)) { V left16363_92 = FLD(m_84, 0); V right16364_93 = FLD(m_85, 0); _r = ((d_Equal_dSyntax_uPrim(left16363_92, right16364_93)) & (TRUE_V)); } else if ((tag_of(m_84) == 5) && (tag_of(m_85) == 5)) {  _r = TRUE_V; } else if ((tag_of(m_84) == 6) && (tag_of(m_85) == 6)) {  _r = TRUE_V; } else if ((tag_of(m_84) == 7) && (tag_of(m_85) == 7)) { V left16365_94 = FLD(m_84, 0); V left16366_95 = FLD(m_84, 1); V right16367_96 = FLD(m_85, 0); V right16368_97 = FLD(m_85, 1); _r = ((d_Equal_dSyntax(left16365_94, right16367_96)) & (((d_Equal_dSyntax(left16366_95, right16368_97)) & (TRUE_V)))); } else if ((tag_of(m_84) == 8) && (tag_of(m_85) == 8)) { V left16369_98 = FLD(m_84, 0); V right16370_99 = FLD(m_85, 0); _r = ((d_Equal_dListOf_uSyntax_u(left16369_98, right16370_99)) & (TRUE_V)); } else if ((tag_of(m_84) == 9) && (tag_of(m_85) == 9)) { V left16375_100 = FLD(m_84, 0); V right16376_101 = FLD(m_85, 0); _r = ((d_Equal_dListOf_uSyntax_u(left16375_100, right16376_101)) & (TRUE_V)); } else if ((tag_of(m_84) == 10) && (tag_of(m_85) == 10)) { V left16377_102 = FLD(m_84, 0); V right16378_103 = FLD(m_85, 0); _r = ((d_Equal_dListOf_uSyntax_u(left16377_102, right16378_103)) & (TRUE_V)); } else if ((tag_of(m_84) == 11) && (tag_of(m_85) == 11)) { V left16379_104 = FLD(m_84, 0); V left16380_105 = FLD(m_84, 1); V right16381_106 = FLD(m_85, 0); V right16382_107 = FLD(m_85, 1); _r = ((d_Equal_dSyntax(left16379_104, right16381_106)) & (((d_Big_dis_ueq(left16380_105, right16382_107)) & (TRUE_V)))); } else if ((tag_of(m_84) == 12) && (tag_of(m_85) == 12)) { V left16383_108 = FLD(m_84, 0); V left16384_109 = FLD(m_84, 1); V left16385_110 = FLD(m_84, 2); V right16386_111 = FLD(m_85, 0); V right16387_112 = FLD(m_85, 1); V right16388_113 = FLD(m_85, 2); _r = ((d_Big_dis_ueq(left16383_108, right16386_111)) & (((d_Big_dis_ueq(left16384_109, right16387_112)) & (((d_Equal_dSyntax(left16385_110, right16388_113)) & (TRUE_V)))))); } else if ((tag_of(m_84) == 13) && (tag_of(m_85) == 13)) { V left16389_114 = FLD(m_84, 0); V right16390_115 = FLD(m_85, 0); _r = ((d_Equal_dSyntax(left16389_114, right16390_115)) & (TRUE_V)); } else if ((tag_of(m_84) == 14) && (tag_of(m_85) == 14)) { V left16391_116 = FLD(m_84, 0); V left16392_117 = FLD(m_84, 1); V right16393_118 = FLD(m_85, 0); V right16394_119 = FLD(m_85, 1); _r = ((d_Equal_dSyntax(left16391_116, right16393_118)) & (((d_Equal_dSyntax(left16392_117, right16394_119)) & (TRUE_V)))); } else if ((tag_of(m_84) == 15) && (tag_of(m_85) == 15)) { V left16395_120 = FLD(m_84, 0); V left16396_121 = FLD(m_84, 1); V right16397_122 = FLD(m_85, 0); V right16398_123 = FLD(m_85, 1); _r = ((d_Equal_dListOf_uSyntax_uBinder_u(left16395_120, right16397_122)) & (((d_Equal_dSyntax(left16396_121, right16398_123)) & (TRUE_V)))); } else if ((tag_of(m_84) == 16) && (tag_of(m_85) == 16)) { V left16409_124 = FLD(m_84, 0); V left16410_125 = FLD(m_84, 1); V right16411_126 = FLD(m_85, 0); V right16412_127 = FLD(m_85, 1); _r = ((d_Equal_dSyntax_uBinder(left16409_124, right16411_126)) & (((d_Equal_dSyntax(left16410_125, right16412_127)) & (TRUE_V)))); } else if ((tag_of(m_84) == 17) && (tag_of(m_85) == 17)) { V left16413_128 = FLD(m_84, 0); V left16414_129 = FLD(m_84, 1); V right16415_130 = FLD(m_85, 0); V right16416_131 = FLD(m_85, 1); _r = ((d_Equal_dSyntax_uBinder(left16413_128, right16415_130)) & (((d_Equal_dSyntax(left16414_129, right16416_131)) & (TRUE_V)))); } else if ((tag_of(m_84) == 18) && (tag_of(m_85) == 18)) { V left16417_132 = FLD(m_84, 0); V left16418_133 = FLD(m_84, 1); V left16419_134 = FLD(m_84, 2); V left16420_135 = FLD(m_84, 3); V right16421_136 = FLD(m_85, 0); V right16422_137 = FLD(m_85, 1); V right16423_138 = FLD(m_85, 2); V right16424_139 = FLD(m_85, 3); _r = ((d_NativeString_dequal(left16417_132, right16421_136)) & (((d_Equal_dSyntax(left16418_133, right16422_137)) & (((d_Equal_dSyntax(left16419_134, right16423_138)) & (((d_Equal_dSyntax(left16420_135, right16424_139)) & (TRUE_V)))))))); } else if ((tag_of(m_84) == 19) && (tag_of(m_85) == 19)) { V left16425_140 = FLD(m_84, 0); V left16426_141 = FLD(m_84, 1); V right16427_142 = FLD(m_85, 0); V right16428_143 = FLD(m_85, 1); _r = ((d_Equal_dSyntax(left16425_140, right16427_142)) & (((d_Equal_dSyntax(left16426_141, right16428_143)) & (TRUE_V)))); } else if ((tag_of(m_84) == 20) && (tag_of(m_85) == 20)) { V left16429_144 = FLD(m_84, 0); V left16430_145 = FLD(m_84, 1); V left16431_146 = FLD(m_84, 2); V right16432_147 = FLD(m_85, 0); V right16433_148 = FLD(m_85, 1); V right16434_149 = FLD(m_85, 2); _r = ((d_Equal_dSyntax(left16429_144, right16432_147)) & (((d_Equal_dOptionOf_uSyntax_uMotive_u(left16430_145, right16433_148)) & (((d_Equal_dListOf_uSyntax_uBranch_u(left16431_146, right16434_149)) & (TRUE_V)))))); } else if ((tag_of(m_84) == 21) && (tag_of(m_85) == 21)) { V left16473_150 = FLD(m_84, 0); V left16474_151 = FLD(m_84, 1); V left16475_152 = FLD(m_84, 2); V right16476_153 = FLD(m_85, 0); V right16477_154 = FLD(m_85, 1); V right16478_155 = FLD(m_85, 2); _r = ((d_Equal_dSyntax(left16473_150, right16476_153)) & (((d_Equal_dOptionOf_uSyntax_uMotive_u(left16474_151, right16477_154)) & (((d_Equal_dListOf_uSyntax_uBranch_u(left16475_152, right16478_155)) & (TRUE_V)))))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:105"); _r; });
}
V d_Equal_dSyntax_uPrim(V left_156, V right_157) {
  return ({ V _r = 0; V m_158 = left_156; V m_159 = right_157; if ((tag_of(m_158) == 0) && (tag_of(m_159) == 0)) {  _r = TRUE_V; } else if ((tag_of(m_158) == 1) && (tag_of(m_159) == 1)) {  _r = TRUE_V; } else if ((tag_of(m_158) == 2) && (tag_of(m_159) == 2)) {  _r = TRUE_V; } else if ((tag_of(m_158) == 3) && (tag_of(m_159) == 3)) {  _r = TRUE_V; } else if ((tag_of(m_158) == 4) && (tag_of(m_159) == 4)) {  _r = TRUE_V; } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:131"); _r; });
}
V d_Equal_dListOf_uSyntax_u(V left_160, V right_161) {
  return ({ V _r = 0; V m_162 = left_160; V m_163 = right_161; if (((m_162) == NIL) && ((m_163) == NIL)) {  _r = TRUE_V; } else if (((m_162) != NIL) && ((m_163) != NIL)) { V left16371_164 = FLD(m_162, 0); V left16372_165 = FLD(m_162, 1); V right16373_166 = FLD(m_163, 0); V right16374_167 = FLD(m_163, 1); _r = ((d_Equal_dSyntax(left16371_164, right16373_166)) & (((d_Equal_dListOf_uSyntax_u(left16372_165, right16374_167)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:140"); _r; });
}
V d_Equal_dListOf_uSyntax_uBinder_u(V left_168, V right_169) {
  return ({ V _r = 0; V m_170 = left_168; V m_171 = right_169; if (((m_170) == NIL) && ((m_171) == NIL)) {  _r = TRUE_V; } else if (((m_170) != NIL) && ((m_171) != NIL)) { V left16399_172 = FLD(m_170, 0); V left16400_173 = FLD(m_170, 1); V right16401_174 = FLD(m_171, 0); V right16402_175 = FLD(m_171, 1); _r = ((d_Equal_dSyntax_uBinder(left16399_172, right16401_174)) & (((d_Equal_dListOf_uSyntax_uBinder_u(left16400_173, right16402_175)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:146"); _r; });
}
V d_Equal_dSyntax_uBinder(V left_176, V right_177) {
  return ({ V _r = 0; V m_178 = left_176; V m_179 = right_177; if ((tag_of(m_178) == 0) && (tag_of(m_179) == 0)) { V left16403_180 = FLD(m_178, 0); V left16404_181 = FLD(m_178, 1); V left16405_182 = FLD(m_178, 2); V right16406_183 = FLD(m_179, 0); V right16407_184 = FLD(m_179, 1); V right16408_185 = FLD(m_179, 2); _r = ((d_Equal_dQuantity(left16403_180, right16406_183)) & (((d_NativeString_dequal(left16404_181, right16407_184)) & (((d_Equal_dSyntax(left16405_182, right16408_185)) & (TRUE_V)))))); } else rt_panic("match: no case at tests:152"); _r; });
}
V d_Equal_dListOf_uSyntax_uBranch_u(V left_186, V right_187) {
  return ({ V _r = 0; V m_188 = left_186; V m_189 = right_187; if (((m_188) == NIL) && ((m_189) == NIL)) {  _r = TRUE_V; } else if (((m_188) != NIL) && ((m_189) != NIL)) { V left16435_190 = FLD(m_188, 0); V left16436_191 = FLD(m_188, 1); V right16437_192 = FLD(m_189, 0); V right16438_193 = FLD(m_189, 1); _r = ((d_Equal_dSyntax_uBranch(left16435_190, right16437_192)) & (((d_Equal_dListOf_uSyntax_uBranch_u(left16436_191, right16438_193)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:156"); _r; });
}
V d_Equal_dSyntax_uBranch(V left_194, V right_195) {
  return ({ V _r = 0; V m_196 = left_194; V m_197 = right_195; if ((tag_of(m_196) == 0) && (tag_of(m_197) == 0)) { V left16439_198 = FLD(m_196, 0); V left16440_199 = FLD(m_196, 1); V left16441_200 = FLD(m_196, 2); V right16442_201 = FLD(m_197, 0); V right16443_202 = FLD(m_197, 1); V right16444_203 = FLD(m_197, 2); _r = ((d_Big_dis_ueq(left16439_198, right16442_201)) & (((d_Equal_dListOf_uSyntax_uBinder_u(left16440_199, right16443_202)) & (((d_Equal_dSyntax(left16441_200, right16444_203)) & (TRUE_V)))))); } else if ((tag_of(m_196) == 1) && (tag_of(m_197) == 1)) { V left16445_204 = FLD(m_196, 0); V left16446_205 = FLD(m_196, 1); V left16447_206 = FLD(m_196, 2); V right16448_207 = FLD(m_197, 0); V right16449_208 = FLD(m_197, 1); V right16450_209 = FLD(m_197, 2); _r = ((d_NativeString_dequal(left16445_204, right16448_207)) & (((d_Equal_dListOf_uSyntax_uField_u(left16446_205, right16449_208)) & (((d_Equal_dSyntax(left16447_206, right16450_209)) & (TRUE_V)))))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:162"); _r; });
}
V d_Equal_dListOf_uSyntax_uField_u(V left_210, V right_211) {
  return ({ V _r = 0; V m_212 = left_210; V m_213 = right_211; if (((m_212) == NIL) && ((m_213) == NIL)) {  _r = TRUE_V; } else if (((m_212) != NIL) && ((m_213) != NIL)) { V left16451_214 = FLD(m_212, 0); V left16452_215 = FLD(m_212, 1); V right16453_216 = FLD(m_213, 0); V right16454_217 = FLD(m_213, 1); _r = ((d_Equal_dSyntax_uField(left16451_214, right16453_216)) & (((d_Equal_dListOf_uSyntax_uField_u(left16452_215, right16454_217)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:168"); _r; });
}
V d_Equal_dSyntax_uField(V left_218, V right_219) {
  return ({ V _r = 0; V m_220 = left_218; V m_221 = right_219; if ((tag_of(m_220) == 0) && (tag_of(m_221) == 0)) { V left16455_222 = FLD(m_220, 0); V left16456_223 = FLD(m_220, 1); V left16457_224 = FLD(m_220, 2); V right16458_225 = FLD(m_221, 0); V right16459_226 = FLD(m_221, 1); V right16460_227 = FLD(m_221, 2); _r = ((d_Equal_dQuantity(left16455_222, right16458_225)) & (((d_NativeString_dequal(left16456_223, right16459_226)) & (((d_Equal_dOptionOf_uSyntax_u(left16457_224, right16460_227)) & (TRUE_V)))))); } else rt_panic("match: no case at tests:174"); _r; });
}
V d_Equal_dOptionOf_uSyntax_u(V left_228, V right_229) {
  return ({ V _r = 0; V m_230 = left_228; V m_231 = right_229; if (((m_230) == NONE) && ((m_231) == NONE)) {  _r = TRUE_V; } else if (((m_230) != NONE) && ((m_231) != NONE)) { V left16461_232 = FLD(m_230, 0); V right16462_233 = FLD(m_231, 0); _r = ((d_Equal_dSyntax(left16461_232, right16462_233)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:178"); _r; });
}
V d_Equal_dOptionOf_uSyntax_uMotive_u(V left_234, V right_235) {
  return ({ V _r = 0; V m_236 = left_234; V m_237 = right_235; if (((m_236) == NONE) && ((m_237) == NONE)) {  _r = TRUE_V; } else if (((m_236) != NONE) && ((m_237) != NONE)) { V left16463_238 = FLD(m_236, 0); V right16464_239 = FLD(m_237, 0); _r = ((d_Equal_dSyntax_uMotive(left16463_238, right16464_239)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:184"); _r; });
}
V d_Equal_dSyntax_uMotive(V left_240, V right_241) {
  return ({ V _r = 0; V m_242 = left_240; V m_243 = right_241; if ((tag_of(m_242) == 0) && (tag_of(m_243) == 0)) { V left16465_244 = FLD(m_242, 0); V left16466_245 = FLD(m_242, 1); V left16467_246 = FLD(m_242, 2); V left16468_247 = FLD(m_242, 3); V right16469_248 = FLD(m_243, 0); V right16470_249 = FLD(m_243, 1); V right16471_250 = FLD(m_243, 2); V right16472_251 = FLD(m_243, 3); _r = ((d_NativeString_dequal(left16465_244, right16469_248)) & (((d_Equal_dOptionOf_uString_u(left16466_245, right16470_249)) & (((d_Equal_dListOf_uString_u(left16467_246, right16471_250)) & (((d_Equal_dSyntax(left16468_247, right16472_251)) & (TRUE_V)))))))); } else rt_panic("match: no case at tests:190"); _r; });
}
V d_Equal_dListOf_uSyntax_uFam_u(V left_252, V right_253) {
  return ({ V _r = 0; V m_254 = left_252; V m_255 = right_253; if (((m_254) == NIL) && ((m_255) == NIL)) {  _r = TRUE_V; } else if (((m_254) != NIL) && ((m_255) != NIL)) { V left16485_256 = FLD(m_254, 0); V left16486_257 = FLD(m_254, 1); V right16487_258 = FLD(m_255, 0); V right16488_259 = FLD(m_255, 1); _r = ((d_Equal_dSyntax_uFam(left16485_256, right16487_258)) & (((d_Equal_dListOf_uSyntax_uFam_u(left16486_257, right16488_259)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:194"); _r; });
}
V d_Equal_dSyntax_uFam(V left_260, V right_261) {
  return ({ V _r = 0; V m_262 = left_260; V m_263 = right_261; if ((tag_of(m_262) == 0) && (tag_of(m_263) == 0)) { V left16489_264 = FLD(m_262, 0); V left16490_265 = FLD(m_262, 1); V left16491_266 = FLD(m_262, 2); V left16492_267 = FLD(m_262, 3); V right16493_268 = FLD(m_263, 0); V right16494_269 = FLD(m_263, 1); V right16495_270 = FLD(m_263, 2); V right16496_271 = FLD(m_263, 3); _r = ((d_NativeString_dequal(left16489_264, right16493_268)) & (((d_Equal_dListOf_uSyntax_uBinder_u(left16490_265, right16494_269)) & (((d_Equal_dSyntax(left16491_266, right16495_270)) & (((d_Equal_dListOf_uSyntax_uFam_uctor_u(left16492_267, right16496_271)) & (TRUE_V)))))))); } else rt_panic("match: no case at tests:200"); _r; });
}
V d_Equal_dListOf_uSyntax_uFam_uctor_u(V left_272, V right_273) {
  return ({ V _r = 0; V m_274 = left_272; V m_275 = right_273; if (((m_274) == NIL) && ((m_275) == NIL)) {  _r = TRUE_V; } else if (((m_274) != NIL) && ((m_275) != NIL)) { V left16497_276 = FLD(m_274, 0); V left16498_277 = FLD(m_274, 1); V right16499_278 = FLD(m_275, 0); V right16500_279 = FLD(m_275, 1); _r = ((d_Equal_dSyntax_uFam_uctor(left16497_276, right16499_278)) & (((d_Equal_dListOf_uSyntax_uFam_uctor_u(left16498_277, right16500_279)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:204"); _r; });
}
V d_Equal_dSyntax_uFam_uctor(V left_280, V right_281) {
  return ({ V _r = 0; V m_282 = left_280; V m_283 = right_281; if ((tag_of(m_282) == 0) && (tag_of(m_283) == 0)) { V left16501_284 = FLD(m_282, 0); V left16502_285 = FLD(m_282, 1); V right16503_286 = FLD(m_283, 0); V right16504_287 = FLD(m_283, 1); _r = ((d_NativeString_dequal(left16501_284, right16503_286)) & (((d_Equal_dSyntax(left16502_285, right16504_287)) & (TRUE_V)))); } else rt_panic("match: no case at tests:210"); _r; });
}
V d_Equal_dListOf_uSyntax_uRec_udef_u(V left_288, V right_289) {
  return ({ V _r = 0; V m_290 = left_288; V m_291 = right_289; if (((m_290) == NIL) && ((m_291) == NIL)) {  _r = TRUE_V; } else if (((m_290) != NIL) && ((m_291) != NIL)) { V left16507_292 = FLD(m_290, 0); V left16508_293 = FLD(m_290, 1); V right16509_294 = FLD(m_291, 0); V right16510_295 = FLD(m_291, 1); _r = ((d_Equal_dSyntax_uRec_udef(left16507_292, right16509_294)) & (((d_Equal_dListOf_uSyntax_uRec_udef_u(left16508_293, right16510_295)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:214"); _r; });
}
V d_Equal_dSyntax_uRec_udef(V left_296, V right_297) {
  return ({ V _r = 0; V m_298 = left_296; V m_299 = right_297; if ((tag_of(m_298) == 0) && (tag_of(m_299) == 0)) { V left16511_300 = FLD(m_298, 0); V left16512_301 = FLD(m_298, 1); V left16513_302 = FLD(m_298, 2); V right16514_303 = FLD(m_299, 0); V right16515_304 = FLD(m_299, 1); V right16516_305 = FLD(m_299, 2); _r = ((d_NativeString_dequal(left16511_300, right16514_303)) & (((d_Equal_dSyntax(left16512_301, right16515_304)) & (((d_Equal_dSyntax(left16513_302, right16516_305)) & (TRUE_V)))))); } else rt_panic("match: no case at tests:220"); _r; });
}
V d_Equal_dAsm_uResult_uTupleOf3_uString_u_uListOf_uTupleOf2_uString_u_uBig_u_u_u_uListOf_uAsm_uHeight_u_u_u(V left_316, V right_317) {
  return ({ V _r = 0; V m_318 = left_316; V m_319 = right_317; if ((tag_of(m_318) == 1) && (tag_of(m_319) == 1)) { V left17000_320 = FLD(m_318, 0); V right17001_321 = FLD(m_319, 0); _r = ((d_Equal_dTupleOf3_uString_u_uListOf_uTupleOf2_uString_u_uBig_u_u_u_uListOf_uAsm_uHeight_u_u(left17000_320, right17001_321)) & (TRUE_V)); } else if ((tag_of(m_318) == 0) && (tag_of(m_319) == 0)) { V left17028_322 = FLD(m_318, 0); V right17029_323 = FLD(m_319, 0); _r = ((d_Equal_dAsm_uError(left17028_322, right17029_323)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:234"); _r; });
}
V d_Equal_dTupleOf3_uString_u_uListOf_uTupleOf2_uString_u_uBig_u_u_u_uListOf_uAsm_uHeight_u_u(V left_324, V right_325) {
  return ({ V _r = 0; V m_326 = left_324; V m_327 = right_325; if ((tag_of(m_326) == 0) && (tag_of(m_327) == 0)) { V left17002_328 = FLD(m_326, 0); V left17003_329 = FLD(m_326, 1); V left17004_330 = FLD(m_326, 2); V right17005_331 = FLD(m_327, 0); V right17006_332 = FLD(m_327, 1); V right17007_333 = FLD(m_327, 2); _r = ((d_NativeString_dequal(left17002_328, right17005_331)) & (((d_Equal_dListOf_uTupleOf2_uString_u_uBig_u_u(left17003_329, right17006_332)) & (((d_Equal_dListOf_uAsm_uHeight_u(left17004_330, right17007_333)) & (TRUE_V)))))); } else rt_panic("match: no case at tests:240"); _r; });
}
V d_Equal_dListOf_uAsm_uHeight_u(V left_334, V right_335) {
  return ({ V _r = 0; V m_336 = left_334; V m_337 = right_335; if (((m_336) == NIL) && ((m_337) == NIL)) {  _r = TRUE_V; } else if (((m_336) != NIL) && ((m_337) != NIL)) { V left17008_338 = FLD(m_336, 0); V left17009_339 = FLD(m_336, 1); V right17010_340 = FLD(m_337, 0); V right17011_341 = FLD(m_337, 1); _r = ((d_Equal_dAsm_uHeight(left17008_338, right17010_340)) & (((d_Equal_dListOf_uAsm_uHeight_u(left17009_339, right17011_341)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:244"); _r; });
}
V d_Equal_dAsm_uHeight(V left_342, V right_343) {
  return ({ V _r = 0; V m_344 = left_342; V m_345 = right_343; if ((tag_of(m_344) == 0) && (tag_of(m_345) == 0)) { V left17012_346 = FLD(m_344, 0); V left17013_347 = FLD(m_344, 1); V left17014_348 = FLD(m_344, 2); V left17015_349 = FLD(m_344, 3); V right17016_350 = FLD(m_345, 0); V right17017_351 = FLD(m_345, 1); V right17018_352 = FLD(m_345, 2); V right17019_353 = FLD(m_345, 3); _r = ((d_NativeString_dequal(left17012_346, right17016_350)) & (((d_Big_dis_ueq(left17013_347, right17017_351)) & (((d_Big_dis_ueq(left17014_348, right17018_352)) & (((d_Big_dis_ueq(left17015_349, right17019_353)) & (TRUE_V)))))))); } else rt_panic("match: no case at tests:250"); _r; });
}
V d_Equal_dListOf_uTupleOf2_uString_u_uBig_u_u(V left_354, V right_355) {
  return ({ V _r = 0; V m_356 = left_354; V m_357 = right_355; if (((m_356) == NIL) && ((m_357) == NIL)) {  _r = TRUE_V; } else if (((m_356) != NIL) && ((m_357) != NIL)) { V left17020_358 = FLD(m_356, 0); V left17021_359 = FLD(m_356, 1); V right17022_360 = FLD(m_357, 0); V right17023_361 = FLD(m_357, 1); _r = ((d_Equal_dTupleOf2_uString_u_uBig_u(left17020_358, right17022_360)) & (((d_Equal_dListOf_uTupleOf2_uString_u_uBig_u_u(left17021_359, right17023_361)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:254"); _r; });
}
V d_Equal_dTupleOf2_uString_u_uBig_u(V left_362, V right_363) {
  return ({ V _r = 0; V m_364 = left_362; V m_365 = right_363; if ((tag_of(m_364) == 0) && (tag_of(m_365) == 0)) { V left17024_366 = FLD(m_364, 0); V left17025_367 = FLD(m_364, 1); V right17026_368 = FLD(m_365, 0); V right17027_369 = FLD(m_365, 1); _r = ((d_NativeString_dequal(left17024_366, right17026_368)) & (((d_Big_dis_ueq(left17025_367, right17027_369)) & (TRUE_V)))); } else rt_panic("match: no case at tests:260"); _r; });
}
V d_Equal_dAsm_uError(V left_370, V right_371) {
  return ({ V _r = 0; V m_372 = left_370; V m_373 = right_371; if ((tag_of(m_372) == 0) && (tag_of(m_373) == 0)) {  _r = TRUE_V; } else if ((tag_of(m_372) == 1) && (tag_of(m_373) == 1)) {  _r = TRUE_V; } else if ((tag_of(m_372) == 2) && (tag_of(m_373) == 2)) { V left17030_374 = FLD(m_372, 0); V right17031_375 = FLD(m_373, 0); _r = ((d_NativeString_dequal(left17030_374, right17031_375)) & (TRUE_V)); } else if ((tag_of(m_372) == 3) && (tag_of(m_373) == 3)) { V left17032_376 = FLD(m_372, 0); V right17033_377 = FLD(m_373, 0); _r = ((d_NativeString_dequal(left17032_376, right17033_377)) & (TRUE_V)); } else if ((tag_of(m_372) == 4) && (tag_of(m_373) == 4)) { V left17034_378 = FLD(m_372, 0); V right17035_379 = FLD(m_373, 0); _r = ((d_NativeString_dequal(left17034_378, right17035_379)) & (TRUE_V)); } else if ((tag_of(m_372) == 5) && (tag_of(m_373) == 5)) { V left17036_380 = FLD(m_372, 0); V right17037_381 = FLD(m_373, 0); _r = ((d_NativeString_dequal(left17036_380, right17037_381)) & (TRUE_V)); } else if ((tag_of(m_372) == 6) && (tag_of(m_373) == 6)) { V left17038_382 = FLD(m_372, 0); V left17039_383 = FLD(m_372, 1); V right17040_384 = FLD(m_373, 0); V right17041_385 = FLD(m_373, 1); _r = ((d_NativeString_dequal(left17038_382, right17040_384)) & (((d_Big_dis_ueq(left17039_383, right17041_385)) & (TRUE_V)))); } else if ((tag_of(m_372) == 7) && (tag_of(m_373) == 7)) { V left17042_386 = FLD(m_372, 0); V right17043_387 = FLD(m_373, 0); _r = ((d_Big_dis_ueq(left17042_386, right17043_387)) & (TRUE_V)); } else if ((tag_of(m_372) == 8) && (tag_of(m_373) == 8)) { V left17044_388 = FLD(m_372, 0); V left17045_389 = FLD(m_372, 1); V right17046_390 = FLD(m_373, 0); V right17047_391 = FLD(m_373, 1); _r = ((d_NativeString_dequal(left17044_388, right17046_390)) & (((d_Big_dis_ueq(left17045_389, right17047_391)) & (TRUE_V)))); } else if ((tag_of(m_372) == 9) && (tag_of(m_373) == 9)) { V left17048_392 = FLD(m_372, 0); V right17049_393 = FLD(m_373, 0); _r = ((d_Big_dis_ueq(left17048_392, right17049_393)) & (TRUE_V)); } else if ((tag_of(m_372) == 10) && (tag_of(m_373) == 10)) { V left17050_394 = FLD(m_372, 0); V right17051_395 = FLD(m_373, 0); _r = ((d_NativeString_dequal(left17050_394, right17051_395)) & (TRUE_V)); } else if ((tag_of(m_372) == 11) && (tag_of(m_373) == 11)) { V left17052_396 = FLD(m_372, 0); V right17053_397 = FLD(m_373, 0); _r = ((d_NativeString_dequal(left17052_396, right17053_397)) & (TRUE_V)); } else if ((tag_of(m_372) == 12) && (tag_of(m_373) == 12)) { V left17054_398 = FLD(m_372, 0); V left17055_399 = FLD(m_372, 1); V right17056_400 = FLD(m_373, 0); V right17057_401 = FLD(m_373, 1); _r = ((d_NativeString_dequal(left17054_398, right17056_400)) & (((d_Big_dis_ueq(left17055_399, right17057_401)) & (TRUE_V)))); } else if ((tag_of(m_372) == 13) && (tag_of(m_373) == 13)) { V left17058_402 = FLD(m_372, 0); V left17059_403 = FLD(m_372, 1); V right17060_404 = FLD(m_373, 0); V right17061_405 = FLD(m_373, 1); _r = ((d_NativeString_dequal(left17058_402, right17060_404)) & (((d_NativeString_dequal(left17059_403, right17061_405)) & (TRUE_V)))); } else if ((tag_of(m_372) == 14) && (tag_of(m_373) == 14)) {  _r = TRUE_V; } else if ((tag_of(m_372) == 15) && (tag_of(m_373) == 15)) { V left17062_406 = FLD(m_372, 0); V left17063_407 = FLD(m_372, 1); V left17064_408 = FLD(m_372, 2); V left17065_409 = FLD(m_372, 3); V right17066_410 = FLD(m_373, 0); V right17067_411 = FLD(m_373, 1); V right17068_412 = FLD(m_373, 2); V right17069_413 = FLD(m_373, 3); _r = ((d_NativeString_dequal(left17062_406, right17066_410)) & (((d_NativeString_dequal(left17063_407, right17067_411)) & (((d_Big_dis_ueq(left17064_408, right17068_412)) & (((d_Big_dis_ueq(left17065_409, right17069_413)) & (TRUE_V)))))))); } else if ((tag_of(m_372) == 16) && (tag_of(m_373) == 16)) { V left17070_414 = FLD(m_372, 0); V left17071_415 = FLD(m_372, 1); V left17072_416 = FLD(m_372, 2); V right17073_417 = FLD(m_373, 0); V right17074_418 = FLD(m_373, 1); V right17075_419 = FLD(m_373, 2); _r = ((d_NativeString_dequal(left17070_414, right17073_417)) & (((d_NativeString_dequal(left17071_415, right17074_418)) & (((d_Big_dis_ueq(left17072_416, right17075_419)) & (TRUE_V)))))); } else if ((tag_of(m_372) == 17) && (tag_of(m_373) == 17)) { V left17076_420 = FLD(m_372, 0); V left17077_421 = FLD(m_372, 1); V left17078_422 = FLD(m_372, 2); V left17079_423 = FLD(m_372, 3); V right17080_424 = FLD(m_373, 0); V right17081_425 = FLD(m_373, 1); V right17082_426 = FLD(m_373, 2); V right17083_427 = FLD(m_373, 3); _r = ((d_NativeString_dequal(left17076_420, right17080_424)) & (((d_NativeString_dequal(left17077_421, right17081_425)) & (((d_Big_dis_ueq(left17078_422, right17082_426)) & (((d_Big_dis_ueq(left17079_423, right17083_427)) & (TRUE_V)))))))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:264"); _r; });
}
V d_Get_dAsm_dHeight_dincoming(V value_428) {
  return ({ V _r = 0; V m_429 = value_428; if ((tag_of(m_429) == 0)) { V field1_430 = FLD(m_429, 1); _r = field1_430; } else rt_panic("match: no case at tests:286"); _r; });
}
V d_Get_dAsm_dHeight_doutgoing(V value_431) {
  return ({ V _r = 0; V m_432 = value_431; if ((tag_of(m_432) == 0)) { V field2_433 = FLD(m_432, 2); _r = field2_433; } else rt_panic("match: no case at tests:290"); _r; });
}
V d_Get_dAsm_dHeight_dpeak(V value_434) {
  return ({ V _r = 0; V m_435 = value_434; if ((tag_of(m_435) == 0)) { V field3_436 = FLD(m_435, 3); _r = field3_436; } else rt_panic("match: no case at tests:294"); _r; });
}
V d_Equal_dListOf_uTupleOf3_uBig_u_uBig_u_uBig_u_u(V left_437, V right_438) {
  return ({ V _r = 0; V m_439 = left_437; V m_440 = right_438; if (((m_439) == NIL) && ((m_440) == NIL)) {  _r = TRUE_V; } else if (((m_439) != NIL) && ((m_440) != NIL)) { V left17224_441 = FLD(m_439, 0); V left17225_442 = FLD(m_439, 1); V right17226_443 = FLD(m_440, 0); V right17227_444 = FLD(m_440, 1); _r = ((d_Equal_dTupleOf3_uBig_u_uBig_u_uBig_u(left17224_441, right17226_443)) & (((d_Equal_dListOf_uTupleOf3_uBig_u_uBig_u_uBig_u_u(left17225_442, right17227_444)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:298"); _r; });
}
V d_Equal_dTupleOf3_uBig_u_uBig_u_uBig_u(V left_445, V right_446) {
  return ({ V _r = 0; V m_447 = left_445; V m_448 = right_446; if ((tag_of(m_447) == 0) && (tag_of(m_448) == 0)) { V left17228_449 = FLD(m_447, 0); V left17229_450 = FLD(m_447, 1); V left17230_451 = FLD(m_447, 2); V right17231_452 = FLD(m_448, 0); V right17232_453 = FLD(m_448, 1); V right17233_454 = FLD(m_448, 2); _r = ((d_Big_dis_ueq(left17228_449, right17231_452)) & (((d_Big_dis_ueq(left17229_450, right17232_453)) & (((d_Big_dis_ueq(left17230_451, right17233_454)) & (TRUE_V)))))); } else rt_panic("match: no case at tests:304"); _r; });
}
V d_Equal_dEmit_uResult_uRecognize_uValue_u(V left_455, V right_456) {
  return ({ V _r = 0; V m_457 = left_455; V m_458 = right_456; if ((tag_of(m_457) == 1) && (tag_of(m_458) == 1)) { V left17306_459 = FLD(m_457, 0); V right17307_460 = FLD(m_458, 0); _r = ((d_Equal_dRecognize_uValue(left17306_459, right17307_460)) & (TRUE_V)); } else if ((tag_of(m_457) == 0) && (tag_of(m_458) == 0)) { V left17334_461 = FLD(m_457, 0); V right17335_462 = FLD(m_458, 0); _r = ((d_Equal_dEmit_uError(left17334_461, right17335_462)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:308"); _r; });
}
V d_Equal_dRecognize_uValue(V left_463, V right_464) {
  return ({ V _r = 0; V m_465 = left_463; V m_466 = right_464; if ((tag_of(m_465) == 0) && (tag_of(m_466) == 0)) { V left17308_467 = FLD(m_465, 0); V right17309_468 = FLD(m_466, 0); _r = ((d_Big_dis_ueq(left17308_467, right17309_468)) & (TRUE_V)); } else if ((tag_of(m_465) == 1) && (tag_of(m_466) == 1)) { V left17310_469 = FLD(m_465, 0); V right17311_470 = FLD(m_466, 0); _r = ((d_Big_dis_ueq(left17310_469, right17311_470)) & (TRUE_V)); } else if ((tag_of(m_465) == 2) && (tag_of(m_466) == 2)) {  _r = TRUE_V; } else if ((tag_of(m_465) == 3) && (tag_of(m_466) == 3)) { V left17312_471 = FLD(m_465, 0); V right17313_472 = FLD(m_466, 0); _r = ((d_Big_dis_ueq(left17312_471, right17313_472)) & (TRUE_V)); } else if ((tag_of(m_465) == 4) && (tag_of(m_466) == 4)) { V left17314_473 = FLD(m_465, 0); V left17315_474 = FLD(m_465, 1); V left17316_475 = FLD(m_465, 2); V right17317_476 = FLD(m_466, 0); V right17318_477 = FLD(m_466, 1); V right17319_478 = FLD(m_466, 2); _r = ((d_NativeString_dequal(left17314_473, right17317_476)) & (((d_Big_dis_ueq(left17315_474, right17318_477)) & (((d_Equal_dListOf_uRecognize_uValue_u(left17316_475, right17319_478)) & (TRUE_V)))))); } else if ((tag_of(m_465) == 5) && (tag_of(m_466) == 5)) { V left17324_479 = FLD(m_465, 0); V left17325_480 = FLD(m_465, 1); V right17326_481 = FLD(m_466, 0); V right17327_482 = FLD(m_466, 1); _r = ((d_Equal_dEterm_uTid(left17324_479, right17326_481)) & (((d_Equal_dListOf_uRecognize_uValue_u(left17325_480, right17327_482)) & (TRUE_V)))); } else if ((tag_of(m_465) == 6) && (tag_of(m_466) == 6)) { V left17328_483 = FLD(m_465, 0); V left17329_484 = FLD(m_465, 1); V left17330_485 = FLD(m_465, 2); V right17331_486 = FLD(m_466, 0); V right17332_487 = FLD(m_466, 1); V right17333_488 = FLD(m_466, 2); _r = ((d_Equal_dEterm_uTid(left17328_483, right17331_486)) & (((d_Big_dis_ueq(left17329_484, right17332_487)) & (((d_Equal_dListOf_uRecognize_uValue_u(left17330_485, right17333_488)) & (TRUE_V)))))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:314"); _r; });
}
V d_Equal_dListOf_uRecognize_uValue_u(V left_489, V right_490) {
  return ({ V _r = 0; V m_491 = left_489; V m_492 = right_490; if (((m_491) == NIL) && ((m_492) == NIL)) {  _r = TRUE_V; } else if (((m_491) != NIL) && ((m_492) != NIL)) { V left17320_493 = FLD(m_491, 0); V left17321_494 = FLD(m_491, 1); V right17322_495 = FLD(m_492, 0); V right17323_496 = FLD(m_492, 1); _r = ((d_Equal_dRecognize_uValue(left17320_493, right17322_495)) & (((d_Equal_dListOf_uRecognize_uValue_u(left17321_494, right17323_496)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:325"); _r; });
}
V d_Equal_dEmit_uError(V left_497, V right_498) {
  return ({ V _r = 0; V m_499 = left_497; V m_500 = right_498; if ((tag_of(m_499) == 0) && (tag_of(m_500) == 0)) { V left17336_501 = FLD(m_499, 0); V right17337_502 = FLD(m_500, 0); _r = ((d_Equal_dRecognize_uError(left17336_501, right17337_502)) & (TRUE_V)); } else if ((tag_of(m_499) == 1) && (tag_of(m_500) == 1)) { V left17340_503 = FLD(m_499, 0); V right17341_504 = FLD(m_500, 0); _r = ((d_NativeString_dequal(left17340_503, right17341_504)) & (TRUE_V)); } else if ((tag_of(m_499) == 2) && (tag_of(m_500) == 2)) { V left17342_505 = FLD(m_499, 0); V right17343_506 = FLD(m_500, 0); _r = ((d_NativeString_dequal(left17342_505, right17343_506)) & (TRUE_V)); } else if ((tag_of(m_499) == 3) && (tag_of(m_500) == 3)) {  _r = TRUE_V; } else if ((tag_of(m_499) == 4) && (tag_of(m_500) == 4)) { V left17344_507 = FLD(m_499, 0); V right17345_508 = FLD(m_500, 0); _r = ((d_NativeString_dequal(left17344_507, right17345_508)) & (TRUE_V)); } else if ((tag_of(m_499) == 5) && (tag_of(m_500) == 5)) { V left17346_509 = FLD(m_499, 0); V right17347_510 = FLD(m_500, 0); _r = ((d_NativeString_dequal(left17346_509, right17347_510)) & (TRUE_V)); } else if ((tag_of(m_499) == 6) && (tag_of(m_500) == 6)) {  _r = TRUE_V; } else if ((tag_of(m_499) == 7) && (tag_of(m_500) == 7)) {  _r = TRUE_V; } else if ((tag_of(m_499) == 8) && (tag_of(m_500) == 8)) {  _r = TRUE_V; } else if ((tag_of(m_499) == 9) && (tag_of(m_500) == 9)) {  _r = TRUE_V; } else if ((tag_of(m_499) == 10) && (tag_of(m_500) == 10)) { V left17348_511 = FLD(m_499, 0); V right17349_512 = FLD(m_500, 0); _r = ((d_Equal_dAsm_uError(left17348_511, right17349_512)) & (TRUE_V)); } else if ((tag_of(m_499) == 11) && (tag_of(m_500) == 11)) { V left17350_513 = FLD(m_499, 0); V right17351_514 = FLD(m_500, 0); _r = ((d_NativeString_dequal(left17350_513, right17351_514)) & (TRUE_V)); } else if ((tag_of(m_499) == 12) && (tag_of(m_500) == 12)) { V left17352_515 = FLD(m_499, 0); V right17353_516 = FLD(m_500, 0); _r = ((d_NativeString_dequal(left17352_515, right17353_516)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:331"); _r; });
}
V d_Equal_dRecognize_uError(V left_517, V right_518) {
  return ({ V _r = 0; V m_519 = left_517; V m_520 = right_518; if ((tag_of(m_519) == 0) && (tag_of(m_520) == 0)) { V left17338_521 = FLD(m_519, 0); V right17339_522 = FLD(m_520, 0); _r = ((d_NativeString_dequal(left17338_521, right17339_522)) & (TRUE_V)); } else if ((tag_of(m_519) == 1) && (tag_of(m_520) == 1)) {  _r = TRUE_V; } else if ((tag_of(m_519) == 2) && (tag_of(m_520) == 2)) {  _r = TRUE_V; } else if ((tag_of(m_519) == 3) && (tag_of(m_520) == 3)) {  _r = TRUE_V; } else if ((tag_of(m_519) == 4) && (tag_of(m_520) == 4)) {  _r = TRUE_V; } else if ((tag_of(m_519) == 5) && (tag_of(m_520) == 5)) {  _r = TRUE_V; } else if ((tag_of(m_519) == 6) && (tag_of(m_520) == 6)) {  _r = TRUE_V; } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:348"); _r; });
}
V d_Equal_dEmit_uResult_uTupleOf2_uRecognize_uValue_u_uBig_u_u(V left_523, V right_524) {
  return ({ V _r = 0; V m_525 = left_523; V m_526 = right_524; if ((tag_of(m_525) == 1) && (tag_of(m_526) == 1)) { V left17354_527 = FLD(m_525, 0); V right17355_528 = FLD(m_526, 0); _r = ((d_Equal_dTupleOf2_uRecognize_uValue_u_uBig_u(left17354_527, right17355_528)) & (TRUE_V)); } else if ((tag_of(m_525) == 0) && (tag_of(m_526) == 0)) { V left17360_529 = FLD(m_525, 0); V right17361_530 = FLD(m_526, 0); _r = ((d_Equal_dEmit_uError(left17360_529, right17361_530)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:359"); _r; });
}
V d_Equal_dTupleOf2_uRecognize_uValue_u_uBig_u(V left_531, V right_532) {
  return ({ V _r = 0; V m_533 = left_531; V m_534 = right_532; if ((tag_of(m_533) == 0) && (tag_of(m_534) == 0)) { V left17356_535 = FLD(m_533, 0); V left17357_536 = FLD(m_533, 1); V right17358_537 = FLD(m_534, 0); V right17359_538 = FLD(m_534, 1); _r = ((d_Equal_dRecognize_uValue(left17356_535, right17358_537)) & (((d_Big_dis_ueq(left17357_536, right17359_538)) & (TRUE_V)))); } else rt_panic("match: no case at tests:365"); _r; });
}
V d_Equal_dEmit_uResult_uEmit_uEffect_u(V left_539, V right_540) {
  return ({ V _r = 0; V m_541 = left_539; V m_542 = right_540; if ((tag_of(m_541) == 1) && (tag_of(m_542) == 1)) { V left17362_543 = FLD(m_541, 0); V right17363_544 = FLD(m_542, 0); _r = ((d_Equal_dEmit_uEffect(left17362_543, right17363_544)) & (TRUE_V)); } else if ((tag_of(m_541) == 0) && (tag_of(m_542) == 0)) { V left17378_545 = FLD(m_541, 0); V right17379_546 = FLD(m_542, 0); _r = ((d_Equal_dEmit_uError(left17378_545, right17379_546)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:369"); _r; });
}
V d_Equal_dEmit_uEffect(V left_547, V right_548) {
  return ({ V _r = 0; V m_549 = left_547; V m_550 = right_548; if ((tag_of(m_549) == 0) && (tag_of(m_550) == 0)) { V left17364_551 = FLD(m_549, 0); V right17365_552 = FLD(m_550, 0); _r = ((d_Big_dis_ueq(left17364_551, right17365_552)) & (TRUE_V)); } else if ((tag_of(m_549) == 1) && (tag_of(m_550) == 1)) { V left17366_553 = FLD(m_549, 0); V right17367_554 = FLD(m_550, 0); _r = ((d_Big_dis_ueq(left17366_553, right17367_554)) & (TRUE_V)); } else if ((tag_of(m_549) == 2) && (tag_of(m_550) == 2)) { V left17368_555 = FLD(m_549, 0); V left17369_556 = FLD(m_549, 1); V left17370_557 = FLD(m_549, 2); V right17371_558 = FLD(m_550, 0); V right17372_559 = FLD(m_550, 1); V right17373_560 = FLD(m_550, 2); _r = ((d_Big_dis_ueq(left17368_555, right17371_558)) & (((d_Big_dis_ueq(left17369_556, right17372_559)) & (((d_Equal_dEmit_uEffect(left17370_557, right17373_560)) & (TRUE_V)))))); } else if ((tag_of(m_549) == 3) && (tag_of(m_550) == 3)) { V left17374_561 = FLD(m_549, 0); V left17375_562 = FLD(m_549, 1); V right17376_563 = FLD(m_550, 0); V right17377_564 = FLD(m_550, 1); _r = ((d_Big_dis_ueq(left17374_561, right17376_563)) & (((d_Equal_dEmit_uEffect(left17375_562, right17377_564)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:375"); _r; });
}
V d_Equal_dResultOf_uRecognize_uError_u_uRecognize_uValue_u(V left_565, V right_566) {
  return ({ V _r = 0; V m_567 = left_565; V m_568 = right_566; if ((tag_of(m_567) == 1) && (tag_of(m_568) == 1)) { V left17400_569 = FLD(m_567, 0); V right17401_570 = FLD(m_568, 0); _r = ((d_Equal_dRecognize_uValue(left17400_569, right17401_570)) & (TRUE_V)); } else if ((tag_of(m_567) == 0) && (tag_of(m_568) == 0)) { V left17402_571 = FLD(m_567, 0); V right17403_572 = FLD(m_568, 0); _r = ((d_Equal_dRecognize_uError(left17402_571, right17403_572)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:383"); _r; });
}
V d_Equal_dResultOf_uRecognize_uError_u_uUnit_u(V left_573, V right_574) {
  return ({ V _r = 0; V m_575 = left_573; V m_576 = right_574; if ((tag_of(m_575) == 1) && (tag_of(m_576) == 1)) { V left17404_577 = FLD(m_575, 0); V right17405_578 = FLD(m_576, 0); _r = ((d_Equal_dUnit(left17404_577, right17405_578)) & (TRUE_V)); } else if ((tag_of(m_575) == 0) && (tag_of(m_576) == 0)) { V left17406_579 = FLD(m_575, 0); V right17407_580 = FLD(m_576, 0); _r = ((d_Equal_dRecognize_uError(left17406_579, right17407_580)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:389"); _r; });
}
V d_Equal_dUnit(V left_581, V right_582) {
  return ({ V _r = 0; V m_583 = left_581; V m_584 = right_582; if ((1) && (1)) {  _r = TRUE_V; } else rt_panic("match: no case at tests:395"); _r; });
}
V d_Equal_dResultOf_uRecognize_uError_u_uListOf_uString_u_u(V left_585, V right_586) {
  return ({ V _r = 0; V m_587 = left_585; V m_588 = right_586; if ((tag_of(m_587) == 1) && (tag_of(m_588) == 1)) { V left17464_589 = FLD(m_587, 0); V right17465_590 = FLD(m_588, 0); _r = ((d_Equal_dListOf_uString_u(left17464_589, right17465_590)) & (TRUE_V)); } else if ((tag_of(m_587) == 0) && (tag_of(m_588) == 0)) { V left17466_591 = FLD(m_587, 0); V right17467_592 = FLD(m_588, 0); _r = ((d_Equal_dRecognize_uError(left17466_591, right17467_592)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at tests:399"); _r; });
}
V d_Get_dPositivity_dCtor_dc_ufull_uarity(V value_598) {
  return ({ V _r = 0; V m_599 = value_598; if ((tag_of(m_599) == 0)) { V field3_600 = FLD(m_599, 3); _r = field3_600; } else rt_panic("match: no case at tests:411"); _r; });
}
V d_Check_dinfer_uterm(V _opt__1562_601, V globals_1560_602, V t_1561_603) {
  return ({ V scrut16117_604 = ({ V scrut16115_605 = _opt__1562_601; ({ V _r = 0; V m_606 = scrut16115_605; if (((m_606) == NONE)) {  _r = ({ V __607 = UNIT; d_Budget_dunlimited(); }); } else if (((m_606) != NONE)) { V _m_606_a0_608 = FLD(m_606, 0); _r = ({ V p16116_609 = _m_606_a0_608; p16116_609; }); } else rt_panic("match: no case at tests:421"); _r; }); }); d_Check_dinfer(d_Check_dmake(globals_1560_602, scrut16117_604), ((V)2), t_1561_603); });
}
V d_Error_dmessage(V e_349_610) {
  return ({ V scrut16125_611 = e_349_610; ({ V _r = 0; V m_612 = scrut16125_611; switch (tag_of(m_612)) { case 0: { V _m_612_a0_613 = FLD(m_612, 0); _r = ({ V p16126_614 = _m_612_a0_613; p16126_614; }); break; } case 1: { V _m_612_a0_615 = FLD(m_612, 0); V _m_612_a1_616 = FLD(m_612, 1); V _m_612_a2_617 = FLD(m_612, 2); _r = ({ V p16127_618 = _m_612_a0_615; ({ V p16128_619 = _m_612_a1_616; ({ V p16129_620 = _m_612_a2_617; p16127_618; }); }); }); break; } case 2: { V _m_612_a0_621 = FLD(m_612, 0); _r = ({ V p16130_622 = _m_612_a0_621; p16130_622; }); break; } case 3: { V _m_612_a0_623 = FLD(m_612, 0); _r = ({ V p16131_624 = _m_612_a0_623; p16131_624; }); break; } case 4: { V _m_612_a0_625 = FLD(m_612, 0); _r = ({ V p16132_626 = _m_612_a0_625; p16132_626; }); break; } case 5: { V _m_612_a0_627 = FLD(m_612, 0); _r = ({ V p16133_628 = _m_612_a0_627; p16133_628; }); break; } case 6: { V _m_612_a0_629 = FLD(m_612, 0); _r = ({ V p16134_630 = _m_612_a0_629; p16134_630; }); break; } case 7: { V _m_612_a0_631 = FLD(m_612, 0); _r = ({ V p16135_632 = _m_612_a0_631; p16135_632; }); break; } case 8: { V _m_612_a0_633 = FLD(m_612, 0); _r = ({ V p16136_634 = _m_612_a0_633; p16136_634; }); break; } case 9: { V _m_612_a0_635 = FLD(m_612, 0); _r = ({ V p16137_636 = _m_612_a0_635; p16137_636; }); break; } case 10: { V _m_612_a0_637 = FLD(m_612, 0); _r = ({ V p16138_638 = _m_612_a0_637; p16138_638; }); break; } case 11: { V _m_612_a0_639 = FLD(m_612, 0); _r = ({ V p16139_640 = _m_612_a0_639; p16139_640; }); break; } case 12: { V _m_612_a0_641 = FLD(m_612, 0); _r = ({ V p16140_642 = _m_612_a0_641; p16140_642; }); break; } case 13: { V _m_612_a0_643 = FLD(m_612, 0); _r = ({ V p16141_644 = _m_612_a0_643; p16141_644; }); break; } case 14: { V _m_612_a0_645 = FLD(m_612, 0); _r = ({ V p16142_646 = _m_612_a0_645; d_Error_dtermination_umsg(p16142_646); }); break; } default: rt_panic("match: no case at tests:426"); } _r; }); });
}
V d_Main_dkneg_usmu(V param_911_647) {
  return ({ V scrut16111_648 = param_911_647; ({ V scrut16112_649 = rt_ctor2(3, ((V)&S_0), CON(rt_ctor1(1, d_Level_dzero()), NIL)); ({ V scrut16113_650 = rt_ctor2(6, rt_ctor1(1, d_Big_dzero()), NIL); ({ V local16120_651 = d_Check_dinfer_uterm(NONE, d_Global_dinitial(), rt_ctor2(3, scrut16112_649, scrut16113_650)); ({ V _r = 0; V m_652 = local16120_651; switch (tag_of(m_652)) { case 1: { V _m_652_a0_653 = FLD(m_652, 0); _r = ({ V x_654 = _m_652_a0_653; ({ V local16122_655 = x_654; FAIL(((V)&S_1)); }); }); break; } case 0: { V _m_652_a0_656 = FLD(m_652, 0); _r = ({ V x_657 = _m_652_a0_656; ({ V local16124_658 = x_657; ({ V scrut16143_659 = d_Error_dmessage(local16124_658); ((d_NativeString_dequal(scrut16143_659, ((V)&S_2))) != FALSE_V ? DONE(UNIT) : FAIL(str_concat(CON(((V)&S_3), CON(scrut16143_659, CON(((V)&S_4), NIL)))))); }); }); }); break; } default: rt_panic("match: no case at tests:432"); } _r; }); }); }); }); });
}
V d_Totality_dguard(V _opt__795_660, V globals_761_661, V name_762_662, V ty_763_663, V body_764_664) {
  return ({ V scrut16149_665 = ({ V scrut16147_666 = _opt__795_660; ({ V _r = 0; V m_667 = scrut16147_666; if (((m_667) == NONE)) {  _r = ({ V __668 = UNIT; d_Budget_dunlimited(); }); } else if (((m_667) != NONE)) { V _m_667_a0_669 = FLD(m_667, 0); _r = ({ V p16148_670 = _m_667_a0_669; p16148_670; }); } else rt_panic("match: no case at tests:437"); _r; }); }); ({ V scrut16150_671 = ty_763_663; ({ V local16153_672 = d_Totality_dguard_ugroup(SOME(scrut16149_665), globals_761_661, CON(rt_ctor2(0, name_762_662, body_764_664), NIL)); ({ V _r = 0; V m_673 = local16153_672; switch (tag_of(m_673)) { case 1: { V _m_673_a0_674 = FLD(m_673, 0); _r = ({ V item16161_675 = _m_673_a0_674; DONE(({ V local16156_676 = item16161_675; ({ V _r = 0; V m_677 = local16156_676; if (((m_677) == NONE)) {  _r = ({ V __678 = UNIT; NONE; }); } else if (((m_677) != NONE)) { V _m_677_a0_679 = FLD(m_677, 0); _r = ({ V item16160_680 = _m_677_a0_679; SOME(({ V local16158_681 = item16160_680; d_Get_dOrder_do_uarg(local16158_681); })); }); } else rt_panic("match: no case at tests:439"); _r; }); })); }); break; } case 0: { V _m_673_a0_682 = FLD(m_673, 0); _r = ({ V item16162_683 = _m_673_a0_682; FAIL(item16162_683); }); break; } default: rt_panic("match: no case at tests:439"); } _r; }); }); }); });
}
V d_Main_dguarded_uself(void) {
  static V memo; static int done;
  if (!done) { memo = ({ V scrut16174_684 = rt_ctor3(0, ((V)2), ((V)&S_5), rt_ctor1(10, ((V)&S_6))); ({ V scrut16175_685 = rt_ctor3(7, scrut16174_684, rt_ctor2(0, ((V)2), rt_ctor1(0, d_Big_dzero())), rt_ctor1(10, ((V)&S_7))); ({ V scrut16176_686 = rt_ctor2(0, rt_ctor1(2, ((V)&S_8)), rt_ctor2(0, CON(rt_ctor2(0, ((V)2), ((V)&S_9)), NIL), scrut16175_685)); ({ V scrut16177_687 = rt_ctor1(5, ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = rt_ctor2(3, ((V)&S_6), NIL); _o->f[1] = rt_ctor1(0, d_Big_dzero()); _o->f[2] = ((V)2); _o->f[3] = SOME(rt_ctor4(0, SOME(((V)&S_6)), NIL, ((V)&S_10), rt_ctor1(10, ((V)&S_6)))); _o->f[4] = CON(scrut16176_686, NIL); (V)_o; })); rt_ctor2(6, scrut16174_684, CON(rt_ctor2(0, CON(rt_ctor2(0, ((V)2), ((V)&S_5)), NIL), scrut16177_687), NIL)); }); }); }); }); rt_root(&memo); done = 1; }
  return memo;
}
V d_Main_dkneg_uself(V param_1039_688) {
  return ({ V scrut16144_689 = param_1039_688; ({ V _r = 0; V m_690 = ({ V local16165_691 = d_Totality_dguard(NONE, d_Global_dinitial(), ((V)&S_7), rt_ctor1(10, ((V)&S_11)), rt_ctor1(10, ((V)&S_7))); ({ V _r = 0; V m_692 = local16165_691; switch (tag_of(m_692)) { case 1: { V _m_692_a0_693 = FLD(m_692, 0); _r = ({ V x_694 = _m_692_a0_693; ({ V local16167_695 = x_694; FAIL(((V)&S_12)); }); }); break; } case 0: { V _m_692_a0_696 = FLD(m_692, 0); _r = ({ V x_697 = _m_692_a0_696; ({ V local16169_698 = x_697; ({ V scrut16170_699 = d_Error_dmessage(local16169_698); ((d_NativeString_dequal(scrut16170_699, ((V)&S_13))) != FALSE_V ? DONE(UNIT) : FAIL(str_concat(CON(((V)&S_3), CON(scrut16170_699, CON(((V)&S_4), NIL)))))); }); }); }); break; } default: rt_panic("match: no case at tests:450"); } _r; }); }); switch (tag_of(m_690)) { case 1: { V _m_690_a0_700 = FLD(m_690, 0); _r = ({ V item16190_701 = _m_690_a0_700; ({ V local16172_702 = item16190_701; ({ V scrut16173_703 = local16172_702; ({ V local16180_704 = d_Totality_dguard(NONE, d_Global_dinitial(), ((V)&S_7), rt_ctor1(10, ((V)&S_11)), d_Main_dguarded_uself()); ({ V _r = 0; V m_705 = local16180_704; switch (tag_of(m_705)) { case 1: { V _m_705_a0_706 = FLD(m_705, 0); _r = ({ V x_707 = _m_705_a0_706; ({ V local16182_708 = x_707; ({ V local16185_709 = local16182_708; ({ V _r = 0; V m_710 = local16185_709; if (((m_710) == NONE)) {  _r = ({ V __711 = UNIT; FAIL(((V)&S_14)); }); } else if (((m_710) != NONE)) { V _m_710_a0_712 = FLD(m_710, 0); _r = ({ V value_713 = _m_710_a0_712; ({ V local16187_714 = value_713; ((d_Big_dis_ueq(local16187_714, d_Big_dzero())) != FALSE_V ? DONE(UNIT) : FAIL(str_concat(CON(((V)&S_15), CON(d_Big_dshow(local16187_714), NIL))))); }); }); } else rt_panic("match: no case at tests:452"); _r; }); }); }); }); break; } case 0: { V _m_705_a0_715 = FLD(m_705, 0); _r = ({ V x_716 = _m_705_a0_715; ({ V local16189_717 = x_716; FAIL(str_concat(CON(((V)&S_3), CON(d_Error_dmessage(local16189_717), CON(((V)&S_4), NIL))))); }); }); break; } default: rt_panic("match: no case at tests:452"); } _r; }); }); }); }); }); break; } case 0: { V _m_690_a0_718 = FLD(m_690, 0); _r = ({ V item16191_719 = _m_690_a0_718; FAIL(item16191_719); }); break; } default: rt_panic("match: no case at tests:450"); } _r; }); });
}
V d_Main_dkneg(V name_1042_720) {
  return ({ V scrut16110_721 = UNIT; ((d_NativeString_dequal(name_1042_720, ((V)&S_16))) != FALSE_V ? d_Main_dkneg_usmu(UNIT) : ((d_NativeString_dequal(name_1042_720, ((V)&S_7))) != FALSE_V ? d_Main_dkneg_uself(UNIT) : ((d_NativeString_dequal(name_1042_720, ((V)&S_17))) != FALSE_V ? d_Main_dkneg_ushape(rt_ctor2(2, rt_ctor1(1, d_Level_dzero()), rt_ctor1(1, d_Level_dzero())), ((V)&S_18)) : ((d_NativeString_dequal(name_1042_720, ((V)&S_19))) != FALSE_V ? d_Main_dkneg_ushape(rt_ctor2(4, ((V)&S_0), CON(rt_ctor1(1, d_Level_dzero()), NIL)), ((V)&S_20)) : FAIL(str_concat(CON(((V)&S_21), CON(name_1042_720, CON(((V)&S_4), NIL))))))))); });
}
V d_Main_drecursive_uvalues(V _name_1144_722) {
  return ({ V scrut16193_723 = ((V)&S_22); ({ V scrut16330_724 = ({ V _c = clo_new(lam_888, 1, 1); CLO_ENV(_c)[0] = scrut16193_723; _c; }); ({ V _r = 0; V m_889 = ap(scrut16330_724, UNIT); switch (tag_of(m_889)) { case 1: { V _m_889_a0_890 = FLD(m_889, 0); _r = ({ V item16331_891 = _m_889_a0_890; DONE(item16331_891); }); break; } case 0: { V _m_889_a0_892 = FLD(m_889, 0); _r = ({ V item16332_893 = _m_889_a0_892; FAIL(d_Error_dto_ustring(item16332_893)); }); break; } default: rt_panic("match: no case at tests:472"); } _r; }); }); });
}
V d_Sl_usurface_dfamily(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_47); rt_root(&memo); done = 1; }
  return memo;
}
V d_Sl_usurface_dlegacy_ufamily(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_48); rt_root(&memo); done = 1; }
  return memo;
}
V d_Sl_usurface_dparse(V source_325_894) {
  return ({ V local16339_895 = d_Parser_dparse(source_325_894); ({ V _r = 0; V m_896 = local16339_895; switch (tag_of(m_896)) { case 1: { V _m_896_a0_897 = FLD(m_896, 0); _r = ({ V item16340_898 = _m_896_a0_897; DONE(item16340_898); }); break; } case 0: { V _m_896_a0_899 = FLD(m_896, 0); _r = ({ V item16341_900 = _m_896_a0_899; FAIL(d_Error_dto_ustring(item16341_900)); }); break; } default: rt_panic("match: no case at tests:481"); } _r; }); });
}
V d_Sl_usurface_dsame_utree(V first_484_901, V second_485_902) {
  return ({ V _r = 0; V m_903 = d_Sl_usurface_dparse(first_484_901); switch (tag_of(m_903)) { case 1: { V _m_903_a0_904 = FLD(m_903, 0); _r = ({ V item16519_905 = _m_903_a0_904; ({ V local16343_906 = item16519_905; ({ V _r = 0; V m_907 = d_Sl_usurface_dparse(second_485_902); switch (tag_of(m_907)) { case 1: { V _m_907_a0_908 = FLD(m_907, 0); _r = ({ V item16517_909 = _m_907_a0_908; ({ V local16346_910 = item16517_909; ((d_Equal_dListOf_uSyntax_uDecl_u(local16343_906, local16346_910)) != FALSE_V ? DONE(UNIT) : FAIL(((V)&S_49))); }); }); break; } case 0: { V _m_907_a0_911 = FLD(m_907, 0); _r = ({ V item16518_912 = _m_907_a0_911; FAIL(item16518_912); }); break; } default: rt_panic("match: no case at tests:484"); } _r; }); }); }); break; } case 0: { V _m_903_a0_913 = FLD(m_903, 0); _r = ({ V item16520_914 = _m_903_a0_913; FAIL(item16520_914); }); break; } default: rt_panic("match: no case at tests:484"); } _r; });
}
V d_Sl_usurface_dmutual(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_50); rt_root(&memo); done = 1; }
  return memo;
}
V d_Sl_usurface_dlegacy_umutual(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_51); rt_root(&memo); done = 1; }
  return memo;
}
V d_Sl_usurface_dmatched(void) {
  static V memo; static int done;
  if (!done) { memo = str_append(d_Sl_usurface_dfamily(), ((V)&S_52)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Sl_usurface_dcased(void) {
  static V memo; static int done;
  if (!done) { memo = str_append(d_Sl_usurface_dlegacy_ufamily(), ((V)&S_53)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Sl_usurface_dchecked(V source_490_915) {
  return ({ V local16535_916 = ({ V local16530_917 = d_Elab_dcheck_utext(NONE, d_Global_dinitial(), source_490_915); ({ V _r = 0; V m_918 = local16530_917; switch (tag_of(m_918)) { case 1: { V _m_918_a0_919 = FLD(m_918, 0); _r = ({ V item16531_920 = _m_918_a0_919; DONE(d_Elab_dchecked_uform(item16531_920)); }); break; } case 0: { V _m_918_a0_921 = FLD(m_918, 0); _r = ({ V item16532_922 = _m_918_a0_921; FAIL(item16532_922); }); break; } default: rt_panic("match: no case at tests:499"); } _r; }); }); ({ V _r = 0; V m_923 = local16535_916; switch (tag_of(m_923)) { case 1: { V _m_923_a0_924 = FLD(m_923, 0); _r = ({ V item16536_925 = _m_923_a0_924; DONE(item16536_925); }); break; } case 0: { V _m_923_a0_926 = FLD(m_923, 0); _r = ({ V item16537_927 = _m_923_a0_926; FAIL(d_Error_dto_ustring(item16537_927)); }); break; } default: rt_panic("match: no case at tests:499"); } _r; }); });
}
V d_Sl_usurface_dsame_uchecked(V first_600_928, V second_601_929) {
  return ({ V _r = 0; V m_930 = d_Sl_usurface_dchecked(first_600_928); switch (tag_of(m_930)) { case 1: { V _m_930_a0_931 = FLD(m_930, 0); _r = ({ V item16545_932 = _m_930_a0_931; ({ V local16539_933 = item16545_932; ({ V _r = 0; V m_934 = d_Sl_usurface_dchecked(second_601_929); switch (tag_of(m_934)) { case 1: { V _m_934_a0_935 = FLD(m_934, 0); _r = ({ V item16543_936 = _m_934_a0_935; ({ V local16542_937 = item16543_936; ((d_NativeString_dequal(local16539_933, local16542_937)) != FALSE_V ? DONE(UNIT) : FAIL(((V)&S_54))); }); }); break; } case 0: { V _m_934_a0_938 = FLD(m_934, 0); _r = ({ V item16544_939 = _m_934_a0_938; FAIL(item16544_939); }); break; } default: rt_panic("match: no case at tests:502"); } _r; }); }); }); break; } case 0: { V _m_930_a0_940 = FLD(m_930, 0); _r = ({ V item16546_941 = _m_930_a0_940; FAIL(item16546_941); }); break; } default: rt_panic("match: no case at tests:502"); } _r; });
}
V d_Syntax_dmark(V q_577_942) {
  return ({ V scrut16587_943 = q_577_942; ({ V _r = 0; V m_944 = scrut16587_943; switch (tag_of(m_944)) { case 0: {  _r = ({ V __945 = UNIT; ((V)&S_55); }); break; } case 1: {  _r = ({ V __946 = UNIT; ((V)&S_56); }); break; } case 2: {  _r = ({ V __947 = UNIT; SNIL; }); break; } default: rt_panic("match: no case at tests:506"); } _r; }); });
}
V d_Syntax_dbinder_utext(V b_588_948) {
  return str_concat(CON(((V)&S_57), CON(d_Syntax_dmark(d_Get_dSyntax_dBinder_db_uq(b_588_948)), CON(d_Get_dSyntax_dBinder_db_uname(b_588_948), CON(((V)&S_58), CON(d_Syntax_dat(d_Big_dzero(), d_Get_dSyntax_dBinder_db_uty(b_588_948)), CON(((V)&S_59), NIL)))))));
}
V d_Syntax_dind_utext(V mo_788_949) {
  return ({ V local16606_950 = d_Get_dSyntax_dMotive_dmo_uind(mo_788_949); ({ V _r = 0; V m_951 = local16606_950; if (((m_951) == NONE)) {  _r = ({ V __952 = UNIT; SNIL; }); } else if (((m_951) != NONE)) { V _m_951_a0_953 = FLD(m_951, 0); _r = ({ V value_954 = _m_951_a0_953; ({ V local16608_955 = value_954; str_append(((V)&S_60), str_append(local16608_955, str_join(d_SeqList_dmap(clo_new(lam_957, 1, 0), d_Get_dSyntax_dMotive_dmo_uidx(mo_788_949)), SNIL))); }); }); } else rt_panic("match: no case at tests:512"); _r; }); });
}
V d_Syntax_dmotive_utext(V mo_787_958) {
  return str_concat(CON(((V)&S_62), CON(d_Get_dSyntax_dMotive_dmo_uself(mo_787_958), CON(d_Syntax_dind_utext(mo_787_958), CON(((V)&S_63), CON(d_Syntax_dat(d_Big_done(), d_Get_dSyntax_dMotive_dmo_ubody(mo_787_958)), NIL))))));
}
V d_Syntax_dfield_utext(V f_768_959) {
  return ({ V local16622_960 = d_Get_dSyntax_dField_dfd_uty(f_768_959); ({ V _r = 0; V m_961 = local16622_960; if (((m_961) == NONE)) {  _r = ({ V __962 = UNIT; str_append(((V)&S_61), str_append(d_Syntax_dmark(d_Get_dSyntax_dField_dfd_uq(f_768_959)), d_Get_dSyntax_dField_dfd_uname(f_768_959))); }); } else if (((m_961) != NONE)) { V _m_961_a0_963 = FLD(m_961, 0); _r = ({ V value_964 = _m_961_a0_963; ({ V local16624_965 = value_964; str_append(((V)&S_61), d_Syntax_dbinder_utext(rt_ctor3(0, d_Get_dSyntax_dField_dfd_uq(f_768_959), d_Get_dSyntax_dField_dfd_uname(f_768_959), local16624_965))); }); }); } else rt_panic("match: no case at tests:518"); _r; }); });
}
V d_Syntax_dbranch_utext(V br_625_966) {
  return ({ V scrut16611_967 = br_625_966; ({ V _r = 0; V m_968 = scrut16611_967; switch (tag_of(m_968)) { case 0: { V _m_968_a0_969 = FLD(m_968, 0); V _m_968_a1_970 = FLD(m_968, 1); V _m_968_a2_971 = FLD(m_968, 2); _r = ({ V p16612_972 = _m_968_a0_969; ({ V p16613_973 = _m_968_a1_970; ({ V p16614_974 = _m_968_a2_971; str_concat(CON(((V)&S_64), CON(d_Big_dshow(p16612_972), CON(str_join(d_SeqList_dmap(clo_new(lam_976, 1, 0), p16613_973), SNIL), CON(((V)&S_65), CON(d_Syntax_dat(d_Big_done(), p16614_974), NIL)))))); }); }); }); break; } case 1: { V _m_968_a0_977 = FLD(m_968, 0); V _m_968_a1_978 = FLD(m_968, 1); V _m_968_a2_979 = FLD(m_968, 2); _r = ({ V p16617_980 = _m_968_a0_977; ({ V p16618_981 = _m_968_a1_978; ({ V p16619_982 = _m_968_a2_979; str_concat(CON(((V)&S_64), CON(p16617_980, CON(str_join(d_SeqList_dmap(clo_new(w_Syntax_dfield_utext, 1, 0), p16618_981), SNIL), CON(((V)&S_65), CON(d_Syntax_dat(d_Big_done(), p16619_982), NIL)))))); }); }); }); break; } default: rt_panic("match: no case at tests:522"); } _r; }); });
}
V d_Syntax_draw(V s_791_983) {
  return ({ V scrut16558_984 = s_791_983; ({ V _r = 0; V m_985 = scrut16558_984; switch (tag_of(m_985)) { case 0: { V _m_985_a0_986 = FLD(m_985, 0); _r = ({ V p16559_987 = _m_985_a0_986; p16559_987; }); break; } case 1: { V _m_985_a0_988 = FLD(m_985, 0); _r = ({ V p16560_989 = _m_985_a0_988; d_Bignum_dto_ustring(p16560_989); }); break; } case 2: {  _r = ({ V __990 = UNIT; ((V)&S_66); }); break; } case 3: { V _m_985_a0_991 = FLD(m_985, 0); _r = ({ V p16561_992 = _m_985_a0_991; str_append(((V)&S_67), d_Big_dshow(p16561_992)); }); break; } case 4: { V _m_985_a0_993 = FLD(m_985, 0); _r = ({ V p16562_994 = _m_985_a0_993; d_Syntax_dprim_uname(p16562_994); }); break; } case 5: {  _r = ({ V __995 = UNIT; ((V)&S_68); }); break; } case 6: {  _r = ({ V __996 = UNIT; ((V)&S_69); }); break; } case 7: { V _m_985_a0_997 = FLD(m_985, 0); V _m_985_a1_998 = FLD(m_985, 1); _r = ({ V p16563_999 = _m_985_a0_997; ({ V p16564_1000 = _m_985_a1_998; str_concat(CON(((V)&S_57), CON(d_Syntax_dat(d_Big_dzero(), p16563_999), CON(((V)&S_70), CON(d_Syntax_dat(d_Big_dzero(), p16564_1000), CON(((V)&S_59), NIL)))))); }); }); break; } case 8: { V _m_985_a0_1001 = FLD(m_985, 0); _r = ({ V p16565_1002 = _m_985_a0_1001; str_concat(CON(((V)&S_71), CON(str_join(d_SeqList_dmap(clo_new(lam_1004, 1, 0), p16565_1002), ((V)&S_70)), CON(((V)&S_59), NIL)))); }); break; } case 9: { V _m_985_a0_1005 = FLD(m_985, 0); _r = ({ V p16569_1006 = _m_985_a0_1005; str_concat(CON(((V)&S_72), CON(str_join(d_SeqList_dmap(clo_new(lam_1008, 1, 0), p16569_1006), ((V)&S_70)), CON(((V)&S_59), NIL)))); }); break; } case 10: { V _m_985_a0_1009 = FLD(m_985, 0); _r = ({ V p16573_1010 = _m_985_a0_1009; str_concat(CON(((V)&S_73), CON(str_join(d_SeqList_dmap(clo_new(lam_1012, 1, 0), p16573_1010), ((V)&S_70)), CON(((V)&S_59), NIL)))); }); break; } case 11: { V _m_985_a0_1013 = FLD(m_985, 0); V _m_985_a1_1014 = FLD(m_985, 1); _r = ({ V p16577_1015 = _m_985_a0_1013; ({ V p16578_1016 = _m_985_a1_1014; str_concat(CON(d_Syntax_dat(d_Big_dof_unat(NAT_SMALL(2ull)), p16577_1015), CON(((V)&S_74), CON(d_Big_dshow(p16578_1016), NIL)))); }); }); break; } case 12: { V _m_985_a0_1017 = FLD(m_985, 0); V _m_985_a1_1018 = FLD(m_985, 1); V _m_985_a2_1019 = FLD(m_985, 2); _r = ({ V p16579_1020 = _m_985_a0_1017; ({ V p16580_1021 = _m_985_a1_1018; ({ V p16581_1022 = _m_985_a2_1019; str_concat(CON(((V)&S_75), CON(d_Big_dshow(p16579_1020), CON(((V)&S_76), CON(d_Big_dshow(p16580_1021), CON(((V)&S_61), CON(d_Syntax_dat(d_Big_done(), p16581_1022), NIL))))))); }); }); }); break; } case 13: { V _m_985_a0_1023 = FLD(m_985, 0); _r = ({ V p16582_1024 = _m_985_a0_1023; str_append(((V)&S_77), d_Syntax_dat(d_Big_done(), p16582_1024)); }); break; } case 14: { V _m_985_a0_1025 = FLD(m_985, 0); V _m_985_a1_1026 = FLD(m_985, 1); _r = ({ V p16583_1027 = _m_985_a0_1025; ({ V p16584_1028 = _m_985_a1_1026; str_append(d_Syntax_dat(d_Big_done(), p16583_1027), str_append(((V)&S_61), d_Syntax_dat(d_Big_dof_unat(NAT_SMALL(2ull)), p16584_1028))); }); }); break; } case 15: { V _m_985_a0_1029 = FLD(m_985, 0); V _m_985_a1_1030 = FLD(m_985, 1); _r = ({ V p16585_1031 = _m_985_a0_1029; ({ V p16586_1032 = _m_985_a1_1030; str_concat(CON(((V)&S_78), CON(str_join(d_SeqList_dmap(clo_new(w_Syntax_dbinder_utext, 1, 0), p16585_1031), ((V)&S_61)), CON(((V)&S_65), CON(d_Syntax_dat(d_Big_dzero(), p16586_1032), NIL))))); }); }); break; } case 16: { V _m_985_a0_1033 = FLD(m_985, 0); V _m_985_a1_1034 = FLD(m_985, 1); _r = ({ V p16588_1035 = _m_985_a0_1033; ({ V p16589_1036 = _m_985_a1_1034; str_append(d_Syntax_dbinder_utext(p16588_1035), str_append(((V)&S_79), d_Syntax_dat(d_Big_dzero(), p16589_1036))); }); }); break; } case 17: { V _m_985_a0_1037 = FLD(m_985, 0); V _m_985_a1_1038 = FLD(m_985, 1); _r = ({ V p16590_1039 = _m_985_a0_1037; ({ V p16591_1040 = _m_985_a1_1038; str_append(d_Syntax_dbinder_utext(p16590_1039), str_append(((V)&S_80), d_Syntax_dat(d_Big_dzero(), p16591_1040))); }); }); break; } case 18: { V _m_985_a0_1041 = FLD(m_985, 0); V _m_985_a1_1042 = FLD(m_985, 1); V _m_985_a2_1043 = FLD(m_985, 2); V _m_985_a3_1044 = FLD(m_985, 3); _r = ({ V p16592_1045 = _m_985_a0_1041; ({ V p16593_1046 = _m_985_a1_1042; ({ V p16594_1047 = _m_985_a2_1043; ({ V p16595_1048 = _m_985_a3_1044; str_concat(CON(((V)&S_81), CON(p16592_1045, CON(((V)&S_58), CON(d_Syntax_dat(d_Big_done(), p16593_1046), CON(((V)&S_82), CON(d_Syntax_dat(d_Big_done(), p16594_1047), CON(((V)&S_60), CON(d_Syntax_dat(d_Big_dzero(), p16595_1048), NIL))))))))); }); }); }); }); break; } case 19: { V _m_985_a0_1049 = FLD(m_985, 0); V _m_985_a1_1050 = FLD(m_985, 1); _r = ({ V p16596_1051 = _m_985_a0_1049; ({ V p16597_1052 = _m_985_a1_1050; str_concat(CON(((V)&S_57), CON(d_Syntax_dat(d_Big_dzero(), p16596_1051), CON(((V)&S_58), CON(d_Syntax_dat(d_Big_dzero(), p16597_1052), CON(((V)&S_59), NIL)))))); }); }); break; } case 20: { V _m_985_a0_1053 = FLD(m_985, 0); V _m_985_a1_1054 = FLD(m_985, 1); V _m_985_a2_1055 = FLD(m_985, 2); _r = ({ V p16598_1056 = _m_985_a0_1053; ({ V p16599_1057 = _m_985_a1_1054; ({ V p16600_1058 = _m_985_a2_1055; str_concat(CON(((V)&S_83), CON(d_Syntax_dat(d_Big_done(), p16598_1056), CON(({ V local16603_1059 = p16599_1057; ({ V _r = 0; V m_1060 = local16603_1059; if (((m_1060) == NONE)) {  _r = ({ V __1061 = UNIT; SNIL; }); } else if (((m_1060) != NONE)) { V _m_1060_a0_1062 = FLD(m_1060, 0); _r = ({ V value_1063 = _m_1060_a0_1062; d_Syntax_dmotive_utext(value_1063); }); } else rt_panic("match: no case at tests:526"); _r; }); }), CON(((V)&S_84), CON(str_join(d_SeqList_dmap(clo_new(w_Syntax_dbranch_utext, 1, 0), p16600_1058), SNIL), NIL)))))); }); }); }); break; } case 21: { V _m_985_a0_1064 = FLD(m_985, 0); V _m_985_a1_1065 = FLD(m_985, 1); V _m_985_a2_1066 = FLD(m_985, 2); _r = ({ V p16625_1067 = _m_985_a0_1064; ({ V p16626_1068 = _m_985_a1_1065; ({ V p16627_1069 = _m_985_a2_1066; str_concat(CON(((V)&S_85), CON(d_Syntax_dat(d_Big_done(), p16625_1067), CON(({ V local16630_1070 = p16626_1068; ({ V _r = 0; V m_1071 = local16630_1070; if (((m_1071) == NONE)) {  _r = ({ V __1072 = UNIT; SNIL; }); } else if (((m_1071) != NONE)) { V _m_1071_a0_1073 = FLD(m_1071, 0); _r = ({ V value_1074 = _m_1071_a0_1073; d_Syntax_dmotive_utext(value_1074); }); } else rt_panic("match: no case at tests:526"); _r; }); }), CON(((V)&S_84), CON(str_join(d_SeqList_dmap(clo_new(w_Syntax_dbranch_utext, 1, 0), p16627_1069), SNIL), NIL)))))); }); }); }); break; } default: rt_panic("match: no case at tests:526"); } _r; }); });
}
V d_Syntax_dlevel_uof(V s_574_1075) {
  return ({ V scrut16632_1076 = s_574_1075; ({ V _r = 0; V m_1077 = scrut16632_1076; switch (tag_of(m_1077)) { case 0: { V _m_1077_a0_1078 = FLD(m_1077, 0); _r = ({ V p16633_1079 = _m_1077_a0_1078; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 1: { V _m_1077_a0_1080 = FLD(m_1077, 0); _r = ({ V p16634_1081 = _m_1077_a0_1080; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 2: {  _r = ({ V __1082 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 3: { V _m_1077_a0_1083 = FLD(m_1077, 0); _r = ({ V p16635_1084 = _m_1077_a0_1083; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 4: { V _m_1077_a0_1085 = FLD(m_1077, 0); _r = ({ V p16636_1086 = _m_1077_a0_1085; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 5: {  _r = ({ V __1087 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 6: {  _r = ({ V __1088 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 7: { V _m_1077_a0_1089 = FLD(m_1077, 0); V _m_1077_a1_1090 = FLD(m_1077, 1); _r = ({ V p16637_1091 = _m_1077_a0_1089; ({ V p16638_1092 = _m_1077_a1_1090; d_Big_dof_unat(NAT_SMALL(2ull)); }); }); break; } case 8: { V _m_1077_a0_1093 = FLD(m_1077, 0); _r = ({ V p16639_1094 = _m_1077_a0_1093; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 9: { V _m_1077_a0_1095 = FLD(m_1077, 0); _r = ({ V p16640_1096 = _m_1077_a0_1095; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 10: { V _m_1077_a0_1097 = FLD(m_1077, 0); _r = ({ V p16641_1098 = _m_1077_a0_1097; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 11: { V _m_1077_a0_1099 = FLD(m_1077, 0); V _m_1077_a1_1100 = FLD(m_1077, 1); _r = ({ V p16642_1101 = _m_1077_a0_1099; ({ V p16643_1102 = _m_1077_a1_1100; d_Big_dof_unat(NAT_SMALL(2ull)); }); }); break; } case 12: { V _m_1077_a0_1103 = FLD(m_1077, 0); V _m_1077_a1_1104 = FLD(m_1077, 1); V _m_1077_a2_1105 = FLD(m_1077, 2); _r = ({ V p16644_1106 = _m_1077_a0_1103; ({ V p16645_1107 = _m_1077_a1_1104; ({ V p16646_1108 = _m_1077_a2_1105; d_Big_done(); }); }); }); break; } case 13: { V _m_1077_a0_1109 = FLD(m_1077, 0); _r = ({ V p16647_1110 = _m_1077_a0_1109; d_Big_done(); }); break; } case 14: { V _m_1077_a0_1111 = FLD(m_1077, 0); V _m_1077_a1_1112 = FLD(m_1077, 1); _r = ({ V p16648_1113 = _m_1077_a0_1111; ({ V p16649_1114 = _m_1077_a1_1112; d_Big_done(); }); }); break; } case 15: { V _m_1077_a0_1115 = FLD(m_1077, 0); V _m_1077_a1_1116 = FLD(m_1077, 1); _r = ({ V p16650_1117 = _m_1077_a0_1115; ({ V p16651_1118 = _m_1077_a1_1116; d_Big_dzero(); }); }); break; } case 16: { V _m_1077_a0_1119 = FLD(m_1077, 0); V _m_1077_a1_1120 = FLD(m_1077, 1); _r = ({ V p16652_1121 = _m_1077_a0_1119; ({ V p16653_1122 = _m_1077_a1_1120; d_Big_dzero(); }); }); break; } case 17: { V _m_1077_a0_1123 = FLD(m_1077, 0); V _m_1077_a1_1124 = FLD(m_1077, 1); _r = ({ V p16654_1125 = _m_1077_a0_1123; ({ V p16655_1126 = _m_1077_a1_1124; d_Big_dzero(); }); }); break; } case 18: { V _m_1077_a0_1127 = FLD(m_1077, 0); V _m_1077_a1_1128 = FLD(m_1077, 1); V _m_1077_a2_1129 = FLD(m_1077, 2); V _m_1077_a3_1130 = FLD(m_1077, 3); _r = ({ V p16656_1131 = _m_1077_a0_1127; ({ V p16657_1132 = _m_1077_a1_1128; ({ V p16658_1133 = _m_1077_a2_1129; ({ V p16659_1134 = _m_1077_a3_1130; d_Big_dzero(); }); }); }); }); break; } case 19: { V _m_1077_a0_1135 = FLD(m_1077, 0); V _m_1077_a1_1136 = FLD(m_1077, 1); _r = ({ V p16660_1137 = _m_1077_a0_1135; ({ V p16661_1138 = _m_1077_a1_1136; d_Big_dof_unat(NAT_SMALL(2ull)); }); }); break; } case 20: { V _m_1077_a0_1139 = FLD(m_1077, 0); V _m_1077_a1_1140 = FLD(m_1077, 1); V _m_1077_a2_1141 = FLD(m_1077, 2); _r = ({ V p16662_1142 = _m_1077_a0_1139; ({ V p16663_1143 = _m_1077_a1_1140; ({ V p16664_1144 = _m_1077_a2_1141; d_Big_dzero(); }); }); }); break; } case 21: { V _m_1077_a0_1145 = FLD(m_1077, 0); V _m_1077_a1_1146 = FLD(m_1077, 1); V _m_1077_a2_1147 = FLD(m_1077, 2); _r = ({ V p16665_1148 = _m_1077_a0_1145; ({ V p16666_1149 = _m_1077_a1_1146; ({ V p16667_1150 = _m_1077_a2_1147; d_Big_dzero(); }); }); }); break; } default: rt_panic("match: no case at tests:530"); } _r; }); });
}
V d_Syntax_dat(V lvl_585_1151, V s_586_1152) {
  return ({ V scrut16631_1153 = d_Syntax_draw(s_586_1152); ((d_Big_dis_ule(lvl_585_1151, d_Syntax_dlevel_uof(s_586_1152))) != FALSE_V ? scrut16631_1153 : str_append(((V)&S_57), str_append(scrut16631_1153, ((V)&S_59)))); });
}
V d_Syntax_dfam_uctor_utext(V fc_829_1154) {
  return str_concat(CON(((V)&S_86), CON(d_Get_dSyntax_dFam_uctor_dfc_uname(fc_829_1154), CON(((V)&S_58), CON(d_Syntax_dat(d_Big_dzero(), d_Get_dSyntax_dFam_uctor_dfc_uty(fc_829_1154)), CON(((V)&S_87), NIL))))));
}
V d_Syntax_dfam_utext(V word_832_1155, V fm_833_1156) {
  return str_concat(CON(word_832_1155, CON(((V)&S_61), CON(d_Get_dSyntax_dFam_dfm_uname(fm_833_1156), CON(str_join(d_SeqList_dmap(clo_new(lam_1158, 1, 0), d_Get_dSyntax_dFam_dfm_uparams(fm_833_1156)), SNIL), CON(((V)&S_58), CON(d_Syntax_dat(d_Big_dzero(), d_Get_dSyntax_dFam_dfm_uty(fm_833_1156)), CON(((V)&S_88), CON(str_join(d_SeqList_dmap(clo_new(w_Syntax_dfam_uctor_utext, 1, 0), d_Get_dSyntax_dFam_dfm_uctors(fm_833_1156)), SNIL), NIL)))))))));
}
V d_Syntax_ddecl_utext(V d_837_1159) {
  return ({ V scrut16554_1160 = d_837_1159; ({ V _r = 0; V m_1161 = scrut16554_1160; switch (tag_of(m_1161)) { case 0: { V _m_1161_a0_1162 = FLD(m_1161, 0); V _m_1161_a1_1163 = FLD(m_1161, 1); V _m_1161_a2_1164 = FLD(m_1161, 2); _r = ({ V p16555_1165 = _m_1161_a0_1162; ({ V p16556_1166 = _m_1161_a1_1163; ({ V p16557_1167 = _m_1161_a2_1164; str_concat(CON(((V)&S_89), CON(p16555_1165, CON(((V)&S_58), CON(d_Syntax_dat(d_Big_dzero(), p16556_1166), CON(((V)&S_82), CON(d_Syntax_dat(d_Big_dzero(), p16557_1167), CON(((V)&S_87), NIL)))))))); }); }); }); break; } case 1: { V _m_1161_a0_1168 = FLD(m_1161, 0); V _m_1161_a1_1169 = FLD(m_1161, 1); _r = ({ V p16668_1170 = _m_1161_a0_1168; ({ V p16669_1171 = _m_1161_a1_1169; str_concat(CON(((V)&S_90), CON(p16668_1170, CON(((V)&S_58), CON(d_Syntax_dat(d_Big_dzero(), p16669_1171), CON(((V)&S_87), NIL)))))); }); }); break; } case 2: { V _m_1161_a0_1172 = FLD(m_1161, 0); _r = ({ V p16670_1173 = _m_1161_a0_1172; ({ V _r = 0; V m_1174 = p16670_1173; if (((m_1174) == NIL)) {  _r = ({ V __1175 = UNIT; SNIL; }); } else if (((m_1174) != NIL)) { V _m_1174_a0_1176 = FLD(m_1174, 0); V _m_1174_a1_1177 = FLD(m_1174, 1); _r = ({ V p16671_1178 = _m_1174_a0_1176; ({ V p16672_1179 = _m_1174_a1_1177; ({ V _r = 0; V m_1180 = p16672_1179; if (((m_1180) == NIL)) {  _r = ({ V __1181 = UNIT; d_Syntax_dfam_utext(((V)&S_91), p16671_1178); }); } else if (((m_1180) != NIL)) { V _m_1180_a0_1182 = FLD(m_1180, 0); V _m_1180_a1_1183 = FLD(m_1180, 1); _r = ({ V p16675_1184 = _m_1180_a0_1182; ({ V p16676_1185 = _m_1180_a1_1183; str_append(((V)&S_92), str_append(str_join(d_SeqList_dmap(clo_new(lam_1187, 1, 0), p16670_1173), SNIL), ((V)&S_93))); }); }); } else rt_panic("match: no case at tests:544"); _r; }); }); }); } else rt_panic("match: no case at tests:544"); _r; }); }); break; } case 3: { V _m_1161_a0_1188 = FLD(m_1161, 0); _r = ({ V p16680_1189 = _m_1161_a0_1188; str_join(d_SeqList_dmapi(clo_new(lam_1192, 2, 0), p16680_1189), SNIL); }); break; } default: rt_panic("match: no case at tests:544"); } _r; }); });
}
V d_Syntax_dprint(V ds_884_1193) {
  return str_join(d_SeqList_dmap(clo_new(w_Syntax_ddecl_utext, 1, 0), ds_884_1193), SNIL);
}
V d_Sl_usurface_dround_utrip(V source_400_1194) {
  return ({ V _r = 0; V m_1195 = d_Sl_usurface_dparse(source_400_1194); switch (tag_of(m_1195)) { case 1: { V _m_1195_a0_1196 = FLD(m_1195, 0); _r = ({ V item16689_1197 = _m_1195_a0_1196; ({ V local16552_1198 = item16689_1197; ({ V _r = 0; V m_1199 = d_Sl_usurface_dparse(d_Syntax_dprint(local16552_1198)); switch (tag_of(m_1199)) { case 1: { V _m_1199_a0_1200 = FLD(m_1199, 0); _r = ({ V item16687_1201 = _m_1199_a0_1200; ({ V local16686_1202 = item16687_1201; ((d_Equal_dListOf_uSyntax_uDecl_u(local16552_1198, local16686_1202)) != FALSE_V ? DONE(UNIT) : FAIL(((V)&S_96))); }); }); break; } case 0: { V _m_1199_a0_1203 = FLD(m_1199, 0); _r = ({ V item16688_1204 = _m_1199_a0_1203; FAIL(item16688_1204); }); break; } default: rt_panic("match: no case at tests:550"); } _r; }); }); }); break; } case 0: { V _m_1195_a0_1205 = FLD(m_1195, 0); _r = ({ V item16690_1206 = _m_1195_a0_1205; FAIL(item16690_1206); }); break; } default: rt_panic("match: no case at tests:550"); } _r; });
}
V d_Sl_usurface_dparse_urefusal(V source_405_1207, V message_406_1208) {
  return ({ V local16723_1209 = d_Parser_dparse(source_405_1207); ({ V _r = 0; V m_1210 = local16723_1209; switch (tag_of(m_1210)) { case 1: { V _m_1210_a0_1211 = FLD(m_1210, 0); _r = ({ V x_1212 = _m_1210_a0_1211; ({ V local16725_1213 = x_1212; FAIL(((V)&S_97)); }); }); break; } case 0: { V _m_1210_a0_1214 = FLD(m_1210, 0); _r = ({ V x_1215 = _m_1210_a0_1214; ({ V local16727_1216 = x_1215; ((d_NativeString_dequal(d_Error_dmessage(local16727_1216), message_406_1208)) != FALSE_V ? DONE(UNIT) : FAIL(d_Error_dto_ustring(local16727_1216))); }); }); break; } default: rt_panic("match: no case at tests:553"); } _r; }); });
}
V d_Sl_usurface_dcases(void) {
  static V memo; static int done;
  if (!done) { memo = CON(rt_ctor2(0, ((V)&S_98), clo_new(lam_1219, 1, 0)), CON(rt_ctor2(0, ((V)&S_99), clo_new(lam_1222, 1, 0)), CON(rt_ctor2(0, ((V)&S_100), clo_new(lam_1225, 1, 0)), CON(rt_ctor2(0, ((V)&S_101), clo_new(lam_1228, 1, 0)), CON(rt_ctor2(0, ((V)&S_102), clo_new(lam_1231, 1, 0)), CON(rt_ctor2(0, ((V)&S_103), clo_new(lam_1234, 1, 0)), CON(rt_ctor2(0, ((V)&S_104), clo_new(lam_1237, 1, 0)), CON(rt_ctor2(0, ((V)&S_105), clo_new(lam_1240, 1, 0)), CON(rt_ctor2(0, ((V)&S_106), clo_new(lam_1243, 1, 0)), CON(rt_ctor2(0, ((V)&S_107), clo_new(lam_1246, 1, 0)), CON(rt_ctor2(0, ((V)&S_109), clo_new(lam_1249, 1, 0)), CON(rt_ctor2(0, ((V)&S_111), clo_new(lam_1252, 1, 0)), CON(rt_ctor2(0, ((V)&S_113), clo_new(lam_1255, 1, 0)), CON(rt_ctor2(0, ((V)&S_115), clo_new(lam_1258, 1, 0)), CON(rt_ctor2(0, ((V)&S_118), clo_new(lam_1261, 1, 0)), CON(rt_ctor2(0, ((V)&S_121), clo_new(lam_1264, 1, 0)), CON(rt_ctor2(0, ((V)&S_123), clo_new(lam_1267, 1, 0)), CON(rt_ctor2(0, ((V)&S_126), clo_new(lam_1270, 1, 0)), CON(rt_ctor2(0, ((V)&S_129), clo_new(lam_1273, 1, 0)), CON(rt_ctor2(0, ((V)&S_132), clo_new(lam_1276, 1, 0)), CON(rt_ctor2(0, ((V)&S_134), clo_new(lam_1277, 1, 0)), NIL))))))))))))))))))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Local_dAbi_ucodec_dparse_df16754(V result_806_1278, V param_851_1279) {
_top: ;
  return ({ V scrut16755_1280 = param_851_1279; ({ V _r = 0; V m_1281 = scrut16755_1280; if (((m_1281) == NIL)) {  _r = ({ V __1282 = UNIT; DONE(list_reverse(result_806_1278)); }); } else if (((m_1281) != NIL)) { V _m_1281_a0_1283 = FLD(m_1281, 0); V _m_1281_a1_1284 = FLD(m_1281, 1); _r = ({ V p16756_1285 = _m_1281_a0_1283; ({ V p16757_1286 = _m_1281_a1_1284; ({ V _r = 0; V m_1287 = ({ V scrut16759_1288 = UNIT; ((d_NativeString_dequal(p16756_1285, ((V)&S_137))) != FALSE_V ? DONE(((V)0)) : ((d_NativeString_dequal(p16756_1285, ((V)&S_138))) != FALSE_V ? DONE(((V)1)) : ((d_NativeString_dequal(p16756_1285, ((V)&S_139))) != FALSE_V ? DONE(((V)2)) : ((d_NativeString_dequal(p16756_1285, ((V)&S_140))) != FALSE_V ? DONE(((V)3)) : ((d_NativeString_dequal(p16756_1285, ((V)&S_141))) != FALSE_V ? DONE(((V)4)) : FAIL(((V)&S_142))))))); }); switch (tag_of(m_1287)) { case 1: { V _m_1287_a0_1289 = FLD(m_1287, 0); _r = ({ V item16762_1290 = _m_1287_a0_1289; ({ V local16761_1291 = item16762_1290; ({ V a_1292 = CON(local16761_1291, result_806_1278); V a_1293 = p16757_1286; result_806_1278 = a_1292; param_851_1279 = a_1293;  goto _top; (V)0; }); }); }); break; } case 0: { V _m_1287_a0_1294 = FLD(m_1287, 0); _r = ({ V item16763_1295 = _m_1287_a0_1294; FAIL(item16763_1295); }); break; } default: rt_panic("match: no case at tests:580"); } _r; }); }); }); } else rt_panic("match: no case at tests:580"); _r; }); });
}
V d_Abi_ucodec_dtypes(V text_804_1296) {
  return d_Local_dAbi_ucodec_dparse_df16754(NIL, ((d_NativeString_dequal(text_804_1296, ((V)&S_143))) != FALSE_V ? NIL : d_NativeString_dsplit((((V)44u)), text_804_1296)));
}
V d_Local_dAbi_ucodec_ddigits_df16781(V n_794_1297, V param_797_1298) {
_top: ;
  return ({ V scrut16786_1299 = param_797_1298; ({ V _r = 0; V m_1300 = scrut16786_1299; if (((m_1300) == NIL)) {  _r = ({ V __1301 = UNIT; DONE(n_794_1297); }); } else if (((m_1300) != NIL)) { V _m_1300_a0_1302 = FLD(m_1300, 0); V _m_1300_a1_1303 = FLD(m_1300, 1); _r = ({ V p16787_1304 = _m_1300_a0_1302; ({ V p16788_1305 = _m_1300_a1_1303; ((((((V)(((p16787_1304)) < (((((V)48u))))))) != FALSE_V ? TRUE_V : ((V)((((((V)57u)))) < ((p16787_1304)))))) != FALSE_V ? FAIL(((V)&S_144)) : ({ V a_1306 = d_Big_dadd(d_Big_dmul(n_794_1297, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(10ull)))), d_Big_didentity(d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL((p16787_1304))), d_Big_dof_unat(NAT_SMALL(48ull))))); V a_1307 = p16788_1305; n_794_1297 = a_1306; param_797_1298 = a_1307;  goto _top; (V)0; })); }); }); } else rt_panic("match: no case at tests:588"); _r; }); });
}
V d_Abi_ucodec_dnumber(V text_792_1308) {
  return ({ V scrut16782_1309 = d_Series_dto_ulist(d_Series_dfrom_ustring(text_792_1308)); ({ V _r = 0; V m_1310 = scrut16782_1309; if (((m_1310) == NIL)) {  _r = ({ V __1311 = UNIT; FAIL(((V)&S_144)); }); } else if (((m_1310) != NIL)) { V _m_1310_a0_1312 = FLD(m_1310, 0); V _m_1310_a1_1313 = FLD(m_1310, 1); _r = ({ V p16783_1314 = _m_1310_a0_1312; ({ V p16784_1315 = _m_1310_a1_1313; ({ V otherwise16785_1316 = ({ V _c = clo_new(lam_1317, 1, 2); CLO_ENV(_c)[0] = p16783_1314; CLO_ENV(_c)[1] = p16784_1315; _c; }); ((d_NativeChar_dequal(p16783_1314, (((V)45u)))) != FALSE_V ? ({ V otherwise16789_1318 = ({ V _c = clo_new(lam_1325, 1, 1); CLO_ENV(_c)[0] = p16784_1315; _c; }); ({ V _r = 0; V m_1326 = p16784_1315; if (((m_1326) == NIL)) {  _r = ({ V __1327 = UNIT; FAIL(((V)&S_144)); }); } else if (1) {  _r = ({ V __1328 = UNIT; ap(otherwise16789_1318, UNIT); }); } else rt_panic("match: no case at tests:594"); _r; }); }) : ap(otherwise16785_1316, UNIT)); }); }); }); } else rt_panic("match: no case at tests:592"); _r; }); });
}
V d_Local_dAbi_ucodec_dpairs_df16814(V digit_620_1329, V result_624_1330, V param_789_1331) {
_top: ;
  return ({ V scrut16821_1332 = param_789_1331; ({ V _r = 0; V m_1333 = scrut16821_1332; if (((m_1333) == NIL)) {  _r = ({ V __1334 = UNIT; DONE(d_NativeString_dof_ulist(d_Series_dto_ulist(d_Series_dof_ulist(list_reverse(result_624_1330))))); }); } else if (((m_1333) != NIL)) { V _m_1333_a0_1335 = FLD(m_1333, 0); V _m_1333_a1_1336 = FLD(m_1333, 1); _r = ({ V p16822_1337 = _m_1333_a0_1335; ({ V p16823_1338 = _m_1333_a1_1336; ({ V _r = 0; V m_1339 = p16823_1338; if (((m_1339) == NIL)) {  _r = ({ V __1340 = UNIT; FAIL(((V)&S_145)); }); } else if (((m_1339) != NIL)) { V _m_1339_a0_1341 = FLD(m_1339, 0); V _m_1339_a1_1342 = FLD(m_1339, 1); _r = ({ V p16824_1343 = _m_1339_a0_1341; ({ V p16825_1344 = _m_1339_a1_1342; ({ V _r = 0; V m_1345 = ap(digit_620_1329, p16822_1337); switch (tag_of(m_1345)) { case 1: { V _m_1345_a0_1346 = FLD(m_1345, 0); _r = ({ V item16845_1347 = _m_1345_a0_1346; ({ V local16828_1348 = item16845_1347; ({ V _r = 0; V m_1349 = ap(digit_620_1329, p16824_1343); switch (tag_of(m_1349)) { case 1: { V _m_1349_a0_1350 = FLD(m_1349, 0); _r = ({ V item16843_1351 = _m_1349_a0_1350; ({ V local16831_1352 = item16843_1351; ({ V scrut16832_1353 = d_Series_dfrom_ustring(d_Big_dto_ubytes(d_Big_didentity(d_NativeInt_dadd(d_NativeInt_dmul(local16828_1348, d_Big_dof_unat(NAT_SMALL(16ull))), local16831_1352)))); ({ V scrut16836_1354 = ({ V _r = 0; V m_1355 = d_Series_duncons(scrut16832_1353); if (((m_1355) == NONE)) {  _r = ({ V __1356 = UNIT; (((V)0u)); }); } else if (((m_1355) != NONE)) { V _m_1355_a0_1357 = FLD(m_1355, 0); _r = ({ V value_1358 = _m_1355_a0_1357; ({ V local16835_1359 = value_1358; d_Get_dTuple2_dv0(local16835_1359); }); }); } else rt_panic("match: no case at tests:599"); _r; }); ({ V local16840_1360 = CON(scrut16836_1354, result_624_1330); ({ V local16842_1361 = p16825_1344; ({ V a_1362 = local16840_1360; V a_1363 = local16842_1361; result_624_1330 = a_1362; param_789_1331 = a_1363;  goto _top; (V)0; }); }); }); }); }); }); }); break; } case 0: { V _m_1349_a0_1364 = FLD(m_1349, 0); _r = ({ V item16844_1365 = _m_1349_a0_1364; FAIL(item16844_1365); }); break; } default: rt_panic("match: no case at tests:598"); } _r; }); }); }); break; } case 0: { V _m_1345_a0_1366 = FLD(m_1345, 0); _r = ({ V item16846_1367 = _m_1345_a0_1366; FAIL(item16846_1367); }); break; } default: rt_panic("match: no case at tests:598"); } _r; }); }); }); } else rt_panic("match: no case at tests:598"); _r; }); }); }); } else rt_panic("match: no case at tests:598"); _r; }); });
}
V d_Abi_ucodec_dunhex(V text_619_1368) {
  return ({ V scrut16813_1369 = clo_new(lam_1371, 1, 0); ({ V local16818_1372 = NIL; ({ V local16820_1373 = d_Series_dto_ulist(d_Series_dfrom_ustring(text_619_1368)); d_Local_dAbi_ucodec_dpairs_df16814(scrut16813_1369, local16818_1372, local16820_1373); }); }); });
}
V d_Abi_ucodec_dvalue(V typ_854_1374, V text_855_1375) {
  return ({ V scrut16779_1376 = typ_854_1374; ({ V _r = 0; V m_1377 = scrut16779_1376; switch (tag_of(m_1377)) { case 0: {  _r = ({ V __1378 = UNIT; ({ V _r = 0; V m_1379 = d_Abi_ucodec_dnumber(text_855_1375); switch (tag_of(m_1379)) { case 1: { V _m_1379_a0_1380 = FLD(m_1379, 0); _r = ({ V item16797_1381 = _m_1379_a0_1380; ({ V local16796_1382 = item16797_1381; ((d_Big_dfits_uint(local16796_1382)) != FALSE_V ? DONE(rt_ctor1(0, d_Big_didentity(local16796_1382))) : FAIL(((V)&S_146))); }); }); break; } case 0: { V _m_1379_a0_1383 = FLD(m_1379, 0); _r = ({ V item16798_1384 = _m_1379_a0_1383; FAIL(item16798_1384); }); break; } default: rt_panic("match: no case at tests:608"); } _r; }); }); break; } case 1: {  _r = ({ V __1385 = UNIT; ({ V _r = 0; V m_1386 = d_Abi_ucodec_dnumber(text_855_1375); switch (tag_of(m_1386)) { case 1: { V _m_1386_a0_1387 = FLD(m_1386, 0); _r = ({ V item16802_1388 = _m_1386_a0_1387; ({ V local16801_1389 = item16802_1388; DONE(rt_ctor1(1, local16801_1389)); }); }); break; } case 0: { V _m_1386_a0_1390 = FLD(m_1386, 0); _r = ({ V item16803_1391 = _m_1386_a0_1390; FAIL(item16803_1391); }); break; } default: rt_panic("match: no case at tests:608"); } _r; }); }); break; } case 2: {  _r = ({ V __1392 = UNIT; ({ V _r = 0; V m_1393 = d_Abi_ucodec_dnumber(text_855_1375); switch (tag_of(m_1393)) { case 1: { V _m_1393_a0_1394 = FLD(m_1393, 0); _r = ({ V item16807_1395 = _m_1393_a0_1394; ({ V local16806_1396 = item16807_1395; DONE(rt_ctor1(2, local16806_1396)); }); }); break; } case 0: { V _m_1393_a0_1397 = FLD(m_1393, 0); _r = ({ V item16808_1398 = _m_1393_a0_1397; FAIL(item16808_1398); }); break; } default: rt_panic("match: no case at tests:608"); } _r; }); }); break; } case 3: {  _r = ({ V __1399 = UNIT; ({ V scrut16809_1400 = UNIT; ((d_NativeString_dequal(text_855_1375, ((V)&S_147))) != FALSE_V ? DONE(rt_ctor1(3, TRUE_V)) : ((d_NativeString_dequal(text_855_1375, ((V)&S_148))) != FALSE_V ? DONE(rt_ctor1(3, FALSE_V)) : FAIL(((V)&S_149)))); }); }); break; } case 4: {  _r = ({ V __1401 = UNIT; ({ V _r = 0; V m_1402 = d_Abi_ucodec_dunhex(text_855_1375); switch (tag_of(m_1402)) { case 1: { V _m_1402_a0_1403 = FLD(m_1402, 0); _r = ({ V item16850_1404 = _m_1402_a0_1403; ({ V local16849_1405 = item16850_1404; DONE(rt_ctor1(4, local16849_1405)); }); }); break; } case 0: { V _m_1402_a0_1406 = FLD(m_1402, 0); _r = ({ V item16851_1407 = _m_1402_a0_1406; FAIL(item16851_1407); }); break; } default: rt_panic("match: no case at tests:609"); } _r; }); }); break; } default: rt_panic("match: no case at tests:608"); } _r; }); });
}
V d_Abi_ucodec_dvalues(V ts_869_1408, V args_870_1409) {
  return ({ V scrut16769_1410 = rt_ctor2(0, ts_869_1408, args_870_1409); ({ V _r = 0; V m_1411 = scrut16769_1410; if ((tag_of(m_1411) == 0)) { V _m_1411_a0_1412 = FLD(m_1411, 0); V _m_1411_a1_1413 = FLD(m_1411, 1); _r = ({ V p16770_1414 = _m_1411_a0_1412; ({ V p16771_1415 = _m_1411_a1_1413; ({ V _r = 0; V m_1416 = p16770_1414; if (((m_1416) == NIL)) {  _r = ({ V __1417 = UNIT; ({ V _r = 0; V m_1418 = p16771_1415; if (((m_1418) == NIL)) {  _r = ({ V __1419 = UNIT; DONE(NIL); }); } else if (((m_1418) != NIL)) { V _m_1418_a0_1420 = FLD(m_1418, 0); V _m_1418_a1_1421 = FLD(m_1418, 1); _r = ({ V p16772_1422 = _m_1418_a0_1420; ({ V p16773_1423 = _m_1418_a1_1421; FAIL(((V)&S_150)); }); }); } else rt_panic("match: no case at tests:613"); _r; }); }); } else if (((m_1416) != NIL)) { V _m_1416_a0_1424 = FLD(m_1416, 0); V _m_1416_a1_1425 = FLD(m_1416, 1); _r = ({ V p16774_1426 = _m_1416_a0_1424; ({ V p16775_1427 = _m_1416_a1_1425; ({ V _r = 0; V m_1428 = p16771_1415; if (((m_1428) == NIL)) {  _r = ({ V __1429 = UNIT; FAIL(((V)&S_150)); }); } else if (((m_1428) != NIL)) { V _m_1428_a0_1430 = FLD(m_1428, 0); V _m_1428_a1_1431 = FLD(m_1428, 1); _r = ({ V p16776_1432 = _m_1428_a0_1430; ({ V p16777_1433 = _m_1428_a1_1431; ({ V _r = 0; V m_1434 = d_Abi_ucodec_dvalue(p16774_1426, p16776_1432); switch (tag_of(m_1434)) { case 1: { V _m_1434_a0_1435 = FLD(m_1434, 0); _r = ({ V item16859_1436 = _m_1434_a0_1435; ({ V local16853_1437 = item16859_1436; ({ V _r = 0; V m_1438 = d_Abi_ucodec_dvalues(p16775_1427, p16777_1433); switch (tag_of(m_1438)) { case 1: { V _m_1438_a0_1439 = FLD(m_1438, 0); _r = ({ V item16857_1440 = _m_1438_a0_1439; ({ V local16856_1441 = item16857_1440; DONE(CON(local16853_1437, local16856_1441)); }); }); break; } case 0: { V _m_1438_a0_1442 = FLD(m_1438, 0); _r = ({ V item16858_1443 = _m_1438_a0_1442; FAIL(item16858_1443); }); break; } default: rt_panic("match: no case at tests:613"); } _r; }); }); }); break; } case 0: { V _m_1434_a0_1444 = FLD(m_1434, 0); _r = ({ V item16860_1445 = _m_1434_a0_1444; FAIL(item16860_1445); }); break; } default: rt_panic("match: no case at tests:613"); } _r; }); }); }); } else rt_panic("match: no case at tests:613"); _r; }); }); }); } else rt_panic("match: no case at tests:613"); _r; }); }); }); } else rt_panic("match: no case at tests:613"); _r; }); });
}
V d_Abi_ucodec_dhex(V text_311_1446) {
  return str_join(d_SeqList_dmap(clo_new(lam_1448, 1, 0), d_Series_dto_ulist(d_Series_dfrom_ustring(text_311_1446))), SNIL);
}
V d_Abi_ucodec_derror(V param_880_1449) {
  return ({ V scrut16873_1450 = param_880_1449; ({ V _r = 0; V m_1451 = scrut16873_1450; switch (tag_of(m_1451)) { case 0: { V _m_1451_a0_1452 = FLD(m_1451, 0); _r = ({ V p16874_1453 = _m_1451_a0_1452; str_append(((V)&S_151), d_Abi_dSchema_dtype_uname(p16874_1453)); }); break; } case 1: {  _r = ({ V __1454 = UNIT; ((V)&S_152); }); break; } case 2: {  _r = ({ V __1455 = UNIT; ((V)&S_153); }); break; } case 3: {  _r = ({ V __1456 = UNIT; ((V)&S_154); }); break; } case 4: {  _r = ({ V __1457 = UNIT; ((V)&S_155); }); break; } case 5: {  _r = ({ V __1458 = UNIT; ((V)&S_156); }); break; } case 6: {  _r = ({ V __1459 = UNIT; ((V)&S_157); }); break; } default: rt_panic("match: no case at tests:620"); } _r; }); });
}
V d_Abi_ucodec_doutput(V show_890_1460) {
  return ({ V _c = clo_new(lam_1469, 1, 1); CLO_ENV(_c)[0] = show_890_1460; _c; });
}
V d_Abi_ucodec_dshow_uvalue(V param_888_1470) {
  return ({ V scrut16887_1471 = param_888_1470; ({ V _r = 0; V m_1472 = scrut16887_1471; switch (tag_of(m_1472)) { case 0: { V _m_1472_a0_1473 = FLD(m_1472, 0); _r = ({ V p16888_1474 = _m_1472_a0_1473; d_Big_dshow(p16888_1474); }); break; } case 1: { V _m_1472_a0_1475 = FLD(m_1472, 0); _r = ({ V p16889_1476 = _m_1472_a0_1475; d_Big_dshow(p16889_1476); }); break; } case 2: { V _m_1472_a0_1477 = FLD(m_1472, 0); _r = ({ V p16890_1478 = _m_1472_a0_1477; d_Big_dshow(p16890_1478); }); break; } case 3: { V _m_1472_a0_1479 = FLD(m_1472, 0); _r = ({ V p16891_1480 = _m_1472_a0_1479; d_NativeBool_dshow(p16891_1480); }); break; } case 4: { V _m_1472_a0_1481 = FLD(m_1472, 0); _r = ({ V p16892_1482 = _m_1472_a0_1481; d_Abi_ucodec_dhex(p16892_1482); }); break; } default: rt_panic("match: no case at tests:627"); } _r; }); });
}
V d_Abi_ucodec_dmain(V param_904_1483) {
  return ({ V scrut16746_1484 = param_904_1483; ({ V _r = 0; V m_1485 = scrut16746_1484; if (((m_1485) == NIL)) {  _r = ({ V __1486 = UNIT; FAIL(((V)&S_160)); }); } else if (((m_1485) != NIL)) { V _m_1485_a0_1487 = FLD(m_1485, 0); V _m_1485_a1_1488 = FLD(m_1485, 1); _r = ({ V p16747_1489 = _m_1485_a0_1487; ({ V p16748_1490 = _m_1485_a1_1488; ({ V _r = 0; V m_1491 = p16748_1490; if (((m_1491) == NIL)) {  _r = ({ V __1492 = UNIT; FAIL(((V)&S_160)); }); } else if (((m_1491) != NIL)) { V _m_1491_a0_1493 = FLD(m_1491, 0); V _m_1491_a1_1494 = FLD(m_1491, 1); _r = ({ V p16749_1495 = _m_1491_a0_1493; ({ V p16750_1496 = _m_1491_a1_1494; ({ V _r = 0; V m_1497 = p16750_1496; if (((m_1497) == NIL)) {  _r = ({ V __1498 = UNIT; FAIL(((V)&S_160)); }); } else if (((m_1497) != NIL)) { V _m_1497_a0_1499 = FLD(m_1497, 0); V _m_1497_a1_1500 = FLD(m_1497, 1); _r = ({ V p16751_1501 = _m_1497_a0_1499; ({ V p16752_1502 = _m_1497_a1_1500; ({ V _r = 0; V m_1503 = d_Abi_ucodec_dtypes(p16751_1501); switch (tag_of(m_1503)) { case 1: { V _m_1503_a0_1504 = FLD(m_1503, 0); _r = ({ V item16897_1505 = _m_1503_a0_1504; ({ V local16766_1506 = item16897_1505; ({ V scrut16767_1507 = UNIT; ((d_NativeString_dequal(p16749_1495, ((V)&S_161))) != FALSE_V ? ({ V _r = 0; V m_1508 = d_Abi_ucodec_dvalues(local16766_1506, p16752_1502); switch (tag_of(m_1508)) { case 1: { V _m_1508_a0_1509 = FLD(m_1508, 0); _r = ({ V item16875_1510 = _m_1508_a0_1509; ({ V local16862_1511 = item16875_1510; DONE(ap(d_Abi_ucodec_doutput(clo_new(w_Abi_ucodec_dhex, 1, 0)), d_Abi_dCodec_dencode(local16862_1511))); }); }); break; } case 0: { V _m_1508_a0_1512 = FLD(m_1508, 0); _r = ({ V item16876_1513 = _m_1508_a0_1512; FAIL(item16876_1513); }); break; } default: rt_panic("match: no case at tests:632"); } _r; }) : ((d_NativeString_dequal(p16749_1495, ((V)&S_162))) != FALSE_V ? ({ V scrut16877_1514 = p16752_1502; ({ V _r = 0; V m_1515 = scrut16877_1514; if (((m_1515) == NIL)) {  _r = ({ V __1516 = UNIT; FAIL(((V)&S_160)); }); } else if (((m_1515) != NIL)) { V _m_1515_a0_1517 = FLD(m_1515, 0); V _m_1515_a1_1518 = FLD(m_1515, 1); _r = ({ V p16878_1519 = _m_1515_a0_1517; ({ V p16879_1520 = _m_1515_a1_1518; ({ V _r = 0; V m_1521 = p16879_1520; if (((m_1521) == NIL)) {  _r = ({ V __1522 = UNIT; ({ V _r = 0; V m_1523 = d_Abi_ucodec_dunhex(p16878_1519); switch (tag_of(m_1523)) { case 1: { V _m_1523_a0_1524 = FLD(m_1523, 0); _r = ({ V item16893_1525 = _m_1523_a0_1524; ({ V local16882_1526 = item16893_1525; DONE(ap(d_Abi_ucodec_doutput(clo_new(lam_1530, 1, 0)), d_Abi_dCodec_ddecode(local16766_1506, local16882_1526))); }); }); break; } case 0: { V _m_1523_a0_1531 = FLD(m_1523, 0); _r = ({ V item16894_1532 = _m_1523_a0_1531; FAIL(item16894_1532); }); break; } default: rt_panic("match: no case at tests:633"); } _r; }); }); } else if (((m_1521) != NIL)) { V _m_1521_a0_1533 = FLD(m_1521, 0); V _m_1521_a1_1534 = FLD(m_1521, 1); _r = ({ V p16895_1535 = _m_1521_a0_1533; ({ V p16896_1536 = _m_1521_a1_1534; FAIL(((V)&S_160)); }); }); } else rt_panic("match: no case at tests:633"); _r; }); }); }); } else rt_panic("match: no case at tests:633"); _r; }); }) : FAIL(((V)&S_160)))); }); }); }); break; } case 0: { V _m_1503_a0_1537 = FLD(m_1503, 0); _r = ({ V item16898_1538 = _m_1503_a0_1537; FAIL(item16898_1538); }); break; } default: rt_panic("match: no case at tests:631"); } _r; }); }); }); } else rt_panic("match: no case at tests:631"); _r; }); }); }); } else rt_panic("match: no case at tests:631"); _r; }); }); }); } else rt_panic("match: no case at tests:631"); _r; }); });
}
V d_Keccak_uvec_ddigit(V c_277_1539) {
  return ((((((V)((((((V)48u)))) <= ((c_277_1539))))) != FALSE_V ? ((V)(((c_277_1539)) <= (((((V)57u)))))) : FALSE_V)) != FALSE_V ? DONE(d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL((c_277_1539))), d_Big_dof_unat(NAT_SMALL(((((V)48u))))))) : ((((((V)((((((V)97u)))) <= ((c_277_1539))))) != FALSE_V ? ((V)(((c_277_1539)) <= (((((V)102u)))))) : FALSE_V)) != FALSE_V ? DONE(d_NativeInt_dsub(d_NativeInt_dadd(d_Big_dof_unat(NAT_SMALL(10ull)), d_Big_dof_unat(NAT_SMALL((c_277_1539)))), d_Big_dof_unat(NAT_SMALL(((((V)97u))))))) : FAIL(((V)0))));
}
V d_Keccak_uvec_dalphabet(void) {
  static V memo; static int done;
  if (!done) { memo = str_append(((V)&S_166), str_append(((V)&S_167), str_append(((V)&S_168), str_append(((V)&S_169), str_append(((V)&S_170), str_append(((V)&S_171), str_append(((V)&S_172), str_append(((V)&S_173), str_append(((V)&S_174), str_append(((V)&S_175), str_append(((V)&S_176), str_append(((V)&S_177), str_append(((V)&S_178), str_append(((V)&S_179), str_append(((V)&S_180), ((V)&S_181)))))))))))))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Local_dKeccak_uvec_dgo_df16910(V acc_293_1540, V input_294_1541) {
_top: ;
  return ({ V scrut16911_1542 = ap(input_294_1541, UNIT); ({ V _r = 0; V m_1543 = scrut16911_1542; switch (tag_of(m_1543)) { case 0: {  _r = ({ V __1544 = UNIT; DONE(d_NativeString_dof_ulist(d_Series_dto_ulist(d_Series_dof_ulist(list_reverse(acc_293_1540))))); }); break; } case 1: { V _m_1543_a0_1545 = FLD(m_1543, 0); V _m_1543_a1_1546 = FLD(m_1543, 1); _r = ({ V p16912_1547 = _m_1543_a0_1545; ({ V p16913_1548 = _m_1543_a1_1546; ({ V scrut16914_1549 = ap(p16913_1548, UNIT); ({ V _r = 0; V m_1550 = scrut16914_1549; switch (tag_of(m_1550)) { case 0: {  _r = ({ V __1551 = UNIT; FAIL(((V)1)); }); break; } case 1: { V _m_1550_a0_1552 = FLD(m_1550, 0); V _m_1550_a1_1553 = FLD(m_1550, 1); _r = ({ V p16915_1554 = _m_1550_a0_1552; ({ V p16916_1555 = _m_1550_a1_1553; ({ V _r = 0; V m_1556 = d_Keccak_uvec_ddigit(p16912_1547); switch (tag_of(m_1556)) { case 1: { V _m_1556_a0_1557 = FLD(m_1556, 0); _r = ({ V item16936_1558 = _m_1556_a0_1557; ({ V local16918_1559 = item16936_1558; ({ V _r = 0; V m_1560 = d_Keccak_uvec_ddigit(p16915_1554); switch (tag_of(m_1560)) { case 1: { V _m_1560_a0_1561 = FLD(m_1560, 0); _r = ({ V item16934_1562 = _m_1560_a0_1561; ({ V local16920_1563 = item16934_1562; ({ V scrut16929_1564 = ({ V local16928_1565 = ({ V local16923_1566 = d_Series_dfrom_ustring(d_Keccak_uvec_dalphabet()); d_SeqList_dfind(({ V _c = clo_new(lam_1568, 1, 2); CLO_ENV(_c)[0] = local16918_1559; CLO_ENV(_c)[1] = local16920_1563; _c; }), d_Series_dto_ulist(local16923_1566)); }); ({ V _r = 0; V m_1569 = local16928_1565; if (((m_1569) == NONE)) {  _r = ({ V __1570 = UNIT; FAIL(((V)0)); }); } else if (((m_1569) != NONE)) { V _m_1569_a0_1571 = FLD(m_1569, 0); _r = ({ V x_1572 = _m_1569_a0_1571; DONE(x_1572); }); } else rt_panic("match: no case at tests:644"); _r; }); }); ({ V _r = 0; V m_1573 = scrut16929_1564; switch (tag_of(m_1573)) { case 1: { V _m_1573_a0_1574 = FLD(m_1573, 0); _r = ({ V item16932_1575 = _m_1573_a0_1574; ({ V local16931_1576 = item16932_1575; ({ V a_1577 = CON(local16931_1576, acc_293_1540); V a_1578 = p16916_1555; acc_293_1540 = a_1577; input_294_1541 = a_1578;  goto _top; (V)0; }); }); }); break; } case 0: { V _m_1573_a0_1579 = FLD(m_1573, 0); _r = ({ V item16933_1580 = _m_1573_a0_1579; FAIL(item16933_1580); }); break; } default: rt_panic("match: no case at tests:645"); } _r; }); }); }); }); break; } case 0: { V _m_1560_a0_1581 = FLD(m_1560, 0); _r = ({ V item16935_1582 = _m_1560_a0_1581; FAIL(item16935_1582); }); break; } default: rt_panic("match: no case at tests:644"); } _r; }); }); }); break; } case 0: { V _m_1556_a0_1583 = FLD(m_1556, 0); _r = ({ V item16937_1584 = _m_1556_a0_1583; FAIL(item16937_1584); }); break; } default: rt_panic("match: no case at tests:644"); } _r; }); }); }); break; } default: rt_panic("match: no case at tests:644"); } _r; }); }); }); }); break; } default: rt_panic("match: no case at tests:643"); } _r; }); });
}
V d_Keccak_uvec_ddecode(V text_291_1585) {
  return d_Local_dKeccak_uvec_dgo_df16910(NIL, d_Series_dfrom_ustring(text_291_1585));
}
V d_Keccak_uvec_ddispatch(V args_600_1586) {
  return ({ V scrut16900_1587 = args_600_1586; ({ V _r = 0; V m_1588 = scrut16900_1587; if (((m_1588) == NIL)) {  _r = ({ V __1589 = UNIT; FAIL(((V)2)); }); } else if (((m_1588) != NIL)) { V _m_1588_a0_1590 = FLD(m_1588, 0); V _m_1588_a1_1591 = FLD(m_1588, 1); _r = ({ V p16901_1592 = _m_1588_a0_1590; ({ V p16902_1593 = _m_1588_a1_1591; ({ V otherwise16903_1594 = clo_new(lam_1595, 1, 0); ({ V _r = 0; V m_1596 = p16902_1593; if (((m_1596) != NIL)) { V _m_1596_a0_1597 = FLD(m_1596, 0); V _m_1596_a1_1598 = FLD(m_1596, 1); _r = ({ V p16904_1599 = _m_1596_a0_1597; ({ V p16905_1600 = _m_1596_a1_1598; ({ V _r = 0; V m_1601 = p16905_1600; if (((m_1601) != NIL)) { V _m_1601_a0_1602 = FLD(m_1601, 0); V _m_1601_a1_1603 = FLD(m_1601, 1); _r = ({ V p16906_1604 = _m_1601_a0_1602; ({ V p16907_1605 = _m_1601_a1_1603; ({ V _r = 0; V m_1606 = p16907_1605; if (((m_1606) == NIL)) {  _r = ({ V __1607 = UNIT; ((((d_NativeString_dequal(p16904_1599, ((V)&S_182))) != FALSE_V ? TRUE_V : d_NativeString_dequal(p16904_1599, ((V)&S_183)))) != FALSE_V ? ({ V _r = 0; V m_1608 = d_Keccak_uvec_ddecode(p16906_1604); switch (tag_of(m_1608)) { case 1: { V _m_1608_a0_1609 = FLD(m_1608, 0); _r = ({ V item16939_1610 = _m_1608_a0_1609; DONE(({ V local16909_1611 = item16939_1610; ((d_NativeString_dequal(p16904_1599, ((V)&S_182))) != FALSE_V ? d_Keccak_dkeccak256(local16909_1611) : d_Keccak_dselector(local16909_1611)); })); }); break; } case 0: { V _m_1608_a0_1612 = FLD(m_1608, 0); _r = ({ V item16940_1613 = _m_1608_a0_1612; FAIL(item16940_1613); }); break; } default: rt_panic("match: no case at tests:653"); } _r; }) : ap(otherwise16903_1594, UNIT)); }); } else if (1) {  _r = ({ V __1614 = UNIT; ap(otherwise16903_1594, UNIT); }); } else rt_panic("match: no case at tests:653"); _r; }); }); }); } else if (1) {  _r = ({ V __1615 = UNIT; ap(otherwise16903_1594, UNIT); }); } else rt_panic("match: no case at tests:653"); _r; }); }); }); } else if (1) {  _r = ({ V __1616 = UNIT; ap(otherwise16903_1594, UNIT); }); } else rt_panic("match: no case at tests:653"); _r; }); }); }); }); } else rt_panic("match: no case at tests:652"); _r; }); });
}
V d_Abi_uschema_dp(V typ_291_1617, V name_292_1618) {
  return rt_ctor2(0, name_292_1618, typ_291_1617);
}
V d_Abi_uschema_dfn(V name_338_1619, V inputs_339_1620, V outputs_340_1621, V mutability_341_1622) {
  return rt_ctor4(0, name_338_1619, inputs_339_1620, outputs_340_1621, mutability_341_1622);
}
V d_Abi_uschema_duint(void) {
  static V memo; static int done;
  if (!done) { memo = clo_new(lam_1624, 1, 0); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_daddress(void) {
  static V memo; static int done;
  if (!done) { memo = clo_new(lam_1626, 1, 0); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dfunctions(void) {
  static V memo; static int done;
  if (!done) { memo = CON(d_Abi_uschema_dfn(((V)&S_184), NIL, CON(d_Abi_uschema_dp(((V)4), SNIL), NIL), ((V)0)), CON(d_Abi_uschema_dfn(((V)&S_185), NIL, CON(d_Abi_uschema_dp(((V)4), SNIL), NIL), ((V)0)), CON(d_Abi_uschema_dfn(((V)&S_186), NIL, CON(d_Abi_uschema_dp(((V)0), SNIL), NIL), ((V)0)), CON(d_Abi_uschema_dfn(((V)&S_187), NIL, CON(ap(d_Abi_uschema_duint(), SNIL), NIL), ((V)0)), CON(d_Abi_uschema_dfn(((V)&S_188), CON(ap(d_Abi_uschema_daddress(), ((V)&S_189)), NIL), CON(ap(d_Abi_uschema_duint(), SNIL), NIL), ((V)0)), CON(d_Abi_uschema_dfn(((V)&S_190), CON(ap(d_Abi_uschema_daddress(), ((V)&S_189)), CON(ap(d_Abi_uschema_daddress(), ((V)&S_191)), NIL)), CON(ap(d_Abi_uschema_duint(), SNIL), NIL), ((V)0)), CON(d_Abi_uschema_dfn(((V)&S_192), CON(ap(d_Abi_uschema_daddress(), ((V)&S_193)), CON(ap(d_Abi_uschema_duint(), ((V)&S_194)), NIL)), CON(d_Abi_uschema_dp(((V)3), SNIL), NIL), ((V)1)), CON(d_Abi_uschema_dfn(((V)&S_195), CON(ap(d_Abi_uschema_daddress(), ((V)&S_191)), CON(ap(d_Abi_uschema_duint(), ((V)&S_194)), NIL)), CON(d_Abi_uschema_dp(((V)3), SNIL), NIL), ((V)1)), CON(d_Abi_uschema_dfn(((V)&S_196), CON(ap(d_Abi_uschema_daddress(), ((V)&S_197)), CON(ap(d_Abi_uschema_daddress(), ((V)&S_193)), CON(ap(d_Abi_uschema_duint(), ((V)&S_194)), NIL))), CON(d_Abi_uschema_dp(((V)3), SNIL), NIL), ((V)1)), NIL))))))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dindexed(V parameter_345_1627) {
  return rt_ctor2(0, parameter_345_1627, TRUE_V);
}
V d_Abi_uschema_ddata(V parameter_348_1628) {
  return rt_ctor2(0, parameter_348_1628, FALSE_V);
}
V d_Abi_uschema_devents(void) {
  static V memo; static int done;
  if (!done) { memo = CON(rt_ctor2(0, ((V)&S_198), CON(d_Abi_uschema_dindexed(ap(d_Abi_uschema_daddress(), ((V)&S_197))), CON(d_Abi_uschema_dindexed(ap(d_Abi_uschema_daddress(), ((V)&S_193))), CON(d_Abi_uschema_ddata(ap(d_Abi_uschema_duint(), ((V)&S_194))), NIL)))), CON(rt_ctor2(0, ((V)&S_199), CON(d_Abi_uschema_dindexed(ap(d_Abi_uschema_daddress(), ((V)&S_189))), CON(d_Abi_uschema_dindexed(ap(d_Abi_uschema_daddress(), ((V)&S_191))), CON(d_Abi_uschema_ddata(ap(d_Abi_uschema_duint(), ((V)&S_194))), NIL)))), NIL)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_derc20(void) {
  static V memo; static int done;
  if (!done) { memo = list_append(CON(rt_ctor2(0, NIL, FALSE_V), d_SeqList_dmap(clo_new(lam_1630, 1, 0), d_Abi_uschema_dfunctions())), d_SeqList_dmap(clo_new(lam_1638, 1, 0), d_Abi_uschema_devents())); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dsignatures(void) {
  static V memo; static int done;
  if (!done) { memo = d_SeqList_dmap(clo_new(lam_1641, 1, 0), d_Abi_uschema_dfunctions()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dobject_u(V rows_426_1642) {
  return str_append(((V)&S_200), str_append(str_join(d_SeqList_dmap(clo_new(lam_1650, 1, 0), rows_426_1642), ((V)&S_164)), ((V)&S_202)));
}
V d_Abi_uschema_dtopics(void) {
  static V memo; static int done;
  if (!done) { memo = d_SeqList_dmap(clo_new(lam_1658, 1, 0), d_Abi_uschema_devents()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dedge(void) {
  static V memo; static int done;
  if (!done) { memo = CON(rt_ctor2(0, CON(ap(d_Abi_uschema_daddress(), ((V)&S_189)), NIL), TRUE_V), CON(rt_ctor1(1, d_Abi_uschema_dfn(((V)&S_204), CON(d_Abi_uschema_dp(((V)0), ((V)&S_205)), CON(ap(d_Abi_uschema_duint(), ((V)&S_206)), CON(ap(d_Abi_uschema_daddress(), ((V)&S_207)), CON(d_Abi_uschema_dp(((V)3), ((V)&S_208)), CON(d_Abi_uschema_dp(((V)4), ((V)&S_209)), NIL))))), NIL, ((V)2))), CON(rt_ctor1(1, d_Abi_uschema_dfn(((V)&S_210), NIL, CON(ap(d_Abi_uschema_daddress(), ((V)&S_189)), CON(d_Abi_uschema_dp(((V)0), ((V)&S_211)), NIL)), ((V)0))), CON(rt_ctor2(2, ((V)&S_212), CON(d_Abi_uschema_dp(((V)3), ((V)&S_213)), CON(ap(d_Abi_uschema_daddress(), ((V)&S_214)), NIL))), CON(rt_ctor3(3, ((V)&S_215), CON(d_Abi_uschema_ddata(d_Abi_uschema_dp(((V)4), ((V)&S_216))), CON(d_Abi_uschema_dindexed(ap(d_Abi_uschema_duint(), ((V)&S_217))), NIL)), TRUE_V), CON(rt_ctor1(4, TRUE_V), CON(rt_ctor1(4, FALSE_V), NIL))))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dlegacy_uerrors(void) {
  static V memo; static int done;
  if (!done) { memo = CON(rt_ctor2(0, ((V)&S_218), NIL), CON(rt_ctor2(0, ((V)&S_219), CON(((V)&S_220), CON(((V)&S_221), NIL))), NIL)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dlegacy_uentries(void) {
  static V memo; static int done;
  if (!done) { memo = CON(rt_ctor3(0, ((V)&S_222), NIL, ((V)0)), CON(rt_ctor3(0, ((V)&S_204), CON(((V)&S_223), CON(((V)&S_193), NIL)), ((V)1)), CON(rt_ctor3(0, ((V)&S_224), CON(((V)&S_209), NIL), ((V)2)), NIL))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dinvariant(void) {
  static V memo; static int done;
  if (!done) { memo = d_Abi_uschema_dfn(((V)&S_225), CON(ap(d_Abi_uschema_daddress(), ((V)&S_226)), CON(ap(d_Abi_uschema_duint(), ((V)&S_194)), NIL)), CON(ap(d_Abi_uschema_duint(), SNIL), NIL), ((V)0)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_dchanged(void) {
  static V memo; static int done;
  if (!done) { memo = d_Abi_uschema_dfn(((V)&S_225), CON(ap(d_Abi_uschema_daddress(), ((V)&S_227)), CON(ap(d_Abi_uschema_duint(), ((V)&S_228)), NIL)), NIL, ((V)2)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_uschema_doutput(void) {
  static V memo; static int done;
  if (!done) { memo = d_Abi_uschema_dobject_u(CON(rt_ctor2(0, ((V)&S_229), d_Abi_dSchema_dprint(d_Abi_uschema_derc20())), CON(rt_ctor2(0, ((V)&S_230), d_Abi_uschema_dobject_u(d_Abi_uschema_dsignatures())), CON(rt_ctor2(0, ((V)&S_231), d_Abi_uschema_dobject_u(d_Abi_uschema_dtopics())), CON(rt_ctor2(0, ((V)&S_232), d_Abi_dSchema_dprint(d_Abi_uschema_dedge())), CON(rt_ctor2(0, ((V)&S_233), d_Abi_dquote(d_Abi_dSchema_dprint(NIL))), CON(rt_ctor2(0, ((V)&S_234), d_Abi_dquote(d_Abi_dprint(SOME(d_Abi_uschema_dlegacy_uerrors()), SOME(TRUE_V), d_Abi_uschema_dlegacy_uentries()))), CON(rt_ctor2(0, ((V)&S_235), d_Abi_dquote(d_Abi_dprint(NONE, NONE, NIL))), CON(rt_ctor2(0, ((V)&S_236), d_Abi_uschema_dobject_u(d_SeqList_dmap(clo_new(lam_1660, 1, 0), d_Abi_uschema_dlegacy_uentries()))), CON(rt_ctor2(0, ((V)&S_237), d_Abi_uschema_dobject_u(d_SeqList_dmap(clo_new(lam_1662, 1, 0), d_Abi_uschema_dlegacy_uerrors()))), CON(rt_ctor2(0, ((V)&S_238), d_Abi_dquote(d_Abi_dSchema_dfunction_usignature(d_Abi_uschema_dinvariant()))), CON(rt_ctor2(0, ((V)&S_239), d_Abi_dquote(d_Abi_dSchema_dfunction_usignature(d_Abi_uschema_dchanged()))), NIL)))))))))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Asm_ucompact_dblock(V _opt__310_1663, V _opt__309_1664, V label_277_1665, V ending_278_1666) {
  return ({ V scrut16981_1667 = ({ V scrut16979_1668 = _opt__310_1663; ({ V _r = 0; V m_1669 = scrut16979_1668; if (((m_1669) == NONE)) {  _r = ({ V __1670 = UNIT; FALSE_V; }); } else if (((m_1669) != NONE)) { V _m_1669_a0_1671 = FLD(m_1669, 0); _r = ({ V p16980_1672 = _m_1669_a0_1671; p16980_1672; }); } else rt_panic("match: no case at tests:715"); _r; }); }); ({ V scrut16984_1673 = ({ V scrut16982_1674 = _opt__309_1664; ({ V _r = 0; V m_1675 = scrut16982_1674; if (((m_1675) == NONE)) {  _r = ({ V __1676 = UNIT; NIL; }); } else if (((m_1675) != NONE)) { V _m_1675_a0_1677 = FLD(m_1675, 0); _r = ({ V p16983_1678 = _m_1675_a0_1677; p16983_1678; }); } else rt_panic("match: no case at tests:717"); _r; }); }); ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = label_277_1665; _o->f[1] = scrut16981_1667; _o->f[2] = d_Big_dzero(); _o->f[3] = scrut16984_1673; _o->f[4] = ending_278_1666; (V)_o; }); }); });
}
V d_Asm_ucompact_dpadding(V count_313_1679) {
  return d_SeqList_dinit(count_313_1679, clo_new(lam_1681, 1, 0));
}
V d_Asm_ucompact_djump(V width_383_1682, V count_384_1683) {
  return list_append(CON(d_Asm_ucompact_dblock(NONE, NONE, ((V)&S_241), rt_ctor2(1, width_383_1682, ((V)&S_242))), d_Asm_ucompact_dpadding(count_384_1683)), CON(d_Asm_ucompact_dblock(SOME(TRUE_V), NONE, ((V)&S_242), rt_ctor1(0, ((V)0))), NIL));
}
V d_Asm_ucompact_dobserve(void) {
  static V memo; static int done;
  if (!done) { memo = clo_new(lam_1691, 1, 0); rt_root(&memo); done = 1; }
  return memo;
}
V d_Asm_ucompact_dcheck(V name_413_1692, V wide_414_1693, V narrow_415_1694) {
  return ({ V scrut16991_1695 = ({ V _r = 0; V m_1696 = d_Asm_dassemble(wide_414_1693); switch (tag_of(m_1696)) { case 1: { V _m_1696_a0_1697 = FLD(m_1696, 0); _r = ({ V item16989_1698 = _m_1696_a0_1697; ({ V local16988_1699 = item16989_1698; ((d_Big_dis_ule(d_Big_dof_unat(str_length(d_Asm_dhex(local16988_1699))), d_Big_dof_unat(NAT_SMALL(510ull)))) != FALSE_V ? d_Asm_dassemble(narrow_415_1694) : DONE(local16988_1699)); }); }); break; } case 0: { V _m_1696_a0_1700 = FLD(m_1696, 0); _r = ({ V item16990_1701 = _m_1696_a0_1700; FAIL(item16990_1701); }); break; } default: rt_panic("match: no case at tests:730"); } _r; }); ((d_Equal_dAsm_uResult_uTupleOf3_uString_u_uListOf_uTupleOf2_uString_u_uBig_u_u_u_uListOf_uAsm_uHeight_u_u_u(ap(d_Asm_ucompact_dobserve(), d_Asm_dassemble_ucompact(wide_414_1693)), ap(d_Asm_ucompact_dobserve(), scrut16991_1695))) != FALSE_V ? d_Big_done() : ({ V discard17084_1702 = UNIT; d_Big_dzero(); })); });
}
V d_Asm_ucompact_dbranch(V width_387_1703, V count_388_1704) {
  return list_append(CON(d_Asm_ucompact_dblock(NONE, SOME(CON(rt_ctor1(1, SNIL), NIL)), ((V)&S_241), rt_ctor3(2, width_387_1703, ((V)&S_243), ((V)&S_244))), d_Asm_ucompact_dpadding(count_388_1704)), CON(d_Asm_ucompact_dblock(SOME(TRUE_V), NONE, ((V)&S_243), rt_ctor1(0, ((V)0))), CON(d_Asm_ucompact_dblock(SOME(TRUE_V), NONE, ((V)&S_244), rt_ctor1(0, ((V)0))), NIL)));
}
V d_Asm_ucompact_dpayload(V width_492_1705, V count_493_1706, V bytes_494_1707) {
  return list_append(CON(d_Asm_ucompact_dblock(NONE, SOME(CON(rt_ctor1(1, d_NativeString_drepeat(d_Big_dto_unat(d_NativeInt_dmul(d_Big_dof_unat(NAT_SMALL(2ull)), bytes_494_1707)), (((V)97u)))), CON(rt_ctor1(0, ((V)&S_245)), NIL))), ((V)&S_241), rt_ctor2(1, width_492_1705, ((V)&S_242))), d_Asm_ucompact_dpadding(count_493_1706)), CON(d_Asm_ucompact_dblock(SOME(TRUE_V), NONE, ((V)&S_242), rt_ctor1(0, ((V)0))), NIL));
}
V d_Asm_ucompact_dmixed(V width_489_1708) {
  return CON(d_Asm_ucompact_dblock(NONE, NONE, ((V)&S_241), rt_ctor2(1, d_Big_dof_unat(NAT_SMALL(3ull)), ((V)&S_246))), CON(d_Asm_ucompact_dblock(SOME(TRUE_V), NONE, ((V)&S_246), rt_ctor2(1, width_489_1708, ((V)&S_242))), CON(d_Asm_ucompact_dblock(SOME(TRUE_V), NONE, ((V)&S_242), rt_ctor1(0, ((V)0))), NIL)));
}
V d_Asm_ucompact_doutput(void) {
  static V memo; static int done;
  if (!done) { memo = ({ V scrut17088_1709 = d_SeqList_dfold(clo_new(lam_1712, 2, 0), d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(271ull)), clo_new(lam_1714, 1, 0)), d_Big_dzero()); ({ V scrut17096_1715 = d_SeqList_dfold(clo_new(lam_1718, 2, 0), d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(33ull)), clo_new(lam_1720, 1, 0)), scrut17088_1709); ({ V scrut17097_1721 = d_Asm_ucompact_dblock(NONE, NONE, ((V)&S_251), rt_ctor1(0, ((V)0))); ({ V scrut17126_1722 = CON(({ V local17099_1723 = ((V)&S_233); ({ V local17101_1724 = NIL; rt_ctor3(0, local17099_1723, local17101_1724, local17101_1724); }); }), CON(({ V local17103_1725 = ((V)&S_252); ({ V local17105_1726 = CON(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dAsm_dBlock_dlabel(scrut17097_1721); _o->f[1] = d_Get_dAsm_dBlock_ddestination(scrut17097_1721); _o->f[2] = d_Get_dAsm_dBlock_dstack_uin(scrut17097_1721); _o->f[3] = CON(rt_ctor1(0, ((V)&S_253)), NIL); _o->f[4] = d_Get_dAsm_dBlock_dending(scrut17097_1721); (V)_o; }), NIL); rt_ctor3(0, local17103_1725, local17105_1726, local17105_1726); }); }), CON(({ V local17107_1727 = ((V)&S_254); ({ V local17109_1728 = CON(scrut17097_1721, CON(scrut17097_1721, NIL)); rt_ctor3(0, local17107_1727, local17109_1728, local17109_1728); }); }), CON(rt_ctor3(0, ((V)&S_255), CON(d_Asm_ucompact_dblock(NONE, NONE, ((V)&S_241), rt_ctor2(1, d_Big_dof_unat(NAT_SMALL(2ull)), ((V)&S_256))), NIL), CON(d_Asm_ucompact_dblock(NONE, NONE, ((V)&S_241), rt_ctor2(1, d_Big_done(), ((V)&S_256))), NIL)), CON(rt_ctor3(0, ((V)&S_257), CON(d_Asm_ucompact_dblock(NONE, NONE, ((V)&S_241), rt_ctor2(1, d_Big_dof_unat(NAT_SMALL(2ull)), ((V)&S_251))), CON(scrut17097_1721, NIL)), CON(d_Asm_ucompact_dblock(NONE, NONE, ((V)&S_241), rt_ctor2(1, d_Big_done(), ((V)&S_251))), CON(scrut17097_1721, NIL))), CON(({ V local17111_1729 = ((V)&S_258); ({ V local17113_1730 = CON(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dAsm_dBlock_dlabel(scrut17097_1721); _o->f[1] = d_Get_dAsm_dBlock_ddestination(scrut17097_1721); _o->f[2] = d_Big_done(); _o->f[3] = d_Get_dAsm_dBlock_dbody(scrut17097_1721); _o->f[4] = d_Get_dAsm_dBlock_dending(scrut17097_1721); (V)_o; }), NIL); rt_ctor3(0, local17111_1729, local17113_1730, local17113_1730); }); }), CON(({ V local17115_1731 = ((V)&S_259); ({ V local17117_1732 = CON(d_Asm_ucompact_dblock(SOME(TRUE_V), NONE, ((V)&S_241), rt_ctor2(1, d_Big_dzero(), ((V)&S_241))), NIL); rt_ctor3(0, local17115_1731, local17117_1732, local17117_1732); }); }), CON(({ V local17119_1733 = ((V)&S_260); ({ V local17121_1734 = CON(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dAsm_dBlock_dlabel(scrut17097_1721); _o->f[1] = d_Get_dAsm_dBlock_ddestination(scrut17097_1721); _o->f[2] = d_Get_dAsm_dBlock_dstack_uin(scrut17097_1721); _o->f[3] = CON(rt_ctor1(0, ((V)&S_245)), NIL); _o->f[4] = d_Get_dAsm_dBlock_dending(scrut17097_1721); (V)_o; }), NIL); rt_ctor3(0, local17119_1733, local17121_1734, local17121_1734); }); }), CON(({ V local17123_1735 = ((V)&S_261); ({ V local17125_1736 = CON(d_Asm_ucompact_dblock(NONE, NONE, ((V)&S_241), rt_ctor1(3, ((V)&S_256))), CON(scrut17097_1721, NIL)); rt_ctor3(0, local17123_1735, local17125_1736, local17125_1736); }); }), CON(rt_ctor3(0, ((V)&S_262), d_Asm_ucompact_dmixed(d_Big_dof_unat(NAT_SMALL(2ull))), d_Asm_ucompact_dmixed(d_Big_done())), NIL)))))))))); ({ V scrut17135_1737 = d_SeqList_dfold(clo_new(lam_1748, 2, 0), scrut17126_1722, scrut17096_1715); str_concat(CON(((V)&S_263), CON(d_Big_dshow(scrut17135_1737), CON(((V)&S_264), NIL)))); }); }); }); }); }); rt_root(&memo); done = 1; }
  return memo;
}
V d_Asm_ucases_dblock(V _opt__310_1749, V _opt__309_1750, V label_291_1751, V body_292_1752, V ending_293_1753) {
  return ({ V scrut17143_1754 = ({ V scrut17141_1755 = _opt__310_1749; ({ V _r = 0; V m_1756 = scrut17141_1755; if (((m_1756) == NONE)) {  _r = ({ V __1757 = UNIT; FALSE_V; }); } else if (((m_1756) != NONE)) { V _m_1756_a0_1758 = FLD(m_1756, 0); _r = ({ V p17142_1759 = _m_1756_a0_1758; p17142_1759; }); } else rt_panic("match: no case at tests:754"); _r; }); }); ({ V scrut17146_1760 = ({ V scrut17144_1761 = _opt__309_1750; ({ V _r = 0; V m_1762 = scrut17144_1761; if (((m_1762) == NONE)) {  _r = ({ V __1763 = UNIT; d_Big_dzero(); }); } else if (((m_1762) != NONE)) { V _m_1762_a0_1764 = FLD(m_1762, 0); _r = ({ V p17145_1765 = _m_1762_a0_1764; p17145_1765; }); } else rt_panic("match: no case at tests:756"); _r; }); }); ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = label_291_1751; _o->f[1] = scrut17143_1754; _o->f[2] = scrut17146_1760; _o->f[3] = body_292_1752; _o->f[4] = ending_293_1753; (V)_o; }); }); });
}
V d_Asm_ucases_dstop(V label_313_1766, V body_314_1767) {
  return d_Asm_ucases_dblock(NONE, NONE, label_313_1766, body_314_1767, rt_ctor1(0, ((V)0)));
}
V d_Asm_ucases_dtarget(V _opt__389_1768, V label_388_1769) {
  return ({ V scrut17150_1770 = ({ V scrut17148_1771 = _opt__389_1768; ({ V _r = 0; V m_1772 = scrut17148_1771; if (((m_1772) == NONE)) {  _r = ({ V __1773 = UNIT; d_Big_dzero(); }); } else if (((m_1772) != NONE)) { V _m_1772_a0_1774 = FLD(m_1772, 0); _r = ({ V p17149_1775 = _m_1772_a0_1774; p17149_1775; }); } else rt_panic("match: no case at tests:764"); _r; }); }); d_Asm_ucases_dblock(SOME(TRUE_V), SOME(scrut17150_1770), label_388_1769, NIL, rt_ctor1(0, ((V)0))); });
}
V d_Asm_ucases_dzeros(V n_317_1776) {
  return d_SeqList_dinit(n_317_1776, clo_new(lam_1778, 1, 0));
}
V d_Asm_ucases_dreport(V name_469_1779, V good_470_1780, V detail_471_1781) {
  return ({ V discard17185_1782 = UNIT; good_470_1780; });
}
V d_Asm_ucases_drejection(V name_510_1783, V program_511_1784, V expected_512_1785) {
  return ({ V local17182_1786 = d_Asm_dassemble(program_511_1784); ({ V _r = 0; V m_1787 = local17182_1786; switch (tag_of(m_1787)) { case 1: { V _m_1787_a0_1788 = FLD(m_1787, 0); _r = ({ V x_1789 = _m_1787_a0_1788; ({ V local17184_1790 = x_1789; d_Asm_ucases_dreport(name_510_1783, FALSE_V, str_append(((V)&S_265), expected_512_1785)); }); }); break; } case 0: { V _m_1787_a0_1791 = FLD(m_1787, 0); _r = ({ V x_1792 = _m_1787_a0_1791; ({ V local17187_1793 = x_1792; ({ V scrut17188_1794 = d_Asm_derror_utext(local17187_1793); d_Asm_ucases_dreport(name_510_1783, d_NativeString_dequal(scrut17188_1794, expected_512_1785), scrut17188_1794); }); }); }); break; } default: rt_panic("match: no case at tests:775"); } _r; }); });
}
V d_Asm_ucases_dref20(void) {
  static V memo; static int done;
  if (!done) { memo = list_append(CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_204), CON(rt_ctor1(1, ((V)&S_266)), CON(rt_ctor1(1, SNIL), CON(rt_ctor1(0, ((V)&S_267)), NIL))), rt_ctor2(1, d_Big_done(), ((V)&S_222))), NIL), list_append(d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(4ull)), clo_new(lam_1796, 1, 0)), CON(d_Asm_ucases_dblock(SOME(TRUE_V), NONE, ((V)&S_222), CON(rt_ctor1(1, SNIL), CON(rt_ctor1(0, ((V)&S_269)), CON(rt_ctor1(1, SNIL), CON(rt_ctor1(0, ((V)&S_270)), CON(rt_ctor1(1, ((V)&S_271)), CON(rt_ctor1(1, SNIL), NIL)))))), rt_ctor1(0, ((V)1))), NIL))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Asm_ucases_ddiamond(void) {
  static V memo; static int done;
  if (!done) { memo = CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_272), CON(rt_ctor1(1, ((V)&S_273)), NIL), rt_ctor3(2, d_Big_done(), ((V)&S_243), ((V)&S_244))), CON(d_Asm_ucases_dblock(SOME(TRUE_V), NONE, ((V)&S_243), CON(rt_ctor1(1, ((V)&S_266)), NIL), rt_ctor2(1, d_Big_done(), ((V)&S_274))), CON(d_Asm_ucases_dblock(SOME(TRUE_V), NONE, ((V)&S_244), CON(rt_ctor1(1, ((V)&S_275)), NIL), rt_ctor1(3, ((V)&S_274))), CON(d_Asm_ucases_dblock(SOME(TRUE_V), SOME(d_Big_done()), ((V)&S_274), CON(rt_ctor1(0, ((V)&S_245)), NIL), rt_ctor1(0, ((V)0))), NIL)))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Asm_ucases_dloop(void) {
  static V memo; static int done;
  if (!done) { memo = CON(d_Asm_ucases_dblock(SOME(TRUE_V), NONE, ((V)&S_276), CON(rt_ctor1(1, ((V)&S_273)), NIL), rt_ctor3(2, d_Big_dof_unat(NAT_SMALL(2ull)), ((V)&S_276), ((V)&S_277))), CON(d_Asm_ucases_dtarget(NONE, ((V)&S_277)), NIL)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Asm_ucases_dblocks_uof(V p_538_1797) {
  return d_Big_dof_unat(list_length(d_Asm_dheights(p_538_1797)));
}
V d_Asm_ucases_dacceptance(V name_545_1798, V program_546_1799, V expected_547_1800) {
  return ({ V local17203_1801 = d_Asm_dassemble(program_546_1799); ({ V _r = 0; V m_1802 = local17203_1801; switch (tag_of(m_1802)) { case 1: { V _m_1802_a0_1803 = FLD(m_1802, 0); _r = ({ V x_1804 = _m_1802_a0_1803; ({ V local17205_1805 = x_1804; rt_ctor2(0, d_Asm_ucases_dreport(name_545_1798, d_NativeString_dequal(d_Asm_dhex(local17205_1805), expected_547_1800), ((d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(160ull)), d_Big_dof_unat(str_length(expected_547_1800)))) != FALSE_V ? str_append(((V)&S_278), d_Big_dshow(d_Big_dshift_uright(d_Big_dunsigned(NAT_SMALL(63ull), d_Big_dof_unat(str_length(d_Asm_dhex(local17205_1805)))), d_Big_dto_unat(d_Big_dunsigned(NAT_SMALL(6ull), d_Big_done()))))) : d_Asm_dhex(local17205_1805))), d_Asm_ucases_dblocks_uof(local17205_1805)); }); }); break; } case 0: { V _m_1802_a0_1806 = FLD(m_1802, 0); _r = ({ V x_1807 = _m_1802_a0_1806; ({ V local17207_1808 = x_1807; rt_ctor2(0, d_Asm_ucases_dreport(name_545_1798, FALSE_V, d_Asm_derror_utext(local17207_1808)), d_Big_dzero()); }); }); break; } default: rt_panic("match: no case at tests:791"); } _r; }); });
}
V d_Asm_ucases_drecord(V p_541_1809) {
  return d_SeqList_dmap(clo_new(lam_1811, 1, 0), d_Asm_dheights(p_541_1809));
}
V d_Asm_ucases_dsuite(V param_595_1812) {
  return ({ V scrut17138_1813 = param_595_1812; ({ V scrut17153_1814 = CON(rt_ctor3(0, ((V)&S_233), NIL, ((V)&S_279)), CON(rt_ctor3(0, ((V)&S_280), CON(d_Asm_ucases_dstop(SNIL, NIL), NIL), ((V)&S_281)), CON(rt_ctor3(0, ((V)&S_254), CON(d_Asm_ucases_dstop(((V)&S_10), NIL), CON(d_Asm_ucases_dstop(((V)&S_10), NIL), NIL)), ((V)&S_282)), CON(rt_ctor3(0, ((V)&S_272), CON(d_Asm_ucases_dblock(NONE, SOME(d_Big_done()), ((V)&S_10), NIL, rt_ctor1(0, ((V)0))), NIL), ((V)&S_283)), CON(rt_ctor3(0, ((V)&S_284), CON(d_Asm_ucases_dstop(((V)&S_10), NIL), CON(d_Asm_ucases_dtarget(SOME(d_Big_dneg(d_Big_dof_unat(NAT_SMALL(1ull)))), ((V)&S_285)), NIL)), ((V)&S_286)), CON(rt_ctor3(0, ((V)&S_287), CON(d_Asm_ucases_dstop(((V)&S_10), NIL), CON(d_Asm_ucases_dtarget(SOME(d_Big_dof_unat(NAT_SMALL(1025ull))), ((V)&S_285)), NIL)), ((V)&S_288)), CON(rt_ctor3(0, ((V)&S_289), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(1, SNIL), CON(rt_ctor1(0, ((V)&S_290)), NIL))), NIL), ((V)&S_291)), CON(rt_ctor3(0, ((V)&S_292), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(1, SNIL), CON(rt_ctor1(0, ((V)&S_267)), NIL))), NIL), ((V)&S_293)), CON(rt_ctor3(0, ((V)&S_294), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(2, d_Big_done()), NIL)), NIL), ((V)&S_295)), CON(rt_ctor3(0, ((V)&S_296), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(1, SNIL), CON(rt_ctor1(3, d_Big_done()), NIL))), NIL), ((V)&S_297)), CON(rt_ctor3(0, ((V)&S_298), CON(d_Asm_ucases_dstop(((V)&S_10), d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(1025ull)))), NIL), ((V)&S_299)), CON(rt_ctor3(0, ((V)&S_300), CON(d_Asm_ucases_dstop(((V)&S_10), list_append(d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(1024ull))), CON(rt_ctor1(2, d_Big_done()), NIL))), NIL), ((V)&S_301)), CON(rt_ctor3(0, ((V)&S_302), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(1024ull))), rt_ctor2(1, d_Big_done(), ((V)&S_285))), CON(d_Asm_ucases_dtarget(SOME(d_Big_dof_unat(NAT_SMALL(1024ull))), ((V)&S_285)), NIL)), ((V)&S_303)), CON(rt_ctor3(0, ((V)&S_304), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(1024ull))), rt_ctor3(2, d_Big_done(), ((V)&S_285), ((V)&S_285))), CON(d_Asm_ucases_dtarget(SOME(d_Big_dof_unat(NAT_SMALL(1023ull))), ((V)&S_285)), NIL)), ((V)&S_303)), CON(rt_ctor3(0, ((V)&S_305), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor3(2, d_Big_done(), ((V)&S_285), ((V)&S_285))), CON(d_Asm_ucases_dtarget(NONE, ((V)&S_285)), NIL)), ((V)&S_306)), CON(rt_ctor3(0, ((V)&S_307), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), CON(rt_ctor1(1, SNIL), NIL), rt_ctor1(0, ((V)1))), NIL), ((V)&S_308)), CON(rt_ctor3(0, ((V)&S_309), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor1(0, ((V)2))), NIL), ((V)&S_310)), CON(rt_ctor3(0, ((V)&S_311), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor1(0, ((V)4))), NIL), ((V)&S_312)), CON(rt_ctor3(0, ((V)&S_313), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor2(1, d_Big_done(), ((V)&S_285))), NIL), ((V)&S_314)), CON(rt_ctor3(0, ((V)&S_257), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor2(1, d_Big_done(), ((V)&S_285))), CON(d_Asm_ucases_dstop(((V)&S_285), NIL), NIL)), ((V)&S_315)), CON(rt_ctor3(0, ((V)&S_316), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), CON(rt_ctor1(1, SNIL), NIL), rt_ctor2(1, d_Big_done(), ((V)&S_285))), CON(d_Asm_ucases_dtarget(NONE, ((V)&S_285)), NIL)), ((V)&S_317)), CON(rt_ctor3(0, ((V)&S_318), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), CON(rt_ctor1(1, SNIL), NIL), rt_ctor3(2, d_Big_done(), ((V)&S_285), ((V)&S_29))), CON(d_Asm_ucases_dtarget(SOME(d_Big_done()), ((V)&S_285)), CON(d_Asm_ucases_dtarget(NONE, ((V)&S_29)), NIL))), ((V)&S_319)), CON(rt_ctor3(0, ((V)&S_320), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), CON(rt_ctor1(1, SNIL), NIL), rt_ctor3(2, d_Big_done(), ((V)&S_285), ((V)&S_29))), CON(d_Asm_ucases_dtarget(NONE, ((V)&S_285)), CON(d_Asm_ucases_dtarget(SOME(d_Big_done()), ((V)&S_29)), NIL))), ((V)&S_321)), CON(rt_ctor3(0, ((V)&S_322), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), CON(rt_ctor1(1, SNIL), NIL), rt_ctor1(3, ((V)&S_285))), CON(d_Asm_ucases_dtarget(NONE, ((V)&S_285)), NIL)), ((V)&S_317)), CON(rt_ctor3(0, ((V)&S_323), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor1(3, ((V)&S_29))), CON(d_Asm_ucases_dstop(((V)&S_285), NIL), CON(d_Asm_ucases_dstop(((V)&S_29), NIL), NIL))), ((V)&S_324)), CON(rt_ctor3(0, ((V)&S_325), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor1(3, ((V)&S_10))), NIL), ((V)&S_326)), CON(rt_ctor3(0, ((V)&S_327), CON(d_Asm_ucases_dstop(((V)&S_10), NIL), CON(d_Asm_ucases_dstop(((V)&S_285), CON(rt_ctor1(0, ((V)&S_290)), NIL)), NIL)), ((V)&S_328)), CON(rt_ctor3(0, ((V)&S_329), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(0, ((V)&S_330)), NIL)), NIL), ((V)&S_331)), CON(rt_ctor3(0, ((V)&S_332), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(0, ((V)&S_333)), NIL)), NIL), ((V)&S_334)), CON(rt_ctor3(0, ((V)&S_335), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(0, ((V)&S_336)), NIL)), NIL), ((V)&S_337)), CON(rt_ctor3(0, ((V)&S_338), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor2(1, d_Big_dzero(), ((V)&S_10))), NIL), ((V)&S_339)), CON(rt_ctor3(0, ((V)&S_340), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor3(2, d_Big_dof_unat(NAT_SMALL(33ull)), ((V)&S_10), ((V)&S_10))), NIL), ((V)&S_341)), CON(rt_ctor3(0, ((V)&S_342), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(253ull))), rt_ctor2(1, d_Big_done(), ((V)&S_285))), CON(d_Asm_ucases_dtarget(SOME(d_Big_dof_unat(NAT_SMALL(253ull))), ((V)&S_285)), NIL)), ((V)&S_343)), NIL))))))))))))))))))))))))))))))))); ({ V scrut17161_1815 = ({ V local17156_1816 = CON(((V)&S_344), CON(((V)&S_345), CON(((V)&S_346), CON(((V)&S_347), CON(d_NativeString_drepeat(d_Big_dto_unat(d_Big_dof_unat(NAT_SMALL(66ull))), (((V)48u))), NIL))))); d_SeqList_dmapi(clo_new(lam_1819, 2, 0), local17156_1816); }); ({ V scrut17167_1820 = ({ V local17164_1821 = CON(d_Big_dneg(d_Big_dof_unat(NAT_SMALL(1ull))), CON(d_Big_dzero(), CON(d_Big_dof_unat(NAT_SMALL(17ull)), CON((kc_2_ok ? kc_2 : (kc_2 = d_Big_dpred(d_Big_dshift_uleft(d_Big_done(), NAT_SMALL(62ull))), rt_root(&kc_2), kc_2_ok = 1, kc_2)), NIL)))); list_concat(d_SeqList_dmap(clo_new(lam_1823, 1, 0), local17164_1821)); }); ({ V scrut17173_1824 = ({ V local17170_1825 = CON(((V)&S_354), CON(((V)&S_355), CON(((V)&S_356), CON(((V)&S_357), CON(((V)&S_358), CON(((V)&S_359), CON(((V)&S_360), CON(((V)&S_361), NIL)))))))); d_SeqList_dmap(clo_new(lam_1827, 1, 0), local17170_1825); }); ({ V scrut17189_1828 = d_SeqList_dmap(clo_new(lam_1838, 1, 0), list_append(scrut17153_1814, list_append(scrut17161_1815, list_append(scrut17167_1820, scrut17173_1824)))); ({ V scrut17194_1839 = CON(rt_ctor3(0, ((V)&S_364), d_Asm_ucases_dref20(), ((V)&S_365)), CON(rt_ctor3(0, ((V)&S_366), d_Asm_ucases_ddiamond(), ((V)&S_367)), CON(rt_ctor3(0, ((V)&S_276), d_Asm_ucases_dloop(), ((V)&S_368)), CON(rt_ctor3(0, ((V)&S_369), CON(d_Asm_ucases_dstop(((V)&S_10), CON(rt_ctor1(1, SNIL), CON(rt_ctor1(1, ((V)&S_370)), NIL))), NIL), ((V)&S_371)), CON(rt_ctor3(0, ((V)&S_372), CON(d_Asm_ucases_dstop(((V)&S_10), list_append(d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(1024ull))), CON(rt_ctor1(3, d_Big_dof_unat(NAT_SMALL(16ull))), NIL))), NIL), str_append(str_join(d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(1024ull)), clo_new(lam_1841, 1, 0)), SNIL), ((V)&S_374))), CON(rt_ctor3(0, ((V)&S_375), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor2(1, d_Big_dof_unat(NAT_SMALL(32ull)), ((V)&S_285))), CON(d_Asm_ucases_dtarget(NONE, ((V)&S_285)), NIL)), str_append(((V)&S_376), str_append(d_NativeString_drepeat(d_Big_dto_unat(d_Big_dof_unat(NAT_SMALL(62ull))), (((V)48u))), ((V)&S_377)))), CON(rt_ctor3(0, ((V)&S_378), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(2ull))), rt_ctor1(0, ((V)2))), NIL), ((V)&S_379)), CON(rt_ctor3(0, ((V)&S_380), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), CON(rt_ctor1(1, SNIL), NIL), rt_ctor1(0, ((V)4))), NIL), ((V)&S_381)), CON(rt_ctor3(0, ((V)&S_382), CON(d_Asm_ucases_dblock(NONE, NONE, ((V)&S_10), NIL, rt_ctor1(3, ((V)&S_285))), CON(d_Asm_ucases_dstop(((V)&S_285), NIL), NIL)), ((V)&S_370)), NIL))))))))); ({ V scrut17208_1842 = d_SeqList_dmap(clo_new(lam_1852, 1, 0), scrut17194_1839); ({ V scrut17236_1853 = clo_new(lam_1869, 4, 0); ({ V scrut17237_1870 = apn(scrut17236_1853, 4, (V[]){d_Asm_ucases_dref20(), ((V)&S_222), d_Big_dof_unat(NAT_SMALL(11ull)), CON(rt_ctor3(0, d_Big_dzero(), d_Big_dzero(), d_Big_dof_unat(NAT_SMALL(2ull))), CON(rt_ctor3(0, d_Big_dzero(), d_Big_dzero(), d_Big_dzero()), CON(rt_ctor3(0, d_Big_dzero(), d_Big_dzero(), d_Big_dzero()), CON(rt_ctor3(0, d_Big_dzero(), d_Big_dzero(), d_Big_dzero()), CON(rt_ctor3(0, d_Big_dzero(), d_Big_dzero(), d_Big_dzero()), CON(rt_ctor3(0, d_Big_dzero(), d_Big_dzero(), d_Big_dof_unat(NAT_SMALL(2ull))), NIL))))))}); ({ V _r = 0; V m_1871 = scrut17237_1870; if ((tag_of(m_1871) == 0)) { V _m_1871_a0_1872 = FLD(m_1871, 0); V _m_1871_a1_1873 = FLD(m_1871, 1); _r = ({ V p17238_1874 = _m_1871_a0_1872; ({ V p17239_1875 = _m_1871_a1_1873; ({ V scrut17240_1876 = apn(scrut17236_1853, 4, (V[]){d_Asm_ucases_ddiamond(), ((V)&S_274), d_Big_dof_unat(NAT_SMALL(17ull)), CON(rt_ctor3(0, d_Big_dzero(), d_Big_dzero(), d_Big_dof_unat(NAT_SMALL(2ull))), CON(rt_ctor3(0, d_Big_dzero(), d_Big_done(), d_Big_dof_unat(NAT_SMALL(2ull))), CON(rt_ctor3(0, d_Big_dzero(), d_Big_done(), d_Big_done()), CON(rt_ctor3(0, d_Big_done(), d_Big_dzero(), d_Big_done()), NIL))))}); ({ V _r = 0; V m_1877 = scrut17240_1876; if ((tag_of(m_1877) == 0)) { V _m_1877_a0_1878 = FLD(m_1877, 0); V _m_1877_a1_1879 = FLD(m_1877, 1); _r = ({ V p17241_1880 = _m_1877_a0_1878; ({ V p17242_1881 = _m_1877_a1_1879; ({ V scrut17243_1882 = rt_ctor2(0, d_Asm_ucases_dreport(((V)&S_383), ((p17238_1874) != FALSE_V ? p17241_1880 : FALSE_V), ((V)&S_384)), d_NativeInt_dadd(p17239_1875, p17242_1881)); ({ V scrut17244_1883 = list_append(CON(scrut17243_1882, scrut17189_1828), scrut17208_1842); ({ V scrut17248_1884 = d_SeqList_dall(clo_new(lam_1886, 1, 0), scrut17244_1883); ({ V scrut17256_1887 = d_SeqList_dfold(clo_new(lam_1896, 2, 0), scrut17244_1883, d_Big_dzero()); rt_ctor4(0, ((scrut17248_1884) != FALSE_V ? d_Big_dzero() : d_Big_done()), scrut17256_1887, d_Big_dof_unat(list_length(d_SeqList_dfilter(clo_new(lam_1904, 1, 0), scrut17244_1883))), d_Big_dof_unat(list_length(scrut17244_1883))); }); }); }); }); }); }); } else rt_panic("match: no case at tests:810"); _r; }); }); }); }); } else rt_panic("match: no case at tests:809"); _r; }); }); }); }); }); }); }); }); }); }); });
}
V d_Asm_ucases_deffect(V name_629_1905, V count_630_1906) {
  return ({ V scrut17275_1907 = list_append(d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(33ull)), clo_new(lam_1909, 1, 0)), list_append(d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(16ull)), clo_new(lam_1911, 1, 0)), d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(16ull)), clo_new(lam_1913, 1, 0)))); ({ V scrut17279_1914 = ({ V local17278_1915 = d_SeqList_dassoc(clo_new(lam_1918, 2, 0), name_629_1905, scrut17275_1907); maybe_default(local17278_1915, rt_ctor1(0, name_629_1905)); }); ({ V scrut17292_1919 = ({ V _r = 0; V m_1920 = ({ V local17282_1921 = d_TestNumber_dread(count_630_1906); ({ V _r = 0; V m_1922 = local17282_1921; if (((m_1922) == NONE)) {  _r = ({ V __1923 = UNIT; FAIL(((V)&S_388)); }); } else if (((m_1922) != NONE)) { V _m_1922_a0_1924 = FLD(m_1922, 0); _r = ({ V x_1925 = _m_1922_a0_1924; DONE(x_1925); }); } else rt_panic("match: no case at tests:821"); _r; }); }); switch (tag_of(m_1920)) { case 1: { V _m_1920_a0_1926 = FLD(m_1920, 0); _r = ({ V item17290_1927 = _m_1920_a0_1926; ({ V local17284_1928 = item17290_1927; ((((d_Big_dis_ult(local17284_1928, d_Big_dzero())) != FALSE_V ? TRUE_V : d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(1024ull)), local17284_1928))) != FALSE_V ? FAIL(((V)&S_388)) : ({ V local17287_1929 = d_Asm_dassemble(CON(d_Asm_ucases_dstop(((V)&S_389), list_append(d_Asm_ucases_dzeros(local17284_1928), CON(scrut17279_1914, NIL))), NIL)); ({ V _r = 0; V m_1930 = local17287_1929; switch (tag_of(m_1930)) { case 1: { V _m_1930_a0_1931 = FLD(m_1930, 0); _r = ({ V item17288_1932 = _m_1930_a0_1931; DONE(item17288_1932); }); break; } case 0: { V _m_1930_a0_1933 = FLD(m_1930, 0); _r = ({ V item17289_1934 = _m_1930_a0_1933; FAIL(d_Asm_derror_utext(item17289_1934)); }); break; } default: rt_panic("match: no case at tests:821"); } _r; }); })); }); }); break; } case 0: { V _m_1920_a0_1935 = FLD(m_1920, 0); _r = ({ V item17291_1936 = _m_1920_a0_1935; FAIL(item17291_1936); }); break; } default: rt_panic("match: no case at tests:821"); } _r; }); scrut17292_1919; }); }); });
}
V d_Asm_ucases_dfixtures(void) {
  static V memo; static int done;
  if (!done) { memo = CON(rt_ctor2(0, ((V)&S_364), d_Asm_ucases_dref20()), CON(rt_ctor2(0, ((V)&S_366), d_Asm_ucases_ddiamond()), CON(rt_ctor2(0, ((V)&S_276), d_Asm_ucases_dloop()), CON(rt_ctor2(0, ((V)&S_390), CON(d_Asm_ucases_dstop(((V)&S_390), d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(33ull)), clo_new(lam_1938, 1, 0))), NIL)), CON(rt_ctor2(0, ((V)&S_391), CON(d_Asm_ucases_dstop(((V)&S_391), list_append(d_Asm_ucases_dzeros(d_Big_dof_unat(NAT_SMALL(17ull))), list_append(d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(16ull)), clo_new(lam_1940, 1, 0)), d_SeqList_dinit(d_Big_dof_unat(NAT_SMALL(16ull)), clo_new(lam_1942, 1, 0))))), NIL)), NIL))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Emit_ucases_dlit(V n_325_1943) {
  return rt_ctor1(1, rt_ctor1(1, d_Big_didentity(n_325_1943)));
}
V d_Emit_ucases_denv(void) {
  static V memo; static int done;
  if (!done) { memo = d_Emit_denvironment(NONE, CON(rt_ctor2(0, ((V)&S_392), rt_ctor1(2, CON(rt_ctor4(0, rt_ctor1(0, ((V)&S_392)), CON(((V)0), NIL), ((V)0), rt_ctor2(6, rt_ctor1(2, ((V)&S_393)), CON(rt_ctor1(0, d_Big_dzero()), CON(d_Emit_ucases_dlit(d_Big_done()), NIL)))), NIL))), NIL)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Emit_ucases_dvalue(V result_502_1944) {
  return ({ V _r = 0; V m_1945 = result_502_1944; switch (tag_of(m_1945)) { case 1: { V _m_1945_a0_1946 = FLD(m_1945, 0); _r = ({ V item17304_1947 = _m_1945_a0_1946; DONE(({ V local17303_1948 = item17304_1947; d_Get_dTuple2_dv0(local17303_1948); })); }); break; } case 0: { V _m_1945_a0_1949 = FLD(m_1945, 0); _r = ({ V item17305_1950 = _m_1945_a0_1949; FAIL(item17305_1950); }); break; } default: rt_panic("match: no case at tests:834"); } _r; });
}
V d_Emit_ucases_deval(V term_844_1951) {
  return d_Emit_ucases_dvalue(d_Emit_deval(d_Emit_ucases_denv(), NIL, d_Big_dof_unat(NAT_SMALL(1000ull)), term_844_1951));
}
V d_Emit_ucases_drequire(V label_321_1952, V yes_322_1953) {
  return ((yes_322_1953) != FALSE_V ? DONE(UNIT) : FAIL(label_321_1952));
}
V d_Emit_ucases_dgood(V label_847_1954, V expected_848_1955, V term_849_1956) {
  return d_Emit_ucases_drequire(label_847_1954, d_Equal_dEmit_uResult_uRecognize_uValue_u(d_Emit_ucases_deval(term_849_1956), DONE(expected_848_1955)));
}
V d_Emit_ucases_dpair_utid(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor1(0, ((V)&S_394)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Emit_ucases_dbad(V label_934_1957, V expected_935_1958, V term_936_1959) {
  return d_Emit_ucases_drequire(label_934_1957, d_Equal_dEmit_uResult_uRecognize_uValue_u(d_Emit_ucases_deval(term_936_1959), FAIL(expected_935_1958)));
}
V d_Emit_ucases_dconstructors(V param_1048_1960) {
  return ({ V scrut17300_1961 = param_1048_1960; ({ V scrut17380_1962 = CON(d_Emit_ucases_dgood(((V)&S_395), rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(7ull)))), d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(7ull)))), CON(d_Emit_ucases_dgood(((V)&S_396), ((V)2), ((V)3)), CON(d_Emit_ucases_dgood(((V)&S_397), rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(9ull)))), rt_ctor3(4, ((V)&S_10), d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(9ull))), rt_ctor1(0, d_Big_dzero()))), CON(d_Emit_ucases_dgood(((V)&S_398), rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(10ull)))), rt_ctor2(6, rt_ctor1(2, ((V)&S_392)), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(9ull))), NIL))), CON(d_Emit_ucases_dgood(((V)&S_399), rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(10ull)))), rt_ctor2(7, rt_ctor1(2, ((V)&S_392)), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(9ull))), NIL))), CON(d_Emit_ucases_dgood(((V)&S_400), rt_ctor2(5, d_Emit_ucases_dpair_utid(), CON(rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(8ull)))), NIL)), rt_ctor2(8, d_Emit_ucases_dpair_utid(), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(8ull))), NIL))), CON(d_Emit_ucases_dgood(((V)&S_401), rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(8ull)))), rt_ctor3(9, d_Emit_ucases_dpair_utid(), d_Big_dzero(), rt_ctor2(8, d_Emit_ucases_dpair_utid(), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(8ull))), NIL)))), CON(d_Emit_ucases_dgood(((V)&S_402), rt_ctor3(6, d_Emit_ucases_dpair_utid(), d_Big_dof_unat(NAT_SMALL(2ull)), CON(rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(8ull)))), NIL)), rt_ctor3(10, d_Emit_ucases_dpair_utid(), d_Big_dof_unat(NAT_SMALL(2ull)), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(8ull))), NIL))), CON(d_Emit_ucases_dgood(((V)&S_403), rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(8ull)))), rt_ctor3(11, d_Emit_ucases_dpair_utid(), rt_ctor3(10, d_Emit_ucases_dpair_utid(), d_Big_dof_unat(NAT_SMALL(2ull)), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(8ull))), NIL)), CON(rt_ctor3(0, d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done(), rt_ctor1(0, d_Big_dzero())), NIL))), CON(d_Emit_ucases_dgood(((V)&S_404), rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(8ull)))), rt_ctor3(11, d_Recognize_dword_utid(), rt_ctor3(10, d_Recognize_dword_utid(), d_Big_dzero(), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(8ull))), NIL)), CON(rt_ctor3(0, d_Big_dzero(), d_Big_done(), rt_ctor1(0, d_Big_dzero())), NIL))), CON(d_Emit_ucases_dbad(((V)&S_405), ((V)3), rt_ctor3(5, rt_ctor1(0, ((V)&S_392)), d_Big_done(), NIL)), CON(d_Emit_ucases_dbad(((V)&S_406), ((V)3), rt_ctor2(6, rt_ctor1(0, d_Big_dzero()), CON(d_Emit_ucases_dlit(d_Big_dzero()), NIL))), CON(d_Emit_ucases_dbad(((V)&S_40), ((V)3), rt_ctor1(2, ((V)&S_392))), CON(d_Emit_ucases_dbad(((V)&S_407), rt_ctor1(4, ((V)&S_408)), rt_ctor2(12, rt_ctor1(0, ((V)&S_392)), NIL)), CON(d_Emit_ucases_dbad(((V)&S_409), rt_ctor1(4, ((V)&S_410)), rt_ctor1(13, d_Emit_ucases_dlit(d_Big_dzero()))), CON(d_Emit_ucases_drequire(((V)&S_411), ({ V _r = 0; V m_1963 = d_Emit_dresult_urepr(rt_ctor1(4, d_Emit_ucases_dpair_utid())); switch (tag_of(m_1963)) { case 1: { V _m_1963_a0_1964 = FLD(m_1963, 0); _r = ({ V value_d2_1965 = _m_1963_a0_1964; FALSE_V; }); break; } case 0: { V _m_1963_a0_1966 = FLD(m_1963, 0); _r = ({ V error_d2_1967 = _m_1963_a0_1966; d_Equal_dEmit_uError(error_d2_1967, rt_ctor1(4, ((V)&S_412))); }); break; } default: rt_panic("match: no case at tests:853"); } _r; })), CON(d_Emit_ucases_dbad(((V)&S_141), rt_ctor1(4, ((V)&S_413)), rt_ctor1(1, rt_ctor1(0, ((V)&S_10)))), CON(d_Emit_ucases_dbad(((V)&S_414), rt_ctor1(5, ((V)&S_415)), rt_ctor1(0, d_Big_dneg(d_Big_dof_unat(NAT_SMALL(1ull))))), CON(d_Emit_ucases_dbad(((V)&S_256), rt_ctor1(1, ((V)&S_416)), rt_ctor1(2, ((V)&S_416))), CON(d_Emit_ucases_drequire(((V)&S_417), d_Equal_dEmit_uResult_uTupleOf2_uRecognize_uValue_u_uBig_u_u(d_Emit_deval(d_Emit_ucases_denv(), NIL, d_Big_dzero(), d_Emit_ucases_dlit(d_Big_done())), FAIL(((V)7)))), CON(d_Emit_ucases_drequire(((V)&S_418), d_Equal_dEmit_uResult_uEmit_uEffect_u(d_Emit_deffect(d_Big_dzero(), rt_ctor1(0, d_Big_dzero())), FAIL(((V)6)))), CON(d_Emit_ucases_dgood(((V)&S_419), rt_ctor1(0, d_Big_dzero()), rt_ctor2(6, rt_ctor1(2, ((V)&S_419)), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(2ull))), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(8ull))), NIL)))), CON(d_Emit_ucases_dgood(((V)&S_420), rt_ctor1(0, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(42ull)))), rt_ctor2(6, rt_ctor1(2, ((V)&S_420)), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(6ull))), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(7ull))), NIL)))), NIL))))))))))))))))))))))); ({ V _r = 0; V m_1968 = d_SeqList_dfold(clo_new(lam_1978, 2, 0), scrut17380_1962, DONE(UNIT)); switch (tag_of(m_1968)) { case 1: { V _m_1968_a0_1979 = FLD(m_1968, 0); _r = ({ V item17395_1980 = _m_1968_a0_1979; ({ V local17393_1981 = item17395_1980; ({ V scrut17394_1982 = local17393_1981; DONE(str_concat(CON(((V)&S_421), CON(d_Big_dshow(d_Big_dof_unat(list_length(scrut17380_1962))), CON(((V)&S_264), NIL))))); }); }); }); break; } case 0: { V _m_1968_a0_1983 = FLD(m_1968, 0); _r = ({ V item17396_1984 = _m_1968_a0_1983; FAIL(item17396_1984); }); break; } default: rt_panic("match: no case at tests:854"); } _r; }); }); });
}
V d_Emit_ucases_dunit_utid(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor1(0, ((V)&S_422)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Emit_ucases_dleak(V result_1051_1985) {
  return ({ V _r = 0; V m_1986 = result_1051_1985; switch (tag_of(m_1986)) { case 1: { V _m_1986_a0_1987 = FLD(m_1986, 0); _r = ({ V x_1988 = _m_1986_a0_1987; ({ V local17429_1989 = x_1988; d_Big_done(); }); }); break; } case 0: { V _m_1986_a0_1990 = FLD(m_1986, 0); _r = ({ V x_1991 = _m_1986_a0_1990; ({ V local17431_1992 = x_1991; d_Big_dzero(); }); }); break; } default: rt_panic("match: no case at tests:862"); } _r; });
}
V d_Emit_ucases_dis_uword(V value_1056_1993) {
  return ({ V scrut17434_1994 = value_1056_1993; ({ V _r = 0; V m_1995 = scrut17434_1994; switch (tag_of(m_1995)) { case 0: { V _m_1995_a0_1996 = FLD(m_1995, 0); _r = ({ V p17435_1997 = _m_1995_a0_1996; FALSE_V; }); break; } case 1: { V _m_1995_a0_1998 = FLD(m_1995, 0); _r = ({ V p17436_1999 = _m_1995_a0_1998; TRUE_V; }); break; } case 2: {  _r = ({ V __2000 = UNIT; FALSE_V; }); break; } case 3: { V _m_1995_a0_2001 = FLD(m_1995, 0); _r = ({ V p17437_2002 = _m_1995_a0_2001; FALSE_V; }); break; } case 4: { V _m_1995_a0_2003 = FLD(m_1995, 0); V _m_1995_a1_2004 = FLD(m_1995, 1); V _m_1995_a2_2005 = FLD(m_1995, 2); _r = ({ V p17438_2006 = _m_1995_a0_2003; ({ V p17439_2007 = _m_1995_a1_2004; ({ V p17440_2008 = _m_1995_a2_2005; FALSE_V; }); }); }); break; } case 5: { V _m_1995_a0_2009 = FLD(m_1995, 0); V _m_1995_a1_2010 = FLD(m_1995, 1); _r = ({ V p17441_2011 = _m_1995_a0_2009; ({ V p17442_2012 = _m_1995_a1_2010; FALSE_V; }); }); break; } case 6: { V _m_1995_a0_2013 = FLD(m_1995, 0); V _m_1995_a1_2014 = FLD(m_1995, 1); V _m_1995_a2_2015 = FLD(m_1995, 2); _r = ({ V p17443_2016 = _m_1995_a0_2013; ({ V p17444_2017 = _m_1995_a1_2014; ({ V p17445_2018 = _m_1995_a2_2015; FALSE_V; }); }); }); break; } default: rt_panic("match: no case at tests:866"); } _r; }); });
}
V d_Emit_ucases_dwords(V param_1087_2019) {
  return ({ V scrut17398_2020 = param_1087_2019; ({ V scrut17399_2021 = (kc_3_ok ? kc_3 : (kc_3 = d_Big_dpred(d_Big_dshift_uleft(d_Big_done(), d_Big_dto_unat(d_Big_dof_unat(NAT_SMALL(256ull))))), rt_root(&kc_3), kc_3_ok = 1, kc_3)); ({ V scrut17408_2022 = CON(d_Emit_ucases_drequire(((V)&S_423), d_Equal_dResultOf_uRecognize_uError_u_uRecognize_uValue_u(d_Recognize_dtag(d_Recognize_dword_utid(), d_Big_dzero(), CON(rt_ctor1(0, d_Big_dzero()), NIL)), DONE(rt_ctor1(1, d_Big_dzero())))), CON(d_Emit_ucases_drequire(((V)&S_424), d_Equal_dResultOf_uRecognize_uError_u_uRecognize_uValue_u(d_Recognize_dtag(d_Recognize_dword_utid(), d_Big_dzero(), CON(rt_ctor1(0, scrut17399_2021), NIL)), DONE(rt_ctor1(1, scrut17399_2021)))), CON(d_Emit_ucases_drequire(((V)&S_425), d_Equal_dResultOf_uRecognize_uError_u_uRecognize_uValue_u(d_Recognize_dtag(d_Recognize_dword_utid(), d_Big_dzero(), CON(rt_ctor1(0, d_Big_dsucc(scrut17399_2021)), NIL)), FAIL(((V)2)))), CON(d_Emit_ucases_drequire(((V)&S_426), d_Equal_dResultOf_uRecognize_uError_u_uRecognize_uValue_u(d_Recognize_dtag(d_Recognize_dword_utid(), d_Big_dzero(), CON(rt_ctor1(0, d_Big_dneg(d_Big_done())), NIL)), FAIL(((V)2)))), CON(d_Emit_ucases_drequire(((V)&S_427), d_Equal_dResultOf_uRecognize_uError_u_uRecognize_uValue_u(d_Recognize_dtag(d_Recognize_dword_utid(), d_Big_done(), CON(rt_ctor1(0, d_Big_dzero()), NIL)), FAIL(((V)1)))), CON(d_Emit_ucases_drequire(((V)&S_428), d_Equal_dResultOf_uRecognize_uError_u_uRecognize_uValue_u(d_Recognize_dstruct_uvalue(d_Recognize_dword_utid(), CON(rt_ctor1(0, d_Big_dzero()), NIL)), FAIL(((V)3)))), CON(d_Emit_ucases_drequire(((V)&S_429), d_Equal_dResultOf_uRecognize_uError_u_uUnit_u(d_Recognize_dunboxed(rt_ctor3(6, d_Recognize_dword_utid(), d_Big_dzero(), CON(rt_ctor1(0, d_Big_dzero()), NIL))), FAIL(((V)3)))), CON(d_Emit_ucases_drequire(((V)&S_430), d_Equal_dResultOf_uRecognize_uError_u_uUnit_u(d_Recognize_dunboxed(rt_ctor2(5, d_Emit_ucases_dunit_utid(), CON(rt_ctor2(5, d_Recognize_dword_utid(), CON(rt_ctor1(0, d_Big_dzero()), NIL)), NIL))), FAIL(((V)3)))), CON(d_Emit_ucases_dgood(((V)&S_431), rt_ctor1(1, d_Big_didentity(d_Big_dof_unat(NAT_SMALL(42ull)))), rt_ctor3(10, d_Recognize_dword_utid(), d_Big_dzero(), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(42ull))), NIL))), NIL))))))))); ({ V _r = 0; V m_2023 = d_SeqList_dfold(clo_new(lam_2033, 2, 0), scrut17408_2022, DONE(UNIT)); switch (tag_of(m_2023)) { case 1: { V _m_2023_a0_2034 = FLD(m_2023, 0); _r = ({ V item17449_2035 = _m_2023_a0_2034; ({ V local17421_2036 = item17449_2035; ({ V scrut17422_2037 = local17421_2036; ({ V scrut17426_2038 = d_SeqList_dfilter_umap(clo_new(lam_2045, 1, 0), CON(d_Recognize_dtag(d_Recognize_dword_utid(), d_Big_dzero(), CON(rt_ctor1(0, d_Big_dzero()), NIL)), CON(d_Recognize_dtag(d_Recognize_dword_utid(), d_Big_dzero(), CON(rt_ctor1(0, scrut17399_2021), NIL)), NIL))); ({ V scrut17427_2046 = ({ V _r = 0; V m_2047 = ({ V _r = 0; V m_2048 = d_Emit_ucases_deval(rt_ctor3(10, d_Recognize_dword_utid(), d_Big_dzero(), CON(d_Emit_ucases_dlit(d_Big_dof_unat(NAT_SMALL(42ull))), NIL))); switch (tag_of(m_2048)) { case 1: { V _m_2048_a0_2049 = FLD(m_2048, 0); _r = ({ V x_2050 = _m_2048_a0_2049; SOME(x_2050); }); break; } case 0: { V _m_2048_a0_2051 = FLD(m_2048, 0); _r = ({ V __2052 = _m_2048_a0_2051; NONE; }); break; } default: rt_panic("match: no case at tests:875"); } _r; }); if (((m_2047) == NONE)) {  _r = ({ V __2053 = UNIT; NIL; }); } else if (((m_2047) != NONE)) { V _m_2047_a0_2054 = FLD(m_2047, 0); _r = ({ V item_2055 = _m_2047_a0_2054; CON(item_2055, NIL); }); } else rt_panic("match: no case at tests:875"); _r; }); ({ V scrut17432_2056 = d_Emit_ucases_dleak(d_Recognize_dunboxed(rt_ctor3(6, d_Recognize_dword_utid(), d_Big_dzero(), CON(rt_ctor1(0, d_Big_dzero()), NIL)))); ({ V scrut17433_2057 = d_NativeInt_dadd(d_Emit_ucases_dleak(d_Recognize_dstruct_uvalue(d_Recognize_dword_utid(), CON(rt_ctor1(0, d_Big_dzero()), NIL))), d_Emit_ucases_dleak(d_Recognize_dunboxed(rt_ctor2(5, d_Emit_ucases_dunit_utid(), CON(rt_ctor2(5, d_Recognize_dword_utid(), CON(rt_ctor1(0, d_Big_dzero()), NIL)), NIL))))); ({ V scrut17446_2058 = d_Big_dof_unat(list_length(d_SeqList_dfilter(clo_new(w_Emit_ucases_dis_uword, 1, 0), list_append(scrut17426_2038, scrut17427_2046)))); DONE(str_concat(CON(((V)&S_432), CON(d_Big_dshow(scrut17432_2056), CON(((V)&S_433), CON(d_Big_dshow(scrut17433_2057), CON(((V)&S_434), CON(d_Big_dshow(scrut17446_2058), CON(((V)&S_435), CON(d_Big_dshow(d_Big_dof_unat(list_length(scrut17408_2022))), CON(((V)&S_264), NIL))))))))))); }); }); }); }); }); }); }); }); break; } case 0: { V _m_2023_a0_2059 = FLD(m_2023, 0); _r = ({ V item17450_2060 = _m_2023_a0_2059; FAIL(item17450_2060); }); break; } default: rt_panic("match: no case at tests:872"); } _r; }); }); }); });
}
V d_Emit_ucases_dstorage(V param_1109_2061) {
  return ({ V scrut17452_2062 = param_1109_2061; ({ V scrut17453_2063 = rt_ctor3(5, rt_ctor1(0, ((V)&S_392)), d_Big_done(), NIL); ({ V scrut17456_2064 = ({ V _c = clo_new(lam_2066, 1, 1); CLO_ENV(_c)[0] = scrut17453_2063; _c; }); ({ V scrut17457_2067 = rt_ctor2(8, d_Emit_ucases_dpair_utid(), CON(rt_ctor3(10, d_Recognize_dword_utid(), d_Big_dzero(), CON(d_Emit_ucases_dlit(d_Big_dzero()), NIL)), NIL)); ({ V scrut17458_2068 = rt_ctor2(8, d_Emit_ucases_dpair_utid(), CON(scrut17453_2063, NIL)); ({ V scrut17459_2069 = rt_ctor2(7, rt_ctor1(2, ((V)&S_392)), NIL); ({ V scrut17460_2070 = rt_ctor1(2, ((V)&S_436)); ({ V scrut17461_2071 = rt_ctor2(5, d_Emit_ucases_dpair_utid(), CON(rt_ctor1(1, d_Big_dzero()), CON(rt_ctor1(1, d_Big_done()), NIL))); ({ V scrut17468_2072 = CON(d_Emit_ucases_drequire(((V)&S_437), d_Equal_dResultOf_uRecognize_uError_u_uUnit_u(d_Recognize_dno_uclosure(scrut17456_2064, NIL, scrut17457_2067), DONE(UNIT))), CON(d_Emit_ucases_drequire(((V)&S_438), d_Equal_dResultOf_uRecognize_uError_u_uUnit_u(d_Recognize_dno_uclosure(scrut17456_2064, NIL, scrut17458_2068), FAIL(((V)4)))), CON(d_Emit_ucases_drequire(((V)&S_439), d_Equal_dResultOf_uRecognize_uError_u_uUnit_u(d_Recognize_dno_uclosure(scrut17456_2064, NIL, scrut17459_2069), FAIL(((V)4)))), CON(d_Emit_ucases_drequire(((V)&S_440), d_Equal_dResultOf_uRecognize_uError_u_uUnit_u(d_Recognize_dno_uclosure(scrut17456_2064, NIL, scrut17460_2070), FAIL(((V)4)))), CON(d_Emit_ucases_drequire(((V)&S_441), d_Equal_dResultOf_uRecognize_uError_u_uUnit_u(d_Recognize_dno_uclosure(clo_new(lam_2074, 1, 0), NIL, rt_ctor1(2, ((V)&S_276))), FAIL(((V)4)))), CON(d_Emit_ucases_drequire(((V)&S_442), d_Equal_dResultOf_uRecognize_uError_u_uListOf_uString_u_u(d_Recognize_dstorage(scrut17461_2071), DONE(CON(((V)&S_443), CON(((V)&S_444), NIL))))), CON(d_Emit_ucases_drequire(((V)&S_445), d_Equal_dResultOf_uRecognize_uError_u_uListOf_uString_u_u(d_Recognize_dstorage(rt_ctor2(5, d_Emit_ucases_dpair_utid(), CON(rt_ctor1(1, d_Big_done()), NIL))), FAIL(((V)6)))), CON(d_Emit_ucases_drequire(((V)&S_446), d_Equal_dResultOf_uRecognize_uError_u_uListOf_uString_u_u(d_Recognize_dstorage(rt_ctor2(5, d_Emit_ucases_dpair_utid(), CON(rt_ctor1(0, d_Big_dzero()), NIL))), FAIL(((V)5)))), CON(d_Emit_ucases_drequire(((V)&S_447), d_Equal_dEmit_uResult_uEmit_uEffect_u(d_Emit_deffect(d_Big_done(), rt_ctor3(6, d_Recognize_deff_utid(), d_Big_dof_unat(NAT_SMALL(2ull)), CON(rt_ctor1(1, d_Big_done()), NIL))), FAIL(((V)9)))), NIL))))))))); ({ V _r = 0; V m_2075 = d_SeqList_dfold(clo_new(lam_2085, 2, 0), scrut17468_2072, DONE(UNIT)); switch (tag_of(m_2075)) { case 1: { V _m_2075_a0_2086 = FLD(m_2075, 0); _r = ({ V item17492_2087 = _m_2075_a0_2086; ({ V local17481_2088 = item17492_2087; ({ V scrut17482_2089 = local17481_2088; ({ V scrut17483_2090 = d_NativeInt_dadd(d_Emit_ucases_dleak(d_Recognize_dno_uclosure(scrut17456_2064, NIL, scrut17458_2068)), d_Emit_ucases_dleak(d_Recognize_dno_uclosure(scrut17456_2064, NIL, scrut17460_2070))); ({ V scrut17484_2091 = d_Emit_ucases_dleak(d_Recognize_dno_uclosure(scrut17456_2064, NIL, scrut17459_2069)); ({ V scrut17490_2092 = ({ V _r = 0; V m_2093 = d_Recognize_dstorage(scrut17461_2071); switch (tag_of(m_2093)) { case 1: { V _m_2093_a0_2094 = FLD(m_2093, 0); _r = ({ V x_2095 = _m_2093_a0_2094; ({ V local17487_2096 = x_2095; d_Big_dof_unat(list_length(local17487_2096)); }); }); break; } case 0: { V _m_2093_a0_2097 = FLD(m_2093, 0); _r = ({ V x_2098 = _m_2093_a0_2097; ({ V local17489_2099 = x_2098; d_Big_dzero(); }); }); break; } default: rt_panic("match: no case at tests:895"); } _r; }); DONE(str_concat(CON(((V)&S_448), CON(d_Big_dshow(scrut17483_2090), CON(((V)&S_449), CON(d_Big_dshow(scrut17484_2091), CON(((V)&S_450), CON(d_Big_dshow(scrut17490_2092), CON(((V)&S_435), CON(d_Big_dshow(d_Big_dof_unat(list_length(scrut17468_2072))), CON(((V)&S_264), NIL))))))))))); }); }); }); }); }); }); break; } case 0: { V _m_2075_a0_2100 = FLD(m_2075, 0); _r = ({ V item17493_2101 = _m_2075_a0_2100; FAIL(item17493_2101); }); break; } default: rt_panic("match: no case at tests:891"); } _r; }); }); }); }); }); }); }); }); }); });
}
V d_One_upaths_dpostulate(V globals_883_2102, V name_884_2103, V ty_885_2104) {
  return ({ V _r = 0; V m_2105 = d_Check_dcheck_udecl(globals_883_2102, d_Budget_dunlimited(), rt_ctor4(0, name_884_2103, ((V)1), ty_885_2104, NONE)); switch (tag_of(m_2105)) { case 1: { V _m_2105_a0_2106 = FLD(m_2105, 0); _r = ({ V item17501_2107 = _m_2105_a0_2106; ({ V local17500_2108 = item17501_2107; DONE(d_Global_dadd(name_884_2103, local17500_2108, globals_883_2102)); }); }); break; } case 0: { V _m_2105_a0_2109 = FLD(m_2105, 0); _r = ({ V item17502_2110 = _m_2105_a0_2109; FAIL(item17502_2110); }); break; } default: rt_panic("match: no case at tests:899"); } _r; });
}
V d_One_upaths_dvoid(void) {
  static V memo; static int done;
  if (!done) { memo = d_Rules_dsum_uty(NIL); rt_root(&memo); done = 1; }
  return memo;
}
V d_One_upaths_dlambda(V q_656_2111, V name_657_2112, V dom_658_2113, V body_659_2114) {
  return rt_ctor2(6, rt_ctor3(0, q_656_2111, name_657_2112, dom_658_2113), CON(rt_ctor2(0, CON(rt_ctor2(0, q_656_2111, name_657_2112), NIL), body_659_2114), NIL));
}
V d_One_upaths_dcheck(V globals_733_2115, V term_734_2116, V ty_735_2117) {
  return ({ V _r = 0; V m_2118 = d_Eval_deval(globals_733_2115, NIL, ty_735_2117); switch (tag_of(m_2118)) { case 1: { V _m_2118_a0_2119 = FLD(m_2118, 0); _r = ({ V item17520_2120 = _m_2118_a0_2119; ({ V local17519_2121 = item17520_2120; d_Check_dcheck_uterm(NONE, globals_733_2115, term_734_2116, local17519_2121); }); }); break; } case 0: { V _m_2118_a0_2122 = FLD(m_2118, 0); _r = ({ V item17521_2123 = _m_2118_a0_2122; FAIL(item17521_2123); }); break; } default: rt_panic("match: no case at tests:908"); } _r; });
}
V d_One_upaths_dlinear(V globals_877_2124, V dom_878_2125, V cod_879_2126, V body_880_2127) {
  return d_One_upaths_dcheck(globals_877_2124, d_One_upaths_dlambda(((V)1), ((V)&S_10), dom_878_2125, body_880_2127), d_Rules_darrow(((V)1), ((V)&S_10), dom_878_2125, cod_879_2126));
}
V d_One_upaths_dboth(void) {
  static V memo; static int done;
  if (!done) { memo = d_Rules_dsum_uty(CON(d_Prim_dnat_uty(), CON(d_Prim_dnat_uty(), NIL))); rt_root(&memo); done = 1; }
  return memo;
}
V d_One_upaths_dbranch(V index_936_2128, V body_937_2129) {
  return rt_ctor2(0, rt_ctor1(1, index_936_2128), rt_ctor2(0, CON(rt_ctor2(0, ((V)2), ((V)&S_451)), NIL), body_937_2129));
}
V d_One_upaths_delimination(V shape_940_2130, V scrut_941_2131, V quantity_942_2132, V branches_943_2133) {
  return rt_ctor1(5, ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = shape_940_2130; _o->f[1] = scrut_941_2131; _o->f[2] = quantity_942_2132; _o->f[3] = NONE; _o->f[4] = branches_943_2133; (V)_o; }));
}
V d_One_upaths_dcase(V scrut_946_2134, V quantity_947_2135, V body0_948_2136, V body1_949_2137) {
  return d_One_upaths_delimination(rt_ctor1(1, d_Big_dof_unat(NAT_SMALL(2ull))), scrut_946_2134, quantity_947_2135, CON(d_One_upaths_dbranch(d_Big_dzero(), body0_948_2136), CON(d_One_upaths_dbranch(d_Big_done(), body1_949_2137), NIL)));
}
V d_One_upaths_dzero(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor1(11, rt_ctor1(1, d_Big_dzero())); rt_root(&memo); done = 1; }
  return memo;
}
V d_One_upaths_dapp(V stamp_728_2138, V name_729_2139, V argument_730_2140) {
  return rt_ctor3(7, rt_ctor3(0, stamp_728_2138, ((V)&S_452), d_Prim_dnat_uty()), rt_ctor2(0, stamp_728_2138, argument_730_2140), rt_ctor1(10, name_729_2139));
}
V d_One_upaths_dabsurd(V scrut_952_2141) {
  return d_One_upaths_delimination(rt_ctor1(1, d_Big_dzero()), scrut_952_2141, ((V)1), NIL);
}
V d_One_upaths_dcases(V globals_1043_2142) {
  return ({ V scrut17522_2143 = ({ V _c = clo_new(lam_2145, 1, 1); CLO_ENV(_c)[0] = globals_1043_2142; _c; }); ({ V scrut17527_2146 = ({ V _c = clo_new(lam_2149, 2, 1); CLO_ENV(_c)[0] = globals_1043_2142; _c; }); ({ V scrut17532_2150 = clo_new(lam_2153, 2, 0); ({ V scrut17533_2154 = d_Rules_darrow(((V)2), ((V)&S_453), d_Prim_dnat_uty(), d_Prim_dnat_uty()); ({ V scrut17534_2155 = d_One_upaths_dlambda(((V)2), ((V)&S_453), d_Prim_dnat_uty(), rt_ctor1(0, d_Big_done())); ({ V scrut17537_2156 = clo_new(lam_2158, 1, 0); CON(rt_ctor3(0, ((V)&S_454), ((V)0), ap(scrut17522_2143, rt_ctor1(0, d_Big_dzero()))), CON(rt_ctor3(0, ((V)&S_455), ((V)1), ap(scrut17522_2143, d_One_upaths_dzero())), CON(rt_ctor3(0, ((V)&S_456), ((V)1), ap(scrut17522_2143, d_One_upaths_dapp(((V)1), ((V)&S_457), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_458), ((V)1), ap(scrut17522_2143, d_One_upaths_dapp(((V)0), ((V)&S_459), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_460), ((V)1), ap(scrut17522_2143, d_One_upaths_dapp(((V)1), ((V)&S_459), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_461), ((V)0), ap(scrut17522_2143, d_One_upaths_dapp(((V)2), ((V)&S_462), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_463), ((V)0), ap(scrut17522_2143, d_One_upaths_dapp(((V)0), ((V)&S_462), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_464), ((V)0), ap2(scrut17527_2146, rt_ctor1(0, d_Big_dof_unat(NAT_SMALL(2ull))), rt_ctor1(0, d_Big_dof_unat(NAT_SMALL(2ull))))), CON(rt_ctor3(0, ((V)&S_465), ((V)1), ap2(scrut17527_2146, rt_ctor1(0, d_Big_dof_unat(NAT_SMALL(2ull))), d_One_upaths_dzero())), CON(rt_ctor3(0, ((V)&S_466), ((V)0), d_One_upaths_dlinear(globals_1043_2142, d_One_upaths_dboth(), d_Prim_dnat_uty(), d_One_upaths_dcase(rt_ctor1(0, d_Big_dzero()), ((V)1), rt_ctor1(0, d_Big_dzero()), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_467), ((V)1), d_One_upaths_dlinear(globals_1043_2142, d_One_upaths_dboth(), d_Prim_dnat_uty(), d_One_upaths_dcase(rt_ctor1(0, d_Big_dzero()), ((V)2), rt_ctor1(0, d_Big_dzero()), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_468), ((V)1), d_One_upaths_dlinear(globals_1043_2142, d_One_upaths_dboth(), d_Prim_dnat_uty(), d_One_upaths_dcase(rt_ctor1(0, d_Big_dzero()), ((V)0), rt_ctor1(0, d_Big_dzero()), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_469), ((V)1), d_One_upaths_dlinear(globals_1043_2142, d_One_upaths_dboth(), d_One_upaths_dboth(), d_One_upaths_dcase(rt_ctor1(0, d_Big_dzero()), ((V)1), rt_ctor1(0, d_Big_done()), rt_ctor1(0, d_Big_done())))), CON(rt_ctor3(0, ((V)&S_470), ((V)1), d_One_upaths_dlinear(globals_1043_2142, d_Prim_dnat_uty(), d_Rules_dprod_uty(CON(d_Prim_dnat_uty(), CON(d_Prim_dnat_uty(), NIL))), ap2(scrut17532_2150, rt_ctor1(0, d_Big_dzero()), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_471), ((V)0), ap(scrut17522_2143, rt_ctor4(8, ((V)&S_472), d_Prim_dnat_uty(), rt_ctor1(0, d_Big_dzero()), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_473), ((V)0), ap(scrut17522_2143, rt_ctor4(8, ((V)&S_472), d_Prim_dnat_uty(), rt_ctor1(0, d_Big_dzero()), d_One_upaths_dzero()))), CON(rt_ctor3(0, ((V)&S_474), ((V)1), ap(scrut17522_2143, rt_ctor4(8, ((V)&S_472), d_Prim_dnat_uty(), rt_ctor1(0, d_Big_dzero()), rt_ctor1(0, d_Big_done())))), CON(rt_ctor3(0, ((V)&S_475), ((V)1), d_One_upaths_dlinear(globals_1043_2142, d_Prim_dnat_uty(), d_Rules_dprod_uty(CON(d_Prim_dnat_uty(), CON(d_Prim_dnat_uty(), NIL))), rt_ctor4(8, ((V)&S_472), d_Prim_dnat_uty(), rt_ctor1(0, d_Big_dzero()), ap2(scrut17532_2150, rt_ctor1(0, d_Big_dzero()), rt_ctor1(0, d_Big_dzero()))))), CON(rt_ctor3(0, ((V)&S_476), ((V)1), ap(scrut17522_2143, rt_ctor4(8, ((V)&S_10), d_Prim_dnat_uty(), d_One_upaths_dzero(), rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_477), ((V)0), ap(scrut17522_2143, rt_ctor4(8, ((V)&S_405), scrut17533_2154, scrut17534_2155, ap(scrut17537_2156, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_478), ((V)1), d_One_upaths_dlinear(globals_1043_2142, d_Prim_dnat_uty(), d_Rules_dprod_uty(CON(d_Prim_dnat_uty(), CON(d_Prim_dnat_uty(), NIL))), rt_ctor4(8, ((V)&S_405), scrut17533_2154, scrut17534_2155, ap2(scrut17532_2150, ap(scrut17537_2156, d_Big_dzero()), ap(scrut17537_2156, d_Big_dzero()))))), CON(rt_ctor3(0, ((V)&S_479), ((V)0), d_One_upaths_dlinear(globals_1043_2142, d_One_upaths_dvoid(), d_Prim_dnat_uty(), d_One_upaths_dabsurd(rt_ctor1(0, d_Big_dzero())))), CON(rt_ctor3(0, ((V)&S_480), ((V)0), ap(scrut17522_2143, d_One_upaths_dabsurd(rt_ctor1(10, ((V)&S_481))))), CON(rt_ctor3(0, ((V)&S_482), ((V)0), ap(scrut17522_2143, rt_ctor4(8, ((V)&S_483), d_Prim_dnat_uty(), d_One_upaths_dabsurd(rt_ctor1(10, ((V)&S_481))), d_One_upaths_dzero()))), CON(rt_ctor3(0, ((V)&S_484), ((V)0), ap2(scrut17527_2146, d_One_upaths_dabsurd(rt_ctor1(10, ((V)&S_481))), rt_ctor1(0, d_Big_dof_unat(NAT_SMALL(2ull))))), CON(rt_ctor3(0, ((V)&S_485), ((V)0), ap2(scrut17527_2146, d_One_upaths_dcase(rt_ctor1(0, d_Big_done()), ((V)1), rt_ctor1(0, d_Big_dof_unat(NAT_SMALL(3ull))), rt_ctor1(0, d_Big_dof_unat(NAT_SMALL(3ull)))), rt_ctor1(0, d_Big_dof_unat(NAT_SMALL(2ull))))), CON(rt_ctor3(0, ((V)&S_486), ((V)2), ({ V _r = 0; V m_2159 = d_Check_dinfer_uterm(NONE, globals_1043_2142, rt_ctor1(11, rt_ctor1(1, d_Bignum_dof_uint(d_Big_dneg(d_Big_dof_unat(NAT_SMALL(1ull))))))); switch (tag_of(m_2159)) { case 1: { V _m_2159_a0_2160 = FLD(m_2159, 0); _r = ({ V item17540_2161 = _m_2159_a0_2160; DONE(({ V local17539_2162 = item17540_2161; UNIT; })); }); break; } case 0: { V _m_2159_a0_2163 = FLD(m_2159, 0); _r = ({ V item17541_2164 = _m_2159_a0_2163; FAIL(item17541_2164); }); break; } default: rt_panic("match: no case at tests:941"); } _r; })), NIL))))))))))))))))))))))))))); }); }); }); }); }); });
}
V d_One_upaths_dobserved(V expected_959_2165, V result_960_2166) {
  return ({ V scrut17553_2167 = rt_ctor2(0, expected_959_2165, result_960_2166); ({ V _r = 0; V m_2168 = scrut17553_2167; if ((tag_of(m_2168) == 0)) { V _m_2168_a0_2169 = FLD(m_2168, 0); V _m_2168_a1_2170 = FLD(m_2168, 1); _r = ({ V p17554_2171 = _m_2168_a0_2169; ({ V p17555_2172 = _m_2168_a1_2170; ({ V _r = 0; V m_2173 = p17554_2171; switch (tag_of(m_2173)) { case 0: {  _r = ({ V __2174 = UNIT; ({ V _r = 0; V m_2175 = p17555_2172; switch (tag_of(m_2175)) { case 1: { V _m_2175_a0_2176 = FLD(m_2175, 0); _r = ({ V p17556_2177 = _m_2175_a0_2176; TRUE_V; }); break; } case 0: { V _m_2175_a0_2178 = FLD(m_2175, 0); _r = ({ V p17557_2179 = _m_2175_a0_2178; FALSE_V; }); break; } default: rt_panic("match: no case at tests:945"); } _r; }); }); break; } case 1: {  _r = ({ V __2180 = UNIT; ({ V _r = 0; V m_2181 = p17555_2172; switch (tag_of(m_2181)) { case 1: { V _m_2181_a0_2182 = FLD(m_2181, 0); _r = ({ V p17558_2183 = _m_2181_a0_2182; FALSE_V; }); break; } case 0: { V _m_2181_a0_2184 = FLD(m_2181, 0); _r = ({ V p17559_2185 = _m_2181_a0_2184; ((V)str_starts_with(d_Error_dto_ustring(p17559_2185), ((V)&S_487))); }); break; } default: rt_panic("match: no case at tests:945"); } _r; }); }); break; } case 2: {  _r = ({ V __2186 = UNIT; ({ V _r = 0; V m_2187 = p17555_2172; switch (tag_of(m_2187)) { case 1: { V _m_2187_a0_2188 = FLD(m_2187, 0); _r = ({ V p17560_2189 = _m_2187_a0_2188; FALSE_V; }); break; } case 0: { V _m_2187_a0_2190 = FLD(m_2187, 0); _r = ({ V p17561_2191 = _m_2187_a0_2190; d_NativeString_dequal(d_Error_dto_ustring(p17561_2191), ((V)&S_488)); }); break; } default: rt_panic("match: no case at tests:945"); } _r; }); }); break; } default: rt_panic("match: no case at tests:945"); } _r; }); }); }); } else rt_panic("match: no case at tests:945"); _r; }); });
}
V d_One_upaths_drun(V param_1208_2192) {
  return ({ V scrut17496_2193 = param_1208_2192; ({ V _r = 0; V m_2194 = d_One_upaths_dpostulate(d_Global_dinitial(), ((V)&S_459), d_Rules_darrow(((V)2), ((V)&S_452), d_Prim_dnat_uty(), d_Prim_dnat_uty())); switch (tag_of(m_2194)) { case 1: { V _m_2194_a0_2195 = FLD(m_2194, 0); _r = ({ V item17577_2196 = _m_2194_a0_2195; ({ V local17504_2197 = item17577_2196; ({ V _r = 0; V m_2198 = d_One_upaths_dpostulate(local17504_2197, ((V)&S_462), d_Rules_darrow(((V)1), ((V)&S_452), d_Prim_dnat_uty(), d_Prim_dnat_uty())); switch (tag_of(m_2198)) { case 1: { V _m_2198_a0_2199 = FLD(m_2198, 0); _r = ({ V item17575_2200 = _m_2198_a0_2199; ({ V local17507_2201 = item17575_2200; ({ V _r = 0; V m_2202 = d_One_upaths_dpostulate(local17507_2201, ((V)&S_457), d_Rules_darrow(((V)0), ((V)&S_452), d_Prim_dnat_uty(), d_Prim_dnat_uty())); switch (tag_of(m_2202)) { case 1: { V _m_2202_a0_2203 = FLD(m_2202, 0); _r = ({ V item17573_2204 = _m_2202_a0_2203; ({ V local17510_2205 = item17573_2204; ({ V _r = 0; V m_2206 = d_One_upaths_dpostulate(local17510_2205, ((V)&S_481), d_One_upaths_dvoid()); switch (tag_of(m_2206)) { case 1: { V _m_2206_a0_2207 = FLD(m_2206, 0); _r = ({ V item17571_2208 = _m_2206_a0_2207; ({ V local17513_2209 = item17571_2208; ({ V scrut17544_2210 = d_One_upaths_dcases(local17513_2209); ({ V scrut17568_2211 = d_SeqList_dfold(clo_new(lam_2232, 2, 0), scrut17544_2210, d_Big_dzero()); ({ V discard17569_2233 = UNIT; DONE(d_Big_dis_ueq(scrut17568_2211, d_Big_dof_unat(list_length(scrut17544_2210)))); }); }); }); }); }); break; } case 0: { V _m_2206_a0_2234 = FLD(m_2206, 0); _r = ({ V item17572_2235 = _m_2206_a0_2234; FAIL(item17572_2235); }); break; } default: rt_panic("match: no case at tests:949"); } _r; }); }); }); break; } case 0: { V _m_2202_a0_2236 = FLD(m_2202, 0); _r = ({ V item17574_2237 = _m_2202_a0_2236; FAIL(item17574_2237); }); break; } default: rt_panic("match: no case at tests:949"); } _r; }); }); }); break; } case 0: { V _m_2198_a0_2238 = FLD(m_2198, 0); _r = ({ V item17576_2239 = _m_2198_a0_2238; FAIL(item17576_2239); }); break; } default: rt_panic("match: no case at tests:949"); } _r; }); }); }); break; } case 0: { V _m_2194_a0_2240 = FLD(m_2194, 0); _r = ({ V item17578_2241 = _m_2194_a0_2240; FAIL(item17578_2241); }); break; } default: rt_panic("match: no case at tests:949"); } _r; }); });
}
V d_Export_umu_dquoted(V s_317_2242) {
  return ((d_NativeString_dall(clo_new(lam_2244, 1, 0), s_317_2242)) != FALSE_V ? DONE(str_concat(CON(d_NativeString_dquoted(s_317_2242), NIL))) : FAIL(((V)&S_490)));
}
V d_Export_umu_dnatural(V n_437_2245) {
  return ((d_Big_dis_ule(d_Big_dzero(), n_437_2245)) != FALSE_V ? DONE(d_Big_dshow(n_437_2245)) : FAIL(((V)&S_491)));
}
V d_Export_umu_dquantity(V q_467_2246) {
  return ({ V scrut17632_2247 = q_467_2246; ({ V _r = 0; V m_2248 = scrut17632_2247; switch (tag_of(m_2248)) { case 0: {  _r = ({ V __2249 = UNIT; ((V)&S_492); }); break; } case 1: {  _r = ({ V __2250 = UNIT; ((V)&S_493); }); break; } case 2: {  _r = ({ V __2251 = UNIT; ((V)&S_494); }); break; } default: rt_panic("match: no case at tests:967"); } _r; }); });
}
V d_Export_umu_dsequence(V f_496_2252, V xs_497_2253) {
  return ({ V scrut17652_2254 = xs_497_2253; ({ V _r = 0; V m_2255 = scrut17652_2254; if (((m_2255) == NIL)) {  _r = ({ V __2256 = UNIT; DONE(NIL); }); } else if (((m_2255) != NIL)) { V _m_2255_a0_2257 = FLD(m_2255, 0); V _m_2255_a1_2258 = FLD(m_2255, 1); _r = ({ V p17653_2259 = _m_2255_a0_2257; ({ V p17654_2260 = _m_2255_a1_2258; ({ V _r = 0; V m_2261 = ap(f_496_2252, p17653_2259); switch (tag_of(m_2261)) { case 1: { V _m_2261_a0_2262 = FLD(m_2261, 0); _r = ({ V item17663_2263 = _m_2261_a0_2262; ({ V local17657_2264 = item17663_2263; ({ V _r = 0; V m_2265 = d_Export_umu_dsequence(f_496_2252, p17654_2260); switch (tag_of(m_2265)) { case 1: { V _m_2265_a0_2266 = FLD(m_2265, 0); _r = ({ V item17661_2267 = _m_2265_a0_2266; ({ V local17660_2268 = item17661_2267; DONE(CON(local17657_2264, local17660_2268)); }); }); break; } case 0: { V _m_2265_a0_2269 = FLD(m_2265, 0); _r = ({ V item17662_2270 = _m_2265_a0_2269; FAIL(item17662_2270); }); break; } default: rt_panic("match: no case at tests:971"); } _r; }); }); }); break; } case 0: { V _m_2261_a0_2271 = FLD(m_2261, 0); _r = ({ V item17664_2272 = _m_2261_a0_2271; FAIL(item17664_2272); }); break; } default: rt_panic("match: no case at tests:971"); } _r; }); }); }); } else rt_panic("match: no case at tests:971"); _r; }); });
}
V d_Export_umu_dlist(V f_504_2273, V xs_505_2274) {
  return ({ V _r = 0; V m_2275 = d_Export_umu_dsequence(f_504_2273, xs_505_2274); switch (tag_of(m_2275)) { case 1: { V _m_2275_a0_2276 = FLD(m_2275, 0); _r = ({ V item17665_2277 = _m_2275_a0_2276; DONE(({ V local17651_2278 = item17665_2277; str_append(((V)&S_163), str_append(str_join(local17651_2278, ((V)&S_70)), ((V)&S_165))); })); }); break; } case 0: { V _m_2275_a0_2279 = FLD(m_2275, 0); _r = ({ V item17666_2280 = _m_2275_a0_2279; FAIL(item17666_2280); }); break; } default: rt_panic("match: no case at tests:974"); } _r; });
}
V d_Export_umu_dshape(V s_804_2281) {
  return ({ V scrut17622_2282 = s_804_2281; ({ V _r = 0; V m_2283 = scrut17622_2282; switch (tag_of(m_2283)) { case 0: { V _m_2283_a0_2284 = FLD(m_2283, 0); V _m_2283_a1_2285 = FLD(m_2283, 1); V _m_2283_a2_2286 = FLD(m_2283, 2); _r = ({ V p17623_2287 = _m_2283_a0_2284; ({ V p17624_2288 = _m_2283_a1_2285; ({ V p17625_2289 = _m_2283_a2_2286; ({ V _r = 0; V m_2290 = d_Export_umu_dquoted(p17624_2288); switch (tag_of(m_2290)) { case 1: { V _m_2290_a0_2291 = FLD(m_2290, 0); _r = ({ V item17635_2292 = _m_2290_a0_2291; ({ V local17628_2293 = item17635_2292; ({ V _r = 0; V m_2294 = d_Export_umu_dterm(p17625_2289); switch (tag_of(m_2294)) { case 1: { V _m_2294_a0_2295 = FLD(m_2294, 0); _r = ({ V item17633_2296 = _m_2294_a0_2295; ({ V local17631_2297 = item17633_2296; DONE(str_append(((V)&S_495), str_append(d_Export_umu_dquantity(p17623_2287), str_append(((V)&S_61), str_append(local17628_2293, str_append(((V)&S_61), str_append(local17631_2297, ((V)&S_59)))))))); }); }); break; } case 0: { V _m_2294_a0_2298 = FLD(m_2294, 0); _r = ({ V item17634_2299 = _m_2294_a0_2298; FAIL(item17634_2299); }); break; } default: rt_panic("match: no case at tests:978"); } _r; }); }); }); break; } case 0: { V _m_2290_a0_2300 = FLD(m_2290, 0); _r = ({ V item17636_2301 = _m_2290_a0_2300; FAIL(item17636_2301); }); break; } default: rt_panic("match: no case at tests:978"); } _r; }); }); }); }); break; } case 1: { V _m_2283_a0_2302 = FLD(m_2283, 0); _r = ({ V p17637_2303 = _m_2283_a0_2302; ({ V _r = 0; V m_2304 = d_Export_umu_dnatural(p17637_2303); switch (tag_of(m_2304)) { case 1: { V _m_2304_a0_2305 = FLD(m_2304, 0); _r = ({ V item17640_2306 = _m_2304_a0_2305; DONE(({ V local17639_2307 = item17640_2306; str_append(((V)&S_496), str_append(local17639_2307, ((V)&S_59))); })); }); break; } case 0: { V _m_2304_a0_2308 = FLD(m_2304, 0); _r = ({ V item17641_2309 = _m_2304_a0_2308; FAIL(item17641_2309); }); break; } default: rt_panic("match: no case at tests:978"); } _r; }); }); break; } case 2: { V _m_2283_a0_2310 = FLD(m_2283, 0); V _m_2283_a1_2311 = FLD(m_2283, 1); _r = ({ V p17642_2312 = _m_2283_a0_2310; ({ V p17643_2313 = _m_2283_a1_2311; FAIL(((V)&S_497)); }); }); break; } case 3: { V _m_2283_a0_2314 = FLD(m_2283, 0); V _m_2283_a1_2315 = FLD(m_2283, 1); _r = ({ V p17644_2316 = _m_2283_a0_2314; ({ V p17645_2317 = _m_2283_a1_2315; ({ V _r = 0; V m_2318 = d_Export_umu_dquoted(p17644_2316); switch (tag_of(m_2318)) { case 1: { V _m_2318_a0_2319 = FLD(m_2318, 0); _r = ({ V item17671_2320 = _m_2318_a0_2319; ({ V local17648_2321 = item17671_2320; ({ V _r = 0; V m_2322 = d_Export_umu_dlist(clo_new(w_Export_umu_dterm, 1, 0), p17645_2317); switch (tag_of(m_2322)) { case 1: { V _m_2322_a0_2323 = FLD(m_2322, 0); _r = ({ V item17669_2324 = _m_2322_a0_2323; ({ V local17668_2325 = item17669_2324; DONE(str_append(((V)&S_498), str_append(local17648_2321, str_append(((V)&S_61), str_append(local17668_2325, ((V)&S_59)))))); }); }); break; } case 0: { V _m_2322_a0_2326 = FLD(m_2322, 0); _r = ({ V item17670_2327 = _m_2322_a0_2326; FAIL(item17670_2327); }); break; } default: rt_panic("match: no case at tests:978"); } _r; }); }); }); break; } case 0: { V _m_2318_a0_2328 = FLD(m_2318, 0); _r = ({ V item17672_2329 = _m_2318_a0_2328; FAIL(item17672_2329); }); break; } default: rt_panic("match: no case at tests:978"); } _r; }); }); }); break; } case 4: { V _m_2283_a0_2330 = FLD(m_2283, 0); V _m_2283_a1_2331 = FLD(m_2283, 1); _r = ({ V p17673_2332 = _m_2283_a0_2330; ({ V p17674_2333 = _m_2283_a1_2331; FAIL(((V)&S_499)); }); }); break; } default: rt_panic("match: no case at tests:978"); } _r; }); });
}
V d_Export_umu_dformer(V tag_799_2334, V s_800_2335, V body_801_2336) {
  return ({ V _r = 0; V m_2337 = d_Export_umu_dshape(s_800_2335); switch (tag_of(m_2337)) { case 1: { V _m_2337_a0_2338 = FLD(m_2337, 0); _r = ({ V item17682_2339 = _m_2337_a0_2338; ({ V local17676_2340 = item17682_2339; ({ V _r = 0; V m_2341 = d_Export_umu_dterm(body_801_2336); switch (tag_of(m_2341)) { case 1: { V _m_2341_a0_2342 = FLD(m_2341, 0); _r = ({ V item17680_2343 = _m_2341_a0_2342; ({ V local17679_2344 = item17680_2343; DONE(str_append(((V)&S_500), str_append(tag_799_2334, str_append(((V)&S_61), str_append(local17676_2340, str_append(((V)&S_61), str_append(local17679_2344, ((V)&S_59)))))))); }); }); break; } case 0: { V _m_2341_a0_2345 = FLD(m_2341, 0); _r = ({ V item17681_2346 = _m_2341_a0_2345; FAIL(item17681_2346); }); break; } default: rt_panic("match: no case at tests:981"); } _r; }); }); }); break; } case 0: { V _m_2337_a0_2347 = FLD(m_2337, 0); _r = ({ V item17683_2348 = _m_2337_a0_2347; FAIL(item17683_2348); }); break; } default: rt_panic("match: no case at tests:981"); } _r; });
}
V d_Export_umu_daddress(V a_816_2349) {
  return ({ V scrut17693_2350 = a_816_2349; ({ V _r = 0; V m_2351 = scrut17693_2350; switch (tag_of(m_2351)) { case 0: { V _m_2351_a0_2352 = FLD(m_2351, 0); V _m_2351_a1_2353 = FLD(m_2351, 1); _r = ({ V p17694_2354 = _m_2351_a0_2352; ({ V p17695_2355 = _m_2351_a1_2353; ({ V _r = 0; V m_2356 = d_Export_umu_dterm(p17695_2355); switch (tag_of(m_2356)) { case 1: { V _m_2356_a0_2357 = FLD(m_2356, 0); _r = ({ V item17699_2358 = _m_2356_a0_2357; ({ V local17698_2359 = item17699_2358; DONE(str_append(((V)&S_501), str_append(d_Export_umu_dquantity(p17694_2354), str_append(((V)&S_61), str_append(local17698_2359, ((V)&S_59)))))); }); }); break; } case 0: { V _m_2356_a0_2360 = FLD(m_2356, 0); _r = ({ V item17700_2361 = _m_2356_a0_2360; FAIL(item17700_2361); }); break; } default: rt_panic("match: no case at tests:985"); } _r; }); }); }); break; } case 1: { V _m_2351_a0_2362 = FLD(m_2351, 0); _r = ({ V p17701_2363 = _m_2351_a0_2362; ({ V _r = 0; V m_2364 = d_Export_umu_dnatural(p17701_2363); switch (tag_of(m_2364)) { case 1: { V _m_2364_a0_2365 = FLD(m_2364, 0); _r = ({ V item17704_2366 = _m_2364_a0_2365; DONE(({ V local17703_2367 = item17704_2366; str_append(((V)&S_502), str_append(local17703_2367, ((V)&S_59))); })); }); break; } case 0: { V _m_2364_a0_2368 = FLD(m_2364, 0); _r = ({ V item17705_2369 = _m_2364_a0_2368; FAIL(item17705_2369); }); break; } default: rt_panic("match: no case at tests:985"); } _r; }); }); break; } case 2: { V _m_2351_a0_2370 = FLD(m_2351, 0); _r = ({ V p17706_2371 = _m_2351_a0_2370; ({ V _r = 0; V m_2372 = d_Export_umu_dquoted(p17706_2371); switch (tag_of(m_2372)) { case 1: { V _m_2372_a0_2373 = FLD(m_2372, 0); _r = ({ V item17709_2374 = _m_2372_a0_2373; DONE(({ V local17708_2375 = item17709_2374; str_append(((V)&S_503), str_append(local17708_2375, ((V)&S_59))); })); }); break; } case 0: { V _m_2372_a0_2376 = FLD(m_2372, 0); _r = ({ V item17710_2377 = _m_2372_a0_2376; FAIL(item17710_2377); }); break; } default: rt_panic("match: no case at tests:985"); } _r; }); }); break; } default: rt_panic("match: no case at tests:985"); } _r; }); });
}
V d_Export_umu_doptional(V f_509_2378, V x_510_2379) {
  return ({ V _r = 0; V m_2380 = x_510_2379; if (((m_2380) == NONE)) {  _r = ({ V __2381 = UNIT; DONE(((V)&S_504)); }); } else if (((m_2380) != NONE)) { V _m_2380_a0_2382 = FLD(m_2380, 0); _r = ({ V value_2383 = _m_2380_a0_2382; ({ V local17732_2384 = value_2383; ({ V _r = 0; V m_2385 = ap(f_509_2378, local17732_2384); switch (tag_of(m_2385)) { case 1: { V _m_2385_a0_2386 = FLD(m_2385, 0); _r = ({ V item17735_2387 = _m_2385_a0_2386; DONE(({ V local17734_2388 = item17735_2387; str_append(((V)&S_505), str_append(local17734_2388, ((V)&S_59))); })); }); break; } case 0: { V _m_2385_a0_2389 = FLD(m_2385, 0); _r = ({ V item17736_2390 = _m_2385_a0_2389; FAIL(item17736_2390); }); break; } default: rt_panic("match: no case at tests:988"); } _r; }); }); }); } else rt_panic("match: no case at tests:988"); _r; });
}
V d_Export_umu_dmotive(V m_832_2391) {
  return ({ V _r = 0; V m_2392 = d_Export_umu_doptional(clo_new(w_Export_umu_dquoted, 1, 0), d_Get_dTerm_dMotive_dm_uind(m_832_2391)); switch (tag_of(m_2392)) { case 1: { V _m_2392_a0_2393 = FLD(m_2392, 0); _r = ({ V item17754_2394 = _m_2392_a0_2393; ({ V local17738_2395 = item17754_2394; ({ V _r = 0; V m_2396 = d_Export_umu_dlist(clo_new(w_Export_umu_dquoted, 1, 0), d_Get_dTerm_dMotive_dm_uidx(m_832_2391)); switch (tag_of(m_2396)) { case 1: { V _m_2396_a0_2397 = FLD(m_2396, 0); _r = ({ V item17752_2398 = _m_2396_a0_2397; ({ V local17741_2399 = item17752_2398; ({ V _r = 0; V m_2400 = d_Export_umu_dquoted(d_Get_dTerm_dMotive_dm_uself(m_832_2391)); switch (tag_of(m_2400)) { case 1: { V _m_2400_a0_2401 = FLD(m_2400, 0); _r = ({ V item17750_2402 = _m_2400_a0_2401; ({ V local17744_2403 = item17750_2402; ({ V _r = 0; V m_2404 = d_Export_umu_dterm(d_Get_dTerm_dMotive_dm_ubody(m_832_2391)); switch (tag_of(m_2404)) { case 1: { V _m_2404_a0_2405 = FLD(m_2404, 0); _r = ({ V item17748_2406 = _m_2404_a0_2405; ({ V local17747_2407 = item17748_2406; DONE(str_append(((V)&S_506), str_append(local17738_2395, str_append(((V)&S_61), str_append(local17741_2399, str_append(((V)&S_61), str_append(local17744_2403, str_append(((V)&S_61), str_append(local17747_2407, ((V)&S_59)))))))))); }); }); break; } case 0: { V _m_2404_a0_2408 = FLD(m_2404, 0); _r = ({ V item17749_2409 = _m_2404_a0_2408; FAIL(item17749_2409); }); break; } default: rt_panic("match: no case at tests:991"); } _r; }); }); }); break; } case 0: { V _m_2400_a0_2410 = FLD(m_2400, 0); _r = ({ V item17751_2411 = _m_2400_a0_2410; FAIL(item17751_2411); }); break; } default: rt_panic("match: no case at tests:991"); } _r; }); }); }); break; } case 0: { V _m_2396_a0_2412 = FLD(m_2396, 0); _r = ({ V item17753_2413 = _m_2396_a0_2412; FAIL(item17753_2413); }); break; } default: rt_panic("match: no case at tests:991"); } _r; }); }); }); break; } case 0: { V _m_2392_a0_2414 = FLD(m_2392, 0); _r = ({ V item17755_2415 = _m_2392_a0_2414; FAIL(item17755_2415); }); break; } default: rt_panic("match: no case at tests:991"); } _r; });
}
V d_Export_umu_dbinder(V param_535_2416) {
  return ({ V scrut17767_2417 = param_535_2416; ({ V _r = 0; V m_2418 = scrut17767_2417; if ((tag_of(m_2418) == 0)) { V _m_2418_a0_2419 = FLD(m_2418, 0); V _m_2418_a1_2420 = FLD(m_2418, 1); _r = ({ V p17768_2421 = _m_2418_a0_2419; ({ V p17769_2422 = _m_2418_a1_2420; ({ V _r = 0; V m_2423 = d_Export_umu_dquoted(p17769_2422); switch (tag_of(m_2423)) { case 1: { V _m_2423_a0_2424 = FLD(m_2423, 0); _r = ({ V item17773_2425 = _m_2423_a0_2424; ({ V local17772_2426 = item17773_2425; DONE(str_append(((V)&S_57), str_append(d_Export_umu_dquantity(p17768_2421), str_append(((V)&S_70), str_append(local17772_2426, ((V)&S_59)))))); }); }); break; } case 0: { V _m_2423_a0_2427 = FLD(m_2423, 0); _r = ({ V item17774_2428 = _m_2423_a0_2427; FAIL(item17774_2428); }); break; } default: rt_panic("match: no case at tests:995"); } _r; }); }); }); } else rt_panic("match: no case at tests:995"); _r; }); });
}
V d_Export_umu_dleg(V l_824_2429) {
  return ({ V _r = 0; V m_2430 = d_Export_umu_dlist(clo_new(w_Export_umu_dbinder, 1, 0), d_Get_dTerm_dLeg_dl_ubinders(l_824_2429)); switch (tag_of(m_2430)) { case 1: { V _m_2430_a0_2431 = FLD(m_2430, 0); _r = ({ V item17782_2432 = _m_2430_a0_2431; ({ V local17776_2433 = item17782_2432; ({ V _r = 0; V m_2434 = d_Export_umu_dterm(d_Get_dTerm_dLeg_dl_ubody(l_824_2429)); switch (tag_of(m_2434)) { case 1: { V _m_2434_a0_2435 = FLD(m_2434, 0); _r = ({ V item17780_2436 = _m_2434_a0_2435; ({ V local17779_2437 = item17780_2436; DONE(str_append(((V)&S_506), str_append(local17776_2433, str_append(((V)&S_61), str_append(local17779_2437, ((V)&S_59)))))); }); }); break; } case 0: { V _m_2434_a0_2438 = FLD(m_2434, 0); _r = ({ V item17781_2439 = _m_2434_a0_2438; FAIL(item17781_2439); }); break; } default: rt_panic("match: no case at tests:998"); } _r; }); }); }); break; } case 0: { V _m_2430_a0_2440 = FLD(m_2430, 0); _r = ({ V item17783_2441 = _m_2430_a0_2440; FAIL(item17783_2441); }); break; } default: rt_panic("match: no case at tests:998"); } _r; });
}
V d_Export_umu_dbranch(V param_831_2442) {
  return ({ V scrut17759_2443 = param_831_2442; ({ V _r = 0; V m_2444 = scrut17759_2443; if ((tag_of(m_2444) == 0)) { V _m_2444_a0_2445 = FLD(m_2444, 0); V _m_2444_a1_2446 = FLD(m_2444, 1); _r = ({ V p17760_2447 = _m_2444_a0_2445; ({ V p17761_2448 = _m_2444_a1_2446; ({ V _r = 0; V m_2449 = d_Export_umu_daddress(p17760_2447); switch (tag_of(m_2449)) { case 1: { V _m_2449_a0_2450 = FLD(m_2449, 0); _r = ({ V item17788_2451 = _m_2449_a0_2450; ({ V local17764_2452 = item17788_2451; ({ V _r = 0; V m_2453 = d_Export_umu_dleg(p17761_2448); switch (tag_of(m_2453)) { case 1: { V _m_2453_a0_2454 = FLD(m_2453, 0); _r = ({ V item17786_2455 = _m_2453_a0_2454; ({ V local17785_2456 = item17786_2455; DONE(str_append(((V)&S_57), str_append(local17764_2452, str_append(((V)&S_70), str_append(local17785_2456, ((V)&S_59)))))); }); }); break; } case 0: { V _m_2453_a0_2457 = FLD(m_2453, 0); _r = ({ V item17787_2458 = _m_2453_a0_2457; FAIL(item17787_2458); }); break; } default: rt_panic("match: no case at tests:1002"); } _r; }); }); }); break; } case 0: { V _m_2449_a0_2459 = FLD(m_2449, 0); _r = ({ V item17789_2460 = _m_2449_a0_2459; FAIL(item17789_2460); }); break; } default: rt_panic("match: no case at tests:1002"); } _r; }); }); }); } else rt_panic("match: no case at tests:1002"); _r; }); });
}
V d_Export_umu_dterm(V t_560_2461) {
  return ({ V scrut17612_2462 = t_560_2461; ({ V _r = 0; V m_2463 = scrut17612_2462; switch (tag_of(m_2463)) { case 0: { V _m_2463_a0_2464 = FLD(m_2463, 0); _r = ({ V p17613_2465 = _m_2463_a0_2464; ({ V _r = 0; V m_2466 = d_Export_umu_dnatural(p17613_2465); switch (tag_of(m_2466)) { case 1: { V _m_2466_a0_2467 = FLD(m_2466, 0); _r = ({ V item17616_2468 = _m_2466_a0_2467; DONE(({ V local17615_2469 = item17616_2468; str_append(((V)&S_507), str_append(local17615_2469, ((V)&S_59))); })); }); break; } case 0: { V _m_2466_a0_2470 = FLD(m_2466, 0); _r = ({ V item17617_2471 = _m_2466_a0_2470; FAIL(item17617_2471); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); break; } case 1: { V _m_2463_a0_2472 = FLD(m_2463, 0); _r = ({ V p17618_2473 = _m_2463_a0_2472; DONE(str_append(((V)&S_508), str_append(d_Level_dto_ustring(p17618_2473), ((V)&S_59)))); }); break; } case 2: { V _m_2463_a0_2474 = FLD(m_2463, 0); V _m_2463_a1_2475 = FLD(m_2463, 1); _r = ({ V p17619_2476 = _m_2463_a0_2474; ({ V p17620_2477 = _m_2463_a1_2475; d_Export_umu_dformer(((V)&S_509), p17619_2476, p17620_2477); }); }); break; } case 3: { V _m_2463_a0_2478 = FLD(m_2463, 0); V _m_2463_a1_2479 = FLD(m_2463, 1); _r = ({ V p17684_2480 = _m_2463_a0_2478; ({ V p17685_2481 = _m_2463_a1_2479; d_Export_umu_dformer(((V)&S_510), p17684_2480, p17685_2481); }); }); break; } case 4: { V _m_2463_a0_2482 = FLD(m_2463, 0); V _m_2463_a1_2483 = FLD(m_2463, 1); V _m_2463_a2_2484 = FLD(m_2463, 2); _r = ({ V p17686_2485 = _m_2463_a0_2482; ({ V p17687_2486 = _m_2463_a1_2483; ({ V p17688_2487 = _m_2463_a2_2484; ({ V _r = 0; V m_2488 = d_Export_umu_dshape(p17686_2485); switch (tag_of(m_2488)) { case 1: { V _m_2488_a0_2489 = FLD(m_2488, 0); _r = ({ V item17720_2490 = _m_2488_a0_2489; ({ V local17691_2491 = item17720_2490; ({ V _r = 0; V m_2492 = d_Export_umu_daddress(p17687_2486); switch (tag_of(m_2492)) { case 1: { V _m_2492_a0_2493 = FLD(m_2492, 0); _r = ({ V item17718_2494 = _m_2492_a0_2493; ({ V local17712_2495 = item17718_2494; ({ V _r = 0; V m_2496 = d_Export_umu_dlist(clo_new(w_Export_umu_dterm, 1, 0), p17688_2487); switch (tag_of(m_2496)) { case 1: { V _m_2496_a0_2497 = FLD(m_2496, 0); _r = ({ V item17716_2498 = _m_2496_a0_2497; ({ V local17715_2499 = item17716_2498; DONE(str_append(((V)&S_511), str_append(local17691_2491, str_append(((V)&S_61), str_append(local17712_2495, str_append(((V)&S_61), str_append(local17715_2499, ((V)&S_59)))))))); }); }); break; } case 0: { V _m_2496_a0_2500 = FLD(m_2496, 0); _r = ({ V item17717_2501 = _m_2496_a0_2500; FAIL(item17717_2501); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2492_a0_2502 = FLD(m_2492, 0); _r = ({ V item17719_2503 = _m_2492_a0_2502; FAIL(item17719_2503); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2488_a0_2504 = FLD(m_2488, 0); _r = ({ V item17721_2505 = _m_2488_a0_2504; FAIL(item17721_2505); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); }); break; } case 5: { V _m_2463_a0_2506 = FLD(m_2463, 0); _r = ({ V p17722_2507 = _m_2463_a0_2506; ({ V _r = 0; V m_2508 = d_Export_umu_dshape(d_Get_dTerm_dElim_de_ushape(p17722_2507)); switch (tag_of(m_2508)) { case 1: { V _m_2508_a0_2509 = FLD(m_2508, 0); _r = ({ V item17798_2510 = _m_2508_a0_2509; ({ V local17725_2511 = item17798_2510; ({ V _r = 0; V m_2512 = d_Export_umu_dterm(d_Get_dTerm_dElim_de_uscrut(p17722_2507)); switch (tag_of(m_2512)) { case 1: { V _m_2512_a0_2513 = FLD(m_2512, 0); _r = ({ V item17796_2514 = _m_2512_a0_2513; ({ V local17728_2515 = item17796_2514; ({ V _r = 0; V m_2516 = d_Export_umu_doptional(clo_new(w_Export_umu_dmotive, 1, 0), d_Get_dTerm_dElim_de_umotive(p17722_2507)); switch (tag_of(m_2516)) { case 1: { V _m_2516_a0_2517 = FLD(m_2516, 0); _r = ({ V item17794_2518 = _m_2516_a0_2517; ({ V local17757_2519 = item17794_2518; ({ V _r = 0; V m_2520 = d_Export_umu_dlist(clo_new(w_Export_umu_dbranch, 1, 0), d_Get_dTerm_dElim_de_ubranches(p17722_2507)); switch (tag_of(m_2520)) { case 1: { V _m_2520_a0_2521 = FLD(m_2520, 0); _r = ({ V item17792_2522 = _m_2520_a0_2521; ({ V local17791_2523 = item17792_2522; DONE(str_append(((V)&S_512), str_append(local17725_2511, str_append(((V)&S_61), str_append(local17728_2515, str_append(((V)&S_61), str_append(d_Export_umu_dquantity(d_Get_dTerm_dElim_de_uscrut_uq(p17722_2507)), str_append(((V)&S_61), str_append(local17757_2519, str_append(((V)&S_61), str_append(local17791_2523, ((V)&S_59)))))))))))); }); }); break; } case 0: { V _m_2520_a0_2524 = FLD(m_2520, 0); _r = ({ V item17793_2525 = _m_2520_a0_2524; FAIL(item17793_2525); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2516_a0_2526 = FLD(m_2516, 0); _r = ({ V item17795_2527 = _m_2516_a0_2526; FAIL(item17795_2527); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2512_a0_2528 = FLD(m_2512, 0); _r = ({ V item17797_2529 = _m_2512_a0_2528; FAIL(item17797_2529); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2508_a0_2530 = FLD(m_2508, 0); _r = ({ V item17799_2531 = _m_2508_a0_2530; FAIL(item17799_2531); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); break; } case 6: { V _m_2463_a0_2532 = FLD(m_2463, 0); V _m_2463_a1_2533 = FLD(m_2463, 1); _r = ({ V p17801_2534 = _m_2463_a0_2532; ({ V p17802_2535 = _m_2463_a1_2533; ({ V _r = 0; V m_2536 = d_Export_umu_dshape(p17801_2534); switch (tag_of(m_2536)) { case 1: { V _m_2536_a0_2537 = FLD(m_2536, 0); _r = ({ V item17811_2538 = _m_2536_a0_2537; ({ V local17805_2539 = item17811_2538; ({ V _r = 0; V m_2540 = d_Export_umu_dlist(clo_new(w_Export_umu_dleg, 1, 0), p17802_2535); switch (tag_of(m_2540)) { case 1: { V _m_2540_a0_2541 = FLD(m_2540, 0); _r = ({ V item17809_2542 = _m_2540_a0_2541; ({ V local17808_2543 = item17809_2542; DONE(str_append(((V)&S_513), str_append(local17805_2539, str_append(((V)&S_61), str_append(local17808_2543, ((V)&S_59)))))); }); }); break; } case 0: { V _m_2540_a0_2544 = FLD(m_2540, 0); _r = ({ V item17810_2545 = _m_2540_a0_2544; FAIL(item17810_2545); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2536_a0_2546 = FLD(m_2536, 0); _r = ({ V item17812_2547 = _m_2536_a0_2546; FAIL(item17812_2547); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 7: { V _m_2463_a0_2548 = FLD(m_2463, 0); V _m_2463_a1_2549 = FLD(m_2463, 1); V _m_2463_a2_2550 = FLD(m_2463, 2); _r = ({ V p17813_2551 = _m_2463_a0_2548; ({ V p17814_2552 = _m_2463_a1_2549; ({ V p17815_2553 = _m_2463_a2_2550; ({ V _r = 0; V m_2554 = d_Export_umu_dshape(p17813_2551); switch (tag_of(m_2554)) { case 1: { V _m_2554_a0_2555 = FLD(m_2554, 0); _r = ({ V item17829_2556 = _m_2554_a0_2555; ({ V local17818_2557 = item17829_2556; ({ V _r = 0; V m_2558 = d_Export_umu_daddress(p17814_2552); switch (tag_of(m_2558)) { case 1: { V _m_2558_a0_2559 = FLD(m_2558, 0); _r = ({ V item17827_2560 = _m_2558_a0_2559; ({ V local17821_2561 = item17827_2560; ({ V _r = 0; V m_2562 = d_Export_umu_dterm(p17815_2553); switch (tag_of(m_2562)) { case 1: { V _m_2562_a0_2563 = FLD(m_2562, 0); _r = ({ V item17825_2564 = _m_2562_a0_2563; ({ V local17824_2565 = item17825_2564; DONE(str_append(((V)&S_514), str_append(local17818_2557, str_append(((V)&S_61), str_append(local17821_2561, str_append(((V)&S_61), str_append(local17824_2565, ((V)&S_59)))))))); }); }); break; } case 0: { V _m_2562_a0_2566 = FLD(m_2562, 0); _r = ({ V item17826_2567 = _m_2562_a0_2566; FAIL(item17826_2567); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2558_a0_2568 = FLD(m_2558, 0); _r = ({ V item17828_2569 = _m_2558_a0_2568; FAIL(item17828_2569); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2554_a0_2570 = FLD(m_2554, 0); _r = ({ V item17830_2571 = _m_2554_a0_2570; FAIL(item17830_2571); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); }); break; } case 8: { V _m_2463_a0_2572 = FLD(m_2463, 0); V _m_2463_a1_2573 = FLD(m_2463, 1); V _m_2463_a2_2574 = FLD(m_2463, 2); V _m_2463_a3_2575 = FLD(m_2463, 3); _r = ({ V p17831_2576 = _m_2463_a0_2572; ({ V p17832_2577 = _m_2463_a1_2573; ({ V p17833_2578 = _m_2463_a2_2574; ({ V p17834_2579 = _m_2463_a3_2575; ({ V _r = 0; V m_2580 = d_Export_umu_dquoted(p17831_2576); switch (tag_of(m_2580)) { case 1: { V _m_2580_a0_2581 = FLD(m_2580, 0); _r = ({ V item17853_2582 = _m_2580_a0_2581; ({ V local17837_2583 = item17853_2582; ({ V _r = 0; V m_2584 = d_Export_umu_dterm(p17832_2577); switch (tag_of(m_2584)) { case 1: { V _m_2584_a0_2585 = FLD(m_2584, 0); _r = ({ V item17851_2586 = _m_2584_a0_2585; ({ V local17840_2587 = item17851_2586; ({ V _r = 0; V m_2588 = d_Export_umu_dterm(p17833_2578); switch (tag_of(m_2588)) { case 1: { V _m_2588_a0_2589 = FLD(m_2588, 0); _r = ({ V item17849_2590 = _m_2588_a0_2589; ({ V local17843_2591 = item17849_2590; ({ V _r = 0; V m_2592 = d_Export_umu_dterm(p17834_2579); switch (tag_of(m_2592)) { case 1: { V _m_2592_a0_2593 = FLD(m_2592, 0); _r = ({ V item17847_2594 = _m_2592_a0_2593; ({ V local17846_2595 = item17847_2594; DONE(str_append(((V)&S_515), str_append(local17837_2583, str_append(((V)&S_61), str_append(local17840_2587, str_append(((V)&S_61), str_append(local17843_2591, str_append(((V)&S_61), str_append(local17846_2595, ((V)&S_59)))))))))); }); }); break; } case 0: { V _m_2592_a0_2596 = FLD(m_2592, 0); _r = ({ V item17848_2597 = _m_2592_a0_2596; FAIL(item17848_2597); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2588_a0_2598 = FLD(m_2588, 0); _r = ({ V item17850_2599 = _m_2588_a0_2598; FAIL(item17850_2599); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2584_a0_2600 = FLD(m_2584, 0); _r = ({ V item17852_2601 = _m_2584_a0_2600; FAIL(item17852_2601); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2580_a0_2602 = FLD(m_2580, 0); _r = ({ V item17854_2603 = _m_2580_a0_2602; FAIL(item17854_2603); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); }); }); break; } case 9: { V _m_2463_a0_2604 = FLD(m_2463, 0); V _m_2463_a1_2605 = FLD(m_2463, 1); _r = ({ V p17856_2606 = _m_2463_a0_2604; ({ V p17857_2607 = _m_2463_a1_2605; ({ V _r = 0; V m_2608 = d_Export_umu_dterm(p17856_2606); switch (tag_of(m_2608)) { case 1: { V _m_2608_a0_2609 = FLD(m_2608, 0); _r = ({ V item17866_2610 = _m_2608_a0_2609; ({ V local17860_2611 = item17866_2610; ({ V _r = 0; V m_2612 = d_Export_umu_dterm(p17857_2607); switch (tag_of(m_2612)) { case 1: { V _m_2612_a0_2613 = FLD(m_2612, 0); _r = ({ V item17864_2614 = _m_2612_a0_2613; ({ V local17863_2615 = item17864_2614; DONE(str_append(((V)&S_516), str_append(local17860_2611, str_append(((V)&S_61), str_append(local17863_2615, ((V)&S_59)))))); }); }); break; } case 0: { V _m_2612_a0_2616 = FLD(m_2612, 0); _r = ({ V item17865_2617 = _m_2612_a0_2616; FAIL(item17865_2617); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 0: { V _m_2608_a0_2618 = FLD(m_2608, 0); _r = ({ V item17867_2619 = _m_2608_a0_2618; FAIL(item17867_2619); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); }); break; } case 10: { V _m_2463_a0_2620 = FLD(m_2463, 0); _r = ({ V p17868_2621 = _m_2463_a0_2620; ({ V _r = 0; V m_2622 = d_Export_umu_dquoted(p17868_2621); switch (tag_of(m_2622)) { case 1: { V _m_2622_a0_2623 = FLD(m_2622, 0); _r = ({ V item17871_2624 = _m_2622_a0_2623; DONE(({ V local17870_2625 = item17871_2624; str_append(((V)&S_517), str_append(local17870_2625, ((V)&S_59))); })); }); break; } case 0: { V _m_2622_a0_2626 = FLD(m_2622, 0); _r = ({ V item17872_2627 = _m_2622_a0_2626; FAIL(item17872_2627); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); break; } case 11: { V _m_2463_a0_2628 = FLD(m_2463, 0); _r = ({ V p17873_2629 = _m_2463_a0_2628; ({ V _r = 0; V m_2630 = p17873_2629; switch (tag_of(m_2630)) { case 0: { V _m_2630_a0_2631 = FLD(m_2630, 0); _r = ({ V p17874_2632 = _m_2630_a0_2631; FAIL(((V)&S_518)); }); break; } case 1: { V _m_2630_a0_2633 = FLD(m_2630, 0); _r = ({ V p17875_2634 = _m_2630_a0_2633; ((d_Big_dis_ule(d_Big_dzero(), d_Bignum_dsign(p17875_2634))) != FALSE_V ? DONE(str_append(((V)&S_519), str_append(d_Bignum_dto_ustring(p17875_2634), ((V)&S_59)))) : FAIL(((V)&S_520))); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); }); break; } case 12: {  _r = ({ V __2635 = UNIT; FAIL(((V)&S_521)); }); break; } default: rt_panic("match: no case at tests:1006"); } _r; }); });
}
V d_Export_umu_dfield(V param_844_2636) {
  return ({ V scrut17604_2637 = param_844_2636; ({ V _r = 0; V m_2638 = scrut17604_2637; if ((tag_of(m_2638) == 0)) { V _m_2638_a0_2639 = FLD(m_2638, 0); V _m_2638_a1_2640 = FLD(m_2638, 1); V _m_2638_a2_2641 = FLD(m_2638, 2); _r = ({ V p17605_2642 = _m_2638_a0_2639; ({ V p17606_2643 = _m_2638_a1_2640; ({ V p17607_2644 = _m_2638_a2_2641; ({ V _r = 0; V m_2645 = d_Export_umu_dquoted(p17606_2643); switch (tag_of(m_2645)) { case 1: { V _m_2645_a0_2646 = FLD(m_2645, 0); _r = ({ V item17880_2647 = _m_2645_a0_2646; ({ V local17610_2648 = item17880_2647; ({ V _r = 0; V m_2649 = d_Export_umu_dterm(p17607_2644); switch (tag_of(m_2649)) { case 1: { V _m_2649_a0_2650 = FLD(m_2649, 0); _r = ({ V item17878_2651 = _m_2649_a0_2650; ({ V local17877_2652 = item17878_2651; DONE(str_append(((V)&S_57), str_append(d_Export_umu_dquantity(p17605_2642), str_append(((V)&S_70), str_append(local17610_2648, str_append(((V)&S_70), str_append(local17877_2652, ((V)&S_59)))))))); }); }); break; } case 0: { V _m_2649_a0_2653 = FLD(m_2649, 0); _r = ({ V item17879_2654 = _m_2649_a0_2653; FAIL(item17879_2654); }); break; } default: rt_panic("match: no case at tests:1010"); } _r; }); }); }); break; } case 0: { V _m_2645_a0_2655 = FLD(m_2645, 0); _r = ({ V item17881_2656 = _m_2645_a0_2655; FAIL(item17881_2656); }); break; } default: rt_panic("match: no case at tests:1010"); } _r; }); }); }); }); } else rt_panic("match: no case at tests:1010"); _r; }); });
}
V d_Export_umu_dstatus(V s_868_2657) {
  return ({ V scrut17888_2658 = s_868_2657; ({ V _r = 0; V m_2659 = scrut17888_2658; switch (tag_of(m_2659)) { case 0: {  _r = ({ V __2660 = UNIT; DONE(((V)&S_522)); }); break; } case 1: {  _r = ({ V __2661 = UNIT; DONE(((V)&S_523)); }); break; } case 2: { V _m_2659_a0_2662 = FLD(m_2659, 0); _r = ({ V p17889_2663 = _m_2659_a0_2662; ({ V _r = 0; V m_2664 = d_Export_umu_dlist(clo_new(w_Export_umu_dquoted, 1, 0), p17889_2663); switch (tag_of(m_2664)) { case 1: { V _m_2664_a0_2665 = FLD(m_2664, 0); _r = ({ V item17892_2666 = _m_2664_a0_2665; DONE(({ V local17891_2667 = item17892_2666; str_append(((V)&S_524), str_append(local17891_2667, ((V)&S_59))); })); }); break; } case 0: { V _m_2664_a0_2668 = FLD(m_2664, 0); _r = ({ V item17893_2669 = _m_2664_a0_2668; FAIL(item17893_2669); }); break; } default: rt_panic("match: no case at tests:1014"); } _r; }); }); break; } default: rt_panic("match: no case at tests:1014"); } _r; }); });
}
V d_Export_umu_dconstructor(V c_861_2670) {
  return ({ V _r = 0; V m_2671 = d_Export_umu_dquoted(d_Get_dPositivity_dCtor_dc_uname(c_861_2670)); switch (tag_of(m_2671)) { case 1: { V _m_2671_a0_2672 = FLD(m_2671, 0); _r = ({ V item17915_2673 = _m_2671_a0_2672; ({ V local17899_2674 = item17915_2673; ({ V _r = 0; V m_2675 = d_Export_umu_dlist(clo_new(w_Export_umu_dfield, 1, 0), d_Get_dPositivity_dCtor_dc_uargs(c_861_2670)); switch (tag_of(m_2675)) { case 1: { V _m_2675_a0_2676 = FLD(m_2675, 0); _r = ({ V item17913_2677 = _m_2675_a0_2676; ({ V local17902_2678 = item17913_2677; ({ V _r = 0; V m_2679 = d_Export_umu_dlist(clo_new(w_Export_umu_dterm, 1, 0), d_Get_dPositivity_dCtor_dc_ures_uidx(c_861_2670)); switch (tag_of(m_2679)) { case 1: { V _m_2679_a0_2680 = FLD(m_2679, 0); _r = ({ V item17911_2681 = _m_2679_a0_2680; ({ V local17905_2682 = item17911_2681; ({ V _r = 0; V m_2683 = d_Export_umu_dnatural(d_Get_dPositivity_dCtor_dc_ufull_uarity(c_861_2670)); switch (tag_of(m_2683)) { case 1: { V _m_2683_a0_2684 = FLD(m_2683, 0); _r = ({ V item17909_2685 = _m_2683_a0_2684; ({ V local17908_2686 = item17909_2685; DONE(str_append(((V)&S_525), str_append(local17899_2674, str_append(((V)&S_526), str_append(local17902_2678, str_append(((V)&S_527), str_append(local17905_2682, str_append(((V)&S_528), str_append(local17908_2686, str_append(((V)&S_529), str_append(d_NativeBool_dshow(d_Get_dPositivity_dCtor_dc_uself_urec(c_861_2670)), ((V)&S_530)))))))))))); }); }); break; } case 0: { V _m_2683_a0_2687 = FLD(m_2683, 0); _r = ({ V item17910_2688 = _m_2683_a0_2687; FAIL(item17910_2688); }); break; } default: rt_panic("match: no case at tests:1017"); } _r; }); }); }); break; } case 0: { V _m_2679_a0_2689 = FLD(m_2679, 0); _r = ({ V item17912_2690 = _m_2679_a0_2689; FAIL(item17912_2690); }); break; } default: rt_panic("match: no case at tests:1017"); } _r; }); }); }); break; } case 0: { V _m_2675_a0_2691 = FLD(m_2675, 0); _r = ({ V item17914_2692 = _m_2675_a0_2691; FAIL(item17914_2692); }); break; } default: rt_panic("match: no case at tests:1017"); } _r; }); }); }); break; } case 0: { V _m_2671_a0_2693 = FLD(m_2671, 0); _r = ({ V item17916_2694 = _m_2671_a0_2693; FAIL(item17916_2694); }); break; } default: rt_panic("match: no case at tests:1017"); } _r; });
}
V d_Export_umu_ddeclaration(V f_887_2695) {
  return ({ V _r = 0; V m_2696 = d_Export_umu_dquoted(d_Get_dPositivity_dFamily_df_uname(f_887_2695)); switch (tag_of(m_2696)) { case 1: { V _m_2696_a0_2697 = FLD(m_2696, 0); _r = ({ V item17927_2698 = _m_2696_a0_2697; ({ V local17602_2699 = item17927_2698; ({ V _r = 0; V m_2700 = d_Export_umu_dlist(clo_new(w_Export_umu_dfield, 1, 0), d_Get_dPositivity_dFamily_df_uparams(f_887_2695)); switch (tag_of(m_2700)) { case 1: { V _m_2700_a0_2701 = FLD(m_2700, 0); _r = ({ V item17925_2702 = _m_2700_a0_2701; ({ V local17883_2703 = item17925_2702; ({ V _r = 0; V m_2704 = d_Export_umu_dlist(clo_new(w_Export_umu_dfield, 1, 0), d_Get_dPositivity_dFamily_df_uindices(f_887_2695)); switch (tag_of(m_2704)) { case 1: { V _m_2704_a0_2705 = FLD(m_2704, 0); _r = ({ V item17923_2706 = _m_2704_a0_2705; ({ V local17886_2707 = item17923_2706; ({ V _r = 0; V m_2708 = d_Export_umu_dstatus(d_Get_dPositivity_dFamily_df_ustatus(f_887_2695)); switch (tag_of(m_2708)) { case 1: { V _m_2708_a0_2709 = FLD(m_2708, 0); _r = ({ V item17921_2710 = _m_2708_a0_2709; ({ V local17895_2711 = item17921_2710; ({ V _r = 0; V m_2712 = d_Export_umu_dlist(clo_new(w_Export_umu_dconstructor, 1, 0), d_Get_dPositivity_dFamily_df_uctors(f_887_2695)); switch (tag_of(m_2712)) { case 1: { V _m_2712_a0_2713 = FLD(m_2712, 0); _r = ({ V item17919_2714 = _m_2712_a0_2713; ({ V local17918_2715 = item17919_2714; DONE(str_append(((V)&S_525), str_append(local17602_2699, str_append(((V)&S_531), str_append(local17883_2703, str_append(((V)&S_532), str_append(local17886_2707, str_append(((V)&S_533), str_append(d_Level_dto_ustring(d_Get_dPositivity_dFamily_df_ulevel(f_887_2695)), str_append(((V)&S_534), str_append(local17895_2711, str_append(((V)&S_535), str_append(local17918_2715, str_append(((V)&S_536), str_append(d_NativeBool_dshow(d_Get_dPositivity_dFamily_df_upositive(f_887_2695)), ((V)&S_530)))))))))))))))); }); }); break; } case 0: { V _m_2712_a0_2716 = FLD(m_2712, 0); _r = ({ V item17920_2717 = _m_2712_a0_2716; FAIL(item17920_2717); }); break; } default: rt_panic("match: no case at tests:1020"); } _r; }); }); }); break; } case 0: { V _m_2708_a0_2718 = FLD(m_2708, 0); _r = ({ V item17922_2719 = _m_2708_a0_2718; FAIL(item17922_2719); }); break; } default: rt_panic("match: no case at tests:1020"); } _r; }); }); }); break; } case 0: { V _m_2704_a0_2720 = FLD(m_2704, 0); _r = ({ V item17924_2721 = _m_2704_a0_2720; FAIL(item17924_2721); }); break; } default: rt_panic("match: no case at tests:1020"); } _r; }); }); }); break; } case 0: { V _m_2700_a0_2722 = FLD(m_2700, 0); _r = ({ V item17926_2723 = _m_2700_a0_2722; FAIL(item17926_2723); }); break; } default: rt_panic("match: no case at tests:1020"); } _r; }); }); }); break; } case 0: { V _m_2696_a0_2724 = FLD(m_2696, 0); _r = ({ V item17928_2725 = _m_2696_a0_2724; FAIL(item17928_2725); }); break; } default: rt_panic("match: no case at tests:1020"); } _r; });
}
V d_Export_umu_ddefinition(V rows_915_2726, V name_916_2727) {
  return ({ V _r = 0; V m_2728 = ({ V local17938_2729 = d_SeqList_dassoc(clo_new(lam_2732, 2, 0), name_916_2727, rows_915_2726); ({ V _r = 0; V m_2733 = local17938_2729; if (((m_2733) == NONE)) {  _r = ({ V __2734 = UNIT; FAIL(str_append(((V)&S_537), name_916_2727)); }); } else if (((m_2733) != NONE)) { V _m_2733_a0_2735 = FLD(m_2733, 0); _r = ({ V x_2736 = _m_2733_a0_2735; DONE(x_2736); }); } else rt_panic("match: no case at tests:1023"); _r; }); }); switch (tag_of(m_2728)) { case 1: { V _m_2728_a0_2737 = FLD(m_2728, 0); _r = ({ V item17961_2738 = _m_2728_a0_2737; ({ V local17940_2739 = item17961_2738; ({ V scrut17941_2740 = local17940_2739; ({ V _r = 0; V m_2741 = scrut17941_2740; switch (tag_of(m_2741)) { case 0: { V _m_2741_a0_2742 = FLD(m_2741, 0); _r = ({ V p17942_2743 = _m_2741_a0_2742; ({ V _r = 0; V m_2744 = d_Export_umu_dterm(d_Get_dGlobal_dDef_uentry_ddef(p17942_2743)); switch (tag_of(m_2744)) { case 1: { V _m_2744_a0_2745 = FLD(m_2744, 0); _r = ({ V item17956_2746 = _m_2744_a0_2745; ({ V local17945_2747 = item17956_2746; ({ V _r = 0; V m_2748 = d_Export_umu_dterm(d_Get_dGlobal_dDef_uentry_dty(p17942_2743)); switch (tag_of(m_2748)) { case 1: { V _m_2748_a0_2749 = FLD(m_2748, 0); _r = ({ V item17954_2750 = _m_2748_a0_2749; ({ V local17948_2751 = item17954_2750; ({ V _r = 0; V m_2752 = d_Export_umu_doptional(clo_new(w_Export_umu_dnatural, 1, 0), d_Get_dGlobal_dDef_uentry_drec_uarg(p17942_2743)); switch (tag_of(m_2752)) { case 1: { V _m_2752_a0_2753 = FLD(m_2752, 0); _r = ({ V item17952_2754 = _m_2752_a0_2753; ({ V local17951_2755 = item17952_2754; DONE(str_append(((V)&S_89), str_append(name_916_2727, str_append(((V)&S_538), str_append(local17945_2747, str_append(((V)&S_539), str_append(((V)&S_89), str_append(name_916_2727, str_append(((V)&S_540), str_append(local17948_2751, str_append(((V)&S_539), str_append(((V)&S_89), str_append(name_916_2727, str_append(((V)&S_541), str_append(local17951_2755, str_append(((V)&S_87), str_append(((V)&S_89), str_append(name_916_2727, str_append(((V)&S_542), str_append(d_NativeBool_dshow(d_Get_dGlobal_dDef_uentry_dpartial(p17942_2743)), str_append(((V)&S_87), str_append(((V)&S_89), str_append(name_916_2727, str_append(((V)&S_543), str_append(d_NativeBool_dshow(d_Get_dGlobal_dDef_uentry_dreducible(p17942_2743)), ((V)&S_87)))))))))))))))))))))))))); }); }); break; } case 0: { V _m_2752_a0_2756 = FLD(m_2752, 0); _r = ({ V item17953_2757 = _m_2752_a0_2756; FAIL(item17953_2757); }); break; } default: rt_panic("match: no case at tests:1024"); } _r; }); }); }); break; } case 0: { V _m_2748_a0_2758 = FLD(m_2748, 0); _r = ({ V item17955_2759 = _m_2748_a0_2758; FAIL(item17955_2759); }); break; } default: rt_panic("match: no case at tests:1024"); } _r; }); }); }); break; } case 0: { V _m_2744_a0_2760 = FLD(m_2744, 0); _r = ({ V item17957_2761 = _m_2744_a0_2760; FAIL(item17957_2761); }); break; } default: rt_panic("match: no case at tests:1024"); } _r; }); }); break; } case 1: { V _m_2741_a0_2762 = FLD(m_2741, 0); _r = ({ V p17959_2763 = _m_2741_a0_2762; FAIL(str_append(((V)&S_544), name_916_2727)); }); break; } case 2: { V _m_2741_a0_2764 = FLD(m_2741, 0); _r = ({ V p17960_2765 = _m_2741_a0_2764; FAIL(str_append(((V)&S_544), name_916_2727)); }); break; } default: rt_panic("match: no case at tests:1024"); } _r; }); }); }); }); break; } case 0: { V _m_2728_a0_2766 = FLD(m_2728, 0); _r = ({ V item17962_2767 = _m_2728_a0_2766; FAIL(item17962_2767); }); break; } default: rt_panic("match: no case at tests:1023"); } _r; });
}
V d_Export_umu_dexport(V source_1010_2768) {
  return ({ V _r = 0; V m_2769 = ({ V local17583_2770 = d_Elab_dcheck_uin(NONE, d_Global_dinitial(), source_1010_2768); ({ V _r = 0; V m_2771 = local17583_2770; switch (tag_of(m_2771)) { case 1: { V _m_2771_a0_2772 = FLD(m_2771, 0); _r = ({ V item17584_2773 = _m_2771_a0_2772; DONE(item17584_2773); }); break; } case 0: { V _m_2771_a0_2774 = FLD(m_2771, 0); _r = ({ V item17585_2775 = _m_2771_a0_2774; FAIL(d_Error_dto_ustring(item17585_2775)); }); break; } default: rt_panic("match: no case at tests:1027"); } _r; }); }); switch (tag_of(m_2769)) { case 1: { V _m_2769_a0_2776 = FLD(m_2769, 0); _r = ({ V item17972_2777 = _m_2769_a0_2776; ({ V local17587_2778 = item17972_2777; ({ V scrut17588_2779 = local17587_2778; ({ V _r = 0; V m_2780 = scrut17588_2779; if ((tag_of(m_2780) == 0)) { V _m_2780_a0_2781 = FLD(m_2780, 0); V _m_2780_a1_2782 = FLD(m_2780, 1); _r = ({ V p17589_2783 = _m_2780_a0_2781; ({ V p17590_2784 = _m_2780_a1_2782; ({ V _r = 0; V m_2785 = ({ V local17594_2786 = d_Global_dfind_ufamily(((V)&S_6), p17589_2783); ({ V _r = 0; V m_2787 = local17594_2786; if (((m_2787) == NONE)) {  _r = ({ V __2788 = UNIT; FAIL(((V)&S_545)); }); } else if (((m_2787) != NONE)) { V _m_2787_a0_2789 = FLD(m_2787, 0); _r = ({ V x_2790 = _m_2787_a0_2789; DONE(x_2790); }); } else rt_panic("match: no case at tests:1028"); _r; }); }); switch (tag_of(m_2785)) { case 1: { V _m_2785_a0_2791 = FLD(m_2785, 0); _r = ({ V item17969_2792 = _m_2785_a0_2791; ({ V local17596_2793 = item17969_2792; ({ V _r = 0; V m_2794 = d_Export_umu_ddeclaration(local17596_2793); switch (tag_of(m_2794)) { case 1: { V _m_2794_a0_2795 = FLD(m_2794, 0); _r = ({ V item17967_2796 = _m_2794_a0_2795; ({ V local17930_2797 = item17967_2796; ({ V _r = 0; V m_2798 = d_Export_umu_dsequence(({ V _c = clo_new(lam_2800, 1, 1); CLO_ENV(_c)[0] = p17590_2784; _c; }), CON(((V)&S_546), CON(((V)&S_38), NIL))); switch (tag_of(m_2798)) { case 1: { V _m_2798_a0_2801 = FLD(m_2798, 0); _r = ({ V item17965_2802 = _m_2798_a0_2801; ({ V local17964_2803 = item17965_2802; DONE(str_append(((V)&S_547), str_append(((V)&S_548), str_append(((V)&S_549), str_append(local17930_2797, str_append(((V)&S_539), str_append(str_join(local17964_2803, ((V)&S_87)), ((V)&S_550)))))))); }); }); break; } case 0: { V _m_2798_a0_2804 = FLD(m_2798, 0); _r = ({ V item17966_2805 = _m_2798_a0_2804; FAIL(item17966_2805); }); break; } default: rt_panic("match: no case at tests:1028"); } _r; }); }); }); break; } case 0: { V _m_2794_a0_2806 = FLD(m_2794, 0); _r = ({ V item17968_2807 = _m_2794_a0_2806; FAIL(item17968_2807); }); break; } default: rt_panic("match: no case at tests:1028"); } _r; }); }); }); break; } case 0: { V _m_2785_a0_2808 = FLD(m_2785, 0); _r = ({ V item17970_2809 = _m_2785_a0_2808; FAIL(item17970_2809); }); break; } default: rt_panic("match: no case at tests:1028"); } _r; }); }); }); } else rt_panic("match: no case at tests:1028"); _r; }); }); }); }); break; } case 0: { V _m_2769_a0_2810 = FLD(m_2769, 0); _r = ({ V item17973_2811 = _m_2769_a0_2810; FAIL(item17973_2811); }); break; } default: rt_panic("match: no case at tests:1027"); } _r; });
}
V d_Export_umu_dexport_utree(V source_1095_2812) {
  return ({ V _r = 0; V m_2813 = ({ V local17977_2814 = d_Elab_dcheck_uin(NONE, d_Global_dinitial(), source_1095_2812); ({ V _r = 0; V m_2815 = local17977_2814; switch (tag_of(m_2815)) { case 1: { V _m_2815_a0_2816 = FLD(m_2815, 0); _r = ({ V item17978_2817 = _m_2815_a0_2816; DONE(item17978_2817); }); break; } case 0: { V _m_2815_a0_2818 = FLD(m_2815, 0); _r = ({ V item17979_2819 = _m_2815_a0_2818; FAIL(d_Error_dto_ustring(item17979_2819)); }); break; } default: rt_panic("match: no case at tests:1031"); } _r; }); }); switch (tag_of(m_2813)) { case 1: { V _m_2813_a0_2820 = FLD(m_2813, 0); _r = ({ V item18007_2821 = _m_2813_a0_2820; ({ V local17981_2822 = item18007_2821; ({ V scrut17982_2823 = local17981_2822; ({ V _r = 0; V m_2824 = scrut17982_2823; if ((tag_of(m_2824) == 0)) { V _m_2824_a0_2825 = FLD(m_2824, 0); V _m_2824_a1_2826 = FLD(m_2824, 1); _r = ({ V p17983_2827 = _m_2824_a0_2825; ({ V p17984_2828 = _m_2824_a1_2826; ({ V _r = 0; V m_2829 = ({ V local17988_2830 = d_Global_dfind_ufamily(((V)&S_551), p17983_2827); ({ V _r = 0; V m_2831 = local17988_2830; if (((m_2831) == NONE)) {  _r = ({ V __2832 = UNIT; FAIL(((V)&S_552)); }); } else if (((m_2831) != NONE)) { V _m_2831_a0_2833 = FLD(m_2831, 0); _r = ({ V x_2834 = _m_2831_a0_2833; DONE(x_2834); }); } else rt_panic("match: no case at tests:1032"); _r; }); }); switch (tag_of(m_2829)) { case 1: { V _m_2829_a0_2835 = FLD(m_2829, 0); _r = ({ V item18004_2836 = _m_2829_a0_2835; ({ V local17990_2837 = item18004_2836; ({ V _r = 0; V m_2838 = d_Export_umu_ddeclaration(local17990_2837); switch (tag_of(m_2838)) { case 1: { V _m_2838_a0_2839 = FLD(m_2838, 0); _r = ({ V item18002_2840 = _m_2838_a0_2839; ({ V local17993_2841 = item18002_2840; ({ V _r = 0; V m_2842 = d_Export_umu_dsequence(({ V _c = clo_new(lam_2844, 1, 1); CLO_ENV(_c)[0] = p17984_2828; _c; }), CON(((V)&S_553), CON(((V)&S_554), NIL))); switch (tag_of(m_2842)) { case 1: { V _m_2842_a0_2845 = FLD(m_2842, 0); _r = ({ V item18000_2846 = _m_2842_a0_2845; ({ V local17999_2847 = item18000_2846; DONE(str_append(((V)&S_547), str_append(((V)&S_555), str_append(((V)&S_556), str_append(local17993_2841, str_append(((V)&S_539), str_append(str_join(local17999_2847, ((V)&S_87)), ((V)&S_557)))))))); }); }); break; } case 0: { V _m_2842_a0_2848 = FLD(m_2842, 0); _r = ({ V item18001_2849 = _m_2842_a0_2848; FAIL(item18001_2849); }); break; } default: rt_panic("match: no case at tests:1032"); } _r; }); }); }); break; } case 0: { V _m_2838_a0_2850 = FLD(m_2838, 0); _r = ({ V item18003_2851 = _m_2838_a0_2850; FAIL(item18003_2851); }); break; } default: rt_panic("match: no case at tests:1032"); } _r; }); }); }); break; } case 0: { V _m_2829_a0_2852 = FLD(m_2829, 0); _r = ({ V item18005_2853 = _m_2829_a0_2852; FAIL(item18005_2853); }); break; } default: rt_panic("match: no case at tests:1032"); } _r; }); }); }); } else rt_panic("match: no case at tests:1032"); _r; }); }); }); }); break; } case 0: { V _m_2813_a0_2854 = FLD(m_2813, 0); _r = ({ V item18008_2855 = _m_2813_a0_2854; FAIL(item18008_2855); }); break; } default: rt_panic("match: no case at tests:1031"); } _r; });
}
V d_Export_umu_dexport_uvector(V source_1104_2856) {
  return ({ V _r = 0; V m_2857 = ({ V local18012_2858 = d_Elab_dcheck_uin(NONE, d_Global_dinitial(), source_1104_2856); ({ V _r = 0; V m_2859 = local18012_2858; switch (tag_of(m_2859)) { case 1: { V _m_2859_a0_2860 = FLD(m_2859, 0); _r = ({ V item18013_2861 = _m_2859_a0_2860; DONE(item18013_2861); }); break; } case 0: { V _m_2859_a0_2862 = FLD(m_2859, 0); _r = ({ V item18014_2863 = _m_2859_a0_2862; FAIL(d_Error_dto_ustring(item18014_2863)); }); break; } default: rt_panic("match: no case at tests:1035"); } _r; }); }); switch (tag_of(m_2857)) { case 1: { V _m_2857_a0_2864 = FLD(m_2857, 0); _r = ({ V item18055_2865 = _m_2857_a0_2864; ({ V local18016_2866 = item18055_2865; ({ V scrut18017_2867 = local18016_2866; ({ V _r = 0; V m_2868 = scrut18017_2867; if ((tag_of(m_2868) == 0)) { V _m_2868_a0_2869 = FLD(m_2868, 0); V _m_2868_a1_2870 = FLD(m_2868, 1); _r = ({ V p18018_2871 = _m_2868_a0_2869; ({ V p18019_2872 = _m_2868_a1_2870; ({ V _r = 0; V m_2873 = ({ V local18023_2874 = d_Global_dfind_ufamily(((V)&S_6), p18018_2871); ({ V _r = 0; V m_2875 = local18023_2874; if (((m_2875) == NONE)) {  _r = ({ V __2876 = UNIT; FAIL(((V)&S_545)); }); } else if (((m_2875) != NONE)) { V _m_2875_a0_2877 = FLD(m_2875, 0); _r = ({ V x_2878 = _m_2875_a0_2877; DONE(x_2878); }); } else rt_panic("match: no case at tests:1036"); _r; }); }); switch (tag_of(m_2873)) { case 1: { V _m_2873_a0_2879 = FLD(m_2873, 0); _r = ({ V item18052_2880 = _m_2873_a0_2879; ({ V local18025_2881 = item18052_2880; ({ V _r = 0; V m_2882 = ({ V local18029_2883 = d_Global_dfind_ufamily(((V)&S_558), p18018_2871); ({ V _r = 0; V m_2884 = local18029_2883; if (((m_2884) == NONE)) {  _r = ({ V __2885 = UNIT; FAIL(((V)&S_559)); }); } else if (((m_2884) != NONE)) { V _m_2884_a0_2886 = FLD(m_2884, 0); _r = ({ V x_2887 = _m_2884_a0_2886; DONE(x_2887); }); } else rt_panic("match: no case at tests:1036"); _r; }); }); switch (tag_of(m_2882)) { case 1: { V _m_2882_a0_2888 = FLD(m_2882, 0); _r = ({ V item18050_2889 = _m_2882_a0_2888; ({ V local18031_2890 = item18050_2889; ({ V _r = 0; V m_2891 = d_Export_umu_ddeclaration(local18025_2881); switch (tag_of(m_2891)) { case 1: { V _m_2891_a0_2892 = FLD(m_2891, 0); _r = ({ V item18048_2893 = _m_2891_a0_2892; ({ V local18034_2894 = item18048_2893; ({ V _r = 0; V m_2895 = d_Export_umu_ddeclaration(local18031_2890); switch (tag_of(m_2895)) { case 1: { V _m_2895_a0_2896 = FLD(m_2895, 0); _r = ({ V item18046_2897 = _m_2895_a0_2896; ({ V local18037_2898 = item18046_2897; ({ V _r = 0; V m_2899 = d_Export_umu_dsequence(({ V _c = clo_new(lam_2901, 1, 1); CLO_ENV(_c)[0] = p18019_2872; _c; }), CON(((V)&S_553), CON(((V)&S_560), NIL))); switch (tag_of(m_2899)) { case 1: { V _m_2899_a0_2902 = FLD(m_2899, 0); _r = ({ V item18044_2903 = _m_2899_a0_2902; ({ V local18043_2904 = item18044_2903; DONE(str_append(((V)&S_547), str_append(((V)&S_561), str_append(((V)&S_562), str_append(local18034_2894, str_append(((V)&S_539), str_append(((V)&S_556), str_append(local18037_2898, str_append(((V)&S_539), str_append(str_join(local18043_2904, ((V)&S_87)), ((V)&S_563))))))))))); }); }); break; } case 0: { V _m_2899_a0_2905 = FLD(m_2899, 0); _r = ({ V item18045_2906 = _m_2899_a0_2905; FAIL(item18045_2906); }); break; } default: rt_panic("match: no case at tests:1036"); } _r; }); }); }); break; } case 0: { V _m_2895_a0_2907 = FLD(m_2895, 0); _r = ({ V item18047_2908 = _m_2895_a0_2907; FAIL(item18047_2908); }); break; } default: rt_panic("match: no case at tests:1036"); } _r; }); }); }); break; } case 0: { V _m_2891_a0_2909 = FLD(m_2891, 0); _r = ({ V item18049_2910 = _m_2891_a0_2909; FAIL(item18049_2910); }); break; } default: rt_panic("match: no case at tests:1036"); } _r; }); }); }); break; } case 0: { V _m_2882_a0_2911 = FLD(m_2882, 0); _r = ({ V item18051_2912 = _m_2882_a0_2911; FAIL(item18051_2912); }); break; } default: rt_panic("match: no case at tests:1036"); } _r; }); }); }); break; } case 0: { V _m_2873_a0_2913 = FLD(m_2873, 0); _r = ({ V item18053_2914 = _m_2873_a0_2913; FAIL(item18053_2914); }); break; } default: rt_panic("match: no case at tests:1036"); } _r; }); }); }); } else rt_panic("match: no case at tests:1036"); _r; }); }); }); }); break; } case 0: { V _m_2857_a0_2915 = FLD(m_2857, 0); _r = ({ V item18056_2916 = _m_2857_a0_2915; FAIL(item18056_2916); }); break; } default: rt_panic("match: no case at tests:1035"); } _r; });
}
V d_Export_umu_dexport_ufinitary(V name_1115_2917, V source_1116_2918) {
  return ({ V _r = 0; V m_2919 = ({ V local18060_2920 = d_Elab_dcheck_uin(NONE, d_Global_dinitial(), source_1116_2918); ({ V _r = 0; V m_2921 = local18060_2920; switch (tag_of(m_2921)) { case 1: { V _m_2921_a0_2922 = FLD(m_2921, 0); _r = ({ V item18061_2923 = _m_2921_a0_2922; DONE(item18061_2923); }); break; } case 0: { V _m_2921_a0_2924 = FLD(m_2921, 0); _r = ({ V item18062_2925 = _m_2921_a0_2924; FAIL(d_Error_dto_ustring(item18062_2925)); }); break; } default: rt_panic("match: no case at tests:1039"); } _r; }); }); switch (tag_of(m_2919)) { case 1: { V _m_2919_a0_2926 = FLD(m_2919, 0); _r = ({ V item18087_2927 = _m_2919_a0_2926; ({ V local18064_2928 = item18087_2927; ({ V scrut18065_2929 = local18064_2928; ({ V _r = 0; V m_2930 = scrut18065_2929; if ((tag_of(m_2930) == 0)) { V _m_2930_a0_2931 = FLD(m_2930, 0); V _m_2930_a1_2932 = FLD(m_2930, 1); _r = ({ V p18066_2933 = _m_2930_a0_2931; ({ V p18067_2934 = _m_2930_a1_2932; ({ V _r = 0; V m_2935 = ({ V local18071_2936 = d_Global_dfind_ufamily(name_1115_2917, p18066_2933); ({ V _r = 0; V m_2937 = local18071_2936; if (((m_2937) == NONE)) {  _r = ({ V __2938 = UNIT; FAIL(str_append(((V)&S_564), str_append(name_1115_2917, ((V)&S_565)))); }); } else if (((m_2937) != NONE)) { V _m_2937_a0_2939 = FLD(m_2937, 0); _r = ({ V x_2940 = _m_2937_a0_2939; DONE(x_2940); }); } else rt_panic("match: no case at tests:1040"); _r; }); }); switch (tag_of(m_2935)) { case 1: { V _m_2935_a0_2941 = FLD(m_2935, 0); _r = ({ V item18084_2942 = _m_2935_a0_2941; ({ V local18073_2943 = item18084_2942; ({ V _r = 0; V m_2944 = d_Export_umu_ddeclaration(local18073_2943); switch (tag_of(m_2944)) { case 1: { V _m_2944_a0_2945 = FLD(m_2944, 0); _r = ({ V item18082_2946 = _m_2944_a0_2945; ({ V local18076_2947 = item18082_2946; ({ V _r = 0; V m_2948 = d_Export_umu_ddefinition(p18067_2934, ((V)&S_553)); switch (tag_of(m_2948)) { case 1: { V _m_2948_a0_2949 = FLD(m_2948, 0); _r = ({ V item18080_2950 = _m_2948_a0_2949; ({ V local18079_2951 = item18080_2950; DONE(str_append(((V)&S_547), str_append(((V)&S_566), str_append(((V)&S_556), str_append(local18076_2947, str_append(((V)&S_539), str_append(local18079_2951, ((V)&S_567)))))))); }); }); break; } case 0: { V _m_2948_a0_2952 = FLD(m_2948, 0); _r = ({ V item18081_2953 = _m_2948_a0_2952; FAIL(item18081_2953); }); break; } default: rt_panic("match: no case at tests:1040"); } _r; }); }); }); break; } case 0: { V _m_2944_a0_2954 = FLD(m_2944, 0); _r = ({ V item18083_2955 = _m_2944_a0_2954; FAIL(item18083_2955); }); break; } default: rt_panic("match: no case at tests:1040"); } _r; }); }); }); break; } case 0: { V _m_2935_a0_2956 = FLD(m_2935, 0); _r = ({ V item18085_2957 = _m_2935_a0_2956; FAIL(item18085_2957); }); break; } default: rt_panic("match: no case at tests:1040"); } _r; }); }); }); } else rt_panic("match: no case at tests:1040"); _r; }); }); }); }); break; } case 0: { V _m_2919_a0_2958 = FLD(m_2919, 0); _r = ({ V item18088_2959 = _m_2919_a0_2958; FAIL(item18088_2959); }); break; } default: rt_panic("match: no case at tests:1039"); } _r; });
}
V d_Tests_dunit(V name_2960, V result_2961) {
  return ({ V _r = 0; V m_2962 = result_2961; switch (tag_of(m_2962)) { case 0: { V message_2963 = FLD(m_2962, 0); _r = d_NativeIO_ddie(((V)1u), str_concat(CON(name_2960, CON(((V)&S_568), CON(message_2963, NIL))))); break; } case 1: { V unit_2964 = FLD(m_2962, 0); _r = d_NativeIO_dprint(str_append(name_2960, ((V)&S_569))); break; } default: rt_panic("match: no case at tests:1042"); } _r; });
}
V d_Tests_dmessage(V result_2965) {
  return ({ V _r = 0; V m_2966 = result_2965; switch (tag_of(m_2966)) { case 0: { V message_2967 = FLD(m_2966, 0); _r = d_NativeIO_ddie(((V)1u), message_2967); break; } case 1: { V message_2968 = FLD(m_2966, 0); _r = d_NativeIO_dstdout(message_2968); break; } default: rt_panic("match: no case at tests:1046"); } _r; });
}
V d_Tests_dadapter(V result_2969) {
  return ({ V _r = 0; V m_2970 = result_2969; switch (tag_of(m_2970)) { case 0: { V message_2971 = FLD(m_2970, 0); _r = d_NativeIO_ddie(((V)64u), message_2971); break; } case 1: { V message_2972 = FLD(m_2970, 0); _r = d_NativeIO_dprint(message_2972); break; } default: rt_panic("match: no case at tests:1050"); } _r; });
}
V d_Tests_dkernel(void) {
  static V memo; static int done;
  if (!done) { memo = clo_new(io_2973, 0, 0); rt_root(&memo); done = 1; }
  return memo;
}
V d_Tests_dsurface(V cases_2974, V count_2975) {
  return ({ V _r = 0; V m_2976 = cases_2974; if (((m_2976) == NIL)) {  _r = ({ V _c = clo_new(io_2977, 0, 1); CLO_ENV(_c)[0] = count_2975; _c; }); } else if (((m_2976) != NIL) && (tag_of(FLD(m_2976, 0)) == 0)) { V name_2978 = FLD(FLD(m_2976, 0), 0); V test_2979 = FLD(FLD(m_2976, 0), 1); V rest_2980 = FLD(m_2976, 1); _r = ({ V _c = clo_new(io_2981, 0, 4); CLO_ENV(_c)[0] = name_2978; CLO_ENV(_c)[1] = test_2979; CLO_ENV(_c)[2] = rest_2980; CLO_ENV(_c)[3] = count_2975; _c; }); } else rt_panic("match: no case at tests:1062"); _r; });
}
V d_Tests_dkeccak(V result_2982) {
  return ({ V _r = 0; V m_2983 = result_2982; if ((tag_of(m_2983) == 1)) { V hex_2984 = FLD(m_2983, 0); _r = d_NativeIO_dprint(str_append(((V)&S_203), hex_2984)); } else if ((tag_of(m_2983) == 0) && (tag_of(FLD(m_2983, 0)) == 0)) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_581)); } else if ((tag_of(m_2983) == 0) && (tag_of(FLD(m_2983, 0)) == 1)) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_582)); } else if ((tag_of(m_2983) == 0) && (tag_of(FLD(m_2983, 0)) == 2)) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_583)); } else rt_panic("match: no case at tests:1070"); _r; });
}
V d_Tests_dsuite(V result_2985) {
  return ({ V _r = 0; V m_2986 = result_2985; if ((tag_of(m_2986) == 0)) { V status_2987 = FLD(m_2986, 0); V blocks_2988 = FLD(m_2986, 1); V mismatch_2989 = FLD(m_2986, 2); V cases_2990 = FLD(m_2986, 3); _r = ({ V ok_2991 = d_Big_dis_ueq(status_2987, d_Big_dzero()); ({ V message_2992 = str_concat(CON(((V)&S_584), CON(d_Big_dshow(blocks_2988), CON(((V)&S_585), CON(d_Big_dshow(mismatch_2989), CON(((V)&S_435), CON(d_Big_dshow(cases_2990), CON(((ok_2991) != FALSE_V ? ((V)&S_569) : ((V)&S_586)), NIL)))))))); ((ok_2991) != FALSE_V ? d_NativeIO_dprint(message_2992) : d_NativeIO_ddie(((V)1u), message_2992)); }); }); } else rt_panic("match: no case at tests:1077"); _r; });
}
V d_Tests_dfixture_uresult(V name_2993, V result_2994) {
  return ({ V _r = 0; V m_2995 = result_2994; switch (tag_of(m_2995)) { case 0: { V error_2996 = FLD(m_2995, 0); _r = d_NativeIO_ddie(((V)1u), d_Asm_derror_utext(error_2996)); break; } case 1: { V program_2997 = FLD(m_2995, 0); _r = d_NativeIO_dprint(str_concat(CON(name_2993, CON(((V)&S_61), CON(d_Asm_dhex(program_2997), NIL))))); break; } default: rt_panic("match: no case at tests:1083"); } _r; });
}
V d_Tests_dasm_ufixtures(V fixtures_2998) {
  return ({ V _r = 0; V m_2999 = fixtures_2998; if (((m_2999) == NIL)) {  _r = io_pure(UNIT); } else if (((m_2999) != NIL) && (tag_of(FLD(m_2999, 0)) == 0)) { V name_3000 = FLD(FLD(m_2999, 0), 0); V blocks_3001 = FLD(FLD(m_2999, 0), 1); V rest_3002 = FLD(m_2999, 1); _r = ({ V _c = clo_new(io_3003, 0, 3); CLO_ENV(_c)[0] = name_3000; CLO_ENV(_c)[1] = blocks_3001; CLO_ENV(_c)[2] = rest_3002; _c; }); } else rt_panic("match: no case at tests:1087"); _r; });
}
V d_Tests_dlisting(V result_3004) {
  return ({ V _r = 0; V m_3005 = result_3004; switch (tag_of(m_3005)) { case 0: { V error_3006 = FLD(m_3005, 0); _r = d_NativeIO_ddie(((V)2u), d_Listing_derror_utext(error_3006)); break; } case 1: { V listing_3007 = FLD(m_3005, 0); _r = d_NativeIO_dstdout(listing_3007); break; } default: rt_panic("match: no case at tests:1093"); } _r; });
}
V d_Tests_dheights(V rows_3008) {
  return ({ V _r = 0; V m_3009 = rows_3008; if (((m_3009) == NIL)) {  _r = io_pure(UNIT); } else if (((m_3009) != NIL) && (tag_of(FLD(m_3009, 0)) == 0)) { V label_3010 = FLD(FLD(m_3009, 0), 0); V incoming_3011 = FLD(FLD(m_3009, 0), 1); V outgoing_3012 = FLD(FLD(m_3009, 0), 2); V peak_3013 = FLD(FLD(m_3009, 0), 3); V rest_3014 = FLD(m_3009, 1); _r = ({ V _c = clo_new(io_3015, 0, 3); CLO_ENV(_c)[0] = outgoing_3012; CLO_ENV(_c)[1] = peak_3013; CLO_ENV(_c)[2] = rest_3014; _c; }); } else rt_panic("match: no case at tests:1097"); _r; });
}
V d_Tests_deffect(V result_3016) {
  return ({ V _r = 0; V m_3017 = result_3016; switch (tag_of(m_3017)) { case 0: { V error_3018 = FLD(m_3017, 0); _r = ({ V _c = clo_new(io_3019, 0, 1); CLO_ENV(_c)[0] = error_3018; _c; }); break; } case 1: { V program_3020 = FLD(m_3017, 0); _r = d_Tests_dheights(d_Asm_dheights(program_3020)); break; } default: rt_panic("match: no case at tests:1103"); } _r; });
}
V d_Tests_deffect_uheights(V rows_3021) {
  return ({ V _r = 0; V m_3022 = rows_3021; if (((m_3022) == NIL)) {  _r = SNIL; } else if (((m_3022) != NIL) && (tag_of(FLD(m_3022, 0)) == 0)) { V outgoing_3023 = FLD(FLD(m_3022, 0), 2); V peak_3024 = FLD(FLD(m_3022, 0), 3); V rest_3025 = FLD(m_3022, 1); _r = str_concat(CON(d_Big_dshow(outgoing_3023), CON(((V)&S_61), CON(d_Big_dshow(peak_3024), CON(((V)&S_87), CON(d_Tests_deffect_uheights(rest_3025), NIL)))))); } else rt_panic("match: no case at tests:1110"); _r; });
}
V d_Tests_deffect_uoutput(V result_3026) {
  return ({ V _r = 0; V m_3027 = result_3026; switch (tag_of(m_3027)) { case 0: { V error_3028 = FLD(m_3027, 0); _r = str_concat(CON(((V)&S_587), CON(error_3028, CON(((V)&S_87), NIL)))); break; } case 1: { V program_3029 = FLD(m_3027, 0); _r = str_append(((V)&S_588), d_Tests_deffect_uheights(d_Asm_dheights(program_3029))); break; } default: rt_panic("match: no case at tests:1114"); } _r; });
}
V d_Tests_deffect_uemit(V rest_3030, V text_3031) {
  return ({ V _c = clo_new(io_3032, 0, 2); CLO_ENV(_c)[0] = text_3031; CLO_ENV(_c)[1] = rest_3030; _c; });
}
V d_Tests_deffect_ubatch(V fields_3033) {
  return ({ V _r = 0; V m_3034 = fields_3033; if (((m_3034) == NIL)) {  _r = io_pure(UNIT); } else if (((m_3034) != NIL) && (str_eq_lit(FLD(m_3034, 0), "", 0)) && ((FLD(m_3034, 1)) == NIL)) {  _r = io_pure(UNIT); } else if (((m_3034) != NIL) && ((FLD(m_3034, 1)) != NIL)) { V name_3035 = FLD(m_3034, 0); V height_3036 = FLD(FLD(m_3034, 1), 0); V rest_3037 = FLD(FLD(m_3034, 1), 1); _r = d_Tests_deffect_uemit(rest_3037, d_Tests_deffect_uoutput(d_Asm_ucases_deffect(name_3035, height_3036))); } else if (1) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_589)); } else rt_panic("match: no case at tests:1124"); _r; });
}
V d_Tests_deffect_umanifest(V result_3038) {
  return ({ V _r = 0; V m_3039 = result_3038; switch (tag_of(m_3039)) { case 0: { V error_3040 = FLD(m_3039, 0); _r = d_NativeIO_ddie(((V)1u), error_3040); break; } case 1: { V text_3041 = FLD(m_3039, 0); _r = d_Tests_deffect_ubatch(d_NativeString_dsplit((((V)0u)), text_3041)); break; } default: rt_panic("match: no case at tests:1130"); } _r; });
}
V d_Tests_dopcode(V row_3042) {
  return ({ V _r = 0; V m_3043 = row_3042; if (((m_3043) == NONE)) {  _r = io_pure(UNIT); } else if (((m_3043) != NONE) && (tag_of(FLD(m_3043, 0)) == 0)) { V byte_3044 = FLD(FLD(m_3043, 0), 0); V name_3045 = FLD(FLD(m_3043, 0), 1); V pops_3046 = FLD(FLD(m_3043, 0), 2); V pushes_3047 = FLD(FLD(m_3043, 0), 3); _r = d_NativeIO_dprint(str_concat(CON(d_NativeString_dpad(NAT_SMALL(2ull), ((V)48), d_Big_dhex(byte_3044, FALSE_V)), CON(((V)&S_61), CON(name_3045, CON(((V)&S_61), CON(d_Big_dshow(pops_3046), CON(((V)&S_61), CON(d_Big_dshow(pushes_3047), NIL))))))))); } else rt_panic("match: no case at tests:1134"); _r; });
}
V d_Tests_dmetadata(V n_3048) {
  return ((((V)(nat_cmp(n_3048, NAT_SMALL(256ull)) < 0))) != FALSE_V ? ({ V _c = clo_new(io_3049, 0, 1); CLO_ENV(_c)[0] = n_3048; _c; }) : io_pure(UNIT));
}
V d_Tests_dasm_ucases(V args_3050) {
  return ({ V _r = 0; V m_3051 = args_3050; if (((m_3051) != NIL) && ((FLD(m_3051, 1)) == NIL)) { V mode_3052 = FLD(m_3051, 0); _r = ((d_NativeString_dequal(mode_3052, ((V)&S_590))) != FALSE_V ? clo_new(io_3053, 0, 0) : ((d_NativeString_dequal(mode_3052, ((V)&S_591))) != FALSE_V ? d_Tests_dasm_ufixtures(d_Asm_ucases_dfixtures()) : ((d_NativeString_dequal(mode_3052, ((V)&S_592))) != FALSE_V ? d_Tests_dmetadata(NAT_SMALL(0ull)) : d_NativeIO_ddie(((V)64u), ((V)&S_593))))); } else if (((m_3051) != NIL) && ((FLD(m_3051, 1)) != NIL) && ((FLD(FLD(m_3051, 1), 1)) == NIL)) { V mode_3054 = FLD(m_3051, 0); V hex_3055 = FLD(FLD(m_3051, 1), 0); _r = ((d_NativeString_dequal(mode_3054, ((V)&S_594))) != FALSE_V ? d_Tests_dlisting(d_Listing_drender(hex_3055)) : ((d_NativeString_dequal(mode_3054, ((V)&S_595))) != FALSE_V ? io_bind(d_NativeIO_dread(hex_3055), clo_new(lam_3057, 1, 0)) : d_NativeIO_ddie(((V)64u), ((V)&S_596)))); } else if (((m_3051) != NIL) && ((FLD(m_3051, 1)) != NIL) && ((FLD(FLD(m_3051, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3051, 1), 1), 1)) == NIL)) { V mode_3058 = FLD(m_3051, 0); V name_3059 = FLD(FLD(m_3051, 1), 0); V count_3060 = FLD(FLD(FLD(m_3051, 1), 1), 0); _r = ((d_NativeString_dequal(mode_3058, ((V)&S_389))) != FALSE_V ? d_Tests_deffect(d_Asm_ucases_deffect(name_3059, count_3060)) : d_NativeIO_ddie(((V)64u), ((V)&S_593))); } else if (1) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_593)); } else rt_panic("match: no case at tests:1144"); _r; });
}
V d_Tests_dcompact_uhex(V result_3061) {
  return ({ V _r = 0; V m_3062 = result_3061; switch (tag_of(m_3062)) { case 0: { V error_3063 = FLD(m_3062, 0); _r = d_NativeIO_ddie(((V)1u), d_Asm_derror_utext(error_3063)); break; } case 1: { V program_3064 = FLD(m_3062, 0); _r = ((d_NativeString_dequal(d_Asm_dhex(program_3064), ((V)&S_597))) != FALSE_V ? io_pure(UNIT) : d_NativeIO_ddie(((V)1u), ((V)&S_598))); break; } default: rt_panic("match: no case at tests:1156"); } _r; });
}
V d_Tests_dcompact(V message_3065) {
  return ((d_NativeString_dequal(message_3065, ((V)&S_599))) != FALSE_V ? ({ V _c = clo_new(io_3066, 0, 1); CLO_ENV(_c)[0] = message_3065; _c; }) : d_NativeIO_ddie(((V)1u), str_append(((V)&S_600), message_3065)));
}
V d_Tests_dasm_uwitness(V name_3067, V good_3068) {
  return ((good_3068) != FALSE_V ? io_pure(UNIT) : d_NativeIO_dprint(str_concat(CON(((V)&S_601), CON(name_3067, CON(((V)&S_586), NIL))))));
}
V d_Tests_dasm_uaccept(V result_3069) {
  return ({ V _r = 0; V m_3070 = result_3069; if ((tag_of(m_3070) == 0)) { V good_3071 = FLD(m_3070, 0); _r = d_Tests_dasm_uwitness(((V)&S_364), good_3071); } else rt_panic("match: no case at tests:1168"); _r; });
}
V d_Tests_dasm_uwitnesses(void) {
  static V memo; static int done;
  if (!done) { memo = clo_new(io_3072, 0, 0); rt_root(&memo); done = 1; }
  return memo;
}
V d_Tests_dcompact_uwitness(V name_3073, V wide_3074, V narrow_3075) {
  return ((d_Big_dis_ueq(d_Asm_ucompact_dcheck(name_3073, wide_3074, narrow_3075), d_Big_done())) != FALSE_V ? io_pure(UNIT) : d_NativeIO_ddie(((V)1u), str_append(((V)&S_602), name_3073)));
}
V d_Tests_dcompact_uall(void) {
  static V memo; static int done;
  if (!done) { memo = clo_new(io_3076, 0, 0); rt_root(&memo); done = 1; }
  return memo;
}
V d_Tests_demit_uresult(V result_3077) {
  return ({ V _r = 0; V m_3078 = result_3077; switch (tag_of(m_3078)) { case 0: { V message_3079 = FLD(m_3078, 0); _r = ({ V _c = clo_new(io_3080, 0, 1); CLO_ENV(_c)[0] = message_3079; _c; }); break; } case 1: { V message_3081 = FLD(m_3078, 0); _r = d_NativeIO_dstdout(message_3081); break; } default: rt_panic("match: no case at tests:1189"); } _r; });
}
V d_Tests_demit_ucases(V args_3082) {
  return ({ V _r = 0; V m_3083 = args_3082; if (((m_3083) != NIL) && ((FLD(m_3083, 1)) == NIL)) { V mode_3084 = FLD(m_3083, 0); _r = ((d_NativeString_dequal(mode_3084, ((V)&S_607))) != FALSE_V ? d_Tests_demit_uresult(d_Emit_ucases_dconstructors(UNIT)) : ((d_NativeString_dequal(mode_3084, ((V)&S_608))) != FALSE_V ? d_Tests_demit_uresult(d_Emit_ucases_dwords(UNIT)) : ((d_NativeString_dequal(mode_3084, ((V)&S_609))) != FALSE_V ? d_Tests_demit_uresult(d_Emit_ucases_dstorage(UNIT)) : ((d_NativeString_dequal(mode_3084, ((V)&S_610))) != FALSE_V ? d_NativeIO_dstdout(d_Layout_dprint(((V)&S_611), CON(((V)&S_612), CON(((V)&S_206), NIL)))) : d_NativeIO_ddie(((V)64u), ((V)&S_613)))))); } else if (1) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_613)); } else rt_panic("match: no case at tests:1196"); _r; });
}
V d_Tests_dread_uresult(V result_3085) {
  return ({ V _r = 0; V m_3086 = result_3085; switch (tag_of(m_3086)) { case 0: { V error_3087 = FLD(m_3086, 0); _r = d_NativeIO_ddie(((V)1u), error_3087); break; } case 1: { V source_3088 = FLD(m_3086, 0); _r = d_Tests_dunit(((V)&S_614), d_Sl_usurface_dround_utrip(source_3088)); break; } default: rt_panic("match: no case at tests:1204"); } _r; });
}
V d_Tests_droundtrip(V args_3089) {
  return ({ V _r = 0; V m_3090 = args_3089; if (((m_3090) != NIL) && ((FLD(m_3090, 1)) == NIL)) { V path_3091 = FLD(m_3090, 0); _r = io_bind(d_NativeIO_dread(path_3091), clo_new(lam_3093, 1, 0)); } else if (1) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_615)); } else rt_panic("match: no case at tests:1208"); _r; });
}
V d_Tests_ddispatch(V name_3094, V args_3095) {
  return ((d_NativeString_dequal(name_3094, ((V)&S_616))) != FALSE_V ? d_Tests_dcontract_uroute(args_3095) : ((d_NativeString_dequal(name_3094, ((V)&S_617))) != FALSE_V ? d_Tests_dfixture(args_3095) : ((d_NativeString_dequal(name_3094, ((V)&S_618))) != FALSE_V ? d_Tests_done_upaths(d_One_upaths_drun(UNIT)) : ((d_NativeString_dequal(name_3094, ((V)&S_619))) != FALSE_V ? d_Tests_dexport_umu(args_3095) : ((d_NativeString_dequal(name_3094, ((V)&S_620))) != FALSE_V ? d_Tests_dkernel() : ((d_NativeString_dequal(name_3094, ((V)&S_621))) != FALSE_V ? d_Tests_dsurface(d_Sl_usurface_dcases(), NAT_SMALL(0ull)) : ((d_NativeString_dequal(name_3094, ((V)&S_622))) != FALSE_V ? d_Tests_dadapter(d_Abi_ucodec_dmain(CON(((V)&S_622), args_3095))) : ((d_NativeString_dequal(name_3094, ((V)&S_623))) != FALSE_V ? d_Tests_dkeccak(d_Keccak_uvec_ddispatch(CON(((V)&S_623), args_3095))) : ((d_NativeString_dequal(name_3094, ((V)&S_624))) != FALSE_V ? d_NativeIO_dprint(d_Abi_uschema_doutput()) : ((d_NativeString_dequal(name_3094, ((V)&S_625))) != FALSE_V ? d_Tests_dasm_ucases(args_3095) : ((d_NativeString_dequal(name_3094, ((V)&S_626))) != FALSE_V ? d_Tests_dcompact_uall() : ((d_NativeString_dequal(name_3094, ((V)&S_627))) != FALSE_V ? d_Tests_demit_ucases(args_3095) : ((d_NativeString_dequal(name_3094, ((V)&S_628))) != FALSE_V ? d_Tests_droundtrip(args_3095) : d_NativeIO_ddie(((V)64u), ((V)&S_629)))))))))))))));
}
V d_Tests_darguments(V args_3096) {
  return ({ V _r = 0; V m_3097 = args_3096; if (((m_3097) == NIL)) {  _r = NIL; } else if (((m_3097) != NIL)) { V head_3098 = FLD(m_3097, 0); V tail_3099 = FLD(m_3097, 1); _r = CON(head_3098, d_Tests_darguments(tail_3099)); } else rt_panic("match: no case at tests:1227"); _r; });
}
V d_Tests_dmain(V args_3100) {
  return ({ V _r = 0; V m_3101 = args_3100; if (((m_3101) == NIL)) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_630)); } else if (((m_3101) != NIL) && (str_eq_lit(FLD(m_3101, 0), "batch", 5)) && ((FLD(m_3101, 1)) != NIL) && ((FLD(FLD(m_3101, 1), 1)) == NIL)) { V path_3102 = FLD(FLD(m_3101, 1), 0); _r = io_bind(d_NativeIO_dread(path_3102), clo_new(lam_3104, 1, 0)); } else if (((m_3101) != NIL)) { V name_3105 = FLD(m_3101, 0); V rest_3106 = FLD(m_3101, 1); _r = d_Tests_ddispatch(name_3105, rest_3106); } else rt_panic("match: no case at tests:1231"); _r; });
}
V d_Entry_dTests(void) {
  static V memo; static int done;
  if (!done) { memo = io_bind(d_NativeIO_dargs(), clo_new(lam_3108, 1, 0)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Tests_done_upaths(V result_3109) {
  return ({ V _r = 0; V m_3110 = result_3109; if ((tag_of(m_3110) == 0)) { V error_3111 = FLD(m_3110, 0); _r = d_NativeIO_ddie(((V)1u), d_Error_dto_ustring(error_3111)); } else if ((tag_of(m_3110) == 1) && ((FLD(m_3110, 0)) == TRUE_V)) {  _r = d_NativeIO_dprint(((V)&S_631)); } else if ((tag_of(m_3110) == 1) && ((FLD(m_3110, 0)) == FALSE_V)) {  _r = d_NativeIO_ddie(((V)1u), ((V)&S_632)); } else rt_panic("match: no case at tests:1238"); _r; });
}
V d_Fixture_dchecked(V result_3112) {
  return ({ V _r = 0; V m_3113 = result_3112; switch (tag_of(m_3113)) { case 0: { V error_3114 = FLD(m_3113, 0); _r = str_append(((V)&S_633), d_Error_dmessage(error_3114)); break; } case 1: { V rows_3115 = FLD(m_3113, 0); _r = str_append(((V)&S_634), d_Elab_dchecked_uform(rows_3115)); break; } default: rt_panic("match: no case at tests:1244"); } _r; });
}
V d_Fixture_derased(V result_3116) {
  return ({ V _r = 0; V m_3117 = result_3116; switch (tag_of(m_3117)) { case 0: { V error_3118 = FLD(m_3117, 0); _r = str_append(((V)&S_633), d_Error_dmessage(error_3118)); break; } case 1: { V rows_3119 = FLD(m_3117, 0); _r = str_append(((V)&S_634), d_Erase_dprint(rows_3119)); break; } default: rt_panic("match: no case at tests:1248"); } _r; });
}
V d_Fixture_derase(V result_3120) {
  return ({ V _r = 0; V m_3121 = result_3120; if ((tag_of(m_3121) == 0)) { V error_3122 = FLD(m_3121, 0); _r = str_append(((V)&S_635), d_Error_dmessage(error_3122)); } else if ((tag_of(m_3121) == 1) && (tag_of(FLD(m_3121, 0)) == 0)) { V globals_3123 = FLD(FLD(m_3121, 0), 0); V rows_3124 = FLD(FLD(m_3121, 0), 1); _r = d_Fixture_derased(d_Erase_dprogram(NONE, globals_3123, rows_3124)); } else rt_panic("match: no case at tests:1252"); _r; });
}
V d_Fixture_drun(V mode_3125, V source_3126) {
  return ((d_NativeString_dequal(mode_3125, ((V)&S_636))) != FALSE_V ? d_NativeIO_dstdout(d_Fixture_dchecked(d_Elab_dcheck_utext(NONE, d_Global_dinitial(), source_3126))) : ((d_NativeString_dequal(mode_3125, ((V)&S_637))) != FALSE_V ? d_NativeIO_dstdout(d_Fixture_derase(d_Elab_dcheck_uin(NONE, d_Global_dinitial(), source_3126))) : d_NativeIO_ddie(((V)64u), ((V)&S_638))));
}
V d_Fixture_dread(V mode_3127, V result_3128) {
  return ({ V _r = 0; V m_3129 = result_3128; switch (tag_of(m_3129)) { case 0: { V error_3130 = FLD(m_3129, 0); _r = d_NativeIO_ddie(((V)1u), error_3130); break; } case 1: { V source_3131 = FLD(m_3129, 0); _r = d_Fixture_drun(mode_3127, source_3131); break; } default: rt_panic("match: no case at tests:1261"); } _r; });
}
V d_Tests_dfixture(V args_3132) {
  return ({ V _r = 0; V m_3133 = args_3132; if (((m_3133) != NIL) && ((FLD(m_3133, 1)) != NIL) && ((FLD(FLD(m_3133, 1), 1)) == NIL)) { V mode_3134 = FLD(m_3133, 0); V path_3135 = FLD(FLD(m_3133, 1), 0); _r = io_bind(d_NativeIO_dread(path_3135), ({ V _c = clo_new(lam_3137, 1, 1); CLO_ENV(_c)[0] = mode_3134; _c; })); } else if (1) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_638)); } else rt_panic("match: no case at tests:1265"); _r; });
}
V d_Fixture_dbatch_uroundtrip(V result_3138) {
  return ({ V _r = 0; V m_3139 = result_3138; switch (tag_of(m_3139)) { case 1: {  _r = ((V)&S_639); break; } case 0: { V message_3140 = FLD(m_3139, 0); _r = str_append(((V)&S_640), message_3140); break; } default: rt_panic("match: no case at tests:1270"); } _r; });
}
V d_Fixture_dbatch_uoutput(V mode_3141, V source_3142) {
  return ((d_NativeString_dequal(mode_3141, ((V)&S_641))) != FALSE_V ? d_Fixture_dbatch_uroundtrip(d_Sl_usurface_dround_utrip(source_3142)) : ((d_NativeString_dequal(mode_3141, ((V)&S_636))) != FALSE_V ? d_Fixture_dchecked(d_Elab_dcheck_utext(NONE, d_Global_dinitial(), source_3142)) : ((d_NativeString_dequal(mode_3141, ((V)&S_637))) != FALSE_V ? d_Fixture_derase(d_Elab_dcheck_uin(NONE, d_Global_dinitial(), source_3142)) : ((V)&S_642))));
}
V d_Fixture_dbatch_uemit(V rest_3143, V text_3144) {
  return ({ V _c = clo_new(io_3145, 0, 2); CLO_ENV(_c)[0] = text_3144; CLO_ENV(_c)[1] = rest_3143; _c; });
}
V d_Fixture_dbatch_ureceived(V mode_3146, V rest_3147, V result_3148) {
  return ({ V _r = 0; V m_3149 = result_3148; switch (tag_of(m_3149)) { case 0: { V error_3150 = FLD(m_3149, 0); _r = d_NativeIO_ddie(((V)1u), error_3150); break; } case 1: { V source_3151 = FLD(m_3149, 0); _r = d_Fixture_dbatch_uemit(rest_3147, d_Fixture_dbatch_uoutput(mode_3146, source_3151)); break; } default: rt_panic("match: no case at tests:1285"); } _r; });
}
V d_Fixture_dbatch(V fields_3152) {
  return ({ V _r = 0; V m_3153 = fields_3152; if (((m_3153) == NIL)) {  _r = io_pure(UNIT); } else if (((m_3153) != NIL) && (str_eq_lit(FLD(m_3153, 0), "", 0)) && ((FLD(m_3153, 1)) == NIL)) {  _r = io_pure(UNIT); } else if (((m_3153) != NIL) && ((FLD(m_3153, 1)) != NIL)) { V mode_3154 = FLD(m_3153, 0); V path_3155 = FLD(FLD(m_3153, 1), 0); V rest_3156 = FLD(FLD(m_3153, 1), 1); _r = io_bind(d_NativeIO_dread(path_3155), ({ V _c = clo_new(lam_3158, 1, 2); CLO_ENV(_c)[0] = mode_3154; CLO_ENV(_c)[1] = rest_3156; _c; })); } else if (1) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_643)); } else rt_panic("match: no case at tests:1290"); _r; });
}
V d_Fixture_dbatch_umanifest(V result_3159) {
  return ({ V _r = 0; V m_3160 = result_3159; switch (tag_of(m_3160)) { case 0: { V error_3161 = FLD(m_3160, 0); _r = d_NativeIO_ddie(((V)1u), error_3161); break; } case 1: { V text_3162 = FLD(m_3160, 0); _r = d_Fixture_dbatch(d_NativeString_dsplit((((V)0u)), text_3162)); break; } default: rt_panic("match: no case at tests:1296"); } _r; });
}
V d_Tests_dexport_uoutput(V result_3163) {
  return ({ V _r = 0; V m_3164 = result_3163; switch (tag_of(m_3164)) { case 0: { V error_3165 = FLD(m_3164, 0); _r = d_NativeIO_ddie(((V)1u), error_3165); break; } case 1: { V text_3166 = FLD(m_3164, 0); _r = d_NativeIO_dstdout(text_3166); break; } default: rt_panic("match: no case at tests:1301"); } _r; });
}
V d_Tests_dexport_uread(V exporter_3167, V path_3168, V result_3169) {
  return ({ V _r = 0; V m_3170 = result_3169; switch (tag_of(m_3170)) { case 0: {  _r = d_NativeIO_ddie(((V)1u), str_append(((V)&S_644), path_3168)); break; } case 1: { V source_3171 = FLD(m_3170, 0); _r = d_Tests_dexport_uoutput(ap(exporter_3167, source_3171)); break; } default: rt_panic("match: no case at tests:1305"); } _r; });
}
V d_Tests_dexport_ufile(V exporter_3172, V path_3173) {
  return ({ V _c = clo_new(io_3178, 0, 2); CLO_ENV(_c)[0] = path_3173; CLO_ENV(_c)[1] = exporter_3172; _c; });
}
V d_Tests_dexport_uusage(void) {
  static V memo; static int done;
  if (!done) { memo = d_NativeIO_ddie(((V)1u), ((V)&S_645)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Tests_dexport_umu(V args_3179) {
  return ({ V _r = 0; V m_3180 = args_3179; if (((m_3180) != NIL) && ((FLD(m_3180, 1)) == NIL)) { V path_3181 = FLD(m_3180, 0); _r = ((((d_NativeString_dequal(path_3181, ((V)&S_646))) | (((d_NativeString_dequal(path_3181, ((V)&S_647))) | (d_NativeString_dequal(path_3181, ((V)&S_648))))))) != FALSE_V ? d_Tests_dexport_uusage() : d_Tests_dexport_ufile(clo_new(lam_3183, 1, 0), path_3181)); } else if (((m_3180) != NIL) && ((FLD(m_3180, 1)) != NIL) && ((FLD(FLD(m_3180, 1), 1)) == NIL)) { V mode_3184 = FLD(m_3180, 0); V path_3185 = FLD(FLD(m_3180, 1), 0); _r = ((d_NativeString_dequal(mode_3184, ((V)&S_646))) != FALSE_V ? d_Tests_dexport_ufile(clo_new(lam_3187, 1, 0), path_3185) : ((d_NativeString_dequal(mode_3184, ((V)&S_647))) != FALSE_V ? d_Tests_dexport_ufile(clo_new(lam_3189, 1, 0), path_3185) : d_Tests_dexport_uusage())); } else if (((m_3180) != NIL) && ((FLD(m_3180, 1)) != NIL) && ((FLD(FLD(m_3180, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3180, 1), 1), 1)) == NIL)) { V mode_3190 = FLD(m_3180, 0); V family_3191 = FLD(FLD(m_3180, 1), 0); V path_3192 = FLD(FLD(FLD(m_3180, 1), 1), 0); _r = ((d_NativeString_dequal(mode_3190, ((V)&S_648))) != FALSE_V ? d_Tests_dexport_ufile(({ V _c = clo_new(lam_3194, 1, 1); CLO_ENV(_c)[0] = family_3191; _c; }), path_3192) : d_Tests_dexport_uusage()); } else if (1) {  _r = d_Tests_dexport_uusage(); } else rt_panic("match: no case at tests:1316"); _r; });
}
V d_TestPerf_dmeasure(V inputs_3195, V route_3196) {
  return testperf_measure(inputs_3195, route_3196);
}
V d_Tests_dlarge_utext(V text_3197, V count_3198) {
_top: ;
  return ({ V _r = 0; V m_3199 = count_3198; if ((nat_cmp(m_3199, NAT_SMALL(0ull)) == 0)) {  _r = text_3197; } else if ((nat_cmp(m_3199, NAT_SMALL(1ull)) >= 0)) { V rest_3200 = nat_sub(m_3199, NAT_SMALL(1ull)); _r = ({ V a_3201 = str_append(text_3197, text_3197); V a_3202 = rest_3200; text_3197 = a_3201; count_3198 = a_3202;  goto _top; (V)0; }); } else rt_panic("match: no case at tests:1334"); _r; });
}
V d_Tests_droute_uresult(V source_3203, V result_3204) {
  return ({ V _r = 0; V m_3205 = result_3204; if ((tag_of(m_3205) == 0)) {  _r = rt_ctor4(0, FALSE_V, source_3203, source_3203, NIL); } else if ((tag_of(m_3205) == 1) && (tag_of(FLD(m_3205, 0)) == 0) && ((FLD(FLD(m_3205, 0), 0)) == NONE)) { V output_3206 = FLD(FLD(m_3205, 0), 1); _r = rt_ctor4(0, TRUE_V, source_3203, output_3206, NIL); } else if ((tag_of(m_3205) == 1) && (tag_of(FLD(m_3205, 0)) == 0) && ((FLD(FLD(m_3205, 0), 0)) != NONE)) { V output_3207 = FLD(FLD(m_3205, 0), 1); _r = rt_ctor4(0, FALSE_V, source_3203, output_3207, NIL); } else rt_panic("match: no case at tests:1339"); _r; });
}
V d_Tests_droute(V source_3208) {
  return d_Tests_droute_uresult(source_3208, d_Contract_dlower(source_3208));
}
V d_Tests_droute_umeasurement(V result_3209) {
  return ({ V _r = 0; V m_3210 = result_3209; if ((tag_of(m_3210) == 0)) { V ok_3211 = FLD(m_3210, 0); V bytes_3212 = FLD(m_3210, 1); _r = ((((ok_3211) & (((V)((bytes_3212) < (((V)131072u))))))) != FALSE_V ? d_NativeIO_dprint(str_append(((V)&S_649), str_append(u32_show(bytes_3212), ((V)&S_650)))) : d_NativeIO_ddie(((V)1u), str_append(((V)&S_651), u32_show(bytes_3212)))); } else rt_panic("match: no case at tests:1347"); _r; });
}
V d_Tests_droute_ucopy(V source_3213) {
  return d_Tests_droute_uresult(source_3213, d_Contract_dlower(str_append(source_3213, SNIL)));
}
V d_Tests_dallocated_uobservation(V observed_3214, V allocation_3215) {
  return ({ V _r = 0; V m_3216 = observed_3214; if ((tag_of(m_3216) == 0)) { V ok_3217 = FLD(m_3216, 0); V source_3218 = FLD(m_3216, 1); V output_3219 = FLD(m_3216, 2); _r = rt_ctor4(0, ok_3217, source_3218, output_3219, allocation_3215); } else rt_panic("match: no case at tests:1355"); _r; });
}
V d_Tests_droute_uallocate(V source_3220) {
  return d_Tests_dallocated_uobservation(d_Tests_droute(source_3220), list_replicate(NAT_SMALL(10000ull), source_3220));
}
V d_Tests_droute_uprobe(V route_3221) {
  return ({ V _c = clo_new(io_3224, 0, 1); CLO_ENV(_c)[0] = route_3221; _c; });
}
V d_Tests_dcontract_uroute(V args_3225) {
  return ({ V _r = 0; V m_3226 = args_3225; if (((m_3226) == NIL)) {  _r = d_Tests_droute_uprobe(clo_new(lam_3228, 1, 0)); } else if (((m_3226) != NIL) && ((FLD(m_3226, 1)) == NIL)) { V mode_3229 = FLD(m_3226, 0); _r = ((d_NativeString_dequal(mode_3229, ((V)&S_560))) != FALSE_V ? d_Tests_droute_uprobe(clo_new(lam_3231, 1, 0)) : ((d_NativeString_dequal(mode_3229, ((V)&S_654))) != FALSE_V ? d_Tests_droute_uprobe(clo_new(lam_3233, 1, 0)) : d_NativeIO_ddie(((V)64u), ((V)&S_655)))); } else if (1) {  _r = d_NativeIO_ddie(((V)64u), ((V)&S_655)); } else rt_panic("match: no case at tests:1369"); _r; });
}
V d_Packed_ulayout_derror(V error_3234) {
  return ({ V _r = 0; V m_3235 = error_3234; switch (tag_of(m_3235)) { case 0: {  _r = ((V)&S_656); break; } case 1: {  _r = ((V)&S_657); break; } case 2: { V name_3236 = FLD(m_3235, 0); _r = str_append(((V)&S_658), name_3236); break; } case 3: {  _r = ((V)&S_659); break; } case 4: {  _r = ((V)&S_660); break; } case 5: { V typ_3237 = FLD(m_3235, 0); _r = str_append(((V)&S_661), d_Abi_dSchema_dtype_uname(typ_3237)); break; } default: rt_panic("match: no case at tests:1377"); } _r; });
}
V d_Packed_ulayout_dshow(V result_3238) {
  return ({ V _r = 0; V m_3239 = result_3238; switch (tag_of(m_3239)) { case 1: { V value_3240 = FLD(m_3239, 0); _r = str_append(((V)&S_158), d_Big_dshow(value_3240)); break; } case 0: { V error_3241 = FLD(m_3239, 0); _r = str_append(((V)&S_662), d_Packed_ulayout_derror(error_3241)); break; } default: rt_panic("match: no case at tests:1385"); } _r; });
}
V d_Packed_ulayout_dparams(V types_3242, V names_3243) {
  return ({ V _r = 0; V m_3244 = types_3242; V m_3245 = names_3243; if (((m_3244) == NIL) && ((m_3245) == NIL)) {  _r = DONE(NIL); } else if (((m_3244) != NIL) && ((m_3245) != NIL)) { V typ_3246 = FLD(m_3244, 0); V ts_3247 = FLD(m_3244, 1); V name_3248 = FLD(m_3245, 0); V ns_3249 = FLD(m_3245, 1); _r = d_StringResult_dbind(d_Packed_ulayout_dparams(ts_3247, ns_3249), ({ V _c = clo_new(lam_3251, 1, 2); CLO_ENV(_c)[0] = name_3248; CLO_ENV(_c)[1] = typ_3246; _c; })); } else if (((m_3244) == NIL) && ((m_3245) != NIL)) {  _r = FAIL(((V)&S_150)); } else if (((m_3244) != NIL) && ((m_3245) == NIL)) {  _r = FAIL(((V)&S_150)); } else rt_panic("match: no case at tests:1390"); _r; });
}
V d_Packed_ulayout_dnumbers(V values_3252) {
  return ({ V _r = 0; V m_3253 = values_3252; if (((m_3253) == NIL)) {  _r = DONE(NIL); } else if (((m_3253) != NIL)) { V value_3254 = FLD(m_3253, 0); V tail_3255 = FLD(m_3253, 1); _r = d_StringResult_dbind(d_Abi_ucodec_dnumber(value_3254), ({ V _c = clo_new(lam_3259, 1, 1); CLO_ENV(_c)[0] = tail_3255; _c; })); } else rt_panic("match: no case at tests:1398"); _r; });
}
V d_Packed_ulayout_daccess(V command_3260, V types_3261, V values_3262) {
  return ({ V _r = 0; V m_3263 = types_3261; if (((m_3263) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3263) != NIL)) { V typ_3264 = FLD(m_3263, 0); V rest_3265 = FLD(m_3263, 1); _r = d_Packed_ulayout_dscalar(command_3260, typ_3264, rest_3265, values_3262); } else rt_panic("match: no case at tests:1405"); _r; });
}
V d_Packed_ulayout_dscalar(V command_3266, V typ_3267, V rest_3268, V values_3269) {
  return ({ V _r = 0; V m_3270 = rest_3268; if (((m_3270) == NIL)) {  _r = d_Packed_ulayout_daccess_unumbers(command_3266, typ_3267, values_3269); } else if (((m_3270) != NIL)) {  _r = FAIL(((V)&S_160)); } else rt_panic("match: no case at tests:1410"); _r; });
}
V d_Packed_ulayout_daccess_unumbers(V command_3271, V typ_3272, V values_3273) {
  return ({ V _r = 0; V m_3274 = values_3273; if (((m_3274) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3274) != NIL) && ((FLD(m_3274, 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3274) != NIL) && ((FLD(m_3274, 1)) != NIL) && ((FLD(FLD(m_3274, 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3274) != NIL) && ((FLD(m_3274, 1)) != NIL) && ((FLD(FLD(m_3274, 1), 1)) != NIL)) { V offset_3275 = FLD(m_3274, 0); V slot_3276 = FLD(FLD(m_3274, 1), 0); V word_3277 = FLD(FLD(FLD(m_3274, 1), 1), 0); V tail_3278 = FLD(FLD(FLD(m_3274, 1), 1), 1); _r = ((d_Abi_dCodec_dwithin(d_Big_dof_unat(NAT_SMALL(48ull)), offset_3275)) != FALSE_V ? d_Packed_ulayout_daccess_uvalid(command_3271, typ_3272, d_Big_dto_unat(offset_3275), slot_3276, word_3277, tail_3278) : DONE(((V)&S_663))); } else rt_panic("match: no case at tests:1415"); _r; });
}
V d_Packed_ulayout_daccess_uvalid(V command_3279, V typ_3280, V offset_3281, V slot_3282, V word_3283, V tail_3284) {
  return d_Packed_ulayout_daccess_ufield(command_3279, rt_ctor4(0, ((V)&S_664), typ_3280, slot_3282, offset_3281), word_3283, tail_3284);
}
V d_Packed_ulayout_daccess_ufield(V command_3285, V field_3286, V word_3287, V tail_3288) {
  return ({ V _r = 0; V m_3289 = tail_3288; if (((m_3289) == NIL)) {  _r = ((d_NativeString_dequal(command_3285, ((V)&S_222))) != FALSE_V ? DONE(d_Packed_ulayout_dshow(d_Layout_dPacked_dread(field_3286, word_3287))) : FAIL(((V)&S_160))); } else if (((m_3289) != NIL) && ((FLD(m_3289, 1)) == NIL)) { V value_3290 = FLD(m_3289, 0); _r = ((d_NativeString_dequal(command_3285, ((V)&S_204))) != FALSE_V ? DONE(d_Packed_ulayout_dshow(d_Layout_dPacked_dwrite(field_3286, word_3287, value_3290))) : FAIL(((V)&S_160))); } else if (((m_3289) != NIL) && ((FLD(m_3289, 1)) != NIL)) {  _r = FAIL(((V)&S_160)); } else rt_panic("match: no case at tests:1426"); _r; });
}
V d_Packed_ulayout_dprint_uresult(V result_3291) {
  return ({ V _r = 0; V m_3292 = result_3291; switch (tag_of(m_3292)) { case 1: { V json_3293 = FLD(m_3292, 0); _r = DONE(json_3293); break; } case 0: { V error_3294 = FLD(m_3292, 0); _r = DONE(str_append(((V)&S_662), d_Packed_ulayout_derror(error_3294))); break; } default: rt_panic("match: no case at tests:1431"); } _r; });
}
V d_Packed_ulayout_dschema_utypes(V contract_3295, V names_3296, V types_3297) {
  return ({ V bare_3298 = ((V)((types_3297) == NIL)); ({ V labels_3299 = ((d_NativeString_dequal(names_3296, SNIL)) != FALSE_V ? ((bare_3298) != FALSE_V ? NIL : CON(SNIL, NIL)) : d_NativeString_dsplit((((V)44u)), names_3296)); d_StringResult_dbind(d_Packed_ulayout_dparams(types_3297, labels_3299), ({ V _c = clo_new(lam_3301, 1, 1); CLO_ENV(_c)[0] = contract_3295; _c; })); }); });
}
V d_Packed_ulayout_dschema(V contract_3302, V types_3303, V rest_3304) {
  return ({ V _r = 0; V m_3305 = rest_3304; if (((m_3305) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3305) != NIL) && ((FLD(m_3305, 1)) == NIL)) { V names_3306 = FLD(m_3305, 0); _r = d_StringResult_dbind(d_Abi_ucodec_dtypes(types_3303), ({ V _c = clo_new(lam_3308, 1, 2); CLO_ENV(_c)[0] = contract_3302; CLO_ENV(_c)[1] = names_3306; _c; })); } else if (((m_3305) != NIL) && ((FLD(m_3305, 1)) != NIL)) {  _r = FAIL(((V)&S_160)); } else rt_panic("match: no case at tests:1441"); _r; });
}
V d_Packed_ulayout_dquery(V parts_3309) {
  return ({ V _r = 0; V m_3310 = parts_3309; if (((m_3310) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3310) != NIL) && ((FLD(m_3310, 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3310) != NIL) && ((FLD(m_3310, 1)) != NIL) && ((FLD(FLD(m_3310, 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3310) != NIL) && ((FLD(m_3310, 1)) != NIL) && ((FLD(FLD(m_3310, 1), 1)) != NIL)) { V command_3311 = FLD(m_3310, 0); V first_3312 = FLD(FLD(m_3310, 1), 0); V second_3313 = FLD(FLD(FLD(m_3310, 1), 1), 0); V rest_3314 = FLD(FLD(FLD(m_3310, 1), 1), 1); _r = ((d_NativeString_dequal(command_3311, ((V)&S_610))) != FALSE_V ? d_Packed_ulayout_dschema(first_3312, second_3313, rest_3314) : d_StringResult_dbind(d_Abi_ucodec_dtypes(first_3312), ({ V _c = clo_new(lam_3318, 1, 3); CLO_ENV(_c)[0] = second_3313; CLO_ENV(_c)[1] = rest_3314; CLO_ENV(_c)[2] = command_3311; _c; }))); } else rt_panic("match: no case at tests:1447"); _r; });
}
V d_Packed_ulayout_djoin(V row_3319, V tail_3320) {
  return ({ V _r = 0; V m_3321 = tail_3320; if (((m_3321) == NIL)) {  _r = DONE(row_3319); } else if (((m_3321) != NIL)) { V head_3322 = FLD(m_3321, 0); V rest_3323 = FLD(m_3321, 1); _r = d_StringResult_dbind(d_Packed_ulayout_dmain(CON(head_3322, rest_3323)), ({ V _c = clo_new(lam_3325, 1, 1); CLO_ENV(_c)[0] = row_3319; _c; })); } else rt_panic("match: no case at tests:1457"); _r; });
}
V d_Packed_ulayout_dmain(V args_3326) {
  return ({ V _r = 0; V m_3327 = args_3326; if (((m_3327) == NIL)) {  _r = DONE(SNIL); } else if (((m_3327) != NIL)) { V query_3328 = FLD(m_3327, 0); V tail_3329 = FLD(m_3327, 1); _r = d_StringResult_dbind(d_Packed_ulayout_dquery(d_NativeString_dsplit((((V)124u)), query_3328)), ({ V _c = clo_new(lam_3331, 1, 1); CLO_ENV(_c)[0] = tail_3329; _c; })); } else rt_panic("match: no case at tests:1462"); _r; });
}
V d_Mapping_ulayout_derror(V error_3332) {
  return ({ V _r = 0; V m_3333 = error_3332; switch (tag_of(m_3333)) { case 0: {  _r = ((V)&S_665); break; } case 1: {  _r = ((V)&S_666); break; } case 2: { V typ_3334 = FLD(m_3333, 0); _r = str_append(((V)&S_661), d_Abi_dSchema_dtype_uname(typ_3334)); break; } case 3: {  _r = ((V)&S_667); break; } default: rt_panic("match: no case at tests:1467"); } _r; });
}
V d_Mapping_ulayout_dshow(V result_3335) {
  return ({ V _r = 0; V m_3336 = result_3335; switch (tag_of(m_3336)) { case 1: { V value_3337 = FLD(m_3336, 0); _r = str_append(((V)&S_158), d_Big_dshow(value_3337)); break; } case 0: { V error_3338 = FLD(m_3336, 0); _r = str_append(((V)&S_662), d_Mapping_ulayout_derror(error_3338)); break; } default: rt_panic("match: no case at tests:1473"); } _r; });
}
V d_Mapping_ulayout_dkeys(V types_3339, V values_3340) {
  return ({ V _r = 0; V m_3341 = types_3339; V m_3342 = values_3340; if (((m_3341) == NIL) && ((m_3342) == NIL)) {  _r = DONE(NIL); } else if (((m_3341) == NIL) && ((m_3342) != NIL)) {  _r = FAIL(((V)&S_150)); } else if (((m_3341) != NIL) && ((m_3342) == NIL)) {  _r = FAIL(((V)&S_150)); } else if (((m_3341) != NIL) && ((m_3342) != NIL)) { V typ_3343 = FLD(m_3341, 0); V types_tail_3344 = FLD(m_3341, 1); V text_3345 = FLD(m_3342, 0); V values_tail_3346 = FLD(m_3342, 1); _r = d_StringResult_dbind(d_Abi_ucodec_dnumber(text_3345), ({ V _c = clo_new(lam_3350, 1, 3); CLO_ENV(_c)[0] = types_tail_3344; CLO_ENV(_c)[1] = values_tail_3346; CLO_ENV(_c)[2] = typ_3343; _c; })); } else rt_panic("match: no case at tests:1478"); _r; });
}
V d_Mapping_ulayout_dsingle(V base_3351, V keys_3352) {
  return ({ V _r = 0; V m_3353 = keys_3352; if (((m_3353) != NIL) && ((FLD(m_3353, 1)) == NIL)) { V key_3354 = FLD(m_3353, 0); _r = DONE(d_Mapping_ulayout_dshow(d_Layout_dMapping_dslot(base_3351, key_3354))); } else if (((m_3353) == NIL)) {  _r = FAIL(((V)&S_150)); } else if (((m_3353) != NIL) && ((FLD(m_3353, 1)) != NIL)) {  _r = FAIL(((V)&S_150)); } else rt_panic("match: no case at tests:1486"); _r; });
}
V d_Mapping_ulayout_ddispatch(V command_3355, V base_3356, V keys_3357) {
  return ((d_NativeString_dequal(command_3355, ((V)&S_668))) != FALSE_V ? d_Mapping_ulayout_dsingle(base_3356, keys_3357) : ((d_NativeString_dequal(command_3355, ((V)&S_669))) != FALSE_V ? DONE(d_Mapping_ulayout_dshow(d_Layout_dMapping_dpath(base_3356, keys_3357))) : FAIL(((V)&S_160))));
}
V d_Mapping_ulayout_dtypes(V text_3358) {
  return ((d_NativeString_dequal(text_3358, SNIL)) != FALSE_V ? DONE(NIL) : d_Abi_ucodec_dtypes(text_3358));
}
V d_Mapping_ulayout_dquery(V parts_3359) {
  return ({ V _r = 0; V m_3360 = parts_3359; if (((m_3360) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3360) != NIL) && ((FLD(m_3360, 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3360) != NIL) && ((FLD(m_3360, 1)) != NIL) && ((FLD(FLD(m_3360, 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3360) != NIL) && ((FLD(m_3360, 1)) != NIL) && ((FLD(FLD(m_3360, 1), 1)) != NIL)) { V command_3361 = FLD(m_3360, 0); V types_3362 = FLD(FLD(m_3360, 1), 0); V base_3363 = FLD(FLD(FLD(m_3360, 1), 1), 0); V values_3364 = FLD(FLD(FLD(m_3360, 1), 1), 1); _r = d_StringResult_dbind(d_Abi_ucodec_dnumber(base_3363), ({ V _c = clo_new(lam_3370, 1, 3); CLO_ENV(_c)[0] = types_3362; CLO_ENV(_c)[1] = values_3364; CLO_ENV(_c)[2] = command_3361; _c; })); } else rt_panic("match: no case at tests:1497"); _r; });
}
V d_Mapping_ulayout_djoin(V row_3371, V tail_3372) {
  return ({ V _r = 0; V m_3373 = tail_3372; if (((m_3373) == NIL)) {  _r = DONE(row_3371); } else if (((m_3373) != NIL)) { V head_3374 = FLD(m_3373, 0); V rest_3375 = FLD(m_3373, 1); _r = d_StringResult_dbind(d_Mapping_ulayout_dmain(CON(head_3374, rest_3375)), ({ V _c = clo_new(lam_3377, 1, 1); CLO_ENV(_c)[0] = row_3371; _c; })); } else rt_panic("match: no case at tests:1507"); _r; });
}
V d_Mapping_ulayout_dmain(V args_3378) {
  return ({ V _r = 0; V m_3379 = args_3378; if (((m_3379) == NIL)) {  _r = DONE(SNIL); } else if (((m_3379) != NIL)) { V query_3380 = FLD(m_3379, 0); V tail_3381 = FLD(m_3379, 1); _r = d_StringResult_dbind(d_Mapping_ulayout_dquery(d_NativeString_dsplit((((V)124u)), query_3380)), ({ V _c = clo_new(lam_3383, 1, 1); CLO_ENV(_c)[0] = tail_3381; _c; })); } else rt_panic("match: no case at tests:1512"); _r; });
}
V d_Event_ucodec_derror(V error_3384) {
  return ({ V _r = 0; V m_3385 = error_3384; switch (tag_of(m_3385)) { case 0: {  _r = ((V)&S_670); break; } case 1: {  _r = ((V)&S_671); break; } case 2: {  _r = ((V)&S_672); break; } case 3: { V error_3386 = FLD(m_3385, 0); _r = d_Abi_ucodec_derror(error_3386); break; } default: rt_panic("match: no case at tests:1516"); } _r; });
}
V d_Event_ucodec_dshow(V result_3387) {
  return ({ V _r = 0; V m_3388 = result_3387; if ((tag_of(m_3388) == 0)) { V error_3389 = FLD(m_3388, 0); _r = str_append(((V)&S_662), d_Event_ucodec_derror(error_3389)); } else if ((tag_of(m_3388) == 1) && (tag_of(FLD(m_3388, 0)) == 0)) { V topics_3390 = FLD(FLD(m_3388, 0), 0); V data_3391 = FLD(FLD(m_3388, 0), 1); _r = str_concat(CON(((V)&S_158), CON(str_join(d_SeqList_dmap(clo_new(w_Abi_ucodec_dhex, 1, 0), topics_3390), ((V)&S_164)), CON(((V)&S_673), CON(d_Abi_ucodec_dhex(data_3391), NIL))))); } else rt_panic("match: no case at tests:1523"); _r; });
}
V d_Event_ucodec_dflag(V text_3392) {
  return ((d_NativeString_dequal(text_3392, ((V)&S_674))) != FALSE_V ? DONE(TRUE_V) : ((d_NativeString_dequal(text_3392, ((V)&S_344))) != FALSE_V ? DONE(FALSE_V) : FAIL(((V)&S_675))));
}
V d_Event_ucodec_dparameters(V types_3393, V flags_3394) {
  return ({ V _r = 0; V m_3395 = types_3393; V m_3396 = flags_3394; if (((m_3395) == NIL) && ((m_3396) == NIL)) {  _r = DONE(NIL); } else if (((m_3395) == NIL) && ((m_3396) != NIL)) {  _r = FAIL(((V)&S_150)); } else if (((m_3395) != NIL) && ((m_3396) == NIL)) {  _r = FAIL(((V)&S_150)); } else if (((m_3395) != NIL) && ((m_3396) != NIL)) { V typ_3397 = FLD(m_3395, 0); V ts_3398 = FLD(m_3395, 1); V flag_3399 = FLD(m_3396, 0); V fs_3400 = FLD(m_3396, 1); _r = d_StringResult_dbind(d_Event_ucodec_dflag(flag_3399), ({ V _c = clo_new(lam_3404, 1, 3); CLO_ENV(_c)[0] = ts_3398; CLO_ENV(_c)[1] = fs_3400; CLO_ENV(_c)[2] = typ_3397; _c; })); } else rt_panic("match: no case at tests:1532"); _r; });
}
V d_Event_ucodec_dflags(V text_3405) {
  return ((d_NativeString_dequal(text_3405, SNIL)) != FALSE_V ? NIL : d_NativeString_dsplit((((V)44u)), text_3405));
}
V d_Event_ucodec_dquery(V parts_3406) {
  return ({ V _r = 0; V m_3407 = parts_3406; if (((m_3407) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3407) != NIL) && ((FLD(m_3407, 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3407) != NIL) && ((FLD(m_3407, 1)) != NIL) && ((FLD(FLD(m_3407, 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3407) != NIL) && ((FLD(m_3407, 1)) != NIL) && ((FLD(FLD(m_3407, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3407, 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3407) != NIL) && ((FLD(m_3407, 1)) != NIL) && ((FLD(FLD(m_3407, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3407, 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(m_3407, 1), 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3407) != NIL) && ((FLD(m_3407, 1)) != NIL) && ((FLD(FLD(m_3407, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3407, 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(m_3407, 1), 1), 1), 1)) != NIL)) { V name_3408 = FLD(m_3407, 0); V anonymous_3409 = FLD(FLD(m_3407, 1), 0); V types_3410 = FLD(FLD(FLD(m_3407, 1), 1), 0); V flags_3411 = FLD(FLD(FLD(FLD(m_3407, 1), 1), 1), 0); V value_types_3412 = FLD(FLD(FLD(FLD(FLD(m_3407, 1), 1), 1), 1), 0); V args_3413 = FLD(FLD(FLD(FLD(FLD(m_3407, 1), 1), 1), 1), 1); _r = d_StringResult_dbind(d_Event_ucodec_dflag(anonymous_3409), ({ V _c = clo_new(lam_3423, 1, 5); CLO_ENV(_c)[0] = types_3410; CLO_ENV(_c)[1] = flags_3411; CLO_ENV(_c)[2] = value_types_3412; CLO_ENV(_c)[3] = args_3413; CLO_ENV(_c)[4] = name_3408; _c; })); } else rt_panic("match: no case at tests:1543"); _r; });
}
V d_Event_ucodec_dmain(V args_3424) {
  return ({ V _r = 0; V m_3425 = args_3424; if (((m_3425) == NIL)) {  _r = DONE(SNIL); } else if (((m_3425) != NIL)) { V query_3426 = FLD(m_3425, 0); V tail_3427 = FLD(m_3425, 1); _r = d_StringResult_dbind(d_Event_ucodec_dquery(d_NativeString_dsplit((((V)124u)), query_3426)), ({ V _c = clo_new(lam_3429, 1, 1); CLO_ENV(_c)[0] = tail_3427; _c; })); } else rt_panic("match: no case at tests:1557"); _r; });
}
V d_Event_ucodec_djoin(V row_3430, V tail_3431) {
  return ({ V _r = 0; V m_3432 = tail_3431; if (((m_3432) == NIL)) {  _r = DONE(row_3430); } else if (((m_3432) != NIL)) { V head_3433 = FLD(m_3432, 0); V rest_3434 = FLD(m_3432, 1); _r = d_StringResult_dbind(d_Event_ucodec_dmain(CON(head_3433, rest_3434)), ({ V _c = clo_new(lam_3436, 1, 1); CLO_ENV(_c)[0] = row_3430; _c; })); } else rt_panic("match: no case at tests:1563"); _r; });
}
V d_Call_ucodec_derror(V error_3437) {
  return ({ V _r = 0; V m_3438 = error_3437; switch (tag_of(m_3438)) { case 0: {  _r = ((V)&S_676); break; } case 1: {  _r = ((V)&S_677); break; } case 2: {  _r = ((V)&S_678); break; } case 3: {  _r = ((V)&S_679); break; } case 4: { V error_3439 = FLD(m_3438, 0); _r = d_Abi_ucodec_derror(error_3439); break; } default: rt_panic("match: no case at tests:1568"); } _r; });
}
V d_Call_ucodec_dfunction(V name_3440, V types_3441, V metadata_3442) {
  return ({ V inputs_3443 = d_SeqList_dmap(({ V _c = clo_new(lam_3445, 1, 1); CLO_ENV(_c)[0] = metadata_3442; _c; }), types_3441); ((metadata_3442) != FALSE_V ? rt_ctor4(0, name_3440, inputs_3443, CON(rt_ctor2(0, ((V)&S_680), ((V)4)), NIL), ((V)2)) : rt_ctor4(0, name_3440, inputs_3443, NIL, ((V)0))); });
}
V d_Call_ucodec_dshow_uencode(V result_3446) {
  return ({ V _r = 0; V m_3447 = result_3446; switch (tag_of(m_3447)) { case 1: { V bytes_3448 = FLD(m_3447, 0); _r = str_concat(CON(((V)&S_158), CON(d_Abi_ucodec_dhex(bytes_3448), NIL))); break; } case 0: { V error_3449 = FLD(m_3447, 0); _r = str_concat(CON(((V)&S_662), CON(d_Call_ucodec_derror(error_3449), NIL))); break; } default: rt_panic("match: no case at tests:1582"); } _r; });
}
V d_Call_ucodec_dvalues_utext(V values_3450) {
  return ({ V _r = 0; V m_3451 = values_3450; if (((m_3451) == NIL)) {  _r = SNIL; } else if (((m_3451) != NIL) && ((FLD(m_3451, 1)) == NIL)) { V value_3452 = FLD(m_3451, 0); _r = d_Abi_ucodec_dshow_uvalue(value_3452); } else if (((m_3451) != NIL) && ((FLD(m_3451, 1)) != NIL)) { V value_3453 = FLD(m_3451, 0); V head_3454 = FLD(FLD(m_3451, 1), 0); V tail_3455 = FLD(FLD(m_3451, 1), 1); _r = str_concat(CON(d_Abi_ucodec_dshow_uvalue(value_3453), CON(((V)&S_673), CON(d_Call_ucodec_dvalues_utext(CON(head_3454, tail_3455)), NIL)))); } else rt_panic("match: no case at tests:1587"); _r; });
}
V d_Call_ucodec_dshow_udecode(V result_3456) {
  return ({ V _r = 0; V m_3457 = result_3456; switch (tag_of(m_3457)) { case 1: { V values_3458 = FLD(m_3457, 0); _r = str_concat(CON(((V)&S_158), CON(d_Call_ucodec_dvalues_utext(values_3458), NIL))); break; } case 0: { V error_3459 = FLD(m_3457, 0); _r = str_concat(CON(((V)&S_662), CON(d_Call_ucodec_derror(error_3459), NIL))); break; } default: rt_panic("match: no case at tests:1593"); } _r; });
}
V d_Call_ucodec_dquery(V parts_3460) {
  return ({ V _r = 0; V m_3461 = parts_3460; if (((m_3461) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3461) != NIL) && ((FLD(m_3461, 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3461) != NIL) && ((FLD(m_3461, 1)) != NIL) && ((FLD(FLD(m_3461, 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3461) != NIL) && ((FLD(m_3461, 1)) != NIL) && ((FLD(FLD(m_3461, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3461, 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3461) != NIL) && ((FLD(m_3461, 1)) != NIL) && ((FLD(FLD(m_3461, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3461, 1), 1), 1)) != NIL)) { V mode_3462 = FLD(m_3461, 0); V name_3463 = FLD(FLD(m_3461, 1), 0); V types_3464 = FLD(FLD(FLD(m_3461, 1), 1), 0); V payload_3465 = FLD(FLD(FLD(FLD(m_3461, 1), 1), 1), 0); V args_3466 = FLD(FLD(FLD(FLD(m_3461, 1), 1), 1), 1); _r = d_StringResult_dbind(d_Mapping_ulayout_dtypes(types_3464), ({ V _c = clo_new(lam_3468, 1, 4); CLO_ENV(_c)[0] = mode_3462; CLO_ENV(_c)[1] = name_3463; CLO_ENV(_c)[2] = payload_3465; CLO_ENV(_c)[3] = args_3466; _c; })); } else rt_panic("match: no case at tests:1598"); _r; });
}
V d_Call_ucodec_ddispatch(V mode_3469, V name_3470, V ts_3471, V payload_3472, V args_3473) {
  return ((d_NativeString_dequal(mode_3469, ((V)&S_162))) != FALSE_V ? d_Call_ucodec_ddecode_uquery(name_3470, ts_3471, payload_3472, args_3473) : ((d_NativeString_dequal(mode_3469, ((V)&S_161))) != FALSE_V ? d_Call_ucodec_dencode_uquery(name_3470, ts_3471, payload_3472, args_3473, FALSE_V) : ((d_NativeString_dequal(mode_3469, ((V)&S_592))) != FALSE_V ? d_Call_ucodec_dencode_uquery(name_3470, ts_3471, payload_3472, args_3473, TRUE_V) : FAIL(((V)&S_681)))));
}
V d_Call_ucodec_dencode_uquery(V name_3474, V ts_3475, V payload_3476, V args_3477, V metadata_3478) {
  return d_StringResult_dbind(d_Mapping_ulayout_dtypes(payload_3476), ({ V _c = clo_new(lam_3482, 1, 4); CLO_ENV(_c)[0] = args_3477; CLO_ENV(_c)[1] = name_3474; CLO_ENV(_c)[2] = ts_3475; CLO_ENV(_c)[3] = metadata_3478; _c; }));
}
V d_Call_ucodec_ddecode_uquery(V name_3483, V ts_3484, V payload_3485, V args_3486) {
  return ({ V _r = 0; V m_3487 = args_3486; if (((m_3487) == NIL)) {  _r = d_StringResult_dbind(d_Abi_ucodec_dunhex(payload_3485), ({ V _c = clo_new(lam_3489, 1, 2); CLO_ENV(_c)[0] = name_3483; CLO_ENV(_c)[1] = ts_3484; _c; })); } else if (((m_3487) != NIL)) {  _r = FAIL(((V)&S_160)); } else rt_panic("match: no case at tests:1617"); _r; });
}
V d_Call_ucodec_dmain(V args_3490) {
  return ({ V _r = 0; V m_3491 = args_3490; if (((m_3491) == NIL)) {  _r = DONE(SNIL); } else if (((m_3491) != NIL)) { V query_3492 = FLD(m_3491, 0); V tail_3493 = FLD(m_3491, 1); _r = d_StringResult_dbind(d_Call_ucodec_dquery(d_NativeString_dsplit((((V)124u)), query_3492)), ({ V _c = clo_new(lam_3495, 1, 1); CLO_ENV(_c)[0] = tail_3493; _c; })); } else rt_panic("match: no case at tests:1622"); _r; });
}
V d_Call_ucodec_djoin(V row_3496, V tail_3497) {
  return ({ V _r = 0; V m_3498 = tail_3497; if (((m_3498) == NIL)) {  _r = DONE(row_3496); } else if (((m_3498) != NIL)) { V head_3499 = FLD(m_3498, 0); V rest_3500 = FLD(m_3498, 1); _r = d_StringResult_dbind(d_Call_ucodec_dmain(CON(head_3499, rest_3500)), ({ V _c = clo_new(lam_3502, 1, 1); CLO_ENV(_c)[0] = row_3496; _c; })); } else rt_panic("match: no case at tests:1628"); _r; });
}
V d_Return_ucodec_derror(V error_3503) {
  return ({ V _r = 0; V m_3504 = error_3503; switch (tag_of(m_3504)) { case 0: {  _r = ((V)&S_676); break; } case 1: {  _r = ((V)&S_677); break; } case 2: { V error_3505 = FLD(m_3504, 0); _r = d_Abi_ucodec_derror(error_3505); break; } default: rt_panic("match: no case at tests:1634"); } _r; });
}
V d_Return_ucodec_dfunction(V name_3506, V types_3507, V metadata_3508) {
  return ({ V outputs_3509 = d_SeqList_dmap(({ V _c = clo_new(lam_3511, 1, 1); CLO_ENV(_c)[0] = metadata_3508; _c; }), types_3507); ((metadata_3508) != FALSE_V ? rt_ctor4(0, ((V)&S_682), CON(rt_ctor2(0, ((V)&S_683), ((V)4)), NIL), outputs_3509, ((V)2)) : rt_ctor4(0, name_3506, NIL, outputs_3509, ((V)0))); });
}
V d_Return_ucodec_dshow_uencode(V result_3512) {
  return ({ V _r = 0; V m_3513 = result_3512; switch (tag_of(m_3513)) { case 1: { V bytes_3514 = FLD(m_3513, 0); _r = str_concat(CON(((V)&S_158), CON(d_Abi_ucodec_dhex(bytes_3514), NIL))); break; } case 0: { V error_3515 = FLD(m_3513, 0); _r = str_concat(CON(((V)&S_662), CON(d_Return_ucodec_derror(error_3515), NIL))); break; } default: rt_panic("match: no case at tests:1646"); } _r; });
}
V d_Return_ucodec_dshow_udecode(V result_3516) {
  return ({ V _r = 0; V m_3517 = result_3516; switch (tag_of(m_3517)) { case 1: { V values_3518 = FLD(m_3517, 0); _r = str_concat(CON(((V)&S_158), CON(d_Call_ucodec_dvalues_utext(values_3518), NIL))); break; } case 0: { V error_3519 = FLD(m_3517, 0); _r = str_concat(CON(((V)&S_662), CON(d_Return_ucodec_derror(error_3519), NIL))); break; } default: rt_panic("match: no case at tests:1651"); } _r; });
}
V d_Return_ucodec_dquery(V parts_3520) {
  return ({ V _r = 0; V m_3521 = parts_3520; if (((m_3521) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3521) != NIL) && ((FLD(m_3521, 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3521) != NIL) && ((FLD(m_3521, 1)) != NIL) && ((FLD(FLD(m_3521, 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3521) != NIL) && ((FLD(m_3521, 1)) != NIL) && ((FLD(FLD(m_3521, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3521, 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3521) != NIL) && ((FLD(m_3521, 1)) != NIL) && ((FLD(FLD(m_3521, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3521, 1), 1), 1)) != NIL)) { V mode_3522 = FLD(m_3521, 0); V name_3523 = FLD(FLD(m_3521, 1), 0); V types_3524 = FLD(FLD(FLD(m_3521, 1), 1), 0); V payload_3525 = FLD(FLD(FLD(FLD(m_3521, 1), 1), 1), 0); V args_3526 = FLD(FLD(FLD(FLD(m_3521, 1), 1), 1), 1); _r = d_StringResult_dbind(d_Mapping_ulayout_dtypes(types_3524), ({ V _c = clo_new(lam_3528, 1, 4); CLO_ENV(_c)[0] = mode_3522; CLO_ENV(_c)[1] = name_3523; CLO_ENV(_c)[2] = payload_3525; CLO_ENV(_c)[3] = args_3526; _c; })); } else rt_panic("match: no case at tests:1656"); _r; });
}
V d_Return_ucodec_ddispatch(V mode_3529, V name_3530, V ts_3531, V payload_3532, V args_3533) {
  return ((d_NativeString_dequal(mode_3529, ((V)&S_162))) != FALSE_V ? d_Return_ucodec_ddecode_uquery(name_3530, ts_3531, payload_3532, args_3533, FALSE_V) : ((d_NativeString_dequal(mode_3529, ((V)&S_684))) != FALSE_V ? d_Return_ucodec_ddecode_uquery(name_3530, ts_3531, payload_3532, args_3533, TRUE_V) : ((d_NativeString_dequal(mode_3529, ((V)&S_161))) != FALSE_V ? d_Return_ucodec_dencode_uquery(name_3530, ts_3531, payload_3532, args_3533, FALSE_V) : ((d_NativeString_dequal(mode_3529, ((V)&S_592))) != FALSE_V ? d_Return_ucodec_dencode_uquery(name_3530, ts_3531, payload_3532, args_3533, TRUE_V) : FAIL(((V)&S_681))))));
}
V d_Return_ucodec_dencode_uquery(V name_3534, V ts_3535, V payload_3536, V args_3537, V metadata_3538) {
  return d_StringResult_dbind(d_Mapping_ulayout_dtypes(payload_3536), ({ V _c = clo_new(lam_3542, 1, 4); CLO_ENV(_c)[0] = args_3537; CLO_ENV(_c)[1] = name_3534; CLO_ENV(_c)[2] = ts_3535; CLO_ENV(_c)[3] = metadata_3538; _c; }));
}
V d_Return_ucodec_ddecode_uquery(V name_3543, V ts_3544, V payload_3545, V args_3546, V metadata_3547) {
  return ({ V _r = 0; V m_3548 = args_3546; if (((m_3548) == NIL)) {  _r = d_StringResult_dbind(d_Abi_ucodec_dunhex(payload_3545), ({ V _c = clo_new(lam_3550, 1, 3); CLO_ENV(_c)[0] = name_3543; CLO_ENV(_c)[1] = ts_3544; CLO_ENV(_c)[2] = metadata_3547; _c; })); } else if (((m_3548) != NIL)) {  _r = FAIL(((V)&S_160)); } else rt_panic("match: no case at tests:1676"); _r; });
}
V d_Return_ucodec_dmain(V args_3551) {
  return ({ V _r = 0; V m_3552 = args_3551; if (((m_3552) == NIL)) {  _r = DONE(SNIL); } else if (((m_3552) != NIL)) { V query_3553 = FLD(m_3552, 0); V tail_3554 = FLD(m_3552, 1); _r = d_StringResult_dbind(d_Return_ucodec_dquery(d_NativeString_dsplit((((V)124u)), query_3553)), ({ V _c = clo_new(lam_3556, 1, 1); CLO_ENV(_c)[0] = tail_3554; _c; })); } else rt_panic("match: no case at tests:1681"); _r; });
}
V d_Return_ucodec_djoin(V row_3557, V tail_3558) {
  return ({ V _r = 0; V m_3559 = tail_3558; if (((m_3559) == NIL)) {  _r = DONE(row_3557); } else if (((m_3559) != NIL)) { V head_3560 = FLD(m_3559, 0); V rest_3561 = FLD(m_3559, 1); _r = d_StringResult_dbind(d_Return_ucodec_dmain(CON(head_3560, rest_3561)), ({ V _c = clo_new(lam_3563, 1, 1); CLO_ENV(_c)[0] = row_3557; _c; })); } else rt_panic("match: no case at tests:1687"); _r; });
}
V d_Revert_ucodec_derror(V error_3564) {
  return ({ V _r = 0; V m_3565 = error_3564; switch (tag_of(m_3565)) { case 0: {  _r = ((V)&S_685); break; } case 1: { V error_3566 = FLD(m_3565, 0); _r = d_Call_ucodec_derror(error_3566); break; } default: rt_panic("match: no case at tests:1692"); } _r; });
}
V d_Revert_ucodec_ddeclaration(V kind_3567, V name_3568, V types_3569, V metadata_3570) {
  return ({ V parameters_3571 = d_SeqList_dmap(({ V _c = clo_new(lam_3573, 1, 1); CLO_ENV(_c)[0] = metadata_3570; _c; }), types_3569); ((d_NativeString_dequal(kind_3567, ((V)&S_686))) != FALSE_V ? DONE(rt_ctor2(2, name_3568, parameters_3571)) : ((d_NativeString_dequal(kind_3567, ((V)&S_687))) != FALSE_V ? DONE(rt_ctor2(0, parameters_3571, FALSE_V)) : ((d_NativeString_dequal(kind_3567, ((V)&S_688))) != FALSE_V ? DONE(rt_ctor1(1, rt_ctor4(0, name_3568, parameters_3571, NIL, ((V)1)))) : ((d_NativeString_dequal(kind_3567, ((V)&S_689))) != FALSE_V ? DONE(rt_ctor3(3, name_3568, NIL, FALSE_V)) : ((d_NativeString_dequal(kind_3567, ((V)&S_690))) != FALSE_V ? DONE(rt_ctor1(4, FALSE_V)) : FAIL(((V)&S_691))))))); });
}
V d_Revert_ucodec_dshow_uencode(V result_3574) {
  return ({ V _r = 0; V m_3575 = result_3574; switch (tag_of(m_3575)) { case 1: { V bytes_3576 = FLD(m_3575, 0); _r = str_concat(CON(((V)&S_158), CON(d_Abi_ucodec_dhex(bytes_3576), NIL))); break; } case 0: { V error_3577 = FLD(m_3575, 0); _r = str_concat(CON(((V)&S_662), CON(d_Revert_ucodec_derror(error_3577), NIL))); break; } default: rt_panic("match: no case at tests:1705"); } _r; });
}
V d_Revert_ucodec_dshow_udecode(V result_3578) {
  return ({ V _r = 0; V m_3579 = result_3578; switch (tag_of(m_3579)) { case 1: { V values_3580 = FLD(m_3579, 0); _r = str_concat(CON(((V)&S_158), CON(d_Call_ucodec_dvalues_utext(values_3580), NIL))); break; } case 0: { V error_3581 = FLD(m_3579, 0); _r = str_concat(CON(((V)&S_662), CON(d_Revert_ucodec_derror(error_3581), NIL))); break; } default: rt_panic("match: no case at tests:1710"); } _r; });
}
V d_Revert_ucodec_dquery(V parts_3582) {
  return ({ V _r = 0; V m_3583 = parts_3582; if (((m_3583) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3583) != NIL) && ((FLD(m_3583, 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3583) != NIL) && ((FLD(m_3583, 1)) != NIL) && ((FLD(FLD(m_3583, 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3583) != NIL) && ((FLD(m_3583, 1)) != NIL) && ((FLD(FLD(m_3583, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3583, 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3583) != NIL) && ((FLD(m_3583, 1)) != NIL) && ((FLD(FLD(m_3583, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3583, 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(m_3583, 1), 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3583) != NIL) && ((FLD(m_3583, 1)) != NIL) && ((FLD(FLD(m_3583, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3583, 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(m_3583, 1), 1), 1), 1)) != NIL)) { V mode_3584 = FLD(m_3583, 0); V kind_3585 = FLD(FLD(m_3583, 1), 0); V name_3586 = FLD(FLD(FLD(m_3583, 1), 1), 0); V types_3587 = FLD(FLD(FLD(FLD(m_3583, 1), 1), 1), 0); V payload_3588 = FLD(FLD(FLD(FLD(FLD(m_3583, 1), 1), 1), 1), 0); V args_3589 = FLD(FLD(FLD(FLD(FLD(m_3583, 1), 1), 1), 1), 1); _r = d_StringResult_dbind(d_Mapping_ulayout_dtypes(types_3587), ({ V _c = clo_new(lam_3591, 1, 5); CLO_ENV(_c)[0] = mode_3584; CLO_ENV(_c)[1] = kind_3585; CLO_ENV(_c)[2] = name_3586; CLO_ENV(_c)[3] = payload_3588; CLO_ENV(_c)[4] = args_3589; _c; })); } else rt_panic("match: no case at tests:1715"); _r; });
}
V d_Revert_ucodec_dprepare(V mode_3592, V kind_3593, V name_3594, V types_3595, V payload_3596, V args_3597) {
  return ({ V metadata_3598 = ((d_NativeString_dequal(mode_3592, ((V)&S_592))) != FALSE_V ? TRUE_V : d_NativeString_dequal(mode_3592, ((V)&S_684))); d_StringResult_dbind(d_Revert_ucodec_ddeclaration(kind_3593, name_3594, types_3595, metadata_3598), ({ V _c = clo_new(lam_3600, 1, 3); CLO_ENV(_c)[0] = mode_3592; CLO_ENV(_c)[1] = payload_3596; CLO_ENV(_c)[2] = args_3597; _c; })); });
}
V d_Revert_ucodec_ddispatch(V mode_3601, V declaration_3602, V payload_3603, V args_3604) {
  return ((d_NativeString_dequal(mode_3601, ((V)&S_162))) != FALSE_V ? d_Revert_ucodec_ddecode_uquery(declaration_3602, payload_3603, args_3604) : ((d_NativeString_dequal(mode_3601, ((V)&S_684))) != FALSE_V ? d_Revert_ucodec_ddecode_uquery(declaration_3602, payload_3603, args_3604) : ((d_NativeString_dequal(mode_3601, ((V)&S_161))) != FALSE_V ? d_Revert_ucodec_dencode_uquery(declaration_3602, payload_3603, args_3604) : ((d_NativeString_dequal(mode_3601, ((V)&S_592))) != FALSE_V ? d_Revert_ucodec_dencode_uquery(declaration_3602, payload_3603, args_3604) : FAIL(((V)&S_681))))));
}
V d_Revert_ucodec_dencode_uquery(V declaration_3605, V payload_3606, V args_3607) {
  return d_StringResult_dbind(d_Mapping_ulayout_dtypes(payload_3606), ({ V _c = clo_new(lam_3611, 1, 2); CLO_ENV(_c)[0] = args_3607; CLO_ENV(_c)[1] = declaration_3605; _c; }));
}
V d_Revert_ucodec_ddecode_uquery(V declaration_3612, V payload_3613, V args_3614) {
  return ({ V _r = 0; V m_3615 = args_3614; if (((m_3615) == NIL)) {  _r = d_StringResult_dbind(d_Abi_ucodec_dunhex(payload_3613), ({ V _c = clo_new(lam_3617, 1, 1); CLO_ENV(_c)[0] = declaration_3612; _c; })); } else if (((m_3615) != NIL)) {  _r = FAIL(((V)&S_160)); } else rt_panic("match: no case at tests:1739"); _r; });
}
V d_Revert_ucodec_dmain(V args_3618) {
  return ({ V _r = 0; V m_3619 = args_3618; if (((m_3619) == NIL)) {  _r = DONE(SNIL); } else if (((m_3619) != NIL)) { V query_3620 = FLD(m_3619, 0); V tail_3621 = FLD(m_3619, 1); _r = d_StringResult_dbind(d_Revert_ucodec_dquery(d_NativeString_dsplit((((V)124u)), query_3620)), ({ V _c = clo_new(lam_3623, 1, 1); CLO_ENV(_c)[0] = tail_3621; _c; })); } else rt_panic("match: no case at tests:1744"); _r; });
}
V d_Revert_ucodec_djoin(V row_3624, V tail_3625) {
  return ({ V _r = 0; V m_3626 = tail_3625; if (((m_3626) == NIL)) {  _r = DONE(row_3624); } else if (((m_3626) != NIL)) { V head_3627 = FLD(m_3626, 0); V rest_3628 = FLD(m_3626, 1); _r = d_StringResult_dbind(d_Revert_ucodec_dmain(CON(head_3627, rest_3628)), ({ V _c = clo_new(lam_3630, 1, 1); CLO_ENV(_c)[0] = row_3624; _c; })); } else rt_panic("match: no case at tests:1749"); _r; });
}
V d_Event_udecode_derror(V error_3631) {
  return ({ V _r = 0; V m_3632 = error_3631; switch (tag_of(m_3632)) { case 0: {  _r = ((V)&S_692); break; } case 1: {  _r = ((V)&S_693); break; } case 2: {  _r = ((V)&S_694); break; } case 3: {  _r = ((V)&S_695); break; } case 4: { V error_3633 = FLD(m_3632, 0); _r = d_Abi_ucodec_derror(error_3633); break; } default: rt_panic("match: no case at tests:1755"); } _r; });
}
V d_Event_udecode_dvalue(V value_3634) {
  return ({ V _r = 0; V m_3635 = value_3634; switch (tag_of(m_3635)) { case 0: { V value_3636 = FLD(m_3635, 0); _r = d_Abi_ucodec_dshow_uvalue(value_3636); break; } case 1: { V bytes_3637 = FLD(m_3635, 0); _r = str_concat(CON(((V)&S_696), CON(d_Abi_ucodec_dhex(bytes_3637), NIL))); break; } default: rt_panic("match: no case at tests:1763"); } _r; });
}
V d_Event_udecode_dshow(V result_3638) {
  return ({ V _r = 0; V m_3639 = result_3638; switch (tag_of(m_3639)) { case 1: { V values_3640 = FLD(m_3639, 0); _r = str_concat(CON(((V)&S_158), CON(str_join(d_SeqList_dmap(clo_new(lam_3642, 1, 0), values_3640), ((V)&S_673)), NIL))); break; } case 0: { V error_3643 = FLD(m_3639, 0); _r = str_concat(CON(((V)&S_662), CON(d_Event_udecode_derror(error_3643), NIL))); break; } default: rt_panic("match: no case at tests:1768"); } _r; });
}
V d_Event_udecode_dtopics(V parts_3644) {
  return ({ V _r = 0; V m_3645 = parts_3644; if (((m_3645) == NIL)) {  _r = DONE(NIL); } else if (((m_3645) != NIL)) { V head_3646 = FLD(m_3645, 0); V tail_3647 = FLD(m_3645, 1); _r = d_StringResult_dbind(d_Abi_ucodec_dunhex(head_3646), ({ V _c = clo_new(lam_3651, 1, 1); CLO_ENV(_c)[0] = tail_3647; _c; })); } else rt_panic("match: no case at tests:1773"); _r; });
}
V d_Event_udecode_dquery(V parts_3652) {
  return ({ V _r = 0; V m_3653 = parts_3652; if (((m_3653) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3653) != NIL) && ((FLD(m_3653, 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3653) != NIL) && ((FLD(m_3653, 1)) != NIL) && ((FLD(FLD(m_3653, 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3653) != NIL) && ((FLD(m_3653, 1)) != NIL) && ((FLD(FLD(m_3653, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3653, 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3653) != NIL) && ((FLD(m_3653, 1)) != NIL) && ((FLD(FLD(m_3653, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3653, 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3653) != NIL) && ((FLD(m_3653, 1)) != NIL) && ((FLD(FLD(m_3653, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3653, 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1), 1)) == NIL)) {  _r = FAIL(((V)&S_160)); } else if (((m_3653) != NIL) && ((FLD(m_3653, 1)) != NIL) && ((FLD(FLD(m_3653, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3653, 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1), 1), 1)) == NIL)) { V name_3654 = FLD(m_3653, 0); V anonymous_3655 = FLD(FLD(m_3653, 1), 0); V types_3656 = FLD(FLD(FLD(m_3653, 1), 1), 0); V flags_3657 = FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 0); V topics_3658 = FLD(FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1), 0); V data_3659 = FLD(FLD(FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1), 1), 0); _r = d_StringResult_dbind(d_Event_ucodec_dflag(anonymous_3655), ({ V _c = clo_new(lam_3669, 1, 5); CLO_ENV(_c)[0] = types_3656; CLO_ENV(_c)[1] = flags_3657; CLO_ENV(_c)[2] = topics_3658; CLO_ENV(_c)[3] = data_3659; CLO_ENV(_c)[4] = name_3654; _c; })); } else if (((m_3653) != NIL) && ((FLD(m_3653, 1)) != NIL) && ((FLD(FLD(m_3653, 1), 1)) != NIL) && ((FLD(FLD(FLD(m_3653, 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1), 1)) != NIL) && ((FLD(FLD(FLD(FLD(FLD(FLD(m_3653, 1), 1), 1), 1), 1), 1)) != NIL)) {  _r = FAIL(((V)&S_160)); } else rt_panic("match: no case at tests:1780"); _r; });
}
V d_Event_udecode_dmain(V args_3670) {
  return ({ V _r = 0; V m_3671 = args_3670; if (((m_3671) == NIL)) {  _r = DONE(SNIL); } else if (((m_3671) != NIL)) { V query_3672 = FLD(m_3671, 0); V tail_3673 = FLD(m_3671, 1); _r = d_StringResult_dbind(d_Event_udecode_dquery(d_NativeString_dsplit((((V)124u)), query_3672)), ({ V _c = clo_new(lam_3675, 1, 1); CLO_ENV(_c)[0] = tail_3673; _c; })); } else rt_panic("match: no case at tests:1796"); _r; });
}
V d_Event_udecode_djoin(V row_3676, V tail_3677) {
  return ({ V _r = 0; V m_3678 = tail_3677; if (((m_3678) == NIL)) {  _r = DONE(row_3676); } else if (((m_3678) != NIL)) { V head_3679 = FLD(m_3678, 0); V rest_3680 = FLD(m_3678, 1); _r = d_StringResult_dbind(d_Event_udecode_dmain(CON(head_3679, rest_3680)), ({ V _c = clo_new(lam_3682, 1, 1); CLO_ENV(_c)[0] = row_3676; _c; })); } else rt_panic("match: no case at tests:1801"); _r; });
}
V d_Main_dkneg_ushape(V shape_d2_3683, V word_d2_3684) {
  return ({ V _r = 0; V m_3685 = d_Check_dinfer_uterm(NONE, d_Global_dinitial(), rt_ctor2(3, shape_d2_3683, rt_ctor2(6, rt_ctor1(1, d_Big_dzero()), NIL))); switch (tag_of(m_3685)) { case 1: { V _m_3685_a0_3686 = FLD(m_3685, 0); _r = ({ V value_d2_3687 = _m_3685_a0_3686; FAIL(str_append(word_d2_3684, ((V)&S_697))); }); break; } case 0: { V _m_3685_a0_3688 = FLD(m_3685, 0); _r = ({ V error_d2_3689 = _m_3685_a0_3688; ({ V message_d2_3690 = d_Error_dmessage(error_d2_3689); ((d_NativeString_dequal(message_d2_3690, word_d2_3684)) != FALSE_V ? DONE(UNIT) : FAIL(str_concat(CON(((V)&S_3), CON(message_d2_3690, CON(((V)&S_4), NIL)))))); }); }); break; } default: rt_panic("match: no case at tests:1806"); } _r; });
}
