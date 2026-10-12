/* generated from src/abi.bend */
#include "assay_gen.h"

static Str S_0 = {TAG_STR, 2, {(const uint8_t *)"\134\042"}};
static Str S_1 = {TAG_STR, 2, {(const uint8_t *)"\134\134"}};
static Str S_2 = {TAG_STR, 2, {(const uint8_t *)"\134u"}};
static V lam_90(V *env, V *args) {
  (void)env; (void)args;
  V local8640_88 = args[0];
  return ({ V scrut8641_89 = UNIT; ((d_NativeChar_dequal(local8640_88, (((V)34u)))) != FALSE_V ? ((V)&S_0) : ((d_NativeChar_dequal(local8640_88, (((V)92u)))) != FALSE_V ? ((V)&S_1) : ((d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL((local8640_88))), d_Big_dof_unat(NAT_SMALL(32ull)))) != FALSE_V ? str_concat(CON(((V)&S_2), CON(d_NativeString_dpad(NAT_SMALL(4ull), (((V)48u)), d_Big_dhex(d_Big_dof_unat(NAT_SMALL((local8640_88))), FALSE_V)), NIL))) : d_NativeString_drepeat(d_Big_dto_unat(d_Big_done()), local8640_88)))); });
}
static Str S_3 = {TAG_STR, 1, {(const uint8_t *)"\042"}};
static Str S_4 = {TAG_STR, 3, {(const uint8_t *)"[]\012"}};
static Str S_5 = {TAG_STR, 5, {(const uint8_t *)"uint8"}};
static Str S_6 = {TAG_STR, 7, {(const uint8_t *)"uint256"}};
static Str S_7 = {TAG_STR, 7, {(const uint8_t *)"address"}};
static Str S_8 = {TAG_STR, 4, {(const uint8_t *)"bool"}};
static Str S_9 = {TAG_STR, 6, {(const uint8_t *)"string"}};
static Str S_10 = {TAG_STR, 1, {(const uint8_t *)"("}};
static V lam_103(V *env, V *args) {
  (void)env; (void)args;
  V local8787_102 = args[0];
  return d_Abi_dSchema_dtype_uname(d_Get_dAbi_dSchema_dParameter_dtyp(local8787_102));
}
static Str S_11 = {TAG_STR, 1, {(const uint8_t *)","}};
static Str S_12 = {TAG_STR, 1, {(const uint8_t *)")"}};
static V w_Abi_dword(V *env, V *args) {
  (void)env; (void)args;
  return d_Abi_dword(args[0]);
}
static Str S_13 = {TAG_STR, 7, {(const uint8_t *)"\042name\042:"}};
static Str S_14 = {TAG_STR, 8, {(const uint8_t *)",\042type\042:"}};
static Str S_15 = {TAG_STR, 1, {(const uint8_t *)"{"}};
static Str S_16 = {TAG_STR, 1, {(const uint8_t *)"}"}};
static Str S_17 = {TAG_STR, 1, {(const uint8_t *)"["}};
static V w_Abi_dSchema_dparameter(V *env, V *args) {
  (void)env; (void)args;
  return d_Abi_dSchema_dparameter(args[0]);
}
static Str S_18 = {TAG_STR, 1, {(const uint8_t *)"]"}};
static Str S_19 = {TAG_STR, 4, {(const uint8_t *)"view"}};
static Str S_20 = {TAG_STR, 10, {(const uint8_t *)"nonpayable"}};
static Str S_21 = {TAG_STR, 7, {(const uint8_t *)"payable"}};
static Str S_22 = {TAG_STR, 31, {(const uint8_t *)"{\042type\042:\042constructor\042,\042inputs\042:"}};
static Str S_23 = {TAG_STR, 19, {(const uint8_t *)",\042stateMutability\042:"}};
static Str S_24 = {TAG_STR, 26, {(const uint8_t *)"{\042type\042:\042function\042,\042name\042:"}};
static Str S_25 = {TAG_STR, 10, {(const uint8_t *)",\042inputs\042:"}};
static Str S_26 = {TAG_STR, 11, {(const uint8_t *)",\042outputs\042:"}};
static Str S_27 = {TAG_STR, 23, {(const uint8_t *)"{\042type\042:\042error\042,\042name\042:"}};
static Str S_28 = {TAG_STR, 11, {(const uint8_t *)",\042indexed\042:"}};
static V lam_145(V *env, V *args) {
  (void)env; (void)args;
  V local10098_144 = args[0];
  return str_append(((V)&S_15), str_append(d_Abi_dSchema_dparameter_ufields(d_Get_dAbi_dSchema_dEvent_uparameter_dparameter(local10098_144)), str_append(((V)&S_28), str_append(d_NativeBool_dshow(d_Get_dAbi_dSchema_dEvent_uparameter_dindexed(local10098_144)), ((V)&S_16)))));
}
static Str S_29 = {TAG_STR, 23, {(const uint8_t *)"{\042type\042:\042event\042,\042name\042:"}};
static Str S_30 = {TAG_STR, 13, {(const uint8_t *)",\042anonymous\042:"}};
static Str S_31 = {TAG_STR, 11, {(const uint8_t *)",\042inputs\042:["}};
static Str S_32 = {TAG_STR, 2, {(const uint8_t *)"]}"}};
static Str S_33 = {TAG_STR, 37, {(const uint8_t *)"{\042type\042:\042fallback\042,\042stateMutability\042:"}};
static V lam_148(V *env, V *args) {
  (void)env; (void)args;
  V local10086_124 = args[0];
  return ({ V scrut10087_125 = local10086_124; ({ V _r = 0; V m_126 = scrut10087_125; switch (tag_of(m_126)) { case 0: { V _m_126_a0_127 = FLD(m_126, 0); V _m_126_a1_128 = FLD(m_126, 1); _r = ({ V p10088_129 = _m_126_a0_127; ({ V p10089_130 = _m_126_a1_128; str_append(((V)&S_22), str_append(d_Abi_dSchema_dparameters(p10088_129), str_append(((V)&S_23), str_append(d_Abi_dquote(d_Abi_dmutability_uname(d_Abi_dSchema_dvalue_umutability(p10089_130))), ((V)&S_16))))); }); }); break; } case 1: { V _m_126_a0_131 = FLD(m_126, 0); _r = ({ V p10091_132 = _m_126_a0_131; str_append(((V)&S_24), str_append(d_Abi_dquote(d_Get_dAbi_dSchema_dFunction_u_dname(p10091_132)), str_append(((V)&S_25), str_append(d_Abi_dSchema_dparameters(d_Get_dAbi_dSchema_dFunction_u_dinputs(p10091_132)), str_append(((V)&S_26), str_append(d_Abi_dSchema_dparameters(d_Get_dAbi_dSchema_dFunction_u_doutputs(p10091_132)), str_append(((V)&S_23), str_append(d_Abi_dquote(d_Abi_dmutability_uname(d_Get_dAbi_dSchema_dFunction_u_dmutability(p10091_132))), ((V)&S_16))))))))); }); break; } case 2: { V _m_126_a0_133 = FLD(m_126, 0); V _m_126_a1_134 = FLD(m_126, 1); _r = ({ V p10092_135 = _m_126_a0_133; ({ V p10093_136 = _m_126_a1_134; str_append(((V)&S_27), str_append(d_Abi_dquote(p10092_135), str_append(((V)&S_25), str_append(d_Abi_dSchema_dparameters(p10093_136), ((V)&S_16))))); }); }); break; } case 3: { V _m_126_a0_137 = FLD(m_126, 0); V _m_126_a1_138 = FLD(m_126, 1); V _m_126_a2_139 = FLD(m_126, 2); _r = ({ V p10094_140 = _m_126_a0_137; ({ V p10095_141 = _m_126_a1_138; ({ V p10096_142 = _m_126_a2_139; ({ V scrut10099_143 = clo_new(lam_145, 1, 0); str_append(((V)&S_29), str_append(d_Abi_dquote(p10094_140), str_append(((V)&S_30), str_append(d_NativeBool_dshow(p10096_142), str_append(((V)&S_31), str_append(str_join(d_SeqList_dmap(scrut10099_143, p10095_141), ((V)&S_11)), ((V)&S_32))))))); }); }); }); }); break; } case 4: { V _m_126_a0_146 = FLD(m_126, 0); _r = ({ V p10100_147 = _m_126_a0_146; str_append(((V)&S_33), str_append(d_Abi_dquote(d_Abi_dmutability_uname(d_Abi_dSchema_dvalue_umutability(p10100_147))), ((V)&S_16))); }); break; } default: rt_panic("match: no case at abi:179"); } _r; }); });
}
static Str S_34 = {TAG_STR, 2, {(const uint8_t *)"]\012"}};
static V lam_166(V *env, V *args) {
  (void)env; (void)args;
  V local10079_165 = args[0];
  return rt_ctor1(1, rt_ctor4(0, d_Get_dAbi_dEntry_dname(local10079_165), d_SeqList_dmap(clo_new(w_Abi_dword, 1, 0), d_Get_dAbi_dEntry_dinputs(local10079_165)), CON(d_Abi_dword(SNIL), NIL), d_Get_dAbi_dEntry_dmutability(local10079_165)));
}
static V lam_169(V *env, V *args) {
  (void)env; (void)args;
  V local10082_168 = args[0];
  return rt_ctor2(2, d_Get_dAbi_dCustom_uerror_derror_uname(local10082_168), d_SeqList_dmap(clo_new(w_Abi_dword, 1, 0), d_Get_dAbi_dCustom_uerror_darguments(local10082_168)));
}
static V lam_175(V *env, V *args) {
  (void)env; (void)args;
  V local10121_174 = args[0];
  return d_Get_dAbi_dSchema_dEvent_uparameter_dparameter(local10121_174);
}
static V lam_183(V *env, V *args) {
  (void)env; (void)args;
  V local10127_176 = args[0];
  V local10129_177 = args[1];
  return ({ V _r = 0; V m_178 = local10127_176; switch (tag_of(m_178)) { case 1: { V _m_178_a0_179 = FLD(m_178, 0); _r = ({ V item10130_180 = _m_178_a0_179; ap(local10129_177, item10130_180); }); break; } case 0: { V _m_178_a0_181 = FLD(m_178, 0); _r = ({ V item10131_182 = _m_178_a0_181; FAIL(item10131_182); }); break; } default: rt_panic("match: no case at abi:200"); } _r; });
}
static V lam_200(V *env, V *args) {
  (void)env; (void)args;
  V local10138_198 = args[0];
  V local10140_199 = args[1];
  return d_Big_dadd(d_Big_dshift_uleft(local10138_198, d_Big_dto_unat(d_Big_dof_unat(NAT_SMALL(8ull)))), d_Big_didentity(d_Big_dof_unat(NAT_SMALL((local10140_199)))));
}
static V lam_226(V *env, V *args) {
  (void)env; (void)args;
  V local10149_219 = args[0];
  return ({ V _r = 0; V m_220 = local10149_219; switch (tag_of(m_220)) { case 1: { V _m_220_a0_221 = FLD(m_220, 0); _r = ({ V item10153_222 = _m_220_a0_221; ({ V local10152_223 = item10153_222; d_Local_dAbi_dbuild_df10144(env[0], CON(local10152_223, env[1]), env[2], env[3]); }); }); break; } case 0: { V _m_220_a0_224 = FLD(m_220, 0); _r = ({ V item10154_225 = _m_220_a0_224; FAIL(item10154_225); }); break; } default: rt_panic("match: no case at abi:224"); } _r; });
}
static V lam_362(V *env, V *args) {
  (void)env; (void)args;
  V bytes_361 = args[0];
  return DONE(rt_ctor2(0, list_reverse(env[0]), bytes_361));
}
static V lam_376(V *env, V *args) {
  (void)env; (void)args;
  V topic_375 = args[0];
  return d_Abi_dEvent_dcollect(env[0], env[1], CON(topic_375, env[2]), env[3]);
}
static V lam_410(V *env, V *args) {
  (void)env; (void)args;
  V bytes_409 = args[0];
  return DONE(str_concat(CON(d_Abi_dCall_dselector(env[0]), CON(bytes_409, NIL))));
}
static V lam_411(V *env, V *args) {
  (void)env; (void)args;
  return d_Abi_dCall_dResult_dbind(d_Abi_dCall_dcodec(d_Abi_dCodec_dencode(env[0])), ({ V _c = clo_new(lam_410, 1, 1); CLO_ENV(_c)[0] = env[1]; _c; }));
}
static V lam_415(V *env, V *args) {
  (void)env; (void)args;
  V parameter_414 = args[0];
  return d_Get_dAbi_dSchema_dParameter_dtyp(parameter_414);
}
static V lam_437(V *env, V *args) {
  (void)env; (void)args;
  return d_Abi_dReturn_dcodec(d_Abi_dCodec_dencode(env[0]));
}
static V lam_441(V *env, V *args) {
  (void)env; (void)args;
  V parameter_440 = args[0];
  return d_Get_dAbi_dSchema_dParameter_dtyp(parameter_440);
}
static V lam_454(V *env, V *args) {
  (void)env; (void)args;
  V fn_453 = args[0];
  return d_Abi_dCall_dencode(fn_453, env[0]);
}
static V lam_458(V *env, V *args) {
  (void)env; (void)args;
  V fn_457 = args[0];
  return d_Abi_dCall_ddecode(fn_457, env[0]);
}
static V w_Abi_dEvent_dsingle(V *env, V *args) {
  (void)env; (void)args;
  return d_Abi_dEvent_dsingle(args[0]);
}
static V lam_505(V *env, V *args) {
  (void)env; (void)args;
  V result_504 = args[0];
  return DONE(CON(env[0], result_504));
}
static V lam_506(V *env, V *args) {
  (void)env; (void)args;
  V value_503 = args[0];
  return d_Abi_dEvent_dDecode_uresult_dbind(d_Abi_dEvent_dmerge(env[0], env[1], env[2]), ({ V _c = clo_new(lam_505, 1, 1); CLO_ENV(_c)[0] = value_503; _c; }));
}
static V lam_514(V *env, V *args) {
  (void)env; (void)args;
  V result_513 = args[0];
  return DONE(CON(rt_ctor1(0, env[0]), result_513));
}
static V lam_519(V *env, V *args) {
  (void)env; (void)args;
  V values_518 = args[0];
  return d_Abi_dEvent_dmerge(env[0], env[1], values_518);
}
static V lam_542(V *env, V *args) {
  (void)env; (void)args;
  return d_Abi_dEvent_ddecode_usignature(env[0], env[1], env[2], env[3], env[4]);
}

V d_Abi_dCodec_dResult_dpure(V value_1) {
  return DONE(value_1);
}
V d_Abi_dCodec_dResult_dbind(V value_2, V next_3) {
  return ({ V _r = 0; V m_4 = value_2; switch (tag_of(m_4)) { case 1: { V x_5 = FLD(m_4, 0); _r = ap(next_3, x_5); break; } case 0: { V error_6 = FLD(m_4, 0); _r = FAIL(error_6); break; } default: rt_panic("match: no case at abi:45"); } _r; });
}
V d_Get_dAbi_dCustom_uerror_derror_uname(V value_7) {
  return ({ V _r = 0; V m_8 = value_7; if ((tag_of(m_8) == 0)) { V field0_9 = FLD(m_8, 0); _r = field0_9; } else rt_panic("match: no case at abi:50"); _r; });
}
V d_Get_dAbi_dCustom_uerror_darguments(V value_10) {
  return ({ V _r = 0; V m_11 = value_10; if ((tag_of(m_11) == 0)) { V field1_12 = FLD(m_11, 1); _r = field1_12; } else rt_panic("match: no case at abi:54"); _r; });
}
V d_Get_dAbi_dSchema_dParameter_dtyp(V value_13) {
  return ({ V _r = 0; V m_14 = value_13; if ((tag_of(m_14) == 0)) { V field1_15 = FLD(m_14, 1); _r = field1_15; } else rt_panic("match: no case at abi:58"); _r; });
}
V d_Get_dAbi_dEntry_dname(V value_23) {
  return ({ V _r = 0; V m_24 = value_23; if ((tag_of(m_24) == 0)) { V field0_25 = FLD(m_24, 0); _r = field0_25; } else rt_panic("match: no case at abi:70"); _r; });
}
V d_Get_dAbi_dEntry_dinputs(V value_26) {
  return ({ V _r = 0; V m_27 = value_26; if ((tag_of(m_27) == 0)) { V field1_28 = FLD(m_27, 1); _r = field1_28; } else rt_panic("match: no case at abi:74"); _r; });
}
V d_Get_dAbi_dEntry_dmutability(V value_29) {
  return ({ V _r = 0; V m_30 = value_29; if ((tag_of(m_30) == 0)) { V field2_31 = FLD(m_30, 2); _r = field2_31; } else rt_panic("match: no case at abi:78"); _r; });
}
V d_Get_dAbi_dSchema_dParameter_dname(V value_53) {
  return ({ V _r = 0; V m_54 = value_53; if ((tag_of(m_54) == 0)) { V field0_55 = FLD(m_54, 0); _r = field0_55; } else rt_panic("match: no case at abi:96"); _r; });
}
V d_Get_dAbi_dSchema_dFunction_u_dname(V value_56) {
  return ({ V _r = 0; V m_57 = value_56; if ((tag_of(m_57) == 0)) { V field0_58 = FLD(m_57, 0); _r = field0_58; } else rt_panic("match: no case at abi:100"); _r; });
}
V d_Get_dAbi_dSchema_dFunction_u_dinputs(V value_59) {
  return ({ V _r = 0; V m_60 = value_59; if ((tag_of(m_60) == 0)) { V field1_61 = FLD(m_60, 1); _r = field1_61; } else rt_panic("match: no case at abi:104"); _r; });
}
V d_Get_dAbi_dSchema_dFunction_u_doutputs(V value_62) {
  return ({ V _r = 0; V m_63 = value_62; if ((tag_of(m_63) == 0)) { V field2_64 = FLD(m_63, 2); _r = field2_64; } else rt_panic("match: no case at abi:108"); _r; });
}
V d_Get_dAbi_dSchema_dFunction_u_dmutability(V value_65) {
  return ({ V _r = 0; V m_66 = value_65; if ((tag_of(m_66) == 0)) { V field3_67 = FLD(m_66, 3); _r = field3_67; } else rt_panic("match: no case at abi:112"); _r; });
}
V d_Get_dAbi_dSchema_dEvent_uparameter_dparameter(V value_68) {
  return ({ V _r = 0; V m_69 = value_68; if ((tag_of(m_69) == 0)) { V field0_70 = FLD(m_69, 0); _r = field0_70; } else rt_panic("match: no case at abi:116"); _r; });
}
V d_Get_dAbi_dSchema_dEvent_uparameter_dindexed(V value_71) {
  return ({ V _r = 0; V m_72 = value_71; if ((tag_of(m_72) == 0)) { V field1_73 = FLD(m_72, 1); _r = field1_73; } else rt_panic("match: no case at abi:120"); _r; });
}
V d_Abi_dquote(V text_274_86) {
  return ({ V scrut8642_87 = clo_new(lam_90, 1, 0); str_append(((V)&S_3), str_append(str_join(d_SeqList_dmap(scrut8642_87, d_Series_dto_ulist(d_Series_dfrom_ustring(text_274_86))), SNIL), ((V)&S_3))); });
}
V d_Abi_dempty(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_4); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_dword(V name_1012_91) {
  return rt_ctor2(0, name_1012_91, ((V)1));
}
V d_Abi_dSchema_dtype_uname(V param_622_92) {
  return ({ V scrut8788_93 = param_622_92; ({ V _r = 0; V m_94 = scrut8788_93; switch (tag_of(m_94)) { case 0: {  _r = ({ V __95 = UNIT; ((V)&S_5); }); break; } case 1: {  _r = ({ V __96 = UNIT; ((V)&S_6); }); break; } case 2: {  _r = ({ V __97 = UNIT; ((V)&S_7); }); break; } case 3: {  _r = ({ V __98 = UNIT; ((V)&S_8); }); break; } case 4: {  _r = ({ V __99 = UNIT; ((V)&S_9); }); break; } default: rt_panic("match: no case at abi:146"); } _r; }); });
}
V d_Abi_dSchema_dsignature(V name_625_100, V parameters_626_101) {
  return str_append(name_625_100, str_append(((V)&S_10), str_append(str_join(d_SeqList_dmap(clo_new(lam_103, 1, 0), parameters_626_101), ((V)&S_11)), ((V)&S_12))));
}
V d_Abi_derror_usignature(V row_1021_104) {
  return d_Abi_dSchema_dsignature(d_Get_dAbi_dCustom_uerror_derror_uname(row_1021_104), d_SeqList_dmap(clo_new(w_Abi_dword, 1, 0), d_Get_dAbi_dCustom_uerror_darguments(row_1021_104)));
}
V d_Abi_dsignature(V entry_1018_105) {
  return d_Abi_dSchema_dsignature(d_Get_dAbi_dEntry_dname(entry_1018_105), d_SeqList_dmap(clo_new(w_Abi_dword, 1, 0), d_Get_dAbi_dEntry_dinputs(entry_1018_105)));
}
V d_Abi_daccepts_uvalue(V entry_1015_106) {
  return ({ V scrut9488_107 = d_Get_dAbi_dEntry_dmutability(entry_1015_106); ({ V _r = 0; V m_108 = scrut9488_107; switch (tag_of(m_108)) { case 0: {  _r = ({ V __109 = UNIT; FALSE_V; }); break; } case 1: {  _r = ({ V __110 = UNIT; FALSE_V; }); break; } case 2: {  _r = ({ V __111 = UNIT; TRUE_V; }); break; } default: rt_panic("match: no case at abi:159"); } _r; }); });
}
V d_Abi_dSchema_dparameter_ufields(V p_638_112) {
  return str_append(((V)&S_13), str_append(d_Abi_dquote(d_Get_dAbi_dSchema_dParameter_dname(p_638_112)), str_append(((V)&S_14), d_Abi_dquote(d_Abi_dSchema_dtype_uname(d_Get_dAbi_dSchema_dParameter_dtyp(p_638_112))))));
}
V d_Abi_dSchema_dparameter(V p_641_113) {
  return str_append(((V)&S_15), str_append(d_Abi_dSchema_dparameter_ufields(p_641_113), ((V)&S_16)));
}
V d_Abi_dSchema_dparameters(V ps_644_114) {
  return str_append(((V)&S_17), str_append(str_join(d_SeqList_dmap(clo_new(w_Abi_dSchema_dparameter, 1, 0), ps_644_114), ((V)&S_11)), ((V)&S_18)));
}
V d_Abi_dSchema_dvalue_umutability(V payable_647_115) {
  return ((payable_647_115) != FALSE_V ? ((V)2) : ((V)1));
}
V d_Abi_dmutability_uname(V param_596_116) {
  return ({ V scrut10090_117 = param_596_116; ({ V _r = 0; V m_118 = scrut10090_117; switch (tag_of(m_118)) { case 0: {  _r = ({ V __119 = UNIT; ((V)&S_19); }); break; } case 1: {  _r = ({ V __120 = UNIT; ((V)&S_20); }); break; } case 2: {  _r = ({ V __121 = UNIT; ((V)&S_21); }); break; } default: rt_panic("match: no case at abi:175"); } _r; }); });
}
V d_Abi_dSchema_dprint(V declarations_650_122) {
  return ({ V scrut10101_123 = clo_new(lam_148, 1, 0); str_append(((V)&S_17), str_append(str_join(d_SeqList_dmap(scrut10101_123, declarations_650_122), ((V)&S_11)), ((V)&S_34))); });
}
V d_Abi_dprint(V _opt__1035_149, V _opt__1034_150, V entries_1026_151) {
  return ({ V scrut10074_152 = ({ V scrut10072_153 = _opt__1035_149; ({ V _r = 0; V m_154 = scrut10072_153; if (((m_154) == NONE)) {  _r = ({ V __155 = UNIT; NIL; }); } else if (((m_154) != NONE)) { V _m_154_a0_156 = FLD(m_154, 0); _r = ({ V p10073_157 = _m_154_a0_156; p10073_157; }); } else rt_panic("match: no case at abi:185"); _r; }); }); ({ V scrut10077_158 = ({ V scrut10075_159 = _opt__1034_150; ({ V _r = 0; V m_160 = scrut10075_159; if (((m_160) == NONE)) {  _r = ({ V __161 = UNIT; FALSE_V; }); } else if (((m_160) != NONE)) { V _m_160_a0_162 = FLD(m_160, 0); _r = ({ V p10076_163 = _m_160_a0_162; p10076_163; }); } else rt_panic("match: no case at abi:187"); _r; }); }); ({ V scrut10080_164 = clo_new(lam_166, 1, 0); ({ V scrut10083_167 = clo_new(lam_169, 1, 0); ({ V scrut10084_170 = ((scrut10077_158) != FALSE_V ? CON(rt_ctor1(4, FALSE_V), NIL) : NIL); d_Abi_dSchema_dprint(list_append(CON(rt_ctor2(0, NIL, FALSE_V), d_SeqList_dmap(scrut10080_164, entries_1026_151)), list_append(d_SeqList_dmap(scrut10083_167, scrut10074_152), scrut10084_170))); }); }); }); }); });
}
V d_Abi_dSchema_dfunction_usignature(V fn_630_171) {
  return d_Abi_dSchema_dsignature(d_Get_dAbi_dSchema_dFunction_u_dname(fn_630_171), d_Get_dAbi_dSchema_dFunction_u_dinputs(fn_630_171));
}
V d_Abi_dSchema_devent_usignature(V name_633_172, V inputs_634_173) {
  return d_Abi_dSchema_dsignature(name_633_172, d_SeqList_dmap(clo_new(lam_175, 1, 0), inputs_634_173));
}
V d_Abi_dCodec_dlet_u(void) {
  static V memo; static int done;
  if (!done) { memo = clo_new(lam_183, 2, 0); rt_root(&memo); done = 1; }
  return memo;
}
V d_Abi_dCodec_dwithin(V bits_844_184, V n_845_185) {
  return ((d_Big_dis_ule(d_Big_dzero(), d_Big_dsign(n_845_185))) != FALSE_V ? d_Big_dis_ult(d_Big_dcompare(n_845_185, d_Big_dshift_uleft(d_Big_done(), d_Big_dto_unat(bits_844_184))), d_Big_dzero()) : FALSE_V);
}
V d_Abi_dCodec_dword(V n_848_186) {
  return ({ V scrut10132_187 = d_Big_dto_ubytes(n_848_186); ({ V scrut10133_188 = d_NativeString_dof_ulist(d_Series_dto_ulist(d_Series_dof_ulist(list_reverse(d_Series_dto_ulist(d_Series_dfrom_ustring(scrut10132_187)))))); str_append(d_NativeString_drepeat(d_Big_dto_unat(d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL(32ull)), d_Big_dof_unat(str_length(scrut10132_187)))), (((V)0u))), scrut10133_188); }); });
}
V d_Abi_dCodec_dslice(V data_853_189, V pos_854_190, V length_855_191) {
  return ((((d_Big_dis_ult(pos_854_190, d_Big_dzero())) != FALSE_V ? TRUE_V : ((d_Big_dis_ult(length_855_191, d_Big_dzero())) != FALSE_V ? TRUE_V : ((d_Big_dis_ult(d_Big_dof_unat(str_length(data_853_189)), pos_854_190)) != FALSE_V ? TRUE_V : d_Big_dis_ult(d_NativeInt_dsub(d_Big_dof_unat(str_length(data_853_189)), pos_854_190), length_855_191))))) != FALSE_V ? FAIL(((V)2)) : DONE(d_NativeString_dtake(d_Big_dto_unat(length_855_191), d_NativeString_ddrop(d_Big_dto_unat(pos_854_190), data_853_189))));
}
V d_Abi_dCodec_dread_uword(V data_858_192, V offset_859_193) {
  return ({ V _r = 0; V m_194 = d_Abi_dCodec_dslice(data_858_192, offset_859_193, d_Big_dof_unat(NAT_SMALL(32ull))); switch (tag_of(m_194)) { case 1: { V _m_194_a0_195 = FLD(m_194, 0); _r = ({ V item10141_196 = _m_194_a0_195; ({ V local10136_197 = item10141_196; DONE(d_NativeString_dfold(clo_new(lam_200, 2, 0), local10136_197, d_Big_dzero())); }); }); break; } case 0: { V _m_194_a0_201 = FLD(m_194, 0); _r = ({ V item10142_202 = _m_194_a0_201; FAIL(item10142_202); }); break; } default: rt_panic("match: no case at abi:214"); } _r; });
}
V d_Abi_dCodec_dpadding(V length_865_203) {
  return d_Big_dlogand(d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL(32ull)), d_Big_dlogand(length_865_203, d_Big_dof_unat(NAT_SMALL(31ull)))), d_Big_dof_unat(NAT_SMALL(31ull)));
}
V d_Abi_dCodec_dscalar(V typ_868_204, V bits_869_205, V n_870_206) {
  return ((d_Abi_dCodec_dwithin(bits_869_205, n_870_206)) != FALSE_V ? DONE(d_Abi_dCodec_dword(n_870_206)) : FAIL(rt_ctor1(0, typ_868_204)));
}
V d_Local_dAbi_dbuild_df10144(V offset_950_207, V heads_951_208, V tails_952_209, V param_968_210) {
_top: ;
  return ({ V scrut10145_211 = param_968_210; ({ V _r = 0; V m_212 = scrut10145_211; if (((m_212) == NIL)) {  _r = ({ V __213 = UNIT; DONE(str_join(list_append(list_reverse(heads_951_208), list_reverse(tails_952_209)), SNIL)); }); } else if (((m_212) != NIL)) { V _m_212_a0_214 = FLD(m_212, 0); V _m_212_a1_215 = FLD(m_212, 1); _r = ({ V p10146_216 = _m_212_a0_214; ({ V p10147_217 = _m_212_a1_215; ({ V scrut10155_218 = ({ V _c = clo_new(lam_226, 1, 4); CLO_ENV(_c)[0] = offset_950_207; CLO_ENV(_c)[1] = heads_951_208; CLO_ENV(_c)[2] = tails_952_209; CLO_ENV(_c)[3] = p10147_217; _c; }); ({ V scrut10156_227 = p10146_216; ({ V _r = 0; V m_228 = scrut10156_227; switch (tag_of(m_228)) { case 0: { V _m_228_a0_229 = FLD(m_228, 0); _r = ({ V p10157_230 = _m_228_a0_229; ap(scrut10155_218, d_Abi_dCodec_dscalar(((V)0), d_Big_dof_unat(NAT_SMALL(8ull)), d_Big_didentity(p10157_230))); }); break; } case 1: { V _m_228_a0_231 = FLD(m_228, 0); _r = ({ V p10158_232 = _m_228_a0_231; ap(scrut10155_218, d_Abi_dCodec_dscalar(((V)1), d_Big_dof_unat(NAT_SMALL(256ull)), p10158_232)); }); break; } case 2: { V _m_228_a0_233 = FLD(m_228, 0); _r = ({ V p10159_234 = _m_228_a0_233; ap(scrut10155_218, d_Abi_dCodec_dscalar(((V)2), d_Big_dof_unat(NAT_SMALL(160ull)), p10159_234)); }); break; } case 3: { V _m_228_a0_235 = FLD(m_228, 0); _r = ({ V p10160_236 = _m_228_a0_235; ap(scrut10155_218, DONE(d_Abi_dCodec_dword(((p10160_236) != FALSE_V ? d_Big_done() : d_Big_dzero())))); }); break; } case 4: { V _m_228_a0_237 = FLD(m_228, 0); _r = ({ V p10161_238 = _m_228_a0_237; ({ V scrut10162_239 = d_Big_dof_unat(str_length(p10161_238)); ({ V scrut10163_240 = d_Abi_dCodec_dpadding(scrut10162_239); ({ V scrut10164_241 = d_NativeInt_dsub(rt_ctor2(0, FALSE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(FALSE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, NIL)))))))))))))))))))))))))))))))))))))))))))))))))))))))))), offset_950_207); ((((d_Big_dis_ult(scrut10164_241, d_Big_dof_unat(NAT_SMALL(32ull)))) != FALSE_V ? TRUE_V : ((d_Big_dis_ult(d_NativeInt_dsub(scrut10164_241, d_Big_dof_unat(NAT_SMALL(32ull))), scrut10162_239)) != FALSE_V ? TRUE_V : d_Big_dis_ult(d_NativeInt_dsub(d_NativeInt_dsub(scrut10164_241, d_Big_dof_unat(NAT_SMALL(32ull))), scrut10162_239), scrut10163_240)))) != FALSE_V ? FAIL(((V)1)) : ({ V scrut10165_242 = str_append(d_Abi_dCodec_dword(d_Big_didentity(scrut10162_239)), str_append(p10161_238, d_NativeString_drepeat(d_Big_dto_unat(scrut10163_240), (((V)0u))))); ({ V a_243 = d_NativeInt_dadd(d_NativeInt_dadd(d_NativeInt_dadd(offset_950_207, d_Big_dof_unat(NAT_SMALL(32ull))), scrut10162_239), scrut10163_240); V a_244 = CON(d_Abi_dCodec_dword(d_Big_didentity(offset_950_207)), heads_951_208); V a_245 = CON(scrut10165_242, tails_952_209); V a_246 = p10147_217; offset_950_207 = a_243; heads_951_208 = a_244; tails_952_209 = a_245; param_968_210 = a_246;  goto _top; (V)0; }); })); }); }); }); }); break; } default: rt_panic("match: no case at abi:226"); } _r; }); }); }); }); }); } else rt_panic("match: no case at abi:224"); _r; }); });
}
V d_Abi_dCodec_dencode(V values_873_247) {
  return ({ V scrut10143_248 = d_Big_dof_unat(list_length(values_873_247)); ((d_Big_dis_ult(d_Big_dshift_uright(d_Big_dunsigned(NAT_SMALL(63ull), rt_ctor2(0, FALSE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(FALSE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, CON(TRUE_V, NIL))))))))))))))))))))))))))))))))))))))))))))))))))))))))))), d_Big_dto_unat(d_Big_dunsigned(NAT_SMALL(6ull), d_Big_dof_unat(NAT_SMALL(5ull))))), scrut10143_248)) != FALSE_V ? FAIL(((V)1)) : d_Local_dAbi_dbuild_df10144(d_NativeInt_dmul(scrut10143_248, d_Big_dof_unat(NAT_SMALL(32ull))), NIL, NIL, values_873_247)); });
}
V d_Local_dAbi_dread_df10170(V size_973_249, V data_972_250, V head_976_251, V tail_977_252, V values_978_253, V param_992_254) {
_top: ;
  return ({ V scrut10183_255 = param_992_254; ({ V _r = 0; V m_256 = scrut10183_255; if (((m_256) == NIL)) {  _r = ({ V __257 = UNIT; ((d_Big_dis_ueq(tail_977_252, size_973_249)) != FALSE_V ? DONE(list_reverse(values_978_253)) : FAIL(((V)6))); }); } else if (((m_256) != NIL)) { V _m_256_a0_258 = FLD(m_256, 0); V _m_256_a1_259 = FLD(m_256, 1); _r = ({ V p10184_260 = _m_256_a0_258; ({ V p10185_261 = _m_256_a1_259; ({ V _r = 0; V m_262 = d_Abi_dCodec_dread_uword(data_972_250, head_976_251); switch (tag_of(m_262)) { case 1: { V _m_262_a0_263 = FLD(m_262, 0); _r = ({ V item10231_264 = _m_262_a0_263; ({ V local10188_265 = item10231_264; ({ V _r = 0; V m_266 = ({ V scrut10190_267 = p10184_260; ({ V _r = 0; V m_268 = scrut10190_267; switch (tag_of(m_268)) { case 0: {  _r = ({ V __269 = UNIT; ((d_Abi_dCodec_dwithin(d_Big_dof_unat(NAT_SMALL(8ull)), local10188_265)) != FALSE_V ? DONE(rt_ctor2(0, rt_ctor1(0, d_Big_didentity(local10188_265)), tail_977_252)) : FAIL(rt_ctor1(0, ((V)0)))); }); break; } case 1: {  _r = ({ V __270 = UNIT; DONE(rt_ctor2(0, rt_ctor1(1, local10188_265), tail_977_252)); }); break; } case 2: {  _r = ({ V __271 = UNIT; ((d_Abi_dCodec_dwithin(d_Big_dof_unat(NAT_SMALL(160ull)), local10188_265)) != FALSE_V ? DONE(rt_ctor2(0, rt_ctor1(2, local10188_265), tail_977_252)) : FAIL(rt_ctor1(0, ((V)2)))); }); break; } case 3: {  _r = ({ V __272 = UNIT; ((d_Big_dis_ueq(local10188_265, d_Big_dzero())) != FALSE_V ? DONE(rt_ctor2(0, rt_ctor1(3, FALSE_V), tail_977_252)) : ((d_Big_dis_ueq(local10188_265, d_Big_done())) != FALSE_V ? DONE(rt_ctor2(0, rt_ctor1(3, TRUE_V), tail_977_252)) : FAIL(((V)3)))); }); break; } case 4: {  _r = ({ V __273 = UNIT; ((((d_Big_dis_ueq(local10188_265, d_Big_didentity(tail_977_252))) ^ 1u)) != FALSE_V ? FAIL(((V)4)) : ((d_Big_dis_ult(d_NativeInt_dsub(size_973_249, tail_977_252), d_Big_dof_unat(NAT_SMALL(32ull)))) != FALSE_V ? FAIL(((V)2)) : ({ V _r = 0; V m_274 = d_Abi_dCodec_dread_uword(data_972_250, tail_977_252); switch (tag_of(m_274)) { case 1: { V _m_274_a0_275 = FLD(m_274, 0); _r = ({ V item10209_276 = _m_274_a0_275; ({ V local10193_277 = item10209_276; ({ V scrut10194_278 = d_NativeInt_dsub(d_NativeInt_dsub(size_973_249, tail_977_252), d_Big_dof_unat(NAT_SMALL(32ull))); ((d_Big_dis_ult(d_Big_dzero(), d_Big_dcompare(local10193_277, d_Big_didentity(scrut10194_278)))) != FALSE_V ? FAIL(((V)2)) : ({ V scrut10195_279 = d_Big_didentity(local10193_277); ({ V scrut10196_280 = d_Abi_dCodec_dpadding(scrut10195_279); ((d_Big_dis_ult(d_NativeInt_dsub(scrut10194_278, scrut10195_279), scrut10196_280)) != FALSE_V ? FAIL(((V)2)) : ({ V scrut10197_281 = d_NativeInt_dadd(tail_977_252, d_Big_dof_unat(NAT_SMALL(32ull))); ({ V _r = 0; V m_282 = d_Abi_dCodec_dslice(data_972_250, d_NativeInt_dadd(scrut10197_281, scrut10195_279), scrut10196_280); switch (tag_of(m_282)) { case 1: { V _m_282_a0_283 = FLD(m_282, 0); _r = ({ V item10206_284 = _m_282_a0_283; ({ V local10200_285 = item10206_284; ((((d_NativeString_dequal(local10200_285, d_NativeString_drepeat(d_Big_dto_unat(scrut10196_280), (((V)0u))))) ^ 1u)) != FALSE_V ? FAIL(((V)5)) : ({ V _r = 0; V m_286 = d_Abi_dCodec_dslice(data_972_250, scrut10197_281, scrut10195_279); switch (tag_of(m_286)) { case 1: { V _m_286_a0_287 = FLD(m_286, 0); _r = ({ V item10204_288 = _m_286_a0_287; ({ V local10203_289 = item10204_288; DONE(rt_ctor2(0, rt_ctor1(4, local10203_289), d_NativeInt_dadd(d_NativeInt_dadd(scrut10197_281, scrut10195_279), scrut10196_280))); }); }); break; } case 0: { V _m_286_a0_290 = FLD(m_286, 0); _r = ({ V item10205_291 = _m_286_a0_290; FAIL(item10205_291); }); break; } default: rt_panic("match: no case at abi:243"); } _r; })); }); }); break; } case 0: { V _m_282_a0_292 = FLD(m_282, 0); _r = ({ V item10207_293 = _m_282_a0_292; FAIL(item10207_293); }); break; } default: rt_panic("match: no case at abi:243"); } _r; }); })); }); })); }); }); }); break; } case 0: { V _m_274_a0_294 = FLD(m_274, 0); _r = ({ V item10210_295 = _m_274_a0_294; FAIL(item10210_295); }); break; } default: rt_panic("match: no case at abi:239"); } _r; }))); }); break; } default: rt_panic("match: no case at abi:239"); } _r; }); }); switch (tag_of(m_266)) { case 1: { V _m_266_a0_296 = FLD(m_266, 0); _r = ({ V item10229_297 = _m_266_a0_296; ({ V local10213_298 = item10229_297; ({ V scrut10214_299 = local10213_298; ({ V _r = 0; V m_300 = scrut10214_299; if ((tag_of(m_300) == 0)) { V _m_300_a0_301 = FLD(m_300, 0); V _m_300_a1_302 = FLD(m_300, 1); _r = ({ V p10215_303 = _m_300_a0_301; ({ V p10216_304 = _m_300_a1_302; ({ V local10222_305 = d_NativeInt_dadd(head_976_251, d_Big_dof_unat(NAT_SMALL(32ull))); ({ V local10224_306 = p10216_304; ({ V local10226_307 = CON(p10215_303, values_978_253); ({ V local10228_308 = p10185_261; ({ V a_309 = local10222_305; V a_310 = local10224_306; V a_311 = local10226_307; V a_312 = local10228_308; head_976_251 = a_309; tail_977_252 = a_310; values_978_253 = a_311; param_992_254 = a_312;  goto _top; (V)0; }); }); }); }); }); }); }); } else rt_panic("match: no case at abi:244"); _r; }); }); }); }); break; } case 0: { V _m_266_a0_313 = FLD(m_266, 0); _r = ({ V item10230_314 = _m_266_a0_313; FAIL(item10230_314); }); break; } default: rt_panic("match: no case at abi:238"); } _r; }); }); }); break; } case 0: { V _m_262_a0_315 = FLD(m_262, 0); _r = ({ V item10232_316 = _m_262_a0_315; FAIL(item10232_316); }); break; } default: rt_panic("match: no case at abi:238"); } _r; }); }); }); } else rt_panic("match: no case at abi:238"); _r; }); });
}
V d_Abi_dCodec_ddecode(V types_971_317, V data_972_318) {
  return ({ V scrut10168_319 = d_Big_dof_unat(str_length(data_972_318)); ({ V scrut10169_320 = d_Big_dof_unat(list_length(types_971_317)); ((d_Big_dis_ult(d_Big_dshift_uright(d_Big_dunsigned(NAT_SMALL(63ull), scrut10168_319), d_Big_dto_unat(d_Big_dunsigned(NAT_SMALL(6ull), d_Big_dof_unat(NAT_SMALL(5ull))))), scrut10169_320)) != FALSE_V ? FAIL(((V)2)) : ({ V local10176_321 = d_Big_dzero(); ({ V local10178_322 = d_NativeInt_dmul(scrut10169_320, d_Big_dof_unat(NAT_SMALL(32ull))); ({ V local10180_323 = NIL; ({ V local10182_324 = types_971_317; d_Local_dAbi_dread_df10170(scrut10168_319, data_972_318, local10176_321, local10178_322, local10180_323, local10182_324); }); }); }); })); }); });
}
V d_Abi_dEvent_dResult_dbind(V value_325, V next_326) {
  return ({ V _r = 0; V m_327 = value_325; switch (tag_of(m_327)) { case 1: { V x_328 = FLD(m_327, 0); _r = ap(next_326, x_328); break; } case 0: { V error_329 = FLD(m_327, 0); _r = FAIL(error_329); break; } default: rt_panic("match: no case at abi:259"); } _r; });
}
V d_Abi_dEvent_dcodec(V result_330) {
  return ({ V _r = 0; V m_331 = result_330; switch (tag_of(m_331)) { case 1: { V bytes_332 = FLD(m_331, 0); _r = DONE(bytes_332); break; } case 0: { V error_333 = FLD(m_331, 0); _r = FAIL(rt_ctor1(3, error_333)); break; } default: rt_panic("match: no case at abi:263"); } _r; });
}
V d_Abi_dEvent_dvalue_utype(V value_334) {
  return ({ V _r = 0; V m_335 = value_334; switch (tag_of(m_335)) { case 0: {  _r = ((V)0); break; } case 1: {  _r = ((V)1); break; } case 2: {  _r = ((V)2); break; } case 3: {  _r = ((V)3); break; } case 4: {  _r = ((V)4); break; } default: rt_panic("match: no case at abi:267"); } _r; });
}
V d_Abi_dEvent_dtopic(V value_336) {
  return ({ V _r = 0; V m_337 = value_336; switch (tag_of(m_337)) { case 0: { V n_338 = FLD(m_337, 0); _r = d_Abi_dEvent_dcodec(d_Abi_dCodec_dscalar(((V)0), d_Big_dof_unat(NAT_SMALL(8ull)), n_338)); break; } case 1: { V n_339 = FLD(m_337, 0); _r = d_Abi_dEvent_dcodec(d_Abi_dCodec_dscalar(((V)1), d_Big_dof_unat(NAT_SMALL(256ull)), n_339)); break; } case 2: { V n_340 = FLD(m_337, 0); _r = d_Abi_dEvent_dcodec(d_Abi_dCodec_dscalar(((V)2), d_Big_dof_unat(NAT_SMALL(160ull)), n_340)); break; } case 3: { V b_341 = FLD(m_337, 0); _r = d_Abi_dEvent_dcodec(d_Abi_dCodec_dencode(CON(rt_ctor1(3, b_341), NIL))); break; } case 4: { V bytes_342 = FLD(m_337, 0); _r = DONE(d_Abi_dEvent_dhash(bytes_342)); break; } default: rt_panic("match: no case at abi:274"); } _r; });
}
V d_Abi_dEvent_dhash(V bytes_343) {
  return d_Abi_dCodec_dword(d_Big_dread_uvalidated(d_Big_dof_unat(NAT_SMALL(16ull)), d_Keccak_dkeccak256(bytes_343)));
}
V d_Abi_dEvent_dcount(V inputs_344) {
  return ({ V _r = 0; V m_345 = inputs_344; if (((m_345) == NIL)) {  _r = NAT_SMALL(0ull); } else if (((m_345) != NIL) && (tag_of(FLD(m_345, 0)) == 0)) { V indexed_346 = FLD(FLD(m_345, 0), 1); V tail_347 = FLD(m_345, 1); _r = nat_add(((indexed_346) != FALSE_V ? NAT_SMALL(1ull) : NAT_SMALL(0ull)), d_Abi_dEvent_dcount(tail_347)); } else rt_panic("match: no case at abi:284"); _r; });
}
V scc_0(uint32_t w, V *a) {
  V inputs_348;
  V values_349;
  V topics_350;
  V data_351;
  V typ_352;
  V indexed_353;
  V tail_354;
  V value_355;
  V rest_356;
  V topics_357;
  V data_358;
  switch (w) {
  default: inputs_348 = a[0]; values_349 = a[1]; topics_350 = a[2]; data_351 = a[3]; goto _m0;
  case 1: typ_352 = a[0]; indexed_353 = a[1]; tail_354 = a[2]; value_355 = a[3]; rest_356 = a[4]; topics_357 = a[5]; data_358 = a[6]; goto _m1;
  }
_m0: ;
  return ({ V _r = 0; V m_359 = inputs_348; V m_360 = values_349; if (((m_359) == NIL) && ((m_360) == NIL)) {  _r = d_Abi_dEvent_dResult_dbind(d_Abi_dEvent_dcodec(d_Abi_dCodec_dencode(list_reverse(data_351))), ({ V _c = clo_new(lam_362, 1, 1); CLO_ENV(_c)[0] = topics_350; _c; })); } else if (((m_359) == NIL) && ((m_360) != NIL)) {  _r = FAIL(((V)0)); } else if (((m_359) != NIL) && ((m_360) == NIL)) {  _r = FAIL(((V)0)); } else if (((m_359) != NIL) && (tag_of(FLD(m_359, 0)) == 0) && (tag_of(FLD(FLD(m_359, 0), 0)) == 0) && ((m_360) != NIL)) { V typ_363 = FLD(FLD(FLD(m_359, 0), 0), 1); V indexed_364 = FLD(FLD(m_359, 0), 1); V tail_365 = FLD(m_359, 1); V value_366 = FLD(m_360, 0); V rest_367 = FLD(m_360, 1); _r = ({ V a_368 = typ_363; V a_369 = indexed_364; V a_370 = tail_365; V a_371 = value_366; V a_372 = rest_367; V a_373 = topics_350; V a_374 = data_351; typ_352 = a_368; indexed_353 = a_369; tail_354 = a_370; value_355 = a_371; rest_356 = a_372; topics_357 = a_373; data_358 = a_374;  goto _m1; (V)0; }); } else rt_panic("match: no case at abi:290"); _r; });
_m1: ;
  return ((d_NativeString_dequal(d_Abi_dSchema_dtype_uname(typ_352), d_Abi_dSchema_dtype_uname(d_Abi_dEvent_dvalue_utype(value_355)))) != FALSE_V ? ((indexed_353) != FALSE_V ? d_Abi_dEvent_dResult_dbind(d_Abi_dEvent_dtopic(value_355), ({ V _c = clo_new(lam_376, 1, 4); CLO_ENV(_c)[0] = tail_354; CLO_ENV(_c)[1] = rest_356; CLO_ENV(_c)[2] = topics_357; CLO_ENV(_c)[3] = data_358; _c; })) : ({ V a_377 = tail_354; V a_378 = rest_356; V a_379 = topics_357; V a_380 = CON(value_355, data_358); inputs_348 = a_377; values_349 = a_378; topics_350 = a_379; data_351 = a_380;  goto _m0; (V)0; })) : FAIL(((V)1)));
}
V scc_0(uint32_t w, V *a);
V d_Abi_dEvent_dcollect(V inputs_348, V values_349, V topics_350, V data_351) {
  V w_a[] = {inputs_348, values_349, topics_350, data_351};
  return scc_0(0, w_a);
}
V scc_0(uint32_t w, V *a);
V d_Abi_dEvent_dfield(V typ_352, V indexed_353, V tail_354, V value_355, V rest_356, V topics_357, V data_358) {
  V w_a[] = {typ_352, indexed_353, tail_354, value_355, rest_356, topics_357, data_358};
  return scc_0(1, w_a);
}
V d_Abi_dEvent_dencode(V name_381, V inputs_382, V anonymous_383, V values_384) {
  return ({ V limit_385 = ((anonymous_383) != FALSE_V ? NAT_SMALL(4ull) : NAT_SMALL(3ull)); ((d_Big_dis_ule(d_Big_dof_unat(d_Abi_dEvent_dcount(inputs_382)), d_Big_dof_unat(limit_385))) != FALSE_V ? ({ V topics_386 = ((anonymous_383) != FALSE_V ? NIL : CON(d_Abi_dEvent_dhash(d_Abi_dSchema_devent_usignature(name_381, inputs_382)), NIL)); d_Abi_dEvent_dcollect(inputs_382, values_384, topics_386, NIL); }) : FAIL(((V)2))); });
}
V d_Abi_dCall_dResult_dbind(V value_387, V next_388) {
  return ({ V _r = 0; V m_389 = value_387; switch (tag_of(m_389)) { case 1: { V x_390 = FLD(m_389, 0); _r = ap(next_388, x_390); break; } case 0: { V error_391 = FLD(m_389, 0); _r = FAIL(error_391); break; } default: rt_panic("match: no case at abi:318"); } _r; });
}
V d_Abi_dCall_dcodec(V result_392) {
  return ({ V _r = 0; V m_393 = result_392; switch (tag_of(m_393)) { case 1: { V value_394 = FLD(m_393, 0); _r = DONE(value_394); break; } case 0: { V error_395 = FLD(m_393, 0); _r = FAIL(rt_ctor1(4, error_395)); break; } default: rt_panic("match: no case at abi:322"); } _r; });
}
V d_Abi_dCall_dselector(V fn_396) {
  return d_NativeString_dtake(NAT_SMALL(4ull), d_Abi_dCodec_dword(d_Big_dread_uvalidated(d_Big_dof_unat(NAT_SMALL(16ull)), d_Keccak_dkeccak256(d_Abi_dSchema_dfunction_usignature(fn_396)))));
}
V d_Abi_dCall_dvalidate(V inputs_397, V values_398) {
_top: ;
  return ({ V _r = 0; V m_399 = inputs_397; V m_400 = values_398; if (((m_399) == NIL) && ((m_400) == NIL)) {  _r = DONE(UNIT); } else if (((m_399) == NIL) && ((m_400) != NIL)) {  _r = FAIL(((V)0)); } else if (((m_399) != NIL) && ((m_400) == NIL)) {  _r = FAIL(((V)0)); } else if (((m_399) != NIL) && (tag_of(FLD(m_399, 0)) == 0) && ((m_400) != NIL)) { V typ_401 = FLD(FLD(m_399, 0), 1); V tail_402 = FLD(m_399, 1); V value_403 = FLD(m_400, 0); V rest_404 = FLD(m_400, 1); _r = ((d_NativeString_dequal(d_Abi_dSchema_dtype_uname(typ_401), d_Abi_dSchema_dtype_uname(d_Abi_dEvent_dvalue_utype(value_403)))) != FALSE_V ? ({ V a_405 = tail_402; V a_406 = rest_404; inputs_397 = a_405; values_398 = a_406;  goto _top; (V)0; }) : FAIL(((V)1))); } else rt_panic("match: no case at abi:330"); _r; });
}
V d_Abi_dCall_dencode(V fn_407, V values_408) {
  return d_Abi_dCall_dResult_dbind(d_Abi_dCall_dvalidate(d_Get_dAbi_dSchema_dFunction_u_dinputs(fn_407), values_408), ({ V _c = clo_new(lam_411, 1, 2); CLO_ENV(_c)[0] = values_408; CLO_ENV(_c)[1] = fn_407; _c; }));
}
V d_Abi_dCall_ddecode(V fn_412, V data_413) {
  return ((d_Big_dis_ult(d_Big_dof_unat(str_length(data_413)), d_Big_dof_unat(NAT_SMALL(4ull)))) != FALSE_V ? FAIL(((V)2)) : ((d_NativeString_dequal(d_NativeString_dtake(NAT_SMALL(4ull), data_413), d_Abi_dCall_dselector(fn_412))) != FALSE_V ? d_Abi_dCall_dcodec(d_Abi_dCodec_ddecode(d_SeqList_dmap(clo_new(lam_415, 1, 0), d_Get_dAbi_dSchema_dFunction_u_dinputs(fn_412)), d_NativeString_ddrop(NAT_SMALL(4ull), data_413))) : FAIL(((V)3))));
}
V d_Abi_dReturn_dResult_dbind(V value_416, V next_417) {
  return ({ V _r = 0; V m_418 = value_416; switch (tag_of(m_418)) { case 1: { V x_419 = FLD(m_418, 0); _r = ap(next_417, x_419); break; } case 0: { V error_420 = FLD(m_418, 0); _r = FAIL(error_420); break; } default: rt_panic("match: no case at abi:355"); } _r; });
}
V d_Abi_dReturn_dcodec(V result_421) {
  return ({ V _r = 0; V m_422 = result_421; switch (tag_of(m_422)) { case 1: { V value_423 = FLD(m_422, 0); _r = DONE(value_423); break; } case 0: { V error_424 = FLD(m_422, 0); _r = FAIL(rt_ctor1(2, error_424)); break; } default: rt_panic("match: no case at abi:359"); } _r; });
}
V d_Abi_dReturn_dvalidate(V outputs_425, V values_426) {
_top: ;
  return ({ V _r = 0; V m_427 = outputs_425; V m_428 = values_426; if (((m_427) == NIL) && ((m_428) == NIL)) {  _r = DONE(UNIT); } else if (((m_427) == NIL) && ((m_428) != NIL)) {  _r = FAIL(((V)0)); } else if (((m_427) != NIL) && ((m_428) == NIL)) {  _r = FAIL(((V)0)); } else if (((m_427) != NIL) && (tag_of(FLD(m_427, 0)) == 0) && ((m_428) != NIL)) { V typ_429 = FLD(FLD(m_427, 0), 1); V tail_430 = FLD(m_427, 1); V value_431 = FLD(m_428, 0); V rest_432 = FLD(m_428, 1); _r = ((d_NativeString_dequal(d_Abi_dSchema_dtype_uname(typ_429), d_Abi_dSchema_dtype_uname(d_Abi_dEvent_dvalue_utype(value_431)))) != FALSE_V ? ({ V a_433 = tail_430; V a_434 = rest_432; outputs_425 = a_433; values_426 = a_434;  goto _top; (V)0; }) : FAIL(((V)1))); } else rt_panic("match: no case at abi:364"); _r; });
}
V d_Abi_dReturn_dencode(V fn_435, V values_436) {
  return d_Abi_dReturn_dResult_dbind(d_Abi_dReturn_dvalidate(d_Get_dAbi_dSchema_dFunction_u_doutputs(fn_435), values_436), ({ V _c = clo_new(lam_437, 1, 1); CLO_ENV(_c)[0] = values_436; _c; }));
}
V d_Abi_dReturn_ddecode(V fn_438, V data_439) {
  return d_Abi_dReturn_dcodec(d_Abi_dCodec_ddecode(d_SeqList_dmap(clo_new(lam_441, 1, 0), d_Get_dAbi_dSchema_dFunction_u_doutputs(fn_438)), data_439));
}
V d_Abi_dRevert_dcall(V result_442) {
  return ({ V _r = 0; V m_443 = result_442; switch (tag_of(m_443)) { case 1: { V value_444 = FLD(m_443, 0); _r = DONE(value_444); break; } case 0: { V error_445 = FLD(m_443, 0); _r = FAIL(rt_ctor1(1, error_445)); break; } default: rt_panic("match: no case at abi:384"); } _r; });
}
V d_Abi_dRevert_dapply(V declaration_446, V action_447) {
  return ({ V _r = 0; V m_448 = declaration_446; switch (tag_of(m_448)) { case 2: { V name_449 = FLD(m_448, 0); V parameters_450 = FLD(m_448, 1); _r = d_Abi_dRevert_dcall(ap(action_447, rt_ctor4(0, name_449, parameters_450, NIL, ((V)1)))); break; } case 0: {  _r = FAIL(((V)0)); break; } case 1: {  _r = FAIL(((V)0)); break; } case 3: {  _r = FAIL(((V)0)); break; } case 4: {  _r = FAIL(((V)0)); break; } default: rt_panic("match: no case at abi:388"); } _r; });
}
V d_Abi_dRevert_dencode(V declaration_451, V values_452) {
  return d_Abi_dRevert_dapply(declaration_451, ({ V _c = clo_new(lam_454, 1, 1); CLO_ENV(_c)[0] = values_452; _c; }));
}
V d_Abi_dRevert_ddecode(V declaration_455, V data_456) {
  return d_Abi_dRevert_dapply(declaration_455, ({ V _c = clo_new(lam_458, 1, 1); CLO_ENV(_c)[0] = data_456; _c; }));
}
V d_Abi_dEvent_dDecode_uresult_dbind(V value_459, V next_460) {
  return ({ V _r = 0; V m_461 = value_459; switch (tag_of(m_461)) { case 1: { V value_462 = FLD(m_461, 0); _r = ap(next_460, value_462); break; } case 0: { V error_463 = FLD(m_461, 0); _r = FAIL(error_463); break; } default: rt_panic("match: no case at abi:412"); } _r; });
}
V d_Abi_dEvent_ddecode_ucodec(V value_464) {
  return ({ V _r = 0; V m_465 = value_464; switch (tag_of(m_465)) { case 1: { V value_466 = FLD(m_465, 0); _r = DONE(value_466); break; } case 0: { V error_467 = FLD(m_465, 0); _r = FAIL(rt_ctor1(4, error_467)); break; } default: rt_panic("match: no case at abi:416"); } _r; });
}
V d_Abi_dEvent_ddata_utypes(V inputs_468) {
_top: ;
  return ({ V _r = 0; V m_469 = inputs_468; if (((m_469) == NIL)) {  _r = NIL; } else if (((m_469) != NIL) && (tag_of(FLD(m_469, 0)) == 0) && (tag_of(FLD(FLD(m_469, 0), 0)) == 0)) { V typ_470 = FLD(FLD(FLD(m_469, 0), 0), 1); V indexed_471 = FLD(FLD(m_469, 0), 1); V tail_472 = FLD(m_469, 1); _r = ((indexed_471) != FALSE_V ? ({ V a_473 = tail_472; inputs_468 = a_473;  goto _top; (V)0; }) : CON(typ_470, d_Abi_dEvent_ddata_utypes(tail_472))); } else rt_panic("match: no case at abi:421"); _r; });
}
V d_Abi_dEvent_dtopic_usizes(V topics_474) {
_top: ;
  return ({ V _r = 0; V m_475 = topics_474; if (((m_475) == NIL)) {  _r = DONE(UNIT); } else if (((m_475) != NIL)) { V topic_476 = FLD(m_475, 0); V tail_477 = FLD(m_475, 1); _r = ((d_Big_dis_ueq(d_Big_dof_unat(str_length(topic_476)), d_Big_dof_unat(NAT_SMALL(32ull)))) != FALSE_V ? ({ V a_478 = tail_477; topics_474 = a_478;  goto _top; (V)0; }) : FAIL(((V)2))); } else rt_panic("match: no case at abi:427"); _r; });
}
V d_Abi_dEvent_ddecode_utopic(V typ_479, V topic_480) {
  return ({ V _r = 0; V m_481 = typ_479; switch (tag_of(m_481)) { case 4: {  _r = DONE(rt_ctor1(1, topic_480)); break; } case 0: {  _r = d_Abi_dEvent_ddecode_uscalar(((V)0), topic_480); break; } case 1: {  _r = d_Abi_dEvent_ddecode_uscalar(((V)1), topic_480); break; } case 2: {  _r = d_Abi_dEvent_ddecode_uscalar(((V)2), topic_480); break; } case 3: {  _r = d_Abi_dEvent_ddecode_uscalar(((V)3), topic_480); break; } default: rt_panic("match: no case at abi:434"); } _r; });
}
V d_Abi_dEvent_ddecode_uscalar(V typ_482, V topic_483) {
  return d_Abi_dEvent_dDecode_uresult_dbind(d_Abi_dEvent_ddecode_ucodec(d_Abi_dCodec_ddecode(CON(typ_482, NIL), topic_483)), clo_new(w_Abi_dEvent_dsingle, 1, 0));
}
V d_Abi_dEvent_dsingle(V values_484) {
  return ({ V _r = 0; V m_485 = values_484; if (((m_485) != NIL) && ((FLD(m_485, 1)) == NIL)) { V value_486 = FLD(m_485, 0); _r = DONE(rt_ctor1(0, value_486)); } else if (((m_485) == NIL)) {  _r = FAIL(((V)1)); } else if (((m_485) != NIL) && ((FLD(m_485, 1)) != NIL)) {  _r = FAIL(((V)1)); } else rt_panic("match: no case at abi:444"); _r; });
}
V d_Abi_dEvent_dmerge(V inputs_487, V topics_488, V values_489) {
  return ({ V _r = 0; V m_490 = inputs_487; if (((m_490) == NIL)) {  _r = ({ V _r = 0; V m_491 = topics_488; V m_492 = values_489; if (((m_491) == NIL) && ((m_492) == NIL)) {  _r = DONE(NIL); } else if (((m_491) == NIL) && ((m_492) != NIL)) {  _r = FAIL(((V)1)); } else if (((m_491) != NIL)) {  _r = FAIL(((V)1)); } else rt_panic("match: no case at abi:452"); _r; }); } else if (((m_490) != NIL) && (tag_of(FLD(m_490, 0)) == 0) && (tag_of(FLD(FLD(m_490, 0), 0)) == 0)) { V typ_493 = FLD(FLD(FLD(m_490, 0), 0), 1); V indexed_494 = FLD(FLD(m_490, 0), 1); V tail_495 = FLD(m_490, 1); _r = ((indexed_494) != FALSE_V ? d_Abi_dEvent_dmerge_utopic(typ_493, tail_495, topics_488, values_489) : d_Abi_dEvent_dmerge_uvalue(tail_495, topics_488, values_489)); } else rt_panic("match: no case at abi:450"); _r; });
}
V d_Abi_dEvent_dmerge_utopic(V typ_496, V tail_497, V topics_498, V values_499) {
  return ({ V _r = 0; V m_500 = topics_498; if (((m_500) == NIL)) {  _r = FAIL(((V)1)); } else if (((m_500) != NIL)) { V topic_501 = FLD(m_500, 0); V rest_502 = FLD(m_500, 1); _r = d_Abi_dEvent_dDecode_uresult_dbind(d_Abi_dEvent_ddecode_utopic(typ_496, topic_501), ({ V _c = clo_new(lam_506, 1, 3); CLO_ENV(_c)[0] = tail_497; CLO_ENV(_c)[1] = rest_502; CLO_ENV(_c)[2] = values_499; _c; })); } else rt_panic("match: no case at abi:461"); _r; });
}
V d_Abi_dEvent_dmerge_uvalue(V tail_507, V topics_508, V values_509) {
  return ({ V _r = 0; V m_510 = values_509; if (((m_510) == NIL)) {  _r = FAIL(((V)1)); } else if (((m_510) != NIL)) { V value_511 = FLD(m_510, 0); V rest_512 = FLD(m_510, 1); _r = d_Abi_dEvent_dDecode_uresult_dbind(d_Abi_dEvent_dmerge(tail_507, topics_508, rest_512), ({ V _c = clo_new(lam_514, 1, 1); CLO_ENV(_c)[0] = value_511; _c; })); } else rt_panic("match: no case at abi:468"); _r; });
}
V d_Abi_dEvent_ddecode_ufields(V inputs_515, V topics_516, V data_517) {
  return d_Abi_dEvent_dDecode_uresult_dbind(d_Abi_dEvent_ddecode_ucodec(d_Abi_dCodec_ddecode(d_Abi_dEvent_ddata_utypes(inputs_515), data_517)), ({ V _c = clo_new(lam_519, 1, 2); CLO_ENV(_c)[0] = inputs_515; CLO_ENV(_c)[1] = topics_516; _c; }));
}
V d_Abi_dEvent_ddecode_usignature(V name_520, V inputs_521, V anonymous_522, V topics_523, V data_524) {
  return ((anonymous_522) != FALSE_V ? d_Abi_dEvent_ddecode_ufields(inputs_521, topics_523, data_524) : d_Abi_dEvent_ddecode_unamed(name_520, inputs_521, topics_523, data_524));
}
V d_Abi_dEvent_ddecode_unamed(V name_525, V inputs_526, V topics_527, V data_528) {
  return ({ V _r = 0; V m_529 = topics_527; if (((m_529) == NIL)) {  _r = FAIL(((V)1)); } else if (((m_529) != NIL)) { V signature_530 = FLD(m_529, 0); V rest_531 = FLD(m_529, 1); _r = ((d_NativeString_dequal(signature_530, d_Abi_dEvent_dhash(d_Abi_dSchema_devent_usignature(name_525, inputs_526)))) != FALSE_V ? d_Abi_dEvent_ddecode_ufields(inputs_526, rest_531, data_528) : FAIL(((V)3))); } else rt_panic("match: no case at abi:480"); _r; });
}
V d_Abi_dEvent_ddecode(V name_532, V inputs_533, V anonymous_534, V log_535) {
  return ({ V _r = 0; V m_536 = log_535; if ((tag_of(m_536) == 0)) { V topics_537 = FLD(m_536, 0); V data_538 = FLD(m_536, 1); _r = ({ V count_539 = d_Abi_dEvent_dcount(inputs_533); ({ V limit_540 = ((anonymous_534) != FALSE_V ? NAT_SMALL(4ull) : NAT_SMALL(3ull)); ({ V expected_541 = nat_add(count_539, ((anonymous_534) != FALSE_V ? NAT_SMALL(0ull) : NAT_SMALL(1ull))); ((d_Big_dis_ule(d_Big_dof_unat(count_539), d_Big_dof_unat(limit_540))) != FALSE_V ? ((d_Big_dis_ueq(d_Big_dof_unat(list_length(topics_537)), d_Big_dof_unat(expected_541))) != FALSE_V ? d_Abi_dEvent_dDecode_uresult_dbind(d_Abi_dEvent_dtopic_usizes(topics_537), ({ V _c = clo_new(lam_542, 1, 5); CLO_ENV(_c)[0] = name_532; CLO_ENV(_c)[1] = inputs_533; CLO_ENV(_c)[2] = anonymous_534; CLO_ENV(_c)[3] = topics_537; CLO_ENV(_c)[4] = data_538; _c; })) : FAIL(((V)1))) : FAIL(((V)0))); }); }); }); } else rt_panic("match: no case at abi:487"); _r; });
}
