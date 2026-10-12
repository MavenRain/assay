/* generated from src/assembler.bend */
#include "assay_gen.h"

static V kc_0; static int kc_0_ok;
static Str S_0 = {TAG_STR, 13, {(const uint8_t *)"EMPTY-PROGRAM"}};
static Str S_1 = {TAG_STR, 11, {(const uint8_t *)"EMPTY-LABEL"}};
static Str S_2 = {TAG_STR, 16, {(const uint8_t *)"DUPLICATE-LABEL "}};
static Str S_3 = {TAG_STR, 15, {(const uint8_t *)"UNKNOWN-OPCODE "}};
static Str S_4 = {TAG_STR, 16, {(const uint8_t *)"CONTROL-IN-BODY "}};
static Str S_5 = {TAG_STR, 13, {(const uint8_t *)"INVALID-PUSH "}};
static Str S_6 = {TAG_STR, 14, {(const uint8_t *)"INVALID-DEPTH "}};
static Str S_7 = {TAG_STR, 1, {(const uint8_t *)" "}};
static Str S_8 = {TAG_STR, 14, {(const uint8_t *)"INVALID-WIDTH "}};
static Str S_9 = {TAG_STR, 15, {(const uint8_t *)"INVALID-HEIGHT "}};
static Str S_10 = {TAG_STR, 13, {(const uint8_t *)"ENTRY-HEIGHT "}};
static Str S_11 = {TAG_STR, 14, {(const uint8_t *)"UNKNOWN-LABEL "}};
static Str S_12 = {TAG_STR, 16, {(const uint8_t *)"NOT-DESTINATION "}};
static Str S_13 = {TAG_STR, 15, {(const uint8_t *)"LABEL-OVERFLOW "}};
static Str S_14 = {TAG_STR, 5, {(const uint8_t *)" PUSH"}};
static Str S_15 = {TAG_STR, 13, {(const uint8_t *)"INVALID-NEXT "}};
static Str S_16 = {TAG_STR, 13, {(const uint8_t *)"CODE-OVERFLOW"}};
static Str S_17 = {TAG_STR, 10, {(const uint8_t *)"UNDERFLOW "}};
static Str S_18 = {TAG_STR, 5, {(const uint8_t *)" got="}};
static Str S_19 = {TAG_STR, 6, {(const uint8_t *)" need="}};
static Str S_20 = {TAG_STR, 9, {(const uint8_t *)"OVERFLOW "}};
static Str S_21 = {TAG_STR, 16, {(const uint8_t *)"HEIGHT-MISMATCH "}};
static Str S_22 = {TAG_STR, 6, {(const uint8_t *)" want="}};
static V lam_182(V *env, V *args) {
  (void)env; (void)args;
  V item497_181 = args[0];
  return d_NativeString_dequal(env[0], item497_181);
}
static Str S_23 = {TAG_STR, 4, {(const uint8_t *)"STOP"}};
static Str S_24 = {TAG_STR, 4, {(const uint8_t *)"JUMP"}};
static Str S_25 = {TAG_STR, 5, {(const uint8_t *)"JUMPI"}};
static Str S_26 = {TAG_STR, 8, {(const uint8_t *)"JUMPDEST"}};
static Str S_27 = {TAG_STR, 6, {(const uint8_t *)"RETURN"}};
static Str S_28 = {TAG_STR, 6, {(const uint8_t *)"REVERT"}};
static Str S_29 = {TAG_STR, 7, {(const uint8_t *)"INVALID"}};
static Str S_30 = {TAG_STR, 12, {(const uint8_t *)"SELFDESTRUCT"}};
static Str S_31 = {TAG_STR, 3, {(const uint8_t *)"ADD"}};
static Str S_32 = {TAG_STR, 3, {(const uint8_t *)"MUL"}};
static Str S_33 = {TAG_STR, 3, {(const uint8_t *)"SUB"}};
static Str S_34 = {TAG_STR, 3, {(const uint8_t *)"DIV"}};
static Str S_35 = {TAG_STR, 4, {(const uint8_t *)"SDIV"}};
static Str S_36 = {TAG_STR, 3, {(const uint8_t *)"MOD"}};
static Str S_37 = {TAG_STR, 4, {(const uint8_t *)"SMOD"}};
static Str S_38 = {TAG_STR, 6, {(const uint8_t *)"ADDMOD"}};
static Str S_39 = {TAG_STR, 6, {(const uint8_t *)"MULMOD"}};
static Str S_40 = {TAG_STR, 3, {(const uint8_t *)"EXP"}};
static Str S_41 = {TAG_STR, 10, {(const uint8_t *)"SIGNEXTEND"}};
static Str S_42 = {TAG_STR, 2, {(const uint8_t *)"LT"}};
static Str S_43 = {TAG_STR, 2, {(const uint8_t *)"GT"}};
static Str S_44 = {TAG_STR, 3, {(const uint8_t *)"SLT"}};
static Str S_45 = {TAG_STR, 3, {(const uint8_t *)"SGT"}};
static Str S_46 = {TAG_STR, 2, {(const uint8_t *)"EQ"}};
static Str S_47 = {TAG_STR, 6, {(const uint8_t *)"ISZERO"}};
static Str S_48 = {TAG_STR, 3, {(const uint8_t *)"AND"}};
static Str S_49 = {TAG_STR, 2, {(const uint8_t *)"OR"}};
static Str S_50 = {TAG_STR, 3, {(const uint8_t *)"XOR"}};
static Str S_51 = {TAG_STR, 3, {(const uint8_t *)"NOT"}};
static Str S_52 = {TAG_STR, 4, {(const uint8_t *)"BYTE"}};
static Str S_53 = {TAG_STR, 3, {(const uint8_t *)"SHL"}};
static Str S_54 = {TAG_STR, 3, {(const uint8_t *)"SHR"}};
static Str S_55 = {TAG_STR, 3, {(const uint8_t *)"SAR"}};
static Str S_56 = {TAG_STR, 9, {(const uint8_t *)"KECCAK256"}};
static Str S_57 = {TAG_STR, 7, {(const uint8_t *)"ADDRESS"}};
static Str S_58 = {TAG_STR, 7, {(const uint8_t *)"BALANCE"}};
static Str S_59 = {TAG_STR, 6, {(const uint8_t *)"ORIGIN"}};
static Str S_60 = {TAG_STR, 6, {(const uint8_t *)"CALLER"}};
static Str S_61 = {TAG_STR, 9, {(const uint8_t *)"CALLVALUE"}};
static Str S_62 = {TAG_STR, 12, {(const uint8_t *)"CALLDATALOAD"}};
static Str S_63 = {TAG_STR, 12, {(const uint8_t *)"CALLDATASIZE"}};
static Str S_64 = {TAG_STR, 12, {(const uint8_t *)"CALLDATACOPY"}};
static Str S_65 = {TAG_STR, 8, {(const uint8_t *)"CODESIZE"}};
static Str S_66 = {TAG_STR, 8, {(const uint8_t *)"CODECOPY"}};
static Str S_67 = {TAG_STR, 8, {(const uint8_t *)"GASPRICE"}};
static Str S_68 = {TAG_STR, 11, {(const uint8_t *)"EXTCODESIZE"}};
static Str S_69 = {TAG_STR, 11, {(const uint8_t *)"EXTCODECOPY"}};
static Str S_70 = {TAG_STR, 14, {(const uint8_t *)"RETURNDATASIZE"}};
static Str S_71 = {TAG_STR, 14, {(const uint8_t *)"RETURNDATACOPY"}};
static Str S_72 = {TAG_STR, 11, {(const uint8_t *)"EXTCODEHASH"}};
static Str S_73 = {TAG_STR, 9, {(const uint8_t *)"BLOCKHASH"}};
static Str S_74 = {TAG_STR, 8, {(const uint8_t *)"COINBASE"}};
static Str S_75 = {TAG_STR, 9, {(const uint8_t *)"TIMESTAMP"}};
static Str S_76 = {TAG_STR, 6, {(const uint8_t *)"NUMBER"}};
static Str S_77 = {TAG_STR, 10, {(const uint8_t *)"PREVRANDAO"}};
static Str S_78 = {TAG_STR, 8, {(const uint8_t *)"GASLIMIT"}};
static Str S_79 = {TAG_STR, 7, {(const uint8_t *)"CHAINID"}};
static Str S_80 = {TAG_STR, 11, {(const uint8_t *)"SELFBALANCE"}};
static Str S_81 = {TAG_STR, 7, {(const uint8_t *)"BASEFEE"}};
static Str S_82 = {TAG_STR, 8, {(const uint8_t *)"BLOBHASH"}};
static Str S_83 = {TAG_STR, 11, {(const uint8_t *)"BLOBBASEFEE"}};
static Str S_84 = {TAG_STR, 3, {(const uint8_t *)"POP"}};
static Str S_85 = {TAG_STR, 5, {(const uint8_t *)"MLOAD"}};
static Str S_86 = {TAG_STR, 6, {(const uint8_t *)"MSTORE"}};
static Str S_87 = {TAG_STR, 7, {(const uint8_t *)"MSTORE8"}};
static Str S_88 = {TAG_STR, 5, {(const uint8_t *)"SLOAD"}};
static Str S_89 = {TAG_STR, 6, {(const uint8_t *)"SSTORE"}};
static Str S_90 = {TAG_STR, 2, {(const uint8_t *)"PC"}};
static Str S_91 = {TAG_STR, 5, {(const uint8_t *)"MSIZE"}};
static Str S_92 = {TAG_STR, 3, {(const uint8_t *)"GAS"}};
static Str S_93 = {TAG_STR, 5, {(const uint8_t *)"TLOAD"}};
static Str S_94 = {TAG_STR, 6, {(const uint8_t *)"TSTORE"}};
static Str S_95 = {TAG_STR, 5, {(const uint8_t *)"MCOPY"}};
static Str S_96 = {TAG_STR, 4, {(const uint8_t *)"LOG0"}};
static Str S_97 = {TAG_STR, 4, {(const uint8_t *)"LOG1"}};
static Str S_98 = {TAG_STR, 4, {(const uint8_t *)"LOG2"}};
static Str S_99 = {TAG_STR, 4, {(const uint8_t *)"LOG3"}};
static Str S_100 = {TAG_STR, 4, {(const uint8_t *)"LOG4"}};
static Str S_101 = {TAG_STR, 6, {(const uint8_t *)"CREATE"}};
static Str S_102 = {TAG_STR, 4, {(const uint8_t *)"CALL"}};
static Str S_103 = {TAG_STR, 8, {(const uint8_t *)"CALLCODE"}};
static Str S_104 = {TAG_STR, 12, {(const uint8_t *)"DELEGATECALL"}};
static Str S_105 = {TAG_STR, 7, {(const uint8_t *)"CREATE2"}};
static Str S_106 = {TAG_STR, 10, {(const uint8_t *)"STATICCALL"}};
static V w_Asm_dhex_uchar(V *env, V *args) {
  (void)env; (void)args;
  return d_Asm_dhex_uchar(args[0]);
}
static V lam_198(V *env, V *args) {
  (void)env; (void)args;
  V local500_197 = args[0];
  return d_NativeString_dequal(d_Get_dAsm_dOperation_dname(local500_197), env[0]);
}
static Str S_107 = {TAG_STR, 4, {(const uint8_t *)"PUSH"}};
static Str S_108 = {TAG_STR, 3, {(const uint8_t *)"DUP"}};
static Str S_109 = {TAG_STR, 4, {(const uint8_t *)"SWAP"}};
static V lam_264(V *env, V *args) {
  (void)env; (void)args;
  V local484_229 = args[0];
  V local486_230 = args[1];
  return ({ V _r = 0; V m_231 = local484_229; switch (tag_of(m_231)) { case 1: { V _m_231_a0_232 = FLD(m_231, 0); _r = ({ V item533_233 = _m_231_a0_232; ({ V local489_234 = item533_233; ({ V scrut490_235 = local489_234; ({ V _r = 0; V m_236 = scrut490_235; if ((tag_of(m_236) == 0)) { V _m_236_a0_237 = FLD(m_236, 0); V _m_236_a1_238 = FLD(m_236, 1); V _m_236_a2_239 = FLD(m_236, 2); _r = ({ V p491_240 = _m_236_a0_237; ({ V p492_241 = _m_236_a1_238; ({ V p493_242 = _m_236_a2_239; ({ V _r = 0; V m_243 = d_Asm_dinstruction(local486_230); switch (tag_of(m_243)) { case 1: { V _m_243_a0_244 = FLD(m_243, 0); _r = ({ V item530_245 = _m_243_a0_244; ({ V local516_246 = item530_245; ({ V scrut517_247 = local516_246; ({ V _r = 0; V m_248 = scrut517_247; if ((tag_of(m_248) == 0)) { V _m_248_a0_249 = FLD(m_248, 0); V _m_248_a1_250 = FLD(m_248, 1); _r = ({ V p518_251 = _m_248_a0_249; ({ V p519_252 = _m_248_a1_250; ({ V _r = 0; V m_253 = d_Asm_dstep(d_Get_dAsm_dBlock_dlabel(env[0]), p491_240, p518_251); switch (tag_of(m_253)) { case 1: { V _m_253_a0_254 = FLD(m_253, 0); _r = ({ V item528_255 = _m_253_a0_254; ({ V local526_256 = item528_255; ({ V scrut527_257 = d_Big_dshift_uright(d_Big_dunsigned(NAT_SMALL(63ull), d_Big_dof_unat(str_length(p519_252))), d_Big_dto_unat(d_Big_dunsigned(NAT_SMALL(6ull), d_Big_done()))); ((d_Big_dis_ult(d_NativeInt_dsub((kc_0_ok ? kc_0 : (kc_0 = d_Big_dpred(d_Big_dshift_uleft(d_Big_done(), NAT_SMALL(62ull))), rt_root(&kc_0), kc_0_ok = 1, kc_0)), scrut527_257), p493_242)) != FALSE_V ? FAIL(((V)14)) : DONE(rt_ctor3(0, local526_256, CON(p519_252, p492_241), d_NativeInt_dadd(p493_242, scrut527_257)))); }); }); }); break; } case 0: { V _m_253_a0_258 = FLD(m_253, 0); _r = ({ V item529_259 = _m_253_a0_258; FAIL(item529_259); }); break; } default: rt_panic("match: no case at assembler:182"); } _r; }); }); }); } else rt_panic("match: no case at assembler:182"); _r; }); }); }); }); break; } case 0: { V _m_243_a0_260 = FLD(m_243, 0); _r = ({ V item531_261 = _m_243_a0_260; FAIL(item531_261); }); break; } default: rt_panic("match: no case at assembler:181"); } _r; }); }); }); }); } else rt_panic("match: no case at assembler:181"); _r; }); }); }); }); break; } case 0: { V _m_231_a0_262 = FLD(m_231, 0); _r = ({ V item534_263 = _m_231_a0_262; FAIL(item534_263); }); break; } default: rt_panic("match: no case at assembler:180"); } _r; });
}
static V lam_313(V *env, V *args) {
  (void)env; (void)args;
  V a_311 = args[0];
  V b_312 = args[1];
  return d_NativeString_dorder(a_311, b_312);
}
static V lam_333(V *env, V *args) {
  (void)env; (void)args;
  V a_331 = args[0];
  V b_332 = args[1];
  return d_NativeString_dorder(a_331, b_332);
}
static V lam_340(V *env, V *args) {
  (void)env; (void)args;
  V local471_296 = args[0];
  V local473_297 = args[1];
  return ({ V _r = 0; V m_298 = local471_296; switch (tag_of(m_298)) { case 1: { V _m_298_a0_299 = FLD(m_298, 0); _r = ({ V item569_300 = _m_298_a0_299; ({ V local476_301 = item569_300; ({ V scrut477_302 = local476_301; ({ V _r = 0; V m_303 = scrut477_302; if ((tag_of(m_303) == 0)) { V _m_303_a0_304 = FLD(m_303, 0); V _m_303_a1_305 = FLD(m_303, 1); V _m_303_a2_306 = FLD(m_303, 2); _r = ({ V p478_307 = _m_303_a0_304; ({ V p479_308 = _m_303_a1_305; ({ V p480_309 = _m_303_a2_306; ({ V scrut481_310 = UNIT; ((d_NativeString_dequal(d_Get_dAsm_dBlock_dlabel(local473_297), SNIL)) != FALSE_V ? FAIL(((V)1)) : ((((V)maybe_is_some(d_Assoc_dfind(clo_new(lam_313, 2, 0), d_Get_dAsm_dBlock_dlabel(local473_297), p479_308)))) != FALSE_V ? FAIL(rt_ctor1(2, d_Get_dAsm_dBlock_dlabel(local473_297))) : ((((d_Big_dis_ult(d_Get_dAsm_dBlock_dstack_uin(local473_297), d_Big_dzero())) != FALSE_V ? TRUE_V : d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(1024ull)), d_Get_dAsm_dBlock_dstack_uin(local473_297)))) != FALSE_V ? FAIL(rt_ctor2(8, d_Get_dAsm_dBlock_dlabel(local473_297), d_Get_dAsm_dBlock_dstack_uin(local473_297))) : ({ V _r = 0; V m_314 = d_Asm_dbody(local473_297); switch (tag_of(m_314)) { case 1: { V _m_314_a0_315 = FLD(m_314, 0); _r = ({ V item566_316 = _m_314_a0_315; ({ V local536_317 = item566_316; ({ V scrut537_318 = local536_317; ({ V _r = 0; V m_319 = scrut537_318; if ((tag_of(m_319) == 0)) { V _m_319_a0_320 = FLD(m_319, 0); V _m_319_a1_321 = FLD(m_319, 1); V _m_319_a2_322 = FLD(m_319, 2); _r = ({ V p538_323 = _m_319_a0_320; ({ V p539_324 = _m_319_a1_321; ({ V p540_325 = _m_319_a2_322; ({ V _r = 0; V m_326 = d_Asm_dending_usize(d_Get_dAsm_dBlock_dending(local473_297)); switch (tag_of(m_326)) { case 1: { V _m_326_a0_327 = FLD(m_326, 0); _r = ({ V item563_328 = _m_326_a0_327; ({ V local561_329 = item563_328; ({ V scrut562_330 = d_NativeInt_dadd(local561_329, ((d_Get_dAsm_dBlock_ddestination(local473_297)) != FALSE_V ? d_Big_done() : d_Big_dzero())); ((((d_Big_dis_ult(d_NativeInt_dsub((kc_0_ok ? kc_0 : (kc_0 = d_Big_dpred(d_Big_dshift_uleft(d_Big_done(), NAT_SMALL(62ull))), rt_root(&kc_0), kc_0_ok = 1, kc_0)), scrut562_330), p540_325)) != FALSE_V ? TRUE_V : d_Big_dis_ult(d_NativeInt_dsub(d_NativeInt_dsub((kc_0_ok ? kc_0 : (kc_0 = d_Big_dpred(d_Big_dshift_uleft(d_Big_done(), NAT_SMALL(62ull))), rt_root(&kc_0), kc_0_ok = 1, kc_0)), p540_325), scrut562_330), p478_307))) != FALSE_V ? FAIL(((V)14)) : DONE(rt_ctor3(0, d_NativeInt_dadd(d_NativeInt_dadd(p478_307, p540_325), scrut562_330), d_Assoc_dadd(clo_new(lam_333, 2, 0), d_Get_dAsm_dBlock_dlabel(local473_297), rt_ctor2(0, p478_307, local473_297), p479_308), CON(rt_ctor3(0, local473_297, p538_323, list_reverse(p539_324)), p480_309)))); }); }); }); break; } case 0: { V _m_326_a0_334 = FLD(m_326, 0); _r = ({ V item564_335 = _m_326_a0_334; FAIL(item564_335); }); break; } default: rt_panic("match: no case at assembler:196"); } _r; }); }); }); }); } else rt_panic("match: no case at assembler:196"); _r; }); }); }); }); break; } case 0: { V _m_314_a0_336 = FLD(m_314, 0); _r = ({ V item567_337 = _m_314_a0_336; FAIL(item567_337); }); break; } default: rt_panic("match: no case at assembler:195"); } _r; })))); }); }); }); }); } else rt_panic("match: no case at assembler:194"); _r; }); }); }); }); break; } case 0: { V _m_298_a0_338 = FLD(m_298, 0); _r = ({ V item570_339 = _m_298_a0_338; FAIL(item570_339); }); break; } default: rt_panic("match: no case at assembler:193"); } _r; });
}
static V lam_357(V *env, V *args) {
  (void)env; (void)args;
  V a_355 = args[0];
  V b_356 = args[1];
  return d_NativeString_dorder(a_355, b_356);
}
static Str S_110 = {TAG_STR, 10, {(const uint8_t *)"PUSH-label"}};
static Str S_111 = {TAG_STR, 2, {(const uint8_t *)"56"}};
static Str S_112 = {TAG_STR, 2, {(const uint8_t *)"57"}};
static V lam_498(V *env, V *args) {
  (void)env; (void)args;
  V local592_486 = args[0];
  return ({ V scrut593_487 = local592_486; ({ V _r = 0; V m_488 = scrut593_487; if ((tag_of(m_488) == 0)) { V _m_488_a0_489 = FLD(m_488, 0); V _m_488_a1_490 = FLD(m_488, 1); _r = ({ V p594_491 = _m_488_a0_489; ({ V p595_492 = _m_488_a1_490; ({ V _r = 0; V m_493 = p595_492; if ((tag_of(m_493) == 0)) { V _m_493_a0_494 = FLD(m_493, 0); V _m_493_a1_495 = FLD(m_493, 1); _r = ({ V p596_496 = _m_493_a0_494; ({ V p597_497 = _m_493_a1_495; rt_ctor2(0, p594_491, p596_496); }); }); } else rt_panic("match: no case at assembler:222"); _r; }); }); }); } else rt_panic("match: no case at assembler:222"); _r; }); });
}
static Str S_113 = {TAG_STR, 2, {(const uint8_t *)"5b"}};
static V lam_580(V *env, V *args) {
  (void)env; (void)args;
  V local8601_579 = args[0];
  return d_Big_dis_ueq(d_Get_dAsm_dOperation_dbyte(local8601_579), env[0]);
}
static V lam_604(V *env, V *args) {
  (void)env; (void)args;
  V local8684_592 = args[0];
  V local8686_593 = args[1];
  return ({ V scrut8687_594 = local8686_593; ({ V _r = 0; V m_595 = scrut8687_594; switch (tag_of(m_595)) { case 0: { V _m_595_a0_596 = FLD(m_595, 0); _r = ({ V p8688_597 = _m_595_a0_596; d_NativeInt_dadd(local8684_592, d_Big_done()); }); break; } case 1: { V _m_595_a0_598 = FLD(m_595, 0); _r = ({ V p8689_599 = _m_595_a0_598; d_NativeInt_dadd(d_NativeInt_dadd(local8684_592, d_Big_done()), d_Big_dshift_uright(d_Big_dunsigned(NAT_SMALL(63ull), d_Big_dof_unat(str_length(p8689_599))), d_Big_dto_unat(d_Big_dunsigned(NAT_SMALL(6ull), d_Big_done())))); }); break; } case 2: { V _m_595_a0_600 = FLD(m_595, 0); _r = ({ V p8690_601 = _m_595_a0_600; d_NativeInt_dadd(local8684_592, d_Big_done()); }); break; } case 3: { V _m_595_a0_602 = FLD(m_595, 0); _r = ({ V p8691_603 = _m_595_a0_602; d_NativeInt_dadd(local8684_592, d_Big_done()); }); break; } default: rt_panic("match: no case at assembler:245"); } _r; }); });
}
static V lam_620(V *env, V *args) {
  (void)env; (void)args;
  return d_Get_dAsm_dBlock_dending(env[0]);
}
static V lam_628(V *env, V *args) {
  (void)env; (void)args;
  return d_Get_dAsm_dBlock_dending(env[0]);
}
static V lam_631(V *env, V *args) {
  (void)env; (void)args;
  V local8677_583 = args[0];
  V local8679_584 = args[1];
  return ({ V scrut8680_585 = local8677_583; ({ V _r = 0; V m_586 = scrut8680_585; if ((tag_of(m_586) == 0)) { V _m_586_a0_587 = FLD(m_586, 0); V _m_586_a1_588 = FLD(m_586, 1); _r = ({ V p8681_589 = _m_586_a0_587; ({ V p8682_590 = _m_586_a1_588; ({ V scrut8692_591 = d_SeqList_dfold(clo_new(lam_604, 2, 0), d_Get_dAsm_dBlock_dbody(local8679_584), d_NativeInt_dadd(((d_Get_dAsm_dBlock_ddestination(local8679_584)) != FALSE_V ? d_Big_done() : d_Big_dzero()), ({ V _r = 0; V m_605 = d_Asm_dending_usize(d_Get_dAsm_dBlock_dending(local8679_584)); switch (tag_of(m_605)) { case 1: { V _m_605_a0_606 = FLD(m_605, 0); _r = ({ V x_607 = _m_605_a0_606; x_607; }); break; } case 0: { V _m_605_a0_608 = FLD(m_605, 0); _r = ({ V __609 = _m_605_a0_608; d_Big_dof_unat(NAT_SMALL(256ull)); }); break; } default: rt_panic("match: no case at assembler:245"); } _r; }))); ({ V scrut8703_610 = ({ V scrut8693_611 = d_Get_dAsm_dBlock_dending(local8679_584); ({ V _r = 0; V m_612 = scrut8693_611; switch (tag_of(m_612)) { case 0: { V _m_612_a0_613 = FLD(m_612, 0); _r = ({ V p8694_614 = _m_612_a0_613; d_Get_dAsm_dBlock_dending(local8679_584); }); break; } case 1: { V _m_612_a0_615 = FLD(m_612, 0); V _m_612_a1_616 = FLD(m_612, 1); _r = ({ V p8695_617 = _m_612_a0_615; ({ V p8696_618 = _m_612_a1_616; ({ V otherwise8697_619 = ({ V _c = clo_new(lam_620, 1, 1); CLO_ENV(_c)[0] = local8679_584; _c; }); ((d_Big_dis_ueq(p8695_617, d_Big_dof_unat(NAT_SMALL(2ull)))) != FALSE_V ? rt_ctor2(1, d_Big_done(), p8696_618) : ap(otherwise8697_619, UNIT)); }); }); }); break; } case 2: { V _m_612_a0_621 = FLD(m_612, 0); V _m_612_a1_622 = FLD(m_612, 1); V _m_612_a2_623 = FLD(m_612, 2); _r = ({ V p8698_624 = _m_612_a0_621; ({ V p8699_625 = _m_612_a1_622; ({ V p8700_626 = _m_612_a2_623; ({ V otherwise8701_627 = ({ V _c = clo_new(lam_628, 1, 1); CLO_ENV(_c)[0] = local8679_584; _c; }); ((d_Big_dis_ueq(p8698_624, d_Big_dof_unat(NAT_SMALL(2ull)))) != FALSE_V ? rt_ctor3(2, d_Big_done(), p8699_625, p8700_626) : ap(otherwise8701_627, UNIT)); }); }); }); }); break; } case 3: { V _m_612_a0_629 = FLD(m_612, 0); _r = ({ V p8702_630 = _m_612_a0_629; d_Get_dAsm_dBlock_dending(local8679_584); }); break; } default: rt_panic("match: no case at assembler:247"); } _r; }); }); rt_ctor2(0, d_Big_dminimum(d_Big_dof_unat(NAT_SMALL(256ull)), d_NativeInt_dadd(p8681_589, scrut8692_591)), CON(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dAsm_dBlock_dlabel(local8679_584); _o->f[1] = d_Get_dAsm_dBlock_ddestination(local8679_584); _o->f[2] = d_Get_dAsm_dBlock_dstack_uin(local8679_584); _o->f[3] = d_Get_dAsm_dBlock_dbody(local8679_584); _o->f[4] = scrut8703_610; (V)_o; }), p8682_590)); }); }); }); }); } else rt_panic("match: no case at assembler:244"); _r; }); });
}
static V lam_640(V *env, V *args) {
  (void)env; (void)args;
  V local8710_638 = args[0];
  return ({ V scrut8711_639 = local8710_638; d_Asm_dassemble(env[0]); });
}
static V lam_656(V *env, V *args) {
  (void)env; (void)args;
  V local10115_649 = args[0];
  V local10117_650 = args[1];
  return ({ V _r = 0; V m_651 = local10115_649; switch (tag_of(m_651)) { case 1: { V _m_651_a0_652 = FLD(m_651, 0); _r = ({ V item10118_653 = _m_651_a0_652; ap(local10117_650, item10118_653); }); break; } case 0: { V _m_651_a0_654 = FLD(m_651, 0); _r = ({ V item10119_655 = _m_651_a0_654; FAIL(item10119_655); }); break; } default: rt_panic("match: no case at assembler:256"); } _r; });
}
static Str S_114 = {TAG_STR, 8, {(const uint8_t *)":packed:"}};
static Str S_115 = {TAG_STR, 9, {(const uint8_t *)":continue"}};
static Str S_116 = {TAG_STR, 7, {(const uint8_t *)":reject"}};
static Str S_117 = {TAG_STR, 11, {(const uint8_t *)"constructor"}};
static Str S_118 = {TAG_STR, 6, {(const uint8_t *)"reject"}};
static Str S_119 = {TAG_STR, 10, {(const uint8_t *)"initialize"}};
static V lam_1000(V *env, V *args) {
  (void)env; (void)args;
  V offset_999 = args[0];
  return d_Emit_dPacked_dassemble(CON(d_Emit_dblock(NONE, ((V)&S_117), CON(rt_ctor1(0, ((V)&S_61)), NIL), d_Emit_dbranch_uto(((V)&S_118), ((V)&S_119))), CON(d_Emit_dmarked(((V)&S_119), list_append(env[0], CON(d_Emit_dnumber(env[1]), CON(d_Emit_dnumber(offset_999), CON(d_Emit_dnumber(d_Big_dzero()), CON(rt_ctor1(0, ((V)&S_66)), CON(d_Emit_dnumber(env[1]), CON(d_Emit_dnumber(d_Big_dzero()), NIL))))))), rt_ctor1(0, ((V)1))), CON(d_Emit_dmarked(((V)&S_118), CON(d_Emit_dnumber(d_Big_dzero()), CON(d_Emit_dnumber(d_Big_dzero()), NIL)), rt_ctor1(0, ((V)2))), NIL))), env[2]);
}
static Str S_120 = {TAG_STR, 54, {(const uint8_t *)"PACKED_LAYOUT: cannot print the checked storage layout"}};
static Str S_121 = {TAG_STR, 32, {(const uint8_t *)"generated packed storage listing"}};
static V lam_1012(V *env, V *args) {
  (void)env; (void)args;
  V runtime_1011 = args[0];
  return d_Emit_dPacked_dinit(runtime_1011, env[0], env[1]);
}
static Str S_122 = {TAG_STR, 49, {(const uint8_t *)"PACKED_LAYOUT: invalid scalar storage declaration"}};
static Str S_123 = {TAG_STR, 59, {(const uint8_t *)"PACKED_LAYOUT: checked core fields and source layout differ"}};
static V lam_1059(V *env, V *args) {
  (void)env; (void)args;
  V row_1058 = args[0];
  return d_Emit_dPacked_derror(row_1058);
}
static V lam_1061(V *env, V *args) {
  (void)env; (void)args;
  V entry_1060 = args[0];
  return d_Get_dEmit_dEntry_dabi_uentry(entry_1060);
}

V d_Asm_dResult_dpure(V value_1) {
  return DONE(value_1);
}
V d_Asm_dResult_dbind(V value_2, V next_3) {
  return ({ V _r = 0; V m_4 = value_2; switch (tag_of(m_4)) { case 1: { V x_5 = FLD(m_4, 0); _r = ap(next_3, x_5); break; } case 0: { V error_6 = FLD(m_4, 0); _r = FAIL(error_6); break; } default: rt_panic("match: no case at assembler:48"); } _r; });
}
V d_Get_dAsm_dBlock_dstack_uin(V value_54) {
  return ({ V _r = 0; V m_55 = value_54; if ((tag_of(m_55) == 0)) { V field2_56 = FLD(m_55, 2); _r = field2_56; } else rt_panic("match: no case at assembler:74"); _r; });
}
V d_Get_dAsm_dBlock_dlabel(V value_57) {
  return ({ V _r = 0; V m_58 = value_57; if ((tag_of(m_58) == 0)) { V field0_59 = FLD(m_58, 0); _r = field0_59; } else rt_panic("match: no case at assembler:78"); _r; });
}
V d_Get_dAsm_dOperation_dname(V value_70) {
  return ({ V _r = 0; V m_71 = value_70; if ((tag_of(m_71) == 0)) { V field1_72 = FLD(m_71, 1); _r = field1_72; } else rt_panic("match: no case at assembler:89"); _r; });
}
V d_Get_dAsm_dOperation_dbyte(V value_73) {
  return ({ V _r = 0; V m_74 = value_73; if ((tag_of(m_74) == 0)) { V field0_75 = FLD(m_74, 0); _r = field0_75; } else rt_panic("match: no case at assembler:93"); _r; });
}
V d_Get_dAsm_dOperation_dpops(V value_76) {
  return ({ V _r = 0; V m_77 = value_76; if ((tag_of(m_77) == 0)) { V field2_78 = FLD(m_77, 2); _r = field2_78; } else rt_panic("match: no case at assembler:97"); _r; });
}
V d_Get_dAsm_dOperation_dpushes(V value_79) {
  return ({ V _r = 0; V m_80 = value_79; if ((tag_of(m_80) == 0)) { V field3_81 = FLD(m_80, 3); _r = field3_81; } else rt_panic("match: no case at assembler:101"); _r; });
}
V d_Get_dAsm_dBlock_dbody(V value_82) {
  return ({ V _r = 0; V m_83 = value_82; if ((tag_of(m_83) == 0)) { V field3_84 = FLD(m_83, 3); _r = field3_84; } else rt_panic("match: no case at assembler:105"); _r; });
}
V d_Get_dAsm_dBlock_dending(V value_85) {
  return ({ V _r = 0; V m_86 = value_85; if ((tag_of(m_86) == 0)) { V field4_87 = FLD(m_86, 4); _r = field4_87; } else rt_panic("match: no case at assembler:109"); _r; });
}
V d_Get_dAsm_dBlock_ddestination(V value_101) {
  return ({ V _r = 0; V m_102 = value_101; if ((tag_of(m_102) == 0)) { V field1_103 = FLD(m_102, 1); _r = field1_103; } else rt_panic("match: no case at assembler:120"); _r; });
}
V d_Get_dAsm_dbytes(V value_111) {
  return ({ V _r = 0; V m_112 = value_111; if ((tag_of(m_112) == 0)) { V field0_113 = FLD(m_112, 0); _r = field0_113; } else rt_panic("match: no case at assembler:132"); _r; });
}
V d_Get_dAsm_dpositions(V value_114) {
  return ({ V _r = 0; V m_115 = value_114; if ((tag_of(m_115) == 0)) { V field1_116 = FLD(m_115, 1); _r = field1_116; } else rt_panic("match: no case at assembler:136"); _r; });
}
V d_Get_dAsm_dstacks(V value_117) {
  return ({ V _r = 0; V m_118 = value_117; if ((tag_of(m_118) == 0)) { V field2_119 = FLD(m_118, 2); _r = field2_119; } else rt_panic("match: no case at assembler:140"); _r; });
}
V d_Asm_derror_utext(V param_1003_120) {
  return ({ V scrut20_121 = param_1003_120; ({ V _r = 0; V m_122 = scrut20_121; switch (tag_of(m_122)) { case 0: {  _r = ({ V __123 = UNIT; ((V)&S_0); }); break; } case 1: {  _r = ({ V __124 = UNIT; ((V)&S_1); }); break; } case 2: { V _m_122_a0_125 = FLD(m_122, 0); _r = ({ V p21_126 = _m_122_a0_125; str_append(((V)&S_2), p21_126); }); break; } case 3: { V _m_122_a0_127 = FLD(m_122, 0); _r = ({ V p22_128 = _m_122_a0_127; str_append(((V)&S_3), p22_128); }); break; } case 4: { V _m_122_a0_129 = FLD(m_122, 0); _r = ({ V p23_130 = _m_122_a0_129; str_append(((V)&S_4), p23_130); }); break; } case 5: { V _m_122_a0_131 = FLD(m_122, 0); _r = ({ V p24_132 = _m_122_a0_131; str_append(((V)&S_5), p24_132); }); break; } case 6: { V _m_122_a0_133 = FLD(m_122, 0); V _m_122_a1_134 = FLD(m_122, 1); _r = ({ V p25_135 = _m_122_a0_133; ({ V p26_136 = _m_122_a1_134; str_concat(CON(((V)&S_6), CON(p25_135, CON(((V)&S_7), CON(d_Big_dshow(p26_136), NIL))))); }); }); break; } case 7: { V _m_122_a0_137 = FLD(m_122, 0); _r = ({ V p27_138 = _m_122_a0_137; str_concat(CON(((V)&S_8), CON(d_Big_dshow(p27_138), NIL))); }); break; } case 8: { V _m_122_a0_139 = FLD(m_122, 0); V _m_122_a1_140 = FLD(m_122, 1); _r = ({ V p28_141 = _m_122_a0_139; ({ V p29_142 = _m_122_a1_140; str_concat(CON(((V)&S_9), CON(p28_141, CON(((V)&S_7), CON(d_Big_dshow(p29_142), NIL))))); }); }); break; } case 9: { V _m_122_a0_143 = FLD(m_122, 0); _r = ({ V p30_144 = _m_122_a0_143; str_concat(CON(((V)&S_10), CON(d_Big_dshow(p30_144), NIL))); }); break; } case 10: { V _m_122_a0_145 = FLD(m_122, 0); _r = ({ V p31_146 = _m_122_a0_145; str_append(((V)&S_11), p31_146); }); break; } case 11: { V _m_122_a0_147 = FLD(m_122, 0); _r = ({ V p32_148 = _m_122_a0_147; str_append(((V)&S_12), p32_148); }); break; } case 12: { V _m_122_a0_149 = FLD(m_122, 0); V _m_122_a1_150 = FLD(m_122, 1); _r = ({ V p33_151 = _m_122_a0_149; ({ V p34_152 = _m_122_a1_150; str_concat(CON(((V)&S_13), CON(p33_151, CON(((V)&S_14), CON(d_Big_dshow(p34_152), NIL))))); }); }); break; } case 13: { V _m_122_a0_153 = FLD(m_122, 0); V _m_122_a1_154 = FLD(m_122, 1); _r = ({ V p35_155 = _m_122_a0_153; ({ V p36_156 = _m_122_a1_154; str_concat(CON(((V)&S_15), CON(p35_155, CON(((V)&S_7), CON(p36_156, NIL))))); }); }); break; } case 14: {  _r = ({ V __157 = UNIT; ((V)&S_16); }); break; } case 15: { V _m_122_a0_158 = FLD(m_122, 0); V _m_122_a1_159 = FLD(m_122, 1); V _m_122_a2_160 = FLD(m_122, 2); V _m_122_a3_161 = FLD(m_122, 3); _r = ({ V p37_162 = _m_122_a0_158; ({ V p38_163 = _m_122_a1_159; ({ V p39_164 = _m_122_a2_160; ({ V p40_165 = _m_122_a3_161; str_concat(CON(((V)&S_17), CON(p37_162, CON(((V)&S_7), CON(p38_163, CON(((V)&S_18), CON(d_Big_dshow(p39_164), CON(((V)&S_19), CON(d_Big_dshow(p40_165), NIL))))))))); }); }); }); }); break; } case 16: { V _m_122_a0_166 = FLD(m_122, 0); V _m_122_a1_167 = FLD(m_122, 1); V _m_122_a2_168 = FLD(m_122, 2); _r = ({ V p41_169 = _m_122_a0_166; ({ V p42_170 = _m_122_a1_167; ({ V p43_171 = _m_122_a2_168; str_concat(CON(((V)&S_20), CON(p41_169, CON(((V)&S_7), CON(p42_170, CON(((V)&S_18), CON(d_Big_dshow(p43_171), NIL))))))); }); }); }); break; } case 17: { V _m_122_a0_172 = FLD(m_122, 0); V _m_122_a1_173 = FLD(m_122, 1); V _m_122_a2_174 = FLD(m_122, 2); V _m_122_a3_175 = FLD(m_122, 3); _r = ({ V p44_176 = _m_122_a0_172; ({ V p45_177 = _m_122_a1_173; ({ V p46_178 = _m_122_a2_174; ({ V p47_179 = _m_122_a3_175; str_concat(CON(((V)&S_21), CON(p44_176, CON(((V)&S_7), CON(p45_177, CON(((V)&S_18), CON(d_Big_dshow(p46_178), CON(((V)&S_22), CON(d_Big_dshow(p47_179), NIL))))))))); }); }); }); }); break; } default: rt_panic("match: no case at assembler:146"); } _r; }); });
}
V d_Asm_dcontrol(V name_600_180) {
  return d_SeqList_dexists(({ V _c = clo_new(lam_182, 1, 1); CLO_ENV(_c)[0] = name_600_180; _c; }), CON(((V)&S_23), CON(((V)&S_24), CON(((V)&S_25), CON(((V)&S_26), CON(((V)&S_27), CON(((V)&S_28), CON(((V)&S_29), CON(((V)&S_30), NIL)))))))));
}
V d_Asm_dop(V byte_521_183, V name_522_184, V pops_523_185, V pushes_524_186) {
  return rt_ctor4(0, byte_521_183, name_522_184, pops_523_185, pushes_524_186);
}
V d_Asm_dtable(void) {
  static V memo; static int done;
  if (!done) { memo = CON(d_Asm_dop(d_Big_dzero(), ((V)&S_23), d_Big_dzero(), d_Big_dzero()), CON(d_Asm_dop(d_Big_done(), ((V)&S_31), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(2ull)), ((V)&S_32), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(3ull)), ((V)&S_33), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(4ull)), ((V)&S_34), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(5ull)), ((V)&S_35), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(6ull)), ((V)&S_36), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(7ull)), ((V)&S_37), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(8ull)), ((V)&S_38), d_Big_dof_unat(NAT_SMALL(3ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(9ull)), ((V)&S_39), d_Big_dof_unat(NAT_SMALL(3ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(10ull)), ((V)&S_40), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(11ull)), ((V)&S_41), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(16ull)), ((V)&S_42), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(17ull)), ((V)&S_43), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(18ull)), ((V)&S_44), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(19ull)), ((V)&S_45), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(20ull)), ((V)&S_46), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(21ull)), ((V)&S_47), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(22ull)), ((V)&S_48), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(23ull)), ((V)&S_49), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(24ull)), ((V)&S_50), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(25ull)), ((V)&S_51), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(26ull)), ((V)&S_52), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(27ull)), ((V)&S_53), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(28ull)), ((V)&S_54), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(29ull)), ((V)&S_55), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(32ull)), ((V)&S_56), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(48ull)), ((V)&S_57), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(49ull)), ((V)&S_58), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(50ull)), ((V)&S_59), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(51ull)), ((V)&S_60), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(52ull)), ((V)&S_61), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(53ull)), ((V)&S_62), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(54ull)), ((V)&S_63), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(55ull)), ((V)&S_64), d_Big_dof_unat(NAT_SMALL(3ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(56ull)), ((V)&S_65), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(57ull)), ((V)&S_66), d_Big_dof_unat(NAT_SMALL(3ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(58ull)), ((V)&S_67), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(59ull)), ((V)&S_68), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(60ull)), ((V)&S_69), d_Big_dof_unat(NAT_SMALL(4ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(61ull)), ((V)&S_70), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(62ull)), ((V)&S_71), d_Big_dof_unat(NAT_SMALL(3ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(63ull)), ((V)&S_72), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(64ull)), ((V)&S_73), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(65ull)), ((V)&S_74), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(66ull)), ((V)&S_75), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(67ull)), ((V)&S_76), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(68ull)), ((V)&S_77), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(69ull)), ((V)&S_78), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(70ull)), ((V)&S_79), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(71ull)), ((V)&S_80), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(72ull)), ((V)&S_81), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(73ull)), ((V)&S_82), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(74ull)), ((V)&S_83), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(80ull)), ((V)&S_84), d_Big_done(), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(81ull)), ((V)&S_85), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(82ull)), ((V)&S_86), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(83ull)), ((V)&S_87), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(84ull)), ((V)&S_88), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(85ull)), ((V)&S_89), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(86ull)), ((V)&S_24), d_Big_done(), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(87ull)), ((V)&S_25), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(88ull)), ((V)&S_90), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(89ull)), ((V)&S_91), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(90ull)), ((V)&S_92), d_Big_dzero(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(91ull)), ((V)&S_26), d_Big_dzero(), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(92ull)), ((V)&S_93), d_Big_done(), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(93ull)), ((V)&S_94), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(94ull)), ((V)&S_95), d_Big_dof_unat(NAT_SMALL(3ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(160ull)), ((V)&S_96), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(161ull)), ((V)&S_97), d_Big_dof_unat(NAT_SMALL(3ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(162ull)), ((V)&S_98), d_Big_dof_unat(NAT_SMALL(4ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(163ull)), ((V)&S_99), d_Big_dof_unat(NAT_SMALL(5ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(164ull)), ((V)&S_100), d_Big_dof_unat(NAT_SMALL(6ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(240ull)), ((V)&S_101), d_Big_dof_unat(NAT_SMALL(3ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(241ull)), ((V)&S_102), d_Big_dof_unat(NAT_SMALL(7ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(242ull)), ((V)&S_103), d_Big_dof_unat(NAT_SMALL(7ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(243ull)), ((V)&S_27), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(244ull)), ((V)&S_104), d_Big_dof_unat(NAT_SMALL(6ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(245ull)), ((V)&S_105), d_Big_dof_unat(NAT_SMALL(4ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(250ull)), ((V)&S_106), d_Big_dof_unat(NAT_SMALL(6ull)), d_Big_done()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(253ull)), ((V)&S_28), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(254ull)), ((V)&S_29), d_Big_dzero(), d_Big_dzero()), CON(d_Asm_dop(d_Big_dof_unat(NAT_SMALL(255ull)), ((V)&S_30), d_Big_done(), d_Big_dzero()), NIL)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Asm_dbyte_uhex(V byte_609_187) {
  return str_concat(CON(d_NativeString_dpad(NAT_SMALL(2ull), (((V)48u)), d_Big_dhex(byte_609_187, FALSE_V)), NIL));
}
V d_Asm_dhex_uchar(V c_603_188) {
  return ((((((V)((((((V)48u)))) <= ((c_603_188))))) != FALSE_V ? ((V)(((c_603_188)) <= (((((V)57u)))))) : FALSE_V)) != FALSE_V ? TRUE_V : ((((V)((((((V)97u)))) <= ((c_603_188))))) != FALSE_V ? ((V)(((c_603_188)) <= (((((V)102u)))))) : FALSE_V));
}
V d_Asm_dvalid_uhex(V s_606_189) {
  return ((d_Big_dis_ueq(d_Big_dlogand(d_Big_dof_unat(str_length(s_606_189)), d_Big_done()), d_Big_dzero())) != FALSE_V ? d_NativeString_dall(clo_new(w_Asm_dhex_uchar, 1, 0), s_606_189) : FALSE_V);
}
V d_Asm_dinstruction(V param_675_190) {
  return ({ V scrut495_191 = param_675_190; ({ V _r = 0; V m_192 = scrut495_191; switch (tag_of(m_192)) { case 0: { V _m_192_a0_193 = FLD(m_192, 0); _r = ({ V p496_194 = _m_192_a0_193; ((d_Asm_dcontrol(p496_194)) != FALSE_V ? FAIL(rt_ctor1(4, p496_194)) : ({ V _r = 0; V m_195 = ({ V local503_196 = d_SeqList_dfind(({ V _c = clo_new(lam_198, 1, 1); CLO_ENV(_c)[0] = p496_194; _c; }), d_Asm_dtable()); ({ V _r = 0; V m_199 = local503_196; if (((m_199) == NONE)) {  _r = ({ V __200 = UNIT; FAIL(rt_ctor1(3, p496_194)); }); } else if (((m_199) != NONE)) { V _m_199_a0_201 = FLD(m_199, 0); _r = ({ V x_202 = _m_199_a0_201; DONE(x_202); }); } else rt_panic("match: no case at assembler:168"); _r; }); }); switch (tag_of(m_195)) { case 1: { V _m_195_a0_203 = FLD(m_195, 0); _r = ({ V item506_204 = _m_195_a0_203; ({ V local505_205 = item506_204; DONE(rt_ctor2(0, local505_205, d_Asm_dbyte_uhex(d_Get_dAsm_dOperation_dbyte(local505_205)))); }); }); break; } case 0: { V _m_195_a0_206 = FLD(m_195, 0); _r = ({ V item507_207 = _m_195_a0_206; FAIL(item507_207); }); break; } default: rt_panic("match: no case at assembler:168"); } _r; })); }); break; } case 1: { V _m_192_a0_208 = FLD(m_192, 0); _r = ({ V p508_209 = _m_192_a0_208; ((((d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(64ull)), d_Big_dof_unat(str_length(p508_209)))) != FALSE_V ? TRUE_V : ((d_Asm_dvalid_uhex(p508_209)) ^ 1u))) != FALSE_V ? FAIL(rt_ctor1(5, p508_209)) : ({ V scrut509_210 = d_Big_dshift_uright(d_Big_dunsigned(NAT_SMALL(63ull), d_Big_dof_unat(str_length(p508_209))), d_Big_dto_unat(d_Big_dunsigned(NAT_SMALL(6ull), d_Big_done()))); ({ V scrut510_211 = d_Asm_dop(d_NativeInt_dadd(d_Big_dof_unat(NAT_SMALL(95ull)), scrut509_210), str_append(((V)&S_107), d_Big_dshow(scrut509_210)), d_Big_dzero(), d_Big_done()); DONE(rt_ctor2(0, scrut510_211, str_append(d_Asm_dbyte_uhex(d_Get_dAsm_dOperation_dbyte(scrut510_211)), p508_209))); }); })); }); break; } case 2: { V _m_192_a0_212 = FLD(m_192, 0); _r = ({ V p511_213 = _m_192_a0_212; ((((d_Big_dis_ult(p511_213, d_Big_done())) != FALSE_V ? TRUE_V : d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(16ull)), p511_213))) != FALSE_V ? FAIL(rt_ctor2(6, ((V)&S_108), p511_213)) : ({ V scrut512_214 = d_Asm_dop(d_NativeInt_dadd(d_Big_dof_unat(NAT_SMALL(127ull)), p511_213), str_append(((V)&S_108), d_Big_dshow(p511_213)), p511_213, d_NativeInt_dadd(p511_213, d_Big_done())); DONE(rt_ctor2(0, scrut512_214, d_Asm_dbyte_uhex(d_Get_dAsm_dOperation_dbyte(scrut512_214)))); })); }); break; } case 3: { V _m_192_a0_215 = FLD(m_192, 0); _r = ({ V p513_216 = _m_192_a0_215; ((((d_Big_dis_ult(p513_216, d_Big_done())) != FALSE_V ? TRUE_V : d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(16ull)), p513_216))) != FALSE_V ? FAIL(rt_ctor2(6, ((V)&S_109), p513_216)) : ({ V scrut514_217 = d_Asm_dop(d_NativeInt_dadd(d_Big_dof_unat(NAT_SMALL(143ull)), p513_216), str_append(((V)&S_109), d_Big_dshow(p513_216)), d_NativeInt_dadd(p513_216, d_Big_done()), d_NativeInt_dadd(p513_216, d_Big_done())); DONE(rt_ctor2(0, scrut514_217, d_Asm_dbyte_uhex(d_Get_dAsm_dOperation_dbyte(scrut514_217)))); })); }); break; } default: rt_panic("match: no case at assembler:168"); } _r; }); });
}
V d_Asm_dstep(V label_696_218, V param_701_219, V row_699_220) {
  return ({ V scrut521_221 = param_701_219; ({ V _r = 0; V m_222 = scrut521_221; if ((tag_of(m_222) == 0)) { V _m_222_a0_223 = FLD(m_222, 0); V _m_222_a1_224 = FLD(m_222, 1); _r = ({ V p522_225 = _m_222_a0_223; ({ V p523_226 = _m_222_a1_224; ((d_Big_dis_ult(p522_225, d_Get_dAsm_dOperation_dpops(row_699_220))) != FALSE_V ? FAIL(rt_ctor4(15, label_696_218, d_Get_dAsm_dOperation_dname(row_699_220), p522_225, d_Get_dAsm_dOperation_dpops(row_699_220))) : ({ V scrut524_227 = d_NativeInt_dadd(d_NativeInt_dsub(p522_225, d_Get_dAsm_dOperation_dpops(row_699_220)), d_Get_dAsm_dOperation_dpushes(row_699_220)); ((d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(1024ull)), scrut524_227)) != FALSE_V ? FAIL(rt_ctor3(16, label_696_218, d_Get_dAsm_dOperation_dname(row_699_220), scrut524_227)) : DONE(rt_ctor2(0, scrut524_227, d_Big_dmaximum(p523_226, scrut524_227)))); })); }); }); } else rt_panic("match: no case at assembler:176"); _r; }); });
}
V d_Asm_dbody(V block_704_228) {
  return d_SeqList_dfold(({ V _c = clo_new(lam_264, 2, 1); CLO_ENV(_c)[0] = block_704_228; _c; }), d_Get_dAsm_dBlock_dbody(block_704_228), DONE(rt_ctor3(0, rt_ctor2(0, d_Get_dAsm_dBlock_dstack_uin(block_704_228), d_Get_dAsm_dBlock_dstack_uin(block_704_228)), NIL, d_Big_dzero())));
}
V d_Asm_dwidth(V n_681_265) {
  return ((((d_Big_dis_ult(n_681_265, d_Big_done())) != FALSE_V ? TRUE_V : d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(32ull)), n_681_265))) != FALSE_V ? FAIL(rt_ctor1(7, n_681_265)) : DONE(n_681_265));
}
V d_Asm_dending_usize(V param_693_266) {
  return ({ V scrut542_267 = param_693_266; ({ V _r = 0; V m_268 = scrut542_267; switch (tag_of(m_268)) { case 0: { V _m_268_a0_269 = FLD(m_268, 0); _r = ({ V p543_270 = _m_268_a0_269; DONE(d_Big_done()); }); break; } case 1: { V _m_268_a0_271 = FLD(m_268, 0); V _m_268_a1_272 = FLD(m_268, 1); _r = ({ V p544_273 = _m_268_a0_271; ({ V p545_274 = _m_268_a1_272; ({ V _r = 0; V m_275 = d_Asm_dwidth(p544_273); switch (tag_of(m_275)) { case 1: { V _m_275_a0_276 = FLD(m_275, 0); _r = ({ V item549_277 = _m_275_a0_276; ({ V local548_278 = item549_277; DONE(d_NativeInt_dadd(local548_278, d_Big_dof_unat(NAT_SMALL(2ull)))); }); }); break; } case 0: { V _m_275_a0_279 = FLD(m_275, 0); _r = ({ V item550_280 = _m_275_a0_279; FAIL(item550_280); }); break; } default: rt_panic("match: no case at assembler:190"); } _r; }); }); }); break; } case 2: { V _m_268_a0_281 = FLD(m_268, 0); V _m_268_a1_282 = FLD(m_268, 1); V _m_268_a2_283 = FLD(m_268, 2); _r = ({ V p551_284 = _m_268_a0_281; ({ V p552_285 = _m_268_a1_282; ({ V p553_286 = _m_268_a2_283; ({ V _r = 0; V m_287 = d_Asm_dwidth(p551_284); switch (tag_of(m_287)) { case 1: { V _m_287_a0_288 = FLD(m_287, 0); _r = ({ V item557_289 = _m_287_a0_288; ({ V local556_290 = item557_289; DONE(d_NativeInt_dmul(d_Big_dof_unat(NAT_SMALL(2ull)), d_NativeInt_dadd(local556_290, d_Big_dof_unat(NAT_SMALL(2ull))))); }); }); break; } case 0: { V _m_287_a0_291 = FLD(m_287, 0); _r = ({ V item558_292 = _m_287_a0_291; FAIL(item558_292); }); break; } default: rt_panic("match: no case at assembler:190"); } _r; }); }); }); }); break; } case 3: { V _m_268_a0_293 = FLD(m_268, 0); _r = ({ V p559_294 = _m_268_a0_293; DONE(d_Big_dzero()); }); break; } default: rt_panic("match: no case at assembler:190"); } _r; }); });
}
V d_Asm_dlayout(V blocks_718_295) {
  return d_SeqList_dfold(clo_new(lam_340, 2, 0), blocks_718_295, DONE(rt_ctor3(0, d_Big_dzero(), d_Assoc_dempty(), NIL)));
}
V d_Asm_dhalt(V param_678_341) {
  return ({ V scrut616_342 = param_678_341; ({ V _r = 0; V m_343 = scrut616_342; switch (tag_of(m_343)) { case 0: {  _r = ({ V __344 = UNIT; d_Asm_dop(d_Big_dzero(), ((V)&S_23), d_Big_dzero(), d_Big_dzero()); }); break; } case 1: {  _r = ({ V __345 = UNIT; d_Asm_dop(d_Big_dof_unat(NAT_SMALL(243ull)), ((V)&S_27), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()); }); break; } case 2: {  _r = ({ V __346 = UNIT; d_Asm_dop(d_Big_dof_unat(NAT_SMALL(253ull)), ((V)&S_28), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero()); }); break; } case 3: {  _r = ({ V __347 = UNIT; d_Asm_dop(d_Big_dof_unat(NAT_SMALL(254ull)), ((V)&S_29), d_Big_dzero(), d_Big_dzero()); }); break; } case 4: {  _r = ({ V __348 = UNIT; d_Asm_dop(d_Big_dof_unat(NAT_SMALL(255ull)), ((V)&S_30), d_Big_done(), d_Big_dzero()); }); break; } default: rt_panic("match: no case at assembler:201"); } _r; }); });
}
V d_Asm_dtarget(V labels_868_349, V source_869_350, V height_870_351, V name_871_352) {
  return ({ V _r = 0; V m_353 = ({ V local636_354 = d_Assoc_dfind(clo_new(lam_357, 2, 0), name_871_352, labels_868_349); ({ V _r = 0; V m_358 = local636_354; if (((m_358) == NONE)) {  _r = ({ V __359 = UNIT; FAIL(rt_ctor1(10, name_871_352)); }); } else if (((m_358) != NONE)) { V _m_358_a0_360 = FLD(m_358, 0); _r = ({ V x_361 = _m_358_a0_360; DONE(x_361); }); } else rt_panic("match: no case at assembler:204"); _r; }); }); switch (tag_of(m_353)) { case 1: { V _m_353_a0_362 = FLD(m_353, 0); _r = ({ V item642_363 = _m_353_a0_362; ({ V local638_364 = item642_363; ({ V scrut639_365 = local638_364; ({ V _r = 0; V m_366 = scrut639_365; if ((tag_of(m_366) == 0)) { V _m_366_a0_367 = FLD(m_366, 0); V _m_366_a1_368 = FLD(m_366, 1); _r = ({ V p640_369 = _m_366_a0_367; ({ V p641_370 = _m_366_a1_368; ((((d_Big_dis_ueq(height_870_351, d_Get_dAsm_dBlock_dstack_uin(p641_370))) ^ 1u)) != FALSE_V ? FAIL(rt_ctor4(17, source_869_350, name_871_352, height_870_351, d_Get_dAsm_dBlock_dstack_uin(p641_370))) : DONE(rt_ctor2(0, p640_369, p641_370))); }); }); } else rt_panic("match: no case at assembler:205"); _r; }); }); }); }); break; } case 0: { V _m_353_a0_371 = FLD(m_353, 0); _r = ({ V item643_372 = _m_353_a0_371; FAIL(item643_372); }); break; } default: rt_panic("match: no case at assembler:204"); } _r; });
}
V d_Asm_daddress(V labels_877_373, V source_878_374, V height_879_375, V n_880_376, V name_881_377) {
  return ({ V _r = 0; V m_378 = d_Asm_dtarget(labels_877_373, source_878_374, height_879_375, name_881_377); switch (tag_of(m_378)) { case 1: { V _m_378_a0_379 = FLD(m_378, 0); _r = ({ V item650_380 = _m_378_a0_379; ({ V local645_381 = item650_380; ({ V scrut646_382 = local645_381; ({ V _r = 0; V m_383 = scrut646_382; if ((tag_of(m_383) == 0)) { V _m_383_a0_384 = FLD(m_383, 0); V _m_383_a1_385 = FLD(m_383, 1); _r = ({ V p647_386 = _m_383_a0_384; ({ V p648_387 = _m_383_a1_385; ((((d_Get_dAsm_dBlock_ddestination(p648_387)) ^ 1u)) != FALSE_V ? FAIL(rt_ctor1(11, name_881_377)) : ({ V scrut649_388 = str_concat(CON(d_Big_dhex(p647_386, FALSE_V), NIL)); ((d_Big_dis_ult(d_NativeInt_dmul(n_880_376, d_Big_dof_unat(NAT_SMALL(2ull))), d_Big_dof_unat(str_length(scrut649_388)))) != FALSE_V ? FAIL(rt_ctor2(12, name_881_377, n_880_376)) : DONE(str_append(d_Asm_dbyte_uhex(d_NativeInt_dadd(d_Big_dof_unat(NAT_SMALL(95ull)), n_880_376)), str_append(d_NativeString_drepeat(d_Big_dto_unat(d_NativeInt_dsub(d_NativeInt_dmul(n_880_376, d_Big_dof_unat(NAT_SMALL(2ull))), d_Big_dof_unat(str_length(scrut649_388)))), (((V)48u))), scrut649_388)))); })); }); }); } else rt_panic("match: no case at assembler:209"); _r; }); }); }); }); break; } case 0: { V _m_378_a0_389 = FLD(m_378, 0); _r = ({ V item651_390 = _m_378_a0_389; FAIL(item651_390); }); break; } default: rt_panic("match: no case at assembler:208"); } _r; });
}
V d_Asm_dfinish(V labels_888_391, V block_889_392, V state_890_393, V next_891_394) {
  return ({ V scrut611_395 = state_890_393; ({ V _r = 0; V m_396 = scrut611_395; if ((tag_of(m_396) == 0)) { V _m_396_a0_397 = FLD(m_396, 0); V _m_396_a1_398 = FLD(m_396, 1); _r = ({ V p612_399 = _m_396_a0_397; ({ V p613_400 = _m_396_a1_398; ({ V scrut614_401 = d_Get_dAsm_dBlock_dending(block_889_392); ({ V _r = 0; V m_402 = scrut614_401; switch (tag_of(m_402)) { case 0: { V _m_402_a0_403 = FLD(m_402, 0); _r = ({ V p615_404 = _m_402_a0_403; ({ V scrut617_405 = d_Asm_dhalt(p615_404); ({ V _r = 0; V m_406 = d_Asm_dstep(d_Get_dAsm_dBlock_dlabel(block_889_392), state_890_393, scrut617_405); switch (tag_of(m_406)) { case 1: { V _m_406_a0_407 = FLD(m_406, 0); _r = ({ V item621_408 = _m_406_a0_407; ({ V local620_409 = item621_408; DONE(rt_ctor2(0, local620_409, d_Asm_dbyte_uhex(d_Get_dAsm_dOperation_dbyte(scrut617_405)))); }); }); break; } case 0: { V _m_406_a0_410 = FLD(m_406, 0); _r = ({ V item622_411 = _m_406_a0_410; FAIL(item622_411); }); break; } default: rt_panic("match: no case at assembler:216"); } _r; }); }); }); break; } case 1: { V _m_402_a0_412 = FLD(m_402, 0); V _m_402_a1_413 = FLD(m_402, 1); _r = ({ V p623_414 = _m_402_a0_412; ({ V p624_415 = _m_402_a1_413; ({ V _r = 0; V m_416 = d_Asm_dstep(d_Get_dAsm_dBlock_dlabel(block_889_392), state_890_393, d_Asm_dop(d_NativeInt_dadd(d_Big_dof_unat(NAT_SMALL(95ull)), p623_414), ((V)&S_110), d_Big_dzero(), d_Big_done())); switch (tag_of(m_416)) { case 1: { V _m_416_a0_417 = FLD(m_416, 0); _r = ({ V item658_418 = _m_416_a0_417; ({ V local627_419 = item658_418; ({ V _r = 0; V m_420 = d_Asm_dstep(d_Get_dAsm_dBlock_dlabel(block_889_392), local627_419, d_Asm_dop(d_Big_dof_unat(NAT_SMALL(86ull)), ((V)&S_24), d_Big_done(), d_Big_dzero())); switch (tag_of(m_420)) { case 1: { V _m_420_a0_421 = FLD(m_420, 0); _r = ({ V item656_422 = _m_420_a0_421; ({ V local630_423 = item656_422; ({ V _r = 0; V m_424 = d_Asm_daddress(labels_888_391, d_Get_dAsm_dBlock_dlabel(block_889_392), p612_399, p623_414, p624_415); switch (tag_of(m_424)) { case 1: { V _m_424_a0_425 = FLD(m_424, 0); _r = ({ V item654_426 = _m_424_a0_425; ({ V local653_427 = item654_426; DONE(rt_ctor2(0, local630_423, str_append(local653_427, ((V)&S_111)))); }); }); break; } case 0: { V _m_424_a0_428 = FLD(m_424, 0); _r = ({ V item655_429 = _m_424_a0_428; FAIL(item655_429); }); break; } default: rt_panic("match: no case at assembler:216"); } _r; }); }); }); break; } case 0: { V _m_420_a0_430 = FLD(m_420, 0); _r = ({ V item657_431 = _m_420_a0_430; FAIL(item657_431); }); break; } default: rt_panic("match: no case at assembler:216"); } _r; }); }); }); break; } case 0: { V _m_416_a0_432 = FLD(m_416, 0); _r = ({ V item659_433 = _m_416_a0_432; FAIL(item659_433); }); break; } default: rt_panic("match: no case at assembler:216"); } _r; }); }); }); break; } case 2: { V _m_402_a0_434 = FLD(m_402, 0); V _m_402_a1_435 = FLD(m_402, 1); V _m_402_a2_436 = FLD(m_402, 2); _r = ({ V p661_437 = _m_402_a0_434; ({ V p662_438 = _m_402_a1_435; ({ V p663_439 = _m_402_a2_436; ({ V _r = 0; V m_440 = d_Asm_dstep(d_Get_dAsm_dBlock_dlabel(block_889_392), state_890_393, d_Asm_dop(d_NativeInt_dadd(d_Big_dof_unat(NAT_SMALL(95ull)), p661_437), ((V)&S_110), d_Big_dzero(), d_Big_done())); switch (tag_of(m_440)) { case 1: { V _m_440_a0_441 = FLD(m_440, 0); _r = ({ V item685_442 = _m_440_a0_441; ({ V local666_443 = item685_442; ({ V _r = 0; V m_444 = d_Asm_dstep(d_Get_dAsm_dBlock_dlabel(block_889_392), local666_443, d_Asm_dop(d_Big_dof_unat(NAT_SMALL(87ull)), ((V)&S_25), d_Big_dof_unat(NAT_SMALL(2ull)), d_Big_dzero())); switch (tag_of(m_444)) { case 1: { V _m_444_a0_445 = FLD(m_444, 0); _r = ({ V item683_446 = _m_444_a0_445; ({ V local669_447 = item683_446; ({ V scrut670_448 = local669_447; ({ V _r = 0; V m_449 = scrut670_448; if ((tag_of(m_449) == 0)) { V _m_449_a0_450 = FLD(m_449, 0); V _m_449_a1_451 = FLD(m_449, 1); _r = ({ V p671_452 = _m_449_a0_450; ({ V p672_453 = _m_449_a1_451; ({ V _r = 0; V m_454 = d_Asm_daddress(labels_888_391, d_Get_dAsm_dBlock_dlabel(block_889_392), p671_452, p661_437, p662_438); switch (tag_of(m_454)) { case 1: { V _m_454_a0_455 = FLD(m_454, 0); _r = ({ V item681_456 = _m_454_a0_455; ({ V local675_457 = item681_456; ({ V _r = 0; V m_458 = d_Asm_daddress(labels_888_391, d_Get_dAsm_dBlock_dlabel(block_889_392), p671_452, p661_437, p663_439); switch (tag_of(m_458)) { case 1: { V _m_458_a0_459 = FLD(m_458, 0); _r = ({ V item679_460 = _m_458_a0_459; ({ V local678_461 = item679_460; DONE(rt_ctor2(0, local669_447, str_append(local675_457, str_append(((V)&S_112), str_append(local678_461, ((V)&S_111)))))); }); }); break; } case 0: { V _m_458_a0_462 = FLD(m_458, 0); _r = ({ V item680_463 = _m_458_a0_462; FAIL(item680_463); }); break; } default: rt_panic("match: no case at assembler:217"); } _r; }); }); }); break; } case 0: { V _m_454_a0_464 = FLD(m_454, 0); _r = ({ V item682_465 = _m_454_a0_464; FAIL(item682_465); }); break; } default: rt_panic("match: no case at assembler:217"); } _r; }); }); }); } else rt_panic("match: no case at assembler:217"); _r; }); }); }); }); break; } case 0: { V _m_444_a0_466 = FLD(m_444, 0); _r = ({ V item684_467 = _m_444_a0_466; FAIL(item684_467); }); break; } default: rt_panic("match: no case at assembler:216"); } _r; }); }); }); break; } case 0: { V _m_440_a0_468 = FLD(m_440, 0); _r = ({ V item686_469 = _m_440_a0_468; FAIL(item686_469); }); break; } default: rt_panic("match: no case at assembler:216"); } _r; }); }); }); }); break; } case 3: { V _m_402_a0_470 = FLD(m_402, 0); _r = ({ V p688_471 = _m_402_a0_470; ((((d_Equal_dOptionOf_uString_u(next_891_394, SOME(p688_471))) ^ 1u)) != FALSE_V ? FAIL(rt_ctor2(13, d_Get_dAsm_dBlock_dlabel(block_889_392), p688_471)) : ({ V _r = 0; V m_472 = d_Asm_dtarget(labels_888_391, d_Get_dAsm_dBlock_dlabel(block_889_392), p612_399, p688_471); switch (tag_of(m_472)) { case 1: { V _m_472_a0_473 = FLD(m_472, 0); _r = ({ V item694_474 = _m_472_a0_473; ({ V local693_475 = item694_474; DONE(rt_ctor2(0, state_890_393, SNIL)); }); }); break; } case 0: { V _m_472_a0_476 = FLD(m_472, 0); _r = ({ V item695_477 = _m_472_a0_476; FAIL(item695_477); }); break; } default: rt_panic("match: no case at assembler:217"); } _r; })); }); break; } default: rt_panic("match: no case at assembler:215"); } _r; }); }); }); }); } else rt_panic("match: no case at assembler:214"); _r; }); });
}
V d_Local_dAsm_dencode_df577(V labels_919_478, V acc_922_479, V stacks_923_480, V param_942_481) {
_top: ;
  return ({ V scrut587_482 = param_942_481; ({ V _r = 0; V m_483 = scrut587_482; if (((m_483) == NIL)) {  _r = ({ V __484 = UNIT; DONE(rt_ctor3(0, str_join(list_reverse(acc_922_479), SNIL), ({ V local590_485 = d_Assoc_drows(labels_919_478); d_SeqList_dmap(clo_new(lam_498, 1, 0), local590_485); }), list_reverse(stacks_923_480))); }); } else if (((m_483) != NIL)) { V _m_483_a0_499 = FLD(m_483, 0); V _m_483_a1_500 = FLD(m_483, 1); _r = ({ V p598_501 = _m_483_a0_499; ({ V p599_502 = _m_483_a1_500; ({ V _r = 0; V m_503 = p598_501; if ((tag_of(m_503) == 0)) { V _m_503_a0_504 = FLD(m_503, 0); V _m_503_a1_505 = FLD(m_503, 1); V _m_503_a2_506 = FLD(m_503, 2); _r = ({ V p600_507 = _m_503_a0_504; ({ V p601_508 = _m_503_a1_505; ({ V p602_509 = _m_503_a2_506; ({ V scrut609_510 = ({ V scrut603_511 = p599_502; ({ V _r = 0; V m_512 = scrut603_511; if (((m_512) == NIL)) {  _r = ({ V __513 = UNIT; NONE; }); } else if (((m_512) != NIL)) { V _m_512_a0_514 = FLD(m_512, 0); V _m_512_a1_515 = FLD(m_512, 1); _r = ({ V p604_516 = _m_512_a0_514; ({ V p605_517 = _m_512_a1_515; ({ V _r = 0; V m_518 = p604_516; if ((tag_of(m_518) == 0)) { V _m_518_a0_519 = FLD(m_518, 0); V _m_518_a1_520 = FLD(m_518, 1); V _m_518_a2_521 = FLD(m_518, 2); _r = ({ V p606_522 = _m_518_a0_519; ({ V p607_523 = _m_518_a1_520; ({ V p608_524 = _m_518_a2_521; SOME(d_Get_dAsm_dBlock_dlabel(p606_522)); }); }); }); } else rt_panic("match: no case at assembler:223"); _r; }); }); }); } else rt_panic("match: no case at assembler:223"); _r; }); }); ({ V _r = 0; V m_525 = d_Asm_dfinish(labels_919_478, p600_507, p601_508, scrut609_510); switch (tag_of(m_525)) { case 1: { V _m_525_a0_526 = FLD(m_525, 0); _r = ({ V item714_527 = _m_525_a0_526; ({ V local698_528 = item714_527; ({ V scrut699_529 = local698_528; ({ V _r = 0; V m_530 = scrut699_529; if ((tag_of(m_530) == 0)) { V _m_530_a0_531 = FLD(m_530, 0); V _m_530_a1_532 = FLD(m_530, 1); _r = ({ V p700_533 = _m_530_a0_531; ({ V p701_534 = _m_530_a1_532; ({ V _r = 0; V m_535 = p700_533; if ((tag_of(m_535) == 0)) { V _m_535_a0_536 = FLD(m_535, 0); V _m_535_a1_537 = FLD(m_535, 1); _r = ({ V p702_538 = _m_535_a0_536; ({ V p703_539 = _m_535_a1_537; ({ V scrut704_540 = str_append(((d_Get_dAsm_dBlock_ddestination(p600_507)) != FALSE_V ? ((V)&S_113) : SNIL), str_append(str_join(p602_509, SNIL), p701_534)); ({ V local709_541 = CON(scrut704_540, acc_922_479); ({ V local711_542 = CON(rt_ctor4(0, d_Get_dAsm_dBlock_dlabel(p600_507), d_Get_dAsm_dBlock_dstack_uin(p600_507), p702_538, p703_539), stacks_923_480); ({ V local713_543 = p599_502; ({ V a_544 = local709_541; V a_545 = local711_542; V a_546 = local713_543; acc_922_479 = a_544; stacks_923_480 = a_545; param_942_481 = a_546;  goto _top; (V)0; }); }); }); }); }); }); }); } else rt_panic("match: no case at assembler:225"); _r; }); }); }); } else rt_panic("match: no case at assembler:225"); _r; }); }); }); }); break; } case 0: { V _m_525_a0_547 = FLD(m_525, 0); _r = ({ V item715_548 = _m_525_a0_547; FAIL(item715_548); }); break; } default: rt_panic("match: no case at assembler:224"); } _r; }); }); }); }); }); } else rt_panic("match: no case at assembler:222"); _r; }); }); }); } else rt_panic("match: no case at assembler:221"); _r; }); });
}
V d_Asm_dassemble(V blocks_915_549) {
  return ({ V scrut466_550 = blocks_915_549; ({ V _r = 0; V m_551 = scrut466_550; if (((m_551) == NIL)) {  _r = ({ V __552 = UNIT; FAIL(((V)0)); }); } else if (((m_551) != NIL)) { V _m_551_a0_553 = FLD(m_551, 0); V _m_551_a1_554 = FLD(m_551, 1); _r = ({ V p467_555 = _m_551_a0_553; ({ V p468_556 = _m_551_a1_554; ((((d_Big_dis_ueq(d_Get_dAsm_dBlock_dstack_uin(p467_555), d_Big_dzero())) ^ 1u)) != FALSE_V ? FAIL(rt_ctor1(9, d_Get_dAsm_dBlock_dstack_uin(p467_555))) : ({ V _r = 0; V m_557 = d_Asm_dlayout(blocks_915_549); switch (tag_of(m_557)) { case 1: { V _m_557_a0_558 = FLD(m_557, 0); _r = ({ V item717_559 = _m_557_a0_558; ({ V local572_560 = item717_559; ({ V scrut573_561 = local572_560; ({ V _r = 0; V m_562 = scrut573_561; if ((tag_of(m_562) == 0)) { V _m_562_a0_563 = FLD(m_562, 0); V _m_562_a1_564 = FLD(m_562, 1); V _m_562_a2_565 = FLD(m_562, 2); _r = ({ V p574_566 = _m_562_a0_563; ({ V p575_567 = _m_562_a1_564; ({ V p576_568 = _m_562_a2_565; ({ V local582_569 = NIL; ({ V local584_570 = NIL; ({ V local586_571 = list_reverse(p576_568); d_Local_dAsm_dencode_df577(p575_567, local582_569, local584_570, local586_571); }); }); }); }); }); }); } else rt_panic("match: no case at assembler:231"); _r; }); }); }); }); break; } case 0: { V _m_557_a0_572 = FLD(m_557, 0); _r = ({ V item718_573 = _m_557_a0_572; FAIL(item718_573); }); break; } default: rt_panic("match: no case at assembler:230"); } _r; })); }); }); } else rt_panic("match: no case at assembler:230"); _r; }); });
}
V d_Asm_dhex(V program_967_574) {
  return d_Get_dAsm_dbytes(program_967_574);
}
V d_Asm_ddecode_uopcode(V byte_528_575) {
  return ({ V scrut8597_576 = UNIT; ((((d_Big_dis_ule(d_Big_dof_unat(NAT_SMALL(95ull)), byte_528_575)) != FALSE_V ? d_Big_dis_ule(byte_528_575, d_Big_dof_unat(NAT_SMALL(127ull))) : FALSE_V)) != FALSE_V ? SOME(d_Asm_dop(byte_528_575, str_append(((V)&S_107), d_Big_dshow(d_NativeInt_dsub(byte_528_575, d_Big_dof_unat(NAT_SMALL(95ull))))), d_Big_dzero(), d_Big_done())) : ((((d_Big_dis_ule(d_Big_dof_unat(NAT_SMALL(128ull)), byte_528_575)) != FALSE_V ? d_Big_dis_ule(byte_528_575, d_Big_dof_unat(NAT_SMALL(143ull))) : FALSE_V)) != FALSE_V ? ({ V scrut8598_577 = d_NativeInt_dsub(byte_528_575, d_Big_dof_unat(NAT_SMALL(127ull))); SOME(d_Asm_dop(byte_528_575, str_append(((V)&S_108), d_Big_dshow(scrut8598_577)), scrut8598_577, d_NativeInt_dadd(scrut8598_577, d_Big_done()))); }) : ((((d_Big_dis_ule(d_Big_dof_unat(NAT_SMALL(144ull)), byte_528_575)) != FALSE_V ? d_Big_dis_ule(byte_528_575, d_Big_dof_unat(NAT_SMALL(159ull))) : FALSE_V)) != FALSE_V ? ({ V scrut8599_578 = d_NativeInt_dsub(byte_528_575, d_Big_dof_unat(NAT_SMALL(143ull))); SOME(d_Asm_dop(byte_528_575, str_append(((V)&S_109), d_Big_dshow(scrut8599_578)), d_NativeInt_dadd(scrut8599_578, d_Big_done()), d_NativeInt_dadd(scrut8599_578, d_Big_done()))); }) : d_SeqList_dfind(({ V _c = clo_new(lam_580, 1, 1); CLO_ENV(_c)[0] = byte_528_575; _c; }), d_Asm_dtable())))); });
}
V d_Asm_dassemble_ucompact(V blocks_946_581) {
  return ({ V scrut8706_582 = d_SeqList_dfold(clo_new(lam_631, 2, 0), blocks_946_581, rt_ctor2(0, d_Big_dzero(), NIL)); ({ V _r = 0; V m_632 = scrut8706_582; if ((tag_of(m_632) == 0)) { V _m_632_a0_633 = FLD(m_632, 0); V _m_632_a1_634 = FLD(m_632, 1); _r = ({ V p8707_635 = _m_632_a0_633; ({ V p8708_636 = _m_632_a1_634; ({ V scrut8712_637 = ({ V _c = clo_new(lam_640, 1, 1); CLO_ENV(_c)[0] = blocks_946_581; _c; }); ((d_Big_dis_ult(d_Big_dof_unat(NAT_SMALL(255ull)), p8707_635)) != FALSE_V ? ap(scrut8712_637, UNIT) : ({ V local8715_641 = d_Asm_dassemble(list_reverse(p8708_636)); ({ V _r = 0; V m_642 = local8715_641; switch (tag_of(m_642)) { case 1: { V _m_642_a0_643 = FLD(m_642, 0); _r = ({ V x_644 = _m_642_a0_643; ({ V local8718_645 = x_644; DONE(local8718_645); }); }); break; } case 0: { V _m_642_a0_646 = FLD(m_642, 0); _r = ({ V x_647 = _m_642_a0_646; ({ V local8720_648 = x_647; ap(scrut8712_637, UNIT); }); }); break; } default: rt_panic("match: no case at assembler:253"); } _r; }); })); }); }); }); } else rt_panic("match: no case at assembler:251"); _r; }); });
}
V d_Asm_dlet_u(void) {
  static V memo; static int done;
  if (!done) { memo = clo_new(lam_656, 2, 0); rt_root(&memo); done = 1; }
  return memo;
}
V d_Asm_dlabels(V program_970_657) {
  return d_Get_dAsm_dpositions(program_970_657);
}
V d_Asm_dheights(V program_973_658) {
  return d_Get_dAsm_dstacks(program_973_658);
}
V scc_1(uint32_t w, V *a) {
  V label_659;
  V destination_660;
  V stack_661;
  V instruction_662;
  V rest_663;
  V acc_664;
  V ending_665;
  V fields_666;
  V serial_667;
  V label_668;
  V destination_669;
  V stack_670;
  V hex_671;
  V operation_672;
  V rest_673;
  V acc_674;
  V ending_675;
  V fields_676;
  V serial_677;
  V label_678;
  V destination_679;
  V stack_680;
  V instructions_681;
  V acc_682;
  V ending_683;
  V fields_684;
  V serial_685;
  V packed_switch_9_686;
  V acc_687;
  V destination_688;
  V ending_689;
  V field_690;
  V fields_691;
  V label_692;
  V operation_693;
  V rest_694;
  V serial_695;
  V stack_696;
  V packed_switch_10_697;
  V acc_698;
  V destination_699;
  V ending_700;
  V fields_701;
  V label_702;
  V operation_703;
  V rest_704;
  V serial_705;
  V stack_706;
  V packed_switch_23_707;
  V acc_708;
  V destination_709;
  V ending_710;
  V fields_711;
  V hex_712;
  V instruction_713;
  V label_714;
  V rest_715;
  V serial_716;
  V stack_717;
  V tail_718;
  V packed_switch_24_719;
  V acc_720;
  V destination_721;
  V ending_722;
  V fields_723;
  V hex_724;
  V instruction_725;
  V label_726;
  V serial_727;
  V stack_728;
  V tail_729;
  V packed_switch_25_730;
  V acc_731;
  V destination_732;
  V ending_733;
  V fields_734;
  V instruction_735;
  V label_736;
  V serial_737;
  V stack_738;
  V tail_739;
  V packed_switch_26_740;
  V acc_741;
  V destination_742;
  V ending_743;
  V fields_744;
  V label_745;
  V serial_746;
  V stack_747;
  switch (w) {
  default: label_659 = a[0]; destination_660 = a[1]; stack_661 = a[2]; instruction_662 = a[3]; rest_663 = a[4]; acc_664 = a[5]; ending_665 = a[6]; fields_666 = a[7]; serial_667 = a[8]; goto _m0;
  case 1: label_668 = a[0]; destination_669 = a[1]; stack_670 = a[2]; hex_671 = a[3]; operation_672 = a[4]; rest_673 = a[5]; acc_674 = a[6]; ending_675 = a[7]; fields_676 = a[8]; serial_677 = a[9]; goto _m1;
  case 2: label_678 = a[0]; destination_679 = a[1]; stack_680 = a[2]; instructions_681 = a[3]; acc_682 = a[4]; ending_683 = a[5]; fields_684 = a[6]; serial_685 = a[7]; goto _m2;
  case 3: packed_switch_9_686 = a[0]; acc_687 = a[1]; destination_688 = a[2]; ending_689 = a[3]; field_690 = a[4]; fields_691 = a[5]; label_692 = a[6]; operation_693 = a[7]; rest_694 = a[8]; serial_695 = a[9]; stack_696 = a[10]; goto _m3;
  case 4: packed_switch_10_697 = a[0]; acc_698 = a[1]; destination_699 = a[2]; ending_700 = a[3]; fields_701 = a[4]; label_702 = a[5]; operation_703 = a[6]; rest_704 = a[7]; serial_705 = a[8]; stack_706 = a[9]; goto _m4;
  case 5: packed_switch_23_707 = a[0]; acc_708 = a[1]; destination_709 = a[2]; ending_710 = a[3]; fields_711 = a[4]; hex_712 = a[5]; instruction_713 = a[6]; label_714 = a[7]; rest_715 = a[8]; serial_716 = a[9]; stack_717 = a[10]; tail_718 = a[11]; goto _m5;
  case 6: packed_switch_24_719 = a[0]; acc_720 = a[1]; destination_721 = a[2]; ending_722 = a[3]; fields_723 = a[4]; hex_724 = a[5]; instruction_725 = a[6]; label_726 = a[7]; serial_727 = a[8]; stack_728 = a[9]; tail_729 = a[10]; goto _m6;
  case 7: packed_switch_25_730 = a[0]; acc_731 = a[1]; destination_732 = a[2]; ending_733 = a[3]; fields_734 = a[4]; instruction_735 = a[5]; label_736 = a[6]; serial_737 = a[7]; stack_738 = a[8]; tail_739 = a[9]; goto _m7;
  case 8: packed_switch_26_740 = a[0]; acc_741 = a[1]; destination_742 = a[2]; ending_743 = a[3]; fields_744 = a[4]; label_745 = a[5]; serial_746 = a[6]; stack_747 = a[7]; goto _m8;
  }
_m0: ;
  return ({ V a_748 = label_659; V a_749 = destination_660; V a_750 = stack_661; V a_751 = rest_663; V a_752 = CON(instruction_662, acc_664); V a_753 = ending_665; V a_754 = fields_666; V a_755 = serial_667; label_678 = a_748; destination_679 = a_749; stack_680 = a_750; instructions_681 = a_751; acc_682 = a_752; ending_683 = a_753; fields_684 = a_754; serial_685 = a_755;  goto _m2; (V)0; });
_m1: ;
  return ({ V a_756 = d_Emit_dPacked_dfind(hex_671, fields_676, d_Big_dzero()); V a_757 = acc_674; V a_758 = destination_669; V a_759 = ending_675; V a_760 = fields_676; V a_761 = label_668; V a_762 = operation_672; V a_763 = rest_673; V a_764 = serial_677; V a_765 = stack_670; packed_switch_10_697 = a_756; acc_698 = a_757; destination_699 = a_758; ending_700 = a_759; fields_701 = a_760; label_702 = a_761; operation_703 = a_762; rest_704 = a_763; serial_705 = a_764; stack_706 = a_765;  goto _m4; (V)0; });
_m2: ;
  return ({ V a_766 = instructions_681; V a_767 = acc_682; V a_768 = destination_679; V a_769 = ending_683; V a_770 = fields_684; V a_771 = label_678; V a_772 = serial_685; V a_773 = stack_680; packed_switch_26_740 = a_766; acc_741 = a_767; destination_742 = a_768; ending_743 = a_769; fields_744 = a_770; label_745 = a_771; serial_746 = a_772; stack_747 = a_773;  goto _m8; (V)0; });
_m3: ;
  return ({ V _r = 0; V m_774 = packed_switch_9_686; if ((tag_of(m_774) == 0)) { V typ_775 = FLD(m_774, 1); _r = ((d_NativeString_dequal(operation_693, ((V)&S_88))) != FALSE_V ? ({ V loaded_776 = list_append(list_reverse(d_Emit_dPacked_dload(field_690)), acc_687); ((d_Emit_dPacked_dboolean(typ_775)) != FALSE_V ? d_Emit_dPacked_dguard(label_692, destination_688, stack_696, rest_694, loaded_776, ending_689, fields_691, serial_695, d_Big_dof_unat(NAT_SMALL(2ull)), NIL) : ({ V a_777 = label_692; V a_778 = destination_688; V a_779 = stack_696; V a_780 = rest_694; V a_781 = loaded_776; V a_782 = ending_689; V a_783 = fields_691; V a_784 = serial_695; label_678 = a_777; destination_679 = a_778; stack_680 = a_779; instructions_681 = a_780; acc_682 = a_781; ending_683 = a_782; fields_684 = a_783; serial_685 = a_784;  goto _m2; (V)0; })); }) : ((d_Big_dis_ueq(d_Big_dof_unat(d_Layout_dPacked_dwidth(typ_775)), d_Big_dof_unat(NAT_SMALL(32ull)))) != FALSE_V ? ({ V a_785 = label_692; V a_786 = destination_688; V a_787 = stack_696; V a_788 = rest_694; V a_789 = list_append(list_reverse(d_Emit_dPacked_dstore(field_690)), acc_687); V a_790 = ending_689; V a_791 = fields_691; V a_792 = serial_695; label_678 = a_785; destination_679 = a_786; stack_680 = a_787; instructions_681 = a_788; acc_682 = a_789; ending_683 = a_790; fields_684 = a_791; serial_685 = a_792;  goto _m2; (V)0; }) : d_Emit_dPacked_dguard(label_692, destination_688, stack_696, rest_694, acc_687, ending_689, fields_691, serial_695, d_Big_dshift_uleft(d_Big_done(), d_Layout_dPacked_dbits(typ_775)), d_Emit_dPacked_dstore(field_690)))); } else rt_panic("match: no case at assembler:302"); _r; });
_m4: ;
  return ({ V _r = 0; V m_793 = packed_switch_10_697; switch (tag_of(m_793)) { case 0: { V error_794 = FLD(m_793, 0); _r = FAIL(error_794); break; } case 1: { V field_795 = FLD(m_793, 0); _r = ({ V a_796 = field_795; V a_797 = acc_698; V a_798 = destination_699; V a_799 = ending_700; V a_800 = field_795; V a_801 = fields_701; V a_802 = label_702; V a_803 = operation_703; V a_804 = rest_704; V a_805 = serial_705; V a_806 = stack_706; packed_switch_9_686 = a_796; acc_687 = a_797; destination_688 = a_798; ending_689 = a_799; field_690 = a_800; fields_691 = a_801; label_692 = a_802; operation_693 = a_803; rest_694 = a_804; serial_695 = a_805; stack_696 = a_806;  goto _m3; (V)0; }); break; } default: rt_panic("match: no case at assembler:313"); } _r; });
_m5: ;
  return ({ V _r = 0; V m_807 = packed_switch_23_707; switch (tag_of(m_807)) { case 0: { V operation_808 = FLD(m_807, 0); _r = ((((d_NativeString_dequal(operation_808, ((V)&S_88))) | (d_NativeString_dequal(operation_808, ((V)&S_89))))) != FALSE_V ? ({ V a_809 = label_714; V a_810 = destination_709; V a_811 = stack_717; V a_812 = hex_712; V a_813 = operation_808; V a_814 = rest_715; V a_815 = acc_708; V a_816 = ending_710; V a_817 = fields_711; V a_818 = serial_716; label_668 = a_809; destination_669 = a_810; stack_670 = a_811; hex_671 = a_812; operation_672 = a_813; rest_673 = a_814; acc_674 = a_815; ending_675 = a_816; fields_676 = a_817; serial_677 = a_818;  goto _m1; (V)0; }) : ({ V a_819 = label_714; V a_820 = destination_709; V a_821 = stack_717; V a_822 = instruction_713; V a_823 = tail_718; V a_824 = acc_708; V a_825 = ending_710; V a_826 = fields_711; V a_827 = serial_716; label_659 = a_819; destination_660 = a_820; stack_661 = a_821; instruction_662 = a_822; rest_663 = a_823; acc_664 = a_824; ending_665 = a_825; fields_666 = a_826; serial_667 = a_827;  goto _m0; (V)0; })); break; } case 1: {  _r = ({ V a_828 = label_714; V a_829 = destination_709; V a_830 = stack_717; V a_831 = instruction_713; V a_832 = tail_718; V a_833 = acc_708; V a_834 = ending_710; V a_835 = fields_711; V a_836 = serial_716; label_659 = a_828; destination_660 = a_829; stack_661 = a_830; instruction_662 = a_831; rest_663 = a_832; acc_664 = a_833; ending_665 = a_834; fields_666 = a_835; serial_667 = a_836;  goto _m0; (V)0; }); break; } case 2: {  _r = ({ V a_837 = label_714; V a_838 = destination_709; V a_839 = stack_717; V a_840 = instruction_713; V a_841 = tail_718; V a_842 = acc_708; V a_843 = ending_710; V a_844 = fields_711; V a_845 = serial_716; label_659 = a_837; destination_660 = a_838; stack_661 = a_839; instruction_662 = a_840; rest_663 = a_841; acc_664 = a_842; ending_665 = a_843; fields_666 = a_844; serial_667 = a_845;  goto _m0; (V)0; }); break; } case 3: {  _r = ({ V a_846 = label_714; V a_847 = destination_709; V a_848 = stack_717; V a_849 = instruction_713; V a_850 = tail_718; V a_851 = acc_708; V a_852 = ending_710; V a_853 = fields_711; V a_854 = serial_716; label_659 = a_846; destination_660 = a_847; stack_661 = a_848; instruction_662 = a_849; rest_663 = a_850; acc_664 = a_851; ending_665 = a_852; fields_666 = a_853; serial_667 = a_854;  goto _m0; (V)0; }); break; } default: rt_panic("match: no case at assembler:388"); } _r; });
_m6: ;
  return ({ V _r = 0; V m_855 = packed_switch_24_719; if (((m_855) == NIL)) {  _r = ({ V a_856 = label_726; V a_857 = destination_721; V a_858 = stack_728; V a_859 = instruction_725; V a_860 = tail_729; V a_861 = acc_720; V a_862 = ending_722; V a_863 = fields_723; V a_864 = serial_727; label_659 = a_856; destination_660 = a_857; stack_661 = a_858; instruction_662 = a_859; rest_663 = a_860; acc_664 = a_861; ending_665 = a_862; fields_666 = a_863; serial_667 = a_864;  goto _m0; (V)0; }); } else if (((m_855) != NIL)) { V next_865 = FLD(m_855, 0); V rest_866 = FLD(m_855, 1); _r = ({ V a_867 = next_865; V a_868 = acc_720; V a_869 = destination_721; V a_870 = ending_722; V a_871 = fields_723; V a_872 = hex_724; V a_873 = instruction_725; V a_874 = label_726; V a_875 = rest_866; V a_876 = serial_727; V a_877 = stack_728; V a_878 = tail_729; packed_switch_23_707 = a_867; acc_708 = a_868; destination_709 = a_869; ending_710 = a_870; fields_711 = a_871; hex_712 = a_872; instruction_713 = a_873; label_714 = a_874; rest_715 = a_875; serial_716 = a_876; stack_717 = a_877; tail_718 = a_878;  goto _m5; (V)0; }); } else rt_panic("match: no case at assembler:397"); _r; });
_m7: ;
  return ({ V _r = 0; V m_879 = packed_switch_25_730; switch (tag_of(m_879)) { case 1: { V hex_880 = FLD(m_879, 0); _r = ({ V a_881 = tail_739; V a_882 = acc_731; V a_883 = destination_732; V a_884 = ending_733; V a_885 = fields_734; V a_886 = hex_880; V a_887 = instruction_735; V a_888 = label_736; V a_889 = serial_737; V a_890 = stack_738; V a_891 = tail_739; packed_switch_24_719 = a_881; acc_720 = a_882; destination_721 = a_883; ending_722 = a_884; fields_723 = a_885; hex_724 = a_886; instruction_725 = a_887; label_726 = a_888; serial_727 = a_889; stack_728 = a_890; tail_729 = a_891;  goto _m6; (V)0; }); break; } case 0: {  _r = ({ V a_892 = label_736; V a_893 = destination_732; V a_894 = stack_738; V a_895 = instruction_735; V a_896 = tail_739; V a_897 = acc_731; V a_898 = ending_733; V a_899 = fields_734; V a_900 = serial_737; label_659 = a_892; destination_660 = a_893; stack_661 = a_894; instruction_662 = a_895; rest_663 = a_896; acc_664 = a_897; ending_665 = a_898; fields_666 = a_899; serial_667 = a_900;  goto _m0; (V)0; }); break; } case 2: {  _r = ({ V a_901 = label_736; V a_902 = destination_732; V a_903 = stack_738; V a_904 = instruction_735; V a_905 = tail_739; V a_906 = acc_731; V a_907 = ending_733; V a_908 = fields_734; V a_909 = serial_737; label_659 = a_901; destination_660 = a_902; stack_661 = a_903; instruction_662 = a_904; rest_663 = a_905; acc_664 = a_906; ending_665 = a_907; fields_666 = a_908; serial_667 = a_909;  goto _m0; (V)0; }); break; } case 3: {  _r = ({ V a_910 = label_736; V a_911 = destination_732; V a_912 = stack_738; V a_913 = instruction_735; V a_914 = tail_739; V a_915 = acc_731; V a_916 = ending_733; V a_917 = fields_734; V a_918 = serial_737; label_659 = a_910; destination_660 = a_911; stack_661 = a_912; instruction_662 = a_913; rest_663 = a_914; acc_664 = a_915; ending_665 = a_916; fields_666 = a_917; serial_667 = a_918;  goto _m0; (V)0; }); break; } default: rt_panic("match: no case at assembler:403"); } _r; });
_m8: ;
  return ({ V _r = 0; V m_919 = packed_switch_26_740; if (((m_919) == NIL)) {  _r = DONE(CON(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = label_745; _o->f[1] = destination_742; _o->f[2] = stack_747; _o->f[3] = list_reverse(acc_741); _o->f[4] = ending_743; (V)_o; }), NIL)); } else if (((m_919) != NIL)) { V instruction_920 = FLD(m_919, 0); V tail_921 = FLD(m_919, 1); _r = ({ V a_922 = instruction_920; V a_923 = acc_741; V a_924 = destination_742; V a_925 = ending_743; V a_926 = fields_744; V a_927 = instruction_920; V a_928 = label_745; V a_929 = serial_746; V a_930 = stack_747; V a_931 = tail_921; packed_switch_25_730 = a_922; acc_731 = a_923; destination_732 = a_924; ending_733 = a_925; fields_734 = a_926; instruction_735 = a_927; label_736 = a_928; serial_737 = a_929; stack_738 = a_930; tail_739 = a_931;  goto _m7; (V)0; }); } else rt_panic("match: no case at assembler:411"); _r; });
}
V scc_1(uint32_t w, V *a);
V d_Emit_dPacked_dnext(V label_659, V destination_660, V stack_661, V instruction_662, V rest_663, V acc_664, V ending_665, V fields_666, V serial_667) {
  V w_a[] = {label_659, destination_660, stack_661, instruction_662, rest_663, acc_664, ending_665, fields_666, serial_667};
  return scc_1(0, w_a);
}
V d_Emit_dPacked_dguard(V label_932, V destination_933, V stack_934, V rest_935, V acc_936, V ending_937, V fields_938, V serial_939, V bound_940, V accepted_941) {
  return ({ V continue_942 = str_concat(CON(label_932, CON(((V)&S_114), CON(d_Big_dshow(d_Big_dof_unat(serial_939)), CON(((V)&S_115), NIL))))); ({ V reject_943 = str_concat(CON(label_932, CON(((V)&S_114), CON(d_Big_dshow(d_Big_dof_unat(serial_939)), CON(((V)&S_116), NIL))))); ({ V guard_944 = list_append(list_reverse(acc_936), CON(rt_ctor1(2, d_Big_done()), CON(d_Emit_dnumber(bound_940), CON(rt_ctor1(3, d_Big_done()), CON(rt_ctor1(0, ((V)&S_42)), NIL))))); d_Case_dPacked_dswitch_u8(d_Emit_dPacked_dscan(continue_942, TRUE_V, d_Big_done(), rest_935, list_reverse(accepted_941), ending_937, fields_938, nat_add(serial_939, NAT_SMALL(1ull))), continue_942, destination_933, guard_944, label_932, reject_943, stack_934); }); }); });
}
V scc_1(uint32_t w, V *a);
V d_Emit_dPacked_dstorage(V label_668, V destination_669, V stack_670, V hex_671, V operation_672, V rest_673, V acc_674, V ending_675, V fields_676, V serial_677) {
  V w_a[] = {label_668, destination_669, stack_670, hex_671, operation_672, rest_673, acc_674, ending_675, fields_676, serial_677};
  return scc_1(1, w_a);
}
V scc_1(uint32_t w, V *a);
V d_Emit_dPacked_dscan(V label_678, V destination_679, V stack_680, V instructions_681, V acc_682, V ending_683, V fields_684, V serial_685) {
  V w_a[] = {label_678, destination_679, stack_680, instructions_681, acc_682, ending_683, fields_684, serial_685};
  return scc_1(2, w_a);
}
V d_Emit_dPacked_dblocks(V blocks_945, V fields_946) {
  return d_Case_dPacked_dswitch_u22(blocks_945, fields_946);
}
V d_Emit_dPacked_dassemble(V blocks_947, V fields_948) {
  return d_Case_dPacked_dswitch_u13(d_Emit_dPacked_dblocks(blocks_947, fields_948));
}
V d_Emit_dPacked_dinit(V runtime_949, V constructor_950, V fields_951) {
  return d_Case_dPacked_dswitch_u14(d_Emit_dconstructor_ubody(constructor_950), fields_951, runtime_949);
}
V d_Emit_dPacked_derror(V row_952) {
  return d_Case_dPacked_dswitch_u20(row_952);
}
V d_Emit_dPacked_doutput(V contract_953, V constructor_954, V fields_955, V parameters_956, V abi_957, V names_958, V rows_959, V program_960) {
  return d_Case_dPacked_dswitch_u15(d_Layout_dPacked_dprint(contract_953, parameters_956), abi_957, constructor_954, contract_953, fields_955, names_958, program_960, rows_959);
}
V d_Emit_dPacked_dprogram(V contract_961, V export_962, V globals_963, V rows_964, V erased_965, V parameters_966) {
  return d_Case_dPacked_dswitch_u17(d_Layout_dPacked_dplan(parameters_966), contract_961, erased_965, export_962, globals_963, parameters_966, rows_964);
}
V d_Case_dPacked_dswitch_u8(V packed_switch_8_967, V continue_968, V destination_969, V guard_970, V label_971, V reject_972, V stack_973) {
  return ({ V _r = 0; V m_974 = packed_switch_8_967; switch (tag_of(m_974)) { case 0: { V error_975 = FLD(m_974, 0); _r = FAIL(error_975); break; } case 1: { V blocks_976 = FLD(m_974, 0); _r = DONE(CON(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = label_971; _o->f[1] = destination_969; _o->f[2] = stack_973; _o->f[3] = guard_970; _o->f[4] = rt_ctor3(2, d_Big_dof_unat(NAT_SMALL(2ull)), continue_968, reject_972); (V)_o; }), CON(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = reject_972; _o->f[1] = TRUE_V; _o->f[2] = d_Big_done(); _o->f[3] = CON(rt_ctor1(0, ((V)&S_84)), CON(d_Emit_dnumber(d_Big_dzero()), CON(d_Emit_dnumber(d_Big_dzero()), NIL))); _o->f[4] = rt_ctor1(0, ((V)2)); (V)_o; }), blocks_976))); break; } default: rt_panic("match: no case at assembler:297"); } _r; });
}
V scc_1(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u9(V packed_switch_9_686, V acc_687, V destination_688, V ending_689, V field_690, V fields_691, V label_692, V operation_693, V rest_694, V serial_695, V stack_696) {
  V w_a[] = {packed_switch_9_686, acc_687, destination_688, ending_689, field_690, fields_691, label_692, operation_693, rest_694, serial_695, stack_696};
  return scc_1(3, w_a);
}
V scc_1(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u10(V packed_switch_10_697, V acc_698, V destination_699, V ending_700, V fields_701, V label_702, V operation_703, V rest_704, V serial_705, V stack_706) {
  V w_a[] = {packed_switch_10_697, acc_698, destination_699, ending_700, fields_701, label_702, operation_703, rest_704, serial_705, stack_706};
  return scc_1(4, w_a);
}
V d_Case_dPacked_dswitch_u11(V packed_switch_11_977, V fields_978, V rest_979) {
  return ({ V _r = 0; V m_980 = packed_switch_11_977; switch (tag_of(m_980)) { case 0: { V error_981 = FLD(m_980, 0); _r = FAIL(error_981); break; } case 1: { V head_982 = FLD(m_980, 0); _r = d_Case_dPacked_dswitch_u12(d_Emit_dPacked_dblocks(rest_979, fields_978), head_982); break; } default: rt_panic("match: no case at assembler:319"); } _r; });
}
V d_Case_dPacked_dswitch_u12(V packed_switch_12_983, V head_984) {
  return ({ V _r = 0; V m_985 = packed_switch_12_983; switch (tag_of(m_985)) { case 0: { V error_986 = FLD(m_985, 0); _r = FAIL(error_986); break; } case 1: { V tail_987 = FLD(m_985, 0); _r = DONE(list_append(head_984, tail_987)); break; } default: rt_panic("match: no case at assembler:325"); } _r; });
}
V d_Case_dPacked_dswitch_u13(V packed_switch_13_988) {
  return ({ V _r = 0; V m_989 = packed_switch_13_988; switch (tag_of(m_989)) { case 0: { V error_990 = FLD(m_989, 0); _r = FAIL(error_990); break; } case 1: { V lowered_991 = FLD(m_989, 0); _r = d_Emit_dassemble(lowered_991); break; } default: rt_panic("match: no case at assembler:330"); } _r; });
}
V d_Case_dPacked_dswitch_u14(V packed_switch_14_992, V fields_993, V runtime_994) {
  return ({ V _r = 0; V m_995 = packed_switch_14_992; switch (tag_of(m_995)) { case 0: { V error_996 = FLD(m_995, 0); _r = FAIL(error_996); break; } case 1: { V body_997 = FLD(m_995, 0); _r = ({ V size_998 = d_Big_dshift_uright(d_Big_dof_unat(str_length(runtime_994)), NAT_SMALL(1ull)); d_Emit_dsettle_uinit(runtime_994, ({ V _c = clo_new(lam_1000, 1, 3); CLO_ENV(_c)[0] = body_997; CLO_ENV(_c)[1] = size_998; CLO_ENV(_c)[2] = fields_993; _c; })); }); break; } default: rt_panic("match: no case at assembler:335"); } _r; });
}
V d_Case_dPacked_dswitch_u15(V packed_switch_15_1001, V abi_1002, V constructor_1003, V contract_1004, V fields_1005, V names_1006, V program_1007, V rows_1008) {
  return ({ V _r = 0; V m_1009 = packed_switch_15_1001; switch (tag_of(m_1009)) { case 0: {  _r = FAIL(rt_ctor1(5, ((V)&S_120))); break; } case 1: { V layout_1010 = FLD(m_1009, 0); _r = d_Case_dPacked_dswitch_u16(d_Emit_doutput(contract_1004, ((V)&S_121), ({ V _c = clo_new(lam_1012, 1, 2); CLO_ENV(_c)[0] = constructor_1003; CLO_ENV(_c)[1] = fields_1005; _c; }), abi_1002, names_1006, rows_1008, program_1007), fields_1005, layout_1010); break; } default: rt_panic("match: no case at assembler:346"); } _r; });
}
V d_Case_dPacked_dswitch_u16(V packed_switch_16_1013, V fields_1014, V layout_1015) {
  return ({ V _r = 0; V m_1016 = packed_switch_16_1013; if ((tag_of(m_1016) == 0)) { V error_1017 = FLD(m_1016, 0); _r = FAIL(error_1017); } else if ((tag_of(m_1016) == 1) && (tag_of(FLD(m_1016, 0)) == 0)) { V runtime_1018 = FLD(FLD(m_1016, 0), 0); V init_1019 = FLD(FLD(m_1016, 0), 1); V printed_abi_1020 = FLD(FLD(m_1016, 0), 2); V axioms_1021 = FLD(FLD(m_1016, 0), 4); V listing_1022 = FLD(FLD(m_1016, 0), 5); _r = DONE(({ Obj *_o = rt_ctor(0, 7); _o->f[0] = runtime_1018; _o->f[1] = init_1019; _o->f[2] = printed_abi_1020; _o->f[3] = layout_1015; _o->f[4] = axioms_1021; _o->f[5] = listing_1022; _o->f[6] = d_Emit_dPacked_dslots(fields_1014, d_Big_dzero()); (V)_o; })); } else rt_panic("match: no case at assembler:352"); _r; });
}
V d_Case_dPacked_dswitch_u17(V packed_switch_17_1023, V contract_1024, V erased_1025, V export_1026, V globals_1027, V parameters_1028, V rows_1029) {
  return ({ V _r = 0; V m_1030 = packed_switch_17_1023; switch (tag_of(m_1030)) { case 0: {  _r = FAIL(rt_ctor1(5, ((V)&S_122))); break; } case 1: { V fields_1031 = FLD(m_1030, 0); _r = d_Case_dPacked_dswitch_u18(d_Emit_drequire_ulowerable(d_Emit_dprepare_um1(export_1026, globals_1027, erased_1025)), contract_1024, fields_1031, parameters_1028, rows_1029); break; } default: rt_panic("match: no case at assembler:357"); } _r; });
}
V d_Case_dPacked_dswitch_u18(V packed_switch_18_1032, V contract_1033, V fields_1034, V parameters_1035, V rows_1036) {
  return ({ V _r = 0; V m_1037 = packed_switch_18_1032; if ((tag_of(m_1037) == 0)) { V error_1038 = FLD(m_1037, 0); _r = FAIL(error_1038); } else if ((tag_of(m_1037) == 1) && (tag_of(FLD(m_1037, 0)) == 0)) { V entries_1039 = FLD(FLD(m_1037, 0), 0); V constructor_1040 = FLD(FLD(m_1037, 0), 1); V names_1041 = FLD(FLD(m_1037, 0), 2); V errors_1042 = FLD(FLD(m_1037, 0), 3); V fallback_1043 = FLD(FLD(m_1037, 0), 4); _r = ((d_Emit_dPacked_dnames(fields_1034, names_1041)) != FALSE_V ? d_Case_dPacked_dswitch_u19(d_Emit_dPacked_dassemble(d_Emit_ddispatch_ublocks(fallback_1043, entries_1039), fields_1034), constructor_1040, contract_1033, entries_1039, errors_1042, fallback_1043, fields_1034, names_1041, parameters_1035, rows_1036) : FAIL(rt_ctor1(5, ((V)&S_123)))); } else rt_panic("match: no case at assembler:363"); _r; });
}
V d_Case_dPacked_dswitch_u19(V packed_switch_19_1044, V constructor_1045, V contract_1046, V entries_1047, V errors_1048, V fallback_1049, V fields_1050, V names_1051, V parameters_1052, V rows_1053) {
  return ({ V _r = 0; V m_1054 = packed_switch_19_1044; switch (tag_of(m_1054)) { case 0: { V error_1055 = FLD(m_1054, 0); _r = FAIL(error_1055); break; } case 1: { V program_1056 = FLD(m_1054, 0); _r = ({ V abi_1057 = d_Abi_dprint(SOME(d_SeqList_dmap(clo_new(lam_1059, 1, 0), errors_1048)), SOME(((V)maybe_is_some(fallback_1049))), d_SeqList_dmap(clo_new(lam_1061, 1, 0), entries_1047)); d_Emit_dPacked_doutput(contract_1046, constructor_1045, fields_1050, parameters_1052, abi_1057, names_1051, rows_1053, program_1056); }); break; } default: rt_panic("match: no case at assembler:371"); } _r; });
}
V d_Case_dPacked_dswitch_u20(V packed_switch_20_1062) {
  return ({ V _r = 0; V m_1063 = packed_switch_20_1062; if ((tag_of(m_1063) == 0)) { V error_1064 = FLD(m_1063, 0); _r = error_1064; } else rt_panic("match: no case at assembler:378"); _r; });
}
V d_Case_dPacked_dswitch_u22(V packed_switch_22_1065, V fields_1066) {
  return ({ V _r = 0; V m_1067 = packed_switch_22_1065; if (((m_1067) == NIL)) {  _r = DONE(NIL); } else if (((m_1067) != NIL) && (tag_of(FLD(m_1067, 0)) == 0)) { V label_1068 = FLD(FLD(m_1067, 0), 0); V destination_1069 = FLD(FLD(m_1067, 0), 1); V stack_1070 = FLD(FLD(m_1067, 0), 2); V body_1071 = FLD(FLD(m_1067, 0), 3); V ending_1072 = FLD(FLD(m_1067, 0), 4); V rest_1073 = FLD(m_1067, 1); _r = d_Case_dPacked_dswitch_u11(d_Emit_dPacked_dscan(label_1068, destination_1069, stack_1070, body_1071, NIL, ending_1072, fields_1066, NAT_SMALL(0ull)), fields_1066, rest_1073); } else rt_panic("match: no case at assembler:382"); _r; });
}
V scc_1(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u23(V packed_switch_23_707, V acc_708, V destination_709, V ending_710, V fields_711, V hex_712, V instruction_713, V label_714, V rest_715, V serial_716, V stack_717, V tail_718) {
  V w_a[] = {packed_switch_23_707, acc_708, destination_709, ending_710, fields_711, hex_712, instruction_713, label_714, rest_715, serial_716, stack_717, tail_718};
  return scc_1(5, w_a);
}
V scc_1(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u24(V packed_switch_24_719, V acc_720, V destination_721, V ending_722, V fields_723, V hex_724, V instruction_725, V label_726, V serial_727, V stack_728, V tail_729) {
  V w_a[] = {packed_switch_24_719, acc_720, destination_721, ending_722, fields_723, hex_724, instruction_725, label_726, serial_727, stack_728, tail_729};
  return scc_1(6, w_a);
}
V scc_1(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u25(V packed_switch_25_730, V acc_731, V destination_732, V ending_733, V fields_734, V instruction_735, V label_736, V serial_737, V stack_738, V tail_739) {
  V w_a[] = {packed_switch_25_730, acc_731, destination_732, ending_733, fields_734, instruction_735, label_736, serial_737, stack_738, tail_739};
  return scc_1(7, w_a);
}
V scc_1(uint32_t w, V *a);
V d_Case_dPacked_dswitch_u26(V packed_switch_26_740, V acc_741, V destination_742, V ending_743, V fields_744, V label_745, V serial_746, V stack_747) {
  V w_a[] = {packed_switch_26_740, acc_741, destination_742, ending_743, fields_744, label_745, serial_746, stack_747};
  return scc_1(8, w_a);
}
