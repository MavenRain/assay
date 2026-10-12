/* generated from src/layout.bend */
#include "assay_gen.h"

static V lam_26(V *env, V *args) {
  (void)env; (void)args;
  V word_25 = args[0];
  return DONE(d_Layout_dMapping_ddigest_uvalue(d_Keccak_dkeccak256(str_append(word_25, d_Abi_dCodec_dword(env[0]))), d_Big_dzero()));
}
static V lam_33(V *env, V *args) {
  (void)env; (void)args;
  V next_32 = args[0];
  return d_Layout_dMapping_dwalk(next_32, env[0]);
}
static V lam_77(V *env, V *args) {
  (void)env; (void)args;
  V rest_76 = args[0];
  return DONE(CON(rt_ctor4(0, env[0], env[1], env[2], env[3]), rest_76));
}
static V lam_92(V *env, V *args) {
  (void)env; (void)args;
  return d_Layout_dPacked_dread_uvalid(env[0], env[1]);
}
static V lam_93(V *env, V *args) {
  (void)env; (void)args;
  return d_Layout_dPacked_dResult_dbind(d_Layout_dPacked_dword(env[0]), ({ V _c = clo_new(lam_92, 1, 2); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[0]; _c; }));
}
static V lam_103(V *env, V *args) {
  (void)env; (void)args;
  return d_Layout_dPacked_dwrite_uvalid(env[0], env[1], env[2]);
}
static V lam_104(V *env, V *args) {
  (void)env; (void)args;
  return d_Layout_dPacked_dResult_dbind(d_Layout_dPacked_dword(env[0]), ({ V _c = clo_new(lam_103, 1, 3); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[0]; CLO_ENV(_c)[2] = env[2]; _c; }));
}
static Str S_0 = {TAG_STR, 9, {(const uint8_t *)"{\042astId\042:"}};
static Str S_1 = {TAG_STR, 12, {(const uint8_t *)",\042contract\042:"}};
static Str S_2 = {TAG_STR, 9, {(const uint8_t *)",\042label\042:"}};
static Str S_3 = {TAG_STR, 10, {(const uint8_t *)",\042offset\042:"}};
static Str S_4 = {TAG_STR, 8, {(const uint8_t *)",\042slot\042:"}};
static Str S_5 = {TAG_STR, 8, {(const uint8_t *)",\042type\042:"}};
static Str S_6 = {TAG_STR, 2, {(const uint8_t *)"t_"}};
static Str S_7 = {TAG_STR, 1, {(const uint8_t *)"}"}};
static Str S_8 = {TAG_STR, 31, {(const uint8_t *)":{\042encoding\042:\042inplace\042,\042label\042:"}};
static Str S_9 = {TAG_STR, 17, {(const uint8_t *)",\042numberOfBytes\042:"}};
static Str S_10 = {TAG_STR, 12, {(const uint8_t *)"{\042storage\042:["}};
static V lam_132(V *env, V *args) {
  (void)env; (void)args;
  V index_130 = args[0];
  V field_131 = args[1];
  return d_Layout_dPacked_dfield_ujson(env[0], index_130, field_131);
}
static Str S_11 = {TAG_STR, 1, {(const uint8_t *)","}};
static Str S_12 = {TAG_STR, 11, {(const uint8_t *)"],\042types\042:{"}};
static Str S_13 = {TAG_STR, 2, {(const uint8_t *)"}}"}};
static V lam_133(V *env, V *args) {
  (void)env; (void)args;
  V rows_129 = args[0];
  return DONE(str_concat(CON(((V)&S_10), CON(str_join(d_SeqList_dmapi(({ V _c = clo_new(lam_132, 2, 1); CLO_ENV(_c)[0] = env[0]; _c; }), rows_129), ((V)&S_11)), CON(((V)&S_12), CON(str_join(d_Layout_dPacked_dtype_urows(rows_129, NIL), ((V)&S_11)), CON(((V)&S_13), NIL)))))));
}
static Str S_14 = {TAG_STR, 19, {(const uint8_t *)",\042offset\042:0,\042slot\042:"}};
static Str S_15 = {TAG_STR, 20, {(const uint8_t *)",\042type\042:\042t_uint256\042}"}};
static V lam_139(V *env, V *args) {
  (void)env; (void)args;
  V local8636_137 = args[0];
  V local8638_138 = args[1];
  return str_concat(CON(((V)&S_0), CON(d_Big_dshow(local8636_137), CON(((V)&S_1), CON(d_Abi_dquote(env[0]), CON(((V)&S_2), CON(d_Abi_dquote(local8638_138), CON(((V)&S_14), CON(d_Abi_dquote(d_Big_dshow(local8636_137)), CON(((V)&S_15), NIL))))))))));
}
static Str S_16 = {TAG_STR, 87, {(const uint8_t *)"],\042types\042:{\042t_uint256\042:{\042encoding\042:\042inplace\042,\042label\042:\042uint256\042,\042numberOfBytes\042:\04232\042}}}\012"}};
static Str S_17 = {TAG_STR, 36, {(const uint8_t *)"PACKED_SLOT: expected a slot literal"}};
static Str S_18 = {TAG_STR, 42, {(const uint8_t *)"PACKED_SLOT: unknown logical storage field"}};
static Str S_19 = {TAG_STR, 6, {(const uint8_t *)"SSTORE"}};
static Str S_20 = {TAG_STR, 3, {(const uint8_t *)"SHL"}};
static Str S_21 = {TAG_STR, 5, {(const uint8_t *)"SLOAD"}};
static Str S_22 = {TAG_STR, 3, {(const uint8_t *)"AND"}};
static Str S_23 = {TAG_STR, 2, {(const uint8_t *)"OR"}};
static Str S_24 = {TAG_STR, 3, {(const uint8_t *)"SHR"}};

V d_Layout_dMapping_dResult_dbind(V value_1, V next_2) {
  return ({ V _r = 0; V m_3 = value_1; switch (tag_of(m_3)) { case 1: { V x_4 = FLD(m_3, 0); _r = ap(next_2, x_4); break; } case 0: { V error_5 = FLD(m_3, 0); _r = FAIL(error_5); break; } default: rt_panic("match: no case at layout:11"); } _r; });
}
V d_Layout_dMapping_dkey_uword(V key_6) {
  return ({ V _r = 0; V m_7 = key_6; if ((tag_of(m_7) == 0)) { V typ_8 = FLD(m_7, 0); V value_9 = FLD(m_7, 1); _r = ({ V _r = 0; V m_10 = typ_8; switch (tag_of(m_10)) { case 4: {  _r = FAIL(((V)1)); break; } case 0: {  _r = d_Layout_dMapping_dchecked_uword(typ_8, value_9, NAT_SMALL(8ull)); break; } case 1: {  _r = d_Layout_dMapping_dchecked_uword(typ_8, value_9, NAT_SMALL(256ull)); break; } case 2: {  _r = d_Layout_dMapping_dchecked_uword(typ_8, value_9, NAT_SMALL(160ull)); break; } case 3: {  _r = d_Layout_dMapping_dchecked_uword(typ_8, value_9, NAT_SMALL(1ull)); break; } default: rt_panic("match: no case at layout:17"); } _r; }); } else rt_panic("match: no case at layout:15"); _r; });
}
V d_Layout_dMapping_dchecked_uword(V typ_11, V value_12, V bits_13) {
  return ((d_Abi_dCodec_dwithin(d_Big_dof_unat(bits_13), value_12)) != FALSE_V ? DONE(d_Abi_dCodec_dword(value_12)) : FAIL(rt_ctor1(2, typ_11)));
}
V d_Layout_dMapping_ddigest_uvalue(V text_14, V acc_15) {
_top: ;
  return ({ V _r = 0; V m_16 = text_14; if ((str_eq_lit(m_16, "", 0))) {  _r = acc_15; } else if ((!str_is_nil(m_16))) { V char_17 = str_head(m_16); V tail_18 = str_tail(m_16); _r = ({ V code_19 = NAT_SMALL((char_17)); ({ V digit_20 = ((((V)(nat_cmp(code_19, NAT_SMALL(58ull)) < 0))) != FALSE_V ? nat_sub(code_19, NAT_SMALL(48ull)) : nat_sub(code_19, NAT_SMALL(87ull))); ({ V a_21 = tail_18; V a_22 = d_Big_dadd(d_Big_dshift_uleft(acc_15, NAT_SMALL(4ull)), d_Big_dof_unat(digit_20)); text_14 = a_21; acc_15 = a_22;  goto _top; (V)0; }); }); }); } else rt_panic("match: no case at layout:28"); _r; });
}
V d_Layout_dMapping_dslot(V base_23, V key_24) {
  return ((d_Abi_dCodec_dwithin(d_Big_dof_unat(NAT_SMALL(256ull)), base_23)) != FALSE_V ? d_Layout_dMapping_dResult_dbind(d_Layout_dMapping_dkey_uword(key_24), ({ V _c = clo_new(lam_26, 1, 1); CLO_ENV(_c)[0] = base_23; _c; })) : FAIL(((V)0)));
}
V d_Layout_dMapping_dwalk(V base_27, V keys_28) {
  return ({ V _r = 0; V m_29 = keys_28; if (((m_29) == NIL)) {  _r = DONE(base_27); } else if (((m_29) != NIL)) { V key_30 = FLD(m_29, 0); V tail_31 = FLD(m_29, 1); _r = d_Layout_dMapping_dResult_dbind(d_Layout_dMapping_dslot(base_27, key_30), ({ V _c = clo_new(lam_33, 1, 1); CLO_ENV(_c)[0] = tail_31; _c; })); } else rt_panic("match: no case at layout:40"); _r; });
}
V d_Layout_dMapping_dpath(V base_34, V keys_35) {
  return ({ V _r = 0; V m_36 = keys_35; if (((m_36) == NIL)) {  _r = FAIL(((V)3)); } else if (((m_36) != NIL)) { V key_37 = FLD(m_36, 0); V tail_38 = FLD(m_36, 1); _r = d_Layout_dMapping_dwalk(base_34, CON(key_37, tail_38)); } else rt_panic("match: no case at layout:44"); _r; });
}
V d_Layout_dPacked_dResult_dbind(V value_39, V next_40) {
  return ({ V _r = 0; V m_41 = value_39; switch (tag_of(m_41)) { case 1: { V x_42 = FLD(m_41, 0); _r = ap(next_40, x_42); break; } case 0: { V error_43 = FLD(m_41, 0); _r = FAIL(error_43); break; } default: rt_panic("match: no case at layout:59"); } _r; });
}
V d_Layout_dPacked_dwidth(V typ_44) {
  return ({ V _r = 0; V m_45 = typ_44; switch (tag_of(m_45)) { case 0: {  _r = NAT_SMALL(1ull); break; } case 1: {  _r = NAT_SMALL(32ull); break; } case 2: {  _r = NAT_SMALL(20ull); break; } case 3: {  _r = NAT_SMALL(1ull); break; } case 4: {  _r = NAT_SMALL(0ull); break; } default: rt_panic("match: no case at layout:63"); } _r; });
}
V d_Layout_dPacked_dbits(V typ_46) {
  return ({ V _r = 0; V m_47 = typ_46; switch (tag_of(m_47)) { case 3: {  _r = NAT_SMALL(1ull); break; } case 0: {  _r = NAT_SMALL(8ull); break; } case 1: {  _r = NAT_SMALL(256ull); break; } case 2: {  _r = NAT_SMALL(160ull); break; } case 4: {  _r = NAT_SMALL(0ull); break; } default: rt_panic("match: no case at layout:70"); } _r; });
}
V d_Layout_dPacked_dseen(V name_48, V names_49) {
_top: ;
  return ({ V _r = 0; V m_50 = names_49; if (((m_50) == NIL)) {  _r = FALSE_V; } else if (((m_50) != NIL)) { V head_51 = FLD(m_50, 0); V tail_52 = FLD(m_50, 1); _r = ((d_NativeString_dequal(name_48, head_51)) != FALSE_V ? TRUE_V : ({ V a_53 = tail_52; names_49 = a_53;  goto _top; (V)0; })); } else rt_panic("match: no case at layout:78"); _r; });
}
V d_Layout_dPacked_dplan_ugo(V fields_54, V seen_55, V slot_56, V offset_57) {
  return ({ V _r = 0; V m_58 = fields_54; if (((m_58) == NIL)) {  _r = DONE(NIL); } else if (((m_58) != NIL) && (tag_of(FLD(m_58, 0)) == 0)) { V name_59 = FLD(FLD(m_58, 0), 0); V typ_60 = FLD(FLD(m_58, 0), 1); V tail_61 = FLD(m_58, 1); _r = ((d_NativeString_dequal(name_59, SNIL)) != FALSE_V ? FAIL(((V)1)) : ((d_Layout_dPacked_dseen(name_59, seen_55)) != FALSE_V ? FAIL(rt_ctor1(2, name_59)) : ((d_Big_dis_uzero(d_Big_dof_unat(d_Layout_dPacked_dwidth(typ_60)))) != FALSE_V ? FAIL(((V)0)) : d_Layout_dPacked_dplace(name_59, typ_60, tail_61, seen_55, slot_56, offset_57)))); } else rt_panic("match: no case at layout:83"); _r; });
}
V d_Layout_dPacked_dplace(V name_62, V typ_63, V tail_64, V seen_65, V slot_66, V offset_67) {
  return ({ V width_68 = d_Layout_dPacked_dwidth(typ_63); ({ V spill_69 = d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(32ull)), d_Big_dof_unat(nat_add(offset_67, width_68))); ({ V placed_slot_70 = ((spill_69) != FALSE_V ? d_Big_dadd(slot_66, d_Big_done()) : slot_66); ({ V placed_offset_71 = ((spill_69) != FALSE_V ? NAT_SMALL(0ull) : offset_67); ({ V end_72 = nat_add(placed_offset_71, width_68); ({ V full_73 = d_Big_dis_uzero(d_Big_dsub(d_Big_dof_unat(end_72), d_Big_dof_unat(NAT_SMALL(32ull)))); ({ V next_slot_74 = ((full_73) != FALSE_V ? d_Big_dadd(placed_slot_70, d_Big_done()) : placed_slot_70); ({ V next_offset_75 = ((full_73) != FALSE_V ? NAT_SMALL(0ull) : end_72); d_Layout_dPacked_dResult_dbind(d_Layout_dPacked_dplan_ugo(tail_64, CON(name_62, seen_65), next_slot_74, next_offset_75), ({ V _c = clo_new(lam_77, 1, 4); CLO_ENV(_c)[0] = name_62; CLO_ENV(_c)[1] = typ_63; CLO_ENV(_c)[2] = placed_slot_70; CLO_ENV(_c)[3] = placed_offset_71; _c; })); }); }); }); }); }); }); }); });
}
V d_Layout_dPacked_dplan(V fields_78) {
  return d_Layout_dPacked_dplan_ugo(fields_78, NIL, d_Big_dzero(), NAT_SMALL(0ull));
}
V d_Layout_dPacked_dvalidate(V field_79) {
  return ({ V _r = 0; V m_80 = field_79; if ((tag_of(m_80) == 0)) { V typ_81 = FLD(m_80, 1); V slot_82 = FLD(m_80, 2); V offset_83 = FLD(m_80, 3); _r = ({ V width_84 = d_Layout_dPacked_dwidth(typ_81); ({ V fits_85 = d_Big_dis_ule(d_Big_dof_unat(offset_83), d_Big_dof_unat(nat_sub(NAT_SMALL(32ull), width_84))); ((d_Big_dis_uzero(d_Big_dof_unat(width_84))) != FALSE_V ? FAIL(((V)0)) : ((((fits_85) & (d_Abi_dCodec_dwithin(d_Big_dof_unat(NAT_SMALL(256ull)), slot_82)))) != FALSE_V ? DONE(UNIT) : FAIL(((V)3)))); }); }); } else rt_panic("match: no case at layout:105"); _r; });
}
V d_Layout_dPacked_dword(V word_86) {
  return ((d_Abi_dCodec_dwithin(d_Big_dof_unat(NAT_SMALL(256ull)), word_86)) != FALSE_V ? DONE(UNIT) : FAIL(((V)4)));
}
V d_Layout_dPacked_dextract(V word_87, V width_88, V offset_89) {
  return d_Big_dlogand(d_Big_dshift_uright(word_87, nat_mul(offset_89, NAT_SMALL(8ull))), d_Big_dsub(d_Big_dshift_uleft(d_Big_done(), nat_mul(width_88, NAT_SMALL(8ull))), d_Big_done()));
}
V d_Layout_dPacked_dread(V field_90, V word_91) {
  return d_Layout_dPacked_dResult_dbind(d_Layout_dPacked_dvalidate(field_90), ({ V _c = clo_new(lam_93, 1, 2); CLO_ENV(_c)[0] = word_91; CLO_ENV(_c)[1] = field_90; _c; }));
}
V d_Layout_dPacked_dread_uvalid(V field_94, V word_95) {
  return ({ V _r = 0; V m_96 = field_94; if ((tag_of(m_96) == 0)) { V typ_97 = FLD(m_96, 1); V offset_98 = FLD(m_96, 3); _r = ({ V value_99 = d_Layout_dPacked_dextract(word_95, d_Layout_dPacked_dwidth(typ_97), offset_98); ((d_Abi_dCodec_dwithin(d_Big_dof_unat(d_Layout_dPacked_dbits(typ_97)), value_99)) != FALSE_V ? DONE(value_99) : FAIL(rt_ctor1(5, typ_97))); }); } else rt_panic("match: no case at layout:122"); _r; });
}
V d_Layout_dPacked_dwrite(V field_100, V word_101, V value_102) {
  return d_Layout_dPacked_dResult_dbind(d_Layout_dPacked_dvalidate(field_100), ({ V _c = clo_new(lam_104, 1, 3); CLO_ENV(_c)[0] = word_101; CLO_ENV(_c)[1] = field_100; CLO_ENV(_c)[2] = value_102; _c; }));
}
V d_Layout_dPacked_dwrite_uvalid(V field_105, V word_106, V value_107) {
  return ({ V _r = 0; V m_108 = field_105; if ((tag_of(m_108) == 0)) { V typ_109 = FLD(m_108, 1); V offset_110 = FLD(m_108, 3); _r = ({ V shift_111 = nat_mul(offset_110, NAT_SMALL(8ull)); ((d_Abi_dCodec_dwithin(d_Big_dof_unat(d_Layout_dPacked_dbits(typ_109)), value_107)) != FALSE_V ? DONE(d_Big_dadd(d_Big_dsub(word_106, d_Big_dshift_uleft(d_Layout_dPacked_dextract(word_106, d_Layout_dPacked_dwidth(typ_109), offset_110), shift_111)), d_Big_dshift_uleft(value_107, shift_111))) : FAIL(rt_ctor1(5, typ_109))); }); } else rt_panic("match: no case at layout:132"); _r; });
}
V d_Layout_dPacked_dfield_ujson(V contract_112, V index_113, V field_114) {
  return ({ V _r = 0; V m_115 = field_114; if ((tag_of(m_115) == 0)) { V name_116 = FLD(m_115, 0); V typ_117 = FLD(m_115, 1); V slot_118 = FLD(m_115, 2); V offset_119 = FLD(m_115, 3); _r = str_concat(CON(((V)&S_0), CON(d_Big_dshow(index_113), CON(((V)&S_1), CON(d_Abi_dquote(contract_112), CON(((V)&S_2), CON(d_Abi_dquote(name_116), CON(((V)&S_3), CON(nat_show(offset_119), CON(((V)&S_4), CON(d_Abi_dquote(d_Big_dshow(slot_118)), CON(((V)&S_5), CON(d_Abi_dquote(str_append(((V)&S_6), d_Abi_dSchema_dtype_uname(typ_117))), CON(((V)&S_7), NIL)))))))))))))); } else rt_panic("match: no case at layout:139"); _r; });
}
V d_Layout_dPacked_dtype_urows(V fields_120, V seen_121) {
_top: ;
  return ({ V _r = 0; V m_122 = fields_120; if (((m_122) == NIL)) {  _r = NIL; } else if (((m_122) != NIL) && (tag_of(FLD(m_122, 0)) == 0)) { V typ_123 = FLD(FLD(m_122, 0), 1); V tail_124 = FLD(m_122, 1); _r = ({ V name_125 = d_Abi_dSchema_dtype_uname(typ_123); ((d_Layout_dPacked_dseen(name_125, seen_121)) != FALSE_V ? ({ V a_126 = tail_124; fields_120 = a_126;  goto _top; (V)0; }) : CON(str_concat(CON(d_Abi_dquote(str_append(((V)&S_6), name_125)), CON(((V)&S_8), CON(d_Abi_dquote(name_125), CON(((V)&S_9), CON(d_Abi_dquote(nat_show(d_Layout_dPacked_dwidth(typ_123))), CON(((V)&S_7), NIL))))))), d_Layout_dPacked_dtype_urows(tail_124, CON(name_125, seen_121)))); }); } else rt_panic("match: no case at layout:144"); _r; });
}
V d_Layout_dPacked_dprint(V contract_127, V fields_128) {
  return d_Layout_dPacked_dResult_dbind(d_Layout_dPacked_dplan(fields_128), ({ V _c = clo_new(lam_133, 1, 1); CLO_ENV(_c)[0] = contract_127; _c; }));
}
V d_Layout_dprint(V contract_274_134, V fields_275_135) {
  return ({ V scrut8643_136 = d_SeqList_dmapi(({ V _c = clo_new(lam_139, 2, 1); CLO_ENV(_c)[0] = contract_274_134; _c; }), fields_275_135); str_append(((V)&S_10), str_append(str_join(scrut8643_136, ((V)&S_11)), ((V)&S_16))); });
}
V d_Emit_dPacked_dnames(V fields_140, V names_141) {
  return d_Case_dPacked_dswitch_u33(fields_140, names_141);
}
V scc_31(uint32_t w, V *a) {
  V hex_142;
  V fields_143;
  V index_144;
  V packed_switch_7_145;
  V field_146;
  V hex_147;
  V index_148;
  V rest_149;
  V packed_switch_30_150;
  V hex_151;
  V index_152;
  switch (w) {
  default: hex_142 = a[0]; fields_143 = a[1]; index_144 = a[2]; goto _m0;
  case 1: packed_switch_7_145 = a[0]; field_146 = a[1]; hex_147 = a[2]; index_148 = a[3]; rest_149 = a[4]; goto _m1;
  case 2: packed_switch_30_150 = a[0]; hex_151 = a[1]; index_152 = a[2]; goto _m2;
  }
_m0: ;
  return ({ V a_153 = fields_143; V a_154 = hex_142; V a_155 = index_144; packed_switch_30_150 = a_153; hex_151 = a_154; index_152 = a_155;  goto _m2; (V)0; });
_m1: ;
  return ({ V _r = 0; V m_156 = packed_switch_7_145; switch (tag_of(m_156)) { case 1: { V expected_157 = FLD(m_156, 0); _r = ((d_NativeString_dequal(hex_147, expected_157)) != FALSE_V ? DONE(field_146) : ({ V a_158 = hex_147; V a_159 = rest_149; V a_160 = d_Big_dadd(index_148, d_Big_done()); hex_142 = a_158; fields_143 = a_159; index_144 = a_160;  goto _m0; (V)0; })); break; } case 0: {  _r = FAIL(rt_ctor1(5, ((V)&S_17))); break; } case 2: {  _r = FAIL(rt_ctor1(5, ((V)&S_17))); break; } case 3: {  _r = FAIL(rt_ctor1(5, ((V)&S_17))); break; } default: rt_panic("match: no case at layout:181"); } _r; });
_m2: ;
  return ({ V _r = 0; V m_161 = packed_switch_30_150; if (((m_161) == NIL)) {  _r = FAIL(rt_ctor1(5, ((V)&S_18))); } else if (((m_161) != NIL)) { V field_162 = FLD(m_161, 0); V rest_163 = FLD(m_161, 1); _r = ({ V a_164 = d_Emit_dnumber(index_152); V a_165 = field_162; V a_166 = hex_151; V a_167 = index_152; V a_168 = rest_163; packed_switch_7_145 = a_164; field_146 = a_165; hex_147 = a_166; index_148 = a_167; rest_149 = a_168;  goto _m1; (V)0; }); } else rt_panic("match: no case at layout:218"); _r; });
}
V scc_31(uint32_t w, V *a);
V d_Emit_dPacked_dfind(V hex_142, V fields_143, V index_144) {
  V w_a[] = {hex_142, fields_143, index_144};
  return scc_31(0, w_a);
}
V d_Emit_dPacked_dmask(V width_169) {
  return d_Big_dsub(d_Big_dshift_uleft(d_Big_done(), nat_mul(width_169, NAT_SMALL(8ull))), d_Big_done());
}
V d_Emit_dPacked_dload(V field_170) {
  return d_Case_dPacked_dswitch_u29(field_170);
}
V d_Emit_dPacked_dstore(V field_171) {
  return d_Case_dPacked_dswitch_u28(field_171);
}
V d_Emit_dPacked_dboolean(V typ_172) {
  return d_Case_dPacked_dswitch_u27(typ_172);
}
V scc_32(uint32_t w, V *a) {
  V fields_173;
  V count_174;
  V packed_switch_21_175;
  V count_176;
  switch (w) {
  default: fields_173 = a[0]; count_174 = a[1]; goto _m0;
  case 1: packed_switch_21_175 = a[0]; count_176 = a[1]; goto _m1;
  }
_m0: ;
  return ({ V a_177 = fields_173; V a_178 = count_174; packed_switch_21_175 = a_177; count_176 = a_178;  goto _m1; (V)0; });
_m1: ;
  return ({ V _r = 0; V m_179 = packed_switch_21_175; if (((m_179) == NIL)) {  _r = count_176; } else if (((m_179) != NIL) && (tag_of(FLD(m_179, 0)) == 0)) { V slot_180 = FLD(FLD(m_179, 0), 2); V rest_181 = FLD(m_179, 1); _r = ({ V a_182 = rest_181; V a_183 = d_Big_dadd(slot_180, d_Big_done()); fields_173 = a_182; count_174 = a_183;  goto _m0; (V)0; }); } else rt_panic("match: no case at layout:189"); _r; });
}
V scc_32(uint32_t w, V *a);
V d_Emit_dPacked_dslots(V fields_173, V count_174) {
  V w_a[] = {fields_173, count_174};
  return scc_32(0, w_a);
}
V scc_31(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u7(V packed_switch_7_145, V field_146, V hex_147, V index_148, V rest_149) {
  V w_a[] = {packed_switch_7_145, field_146, hex_147, index_148, rest_149};
  return scc_31(1, w_a);
}
V scc_32(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u21(V packed_switch_21_175, V count_176) {
  V w_a[] = {packed_switch_21_175, count_176};
  return scc_32(1, w_a);
}
V d_Case_dPacked_dswitch_u27(V packed_switch_27_184) {
  return ({ V _r = 0; V m_185 = packed_switch_27_184; switch (tag_of(m_185)) { case 3: {  _r = TRUE_V; break; } case 0: {  _r = FALSE_V; break; } case 1: {  _r = FALSE_V; break; } case 2: {  _r = FALSE_V; break; } case 4: {  _r = FALSE_V; break; } default: rt_panic("match: no case at layout:194"); } _r; });
}
V d_Case_dPacked_dswitch_u28(V packed_switch_28_186) {
  return ({ V _r = 0; V m_187 = packed_switch_28_186; if ((tag_of(m_187) == 0)) { V typ_188 = FLD(m_187, 1); V slot_189 = FLD(m_187, 2); V offset_190 = FLD(m_187, 3); _r = ((d_Big_dis_ueq(d_Big_dof_unat(d_Layout_dPacked_dwidth(typ_188)), d_Big_dof_unat(NAT_SMALL(32ull)))) != FALSE_V ? CON(d_Emit_dnumber(slot_189), CON(rt_ctor1(0, ((V)&S_19)), NIL)) : ({ V clear_191 = d_Big_dsub(d_Emit_dPacked_dmask(NAT_SMALL(32ull)), d_Big_dshift_uleft(d_Emit_dPacked_dmask(d_Layout_dPacked_dwidth(typ_188)), nat_mul(offset_190, NAT_SMALL(8ull)))); ({ V shift_192 = ((d_Big_dis_uzero(d_Big_dof_unat(offset_190))) != FALSE_V ? NIL : CON(d_Emit_dnumber(d_Big_dof_unat(nat_mul(offset_190, NAT_SMALL(8ull)))), CON(rt_ctor1(0, ((V)&S_20)), NIL))); list_append(CON(d_Emit_dnumber(slot_189), CON(rt_ctor1(0, ((V)&S_21)), CON(d_Emit_dnumber(clear_191), CON(rt_ctor1(0, ((V)&S_22)), CON(rt_ctor1(3, d_Big_done()), NIL))))), list_append(shift_192, CON(rt_ctor1(0, ((V)&S_23)), CON(d_Emit_dnumber(slot_189), CON(rt_ctor1(0, ((V)&S_19)), NIL))))); }); })); } else rt_panic("match: no case at layout:202"); _r; });
}
V d_Case_dPacked_dswitch_u29(V packed_switch_29_193) {
  return ({ V _r = 0; V m_194 = packed_switch_29_193; if ((tag_of(m_194) == 0)) { V typ_195 = FLD(m_194, 1); V slot_196 = FLD(m_194, 2); V offset_197 = FLD(m_194, 3); _r = ({ V shift_198 = ((d_Big_dis_uzero(d_Big_dof_unat(offset_197))) != FALSE_V ? NIL : CON(d_Emit_dnumber(d_Big_dof_unat(nat_mul(offset_197, NAT_SMALL(8ull)))), CON(rt_ctor1(0, ((V)&S_24)), NIL))); ({ V mask_199 = ((d_Big_dis_ueq(d_Big_dof_unat(d_Layout_dPacked_dwidth(typ_195)), d_Big_dof_unat(NAT_SMALL(32ull)))) != FALSE_V ? NIL : CON(d_Emit_dnumber(d_Emit_dPacked_dmask(d_Layout_dPacked_dwidth(typ_195))), CON(rt_ctor1(0, ((V)&S_22)), NIL))); list_append(CON(d_Emit_dnumber(slot_196), CON(rt_ctor1(0, ((V)&S_21)), NIL)), list_append(shift_198, mask_199)); }); }); } else rt_panic("match: no case at layout:211"); _r; });
}
V scc_31(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u30(V packed_switch_30_150, V hex_151, V index_152) {
  V w_a[] = {packed_switch_30_150, hex_151, index_152};
  return scc_31(2, w_a);
}
V d_Case_dPacked_dswitch_u31(V packed_switch_31_200, V name_201, V rest_202) {
  return ({ V _r = 0; V m_203 = packed_switch_31_200; if (((m_203) == NIL)) {  _r = FALSE_V; } else if (((m_203) != NIL)) { V expected_204 = FLD(m_203, 0); V tail_205 = FLD(m_203, 1); _r = ((d_NativeString_dequal(name_201, expected_204)) & (d_Emit_dPacked_dnames(rest_202, tail_205))); } else rt_panic("match: no case at layout:224"); _r; });
}
V d_Case_dPacked_dswitch_u32(V packed_switch_32_206) {
  return ({ V _r = 0; V m_207 = packed_switch_32_206; if (((m_207) == NIL)) {  _r = TRUE_V; } else if (((m_207) != NIL)) {  _r = FALSE_V; } else rt_panic("match: no case at layout:229"); _r; });
}
V d_Case_dPacked_dswitch_u33(V packed_switch_33_208, V names_209) {
  return ({ V _r = 0; V m_210 = packed_switch_33_208; if (((m_210) == NIL)) {  _r = d_Case_dPacked_dswitch_u32(names_209); } else if (((m_210) != NIL) && (tag_of(FLD(m_210, 0)) == 0)) { V name_211 = FLD(FLD(m_210, 0), 0); V rest_212 = FLD(m_210, 1); _r = d_Case_dPacked_dswitch_u31(names_209, name_211, rest_212); } else rt_panic("match: no case at layout:234"); _r; });
}
