/* generated from src/external_call.bend */
#include "assay_gen.h"

static Str S_0 = {TAG_STR, 1, {(const uint8_t *)";"}};
static Str S_1 = {TAG_STR, 2, {(const uint8_t *)"0x"}};
static V lam_11(V *env, V *args) {
  (void)env; (void)args;
  V c_10 = args[0];
  return d_ExternalCall_dhex_udigit(c_10);
}
static Str S_2 = {TAG_STR, 4, {(const uint8_t *)"call"}};
static Str S_3 = {TAG_STR, 31, {(const uint8_t *)"call must bind its success word"}};
static Str S_4 = {TAG_STR, 29, {(const uint8_t *)"returndata must bind its word"}};
static Str S_5 = {TAG_STR, 4, {(const uint8_t *)"CALL"}};
static Str S_6 = {TAG_STR, 28, {(const uint8_t *)"returndata takes no operands"}};
static Str S_7 = {TAG_STR, 33, {(const uint8_t *)"call expects a target and a value"}};
static Str S_8 = {TAG_STR, 42, {(const uint8_t *)"call selector must be a 4-byte hex literal"}};
static Str S_9 = {TAG_STR, 37, {(const uint8_t *)"call accepts at most 8 word arguments"}};
static V lam_143(V *env, V *args) {
  (void)env; (void)args;
  V step_142 = args[0];
  return d_ExternalCall_dis_ustep(step_142);
}
static V lam_144(V *env, V *args) {
  (void)env; (void)args;
  V entry_141 = args[0];
  return d_SeqList_dexists(clo_new(lam_143, 1, 0), d_Get_dTuple2_dv0(d_Get_dContract_dEntry_dbody(entry_141)));
}
static Str S_10 = {TAG_STR, 3, {(const uint8_t *)"nil"}};
static Str S_11 = {TAG_STR, 3, {(const uint8_t *)"arg"}};
static Str S_12 = {TAG_STR, 7, {(const uint8_t *)"callraw"}};
static Str S_13 = {TAG_STR, 2, {(const uint8_t *)"Tx"}};
static V lam_183(V *env, V *args) {
  (void)env; (void)args;
  V name_178 = args[0];
  return ({ V _r = 0; V m_179 = d_Recognize_dconstructor_utag(env[0], ((V)&S_13), name_178); if (((m_179) == NONE)) {  _r = ({ V __180 = UNIT; NONE; }); } else if (((m_179) != NONE)) { V _m_179_a0_181 = FLD(m_179, 0); _r = ({ V tag_182 = _m_179_a0_181; SOME(rt_ctor2(0, tag_182, name_178)); }); } else rt_panic("match: no case at external_call:112"); _r; });
}
static Str S_14 = {TAG_STR, 10, {(const uint8_t *)"returndata"}};
static V lam_187(V *env, V *args) {
  (void)env; (void)args;
  V row_186 = args[0];
  return d_Big_dis_ueq(d_Get_dTuple2_dv0(row_186), env[0]);
}
static Str S_15 = {TAG_STR, 14, {(const uint8_t *)"call arguments"}};
static V lam_202(V *env, V *args) {
  (void)env; (void)args;
  V more_201 = args[0];
  return DONE(CON(env[0], more_201));
}
static V lam_203(V *env, V *args) {
  (void)env; (void)args;
  V head_200 = args[0];
  return d_Emit_dResult_dbind(d_Emit_dcall_uarguments(env[0]), ({ V _c = clo_new(lam_202, 1, 1); CLO_ENV(_c)[0] = head_200; _c; }));
}
static V lam_217(V *env, V *args) {
  (void)env; (void)args;
  V done_209 = args[0];
  return ({ V _r = 0; V m_210 = done_209; if ((tag_of(m_210) == 0)) { V _m_210_a0_211 = FLD(m_210, 0); V _m_210_a1_212 = FLD(m_210, 1); V _m_210_a2_213 = FLD(m_210, 2); _r = ({ V tx_214 = _m_210_a0_211; ({ V fuel2_215 = _m_210_a1_212; ({ V fresh2_216 = _m_210_a2_213; DONE(rt_ctor3(0, ap2(env[0], env[1], tx_214), fuel2_215, fresh2_216)); }); }); }); } else rt_panic("match: no case at external_call:159"); _r; });
}
static V lam_233(V *env, V *args) {
  (void)env; (void)args;
  V operand_232 = args[0];
  return ap2(env[0], operand_232, env[1]);
}
static V lam_244(V *env, V *args) {
  (void)env; (void)args;
  V a_243 = args[0];
  return ap3(env[0], env[1], a_243, env[2]);
}
static V lam_245(V *env, V *args) {
  (void)env; (void)args;
  V s_242 = args[0];
  return d_Emit_dResult_dbind(d_Emit_dcall_uarguments(env[0]), ({ V _c = clo_new(lam_244, 1, 3); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = s_242; CLO_ENV(_c)[2] = env[2]; _c; }));
}
static V lam_253(V *env, V *args) {
  (void)env; (void)args;
  V binder_251 = args[0];
  V tx_252 = args[1];
  return rt_ctor2(10, binder_251, tx_252);
}
static V lam_260(V *env, V *args) {
  (void)env; (void)args;
  V binder_258 = args[0];
  V tx_259 = args[1];
  return ({ Obj *_o = rt_ctor(9, 6); _o->f[0] = env[0]; _o->f[1] = env[1]; _o->f[2] = NONE; _o->f[3] = NIL; _o->f[4] = binder_258; _o->f[5] = tx_259; (V)_o; });
}
static V lam_266(V *env, V *args) {
  (void)env; (void)args;
  V binder_264 = args[0];
  V tx_265 = args[1];
  return ({ Obj *_o = rt_ctor(9, 6); _o->f[0] = env[0]; _o->f[1] = env[1]; _o->f[2] = SOME(env[2]); _o->f[3] = env[3]; _o->f[4] = binder_264; _o->f[5] = tx_265; (V)_o; });
}
static V lam_267(V *env, V *args) {
  (void)env; (void)args;
  V s_261 = args[0];
  V a_262 = args[1];
  V tail_263 = args[2];
  return d_Emit_dresume_ulast(tail_263, env[0], env[1], env[2], ({ V _c = clo_new(lam_266, 2, 4); CLO_ENV(_c)[0] = env[3]; CLO_ENV(_c)[1] = env[4]; CLO_ENV(_c)[2] = s_261; CLO_ENV(_c)[3] = a_262; _c; }));
}
static V lam_268(V *env, V *args) {
  (void)env; (void)args;
  V value_256 = args[0];
  V more_257 = args[1];
  return ((d_NativeString_dequal(env[0], ((V)&S_12))) != FALSE_V ? d_Emit_dresume_ulast(more_257, env[1], env[2], env[3], ({ V _c = clo_new(lam_260, 2, 2); CLO_ENV(_c)[0] = env[4]; CLO_ENV(_c)[1] = value_256; _c; })) : d_Emit_dtake_ucalldata(more_257, ({ V _c = clo_new(lam_267, 3, 5); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; CLO_ENV(_c)[3] = env[4]; CLO_ENV(_c)[4] = value_256; _c; })));
}
static V lam_269(V *env, V *args) {
  (void)env; (void)args;
  V target_254 = args[0];
  V rest_255 = args[1];
  return d_Emit_dtake_uoperand(rest_255, ({ V _c = clo_new(lam_268, 2, 5); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; CLO_ENV(_c)[2] = env[2]; CLO_ENV(_c)[3] = env[3]; CLO_ENV(_c)[4] = target_254; _c; }));
}
static V lam_279(V *env, V *args) {
  (void)env; (void)args;
  V x_277 = args[0];
  V y_278 = args[1];
  return d_Big_dis_ueq(x_277, y_278);
}
static Str S_16 = {TAG_STR, 14, {(const uint8_t *)"Tx constructor"}};
static V lam_299(V *env, V *args) {
  (void)env; (void)args;
  V packet_298 = args[0];
  return d_Emit_dlowerable_upacket(packet_298);
}
static V lam_309(V *env, V *args) {
  (void)env; (void)args;
  V entry_308 = args[0];
  return d_Emit_dhas_uexternal(d_Get_dEmit_dEntry_dtx(entry_308));
}
static Str S_17 = {TAG_STR, 62, {(const uint8_t *)"CALL: external call lowering is not available until M3 group 3"}};

V d_ExternalCall_dends(V tokens_1) {
  return ({ V _r = 0; V m_2 = tokens_1; if (((m_2) != NIL)) { V head_3 = FLD(m_2, 0); _r = d_NativeString_dequal(d_Get_dContract_dToken_dtext(head_3), ((V)&S_0)); } else if (((m_2) == NIL)) {  _r = TRUE_V; } else rt_panic("match: no case at external_call:12"); _r; });
}
V d_ExternalCall_dwithin(V code_4, V low_5, V high_6) {
  return ((d_Big_dis_ule(low_5, code_4)) & (d_Big_dis_ule(code_4, high_6)));
}
V d_ExternalCall_dhex_udigit(V c_7) {
  return d_ExternalCall_dhex_ucode(d_Big_dof_unat(NAT_SMALL((d_NativeChar_dlower(c_7)))));
}
V d_ExternalCall_dhex_ucode(V code_8) {
  return ((d_ExternalCall_dwithin(code_8, d_Big_dof_unat(NAT_SMALL(48ull)), d_Big_dof_unat(NAT_SMALL(57ull)))) | (d_ExternalCall_dwithin(code_8, d_Big_dof_unat(NAT_SMALL(97ull)), d_Big_dof_unat(NAT_SMALL(102ull)))));
}
V d_ExternalCall_dis_uselector(V text_9) {
  return ((d_Big_dis_ueq(d_Big_dof_unat(str_length(text_9)), d_Big_dof_unat(NAT_SMALL(10ull)))) & (((d_NativeString_dequal(d_NativeString_dtake(NAT_SMALL(2ull), text_9), ((V)&S_1))) & (d_NativeString_dall(clo_new(lam_11, 1, 0), d_NativeString_ddrop(NAT_SMALL(2ull), text_9))))));
}
V d_ExternalCall_dunbound(V keyword_12) {
  return ((d_NativeString_dequal(keyword_12, ((V)&S_2))) != FALSE_V ? ((V)&S_3) : ((V)&S_4));
}
V d_ExternalCall_dreturndata(V binder_13, V tokens_14) {
  return ((d_ExternalCall_dends(tokens_14)) != FALSE_V ? DONE(rt_ctor2(0, rt_ctor1(12, binder_13), tokens_14)) : d_Contract_dfail(d_Contract_dhere(tokens_14), ((V)&S_5), ((V)&S_6)));
}
V d_ExternalCall_doperand(V keyword_15, V tokens_16) {
  return ((d_ExternalCall_dends(tokens_16)) != FALSE_V ? d_Contract_dfail(keyword_15, ((V)&S_5), ((V)&S_7)) : d_Contract_dvalue(d_Big_dzero(), tokens_16));
}
V d_ExternalCall_dcall(V binder_17, V keyword_18, V tokens_19) {
  return ({ V t_20 = d_ExternalCall_doperand(keyword_18, tokens_19); V _r; if (tag_of(t_20) == 0) _r = t_20; else { V first_21 = FLD(t_20, 0); _r = ({ V _r = 0; V m_22 = first_21; if ((tag_of(m_22) == 0)) { V _m_22_a0_23 = FLD(m_22, 0); V _m_22_a1_24 = FLD(m_22, 1); _r = ({ V target_25 = _m_22_a0_23; ({ V after_26 = _m_22_a1_24; ({ V t_27 = d_ExternalCall_doperand(keyword_18, after_26); V _r; if (tag_of(t_27) == 0) _r = t_27; else { V second_28 = FLD(t_27, 0); _r = ({ V _r = 0; V m_29 = second_28; if ((tag_of(m_29) == 0)) { V _m_29_a0_30 = FLD(m_29, 0); V _m_29_a1_31 = FLD(m_29, 1); _r = ({ V value_32 = _m_29_a0_30; ({ V rest_33 = _m_29_a1_31; d_ExternalCall_dcalldata(binder_17, keyword_18, target_25, value_32, rest_33); }); }); } else rt_panic("match: no case at external_call:47"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at external_call:45"); _r; }); } _r; });
}
V d_ExternalCall_dcalldata(V binder_34, V keyword_35, V target_36, V value_37, V tokens_38) {
  return ({ V _r = 0; V m_39 = tokens_38; if (((m_39) == NIL)) {  _r = DONE(rt_ctor2(0, rt_ctor4(11, binder_34, target_36, value_37, NONE), NIL)); } else if (((m_39) != NIL)) { V selector_40 = FLD(m_39, 0); V rest_41 = FLD(m_39, 1); _r = ((d_NativeString_dequal(d_Get_dContract_dToken_dtext(selector_40), ((V)&S_0))) != FALSE_V ? DONE(rt_ctor2(0, rt_ctor4(11, binder_34, target_36, value_37, NONE), CON(selector_40, rest_41))) : ((d_ExternalCall_dis_uselector(d_Get_dContract_dToken_dtext(selector_40))) != FALSE_V ? d_ExternalCall_darguments(binder_34, keyword_35, target_36, value_37, selector_40, rest_41) : d_Contract_dfail(selector_40, ((V)&S_5), ((V)&S_8)))); } else rt_panic("match: no case at external_call:51"); _r; });
}
V d_ExternalCall_darguments(V binder_42, V keyword_43, V target_44, V value_45, V selector_46, V tokens_47) {
  return ({ V t_48 = d_ExternalCall_dwords(tokens_47); V _r; if (tag_of(t_48) == 0) _r = t_48; else { V parsed_49 = FLD(t_48, 0); _r = ({ V _r = 0; V m_50 = parsed_49; if ((tag_of(m_50) == 0)) { V _m_50_a0_51 = FLD(m_50, 0); V _m_50_a1_52 = FLD(m_50, 1); _r = ({ V words_53 = _m_50_a0_51; ({ V rest_54 = _m_50_a1_52; ((d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(8ull)), d_Big_dof_unat(list_length(words_53)))) != FALSE_V ? d_Contract_dfail(keyword_43, ((V)&S_5), ((V)&S_9)) : DONE(rt_ctor2(0, rt_ctor4(11, binder_42, target_44, value_45, SOME(rt_ctor2(0, selector_46, words_53))), rest_54))); }); }); } else rt_panic("match: no case at external_call:62"); _r; }); } _r; });
}
V d_ExternalCall_dwords(V tokens_55) {
  return ((d_ExternalCall_dends(tokens_55)) != FALSE_V ? DONE(rt_ctor2(0, NIL, tokens_55)) : ({ V t_56 = d_Contract_dvalue(d_Big_dzero(), tokens_55); V _r; if (tag_of(t_56) == 0) _r = t_56; else { V first_57 = FLD(t_56, 0); _r = ({ V _r = 0; V m_58 = first_57; if ((tag_of(m_58) == 0)) { V _m_58_a0_59 = FLD(m_58, 0); V _m_58_a1_60 = FLD(m_58, 1); _r = ({ V word_61 = _m_58_a0_59; ({ V after_62 = _m_58_a1_60; ({ V t_63 = d_ExternalCall_dwords(after_62); V _r; if (tag_of(t_63) == 0) _r = t_63; else { V more_64 = FLD(t_63, 0); _r = ({ V _r = 0; V m_65 = more_64; if ((tag_of(m_65) == 0)) { V _m_65_a0_66 = FLD(m_65, 0); V _m_65_a1_67 = FLD(m_65, 1); _r = ({ V words_68 = _m_65_a0_66; ({ V rest_69 = _m_65_a1_67; DONE(rt_ctor2(0, CON(word_61, words_68), rest_69)); }); }); } else rt_panic("match: no case at external_call:73"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at external_call:71"); _r; }); } _r; }));
}
V d_ExternalCall_dis_ustep(V step_70) {
  return ({ V _r = 0; V m_71 = step_70; switch (tag_of(m_71)) { case 0: { V _m_71_a0_72 = FLD(m_71, 0); V _m_71_a1_73 = FLD(m_71, 1); _r = ({ V a_74 = _m_71_a0_72; ({ V b_75 = _m_71_a1_73; FALSE_V; }); }); break; } case 1: { V _m_71_a0_76 = FLD(m_71, 0); V _m_71_a1_77 = FLD(m_71, 1); _r = ({ V a_78 = _m_71_a0_76; ({ V b_79 = _m_71_a1_77; FALSE_V; }); }); break; } case 2: { V _m_71_a0_80 = FLD(m_71, 0); _r = ({ V a_81 = _m_71_a0_80; FALSE_V; }); break; } case 3: { V _m_71_a0_82 = FLD(m_71, 0); V _m_71_a1_83 = FLD(m_71, 1); V _m_71_a2_84 = FLD(m_71, 2); _r = ({ V a_85 = _m_71_a0_82; ({ V b_86 = _m_71_a1_83; ({ V c_87 = _m_71_a2_84; FALSE_V; }); }); }); break; } case 4: { V _m_71_a0_88 = FLD(m_71, 0); V _m_71_a1_89 = FLD(m_71, 1); V _m_71_a2_90 = FLD(m_71, 2); _r = ({ V a_91 = _m_71_a0_88; ({ V b_92 = _m_71_a1_89; ({ V c_93 = _m_71_a2_90; FALSE_V; }); }); }); break; } case 5: { V _m_71_a0_94 = FLD(m_71, 0); V _m_71_a1_95 = FLD(m_71, 1); _r = ({ V a_96 = _m_71_a0_94; ({ V b_97 = _m_71_a1_95; FALSE_V; }); }); break; } case 6: { V _m_71_a0_98 = FLD(m_71, 0); V _m_71_a1_99 = FLD(m_71, 1); _r = ({ V a_100 = _m_71_a0_98; ({ V b_101 = _m_71_a1_99; FALSE_V; }); }); break; } case 7: { V _m_71_a0_102 = FLD(m_71, 0); V _m_71_a1_103 = FLD(m_71, 1); _r = ({ V a_104 = _m_71_a0_102; ({ V b_105 = _m_71_a1_103; FALSE_V; }); }); break; } case 8: { V _m_71_a0_106 = FLD(m_71, 0); V _m_71_a1_107 = FLD(m_71, 1); V _m_71_a2_108 = FLD(m_71, 2); V _m_71_a3_109 = FLD(m_71, 3); _r = ({ V a_110 = _m_71_a0_106; ({ V b_111 = _m_71_a1_107; ({ V c_112 = _m_71_a2_108; ({ V d_113 = _m_71_a3_109; FALSE_V; }); }); }); }); break; } case 9: { V _m_71_a0_114 = FLD(m_71, 0); V _m_71_a1_115 = FLD(m_71, 1); V _m_71_a2_116 = FLD(m_71, 2); V _m_71_a3_117 = FLD(m_71, 3); V _m_71_a4_118 = FLD(m_71, 4); _r = ({ V a_119 = _m_71_a0_114; ({ V b_120 = _m_71_a1_115; ({ V c_121 = _m_71_a2_116; ({ V d_122 = _m_71_a3_117; ({ V e_123 = _m_71_a4_118; FALSE_V; }); }); }); }); }); break; } case 10: { V _m_71_a0_124 = FLD(m_71, 0); V _m_71_a1_125 = FLD(m_71, 1); V _m_71_a2_126 = FLD(m_71, 2); _r = ({ V a_127 = _m_71_a0_124; ({ V b_128 = _m_71_a1_125; ({ V c_129 = _m_71_a2_126; FALSE_V; }); }); }); break; } case 11: { V _m_71_a0_130 = FLD(m_71, 0); V _m_71_a1_131 = FLD(m_71, 1); V _m_71_a2_132 = FLD(m_71, 2); V _m_71_a3_133 = FLD(m_71, 3); _r = ({ V a_134 = _m_71_a0_130; ({ V b_135 = _m_71_a1_131; ({ V c_136 = _m_71_a2_132; ({ V d_137 = _m_71_a3_133; TRUE_V; }); }); }); }); break; } case 12: { V _m_71_a0_138 = FLD(m_71, 0); _r = ({ V a_139 = _m_71_a0_138; TRUE_V; }); break; } default: rt_panic("match: no case at external_call:78"); } _r; });
}
V d_ExternalCall_duses(V entries_140) {
  return d_SeqList_dexists(clo_new(lam_144, 1, 0), entries_140);
}
V d_ExternalCall_darguments_uterm(V env_145, V words_146) {
  return ({ V _r = 0; V m_147 = words_146; if (((m_147) == NIL)) {  _r = DONE(((V)&S_10)); } else if (((m_147) != NIL)) { V word_148 = FLD(m_147, 0); V rest_149 = FLD(m_147, 1); _r = ({ V t_150 = d_Contract_dword(env_145, word_148); V _r; if (tag_of(t_150) == 0) _r = t_150; else { V head_151 = FLD(t_150, 0); _r = ({ V t_152 = d_ExternalCall_darguments_uterm(env_145, rest_149); V _r; if (tag_of(t_152) == 0) _r = t_152; else { V tail_153 = FLD(t_152, 0); _r = DONE(d_Contract_dapp(((V)&S_11), CON(head_151, CON(tail_153, NIL)))); } _r; }); } _r; }); } else rt_panic("match: no case at external_call:85"); _r; });
}
V d_ExternalCall_dlowered(V env_154, V target_155, V value_156, V calldata_157) {
  return ({ V t_158 = d_Contract_dword(env_154, target_155); V _r; if (tag_of(t_158) == 0) _r = t_158; else { V t_159 = FLD(t_158, 0); _r = ({ V t_160 = d_Contract_dword(env_154, value_156); V _r; if (tag_of(t_160) == 0) _r = t_160; else { V v_161 = FLD(t_160, 0); _r = ({ V _r = 0; V m_162 = calldata_157; if (((m_162) == NONE)) {  _r = ({ V __163 = UNIT; DONE(rt_ctor2(0, ((V)&S_12), CON(t_159, CON(v_161, NIL)))); }); } else if (((m_162) != NONE)) { V _m_162_a0_164 = FLD(m_162, 0); _r = ({ V data_165 = _m_162_a0_164; ({ V _r = 0; V m_166 = data_165; if ((tag_of(m_166) == 0)) { V _m_166_a0_167 = FLD(m_166, 0); V _m_166_a1_168 = FLD(m_166, 1); _r = ({ V selector_169 = _m_166_a0_167; ({ V words_170 = _m_166_a1_168; ({ V t_171 = d_Contract_dliteral(selector_169); V _r; if (tag_of(t_171) == 0) _r = t_171; else { V w_172 = FLD(t_171, 0); _r = ({ V t_173 = d_Contract_dword(env_154, w_172); V _r; if (tag_of(t_173) == 0) _r = t_173; else { V s_174 = FLD(t_173, 0); _r = ({ V t_175 = d_ExternalCall_darguments_uterm(env_154, words_170); V _r; if (tag_of(t_175) == 0) _r = t_175; else { V a_176 = FLD(t_175, 0); _r = DONE(rt_ctor2(0, ((V)&S_2), CON(t_159, CON(v_161, CON(s_174, CON(a_176, NIL)))))); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at external_call:97"); _r; }); }); } else rt_panic("match: no case at external_call:95"); _r; }); } _r; }); } _r; });
}
V d_Recognize_dcall_utags(V globals_177) {
  return d_SeqList_dfilter_umap(({ V _c = clo_new(lam_183, 1, 1); CLO_ENV(_c)[0] = globals_177; _c; }), CON(((V)&S_12), CON(((V)&S_2), CON(((V)&S_14), NIL))));
}
V d_Emit_dis_ucall_utag(V env_184, V tag_185) {
  return d_SeqList_dexists(({ V _c = clo_new(lam_187, 1, 1); CLO_ENV(_c)[0] = tag_185; _c; }), d_Get_dEmit_dEnvironment_dcall_utags(env_184));
}
V d_Emit_dcall_ushape(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor1(11, ((V)&S_15)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Emit_dselector(V value_188) {
  return ({ V _r = 0; V m_189 = value_188; switch (tag_of(m_189)) { case 1: { V word_190 = FLD(m_189, 0); _r = DONE(word_190); break; } case 0: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 2: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 3: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 4: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 5: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 6: {  _r = FAIL(d_Emit_dcall_ushape()); break; } default: rt_panic("match: no case at external_call:124"); } _r; });
}
V d_Emit_dcall_uarguments(V value_191) {
  return ({ V _r = 0; V m_192 = value_191; switch (tag_of(m_192)) { case 6: { V fields_193 = FLD(m_192, 2); _r = d_Emit_dcall_uargument_ufields(fields_193); break; } case 0: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 1: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 2: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 3: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 4: {  _r = FAIL(d_Emit_dcall_ushape()); break; } case 5: {  _r = FAIL(d_Emit_dcall_ushape()); break; } default: rt_panic("match: no case at external_call:135"); } _r; });
}
V d_Emit_dcall_uargument_ufields(V fields_194) {
  return ({ V _r = 0; V m_195 = fields_194; if (((m_195) == NIL)) {  _r = DONE(NIL); } else if (((m_195) != NIL)) { V word_196 = FLD(m_195, 0); V rest_197 = FLD(m_195, 1); _r = ({ V _r = 0; V m_198 = rest_197; if (((m_198) != NIL)) { V tail_199 = FLD(m_198, 0); _r = d_Emit_dResult_dbind(d_Emit_doperand(word_196), ({ V _c = clo_new(lam_203, 1, 1); CLO_ENV(_c)[0] = tail_199; _c; })); } else if (((m_198) == NIL)) {  _r = FAIL(d_Emit_dcall_ushape()); } else rt_panic("match: no case at external_call:148"); _r; }); } else rt_panic("match: no case at external_call:145"); _r; });
}
V d_Emit_dresume(V next_204, V fuel_205, V fresh_206, V k_207, V node_208) {
  return d_Emit_dResult_dbind(apn(next_204, 4, (V[]){fuel_205, d_NativeInt_dadd(fresh_206, d_Big_done()), k_207, rt_ctor1(3, fresh_206)}), ({ V _c = clo_new(lam_217, 1, 2); CLO_ENV(_c)[0] = node_208; CLO_ENV(_c)[1] = fresh_206; _c; }));
}
V d_Emit_dresume_ulast(V values_218, V next_219, V fuel_220, V fresh_221, V node_222) {
  return ({ V _r = 0; V m_223 = values_218; if (((m_223) != NIL)) { V k_224 = FLD(m_223, 0); V tail_225 = FLD(m_223, 1); _r = ({ V _r = 0; V m_226 = tail_225; if (((m_226) == NIL)) {  _r = d_Emit_dresume(next_219, fuel_220, fresh_221, k_224, node_222); } else if (((m_226) != NIL)) {  _r = FAIL(d_Emit_dcall_ushape()); } else rt_panic("match: no case at external_call:165"); _r; }); } else if (((m_223) == NIL)) {  _r = FAIL(d_Emit_dcall_ushape()); } else rt_panic("match: no case at external_call:163"); _r; });
}
V d_Emit_dtake_uoperand(V values_227, V then_228) {
  return ({ V _r = 0; V m_229 = values_227; if (((m_229) != NIL)) { V head_230 = FLD(m_229, 0); V tail_231 = FLD(m_229, 1); _r = d_Emit_dResult_dbind(d_Emit_doperand(head_230), ({ V _c = clo_new(lam_233, 1, 2); CLO_ENV(_c)[0] = then_228; CLO_ENV(_c)[1] = tail_231; _c; })); } else if (((m_229) == NIL)) {  _r = FAIL(d_Emit_dcall_ushape()); } else rt_panic("match: no case at external_call:171"); _r; });
}
V d_Emit_dtake_ucalldata(V values_234, V then_235) {
  return ({ V _r = 0; V m_236 = values_234; if (((m_236) != NIL)) { V selector_237 = FLD(m_236, 0); V rest_238 = FLD(m_236, 1); _r = ({ V _r = 0; V m_239 = rest_238; if (((m_239) != NIL)) { V words_240 = FLD(m_239, 0); V tail_241 = FLD(m_239, 1); _r = d_Emit_dResult_dbind(d_Emit_dselector(selector_237), ({ V _c = clo_new(lam_245, 1, 3); CLO_ENV(_c)[0] = words_240; CLO_ENV(_c)[1] = then_235; CLO_ENV(_c)[2] = tail_241; _c; })); } else if (((m_239) == NIL)) {  _r = FAIL(d_Emit_dcall_ushape()); } else rt_panic("match: no case at external_call:178"); _r; }); } else if (((m_236) == NIL)) {  _r = FAIL(d_Emit_dcall_ushape()); } else rt_panic("match: no case at external_call:176"); _r; });
}
V d_Emit_dexternal_unode(V name_246, V args_247, V next_248, V fuel_249, V fresh_250) {
  return ((d_NativeString_dequal(name_246, ((V)&S_14))) != FALSE_V ? d_Emit_dresume_ulast(args_247, next_248, fuel_249, fresh_250, clo_new(lam_253, 2, 0)) : d_Emit_dtake_uoperand(args_247, ({ V _c = clo_new(lam_269, 2, 4); CLO_ENV(_c)[0] = name_246; CLO_ENV(_c)[1] = next_248; CLO_ENV(_c)[2] = fuel_249; CLO_ENV(_c)[3] = fresh_250; _c; })));
}
V d_Emit_dexternal(V env_270, V tag_271, V args_272, V next_273, V fuel_274, V fresh_275) {
  return ({ V _r = 0; V m_276 = d_SeqList_dassoc(clo_new(lam_279, 2, 0), tag_271, d_Get_dEmit_dEnvironment_dcall_utags(env_270)); if (((m_276) == NONE)) {  _r = ({ V __280 = UNIT; FAIL(rt_ctor1(11, ((V)&S_16))); }); } else if (((m_276) != NONE)) { V _m_276_a0_281 = FLD(m_276, 0); _r = ({ V name_282 = _m_276_a0_281; d_Emit_dexternal_unode(name_282, args_272, next_273, fuel_274, fresh_275); }); } else rt_panic("match: no case at external_call:199"); _r; });
}
V d_Emit_dhas_uexternal(V tx_283) {
_top: ;
  return ({ V _r = 0; V m_284 = tx_283; switch (tag_of(m_284)) { case 0: {  _r = FALSE_V; break; } case 1: {  _r = FALSE_V; break; } case 2: {  _r = FALSE_V; break; } case 3: { V after_285 = FLD(m_284, 2); _r = ({ V a_286 = after_285; tx_283 = a_286;  goto _top; (V)0; }); break; } case 4: { V after_287 = FLD(m_284, 2); _r = ({ V a_288 = after_287; tx_283 = a_288;  goto _top; (V)0; }); break; } case 5: { V after_289 = FLD(m_284, 2); _r = ({ V a_290 = after_289; tx_283 = a_290;  goto _top; (V)0; }); break; } case 6: { V yes_291 = FLD(m_284, 4); V no_292 = FLD(m_284, 5); _r = ((d_Emit_dhas_uexternal(yes_291)) | (d_Emit_dhas_uexternal(no_292))); break; } case 7: { V after_293 = FLD(m_284, 4); _r = ({ V a_294 = after_293; tx_283 = a_294;  goto _top; (V)0; }); break; } case 8: { V yes_295 = FLD(m_284, 2); V no_296 = FLD(m_284, 3); _r = ((d_Emit_dhas_uexternal(yes_295)) | (d_Emit_dhas_uexternal(no_296))); break; } case 9: {  _r = TRUE_V; break; } case 10: {  _r = TRUE_V; break; } default: rt_panic("match: no case at external_call:207"); } _r; });
}
V d_Emit_drequire_ulowerable(V result_297) {
  return d_Emit_dResult_dbind(result_297, clo_new(lam_299, 1, 0));
}
V d_Emit_dlowerable_upacket(V packet_300) {
  return ({ V _r = 0; V m_301 = packet_300; if ((tag_of(m_301) == 0)) { V entries_302 = FLD(m_301, 0); V constructor_303 = FLD(m_301, 1); V names_304 = FLD(m_301, 2); V errors_305 = FLD(m_301, 3); V fallback_306 = FLD(m_301, 4); _r = ({ V entry_call_307 = d_SeqList_dexists(clo_new(lam_309, 1, 0), entries_302); ({ V fallback_call_310 = ({ V _r = 0; V m_311 = fallback_306; if (((m_311) == NONE)) {  _r = ({ V __312 = UNIT; FALSE_V; }); } else if (((m_311) != NONE)) { V _m_311_a0_313 = FLD(m_311, 0); _r = ({ V tx_314 = _m_311_a0_313; d_Emit_dhas_uexternal(tx_314); }); } else rt_panic("match: no case at external_call:229"); _r; }); ((((entry_call_307) | (fallback_call_310))) != FALSE_V ? FAIL(rt_ctor1(5, ((V)&S_17))) : DONE(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = entries_302; _o->f[1] = constructor_303; _o->f[2] = names_304; _o->f[3] = errors_305; _o->f[4] = fallback_306; (V)_o; }))); }); }); } else rt_panic("match: no case at external_call:226"); _r; });
}
