/* generated from src/kernel.bend */
#include "assay_gen.h"

static Str S_0 = {TAG_STR, 1, {(const uint8_t *)"-"}};
static Str S_1 = {TAG_STR, 1, {(const uint8_t *)"0"}};
static V lam_374(V *env, V *args) {
  (void)env; (void)args;
  return d_Series_dstring_unode(env[0]);
}
static V lam_376(V *env, V *args) {
  (void)env; (void)args;
  return d_Series_dstring_unode(env[0]);
}
static V lam_381(V *env, V *args) {
  (void)env; (void)args;
  return d_Series_dlist_unode(env[0]);
}
static V lam_383(V *env, V *args) {
  (void)env; (void)args;
  return d_Series_dlist_unode(env[0]);
}
static V lam_419(V *env, V *args) {
  (void)env; (void)args;
  V u_418 = args[0];
  return d_Series_dtake(UNIT, UNIT, env[0], env[1], u_418);
}
static Str S_2 = {TAG_STR, 4, {(const uint8_t *)"true"}};
static Str S_3 = {TAG_STR, 5, {(const uint8_t *)"false"}};
static V lam_495(V *env, V *args) {
  (void)env; (void)args;
  V c_494 = args[0];
  return d_NativeChar_dlower(c_494);
}
static V lam_498(V *env, V *args) {
  (void)env; (void)args;
  V c_497 = args[0];
  return d_NativeChar_dupper(c_497);
}
static Str S_4 = {TAG_STR, 21, {(const uint8_t *)"recursive definition "}};
static Str S_5 = {TAG_STR, 40, {(const uint8_t *)" failed the structural termination guard"}};
static Str S_6 = {TAG_STR, 9, {(const uint8_t *)"not yet: "}};
static Str S_7 = {TAG_STR, 5, {(const uint8_t *)"line "}};
static Str S_8 = {TAG_STR, 9, {(const uint8_t *)", column "}};
static Str S_9 = {TAG_STR, 2, {(const uint8_t *)": "}};
static Str S_10 = {TAG_STR, 7, {(const uint8_t *)"carry: "}};
static Str S_11 = {TAG_STR, 9, {(const uint8_t *)"unbound: "}};
static Str S_12 = {TAG_STR, 10, {(const uint8_t *)"mismatch: "}};
static Str S_13 = {TAG_STR, 10, {(const uint8_t *)"universe: "}};
static Str S_14 = {TAG_STR, 10, {(const uint8_t *)"quantity: "}};
static Str S_15 = {TAG_STR, 11, {(const uint8_t *)"wrong leg: "}};
static Str S_16 = {TAG_STR, 16, {(const uint8_t *)"missing branch: "}};
static Str S_17 = {TAG_STR, 10, {(const uint8_t *)"overflow: "}};
static Str S_18 = {TAG_STR, 14, {(const uint8_t *)"cannot infer: "}};
static Str S_19 = {TAG_STR, 8, {(const uint8_t *)"budget: "}};
static Str S_20 = {TAG_STR, 16, {(const uint8_t *)"index not zero: "}};
static Str S_21 = {TAG_STR, 22, {(const uint8_t *)"index above universe: "}};
static Str S_22 = {TAG_STR, 13, {(const uint8_t *)"termination: "}};
static Str S_23 = {TAG_STR, 6, {(const uint8_t *)"natAdd"}};
static Str S_24 = {TAG_STR, 6, {(const uint8_t *)"natSub"}};
static Str S_25 = {TAG_STR, 6, {(const uint8_t *)"natMul"}};
static Str S_26 = {TAG_STR, 5, {(const uint8_t *)"natEq"}};
static Str S_27 = {TAG_STR, 5, {(const uint8_t *)"natLt"}};
static Str S_28 = {TAG_STR, 3, {(const uint8_t *)"Nat"}};
static V w_Rules_dleg_uof(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dleg_uof(args[0]);
}
static Str S_29 = {TAG_STR, 1, {(const uint8_t *)"a"}};
static Str S_30 = {TAG_STR, 1, {(const uint8_t *)"b"}};
static V lam_1920(V *env, V *args) {
  (void)env; (void)args;
  V local802_1919 = args[0];
  return d_Rules_darrow(((V)2), ((V)&S_29), d_Prim_dnat_uty(), d_Rules_darrow(((V)2), ((V)&S_30), d_Prim_dnat_uty(), local802_1919));
}
static V lam_1933(V *env, V *args) {
  (void)env; (void)args;
  V a_1931 = args[0];
  V b_1932 = args[1];
  return d_NativeString_dorder(a_1931, b_1932);
}
static V lam_1937(V *env, V *args) {
  (void)env; (void)args;
  V local797_1935 = args[0];
  V local799_1936 = args[1];
  return d_Global_dadd(d_Prim_dname(local799_1936), rt_ctor1(2, rt_ctor2(0, d_Prim_dty(local799_1936), local799_1936)), local797_1935);
}
static V lam_1940(V *env, V *args) {
  (void)env; (void)args;
  V local808_1938 = args[0];
  return ({ V scrut809_1939 = local808_1938; FALSE_V; });
}
static V lam_1955(V *env, V *args) {
  (void)env; (void)args;
  V local831_1948 = args[0];
  V local833_1949 = args[1];
  return ({ V _r = 0; V m_1950 = local831_1948; if (((m_1950) == NONE)) {  _r = ({ V __1951 = UNIT; NONE; }); } else if (((m_1950) != NONE)) { V _m_1950_a0_1952 = FLD(m_1950, 0); _r = ({ V item837_1953 = _m_1950_a0_1952; ({ V local835_1954 = item837_1953; ((((((V)((((((V)48u)))) <= ((local833_1949))))) != FALSE_V ? ((V)(((local833_1949)) <= (((((V)57u)))))) : FALSE_V)) != FALSE_V ? SOME(d_Bignum_dadd(d_Bignum_dmul(local835_1954, d_Bignum_dof_uint(d_Big_dof_unat(NAT_SMALL(10ull)))), d_Bignum_dof_uint(d_NativeInt_dsub(d_Big_dof_unat(NAT_SMALL((local833_1949))), d_Big_dof_unat(NAT_SMALL(((((V)48u))))))))) : NONE); }); }); } else rt_panic("match: no case at kernel:1926"); _r; });
}
static V lam_1973(V *env, V *args) {
  (void)env; (void)args;
  V local1873_1964 = args[0];
  return ({ V scrut1874_1965 = local1873_1964; ({ V _r = 0; V m_1966 = scrut1874_1965; if ((tag_of(m_1966) == 0)) { V _m_1966_a0_1967 = FLD(m_1966, 0); V _m_1966_a1_1968 = FLD(m_1966, 1); V _m_1966_a2_1969 = FLD(m_1966, 2); _r = ({ V p1875_1970 = _m_1966_a0_1967; ({ V p1876_1971 = _m_1966_a1_1968; ({ V p1877_1972 = _m_1966_a2_1969; p1875_1970; }); }); }); } else rt_panic("match: no case at kernel:1946"); _r; }); });
}
static V lam_1978(V *env, V *args) {
  (void)env; (void)args;
  V a_1976 = args[0];
  V b_1977 = args[1];
  return d_NativeString_dorder(a_1976, b_1977);
}
static V lam_1982(V *env, V *args) {
  (void)env; (void)args;
  V local1908_1981 = args[0];
  return d_NativeString_dequal(d_Get_dPositivity_dCtor_dc_uname(local1908_1981), env[0]);
}
static V lam_1998(V *env, V *args) {
  (void)env; (void)args;
  V local1941_1984 = args[0];
  V local1943_1985 = args[1];
  return ({ V _r = 0; V m_1986 = local1941_1984; switch (tag_of(m_1986)) { case 1: { V _m_1986_a0_1987 = FLD(m_1986, 0); _r = ({ V item1952_1988 = _m_1986_a0_1987; ({ V local1946_1989 = item1952_1988; ({ V _r = 0; V m_1990 = local1943_1985; switch (tag_of(m_1990)) { case 1: { V _m_1990_a0_1991 = FLD(m_1990, 0); _r = ({ V item1950_1992 = _m_1990_a0_1991; ({ V local1949_1993 = item1950_1992; DONE(list_append(local1946_1989, CON(local1949_1993, NIL))); }); }); break; } case 0: { V _m_1990_a0_1994 = FLD(m_1990, 0); _r = ({ V item1951_1995 = _m_1990_a0_1994; FAIL(item1951_1995); }); break; } default: rt_panic("match: no case at kernel:1955"); } _r; }); }); }); break; } case 0: { V _m_1986_a0_1996 = FLD(m_1986, 0); _r = ({ V item1953_1997 = _m_1986_a0_1996; FAIL(item1953_1997); }); break; } default: rt_panic("match: no case at kernel:1955"); } _r; });
}
static Str S_31 = {TAG_STR, 16, {(const uint8_t *)"SPar is deferred"}};
static Str S_32 = {TAG_STR, 15, {(const uint8_t *)"SNu is deferred"}};
static V lam_2059(V *env, V *args) {
  (void)env; (void)args;
  V local2064_2057 = args[0];
  V local2066_2058 = args[1];
  return d_Eval_deval(env[0], local2064_2057, local2066_2058);
}
static V w_Level_dmax(V *env, V *args) {
  (void)env; (void)args;
  return d_Level_dmax(args[0], args[1]);
}
static Str S_33 = {TAG_STR, 50, {(const uint8_t *)"the rule pack does not match the shape of the term"}};
static V lam_2114(V *env, V *args) {
  (void)env; (void)args;
  V local2109_2099 = args[0];
  return ({ V scrut2110_2100 = local2109_2099; ({ V _r = 0; V m_2101 = scrut2110_2100; if ((tag_of(m_2101) == 0)) { V _m_2101_a0_2102 = FLD(m_2101, 0); V _m_2101_a1_2103 = FLD(m_2101, 1); V _m_2101_a2_2104 = FLD(m_2101, 2); _r = ({ V p2111_2105 = _m_2101_a0_2102; ({ V p2112_2106 = _m_2101_a1_2103; ({ V p2113_2107 = _m_2101_a2_2104; ({ V t_2108 = ap2(d_Get_dRules_dOps_do_uinfer_uuniv(env[0]), env[1], p2113_2107); V _r; if (tag_of(t_2108) == 0) _r = t_2108; else { V bound2115_2109 = FLD(t_2108, 0); _r = ({ V t_2110 = ap2(d_Get_dRules_dOps_do_ueval(env[0]), env[1], p2113_2107); V _r; if (tag_of(t_2110) == 0) _r = t_2110; else { V bound2117_2111 = FLD(t_2110, 0); _r = ({ V t_2112 = ap2(d_Get_dRules_dOps_do_uinfer_uuniv(env[0]), apn(d_Get_dRules_dOps_do_ubind(env[0]), 4, (V[]){p2112_2106, p2111_2105, bound2117_2111, env[1]}), env[2]); V _r; if (tag_of(t_2112) == 0) _r = t_2112; else { V bound2119_2113 = FLD(t_2112, 0); _r = DONE(CON(bound2115_2109, CON(bound2119_2113, NIL))); } _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:1998"); _r; }); });
}
static V lam_2200(V *env, V *args) {
  (void)env; (void)args;
  V a_2198 = args[0];
  V b_2199 = args[1];
  return d_Big_dcmp(a_2198, b_2199);
}
static V lam_2216(V *env, V *args) {
  (void)env; (void)args;
  V local2182_2201 = args[0];
  V local2184_2202 = args[1];
  V local2186_2203 = args[2];
  return ({ V scrut2187_2204 = maybe_default(local2184_2202, rt_ctor2(0, ((V)0), ((V)0))); ({ V _r = 0; V m_2205 = scrut2187_2204; if ((tag_of(m_2205) == 0)) { V _m_2205_a0_2206 = FLD(m_2205, 0); V _m_2205_a1_2207 = FLD(m_2205, 1); _r = ({ V p2188_2208 = _m_2205_a0_2206; ({ V p2189_2209 = _m_2205_a1_2207; ({ V scrut2190_2210 = maybe_default(local2186_2203, rt_ctor2(0, ((V)0), ((V)0))); ({ V _r = 0; V m_2211 = scrut2190_2210; if ((tag_of(m_2211) == 0)) { V _m_2211_a0_2212 = FLD(m_2211, 0); V _m_2211_a1_2213 = FLD(m_2211, 1); _r = ({ V p2191_2214 = _m_2211_a0_2212; ({ V p2192_2215 = _m_2211_a1_2213; SOME(rt_ctor2(0, ap2(env[0], p2188_2208, p2191_2214), ap2(env[1], p2189_2209, p2192_2215))); }); }); } else rt_panic("match: no case at kernel:2031"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2030"); _r; }); });
}
static V w_Quantity_dadd(V *env, V *args) {
  (void)env; (void)args;
  return d_Quantity_dadd(args[0], args[1]);
}
static V w_Value_das_ulan(V *env, V *args) {
  (void)env; (void)args;
  return d_Value_das_ulan(args[0]);
}
static Str S_34 = {TAG_STR, 47, {(const uint8_t *)"a pair needs a left former as its expected type"}};
static Str S_35 = {TAG_STR, 27, {(const uint8_t *)"a pair needs a point former"}};
static Str S_36 = {TAG_STR, 30, {(const uint8_t *)"a pair takes the point address"}};
static Str S_37 = {TAG_STR, 32, {(const uint8_t *)"a pair carries one fibre element"}};
static V lam_2416(V *env, V *args) {
  (void)env; (void)args;
  V local2309_2409 = args[0];
  return ({ V scrut2310_2410 = local2309_2409; ({ V _r = 0; V m_2411 = scrut2310_2410; if ((tag_of(m_2411) == 0)) { V _m_2411_a0_2412 = FLD(m_2411, 0); V _m_2411_a1_2413 = FLD(m_2411, 1); _r = ({ V p2311_2414 = _m_2411_a0_2412; ({ V p2312_2415 = _m_2411_a1_2413; rt_ctor2(0, d_Quantity_dmul(env[0], p2311_2414), d_Quantity_dmul(env[1], p2312_2415)); }); }); } else rt_panic("match: no case at kernel:2082"); _r; }); });
}
static V lam_2417(V *env, V *args) {
  (void)env; (void)args;
  V local2307_2408 = args[0];
  return d_Assoc_dmap(({ V _c = clo_new(lam_2416, 1, 2); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; _c; }), local2307_2408);
}
static Str S_38 = {TAG_STR, 54, {(const uint8_t *)"an elimination without a motive needs an expected type"}};
static Str S_39 = {TAG_STR, 1, {(const uint8_t *)"1"}};
static Str S_40 = {TAG_STR, 1, {(const uint8_t *)"w"}};
static Str S_41 = {TAG_STR, 4, {(const uint8_t *)"the "}};
static Str S_42 = {TAG_STR, 1, {(const uint8_t *)" "}};
static Str S_43 = {TAG_STR, 11, {(const uint8_t *)" is marked "}};
static Str S_44 = {TAG_STR, 9, {(const uint8_t *)" and the "}};
static Str S_45 = {TAG_STR, 10, {(const uint8_t *)" marks it "}};
static Str S_46 = {TAG_STR, 41, {(const uint8_t *)"the leg address is outside the collection"}};
static Str S_47 = {TAG_STR, 51, {(const uint8_t *)"an erased scrutinee cannot be eliminated at runtime"}};
static Str S_48 = {TAG_STR, 34, {(const uint8_t *)"the scrutinee is not a left former"}};
static Str S_49 = {TAG_STR, 48, {(const uint8_t *)"an elimination at the point shape has one branch"}};
static Str S_50 = {TAG_STR, 32, {(const uint8_t *)"the branch takes the leg address"}};
static Str S_51 = {TAG_STR, 57, {(const uint8_t *)"the branch binds the point and the fibre element (D-M0-3)"}};
static Str S_52 = {TAG_STR, 13, {(const uint8_t *)"branch binder"}};
static Str S_53 = {TAG_STR, 4, {(const uint8_t *)"type"}};
static V lam_2625(V *env, V *args) {
  (void)env; (void)args;
  V local2394_2623 = args[0];
  V local2396_2624 = args[1];
  return local2394_2623;
}
static V w_Quantity_dmaximum(V *env, V *args) {
  (void)env; (void)args;
  return d_Quantity_dmaximum(args[0], args[1]);
}
static V w_Value_das_uran(V *env, V *args) {
  (void)env; (void)args;
  return d_Value_das_uran(args[0]);
}
static Str S_54 = {TAG_STR, 51, {(const uint8_t *)"a section needs a right former as its expected type"}};
static Str S_55 = {TAG_STR, 49, {(const uint8_t *)"a section at the point shape needs a point former"}};
static Str S_56 = {TAG_STR, 40, {(const uint8_t *)"a section at the point shape has one leg"}};
static Str S_57 = {TAG_STR, 28, {(const uint8_t *)"the leg binds the point once"}};
static Str S_58 = {TAG_STR, 6, {(const uint8_t *)"binder"}};
static Str S_59 = {TAG_STR, 38, {(const uint8_t *)"an application takes the point address"}};
static Str S_60 = {TAG_STR, 44, {(const uint8_t *)"the head of an application is not a function"}};
static V lam_2895(V *env, V *args) {
  (void)env; (void)args;
  V local2499_2888 = args[0];
  return ({ V _r = 0; V m_2889 = d_Rules_dopen_uclosure(env[0], d_Get_dValue_dVleg_dvl_uclo(local2499_2888), CON(env[1], NIL)); switch (tag_of(m_2889)) { case 1: { V _m_2889_a0_2890 = FLD(m_2889, 0); _r = ({ V item2503_2891 = _m_2889_a0_2890; DONE(({ V local2502_2892 = item2503_2891; SOME(local2502_2892); })); }); break; } case 0: { V _m_2889_a0_2893 = FLD(m_2889, 0); _r = ({ V item2504_2894 = _m_2889_a0_2893; FAIL(item2504_2894); }); break; } default: rt_panic("match: no case at kernel:2220"); } _r; });
}
static V lam_2896(V *env, V *args) {
  (void)env; (void)args;
  V local2493_2881 = args[0];
  return ({ V scrut2494_2882 = local2493_2881; ({ V _r = 0; V m_2883 = scrut2494_2882; if ((tag_of(m_2883) == 0)) { V _m_2883_a0_2884 = FLD(m_2883, 0); V _m_2883_a1_2885 = FLD(m_2883, 1); _r = ({ V p2495_2886 = _m_2883_a0_2884; ({ V p2496_2887 = _m_2883_a1_2885; d_Rules_dlet_u(d_Rules_done_uof(p2496_2887), ({ V _c = clo_new(lam_2895, 1, 2); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; _c; })); }); }); } else rt_panic("match: no case at kernel:2220"); _r; }); });
}
static V lam_2897(V *env, V *args) {
  (void)env; (void)args;
  V local2471_2874 = args[0];
  return ({ V scrut2472_2875 = local2471_2874; ({ V _r = 0; V m_2876 = scrut2472_2875; if ((tag_of(m_2876) == 0)) { V _m_2876_a0_2877 = FLD(m_2876, 0); V _m_2876_a1_2878 = FLD(m_2876, 1); _r = ({ V p2473_2879 = _m_2876_a0_2877; ({ V p2474_2880 = _m_2876_a1_2878; d_Rules_dlet_u(d_Value_das_usec(env[0]), ({ V _c = clo_new(lam_2896, 1, 2); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = p2474_2880; _c; })); }); }); } else rt_panic("match: no case at kernel:2219"); _r; }); });
}
static V lam_2936(V *env, V *args) {
  (void)env; (void)args;
  V local2543_2923 = args[0];
  return ({ V scrut2544_2924 = local2543_2923; ({ V _r = 0; V m_2925 = scrut2544_2924; if ((tag_of(m_2925) == 0)) { V _m_2925_a0_2926 = FLD(m_2925, 0); V _m_2925_a1_2927 = FLD(m_2925, 1); _r = ({ V p2545_2928 = _m_2925_a0_2926; ({ V p2546_2929 = _m_2925_a1_2927; ({ V _r = 0; V m_2930 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[0]), CON(env[1], CON(env[2], env[3])), d_Get_dTerm_dLeg_dl_ubody(p2546_2929)); switch (tag_of(m_2930)) { case 1: { V _m_2930_a0_2931 = FLD(m_2930, 0); _r = ({ V item2550_2932 = _m_2930_a0_2931; DONE(({ V local2549_2933 = item2550_2932; SOME(local2549_2933); })); }); break; } case 0: { V _m_2930_a0_2934 = FLD(m_2930, 0); _r = ({ V item2551_2935 = _m_2930_a0_2934; FAIL(item2551_2935); }); break; } default: rt_panic("match: no case at kernel:2223"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2223"); _r; }); });
}
static V lam_2937(V *env, V *args) {
  (void)env; (void)args;
  V local2540_2922 = args[0];
  return d_Rules_dlet_u(d_Rules_done_uof(env[0]), ({ V _c = clo_new(lam_2936, 1, 4); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = local2540_2922; CLO_ENV(_c)[2] = env[2]; CLO_ENV(_c)[3] = env[3]; _c; }));
}
static V lam_2938(V *env, V *args) {
  (void)env; (void)args;
  V local2534_2915 = args[0];
  return ({ V scrut2535_2916 = local2534_2915; ({ V _r = 0; V m_2917 = scrut2535_2916; if ((tag_of(m_2917) == 0)) { V _m_2917_a0_2918 = FLD(m_2917, 0); V _m_2917_a1_2919 = FLD(m_2917, 1); _r = ({ V p2536_2920 = _m_2917_a0_2918; ({ V p2537_2921 = _m_2917_a1_2919; d_Rules_dlet_u(d_Rules_done_uof(env[0]), ({ V _c = clo_new(lam_2937, 1, 4); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = p2537_2921; CLO_ENV(_c)[3] = env[3]; _c; })); }); }); } else rt_panic("match: no case at kernel:2222"); _r; }); });
}
static V lam_2939(V *env, V *args) {
  (void)env; (void)args;
  V local2527_2906 = args[0];
  return ({ V scrut2528_2907 = local2527_2906; ({ V _r = 0; V m_2908 = scrut2528_2907; if ((tag_of(m_2908) == 0)) { V _m_2908_a0_2909 = FLD(m_2908, 0); V _m_2908_a1_2910 = FLD(m_2908, 1); V _m_2908_a2_2911 = FLD(m_2908, 2); _r = ({ V p2529_2912 = _m_2908_a0_2909; ({ V p2530_2913 = _m_2908_a1_2910; ({ V p2531_2914 = _m_2908_a2_2911; d_Rules_dlet_u(d_Value_das_upt(p2530_2913), ({ V _c = clo_new(lam_2938, 1, 4); CLO_ENV(_c)[0] = p2531_2914; CLO_ENV(_c)[1] = env[0]; CLO_ENV(_c)[2] = env[1]; CLO_ENV(_c)[3] = env[2]; _c; })); }); }); }); } else rt_panic("match: no case at kernel:2221"); _r; }); });
}
static Str S_61 = {TAG_STR, 46, {(const uint8_t *)"an elimination met a value it cannot eliminate"}};
static V w_Rules_dspi_ubeta(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_ubeta(args[0], args[1]);
}
static Str S_62 = {TAG_STR, 1, {(const uint8_t *)"x"}};
static Str S_63 = {TAG_STR, 1, {(const uint8_t *)"y"}};
static Str S_64 = {TAG_STR, 4, {(const uint8_t *)"self"}};
static V w_Rules_dspi_ulan_ulvl(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_ulan_ulvl(args[0]);
}
static V lam_3192(V *env, V *args) {
  (void)env; (void)args;
  V local2074_3187 = args[0];
  V local2076_3188 = args[1];
  V local2078_3189 = args[2];
  V local2080_3190 = args[3];
  V local2082_3191 = args[4];
  return d_Rules_dspi_uform(clo_new(w_Rules_dspi_ulan_ulvl, 1, 0), local2074_3187, local2076_3188, local2078_3189, local2080_3190, local2082_3191);
}
static V w_Rules_dspi_uran_ulvl(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_uran_ulvl(args[0]);
}
static V lam_3198(V *env, V *args) {
  (void)env; (void)args;
  V local2123_3193 = args[0];
  V local2125_3194 = args[1];
  V local2127_3195 = args[2];
  V local2129_3196 = args[3];
  V local2131_3197 = args[4];
  return d_Rules_dspi_uform(clo_new(w_Rules_dspi_uran_ulvl, 1, 0), local2123_3193, local2125_3194, local2127_3195, local2129_3196, local2131_3197);
}
static V w_Rules_dspi_uintro_uin(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_uintro_uin(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
}
static V w_Rules_dspi_uelim_uelim(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_uelim_uelim(args[0], args[1], args[2], args[3], args[4]);
}
static V w_Rules_dspi_uintro_usec(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_uintro_usec(args[0], args[1], args[2], args[3], args[4], args[5]);
}
static V w_Rules_dspi_uelim_uout(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_uelim_uout(args[0], args[1], args[2], args[3], args[4], args[5]);
}
static V w_Rules_dspi_udiagram_uarity(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_udiagram_uarity(args[0]);
}
static V w_Rules_dspi_uspine_uty(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_uspine_uty(args[0], args[1], args[2], args[3], args[4]);
}
static V w_Rules_dspi_ueta_uran(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_ueta_uran(args[0], args[1], args[2], args[3], args[4], args[5]);
}
static V w_Rules_dspi_ueta_ulan(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_ueta_ulan(args[0], args[1], args[2], args[3], args[4], args[5]);
}
static V w_Rules_dspi_uconv_udiagram(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_uconv_udiagram(args[0], args[1], args[2], args[3], args[4]);
}
static V w_Rules_dspi_uann_ulvl_ueq(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dspi_uann_ulvl_ueq(args[0], args[1], args[2]);
}
static V lam_3203(V *env, V *args) {
  (void)env; (void)args;
  V local2691_3199 = args[0];
  V local2693_3200 = args[1];
  V local2695_3201 = args[2];
  V local2697_3202 = args[3];
  return d_Rules_dpayload_ulvl(clo_new(w_Rules_dspi_ulan_ulvl, 1, 0), local2691_3199, local2693_3200, local2695_3201, local2697_3202);
}
static V lam_3208(V *env, V *args) {
  (void)env; (void)args;
  V local2703_3204 = args[0];
  V local2705_3205 = args[1];
  V local2707_3206 = args[2];
  V local2709_3207 = args[3];
  return d_Rules_dpayload_ulvl(clo_new(w_Rules_dspi_uran_ulvl, 1, 0), local2703_3204, local2705_3205, local2707_3206, local2709_3207);
}
static V w_Rules_dno_usubsingleton(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dno_usubsingleton(args[0], args[1], args[2]);
}
static Str S_65 = {TAG_STR, 50, {(const uint8_t *)"the diagram is not a section of the declared width"}};
static V lam_3318(V *env, V *args) {
  (void)env; (void)args;
  V local2730_3317 = args[0];
  return d_Big_dis_ueq(d_Big_dof_unat(list_length(d_Get_dTerm_dLeg_dl_ubinders(local2730_3317))), d_Big_dzero());
}
static Str S_66 = {TAG_STR, 27, {(const uint8_t *)"a diagram leg binds nothing"}};
static V lam_3322(V *env, V *args) {
  (void)env; (void)args;
  V local2728_3321 = args[0];
  return ap2(d_Get_dRules_dOps_do_uinfer_uuniv(env[0]), env[1], d_Get_dTerm_dLeg_dl_ubody(local2728_3321));
}
static Str S_67 = {TAG_STR, 53, {(const uint8_t *)"an injection needs a left former as its expected type"}};
static Str S_68 = {TAG_STR, 34, {(const uint8_t *)"an injection takes the leg address"}};
static Str S_69 = {TAG_STR, 32, {(const uint8_t *)"an injection carries one payload"}};
static V w_Quantity_dminimum(V *env, V *args) {
  (void)env; (void)args;
  return d_Quantity_dminimum(args[0], args[1]);
}
static V lam_3417(V *env, V *args) {
  (void)env; (void)args;
  V local2851_3411 = args[0];
  return ({ V _r = 0; V m_3412 = d_Get_dQuantity_dUsage_dpaths(env[0]); if (((m_3412) == NONE)) {  _r = ({ V __3413 = UNIT; SOME(local2851_3411); }); } else if (((m_3412) != NONE)) { V _m_3412_a0_3414 = FLD(m_3412, 0); _r = ({ V value_3415 = _m_3412_a0_3414; ({ V local2853_3416 = value_3415; SOME(d_Quantity_dcombine(clo_new(w_Quantity_dminimum, 2, 0), clo_new(w_Quantity_dmaximum, 2, 0), local2851_3411, local2853_3416)); }); }); } else rt_panic("match: no case at kernel:2372"); _r; });
}
static V lam_3449(V *env, V *args) {
  (void)env; (void)args;
  V local2880_3432 = args[0];
  return ({ V scrut2881_3433 = local2880_3432; ({ V _r = 0; V m_3434 = scrut2881_3433; if ((tag_of(m_3434) == 0)) { V _m_3434_a0_3435 = FLD(m_3434, 0); V _m_3434_a1_3436 = FLD(m_3434, 1); _r = ({ V p2882_3437 = _m_3434_a0_3435; ({ V p2883_3438 = _m_3434_a1_3436; ({ V _r = 0; V m_3439 = d_Term_das_ualeg(p2882_3437); if (((m_3439) == NONE)) {  _r = ({ V __3440 = UNIT; ((((V)maybe_is_some(SOME(env[0])))) ^ 1u); }); } else if (((m_3439) != NONE)) { V _m_3439_a0_3441 = FLD(m_3439, 0); _r = ({ V x_3442 = _m_3439_a0_3441; ({ V _r = 0; V m_3443 = SOME(env[0]); if (((m_3443) == NONE)) {  _r = ({ V __3444 = UNIT; FALSE_V; }); } else if (((m_3443) != NONE)) { V _m_3443_a0_3445 = FLD(m_3443, 0); _r = ({ V y_3446 = _m_3443_a0_3445; ({ V arg2884_3447 = x_3442; ({ V arg2885_3448 = y_3446; d_Big_dis_ueq(arg2884_3447, arg2885_3448); }); }); }); } else rt_panic("match: no case at kernel:2381"); _r; }); }); } else rt_panic("match: no case at kernel:2381"); _r; }); }); }); } else rt_panic("match: no case at kernel:2381"); _r; }); });
}
static Str S_70 = {TAG_STR, 17, {(const uint8_t *)"no branch at leg "}};
static Str S_71 = {TAG_STR, 34, {(const uint8_t *)"each branch binds its payload once"}};
static Str S_72 = {TAG_STR, 13, {(const uint8_t *)"the case has "}};
static Str S_73 = {TAG_STR, 27, {(const uint8_t *)" branches and the type has "}};
static Str S_74 = {TAG_STR, 5, {(const uint8_t *)" legs"}};
static V lam_3525(V *env, V *args) {
  (void)env; (void)args;
  V local2858_3524 = args[0];
  return d_Rules_dcoll_ubranch(env[0], env[1], env[2], env[3], env[4], env[5], env[6], local2858_3524);
}
static V lam_3527(V *env, V *args) {
  (void)env; (void)args;
  V local2891_3526 = args[0];
  return local2891_3526;
}
static V w_Quantity_dalternative(V *env, V *args) {
  (void)env; (void)args;
  return d_Quantity_dalternative(args[0], args[1]);
}
static Str S_75 = {TAG_STR, 49, {(const uint8_t *)"a tuple needs a right former as its expected type"}};
static Str S_76 = {TAG_STR, 41, {(const uint8_t *)"the tuple width and the type width differ"}};
static V lam_3616(V *env, V *args) {
  (void)env; (void)args;
  V local2917_3607 = args[0];
  return ({ V scrut2918_3608 = local2917_3607; ({ V _r = 0; V m_3609 = scrut2918_3608; if ((tag_of(m_3609) == 0)) { V _m_3609_a0_3610 = FLD(m_3609, 0); V _m_3609_a1_3611 = FLD(m_3609, 1); _r = ({ V p2919_3612 = _m_3609_a0_3610; ({ V p2920_3613 = _m_3609_a1_3611; ({ V t_3614 = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(env[0]), env[1]), d_Get_dValue_dVleg_dvl_uclo(p2920_3613), NIL); V _r; if (tag_of(t_3614) == 0) _r = t_3614; else { V bound2922_3615 = FLD(t_3614, 0); _r = apn(d_Get_dRules_dOps_do_ucheck(env[0]), 4, (V[]){env[1], env[2], d_Get_dTerm_dLeg_dl_ubody(p2919_3612), bound2922_3615}); } _r; }); }); }); } else rt_panic("match: no case at kernel:2427"); _r; }); });
}
static V w_Quantity_dsequence(V *env, V *args) {
  (void)env; (void)args;
  return d_Quantity_dsequence(args[0], args[1]);
}
static Str S_77 = {TAG_STR, 34, {(const uint8_t *)"a projection takes the leg address"}};
static Str S_78 = {TAG_STR, 33, {(const uint8_t *)"a projection needs a right former"}};
static V lam_3701(V *env, V *args) {
  (void)env; (void)args;
  V local2995_3694 = args[0];
  return ({ V _r = 0; V m_3695 = d_Rules_dopen_uclosure(env[0], d_Get_dValue_dVleg_dvl_uclo(local2995_3694), NIL); switch (tag_of(m_3695)) { case 1: { V _m_3695_a0_3696 = FLD(m_3695, 0); _r = ({ V item2999_3697 = _m_3695_a0_3696; DONE(({ V local2998_3698 = item2999_3697; SOME(local2998_3698); })); }); break; } case 0: { V _m_3695_a0_3699 = FLD(m_3695, 0); _r = ({ V item3000_3700 = _m_3695_a0_3699; FAIL(item3000_3700); }); break; } default: rt_panic("match: no case at kernel:2452"); } _r; });
}
static V lam_3702(V *env, V *args) {
  (void)env; (void)args;
  V local2989_3687 = args[0];
  return ({ V scrut2990_3688 = local2989_3687; ({ V _r = 0; V m_3689 = scrut2990_3688; if ((tag_of(m_3689) == 0)) { V _m_3689_a0_3690 = FLD(m_3689, 0); V _m_3689_a1_3691 = FLD(m_3689, 1); _r = ({ V p2991_3692 = _m_3689_a0_3690; ({ V p2992_3693 = _m_3689_a1_3691; d_Rules_dlet_u(d_Rules_dat(env[0], p2992_3693), ({ V _c = clo_new(lam_3701, 1, 1); CLO_ENV(_c)[0] = env[1]; _c; })); }); }); } else rt_panic("match: no case at kernel:2452"); _r; }); });
}
static V lam_3703(V *env, V *args) {
  (void)env; (void)args;
  V local2986_3686 = args[0];
  return d_Rules_dlet_u(d_Value_das_usec(env[0]), ({ V _c = clo_new(lam_3702, 1, 2); CLO_ENV(_c)[0] = local2986_3686; CLO_ENV(_c)[1] = env[1]; _c; }));
}
static V lam_3739(V *env, V *args) {
  (void)env; (void)args;
  V local3017_3722 = args[0];
  return ({ V scrut3018_3723 = local3017_3722; ({ V _r = 0; V m_3724 = scrut3018_3723; if ((tag_of(m_3724) == 0)) { V _m_3724_a0_3725 = FLD(m_3724, 0); V _m_3724_a1_3726 = FLD(m_3724, 1); _r = ({ V p3019_3727 = _m_3724_a0_3725; ({ V p3020_3728 = _m_3724_a1_3726; ({ V _r = 0; V m_3729 = d_Term_das_ualeg(p3019_3727); if (((m_3729) == NONE)) {  _r = ({ V __3730 = UNIT; ((((V)maybe_is_some(SOME(env[0])))) ^ 1u); }); } else if (((m_3729) != NONE)) { V _m_3729_a0_3731 = FLD(m_3729, 0); _r = ({ V x_3732 = _m_3729_a0_3731; ({ V _r = 0; V m_3733 = SOME(env[0]); if (((m_3733) == NONE)) {  _r = ({ V __3734 = UNIT; FALSE_V; }); } else if (((m_3733) != NONE)) { V _m_3733_a0_3735 = FLD(m_3733, 0); _r = ({ V y_3736 = _m_3733_a0_3735; ({ V arg3021_3737 = x_3732; ({ V arg3022_3738 = y_3736; d_Big_dis_ueq(arg3021_3737, arg3022_3738); }); }); }); } else rt_panic("match: no case at kernel:2454"); _r; }); }); } else rt_panic("match: no case at kernel:2454"); _r; }); }); }); } else rt_panic("match: no case at kernel:2454"); _r; }); });
}
static V lam_3753(V *env, V *args) {
  (void)env; (void)args;
  V local3024_3740 = args[0];
  return ({ V scrut3025_3741 = local3024_3740; ({ V _r = 0; V m_3742 = scrut3025_3741; if ((tag_of(m_3742) == 0)) { V _m_3742_a0_3743 = FLD(m_3742, 0); V _m_3742_a1_3744 = FLD(m_3742, 1); _r = ({ V p3026_3745 = _m_3742_a0_3743; ({ V p3027_3746 = _m_3742_a1_3744; ({ V _r = 0; V m_3747 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[0]), list_reverse_go(env[1], env[2]), d_Get_dTerm_dLeg_dl_ubody(p3027_3746)); switch (tag_of(m_3747)) { case 1: { V _m_3747_a0_3748 = FLD(m_3747, 0); _r = ({ V item3031_3749 = _m_3747_a0_3748; DONE(({ V local3030_3750 = item3031_3749; SOME(local3030_3750); })); }); break; } case 0: { V _m_3747_a0_3751 = FLD(m_3747, 0); _r = ({ V item3032_3752 = _m_3747_a0_3751; FAIL(item3032_3752); }); break; } default: rt_panic("match: no case at kernel:2455"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2455"); _r; }); });
}
static V lam_3754(V *env, V *args) {
  (void)env; (void)args;
  V local3014_3721 = args[0];
  return d_Rules_dlet_u(d_SeqList_dfind(({ V _c = clo_new(lam_3739, 1, 1); CLO_ENV(_c)[0] = local3014_3721; _c; }), env[0]), ({ V _c = clo_new(lam_3753, 1, 3); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; _c; }));
}
static V lam_3755(V *env, V *args) {
  (void)env; (void)args;
  V local3007_3712 = args[0];
  return ({ V scrut3008_3713 = local3007_3712; ({ V _r = 0; V m_3714 = scrut3008_3713; if ((tag_of(m_3714) == 0)) { V _m_3714_a0_3715 = FLD(m_3714, 0); V _m_3714_a1_3716 = FLD(m_3714, 1); V _m_3714_a2_3717 = FLD(m_3714, 2); _r = ({ V p3009_3718 = _m_3714_a0_3715; ({ V p3010_3719 = _m_3714_a1_3716; ({ V p3011_3720 = _m_3714_a2_3717; d_Rules_dlet_u(d_Value_das_uleg(p3010_3719), ({ V _c = clo_new(lam_3754, 1, 4); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; CLO_ENV(_c)[2] = p3011_3720; CLO_ENV(_c)[3] = env[2]; _c; })); }); }); }); } else rt_panic("match: no case at kernel:2453"); _r; }); });
}
static V w_Rules_dcoll_ubeta(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_ubeta(args[0], args[1]);
}
static V lam_3808(V *env, V *args) {
  (void)env; (void)args;
  V local3056_3798 = args[0];
  V local3058_3799 = args[1];
  return ({ V t_3800 = local3056_3798; V _r; if (tag_of(t_3800) == 0) _r = t_3800; else { V bound3060_3801 = FLD(t_3800, 0); _r = ((bound3060_3801) != FALSE_V ? ({ V t_3802 = d_Rules_dcoll_uleg_uty(env[0], env[1], env[2], local3058_3799); V _r; if (tag_of(t_3802) == 0) _r = t_3802; else { V bound3062_3803 = FLD(t_3802, 0); _r = ({ V t_3804 = d_Rules_dout_uwith(clo_new(w_Rules_dcoll_ubeta, 2, 0), env[3], env[4], rt_ctor1(1, local3058_3799), env[5]); V _r; if (tag_of(t_3804) == 0) _r = t_3804; else { V bound3064_3805 = FLD(t_3804, 0); _r = ({ V t_3806 = d_Rules_dout_uwith(clo_new(w_Rules_dcoll_ubeta, 2, 0), env[3], env[4], rt_ctor1(1, local3058_3799), env[6]); V _r; if (tag_of(t_3806) == 0) _r = t_3806; else { V bound3066_3807 = FLD(t_3806, 0); _r = apn(d_Get_dRules_dOps_do_uconv(env[0]), 4, (V[]){env[1], bound3062_3803, bound3064_3805, bound3066_3807}); } _r; }); } _r; }); } _r; }) : DONE(FALSE_V)); } _r; });
}
static V lam_3810(V *env, V *args) {
  (void)env; (void)args;
  V local3069_3809 = args[0];
  return local3069_3809;
}
static V w_Rules_dcoll_ulevels(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_ulevels(args[0], args[1], args[2], args[3], args[4]);
}
static V w_Rules_dcoll_uintro_uin(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_uintro_uin(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
}
static V w_Rules_dcoll_uelim_uelim(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_uelim_uelim(args[0], args[1], args[2], args[3], args[4]);
}
static V w_Rules_dcoll_uintro_usec(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_uintro_usec(args[0], args[1], args[2], args[3], args[4], args[5]);
}
static V w_Rules_dcoll_uelim_uout(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_uelim_uout(args[0], args[1], args[2], args[3], args[4], args[5]);
}
static V w_Rules_dcoll_udiagram_uarity(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_udiagram_uarity(args[0]);
}
static V w_Rules_dcoll_uspine_uty(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_uspine_uty(args[0], args[1], args[2], args[3], args[4]);
}
static V w_Rules_dcoll_ueta_uran(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_ueta_uran(args[0], args[1], args[2], args[3], args[4], args[5]);
}
static V w_Rules_dcoll_uconv_udiagram(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_uconv_udiagram(args[0], args[1], args[2], args[3], args[4]);
}
static V w_Rules_dcoll_uann_ulvl_ueq(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_uann_ulvl_ueq(args[0], args[1], args[2]);
}
static V w_Rules_dcoll_ulvl(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dcoll_ulvl(args[0]);
}
static V lam_3836(V *env, V *args) {
  (void)env; (void)args;
  V local3089_3832 = args[0];
  V local3091_3833 = args[1];
  V local3093_3834 = args[2];
  V local3095_3835 = args[3];
  return d_Rules_dpayload_ulvl(clo_new(w_Rules_dcoll_ulvl, 1, 0), local3089_3832, local3091_3833, local3093_3834, local3095_3835);
}
static V lam_3841(V *env, V *args) {
  (void)env; (void)args;
  V local3101_3837 = args[0];
  V local3103_3838 = args[1];
  V local3105_3839 = args[2];
  V local3107_3840 = args[3];
  return d_Rules_dpayload_ulvl(clo_new(w_Rules_dcoll_ulvl, 1, 0), local3101_3837, local3103_3838, local3105_3839, local3107_3840);
}
static Str S_79 = {TAG_STR, 7, {(const uint8_t *)" takes "}};
static Str S_80 = {TAG_STR, 30, {(const uint8_t *)" arguments and the term gives "}};
static V lam_3885(V *env, V *args) {
  (void)env; (void)args;
  V local3134_3857 = args[0];
  V local3136_3858 = args[1];
  return ({ V scrut3137_3859 = local3136_3858; ({ V _r = 0; V m_3860 = scrut3137_3859; if ((tag_of(m_3860) == 0)) { V _m_3860_a0_3861 = FLD(m_3860, 0); V _m_3860_a1_3862 = FLD(m_3860, 1); _r = ({ V p3138_3863 = _m_3860_a0_3861; ({ V p3139_3864 = _m_3860_a1_3862; ({ V _r = 0; V m_3865 = p3138_3863; if ((tag_of(m_3865) == 0)) { V _m_3865_a0_3866 = FLD(m_3865, 0); V _m_3865_a1_3867 = FLD(m_3865, 1); V _m_3865_a2_3868 = FLD(m_3865, 2); _r = ({ V p3140_3869 = _m_3865_a0_3866; ({ V p3141_3870 = _m_3865_a1_3867; ({ V p3142_3871 = _m_3865_a2_3868; ({ V t_3872 = local3134_3857; V _r; if (tag_of(t_3872) == 0) _r = t_3872; else { V bound3144_3873 = FLD(t_3872, 0); _r = ({ V _r = 0; V m_3874 = bound3144_3873; if ((tag_of(m_3874) == 0)) { V _m_3874_a0_3875 = FLD(m_3874, 0); V _m_3874_a1_3876 = FLD(m_3874, 1); _r = ({ V p3145_3877 = _m_3874_a0_3875; ({ V p3146_3878 = _m_3874_a1_3876; ({ V t_3879 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[0]), p3145_3877, p3142_3871); V _r; if (tag_of(t_3879) == 0) _r = t_3879; else { V bound3148_3880 = FLD(t_3879, 0); _r = ({ V t_3881 = apn(d_Get_dRules_dOps_do_ucheck(env[1]), 4, (V[]){env[2], d_Quantity_dmul(env[3], p3140_3869), p3139_3864, bound3148_3880}); V _r; if (tag_of(t_3881) == 0) _r = t_3881; else { V bound3150_3882 = FLD(t_3881, 0); _r = ({ V t_3883 = ap2(d_Get_dRules_dOps_do_ueval(env[1]), env[2], p3139_3864); V _r; if (tag_of(t_3883) == 0) _r = t_3883; else { V bound3152_3884 = FLD(t_3883, 0); _r = DONE(rt_ctor2(0, CON(bound3152_3884, p3145_3877), d_Quantity_dsequence(p3146_3878, bound3150_3882))); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2499"); _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2497"); _r; }); }); }); } else rt_panic("match: no case at kernel:2497"); _r; }); });
}
static V lam_3917(V *env, V *args) {
  (void)env; (void)args;
  V local3171_3916 = args[0];
  return d_Get_dTerm_dLeg_dl_ubody(local3171_3916);
}
static Str S_81 = {TAG_STR, 50, {(const uint8_t *)"a family that is not strictly positive is deferred"}};
static Str S_82 = {TAG_STR, 11, {(const uint8_t *)"the family "}};
static Str S_83 = {TAG_STR, 16, {(const uint8_t *)" is not declared"}};
static Str S_84 = {TAG_STR, 15, {(const uint8_t *)"the indices of "}};
static Str S_85 = {TAG_STR, 40, {(const uint8_t *)"a right former at a mu shape is deferred"}};
static Str S_86 = {TAG_STR, 7, {(const uint8_t *)" gives "}};
static Str S_87 = {TAG_STR, 20, {(const uint8_t *)" result indices and "}};
static Str S_88 = {TAG_STR, 16, {(const uint8_t *)"the constructor "}};
static Str S_89 = {TAG_STR, 4, {(const uint8_t *)" of "}};
static Str S_90 = {TAG_STR, 17, {(const uint8_t *)" gives the index "}};
static Str S_91 = {TAG_STR, 23, {(const uint8_t *)" and the type asks for "}};
static V lam_4015(V *env, V *args) {
  (void)env; (void)args;
  V local3236_4001 = args[0];
  V local3238_4002 = args[1];
  return ({ V scrut3239_4003 = local3238_4002; ({ V _r = 0; V m_4004 = scrut3239_4003; if ((tag_of(m_4004) == 0)) { V _m_4004_a0_4005 = FLD(m_4004, 0); V _m_4004_a1_4006 = FLD(m_4004, 1); _r = ({ V p3240_4007 = _m_4004_a0_4005; ({ V p3241_4008 = _m_4004_a1_4006; ({ V t_4009 = local3236_4001; V _r; if (tag_of(t_4009) == 0) _r = t_4009; else { V bound3243_4010 = FLD(t_4009, 0); _r = ({ V t_4011 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[0]), env[1], p3240_4007); V _r; if (tag_of(t_4011) == 0) _r = t_4011; else { V bound3245_4012 = FLD(t_4011, 0); _r = ({ V t_4013 = ap3(d_Get_dRules_dOps_do_uconv_utype(env[2]), env[3], bound3245_4012, p3241_4008); V _r; if (tag_of(t_4013) == 0) _r = t_4013; else { V bound3247_4014 = FLD(t_4013, 0); _r = ((bound3247_4014) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, str_concat(CON(((V)&S_88), CON(d_Get_dPositivity_dCtor_dc_uname(env[4]), CON(((V)&S_89), CON(env[5], CON(((V)&S_90), CON(ap2(d_Get_dRules_dOps_do_upp(env[2]), env[3], bound3245_4012), CON(((V)&S_91), CON(ap2(d_Get_dRules_dOps_do_upp(env[2]), env[3], p3241_4008), NIL)))))))))))); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2546"); _r; }); });
}
static V lam_4024(V *env, V *args) {
  (void)env; (void)args;
  V local3258_4023 = args[0];
  return d_Rules_dopen_uclosure(env[0], d_Get_dValue_dVleg_dvl_uclo(local3258_4023), NIL);
}
static Str S_92 = {TAG_STR, 33, {(const uint8_t *)"a constructor needs a left former"}};
static Str S_93 = {TAG_STR, 41, {(const uint8_t *)"a constructor takes a constructor address"}};
static Str S_94 = {TAG_STR, 25, {(const uint8_t *)" is not a constructor of "}};
static V lam_4137(V *env, V *args) {
  (void)env; (void)args;
  V local3382_4120 = args[0];
  return ({ V scrut3383_4121 = local3382_4120; ({ V _r = 0; V m_4122 = scrut3383_4121; if ((tag_of(m_4122) == 0)) { V _m_4122_a0_4123 = FLD(m_4122, 0); V _m_4122_a1_4124 = FLD(m_4122, 1); _r = ({ V p3384_4125 = _m_4122_a0_4123; ({ V p3385_4126 = _m_4122_a1_4124; ({ V _r = 0; V m_4127 = d_Term_das_uactor(p3384_4125); if (((m_4127) == NONE)) {  _r = ({ V __4128 = UNIT; ((((V)maybe_is_some(SOME(env[0])))) ^ 1u); }); } else if (((m_4127) != NONE)) { V _m_4127_a0_4129 = FLD(m_4127, 0); _r = ({ V x_4130 = _m_4127_a0_4129; ({ V _r = 0; V m_4131 = SOME(env[0]); if (((m_4131) == NONE)) {  _r = ({ V __4132 = UNIT; FALSE_V; }); } else if (((m_4131) != NONE)) { V _m_4131_a0_4133 = FLD(m_4131, 0); _r = ({ V y_4134 = _m_4131_a0_4133; ({ V arg3386_4135 = x_4130; ({ V arg3387_4136 = y_4134; d_NativeString_dequal(arg3386_4135, arg3387_4136); }); }); }); } else rt_panic("match: no case at kernel:2588"); _r; }); }); } else rt_panic("match: no case at kernel:2588"); _r; }); }); }); } else rt_panic("match: no case at kernel:2588"); _r; }); });
}
static Str S_95 = {TAG_STR, 19, {(const uint8_t *)"the elimination of "}};
static Str S_96 = {TAG_STR, 18, {(const uint8_t *)" has no branch at "}};
static Str S_97 = {TAG_STR, 14, {(const uint8_t *)"the branch at "}};
static Str S_98 = {TAG_STR, 7, {(const uint8_t *)" binds "}};
static Str S_99 = {TAG_STR, 12, {(const uint8_t *)" fields and "}};
static Str S_100 = {TAG_STR, 5, {(const uint8_t *)"field"}};
static V lam_4205(V *env, V *args) {
  (void)env; (void)args;
  V local3326_4157 = args[0];
  V local3328_4158 = args[1];
  return ({ V scrut3329_4159 = local3328_4158; ({ V _r = 0; V m_4160 = scrut3329_4159; if ((tag_of(m_4160) == 0)) { V _m_4160_a0_4161 = FLD(m_4160, 0); V _m_4160_a1_4162 = FLD(m_4160, 1); _r = ({ V p3330_4163 = _m_4160_a0_4161; ({ V p3331_4164 = _m_4160_a1_4162; ({ V _r = 0; V m_4165 = p3330_4163; if ((tag_of(m_4165) == 0)) { V _m_4165_a0_4166 = FLD(m_4165, 0); V _m_4165_a1_4167 = FLD(m_4165, 1); V _m_4165_a2_4168 = FLD(m_4165, 2); _r = ({ V p3332_4169 = _m_4165_a0_4166; ({ V p3333_4170 = _m_4165_a1_4167; ({ V p3334_4171 = _m_4165_a2_4168; ({ V _r = 0; V m_4172 = p3331_4164; if ((tag_of(m_4172) == 0)) { V _m_4172_a0_4173 = FLD(m_4172, 0); V _m_4172_a1_4174 = FLD(m_4172, 1); _r = ({ V p3335_4175 = _m_4172_a0_4173; ({ V p3336_4176 = _m_4172_a1_4174; ({ V _r = 0; V m_4177 = local3326_4157; switch (tag_of(m_4177)) { case 1: { V _m_4177_a0_4178 = FLD(m_4177, 0); _r = ({ V item3356_4179 = _m_4177_a0_4178; ({ V local3339_4180 = item3356_4179; ({ V scrut3340_4181 = local3339_4180; ({ V _r = 0; V m_4182 = scrut3340_4181; if ((tag_of(m_4182) == 0)) { V _m_4182_a0_4183 = FLD(m_4182, 0); V _m_4182_a1_4184 = FLD(m_4182, 1); V _m_4182_a2_4185 = FLD(m_4182, 2); _r = ({ V p3341_4186 = _m_4182_a0_4183; ({ V p3342_4187 = _m_4182_a1_4184; ({ V p3343_4188 = _m_4182_a2_4185; ({ V _r = 0; V m_4189 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[0]), p3342_4187, p3334_4171); switch (tag_of(m_4189)) { case 1: { V _m_4189_a0_4190 = FLD(m_4189, 0); _r = ({ V item3354_4191 = _m_4189_a0_4190; ({ V local3346_4192 = item3354_4191; ({ V scrut3347_4193 = d_Value_dvar(ap(d_Get_dRules_dOps_do_usize(env[1]), p3341_4186)); ({ V _r = 0; V m_4194 = d_Rules_dbinder_uquantity(((V)&S_52), ((V)&S_100), p3336_4176, p3335_4175, p3332_4169); switch (tag_of(m_4194)) { case 1: { V _m_4194_a0_4195 = FLD(m_4194, 0); _r = ({ V item3352_4196 = _m_4194_a0_4195; ({ V local3350_4197 = item3352_4196; ({ V scrut3351_4198 = local3350_4197; DONE(rt_ctor3(0, apn(d_Get_dRules_dOps_do_ubind(env[1]), 4, (V[]){p3336_4176, p3332_4169, local3346_4192, p3341_4186}), CON(scrut3347_4193, p3342_4187), CON(scrut3347_4193, p3343_4188))); }); }); }); break; } case 0: { V _m_4194_a0_4199 = FLD(m_4194, 0); _r = ({ V item3353_4200 = _m_4194_a0_4199; FAIL(item3353_4200); }); break; } default: rt_panic("match: no case at kernel:2595"); } _r; }); }); }); }); break; } case 0: { V _m_4189_a0_4201 = FLD(m_4189, 0); _r = ({ V item3355_4202 = _m_4189_a0_4201; FAIL(item3355_4202); }); break; } default: rt_panic("match: no case at kernel:2594"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2594"); _r; }); }); }); }); break; } case 0: { V _m_4177_a0_4203 = FLD(m_4177, 0); _r = ({ V item3357_4204 = _m_4177_a0_4203; FAIL(item3357_4204); }); break; } default: rt_panic("match: no case at kernel:2593"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2593"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2593"); _r; }); }); }); } else rt_panic("match: no case at kernel:2593"); _r; }); });
}
static V lam_4219(V *env, V *args) {
  (void)env; (void)args;
  V local3373_4218 = args[0];
  return ap2(d_Get_dRules_dEvaluator_dev_ueval(env[0]), env[1], local3373_4218);
}
static V lam_4231(V *env, V *args) {
  (void)env; (void)args;
  V local3422_4230 = args[0];
  return d_NativeString_dequal(env[0], local3422_4230);
}
static V lam_4243(V *env, V *args) {
  (void)env; (void)args;
  V local3396_4236 = args[0];
  return ({ V scrut3397_4237 = local3396_4236; ({ V _r = 0; V m_4238 = scrut3397_4237; if ((tag_of(m_4238) == 0)) { V _m_4238_a0_4239 = FLD(m_4238, 0); V _m_4238_a1_4240 = FLD(m_4238, 1); _r = ({ V p3398_4241 = _m_4238_a0_4239; ({ V p3399_4242 = _m_4238_a1_4240; d_Term_das_uactor(p3398_4241); }); }); } else rt_panic("match: no case at kernel:2610"); _r; }); });
}
static Str S_101 = {TAG_STR, 12, {(const uint8_t *)"a branch of "}};
static Str S_102 = {TAG_STR, 30, {(const uint8_t *)" takes the constructor address"}};
static Str S_103 = {TAG_STR, 23, {(const uint8_t *)" repeats the branch at "}};
static V lam_4253(V *env, V *args) {
  (void)env; (void)args;
  V local3415_4247 = args[0];
  V local3417_4248 = args[1];
  return ({ V t_4249 = local3415_4247; V _r; if (tag_of(t_4249) == 0) _r = t_4249; else { V bound3419_4250 = FLD(t_4249, 0); _r = ({ V scrut3423_4251 = d_Rules_dmu_ucount(local3417_4248, env[0]); ({ V scrut3424_4252 = UNIT; ((d_Big_dis_ueq(scrut3423_4251, d_Big_done())) != FALSE_V ? DONE(UNIT) : ((d_Big_dis_ueq(scrut3423_4251, d_Big_dzero())) != FALSE_V ? FAIL(rt_ctor1(8, str_concat(CON(((V)&S_95), CON(env[1], CON(((V)&S_96), CON(local3417_4248, NIL))))))) : FAIL(rt_ctor1(7, str_concat(CON(((V)&S_95), CON(env[1], CON(((V)&S_103), CON(local3417_4248, NIL))))))))); }); }); } _r; });
}
static V lam_4260(V *env, V *args) {
  (void)env; (void)args;
  V local3413_4259 = args[0];
  return d_NativeString_dequal(env[0], local3413_4259);
}
static V lam_4261(V *env, V *args) {
  (void)env; (void)args;
  V local3406_4255 = args[0];
  V local3408_4256 = args[1];
  return ({ V t_4257 = local3406_4255; V _r; if (tag_of(t_4257) == 0) _r = t_4257; else { V bound3410_4258 = FLD(t_4257, 0); _r = ((d_SeqList_dexists(({ V _c = clo_new(lam_4260, 1, 1); CLO_ENV(_c)[0] = local3408_4256; _c; }), env[0])) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(3, str_append(local3408_4256, str_append(((V)&S_94), env[1]))))); } _r; });
}
static Str S_104 = {TAG_STR, 27, {(const uint8_t *)" is still under declaration"}};
static Str S_105 = {TAG_STR, 39, {(const uint8_t *)" is a kernel family and has no branches"}};
static V lam_4300(V *env, V *args) {
  (void)env; (void)args;
  V local3440_4291 = args[0];
  return ({ V scrut3441_4292 = local3440_4291; ({ V _r = 0; V m_4293 = scrut3441_4292; if ((tag_of(m_4293) == 0)) { V _m_4293_a0_4294 = FLD(m_4293, 0); V _m_4293_a1_4295 = FLD(m_4293, 1); V _m_4293_a2_4296 = FLD(m_4293, 2); _r = ({ V p3442_4297 = _m_4293_a0_4294; ({ V p3443_4298 = _m_4293_a1_4295; ({ V p3444_4299 = _m_4293_a2_4296; d_Quantity_dequal(p3442_4297, ((V)0)); }); }); }); } else rt_panic("match: no case at kernel:2630"); _r; }); });
}
static Str S_106 = {TAG_STR, 68, {(const uint8_t *)"a large elimination out of a proposition needs a subsingleton family"}};
static Str S_107 = {TAG_STR, 4, {(const uint8_t *)" at "}};
static Str S_108 = {TAG_STR, 14, {(const uint8_t *)"the motive of "}};
static Str S_109 = {TAG_STR, 26, {(const uint8_t *)" does not bind the indices"}};
static V lam_4362(V *env, V *args) {
  (void)env; (void)args;
  V local3452_4326 = args[0];
  V local3454_4327 = args[1];
  return ({ V scrut3455_4328 = local3454_4327; ({ V _r = 0; V m_4329 = scrut3455_4328; if ((tag_of(m_4329) == 0)) { V _m_4329_a0_4330 = FLD(m_4329, 0); V _m_4329_a1_4331 = FLD(m_4329, 1); _r = ({ V p3456_4332 = _m_4329_a0_4330; ({ V p3457_4333 = _m_4329_a1_4331; ({ V _r = 0; V m_4334 = p3456_4332; if ((tag_of(m_4334) == 0)) { V _m_4334_a0_4335 = FLD(m_4334, 0); V _m_4334_a1_4336 = FLD(m_4334, 1); V _m_4334_a2_4337 = FLD(m_4334, 2); _r = ({ V p3458_4338 = _m_4334_a0_4335; ({ V p3459_4339 = _m_4334_a1_4336; ({ V p3460_4340 = _m_4334_a2_4337; ({ V _r = 0; V m_4341 = local3452_4326; switch (tag_of(m_4341)) { case 1: { V _m_4341_a0_4342 = FLD(m_4341, 0); _r = ({ V item3474_4343 = _m_4341_a0_4342; ({ V local3463_4344 = item3474_4343; ({ V scrut3464_4345 = local3463_4344; ({ V _r = 0; V m_4346 = scrut3464_4345; if ((tag_of(m_4346) == 0)) { V _m_4346_a0_4347 = FLD(m_4346, 0); V _m_4346_a1_4348 = FLD(m_4346, 1); V _m_4346_a2_4349 = FLD(m_4346, 2); _r = ({ V p3465_4350 = _m_4346_a0_4347; ({ V p3466_4351 = _m_4346_a1_4348; ({ V p3467_4352 = _m_4346_a2_4349; ({ V _r = 0; V m_4353 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[0]), p3466_4351, p3460_4340); switch (tag_of(m_4353)) { case 1: { V _m_4353_a0_4354 = FLD(m_4353, 0); _r = ({ V item3472_4355 = _m_4353_a0_4354; ({ V local3470_4356 = item3472_4355; ({ V scrut3471_4357 = d_Value_dvar(ap(d_Get_dRules_dOps_do_usize(env[1]), p3465_4350)); DONE(rt_ctor3(0, apn(d_Get_dRules_dOps_do_ubind(env[1]), 4, (V[]){p3457_4333, ((V)0), local3470_4356, p3465_4350}), CON(scrut3471_4357, p3466_4351), CON(scrut3471_4357, p3467_4352))); }); }); }); break; } case 0: { V _m_4353_a0_4358 = FLD(m_4353, 0); _r = ({ V item3473_4359 = _m_4353_a0_4358; FAIL(item3473_4359); }); break; } default: rt_panic("match: no case at kernel:2645"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2645"); _r; }); }); }); }); break; } case 0: { V _m_4341_a0_4360 = FLD(m_4341, 0); _r = ({ V item3475_4361 = _m_4341_a0_4360; FAIL(item3475_4361); }); break; } default: rt_panic("match: no case at kernel:2644"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2644"); _r; }); }); }); } else rt_panic("match: no case at kernel:2644"); _r; }); });
}
static Str S_110 = {TAG_STR, 43, {(const uint8_t *)"an elimination at a mu shape needs a motive"}};
static Str S_111 = {TAG_STR, 32, {(const uint8_t *)"the motive of an elimination at "}};
static Str S_112 = {TAG_STR, 16, {(const uint8_t *)" names no family"}};
static Str S_113 = {TAG_STR, 24, {(const uint8_t *)"the motive is built for "}};
static Str S_114 = {TAG_STR, 25, {(const uint8_t *)" and the scrutinee is at "}};
static Str S_115 = {TAG_STR, 28, {(const uint8_t *)" indices and the family has "}};
static Str S_116 = {TAG_STR, 15, {(const uint8_t *)" is applied to "}};
static V lam_4453(V *env, V *args) {
  (void)env; (void)args;
  V local3314_4452 = args[0];
  return d_Rules_dmu_ubranch(env[0], env[1], env[2], env[3], env[4], env[5], env[6], d_Get_dTerm_dElim_de_ubranches(env[7]), local3314_4452);
}
static V lam_4516(V *env, V *args) {
  (void)env; (void)args;
  V local3558_4499 = args[0];
  return ({ V scrut3559_4500 = local3558_4499; ({ V _r = 0; V m_4501 = scrut3559_4500; if ((tag_of(m_4501) == 0)) { V _m_4501_a0_4502 = FLD(m_4501, 0); V _m_4501_a1_4503 = FLD(m_4501, 1); _r = ({ V p3560_4504 = _m_4501_a0_4502; ({ V p3561_4505 = _m_4501_a1_4503; ({ V _r = 0; V m_4506 = d_Term_das_uactor(p3560_4504); if (((m_4506) == NONE)) {  _r = ({ V __4507 = UNIT; ((((V)maybe_is_some(SOME(env[0])))) ^ 1u); }); } else if (((m_4506) != NONE)) { V _m_4506_a0_4508 = FLD(m_4506, 0); _r = ({ V x_4509 = _m_4506_a0_4508; ({ V _r = 0; V m_4510 = SOME(env[0]); if (((m_4510) == NONE)) {  _r = ({ V __4511 = UNIT; FALSE_V; }); } else if (((m_4510) != NONE)) { V _m_4510_a0_4512 = FLD(m_4510, 0); _r = ({ V y_4513 = _m_4510_a0_4512; ({ V arg3562_4514 = x_4509; ({ V arg3563_4515 = y_4513; d_NativeString_dequal(arg3562_4514, arg3563_4515); }); }); }); } else rt_panic("match: no case at kernel:2693"); _r; }); }); } else rt_panic("match: no case at kernel:2693"); _r; }); }); }); } else rt_panic("match: no case at kernel:2693"); _r; }); });
}
static V lam_4530(V *env, V *args) {
  (void)env; (void)args;
  V local3565_4517 = args[0];
  return ({ V scrut3566_4518 = local3565_4517; ({ V _r = 0; V m_4519 = scrut3566_4518; if ((tag_of(m_4519) == 0)) { V _m_4519_a0_4520 = FLD(m_4519, 0); V _m_4519_a1_4521 = FLD(m_4519, 1); _r = ({ V p3567_4522 = _m_4519_a0_4520; ({ V p3568_4523 = _m_4519_a1_4521; ({ V _r = 0; V m_4524 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[0]), list_reverse_go(env[1], env[2]), d_Get_dTerm_dLeg_dl_ubody(p3568_4523)); switch (tag_of(m_4524)) { case 1: { V _m_4524_a0_4525 = FLD(m_4524, 0); _r = ({ V item3572_4526 = _m_4524_a0_4525; DONE(({ V local3571_4527 = item3572_4526; SOME(local3571_4527); })); }); break; } case 0: { V _m_4524_a0_4528 = FLD(m_4524, 0); _r = ({ V item3573_4529 = _m_4524_a0_4528; FAIL(item3573_4529); }); break; } default: rt_panic("match: no case at kernel:2694"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2694"); _r; }); });
}
static V lam_4531(V *env, V *args) {
  (void)env; (void)args;
  V local3555_4498 = args[0];
  return d_Rules_dlet_u(d_SeqList_dfind(({ V _c = clo_new(lam_4516, 1, 1); CLO_ENV(_c)[0] = local3555_4498; _c; }), env[0]), ({ V _c = clo_new(lam_4530, 1, 3); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; _c; }));
}
static V lam_4532(V *env, V *args) {
  (void)env; (void)args;
  V local3543_4489 = args[0];
  return ({ V scrut3544_4490 = local3543_4489; ({ V _r = 0; V m_4491 = scrut3544_4490; if ((tag_of(m_4491) == 0)) { V _m_4491_a0_4492 = FLD(m_4491, 0); V _m_4491_a1_4493 = FLD(m_4491, 1); V _m_4491_a2_4494 = FLD(m_4491, 2); _r = ({ V p3545_4495 = _m_4491_a0_4492; ({ V p3546_4496 = _m_4491_a1_4493; ({ V p3547_4497 = _m_4491_a2_4494; d_Rules_dlet_u(d_Value_das_uctor(p3546_4496), ({ V _c = clo_new(lam_4531, 1, 4); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; CLO_ENV(_c)[2] = p3547_4497; CLO_ENV(_c)[3] = env[2]; _c; })); }); }); }); } else rt_panic("match: no case at kernel:2692"); _r; }); });
}
static V w_Rules_dmu_uform_ulan(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dmu_uform_ulan(args[0], args[1], args[2], args[3], args[4]);
}
static V lam_4581(V *env, V *args) {
  (void)env; (void)args;
  V local3197_4576 = args[0];
  V local3199_4577 = args[1];
  V local3201_4578 = args[2];
  V local3203_4579 = args[3];
  V local3205_4580 = args[4];
  return FAIL(rt_ctor1(0, d_Rules_dmu_uran_uword()));
}
static V w_Rules_dmu_uintro_uin(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dmu_uintro_uin(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
}
static V w_Rules_dmu_uelim_uelim(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dmu_uelim_uelim(args[0], args[1], args[2], args[3], args[4]);
}
static V lam_4588(V *env, V *args) {
  (void)env; (void)args;
  V local3510_4582 = args[0];
  V local3512_4583 = args[1];
  V local3514_4584 = args[2];
  V local3516_4585 = args[3];
  V local3518_4586 = args[4];
  V local3520_4587 = args[5];
  return FAIL(rt_ctor1(0, d_Rules_dmu_uran_uword()));
}
static V lam_4595(V *env, V *args) {
  (void)env; (void)args;
  V local3522_4589 = args[0];
  V local3524_4590 = args[1];
  V local3526_4591 = args[2];
  V local3528_4592 = args[3];
  V local3530_4593 = args[4];
  V local3532_4594 = args[5];
  return FAIL(rt_ctor1(0, d_Rules_dmu_uran_uword()));
}
static V w_Rules_dmu_ubeta(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dmu_ubeta(args[0], args[1]);
}
static V lam_4601(V *env, V *args) {
  (void)env; (void)args;
  V local3576_4596 = args[0];
  V local3578_4597 = args[1];
  V local3580_4598 = args[2];
  V local3582_4599 = args[3];
  V local3584_4600 = args[4];
  return DONE(NONE);
}
static V w_Rules_dmu_ulan_ulvl(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dmu_ulan_ulvl(args[0], args[1], args[2], args[3]);
}
static V lam_4606(V *env, V *args) {
  (void)env; (void)args;
  V local3595_4602 = args[0];
  V local3597_4603 = args[1];
  V local3599_4604 = args[2];
  V local3601_4605 = args[3];
  return FAIL(rt_ctor1(0, d_Rules_dmu_uran_uword()));
}
static V w_Rules_dmu_usubsingleton(V *env, V *args) {
  (void)env; (void)args;
  return d_Rules_dmu_usubsingleton(args[0], args[1], args[2]);
}
static V lam_4649(V *env, V *args) {
  (void)env; (void)args;
  V a_4647 = args[0];
  V b_4648 = args[1];
  return d_NativeString_dorder(a_4647, b_4648);
}
static V lam_4699(V *env, V *args) {
  (void)env; (void)args;
  V local3737_4690 = args[0];
  return ({ V scrut3738_4691 = local3737_4690; ({ V _r = 0; V m_4692 = scrut3738_4691; if ((tag_of(m_4692) == 0)) { V _m_4692_a0_4693 = FLD(m_4692, 0); V _m_4692_a1_4694 = FLD(m_4692, 1); V _m_4692_a2_4695 = FLD(m_4692, 2); _r = ({ V p3739_4696 = _m_4692_a0_4693; ({ V p3740_4697 = _m_4692_a1_4694; ({ V p3741_4698 = _m_4692_a2_4695; d_Value_das_uctor(p3740_4697); }); }); }); } else rt_panic("match: no case at kernel:2732"); _r; }); });
}
static V lam_4733(V *env, V *args) {
  (void)env; (void)args;
  V local3747_4719 = args[0];
  V local3749_4720 = args[1];
  return ({ V t_4721 = local3747_4719; V _r; if (tag_of(t_4721) == 0) _r = t_4721; else { V bound3751_4722 = FLD(t_4721, 0); _r = ({ V scrut3752_4723 = local3749_4720; ({ V _r = 0; V m_4724 = scrut3752_4723; switch (tag_of(m_4724)) { case 0: { V _m_4724_a0_4725 = FLD(m_4724, 0); V _m_4724_a1_4726 = FLD(m_4724, 1); _r = ({ V p3753_4727 = _m_4724_a0_4725; ({ V p3754_4728 = _m_4724_a1_4726; ({ V t_4729 = d_Rules_dout_uvalue(d_Eval_dev(env[0]), p3753_4727, p3754_4728, bound3751_4722); V _r; if (tag_of(t_4729) == 0) _r = t_4729; else { V bound3756_4730 = FLD(t_4729, 0); _r = d_Eval_dwhnf(env[0], bound3756_4730); } _r; }); }); }); break; } case 1: { V _m_4724_a0_4731 = FLD(m_4724, 0); _r = ({ V p3762_4732 = _m_4724_a0_4731; d_Rules_delim_uvalue(d_Eval_dev(env[0]), d_Get_dValue_dStuck_uelim_ds_ushape(p3762_4732), d_Get_dValue_dStuck_uelim_ds_uscrut_uq(p3762_4732), d_Get_dValue_dStuck_uelim_ds_umotive(p3762_4732), d_Get_dValue_dStuck_uelim_ds_ubranches(p3762_4732), d_Get_dValue_dStuck_uelim_ds_uenv(p3762_4732), bound3751_4722); }); break; } default: rt_panic("match: no case at kernel:2741"); } _r; }); }); } _r; });
}
static V lam_4824(V *env, V *args) {
  (void)env; (void)args;
  V local3811_4812 = args[0];
  return ({ V scrut3812_4813 = local3811_4812; ({ V _r = 0; V m_4814 = scrut3812_4813; if ((tag_of(m_4814) == 0)) { V _m_4814_a0_4815 = FLD(m_4814, 0); V _m_4814_a1_4816 = FLD(m_4814, 1); _r = ({ V p3813_4817 = _m_4814_a0_4815; ({ V p3814_4818 = _m_4814_a1_4816; ({ V _r = 0; V m_4819 = d_Value_das_ulit(p3814_4818); if (((m_4819) == NONE)) {  _r = ({ V __4820 = UNIT; NONE; }); } else if (((m_4819) != NONE)) { V _m_4819_a0_4821 = FLD(m_4819, 0); _r = ({ V item3834_4822 = _m_4819_a0_4821; SOME(({ V local3816_4823 = item3834_4822; CON(local3816_4823, env[0]); })); }); } else rt_panic("match: no case at kernel:2763"); _r; }); }); }); } else rt_panic("match: no case at kernel:2763"); _r; }); });
}
static V lam_4831(V *env, V *args) {
  (void)env; (void)args;
  V local3791_4796 = args[0];
  V local3793_4797 = args[1];
  return ({ V _r = 0; V m_4798 = local3791_4796; if (((m_4798) == NONE)) {  _r = ({ V __4799 = UNIT; NONE; }); } else if (((m_4798) != NONE)) { V _m_4798_a0_4800 = FLD(m_4798, 0); _r = ({ V item3837_4801 = _m_4798_a0_4800; ({ V local3795_4802 = item3837_4801; ({ V scrut3796_4803 = local3793_4797; ({ V _r = 0; V m_4804 = scrut3796_4803; switch (tag_of(m_4804)) { case 0: { V _m_4804_a0_4805 = FLD(m_4804, 0); V _m_4804_a1_4806 = FLD(m_4804, 1); _r = ({ V p3797_4807 = _m_4804_a0_4805; ({ V p3798_4808 = _m_4804_a1_4806; ({ V local3801_4809 = d_Value_das_upt(p3798_4808); ({ V local3805_4810 = local3801_4809; ({ V local3807_4811 = ({ V _c = clo_new(lam_4824, 1, 1); CLO_ENV(_c)[0] = local3795_4802; _c; }); ({ V _r = 0; V m_4825 = local3805_4810; if (((m_4825) == NONE)) {  _r = ({ V __4826 = UNIT; NONE; }); } else if (((m_4825) != NONE)) { V _m_4825_a0_4827 = FLD(m_4825, 0); _r = ({ V item3809_4828 = _m_4825_a0_4827; ap(local3807_4811, item3809_4828); }); } else rt_panic("match: no case at kernel:2762"); _r; }); }); }); }); }); }); break; } case 1: { V _m_4804_a0_4829 = FLD(m_4804, 0); _r = ({ V p3835_4830 = _m_4804_a0_4829; NONE; }); break; } default: rt_panic("match: no case at kernel:2762"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2761"); _r; });
}
static V lam_4868(V *env, V *args) {
  (void)env; (void)args;
  V local3859_4851 = args[0];
  return ({ V scrut3860_4852 = local3859_4851; ({ V _r = 0; V m_4853 = scrut3860_4852; if ((tag_of(m_4853) == 0)) { V _m_4853_a0_4854 = FLD(m_4853, 0); V _m_4853_a1_4855 = FLD(m_4853, 1); _r = ({ V p3861_4856 = _m_4853_a0_4854; ({ V p3862_4857 = _m_4853_a1_4855; ({ V _r = 0; V m_4858 = d_Prim_das_unat(p3861_4856); if (((m_4858) == NONE)) {  _r = ({ V __4859 = UNIT; NONE; }); } else if (((m_4858) != NONE)) { V _m_4858_a0_4860 = FLD(m_4858, 0); _r = ({ V item3873_4861 = _m_4858_a0_4860; ({ V local3867_4862 = item3873_4861; ({ V _r = 0; V m_4863 = d_Prim_das_unat(p3862_4857); if (((m_4863) == NONE)) {  _r = ({ V __4864 = UNIT; NONE; }); } else if (((m_4863) != NONE)) { V _m_4863_a0_4865 = FLD(m_4863, 0); _r = ({ V item3871_4866 = _m_4863_a0_4865; SOME(({ V local3869_4867 = item3871_4866; rt_ctor2(0, local3867_4862, local3869_4867); })); }); } else rt_panic("match: no case at kernel:2775"); _r; }); }); }); } else rt_panic("match: no case at kernel:2775"); _r; }); }); }); } else rt_panic("match: no case at kernel:2775"); _r; }); });
}
static V w_Bignum_dequal(V *env, V *args) {
  (void)env; (void)args;
  return d_Bignum_dequal(args[0], args[1]);
}
static V lam_4886(V *env, V *args) {
  (void)env; (void)args;
  V local3894_4884 = args[0];
  V local3896_4885 = args[1];
  return d_Big_dis_ult(d_Bignum_dcompare(local3894_4884, local3896_4885), d_Big_dzero());
}
static V w_Prim_dadd(V *env, V *args) {
  (void)env; (void)args;
  return d_Prim_dadd(args[0], args[1]);
}
static V w_Prim_dsub(V *env, V *args) {
  (void)env; (void)args;
  return d_Prim_dsub(args[0], args[1]);
}
static V w_Prim_dmul(V *env, V *args) {
  (void)env; (void)args;
  return d_Prim_dmul(args[0], args[1]);
}
static V lam_4952(V *env, V *args) {
  (void)env; (void)args;
  V local3886_4940 = args[0];
  return ({ V scrut3887_4941 = local3886_4940; ({ V _r = 0; V m_4942 = scrut3887_4941; if ((tag_of(m_4942) == 0)) { V _m_4942_a0_4943 = FLD(m_4942, 0); V _m_4942_a1_4944 = FLD(m_4942, 1); _r = ({ V p3888_4945 = _m_4942_a0_4943; ({ V p3889_4946 = _m_4942_a1_4944; ({ V _r = 0; V m_4947 = d_Prim_dcompare_uop(env[0]); if (((m_4947) == NONE)) {  _r = ({ V __4948 = UNIT; NONE; }); } else if (((m_4947) != NONE)) { V _m_4947_a0_4949 = FLD(m_4947, 0); _r = ({ V item3898_4950 = _m_4947_a0_4949; SOME(({ V local3891_4951 = item3898_4950; d_Rules_dbool_uvalue(ap2(local3891_4951, p3888_4945, p3889_4946)); })); }); } else rt_panic("match: no case at kernel:2809"); _r; }); }); }); } else rt_panic("match: no case at kernel:2809"); _r; }); });
}
static V w_Global_ddef_uof(V *env, V *args) {
  (void)env; (void)args;
  return d_Global_ddef_uof(args[0]);
}
static V lam_5038(V *env, V *args) {
  (void)env; (void)args;
  V local3696_5032 = args[0];
  return ((d_Get_dGlobal_dDef_uentry_dreducible(local3696_5032)) != FALSE_V ? ({ V _r = 0; V m_5033 = d_Get_dGlobal_dDef_uentry_drec_uarg(local3696_5032); if (((m_5033) == NONE)) {  _r = ({ V __5034 = UNIT; NONE; }); } else if (((m_5033) != NONE)) { V _m_5033_a0_5035 = FLD(m_5033, 0); _r = ({ V item3700_5036 = _m_5033_a0_5035; SOME(({ V local3698_5037 = item3700_5036; rt_ctor3(0, d_Get_dGlobal_dDef_uentry_ddef(local3696_5032), local3698_5037, list_reverse(env[0])); })); }); } else rt_panic("match: no case at kernel:2821"); _r; }) : NONE);
}
static V lam_5043(V *env, V *args) {
  (void)env; (void)args;
  V local3662_5009 = args[0];
  return ({ V scrut3663_5010 = local3662_5009; ({ V _r = 0; V m_5011 = scrut3663_5010; if ((tag_of(m_5011) == 0)) { V _m_5011_a0_5012 = FLD(m_5011, 0); V _m_5011_a1_5013 = FLD(m_5011, 1); _r = ({ V p3664_5014 = _m_5011_a0_5012; ({ V p3665_5015 = _m_5011_a1_5013; ({ V scrut3666_5016 = p3664_5014; ({ V _r = 0; V m_5017 = scrut3666_5016; switch (tag_of(m_5017)) { case 0: { V _m_5017_a0_5018 = FLD(m_5017, 0); _r = ({ V p3667_5019 = _m_5017_a0_5018; NONE; }); break; } case 1: { V _m_5017_a0_5020 = FLD(m_5017, 0); _r = ({ V p3668_5021 = _m_5017_a0_5020; ({ V local3686_5022 = ({ V local3671_5023 = d_Global_dfind(p3668_5021, env[0]); ({ V local3675_5024 = local3671_5023; ({ V local3677_5025 = clo_new(w_Global_ddef_uof, 1, 0); ({ V _r = 0; V m_5026 = local3675_5024; if (((m_5026) == NONE)) {  _r = ({ V __5027 = UNIT; NONE; }); } else if (((m_5026) != NONE)) { V _m_5026_a0_5028 = FLD(m_5026, 0); _r = ({ V item3679_5029 = _m_5026_a0_5028; ap(local3677_5025, item3679_5029); }); } else rt_panic("match: no case at kernel:2821"); _r; }); }); }); }); ({ V local3690_5030 = local3686_5022; ({ V local3692_5031 = ({ V _c = clo_new(lam_5038, 1, 1); CLO_ENV(_c)[0] = p3665_5015; _c; }); ({ V _r = 0; V m_5039 = local3690_5030; if (((m_5039) == NONE)) {  _r = ({ V __5040 = UNIT; NONE; }); } else if (((m_5039) != NONE)) { V _m_5039_a0_5041 = FLD(m_5039, 0); _r = ({ V item3694_5042 = _m_5039_a0_5041; ap(local3692_5031, item3694_5042); }); } else rt_panic("match: no case at kernel:2821"); _r; }); }); }); }); }); break; } default: rt_panic("match: no case at kernel:2821"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2820"); _r; }); });
}
static V w_Value_das_uuniv(V *env, V *args) {
  (void)env; (void)args;
  return d_Value_das_uuniv(args[0]);
}
static V lam_5124(V *env, V *args) {
  (void)env; (void)args;
  V local3947_5117 = args[0];
  return ({ V local3950_5118 = local3947_5117; ({ V _r = 0; V m_5119 = local3950_5118; if (((m_5119) == NONE)) {  _r = ({ V __5120 = UNIT; d_Eval_dlevel_uof_uann(env[0], env[1], env[2]); }); } else if (((m_5119) != NONE)) { V _m_5119_a0_5121 = FLD(m_5119, 0); _r = ({ V value_5122 = _m_5119_a0_5121; ({ V local3980_5123 = value_5122; SOME(local3980_5123); }); }); } else rt_panic("match: no case at kernel:2835"); _r; }); });
}
static V lam_5178(V *env, V *args) {
  (void)env; (void)args;
  V local4030_5171 = args[0];
  return ({ V local4033_5172 = d_Global_ddef_uof(local4030_5171); ({ V _r = 0; V m_5173 = local4033_5172; if (((m_5173) == NONE)) {  _r = ({ V __5174 = UNIT; DONE(env[0]); }); } else if (((m_5173) != NONE)) { V _m_5173_a0_5175 = FLD(m_5173, 0); _r = ({ V value_5176 = _m_5173_a0_5175; ({ V local4035_5177 = value_5176; ((((d_Get_dGlobal_dDef_uentry_dreducible(local4035_5177)) != FALSE_V ? ((((V)maybe_is_some(d_Get_dGlobal_dDef_uentry_drec_uarg(local4035_5177)))) ^ 1u) : FALSE_V)) != FALSE_V ? d_Eval_deval(env[1], NIL, d_Get_dGlobal_dDef_uentry_ddef(local4035_5177)) : DONE(env[0])); }); }); } else rt_panic("match: no case at kernel:2842"); _r; }); });
}
static Str S_117 = {TAG_STR, 22, {(const uint8_t *)"instances are deferred"}};
static Str S_118 = {TAG_STR, 16, {(const uint8_t *)"de Bruijn index "}};
static Str S_119 = {TAG_STR, 27, {(const uint8_t *)" is outside the environment"}};
static V lam_5204(V *env, V *args) {
  (void)env; (void)args;
  V local2007_5203 = args[0];
  return d_Eval_deval(env[0], env[1], local2007_5203);
}
static V lam_5212(V *env, V *args) {
  (void)env; (void)args;
  V local2033_5211 = args[0];
  return d_Eval_deval(env[0], env[1], local2033_5211);
}
static V lam_5222(V *env, V *args) {
  (void)env; (void)args;
  V local2057_5221 = args[0];
  return d_Eval_deval(env[0], env[1], local2057_5221);
}
static V lam_5228(V *env, V *args) {
  (void)env; (void)args;
  V local2045_5227 = args[0];
  return d_Eval_deval(env[0], env[1], local2045_5227);
}
static V lam_5234(V *env, V *args) {
  (void)env; (void)args;
  V local3626_5233 = args[0];
  return d_Eval_deval(env[0], env[1], local3626_5233);
}
static V lam_5244(V *env, V *args) {
  (void)env; (void)args;
  V local3636_5243 = args[0];
  return d_Eval_deval(env[0], env[1], local3636_5243);
}
static V lam_5247(V *env, V *args) {
  (void)env; (void)args;
  V local3633_5246 = args[0];
  return d_Eval_dleg_uclosure(env[0], local3633_5246);
}
static V lam_5256(V *env, V *args) {
  (void)env; (void)args;
  V local3935_5255 = args[0];
  return d_Eval_deval(env[0], env[1], local3935_5255);
}
static V lam_5295(V *env, V *args) {
  (void)env; (void)args;
  V local4082_5294 = args[0];
  return d_Eval_dquote(env[0], env[1], local4082_5294);
}
static V lam_5304(V *env, V *args) {
  (void)env; (void)args;
  V local4065_5303 = args[0];
  return d_Value_dvar(d_NativeInt_dadd(env[0], local4065_5303));
}
static V lam_5343(V *env, V *args) {
  (void)env; (void)args;
  V local4126_5342 = args[0];
  return d_Value_dvar(d_NativeInt_dadd(env[0], local4126_5342));
}
static V lam_5371(V *env, V *args) {
  (void)env; (void)args;
  V local4157_5370 = args[0];
  return d_Eval_dquote(env[0], env[1], local4157_5370);
}
static V lam_5379(V *env, V *args) {
  (void)env; (void)args;
  V local4163_5378 = args[0];
  return d_Eval_dquote(env[0], env[1], local4163_5378);
}
static V lam_5381(V *env, V *args) {
  (void)env; (void)args;
  V local4143_5359 = args[0];
  V local4145_5360 = args[1];
  return ({ V t_5361 = local4143_5359; V _r; if (tag_of(t_5361) == 0) _r = t_5361; else { V bound4147_5362 = FLD(t_5361, 0); _r = ({ V scrut4148_5363 = local4145_5360; ({ V _r = 0; V m_5364 = scrut4148_5363; switch (tag_of(m_5364)) { case 0: { V _m_5364_a0_5365 = FLD(m_5364, 0); V _m_5364_a1_5366 = FLD(m_5364, 1); _r = ({ V p4149_5367 = _m_5364_a0_5365; ({ V p4150_5368 = _m_5364_a1_5366; ({ V t_5369 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5371, 1, 2); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; _c; }), p4149_5367); V _r; if (tag_of(t_5369) == 0) _r = t_5369; else { V bound4152_5372 = FLD(t_5369, 0); _r = ({ V t_5373 = d_Eval_dquote_uaddr(env[0], env[1], p4150_5368); V _r; if (tag_of(t_5373) == 0) _r = t_5373; else { V bound4154_5374 = FLD(t_5373, 0); _r = DONE(rt_ctor3(7, bound4152_5372, bound4154_5374, bound4147_5362)); } _r; }); } _r; }); }); }); break; } case 1: { V _m_5364_a0_5375 = FLD(m_5364, 0); _r = ({ V p4158_5376 = _m_5364_a0_5375; ({ V t_5377 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5379, 1, 2); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; _c; }), d_Get_dValue_dStuck_uelim_ds_ushape(p4158_5376)); V _r; if (tag_of(t_5377) == 0) _r = t_5377; else { V bound4160_5380 = FLD(t_5377, 0); _r = DONE(rt_ctor1(5, ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = bound4160_5380; _o->f[1] = bound4147_5362; _o->f[2] = d_Get_dValue_dStuck_uelim_ds_uscrut_uq(p4158_5376); _o->f[3] = d_Get_dValue_dStuck_uelim_ds_umotive(p4158_5376); _o->f[4] = d_Get_dValue_dStuck_uelim_ds_ubranches(p4158_5376); (V)_o; }))); } _r; }); }); break; } default: rt_panic("match: no case at kernel:2902"); } _r; }); }); } _r; });
}
static V lam_5402(V *env, V *args) {
  (void)env; (void)args;
  V local4054_5395 = args[0];
  return ({ V scrut4055_5396 = local4054_5395; ({ V _r = 0; V m_5397 = scrut4055_5396; if ((tag_of(m_5397) == 0)) { V _m_5397_a0_5398 = FLD(m_5397, 0); V _m_5397_a1_5399 = FLD(m_5397, 1); _r = ({ V p4056_5400 = _m_5397_a0_5398; ({ V p4057_5401 = _m_5397_a1_5399; rt_ctor2(2, p4056_5400, p4057_5401); }); }); } else rt_panic("match: no case at kernel:2912"); _r; }); });
}
static V lam_5416(V *env, V *args) {
  (void)env; (void)args;
  V local4087_5409 = args[0];
  return ({ V scrut4088_5410 = local4087_5409; ({ V _r = 0; V m_5411 = scrut4088_5410; if ((tag_of(m_5411) == 0)) { V _m_5411_a0_5412 = FLD(m_5411, 0); V _m_5411_a1_5413 = FLD(m_5411, 1); _r = ({ V p4089_5414 = _m_5411_a0_5412; ({ V p4090_5415 = _m_5411_a1_5413; rt_ctor2(3, p4089_5414, p4090_5415); }); }); } else rt_panic("match: no case at kernel:2913"); _r; }); });
}
static V lam_5425(V *env, V *args) {
  (void)env; (void)args;
  V local4114_5424 = args[0];
  return d_Eval_dquote(env[0], env[1], local4114_5424);
}
static V lam_5431(V *env, V *args) {
  (void)env; (void)args;
  V local4102_5430 = args[0];
  return d_Eval_dquote(env[0], env[1], local4102_5430);
}
static V lam_5439(V *env, V *args) {
  (void)env; (void)args;
  V local4134_5438 = args[0];
  return d_Eval_dquote(env[0], env[1], local4134_5438);
}
static V lam_5443(V *env, V *args) {
  (void)env; (void)args;
  V local4123_5442 = args[0];
  return d_Eval_dquote_uleg(env[0], env[1], local4123_5442);
}
static Str S_120 = {TAG_STR, 29, {(const uint8_t *)"the check budget is exhausted"}};
static Str S_121 = {TAG_STR, 51, {(const uint8_t *)" has no type of its own;  it needs an expected type"}};
static V lam_5464(V *env, V *args) {
  (void)env; (void)args;
  V a_5462 = args[0];
  V b_5463 = args[1];
  return d_Big_dcmp(a_5462, b_5463);
}
static V lam_5516(V *env, V *args) {
  (void)env; (void)args;
  V a_5514 = args[0];
  V b_5515 = args[1];
  return d_Big_dcmp(a_5514, b_5515);
}
static V lam_5519(V *env, V *args) {
  (void)env; (void)args;
  V a_5517 = args[0];
  V b_5518 = args[1];
  return d_Big_dcmp(a_5517, b_5518);
}
static V w_Quantity_dat_umost_uonce(V *env, V *args) {
  (void)env; (void)args;
  return d_Quantity_dat_umost_uonce(args[0], args[1]);
}
static V w_Quantity_dexactly_uonce(V *env, V *args) {
  (void)env; (void)args;
  return d_Quantity_dexactly_uonce(args[0], args[1]);
}
static Str S_122 = {TAG_STR, 17, {(const uint8_t *)"the linear alias "}};
static Str S_123 = {TAG_STR, 25, {(const uint8_t *)" may be used at most once"}};
static Str S_124 = {TAG_STR, 18, {(const uint8_t *)"the linear binder "}};
static Str S_125 = {TAG_STR, 48, {(const uint8_t *)" must be used exactly once on every runtime path"}};
static V lam_5549(V *env, V *args) {
  (void)env; (void)args;
  V local4388_5531 = args[0];
  V local4390_5532 = args[1];
  return ({ V scrut4391_5533 = local4390_5532; ({ V _r = 0; V m_5534 = scrut4391_5533; if ((tag_of(m_5534) == 0)) { V _m_5534_a0_5535 = FLD(m_5534, 0); V _m_5534_a1_5536 = FLD(m_5534, 1); _r = ({ V p4392_5537 = _m_5534_a0_5535; ({ V p4393_5538 = _m_5534_a1_5536; ({ V _r = 0; V m_5539 = p4393_5538; if ((tag_of(m_5539) == 0)) { V _m_5539_a0_5540 = FLD(m_5539, 0); V _m_5539_a1_5541 = FLD(m_5539, 1); V _m_5539_a2_5542 = FLD(m_5539, 2); _r = ({ V p4394_5543 = _m_5539_a0_5540; ({ V p4395_5544 = _m_5539_a1_5541; ({ V p4396_5545 = _m_5539_a2_5542; ({ V t_5546 = local4388_5531; V _r; if (tag_of(t_5546) == 0) _r = t_5546; else { V bound4398_5547 = FLD(t_5546, 0); _r = ((d_Big_dis_ult(p4392_5537, env[0])) != FALSE_V ? DONE(bound4398_5547) : ((((((d_Quantity_dequal(env[1], ((V)0))) ^ 1u)) != FALSE_V ? ((d_Quantity_dequal(p4395_5544, ((V)1))) != FALSE_V ? ((ap2(((env[2]) != FALSE_V ? clo_new(w_Quantity_dat_umost_uonce, 2, 0) : clo_new(w_Quantity_dexactly_uonce, 2, 0)), p4392_5537, bound4398_5547)) ^ 1u) : FALSE_V) : FALSE_V)) != FALSE_V ? ({ V scrut4411_5548 = ((env[2]) != FALSE_V ? str_append(((V)&S_122), str_append(p4394_5543, ((V)&S_123))) : str_append(((V)&S_124), str_append(p4394_5543, ((V)&S_125)))); FAIL(rt_ctor1(6, scrut4411_5548)); }) : DONE(d_Quantity_dremove(p4392_5537, bound4398_5547)))); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2976"); _r; }); }); }); } else rt_panic("match: no case at kernel:2976"); _r; }); });
}
static V lam_5552(V *env, V *args) {
  (void)env; (void)args;
  V local4419_5550 = args[0];
  V local4421_5551 = args[1];
  return rt_ctor2(0, d_NativeInt_dsub(d_NativeInt_dsub(d_Get_dCheck_dCtx_dsize(env[0]), local4419_5550), d_Big_done()), local4421_5551);
}
static Str S_126 = {TAG_STR, 4, {(const uint8_t *)"SPi "}};
static Str S_127 = {TAG_STR, 6, {(const uint8_t *)"SColl "}};
static Str S_128 = {TAG_STR, 5, {(const uint8_t *)"SPar "}};
static Str S_129 = {TAG_STR, 4, {(const uint8_t *)"SMu "}};
static Str S_130 = {TAG_STR, 2, {(const uint8_t *)" ["}};
static V lam_5586(V *env, V *args) {
  (void)env; (void)args;
  V local4463_5585 = args[0];
  return d_Pp_dterm(env[0], local4463_5585);
}
static Str S_131 = {TAG_STR, 2, {(const uint8_t *)"; "}};
static Str S_132 = {TAG_STR, 1, {(const uint8_t *)"]"}};
static Str S_133 = {TAG_STR, 4, {(const uint8_t *)"SNu "}};
static V lam_5592(V *env, V *args) {
  (void)env; (void)args;
  V local4468_5591 = args[0];
  return d_Pp_dterm(env[0], local4468_5591);
}
static Str S_134 = {TAG_STR, 5, {(const uint8_t *)"(APt "}};
static Str S_135 = {TAG_STR, 1, {(const uint8_t *)")"}};
static Str S_136 = {TAG_STR, 6, {(const uint8_t *)"(ALeg "}};
static Str S_137 = {TAG_STR, 7, {(const uint8_t *)"(ACtor "}};
static V lam_5637(V *env, V *args) {
  (void)env; (void)args;
  V local4507_5630 = args[0];
  return ({ V scrut4508_5631 = local4507_5630; ({ V _r = 0; V m_5632 = scrut4508_5631; if ((tag_of(m_5632) == 0)) { V _m_5632_a0_5633 = FLD(m_5632, 0); V _m_5632_a1_5634 = FLD(m_5632, 1); _r = ({ V p4509_5635 = _m_5632_a0_5633; ({ V p4510_5636 = _m_5632_a1_5634; p4510_5636; }); }); } else rt_panic("match: no case at kernel:3002"); _r; }); });
}
static V lam_5642(V *env, V *args) {
  (void)env; (void)args;
  V local4513_5640 = args[0];
  V local4515_5641 = args[1];
  return CON(local4515_5641, local4513_5640);
}
static Str S_138 = {TAG_STR, 4, {(const uint8_t *)" => "}};
static Str S_139 = {TAG_STR, 4, {(const uint8_t *)" as "}};
static Str S_140 = {TAG_STR, 8, {(const uint8_t *)" return "}};
static Str S_141 = {TAG_STR, 3, {(const uint8_t *)" | "}};
static V lam_5664(V *env, V *args) {
  (void)env; (void)args;
  V local4502_5657 = args[0];
  return ({ V scrut4503_5658 = local4502_5657; ({ V _r = 0; V m_5659 = scrut4503_5658; if ((tag_of(m_5659) == 0)) { V _m_5659_a0_5660 = FLD(m_5659, 0); V _m_5659_a1_5661 = FLD(m_5659, 1); _r = ({ V p4504_5662 = _m_5659_a0_5660; ({ V p4505_5663 = _m_5659_a1_5661; str_concat(CON(((V)&S_141), CON(d_Pp_daddr(env[0], p4504_5662), CON(((V)&S_42), CON(d_Pp_dleg(env[0], p4505_5663), NIL))))); }); }); } else rt_panic("match: no case at kernel:3015"); _r; }); });
}
static Str S_142 = {TAG_STR, 6, {(const uint8_t *)"(Elim "}};
static Str S_143 = {TAG_STR, 5, {(const uint8_t *)" with"}};
static Str S_144 = {TAG_STR, 1, {(const uint8_t *)"\042"}};
static Str S_145 = {TAG_STR, 1, {(const uint8_t *)"#"}};
static Str S_146 = {TAG_STR, 5, {(const uint8_t *)"Type "}};
static Str S_147 = {TAG_STR, 5, {(const uint8_t *)"(Lan "}};
static Str S_148 = {TAG_STR, 5, {(const uint8_t *)"(Ran "}};
static Str S_149 = {TAG_STR, 4, {(const uint8_t *)"(In "}};
static V lam_5696(V *env, V *args) {
  (void)env; (void)args;
  V local4492_5695 = args[0];
  return d_Pp_dterm(env[0], local4492_5695);
}
static Str S_150 = {TAG_STR, 2, {(const uint8_t *)"])"}};
static Str S_151 = {TAG_STR, 5, {(const uint8_t *)"(Sec "}};
static V lam_5704(V *env, V *args) {
  (void)env; (void)args;
  V local4521_5703 = args[0];
  return d_Pp_dleg(env[0], local4521_5703);
}
static Str S_152 = {TAG_STR, 5, {(const uint8_t *)"(Out "}};
static Str S_153 = {TAG_STR, 4, {(const uint8_t *)"let "}};
static Str S_154 = {TAG_STR, 3, {(const uint8_t *)" : "}};
static Str S_155 = {TAG_STR, 4, {(const uint8_t *)" := "}};
static Str S_156 = {TAG_STR, 4, {(const uint8_t *)" in "}};
static Str S_157 = {TAG_STR, 1, {(const uint8_t *)"("}};
static Str S_158 = {TAG_STR, 4, {(const uint8_t *)"auto"}};
static Str S_159 = {TAG_STR, 31, {(const uint8_t *)"a value that does not read back"}};
static V lam_5752(V *env, V *args) {
  (void)env; (void)args;
  V local4554_5751 = args[0];
  return ap2(d_Get_dRules_dOps_do_uinfer_uuniv(env[0]), env[1], local4554_5751);
}
static V lam_6023(V *env, V *args) {
  (void)env; (void)args;
  V local4630_6021 = args[0];
  V local4632_6022 = args[1];
  return d_Conv_dconv_utype(UNIT, UNIT, env[0], env[1], local4630_6021, local4632_6022);
}
static V lam_6034(V *env, V *args) {
  (void)env; (void)args;
  V local4740_6032 = args[0];
  V local4742_6033 = args[1];
  return d_Conv_dconv_utype(UNIT, UNIT, env[0], env[1], local4740_6032, local4742_6033);
}
static V lam_6045(V *env, V *args) {
  (void)env; (void)args;
  V local4764_6043 = args[0];
  return ({ V scrut4765_6044 = local4764_6043; ap(env[0], env[1]); });
}
static V lam_6052(V *env, V *args) {
  (void)env; (void)args;
  V local4798_6050 = args[0];
  return ({ V scrut4799_6051 = local4798_6050; ap(env[0], UNIT); });
}
static V lam_6054(V *env, V *args) {
  (void)env; (void)args;
  V local4801_6053 = args[0];
  return SOME(local4801_6053);
}
static V lam_6055(V *env, V *args) {
  (void)env; (void)args;
  V local4794_6048 = args[0];
  V local4796_6049 = args[1];
  return d_Conv_dopt_uelse(local4794_6048, ({ V _c = clo_new(lam_6052, 1, 1); CLO_ENV(_c)[0] = local4796_6049; _c; }), clo_new(lam_6054, 1, 0));
}
static V lam_6087(V *env, V *args) {
  (void)env; (void)args;
  V local4757_6085 = args[0];
  return ({ V scrut4758_6086 = local4757_6085; d_Conv_dconv_utype(UNIT, UNIT, env[0], env[1], env[2], env[3]); });
}
static V lam_6089(V *env, V *args) {
  (void)env; (void)args;
  V local4760_6088 = args[0];
  return d_Conv_dconv(UNIT, UNIT, env[0], env[1], local4760_6088, env[2], env[3]);
}
static V lam_6090(V *env, V *args) {
  (void)env; (void)args;
  V local4744_6061 = args[0];
  return ({ V scrut4745_6062 = local4744_6061; ({ V _r = 0; V m_6063 = d_Value_das_upt(env[0]); if (((m_6063) == NONE)) {  _r = ({ V __6064 = UNIT; NONE; }); } else if (((m_6063) != NONE)) { V _m_6063_a0_6065 = FLD(m_6063, 0); _r = ({ V item4769_6066 = _m_6063_a0_6065; ({ V local4747_6067 = item4769_6066; ({ V scrut4748_6068 = local4747_6067; ({ V _r = 0; V m_6069 = scrut4748_6068; if ((tag_of(m_6069) == 0)) { V _m_6069_a0_6070 = FLD(m_6069, 0); V _m_6069_a1_6071 = FLD(m_6069, 1); _r = ({ V p4749_6072 = _m_6069_a0_6070; ({ V p4750_6073 = _m_6069_a1_6071; ({ V _r = 0; V m_6074 = d_Value_das_upt(env[1]); if (((m_6074) == NONE)) {  _r = ({ V __6075 = UNIT; NONE; }); } else if (((m_6074) != NONE)) { V _m_6074_a0_6076 = FLD(m_6074, 0); _r = ({ V item4767_6077 = _m_6074_a0_6076; SOME(({ V local4752_6078 = item4767_6077; ({ V scrut4753_6079 = local4752_6078; ({ V _r = 0; V m_6080 = scrut4753_6079; if ((tag_of(m_6080) == 0)) { V _m_6080_a0_6081 = FLD(m_6080, 0); V _m_6080_a1_6082 = FLD(m_6080, 1); _r = ({ V p4754_6083 = _m_6080_a0_6081; ({ V p4755_6084 = _m_6080_a1_6082; d_Conv_dopt_uelse(env[2], ({ V _c = clo_new(lam_6087, 1, 4); CLO_ENV(_c)[0] = env[3]; CLO_ENV(_c)[1] = env[4]; CLO_ENV(_c)[2] = p4750_6073; CLO_ENV(_c)[3] = p4755_6084; _c; }), ({ V _c = clo_new(lam_6089, 1, 4); CLO_ENV(_c)[0] = env[3]; CLO_ENV(_c)[1] = env[4]; CLO_ENV(_c)[2] = p4750_6073; CLO_ENV(_c)[3] = p4755_6084; _c; })); }); }); } else rt_panic("match: no case at kernel:3080"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3079"); _r; }); }); }); } else rt_panic("match: no case at kernel:3079"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3078"); _r; }); });
}
static V lam_6103(V *env, V *args) {
  (void)env; (void)args;
  V local4772_6091 = args[0];
  return ({ V scrut4773_6092 = local4772_6091; ({ V _r = 0; V m_6093 = d_Value_das_uleg(env[0]); if (((m_6093) == NONE)) {  _r = ({ V __6094 = UNIT; NONE; }); } else if (((m_6093) != NONE)) { V _m_6093_a0_6095 = FLD(m_6093, 0); _r = ({ V item4781_6096 = _m_6093_a0_6095; ({ V local4775_6097 = item4781_6096; ({ V _r = 0; V m_6098 = d_Value_das_uleg(env[1]); if (((m_6098) == NONE)) {  _r = ({ V __6099 = UNIT; NONE; }); } else if (((m_6098) != NONE)) { V _m_6098_a0_6100 = FLD(m_6098, 0); _r = ({ V item4779_6101 = _m_6098_a0_6100; SOME(({ V local4777_6102 = item4779_6101; DONE(d_Big_dis_ueq(local4775_6097, local4777_6102)); })); }); } else rt_panic("match: no case at kernel:3082"); _r; }); }); }); } else rt_panic("match: no case at kernel:3082"); _r; }); });
}
static V lam_6116(V *env, V *args) {
  (void)env; (void)args;
  V local4783_6104 = args[0];
  return ({ V scrut4784_6105 = local4783_6104; ({ V _r = 0; V m_6106 = d_Value_das_uctor(env[0]); if (((m_6106) == NONE)) {  _r = ({ V __6107 = UNIT; NONE; }); } else if (((m_6106) != NONE)) { V _m_6106_a0_6108 = FLD(m_6106, 0); _r = ({ V item4792_6109 = _m_6106_a0_6108; ({ V local4786_6110 = item4792_6109; ({ V _r = 0; V m_6111 = d_Value_das_uctor(env[1]); if (((m_6111) == NONE)) {  _r = ({ V __6112 = UNIT; NONE; }); } else if (((m_6111) != NONE)) { V _m_6111_a0_6113 = FLD(m_6111, 0); _r = ({ V item4790_6114 = _m_6111_a0_6113; SOME(({ V local4788_6115 = item4790_6114; DONE(d_NativeString_dequal(local4786_6110, local4788_6115)); })); }); } else rt_panic("match: no case at kernel:3083"); _r; }); }); }); } else rt_panic("match: no case at kernel:3083"); _r; }); });
}
static V lam_6150(V *env, V *args) {
  (void)env; (void)args;
  V local4808_6148 = args[0];
  V local4810_6149 = args[1];
  return d_Conv_dconv_utype(UNIT, UNIT, env[0], env[1], local4808_6148, local4810_6149);
}
static Str S_160 = {TAG_STR, 1, {(const uint8_t *)"_"}};
static V lam_6160(V *env, V *args) {
  (void)env; (void)args;
  V local4846_6158 = args[0];
  V local4848_6159 = args[1];
  return apn(d_Get_dRules_dOps_do_ubind(env[0]), 4, (V[]){((V)&S_160), ((V)2), d_Conv_dplaceholder(), local4846_6158});
}
static V lam_6162(V *env, V *args) {
  (void)env; (void)args;
  V local4850_6161 = args[0];
  return local4850_6161;
}
static V lam_6172(V *env, V *args) {
  (void)env; (void)args;
  V local4838_6171 = args[0];
  return d_Value_dvar(d_NativeInt_dsub(d_NativeInt_dsub(d_NativeInt_dadd(env[0], env[1]), d_Big_done()), local4838_6171));
}
static V lam_6184(V *env, V *args) {
  (void)env; (void)args;
  V local4833_6182 = args[0];
  V local4835_6183 = args[1];
  return d_Conv_dconv_uclosures(env[0], env[1], d_Big_dof_unat(list_length(d_Get_dValue_dVleg_dvl_ubinders(local4833_6182))), d_Get_dValue_dVleg_dvl_uclo(local4833_6182), d_Big_dof_unat(list_length(d_Get_dValue_dVleg_dvl_ubinders(local4835_6183))), d_Get_dValue_dVleg_dvl_uclo(local4835_6183));
}
static V lam_6214(V *env, V *args) {
  (void)env; (void)args;
  V local4854_6212 = args[0];
  V local4856_6213 = args[1];
  return d_Conv_dconv_utype(UNIT, UNIT, env[0], env[1], local4854_6212, local4856_6213);
}
static V lam_6249(V *env, V *args) {
  (void)env; (void)args;
  V local4923_6247 = args[0];
  return ({ V scrut4924_6248 = local4923_6247; DONE(NONE); });
}
static V lam_6265(V *env, V *args) {
  (void)env; (void)args;
  V local4926_6250 = args[0];
  return ({ V scrut4927_6251 = local4926_6250; ({ V _r = 0; V m_6252 = scrut4927_6251; if ((tag_of(m_6252) == 0)) { V _m_6252_a0_6253 = FLD(m_6252, 0); V _m_6252_a1_6254 = FLD(m_6252, 1); V _m_6252_a2_6255 = FLD(m_6252, 2); _r = ({ V p4928_6256 = _m_6252_a0_6253; ({ V p4929_6257 = _m_6252_a1_6254; ({ V p4930_6258 = _m_6252_a2_6255; ({ V _r = 0; V m_6259 = d_Rules_drules(env[0]); switch (tag_of(m_6259)) { case 1: { V _m_6259_a0_6260 = FLD(m_6259, 0); _r = ({ V item4934_6261 = _m_6259_a0_6260; ({ V local4933_6262 = item4934_6261; apn(d_Get_dRules_dRule_upack_dspine_uty(local4933_6262), 5, (V[]){env[1], env[2], env[0], p4929_6257, env[3]}); }); }); break; } case 0: { V _m_6259_a0_6263 = FLD(m_6259, 0); _r = ({ V item4935_6264 = _m_6259_a0_6263; FAIL(item4935_6264); }); break; } default: rt_panic("match: no case at kernel:3126"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3126"); _r; }); });
}
static V lam_6301(V *env, V *args) {
  (void)env; (void)args;
  V local4970_6273 = args[0];
  return ({ V scrut4971_6274 = local4970_6273; ({ V _r = 0; V m_6275 = d_Term_das_uapt(env[0]); if (((m_6275) == NONE)) {  _r = ({ V __6276 = UNIT; NONE; }); } else if (((m_6275) != NONE)) { V _m_6275_a0_6277 = FLD(m_6275, 0); _r = ({ V item4989_6278 = _m_6275_a0_6277; ({ V local4973_6279 = item4989_6278; ({ V scrut4974_6280 = local4973_6279; ({ V _r = 0; V m_6281 = scrut4974_6280; if ((tag_of(m_6281) == 0)) { V _m_6281_a0_6282 = FLD(m_6281, 0); V _m_6281_a1_6283 = FLD(m_6281, 1); _r = ({ V p4975_6284 = _m_6281_a0_6282; ({ V p4976_6285 = _m_6281_a1_6283; ({ V _r = 0; V m_6286 = d_Term_das_uapt(env[1]); if (((m_6286) == NONE)) {  _r = ({ V __6287 = UNIT; NONE; }); } else if (((m_6286) != NONE)) { V _m_6286_a0_6288 = FLD(m_6286, 0); _r = ({ V item4987_6289 = _m_6286_a0_6288; SOME(({ V local4978_6290 = item4987_6289; ({ V scrut4979_6291 = local4978_6290; ({ V _r = 0; V m_6292 = scrut4979_6291; if ((tag_of(m_6292) == 0)) { V _m_6292_a0_6293 = FLD(m_6292, 0); V _m_6292_a1_6294 = FLD(m_6292, 1); _r = ({ V p4980_6295 = _m_6292_a0_6293; ({ V p4981_6296 = _m_6292_a1_6294; ({ V t_6297 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[2]), env[3], p4976_6285); V _r; if (tag_of(t_6297) == 0) _r = t_6297; else { V bound4983_6298 = FLD(t_6297, 0); _r = ({ V t_6299 = ap2(d_Get_dRules_dEvaluator_dev_ueval(env[2]), env[4], p4981_6296); V _r; if (tag_of(t_6299) == 0) _r = t_6299; else { V bound4985_6300 = FLD(t_6299, 0); _r = d_Conv_dconv_utype(UNIT, UNIT, env[5], env[6], bound4983_6298, bound4985_6300); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:3133"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3132"); _r; }); }); }); } else rt_panic("match: no case at kernel:3132"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3131"); _r; }); });
}
static V lam_6314(V *env, V *args) {
  (void)env; (void)args;
  V local4992_6302 = args[0];
  return ({ V scrut4993_6303 = local4992_6302; ({ V _r = 0; V m_6304 = d_Term_das_ualeg(env[0]); if (((m_6304) == NONE)) {  _r = ({ V __6305 = UNIT; NONE; }); } else if (((m_6304) != NONE)) { V _m_6304_a0_6306 = FLD(m_6304, 0); _r = ({ V item5001_6307 = _m_6304_a0_6306; ({ V local4995_6308 = item5001_6307; ({ V _r = 0; V m_6309 = d_Term_das_ualeg(env[1]); if (((m_6309) == NONE)) {  _r = ({ V __6310 = UNIT; NONE; }); } else if (((m_6309) != NONE)) { V _m_6309_a0_6311 = FLD(m_6309, 0); _r = ({ V item4999_6312 = _m_6309_a0_6311; SOME(({ V local4997_6313 = item4999_6312; DONE(d_Big_dis_ueq(local4995_6308, local4997_6313)); })); }); } else rt_panic("match: no case at kernel:3137"); _r; }); }); }); } else rt_panic("match: no case at kernel:3137"); _r; }); });
}
static V lam_6327(V *env, V *args) {
  (void)env; (void)args;
  V local5003_6315 = args[0];
  return ({ V scrut5004_6316 = local5003_6315; ({ V _r = 0; V m_6317 = d_Term_das_uactor(env[0]); if (((m_6317) == NONE)) {  _r = ({ V __6318 = UNIT; NONE; }); } else if (((m_6317) != NONE)) { V _m_6317_a0_6319 = FLD(m_6317, 0); _r = ({ V item5012_6320 = _m_6317_a0_6319; ({ V local5006_6321 = item5012_6320; ({ V _r = 0; V m_6322 = d_Term_das_uactor(env[1]); if (((m_6322) == NONE)) {  _r = ({ V __6323 = UNIT; NONE; }); } else if (((m_6322) != NONE)) { V _m_6322_a0_6324 = FLD(m_6322, 0); _r = ({ V item5010_6325 = _m_6322_a0_6324; SOME(({ V local5008_6326 = item5010_6325; DONE(d_NativeString_dequal(local5006_6321, local5008_6326)); })); }); } else rt_panic("match: no case at kernel:3138"); _r; }); }); }); } else rt_panic("match: no case at kernel:3138"); _r; }); });
}
static V lam_6350(V *env, V *args) {
  (void)env; (void)args;
  V local4957_6334 = args[0];
  V local4959_6335 = args[1];
  return ({ V scrut4960_6336 = local4957_6334; ({ V _r = 0; V m_6337 = scrut4960_6336; if ((tag_of(m_6337) == 0)) { V _m_6337_a0_6338 = FLD(m_6337, 0); V _m_6337_a1_6339 = FLD(m_6337, 1); _r = ({ V p4961_6340 = _m_6337_a0_6338; ({ V p4962_6341 = _m_6337_a1_6339; ({ V scrut4963_6342 = local4959_6335; ({ V _r = 0; V m_6343 = scrut4963_6342; if ((tag_of(m_6343) == 0)) { V _m_6343_a0_6344 = FLD(m_6343, 0); V _m_6343_a1_6345 = FLD(m_6343, 1); _r = ({ V p4964_6346 = _m_6343_a0_6344; ({ V p4965_6347 = _m_6343_a1_6345; ({ V t_6348 = d_Conv_dbranch_uaddr(env[0], env[1], env[2], env[3], p4961_6340, p4964_6346); V _r; if (tag_of(t_6348) == 0) _r = t_6348; else { V bound4967_6349 = FLD(t_6348, 0); _r = ((((bound4967_6349) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : d_Conv_dconv_uclosures(env[0], env[1], d_Big_dof_unat(list_length(d_Get_dTerm_dLeg_dl_ubinders(p4962_6341))), rt_ctor2(0, env[2], d_Get_dTerm_dLeg_dl_ubody(p4962_6341)), d_Big_dof_unat(list_length(d_Get_dTerm_dLeg_dl_ubinders(p4965_6347))), rt_ctor2(0, env[3], d_Get_dTerm_dLeg_dl_ubody(p4965_6347)))); } _r; }); }); }); } else rt_panic("match: no case at kernel:3143"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3142"); _r; }); });
}
static V lam_6373(V *env, V *args) {
  (void)env; (void)args;
  V local5029_6372 = args[0];
  return d_Value_dvar(d_NativeInt_dsub(d_NativeInt_dsub(d_NativeInt_dadd(env[0], env[1]), d_Big_done()), local5029_6372));
}
static V lam_6387(V *env, V *args) {
  (void)env; (void)args;
  V local5041_6385 = args[0];
  V local5043_6386 = args[1];
  return d_Conv_dconv_utype(UNIT, UNIT, env[0], env[1], local5041_6385, local5043_6386);
}
static V lam_6436(V *env, V *args) {
  (void)env; (void)args;
  V local4939_6434 = args[0];
  V local4941_6435 = args[1];
  return d_Conv_dconv_utype(env[0], env[1], env[2], env[3], local4939_6434, local4941_6435);
}
static V lam_6520(V *env, V *args) {
  (void)env; (void)args;
  V local4574_6518 = args[0];
  return ({ V scrut4575_6519 = local4574_6518; d_Conv_duniv_ucase(env[0], env[1]); });
}
static V lam_6523(V *env, V *args) {
  (void)env; (void)args;
  V local4585_6521 = args[0];
  return ({ V scrut4586_6522 = local4585_6521; d_Conv_dlit_ucase(env[0], env[1]); });
}
static V lam_6526(V *env, V *args) {
  (void)env; (void)args;
  V local4605_6524 = args[0];
  return ({ V scrut4606_6525 = local4605_6524; d_Conv_dformer_ucase(env[0], env[1], ((V)0), env[2], env[3]); });
}
static V lam_6529(V *env, V *args) {
  (void)env; (void)args;
  V local4715_6527 = args[0];
  return ({ V scrut4716_6528 = local4715_6527; d_Conv_dformer_ucase(env[0], env[1], ((V)1), env[2], env[3]); });
}
static V lam_6532(V *env, V *args) {
  (void)env; (void)args;
  V local4718_6530 = args[0];
  return ({ V scrut4719_6531 = local4718_6530; d_Conv_din_ucase(env[0], env[1], env[2], env[3]); });
}
static V lam_6535(V *env, V *args) {
  (void)env; (void)args;
  V local4817_6533 = args[0];
  return ({ V scrut4818_6534 = local4817_6533; d_Conv_dsec_ucase(env[0], env[1], env[2], env[3]); });
}
static V lam_6538(V *env, V *args) {
  (void)env; (void)args;
  V local4862_6536 = args[0];
  return ({ V scrut4863_6537 = local4862_6536; d_Conv_dneutral_ucase(env[0], env[1], env[2], env[3]); });
}
static V lam_6587(V *env, V *args) {
  (void)env; (void)args;
  V local5081_6585 = args[0];
  return ({ V scrut5082_6586 = local5081_6585; DONE(NONE); });
}
static V lam_6603(V *env, V *args) {
  (void)env; (void)args;
  V local5094_6601 = args[0];
  return ({ V scrut5095_6602 = local5094_6601; DONE(NONE); });
}
static V lam_6611(V *env, V *args) {
  (void)env; (void)args;
  V local5097_6604 = args[0];
  return ({ V _r = 0; V m_6605 = apn(local5097_6604, 6, (V[]){env[0], env[1], env[2], env[3], env[4], env[5]}); switch (tag_of(m_6605)) { case 1: { V _m_6605_a0_6606 = FLD(m_6605, 0); _r = ({ V item5101_6607 = _m_6605_a0_6606; DONE(({ V local5100_6608 = item5101_6607; SOME(local5100_6608); })); }); break; } case 0: { V _m_6605_a0_6609 = FLD(m_6605, 0); _r = ({ V item5102_6610 = _m_6605_a0_6609; FAIL(item5102_6610); }); break; } default: rt_panic("match: no case at kernel:3214"); } _r; });
}
static V lam_6614(V *env, V *args) {
  (void)env; (void)args;
  V local5084_6588 = args[0];
  return ({ V scrut5085_6589 = local5084_6588; ({ V _r = 0; V m_6590 = scrut5085_6589; if ((tag_of(m_6590) == 0)) { V _m_6590_a0_6591 = FLD(m_6590, 0); V _m_6590_a1_6592 = FLD(m_6590, 1); V _m_6590_a2_6593 = FLD(m_6590, 2); _r = ({ V p5086_6594 = _m_6590_a0_6591; ({ V p5087_6595 = _m_6590_a1_6592; ({ V p5088_6596 = _m_6590_a2_6593; ({ V _r = 0; V m_6597 = d_Rules_drules(p5087_6595); switch (tag_of(m_6597)) { case 1: { V _m_6597_a0_6598 = FLD(m_6597, 0); _r = ({ V item5103_6599 = _m_6597_a0_6598; ({ V local5091_6600 = item5103_6599; d_Conv_dopt_uelse(d_Conv_dexpansion_uof(local5091_6600, p5086_6594), clo_new(lam_6603, 1, 0), ({ V _c = clo_new(lam_6611, 1, 6); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; CLO_ENV(_c)[2] = p5087_6595; CLO_ENV(_c)[3] = p5088_6596; CLO_ENV(_c)[4] = env[2]; CLO_ENV(_c)[5] = env[3]; _c; })); }); }); break; } case 0: { V _m_6597_a0_6612 = FLD(m_6597, 0); _r = ({ V item5104_6613 = _m_6597_a0_6612; FAIL(item5104_6613); }); break; } default: rt_panic("match: no case at kernel:3213"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3213"); _r; }); });
}
static V lam_6620(V *env, V *args) {
  (void)env; (void)args;
  V local5107_6618 = args[0];
  return ({ V scrut5108_6619 = local5107_6618; DONE(FALSE_V); });
}
static V lam_6636(V *env, V *args) {
  (void)env; (void)args;
  V local5110_6621 = args[0];
  return ({ V scrut5111_6622 = local5110_6621; ({ V _r = 0; V m_6623 = scrut5111_6622; if ((tag_of(m_6623) == 0)) { V _m_6623_a0_6624 = FLD(m_6623, 0); V _m_6623_a1_6625 = FLD(m_6623, 1); V _m_6623_a2_6626 = FLD(m_6623, 2); _r = ({ V p5112_6627 = _m_6623_a0_6624; ({ V p5113_6628 = _m_6623_a1_6625; ({ V p5114_6629 = _m_6623_a2_6626; ({ V _r = 0; V m_6630 = d_Rules_drules(p5112_6627); switch (tag_of(m_6630)) { case 1: { V _m_6630_a0_6631 = FLD(m_6630, 0); _r = ({ V item5118_6632 = _m_6630_a0_6631; ({ V local5117_6633 = item5118_6632; ap3(d_Get_dRules_dRule_upack_dsubsingleton(local5117_6633), env[0], env[1], p5112_6627); }); }); break; } case 0: { V _m_6630_a0_6634 = FLD(m_6630, 0); _r = ({ V item5119_6635 = _m_6630_a0_6634; FAIL(item5119_6635); }); break; } default: rt_panic("match: no case at kernel:3219"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3219"); _r; }); });
}
static V lam_6653(V *env, V *args) {
  (void)env; (void)args;
  V local4567_6651 = args[0];
  return ({ V scrut4568_6652 = local4567_6651; d_Conv_dstructural(env[0], env[1], env[2], env[3]); });
}
static V lam_6655(V *env, V *args) {
  (void)env; (void)args;
  V local5050_6654 = args[0];
  return DONE(local5050_6654);
}
static Str S_161 = {TAG_STR, 18, {(const uint8_t *)"the term has type "}};
static Str S_162 = {TAG_STR, 26, {(const uint8_t *)" and the expected type is "}};
static Str S_163 = {TAG_STR, 65, {(const uint8_t *)"a type former is checked against a type that is not a universe:  "}};
static Str S_164 = {TAG_STR, 20, {(const uint8_t *)"the former lives at "}};
static Str S_165 = {TAG_STR, 30, {(const uint8_t *)" and the expected universe is "}};
static V lam_6806(V *env, V *args) {
  (void)env; (void)args;
  V local5201_6803 = args[0];
  return ({ V t_6804 = d_Check_dcheck_uuses(local5201_6803, env[0], env[1], env[2]); V _r; if (tag_of(t_6804) == 0) _r = t_6804; else { V bound5203_6805 = FLD(t_6804, 0); _r = DONE(rt_ctor2(0, env[2], bound5203_6805)); } _r; });
}
static Str S_166 = {TAG_STR, 42, {(const uint8_t *)"a term used as a type is not a universe:  "}};
static V lam_6902(V *env, V *args) {
  (void)env; (void)args;
  V local4360_6888 = args[0];
  return ({ V scrut4361_6889 = local4360_6888; ({ V _r = 0; V m_6890 = scrut4361_6889; if ((tag_of(m_6890) == 0)) { V _m_6890_a0_6891 = FLD(m_6890, 0); V _m_6890_a1_6892 = FLD(m_6890, 1); _r = ({ V p4362_6893 = _m_6890_a0_6891; ({ V p4363_6894 = _m_6890_a1_6892; ({ V _r = 0; V m_6895 = p4363_6894; if ((tag_of(m_6895) == 0)) { V _m_6895_a0_6896 = FLD(m_6895, 0); V _m_6895_a1_6897 = FLD(m_6895, 1); V _m_6895_a2_6898 = FLD(m_6895, 2); _r = ({ V p4364_6899 = _m_6895_a0_6896; ({ V p4365_6900 = _m_6895_a1_6897; ({ V p4366_6901 = _m_6895_a2_6898; ((d_Quantity_dequal(p4365_6900, ((V)1))) != FALSE_V ? d_Quantity_dused(d_NativeInt_dsub(d_NativeInt_dsub(d_Get_dCheck_dCtx_dsize(env[0]), p4362_6893), d_Big_done()), env[1]) : FALSE_V); }); }); }); } else rt_panic("match: no case at kernel:3302"); _r; }); }); }); } else rt_panic("match: no case at kernel:3302"); _r; }); });
}
static V lam_6905(V *env, V *args) {
  (void)env; (void)args;
  V local4371_6903 = args[0];
  V local4373_6904 = args[1];
  return rt_ctor2(0, local4371_6903, local4373_6904);
}
static Str S_167 = {TAG_STR, 36, {(const uint8_t *)"a local level is outside the context"}};
static V lam_6963(V *env, V *args) {
  (void)env; (void)args;
  V local5286_6962 = args[0];
  return d_Eval_deval(d_Get_dCheck_dCtx_dglobals(env[0]), NIL, d_Global_dentry_uty(local5286_6962));
}
static Str S_168 = {TAG_STR, 25, {(const uint8_t *)"string types are deferred"}};
static Str S_169 = {TAG_STR, 23, {(const uint8_t *)" is outside the context"}};
static Str S_170 = {TAG_STR, 18, {(const uint8_t *)"the erased binder "}};
static Str S_171 = {TAG_STR, 30, {(const uint8_t *)" is read in a runtime position"}};
static Str S_172 = {TAG_STR, 12, {(const uint8_t *)"an injection"}};
static Str S_173 = {TAG_STR, 9, {(const uint8_t *)"a section"}};
static V lam_7055(V *env, V *args) {
  (void)env; (void)args;
  V local4350_7054 = args[0];
  return d_Check_dinfer_uuses(local4350_7054, env[0], env[1]);
}
static Str S_174 = {TAG_STR, 33, {(const uint8_t *)"a Nat literal must be nonnegative"}};
static V lam_7090(V *env, V *args) {
  (void)env; (void)args;
  V local4290_7087 = args[0];
  V local4292_7088 = args[1];
  V local4294_7089 = args[2];
  return d_Check_dinfer_uuses(local4290_7087, local4292_7088, local4294_7089);
}
static V lam_7095(V *env, V *args) {
  (void)env; (void)args;
  V local5297_7091 = args[0];
  V local5299_7092 = args[1];
  V local5301_7093 = args[2];
  V local5303_7094 = args[3];
  return d_Check_dcheck_uuses(local5297_7091, local5299_7092, local5301_7093, local5303_7094);
}
static V lam_7100(V *env, V *args) {
  (void)env; (void)args;
  V local5305_7096 = args[0];
  V local5307_7097 = args[1];
  V local5309_7098 = args[2];
  V local5311_7099 = args[3];
  return d_Check_dclose(NONE, local5305_7096, local5307_7097, local5309_7098, local5311_7099);
}
static V lam_7103(V *env, V *args) {
  (void)env; (void)args;
  V local5313_7101 = args[0];
  V local5315_7102 = args[1];
  return d_Check_dinfer_uuniv(local5313_7101, local5315_7102);
}
static V lam_7108(V *env, V *args) {
  (void)env; (void)args;
  V local5317_7104 = args[0];
  V local5319_7105 = args[1];
  V local5321_7106 = args[2];
  V local5323_7107 = args[3];
  return d_Conv_dconv(UNIT, UNIT, d_Check_dops(), local5317_7104, local5319_7105, local5321_7106, local5323_7107);
}
static V lam_7112(V *env, V *args) {
  (void)env; (void)args;
  V local5325_7109 = args[0];
  V local5327_7110 = args[1];
  V local5329_7111 = args[2];
  return d_Conv_dconv_utype(UNIT, UNIT, d_Check_dops(), local5325_7109, local5327_7110, local5329_7111);
}
static V lam_7115(V *env, V *args) {
  (void)env; (void)args;
  V local5331_7113 = args[0];
  V local5333_7114 = args[1];
  return d_Eval_deval(d_Get_dCheck_dCtx_dglobals(local5331_7113), d_Get_dCheck_dCtx_denv(local5331_7113), local5333_7114);
}
static V lam_7118(V *env, V *args) {
  (void)env; (void)args;
  V local5335_7116 = args[0];
  V local5337_7117 = args[1];
  return d_Eval_dwhnf(d_Get_dCheck_dCtx_dglobals(local5335_7116), local5337_7117);
}
static V lam_7123(V *env, V *args) {
  (void)env; (void)args;
  V local5339_7119 = args[0];
  V local5341_7120 = args[1];
  V local5343_7121 = args[2];
  V local5345_7122 = args[3];
  return d_Check_dbind(local5339_7119, local5341_7120, local5343_7121, local5345_7122);
}
static V lam_7125(V *env, V *args) {
  (void)env; (void)args;
  V local5347_7124 = args[0];
  return d_Get_dCheck_dCtx_dsize(local5347_7124);
}
static V lam_7127(V *env, V *args) {
  (void)env; (void)args;
  V local5349_7126 = args[0];
  return d_Get_dCheck_dCtx_denv(local5349_7126);
}
static V lam_7129(V *env, V *args) {
  (void)env; (void)args;
  V local5351_7128 = args[0];
  return d_Eval_dev(d_Get_dCheck_dCtx_dglobals(local5351_7128));
}
static V lam_7132(V *env, V *args) {
  (void)env; (void)args;
  V local5353_7130 = args[0];
  V local5355_7131 = args[1];
  return d_Check_dpp_uvalue(local5353_7130, local5355_7131);
}
static V lam_7135(V *env, V *args) {
  (void)env; (void)args;
  V local5357_7133 = args[0];
  V local5359_7134 = args[1];
  return d_Eval_dquote(d_Get_dCheck_dCtx_dglobals(local5357_7133), d_Get_dCheck_dCtx_dsize(local5357_7133), local5359_7134);
}
static V lam_7138(V *env, V *args) {
  (void)env; (void)args;
  V local5361_7136 = args[0];
  V local5363_7137 = args[1];
  return d_Check_dhead_uty(local5361_7136, local5363_7137);
}
static V lam_7141(V *env, V *args) {
  (void)env; (void)args;
  V local5365_7139 = args[0];
  V local5367_7140 = args[1];
  return d_Global_dfind_ufamily(local5367_7140, d_Get_dCheck_dCtx_dglobals(local5365_7139));
}
static Str S_175 = {TAG_STR, 15, {(const uint8_t *)"the definition "}};
static Str S_176 = {TAG_STR, 12, {(const uint8_t *)" has no body"}};
static V lam_7204(V *env, V *args) {
  (void)env; (void)args;
  V local6265_7193 = args[0];
  V local6267_7194 = args[1];
  return ({ V t_7195 = local6265_7193; V _r; if (tag_of(t_7195) == 0) _r = t_7195; else { V bound6269_7196 = FLD(t_7195, 0); _r = ({ V _r = 0; V m_7197 = bound6269_7196; if ((tag_of(m_7197) == 0)) { V _m_7197_a0_7198 = FLD(m_7197, 0); V _m_7197_a1_7199 = FLD(m_7197, 1); _r = ({ V p6270_7200 = _m_7197_a0_7198; ({ V p6271_7201 = _m_7197_a1_7199; ({ V t_7202 = d_Check_dcheck_udecl(p6270_7200, env[0], local6267_7194); V _r; if (tag_of(t_7202) == 0) _r = t_7202; else { V bound6273_7203 = FLD(t_7202, 0); _r = DONE(rt_ctor2(0, d_Global_dadd(d_Get_dCheck_dDecl_dd_uname(local6267_7194), bound6273_7203, p6270_7200), CON(rt_ctor2(0, d_Get_dCheck_dDecl_dd_uname(local6267_7194), bound6273_7203), p6271_7201))); } _r; }); }); }); } else rt_panic("match: no case at kernel:3376"); _r; }); } _r; });
}
static V lam_7247(V *env, V *args) {
  (void)env; (void)args;
  V local6480_7219 = args[0];
  V local6482_7220 = args[1];
  return ({ V scrut6483_7221 = local6482_7220; ({ V _r = 0; V m_7222 = scrut6483_7221; if ((tag_of(m_7222) == 0)) { V _m_7222_a0_7223 = FLD(m_7222, 0); V _m_7222_a1_7224 = FLD(m_7222, 1); V _m_7222_a2_7225 = FLD(m_7222, 2); _r = ({ V p6484_7226 = _m_7222_a0_7223; ({ V p6485_7227 = _m_7222_a1_7224; ({ V p6486_7228 = _m_7222_a2_7225; ({ V _r = 0; V m_7229 = local6480_7219; switch (tag_of(m_7229)) { case 1: { V _m_7229_a0_7230 = FLD(m_7229, 0); _r = ({ V item6500_7231 = _m_7229_a0_7230; ({ V local6489_7232 = item6500_7231; ({ V _r = 0; V m_7233 = d_Check_dinfer_uuniv(local6489_7232, p6486_7228); switch (tag_of(m_7233)) { case 1: { V _m_7233_a0_7234 = FLD(m_7233, 0); _r = ({ V item6498_7235 = _m_7233_a0_7234; ({ V local6492_7236 = item6498_7235; ({ V _r = 0; V m_7237 = d_Eval_deval(d_Get_dCheck_dCtx_dglobals(local6489_7232), d_Get_dCheck_dCtx_denv(local6489_7232), p6486_7228); switch (tag_of(m_7237)) { case 1: { V _m_7237_a0_7238 = FLD(m_7237, 0); _r = ({ V item6496_7239 = _m_7237_a0_7238; ({ V local6495_7240 = item6496_7239; DONE(d_Check_dbind(p6485_7227, p6484_7226, local6495_7240, local6489_7232)); }); }); break; } case 0: { V _m_7237_a0_7241 = FLD(m_7237, 0); _r = ({ V item6497_7242 = _m_7237_a0_7241; FAIL(item6497_7242); }); break; } default: rt_panic("match: no case at kernel:3382"); } _r; }); }); }); break; } case 0: { V _m_7233_a0_7243 = FLD(m_7233, 0); _r = ({ V item6499_7244 = _m_7233_a0_7243; FAIL(item6499_7244); }); break; } default: rt_panic("match: no case at kernel:3382"); } _r; }); }); }); break; } case 0: { V _m_7229_a0_7245 = FLD(m_7229, 0); _r = ({ V item6501_7246 = _m_7229_a0_7245; FAIL(item6501_7246); }); break; } default: rt_panic("match: no case at kernel:3382"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3382"); _r; }); });
}
static Str S_177 = {TAG_STR, 10, {(const uint8_t *)"the index "}};
static Str S_178 = {TAG_STR, 16, {(const uint8_t *)" is at quantity "}};
static Str S_179 = {TAG_STR, 31, {(const uint8_t *)" and every index binder is at 0"}};
static Str S_180 = {TAG_STR, 10, {(const uint8_t *)" lives at "}};
static Str S_181 = {TAG_STR, 5, {(const uint8_t *)" and "}};
static Str S_182 = {TAG_STR, 16, {(const uint8_t *)" is declared at "}};
static V lam_7285(V *env, V *args) {
  (void)env; (void)args;
  V local6506_7270 = args[0];
  V local6508_7271 = args[1];
  return ({ V _r = 0; V m_7272 = local6506_7270; switch (tag_of(m_7272)) { case 1: { V _m_7272_a0_7273 = FLD(m_7272, 0); _r = ({ V item6526_7274 = _m_7272_a0_7273; ({ V local6511_7275 = item6526_7274; ({ V _r = 0; V m_7276 = d_Check_dindex_urules(local6511_7275, env[0], env[1], local6508_7271); switch (tag_of(m_7276)) { case 1: { V _m_7276_a0_7277 = FLD(m_7276, 0); _r = ({ V item6524_7278 = _m_7276_a0_7277; ({ V local6522_7279 = item6524_7278; ({ V scrut6523_7280 = local6522_7279; d_Check_dcheck_utelescope(local6511_7275, CON(local6508_7271, NIL)); }); }); }); break; } case 0: { V _m_7276_a0_7281 = FLD(m_7276, 0); _r = ({ V item6525_7282 = _m_7276_a0_7281; FAIL(item6525_7282); }); break; } default: rt_panic("match: no case at kernel:3395"); } _r; }); }); }); break; } case 0: { V _m_7272_a0_7283 = FLD(m_7272, 0); _r = ({ V item6527_7284 = _m_7272_a0_7283; FAIL(item6527_7284); }); break; } default: rt_panic("match: no case at kernel:3395"); } _r; });
}
static V lam_7291(V *env, V *args) {
  (void)env; (void)args;
  V a_7289 = args[0];
  V b_7290 = args[1];
  return d_NativeString_dorder(a_7289, b_7290);
}
static Str S_183 = {TAG_STR, 20, {(const uint8_t *)" is already declared"}};
static V lam_7370(V *env, V *args) {
  (void)env; (void)args;
  V local6728_7369 = args[0];
  return d_Local_dTerm_doccurs_df6699(env[0], env[1], local6728_7369);
}
static V lam_7433(V *env, V *args) {
  (void)env; (void)args;
  V local6773_7432 = args[0];
  return d_Local_dTerm_doccurs_df6699(env[0], env[1], local6773_7432);
}
static V lam_7448(V *env, V *args) {
  (void)env; (void)args;
  V local6793_7439 = args[0];
  return ({ V scrut6794_7440 = local6793_7439; ({ V _r = 0; V m_7441 = scrut6794_7440; if ((tag_of(m_7441) == 0)) { V _m_7441_a0_7442 = FLD(m_7441, 0); V _m_7441_a1_7443 = FLD(m_7441, 1); _r = ({ V p6795_7444 = _m_7441_a0_7442; ({ V p6796_7445 = _m_7441_a1_7443; ((({ V local6799_7446 = p6795_7444; d_Local_dTerm_doccurs_uaddr_df6701(env[0], env[1], local6799_7446); })) != FALSE_V ? TRUE_V : ({ V local6802_7447 = p6796_7445; d_Local_dTerm_doccurs_uleg_df6702(env[0], env[1], local6802_7447); })); }); }); } else rt_panic("match: no case at kernel:3433"); _r; }); });
}
static V lam_7455(V *env, V *args) {
  (void)env; (void)args;
  V local6814_7454 = args[0];
  return d_Local_dTerm_doccurs_uleg_df6702(env[0], env[1], local6814_7454);
}
static V lam_7496(V *env, V *args) {
  (void)env; (void)args;
  V local6697_7495 = args[0];
  return d_NativeString_dequal(env[0], local6697_7495);
}
static V lam_7497(V *env, V *args) {
  (void)env; (void)args;
  V local6694_7494 = args[0];
  return d_SeqList_dexists(({ V _c = clo_new(lam_7496, 1, 1); CLO_ENV(_c)[0] = local6694_7494; _c; }), env[0]);
}
static V lam_7512(V *env, V *args) {
  (void)env; (void)args;
  V local6688_7503 = args[0];
  return ({ V scrut6689_7504 = local6688_7503; ({ V _r = 0; V m_7505 = scrut6689_7504; if ((tag_of(m_7505) == 0)) { V _m_7505_a0_7506 = FLD(m_7505, 0); V _m_7505_a1_7507 = FLD(m_7505, 1); V _m_7505_a2_7508 = FLD(m_7505, 2); _r = ({ V p6690_7509 = _m_7505_a0_7506; ({ V p6691_7510 = _m_7505_a1_7507; ({ V p6692_7511 = _m_7505_a2_7508; d_Positivity_doccurs(env[0], p6692_7511); }); }); }); } else rt_panic("match: no case at kernel:3444"); _r; }); });
}
static V lam_7576(V *env, V *args) {
  (void)env; (void)args;
  V local6905_7575 = args[0];
  return d_NativeString_dequal(env[0], local6905_7575);
}
static V lam_7580(V *env, V *args) {
  (void)env; (void)args;
  V local6908_7579 = args[0];
  return d_Positivity_doccurs(env[0], local6908_7579);
}
static V lam_7705(V *env, V *args) {
  (void)env; (void)args;
  V local6884_7693 = args[0];
  V local6886_7694 = args[1];
  return ({ V scrut6887_7695 = local6886_7694; ({ V _r = 0; V m_7696 = scrut6887_7695; if ((tag_of(m_7696) == 0)) { V _m_7696_a0_7697 = FLD(m_7696, 0); V _m_7696_a1_7698 = FLD(m_7696, 1); V _m_7696_a2_7699 = FLD(m_7696, 2); _r = ({ V p6888_7700 = _m_7696_a0_7697; ({ V p6889_7701 = _m_7696_a1_7698; ({ V p6890_7702 = _m_7696_a2_7699; ({ V t_7703 = local6884_7693; V _r; if (tag_of(t_7703) == 0) _r = t_7703; else { V bound6892_7704 = FLD(t_7703, 0); _r = d_Positivity_dpositive(env[0], p6890_7702); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3475"); _r; }); });
}
static Str S_184 = {TAG_STR, 11, {(const uint8_t *)"a field of "}};
static Str S_185 = {TAG_STR, 28, {(const uint8_t *)" exceeds its family universe"}};
static V lam_7740(V *env, V *args) {
  (void)env; (void)args;
  V local6648_7711 = args[0];
  V local6650_7712 = args[1];
  return ({ V scrut6651_7713 = local6650_7712; ({ V _r = 0; V m_7714 = scrut6651_7713; if ((tag_of(m_7714) == 0)) { V _m_7714_a0_7715 = FLD(m_7714, 0); V _m_7714_a1_7716 = FLD(m_7714, 1); V _m_7714_a2_7717 = FLD(m_7714, 2); _r = ({ V p6652_7718 = _m_7714_a0_7715; ({ V p6653_7719 = _m_7714_a1_7716; ({ V p6654_7720 = _m_7714_a2_7717; ({ V _r = 0; V m_7721 = local6648_7711; switch (tag_of(m_7721)) { case 1: { V _m_7721_a0_7722 = FLD(m_7721, 0); _r = ({ V item6669_7723 = _m_7721_a0_7722; ({ V local6657_7724 = item6669_7723; ({ V _r = 0; V m_7725 = d_Check_dinfer_uuniv(local6657_7724, p6654_7720); switch (tag_of(m_7725)) { case 1: { V _m_7725_a0_7726 = FLD(m_7725, 0); _r = ({ V item6667_7727 = _m_7725_a0_7726; ({ V local6660_7728 = item6667_7727; ({ V _r = 0; V m_7729 = ((d_Level_dle(local6660_7728, d_Get_dPositivity_dFamily_df_ulevel(env[0]))) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(5, str_append(((V)&S_184), str_append(d_Get_dCheck_dCtor_udecl_dct_uname(env[1]), ((V)&S_185)))))); switch (tag_of(m_7729)) { case 1: { V _m_7729_a0_7730 = FLD(m_7729, 0); _r = ({ V item6665_7731 = _m_7729_a0_7730; ({ V local6663_7732 = item6665_7731; ({ V scrut6664_7733 = local6663_7732; d_Check_dcheck_utelescope(local6657_7724, CON(rt_ctor3(0, p6652_7718, p6653_7719, p6654_7720), NIL)); }); }); }); break; } case 0: { V _m_7729_a0_7734 = FLD(m_7729, 0); _r = ({ V item6666_7735 = _m_7729_a0_7734; FAIL(item6666_7735); }); break; } default: rt_panic("match: no case at kernel:3481"); } _r; }); }); }); break; } case 0: { V _m_7725_a0_7736 = FLD(m_7725, 0); _r = ({ V item6668_7737 = _m_7725_a0_7736; FAIL(item6668_7737); }); break; } default: rt_panic("match: no case at kernel:3481"); } _r; }); }); }); break; } case 0: { V _m_7721_a0_7738 = FLD(m_7721, 0); _r = ({ V item6670_7739 = _m_7721_a0_7738; FAIL(item6670_7739); }); break; } default: rt_panic("match: no case at kernel:3481"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3481"); _r; }); });
}
static V lam_7750(V *env, V *args) {
  (void)env; (void)args;
  V local6853_7749 = args[0];
  return local6853_7749;
}
static V lam_7753(V *env, V *args) {
  (void)env; (void)args;
  V local6855_7751 = args[0];
  V local6857_7752 = args[1];
  return d_Check_dparameter_uat(d_NativeInt_dsub(d_NativeInt_dsub(d_NativeInt_dadd(env[0], env[1]), local6855_7751), d_Big_done()), local6857_7752);
}
static Str S_186 = {TAG_STR, 36, {(const uint8_t *)" must preserve its family parameters"}};
static Str S_187 = {TAG_STR, 18, {(const uint8_t *)"the parameters of "}};
static Str S_188 = {TAG_STR, 22, {(const uint8_t *)"the result indices of "}};
static Str S_189 = {TAG_STR, 20, {(const uint8_t *)"the constructors of "}};
static Str S_190 = {TAG_STR, 22, {(const uint8_t *)" are already installed"}};
static V lam_7802(V *env, V *args) {
  (void)env; (void)args;
  V local6639_7796 = args[0];
  V local6641_7797 = args[1];
  return ({ V t_7798 = local6639_7796; V _r; if (tag_of(t_7798) == 0) _r = t_7798; else { V bound6643_7799 = FLD(t_7798, 0); _r = ({ V t_7800 = d_Check_dcheck_uctor(env[0], env[1], env[2], local6641_7797); V _r; if (tag_of(t_7800) == 0) _r = t_7800; else { V bound6645_7801 = FLD(t_7800, 0); _r = DONE(list_append(bound6643_7799, CON(bound6645_7801, NIL))); } _r; }); } _r; });
}
static V lam_7805(V *env, V *args) {
  (void)env; (void)args;
  V local6637_7804 = args[0];
  return d_Get_dCheck_dCtor_udecl_dct_uname(local6637_7804);
}
static V w_Order_dok_uboth(V *env, V *args) {
  (void)env; (void)args;
  return d_Order_dok_uboth(args[0], args[1]);
}
static V lam_7931(V *env, V *args) {
  (void)env; (void)args;
  V local7264_7927 = args[0];
  return ({ V local7269_7928 = env[0]; ({ V local7271_7929 = env[1]; ({ V local7273_7930 = local7264_7927; d_Local_dOrder_dok_df7230(env[2], env[3], env[4], local7269_7928, local7271_7929, local7273_7930); }); }); });
}
static V lam_8016(V *env, V *args) {
  (void)env; (void)args;
  V local7452_8014 = args[0];
  V local7454_8015 = args[1];
  return CON(env[0], local7452_8014);
}
static V lam_8041(V *env, V *args) {
  (void)env; (void)args;
  V local7409_8033 = args[0];
  return ({ V local7412_8034 = env[0]; ({ V _r = 0; V m_8035 = local7412_8034; if (((m_8035) == NONE)) {  _r = ({ V __8036 = UNIT; env[1]; }); } else if (((m_8035) != NONE)) { V _m_8035_a0_8037 = FLD(m_8035, 0); _r = ({ V value_8038 = _m_8035_a0_8037; ({ V local7414_8039 = value_8038; ({ V scrut7415_8040 = UNIT; ((env[2]) != FALSE_V ? CON(rt_ctor2(0, local7414_8039, d_Term_das_uactor(local7409_8033)), env[1]) : env[1]); }); }); }); } else rt_panic("match: no case at kernel:3553"); _r; }); });
}
static V lam_8052(V *env, V *args) {
  (void)env; (void)args;
  V local7423_8050 = args[0];
  V local7425_8051 = args[1];
  return CON(((V)2), local7423_8050);
}
static V lam_8070(V *env, V *args) {
  (void)env; (void)args;
  V local7438_8057 = args[0];
  return ({ V scrut7439_8058 = local7438_8057; ({ V _r = 0; V m_8059 = scrut7439_8058; if ((tag_of(m_8059) == 0)) { V _m_8059_a0_8060 = FLD(m_8059, 0); V _m_8059_a1_8061 = FLD(m_8059, 1); _r = ({ V p7440_8062 = _m_8059_a0_8060; ({ V p7441_8063 = _m_8059_a1_8061; d_Order_dok_uall(CON(({ V local7446_8064 = env[0]; ({ V local7448_8065 = env[1]; ({ V local7450_8066 = p7440_8062; d_Local_dOrder_daddr_uok_df7232(env[2], env[3], env[4], local7446_8064, local7448_8065, local7450_8066); }); }); }), CON(({ V local7459_8067 = d_Order_dunder(env[5], d_Get_dTerm_dLeg_dl_ubinders(p7441_8063), env[0]); ({ V local7461_8068 = ap(env[6], p7440_8062); ({ V local7463_8069 = d_Get_dTerm_dLeg_dl_ubody(p7441_8063); d_Local_dOrder_dok_df7230(env[2], env[3], env[4], local7459_8067, local7461_8068, local7463_8069); }); }); }), NIL))); }); }); } else rt_panic("match: no case at kernel:3558"); _r; }); });
}
static V lam_8156(V *env, V *args) {
  (void)env; (void)args;
  V local7682_8155 = args[0];
  return d_NativeString_dequal(env[0], local7682_8155);
}
static V lam_8256(V *env, V *args) {
  (void)env; (void)args;
  V local7687_8252 = args[0];
  return ({ V local7692_8253 = env[0]; ({ V local7694_8254 = env[1]; ({ V local7696_8255 = local7687_8252; d_Local_dOrder_dshape_uok_df7231(env[2], env[3], env[4], local7692_8253, local7694_8254, local7696_8255); }); }); });
}
static V lam_8261(V *env, V *args) {
  (void)env; (void)args;
  V local7699_8257 = args[0];
  return ({ V local7704_8258 = env[0]; ({ V local7706_8259 = env[1]; ({ V local7708_8260 = local7699_8257; d_Local_dOrder_dok_df7230(env[2], env[3], env[4], local7704_8258, local7706_8259, local7708_8260); }); }); });
}
static V lam_8310(V *env, V *args) {
  (void)env; (void)args;
  V local7356_8306 = args[0];
  return ({ V local7361_8307 = env[0]; ({ V local7363_8308 = env[1]; ({ V local7365_8309 = local7356_8306; d_Local_dOrder_dok_df7230(env[2], env[3], env[4], local7361_8307, local7363_8308, local7365_8309); }); }); });
}
static V lam_8327(V *env, V *args) {
  (void)env; (void)args;
  V local7499_8323 = args[0];
  return ({ V local7504_8324 = env[0]; ({ V local7506_8325 = env[1]; ({ V local7508_8326 = local7499_8323; d_Local_dOrder_dleg_uok_df7233(env[2], env[3], env[4], local7504_8324, local7506_8325, local7508_8326); }); }); });
}
static V lam_8388(V *env, V *args) {
  (void)env; (void)args;
  V local7174_8375 = args[0];
  V local7176_8376 = args[1];
  return ({ V local7179_8377 = d_Order_dstatus_uat(local7174_8375, local7176_8376); ({ V _r = 0; V m_8378 = local7179_8377; if (((m_8378) == NONE)) {  _r = ({ V __8379 = UNIT; FALSE_V; }); } else if (((m_8378) != NONE)) { V _m_8378_a0_8380 = FLD(m_8378, 0); _r = ({ V value_8381 = _m_8378_a0_8380; ({ V local7181_8382 = value_8381; ({ V scrut7182_8383 = local7181_8382; ({ V _r = 0; V m_8384 = scrut7182_8383; switch (tag_of(m_8384)) { case 0: {  _r = ({ V __8385 = UNIT; FALSE_V; }); break; } case 1: {  _r = ({ V __8386 = UNIT; TRUE_V; }); break; } case 2: {  _r = ({ V __8387 = UNIT; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:3585"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3584"); _r; }); });
}
static V lam_8403(V *env, V *args) {
  (void)env; (void)args;
  V local7185_8390 = args[0];
  V local7187_8391 = args[1];
  return ({ V local7190_8392 = d_Order_dstatus_uat(local7185_8390, local7187_8391); ({ V _r = 0; V m_8393 = local7190_8392; if (((m_8393) == NONE)) {  _r = ({ V __8394 = UNIT; FALSE_V; }); } else if (((m_8393) != NONE)) { V _m_8393_a0_8395 = FLD(m_8393, 0); _r = ({ V value_8396 = _m_8393_a0_8395; ({ V local7192_8397 = value_8396; ({ V scrut7193_8398 = local7192_8397; ({ V _r = 0; V m_8399 = scrut7193_8398; switch (tag_of(m_8399)) { case 0: {  _r = ({ V __8400 = UNIT; TRUE_V; }); break; } case 1: {  _r = ({ V __8401 = UNIT; TRUE_V; }); break; } case 2: {  _r = ({ V __8402 = UNIT; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:3587"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3586"); _r; }); });
}
static V lam_8465(V *env, V *args) {
  (void)env; (void)args;
  V local7196_8405 = args[0];
  V local7198_8406 = args[1];
  return ({ V local7201_8407 = d_Rules_dat(env[0], local7198_8406); ({ V _r = 0; V m_8408 = local7201_8407; if (((m_8408) == NONE)) {  _r = ({ V __8409 = UNIT; FALSE_V; }); } else if (((m_8408) != NONE)) { V _m_8408_a0_8410 = FLD(m_8408, 0); _r = ({ V value_8411 = _m_8408_a0_8410; ({ V local7203_8412 = value_8411; ({ V scrut7204_8413 = local7203_8412; ({ V _r = 0; V m_8414 = scrut7204_8413; switch (tag_of(m_8414)) { case 0: { V _m_8414_a0_8415 = FLD(m_8414, 0); _r = ({ V p7205_8416 = _m_8414_a0_8415; ap2(env[1], local7196_8405, p7205_8416); }); break; } case 1: { V _m_8414_a0_8417 = FLD(m_8414, 0); _r = ({ V p7206_8418 = _m_8414_a0_8417; FALSE_V; }); break; } case 2: { V _m_8414_a0_8419 = FLD(m_8414, 0); V _m_8414_a1_8420 = FLD(m_8414, 1); _r = ({ V p7207_8421 = _m_8414_a0_8419; ({ V p7208_8422 = _m_8414_a1_8420; FALSE_V; }); }); break; } case 3: { V _m_8414_a0_8423 = FLD(m_8414, 0); V _m_8414_a1_8424 = FLD(m_8414, 1); _r = ({ V p7209_8425 = _m_8414_a0_8423; ({ V p7210_8426 = _m_8414_a1_8424; FALSE_V; }); }); break; } case 4: { V _m_8414_a0_8427 = FLD(m_8414, 0); V _m_8414_a1_8428 = FLD(m_8414, 1); V _m_8414_a2_8429 = FLD(m_8414, 2); _r = ({ V p7211_8430 = _m_8414_a0_8427; ({ V p7212_8431 = _m_8414_a1_8428; ({ V p7213_8432 = _m_8414_a2_8429; FALSE_V; }); }); }); break; } case 5: { V _m_8414_a0_8433 = FLD(m_8414, 0); _r = ({ V p7214_8434 = _m_8414_a0_8433; FALSE_V; }); break; } case 6: { V _m_8414_a0_8435 = FLD(m_8414, 0); V _m_8414_a1_8436 = FLD(m_8414, 1); _r = ({ V p7215_8437 = _m_8414_a0_8435; ({ V p7216_8438 = _m_8414_a1_8436; FALSE_V; }); }); break; } case 7: { V _m_8414_a0_8439 = FLD(m_8414, 0); V _m_8414_a1_8440 = FLD(m_8414, 1); V _m_8414_a2_8441 = FLD(m_8414, 2); _r = ({ V p7217_8442 = _m_8414_a0_8439; ({ V p7218_8443 = _m_8414_a1_8440; ({ V p7219_8444 = _m_8414_a2_8441; ({ V scrut7220_8445 = env[2]; ({ V _r = 0; V m_8446 = scrut7220_8445; if ((tag_of(m_8446) == 0)) {  _r = ({ V __8447 = UNIT; FALSE_V; }); } else rt_panic("match: no case at kernel:3590"); _r; }); }); }); }); }); break; } case 8: { V _m_8414_a0_8448 = FLD(m_8414, 0); V _m_8414_a1_8449 = FLD(m_8414, 1); V _m_8414_a2_8450 = FLD(m_8414, 2); V _m_8414_a3_8451 = FLD(m_8414, 3); _r = ({ V p7221_8452 = _m_8414_a0_8448; ({ V p7222_8453 = _m_8414_a1_8449; ({ V p7223_8454 = _m_8414_a2_8450; ({ V p7224_8455 = _m_8414_a3_8451; FALSE_V; }); }); }); }); break; } case 9: { V _m_8414_a0_8456 = FLD(m_8414, 0); V _m_8414_a1_8457 = FLD(m_8414, 1); _r = ({ V p7225_8458 = _m_8414_a0_8456; ({ V p7226_8459 = _m_8414_a1_8457; FALSE_V; }); }); break; } case 10: { V _m_8414_a0_8460 = FLD(m_8414, 0); _r = ({ V p7227_8461 = _m_8414_a0_8460; FALSE_V; }); break; } case 11: { V _m_8414_a0_8462 = FLD(m_8414, 0); _r = ({ V p7228_8463 = _m_8414_a0_8462; FALSE_V; }); break; } case 12: {  _r = ({ V __8464 = UNIT; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:3589"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3588"); _r; }); });
}
static V lam_8468(V *env, V *args) {
  (void)env; (void)args;
  V local7237_8467 = args[0];
  return ((d_Big_dis_ueq(local7237_8467, d_NativeInt_dsub(d_NativeInt_dsub(env[0], d_Big_done()), env[1]))) != FALSE_V ? ((V)0) : ((V)2));
}
static V lam_8488(V *env, V *args) {
  (void)env; (void)args;
  V local7784_8475 = args[0];
  V local7786_8476 = args[1];
  return ({ V scrut7787_8477 = local7786_8476; ({ V _r = 0; V m_8478 = scrut7787_8477; if ((tag_of(m_8478) == 0)) { V _m_8478_a0_8479 = FLD(m_8478, 0); V _m_8478_a1_8480 = FLD(m_8478, 1); _r = ({ V p7788_8481 = _m_8478_a0_8479; ({ V p7789_8482 = _m_8478_a1_8480; ({ V _r = 0; V m_8483 = local7784_8475; if (((m_8483) == NONE)) {  _r = ({ V __8484 = UNIT; SOME(p7788_8481); }); } else if (((m_8483) != NONE)) { V _m_8483_a0_8485 = FLD(m_8483, 0); _r = ({ V value_8486 = _m_8483_a0_8485; ({ V local7792_8487 = value_8486; SOME(local7792_8487); }); }); } else rt_panic("match: no case at kernel:3596"); _r; }); }); }); } else rt_panic("match: no case at kernel:3596"); _r; }); });
}
static V lam_8503(V *env, V *args) {
  (void)env; (void)args;
  V local7808_8501 = args[0];
  return ({ V local7811_8502 = d_NativeInt_dadd(env[0], d_Big_done()); d_Local_dOrder_dfirst_ufit_df7774(env[1], env[2], env[3], env[4], local7811_8502); });
}
static V lam_8508(V *env, V *args) {
  (void)env; (void)args;
  V local7815_8507 = args[0];
  return DONE(rt_ctor3(0, env[0], env[1], env[2]));
}
static V lam_8509(V *env, V *args) {
  (void)env; (void)args;
  V local7800_8496 = args[0];
  return ({ V local7804_8497 = ap(env[0], env[1]); ({ V local7806_8498 = local7800_8496; ap(({ V _r = 0; V m_8499 = local7804_8497; if (((m_8499) == NONE)) {  _r = ({ V __8500 = UNIT; ({ V _c = clo_new(lam_8503, 1, 5); CLO_ENV(_c)[0] = env[1]; CLO_ENV(_c)[1] = env[2]; CLO_ENV(_c)[2] = env[3]; CLO_ENV(_c)[3] = env[4]; CLO_ENV(_c)[4] = env[0]; _c; }); }); } else if (((m_8499) != NONE)) { V _m_8499_a0_8504 = FLD(m_8499, 0); _r = ({ V value_8505 = _m_8499_a0_8504; ({ V local7813_8506 = value_8505; ({ V _c = clo_new(lam_8508, 1, 3); CLO_ENV(_c)[0] = env[4]; CLO_ENV(_c)[1] = env[1]; CLO_ENV(_c)[2] = local7813_8506; _c; }); }); }); } else rt_panic("match: no case at kernel:3600"); _r; }), local7806_8498); }); });
}
static V lam_8520(V *env, V *args) {
  (void)env; (void)args;
  V local7078_8519 = args[0];
  return d_Get_dTuple2_dv0(local7078_8519);
}
static V lam_8535(V *env, V *args) {
  (void)env; (void)args;
  V local7081_8522 = args[0];
  return ({ V scrut7082_8523 = local7081_8522; ({ V _r = 0; V m_8524 = scrut7082_8523; if ((tag_of(m_8524) == 0)) { V _m_8524_a0_8525 = FLD(m_8524, 0); V _m_8524_a1_8526 = FLD(m_8524, 1); _r = ({ V p7083_8527 = _m_8524_a0_8525; ({ V p7084_8528 = _m_8524_a1_8526; ({ V scrut7140_8529 = d_Order_dpeel(d_Big_dzero(), p7084_8528); ({ V _r = 0; V m_8530 = scrut7140_8529; if ((tag_of(m_8530) == 0)) { V _m_8530_a0_8531 = FLD(m_8530, 0); V _m_8530_a1_8532 = FLD(m_8530, 1); _r = ({ V p7141_8533 = _m_8530_a0_8531; ({ V p7142_8534 = _m_8530_a1_8532; rt_ctor3(0, p7083_8527, p7141_8533, p7142_8534); }); }); } else rt_panic("match: no case at kernel:3608"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3607"); _r; }); });
}
static V lam_8554(V *env, V *args) {
  (void)env; (void)args;
  V local7145_8538 = args[0];
  V local7147_8539 = args[1];
  return ({ V scrut7148_8540 = local7147_8539; ({ V _r = 0; V m_8541 = scrut7148_8540; if ((tag_of(m_8541) == 0)) { V _m_8541_a0_8542 = FLD(m_8541, 0); V _m_8541_a1_8543 = FLD(m_8541, 1); V _m_8541_a2_8544 = FLD(m_8541, 2); _r = ({ V p7149_8545 = _m_8541_a0_8542; ({ V p7150_8546 = _m_8541_a1_8543; ({ V p7151_8547 = _m_8541_a2_8544; ((((d_Order_dmentions(env[0], p7151_8547)) ^ 1u)) != FALSE_V ? local7145_8538 : ({ V local7154_8548 = local7145_8538; ({ V _r = 0; V m_8549 = local7154_8548; if (((m_8549) == NONE)) {  _r = ({ V __8550 = UNIT; SOME(p7150_8546); }); } else if (((m_8549) != NONE)) { V _m_8549_a0_8551 = FLD(m_8549, 0); _r = ({ V value_8552 = _m_8549_a0_8551; ({ V local7156_8553 = value_8552; SOME(((d_Big_dis_ult(local7156_8553, p7150_8546)) != FALSE_V ? local7156_8553 : p7150_8546)); }); }); } else rt_panic("match: no case at kernel:3610"); _r; }); })); }); }); }); } else rt_panic("match: no case at kernel:3610"); _r; }); });
}
static V lam_8578(V *env, V *args) {
  (void)env; (void)args;
  V local7164_8557 = args[0];
  V local7166_8558 = args[1];
  return ({ V scrut7167_8559 = local7166_8558; ({ V _r = 0; V m_8560 = scrut7167_8559; if ((tag_of(m_8560) == 0)) { V _m_8560_a0_8561 = FLD(m_8560, 0); V _m_8560_a1_8562 = FLD(m_8560, 1); V _m_8560_a2_8563 = FLD(m_8560, 2); _r = ({ V p7168_8564 = _m_8560_a0_8561; ({ V p7169_8565 = _m_8560_a1_8562; ({ V p7170_8566 = _m_8560_a2_8563; ({ V _r = 0; V m_8567 = local7164_8557; if (((m_8567) == NONE)) {  _r = ({ V __8568 = UNIT; NONE; }); } else if (((m_8567) != NONE)) { V _m_8567_a0_8569 = FLD(m_8567, 0); _r = ({ V item7772_8570 = _m_8567_a0_8569; ({ V local7172_8571 = item7772_8570; ({ V local7766_8572 = d_Order_dpasses(env[0], env[1], env[2], p7169_8565, p7170_8566); ({ V _r = 0; V m_8573 = local7766_8572; if (((m_8573) == NONE)) {  _r = ({ V __8574 = UNIT; NONE; }); } else if (((m_8573) != NONE)) { V _m_8573_a0_8575 = FLD(m_8573, 0); _r = ({ V item7770_8576 = _m_8573_a0_8575; SOME(({ V local7768_8577 = item7770_8576; list_append(local7172_8571, CON(rt_ctor2(0, p7168_8564, local7768_8577), NIL)); })); }); } else rt_panic("match: no case at kernel:3612"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3612"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3612"); _r; }); });
}
static V lam_8579(V *env, V *args) {
  (void)env; (void)args;
  V local7162_8556 = args[0];
  return d_SeqList_dfold(({ V _c = clo_new(lam_8578, 2, 3); CLO_ENV(_c)[0] = env[0]; CLO_ENV(_c)[1] = env[1]; CLO_ENV(_c)[2] = local7162_8556; _c; }), env[2], SOME(NIL));
}
static V lam_8588(V *env, V *args) {
  (void)env; (void)args;
  V local7821_8581 = args[0];
  return ({ V scrut7822_8582 = local7821_8581; ({ V _r = 0; V m_8583 = scrut7822_8582; if ((tag_of(m_8583) == 0)) { V _m_8583_a0_8584 = FLD(m_8583, 0); V _m_8583_a1_8585 = FLD(m_8583, 1); _r = ({ V p7823_8586 = _m_8583_a0_8584; ({ V p7824_8587 = _m_8583_a1_8585; d_Order_dmentions(env[0], p7824_8587); }); }); } else rt_panic("match: no case at kernel:3615"); _r; }); });
}
static Str S_191 = {TAG_STR, 32, {(const uint8_t *)"the totality budget is exhausted"}};
static V lam_8607(V *env, V *args) {
  (void)env; (void)args;
  V local7844_8599 = args[0];
  return ({ V _r = 0; V m_8600 = d_Totality_dspend(env[0], local7844_8599); switch (tag_of(m_8600)) { case 1: { V _m_8600_a0_8601 = FLD(m_8600, 0); _r = ({ V item7848_8602 = _m_8600_a0_8601; DONE(({ V local7846_8603 = item7848_8602; ({ V scrut7847_8604 = local7846_8603; local7844_8599; }); })); }); break; } case 0: { V _m_8600_a0_8605 = FLD(m_8600, 0); _r = ({ V item7849_8606 = _m_8600_a0_8605; FAIL(item7849_8606); }); break; } default: rt_panic("match: no case at kernel:3621"); } _r; });
}
static V lam_8642(V *env, V *args) {
  (void)env; (void)args;
  V local7884_8630 = args[0];
  V local7886_8631 = args[1];
  return ({ V scrut7887_8632 = local7886_8631; ({ V _r = 0; V m_8633 = scrut7887_8632; if ((tag_of(m_8633) == 0)) { V _m_8633_a0_8634 = FLD(m_8633, 0); V _m_8633_a1_8635 = FLD(m_8633, 1); _r = ({ V p7888_8636 = _m_8633_a0_8634; ({ V p7889_8637 = _m_8633_a1_8635; ({ V t_8638 = local7884_8630; V _r; if (tag_of(t_8638) == 0) _r = t_8638; else { V bound7891_8639 = FLD(t_8638, 0); _r = ({ V t_8640 = d_Totality_dspend_uaddr(env[0], p7888_8636); V _r; if (tag_of(t_8640) == 0) _r = t_8640; else { V bound7893_8641 = FLD(t_8640, 0); _r = d_Totality_dspend(env[0], d_Get_dTerm_dLeg_dl_ubody(p7889_8637)); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:3630"); _r; }); });
}
static V lam_8702(V *env, V *args) {
  (void)env; (void)args;
  V local7904_8701 = args[0];
  return d_Get_dTerm_dLeg_dl_ubody(local7904_8701);
}
static V lam_8750(V *env, V *args) {
  (void)env; (void)args;
  V local7831_8746 = args[0];
  V local7833_8747 = args[1];
  return ({ V t_8748 = local7831_8746; V _r; if (tag_of(t_8748) == 0) _r = t_8748; else { V bound7835_8749 = FLD(t_8748, 0); _r = d_Totality_dspend(env[0], local7833_8747); } _r; });
}
static V lam_8763(V *env, V *args) {
  (void)env; (void)args;
  V local7829_8762 = args[0];
  return d_Get_dTuple2_dv1(local7829_8762);
}
static V lam_8791(V *env, V *args) {
  (void)env; (void)args;
  V local7980_8783 = args[0];
  V local7982_8784 = args[1];
  return ({ V scrut7983_8785 = local7982_8784; ({ V _r = 0; V m_8786 = scrut7983_8785; if ((tag_of(m_8786) == 0)) { V _m_8786_a0_8787 = FLD(m_8786, 0); V _m_8786_a1_8788 = FLD(m_8786, 1); _r = ({ V p7984_8789 = _m_8786_a0_8787; ({ V p7985_8790 = _m_8786_a1_8788; rt_ctor2(6, p7984_8789, CON(rt_ctor2(0, d_Get_dTerm_dLeg_dl_ubinders(p7985_8790), local7980_8783), NIL)); }); }); } else rt_panic("match: no case at kernel:3685"); _r; }); });
}
static Str S_192 = {TAG_STR, 89, {(const uint8_t *)"every branch of the elimination of a structurally recursive definition keys a constructor"}};
static Str S_193 = {TAG_STR, 73, {(const uint8_t *)"the elimination of a structurally recursive definition carries its motive"}};
static Str S_194 = {TAG_STR, 93, {(const uint8_t *)"a structurally recursive definition eliminates its recursive argument at the head of its body"}};
static V lam_8892(V *env, V *args) {
  (void)env; (void)args;
  V local8010_8876 = args[0];
  V local8012_8877 = args[1];
  return ({ V scrut8013_8878 = local8012_8877; ({ V _r = 0; V m_8879 = scrut8013_8878; if ((tag_of(m_8879) == 0)) { V _m_8879_a0_8880 = FLD(m_8879, 0); V _m_8879_a1_8881 = FLD(m_8879, 1); _r = ({ V p8014_8882 = _m_8879_a0_8880; ({ V p8015_8883 = _m_8879_a1_8881; ({ V t_8884 = local8010_8876; V _r; if (tag_of(t_8884) == 0) _r = t_8884; else { V bound8017_8885 = FLD(t_8884, 0); _r = ({ V local8020_8886 = d_Term_das_uactor(p8014_8882); ({ V _r = 0; V m_8887 = local8020_8886; if (((m_8887) == NONE)) {  _r = ({ V __8888 = UNIT; FAIL(rt_ctor1(7, d_Order_dctor_ukey_umsg())); }); } else if (((m_8887) != NONE)) { V _m_8887_a0_8889 = FLD(m_8887, 0); _r = ({ V value_8890 = _m_8887_a0_8889; ({ V local8022_8891 = value_8890; DONE(UNIT); }); }); } else rt_panic("match: no case at kernel:3713"); _r; }); }); } _r; }); }); }); } else rt_panic("match: no case at kernel:3711"); _r; }); });
}
static V lam_8915(V *env, V *args) {
  (void)env; (void)args;
  V local7993_8899 = args[0];
  V local7995_8900 = args[1];
  return ({ V t_8901 = local7993_8899; V _r; if (tag_of(t_8901) == 0) _r = t_8901; else { V bound7997_8902 = FLD(t_8901, 0); _r = ({ V local8000_8903 = d_Rules_dat(d_Big_dzero(), d_Get_dOrder_dCall_dcl_uchain(local7995_8900)); ({ V _r = 0; V m_8904 = local8000_8903; if (((m_8904) == NONE)) {  _r = ({ V __8905 = UNIT; FAIL(rt_ctor1(14, d_Get_dOrder_dRow_drw_umember(env[0]))); }); } else if (((m_8904) != NONE)) { V _m_8904_a0_8906 = FLD(m_8904, 0); _r = ({ V value_8907 = _m_8904_a0_8906; ({ V local8002_8908 = value_8907; ({ V local8005_8909 = d_Get_dOrder_dStep_dst_uctor(local8002_8908); ({ V _r = 0; V m_8910 = local8005_8909; if (((m_8910) == NONE)) {  _r = ({ V __8911 = UNIT; FAIL(rt_ctor1(14, d_Get_dOrder_dRow_drw_umember(env[0]))); }); } else if (((m_8910) != NONE)) { V _m_8910_a0_8912 = FLD(m_8910, 0); _r = ({ V value_8913 = _m_8910_a0_8912; ({ V local8007_8914 = value_8913; DONE(UNIT); }); }); } else rt_panic("match: no case at kernel:3719"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3719"); _r; }); }); } _r; });
}
static V lam_8916(V *env, V *args) {
  (void)env; (void)args;
  V local7987_8895 = args[0];
  V local7989_8896 = args[1];
  return ({ V t_8897 = local7987_8895; V _r; if (tag_of(t_8897) == 0) _r = t_8897; else { V bound7991_8898 = FLD(t_8897, 0); _r = d_SeqList_dfold(({ V _c = clo_new(lam_8915, 2, 1); CLO_ENV(_c)[0] = local7989_8896; _c; }), d_Get_dOrder_dRow_drw_ucalls(local7989_8896), DONE(UNIT)); } _r; });
}
static Str S_195 = {TAG_STR, 3, {(const uint8_t *)"Lan"}};
static Str S_196 = {TAG_STR, 3, {(const uint8_t *)"Ran"}};
static Str S_197 = {TAG_STR, 2, {(const uint8_t *)"In"}};
static Str S_198 = {TAG_STR, 4, {(const uint8_t *)"Elim"}};
static Str S_199 = {TAG_STR, 3, {(const uint8_t *)"Sec"}};
static Str S_200 = {TAG_STR, 3, {(const uint8_t *)"Out"}};
static Str S_201 = {TAG_STR, 3, {(const uint8_t *)"SPi"}};
static Str S_202 = {TAG_STR, 5, {(const uint8_t *)"SColl"}};
static Str S_203 = {TAG_STR, 4, {(const uint8_t *)"SPar"}};
static Str S_204 = {TAG_STR, 3, {(const uint8_t *)"SMu"}};
static Str S_205 = {TAG_STR, 3, {(const uint8_t *)"SNu"}};
static V lam_8980(V *env, V *args) {
  (void)env; (void)args;
  V local15917_8968 = args[0];
  return ({ V local15920_8969 = ({ V _r = 0; V m_8970 = d_Rules_drules(local15917_8968); switch (tag_of(m_8970)) { case 1: { V _m_8970_a0_8971 = FLD(m_8970, 0); _r = ({ V x_8972 = _m_8970_a0_8971; SOME(x_8972); }); break; } case 0: { V _m_8970_a0_8973 = FLD(m_8970, 0); _r = ({ V __8974 = _m_8970_a0_8973; NONE; }); break; } default: rt_panic("match: no case at kernel:3754"); } _r; }); ({ V _r = 0; V m_8975 = local15920_8969; if (((m_8975) == NONE)) {  _r = ({ V __8976 = UNIT; NONE; }); } else if (((m_8975) != NONE)) { V _m_8975_a0_8977 = FLD(m_8975, 0); _r = ({ V item15935_8978 = _m_8975_a0_8977; SOME(({ V local15922_8979 = item15935_8978; rt_ctor2(0, d_Shape_dname(local15917_8968), local15922_8979); })); }); } else rt_panic("match: no case at kernel:3754"); _r; }); });
}
static V lam_8982(V *env, V *args) {
  (void)env; (void)args;
  V local15915_8981 = args[0];
  return d_Get_dTuple2_dv0(local15915_8981);
}
static Str S_206 = {TAG_STR, 17, {(const uint8_t *)"proof-irrelevance"}};
static Str S_207 = {TAG_STR, 30, {(const uint8_t *)"subsingleton-large-elimination"}};
static Str S_208 = {TAG_STR, 17, {(const uint8_t *)"literal-fast-path"}};
static V lam_8990(V *env, V *args) {
  (void)env; (void)args;
  V local15953_8983 = args[0];
  return ({ V scrut15954_8984 = local15953_8983; ({ V _r = 0; V m_8985 = scrut15954_8984; if ((tag_of(m_8985) == 0)) { V _m_8985_a0_8986 = FLD(m_8985, 0); V _m_8985_a1_8987 = FLD(m_8985, 1); _r = ({ V p15955_8988 = _m_8985_a0_8986; ({ V p15956_8989 = _m_8985_a1_8987; rt_ctor2(0, p15955_8988, d_Get_dRules_dRule_upack_deta(p15956_8989)); }); }); } else rt_panic("match: no case at kernel:3767"); _r; }); });
}

V d_Big_dwhen(V test_1, V yes_2, V no_3) {
  return ({ V _r = 0; V m_4 = test_1; if (((m_4) == TRUE_V)) {  _r = ap(yes_2, UNIT); } else if (((m_4) == FALSE_V)) {  _r = ap(no_3, UNIT); } else rt_panic("match: no case at kernel:6"); _r; });
}
V d_Big_dbits_dcons(V bit_5, V tail_6) {
  return ({ V _r = 0; V m_7 = bit_5; V m_8 = tail_6; if (((m_7) == FALSE_V) && ((m_8) == NIL)) {  _r = NIL; } else if (1) { V b_9 = m_7; V t_10 = m_8; _r = CON(b_9, t_10); } else rt_panic("match: no case at kernel:10"); _r; });
}
V d_Big_dbits_dtrim(V bits_11) {
  return bits_trim(bits_11);
}
V d_Big_dsmall(V negative_12, V value_13) {
  return big_small(negative_12, value_13, 1, 0);
}
V d_Big_dmake(V negative_14, V bits_15) {
  return big_make(negative_14, bits_15, 1, 0);
}
V d_Big_dzero(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor2(1, FALSE_V, NAT_SMALL(0ull)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Big_done(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor2(1, FALSE_V, NAT_SMALL(1ull)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Big_dbits(V value_16) {
  return ({ V _r = 0; V m_17 = value_16; switch (tag_of(m_17)) { case 0: { V bits_18 = FLD(m_17, 1); _r = bits_18; break; } case 1: { V value_19 = FLD(m_17, 1); _r = d_Big_dbits_dof_unat(value_19); break; } default: rt_panic("match: no case at kernel:27"); } _r; });
}
V d_Big_dnegative(V value_20) {
  return ({ V _r = 0; V m_21 = value_20; switch (tag_of(m_21)) { case 0: { V negative_22 = FLD(m_21, 0); _r = negative_22; break; } case 1: { V negative_23 = FLD(m_21, 0); _r = negative_23; break; } default: rt_panic("match: no case at kernel:31"); } _r; });
}
V d_Big_dis_uzero(V value_24) {
  return ({ V _r = 0; V m_25 = value_24; switch (tag_of(m_25)) { case 0: { V bits_26 = FLD(m_25, 1); _r = ((V)((bits_26) == NIL)); break; } case 1: { V value_27 = FLD(m_25, 1); _r = ((V)(nat_cmp(value_27, NAT_SMALL(0ull)) == 0)); break; } default: rt_panic("match: no case at kernel:35"); } _r; });
}
V d_Big_dneg(V value_28) {
  return ({ V _r = 0; V m_29 = value_28; switch (tag_of(m_29)) { case 0: { V negative_30 = FLD(m_29, 0); V bits_31 = FLD(m_29, 1); _r = d_Big_dmake(((negative_30) ^ 1u), bits_31); break; } case 1: { V negative_32 = FLD(m_29, 0); V value_33 = FLD(m_29, 1); _r = d_Big_dsmall(((negative_32) ^ 1u), value_33); break; } default: rt_panic("match: no case at kernel:39"); } _r; });
}
V d_Big_dabs(V value_34) {
  return ({ V _r = 0; V m_35 = value_34; switch (tag_of(m_35)) { case 0: { V bits_36 = FLD(m_35, 1); _r = rt_ctor2(0, FALSE_V, bits_36); break; } case 1: { V value_37 = FLD(m_35, 1); _r = rt_ctor2(1, FALSE_V, value_37); break; } default: rt_panic("match: no case at kernel:43"); } _r; });
}
V d_Big_dbits_dcarry(V carry_38) {
  return ({ V _r = 0; V m_39 = carry_38; if (((m_39) == ((V)0u))) {  _r = NIL; } else if (1) {  _r = CON(TRUE_V, NIL); } else rt_panic("match: no case at kernel:47"); _r; });
}
V d_Big_dbits_dadd_udigit(V sum_40, V xs_41, V ys_42) {
  return CON(((V)((((sum_40) & (((V)1u)))) == (((V)1u)))), d_Big_dbits_dadd(xs_41, ys_42, u32_shrn(sum_40, NAT_SMALL(1ull))));
}
V d_Big_dbits_dadd(V xs_43, V ys_44, V carry_45) {
  return bits_add(xs_43, ys_44, carry_45);
}
V d_Big_dbits_dsub_udigit(V difference_46, V xs_47, V ys_48) {
  return d_Big_dbits_dcons(((V)((((difference_46) & (((V)1u)))) == (((V)1u)))), d_Big_dbits_dsub(xs_47, ys_48, (((V)((difference_46) < (((V)2u)))))));
}
V d_Big_dbits_dsub(V xs_49, V ys_50, V borrow_51) {
  return bits_sub(xs_49, ys_50, borrow_51);
}
V d_Big_dbits_dcmp_udigit(V a_52, V b_53, V tail_54) {
  return ({ V _r = 0; V m_55 = tail_54; if (((m_55) == 1)) {  _r = cmp_u(a_52, b_53); } else if (1) { V other_56 = m_55; _r = other_56; } else rt_panic("match: no case at kernel:72"); _r; });
}
V d_Big_dbits_dcmp(V xs_57, V ys_58) {
  return bits_cmp(xs_57, ys_58);
}
V d_Big_dorder_dflip(V order_59) {
  return ({ V _r = 0; V m_60 = order_59; if (((m_60) == 0)) {  _r = CMP_OF(1); } else if (((m_60) == 1)) {  _r = CMP_OF(0); } else if (((m_60) == 2)) {  _r = CMP_OF(-1); } else rt_panic("match: no case at kernel:82"); _r; });
}
V d_Big_dcmp_ubits(V an_61, V xs_62, V bn_63, V ys_64) {
  return ({ V _r = 0; V m_65 = an_61; V m_66 = bn_63; if (((m_65) == FALSE_V) && ((m_66) == FALSE_V)) {  _r = d_Big_dbits_dcmp(xs_62, ys_64); } else if (((m_65) == TRUE_V) && ((m_66) == TRUE_V)) {  _r = d_Big_dorder_dflip(d_Big_dbits_dcmp(xs_62, ys_64)); } else if (((m_65) == TRUE_V) && ((m_66) == FALSE_V)) {  _r = CMP_OF(-1); } else if (((m_65) == FALSE_V) && ((m_66) == TRUE_V)) {  _r = CMP_OF(1); } else rt_panic("match: no case at kernel:87"); _r; });
}
V d_Big_dcmp_usmall(V an_67, V a_68, V bn_69, V b_70) {
  return ({ V _r = 0; V m_71 = an_67; V m_72 = bn_69; if (((m_71) == FALSE_V) && ((m_72) == FALSE_V)) {  _r = CMP_OF(nat_cmp(a_68, b_70)); } else if (((m_71) == TRUE_V) && ((m_72) == TRUE_V)) {  _r = CMP_OF(nat_cmp(b_70, a_68)); } else if (((m_71) == TRUE_V) && ((m_72) == FALSE_V)) {  _r = CMP_OF(-1); } else if (((m_71) == FALSE_V) && ((m_72) == TRUE_V)) {  _r = CMP_OF(1); } else rt_panic("match: no case at kernel:93"); _r; });
}
V d_Big_dcmp(V a_73, V b_74) {
  return big_cmp(a_73, b_74, 1);
}
V d_Big_dorder_deq(V order_75) {
  return ({ V _r = 0; V m_76 = order_75; if (((m_76) == 1)) {  _r = TRUE_V; } else if (((m_76) == 0)) {  _r = FALSE_V; } else if (((m_76) == 2)) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:105"); _r; });
}
V d_Big_dorder_dlt(V order_77) {
  return ({ V _r = 0; V m_78 = order_77; if (((m_78) == 0)) {  _r = TRUE_V; } else if (((m_78) == 1)) {  _r = FALSE_V; } else if (((m_78) == 2)) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:110"); _r; });
}
V d_Big_dis_ueq(V a_79, V b_80) {
  return d_Big_dorder_deq(d_Big_dcmp(a_79, b_80));
}
V d_Big_dis_ult(V a_81, V b_82) {
  return d_Big_dorder_dlt(d_Big_dcmp(a_81, b_82));
}
V d_Big_dis_ule(V a_83, V b_84) {
  return ((d_Big_dis_ult(b_84, a_83)) ^ 1u);
}
V d_Big_ddifference(V order_85, V negative_86, V xs_87, V ys_88) {
  return ({ V _r = 0; V m_89 = order_85; if (((m_89) == 1)) {  _r = d_Big_dzero(); } else if (((m_89) == 2)) {  _r = d_Big_dmake(negative_86, d_Big_dbits_dsub(xs_87, ys_88, ((V)0u))); } else if (((m_89) == 0)) {  _r = d_Big_dmake(((negative_86) ^ 1u), d_Big_dbits_dsub(ys_88, xs_87, ((V)0u))); } else rt_panic("match: no case at kernel:118"); _r; });
}
V d_Big_dadd_ubits(V an_90, V xs_91, V bn_92, V ys_93) {
  return ({ V _r = 0; V m_94 = an_90; V m_95 = bn_92; if (((m_94) == FALSE_V) && ((m_95) == FALSE_V)) {  _r = d_Big_dmake(FALSE_V, d_Big_dbits_dadd(xs_91, ys_93, ((V)0u))); } else if (((m_94) == TRUE_V) && ((m_95) == TRUE_V)) {  _r = d_Big_dmake(TRUE_V, d_Big_dbits_dadd(xs_91, ys_93, ((V)0u))); } else if (((m_94) == FALSE_V) && ((m_95) == TRUE_V)) {  _r = d_Big_ddifference(d_Big_dbits_dcmp(xs_91, ys_93), FALSE_V, xs_91, ys_93); } else if (((m_94) == TRUE_V) && ((m_95) == FALSE_V)) {  _r = d_Big_ddifference(d_Big_dbits_dcmp(xs_91, ys_93), TRUE_V, xs_91, ys_93); } else rt_panic("match: no case at kernel:123"); _r; });
}
V d_Big_dadd_usmall(V an_96, V a_97, V bn_98, V b_99) {
  return ((((((an_96) ^ (bn_98))) ^ 1u)) != FALSE_V ? d_Big_dsmall(an_96, nat_add(a_97, b_99)) : ((((V)(nat_cmp(a_97, b_99) < 0))) != FALSE_V ? d_Big_dsmall(bn_98, nat_sub(b_99, a_97)) : d_Big_dsmall(an_96, nat_sub(a_97, b_99))));
}
V d_Big_dadd(V a_100, V b_101) {
  return big_add(a_100, b_101, 1, 0);
}
V d_Big_dsub(V a_102, V b_103) {
  return big_sub(a_102, b_103, 1, 0);
}
V d_Big_dsucc(V a_104) {
  return d_Big_dadd(a_104, d_Big_done());
}
V d_Big_dpred(V a_105) {
  return d_Big_dsub(a_105, d_Big_done());
}
static V d_Big_dbits_dmul__bend(V xs_106, V ys_107);
V d_Big_dbits_dmul(V xs_106, V ys_107) {
  return (bits_trimmed(ys_107) ? bits_mul(xs_106, ys_107) : d_Big_dbits_dmul__bend(xs_106, ys_107));
}
static V d_Big_dbits_dmul__bend(V xs_106, V ys_107) {
  return ({ V _r = 0; V m_108 = xs_106; if (((m_108) == NIL)) {  _r = NIL; } else if (((m_108) != NIL) && ((FLD(m_108, 0)) == FALSE_V)) { V xt_109 = FLD(m_108, 1); _r = d_Big_dbits_dcons(FALSE_V, d_Big_dbits_dmul(xt_109, ys_107)); } else if (((m_108) != NIL) && ((FLD(m_108, 0)) == TRUE_V)) { V xt_110 = FLD(m_108, 1); _r = d_Big_dbits_dadd(ys_107, d_Big_dbits_dcons(FALSE_V, d_Big_dbits_dmul(xt_110, ys_107)), ((V)0u)); } else rt_panic("match: no case at kernel:141"); _r; });
}
V d_Big_dmul(V a_111, V b_112) {
  return ({ V _r = 0; V m_113 = a_111; V m_114 = b_112; if ((tag_of(m_113) == 1) && (tag_of(m_114) == 1)) { V an_115 = FLD(m_113, 0); V a_116 = FLD(m_113, 1); V bn_117 = FLD(m_114, 0); V b_118 = FLD(m_114, 1); _r = d_Big_dsmall(((an_115) ^ (bn_117)), nat_mul(a_116, b_118)); } else if ((tag_of(m_113) == 1) && (tag_of(m_114) == 0)) { V an_119 = FLD(m_113, 0); V a_120 = FLD(m_113, 1); V bn_121 = FLD(m_114, 0); V ys_122 = FLD(m_114, 1); _r = d_Big_dmake(((an_119) ^ (bn_121)), d_Big_dbits_dmul(d_Big_dbits_dof_unat(a_120), ys_122)); } else if ((tag_of(m_113) == 0) && (tag_of(m_114) == 1)) { V an_123 = FLD(m_113, 0); V xs_124 = FLD(m_113, 1); V bn_125 = FLD(m_114, 0); V b_126 = FLD(m_114, 1); _r = d_Big_dmake(((an_123) ^ (bn_125)), d_Big_dbits_dmul(d_Big_dbits_dof_unat(b_126), xs_124)); } else if ((tag_of(m_113) == 0) && (tag_of(m_114) == 0)) { V an_127 = FLD(m_113, 0); V xs_128 = FLD(m_113, 1); V bn_129 = FLD(m_114, 0); V ys_130 = FLD(m_114, 1); _r = d_Big_dmake(((an_127) ^ (bn_129)), d_Big_dbits_dmul(xs_128, ys_130)); } else rt_panic("match: no case at kernel:146"); _r; });
}
V d_NativeNat_dhalf(V value_131) {
  return FLD(nat_divmod(value_131, NAT_SMALL(2ull)), 0);
}
V d_NativeNat_dparity(V value_132) {
  return FLD(nat_divmod(value_132, NAT_SMALL(2ull)), 1);
}
V d_Big_dbits_dof_unat(V n_133) {
  return nat_to_bits(n_133);
}
V d_Big_dof_unat(V n_134) {
  return d_Big_dsmall(FALSE_V, n_134);
}
V d_Big_dbits_dto_unat(V bits_135) {
  return bits_to_nat(bits_135);
}
V d_Big_dto_unat(V value_136) {
  return ({ V _r = 0; V m_137 = value_136; switch (tag_of(m_137)) { case 1: { V value_138 = FLD(m_137, 1); _r = value_138; break; } case 0: { V bits_139 = FLD(m_137, 1); _r = d_Big_dbits_dto_unat(bits_139); break; } default: rt_panic("match: no case at kernel:165"); } _r; });
}
V d_Big_dbit_ulength(V value_140) {
  return list_length(d_Big_dbits(value_140));
}
V d_Big_dbits_dshl(V n_141, V bits_142) {
  return bits_shl(n_141, bits_142);
}
V d_Big_dshift_uleft(V value_143, V n_144) {
  return big_shift_left(value_143, n_144, 1, 0);
}
V d_Big_dbits_ddrop(V n_145, V bits_146) {
_top: ;
  return ({ V _r = 0; V m_147 = n_145; V m_148 = bits_146; if ((nat_cmp(m_147, NAT_SMALL(0ull)) == 0)) { V xs_149 = m_148; _r = xs_149; } else if ((nat_cmp(m_147, NAT_SMALL(1ull)) >= 0) && ((m_148) == NIL)) { V p_150 = nat_sub(m_147, NAT_SMALL(1ull)); _r = NIL; } else if ((nat_cmp(m_147, NAT_SMALL(1ull)) >= 0) && ((m_148) != NIL)) { V p_151 = nat_sub(m_147, NAT_SMALL(1ull)); V tail_152 = FLD(m_148, 1); _r = ({ V a_153 = p_151; V a_154 = tail_152; n_145 = a_153; bits_146 = a_154;  goto _top; (V)0; }); } else rt_panic("match: no case at kernel:178"); _r; });
}
static V d_Big_dshift_uright__bend(V value_155, V n_156);
V d_Big_dshift_uright(V value_155, V n_156) {
  return (big_wide(value_155, 1) ? big_shift_right_wide(value_155, n_156, 1) : d_Big_dshift_uright__bend(value_155, n_156));
}
static V d_Big_dshift_uright__bend(V value_155, V n_156) {
  return ({ V _r = 0; V m_157 = value_155; switch (tag_of(m_157)) { case 0: { V negative_158 = FLD(m_157, 0); V bits_159 = FLD(m_157, 1); _r = d_Big_dmake(negative_158, d_Big_dbits_ddrop(n_156, bits_159)); break; } case 1: { V negative_160 = FLD(m_157, 0); V value_161 = FLD(m_157, 1); _r = d_Big_dsmall(negative_160, NAT_SMALL(u32_shrn(((V)nat_to_u32(value_161)), n_156))); break; } default: rt_panic("match: no case at kernel:183"); } _r; });
}
V d_Big_dbits_ddivide_ustep(V order_162, V rest_163, V divisor_164, V rem_165, V quot_166) {
  return ({ V _r = 0; V m_167 = order_162; if (((m_167) == 0)) {  _r = d_Big_dbits_ddivide(rest_163, divisor_164, rem_165, d_Big_dbits_dcons(FALSE_V, quot_166)); } else if (((m_167) == 1)) {  _r = d_Big_dbits_ddivide(rest_163, divisor_164, NIL, d_Big_dbits_dcons(TRUE_V, quot_166)); } else if (((m_167) == 2)) {  _r = d_Big_dbits_ddivide(rest_163, divisor_164, d_Big_dbits_dsub(rem_165, divisor_164, ((V)0u)), d_Big_dbits_dcons(TRUE_V, quot_166)); } else rt_panic("match: no case at kernel:193"); _r; });
}
static V d_Big_dbits_ddivide__bend(V bits_168, V divisor_169, V rem_170, V quot_171);
V d_Big_dbits_ddivide(V bits_168, V divisor_169, V rem_170, V quot_171) {
  return (bits_divide_ok(divisor_169, rem_170, quot_171) ? bits_divide(bits_168, divisor_169) : d_Big_dbits_ddivide__bend(bits_168, divisor_169, rem_170, quot_171));
}
static V d_Big_dbits_ddivide__bend(V bits_168, V divisor_169, V rem_170, V quot_171) {
  return ({ V _r = 0; V m_172 = bits_168; if (((m_172) == NIL)) {  _r = rt_ctor2(0, quot_171, rem_170); } else if (((m_172) != NIL)) { V b_173 = FLD(m_172, 0); V rest_174 = FLD(m_172, 1); _r = ({ V next_175 = d_Big_dbits_dcons(b_173, rem_170); d_Big_dbits_ddivide_ustep(d_Big_dbits_dcmp(next_175, divisor_169), rest_174, divisor_169, next_175, quot_171); }); } else rt_panic("match: no case at kernel:199"); _r; });
}
V d_Big_ddivmod_ubits(V a_176, V b_177) {
  return ({ V _r = 0; V m_178 = b_177; if (((m_178) == NIL)) {  _r = NONE; } else if (((m_178) != NIL)) { V b_179 = FLD(m_178, 0); V bs_180 = FLD(m_178, 1); _r = SOME(d_Big_dbits_ddivide(list_reverse(a_176), CON(b_179, bs_180), NIL, NIL)); } else rt_panic("match: no case at kernel:205"); _r; });
}
V d_Big_ddivmod_uunsigned(V a_181, V b_182) {
  return d_Big_ddivmod_ubits(d_Big_dbits(a_181), d_Big_dbits(b_182));
}
V d_Big_dquotient(V negative_183, V qr_184) {
  return ({ V _r = 0; V m_185 = qr_184; if (((m_185) == NONE)) {  _r = NONE; } else if (((m_185) != NONE) && (tag_of(FLD(m_185, 0)) == 0)) { V q_186 = FLD(FLD(m_185, 0), 0); _r = SOME(d_Big_dmake(negative_183, q_186)); } else rt_panic("match: no case at kernel:210"); _r; });
}
V d_Big_dremainder(V negative_187, V qr_188) {
  return ({ V _r = 0; V m_189 = qr_188; if (((m_189) == NONE)) {  _r = NONE; } else if (((m_189) != NONE) && (tag_of(FLD(m_189, 0)) == 0)) { V r_190 = FLD(FLD(m_189, 0), 1); _r = SOME(d_Big_dmake(negative_187, r_190)); } else rt_panic("match: no case at kernel:214"); _r; });
}
V d_Big_ddiv(V a_191, V b_192) {
  return d_Big_dquotient(((d_Big_dnegative(a_191)) ^ (d_Big_dnegative(b_192))), d_Big_ddivmod_uunsigned(a_191, b_192));
}
V d_Big_drem(V a_193, V b_194) {
  return d_Big_dremainder(d_Big_dnegative(a_193), d_Big_ddivmod_uunsigned(a_193, b_194));
}
V d_Big_dshow_ddigit(V qr_195, V acc_196) {
  return ({ V _r = 0; V m_197 = qr_195; if ((tag_of(m_197) == 0)) { V q_198 = FLD(m_197, 0); V r_199 = FLD(m_197, 1); _r = d_Big_dshow_dbits(q_198, str_cons((((V)(uint32_t)((((V)48u)) + (((V)nat_to_u32(d_Big_dbits_dto_unat(r_199))))))), acc_196)); } else rt_panic("match: no case at kernel:222"); _r; });
}
V d_Big_dshow_dbits(V bits_200, V acc_201) {
  return (bits_200 == NIL ? acc_201 : str_append(nat_show(bits_to_nat(bits_200)), acc_201));
}
V d_Big_dshow(V value_202) {
  return ({ V _r = 0; V m_203 = value_202; if ((tag_of(m_203) == 1)) { V negative_204 = FLD(m_203, 0); V value_205 = FLD(m_203, 1); _r = ((negative_204) != FALSE_V ? str_append(((V)&S_0), nat_show(value_205)) : nat_show(value_205)); } else if ((tag_of(m_203) == 0) && ((FLD(m_203, 1)) == NIL)) {  _r = ((V)&S_1); } else if ((tag_of(m_203) == 0) && ((FLD(m_203, 0)) == FALSE_V) && ((FLD(m_203, 1)) != NIL)) { V b_206 = FLD(FLD(m_203, 1), 0); V tail_207 = FLD(FLD(m_203, 1), 1); _r = d_Big_dshow_dbits(CON(b_206, tail_207), SNIL); } else if ((tag_of(m_203) == 0) && ((FLD(m_203, 0)) == TRUE_V) && ((FLD(m_203, 1)) != NIL)) { V b_208 = FLD(FLD(m_203, 1), 0); V tail_209 = FLD(FLD(m_203, 1), 1); _r = str_append(((V)&S_0), d_Big_dshow_dbits(CON(b_208, tail_209), SNIL)); } else rt_panic("match: no case at kernel:230"); _r; });
}
V d_Big_dread_ddigit(V c_210) {
  return ({ V n_211 = (c_210); ((((((V)((((V)48u)) <= (n_211)))) & (((V)((n_211) <= (((V)57u))))))) != FALSE_V ? SOME(NAT_SMALL(((V)(uint32_t)((n_211) - (((V)48u)))))) : NONE); });
}
V scc_27(uint32_t w, V *a) {
  V digit_212;
  V text_213;
  V value_214;
  V text_215;
  V value_216;
  switch (w) {
  default: digit_212 = a[0]; text_213 = a[1]; value_214 = a[2]; goto _m0;
  case 1: text_215 = a[0]; value_216 = a[1]; goto _m1;
  }
_m0: ;
  return ({ V _r = 0; V m_217 = digit_212; if (((m_217) == NONE)) {  _r = NONE; } else if (((m_217) != NONE)) { V n_218 = FLD(m_217, 0); _r = ({ V a_219 = text_213; V a_220 = d_Big_dadd(d_Big_dmul(value_214, d_Big_dof_unat(NAT_SMALL(10ull))), d_Big_dof_unat(n_218)); text_215 = a_219; value_216 = a_220;  goto _m1; (V)0; }); } else rt_panic("match: no case at kernel:241"); _r; });
_m1: ;
  return ({ V _r = 0; V m_221 = text_215; if ((str_eq_lit(m_221, "", 0))) {  _r = SOME(value_216); } else if ((!str_is_nil(m_221))) { V c_222 = str_head(m_221); V rest_223 = str_tail(m_221); _r = ({ V a_224 = d_Big_dread_ddigit(c_222); V a_225 = rest_223; V a_226 = value_216; digit_212 = a_224; text_213 = a_225; value_214 = a_226;  goto _m0; (V)0; }); } else rt_panic("match: no case at kernel:246"); _r; });
}
V scc_27(uint32_t w, V *a);
V d_Big_dread_dnext(V digit_212, V text_213, V value_214) {
  V w_a[] = {digit_212, text_213, value_214};
  return scc_27(0, w_a);
}
V scc_27(uint32_t w, V *a);
V d_Big_dread_dgo(V text_215, V value_216) {
  V w_a[] = {text_215, value_216};
  return scc_27(1, w_a);
}
V d_Big_dread_dsign(V negative_227, V value_228) {
  return ({ V _r = 0; V m_229 = value_228; if (((m_229) == NONE)) {  _r = NONE; } else if (((m_229) != NONE)) { V v_230 = FLD(m_229, 0); _r = SOME(d_Big_dmake(negative_227, d_Big_dbits(v_230))); } else rt_panic("match: no case at kernel:250"); _r; });
}
V d_Big_dread_dnonempty(V negative_231, V text_232) {
  return ({ V _r = 0; V m_233 = text_232; if ((str_eq_lit(m_233, "", 0))) {  _r = NONE; } else if ((!str_is_nil(m_233))) { V c_234 = str_head(m_233); V rest_235 = str_tail(m_233); _r = d_Big_dread_dsign(negative_231, d_Big_dread_dgo(str_cons(c_234, rest_235), d_Big_dzero())); } else rt_panic("match: no case at kernel:254"); _r; });
}
V d_Big_dread(V text_236) {
  return ({ V _r = 0; V m_237 = text_236; if ((str_eq_lit(m_237, "", 0))) {  _r = NONE; } else if ((!str_is_nil(m_237)) && ((str_head(m_237)) == 45)) { V rest_238 = str_tail(m_237); _r = d_Big_dread_dnonempty(TRUE_V, rest_238); } else if ((!str_is_nil(m_237)) && ((str_head(m_237)) == 43)) { V rest_239 = str_tail(m_237); _r = d_Big_dread_dnonempty(FALSE_V, rest_239); } else if ((!str_is_nil(m_237))) { V c_240 = str_head(m_237); V rest_241 = str_tail(m_237); _r = d_Big_dread_dgo(str_cons(c_240, rest_241), d_Big_dzero()); } else rt_panic("match: no case at kernel:258"); _r; });
}
V d_Big_didentity(V value_242) {
  return value_242;
}
V d_Big_dorder_dnumber(V order_243) {
  return ({ V _r = 0; V m_244 = order_243; if (((m_244) == 0)) {  _r = d_Big_dneg(d_Big_done()); } else if (((m_244) == 1)) {  _r = d_Big_dzero(); } else if (((m_244) == 2)) {  _r = d_Big_done(); } else rt_panic("match: no case at kernel:267"); _r; });
}
V d_Big_dcompare(V a_245, V b_246) {
  return d_Big_dorder_dnumber(d_Big_dcmp(a_245, b_246));
}
V d_Big_dsign(V value_247) {
  return d_Big_dcompare(value_247, d_Big_dzero());
}
V d_Big_dfits_uint(V value_248) {
  return big_fits_int(value_248, 1);
}
V d_Big_dlow_ubits(V n_249, V bits_250) {
  return ({ V _r = 0; V m_251 = n_249; if ((nat_cmp(m_251, NAT_SMALL(0ull)) == 0)) {  _r = NIL; } else if ((nat_cmp(m_251, NAT_SMALL(1ull)) >= 0)) { V p_252 = nat_sub(m_251, NAT_SMALL(1ull)); _r = ({ V _r = 0; V m_253 = bits_250; if (((m_253) == NIL)) {  _r = NIL; } else if (((m_253) != NIL)) { V b_254 = FLD(m_253, 0); V rest_255 = FLD(m_253, 1); _r = d_Big_dbits_dcons(b_254, d_Big_dlow_ubits(p_252, rest_255)); } else rt_panic("match: no case at kernel:280"); _r; }); } else rt_panic("match: no case at kernel:277"); _r; });
}
V d_Big_dunsigned_ubits(V width_256, V value_257) {
  return ({ V low_258 = d_Big_dmake(FALSE_V, d_Big_dlow_ubits(width_256, d_Big_dbits(value_257))); ((((d_Big_dnegative(value_257)) & (((d_Big_dis_uzero(low_258)) ^ 1u)))) != FALSE_V ? d_Big_dsub(d_Big_dshift_uleft(d_Big_done(), width_256), low_258) : low_258); });
}
static V d_Big_dunsigned__bend(V width_259, V value_260);
V d_Big_dunsigned(V width_259, V value_260) {
  return (big_wide_pos(value_260, 1) ? big_unsigned_wide(width_259, value_260, 1) : d_Big_dunsigned__bend(width_259, value_260));
}
static V d_Big_dunsigned__bend(V width_259, V value_260) {
  return ({ V _r = 0; V m_261 = value_260; if ((tag_of(m_261) == 1) && ((FLD(m_261, 0)) == FALSE_V)) { V magnitude_262 = FLD(m_261, 1); _r = ((((V)(nat_cmp(width_259, NAT_SMALL(24ull)) < 0))) != FALSE_V ? d_Big_dof_unat(NAT_SMALL(((((V)nat_to_u32(magnitude_262))) & (((V)(uint32_t)((u32_shln(((V)1u), width_259)) - (((V)1u)))))))) : rt_ctor2(1, FALSE_V, magnitude_262)); } else if ((tag_of(m_261) == 1) && ((FLD(m_261, 0)) == TRUE_V)) { V magnitude_263 = FLD(m_261, 1); _r = d_Big_dunsigned_ubits(width_259, rt_ctor2(1, TRUE_V, magnitude_263)); } else if ((tag_of(m_261) == 0)) { V negative_264 = FLD(m_261, 0); V bits_265 = FLD(m_261, 1); _r = d_Big_dunsigned_ubits(width_259, rt_ctor2(0, negative_264, bits_265)); } else rt_panic("match: no case at kernel:288"); _r; });
}
V d_Big_dsigned_ubits(V width_266, V value_267) {
  return ({ V sign_268 = d_Big_dshift_uleft(d_Big_done(), nat_sub(width_266, NAT_SMALL(1ull))); ((d_Big_dis_ult(value_267, sign_268)) != FALSE_V ? value_267 : d_Big_dsub(value_267, d_Big_dshift_uleft(d_Big_done(), width_266))); });
}
static V d_Big_dsigned__bend(V width_269, V value_270);
V d_Big_dsigned(V width_269, V value_270) {
  return (big_signed_ok(width_269, value_270, 1) ? big_signed_wide(width_269, value_270, 1) : d_Big_dsigned__bend(width_269, value_270));
}
static V d_Big_dsigned__bend(V width_269, V value_270) {
  return ({ V _r = 0; V m_271 = value_270; switch (tag_of(m_271)) { case 1: { V negative_272 = FLD(m_271, 0); V magnitude_273 = FLD(m_271, 1); _r = ((((V)(nat_cmp(width_269, NAT_SMALL(25ull)) < 0))) != FALSE_V ? d_Big_dsigned_ubits(width_269, rt_ctor2(1, negative_272, magnitude_273)) : rt_ctor2(1, negative_272, magnitude_273)); break; } case 0: { V negative_274 = FLD(m_271, 0); V bits_275 = FLD(m_271, 1); _r = d_Big_dsigned_ubits(width_269, rt_ctor2(0, negative_274, bits_275)); break; } default: rt_panic("match: no case at kernel:297"); } _r; });
}
V d_Big_dwrap(V width_276, V value_277) {
  return d_Big_dsigned(width_276, d_Big_dunsigned(width_276, value_277));
}
static V d_NativeInt_dbound__bend(V value_278);
V d_NativeInt_dbound(V value_278) {
  return (big_bound_ok(value_278, 1) ? value_278 : d_NativeInt_dbound__bend(value_278));
}
static V d_NativeInt_dbound__bend(V value_278) {
  return ({ V _r = 0; V m_279 = value_278; switch (tag_of(m_279)) { case 1: { V negative_280 = FLD(m_279, 0); V magnitude_281 = FLD(m_279, 1); _r = rt_ctor2(1, negative_280, magnitude_281); break; } case 0: { V negative_282 = FLD(m_279, 0); V bits_283 = FLD(m_279, 1); _r = ((((V)(nat_cmp(list_length(bits_283), NAT_SMALL(63ull)) < 0))) != FALSE_V ? rt_ctor2(0, negative_282, bits_283) : d_Big_dwrap(NAT_SMALL(63ull), rt_ctor2(0, negative_282, bits_283))); break; } default: rt_panic("match: no case at kernel:303"); } _r; });
}
V d_NativeInt_dadd(V a_284, V b_285) {
  return d_NativeInt_dbound(d_Big_dadd(a_284, b_285));
}
V d_NativeInt_dsub(V a_286, V b_287) {
  return d_NativeInt_dbound(d_Big_dsub(a_286, b_287));
}
V d_NativeInt_dmul(V a_288, V b_289) {
  return d_NativeInt_dbound(d_Big_dmul(a_288, b_289));
}
V d_NativeInt_dneg(V a_290) {
  return d_NativeInt_dbound(d_Big_dneg(a_290));
}
V d_NativeInt_dsucc(V a_291) {
  return d_NativeInt_dadd(a_291, d_Big_done());
}
V d_NativeInt_dpred(V a_292) {
  return d_NativeInt_dsub(a_292, d_Big_done());
}
V d_Big_dbits_dlogic(V mode_293, V xs_294, V ys_295) {
  return ({ V _r = 0; V m_296 = xs_294; V m_297 = ys_295; if (((m_296) == NIL) && ((m_297) == NIL)) {  _r = NIL; } else if (((m_296) != NIL) && ((m_297) == NIL)) { V x_298 = FLD(m_296, 0); V xt_299 = FLD(m_296, 1); _r = d_Big_dbits_dcons(((((V)((mode_293) == (((V)0u))))) != FALSE_V ? FALSE_V : x_298), d_Big_dbits_dlogic(mode_293, xt_299, NIL)); } else if (((m_296) == NIL) && ((m_297) != NIL)) { V y_300 = FLD(m_297, 0); V yt_301 = FLD(m_297, 1); _r = d_Big_dbits_dcons(((((V)((mode_293) == (((V)0u))))) != FALSE_V ? FALSE_V : y_300), d_Big_dbits_dlogic(mode_293, NIL, yt_301)); } else if (((m_296) != NIL) && ((m_297) != NIL)) { V x_302 = FLD(m_296, 0); V xt_303 = FLD(m_296, 1); V y_304 = FLD(m_297, 0); V yt_305 = FLD(m_297, 1); _r = d_Big_dbits_dcons(((((V)((mode_293) == (((V)0u))))) != FALSE_V ? ((x_302) & (y_304)) : ((((V)((mode_293) == (((V)1u))))) != FALSE_V ? ((x_302) | (y_304)) : ((x_302) ^ (y_304)))), d_Big_dbits_dlogic(mode_293, xt_303, yt_305)); } else rt_panic("match: no case at kernel:313"); _r; });
}
V d_Big_dlogic(V mode_306, V a_307, V b_308) {
  return ({ V na_309 = d_Big_dbit_ulength(a_307); ({ V nb_310 = d_Big_dbit_ulength(b_308); ({ V width_311 = nat_add(NAT_SMALL(1ull), ((((V)(nat_cmp(na_309, nb_310) < 0))) != FALSE_V ? nb_310 : na_309)); d_Big_dsigned(width_311, d_Big_dmake(FALSE_V, d_Big_dbits_dlogic(mode_306, d_Big_dbits(d_Big_dunsigned(width_311, a_307)), d_Big_dbits(d_Big_dunsigned(width_311, b_308))))); }); }); });
}
V d_Big_dlogand(V a_312, V b_313) {
  return d_Big_dlogic(((V)0u), a_312, b_313);
}
V d_Big_dlogor(V a_314, V b_315) {
  return d_Big_dlogic(((V)1u), a_314, b_315);
}
V d_Big_dlogxor(V a_316, V b_317) {
  return d_Big_dlogic(((V)2u), a_316, b_317);
}
V d_Big_dshift_uright_ufloor(V a_318, V n_319) {
  return ({ V shifted_320 = d_Big_dshift_uright(a_318, n_319); ((((d_Big_dnegative(a_318)) & (((d_Big_dis_uzero(d_Big_dmake(FALSE_V, d_Big_dlow_ubits(n_319, d_Big_dbits(a_318))))) ^ 1u)))) != FALSE_V ? d_Big_dpred(shifted_320) : shifted_320); });
}
V d_Big_dhex_ugo(V bits_321, V upper_322, V acc_323) {
_top: ;
  return ({ V digit_324 = ((V)nat_to_u32(d_Big_dbits_dto_unat(d_Big_dlow_ubits(NAT_SMALL(4ull), bits_321)))); ({ V base_325 = ((((V)((digit_324) < (((V)10u))))) != FALSE_V ? ((V)48u) : ((upper_322) != FALSE_V ? ((V)55u) : ((V)87u))); ((((V)((bits_321) == NIL))) != FALSE_V ? acc_323 : ({ V a_326 = d_Big_dbits_ddrop(NAT_SMALL(4ull), bits_321); V a_327 = str_cons((((V)(uint32_t)((base_325) + (digit_324)))), acc_323); bits_321 = a_326; acc_323 = a_327;  goto _top; (V)0; })); }); });
}
static V d_Big_dhex__bend(V value_328, V upper_329);
V d_Big_dhex(V value_328, V upper_329) {
  return (big_hex_ok(value_328, 1) ? big_hex_small(value_328, upper_329) : d_Big_dhex__bend(value_328, upper_329));
}
static V d_Big_dhex__bend(V value_328, V upper_329) {
  return ((d_Big_dis_uzero(value_328)) != FALSE_V ? ((V)&S_1) : d_Big_dhex_ugo(d_Big_dbits(d_Big_dunsigned(NAT_SMALL(63ull), value_328)), upper_329, SNIL));
}
V d_Big_dhex_unatural(V value_330) {
  return ((d_Big_dis_uzero(value_330)) != FALSE_V ? ((V)&S_1) : ((d_Big_dnegative(value_330)) != FALSE_V ? str_cons((((V)45u)), d_Big_dhex_ugo(d_Big_dbits(value_330), FALSE_V, SNIL)) : d_Big_dhex_ugo(d_Big_dbits(value_330), FALSE_V, SNIL)));
}
V d_Big_dis_uge(V a_331, V b_332) {
  return d_Big_dis_ule(b_332, a_331);
}
V d_Big_dis_ugt(V a_333, V b_334) {
  return d_Big_dis_ult(b_334, a_333);
}
V d_Big_dmaximum(V a_335, V b_336) {
  return ((d_Big_dis_ult(a_335, b_336)) != FALSE_V ? b_336 : a_335);
}
V d_Big_dminimum(V a_337, V b_338) {
  return ((d_Big_dis_ult(a_337, b_338)) != FALSE_V ? a_337 : b_338);
}
V d_Big_dvalidated_udigits(V base_339, V text_340, V acc_341) {
_top: ;
  return ({ V _r = 0; V m_342 = text_340; if ((str_is_nil(m_342))) {  _r = acc_341; } else if ((!str_is_nil(m_342))) { V c_343 = str_head(m_342); V rest_344 = str_tail(m_342); _r = ({ V code_345 = (c_343); ({ V digit_346 = ((V)(uint32_t)((code_345) - (((((V)((code_345) <= (((V)57u))))) != FALSE_V ? ((V)48u) : ((((V)((code_345) <= (((V)90u))))) != FALSE_V ? ((V)55u) : ((V)87u)))))); ({ V a_347 = rest_344; V a_348 = d_Big_dadd(d_Big_dmul(acc_341, base_339), d_Big_dof_unat(NAT_SMALL(digit_346))); text_340 = a_347; acc_341 = a_348;  goto _top; (V)0; }); }); }); } else rt_panic("match: no case at kernel:344"); _r; });
}
V d_Big_dread_uvalidated(V base_349, V text_350) {
  return d_Big_dvalidated_udigits(base_349, text_350, d_Big_dzero());
}
V d_Big_dbytes_ugo(V bits_351) {
  return ((((V)((bits_351) == NIL))) != FALSE_V ? SNIL : str_cons((((V)nat_to_u32(d_Big_dbits_dto_unat(d_Big_dlow_ubits(NAT_SMALL(8ull), bits_351))))), d_Big_dbytes_ugo(d_Big_dbits_ddrop(NAT_SMALL(8ull), bits_351))));
}
V d_Big_dto_ubytes(V value_352) {
  return d_Big_dbytes_ugo(d_Big_dbits(value_352));
}
V d_NativeString_dhalf_ulength(V text_353) {
  return d_Big_dshift_uright(d_Big_dof_unat(str_length(text_353)), NAT_SMALL(1ull));
}
V d_NativeString_dlength_uparity(V text_354) {
  return d_Big_dunsigned(NAT_SMALL(1ull), d_Big_dof_unat(str_length(text_354)));
}
V d_CheckResult_dpure(V value_355) {
  return DONE(value_355);
}
V d_CheckResult_dbind(V value_356, V next_357) {
  return ({ V _r = 0; V m_358 = value_356; switch (tag_of(m_358)) { case 1: { V x_359 = FLD(m_358, 0); _r = ap(next_357, x_359); break; } case 0: { V error_360 = FLD(m_358, 0); _r = FAIL(error_360); break; } default: rt_panic("match: no case at kernel:549"); } _r; });
}
V d_StringResult_dpure(V value_361) {
  return DONE(value_361);
}
V d_StringResult_dbind(V value_362, V next_363) {
  return ({ V _r = 0; V m_364 = value_362; switch (tag_of(m_364)) { case 1: { V x_365 = FLD(m_364, 0); _r = ap(next_363, x_365); break; } case 0: { V error_366 = FLD(m_364, 0); _r = FAIL(error_366); break; } default: rt_panic("match: no case at kernel:555"); } _r; });
}
V d_NativeBool_dequal(V a_367, V b_368) {
  return ({ V _r = 0; V m_369 = a_367; if (((m_369) == TRUE_V)) {  _r = b_368; } else if (((m_369) == FALSE_V)) {  _r = ((b_368) ^ 1u); } else rt_panic("match: no case at kernel:562"); _r; });
}
V d_Series_dstring_unode(V text_370) {
  return ({ V _r = 0; V m_371 = text_370; if ((str_is_nil(m_371))) {  _r = ((V)0); } else if ((!str_is_nil(m_371))) { V head_372 = str_head(m_371); V tail_373 = str_tail(m_371); _r = rt_ctor2(1, head_372, ({ V _c = clo_new(lam_374, 1, 1); CLO_ENV(_c)[0] = tail_373; _c; })); } else rt_panic("match: no case at kernel:566"); _r; });
}
V d_Series_dfrom_ustring(V text_375) {
  return ({ V _c = clo_new(lam_376, 1, 1); CLO_ENV(_c)[0] = text_375; _c; });
}
V d_Series_dlist_unode(V xs_377) {
  return ({ V _r = 0; V m_378 = xs_377; if (((m_378) == NIL)) {  _r = ((V)0); } else if (((m_378) != NIL)) { V x_379 = FLD(m_378, 0); V rest_380 = FLD(m_378, 1); _r = rt_ctor2(1, x_379, ({ V _c = clo_new(lam_381, 1, 1); CLO_ENV(_c)[0] = rest_380; _c; })); } else rt_panic("match: no case at kernel:572"); _r; });
}
V d_Series_dof_ulist(V xs_382) {
  return ({ V _c = clo_new(lam_383, 1, 1); CLO_ENV(_c)[0] = xs_382; _c; });
}
V d_Series_dcollect(V node_384) {
  return ({ V _r = 0; V m_385 = node_384; switch (tag_of(m_385)) { case 0: {  _r = NIL; break; } case 1: { V x_386 = FLD(m_385, 0); V tail_387 = FLD(m_385, 1); _r = CON(x_386, d_Series_dcollect(ap(tail_387, UNIT))); break; } default: rt_panic("match: no case at kernel:579"); } _r; });
}
V d_Series_dto_ulist(V stream_388) {
  return d_Series_dcollect(ap(stream_388, UNIT));
}
V d_Series_duncons_unode(V node_389) {
  return ({ V _r = 0; V m_390 = node_389; switch (tag_of(m_390)) { case 0: {  _r = NONE; break; } case 1: { V head_391 = FLD(m_390, 0); V tail_392 = FLD(m_390, 1); _r = SOME(rt_ctor2(0, head_391, tail_392)); break; } default: rt_panic("match: no case at kernel:585"); } _r; });
}
V d_Series_duncons(V stream_393) {
  return d_Series_duncons_unode(ap(stream_393, UNIT));
}
V scc_28(uint32_t w, V *a) {
  V n_394;
  V node_395;
  V a_396;
  V A_397;
  V n_398;
  V stream_399;
  V u_400;
  switch (w) {
  default: n_394 = a[0]; node_395 = a[1]; goto _m0;
  case 1: a_396 = a[0]; A_397 = a[1]; n_398 = a[2]; stream_399 = a[3]; u_400 = a[4]; goto _m1;
  }
_m0: ;
  return ({ V _r = 0; V m_401 = node_395; switch (tag_of(m_401)) { case 0: {  _r = ((V)0); break; } case 1: { V x_402 = FLD(m_401, 0); V tail_403 = FLD(m_401, 1); _r = ({ V a_404 = UNIT; V a_405 = UNIT; V a_406 = n_394; V a_407 = tail_403; V a_408 = UNIT; a_396 = a_404; A_397 = a_405; n_398 = a_406; stream_399 = a_407; u_400 = a_408;  goto _m1; (V)0; }); break; } default: rt_panic("match: no case at kernel:592"); } _r; });
_m1: ;
  return ({ V _r = 0; V m_409 = n_398; if ((nat_cmp(m_409, NAT_SMALL(0ull)) == 0)) {  _r = ap(stream_399, u_400); } else if ((nat_cmp(m_409, NAT_SMALL(1ull)) >= 0)) { V p_410 = nat_sub(m_409, NAT_SMALL(1ull)); _r = ({ V a_411 = p_410; V a_412 = ap(stream_399, u_400); n_394 = a_411; node_395 = a_412;  goto _m0; (V)0; }); } else rt_panic("match: no case at kernel:597"); _r; });
}
V scc_28(uint32_t w, V *a);
V d_Series_ddrop_unode(V n_394, V node_395) {
  V w_a[] = {n_394, node_395};
  return scc_28(0, w_a);
}
V scc_28(uint32_t w, V *a);
V d_Series_ddrop(V a_396, V A_397, V n_398, V stream_399, V u_400) {
  V w_a[] = {a_396, A_397, n_398, stream_399, u_400};
  return scc_28(1, w_a);
}
V d_Series_dtake_unode(V n_413, V node_414) {
  return ({ V _r = 0; V m_415 = node_414; switch (tag_of(m_415)) { case 0: {  _r = ((V)0); break; } case 1: { V x_416 = FLD(m_415, 0); V tail_417 = FLD(m_415, 1); _r = rt_ctor2(1, x_416, ({ V _c = clo_new(lam_419, 1, 2); CLO_ENV(_c)[0] = n_413; CLO_ENV(_c)[1] = tail_417; _c; })); break; } default: rt_panic("match: no case at kernel:603"); } _r; });
}
V d_Series_dtake(V a_420, V A_421, V n_422, V stream_423, V u_424) {
  return ({ V _r = 0; V m_425 = n_422; if ((nat_cmp(m_425, NAT_SMALL(0ull)) == 0)) {  _r = ((V)0); } else if ((nat_cmp(m_425, NAT_SMALL(1ull)) >= 0)) { V p_426 = nat_sub(m_425, NAT_SMALL(1ull)); _r = d_Series_dtake_unode(p_426, ap(stream_423, u_424)); } else rt_panic("match: no case at kernel:608"); _r; });
}
V d_NativeChar_dequal(V a_427, V b_428) {
  return ((V)(((a_427)) == ((b_428))));
}
V d_NativeString_dequal(V a_429, V b_430) {
  return (str_eq(a_429, b_430) ? TRUE_V : FALSE_V);
}
V d_NativeString_dorder_ustep(V order_431, V a_432, V b_433) {
  return ({ V _r = 0; V m_434 = order_431; if (((m_434) == 1)) {  _r = d_NativeString_dorder(a_432, b_433); } else if (((m_434) == 0)) {  _r = CMP_OF(-1); } else if (((m_434) == 2)) {  _r = CMP_OF(1); } else rt_panic("match: no case at kernel:621"); _r; });
}
V d_NativeString_dorder(V a_435, V b_436) {
  return str_order(a_435, b_436);
}
V d_NativeString_dcompare(V a_437, V b_438) {
  return d_Big_dorder_dnumber(d_NativeString_dorder(a_437, b_438));
}
V d_NativeBool_dshow(V value_439) {
  return ({ V _r = 0; V m_440 = value_439; if (((m_440) == TRUE_V)) {  _r = ((V)&S_2); } else if (((m_440) == FALSE_V)) {  _r = ((V)&S_3); } else rt_panic("match: no case at kernel:634"); _r; });
}
V d_Native_dchoose(V test_441, V yes_442, V no_443) {
  return ({ V _r = 0; V m_444 = test_441; if (((m_444) == TRUE_V)) {  _r = ap(yes_442, UNIT); } else if (((m_444) == FALSE_V)) {  _r = ap(no_443, UNIT); } else rt_panic("match: no case at kernel:639"); _r; });
}
V d_NativeString_dfold(V f_445, V text_446, V acc_447) {
_top: ;
  return ({ V _r = 0; V m_448 = text_446; if ((str_is_nil(m_448))) {  _r = acc_447; } else if ((!str_is_nil(m_448))) { V c_449 = str_head(m_448); V rest_450 = str_tail(m_448); _r = ({ V a_451 = rest_450; V a_452 = ap2(f_445, acc_447, c_449); text_446 = a_451; acc_447 = a_452;  goto _top; (V)0; }); } else rt_panic("match: no case at kernel:644"); _r; });
}
V d_NativeString_drepeat(V n_453, V c_454) {
  return ({ V _r = 0; V m_455 = n_453; if ((nat_cmp(m_455, NAT_SMALL(0ull)) == 0)) {  _r = SNIL; } else if ((nat_cmp(m_455, NAT_SMALL(1ull)) >= 0)) { V p_456 = nat_sub(m_455, NAT_SMALL(1ull)); _r = str_cons(c_454, d_NativeString_drepeat(p_456, c_454)); } else rt_panic("match: no case at kernel:648"); _r; });
}
V d_NativeString_dpad(V width_457, V c_458, V value_459) {
  return ({ V length_460 = str_length(value_459); ((((V)(nat_cmp(length_460, width_457) < 0))) != FALSE_V ? str_append(d_NativeString_drepeat(nat_sub(width_457, length_460), c_458), value_459) : value_459); });
}
V d_NativeString_dslash(V c_461) {
  return str_cons((((V)92u)), str_cons((c_461), SNIL));
}
V d_NativeString_descape_uchar(V c_462) {
  return ({ V n_463 = (c_462); ((((V)((n_463) == (((V)34u))))) != FALSE_V ? d_NativeString_dslash(((V)34u)) : ((((V)((n_463) == (((V)92u))))) != FALSE_V ? d_NativeString_dslash(((V)92u)) : ((((V)((n_463) == (((V)10u))))) != FALSE_V ? d_NativeString_dslash(((V)110u)) : ((((V)((n_463) == (((V)13u))))) != FALSE_V ? d_NativeString_dslash(((V)114u)) : ((((V)((n_463) == (((V)9u))))) != FALSE_V ? d_NativeString_dslash(((V)116u)) : ((((V)((n_463) == (((V)8u))))) != FALSE_V ? d_NativeString_dslash(((V)98u)) : ((((((V)((n_463) < (((V)32u))))) | (((V)((n_463) >= (((V)127u))))))) != FALSE_V ? str_cons((((V)92u)), d_NativeString_dpad(NAT_SMALL(3ull), (((V)48u)), d_Big_dshow(d_Big_dof_unat(NAT_SMALL(n_463))))) : str_cons(c_462, SNIL)))))))); });
}
V d_NativeString_descaped(V text_464) {
  return ({ V _r = 0; V m_465 = text_464; if ((str_is_nil(m_465))) {  _r = SNIL; } else if ((!str_is_nil(m_465))) { V c_466 = str_head(m_465); V rest_467 = str_tail(m_465); _r = str_append(d_NativeString_descape_uchar(c_466), d_NativeString_descaped(rest_467)); } else rt_panic("match: no case at kernel:665"); _r; });
}
V d_NativeString_dquoted(V text_468) {
  return str_cons((((V)34u)), str_append(d_NativeString_descaped(text_468), str_cons((((V)34u)), SNIL)));
}
V d_NativeString_dchar_uquoted(V c_469) {
  return ({ V body_470 = ((((V)(((c_469)) == (((V)39u))))) != FALSE_V ? d_NativeString_dslash(((V)39u)) : ((((V)(((c_469)) == (((V)34u))))) != FALSE_V ? str_cons(c_469, SNIL) : d_NativeString_descape_uchar(c_469))); str_cons((((V)39u)), str_append(body_470, str_cons((((V)39u)), SNIL))); });
}
V d_NativeString_dto_ulist(V text_471) {
  return ({ V _r = 0; V m_472 = text_471; if ((str_is_nil(m_472))) {  _r = NIL; } else if ((!str_is_nil(m_472))) { V c_473 = str_head(m_472); V rest_474 = str_tail(m_472); _r = CON(c_473, d_NativeString_dto_ulist(rest_474)); } else rt_panic("match: no case at kernel:673"); _r; });
}
V d_NativeString_dof_ulist(V chars_475) {
  return ({ V _r = 0; V m_476 = chars_475; if (((m_476) == NIL)) {  _r = SNIL; } else if (((m_476) != NIL)) { V c_477 = FLD(m_476, 0); V rest_478 = FLD(m_476, 1); _r = str_cons(c_477, d_NativeString_dof_ulist(rest_478)); } else rt_panic("match: no case at kernel:677"); _r; });
}
V d_NativeString_dmap_ugo(V f_479, V text_480, V acc_481) {
_top: ;
  return ({ V _r = 0; V m_482 = text_480; if ((str_is_nil(m_482))) {  _r = str_reverse(acc_481); } else if ((!str_is_nil(m_482))) { V c_483 = str_head(m_482); V rest_484 = str_tail(m_482); _r = ({ V a_485 = rest_484; V a_486 = str_cons(ap(f_479, c_483), acc_481); text_480 = a_485; acc_481 = a_486;  goto _top; (V)0; }); } else rt_panic("match: no case at kernel:682"); _r; });
}
V d_NativeString_dmap(V f_487, V text_488) {
  return d_NativeString_dmap_ugo(f_487, text_488, SNIL);
}
V d_NativeChar_dlower(V c_489) {
  return ({ V n_490 = (c_489); ((((((V)((n_490) >= (((V)65u))))) & (((V)((n_490) <= (((V)90u))))))) != FALSE_V ? (((V)(uint32_t)((n_490) + (((V)32u))))) : c_489); });
}
V d_NativeChar_dupper(V c_491) {
  return ({ V n_492 = (c_491); ((((((V)((n_492) >= (((V)97u))))) & (((V)((n_492) <= (((V)122u))))))) != FALSE_V ? (((V)(uint32_t)((n_492) - (((V)32u))))) : c_491); });
}
V d_NativeString_dlower(V text_493) {
  return d_NativeString_dmap(clo_new(lam_495, 1, 0), text_493);
}
V d_NativeString_dupper(V text_496) {
  return d_NativeString_dmap(clo_new(lam_498, 1, 0), text_496);
}
V d_NativeString_dall(V f_499, V text_500) {
_top: ;
  return ({ V _r = 0; V m_501 = text_500; if ((str_is_nil(m_501))) {  _r = TRUE_V; } else if ((!str_is_nil(m_501))) { V c_502 = str_head(m_501); V rest_503 = str_tail(m_501); _r = ((ap(f_499, c_502)) != FALSE_V ? ({ V a_504 = rest_503; text_500 = a_504;  goto _top; (V)0; }) : FALSE_V); } else rt_panic("match: no case at kernel:696"); _r; });
}
V d_NativeString_ddrop(V n_505, V text_506) {
_top: ;
  return ({ V _r = 0; V m_507 = n_505; if ((nat_cmp(m_507, NAT_SMALL(0ull)) == 0)) {  _r = text_506; } else if ((nat_cmp(m_507, NAT_SMALL(1ull)) >= 0)) { V p_508 = nat_sub(m_507, NAT_SMALL(1ull)); _r = ({ V _r = 0; V m_509 = text_506; if ((str_is_nil(m_509))) {  _r = SNIL; } else if ((!str_is_nil(m_509))) { V c_510 = str_head(m_509); V rest_511 = str_tail(m_509); _r = ({ V a_512 = p_508; V a_513 = rest_511; n_505 = a_512; text_506 = a_513;  goto _top; (V)0; }); } else rt_panic("match: no case at kernel:703"); _r; }); } else rt_panic("match: no case at kernel:700"); _r; });
}
V d_NativeString_dtake(V n_514, V text_515) {
  return ({ V _r = 0; V m_516 = n_514; if ((nat_cmp(m_516, NAT_SMALL(0ull)) == 0)) {  _r = SNIL; } else if ((nat_cmp(m_516, NAT_SMALL(1ull)) >= 0)) { V p_517 = nat_sub(m_516, NAT_SMALL(1ull)); _r = ({ V _r = 0; V m_518 = text_515; if ((str_is_nil(m_518))) {  _r = SNIL; } else if ((!str_is_nil(m_518))) { V c_519 = str_head(m_518); V rest_520 = str_tail(m_518); _r = str_cons(c_519, d_NativeString_dtake(p_517, rest_520)); } else rt_panic("match: no case at kernel:710"); _r; }); } else rt_panic("match: no case at kernel:707"); _r; });
}
V d_NativeString_dsplit_ugo(V sep_521, V text_522, V current_523, V acc_524) {
_top: ;
  return ({ V _r = 0; V m_525 = text_522; if ((str_is_nil(m_525))) {  _r = list_reverse(CON(str_reverse(current_523), acc_524)); } else if ((!str_is_nil(m_525))) { V c_526 = str_head(m_525); V rest_527 = str_tail(m_525); _r = ((d_NativeChar_dequal(c_526, sep_521)) != FALSE_V ? ({ V a_528 = rest_527; V a_529 = SNIL; V a_530 = CON(str_reverse(current_523), acc_524); text_522 = a_528; current_523 = a_529; acc_524 = a_530;  goto _top; (V)0; }) : ({ V a_531 = rest_527; V a_532 = str_cons(c_526, current_523); text_522 = a_531; current_523 = a_532;  goto _top; (V)0; })); } else rt_panic("match: no case at kernel:715"); _r; });
}
V d_NativeString_dsplit(V sep_533, V text_534) {
  return d_NativeString_dsplit_ugo(sep_533, text_534, SNIL, NIL);
}
V d_SeqList_ddrop(V n_535, V xs_536) {
_top: ;
  return ({ V _r = 0; V m_537 = n_535; if ((nat_cmp(m_537, NAT_SMALL(0ull)) == 0)) {  _r = xs_536; } else if ((nat_cmp(m_537, NAT_SMALL(1ull)) >= 0)) { V p_538 = nat_sub(m_537, NAT_SMALL(1ull)); _r = ({ V _r = 0; V m_539 = xs_536; if (((m_539) == NIL)) {  _r = NIL; } else if (((m_539) != NIL)) { V x_540 = FLD(m_539, 0); V rest_541 = FLD(m_539, 1); _r = ({ V a_542 = p_538; V a_543 = rest_541; n_535 = a_542; xs_536 = a_543;  goto _top; (V)0; }); } else rt_panic("match: no case at kernel:723"); _r; }); } else rt_panic("match: no case at kernel:720"); _r; });
}
V d_SeqList_dtake(V n_544, V xs_545) {
  return ({ V _r = 0; V m_546 = n_544; if ((nat_cmp(m_546, NAT_SMALL(0ull)) == 0)) {  _r = NIL; } else if ((nat_cmp(m_546, NAT_SMALL(1ull)) >= 0)) { V p_547 = nat_sub(m_546, NAT_SMALL(1ull)); _r = ({ V _r = 0; V m_548 = xs_545; if (((m_548) == NIL)) {  _r = NIL; } else if (((m_548) != NIL)) { V x_549 = FLD(m_548, 0); V rest_550 = FLD(m_548, 1); _r = CON(x_549, d_SeqList_dtake(p_547, rest_550)); } else rt_panic("match: no case at kernel:730"); _r; }); } else rt_panic("match: no case at kernel:727"); _r; });
}
V d_SeqList_dmerge_usorted(V cmp_551, V xs_552, V ys_553) {
  return ({ V _r = 0; V m_554 = xs_552; V m_555 = ys_553; if (((m_554) == NIL)) { V ys_556 = m_555; _r = ys_556; } else if (((m_554) != NIL) && ((m_555) == NIL)) { V x_557 = FLD(m_554, 0); V rest_558 = FLD(m_554, 1); _r = CON(x_557, rest_558); } else if (((m_554) != NIL) && ((m_555) != NIL)) { V x_559 = FLD(m_554, 0); V xt_560 = FLD(m_554, 1); V y_561 = FLD(m_555, 0); V yt_562 = FLD(m_555, 1); _r = ((d_Big_dis_ule(ap2(cmp_551, x_559, y_561), d_Big_dzero())) != FALSE_V ? CON(x_559, d_SeqList_dmerge_usorted(cmp_551, xt_560, CON(y_561, yt_562))) : CON(y_561, d_SeqList_dmerge_usorted(cmp_551, CON(x_559, xt_560), yt_562))); } else rt_panic("match: no case at kernel:735"); _r; });
}
V d_SeqList_dsort(V cmp_563, V xs_564) {
  return ({ V _r = 0; V m_565 = xs_564; if (((m_565) == NIL)) {  _r = NIL; } else if (((m_565) != NIL) && ((FLD(m_565, 1)) == NIL)) { V x_566 = FLD(m_565, 0); _r = CON(x_566, NIL); } else if (((m_565) != NIL) && ((FLD(m_565, 1)) != NIL)) { V x_567 = FLD(m_565, 0); V y_568 = FLD(FLD(m_565, 1), 0); V rest_569 = FLD(FLD(m_565, 1), 1); _r = ({ V all_570 = CON(x_567, CON(y_568, rest_569)); ({ V half_571 = d_NativeNat_dhalf(list_length(all_570)); d_SeqList_dmerge_usorted(cmp_563, d_SeqList_dsort(cmp_563, d_SeqList_dtake(half_571, all_570)), d_SeqList_dsort(cmp_563, d_SeqList_ddrop(half_571, all_570))); }); }); } else rt_panic("match: no case at kernel:741"); _r; });
}
V d_SeqList_dindex_ugo(V f_572, V xs_573, V index_574) {
_top: ;
  return ({ V _r = 0; V m_575 = xs_573; if (((m_575) == NIL)) {  _r = NONE; } else if (((m_575) != NIL)) { V x_576 = FLD(m_575, 0); V rest_577 = FLD(m_575, 1); _r = ((ap(f_572, x_576)) != FALSE_V ? SOME(index_574) : ({ V a_578 = rest_577; V a_579 = d_Big_dsucc(index_574); xs_573 = a_578; index_574 = a_579;  goto _top; (V)0; })); } else rt_panic("match: no case at kernel:750"); _r; });
}
V d_SeqList_dfind_uindex(V f_580, V xs_581) {
  return d_SeqList_dindex_ugo(f_580, xs_581, d_Big_dzero());
}
V d_SeqList_dremove_uassoc(V eq_582, V key_583, V xs_584) {
  return ({ V _r = 0; V m_585 = xs_584; if (((m_585) == NIL)) {  _r = NIL; } else if (((m_585) != NIL) && (tag_of(FLD(m_585, 0)) == 0)) { V k_586 = FLD(FLD(m_585, 0), 0); V v_587 = FLD(FLD(m_585, 0), 1); V rest_588 = FLD(m_585, 1); _r = ((ap2(eq_582, key_583, k_586)) != FALSE_V ? rest_588 : CON(rt_ctor2(0, k_586, v_587), d_SeqList_dremove_uassoc(eq_582, key_583, rest_588))); } else rt_panic("match: no case at kernel:757"); _r; });
}
V d_SeqList_dassoc(V eq_589, V key_590, V xs_591) {
_top: ;
  return ({ V _r = 0; V m_592 = xs_591; if (((m_592) == NIL)) {  _r = NONE; } else if (((m_592) != NIL) && (tag_of(FLD(m_592, 0)) == 0)) { V k_593 = FLD(FLD(m_592, 0), 0); V v_594 = FLD(FLD(m_592, 0), 1); V rest_595 = FLD(m_592, 1); _r = ((ap2(eq_589, key_590, k_593)) != FALSE_V ? SOME(v_594) : ({ V a_596 = rest_595; xs_591 = a_596;  goto _top; (V)0; })); } else rt_panic("match: no case at kernel:762"); _r; });
}
V d_SeqList_dfold_uright(V f_597, V xs_598, V acc_599) {
  return ({ V _r = 0; V m_600 = xs_598; if (((m_600) == NIL)) {  _r = acc_599; } else if (((m_600) != NIL)) { V x_601 = FLD(m_600, 0); V rest_602 = FLD(m_600, 1); _r = ap2(f_597, x_601, d_SeqList_dfold_uright(f_597, rest_602, acc_599)); } else rt_panic("match: no case at kernel:767"); _r; });
}
V d_SeqList_dfilter_ustep(V yes_603, V x_604, V rest_605) {
  return ({ V _r = 0; V m_606 = yes_603; if (((m_606) == TRUE_V)) {  _r = CON(x_604, rest_605); } else if (((m_606) == FALSE_V)) {  _r = rest_605; } else rt_panic("match: no case at kernel:771"); _r; });
}
V d_SeqList_dmapi_ugo(V f_607, V xs_608, V index_609) {
  return ({ V _r = 0; V m_610 = xs_608; if (((m_610) == NIL)) {  _r = NIL; } else if (((m_610) != NIL)) { V x_611 = FLD(m_610, 0); V rest_612 = FLD(m_610, 1); _r = CON(ap2(f_607, index_609, x_611), d_SeqList_dmapi_ugo(f_607, rest_612, d_Big_dsucc(index_609))); } else rt_panic("match: no case at kernel:776"); _r; });
}
V d_SeqList_dmapi(V f_613, V xs_614) {
  return d_SeqList_dmapi_ugo(f_613, xs_614, d_Big_dzero());
}
V d_SeqList_dfilter(V f_615, V xs_616) {
  return ({ V _r = 0; V m_617 = xs_616; if (((m_617) == NIL)) {  _r = NIL; } else if (((m_617) != NIL)) { V x_618 = FLD(m_617, 0); V rest_619 = FLD(m_617, 1); _r = d_SeqList_dfilter_ustep(ap(f_615, x_618), x_618, d_SeqList_dfilter(f_615, rest_619)); } else rt_panic("match: no case at kernel:783"); _r; });
}
V d_SeqList_dfind(V f_620, V xs_621) {
_top: ;
  return ({ V _r = 0; V m_622 = xs_621; if (((m_622) == NIL)) {  _r = NONE; } else if (((m_622) != NIL)) { V x_623 = FLD(m_622, 0); V rest_624 = FLD(m_622, 1); _r = ((ap(f_620, x_623)) != FALSE_V ? SOME(x_623) : ({ V a_625 = rest_624; xs_621 = a_625;  goto _top; (V)0; })); } else rt_panic("match: no case at kernel:788"); _r; });
}
V d_SeqList_dkeep(V x_626, V rest_627) {
  return ({ V _r = 0; V m_628 = x_626; if (((m_628) == NONE)) {  _r = rest_627; } else if (((m_628) != NONE)) { V v_629 = FLD(m_628, 0); _r = CON(v_629, rest_627); } else rt_panic("match: no case at kernel:792"); _r; });
}
V d_SeqList_dfilter_umap(V f_630, V xs_631) {
  return ({ V _r = 0; V m_632 = xs_631; if (((m_632) == NIL)) {  _r = NIL; } else if (((m_632) != NIL)) { V x_633 = FLD(m_632, 0); V rest_634 = FLD(m_632, 1); _r = d_SeqList_dkeep(ap(f_630, x_633), d_SeqList_dfilter_umap(f_630, rest_634)); } else rt_panic("match: no case at kernel:797"); _r; });
}
V d_SeqList_dfilteri_ugo(V f_635, V xs_636, V i_637) {
  return ({ V _r = 0; V m_638 = xs_636; if (((m_638) == NIL)) {  _r = NIL; } else if (((m_638) != NIL)) { V x_639 = FLD(m_638, 0); V rest_640 = FLD(m_638, 1); _r = d_SeqList_dfilter_ustep(ap2(f_635, i_637, x_639), x_639, d_SeqList_dfilteri_ugo(f_635, rest_640, d_Big_dsucc(i_637))); } else rt_panic("match: no case at kernel:802"); _r; });
}
V d_SeqList_dfilteri(V f_641, V xs_642) {
  return d_SeqList_dfilteri_ugo(f_641, xs_642, d_Big_dzero());
}
V d_SeqList_dinsert_uunique(V cmp_643, V value_644, V xs_645) {
  return ({ V _r = 0; V m_646 = xs_645; if (((m_646) == NIL)) {  _r = CON(value_644, NIL); } else if (((m_646) != NIL)) { V x_647 = FLD(m_646, 0); V rest_648 = FLD(m_646, 1); _r = ({ V order_649 = ap2(cmp_643, value_644, x_647); ((d_Big_dis_ult(order_649, d_Big_dzero())) != FALSE_V ? CON(value_644, CON(x_647, rest_648)) : ((d_Big_dis_uzero(order_649)) != FALSE_V ? CON(value_644, rest_648) : CON(x_647, d_SeqList_dinsert_uunique(cmp_643, value_644, rest_648)))); }); } else rt_panic("match: no case at kernel:809"); _r; });
}
V d_SeqList_dsort_uuniq(V cmp_650, V xs_651) {
  return ({ V _r = 0; V m_652 = xs_651; if (((m_652) == NIL)) {  _r = NIL; } else if (((m_652) != NIL)) { V x_653 = FLD(m_652, 0); V rest_654 = FLD(m_652, 1); _r = d_SeqList_dinsert_uunique(cmp_650, x_653, d_SeqList_dsort_uuniq(cmp_650, rest_654)); } else rt_panic("match: no case at kernel:816"); _r; });
}
V d_SeqList_dinit_ugo(V f_655, V n_656, V i_657) {
  return ((d_Big_dis_ult(i_657, n_656)) != FALSE_V ? CON(ap(f_655, i_657), d_SeqList_dinit_ugo(f_655, n_656, d_Big_dsucc(i_657))) : NIL);
}
V d_SeqList_dinit(V n_658, V f_659) {
  return d_SeqList_dinit_ugo(f_659, n_658, d_Big_dzero());
}
V d_Assoc_drows(V map_660) {
  return ({ V _r = 0; V m_661 = map_660; switch (tag_of(m_661)) { case 0: { V rows_662 = FLD(m_661, 0); _r = rows_662; break; } case 1: { V left_663 = FLD(m_661, 1); V key_664 = FLD(m_661, 2); V value_665 = FLD(m_661, 3); V right_666 = FLD(m_661, 4); _r = list_append(d_Assoc_drows(left_663), CON(rt_ctor2(0, key_664, value_665), d_Assoc_drows(right_666))); break; } default: rt_panic("match: no case at kernel:824"); } _r; });
}
V d_Assoc_dfold_urows(V f_667, V rows_668, V acc_669) {
_top: ;
  return ({ V _r = 0; V m_670 = rows_668; if (((m_670) == NIL)) {  _r = acc_669; } else if (((m_670) != NIL) && (tag_of(FLD(m_670, 0)) == 0)) { V k_671 = FLD(FLD(m_670, 0), 0); V v_672 = FLD(FLD(m_670, 0), 1); V rest_673 = FLD(m_670, 1); _r = ({ V a_674 = rest_673; V a_675 = ap3(f_667, k_671, v_672, acc_669); rows_668 = a_674; acc_669 = a_675;  goto _top; (V)0; }); } else rt_panic("match: no case at kernel:829"); _r; });
}
V d_Assoc_dfold(V f_676, V map_677, V acc_678) {
  return d_Assoc_dfold_urows(f_676, d_Assoc_drows(map_677), acc_678);
}
V d_Assoc_dempty(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor1(0, NIL); rt_root(&memo); done = 1; }
  return memo;
}
V d_Assoc_dsingleton(V key_679, V value_680) {
  return ({ Obj *_o = rt_ctor(1, 5); _o->f[0] = NAT_SMALL(1ull); _o->f[1] = rt_ctor1(0, NIL); _o->f[2] = key_679; _o->f[3] = value_680; _o->f[4] = rt_ctor1(0, NIL); (V)_o; });
}
V d_Assoc_dfind_urows(V cmp_681, V key_682, V rows_683) {
_top: ;
  return ({ V _r = 0; V m_684 = rows_683; if (((m_684) == NIL)) {  _r = NONE; } else if (((m_684) != NIL) && (tag_of(FLD(m_684, 0)) == 0)) { V k_685 = FLD(FLD(m_684, 0), 0); V v_686 = FLD(FLD(m_684, 0), 1); V rest_687 = FLD(m_684, 1); _r = ((d_Big_dorder_deq(ap2(cmp_681, key_682, k_685))) != FALSE_V ? SOME(v_686) : ({ V a_688 = rest_687; rows_683 = a_688;  goto _top; (V)0; })); } else rt_panic("match: no case at kernel:838"); _r; });
}
V scc_29(uint32_t w, V *a) {
  V cmp_689;
  V key_690;
  V map_691;
  V order_692;
  V cmp_693;
  V key_694;
  V left_695;
  V value_696;
  V right_697;
  switch (w) {
  default: cmp_689 = a[0]; key_690 = a[1]; map_691 = a[2]; goto _m0;
  case 1: order_692 = a[0]; cmp_693 = a[1]; key_694 = a[2]; left_695 = a[3]; value_696 = a[4]; right_697 = a[5]; goto _m1;
  }
_m0: ;
  return ({ V _r = 0; V m_698 = map_691; switch (tag_of(m_698)) { case 0: { V rows_699 = FLD(m_698, 0); _r = d_Assoc_dfind_urows(cmp_689, key_690, rows_699); break; } case 1: { V left_700 = FLD(m_698, 1); V k_701 = FLD(m_698, 2); V value_702 = FLD(m_698, 3); V right_703 = FLD(m_698, 4); _r = ({ V a_704 = ap2(cmp_689, key_690, k_701); V a_705 = cmp_689; V a_706 = key_690; V a_707 = left_700; V a_708 = value_702; V a_709 = right_703; order_692 = a_704; cmp_693 = a_705; key_694 = a_706; left_695 = a_707; value_696 = a_708; right_697 = a_709;  goto _m1; (V)0; }); break; } default: rt_panic("match: no case at kernel:843"); } _r; });
_m1: ;
  return ({ V _r = 0; V m_710 = order_692; if (((m_710) == 0)) {  _r = ({ V a_711 = cmp_693; V a_712 = key_694; V a_713 = left_695; cmp_689 = a_711; key_690 = a_712; map_691 = a_713;  goto _m0; (V)0; }); } else if (((m_710) == 1)) {  _r = SOME(value_696); } else if (((m_710) == 2)) {  _r = ({ V a_714 = cmp_693; V a_715 = key_694; V a_716 = right_697; cmp_689 = a_714; key_690 = a_715; map_691 = a_716;  goto _m0; (V)0; }); } else rt_panic("match: no case at kernel:848"); _r; });
}
V scc_29(uint32_t w, V *a);
V d_Assoc_dfind(V cmp_689, V key_690, V map_691) {
  V w_a[] = {cmp_689, key_690, map_691};
  return scc_29(0, w_a);
}
V scc_29(uint32_t w, V *a);
V d_Assoc_dfind_ustep(V order_692, V cmp_693, V key_694, V left_695, V value_696, V right_697) {
  V w_a[] = {order_692, cmp_693, key_694, left_695, value_696, right_697};
  return scc_29(1, w_a);
}
V d_Assoc_dadd_urows(V cmp_717, V key_718, V value_719, V rows_720) {
  return ({ V _r = 0; V m_721 = rows_720; if (((m_721) == NIL)) {  _r = CON(rt_ctor2(0, key_718, value_719), NIL); } else if (((m_721) != NIL) && (tag_of(FLD(m_721, 0)) == 0)) { V k_722 = FLD(FLD(m_721, 0), 0); V v_723 = FLD(FLD(m_721, 0), 1); V rest_724 = FLD(m_721, 1); _r = ({ V order_725 = ap2(cmp_717, key_718, k_722); ((d_Big_dorder_dlt(order_725)) != FALSE_V ? CON(rt_ctor2(0, key_718, value_719), CON(rt_ctor2(0, k_722, v_723), rest_724)) : ((d_Big_dorder_deq(order_725)) != FALSE_V ? CON(rt_ctor2(0, key_718, value_719), rest_724) : CON(rt_ctor2(0, k_722, v_723), d_Assoc_dadd_urows(cmp_717, key_718, value_719, rest_724)))); }); } else rt_panic("match: no case at kernel:854"); _r; });
}
V d_Assoc_dadd(V cmp_726, V key_727, V value_728, V map_729) {
_top: ;
  return ({ V _r = 0; V m_730 = map_729; if ((tag_of(m_730) == 0) && ((FLD(m_730, 0)) == NIL)) {  _r = d_Assoc_dnode(rt_ctor1(0, NIL), key_727, value_728, rt_ctor1(0, NIL)); } else if ((tag_of(m_730) == 0) && ((FLD(m_730, 0)) != NIL)) { V pair_731 = FLD(FLD(m_730, 0), 0); V rest_732 = FLD(FLD(m_730, 0), 1); _r = ({ V a_733 = d_Assoc_dfrom_urows(cmp_726, CON(pair_731, rest_732), rt_ctor1(0, NIL)); map_729 = a_733;  goto _top; (V)0; }); } else if ((tag_of(m_730) == 1)) { V left_734 = FLD(m_730, 1); V k_735 = FLD(m_730, 2); V v_736 = FLD(m_730, 3); V right_737 = FLD(m_730, 4); _r = d_Assoc_dadd_ustep(ap2(cmp_726, key_727, k_735), cmp_726, key_727, value_728, left_734, k_735, v_736, right_737); } else rt_panic("match: no case at kernel:861"); _r; });
}
V d_Assoc_dadd_ustep(V order_738, V cmp_739, V key_740, V value_741, V left_742, V k_743, V v_744, V right_745) {
  return ({ V _r = 0; V m_746 = order_738; if (((m_746) == 0)) {  _r = d_Assoc_dbalance(d_Assoc_dadd(cmp_739, key_740, value_741, left_742), k_743, v_744, right_745); } else if (((m_746) == 1)) {  _r = d_Assoc_dnode(left_742, key_740, value_741, right_745); } else if (((m_746) == 2)) {  _r = d_Assoc_dbalance(left_742, k_743, v_744, d_Assoc_dadd(cmp_739, key_740, value_741, right_745)); } else rt_panic("match: no case at kernel:867"); _r; });
}
V d_Assoc_dfrom_urows(V cmp_747, V rows_748, V map_749) {
_top: ;
  return ({ V _r = 0; V m_750 = rows_748; if (((m_750) == NIL)) {  _r = map_749; } else if (((m_750) != NIL) && (tag_of(FLD(m_750, 0)) == 0)) { V k_751 = FLD(FLD(m_750, 0), 0); V v_752 = FLD(FLD(m_750, 0), 1); V rest_753 = FLD(m_750, 1); _r = ({ V a_754 = rest_753; V a_755 = d_Assoc_dadd(cmp_747, k_751, v_752, map_749); rows_748 = a_754; map_749 = a_755;  goto _top; (V)0; }); } else rt_panic("match: no case at kernel:873"); _r; });
}
V d_Assoc_dheight(V map_756) {
  return ({ V _r = 0; V m_757 = map_756; switch (tag_of(m_757)) { case 0: {  _r = NAT_SMALL(0ull); break; } case 1: { V height_758 = FLD(m_757, 0); _r = height_758; break; } default: rt_panic("match: no case at kernel:878"); } _r; });
}
V d_Assoc_dnode(V left_759, V key_760, V value_761, V right_762) {
  return ({ Obj *_o = rt_ctor(1, 5); _o->f[0] = nat_add(NAT_SMALL(1ull), nat_max(d_Assoc_dheight(left_759), d_Assoc_dheight(right_762))); _o->f[1] = left_759; _o->f[2] = key_760; _o->f[3] = value_761; _o->f[4] = right_762; (V)_o; });
}
V d_Assoc_drotate_uright(V left_763, V key_764, V value_765, V right_766) {
  return ({ V _r = 0; V m_767 = left_763; switch (tag_of(m_767)) { case 0: { V rows_768 = FLD(m_767, 0); _r = d_Assoc_dnode(rt_ctor1(0, rows_768), key_764, value_765, right_766); break; } case 1: { V ll_769 = FLD(m_767, 1); V lk_770 = FLD(m_767, 2); V lv_771 = FLD(m_767, 3); V lr_772 = FLD(m_767, 4); _r = ((((V)(nat_cmp(d_Assoc_dheight(ll_769), d_Assoc_dheight(lr_772)) < 0))) != FALSE_V ? d_Assoc_drotate_uleft_uright(ll_769, lk_770, lv_771, lr_772, key_764, value_765, right_766) : d_Assoc_dnode(ll_769, lk_770, lv_771, d_Assoc_dnode(lr_772, key_764, value_765, right_766))); break; } default: rt_panic("match: no case at kernel:886"); } _r; });
}
V d_Assoc_drotate_uleft_uright(V ll_773, V lk_774, V lv_775, V lr_776, V key_777, V value_778, V right_779) {
  return ({ V _r = 0; V m_780 = lr_776; switch (tag_of(m_780)) { case 0: { V rows_781 = FLD(m_780, 0); _r = d_Assoc_dnode(ll_773, lk_774, lv_775, d_Assoc_dnode(rt_ctor1(0, rows_781), key_777, value_778, right_779)); break; } case 1: { V lrl_782 = FLD(m_780, 1); V lrk_783 = FLD(m_780, 2); V lrv_784 = FLD(m_780, 3); V lrr_785 = FLD(m_780, 4); _r = d_Assoc_dnode(d_Assoc_dnode(ll_773, lk_774, lv_775, lrl_782), lrk_783, lrv_784, d_Assoc_dnode(lrr_785, key_777, value_778, right_779)); break; } default: rt_panic("match: no case at kernel:894"); } _r; });
}
V d_Assoc_drotate_uleft(V left_786, V key_787, V value_788, V right_789) {
  return ({ V _r = 0; V m_790 = right_789; switch (tag_of(m_790)) { case 0: { V rows_791 = FLD(m_790, 0); _r = d_Assoc_dnode(left_786, key_787, value_788, rt_ctor1(0, rows_791)); break; } case 1: { V rl_792 = FLD(m_790, 1); V rk_793 = FLD(m_790, 2); V rv_794 = FLD(m_790, 3); V rr_795 = FLD(m_790, 4); _r = ((((V)(nat_cmp(d_Assoc_dheight(rr_795), d_Assoc_dheight(rl_792)) < 0))) != FALSE_V ? d_Assoc_drotate_uright_uleft(left_786, key_787, value_788, rl_792, rk_793, rv_794, rr_795) : d_Assoc_dnode(d_Assoc_dnode(left_786, key_787, value_788, rl_792), rk_793, rv_794, rr_795)); break; } default: rt_panic("match: no case at kernel:899"); } _r; });
}
V d_Assoc_drotate_uright_uleft(V left_796, V key_797, V value_798, V rl_799, V rk_800, V rv_801, V rr_802) {
  return ({ V _r = 0; V m_803 = rl_799; switch (tag_of(m_803)) { case 0: { V rows_804 = FLD(m_803, 0); _r = d_Assoc_dnode(d_Assoc_dnode(left_796, key_797, value_798, rt_ctor1(0, rows_804)), rk_800, rv_801, rr_802); break; } case 1: { V rll_805 = FLD(m_803, 1); V rlk_806 = FLD(m_803, 2); V rlv_807 = FLD(m_803, 3); V rlr_808 = FLD(m_803, 4); _r = d_Assoc_dnode(d_Assoc_dnode(left_796, key_797, value_798, rll_805), rlk_806, rlv_807, d_Assoc_dnode(rlr_808, rk_800, rv_801, rr_802)); break; } default: rt_panic("match: no case at kernel:907"); } _r; });
}
V d_Assoc_dbalance(V left_809, V key_810, V value_811, V right_812) {
  return ((((V)(nat_cmp(nat_add(d_Assoc_dheight(right_812), NAT_SMALL(1ull)), d_Assoc_dheight(left_809)) < 0))) != FALSE_V ? d_Assoc_drotate_uright(left_809, key_810, value_811, right_812) : ((((V)(nat_cmp(nat_add(d_Assoc_dheight(left_809), NAT_SMALL(1ull)), d_Assoc_dheight(right_812)) < 0))) != FALSE_V ? d_Assoc_drotate_uleft(left_809, key_810, value_811, right_812) : d_Assoc_dnode(left_809, key_810, value_811, right_812)));
}
V d_Assoc_dremove_urows(V cmp_813, V key_814, V rows_815) {
  return ({ V _r = 0; V m_816 = rows_815; if (((m_816) == NIL)) {  _r = NIL; } else if (((m_816) != NIL) && (tag_of(FLD(m_816, 0)) == 0)) { V k_817 = FLD(FLD(m_816, 0), 0); V v_818 = FLD(FLD(m_816, 0), 1); V rest_819 = FLD(m_816, 1); _r = ((d_Big_dorder_deq(ap2(cmp_813, key_814, k_817))) != FALSE_V ? rest_819 : CON(rt_ctor2(0, k_817, v_818), d_Assoc_dremove_urows(cmp_813, key_814, rest_819))); } else rt_panic("match: no case at kernel:919"); _r; });
}
V d_Assoc_dremove(V cmp_820, V key_821, V map_822) {
  return d_Assoc_dfrom_urows(cmp_820, d_Assoc_dremove_urows(cmp_820, key_821, d_Assoc_drows(map_822)), rt_ctor1(0, NIL));
}
V d_Assoc_dmap_urows(V f_823, V rows_824) {
  return ({ V _r = 0; V m_825 = rows_824; if (((m_825) == NIL)) {  _r = NIL; } else if (((m_825) != NIL) && (tag_of(FLD(m_825, 0)) == 0)) { V k_826 = FLD(FLD(m_825, 0), 0); V v_827 = FLD(FLD(m_825, 0), 1); V rest_828 = FLD(m_825, 1); _r = CON(rt_ctor2(0, k_826, ap(f_823, v_827)), d_Assoc_dmap_urows(f_823, rest_828)); } else rt_panic("match: no case at kernel:926"); _r; });
}
V d_Assoc_dmap(V f_829, V map_830) {
  return ({ V _r = 0; V m_831 = map_830; switch (tag_of(m_831)) { case 0: { V rows_832 = FLD(m_831, 0); _r = rt_ctor1(0, d_Assoc_dmap_urows(f_829, rows_832)); break; } case 1: { V height_833 = FLD(m_831, 0); V left_834 = FLD(m_831, 1); V key_835 = FLD(m_831, 2); V value_836 = FLD(m_831, 3); V right_837 = FLD(m_831, 4); _r = ({ Obj *_o = rt_ctor(1, 5); _o->f[0] = height_833; _o->f[1] = d_Assoc_dmap(f_829, left_834); _o->f[2] = key_835; _o->f[3] = ap(f_829, value_836); _o->f[4] = d_Assoc_dmap(f_829, right_837); (V)_o; }); break; } default: rt_panic("match: no case at kernel:931"); } _r; });
}
V d_Assoc_dkeep(V key_838, V value_839, V rest_840) {
  return ({ V _r = 0; V m_841 = value_839; if (((m_841) == NONE)) {  _r = rest_840; } else if (((m_841) != NONE)) { V v_842 = FLD(m_841, 0); _r = CON(rt_ctor2(0, key_838, v_842), rest_840); } else rt_panic("match: no case at kernel:935"); _r; });
}
V d_Assoc_dmerge_urows(V cmp_843, V f_844, V xs_845, V ys_846) {
  return ({ V _r = 0; V m_847 = xs_845; V m_848 = ys_846; if (((m_847) == NIL) && ((m_848) == NIL)) {  _r = NIL; } else if (((m_847) != NIL) && (tag_of(FLD(m_847, 0)) == 0) && ((m_848) == NIL)) { V k_849 = FLD(FLD(m_847, 0), 0); V v_850 = FLD(FLD(m_847, 0), 1); V tail_851 = FLD(m_847, 1); _r = d_Assoc_dkeep(k_849, ap3(f_844, k_849, SOME(v_850), NONE), d_Assoc_dmerge_urows(cmp_843, f_844, tail_851, NIL)); } else if (((m_847) == NIL) && ((m_848) != NIL) && (tag_of(FLD(m_848, 0)) == 0)) { V k_852 = FLD(FLD(m_848, 0), 0); V v_853 = FLD(FLD(m_848, 0), 1); V tail_854 = FLD(m_848, 1); _r = d_Assoc_dkeep(k_852, ap3(f_844, k_852, NONE, SOME(v_853)), d_Assoc_dmerge_urows(cmp_843, f_844, NIL, tail_854)); } else if (((m_847) != NIL) && (tag_of(FLD(m_847, 0)) == 0) && ((m_848) != NIL) && (tag_of(FLD(m_848, 0)) == 0)) { V xk_855 = FLD(FLD(m_847, 0), 0); V xv_856 = FLD(FLD(m_847, 0), 1); V xt_857 = FLD(m_847, 1); V yk_858 = FLD(FLD(m_848, 0), 0); V yv_859 = FLD(FLD(m_848, 0), 1); V yt_860 = FLD(m_848, 1); _r = ({ V order_861 = ap2(cmp_843, xk_855, yk_858); ((d_Big_dorder_dlt(order_861)) != FALSE_V ? d_Assoc_dkeep(xk_855, ap3(f_844, xk_855, SOME(xv_856), NONE), d_Assoc_dmerge_urows(cmp_843, f_844, xt_857, CON(rt_ctor2(0, yk_858, yv_859), yt_860))) : ((d_Big_dorder_deq(order_861)) != FALSE_V ? d_Assoc_dkeep(xk_855, ap3(f_844, xk_855, SOME(xv_856), SOME(yv_859)), d_Assoc_dmerge_urows(cmp_843, f_844, xt_857, yt_860)) : d_Assoc_dkeep(yk_858, ap3(f_844, yk_858, NONE, SOME(yv_859)), d_Assoc_dmerge_urows(cmp_843, f_844, CON(rt_ctor2(0, xk_855, xv_856), xt_857), yt_860)))); }); } else rt_panic("match: no case at kernel:940"); _r; });
}
V d_Assoc_dmerge(V cmp_862, V f_863, V xs_864, V ys_865) {
  return d_Assoc_dfrom_urows(cmp_862, d_Assoc_dmerge_urows(cmp_862, f_863, d_Assoc_drows(xs_864), d_Assoc_drows(ys_865)), rt_ctor1(0, NIL));
}
V d_SeqList_dmap(V f_866, V xs_867) {
  return ({ V _r = 0; V m_868 = xs_867; if (((m_868) == NIL)) {  _r = NIL; } else if (((m_868) != NIL)) { V x_869 = FLD(m_868, 0); V tail_870 = FLD(m_868, 1); _r = CON(ap(f_866, x_869), d_SeqList_dmap(f_866, tail_870)); } else rt_panic("match: no case at kernel:951"); _r; });
}
V d_SeqList_dexists(V f_871, V xs_872) {
_top: ;
  return ({ V _r = 0; V m_873 = xs_872; if (((m_873) == NIL)) {  _r = FALSE_V; } else if (((m_873) != NIL)) { V x_874 = FLD(m_873, 0); V tail_875 = FLD(m_873, 1); _r = ((ap(f_871, x_874)) != FALSE_V ? TRUE_V : ({ V a_876 = tail_875; xs_872 = a_876;  goto _top; (V)0; })); } else rt_panic("match: no case at kernel:956"); _r; });
}
V d_SeqList_dall(V f_877, V xs_878) {
_top: ;
  return ({ V _r = 0; V m_879 = xs_878; if (((m_879) == NIL)) {  _r = TRUE_V; } else if (((m_879) != NIL)) { V x_880 = FLD(m_879, 0); V tail_881 = FLD(m_879, 1); _r = ((ap(f_877, x_880)) != FALSE_V ? ({ V a_882 = tail_881; xs_878 = a_882;  goto _top; (V)0; }) : FALSE_V); } else rt_panic("match: no case at kernel:961"); _r; });
}
V d_SeqList_dfold(V f_883, V xs_884, V acc_885) {
_top: ;
  return ({ V _r = 0; V m_886 = xs_884; if (((m_886) == NIL)) {  _r = acc_885; } else if (((m_886) != NIL)) { V x_887 = FLD(m_886, 0); V tail_888 = FLD(m_886, 1); _r = ({ V a_889 = tail_888; V a_890 = ap2(f_883, acc_885, x_887); xs_884 = a_889; acc_885 = a_890;  goto _top; (V)0; }); } else rt_panic("match: no case at kernel:966"); _r; });
}
V d_SeqList_ddrop_uwhile(V f_891, V xs_892) {
_top: ;
  return ({ V _r = 0; V m_893 = xs_892; if (((m_893) == NIL)) {  _r = NIL; } else if (((m_893) != NIL)) { V x_894 = FLD(m_893, 0); V tail_895 = FLD(m_893, 1); _r = ((ap(f_891, x_894)) != FALSE_V ? ({ V a_896 = tail_895; xs_892 = a_896;  goto _top; (V)0; }) : CON(x_894, tail_895)); } else rt_panic("match: no case at kernel:971"); _r; });
}
V d_Equal_dOptionOf_uString_u(V left_941, V right_942) {
  return ({ V _r = 0; V m_943 = left_941; V m_944 = right_942; if (((m_943) == NONE) && ((m_944) == NONE)) {  _r = TRUE_V; } else if (((m_943) != NONE) && ((m_944) != NONE)) { V left689_945 = FLD(m_943, 0); V right690_946 = FLD(m_944, 0); _r = ((d_NativeString_dequal(left689_945, right690_946)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1048"); _r; });
}
V d_Get_dGlobal_dentries(V value_988) {
  return ({ V _r = 0; V m_989 = value_988; if ((tag_of(m_989) == 0)) { V field0_990 = FLD(m_989, 0); _r = field0_990; } else rt_panic("match: no case at kernel:1080"); _r; });
}
V d_Get_dGlobal_dfamilies(V value_991) {
  return ({ V _r = 0; V m_992 = value_991; if ((tag_of(m_992) == 0)) { V field1_993 = FLD(m_992, 1); _r = field1_993; } else rt_panic("match: no case at kernel:1084"); _r; });
}
V d_Get_dCheck_dCtx_dlocals(V value_994) {
  return ({ V _r = 0; V m_995 = value_994; if ((tag_of(m_995) == 0)) { V field2_996 = FLD(m_995, 2); _r = field2_996; } else rt_panic("match: no case at kernel:1088"); _r; });
}
V d_Get_dCheck_dCtx_dglobals(V value_997) {
  return ({ V _r = 0; V m_998 = value_997; if ((tag_of(m_998) == 0)) { V field0_999 = FLD(m_998, 0); _r = field0_999; } else rt_panic("match: no case at kernel:1092"); _r; });
}
V d_Get_dPositivity_dCtor_dc_uname(V value_1000) {
  return ({ V _r = 0; V m_1001 = value_1000; if ((tag_of(m_1001) == 0)) { V field0_1002 = FLD(m_1001, 0); _r = field0_1002; } else rt_panic("match: no case at kernel:1096"); _r; });
}
V d_Get_dPositivity_dFamily_df_uctors(V value_1003) {
  return ({ V _r = 0; V m_1004 = value_1003; if ((tag_of(m_1004) == 0)) { V field5_1005 = FLD(m_1004, 5); _r = field5_1005; } else rt_panic("match: no case at kernel:1100"); _r; });
}
V d_Get_dPositivity_dFamily_df_uparams(V value_1006) {
  return ({ V _r = 0; V m_1007 = value_1006; if ((tag_of(m_1007) == 0)) { V field1_1008 = FLD(m_1007, 1); _r = field1_1008; } else rt_panic("match: no case at kernel:1104"); _r; });
}
V d_Get_dPositivity_dFamily_df_uname(V value_1009) {
  return ({ V _r = 0; V m_1010 = value_1009; if ((tag_of(m_1010) == 0)) { V field0_1011 = FLD(m_1010, 0); _r = field0_1011; } else rt_panic("match: no case at kernel:1108"); _r; });
}
V d_Get_dPositivity_dFamily_df_uindices(V value_1012) {
  return ({ V _r = 0; V m_1013 = value_1012; if ((tag_of(m_1013) == 0)) { V field2_1014 = FLD(m_1013, 2); _r = field2_1014; } else rt_panic("match: no case at kernel:1112"); _r; });
}
V d_Get_dPositivity_dCtor_dc_uargs(V value_1015) {
  return ({ V _r = 0; V m_1016 = value_1015; if ((tag_of(m_1016) == 0)) { V field1_1017 = FLD(m_1016, 1); _r = field1_1017; } else rt_panic("match: no case at kernel:1116"); _r; });
}
V d_Get_dCheck_dCtx_denv(V value_1018) {
  return ({ V _r = 0; V m_1019 = value_1018; if ((tag_of(m_1019) == 0)) { V field1_1020 = FLD(m_1019, 1); _r = field1_1020; } else rt_panic("match: no case at kernel:1120"); _r; });
}
V d_Get_dTerm_dElim_de_uscrut_uq(V value_1085) {
  return ({ V _r = 0; V m_1086 = value_1085; if ((tag_of(m_1086) == 0)) { V field2_1087 = FLD(m_1086, 2); _r = field2_1087; } else rt_panic("match: no case at kernel:1154"); _r; });
}
V d_Get_dTerm_dElim_de_umotive(V value_1088) {
  return ({ V _r = 0; V m_1089 = value_1088; if ((tag_of(m_1089) == 0)) { V field3_1090 = FLD(m_1089, 3); _r = field3_1090; } else rt_panic("match: no case at kernel:1158"); _r; });
}
V d_Get_dTerm_dElim_de_ubranches(V value_1091) {
  return ({ V _r = 0; V m_1092 = value_1091; if ((tag_of(m_1092) == 0)) { V field4_1093 = FLD(m_1092, 4); _r = field4_1093; } else rt_panic("match: no case at kernel:1162"); _r; });
}
V d_Get_dRules_dOps_do_ubind(V value_1094) {
  return ({ V _r = 0; V m_1095 = value_1094; if ((tag_of(m_1095) == 0)) { V field8_1096 = FLD(m_1095, 8); _r = field8_1096; } else rt_panic("match: no case at kernel:1166"); _r; });
}
V d_Get_dRules_dOps_do_uinfer_uuniv(V value_1097) {
  return ({ V _r = 0; V m_1098 = value_1097; if ((tag_of(m_1098) == 0)) { V field3_1099 = FLD(m_1098, 3); _r = field3_1099; } else rt_panic("match: no case at kernel:1170"); _r; });
}
V d_Get_dRules_dOps_do_ueval(V value_1100) {
  return ({ V _r = 0; V m_1101 = value_1100; if ((tag_of(m_1101) == 0)) { V field6_1102 = FLD(m_1101, 6); _r = field6_1102; } else rt_panic("match: no case at kernel:1174"); _r; });
}
V d_Get_dQuantity_dUsage_dpaths(V value_1103) {
  return ({ V _r = 0; V m_1104 = value_1103; if ((tag_of(m_1104) == 0)) { V field0_1105 = FLD(m_1104, 0); _r = field0_1105; } else rt_panic("match: no case at kernel:1178"); _r; });
}
V d_Get_dQuantity_dUsage_dreads(V value_1111) {
  return ({ V _r = 0; V m_1112 = value_1111; if ((tag_of(m_1112) == 0)) { V field1_1113 = FLD(m_1112, 1); _r = field1_1113; } else rt_panic("match: no case at kernel:1188"); _r; });
}
V d_Get_dRules_dOps_do_ucheck(V value_1114) {
  return ({ V _r = 0; V m_1115 = value_1114; if ((tag_of(m_1115) == 0)) { V field1_1116 = FLD(m_1115, 1); _r = field1_1116; } else rt_panic("match: no case at kernel:1192"); _r; });
}
V d_Get_dRules_dOps_do_uev(V value_1117) {
  return ({ V _r = 0; V m_1118 = value_1117; if ((tag_of(m_1118) == 0)) { V field11_1119 = FLD(m_1118, 11); _r = field11_1119; } else rt_panic("match: no case at kernel:1196"); _r; });
}
V d_Get_dValue_dClosure_denv(V value_1120) {
  return ({ V _r = 0; V m_1121 = value_1120; if ((tag_of(m_1121) == 0)) { V field0_1122 = FLD(m_1121, 0); _r = field0_1122; } else rt_panic("match: no case at kernel:1200"); _r; });
}
V d_Get_dValue_dClosure_dbody(V value_1123) {
  return ({ V _r = 0; V m_1124 = value_1123; if ((tag_of(m_1124) == 0)) { V field1_1125 = FLD(m_1124, 1); _r = field1_1125; } else rt_panic("match: no case at kernel:1204"); _r; });
}
V d_Get_dRules_dEvaluator_dev_ueval(V value_1126) {
  return ({ V _r = 0; V m_1127 = value_1126; if ((tag_of(m_1127) == 0)) { V field0_1128 = FLD(m_1127, 0); _r = field0_1128; } else rt_panic("match: no case at kernel:1208"); _r; });
}
V d_Get_dRules_dOps_do_uwhnf(V value_1153) {
  return ({ V _r = 0; V m_1154 = value_1153; if ((tag_of(m_1154) == 0)) { V field7_1155 = FLD(m_1154, 7); _r = field7_1155; } else rt_panic("match: no case at kernel:1222"); _r; });
}
V d_Get_dRules_dOps_do_usize(V value_1156) {
  return ({ V _r = 0; V m_1157 = value_1156; if ((tag_of(m_1157) == 0)) { V field9_1158 = FLD(m_1157, 9); _r = field9_1158; } else rt_panic("match: no case at kernel:1226"); _r; });
}
V d_Get_dRules_dOps_do_uclose(V value_1159) {
  return ({ V _r = 0; V m_1160 = value_1159; if ((tag_of(m_1160) == 0)) { V field2_1161 = FLD(m_1160, 2); _r = field2_1161; } else rt_panic("match: no case at kernel:1230"); _r; });
}
V d_Get_dTerm_dLeg_dl_ubody(V value_1162) {
  return ({ V _r = 0; V m_1163 = value_1162; if ((tag_of(m_1163) == 0)) { V field1_1164 = FLD(m_1163, 1); _r = field1_1164; } else rt_panic("match: no case at kernel:1234"); _r; });
}
V d_Get_dRules_dOps_do_uenv(V value_1165) {
  return ({ V _r = 0; V m_1166 = value_1165; if ((tag_of(m_1166) == 0)) { V field10_1167 = FLD(m_1166, 10); _r = field10_1167; } else rt_panic("match: no case at kernel:1238"); _r; });
}
V d_Get_dTerm_dMotive_dm_ubody(V value_1168) {
  return ({ V _r = 0; V m_1169 = value_1168; if ((tag_of(m_1169) == 0)) { V field3_1170 = FLD(m_1169, 3); _r = field3_1170; } else rt_panic("match: no case at kernel:1242"); _r; });
}
V d_Get_dTerm_dLeg_dl_ubinders(V value_1171) {
  return ({ V _r = 0; V m_1172 = value_1171; if ((tag_of(m_1172) == 0)) { V field0_1173 = FLD(m_1172, 0); _r = field0_1173; } else rt_panic("match: no case at kernel:1246"); _r; });
}
V d_Get_dTerm_dElim_de_uscrut(V value_1174) {
  return ({ V _r = 0; V m_1175 = value_1174; if ((tag_of(m_1175) == 0)) { V field1_1176 = FLD(m_1175, 1); _r = field1_1176; } else rt_panic("match: no case at kernel:1250"); _r; });
}
V d_Get_dTerm_dMotive_dm_uself(V value_1177) {
  return ({ V _r = 0; V m_1178 = value_1177; if ((tag_of(m_1178) == 0)) { V field2_1179 = FLD(m_1178, 2); _r = field2_1179; } else rt_panic("match: no case at kernel:1254"); _r; });
}
V d_Get_dRules_dOps_do_uinfer(V value_1180) {
  return ({ V _r = 0; V m_1181 = value_1180; if ((tag_of(m_1181) == 0)) { V field0_1182 = FLD(m_1181, 0); _r = field0_1182; } else rt_panic("match: no case at kernel:1258"); _r; });
}
V d_Get_dValue_dVleg_dvl_uclo(V value_1203) {
  return ({ V _r = 0; V m_1204 = value_1203; if ((tag_of(m_1204) == 0)) { V field1_1205 = FLD(m_1204, 1); _r = field1_1205; } else rt_panic("match: no case at kernel:1273"); _r; });
}
V d_Get_dRules_dOps_do_uconv(V value_1206) {
  return ({ V _r = 0; V m_1207 = value_1206; if ((tag_of(m_1207) == 0)) { V field4_1208 = FLD(m_1207, 4); _r = field4_1208; } else rt_panic("match: no case at kernel:1277"); _r; });
}
V d_Get_dRules_dOps_do_uquote(V value_1209) {
  return ({ V _r = 0; V m_1210 = value_1209; if ((tag_of(m_1210) == 0)) { V field13_1211 = FLD(m_1210, 13); _r = field13_1211; } else rt_panic("match: no case at kernel:1281"); _r; });
}
V d_Get_dRules_dOps_do_uconv_utype(V value_1212) {
  return ({ V _r = 0; V m_1213 = value_1212; if ((tag_of(m_1213) == 0)) { V field5_1214 = FLD(m_1213, 5); _r = field5_1214; } else rt_panic("match: no case at kernel:1285"); _r; });
}
V d_Get_dPositivity_dFamily_df_ulevel(V value_1215) {
  return ({ V _r = 0; V m_1216 = value_1215; if ((tag_of(m_1216) == 0)) { V field3_1217 = FLD(m_1216, 3); _r = field3_1217; } else rt_panic("match: no case at kernel:1289"); _r; });
}
V d_Get_dTuple2_dv0(V value_1218) {
  return ({ V _r = 0; V m_1219 = value_1218; if ((tag_of(m_1219) == 0)) { V field0_1220 = FLD(m_1219, 0); _r = field0_1220; } else rt_panic("match: no case at kernel:1293"); _r; });
}
V d_Get_dPositivity_dFamily_df_ustatus(V value_1221) {
  return ({ V _r = 0; V m_1222 = value_1221; if ((tag_of(m_1222) == 0)) { V field4_1223 = FLD(m_1222, 4); _r = field4_1223; } else rt_panic("match: no case at kernel:1297"); _r; });
}
V d_Get_dPositivity_dFamily_df_upositive(V value_1230) {
  return ({ V _r = 0; V m_1231 = value_1230; if ((tag_of(m_1231) == 0)) { V field6_1232 = FLD(m_1231, 6); _r = field6_1232; } else rt_panic("match: no case at kernel:1307"); _r; });
}
V d_Get_dRules_dOps_do_ufamily(V value_1233) {
  return ({ V _r = 0; V m_1234 = value_1233; if ((tag_of(m_1234) == 0)) { V field15_1235 = FLD(m_1234, 15); _r = field15_1235; } else rt_panic("match: no case at kernel:1311"); _r; });
}
V d_Get_dPositivity_dCtor_dc_ures_uidx(V value_1236) {
  return ({ V _r = 0; V m_1237 = value_1236; if ((tag_of(m_1237) == 0)) { V field2_1238 = FLD(m_1237, 2); _r = field2_1238; } else rt_panic("match: no case at kernel:1315"); _r; });
}
V d_Get_dRules_dOps_do_upp(V value_1239) {
  return ({ V _r = 0; V m_1240 = value_1239; if ((tag_of(m_1240) == 0)) { V field12_1241 = FLD(m_1240, 12); _r = field12_1241; } else rt_panic("match: no case at kernel:1319"); _r; });
}
V d_Get_dPositivity_dCtor_dc_uself_urec(V value_1242) {
  return ({ V _r = 0; V m_1243 = value_1242; if ((tag_of(m_1243) == 0)) { V field4_1244 = FLD(m_1243, 4); _r = field4_1244; } else rt_panic("match: no case at kernel:1323"); _r; });
}
V d_Get_dTerm_dMotive_dm_uidx(V value_1245) {
  return ({ V _r = 0; V m_1246 = value_1245; if ((tag_of(m_1246) == 0)) { V field1_1247 = FLD(m_1246, 1); _r = field1_1247; } else rt_panic("match: no case at kernel:1327"); _r; });
}
V d_Get_dTerm_dMotive_dm_uind(V value_1248) {
  return ({ V _r = 0; V m_1249 = value_1248; if ((tag_of(m_1249) == 0)) { V field0_1250 = FLD(m_1249, 0); _r = field0_1250; } else rt_panic("match: no case at kernel:1331"); _r; });
}
V d_Get_dRules_dRule_upack_dbeta(V value_1251) {
  return ({ V _r = 0; V m_1252 = value_1251; if ((tag_of(m_1252) == 0)) { V field6_1253 = FLD(m_1252, 6); _r = field6_1253; } else rt_panic("match: no case at kernel:1335"); _r; });
}
V d_Get_dTerm_dElim_de_ushape(V value_1254) {
  return ({ V _r = 0; V m_1255 = value_1254; if ((tag_of(m_1255) == 0)) { V field0_1256 = FLD(m_1255, 0); _r = field0_1256; } else rt_panic("match: no case at kernel:1339"); _r; });
}
V d_Get_dGlobal_dDef_uentry_dreducible(V value_1271) {
  return ({ V _r = 0; V m_1272 = value_1271; if ((tag_of(m_1272) == 0)) { V field2_1273 = FLD(m_1272, 2); _r = field2_1273; } else rt_panic("match: no case at kernel:1354"); _r; });
}
V d_Get_dGlobal_dDef_uentry_ddef(V value_1274) {
  return ({ V _r = 0; V m_1275 = value_1274; if ((tag_of(m_1275) == 0)) { V field1_1276 = FLD(m_1275, 1); _r = field1_1276; } else rt_panic("match: no case at kernel:1358"); _r; });
}
V d_Get_dGlobal_dDef_uentry_drec_uarg(V value_1277) {
  return ({ V _r = 0; V m_1278 = value_1277; if ((tag_of(m_1278) == 0)) { V field3_1279 = FLD(m_1278, 3); _r = field3_1279; } else rt_panic("match: no case at kernel:1362"); _r; });
}
V d_Get_dValue_dStuck_uelim_ds_ushape(V value_1287) {
  return ({ V _r = 0; V m_1288 = value_1287; if ((tag_of(m_1288) == 0)) { V field0_1289 = FLD(m_1288, 0); _r = field0_1289; } else rt_panic("match: no case at kernel:1371"); _r; });
}
V d_Get_dValue_dStuck_uelim_ds_uscrut_uq(V value_1290) {
  return ({ V _r = 0; V m_1291 = value_1290; if ((tag_of(m_1291) == 0)) { V field1_1292 = FLD(m_1291, 1); _r = field1_1292; } else rt_panic("match: no case at kernel:1375"); _r; });
}
V d_Get_dValue_dStuck_uelim_ds_umotive(V value_1293) {
  return ({ V _r = 0; V m_1294 = value_1293; if ((tag_of(m_1294) == 0)) { V field2_1295 = FLD(m_1294, 2); _r = field2_1295; } else rt_panic("match: no case at kernel:1379"); _r; });
}
V d_Get_dValue_dStuck_uelim_ds_ubranches(V value_1296) {
  return ({ V _r = 0; V m_1297 = value_1296; if ((tag_of(m_1297) == 0)) { V field3_1298 = FLD(m_1297, 3); _r = field3_1298; } else rt_panic("match: no case at kernel:1383"); _r; });
}
V d_Get_dValue_dStuck_uelim_ds_uenv(V value_1299) {
  return ({ V _r = 0; V m_1300 = value_1299; if ((tag_of(m_1300) == 0)) { V field4_1301 = FLD(m_1300, 4); _r = field4_1301; } else rt_panic("match: no case at kernel:1387"); _r; });
}
V d_Get_dGlobal_dPrim_uentry_dprim(V value_1302) {
  return ({ V _r = 0; V m_1303 = value_1302; if ((tag_of(m_1303) == 0)) { V field1_1304 = FLD(m_1303, 1); _r = field1_1304; } else rt_panic("match: no case at kernel:1391"); _r; });
}
V d_Get_dCheck_dCtx_dsize(V value_1305) {
  return ({ V _r = 0; V m_1306 = value_1305; if ((tag_of(m_1306) == 0)) { V field3_1307 = FLD(m_1306, 3); _r = field3_1307; } else rt_panic("match: no case at kernel:1395"); _r; });
}
V d_Get_dRules_dRule_upack_ddiagram_uarity(V value_1308) {
  return ({ V _r = 0; V m_1309 = value_1308; if ((tag_of(m_1309) == 0)) { V field8_1310 = FLD(m_1309, 8); _r = field8_1310; } else rt_panic("match: no case at kernel:1399"); _r; });
}
V d_Get_dValue_dVleg_dvl_ubinders(V value_1311) {
  return ({ V _r = 0; V m_1312 = value_1311; if ((tag_of(m_1312) == 0)) { V field0_1313 = FLD(m_1312, 0); _r = field0_1313; } else rt_panic("match: no case at kernel:1403"); _r; });
}
V d_Get_dCheck_dCtx_dbudget(V value_1314) {
  return ({ V _r = 0; V m_1315 = value_1314; if ((tag_of(m_1315) == 0)) { V field4_1316 = FLD(m_1315, 4); _r = field4_1316; } else rt_panic("match: no case at kernel:1407"); _r; });
}
V d_Get_dBudget_dpoll(V value_1317) {
  return ({ V _r = 0; V m_1318 = value_1317; if ((tag_of(m_1318) == 0)) { V field0_1319 = FLD(m_1318, 0); _r = field0_1319; } else rt_panic("match: no case at kernel:1411"); _r; });
}
V d_Get_dRules_dRule_upack_dform_ulan(V value_1320) {
  return ({ V _r = 0; V m_1321 = value_1320; if ((tag_of(m_1321) == 0)) { V field0_1322 = FLD(m_1321, 0); _r = field0_1322; } else rt_panic("match: no case at kernel:1415"); _r; });
}
V d_Get_dRules_dRule_upack_dform_uran(V value_1323) {
  return ({ V _r = 0; V m_1324 = value_1323; if ((tag_of(m_1324) == 0)) { V field1_1325 = FLD(m_1324, 1); _r = field1_1325; } else rt_panic("match: no case at kernel:1419"); _r; });
}
V d_Get_dRules_dRule_upack_delim_uelim(V value_1326) {
  return ({ V _r = 0; V m_1327 = value_1326; if ((tag_of(m_1327) == 0)) { V field3_1328 = FLD(m_1327, 3); _r = field3_1328; } else rt_panic("match: no case at kernel:1423"); _r; });
}
V d_Get_dRules_dRule_upack_delim_uout(V value_1329) {
  return ({ V _r = 0; V m_1330 = value_1329; if ((tag_of(m_1330) == 0)) { V field5_1331 = FLD(m_1330, 5); _r = field5_1331; } else rt_panic("match: no case at kernel:1427"); _r; });
}
V d_Get_dRules_dRule_upack_dann_ulvl_ueq(V value_1336) {
  return ({ V _r = 0; V m_1337 = value_1336; if ((tag_of(m_1337) == 0)) { V field13_1338 = FLD(m_1337, 13); _r = field13_1338; } else rt_panic("match: no case at kernel:1436"); _r; });
}
V d_Get_dRules_dRule_upack_dconv_udiagram(V value_1339) {
  return ({ V _r = 0; V m_1340 = value_1339; if ((tag_of(m_1340) == 0)) { V field12_1341 = FLD(m_1340, 12); _r = field12_1341; } else rt_panic("match: no case at kernel:1440"); _r; });
}
V d_Get_dTuple2_dv1(V value_1342) {
  return ({ V _r = 0; V m_1343 = value_1342; if ((tag_of(m_1343) == 0)) { V field1_1344 = FLD(m_1343, 1); _r = field1_1344; } else rt_panic("match: no case at kernel:1444"); _r; });
}
V d_Get_dRules_dRule_upack_dspine_uty(V value_1345) {
  return ({ V _r = 0; V m_1346 = value_1345; if ((tag_of(m_1346) == 0)) { V field9_1347 = FLD(m_1346, 9); _r = field9_1347; } else rt_panic("match: no case at kernel:1448"); _r; });
}
V d_Get_dRules_dOps_do_uhead_uty(V value_1348) {
  return ({ V _r = 0; V m_1349 = value_1348; if ((tag_of(m_1349) == 0)) { V field14_1350 = FLD(m_1349, 14); _r = field14_1350; } else rt_panic("match: no case at kernel:1452"); _r; });
}
V d_Get_dRules_dRule_upack_deta(V value_1351) {
  return ({ V _r = 0; V m_1352 = value_1351; if ((tag_of(m_1352) == 0)) { V field7_1353 = FLD(m_1352, 7); _r = field7_1353; } else rt_panic("match: no case at kernel:1456"); _r; });
}
V d_Get_dRules_dEta_urow_deta_uran(V value_1354) {
  return ({ V _r = 0; V m_1355 = value_1354; if ((tag_of(m_1355) == 0)) { V field0_1356 = FLD(m_1355, 0); _r = field0_1356; } else rt_panic("match: no case at kernel:1460"); _r; });
}
V d_Get_dRules_dRule_upack_dexpand_uran(V value_1357) {
  return ({ V _r = 0; V m_1358 = value_1357; if ((tag_of(m_1358) == 0)) { V field10_1359 = FLD(m_1358, 10); _r = field10_1359; } else rt_panic("match: no case at kernel:1464"); _r; });
}
V d_Get_dRules_dEta_urow_deta_ulan(V value_1360) {
  return ({ V _r = 0; V m_1361 = value_1360; if ((tag_of(m_1361) == 0)) { V field1_1362 = FLD(m_1361, 1); _r = field1_1362; } else rt_panic("match: no case at kernel:1468"); _r; });
}
V d_Get_dRules_dRule_upack_dexpand_ulan(V value_1363) {
  return ({ V _r = 0; V m_1364 = value_1363; if ((tag_of(m_1364) == 0)) { V field11_1365 = FLD(m_1364, 11); _r = field11_1365; } else rt_panic("match: no case at kernel:1472"); _r; });
}
V d_Get_dRules_dRule_upack_dsubsingleton(V value_1366) {
  return ({ V _r = 0; V m_1367 = value_1366; if ((tag_of(m_1367) == 0)) { V field16_1368 = FLD(m_1367, 16); _r = field16_1368; } else rt_panic("match: no case at kernel:1476"); _r; });
}
V d_Get_dRules_dRule_upack_dintro_uin(V value_1369) {
  return ({ V _r = 0; V m_1370 = value_1369; if ((tag_of(m_1370) == 0)) { V field2_1371 = FLD(m_1370, 2); _r = field2_1371; } else rt_panic("match: no case at kernel:1480"); _r; });
}
V d_Get_dRules_dRule_upack_dintro_usec(V value_1372) {
  return ({ V _r = 0; V m_1373 = value_1372; if ((tag_of(m_1373) == 0)) { V field4_1374 = FLD(m_1373, 4); _r = field4_1374; } else rt_panic("match: no case at kernel:1484"); _r; });
}
V d_Get_dGlobal_dDef_uentry_dty(V value_1375) {
  return ({ V _r = 0; V m_1376 = value_1375; if ((tag_of(m_1376) == 0)) { V field0_1377 = FLD(m_1376, 0); _r = field0_1377; } else rt_panic("match: no case at kernel:1488"); _r; });
}
V d_Get_dGlobal_dAxiom_uentry_dax_uty(V value_1378) {
  return ({ V _r = 0; V m_1379 = value_1378; if ((tag_of(m_1379) == 0)) { V field0_1380 = FLD(m_1379, 0); _r = field0_1380; } else rt_panic("match: no case at kernel:1492"); _r; });
}
V d_Get_dGlobal_dPrim_uentry_dp_uty(V value_1381) {
  return ({ V _r = 0; V m_1382 = value_1381; if ((tag_of(m_1382) == 0)) { V field0_1383 = FLD(m_1382, 0); _r = field0_1383; } else rt_panic("match: no case at kernel:1496"); _r; });
}
V d_Get_dCheck_dDecl_dd_uname(V value_1391) {
  return ({ V _r = 0; V m_1392 = value_1391; if ((tag_of(m_1392) == 0)) { V field0_1393 = FLD(m_1392, 0); _r = field0_1393; } else rt_panic("match: no case at kernel:1504"); _r; });
}
V d_Get_dCheck_dDecl_dd_ukind(V value_1394) {
  return ({ V _r = 0; V m_1395 = value_1394; if ((tag_of(m_1395) == 0)) { V field1_1396 = FLD(m_1395, 1); _r = field1_1396; } else rt_panic("match: no case at kernel:1508"); _r; });
}
V d_Get_dCheck_dDecl_dd_uty(V value_1401) {
  return ({ V _r = 0; V m_1402 = value_1401; if ((tag_of(m_1402) == 0)) { V field2_1403 = FLD(m_1402, 2); _r = field2_1403; } else rt_panic("match: no case at kernel:1517"); _r; });
}
V d_Get_dCheck_dDecl_dd_ubody(V value_1404) {
  return ({ V _r = 0; V m_1405 = value_1404; if ((tag_of(m_1405) == 0)) { V field3_1406 = FLD(m_1405, 3); _r = field3_1406; } else rt_panic("match: no case at kernel:1521"); _r; });
}
V d_Get_dCheck_dFamily_udecl_dfam_uparams(V value_1407) {
  return ({ V _r = 0; V m_1408 = value_1407; if ((tag_of(m_1408) == 0)) { V field1_1409 = FLD(m_1408, 1); _r = field1_1409; } else rt_panic("match: no case at kernel:1525"); _r; });
}
V d_Get_dCheck_dFamily_udecl_dfam_uname(V value_1410) {
  return ({ V _r = 0; V m_1411 = value_1410; if ((tag_of(m_1411) == 0)) { V field0_1412 = FLD(m_1411, 0); _r = field0_1412; } else rt_panic("match: no case at kernel:1529"); _r; });
}
V d_Get_dCheck_dFamily_udecl_dfam_ulevel(V value_1413) {
  return ({ V _r = 0; V m_1414 = value_1413; if ((tag_of(m_1414) == 0)) { V field3_1415 = FLD(m_1414, 3); _r = field3_1415; } else rt_panic("match: no case at kernel:1533"); _r; });
}
V d_Get_dCheck_dFamily_udecl_dfam_uindices(V value_1416) {
  return ({ V _r = 0; V m_1417 = value_1416; if ((tag_of(m_1417) == 0)) { V field2_1418 = FLD(m_1417, 2); _r = field2_1418; } else rt_panic("match: no case at kernel:1537"); _r; });
}
V d_Get_dCheck_dCtor_udecl_dct_uname(V value_1419) {
  return ({ V _r = 0; V m_1420 = value_1419; if ((tag_of(m_1420) == 0)) { V field0_1421 = FLD(m_1420, 0); _r = field0_1421; } else rt_panic("match: no case at kernel:1541"); _r; });
}
V d_Get_dCheck_dCtor_udecl_dct_uargs(V value_1422) {
  return ({ V _r = 0; V m_1423 = value_1422; if ((tag_of(m_1423) == 0)) { V field1_1424 = FLD(m_1423, 1); _r = field1_1424; } else rt_panic("match: no case at kernel:1545"); _r; });
}
V d_Get_dCheck_dCtor_udecl_dct_ures_uidx(V value_1425) {
  return ({ V _r = 0; V m_1426 = value_1425; if ((tag_of(m_1426) == 0)) { V field3_1427 = FLD(m_1426, 3); _r = field3_1427; } else rt_panic("match: no case at kernel:1549"); _r; });
}
V d_Get_dCheck_dCtor_udecl_dct_ures_uparams(V value_1428) {
  return ({ V _r = 0; V m_1429 = value_1428; if ((tag_of(m_1429) == 0)) { V field2_1430 = FLD(m_1429, 2); _r = field2_1430; } else rt_panic("match: no case at kernel:1553"); _r; });
}
V d_Get_dOrder_do_ugroup(V value_1439) {
  return ({ V _r = 0; V m_1440 = value_1439; if ((tag_of(m_1440) == 0)) { V field0_1441 = FLD(m_1440, 0); _r = field0_1441; } else rt_panic("match: no case at kernel:1567"); _r; });
}
V d_Get_dOrder_dCall_dcl_uchain(V value_1442) {
  return ({ V _r = 0; V m_1443 = value_1442; if ((tag_of(m_1443) == 0)) { V field1_1444 = FLD(m_1443, 1); _r = field1_1444; } else rt_panic("match: no case at kernel:1571"); _r; });
}
V d_Get_dOrder_dRow_drw_umember(V value_1445) {
  return ({ V _r = 0; V m_1446 = value_1445; if ((tag_of(m_1446) == 0)) { V field0_1447 = FLD(m_1446, 0); _r = field0_1447; } else rt_panic("match: no case at kernel:1575"); _r; });
}
V d_Get_dOrder_dStep_dst_uctor(V value_1448) {
  return ({ V _r = 0; V m_1449 = value_1448; if ((tag_of(m_1449) == 0)) { V field1_1450 = FLD(m_1449, 1); _r = field1_1450; } else rt_panic("match: no case at kernel:1579"); _r; });
}
V d_Get_dOrder_dRow_drw_ucalls(V value_1451) {
  return ({ V _r = 0; V m_1452 = value_1451; if ((tag_of(m_1452) == 0)) { V field1_1453 = FLD(m_1452, 1); _r = field1_1453; } else rt_panic("match: no case at kernel:1583"); _r; });
}
V d_Get_dOrder_do_urows(V value_1454) {
  return ({ V _r = 0; V m_1455 = value_1454; if ((tag_of(m_1455) == 0)) { V field2_1456 = FLD(m_1455, 2); _r = field2_1456; } else rt_panic("match: no case at kernel:1587"); _r; });
}
V d_Get_dOrder_do_uarg(V value_1457) {
  return ({ V _r = 0; V m_1458 = value_1457; if ((tag_of(m_1458) == 0)) { V field1_1459 = FLD(m_1458, 1); _r = field1_1459; } else rt_panic("match: no case at kernel:1591"); _r; });
}
V d_Equal_dOptionOf_uGlobal_uEntry_u(V left_1460, V right_1461) {
  return ({ V _r = 0; V m_1462 = left_1460; V m_1463 = right_1461; if (((m_1462) == NONE) && ((m_1463) == NONE)) {  _r = TRUE_V; } else if (((m_1462) != NONE) && ((m_1463) != NONE)) { V left8151_1464 = FLD(m_1462, 0); V right8152_1465 = FLD(m_1463, 0); _r = ((d_Equal_dGlobal_uEntry(left8151_1464, right8152_1465)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1595"); _r; });
}
V d_Equal_dGlobal_uEntry(V left_1466, V right_1467) {
  return ({ V _r = 0; V m_1468 = left_1466; V m_1469 = right_1467; if ((tag_of(m_1468) == 0) && (tag_of(m_1469) == 0)) { V left8153_1470 = FLD(m_1468, 0); V right8154_1471 = FLD(m_1469, 0); _r = ((d_Equal_dGlobal_uDef_uentry(left8153_1470, right8154_1471)) & (TRUE_V)); } else if ((tag_of(m_1468) == 1) && (tag_of(m_1469) == 1)) { V left8297_1472 = FLD(m_1468, 0); V right8298_1473 = FLD(m_1469, 0); _r = ((d_Equal_dGlobal_uAxiom_uentry(left8297_1472, right8298_1473)) & (TRUE_V)); } else if ((tag_of(m_1468) == 2) && (tag_of(m_1469) == 2)) { V left8301_1474 = FLD(m_1468, 0); V right8302_1475 = FLD(m_1469, 0); _r = ((d_Equal_dGlobal_uPrim_uentry(left8301_1474, right8302_1475)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1601"); _r; });
}
V d_Equal_dGlobal_uDef_uentry(V left_1476, V right_1477) {
  return ({ V _r = 0; V m_1478 = left_1476; V m_1479 = right_1477; if ((tag_of(m_1478) == 0) && (tag_of(m_1479) == 0)) { V left8155_1480 = FLD(m_1478, 0); V left8156_1481 = FLD(m_1478, 1); V left8157_1482 = FLD(m_1478, 2); V left8158_1483 = FLD(m_1478, 3); V left8159_1484 = FLD(m_1478, 4); V right8160_1485 = FLD(m_1479, 0); V right8161_1486 = FLD(m_1479, 1); V right8162_1487 = FLD(m_1479, 2); V right8163_1488 = FLD(m_1479, 3); V right8164_1489 = FLD(m_1479, 4); _r = ((d_Equal_dTerm(left8155_1480, right8160_1485)) & (((d_Equal_dTerm(left8156_1481, right8161_1486)) & (((((((left8157_1482) ^ (right8162_1487))) ^ 1u)) & (((d_Equal_dOptionOf_uBig_u(left8158_1483, right8163_1488)) & (((((((left8159_1484) ^ (right8164_1489))) ^ 1u)) & (TRUE_V)))))))))); } else rt_panic("match: no case at kernel:1608"); _r; });
}
V d_Equal_dOptionOf_uBig_u(V left_1490, V right_1491) {
  return ({ V _r = 0; V m_1492 = left_1490; V m_1493 = right_1491; if (((m_1492) == NONE) && ((m_1493) == NONE)) {  _r = TRUE_V; } else if (((m_1492) != NONE) && ((m_1493) != NONE)) { V left8165_1494 = FLD(m_1492, 0); V right8166_1495 = FLD(m_1493, 0); _r = ((d_Big_dis_ueq(left8165_1494, right8166_1495)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1612"); _r; });
}
V d_Equal_dTerm(V left_1496, V right_1497) {
  return ({ V _r = 0; V m_1498 = left_1496; V m_1499 = right_1497; if ((tag_of(m_1498) == 0) && (tag_of(m_1499) == 0)) { V left8167_1500 = FLD(m_1498, 0); V right8168_1501 = FLD(m_1499, 0); _r = ((d_Big_dis_ueq(left8167_1500, right8168_1501)) & (TRUE_V)); } else if ((tag_of(m_1498) == 1) && (tag_of(m_1499) == 1)) { V left8169_1502 = FLD(m_1498, 0); V right8170_1503 = FLD(m_1499, 0); _r = ((d_Big_dis_ueq(left8169_1502, right8170_1503)) & (TRUE_V)); } else if ((tag_of(m_1498) == 2) && (tag_of(m_1499) == 2)) { V left8171_1504 = FLD(m_1498, 0); V left8172_1505 = FLD(m_1498, 1); V right8173_1506 = FLD(m_1499, 0); V right8174_1507 = FLD(m_1499, 1); _r = ((d_Equal_dShape_u_u2_u_uTerm_u(left8171_1504, right8173_1506)) & (((d_Equal_dTerm(left8172_1505, right8174_1507)) & (TRUE_V)))); } else if ((tag_of(m_1498) == 3) && (tag_of(m_1499) == 3)) { V left8199_1508 = FLD(m_1498, 0); V left8200_1509 = FLD(m_1498, 1); V right8201_1510 = FLD(m_1499, 0); V right8202_1511 = FLD(m_1499, 1); _r = ((d_Equal_dShape_u_u2_u_uTerm_u(left8199_1508, right8201_1510)) & (((d_Equal_dTerm(left8200_1509, right8202_1511)) & (TRUE_V)))); } else if ((tag_of(m_1498) == 4) && (tag_of(m_1499) == 4)) { V left8203_1512 = FLD(m_1498, 0); V left8204_1513 = FLD(m_1498, 1); V left8205_1514 = FLD(m_1498, 2); V right8206_1515 = FLD(m_1499, 0); V right8207_1516 = FLD(m_1499, 1); V right8208_1517 = FLD(m_1499, 2); _r = ((d_Equal_dShape_u_u2_u_uTerm_u(left8203_1512, right8206_1515)) & (((d_Equal_dTerm_uAddr(left8204_1513, right8207_1516)) & (((d_Equal_dListOf_uTerm_u(left8205_1514, right8208_1517)) & (TRUE_V)))))); } else if ((tag_of(m_1498) == 5) && (tag_of(m_1499) == 5)) { V left8217_1518 = FLD(m_1498, 0); V right8218_1519 = FLD(m_1499, 0); _r = ((d_Equal_dTerm_uElim(left8217_1518, right8218_1519)) & (TRUE_V)); } else if ((tag_of(m_1498) == 6) && (tag_of(m_1499) == 6)) { V left8263_1520 = FLD(m_1498, 0); V left8264_1521 = FLD(m_1498, 1); V right8265_1522 = FLD(m_1499, 0); V right8266_1523 = FLD(m_1499, 1); _r = ((d_Equal_dShape_u_u2_u_uTerm_u(left8263_1520, right8265_1522)) & (((d_Equal_dListOf_uTerm_uLeg_u(left8264_1521, right8266_1523)) & (TRUE_V)))); } else if ((tag_of(m_1498) == 7) && (tag_of(m_1499) == 7)) { V left8271_1524 = FLD(m_1498, 0); V left8272_1525 = FLD(m_1498, 1); V left8273_1526 = FLD(m_1498, 2); V right8274_1527 = FLD(m_1499, 0); V right8275_1528 = FLD(m_1499, 1); V right8276_1529 = FLD(m_1499, 2); _r = ((d_Equal_dShape_u_u2_u_uTerm_u(left8271_1524, right8274_1527)) & (((d_Equal_dTerm_uAddr(left8272_1525, right8275_1528)) & (((d_Equal_dTerm(left8273_1526, right8276_1529)) & (TRUE_V)))))); } else if ((tag_of(m_1498) == 8) && (tag_of(m_1499) == 8)) { V left8277_1530 = FLD(m_1498, 0); V left8278_1531 = FLD(m_1498, 1); V left8279_1532 = FLD(m_1498, 2); V left8280_1533 = FLD(m_1498, 3); V right8281_1534 = FLD(m_1499, 0); V right8282_1535 = FLD(m_1499, 1); V right8283_1536 = FLD(m_1499, 2); V right8284_1537 = FLD(m_1499, 3); _r = ((d_NativeString_dequal(left8277_1530, right8281_1534)) & (((d_Equal_dTerm(left8278_1531, right8282_1535)) & (((d_Equal_dTerm(left8279_1532, right8283_1536)) & (((d_Equal_dTerm(left8280_1533, right8284_1537)) & (TRUE_V)))))))); } else if ((tag_of(m_1498) == 9) && (tag_of(m_1499) == 9)) { V left8285_1538 = FLD(m_1498, 0); V left8286_1539 = FLD(m_1498, 1); V right8287_1540 = FLD(m_1499, 0); V right8288_1541 = FLD(m_1499, 1); _r = ((d_Equal_dTerm(left8285_1538, right8287_1540)) & (((d_Equal_dTerm(left8286_1539, right8288_1541)) & (TRUE_V)))); } else if ((tag_of(m_1498) == 10) && (tag_of(m_1499) == 10)) { V left8289_1542 = FLD(m_1498, 0); V right8290_1543 = FLD(m_1499, 0); _r = ((d_NativeString_dequal(left8289_1542, right8290_1543)) & (TRUE_V)); } else if ((tag_of(m_1498) == 11) && (tag_of(m_1499) == 11)) { V left8291_1544 = FLD(m_1498, 0); V right8292_1545 = FLD(m_1499, 0); _r = ((d_Equal_dLiteral(left8291_1544, right8292_1545)) & (TRUE_V)); } else if ((tag_of(m_1498) == 12) && (tag_of(m_1499) == 12)) {  _r = TRUE_V; } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1618"); _r; });
}
V d_Equal_dShape_u_u2_u_uTerm_u(V left_1546, V right_1547) {
  return ({ V _r = 0; V m_1548 = left_1546; V m_1549 = right_1547; if ((tag_of(m_1548) == 0) && (tag_of(m_1549) == 0)) { V left8175_1550 = FLD(m_1548, 0); V left8176_1551 = FLD(m_1548, 1); V left8177_1552 = FLD(m_1548, 2); V right8178_1553 = FLD(m_1549, 0); V right8179_1554 = FLD(m_1549, 1); V right8180_1555 = FLD(m_1549, 2); _r = ((d_Equal_dQuantity(left8175_1550, right8178_1553)) & (((d_NativeString_dequal(left8176_1551, right8179_1554)) & (((d_Equal_dTerm(left8177_1552, right8180_1555)) & (TRUE_V)))))); } else if ((tag_of(m_1548) == 1) && (tag_of(m_1549) == 1)) { V left8181_1556 = FLD(m_1548, 0); V right8182_1557 = FLD(m_1549, 0); _r = ((d_Big_dis_ueq(left8181_1556, right8182_1557)) & (TRUE_V)); } else if ((tag_of(m_1548) == 2) && (tag_of(m_1549) == 2)) { V left8183_1558 = FLD(m_1548, 0); V left8184_1559 = FLD(m_1548, 1); V right8185_1560 = FLD(m_1549, 0); V right8186_1561 = FLD(m_1549, 1); _r = ((d_Equal_dTerm(left8183_1558, right8185_1560)) & (((d_Equal_dTerm(left8184_1559, right8186_1561)) & (TRUE_V)))); } else if ((tag_of(m_1548) == 3) && (tag_of(m_1549) == 3)) { V left8187_1562 = FLD(m_1548, 0); V left8188_1563 = FLD(m_1548, 1); V right8189_1564 = FLD(m_1549, 0); V right8190_1565 = FLD(m_1549, 1); _r = ((d_NativeString_dequal(left8187_1562, right8189_1564)) & (((d_Equal_dListOf_uTerm_u(left8188_1563, right8190_1565)) & (TRUE_V)))); } else if ((tag_of(m_1548) == 4) && (tag_of(m_1549) == 4)) { V left8195_1566 = FLD(m_1548, 0); V left8196_1567 = FLD(m_1548, 1); V right8197_1568 = FLD(m_1549, 0); V right8198_1569 = FLD(m_1549, 1); _r = ((d_NativeString_dequal(left8195_1566, right8197_1568)) & (((d_Equal_dListOf_uTerm_u(left8196_1567, right8198_1569)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1635"); _r; });
}
V d_Equal_dQuantity(V left_1570, V right_1571) {
  return ({ V _r = 0; V m_1572 = left_1570; V m_1573 = right_1571; if ((tag_of(m_1572) == 0) && (tag_of(m_1573) == 0)) {  _r = TRUE_V; } else if ((tag_of(m_1572) == 1) && (tag_of(m_1573) == 1)) {  _r = TRUE_V; } else if ((tag_of(m_1572) == 2) && (tag_of(m_1573) == 2)) {  _r = TRUE_V; } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1644"); _r; });
}
V d_Equal_dListOf_uTerm_u(V left_1574, V right_1575) {
  return ({ V _r = 0; V m_1576 = left_1574; V m_1577 = right_1575; if (((m_1576) == NIL) && ((m_1577) == NIL)) {  _r = TRUE_V; } else if (((m_1576) != NIL) && ((m_1577) != NIL)) { V left8191_1578 = FLD(m_1576, 0); V left8192_1579 = FLD(m_1576, 1); V right8193_1580 = FLD(m_1577, 0); V right8194_1581 = FLD(m_1577, 1); _r = ((d_Equal_dTerm(left8191_1578, right8193_1580)) & (((d_Equal_dListOf_uTerm_u(left8192_1579, right8194_1581)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1651"); _r; });
}
V d_Equal_dTerm_uAddr(V left_1582, V right_1583) {
  return ({ V _r = 0; V m_1584 = left_1582; V m_1585 = right_1583; if ((tag_of(m_1584) == 0) && (tag_of(m_1585) == 0)) { V left8209_1586 = FLD(m_1584, 0); V left8210_1587 = FLD(m_1584, 1); V right8211_1588 = FLD(m_1585, 0); V right8212_1589 = FLD(m_1585, 1); _r = ((d_Equal_dQuantity(left8209_1586, right8211_1588)) & (((d_Equal_dTerm(left8210_1587, right8212_1589)) & (TRUE_V)))); } else if ((tag_of(m_1584) == 1) && (tag_of(m_1585) == 1)) { V left8213_1590 = FLD(m_1584, 0); V right8214_1591 = FLD(m_1585, 0); _r = ((d_Big_dis_ueq(left8213_1590, right8214_1591)) & (TRUE_V)); } else if ((tag_of(m_1584) == 2) && (tag_of(m_1585) == 2)) { V left8215_1592 = FLD(m_1584, 0); V right8216_1593 = FLD(m_1585, 0); _r = ((d_NativeString_dequal(left8215_1592, right8216_1593)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1657"); _r; });
}
V d_Equal_dTerm_uElim(V left_1594, V right_1595) {
  return ({ V _r = 0; V m_1596 = left_1594; V m_1597 = right_1595; if ((tag_of(m_1596) == 0) && (tag_of(m_1597) == 0)) { V left8219_1598 = FLD(m_1596, 0); V left8220_1599 = FLD(m_1596, 1); V left8221_1600 = FLD(m_1596, 2); V left8222_1601 = FLD(m_1596, 3); V left8223_1602 = FLD(m_1596, 4); V right8224_1603 = FLD(m_1597, 0); V right8225_1604 = FLD(m_1597, 1); V right8226_1605 = FLD(m_1597, 2); V right8227_1606 = FLD(m_1597, 3); V right8228_1607 = FLD(m_1597, 4); _r = ((d_Equal_dShape_u_u2_u_uTerm_u(left8219_1598, right8224_1603)) & (((d_Equal_dTerm(left8220_1599, right8225_1604)) & (((d_Equal_dQuantity(left8221_1600, right8226_1605)) & (((d_Equal_dOptionOf_uTerm_uMotive_u(left8222_1601, right8227_1606)) & (((d_Equal_dListOf_uTupleOf2_uTerm_uAddr_u_uTerm_uLeg_u_u(left8223_1602, right8228_1607)) & (TRUE_V)))))))))); } else rt_panic("match: no case at kernel:1664"); _r; });
}
V d_Equal_dListOf_uTupleOf2_uTerm_uAddr_u_uTerm_uLeg_u_u(V left_1608, V right_1609) {
  return ({ V _r = 0; V m_1610 = left_1608; V m_1611 = right_1609; if (((m_1610) == NIL) && ((m_1611) == NIL)) {  _r = TRUE_V; } else if (((m_1610) != NIL) && ((m_1611) != NIL)) { V left8229_1612 = FLD(m_1610, 0); V left8230_1613 = FLD(m_1610, 1); V right8231_1614 = FLD(m_1611, 0); V right8232_1615 = FLD(m_1611, 1); _r = ((d_Equal_dTupleOf2_uTerm_uAddr_u_uTerm_uLeg_u(left8229_1612, right8231_1614)) & (((d_Equal_dListOf_uTupleOf2_uTerm_uAddr_u_uTerm_uLeg_u_u(left8230_1613, right8232_1615)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1668"); _r; });
}
V d_Equal_dTupleOf2_uTerm_uAddr_u_uTerm_uLeg_u(V left_1616, V right_1617) {
  return ({ V _r = 0; V m_1618 = left_1616; V m_1619 = right_1617; if ((tag_of(m_1618) == 0) && (tag_of(m_1619) == 0)) { V left8233_1620 = FLD(m_1618, 0); V left8234_1621 = FLD(m_1618, 1); V right8235_1622 = FLD(m_1619, 0); V right8236_1623 = FLD(m_1619, 1); _r = ((d_Equal_dTerm_uAddr(left8233_1620, right8235_1622)) & (((d_Equal_dTerm_uLeg(left8234_1621, right8236_1623)) & (TRUE_V)))); } else rt_panic("match: no case at kernel:1674"); _r; });
}
V d_Equal_dTerm_uLeg(V left_1624, V right_1625) {
  return ({ V _r = 0; V m_1626 = left_1624; V m_1627 = right_1625; if ((tag_of(m_1626) == 0) && (tag_of(m_1627) == 0)) { V left8237_1628 = FLD(m_1626, 0); V left8238_1629 = FLD(m_1626, 1); V right8239_1630 = FLD(m_1627, 0); V right8240_1631 = FLD(m_1627, 1); _r = ((d_Equal_dListOf_uTupleOf2_uQuantity_u_uString_u_u(left8237_1628, right8239_1630)) & (((d_Equal_dTerm(left8238_1629, right8240_1631)) & (TRUE_V)))); } else rt_panic("match: no case at kernel:1678"); _r; });
}
V d_Equal_dListOf_uTupleOf2_uQuantity_u_uString_u_u(V left_1632, V right_1633) {
  return ({ V _r = 0; V m_1634 = left_1632; V m_1635 = right_1633; if (((m_1634) == NIL) && ((m_1635) == NIL)) {  _r = TRUE_V; } else if (((m_1634) != NIL) && ((m_1635) != NIL)) { V left8241_1636 = FLD(m_1634, 0); V left8242_1637 = FLD(m_1634, 1); V right8243_1638 = FLD(m_1635, 0); V right8244_1639 = FLD(m_1635, 1); _r = ((d_Equal_dTupleOf2_uQuantity_u_uString_u(left8241_1636, right8243_1638)) & (((d_Equal_dListOf_uTupleOf2_uQuantity_u_uString_u_u(left8242_1637, right8244_1639)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1682"); _r; });
}
V d_Equal_dTupleOf2_uQuantity_u_uString_u(V left_1640, V right_1641) {
  return ({ V _r = 0; V m_1642 = left_1640; V m_1643 = right_1641; if ((tag_of(m_1642) == 0) && (tag_of(m_1643) == 0)) { V left8245_1644 = FLD(m_1642, 0); V left8246_1645 = FLD(m_1642, 1); V right8247_1646 = FLD(m_1643, 0); V right8248_1647 = FLD(m_1643, 1); _r = ((d_Equal_dQuantity(left8245_1644, right8247_1646)) & (((d_NativeString_dequal(left8246_1645, right8248_1647)) & (TRUE_V)))); } else rt_panic("match: no case at kernel:1688"); _r; });
}
V d_Equal_dOptionOf_uTerm_uMotive_u(V left_1648, V right_1649) {
  return ({ V _r = 0; V m_1650 = left_1648; V m_1651 = right_1649; if (((m_1650) == NONE) && ((m_1651) == NONE)) {  _r = TRUE_V; } else if (((m_1650) != NONE) && ((m_1651) != NONE)) { V left8249_1652 = FLD(m_1650, 0); V right8250_1653 = FLD(m_1651, 0); _r = ((d_Equal_dTerm_uMotive(left8249_1652, right8250_1653)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1692"); _r; });
}
V d_Equal_dTerm_uMotive(V left_1654, V right_1655) {
  return ({ V _r = 0; V m_1656 = left_1654; V m_1657 = right_1655; if ((tag_of(m_1656) == 0) && (tag_of(m_1657) == 0)) { V left8251_1658 = FLD(m_1656, 0); V left8252_1659 = FLD(m_1656, 1); V left8253_1660 = FLD(m_1656, 2); V left8254_1661 = FLD(m_1656, 3); V right8255_1662 = FLD(m_1657, 0); V right8256_1663 = FLD(m_1657, 1); V right8257_1664 = FLD(m_1657, 2); V right8258_1665 = FLD(m_1657, 3); _r = ((d_Equal_dOptionOf_uString_u(left8251_1658, right8255_1662)) & (((d_Equal_dListOf_uString_u(left8252_1659, right8256_1663)) & (((d_NativeString_dequal(left8253_1660, right8257_1664)) & (((d_Equal_dTerm(left8254_1661, right8258_1665)) & (TRUE_V)))))))); } else rt_panic("match: no case at kernel:1698"); _r; });
}
V d_Equal_dListOf_uString_u(V left_1666, V right_1667) {
  return ({ V _r = 0; V m_1668 = left_1666; V m_1669 = right_1667; if (((m_1668) == NIL) && ((m_1669) == NIL)) {  _r = TRUE_V; } else if (((m_1668) != NIL) && ((m_1669) != NIL)) { V left8259_1670 = FLD(m_1668, 0); V left8260_1671 = FLD(m_1668, 1); V right8261_1672 = FLD(m_1669, 0); V right8262_1673 = FLD(m_1669, 1); _r = ((d_NativeString_dequal(left8259_1670, right8261_1672)) & (((d_Equal_dListOf_uString_u(left8260_1671, right8262_1673)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1702"); _r; });
}
V d_Equal_dListOf_uTerm_uLeg_u(V left_1674, V right_1675) {
  return ({ V _r = 0; V m_1676 = left_1674; V m_1677 = right_1675; if (((m_1676) == NIL) && ((m_1677) == NIL)) {  _r = TRUE_V; } else if (((m_1676) != NIL) && ((m_1677) != NIL)) { V left8267_1678 = FLD(m_1676, 0); V left8268_1679 = FLD(m_1676, 1); V right8269_1680 = FLD(m_1677, 0); V right8270_1681 = FLD(m_1677, 1); _r = ((d_Equal_dTerm_uLeg(left8267_1678, right8269_1680)) & (((d_Equal_dListOf_uTerm_uLeg_u(left8268_1679, right8270_1681)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1708"); _r; });
}
V d_Equal_dLiteral(V left_1682, V right_1683) {
  return ({ V _r = 0; V m_1684 = left_1682; V m_1685 = right_1683; if ((tag_of(m_1684) == 0) && (tag_of(m_1685) == 0)) { V left8293_1686 = FLD(m_1684, 0); V right8294_1687 = FLD(m_1685, 0); _r = ((d_NativeString_dequal(left8293_1686, right8294_1687)) & (TRUE_V)); } else if ((tag_of(m_1684) == 1) && (tag_of(m_1685) == 1)) { V left8295_1688 = FLD(m_1684, 0); V right8296_1689 = FLD(m_1685, 0); _r = ((d_Big_dis_ueq(left8295_1688, right8296_1689)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1714"); _r; });
}
V d_Equal_dGlobal_uAxiom_uentry(V left_1690, V right_1691) {
  return ({ V _r = 0; V m_1692 = left_1690; V m_1693 = right_1691; if ((tag_of(m_1692) == 0) && (tag_of(m_1693) == 0)) { V left8299_1694 = FLD(m_1692, 0); V right8300_1695 = FLD(m_1693, 0); _r = ((d_Equal_dTerm(left8299_1694, right8300_1695)) & (TRUE_V)); } else rt_panic("match: no case at kernel:1720"); _r; });
}
V d_Equal_dGlobal_uPrim_uentry(V left_1696, V right_1697) {
  return ({ V _r = 0; V m_1698 = left_1696; V m_1699 = right_1697; if ((tag_of(m_1698) == 0) && (tag_of(m_1699) == 0)) { V left8303_1700 = FLD(m_1698, 0); V left8304_1701 = FLD(m_1698, 1); V right8305_1702 = FLD(m_1699, 0); V right8306_1703 = FLD(m_1699, 1); _r = ((d_Equal_dTerm(left8303_1700, right8305_1702)) & (((d_Equal_dPrim(left8304_1701, right8306_1703)) & (TRUE_V)))); } else rt_panic("match: no case at kernel:1724"); _r; });
}
V d_Equal_dPrim(V left_1704, V right_1705) {
  return ({ V _r = 0; V m_1706 = left_1704; V m_1707 = right_1705; if ((tag_of(m_1706) == 0) && (tag_of(m_1707) == 0)) {  _r = TRUE_V; } else if ((tag_of(m_1706) == 1) && (tag_of(m_1707) == 1)) {  _r = TRUE_V; } else if ((tag_of(m_1706) == 2) && (tag_of(m_1707) == 2)) {  _r = TRUE_V; } else if ((tag_of(m_1706) == 3) && (tag_of(m_1707) == 3)) {  _r = TRUE_V; } else if ((tag_of(m_1706) == 4) && (tag_of(m_1707) == 4)) {  _r = TRUE_V; } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1728"); _r; });
}
V d_Equal_dOptionOf_uPositivity_uFamily_u(V left_1708, V right_1709) {
  return ({ V _r = 0; V m_1710 = left_1708; V m_1711 = right_1709; if (((m_1710) == NONE) && ((m_1711) == NONE)) {  _r = TRUE_V; } else if (((m_1710) != NONE) && ((m_1711) != NONE)) { V left8314_1712 = FLD(m_1710, 0); V right8315_1713 = FLD(m_1711, 0); _r = ((d_Equal_dPositivity_uFamily(left8314_1712, right8315_1713)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1737"); _r; });
}
V d_Equal_dPositivity_uFamily(V left_1714, V right_1715) {
  return ({ V _r = 0; V m_1716 = left_1714; V m_1717 = right_1715; if ((tag_of(m_1716) == 0) && (tag_of(m_1717) == 0)) { V left8316_1718 = FLD(m_1716, 0); V left8317_1719 = FLD(m_1716, 1); V left8318_1720 = FLD(m_1716, 2); V left8319_1721 = FLD(m_1716, 3); V left8320_1722 = FLD(m_1716, 4); V left8321_1723 = FLD(m_1716, 5); V left8322_1724 = FLD(m_1716, 6); V right8323_1725 = FLD(m_1717, 0); V right8324_1726 = FLD(m_1717, 1); V right8325_1727 = FLD(m_1717, 2); V right8326_1728 = FLD(m_1717, 3); V right8327_1729 = FLD(m_1717, 4); V right8328_1730 = FLD(m_1717, 5); V right8329_1731 = FLD(m_1717, 6); _r = ((d_NativeString_dequal(left8316_1718, right8323_1725)) & (((d_Equal_dPositivity_uTelescope(left8317_1719, right8324_1726)) & (((d_Equal_dPositivity_uTelescope(left8318_1720, right8325_1727)) & (((d_Big_dis_ueq(left8319_1721, right8326_1728)) & (((d_Equal_dPositivity_uCtor_ustatus(left8320_1722, right8327_1729)) & (((d_Equal_dListOf_uPositivity_uCtor_u(left8321_1723, right8328_1730)) & (((((((left8322_1724) ^ (right8329_1731))) ^ 1u)) & (TRUE_V)))))))))))))); } else rt_panic("match: no case at kernel:1743"); _r; });
}
V d_Equal_dListOf_uPositivity_uCtor_u(V left_1732, V right_1733) {
  return ({ V _r = 0; V m_1734 = left_1732; V m_1735 = right_1733; if (((m_1734) == NIL) && ((m_1735) == NIL)) {  _r = TRUE_V; } else if (((m_1734) != NIL) && ((m_1735) != NIL)) { V left8330_1736 = FLD(m_1734, 0); V left8331_1737 = FLD(m_1734, 1); V right8332_1738 = FLD(m_1735, 0); V right8333_1739 = FLD(m_1735, 1); _r = ((d_Equal_dPositivity_uCtor(left8330_1736, right8332_1738)) & (((d_Equal_dListOf_uPositivity_uCtor_u(left8331_1737, right8333_1739)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1747"); _r; });
}
V d_Equal_dPositivity_uCtor(V left_1740, V right_1741) {
  return ({ V _r = 0; V m_1742 = left_1740; V m_1743 = right_1741; if ((tag_of(m_1742) == 0) && (tag_of(m_1743) == 0)) { V left8334_1744 = FLD(m_1742, 0); V left8335_1745 = FLD(m_1742, 1); V left8336_1746 = FLD(m_1742, 2); V left8337_1747 = FLD(m_1742, 3); V left8338_1748 = FLD(m_1742, 4); V right8339_1749 = FLD(m_1743, 0); V right8340_1750 = FLD(m_1743, 1); V right8341_1751 = FLD(m_1743, 2); V right8342_1752 = FLD(m_1743, 3); V right8343_1753 = FLD(m_1743, 4); _r = ((d_NativeString_dequal(left8334_1744, right8339_1749)) & (((d_Equal_dPositivity_uTelescope(left8335_1745, right8340_1750)) & (((d_Equal_dListOf_uTerm_u(left8336_1746, right8341_1751)) & (((d_Big_dis_ueq(left8337_1747, right8342_1752)) & (((((((left8338_1748) ^ (right8343_1753))) ^ 1u)) & (TRUE_V)))))))))); } else rt_panic("match: no case at kernel:1753"); _r; });
}
V d_Equal_dPositivity_uTelescope(V left_1754, V right_1755) {
  return ({ V _r = 0; V m_1756 = left_1754; V m_1757 = right_1755; if (((m_1756) == NIL) && ((m_1757) == NIL)) {  _r = TRUE_V; } else if (((m_1756) != NIL) && ((m_1757) != NIL)) { V left8344_1758 = FLD(m_1756, 0); V left8345_1759 = FLD(m_1756, 1); V right8346_1760 = FLD(m_1757, 0); V right8347_1761 = FLD(m_1757, 1); _r = ((d_Equal_dTupleOf3_uQuantity_u_uString_u_uTerm_u(left8344_1758, right8346_1760)) & (((d_Equal_dListOf_uTupleOf3_uQuantity_u_uString_u_uTerm_u_u(left8345_1759, right8347_1761)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1757"); _r; });
}
V d_Equal_dListOf_uTupleOf3_uQuantity_u_uString_u_uTerm_u_u(V left_1762, V right_1763) {
  return ({ V _r = 0; V m_1764 = left_1762; V m_1765 = right_1763; if (((m_1764) == NIL) && ((m_1765) == NIL)) {  _r = TRUE_V; } else if (((m_1764) != NIL) && ((m_1765) != NIL)) { V left8348_1766 = FLD(m_1764, 0); V left8349_1767 = FLD(m_1764, 1); V right8350_1768 = FLD(m_1765, 0); V right8351_1769 = FLD(m_1765, 1); _r = ((d_Equal_dTupleOf3_uQuantity_u_uString_u_uTerm_u(left8348_1766, right8350_1768)) & (((d_Equal_dListOf_uTupleOf3_uQuantity_u_uString_u_uTerm_u_u(left8349_1767, right8351_1769)) & (TRUE_V)))); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1763"); _r; });
}
V d_Equal_dTupleOf3_uQuantity_u_uString_u_uTerm_u(V left_1770, V right_1771) {
  return ({ V _r = 0; V m_1772 = left_1770; V m_1773 = right_1771; if ((tag_of(m_1772) == 0) && (tag_of(m_1773) == 0)) { V left8352_1774 = FLD(m_1772, 0); V left8353_1775 = FLD(m_1772, 1); V left8354_1776 = FLD(m_1772, 2); V right8355_1777 = FLD(m_1773, 0); V right8356_1778 = FLD(m_1773, 1); V right8357_1779 = FLD(m_1773, 2); _r = ((d_Equal_dQuantity(left8352_1774, right8355_1777)) & (((d_NativeString_dequal(left8353_1775, right8356_1778)) & (((d_Equal_dTerm(left8354_1776, right8357_1779)) & (TRUE_V)))))); } else rt_panic("match: no case at kernel:1769"); _r; });
}
V d_Equal_dPositivity_uCtor_ustatus(V left_1780, V right_1781) {
  return ({ V _r = 0; V m_1782 = left_1780; V m_1783 = right_1781; if ((tag_of(m_1782) == 0) && (tag_of(m_1783) == 0)) {  _r = TRUE_V; } else if ((tag_of(m_1782) == 1) && (tag_of(m_1783) == 1)) {  _r = TRUE_V; } else if ((tag_of(m_1782) == 2) && (tag_of(m_1783) == 2)) { V left8358_1784 = FLD(m_1782, 0); V right8359_1785 = FLD(m_1783, 0); _r = ((d_Equal_dListOf_uString_u(left8358_1784, right8359_1785)) & (TRUE_V)); } else if (1) {  _r = FALSE_V; } else rt_panic("match: no case at kernel:1773"); _r; });
}
V d_Rules_dat(V n_636_1851, V xs_637_1852) {
_top: ;
  return ({ V scrut80_1853 = xs_637_1852; ({ V _r = 0; V m_1854 = scrut80_1853; if (((m_1854) == NIL)) {  _r = ({ V __1855 = UNIT; NONE; }); } else if (((m_1854) != NIL)) { V _m_1854_a0_1856 = FLD(m_1854, 0); V _m_1854_a1_1857 = FLD(m_1854, 1); _r = ({ V p81_1858 = _m_1854_a0_1856; ({ V p82_1859 = _m_1854_a1_1857; ((d_Big_dis_ueq(n_636_1851, d_Big_dzero())) != FALSE_V ? SOME(p81_1858) : ({ V a_1860 = d_NativeInt_dsub(n_636_1851, d_Big_done()); V a_1861 = p82_1859; n_636_1851 = a_1860; xs_637_1852 = a_1861;  goto _top; (V)0; })); }); }); } else rt_panic("match: no case at kernel:1851"); _r; }); });
}
V d_Error_dtermination_umsg(V n_310_1862) {
  return str_concat(CON(((V)&S_4), CON(n_310_1862, CON(((V)&S_5), NIL))));
}
V d_Error_dto_ustring(V e_367_1863) {
  return ({ V scrut776_1864 = e_367_1863; ({ V _r = 0; V m_1865 = scrut776_1864; switch (tag_of(m_1865)) { case 0: { V _m_1865_a0_1866 = FLD(m_1865, 0); _r = ({ V p777_1867 = _m_1865_a0_1866; str_append(((V)&S_6), p777_1867); }); break; } case 1: { V _m_1865_a0_1868 = FLD(m_1865, 0); V _m_1865_a1_1869 = FLD(m_1865, 1); V _m_1865_a2_1870 = FLD(m_1865, 2); _r = ({ V p778_1871 = _m_1865_a0_1868; ({ V p779_1872 = _m_1865_a1_1869; ({ V p780_1873 = _m_1865_a2_1870; str_concat(CON(((V)&S_7), CON(d_Big_dshow(p779_1872), CON(((V)&S_8), CON(d_Big_dshow(p780_1873), CON(((V)&S_9), CON(p778_1871, NIL))))))); }); }); }); break; } case 2: { V _m_1865_a0_1874 = FLD(m_1865, 0); _r = ({ V p781_1875 = _m_1865_a0_1874; str_append(((V)&S_10), p781_1875); }); break; } case 3: { V _m_1865_a0_1876 = FLD(m_1865, 0); _r = ({ V p782_1877 = _m_1865_a0_1876; str_append(((V)&S_11), p782_1877); }); break; } case 4: { V _m_1865_a0_1878 = FLD(m_1865, 0); _r = ({ V p783_1879 = _m_1865_a0_1878; str_append(((V)&S_12), p783_1879); }); break; } case 5: { V _m_1865_a0_1880 = FLD(m_1865, 0); _r = ({ V p784_1881 = _m_1865_a0_1880; str_append(((V)&S_13), p784_1881); }); break; } case 6: { V _m_1865_a0_1882 = FLD(m_1865, 0); _r = ({ V p785_1883 = _m_1865_a0_1882; str_append(((V)&S_14), p785_1883); }); break; } case 7: { V _m_1865_a0_1884 = FLD(m_1865, 0); _r = ({ V p786_1885 = _m_1865_a0_1884; str_append(((V)&S_15), p786_1885); }); break; } case 8: { V _m_1865_a0_1886 = FLD(m_1865, 0); _r = ({ V p787_1887 = _m_1865_a0_1886; str_append(((V)&S_16), p787_1887); }); break; } case 9: { V _m_1865_a0_1888 = FLD(m_1865, 0); _r = ({ V p788_1889 = _m_1865_a0_1888; str_append(((V)&S_17), p788_1889); }); break; } case 10: { V _m_1865_a0_1890 = FLD(m_1865, 0); _r = ({ V p789_1891 = _m_1865_a0_1890; str_append(((V)&S_18), p789_1891); }); break; } case 11: { V _m_1865_a0_1892 = FLD(m_1865, 0); _r = ({ V p790_1893 = _m_1865_a0_1892; str_append(((V)&S_19), p790_1893); }); break; } case 12: { V _m_1865_a0_1894 = FLD(m_1865, 0); _r = ({ V p791_1895 = _m_1865_a0_1894; str_append(((V)&S_20), p791_1895); }); break; } case 13: { V _m_1865_a0_1896 = FLD(m_1865, 0); _r = ({ V p792_1897 = _m_1865_a0_1896; str_append(((V)&S_21), p792_1897); }); break; } case 14: { V _m_1865_a0_1898 = FLD(m_1865, 0); _r = ({ V p793_1899 = _m_1865_a0_1898; str_append(((V)&S_22), d_Error_dtermination_umsg(p793_1899)); }); break; } default: rt_panic("match: no case at kernel:1858"); } _r; }); });
}
V d_Level_done(void) {
  static V memo; static int done;
  if (!done) { memo = d_Big_done(); rt_root(&memo); done = 1; }
  return memo;
}
V d_Prim_dname(V p_300_1900) {
  return ({ V scrut800_1901 = p_300_1900; ({ V _r = 0; V m_1902 = scrut800_1901; switch (tag_of(m_1902)) { case 0: {  _r = ({ V __1903 = UNIT; ((V)&S_23); }); break; } case 1: {  _r = ({ V __1904 = UNIT; ((V)&S_24); }); break; } case 2: {  _r = ({ V __1905 = UNIT; ((V)&S_25); }); break; } case 3: {  _r = ({ V __1906 = UNIT; ((V)&S_26); }); break; } case 4: {  _r = ({ V __1907 = UNIT; ((V)&S_27); }); break; } default: rt_panic("match: no case at kernel:1865"); } _r; }); });
}
V d_Prim_dnat_uname(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_28); rt_root(&memo); done = 1; }
  return memo;
}
V d_Prim_dnat_uty(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor1(10, d_Prim_dnat_uname()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_darrow(V q_785_1908, V x_786_1909, V dom_787_1910, V cod_788_1911) {
  return rt_ctor2(3, rt_ctor3(0, q_785_1908, x_786_1909, dom_787_1910), cod_788_1911);
}
V d_Rules_dleg_uof(V body_791_1912) {
  return rt_ctor2(0, NIL, body_791_1912);
}
V d_Rules_ddiagram_uof(V legs_794_1913) {
  return rt_ctor2(6, rt_ctor1(1, d_Big_dof_unat(list_length(legs_794_1913))), d_SeqList_dmap(clo_new(w_Rules_dleg_uof, 1, 0), legs_794_1913));
}
V d_Rules_dprod_uty(V legs_800_1914) {
  return rt_ctor2(3, rt_ctor1(1, d_Big_dof_unat(list_length(legs_800_1914))), d_Rules_ddiagram_uof(legs_800_1914));
}
V d_Rules_dunit_uty(V l_803_1915) {
  return rt_ctor2(9, d_Rules_dprod_uty(NIL), rt_ctor1(1, l_803_1915));
}
V d_Rules_dsum_uty(V legs_797_1916) {
  return rt_ctor2(2, rt_ctor1(1, d_Big_dof_unat(list_length(legs_797_1916))), d_Rules_ddiagram_uof(legs_797_1916));
}
V d_Rules_dbool_uty(void) {
  static V memo; static int done;
  if (!done) { memo = d_Rules_dsum_uty(CON(d_Rules_dunit_uty(d_Level_done()), CON(d_Rules_dunit_uty(d_Level_done()), NIL))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Prim_dty(V p_470_1917) {
  return ({ V scrut803_1918 = clo_new(lam_1920, 1, 0); ({ V scrut804_1921 = p_470_1917; ({ V _r = 0; V m_1922 = scrut804_1921; switch (tag_of(m_1922)) { case 0: {  _r = ({ V __1923 = UNIT; ap(scrut803_1918, d_Prim_dnat_uty()); }); break; } case 1: {  _r = ({ V __1924 = UNIT; ap(scrut803_1918, d_Prim_dnat_uty()); }); break; } case 2: {  _r = ({ V __1925 = UNIT; ap(scrut803_1918, d_Prim_dnat_uty()); }); break; } case 3: {  _r = ({ V __1926 = UNIT; ap(scrut803_1918, d_Rules_dbool_uty()); }); break; } case 4: {  _r = ({ V __1927 = UNIT; ap(scrut803_1918, d_Rules_dbool_uty()); }); break; } default: rt_panic("match: no case at kernel:1897"); } _r; }); }); });
}
V d_Global_dadd(V name_762_1928, V entry_763_1929, V globals_764_1930) {
  return rt_ctor2(0, d_Assoc_dadd(clo_new(lam_1933, 2, 0), name_762_1928, entry_763_1929, d_Get_dGlobal_dentries(globals_764_1930)), d_Get_dGlobal_dfamilies(globals_764_1930));
}
V d_Global_dempty(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor2(0, d_Assoc_dempty(), d_Assoc_dempty()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Prim_dcatalog(void) {
  static V memo; static int done;
  if (!done) { memo = CON(((V)0), CON(((V)1), CON(((V)2), CON(((V)3), CON(((V)4), NIL))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Global_dinitial(void) {
  static V memo; static int done;
  if (!done) { memo = ({ V scrut795_1934 = rt_ctor1(1, rt_ctor1(0, rt_ctor1(1, d_Level_done()))); d_SeqList_dfold(clo_new(lam_1937, 2, 0), d_Prim_dcatalog(), d_Global_dadd(d_Prim_dnat_uname(), scrut795_1934, d_Global_dempty())); }); rt_root(&memo); done = 1; }
  return memo;
}
V d_Budget_dunlimited(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor1(0, clo_new(lam_1940, 1, 0)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Bignum_dof_uint(V value_435_1941) {
  return d_Big_didentity(value_435_1941);
}
V d_Bignum_dmul(V left_454_1942, V right_455_1943) {
  return d_Big_dmul(left_454_1942, right_455_1943);
}
V d_Bignum_dadd(V left_450_1944, V right_451_1945) {
  return d_Big_dadd(left_450_1944, right_451_1945);
}
V d_Bignum_dof_udecimal(V source_462_1946) {
  return ({ V scrut838_1947 = clo_new(lam_1955, 2, 0); ((d_Big_dis_ueq(d_Big_dof_unat(str_length(source_462_1946)), d_Big_dzero())) != FALSE_V ? NONE : d_NativeString_dfold(scrut838_1947, source_462_1946, SOME(d_Big_dzero()))); });
}
V d_Bignum_dto_ustring(V value_567_1956) {
  return d_Big_dshow(value_567_1956);
}
V d_Bignum_dequal(V left_440_1957, V right_441_1958) {
  return d_Big_dis_ueq(left_440_1957, right_441_1958);
}
V d_Bignum_dsign(V value_447_1959) {
  return d_Big_dsign(value_447_1959);
}
V d_Bignum_dto_uint(V value_570_1960) {
  return ((d_Big_dfits_uint(value_570_1960)) != FALSE_V ? SOME(d_Big_didentity(value_570_1960)) : NONE);
}
V d_Check_dmake(V globals_463_1961, V budget_464_1962) {
  return ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = globals_463_1961; _o->f[1] = NIL; _o->f[2] = NIL; _o->f[3] = d_Big_dzero(); _o->f[4] = budget_464_1962; (V)_o; });
}
V d_Check_dnames_uof(V c_497_1963) {
  return d_SeqList_dmap(clo_new(lam_1973, 1, 0), d_Get_dCheck_dCtx_dlocals(c_497_1963));
}
V d_Global_dfind_ufamily(V name_767_1974, V globals_768_1975) {
  return d_Assoc_dfind(clo_new(lam_1978, 2, 0), name_767_1974, d_Get_dGlobal_dfamilies(globals_768_1975));
}
V d_Positivity_dctor_uof(V name_429_1979, V f_430_1980) {
  return d_SeqList_dfind(({ V _c = clo_new(lam_1982, 1, 1); CLO_ENV(_c)[0] = name_429_1979; _c; }), d_Get_dPositivity_dFamily_df_uctors(f_430_1980));
}
V d_Rules_dall_uok(V xs_673_1983) {
  return d_SeqList_dfold(clo_new(lam_1998, 2, 0), xs_673_1983, DONE(NIL));
}
V d_Value_dclose(V env_437_1999, V body_438_2000) {
  return rt_ctor2(0, env_437_1999, body_438_2000);
}
V d_Rules_dspar_uword(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_31); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dsnu_uword(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_32); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dmap_ushape(V f_773_2001, V s_774_2002) {
  return ({ V scrut2008_2003 = s_774_2002; ({ V _r = 0; V m_2004 = scrut2008_2003; switch (tag_of(m_2004)) { case 0: { V _m_2004_a0_2005 = FLD(m_2004, 0); V _m_2004_a1_2006 = FLD(m_2004, 1); V _m_2004_a2_2007 = FLD(m_2004, 2); _r = ({ V p2009_2008 = _m_2004_a0_2005; ({ V p2010_2009 = _m_2004_a1_2006; ({ V p2011_2010 = _m_2004_a2_2007; ({ V _r = 0; V m_2011 = ap(f_773_2001, p2011_2010); switch (tag_of(m_2011)) { case 1: { V _m_2011_a0_2012 = FLD(m_2011, 0); _r = ({ V item2014_2013 = _m_2011_a0_2012; DONE(({ V local2013_2014 = item2014_2013; rt_ctor3(0, p2009_2008, p2010_2009, local2013_2014); })); }); break; } case 0: { V _m_2011_a0_2015 = FLD(m_2011, 0); _r = ({ V item2015_2016 = _m_2011_a0_2015; FAIL(item2015_2016); }); break; } default: rt_panic("match: no case at kernel:1968"); } _r; }); }); }); }); break; } case 1: { V _m_2004_a0_2017 = FLD(m_2004, 0); _r = ({ V p2016_2018 = _m_2004_a0_2017; DONE(rt_ctor1(1, p2016_2018)); }); break; } case 2: { V _m_2004_a0_2019 = FLD(m_2004, 0); V _m_2004_a1_2020 = FLD(m_2004, 1); _r = ({ V p2017_2021 = _m_2004_a0_2019; ({ V p2018_2022 = _m_2004_a1_2020; FAIL(rt_ctor1(0, d_Rules_dspar_uword())); }); }); break; } case 3: { V _m_2004_a0_2023 = FLD(m_2004, 0); V _m_2004_a1_2024 = FLD(m_2004, 1); _r = ({ V p2019_2025 = _m_2004_a0_2023; ({ V p2020_2026 = _m_2004_a1_2024; ({ V _r = 0; V m_2027 = d_Rules_dall_uok(d_SeqList_dmap(f_773_2001, p2020_2026)); switch (tag_of(m_2027)) { case 1: { V _m_2027_a0_2028 = FLD(m_2027, 0); _r = ({ V item2023_2029 = _m_2027_a0_2028; DONE(({ V local2022_2030 = item2023_2029; rt_ctor2(3, p2019_2025, local2022_2030); })); }); break; } case 0: { V _m_2027_a0_2031 = FLD(m_2027, 0); _r = ({ V item2024_2032 = _m_2027_a0_2031; FAIL(item2024_2032); }); break; } default: rt_panic("match: no case at kernel:1968"); } _r; }); }); }); break; } case 4: { V _m_2004_a0_2033 = FLD(m_2004, 0); V _m_2004_a1_2034 = FLD(m_2004, 1); _r = ({ V p2025_2035 = _m_2004_a0_2033; ({ V p2026_2036 = _m_2004_a1_2034; FAIL(rt_ctor1(0, d_Rules_dsnu_uword())); }); }); break; } default: rt_panic("match: no case at kernel:1968"); } _r; }); });
}
V d_Eval_deval_uaddr(V globals_948_2037, V env_949_2038, V a_950_2039) {
  return ({ V scrut2046_2040 = a_950_2039; ({ V _r = 0; V m_2041 = scrut2046_2040; switch (tag_of(m_2041)) { case 0: { V _m_2041_a0_2042 = FLD(m_2041, 0); V _m_2041_a1_2043 = FLD(m_2041, 1); _r = ({ V p2047_2044 = _m_2041_a0_2042; ({ V p2048_2045 = _m_2041_a1_2043; ({ V _r = 0; V m_2046 = d_Eval_deval(globals_948_2037, env_949_2038, p2048_2045); switch (tag_of(m_2046)) { case 1: { V _m_2046_a0_2047 = FLD(m_2046, 0); _r = ({ V item2051_2048 = _m_2046_a0_2047; DONE(({ V local2050_2049 = item2051_2048; rt_ctor2(0, p2047_2044, local2050_2049); })); }); break; } case 0: { V _m_2046_a0_2050 = FLD(m_2046, 0); _r = ({ V item2052_2051 = _m_2046_a0_2050; FAIL(item2052_2051); }); break; } default: rt_panic("match: no case at kernel:1972"); } _r; }); }); }); break; } case 1: { V _m_2041_a0_2052 = FLD(m_2041, 0); _r = ({ V p2053_2053 = _m_2041_a0_2052; DONE(rt_ctor1(1, p2053_2053)); }); break; } case 2: { V _m_2041_a0_2054 = FLD(m_2041, 0); _r = ({ V p2054_2055 = _m_2041_a0_2054; DONE(rt_ctor1(2, p2054_2055)); }); break; } default: rt_panic("match: no case at kernel:1972"); } _r; }); });
}
V d_Eval_dev(V globals_943_2056) {
  return rt_ctor1(0, ({ V _c = clo_new(lam_2059, 2, 1); CLO_ENV(_c)[0] = globals_943_2056; _c; }));
}
V d_Level_dmax(V a_298_2060, V b_299_2061) {
  return ((d_Big_dis_ult(a_298_2060, b_299_2061)) != FALSE_V ? b_299_2061 : a_298_2060);
}
V d_Level_dzero(void) {
  static V memo; static int done;
  if (!done) { memo = d_Big_dzero(); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dmax_uof(V ls_620_2062) {
  return d_SeqList_dfold(clo_new(w_Level_dmax, 2, 0), ls_620_2062, d_Level_dzero());
}
V d_Rules_dspi_ulan_ulvl(V ls_982_2063) {
  return d_Rules_dmax_uof(ls_982_2063);
}
V d_Rules_das_uvpi(V s_811_2064) {
  return ({ V scrut2083_2065 = s_811_2064; ({ V _r = 0; V m_2066 = scrut2083_2065; switch (tag_of(m_2066)) { case 0: { V _m_2066_a0_2067 = FLD(m_2066, 0); V _m_2066_a1_2068 = FLD(m_2066, 1); V _m_2066_a2_2069 = FLD(m_2066, 2); _r = ({ V p2084_2070 = _m_2066_a0_2067; ({ V p2085_2071 = _m_2066_a1_2068; ({ V p2086_2072 = _m_2066_a2_2069; SOME(rt_ctor3(0, p2084_2070, p2085_2071, p2086_2072)); }); }); }); break; } case 1: { V _m_2066_a0_2073 = FLD(m_2066, 0); _r = ({ V p2087_2074 = _m_2066_a0_2073; NONE; }); break; } case 2: { V _m_2066_a0_2075 = FLD(m_2066, 0); V _m_2066_a1_2076 = FLD(m_2066, 1); _r = ({ V p2088_2077 = _m_2066_a0_2075; ({ V p2089_2078 = _m_2066_a1_2076; NONE; }); }); break; } case 3: { V _m_2066_a0_2079 = FLD(m_2066, 0); V _m_2066_a1_2080 = FLD(m_2066, 1); _r = ({ V p2090_2081 = _m_2066_a0_2079; ({ V p2091_2082 = _m_2066_a1_2080; NONE; }); }); break; } case 4: { V _m_2066_a0_2083 = FLD(m_2066, 0); V _m_2066_a1_2084 = FLD(m_2066, 1); _r = ({ V p2092_2085 = _m_2066_a0_2083; ({ V p2093_2086 = _m_2066_a1_2084; NONE; }); }); break; } default: rt_panic("match: no case at kernel:1991"); } _r; }); });
}
V d_Rules_dwrong_upack(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_33); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dspi_ulevels(V ops_962_2087, V ctx_963_2088, V s_964_2089, V diagram_965_2090) {
  return ({ V local2099_2091 = ({ V local2096_2092 = d_Rules_das_uvpi(s_964_2089); ({ V _r = 0; V m_2093 = local2096_2092; if (((m_2093) == NONE)) {  _r = ({ V __2094 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_2093) != NONE)) { V _m_2093_a0_2095 = FLD(m_2093, 0); _r = ({ V x_2096 = _m_2093_a0_2095; DONE(x_2096); }); } else rt_panic("match: no case at kernel:2002"); _r; }); }); ({ V local2103_2097 = local2099_2091; ({ V local2105_2098 = ({ V _c = clo_new(lam_2114, 1, 3); CLO_ENV(_c)[0] = ops_962_2087; CLO_ENV(_c)[1] = ctx_963_2088; CLO_ENV(_c)[2] = diagram_965_2090; _c; }); ({ V _r = 0; V m_2115 = local2103_2097; switch (tag_of(m_2115)) { case 1: { V _m_2115_a0_2116 = FLD(m_2115, 0); _r = ({ V item2106_2117 = _m_2115_a0_2116; ap(local2105_2098, item2106_2117); }); break; } case 0: { V _m_2115_a0_2118 = FLD(m_2115, 0); _r = ({ V item2107_2119 = _m_2115_a0_2118; FAIL(item2107_2119); }); break; } default: rt_panic("match: no case at kernel:1997"); } _r; }); }); }); });
}
V d_Rules_dspi_uform(V level_998_2120, V ops_999_2121, V ctx_1000_2122, V s_1001_2123, V diagram_1002_2124, V _expected_1003_2125) {
  return ({ V _r = 0; V m_2126 = d_Rules_dspi_ulevels(ops_999_2121, ctx_1000_2122, s_1001_2123, diagram_1002_2124); switch (tag_of(m_2126)) { case 1: { V _m_2126_a0_2127 = FLD(m_2126, 0); _r = ({ V item2120_2128 = _m_2126_a0_2127; DONE(ap(level_998_2120, item2120_2128)); }); break; } case 0: { V _m_2126_a0_2129 = FLD(m_2126, 0); _r = ({ V item2121_2130 = _m_2126_a0_2129; FAIL(item2121_2130); }); break; } default: rt_panic("match: no case at kernel:2005"); } _r; });
}
V d_Rules_dlevel_upair(V ls_623_2131) {
  return ({ V scrut2132_2132 = ls_623_2131; ({ V _r = 0; V m_2133 = scrut2132_2132; if (((m_2133) == NIL)) {  _r = ({ V __2134 = UNIT; NONE; }); } else if (((m_2133) != NIL)) { V _m_2133_a0_2135 = FLD(m_2133, 0); V _m_2133_a1_2136 = FLD(m_2133, 1); _r = ({ V p2133_2137 = _m_2133_a0_2135; ({ V p2134_2138 = _m_2133_a1_2136; ({ V _r = 0; V m_2139 = p2134_2138; if (((m_2139) == NIL)) {  _r = ({ V __2140 = UNIT; NONE; }); } else if (((m_2139) != NIL)) { V _m_2139_a0_2141 = FLD(m_2139, 0); V _m_2139_a1_2142 = FLD(m_2139, 1); _r = ({ V p2135_2143 = _m_2139_a0_2141; ({ V p2136_2144 = _m_2139_a1_2142; ({ V _r = 0; V m_2145 = p2136_2144; if (((m_2145) == NIL)) {  _r = ({ V __2146 = UNIT; SOME(rt_ctor2(0, p2133_2137, p2135_2143)); }); } else if (((m_2145) != NIL)) { V _m_2145_a0_2147 = FLD(m_2145, 0); V _m_2145_a1_2148 = FLD(m_2145, 1); _r = ({ V p2137_2149 = _m_2145_a0_2147; ({ V p2138_2150 = _m_2145_a1_2148; NONE; }); }); } else rt_panic("match: no case at kernel:2009"); _r; }); }); }); } else rt_panic("match: no case at kernel:2009"); _r; }); }); }); } else rt_panic("match: no case at kernel:2009"); _r; }); });
}
V d_Level_dequal(V a_333_2151, V b_334_2152) {
  return d_Big_dis_ueq(a_333_2151, b_334_2152);
}
V d_Rules_dimax(V l_616_2153, V l__617_2154) {
  return ((d_Level_dequal(l__617_2154, d_Level_dzero())) != FALSE_V ? d_Level_dzero() : d_Level_dmax(l_616_2153, l__617_2154));
}
V d_Rules_dspi_uran_ulvl(V ls_985_2155) {
  return ({ V local2141_2156 = d_Rules_dlevel_upair(ls_985_2155); ({ V _r = 0; V m_2157 = local2141_2156; if (((m_2157) == NONE)) {  _r = ({ V __2158 = UNIT; d_Rules_dmax_uof(ls_985_2155); }); } else if (((m_2157) != NONE)) { V _m_2157_a0_2159 = FLD(m_2157, 0); _r = ({ V value_2160 = _m_2157_a0_2159; ({ V local2143_2161 = value_2160; ({ V scrut2144_2162 = local2143_2161; ({ V _r = 0; V m_2163 = scrut2144_2162; if ((tag_of(m_2163) == 0)) { V _m_2163_a0_2164 = FLD(m_2163, 0); V _m_2163_a1_2165 = FLD(m_2163, 1); _r = ({ V p2145_2166 = _m_2163_a0_2164; ({ V p2146_2167 = _m_2163_a1_2165; d_Rules_dimax(p2145_2166, p2146_2167); }); }); } else rt_panic("match: no case at kernel:2019"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2018"); _r; }); });
}
V d_Quantity_dequal(V a_302_2168, V b_303_2169) {
  return ({ V scrut2178_2170 = rt_ctor2(0, a_302_2168, b_303_2169); ({ V _r = 0; V m_2171 = scrut2178_2170; if ((tag_of(m_2171) == 0)) { V _m_2171_a0_2172 = FLD(m_2171, 0); V _m_2171_a1_2173 = FLD(m_2171, 1); _r = ({ V p2179_2174 = _m_2171_a0_2172; ({ V p2180_2175 = _m_2171_a1_2173; ({ V _r = 0; V m_2176 = p2179_2174; switch (tag_of(m_2176)) { case 0: {  _r = ({ V __2177 = UNIT; ({ V _r = 0; V m_2178 = p2180_2175; switch (tag_of(m_2178)) { case 0: {  _r = ({ V __2179 = UNIT; TRUE_V; }); break; } case 1: {  _r = ({ V __2180 = UNIT; FALSE_V; }); break; } case 2: {  _r = ({ V __2181 = UNIT; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:2023"); } _r; }); }); break; } case 1: {  _r = ({ V __2182 = UNIT; ({ V _r = 0; V m_2183 = p2180_2175; switch (tag_of(m_2183)) { case 0: {  _r = ({ V __2184 = UNIT; FALSE_V; }); break; } case 1: {  _r = ({ V __2185 = UNIT; TRUE_V; }); break; } case 2: {  _r = ({ V __2186 = UNIT; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:2023"); } _r; }); }); break; } case 2: {  _r = ({ V __2187 = UNIT; ({ V _r = 0; V m_2188 = p2180_2175; switch (tag_of(m_2188)) { case 0: {  _r = ({ V __2189 = UNIT; FALSE_V; }); break; } case 1: {  _r = ({ V __2190 = UNIT; FALSE_V; }); break; } case 2: {  _r = ({ V __2191 = UNIT; TRUE_V; }); break; } default: rt_panic("match: no case at kernel:2023"); } _r; }); }); break; } default: rt_panic("match: no case at kernel:2023"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2023"); _r; }); });
}
V d_Quantity_dadd(V a_312_2192, V b_313_2193) {
  return ((d_Quantity_dequal(a_312_2192, ((V)0))) != FALSE_V ? b_313_2193 : ((d_Quantity_dequal(b_313_2193, ((V)0))) != FALSE_V ? a_312_2192 : ((V)2)));
}
V d_Quantity_dcombine(V f_627_2194, V g_628_2195, V a_629_2196, V b_630_2197) {
  return d_Assoc_dmerge(clo_new(lam_2200, 2, 0), ({ V _c = clo_new(lam_2216, 3, 2); CLO_ENV(_c)[0] = f_627_2194; CLO_ENV(_c)[1] = g_628_2195; _c; }), a_629_2196, b_630_2197);
}
V d_Quantity_dsequence(V a_640_2217, V b_641_2218) {
  return rt_ctor2(0, ({ V _r = 0; V m_2219 = d_Get_dQuantity_dUsage_dpaths(a_640_2217); if (((m_2219) == NONE)) {  _r = ({ V __2220 = UNIT; NONE; }); } else if (((m_2219) != NONE)) { V _m_2219_a0_2221 = FLD(m_2219, 0); _r = ({ V item2196_2222 = _m_2219_a0_2221; ({ V local2174_2223 = item2196_2222; ({ V _r = 0; V m_2224 = d_Get_dQuantity_dUsage_dpaths(b_641_2218); if (((m_2224) == NONE)) {  _r = ({ V __2225 = UNIT; NONE; }); } else if (((m_2224) != NONE)) { V _m_2224_a0_2226 = FLD(m_2224, 0); _r = ({ V item2194_2227 = _m_2224_a0_2226; SOME(({ V local2177_2228 = item2194_2227; d_Quantity_dcombine(clo_new(w_Quantity_dadd, 2, 0), clo_new(w_Quantity_dadd, 2, 0), local2174_2223, local2177_2228); })); }); } else rt_panic("match: no case at kernel:2034"); _r; }); }); }); } else rt_panic("match: no case at kernel:2034"); _r; }), d_Quantity_dcombine(clo_new(w_Quantity_dadd, 2, 0), clo_new(w_Quantity_dadd, 2, 0), d_Get_dQuantity_dUsage_dreads(a_640_2217), d_Get_dQuantity_dUsage_dreads(b_641_2218)));
}
V d_Rules_dopen_uclosure(V ev_391_2229, V clo_392_2230, V args_393_2231) {
  return ap2(d_Get_dRules_dEvaluator_dev_ueval(ev_391_2229), list_reverse_go(args_393_2231, d_Get_dValue_dClosure_denv(clo_392_2230)), d_Get_dValue_dClosure_dbody(clo_392_2230));
}
V d_Quantity_dmul(V a_298_2232, V b_299_2233) {
  return ({ V scrut2197_2234 = rt_ctor2(0, a_298_2232, b_299_2233); ({ V _r = 0; V m_2235 = scrut2197_2234; if ((tag_of(m_2235) == 0)) { V _m_2235_a0_2236 = FLD(m_2235, 0); V _m_2235_a1_2237 = FLD(m_2235, 1); _r = ({ V p2198_2238 = _m_2235_a0_2236; ({ V p2199_2239 = _m_2235_a1_2237; ({ V _r = 0; V m_2240 = p2198_2238; switch (tag_of(m_2240)) { case 0: {  _r = ({ V __2241 = UNIT; ({ V _r = 0; V m_2242 = p2199_2239; switch (tag_of(m_2242)) { case 0: {  _r = ({ V __2243 = UNIT; ((V)0); }); break; } case 1: {  _r = ({ V __2244 = UNIT; ((V)0); }); break; } case 2: {  _r = ({ V __2245 = UNIT; ((V)0); }); break; } default: rt_panic("match: no case at kernel:2041"); } _r; }); }); break; } case 1: {  _r = ({ V __2246 = UNIT; ({ V _r = 0; V m_2247 = p2199_2239; switch (tag_of(m_2247)) { case 0: {  _r = ({ V __2248 = UNIT; ((V)0); }); break; } case 1: {  _r = ({ V __2249 = UNIT; ((V)1); }); break; } case 2: {  _r = ({ V __2250 = UNIT; ((V)2); }); break; } default: rt_panic("match: no case at kernel:2041"); } _r; }); }); break; } case 2: {  _r = ({ V __2251 = UNIT; ({ V _r = 0; V m_2252 = p2199_2239; switch (tag_of(m_2252)) { case 0: {  _r = ({ V __2253 = UNIT; ((V)0); }); break; } case 1: {  _r = ({ V __2254 = UNIT; ((V)2); }); break; } case 2: {  _r = ({ V __2255 = UNIT; ((V)2); }); break; } default: rt_panic("match: no case at kernel:2041"); } _r; }); }); break; } default: rt_panic("match: no case at kernel:2041"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2041"); _r; }); });
}
V d_Rules_done_uof(V xs_628_2256) {
  return ({ V scrut2200_2257 = xs_628_2256; ({ V _r = 0; V m_2258 = scrut2200_2257; if (((m_2258) == NIL)) {  _r = ({ V __2259 = UNIT; NONE; }); } else if (((m_2258) != NIL)) { V _m_2258_a0_2260 = FLD(m_2258, 0); V _m_2258_a1_2261 = FLD(m_2258, 1); _r = ({ V p2201_2262 = _m_2258_a0_2260; ({ V p2202_2263 = _m_2258_a1_2261; ({ V _r = 0; V m_2264 = p2202_2263; if (((m_2264) == NIL)) {  _r = ({ V __2265 = UNIT; SOME(p2201_2262); }); } else if (((m_2264) != NIL)) { V _m_2264_a0_2266 = FLD(m_2264, 0); V _m_2264_a1_2267 = FLD(m_2264, 1); _r = ({ V p2203_2268 = _m_2264_a0_2266; ({ V p2204_2269 = _m_2264_a1_2267; NONE; }); }); } else rt_panic("match: no case at kernel:2045"); _r; }); }); }); } else rt_panic("match: no case at kernel:2045"); _r; }); });
}
V d_Term_das_uapt(V a_416_2270) {
  return ({ V scrut2208_2271 = a_416_2270; ({ V _r = 0; V m_2272 = scrut2208_2271; switch (tag_of(m_2272)) { case 0: { V _m_2272_a0_2273 = FLD(m_2272, 0); V _m_2272_a1_2274 = FLD(m_2272, 1); _r = ({ V p2209_2275 = _m_2272_a0_2273; ({ V p2210_2276 = _m_2272_a1_2274; SOME(rt_ctor2(0, p2209_2275, p2210_2276)); }); }); break; } case 1: { V _m_2272_a0_2277 = FLD(m_2272, 0); _r = ({ V p2211_2278 = _m_2272_a0_2277; NONE; }); break; } case 2: { V _m_2272_a0_2279 = FLD(m_2272, 0); _r = ({ V p2212_2280 = _m_2272_a0_2279; NONE; }); break; } default: rt_panic("match: no case at kernel:2049"); } _r; }); });
}
V d_Value_das_ulan(V v_445_2281) {
  return ({ V scrut2220_2282 = v_445_2281; ({ V _r = 0; V m_2283 = scrut2220_2282; switch (tag_of(m_2283)) { case 0: { V _m_2283_a0_2284 = FLD(m_2283, 0); _r = ({ V p2221_2285 = _m_2283_a0_2284; NONE; }); break; } case 1: { V _m_2283_a0_2286 = FLD(m_2283, 0); V _m_2283_a1_2287 = FLD(m_2283, 1); V _m_2283_a2_2288 = FLD(m_2283, 2); _r = ({ V p2222_2289 = _m_2283_a0_2286; ({ V p2223_2290 = _m_2283_a1_2287; ({ V p2224_2291 = _m_2283_a2_2288; SOME(rt_ctor3(0, p2222_2289, p2223_2290, p2224_2291)); }); }); }); break; } case 2: { V _m_2283_a0_2292 = FLD(m_2283, 0); V _m_2283_a1_2293 = FLD(m_2283, 1); V _m_2283_a2_2294 = FLD(m_2283, 2); _r = ({ V p2225_2295 = _m_2283_a0_2292; ({ V p2226_2296 = _m_2283_a1_2293; ({ V p2227_2297 = _m_2283_a2_2294; NONE; }); }); }); break; } case 3: { V _m_2283_a0_2298 = FLD(m_2283, 0); V _m_2283_a1_2299 = FLD(m_2283, 1); V _m_2283_a2_2300 = FLD(m_2283, 2); _r = ({ V p2228_2301 = _m_2283_a0_2298; ({ V p2229_2302 = _m_2283_a1_2299; ({ V p2230_2303 = _m_2283_a2_2300; NONE; }); }); }); break; } case 4: { V _m_2283_a0_2304 = FLD(m_2283, 0); V _m_2283_a1_2305 = FLD(m_2283, 1); _r = ({ V p2231_2306 = _m_2283_a0_2304; ({ V p2232_2307 = _m_2283_a1_2305; NONE; }); }); break; } case 5: { V _m_2283_a0_2308 = FLD(m_2283, 0); _r = ({ V p2233_2309 = _m_2283_a0_2308; NONE; }); break; } case 6: { V _m_2283_a0_2310 = FLD(m_2283, 0); V _m_2283_a1_2311 = FLD(m_2283, 1); _r = ({ V p2234_2312 = _m_2283_a0_2310; ({ V p2235_2313 = _m_2283_a1_2311; NONE; }); }); break; } default: rt_panic("match: no case at kernel:2053"); } _r; }); });
}
V d_Rules_dformer_uview(V ops_855_2314, V ctx_856_2315, V view_857_2316, V message_858_2317, V ty_859_2318) {
  return ({ V _r = 0; V m_2319 = ap2(d_Get_dRules_dOps_do_uwhnf(ops_855_2314), ctx_856_2315, ty_859_2318); switch (tag_of(m_2319)) { case 1: { V _m_2319_a0_2320 = FLD(m_2319, 0); _r = ({ V item2247_2321 = _m_2319_a0_2320; ({ V local2238_2322 = item2247_2321; ({ V _r = 0; V m_2323 = ({ V local2242_2324 = ap(view_857_2316, local2238_2322); ({ V _r = 0; V m_2325 = local2242_2324; if (((m_2325) == NONE)) {  _r = ({ V __2326 = UNIT; FAIL(rt_ctor1(4, message_858_2317)); }); } else if (((m_2325) != NONE)) { V _m_2325_a0_2327 = FLD(m_2325, 0); _r = ({ V x_2328 = _m_2325_a0_2327; DONE(x_2328); }); } else rt_panic("match: no case at kernel:2056"); _r; }); }); switch (tag_of(m_2323)) { case 1: { V _m_2323_a0_2329 = FLD(m_2323, 0); _r = ({ V item2245_2330 = _m_2323_a0_2329; ({ V local2244_2331 = item2245_2330; DONE(rt_ctor2(0, local2238_2322, local2244_2331)); }); }); break; } case 0: { V _m_2323_a0_2332 = FLD(m_2323, 0); _r = ({ V item2246_2333 = _m_2323_a0_2332; FAIL(item2246_2333); }); break; } default: rt_panic("match: no case at kernel:2056"); } _r; }); }); }); break; } case 0: { V _m_2319_a0_2334 = FLD(m_2319, 0); _r = ({ V item2248_2335 = _m_2319_a0_2334; FAIL(item2248_2335); }); break; } default: rt_panic("match: no case at kernel:2056"); } _r; });
}
V d_Rules_dspi_uintro_uin(V ops_1062_2336, V ctx_1063_2337, V mode_1064_2338, V _s_1065_2339, V addr_1066_2340, V args_1067_2341, V expected_1068_2342) {
  return ({ V t_2343 = d_Rules_dformer_uview(ops_1062_2336, ctx_1063_2337, clo_new(w_Value_das_ulan, 1, 0), ((V)&S_34), expected_1068_2342); V _r; if (tag_of(t_2343) == 0) _r = t_2343; else { V bound2148_2344 = FLD(t_2343, 0); _r = ({ V _r = 0; V m_2345 = bound2148_2344; if ((tag_of(m_2345) == 0)) { V _m_2345_a0_2346 = FLD(m_2345, 0); V _m_2345_a1_2347 = FLD(m_2345, 1); _r = ({ V p2149_2348 = _m_2345_a0_2346; ({ V p2150_2349 = _m_2345_a1_2347; ({ V _r = 0; V m_2350 = p2150_2349; if ((tag_of(m_2350) == 0)) { V _m_2350_a0_2351 = FLD(m_2350, 0); V _m_2350_a1_2352 = FLD(m_2350, 1); V _m_2350_a2_2353 = FLD(m_2350, 2); _r = ({ V p2151_2354 = _m_2350_a0_2351; ({ V p2152_2355 = _m_2350_a1_2352; ({ V p2153_2356 = _m_2350_a2_2353; ({ V t_2357 = ({ V local2219_2358 = d_Rules_das_uvpi(p2151_2354); ({ V _r = 0; V m_2359 = local2219_2358; if (((m_2359) == NONE)) {  _r = ({ V __2360 = UNIT; FAIL(rt_ctor1(4, ((V)&S_35))); }); } else if (((m_2359) != NONE)) { V _m_2359_a0_2361 = FLD(m_2359, 0); _r = ({ V x_2362 = _m_2359_a0_2361; DONE(x_2362); }); } else rt_panic("match: no case at kernel:2062"); _r; }); }); V _r; if (tag_of(t_2357) == 0) _r = t_2357; else { V bound2155_2363 = FLD(t_2357, 0); _r = ({ V _r = 0; V m_2364 = bound2155_2363; if ((tag_of(m_2364) == 0)) { V _m_2364_a0_2365 = FLD(m_2364, 0); V _m_2364_a1_2366 = FLD(m_2364, 1); V _m_2364_a2_2367 = FLD(m_2364, 2); _r = ({ V p2156_2368 = _m_2364_a0_2365; ({ V p2157_2369 = _m_2364_a1_2366; ({ V p2158_2370 = _m_2364_a2_2367; ({ V t_2371 = ({ V local2215_2372 = d_Term_das_uapt(addr_1066_2340); ({ V _r = 0; V m_2373 = local2215_2372; if (((m_2373) == NONE)) {  _r = ({ V __2374 = UNIT; FAIL(rt_ctor1(7, ((V)&S_36))); }); } else if (((m_2373) != NONE)) { V _m_2373_a0_2375 = FLD(m_2373, 0); _r = ({ V x_2376 = _m_2373_a0_2375; DONE(x_2376); }); } else rt_panic("match: no case at kernel:2064"); _r; }); }); V _r; if (tag_of(t_2371) == 0) _r = t_2371; else { V bound2160_2377 = FLD(t_2371, 0); _r = ({ V _r = 0; V m_2378 = bound2160_2377; if ((tag_of(m_2378) == 0)) { V _m_2378_a0_2379 = FLD(m_2378, 0); V _m_2378_a1_2380 = FLD(m_2378, 1); _r = ({ V p2161_2381 = _m_2378_a0_2379; ({ V p2162_2382 = _m_2378_a1_2380; ({ V t_2383 = ({ V local2207_2384 = d_Rules_done_uof(args_1067_2341); ({ V _r = 0; V m_2385 = local2207_2384; if (((m_2385) == NONE)) {  _r = ({ V __2386 = UNIT; FAIL(rt_ctor1(4, ((V)&S_37))); }); } else if (((m_2385) != NONE)) { V _m_2385_a0_2387 = FLD(m_2385, 0); _r = ({ V x_2388 = _m_2385_a0_2387; DONE(x_2388); }); } else rt_panic("match: no case at kernel:2066"); _r; }); }); V _r; if (tag_of(t_2383) == 0) _r = t_2383; else { V bound2164_2389 = FLD(t_2383, 0); _r = ({ V t_2390 = apn(d_Get_dRules_dOps_do_ucheck(ops_1062_2336), 4, (V[]){ctx_1063_2337, d_Quantity_dmul(mode_1064_2338, p2156_2368), p2162_2382, p2158_2370}); V _r; if (tag_of(t_2390) == 0) _r = t_2390; else { V bound2166_2391 = FLD(t_2390, 0); _r = ({ V t_2392 = ap2(d_Get_dRules_dOps_do_ueval(ops_1062_2336), ctx_1063_2337, p2162_2382); V _r; if (tag_of(t_2392) == 0) _r = t_2392; else { V bound2168_2393 = FLD(t_2392, 0); _r = ({ V t_2394 = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(ops_1062_2336), ctx_1063_2337), p2152_2355, CON(bound2168_2393, NIL)); V _r; if (tag_of(t_2394) == 0) _r = t_2394; else { V bound2170_2395 = FLD(t_2394, 0); _r = ({ V t_2396 = apn(d_Get_dRules_dOps_do_ucheck(ops_1062_2336), 4, (V[]){ctx_1063_2337, mode_1064_2338, bound2164_2389, bound2170_2395}); V _r; if (tag_of(t_2396) == 0) _r = t_2396; else { V bound2172_2397 = FLD(t_2396, 0); _r = DONE(d_Quantity_dsequence(bound2166_2391, bound2172_2397)); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2065"); _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2063"); _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2061"); _r; }); }); }); } else rt_panic("match: no case at kernel:2061"); _r; }); } _r; });
}
V d_Value_dvar(V lvl_434_2398) {
  return rt_ctor2(6, rt_ctor1(0, lvl_434_2398), NIL);
}
V d_Quantity_dempty(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor2(0, SOME(d_Assoc_dempty()), d_Assoc_dempty()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Quantity_dscale_urange(V param_660_2399, V uses_655_2400) {
  return ({ V scrut2302_2401 = param_660_2399; ({ V _r = 0; V m_2402 = scrut2302_2401; if ((tag_of(m_2402) == 0)) { V _m_2402_a0_2403 = FLD(m_2402, 0); V _m_2402_a1_2404 = FLD(m_2402, 1); _r = ({ V p2303_2405 = _m_2402_a0_2403; ({ V p2304_2406 = _m_2402_a1_2404; ({ V scrut2313_2407 = ({ V _c = clo_new(lam_2417, 1, 2); CLO_ENV(_c)[0] = p2303_2405; CLO_ENV(_c)[1] = p2304_2406; _c; }); rt_ctor2(0, ({ V _r = 0; V m_2418 = d_Get_dQuantity_dUsage_dpaths(uses_655_2400); if (((m_2418) == NONE)) {  _r = ({ V __2419 = UNIT; NONE; }); } else if (((m_2418) != NONE)) { V _m_2418_a0_2420 = FLD(m_2418, 0); _r = ({ V item2315_2421 = _m_2418_a0_2420; SOME(ap(scrut2313_2407, item2315_2421)); }); } else rt_panic("match: no case at kernel:2083"); _r; }), ap(scrut2313_2407, d_Get_dQuantity_dUsage_dreads(uses_655_2400))); }); }); }); } else rt_panic("match: no case at kernel:2081"); _r; }); });
}
V d_Quantity_dscale(V q_663_2422, V uses_664_2423) {
  return ((d_Quantity_dequal(q_663_2422, ((V)0))) != FALSE_V ? d_Quantity_dempty() : d_Quantity_dscale_urange(rt_ctor2(0, q_663_2422, q_663_2422), uses_664_2423));
}
V d_Quantity_druntime(V q_309_2424) {
  return ((d_Quantity_dequal(q_309_2424, ((V)0))) != FALSE_V ? ((V)0) : ((V)1));
}
V d_Rules_delim_uresult(V ops_945_2425, V ctx_946_2426, V mo_947_2427, V expected_948_2428, V self_949_2429) {
  return ({ V local2318_2430 = mo_947_2427; ({ V _r = 0; V m_2431 = local2318_2430; if (((m_2431) == NONE)) {  _r = ({ V __2432 = UNIT; ({ V local2321_2433 = expected_948_2428; ({ V _r = 0; V m_2434 = local2321_2433; if (((m_2434) == NONE)) {  _r = ({ V __2435 = UNIT; FAIL(rt_ctor1(10, ((V)&S_38))); }); } else if (((m_2434) != NONE)) { V _m_2434_a0_2436 = FLD(m_2434, 0); _r = ({ V x_2437 = _m_2434_a0_2436; DONE(x_2437); }); } else rt_panic("match: no case at kernel:2092"); _r; }); }); }); } else if (((m_2431) != NONE)) { V _m_2431_a0_2438 = FLD(m_2431, 0); _r = ({ V value_2439 = _m_2431_a0_2438; ({ V local2323_2440 = value_2439; ap2(d_Get_dRules_dEvaluator_dev_ueval(ap(d_Get_dRules_dOps_do_uev(ops_945_2425), ctx_946_2426)), CON(self_949_2429, ap(d_Get_dRules_dOps_do_uenv(ops_945_2425), ctx_946_2426)), d_Get_dTerm_dMotive_dm_ubody(local2323_2440)); }); }); } else rt_panic("match: no case at kernel:2092"); _r; }); });
}
V d_Quantity_dto_ustring(V q_306_2441) {
  return ({ V scrut2325_2442 = q_306_2441; ({ V _r = 0; V m_2443 = scrut2325_2442; switch (tag_of(m_2443)) { case 0: {  _r = ({ V __2444 = UNIT; ((V)&S_1); }); break; } case 1: {  _r = ({ V __2445 = UNIT; ((V)&S_39); }); break; } case 2: {  _r = ({ V __2446 = UNIT; ((V)&S_40); }); break; } default: rt_panic("match: no case at kernel:2096"); } _r; }); });
}
V d_Rules_dbinder_uquantity(V subject_864_2447, V source_865_2448, V name_866_2449, V marked_867_2450, V declared_868_2451) {
  return ((d_Quantity_dequal(marked_867_2450, declared_868_2451)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(6, str_concat(CON(((V)&S_41), CON(subject_864_2447, CON(((V)&S_42), CON(name_866_2449, CON(((V)&S_43), CON(d_Quantity_dto_ustring(marked_867_2450), CON(((V)&S_44), CON(source_865_2448, CON(((V)&S_45), CON(d_Quantity_dto_ustring(declared_868_2451), NIL))))))))))))));
}
V d_Rules_dtwo_uof(V xs_632_2452) {
  return ({ V scrut2326_2453 = xs_632_2452; ({ V _r = 0; V m_2454 = scrut2326_2453; if (((m_2454) == NIL)) {  _r = ({ V __2455 = UNIT; NONE; }); } else if (((m_2454) != NIL)) { V _m_2454_a0_2456 = FLD(m_2454, 0); V _m_2454_a1_2457 = FLD(m_2454, 1); _r = ({ V p2327_2458 = _m_2454_a0_2456; ({ V p2328_2459 = _m_2454_a1_2457; ({ V _r = 0; V m_2460 = p2328_2459; if (((m_2460) == NIL)) {  _r = ({ V __2461 = UNIT; NONE; }); } else if (((m_2460) != NIL)) { V _m_2460_a0_2462 = FLD(m_2460, 0); V _m_2460_a1_2463 = FLD(m_2460, 1); _r = ({ V p2329_2464 = _m_2460_a0_2462; ({ V p2330_2465 = _m_2460_a1_2463; ({ V _r = 0; V m_2466 = p2330_2465; if (((m_2466) == NIL)) {  _r = ({ V __2467 = UNIT; SOME(rt_ctor2(0, p2327_2458, p2329_2464)); }); } else if (((m_2466) != NIL)) { V _m_2466_a0_2468 = FLD(m_2466, 0); V _m_2466_a1_2469 = FLD(m_2466, 1); _r = ({ V p2331_2470 = _m_2466_a0_2468; ({ V p2332_2471 = _m_2466_a1_2469; NONE; }); }); } else rt_panic("match: no case at kernel:2103"); _r; }); }); }); } else rt_panic("match: no case at kernel:2103"); _r; }); }); }); } else rt_panic("match: no case at kernel:2103"); _r; }); });
}
V d_Rules_dleg_umsg(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_46); rt_root(&memo); done = 1; }
  return memo;
}
V d_Term_das_ualeg(V a_421_2472) {
  return ({ V scrut2337_2473 = a_421_2472; ({ V _r = 0; V m_2474 = scrut2337_2473; switch (tag_of(m_2474)) { case 0: { V _m_2474_a0_2475 = FLD(m_2474, 0); V _m_2474_a1_2476 = FLD(m_2474, 1); _r = ({ V p2338_2477 = _m_2474_a0_2475; ({ V p2339_2478 = _m_2474_a1_2476; NONE; }); }); break; } case 1: { V _m_2474_a0_2479 = FLD(m_2474, 0); _r = ({ V p2340_2480 = _m_2474_a0_2479; SOME(p2340_2480); }); break; } case 2: { V _m_2474_a0_2481 = FLD(m_2474, 0); _r = ({ V p2341_2482 = _m_2474_a0_2481; NONE; }); break; } default: rt_panic("match: no case at kernel:2110"); } _r; }); });
}
V d_Rules_dcheck_umotive(V ops_953_2483, V ctx_954_2484, V mo_955_2485, V scrut_ty_956_2486) {
  return ({ V local2351_2487 = mo_955_2485; ({ V _r = 0; V m_2488 = local2351_2487; if (((m_2488) == NONE)) {  _r = ({ V __2489 = UNIT; DONE(UNIT); }); } else if (((m_2488) != NONE)) { V _m_2488_a0_2490 = FLD(m_2488, 0); _r = ({ V value_2491 = _m_2488_a0_2490; ({ V local2353_2492 = value_2491; ({ V scrut2354_2493 = apn(d_Get_dRules_dOps_do_ubind(ops_953_2483), 4, (V[]){d_Get_dTerm_dMotive_dm_uself(local2353_2492), ((V)0), scrut_ty_956_2486, ctx_954_2484}); ({ V _r = 0; V m_2494 = ap2(d_Get_dRules_dOps_do_uinfer_uuniv(ops_953_2483), scrut2354_2493, d_Get_dTerm_dMotive_dm_ubody(local2353_2492)); switch (tag_of(m_2494)) { case 1: { V _m_2494_a0_2495 = FLD(m_2494, 0); _r = ({ V item2357_2496 = _m_2494_a0_2495; DONE(({ V local2356_2497 = item2357_2496; UNIT; })); }); break; } case 0: { V _m_2494_a0_2498 = FLD(m_2494, 0); _r = ({ V item2358_2499 = _m_2494_a0_2498; FAIL(item2358_2499); }); break; } default: rt_panic("match: no case at kernel:2114"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2113"); _r; }); });
}
V d_Rules_dinfer_uscrutinee(V ops_907_2500, V ctx_908_2501, V mode_909_2502, V e_910_2503) {
  return ((((((d_Quantity_dequal(mode_909_2502, ((V)0))) ^ 1u)) != FALSE_V ? d_Quantity_dequal(d_Get_dTerm_dElim_de_uscrut_uq(e_910_2503), ((V)0)) : FALSE_V)) != FALSE_V ? FAIL(rt_ctor1(6, ((V)&S_47))) : ap3(d_Get_dRules_dOps_do_uinfer(ops_907_2500), ctx_908_2501, d_Quantity_dmul(mode_909_2502, d_Get_dTerm_dElim_de_uscrut_uq(e_910_2503)), d_Get_dTerm_dElim_de_uscrut(e_910_2503)));
}
V d_Rules_dspi_uelim_uelim(V ops_1114_2504, V ctx_1115_2505, V mode_1116_2506, V e_1117_2507, V expected_1118_2508) {
  return ({ V t_2509 = d_Rules_dinfer_uscrutinee(ops_1114_2504, ctx_1115_2505, mode_1116_2506, e_1117_2507); V _r; if (tag_of(t_2509) == 0) _r = t_2509; else { V bound2250_2510 = FLD(t_2509, 0); _r = ({ V _r = 0; V m_2511 = bound2250_2510; if ((tag_of(m_2511) == 0)) { V _m_2511_a0_2512 = FLD(m_2511, 0); V _m_2511_a1_2513 = FLD(m_2511, 1); _r = ({ V p2251_2514 = _m_2511_a0_2512; ({ V p2252_2515 = _m_2511_a1_2513; ({ V t_2516 = d_Rules_dformer_uview(ops_1114_2504, ctx_1115_2505, clo_new(w_Value_das_ulan, 1, 0), ((V)&S_48), p2251_2514); V _r; if (tag_of(t_2516) == 0) _r = t_2516; else { V bound2254_2517 = FLD(t_2516, 0); _r = ({ V _r = 0; V m_2518 = bound2254_2517; if ((tag_of(m_2518) == 0)) { V _m_2518_a0_2519 = FLD(m_2518, 0); V _m_2518_a1_2520 = FLD(m_2518, 1); _r = ({ V p2255_2521 = _m_2518_a0_2519; ({ V p2256_2522 = _m_2518_a1_2520; ({ V _r = 0; V m_2523 = p2256_2522; if ((tag_of(m_2523) == 0)) { V _m_2523_a0_2524 = FLD(m_2523, 0); V _m_2523_a1_2525 = FLD(m_2523, 1); V _m_2523_a2_2526 = FLD(m_2523, 2); _r = ({ V p2257_2527 = _m_2523_a0_2524; ({ V p2258_2528 = _m_2523_a1_2525; ({ V p2259_2529 = _m_2523_a2_2526; ({ V t_2530 = ({ V local2361_2531 = d_Rules_das_uvpi(p2257_2527); ({ V _r = 0; V m_2532 = local2361_2531; if (((m_2532) == NONE)) {  _r = ({ V __2533 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_2532) != NONE)) { V _m_2532_a0_2534 = FLD(m_2532, 0); _r = ({ V x_2535 = _m_2532_a0_2534; DONE(x_2535); }); } else rt_panic("match: no case at kernel:2125"); _r; }); }); V _r; if (tag_of(t_2530) == 0) _r = t_2530; else { V bound2261_2536 = FLD(t_2530, 0); _r = ({ V _r = 0; V m_2537 = bound2261_2536; if ((tag_of(m_2537) == 0)) { V _m_2537_a0_2538 = FLD(m_2537, 0); V _m_2537_a1_2539 = FLD(m_2537, 1); V _m_2537_a2_2540 = FLD(m_2537, 2); _r = ({ V p2262_2541 = _m_2537_a0_2538; ({ V p2263_2542 = _m_2537_a1_2539; ({ V p2264_2543 = _m_2537_a2_2540; ({ V t_2544 = d_Rules_dcheck_umotive(ops_1114_2504, ctx_1115_2505, d_Get_dTerm_dElim_de_umotive(e_1117_2507), p2255_2521); V _r; if (tag_of(t_2544) == 0) _r = t_2544; else { V bound2266_2545 = FLD(t_2544, 0); _r = ({ V t_2546 = ap2(d_Get_dRules_dOps_do_ueval(ops_1114_2504), ctx_1115_2505, d_Get_dTerm_dElim_de_uscrut(e_1117_2507)); V _r; if (tag_of(t_2546) == 0) _r = t_2546; else { V bound2268_2547 = FLD(t_2546, 0); _r = ({ V t_2548 = d_Rules_delim_uresult(ops_1114_2504, ctx_1115_2505, d_Get_dTerm_dElim_de_umotive(e_1117_2507), expected_1118_2508, bound2268_2547); V _r; if (tag_of(t_2548) == 0) _r = t_2548; else { V bound2270_2549 = FLD(t_2548, 0); _r = ({ V t_2550 = ({ V local2347_2551 = d_Rules_done_uof(d_Get_dTerm_dElim_de_ubranches(e_1117_2507)); ({ V _r = 0; V m_2552 = local2347_2551; if (((m_2552) == NONE)) {  _r = ({ V __2553 = UNIT; FAIL(rt_ctor1(8, ((V)&S_49))); }); } else if (((m_2552) != NONE)) { V _m_2552_a0_2554 = FLD(m_2552, 0); _r = ({ V x_2555 = _m_2552_a0_2554; DONE(x_2555); }); } else rt_panic("match: no case at kernel:2131"); _r; }); }); V _r; if (tag_of(t_2550) == 0) _r = t_2550; else { V bound2272_2556 = FLD(t_2550, 0); _r = ({ V _r = 0; V m_2557 = bound2272_2556; if ((tag_of(m_2557) == 0)) { V _m_2557_a0_2558 = FLD(m_2557, 0); V _m_2557_a1_2559 = FLD(m_2557, 1); _r = ({ V p2273_2560 = _m_2557_a0_2558; ({ V p2274_2561 = _m_2557_a1_2559; ({ V t_2562 = ({ V local2344_2563 = d_Term_das_ualeg(p2273_2560); ({ V _r = 0; V m_2564 = local2344_2563; if (((m_2564) == NONE)) {  _r = ({ V __2565 = UNIT; FAIL(rt_ctor1(7, ((V)&S_50))); }); } else if (((m_2564) != NONE)) { V _m_2564_a0_2566 = FLD(m_2564, 0); _r = ({ V x_2567 = _m_2564_a0_2566; DONE(x_2567); }); } else rt_panic("match: no case at kernel:2133"); _r; }); }); V _r; if (tag_of(t_2562) == 0) _r = t_2562; else { V bound2276_2568 = FLD(t_2562, 0); _r = ({ V t_2569 = ((d_Big_dis_ueq(bound2276_2568, d_Big_dzero())) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(7, d_Rules_dleg_umsg()))); V _r; if (tag_of(t_2569) == 0) _r = t_2569; else { V bound2278_2570 = FLD(t_2569, 0); _r = ({ V t_2571 = ({ V local2335_2572 = d_Rules_dtwo_uof(d_Get_dTerm_dLeg_dl_ubinders(p2274_2561)); ({ V _r = 0; V m_2573 = local2335_2572; if (((m_2573) == NONE)) {  _r = ({ V __2574 = UNIT; FAIL(rt_ctor1(8, ((V)&S_51))); }); } else if (((m_2573) != NONE)) { V _m_2573_a0_2575 = FLD(m_2573, 0); _r = ({ V x_2576 = _m_2573_a0_2575; DONE(x_2576); }); } else rt_panic("match: no case at kernel:2136"); _r; }); }); V _r; if (tag_of(t_2571) == 0) _r = t_2571; else { V bound2280_2577 = FLD(t_2571, 0); _r = ({ V _r = 0; V m_2578 = bound2280_2577; if ((tag_of(m_2578) == 0)) { V _m_2578_a0_2579 = FLD(m_2578, 0); V _m_2578_a1_2580 = FLD(m_2578, 1); _r = ({ V p2281_2581 = _m_2578_a0_2579; ({ V p2282_2582 = _m_2578_a1_2580; ({ V _r = 0; V m_2583 = p2281_2581; if ((tag_of(m_2583) == 0)) { V _m_2583_a0_2584 = FLD(m_2583, 0); V _m_2583_a1_2585 = FLD(m_2583, 1); _r = ({ V p2283_2586 = _m_2583_a0_2584; ({ V p2284_2587 = _m_2583_a1_2585; ({ V _r = 0; V m_2588 = p2282_2582; if ((tag_of(m_2588) == 0)) { V _m_2588_a0_2589 = FLD(m_2588, 0); V _m_2588_a1_2590 = FLD(m_2588, 1); _r = ({ V p2285_2591 = _m_2588_a0_2589; ({ V p2286_2592 = _m_2588_a1_2590; ({ V t_2593 = d_Rules_dbinder_uquantity(((V)&S_52), ((V)&S_53), p2284_2587, p2283_2586, p2262_2541); V _r; if (tag_of(t_2593) == 0) _r = t_2593; else { V bound2288_2594 = FLD(t_2593, 0); _r = ({ V scrut2289_2595 = ap(d_Get_dRules_dOps_do_usize(ops_1114_2504), ctx_1115_2505); ({ V scrut2290_2596 = d_Value_dvar(scrut2289_2595); ({ V scrut2291_2597 = d_Value_dvar(d_NativeInt_dadd(scrut2289_2595, d_Big_done())); ({ V t_2598 = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(ops_1114_2504), ctx_1115_2505), p2258_2528, CON(scrut2290_2596, NIL)); V _r; if (tag_of(t_2598) == 0) _r = t_2598; else { V bound2293_2599 = FLD(t_2598, 0); _r = ({ V scrut2294_2600 = apn(d_Get_dRules_dOps_do_ubind(ops_1114_2504), 4, (V[]){p2286_2592, p2285_2591, bound2293_2599, apn(d_Get_dRules_dOps_do_ubind(ops_1114_2504), 4, (V[]){p2284_2587, p2283_2586, p2264_2543, ctx_1115_2505})}); ({ V scrut2295_2601 = rt_ctor3(3, p2257_2527, rt_ctor2(0, p2262_2541, scrut2290_2596), CON(scrut2291_2597, NIL)); ({ V t_2602 = d_Rules_delim_uresult(ops_1114_2504, ctx_1115_2505, d_Get_dTerm_dElim_de_umotive(e_1117_2507), expected_1118_2508, scrut2295_2601); V _r; if (tag_of(t_2602) == 0) _r = t_2602; else { V bound2297_2603 = FLD(t_2602, 0); _r = ({ V t_2604 = apn(d_Get_dRules_dOps_do_ucheck(ops_1114_2504), 4, (V[]){scrut2294_2600, d_Quantity_druntime(mode_1116_2506), d_Get_dTerm_dLeg_dl_ubody(p2274_2561), bound2297_2603}); V _r; if (tag_of(t_2604) == 0) _r = t_2604; else { V bound2299_2605 = FLD(t_2604, 0); _r = ({ V t_2606 = apn(d_Get_dRules_dOps_do_uclose(ops_1114_2504), 4, (V[]){scrut2294_2600, ap(d_Get_dRules_dOps_do_usize(ops_1114_2504), ctx_1115_2505), mode_1116_2506, bound2299_2605}); V _r; if (tag_of(t_2606) == 0) _r = t_2606; else { V bound2301_2607 = FLD(t_2606, 0); _r = DONE(rt_ctor2(0, bound2270_2549, d_Quantity_dsequence(p2252_2515, d_Quantity_dscale(mode_1116_2506, bound2301_2607)))); } _r; }); } _r; }); } _r; }); }); }); } _r; }); }); }); }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2137"); _r; }); }); }); } else rt_panic("match: no case at kernel:2137"); _r; }); }); }); } else rt_panic("match: no case at kernel:2137"); _r; }); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2132"); _r; }); } _r; }); } _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2126"); _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2124"); _r; }); }); }); } else rt_panic("match: no case at kernel:2124"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2122"); _r; }); } _r; });
}
V d_Quantity_drank(V q_316_2608) {
  return ({ V scrut2397_2609 = q_316_2608; ({ V _r = 0; V m_2610 = scrut2397_2609; switch (tag_of(m_2610)) { case 0: {  _r = ({ V __2611 = UNIT; d_Big_dzero(); }); break; } case 1: {  _r = ({ V __2612 = UNIT; d_Big_done(); }); break; } case 2: {  _r = ({ V __2613 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } default: rt_panic("match: no case at kernel:2154"); } _r; }); });
}
V d_Quantity_dmaximum(V a_323_2614, V b_324_2615) {
  return ((d_Big_dis_ule(d_Quantity_drank(b_324_2615), d_Quantity_drank(a_323_2614))) != FALSE_V ? a_323_2614 : b_324_2615);
}
V d_Quantity_dcaptures(V uses_695_2616) {
  return ({ V scrut2398_2617 = ({ V _r = 0; V m_2618 = d_Get_dQuantity_dUsage_dpaths(uses_695_2616); if (((m_2618) == NONE)) {  _r = ({ V __2619 = UNIT; d_Get_dQuantity_dUsage_dreads(uses_695_2616); }); } else if (((m_2618) != NONE)) { V _m_2618_a0_2620 = FLD(m_2618, 0); _r = ({ V value_2621 = _m_2618_a0_2620; ({ V local2392_2622 = value_2621; d_Quantity_dcombine(clo_new(lam_2625, 2, 0), clo_new(w_Quantity_dmaximum, 2, 0), local2392_2622, d_Get_dQuantity_dUsage_dreads(uses_695_2616)); }); }); } else rt_panic("match: no case at kernel:2160"); _r; }); rt_ctor2(0, SOME(scrut2398_2617), d_Get_dQuantity_dUsage_dreads(uses_695_2616)); });
}
V d_Value_das_uran(V v_451_2626) {
  return ({ V scrut2410_2627 = v_451_2626; ({ V _r = 0; V m_2628 = scrut2410_2627; switch (tag_of(m_2628)) { case 0: { V _m_2628_a0_2629 = FLD(m_2628, 0); _r = ({ V p2411_2630 = _m_2628_a0_2629; NONE; }); break; } case 1: { V _m_2628_a0_2631 = FLD(m_2628, 0); V _m_2628_a1_2632 = FLD(m_2628, 1); V _m_2628_a2_2633 = FLD(m_2628, 2); _r = ({ V p2412_2634 = _m_2628_a0_2631; ({ V p2413_2635 = _m_2628_a1_2632; ({ V p2414_2636 = _m_2628_a2_2633; NONE; }); }); }); break; } case 2: { V _m_2628_a0_2637 = FLD(m_2628, 0); V _m_2628_a1_2638 = FLD(m_2628, 1); V _m_2628_a2_2639 = FLD(m_2628, 2); _r = ({ V p2415_2640 = _m_2628_a0_2637; ({ V p2416_2641 = _m_2628_a1_2638; ({ V p2417_2642 = _m_2628_a2_2639; SOME(rt_ctor3(0, p2415_2640, p2416_2641, p2417_2642)); }); }); }); break; } case 3: { V _m_2628_a0_2643 = FLD(m_2628, 0); V _m_2628_a1_2644 = FLD(m_2628, 1); V _m_2628_a2_2645 = FLD(m_2628, 2); _r = ({ V p2418_2646 = _m_2628_a0_2643; ({ V p2419_2647 = _m_2628_a1_2644; ({ V p2420_2648 = _m_2628_a2_2645; NONE; }); }); }); break; } case 4: { V _m_2628_a0_2649 = FLD(m_2628, 0); V _m_2628_a1_2650 = FLD(m_2628, 1); _r = ({ V p2421_2651 = _m_2628_a0_2649; ({ V p2422_2652 = _m_2628_a1_2650; NONE; }); }); break; } case 5: { V _m_2628_a0_2653 = FLD(m_2628, 0); _r = ({ V p2423_2654 = _m_2628_a0_2653; NONE; }); break; } case 6: { V _m_2628_a0_2655 = FLD(m_2628, 0); V _m_2628_a1_2656 = FLD(m_2628, 1); _r = ({ V p2424_2657 = _m_2628_a0_2655; ({ V p2425_2658 = _m_2628_a1_2656; NONE; }); }); break; } default: rt_panic("match: no case at kernel:2165"); } _r; }); });
}
V d_Rules_dspi_uintro_usec(V ops_1035_2659, V ctx_1036_2660, V mode_1037_2661, V _s_1038_2662, V legs_1039_2663, V expected_1040_2664) {
  return ({ V t_2665 = d_Rules_dformer_uview(ops_1035_2659, ctx_1036_2660, clo_new(w_Value_das_uran, 1, 0), ((V)&S_54), expected_1040_2664); V _r; if (tag_of(t_2665) == 0) _r = t_2665; else { V bound2364_2666 = FLD(t_2665, 0); _r = ({ V _r = 0; V m_2667 = bound2364_2666; if ((tag_of(m_2667) == 0)) { V _m_2667_a0_2668 = FLD(m_2667, 0); V _m_2667_a1_2669 = FLD(m_2667, 1); _r = ({ V p2365_2670 = _m_2667_a0_2668; ({ V p2366_2671 = _m_2667_a1_2669; ({ V _r = 0; V m_2672 = p2366_2671; if ((tag_of(m_2672) == 0)) { V _m_2672_a0_2673 = FLD(m_2672, 0); V _m_2672_a1_2674 = FLD(m_2672, 1); V _m_2672_a2_2675 = FLD(m_2672, 2); _r = ({ V p2367_2676 = _m_2672_a0_2673; ({ V p2368_2677 = _m_2672_a1_2674; ({ V p2369_2678 = _m_2672_a2_2675; ({ V t_2679 = ({ V local2409_2680 = d_Rules_das_uvpi(p2367_2676); ({ V _r = 0; V m_2681 = local2409_2680; if (((m_2681) == NONE)) {  _r = ({ V __2682 = UNIT; FAIL(rt_ctor1(4, ((V)&S_55))); }); } else if (((m_2681) != NONE)) { V _m_2681_a0_2683 = FLD(m_2681, 0); _r = ({ V x_2684 = _m_2681_a0_2683; DONE(x_2684); }); } else rt_panic("match: no case at kernel:2171"); _r; }); }); V _r; if (tag_of(t_2679) == 0) _r = t_2679; else { V bound2371_2685 = FLD(t_2679, 0); _r = ({ V _r = 0; V m_2686 = bound2371_2685; if ((tag_of(m_2686) == 0)) { V _m_2686_a0_2687 = FLD(m_2686, 0); V _m_2686_a1_2688 = FLD(m_2686, 1); V _m_2686_a2_2689 = FLD(m_2686, 2); _r = ({ V p2372_2690 = _m_2686_a0_2687; ({ V p2373_2691 = _m_2686_a1_2688; ({ V p2374_2692 = _m_2686_a2_2689; ({ V t_2693 = ({ V local2405_2694 = d_Rules_done_uof(legs_1039_2663); ({ V _r = 0; V m_2695 = local2405_2694; if (((m_2695) == NONE)) {  _r = ({ V __2696 = UNIT; FAIL(rt_ctor1(4, ((V)&S_56))); }); } else if (((m_2695) != NONE)) { V _m_2695_a0_2697 = FLD(m_2695, 0); _r = ({ V x_2698 = _m_2695_a0_2697; DONE(x_2698); }); } else rt_panic("match: no case at kernel:2173"); _r; }); }); V _r; if (tag_of(t_2693) == 0) _r = t_2693; else { V bound2376_2699 = FLD(t_2693, 0); _r = ({ V t_2700 = ({ V local2402_2701 = d_Rules_done_uof(d_Get_dTerm_dLeg_dl_ubinders(bound2376_2699)); ({ V _r = 0; V m_2702 = local2402_2701; if (((m_2702) == NONE)) {  _r = ({ V __2703 = UNIT; FAIL(rt_ctor1(4, ((V)&S_57))); }); } else if (((m_2702) != NONE)) { V _m_2702_a0_2704 = FLD(m_2702, 0); _r = ({ V x_2705 = _m_2702_a0_2704; DONE(x_2705); }); } else rt_panic("match: no case at kernel:2174"); _r; }); }); V _r; if (tag_of(t_2700) == 0) _r = t_2700; else { V bound2378_2706 = FLD(t_2700, 0); _r = ({ V _r = 0; V m_2707 = bound2378_2706; if ((tag_of(m_2707) == 0)) { V _m_2707_a0_2708 = FLD(m_2707, 0); V _m_2707_a1_2709 = FLD(m_2707, 1); _r = ({ V p2379_2710 = _m_2707_a0_2708; ({ V p2380_2711 = _m_2707_a1_2709; ({ V t_2712 = d_Rules_dbinder_uquantity(((V)&S_58), ((V)&S_53), p2380_2711, p2379_2710, p2372_2690); V _r; if (tag_of(t_2712) == 0) _r = t_2712; else { V bound2382_2713 = FLD(t_2712, 0); _r = ({ V scrut2383_2714 = d_Value_dvar(ap(d_Get_dRules_dOps_do_usize(ops_1035_2659), ctx_1036_2660)); ({ V t_2715 = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(ops_1035_2659), ctx_1036_2660), p2368_2677, CON(scrut2383_2714, NIL)); V _r; if (tag_of(t_2715) == 0) _r = t_2715; else { V bound2385_2716 = FLD(t_2715, 0); _r = ({ V scrut2386_2717 = apn(d_Get_dRules_dOps_do_ubind(ops_1035_2659), 4, (V[]){p2380_2711, p2372_2690, p2374_2692, ctx_1036_2660}); ({ V t_2718 = apn(d_Get_dRules_dOps_do_ucheck(ops_1035_2659), 4, (V[]){scrut2386_2717, d_Quantity_druntime(mode_1037_2661), d_Get_dTerm_dLeg_dl_ubody(bound2376_2699), bound2385_2716}); V _r; if (tag_of(t_2718) == 0) _r = t_2718; else { V bound2388_2719 = FLD(t_2718, 0); _r = ({ V t_2720 = apn(d_Get_dRules_dOps_do_uclose(ops_1035_2659), 4, (V[]){scrut2386_2717, ap(d_Get_dRules_dOps_do_usize(ops_1035_2659), ctx_1036_2660), mode_1037_2661, bound2388_2719}); V _r; if (tag_of(t_2720) == 0) _r = t_2720; else { V bound2390_2721 = FLD(t_2720, 0); _r = DONE(d_Quantity_dscale(mode_1037_2661, d_Quantity_dcaptures(bound2390_2721))); } _r; }); } _r; }); }); } _r; }); }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2175"); _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2172"); _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2170"); _r; }); }); }); } else rt_panic("match: no case at kernel:2170"); _r; }); } _r; });
}
V d_Rules_dspi_uelim_uout(V ops_1088_2722, V ctx_1089_2723, V mode_1090_2724, V _s_1091_2725, V addr_1092_2726, V head_1093_2727) {
  return ({ V t_2728 = ({ V local2459_2729 = d_Term_das_uapt(addr_1092_2726); ({ V _r = 0; V m_2730 = local2459_2729; if (((m_2730) == NONE)) {  _r = ({ V __2731 = UNIT; FAIL(rt_ctor1(7, ((V)&S_59))); }); } else if (((m_2730) != NONE)) { V _m_2730_a0_2732 = FLD(m_2730, 0); _r = ({ V x_2733 = _m_2730_a0_2732; DONE(x_2733); }); } else rt_panic("match: no case at kernel:2188"); _r; }); }); V _r; if (tag_of(t_2728) == 0) _r = t_2728; else { V bound2427_2734 = FLD(t_2728, 0); _r = ({ V _r = 0; V m_2735 = bound2427_2734; if ((tag_of(m_2735) == 0)) { V _m_2735_a0_2736 = FLD(m_2735, 0); V _m_2735_a1_2737 = FLD(m_2735, 1); _r = ({ V p2428_2738 = _m_2735_a0_2736; ({ V p2429_2739 = _m_2735_a1_2737; ({ V t_2740 = ap3(d_Get_dRules_dOps_do_uinfer(ops_1088_2722), ctx_1089_2723, mode_1090_2724, head_1093_2727); V _r; if (tag_of(t_2740) == 0) _r = t_2740; else { V bound2431_2741 = FLD(t_2740, 0); _r = ({ V _r = 0; V m_2742 = bound2431_2741; if ((tag_of(m_2742) == 0)) { V _m_2742_a0_2743 = FLD(m_2742, 0); V _m_2742_a1_2744 = FLD(m_2742, 1); _r = ({ V p2432_2745 = _m_2742_a0_2743; ({ V p2433_2746 = _m_2742_a1_2744; ({ V t_2747 = d_Rules_dformer_uview(ops_1088_2722, ctx_1089_2723, clo_new(w_Value_das_uran, 1, 0), ((V)&S_60), p2432_2745); V _r; if (tag_of(t_2747) == 0) _r = t_2747; else { V bound2435_2748 = FLD(t_2747, 0); _r = ({ V _r = 0; V m_2749 = bound2435_2748; if ((tag_of(m_2749) == 0)) { V _m_2749_a0_2750 = FLD(m_2749, 0); V _m_2749_a1_2751 = FLD(m_2749, 1); _r = ({ V p2436_2752 = _m_2749_a0_2750; ({ V p2437_2753 = _m_2749_a1_2751; ({ V _r = 0; V m_2754 = p2437_2753; if ((tag_of(m_2754) == 0)) { V _m_2754_a0_2755 = FLD(m_2754, 0); V _m_2754_a1_2756 = FLD(m_2754, 1); V _m_2754_a2_2757 = FLD(m_2754, 2); _r = ({ V p2438_2758 = _m_2754_a0_2755; ({ V p2439_2759 = _m_2754_a1_2756; ({ V p2440_2760 = _m_2754_a2_2757; ({ V t_2761 = ({ V local2454_2762 = d_Rules_das_uvpi(p2438_2758); ({ V _r = 0; V m_2763 = local2454_2762; if (((m_2763) == NONE)) {  _r = ({ V __2764 = UNIT; FAIL(rt_ctor1(4, ((V)&S_60))); }); } else if (((m_2763) != NONE)) { V _m_2763_a0_2765 = FLD(m_2763, 0); _r = ({ V x_2766 = _m_2763_a0_2765; DONE(x_2766); }); } else rt_panic("match: no case at kernel:2194"); _r; }); }); V _r; if (tag_of(t_2761) == 0) _r = t_2761; else { V bound2442_2767 = FLD(t_2761, 0); _r = ({ V _r = 0; V m_2768 = bound2442_2767; if ((tag_of(m_2768) == 0)) { V _m_2768_a0_2769 = FLD(m_2768, 0); V _m_2768_a1_2770 = FLD(m_2768, 1); V _m_2768_a2_2771 = FLD(m_2768, 2); _r = ({ V p2443_2772 = _m_2768_a0_2769; ({ V p2444_2773 = _m_2768_a1_2770; ({ V p2445_2774 = _m_2768_a2_2771; ({ V t_2775 = apn(d_Get_dRules_dOps_do_ucheck(ops_1088_2722), 4, (V[]){ctx_1089_2723, d_Quantity_dmul(mode_1090_2724, p2443_2772), p2429_2739, p2445_2774}); V _r; if (tag_of(t_2775) == 0) _r = t_2775; else { V bound2447_2776 = FLD(t_2775, 0); _r = ({ V t_2777 = ap2(d_Get_dRules_dOps_do_ueval(ops_1088_2722), ctx_1089_2723, p2429_2739); V _r; if (tag_of(t_2777) == 0) _r = t_2777; else { V bound2449_2778 = FLD(t_2777, 0); _r = ({ V t_2779 = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(ops_1088_2722), ctx_1089_2723), p2439_2759, CON(bound2449_2778, NIL)); V _r; if (tag_of(t_2779) == 0) _r = t_2779; else { V bound2451_2780 = FLD(t_2779, 0); _r = DONE(rt_ctor2(0, bound2451_2780, d_Quantity_dsequence(p2433_2746, bound2447_2776))); } _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2195"); _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2193"); _r; }); }); }); } else rt_panic("match: no case at kernel:2193"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2191"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2189"); _r; }); } _r; });
}
V d_Value_das_upt(V a_477_2781) {
  return ({ V scrut2465_2782 = a_477_2781; ({ V _r = 0; V m_2783 = scrut2465_2782; switch (tag_of(m_2783)) { case 0: { V _m_2783_a0_2784 = FLD(m_2783, 0); V _m_2783_a1_2785 = FLD(m_2783, 1); _r = ({ V p2466_2786 = _m_2783_a0_2784; ({ V p2467_2787 = _m_2783_a1_2785; SOME(rt_ctor2(0, p2466_2786, p2467_2787)); }); }); break; } case 1: { V _m_2783_a0_2788 = FLD(m_2783, 0); _r = ({ V p2468_2789 = _m_2783_a0_2788; NONE; }); break; } case 2: { V _m_2783_a0_2790 = FLD(m_2783, 0); _r = ({ V p2469_2791 = _m_2783_a0_2790; NONE; }); break; } default: rt_panic("match: no case at kernel:2203"); } _r; }); });
}
V d_Value_das_usec(V v_463_2792) {
  return ({ V scrut2476_2793 = v_463_2792; ({ V _r = 0; V m_2794 = scrut2476_2793; switch (tag_of(m_2794)) { case 0: { V _m_2794_a0_2795 = FLD(m_2794, 0); _r = ({ V p2477_2796 = _m_2794_a0_2795; NONE; }); break; } case 1: { V _m_2794_a0_2797 = FLD(m_2794, 0); V _m_2794_a1_2798 = FLD(m_2794, 1); V _m_2794_a2_2799 = FLD(m_2794, 2); _r = ({ V p2478_2800 = _m_2794_a0_2797; ({ V p2479_2801 = _m_2794_a1_2798; ({ V p2480_2802 = _m_2794_a2_2799; NONE; }); }); }); break; } case 2: { V _m_2794_a0_2803 = FLD(m_2794, 0); V _m_2794_a1_2804 = FLD(m_2794, 1); V _m_2794_a2_2805 = FLD(m_2794, 2); _r = ({ V p2481_2806 = _m_2794_a0_2803; ({ V p2482_2807 = _m_2794_a1_2804; ({ V p2483_2808 = _m_2794_a2_2805; NONE; }); }); }); break; } case 3: { V _m_2794_a0_2809 = FLD(m_2794, 0); V _m_2794_a1_2810 = FLD(m_2794, 1); V _m_2794_a2_2811 = FLD(m_2794, 2); _r = ({ V p2484_2812 = _m_2794_a0_2809; ({ V p2485_2813 = _m_2794_a1_2810; ({ V p2486_2814 = _m_2794_a2_2811; NONE; }); }); }); break; } case 4: { V _m_2794_a0_2815 = FLD(m_2794, 0); V _m_2794_a1_2816 = FLD(m_2794, 1); _r = ({ V p2487_2817 = _m_2794_a0_2815; ({ V p2488_2818 = _m_2794_a1_2816; SOME(rt_ctor2(0, p2487_2817, p2488_2818)); }); }); break; } case 5: { V _m_2794_a0_2819 = FLD(m_2794, 0); _r = ({ V p2489_2820 = _m_2794_a0_2819; NONE; }); break; } case 6: { V _m_2794_a0_2821 = FLD(m_2794, 0); V _m_2794_a1_2822 = FLD(m_2794, 1); _r = ({ V p2490_2823 = _m_2794_a0_2821; ({ V p2491_2824 = _m_2794_a1_2822; NONE; }); }); break; } default: rt_panic("match: no case at kernel:2207"); } _r; }); });
}
V d_Rules_dlet_u(V o_913_2825, V f_914_2826) {
  return ({ V _r = 0; V m_2827 = o_913_2825; if (((m_2827) == NONE)) {  _r = ({ V __2828 = UNIT; DONE(NONE); }); } else if (((m_2827) != NONE)) { V _m_2827_a0_2829 = FLD(m_2827, 0); _r = ({ V value_2830 = _m_2827_a0_2829; ap(f_914_2826, value_2830); }); } else rt_panic("match: no case at kernel:2210"); _r; });
}
V d_Value_das_uin(V v_457_2831) {
  return ({ V scrut2510_2832 = v_457_2831; ({ V _r = 0; V m_2833 = scrut2510_2832; switch (tag_of(m_2833)) { case 0: { V _m_2833_a0_2834 = FLD(m_2833, 0); _r = ({ V p2511_2835 = _m_2833_a0_2834; NONE; }); break; } case 1: { V _m_2833_a0_2836 = FLD(m_2833, 0); V _m_2833_a1_2837 = FLD(m_2833, 1); V _m_2833_a2_2838 = FLD(m_2833, 2); _r = ({ V p2512_2839 = _m_2833_a0_2836; ({ V p2513_2840 = _m_2833_a1_2837; ({ V p2514_2841 = _m_2833_a2_2838; NONE; }); }); }); break; } case 2: { V _m_2833_a0_2842 = FLD(m_2833, 0); V _m_2833_a1_2843 = FLD(m_2833, 1); V _m_2833_a2_2844 = FLD(m_2833, 2); _r = ({ V p2515_2845 = _m_2833_a0_2842; ({ V p2516_2846 = _m_2833_a1_2843; ({ V p2517_2847 = _m_2833_a2_2844; NONE; }); }); }); break; } case 3: { V _m_2833_a0_2848 = FLD(m_2833, 0); V _m_2833_a1_2849 = FLD(m_2833, 1); V _m_2833_a2_2850 = FLD(m_2833, 2); _r = ({ V p2518_2851 = _m_2833_a0_2848; ({ V p2519_2852 = _m_2833_a1_2849; ({ V p2520_2853 = _m_2833_a2_2850; SOME(rt_ctor3(0, p2518_2851, p2519_2852, p2520_2853)); }); }); }); break; } case 4: { V _m_2833_a0_2854 = FLD(m_2833, 0); V _m_2833_a1_2855 = FLD(m_2833, 1); _r = ({ V p2521_2856 = _m_2833_a0_2854; ({ V p2522_2857 = _m_2833_a1_2855; NONE; }); }); break; } case 5: { V _m_2833_a0_2858 = FLD(m_2833, 0); _r = ({ V p2523_2859 = _m_2833_a0_2858; NONE; }); break; } case 6: { V _m_2833_a0_2860 = FLD(m_2833, 0); V _m_2833_a1_2861 = FLD(m_2833, 1); _r = ({ V p2524_2862 = _m_2833_a0_2860; ({ V p2525_2863 = _m_2833_a1_2861; NONE; }); }); break; } default: rt_panic("match: no case at kernel:2214"); } _r; }); });
}
V d_Rules_dspi_ubeta(V ev_1006_2864, V r_1007_2865) {
  return ({ V scrut2460_2866 = r_1007_2865; ({ V _r = 0; V m_2867 = scrut2460_2866; switch (tag_of(m_2867)) { case 0: { V _m_2867_a0_2868 = FLD(m_2867, 0); V _m_2867_a1_2869 = FLD(m_2867, 1); V _m_2867_a2_2870 = FLD(m_2867, 2); _r = ({ V p2461_2871 = _m_2867_a0_2868; ({ V p2462_2872 = _m_2867_a1_2869; ({ V p2463_2873 = _m_2867_a2_2870; d_Rules_dlet_u(d_Value_das_upt(p2462_2872), ({ V _c = clo_new(lam_2897, 1, 2); CLO_ENV(_c)[0] = p2463_2873; CLO_ENV(_c)[1] = ev_1006_2864; _c; })); }); }); }); break; } case 1: { V _m_2867_a0_2898 = FLD(m_2867, 0); V _m_2867_a1_2899 = FLD(m_2867, 1); V _m_2867_a2_2900 = FLD(m_2867, 2); V _m_2867_a3_2901 = FLD(m_2867, 3); _r = ({ V p2505_2902 = _m_2867_a0_2898; ({ V p2506_2903 = _m_2867_a1_2899; ({ V p2507_2904 = _m_2867_a2_2900; ({ V p2508_2905 = _m_2867_a3_2901; d_Rules_dlet_u(d_Value_das_uin(p2508_2905), ({ V _c = clo_new(lam_2939, 1, 3); CLO_ENV(_c)[0] = p2506_2903; CLO_ENV(_c)[1] = ev_1006_2864; CLO_ENV(_c)[2] = p2507_2904; _c; })); }); }); }); }); break; } default: rt_panic("match: no case at kernel:2218"); } _r; }); });
}
V d_Rules_dspi_udiagram_uarity(V _s_1244_2940) {
  return d_Big_done();
}
V d_Rules_dspi_uspine_uty(V ops_1229_2941, V ctx_1230_2942, V s_1231_2943, V dclo_1232_2944, V addr_1233_2945) {
  return ({ V local2555_2946 = d_Rules_das_uvpi(s_1231_2943); ({ V _r = 0; V m_2947 = local2555_2946; if (((m_2947) == NONE)) {  _r = ({ V __2948 = UNIT; DONE(NONE); }); } else if (((m_2947) != NONE)) { V _m_2947_a0_2949 = FLD(m_2947, 0); _r = ({ V value_2950 = _m_2947_a0_2949; ({ V local2557_2951 = value_2950; ({ V scrut2558_2952 = local2557_2951; ({ V _r = 0; V m_2953 = scrut2558_2952; if ((tag_of(m_2953) == 0)) { V _m_2953_a0_2954 = FLD(m_2953, 0); V _m_2953_a1_2955 = FLD(m_2953, 1); V _m_2953_a2_2956 = FLD(m_2953, 2); _r = ({ V p2559_2957 = _m_2953_a0_2954; ({ V p2560_2958 = _m_2953_a1_2955; ({ V p2561_2959 = _m_2953_a2_2956; ({ V local2564_2960 = d_Value_das_upt(addr_1233_2945); ({ V _r = 0; V m_2961 = local2564_2960; if (((m_2961) == NONE)) {  _r = ({ V __2962 = UNIT; DONE(NONE); }); } else if (((m_2961) != NONE)) { V _m_2961_a0_2963 = FLD(m_2961, 0); _r = ({ V value_2964 = _m_2961_a0_2963; ({ V local2566_2965 = value_2964; ({ V scrut2567_2966 = local2566_2965; ({ V _r = 0; V m_2967 = scrut2567_2966; if ((tag_of(m_2967) == 0)) { V _m_2967_a0_2968 = FLD(m_2967, 0); V _m_2967_a1_2969 = FLD(m_2967, 1); _r = ({ V p2568_2970 = _m_2967_a0_2968; ({ V p2569_2971 = _m_2967_a1_2969; ({ V _r = 0; V m_2972 = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(ops_1229_2941), ctx_1230_2942), dclo_1232_2944, CON(p2569_2971, NIL)); switch (tag_of(m_2972)) { case 1: { V _m_2972_a0_2973 = FLD(m_2972, 0); _r = ({ V item2572_2974 = _m_2972_a0_2973; DONE(({ V local2571_2975 = item2572_2974; SOME(rt_ctor2(0, SOME(p2561_2959), local2571_2975)); })); }); break; } case 0: { V _m_2972_a0_2976 = FLD(m_2972, 0); _r = ({ V item2573_2977 = _m_2972_a0_2976; FAIL(item2573_2977); }); break; } default: rt_panic("match: no case at kernel:2231"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2231"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2230"); _r; }); }); }); }); }); } else rt_panic("match: no case at kernel:2230"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2229"); _r; }); });
}
V d_Value_das_uneutral(V v_472_2978) {
  return ({ V scrut2592_2979 = v_472_2978; ({ V _r = 0; V m_2980 = scrut2592_2979; switch (tag_of(m_2980)) { case 0: { V _m_2980_a0_2981 = FLD(m_2980, 0); _r = ({ V p2593_2982 = _m_2980_a0_2981; NONE; }); break; } case 1: { V _m_2980_a0_2983 = FLD(m_2980, 0); V _m_2980_a1_2984 = FLD(m_2980, 1); V _m_2980_a2_2985 = FLD(m_2980, 2); _r = ({ V p2594_2986 = _m_2980_a0_2983; ({ V p2595_2987 = _m_2980_a1_2984; ({ V p2596_2988 = _m_2980_a2_2985; NONE; }); }); }); break; } case 2: { V _m_2980_a0_2989 = FLD(m_2980, 0); V _m_2980_a1_2990 = FLD(m_2980, 1); V _m_2980_a2_2991 = FLD(m_2980, 2); _r = ({ V p2597_2992 = _m_2980_a0_2989; ({ V p2598_2993 = _m_2980_a1_2990; ({ V p2599_2994 = _m_2980_a2_2991; NONE; }); }); }); break; } case 3: { V _m_2980_a0_2995 = FLD(m_2980, 0); V _m_2980_a1_2996 = FLD(m_2980, 1); V _m_2980_a2_2997 = FLD(m_2980, 2); _r = ({ V p2600_2998 = _m_2980_a0_2995; ({ V p2601_2999 = _m_2980_a1_2996; ({ V p2602_3000 = _m_2980_a2_2997; NONE; }); }); }); break; } case 4: { V _m_2980_a0_3001 = FLD(m_2980, 0); V _m_2980_a1_3002 = FLD(m_2980, 1); _r = ({ V p2603_3003 = _m_2980_a0_3001; ({ V p2604_3004 = _m_2980_a1_3002; NONE; }); }); break; } case 5: { V _m_2980_a0_3005 = FLD(m_2980, 0); _r = ({ V p2605_3006 = _m_2980_a0_3005; NONE; }); break; } case 6: { V _m_2980_a0_3007 = FLD(m_2980, 0); V _m_2980_a1_3008 = FLD(m_2980, 1); _r = ({ V p2606_3009 = _m_2980_a0_3007; ({ V p2607_3010 = _m_2980_a1_3008; SOME(rt_ctor2(0, p2606_3009, p2607_3010)); }); }); break; } default: rt_panic("match: no case at kernel:2235"); } _r; }); });
}
V d_Rules_dstuck_umsg(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_61); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dout_uwith(V beta_917_3011, V ev_918_3012, V s_919_3013, V addr_920_3014, V v_921_3015) {
  return ({ V t_3016 = ap2(beta_917_3011, ev_918_3012, rt_ctor3(0, s_919_3013, addr_920_3014, v_921_3015)); V _r; if (tag_of(t_3016) == 0) _r = t_3016; else { V bound2588_3017 = FLD(t_3016, 0); _r = ({ V local2591_3018 = bound2588_3017; ({ V _r = 0; V m_3019 = local2591_3018; if (((m_3019) == NONE)) {  _r = ({ V __3020 = UNIT; ({ V local2610_3021 = d_Value_das_uneutral(v_921_3015); ({ V _r = 0; V m_3022 = local2610_3021; if (((m_3022) == NONE)) {  _r = ({ V __3023 = UNIT; FAIL(rt_ctor1(4, d_Rules_dstuck_umsg())); }); } else if (((m_3022) != NONE)) { V _m_3022_a0_3024 = FLD(m_3022, 0); _r = ({ V value_3025 = _m_3022_a0_3024; ({ V local2612_3026 = value_3025; ({ V scrut2613_3027 = local2612_3026; ({ V _r = 0; V m_3028 = scrut2613_3027; if ((tag_of(m_3028) == 0)) { V _m_3028_a0_3029 = FLD(m_3028, 0); V _m_3028_a1_3030 = FLD(m_3028, 1); _r = ({ V p2614_3031 = _m_3028_a0_3029; ({ V p2615_3032 = _m_3028_a1_3030; DONE(rt_ctor2(6, p2614_3031, CON(rt_ctor2(0, s_919_3013, addr_920_3014), p2615_3032))); }); }); } else rt_panic("match: no case at kernel:2244"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2243"); _r; }); }); }); } else if (((m_3019) != NONE)) { V _m_3019_a0_3033 = FLD(m_3019, 0); _r = ({ V value_3034 = _m_3019_a0_3033; ({ V local2617_3035 = value_3034; DONE(local2617_3035); }); }); } else rt_panic("match: no case at kernel:2243"); _r; }); }); } _r; });
}
V d_Rules_dspi_ueta_uran(V ops_1156_3036, V ctx_1157_3037, V s_1158_3038, V dclo_1159_3039, V a_1160_3040, V b_1161_3041) {
  return ({ V t_3042 = ({ V local2620_3043 = d_Rules_das_uvpi(s_1158_3038); ({ V _r = 0; V m_3044 = local2620_3043; if (((m_3044) == NONE)) {  _r = ({ V __3045 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3044) != NONE)) { V _m_3044_a0_3046 = FLD(m_3044, 0); _r = ({ V x_3047 = _m_3044_a0_3046; DONE(x_3047); }); } else rt_panic("match: no case at kernel:2248"); _r; }); }); V _r; if (tag_of(t_3042) == 0) _r = t_3042; else { V bound2575_3048 = FLD(t_3042, 0); _r = ({ V _r = 0; V m_3049 = bound2575_3048; if ((tag_of(m_3049) == 0)) { V _m_3049_a0_3050 = FLD(m_3049, 0); V _m_3049_a1_3051 = FLD(m_3049, 1); V _m_3049_a2_3052 = FLD(m_3049, 2); _r = ({ V p2576_3053 = _m_3049_a0_3050; ({ V p2577_3054 = _m_3049_a1_3051; ({ V p2578_3055 = _m_3049_a2_3052; ({ V scrut2579_3056 = ap(d_Get_dRules_dOps_do_uev(ops_1156_3036), ctx_1157_3037); ({ V scrut2580_3057 = d_Value_dvar(ap(d_Get_dRules_dOps_do_usize(ops_1156_3036), ctx_1157_3037)); ({ V t_3058 = d_Rules_dopen_uclosure(scrut2579_3056, dclo_1159_3039, CON(scrut2580_3057, NIL)); V _r; if (tag_of(t_3058) == 0) _r = t_3058; else { V bound2582_3059 = FLD(t_3058, 0); _r = ({ V t_3060 = d_Rules_dout_uwith(clo_new(w_Rules_dspi_ubeta, 2, 0), scrut2579_3056, s_1158_3038, rt_ctor2(0, p2576_3053, scrut2580_3057), a_1160_3040); V _r; if (tag_of(t_3060) == 0) _r = t_3060; else { V bound2584_3061 = FLD(t_3060, 0); _r = ({ V t_3062 = d_Rules_dout_uwith(clo_new(w_Rules_dspi_ubeta, 2, 0), scrut2579_3056, s_1158_3038, rt_ctor2(0, p2576_3053, scrut2580_3057), b_1161_3041); V _r; if (tag_of(t_3062) == 0) _r = t_3062; else { V bound2586_3063 = FLD(t_3062, 0); _r = apn(d_Get_dRules_dOps_do_uconv(ops_1156_3036), 4, (V[]){apn(d_Get_dRules_dOps_do_ubind(ops_1156_3036), 4, (V[]){p2577_3054, p2576_3053, p2578_3055, ctx_1157_3037}), bound2582_3059, bound2584_3061, bound2586_3063}); } _r; }); } _r; }); } _r; }); }); }); }); }); }); } else rt_panic("match: no case at kernel:2249"); _r; }); } _r; });
}
V d_Rules_dproj_ubranch(V q_1173_3064, V which_1174_3065) {
  return CON(rt_ctor2(0, rt_ctor1(1, d_Big_dzero()), rt_ctor2(0, CON(rt_ctor2(0, q_1173_3064, ((V)&S_62)), CON(rt_ctor2(0, ((V)2), ((V)&S_63)), NIL)), rt_ctor1(0, ((d_Big_dis_ueq(which_1174_3065, d_Big_dzero())) != FALSE_V ? d_Big_done() : d_Big_dzero())))), NIL);
}
V d_Rules_delim_uwith(V beta_929_3066, V ev_930_3067, V s_931_3068, V q_932_3069, V mo_933_3070, V branches_934_3071, V env_935_3072, V v_936_3073) {
  return ({ V t_3074 = ap2(beta_929_3066, ev_930_3067, rt_ctor4(1, s_931_3068, branches_934_3071, env_935_3072, v_936_3073)); V _r; if (tag_of(t_3074) == 0) _r = t_3074; else { V bound2645_3075 = FLD(t_3074, 0); _r = ({ V local2648_3076 = bound2645_3075; ({ V _r = 0; V m_3077 = local2648_3076; if (((m_3077) == NONE)) {  _r = ({ V __3078 = UNIT; ({ V local2651_3079 = d_Value_das_uneutral(v_936_3073); ({ V _r = 0; V m_3080 = local2651_3079; if (((m_3080) == NONE)) {  _r = ({ V __3081 = UNIT; FAIL(rt_ctor1(4, d_Rules_dstuck_umsg())); }); } else if (((m_3080) != NONE)) { V _m_3080_a0_3082 = FLD(m_3080, 0); _r = ({ V value_3083 = _m_3080_a0_3082; ({ V local2653_3084 = value_3083; ({ V scrut2654_3085 = local2653_3084; ({ V _r = 0; V m_3086 = scrut2654_3085; if ((tag_of(m_3086) == 0)) { V _m_3086_a0_3087 = FLD(m_3086, 0); V _m_3086_a1_3088 = FLD(m_3086, 1); _r = ({ V p2655_3089 = _m_3086_a0_3087; ({ V p2656_3090 = _m_3086_a1_3088; ({ V scrut2657_3091 = rt_ctor1(1, ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = s_931_3068; _o->f[1] = q_932_3069; _o->f[2] = mo_933_3070; _o->f[3] = branches_934_3071; _o->f[4] = env_935_3072; (V)_o; })); DONE(rt_ctor2(6, p2655_3089, CON(scrut2657_3091, p2656_3090))); }); }); }); } else rt_panic("match: no case at kernel:2264"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2263"); _r; }); }); }); } else if (((m_3077) != NONE)) { V _m_3077_a0_3092 = FLD(m_3077, 0); _r = ({ V value_3093 = _m_3077_a0_3092; ({ V local2659_3094 = value_3093; DONE(local2659_3094); }); }); } else rt_panic("match: no case at kernel:2263"); _r; }); }); } _r; });
}
V d_Rules_dproj_umotive(V ops_1177_3095, V ctx_1178_3096, V s_1179_3097, V dclo_1180_3098, V q_1181_3099, V x_1182_3100, V dom_v_1183_3101, V which_1184_3102) {
  return ({ V scrut2660_3103 = ap(d_Get_dRules_dOps_do_uev(ops_1177_3095), ctx_1178_3096); ({ V scrut2661_3104 = ap(d_Get_dRules_dOps_do_usize(ops_1177_3095), ctx_1178_3096); ({ V t_3105 = ((d_Big_dis_ueq(which_1184_3102, d_Big_dzero())) != FALSE_V ? DONE(dom_v_1183_3101) : ({ V t_3106 = d_Rules_delim_uwith(clo_new(w_Rules_dspi_ubeta, 2, 0), scrut2660_3103, s_1179_3097, q_1181_3099, NONE, d_Rules_dproj_ubranch(q_1181_3099, d_Big_dzero()), ap(d_Get_dRules_dOps_do_uenv(ops_1177_3095), ctx_1178_3096), d_Value_dvar(scrut2661_3104)); V _r; if (tag_of(t_3106) == 0) _r = t_3106; else { V bound2667_3107 = FLD(t_3106, 0); _r = d_Rules_dopen_uclosure(scrut2660_3103, dclo_1180_3098, CON(bound2667_3107, NIL)); } _r; })); V _r; if (tag_of(t_3105) == 0) _r = t_3105; else { V bound2663_3108 = FLD(t_3105, 0); _r = ({ V t_3109 = ap2(d_Get_dRules_dOps_do_uquote(ops_1177_3095), apn(d_Get_dRules_dOps_do_ubind(ops_1177_3095), 4, (V[]){x_1182_3100, q_1181_3099, dom_v_1183_3101, ctx_1178_3096}), bound2663_3108); V _r; if (tag_of(t_3109) == 0) _r = t_3109; else { V bound2665_3110 = FLD(t_3109, 0); _r = DONE(SOME(rt_ctor4(0, NONE, NIL, ((V)&S_64), bound2665_3110))); } _r; }); } _r; }); }); });
}
V d_Rules_dspi_ueta_ulan(V ops_1192_3111, V ctx_1193_3112, V s_1194_3113, V dclo_1195_3114, V a_1196_3115, V b_1197_3116) {
  return ({ V t_3117 = ({ V local2671_3118 = d_Rules_das_uvpi(s_1194_3113); ({ V _r = 0; V m_3119 = local2671_3118; if (((m_3119) == NONE)) {  _r = ({ V __3120 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3119) != NONE)) { V _m_3119_a0_3121 = FLD(m_3119, 0); _r = ({ V x_3122 = _m_3119_a0_3121; DONE(x_3122); }); } else rt_panic("match: no case at kernel:2279"); _r; }); }); V _r; if (tag_of(t_3117) == 0) _r = t_3117; else { V bound2622_3123 = FLD(t_3117, 0); _r = ({ V _r = 0; V m_3124 = bound2622_3123; if ((tag_of(m_3124) == 0)) { V _m_3124_a0_3125 = FLD(m_3124, 0); V _m_3124_a1_3126 = FLD(m_3124, 1); V _m_3124_a2_3127 = FLD(m_3124, 2); _r = ({ V p2623_3128 = _m_3124_a0_3125; ({ V p2624_3129 = _m_3124_a1_3126; ({ V p2625_3130 = _m_3124_a2_3127; ({ V scrut2626_3131 = ap(d_Get_dRules_dOps_do_uev(ops_1192_3111), ctx_1193_3112); ({ V scrut2627_3132 = ap(d_Get_dRules_dOps_do_uenv(ops_1192_3111), ctx_1193_3112); ({ V t_3133 = d_Rules_dproj_umotive(ops_1192_3111, ctx_1193_3112, s_1194_3113, dclo_1195_3114, p2623_3128, p2624_3129, p2625_3130, d_Big_dzero()); V _r; if (tag_of(t_3133) == 0) _r = t_3133; else { V bound2629_3134 = FLD(t_3133, 0); _r = ({ V t_3135 = d_Rules_delim_uwith(clo_new(w_Rules_dspi_ubeta, 2, 0), scrut2626_3131, s_1194_3113, ((V)1), bound2629_3134, d_Rules_dproj_ubranch(p2623_3128, d_Big_dzero()), scrut2627_3132, a_1196_3115); V _r; if (tag_of(t_3135) == 0) _r = t_3135; else { V bound2631_3136 = FLD(t_3135, 0); _r = ({ V t_3137 = d_Rules_delim_uwith(clo_new(w_Rules_dspi_ubeta, 2, 0), scrut2626_3131, s_1194_3113, ((V)1), bound2629_3134, d_Rules_dproj_ubranch(p2623_3128, d_Big_dzero()), scrut2627_3132, b_1197_3116); V _r; if (tag_of(t_3137) == 0) _r = t_3137; else { V bound2633_3138 = FLD(t_3137, 0); _r = ({ V t_3139 = apn(d_Get_dRules_dOps_do_uconv(ops_1192_3111), 4, (V[]){ctx_1193_3112, p2625_3130, bound2631_3136, bound2633_3138}); V _r; if (tag_of(t_3139) == 0) _r = t_3139; else { V bound2635_3140 = FLD(t_3139, 0); _r = ((bound2635_3140) != FALSE_V ? ({ V t_3141 = d_Rules_dopen_uclosure(scrut2626_3131, dclo_1195_3114, CON(bound2631_3136, NIL)); V _r; if (tag_of(t_3141) == 0) _r = t_3141; else { V bound2637_3142 = FLD(t_3141, 0); _r = ({ V t_3143 = d_Rules_dproj_umotive(ops_1192_3111, ctx_1193_3112, s_1194_3113, dclo_1195_3114, p2623_3128, p2624_3129, p2625_3130, d_Big_done()); V _r; if (tag_of(t_3143) == 0) _r = t_3143; else { V bound2639_3144 = FLD(t_3143, 0); _r = ({ V t_3145 = d_Rules_delim_uwith(clo_new(w_Rules_dspi_ubeta, 2, 0), scrut2626_3131, s_1194_3113, ((V)1), bound2639_3144, d_Rules_dproj_ubranch(p2623_3128, d_Big_done()), scrut2627_3132, a_1196_3115); V _r; if (tag_of(t_3145) == 0) _r = t_3145; else { V bound2641_3146 = FLD(t_3145, 0); _r = ({ V t_3147 = d_Rules_delim_uwith(clo_new(w_Rules_dspi_ubeta, 2, 0), scrut2626_3131, s_1194_3113, ((V)1), bound2639_3144, d_Rules_dproj_ubranch(p2623_3128, d_Big_done()), scrut2627_3132, b_1197_3116); V _r; if (tag_of(t_3147) == 0) _r = t_3147; else { V bound2643_3148 = FLD(t_3147, 0); _r = apn(d_Get_dRules_dOps_do_uconv(ops_1192_3111), 4, (V[]){ctx_1193_3112, bound2637_3142, bound2641_3146, bound2643_3148}); } _r; }); } _r; }); } _r; }); } _r; }) : DONE(FALSE_V)); } _r; }); } _r; }); } _r; }); } _r; }); }); }); }); }); }); } else rt_panic("match: no case at kernel:2280"); _r; }); } _r; });
}
V d_Rules_dspi_uconv_udiagram(V ops_1214_3149, V ctx_1215_3150, V s_1216_3151, V d1_1217_3152, V d2_1218_3153) {
  return ({ V t_3154 = ({ V local2685_3155 = d_Rules_das_uvpi(s_1216_3151); ({ V _r = 0; V m_3156 = local2685_3155; if (((m_3156) == NONE)) {  _r = ({ V __3157 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3156) != NONE)) { V _m_3156_a0_3158 = FLD(m_3156, 0); _r = ({ V x_3159 = _m_3156_a0_3158; DONE(x_3159); }); } else rt_panic("match: no case at kernel:2297"); _r; }); }); V _r; if (tag_of(t_3154) == 0) _r = t_3154; else { V bound2673_3160 = FLD(t_3154, 0); _r = ({ V _r = 0; V m_3161 = bound2673_3160; if ((tag_of(m_3161) == 0)) { V _m_3161_a0_3162 = FLD(m_3161, 0); V _m_3161_a1_3163 = FLD(m_3161, 1); V _m_3161_a2_3164 = FLD(m_3161, 2); _r = ({ V p2674_3165 = _m_3161_a0_3162; ({ V p2675_3166 = _m_3161_a1_3163; ({ V p2676_3167 = _m_3161_a2_3164; ({ V scrut2677_3168 = ap(d_Get_dRules_dOps_do_uev(ops_1214_3149), ctx_1215_3150); ({ V scrut2678_3169 = d_Value_dvar(ap(d_Get_dRules_dOps_do_usize(ops_1214_3149), ctx_1215_3150)); ({ V t_3170 = d_Rules_dopen_uclosure(scrut2677_3168, d1_1217_3152, CON(scrut2678_3169, NIL)); V _r; if (tag_of(t_3170) == 0) _r = t_3170; else { V bound2680_3171 = FLD(t_3170, 0); _r = ({ V t_3172 = d_Rules_dopen_uclosure(scrut2677_3168, d2_1218_3153, CON(scrut2678_3169, NIL)); V _r; if (tag_of(t_3172) == 0) _r = t_3172; else { V bound2682_3173 = FLD(t_3172, 0); _r = ap3(d_Get_dRules_dOps_do_uconv_utype(ops_1214_3149), apn(d_Get_dRules_dOps_do_ubind(ops_1214_3149), 4, (V[]){p2675_3166, p2674_3165, p2676_3167, ctx_1215_3150}), bound2680_3171, bound2682_3173); } _r; }); } _r; }); }); }); }); }); }); } else rt_panic("match: no case at kernel:2298"); _r; }); } _r; });
}
V d_Rules_dspi_uann_ulvl_ueq(V _s_1250_3174, V _u1_1251_3175, V _u2_1252_3176) {
  return TRUE_V;
}
V d_Rules_dpayload_ulvl(V f_991_3177, V _ops_992_3178, V _ctx_993_3179, V _s_994_3180, V ls_995_3181) {
  return DONE(ap(f_991_3177, ls_995_3181));
}
V d_Rules_dno_usubsingleton(V _ops_1255_3182, V _ctx_1256_3183, V _s_1257_3184) {
  return DONE(FALSE_V);
}
V d_Rules_dspi_upack(V param_1270_3185) {
  return ({ V scrut2072_3186 = param_1270_3185; ({ Obj *_o = rt_ctor(0, 17); _o->f[0] = clo_new(lam_3192, 5, 0); _o->f[1] = clo_new(lam_3198, 5, 0); _o->f[2] = clo_new(w_Rules_dspi_uintro_uin, 7, 0); _o->f[3] = clo_new(w_Rules_dspi_uelim_uelim, 5, 0); _o->f[4] = clo_new(w_Rules_dspi_uintro_usec, 6, 0); _o->f[5] = clo_new(w_Rules_dspi_uelim_uout, 6, 0); _o->f[6] = clo_new(w_Rules_dspi_ubeta, 2, 0); _o->f[7] = rt_ctor2(0, TRUE_V, TRUE_V); _o->f[8] = clo_new(w_Rules_dspi_udiagram_uarity, 1, 0); _o->f[9] = clo_new(w_Rules_dspi_uspine_uty, 5, 0); _o->f[10] = SOME(clo_new(w_Rules_dspi_ueta_uran, 6, 0)); _o->f[11] = SOME(clo_new(w_Rules_dspi_ueta_ulan, 6, 0)); _o->f[12] = clo_new(w_Rules_dspi_uconv_udiagram, 5, 0); _o->f[13] = clo_new(w_Rules_dspi_uann_ulvl_ueq, 3, 0); _o->f[14] = clo_new(lam_3203, 4, 0); _o->f[15] = clo_new(lam_3208, 4, 0); _o->f[16] = clo_new(w_Rules_dno_usubsingleton, 3, 0); (V)_o; }); });
}
V d_Rules_dcoll_ulvl(V ls_1273_3209) {
  return d_Rules_dmax_uof(ls_1273_3209);
}
V d_Rules_ddiagram_umsg(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_65); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_das_uvcoll(V s_817_3210) {
  return ({ V scrut2732_3211 = s_817_3210; ({ V _r = 0; V m_3212 = scrut2732_3211; switch (tag_of(m_3212)) { case 0: { V _m_3212_a0_3213 = FLD(m_3212, 0); V _m_3212_a1_3214 = FLD(m_3212, 1); V _m_3212_a2_3215 = FLD(m_3212, 2); _r = ({ V p2733_3216 = _m_3212_a0_3213; ({ V p2734_3217 = _m_3212_a1_3214; ({ V p2735_3218 = _m_3212_a2_3215; NONE; }); }); }); break; } case 1: { V _m_3212_a0_3219 = FLD(m_3212, 0); _r = ({ V p2736_3220 = _m_3212_a0_3219; SOME(p2736_3220); }); break; } case 2: { V _m_3212_a0_3221 = FLD(m_3212, 0); V _m_3212_a1_3222 = FLD(m_3212, 1); _r = ({ V p2737_3223 = _m_3212_a0_3221; ({ V p2738_3224 = _m_3212_a1_3222; NONE; }); }); break; } case 3: { V _m_3212_a0_3225 = FLD(m_3212, 0); V _m_3212_a1_3226 = FLD(m_3212, 1); _r = ({ V p2739_3227 = _m_3212_a0_3225; ({ V p2740_3228 = _m_3212_a1_3226; NONE; }); }); break; } case 4: { V _m_3212_a0_3229 = FLD(m_3212, 0); V _m_3212_a1_3230 = FLD(m_3212, 1); _r = ({ V p2741_3231 = _m_3212_a0_3229; ({ V p2742_3232 = _m_3212_a1_3230; NONE; }); }); break; } default: rt_panic("match: no case at kernel:2326"); } _r; }); });
}
V d_Rules_das_utsec(V t_821_3233) {
  return ({ V scrut2746_3234 = t_821_3233; ({ V _r = 0; V m_3235 = scrut2746_3234; switch (tag_of(m_3235)) { case 0: { V _m_3235_a0_3236 = FLD(m_3235, 0); _r = ({ V p2747_3237 = _m_3235_a0_3236; NONE; }); break; } case 1: { V _m_3235_a0_3238 = FLD(m_3235, 0); _r = ({ V p2748_3239 = _m_3235_a0_3238; NONE; }); break; } case 2: { V _m_3235_a0_3240 = FLD(m_3235, 0); V _m_3235_a1_3241 = FLD(m_3235, 1); _r = ({ V p2749_3242 = _m_3235_a0_3240; ({ V p2750_3243 = _m_3235_a1_3241; NONE; }); }); break; } case 3: { V _m_3235_a0_3244 = FLD(m_3235, 0); V _m_3235_a1_3245 = FLD(m_3235, 1); _r = ({ V p2751_3246 = _m_3235_a0_3244; ({ V p2752_3247 = _m_3235_a1_3245; NONE; }); }); break; } case 4: { V _m_3235_a0_3248 = FLD(m_3235, 0); V _m_3235_a1_3249 = FLD(m_3235, 1); V _m_3235_a2_3250 = FLD(m_3235, 2); _r = ({ V p2753_3251 = _m_3235_a0_3248; ({ V p2754_3252 = _m_3235_a1_3249; ({ V p2755_3253 = _m_3235_a2_3250; NONE; }); }); }); break; } case 5: { V _m_3235_a0_3254 = FLD(m_3235, 0); _r = ({ V p2756_3255 = _m_3235_a0_3254; NONE; }); break; } case 6: { V _m_3235_a0_3256 = FLD(m_3235, 0); V _m_3235_a1_3257 = FLD(m_3235, 1); _r = ({ V p2757_3258 = _m_3235_a0_3256; ({ V p2758_3259 = _m_3235_a1_3257; SOME(rt_ctor2(0, p2757_3258, p2758_3259)); }); }); break; } case 7: { V _m_3235_a0_3260 = FLD(m_3235, 0); V _m_3235_a1_3261 = FLD(m_3235, 1); V _m_3235_a2_3262 = FLD(m_3235, 2); _r = ({ V p2759_3263 = _m_3235_a0_3260; ({ V p2760_3264 = _m_3235_a1_3261; ({ V p2761_3265 = _m_3235_a2_3262; NONE; }); }); }); break; } case 8: { V _m_3235_a0_3266 = FLD(m_3235, 0); V _m_3235_a1_3267 = FLD(m_3235, 1); V _m_3235_a2_3268 = FLD(m_3235, 2); V _m_3235_a3_3269 = FLD(m_3235, 3); _r = ({ V p2762_3270 = _m_3235_a0_3266; ({ V p2763_3271 = _m_3235_a1_3267; ({ V p2764_3272 = _m_3235_a2_3268; ({ V p2765_3273 = _m_3235_a3_3269; NONE; }); }); }); }); break; } case 9: { V _m_3235_a0_3274 = FLD(m_3235, 0); V _m_3235_a1_3275 = FLD(m_3235, 1); _r = ({ V p2766_3276 = _m_3235_a0_3274; ({ V p2767_3277 = _m_3235_a1_3275; NONE; }); }); break; } case 10: { V _m_3235_a0_3278 = FLD(m_3235, 0); _r = ({ V p2768_3279 = _m_3235_a0_3278; NONE; }); break; } case 11: { V _m_3235_a0_3280 = FLD(m_3235, 0); _r = ({ V p2769_3281 = _m_3235_a0_3280; NONE; }); break; } case 12: {  _r = ({ V __3282 = UNIT; NONE; }); break; } default: rt_panic("match: no case at kernel:2330"); } _r; }); });
}
V d_Rules_dcoll_ulevels(V ops_1276_3283, V ctx_1277_3284, V s_1278_3285, V diagram_1279_3286, V expected_1280_3287) {
  return ({ V t_3288 = ({ V local2775_3289 = d_Rules_das_uvcoll(s_1278_3285); ({ V _r = 0; V m_3290 = local2775_3289; if (((m_3290) == NONE)) {  _r = ({ V __3291 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3290) != NONE)) { V _m_3290_a0_3292 = FLD(m_3290, 0); _r = ({ V x_3293 = _m_3290_a0_3292; DONE(x_3293); }); } else rt_panic("match: no case at kernel:2334"); _r; }); }); V _r; if (tag_of(t_3288) == 0) _r = t_3288; else { V bound2714_3294 = FLD(t_3288, 0); _r = ({ V t_3295 = ({ V local2772_3296 = d_Rules_das_utsec(diagram_1279_3286); ({ V _r = 0; V m_3297 = local2772_3296; if (((m_3297) == NONE)) {  _r = ({ V __3298 = UNIT; FAIL(rt_ctor1(4, d_Rules_ddiagram_umsg())); }); } else if (((m_3297) != NONE)) { V _m_3297_a0_3299 = FLD(m_3297, 0); _r = ({ V x_3300 = _m_3297_a0_3299; DONE(x_3300); }); } else rt_panic("match: no case at kernel:2335"); _r; }); }); V _r; if (tag_of(t_3295) == 0) _r = t_3295; else { V bound2716_3301 = FLD(t_3295, 0); _r = ({ V _r = 0; V m_3302 = bound2716_3301; if ((tag_of(m_3302) == 0)) { V _m_3302_a0_3303 = FLD(m_3302, 0); V _m_3302_a1_3304 = FLD(m_3302, 1); _r = ({ V p2717_3305 = _m_3302_a0_3303; ({ V p2718_3306 = _m_3302_a1_3304; ({ V t_3307 = ({ V local2745_3308 = d_Rules_das_uvcoll(p2717_3305); ({ V _r = 0; V m_3309 = local2745_3308; if (((m_3309) == NONE)) {  _r = ({ V __3310 = UNIT; FAIL(rt_ctor1(4, d_Rules_ddiagram_umsg())); }); } else if (((m_3309) != NONE)) { V _m_3309_a0_3311 = FLD(m_3309, 0); _r = ({ V x_3312 = _m_3309_a0_3311; DONE(x_3312); }); } else rt_panic("match: no case at kernel:2337"); _r; }); }); V _r; if (tag_of(t_3307) == 0) _r = t_3307; else { V bound2720_3313 = FLD(t_3307, 0); _r = ({ V t_3314 = ((((d_Big_dis_ueq(bound2720_3313, bound2714_3294)) != FALSE_V ? d_Big_dis_ueq(d_Big_dof_unat(list_length(p2718_3306)), bound2714_3294) : FALSE_V)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, d_Rules_ddiagram_umsg()))); V _r; if (tag_of(t_3314) == 0) _r = t_3314; else { V bound2722_3315 = FLD(t_3314, 0); _r = ({ V t_3316 = ((d_SeqList_dall(clo_new(lam_3318, 1, 0), p2718_3306)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, ((V)&S_66)))); V _r; if (tag_of(t_3316) == 0) _r = t_3316; else { V bound2724_3319 = FLD(t_3316, 0); _r = ({ V t_3320 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_3322, 1, 2); CLO_ENV(_c)[0] = ops_1276_3283; CLO_ENV(_c)[1] = ctx_1277_3284; _c; }), p2718_3306)); V _r; if (tag_of(t_3320) == 0) _r = t_3320; else { V bound2726_3323 = FLD(t_3320, 0); _r = ((d_Big_dis_ueq(bound2714_3294, d_Big_dzero())) != FALSE_V ? DONE(maybe_default(expected_1280_3287, d_Level_dzero())) : DONE(d_Rules_dcoll_ulvl(bound2726_3323))); } _r; }); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2336"); _r; }); } _r; }); } _r; });
}
V d_Rules_dcoll_uleg_uty(V ops_1302_3324, V ctx_1303_3325, V legs_1304_3326, V k_1305_3327) {
  return ({ V t_3328 = ({ V local2802_3329 = d_Rules_dat(k_1305_3327, legs_1304_3326); ({ V _r = 0; V m_3330 = local2802_3329; if (((m_3330) == NONE)) {  _r = ({ V __3331 = UNIT; FAIL(rt_ctor1(7, d_Rules_dleg_umsg())); }); } else if (((m_3330) != NONE)) { V _m_3330_a0_3332 = FLD(m_3330, 0); _r = ({ V x_3333 = _m_3330_a0_3332; DONE(x_3333); }); } else rt_panic("match: no case at kernel:2346"); _r; }); }); V _r; if (tag_of(t_3328) == 0) _r = t_3328; else { V bound2799_3334 = FLD(t_3328, 0); _r = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(ops_1302_3324), ctx_1303_3325), d_Get_dValue_dVleg_dvl_uclo(bound2799_3334), NIL); } _r; });
}
V d_Rules_dcoll_ulegs_uof(V ops_1293_3335, V ctx_1294_3336, V dclo_1295_3337) {
  return ({ V t_3338 = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(ops_1293_3335), ctx_1294_3336), dclo_1295_3337, NIL); V _r; if (tag_of(t_3338) == 0) _r = t_3338; else { V bound2804_3339 = FLD(t_3338, 0); _r = ({ V local2810_3340 = ({ V local2807_3341 = d_Value_das_usec(bound2804_3339); ({ V _r = 0; V m_3342 = local2807_3341; if (((m_3342) == NONE)) {  _r = ({ V __3343 = UNIT; FAIL(rt_ctor1(4, d_Rules_ddiagram_umsg())); }); } else if (((m_3342) != NONE)) { V _m_3342_a0_3344 = FLD(m_3342, 0); _r = ({ V x_3345 = _m_3342_a0_3344; DONE(x_3345); }); } else rt_panic("match: no case at kernel:2353"); _r; }); }); ({ V _r = 0; V m_3346 = local2810_3340; switch (tag_of(m_3346)) { case 1: { V _m_3346_a0_3347 = FLD(m_3346, 0); _r = ({ V item2816_3348 = _m_3346_a0_3347; DONE(({ V local2812_3349 = item2816_3348; ({ V scrut2813_3350 = local2812_3349; ({ V _r = 0; V m_3351 = scrut2813_3350; if ((tag_of(m_3351) == 0)) { V _m_3351_a0_3352 = FLD(m_3351, 0); V _m_3351_a1_3353 = FLD(m_3351, 1); _r = ({ V p2814_3354 = _m_3351_a0_3352; ({ V p2815_3355 = _m_3351_a1_3353; p2815_3355; }); }); } else rt_panic("match: no case at kernel:2353"); _r; }); }); })); }); break; } case 0: { V _m_3346_a0_3356 = FLD(m_3346, 0); _r = ({ V item2817_3357 = _m_3346_a0_3356; FAIL(item2817_3357); }); break; } default: rt_panic("match: no case at kernel:2352"); } _r; }); }); } _r; });
}
V d_Rules_dcoll_uintro_uin(V ops_1359_3358, V ctx_1360_3359, V mode_1361_3360, V _s_1362_3361, V addr_1363_3362, V args_1364_3363, V expected_1365_3364) {
  return ({ V t_3365 = d_Rules_dformer_uview(ops_1359_3358, ctx_1360_3359, clo_new(w_Value_das_ulan, 1, 0), ((V)&S_67), expected_1365_3364); V _r; if (tag_of(t_3365) == 0) _r = t_3365; else { V bound2777_3366 = FLD(t_3365, 0); _r = ({ V _r = 0; V m_3367 = bound2777_3366; if ((tag_of(m_3367) == 0)) { V _m_3367_a0_3368 = FLD(m_3367, 0); V _m_3367_a1_3369 = FLD(m_3367, 1); _r = ({ V p2778_3370 = _m_3367_a0_3368; ({ V p2779_3371 = _m_3367_a1_3369; ({ V _r = 0; V m_3372 = p2779_3371; if ((tag_of(m_3372) == 0)) { V _m_3372_a0_3373 = FLD(m_3372, 0); V _m_3372_a1_3374 = FLD(m_3372, 1); V _m_3372_a2_3375 = FLD(m_3372, 2); _r = ({ V p2780_3376 = _m_3372_a0_3373; ({ V p2781_3377 = _m_3372_a1_3374; ({ V p2782_3378 = _m_3372_a2_3375; ({ V t_3379 = ({ V local2824_3380 = d_Rules_das_uvcoll(p2780_3376); ({ V _r = 0; V m_3381 = local2824_3380; if (((m_3381) == NONE)) {  _r = ({ V __3382 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3381) != NONE)) { V _m_3381_a0_3383 = FLD(m_3381, 0); _r = ({ V x_3384 = _m_3381_a0_3383; DONE(x_3384); }); } else rt_panic("match: no case at kernel:2359"); _r; }); }); V _r; if (tag_of(t_3379) == 0) _r = t_3379; else { V bound2784_3385 = FLD(t_3379, 0); _r = ({ V t_3386 = ({ V local2820_3387 = d_Term_das_ualeg(addr_1363_3362); ({ V _r = 0; V m_3388 = local2820_3387; if (((m_3388) == NONE)) {  _r = ({ V __3389 = UNIT; FAIL(rt_ctor1(7, ((V)&S_68))); }); } else if (((m_3388) != NONE)) { V _m_3388_a0_3390 = FLD(m_3388, 0); _r = ({ V x_3391 = _m_3388_a0_3390; DONE(x_3391); }); } else rt_panic("match: no case at kernel:2361"); _r; }); }); V _r; if (tag_of(t_3386) == 0) _r = t_3386; else { V bound2786_3392 = FLD(t_3386, 0); _r = ({ V t_3393 = ((((d_Big_dis_ule(d_Big_dzero(), bound2786_3392)) != FALSE_V ? d_Big_dis_ult(bound2786_3392, bound2784_3385) : FALSE_V)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(7, d_Rules_dleg_umsg()))); V _r; if (tag_of(t_3393) == 0) _r = t_3393; else { V bound2788_3394 = FLD(t_3393, 0); _r = ({ V t_3395 = d_Rules_dcoll_ulegs_uof(ops_1359_3358, ctx_1360_3359, p2781_3377); V _r; if (tag_of(t_3395) == 0) _r = t_3395; else { V bound2790_3396 = FLD(t_3395, 0); _r = ({ V t_3397 = d_Rules_dcoll_uleg_uty(ops_1359_3358, ctx_1360_3359, bound2790_3396, bound2786_3392); V _r; if (tag_of(t_3397) == 0) _r = t_3397; else { V bound2792_3398 = FLD(t_3397, 0); _r = ({ V t_3399 = ({ V local2797_3400 = d_Rules_done_uof(args_1364_3363); ({ V _r = 0; V m_3401 = local2797_3400; if (((m_3401) == NONE)) {  _r = ({ V __3402 = UNIT; FAIL(rt_ctor1(4, ((V)&S_69))); }); } else if (((m_3401) != NONE)) { V _m_3401_a0_3403 = FLD(m_3401, 0); _r = ({ V x_3404 = _m_3401_a0_3403; DONE(x_3404); }); } else rt_panic("match: no case at kernel:2365"); _r; }); }); V _r; if (tag_of(t_3399) == 0) _r = t_3399; else { V bound2794_3405 = FLD(t_3399, 0); _r = apn(d_Get_dRules_dOps_do_ucheck(ops_1359_3358), 4, (V[]){ctx_1360_3359, mode_1361_3360, bound2794_3405, bound2792_3398}); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2358"); _r; }); }); }); } else rt_panic("match: no case at kernel:2358"); _r; }); } _r; });
}
V d_Quantity_dminimum(V a_319_3406, V b_320_3407) {
  return ((d_Big_dis_ule(d_Quantity_drank(a_319_3406), d_Quantity_drank(b_320_3407))) != FALSE_V ? a_319_3406 : b_320_3407);
}
V d_Quantity_dalternative(V a_645_3408, V b_646_3409) {
  return ({ V scrut2854_3410 = ({ V _c = clo_new(lam_3417, 1, 1); CLO_ENV(_c)[0] = b_646_3409; _c; }); rt_ctor2(0, ({ V _r = 0; V m_3418 = d_Get_dQuantity_dUsage_dpaths(a_645_3408); if (((m_3418) == NONE)) {  _r = ({ V __3419 = UNIT; d_Get_dQuantity_dUsage_dpaths(b_646_3409); }); } else if (((m_3418) != NONE)) { V _m_3418_a0_3420 = FLD(m_3418, 0); _r = ({ V value_3421 = _m_3418_a0_3420; ap(scrut2854_3410, value_3421); }); } else rt_panic("match: no case at kernel:2373"); _r; }), d_Quantity_dcombine(clo_new(w_Quantity_dmaximum, 2, 0), clo_new(w_Quantity_dmaximum, 2, 0), d_Get_dQuantity_dUsage_dreads(a_645_3408), d_Get_dQuantity_dUsage_dreads(b_646_3409))); });
}
V d_Quantity_dunreachable(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor2(0, NONE, d_Assoc_dempty()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dcoll_ubranch(V ops_1400_3422, V ctx_1401_3423, V mode_1402_3424, V e_1403_3425, V vs_1404_3426, V dlegs_1405_3427, V expected_1406_3428, V k_1407_3429) {
  return ({ V t_3430 = ({ V local2888_3431 = d_SeqList_dfind(({ V _c = clo_new(lam_3449, 1, 1); CLO_ENV(_c)[0] = k_1407_3429; _c; }), d_Get_dTerm_dElim_de_ubranches(e_1403_3425)); ({ V _r = 0; V m_3450 = local2888_3431; if (((m_3450) == NONE)) {  _r = ({ V __3451 = UNIT; FAIL(rt_ctor1(8, str_concat(CON(((V)&S_70), CON(d_Big_dshow(k_1407_3429), NIL))))); }); } else if (((m_3450) != NONE)) { V _m_3450_a0_3452 = FLD(m_3450, 0); _r = ({ V x_3453 = _m_3450_a0_3452; DONE(x_3453); }); } else rt_panic("match: no case at kernel:2380"); _r; }); }); V _r; if (tag_of(t_3430) == 0) _r = t_3430; else { V bound2860_3454 = FLD(t_3430, 0); _r = ({ V _r = 0; V m_3455 = bound2860_3454; if ((tag_of(m_3455) == 0)) { V _m_3455_a0_3456 = FLD(m_3455, 0); V _m_3455_a1_3457 = FLD(m_3455, 1); _r = ({ V p2861_3458 = _m_3455_a0_3456; ({ V p2862_3459 = _m_3455_a1_3457; ({ V t_3460 = ({ V local2878_3461 = d_Rules_done_uof(d_Get_dTerm_dLeg_dl_ubinders(p2862_3459)); ({ V _r = 0; V m_3462 = local2878_3461; if (((m_3462) == NONE)) {  _r = ({ V __3463 = UNIT; FAIL(rt_ctor1(8, ((V)&S_71))); }); } else if (((m_3462) != NONE)) { V _m_3462_a0_3464 = FLD(m_3462, 0); _r = ({ V x_3465 = _m_3462_a0_3464; DONE(x_3465); }); } else rt_panic("match: no case at kernel:2383"); _r; }); }); V _r; if (tag_of(t_3460) == 0) _r = t_3460; else { V bound2864_3466 = FLD(t_3460, 0); _r = ({ V _r = 0; V m_3467 = bound2864_3466; if ((tag_of(m_3467) == 0)) { V _m_3467_a0_3468 = FLD(m_3467, 0); V _m_3467_a1_3469 = FLD(m_3467, 1); _r = ({ V p2865_3470 = _m_3467_a0_3468; ({ V p2866_3471 = _m_3467_a1_3469; ({ V t_3472 = d_Rules_dcoll_uleg_uty(ops_1400_3422, ctx_1401_3423, dlegs_1405_3427, k_1407_3429); V _r; if (tag_of(t_3472) == 0) _r = t_3472; else { V bound2868_3473 = FLD(t_3472, 0); _r = ({ V scrut2869_3474 = rt_ctor3(3, vs_1404_3426, rt_ctor1(1, k_1407_3429), CON(d_Value_dvar(ap(d_Get_dRules_dOps_do_usize(ops_1400_3422), ctx_1401_3423)), NIL)); ({ V t_3475 = d_Rules_delim_uresult(ops_1400_3422, ctx_1401_3423, d_Get_dTerm_dElim_de_umotive(e_1403_3425), expected_1406_3428, scrut2869_3474); V _r; if (tag_of(t_3475) == 0) _r = t_3475; else { V bound2871_3476 = FLD(t_3475, 0); _r = ({ V scrut2872_3477 = apn(d_Get_dRules_dOps_do_ubind(ops_1400_3422), 4, (V[]){p2866_3471, p2865_3470, bound2868_3473, ctx_1401_3423}); ({ V t_3478 = apn(d_Get_dRules_dOps_do_ucheck(ops_1400_3422), 4, (V[]){scrut2872_3477, d_Quantity_druntime(mode_1402_3424), d_Get_dTerm_dLeg_dl_ubody(p2862_3459), bound2871_3476}); V _r; if (tag_of(t_3478) == 0) _r = t_3478; else { V bound2874_3479 = FLD(t_3478, 0); _r = apn(d_Get_dRules_dOps_do_uclose(ops_1400_3422), 4, (V[]){scrut2872_3477, ap(d_Get_dRules_dOps_do_usize(ops_1400_3422), ctx_1401_3423), mode_1402_3424, bound2874_3479}); } _r; }); }); } _r; }); }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2384"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2382"); _r; }); } _r; });
}
V d_Rules_dcoll_uelim_uelim(V ops_1424_3480, V ctx_1425_3481, V mode_1426_3482, V e_1427_3483, V expected_1428_3484) {
  return ({ V t_3485 = d_Rules_dinfer_uscrutinee(ops_1424_3480, ctx_1425_3481, mode_1426_3482, e_1427_3483); V _r; if (tag_of(t_3485) == 0) _r = t_3485; else { V bound2826_3486 = FLD(t_3485, 0); _r = ({ V _r = 0; V m_3487 = bound2826_3486; if ((tag_of(m_3487) == 0)) { V _m_3487_a0_3488 = FLD(m_3487, 0); V _m_3487_a1_3489 = FLD(m_3487, 1); _r = ({ V p2827_3490 = _m_3487_a0_3488; ({ V p2828_3491 = _m_3487_a1_3489; ({ V t_3492 = d_Rules_dformer_uview(ops_1424_3480, ctx_1425_3481, clo_new(w_Value_das_ulan, 1, 0), ((V)&S_48), p2827_3490); V _r; if (tag_of(t_3492) == 0) _r = t_3492; else { V bound2830_3493 = FLD(t_3492, 0); _r = ({ V _r = 0; V m_3494 = bound2830_3493; if ((tag_of(m_3494) == 0)) { V _m_3494_a0_3495 = FLD(m_3494, 0); V _m_3494_a1_3496 = FLD(m_3494, 1); _r = ({ V p2831_3497 = _m_3494_a0_3495; ({ V p2832_3498 = _m_3494_a1_3496; ({ V _r = 0; V m_3499 = p2832_3498; if ((tag_of(m_3499) == 0)) { V _m_3499_a0_3500 = FLD(m_3499, 0); V _m_3499_a1_3501 = FLD(m_3499, 1); V _m_3499_a2_3502 = FLD(m_3499, 2); _r = ({ V p2833_3503 = _m_3499_a0_3500; ({ V p2834_3504 = _m_3499_a1_3501; ({ V p2835_3505 = _m_3499_a2_3502; ({ V t_3506 = ({ V local2895_3507 = d_Rules_das_uvcoll(p2833_3503); ({ V _r = 0; V m_3508 = local2895_3507; if (((m_3508) == NONE)) {  _r = ({ V __3509 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3508) != NONE)) { V _m_3508_a0_3510 = FLD(m_3508, 0); _r = ({ V x_3511 = _m_3508_a0_3510; DONE(x_3511); }); } else rt_panic("match: no case at kernel:2400"); _r; }); }); V _r; if (tag_of(t_3506) == 0) _r = t_3506; else { V bound2837_3512 = FLD(t_3506, 0); _r = ({ V t_3513 = d_Rules_dcheck_umotive(ops_1424_3480, ctx_1425_3481, d_Get_dTerm_dElim_de_umotive(e_1427_3483), p2831_3497); V _r; if (tag_of(t_3513) == 0) _r = t_3513; else { V bound2839_3514 = FLD(t_3513, 0); _r = ({ V t_3515 = ap2(d_Get_dRules_dOps_do_ueval(ops_1424_3480), ctx_1425_3481, d_Get_dTerm_dElim_de_uscrut(e_1427_3483)); V _r; if (tag_of(t_3515) == 0) _r = t_3515; else { V bound2841_3516 = FLD(t_3515, 0); _r = ({ V t_3517 = d_Rules_delim_uresult(ops_1424_3480, ctx_1425_3481, d_Get_dTerm_dElim_de_umotive(e_1427_3483), expected_1428_3484, bound2841_3516); V _r; if (tag_of(t_3517) == 0) _r = t_3517; else { V bound2843_3518 = FLD(t_3517, 0); _r = ({ V t_3519 = ((d_Big_dis_ueq(d_Big_dof_unat(list_length(d_Get_dTerm_dElim_de_ubranches(e_1427_3483))), bound2837_3512)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(8, str_concat(CON(((V)&S_72), CON(d_Big_dshow(d_Big_dof_unat(list_length(d_Get_dTerm_dElim_de_ubranches(e_1427_3483)))), CON(((V)&S_73), CON(d_Big_dshow(bound2837_3512), CON(((V)&S_74), NIL))))))))); V _r; if (tag_of(t_3519) == 0) _r = t_3519; else { V bound2845_3520 = FLD(t_3519, 0); _r = ({ V t_3521 = d_Rules_dcoll_ulegs_uof(ops_1424_3480, ctx_1425_3481, p2834_3504); V _r; if (tag_of(t_3521) == 0) _r = t_3521; else { V bound2847_3522 = FLD(t_3521, 0); _r = ({ V t_3523 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_3525, 1, 7); CLO_ENV(_c)[0] = ops_1424_3480; CLO_ENV(_c)[1] = ctx_1425_3481; CLO_ENV(_c)[2] = mode_1426_3482; CLO_ENV(_c)[3] = e_1427_3483; CLO_ENV(_c)[4] = p2833_3503; CLO_ENV(_c)[5] = bound2847_3522; CLO_ENV(_c)[6] = expected_1428_3484; _c; }), d_SeqList_dinit(bound2837_3512, clo_new(lam_3527, 1, 0)))); V _r; if (tag_of(t_3523) == 0) _r = t_3523; else { V bound2849_3528 = FLD(t_3523, 0); _r = ({ V scrut2855_3529 = d_SeqList_dfold(clo_new(w_Quantity_dalternative, 2, 0), bound2849_3528, d_Quantity_dunreachable()); DONE(rt_ctor2(0, bound2843_3518, d_Quantity_dsequence(p2828_3491, d_Quantity_dscale(mode_1426_3482, scrut2855_3529)))); }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2399"); _r; }); }); }); } else rt_panic("match: no case at kernel:2399"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2397"); _r; }); } _r; });
}
V d_Rules_dzip(V xs_825_3530, V ys_826_3531) {
  return ({ V scrut2923_3532 = rt_ctor2(0, xs_825_3530, ys_826_3531); ({ V _r = 0; V m_3533 = scrut2923_3532; if ((tag_of(m_3533) == 0)) { V _m_3533_a0_3534 = FLD(m_3533, 0); V _m_3533_a1_3535 = FLD(m_3533, 1); _r = ({ V p2924_3536 = _m_3533_a0_3534; ({ V p2925_3537 = _m_3533_a1_3535; ({ V _r = 0; V m_3538 = p2924_3536; if (((m_3538) == NIL)) {  _r = ({ V __3539 = UNIT; ({ V _r = 0; V m_3540 = p2925_3537; if (((m_3540) == NIL)) {  _r = ({ V __3541 = UNIT; SOME(NIL); }); } else if (((m_3540) != NIL)) { V _m_3540_a0_3542 = FLD(m_3540, 0); V _m_3540_a1_3543 = FLD(m_3540, 1); _r = ({ V p2926_3544 = _m_3540_a0_3542; ({ V p2927_3545 = _m_3540_a1_3543; NONE; }); }); } else rt_panic("match: no case at kernel:2413"); _r; }); }); } else if (((m_3538) != NIL)) { V _m_3538_a0_3546 = FLD(m_3538, 0); V _m_3538_a1_3547 = FLD(m_3538, 1); _r = ({ V p2928_3548 = _m_3538_a0_3546; ({ V p2929_3549 = _m_3538_a1_3547; ({ V _r = 0; V m_3550 = p2925_3537; if (((m_3550) == NIL)) {  _r = ({ V __3551 = UNIT; NONE; }); } else if (((m_3550) != NIL)) { V _m_3550_a0_3552 = FLD(m_3550, 0); V _m_3550_a1_3553 = FLD(m_3550, 1); _r = ({ V p2930_3554 = _m_3550_a0_3552; ({ V p2931_3555 = _m_3550_a1_3553; ({ V _r = 0; V m_3556 = d_Rules_dzip(p2929_3549, p2931_3555); if (((m_3556) == NONE)) {  _r = ({ V __3557 = UNIT; NONE; }); } else if (((m_3556) != NONE)) { V _m_3556_a0_3558 = FLD(m_3556, 0); _r = ({ V item2935_3559 = _m_3556_a0_3558; SOME(({ V local2933_3560 = item2935_3559; CON(rt_ctor2(0, p2928_3548, p2930_3554), local2933_3560); })); }); } else rt_panic("match: no case at kernel:2413"); _r; }); }); }); } else rt_panic("match: no case at kernel:2413"); _r; }); }); }); } else rt_panic("match: no case at kernel:2413"); _r; }); }); }); } else rt_panic("match: no case at kernel:2413"); _r; }); });
}
V d_Rules_dcoll_uintro_usec(V ops_1336_3561, V ctx_1337_3562, V mode_1338_3563, V s_1339_3564, V legs_1340_3565, V expected_1341_3566) {
  return ({ V t_3567 = ({ V local2946_3568 = d_Rules_das_uvcoll(s_1339_3564); ({ V _r = 0; V m_3569 = local2946_3568; if (((m_3569) == NONE)) {  _r = ({ V __3570 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3569) != NONE)) { V _m_3569_a0_3571 = FLD(m_3569, 0); _r = ({ V x_3572 = _m_3569_a0_3571; DONE(x_3572); }); } else rt_panic("match: no case at kernel:2417"); _r; }); }); V _r; if (tag_of(t_3567) == 0) _r = t_3567; else { V bound2898_3573 = FLD(t_3567, 0); _r = ({ V t_3574 = d_Rules_dformer_uview(ops_1336_3561, ctx_1337_3562, clo_new(w_Value_das_uran, 1, 0), ((V)&S_75), expected_1341_3566); V _r; if (tag_of(t_3574) == 0) _r = t_3574; else { V bound2900_3575 = FLD(t_3574, 0); _r = ({ V _r = 0; V m_3576 = bound2900_3575; if ((tag_of(m_3576) == 0)) { V _m_3576_a0_3577 = FLD(m_3576, 0); V _m_3576_a1_3578 = FLD(m_3576, 1); _r = ({ V p2901_3579 = _m_3576_a0_3577; ({ V p2902_3580 = _m_3576_a1_3578; ({ V _r = 0; V m_3581 = p2902_3580; if ((tag_of(m_3581) == 0)) { V _m_3581_a0_3582 = FLD(m_3581, 0); V _m_3581_a1_3583 = FLD(m_3581, 1); V _m_3581_a2_3584 = FLD(m_3581, 2); _r = ({ V p2903_3585 = _m_3581_a0_3582; ({ V p2904_3586 = _m_3581_a1_3583; ({ V p2905_3587 = _m_3581_a2_3584; ({ V t_3588 = ({ V local2942_3589 = d_Rules_das_uvcoll(p2903_3585); ({ V _r = 0; V m_3590 = local2942_3589; if (((m_3590) == NONE)) {  _r = ({ V __3591 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3590) != NONE)) { V _m_3590_a0_3592 = FLD(m_3590, 0); _r = ({ V x_3593 = _m_3590_a0_3592; DONE(x_3593); }); } else rt_panic("match: no case at kernel:2421"); _r; }); }); V _r; if (tag_of(t_3588) == 0) _r = t_3588; else { V bound2907_3594 = FLD(t_3588, 0); _r = ({ V t_3595 = ((((d_Big_dis_ueq(bound2907_3594, bound2898_3573)) != FALSE_V ? d_Big_dis_ueq(d_Big_dof_unat(list_length(legs_1340_3565)), bound2898_3573) : FALSE_V)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, ((V)&S_76)))); V _r; if (tag_of(t_3595) == 0) _r = t_3595; else { V bound2909_3596 = FLD(t_3595, 0); _r = ({ V t_3597 = d_Rules_dcoll_ulegs_uof(ops_1336_3561, ctx_1337_3562, p2904_3586); V _r; if (tag_of(t_3597) == 0) _r = t_3597; else { V bound2911_3598 = FLD(t_3597, 0); _r = ({ V t_3599 = ({ V local2938_3600 = d_Rules_dzip(legs_1340_3565, bound2911_3598); ({ V _r = 0; V m_3601 = local2938_3600; if (((m_3601) == NONE)) {  _r = ({ V __3602 = UNIT; FAIL(rt_ctor1(4, d_Rules_ddiagram_umsg())); }); } else if (((m_3601) != NONE)) { V _m_3601_a0_3603 = FLD(m_3601, 0); _r = ({ V x_3604 = _m_3601_a0_3603; DONE(x_3604); }); } else rt_panic("match: no case at kernel:2425"); _r; }); }); V _r; if (tag_of(t_3599) == 0) _r = t_3599; else { V bound2913_3605 = FLD(t_3599, 0); _r = ({ V t_3606 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_3616, 1, 3); CLO_ENV(_c)[0] = ops_1336_3561; CLO_ENV(_c)[1] = ctx_1337_3562; CLO_ENV(_c)[2] = mode_1338_3563; _c; }), bound2913_3605)); V _r; if (tag_of(t_3606) == 0) _r = t_3606; else { V bound2915_3617 = FLD(t_3606, 0); _r = DONE(d_SeqList_dfold(clo_new(w_Quantity_dsequence, 2, 0), bound2915_3617, d_Quantity_dempty())); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2420"); _r; }); }); }); } else rt_panic("match: no case at kernel:2420"); _r; }); } _r; }); } _r; });
}
V d_Rules_dcoll_uelim_uout(V ops_1379_3618, V ctx_1380_3619, V mode_1381_3620, V _s_1382_3621, V addr_1383_3622, V head_1384_3623) {
  return ({ V t_3624 = ({ V local2974_3625 = d_Term_das_ualeg(addr_1383_3622); ({ V _r = 0; V m_3626 = local2974_3625; if (((m_3626) == NONE)) {  _r = ({ V __3627 = UNIT; FAIL(rt_ctor1(7, ((V)&S_77))); }); } else if (((m_3626) != NONE)) { V _m_3626_a0_3628 = FLD(m_3626, 0); _r = ({ V x_3629 = _m_3626_a0_3628; DONE(x_3629); }); } else rt_panic("match: no case at kernel:2434"); _r; }); }); V _r; if (tag_of(t_3624) == 0) _r = t_3624; else { V bound2948_3630 = FLD(t_3624, 0); _r = ({ V t_3631 = ap3(d_Get_dRules_dOps_do_uinfer(ops_1379_3618), ctx_1380_3619, mode_1381_3620, head_1384_3623); V _r; if (tag_of(t_3631) == 0) _r = t_3631; else { V bound2950_3632 = FLD(t_3631, 0); _r = ({ V _r = 0; V m_3633 = bound2950_3632; if ((tag_of(m_3633) == 0)) { V _m_3633_a0_3634 = FLD(m_3633, 0); V _m_3633_a1_3635 = FLD(m_3633, 1); _r = ({ V p2951_3636 = _m_3633_a0_3634; ({ V p2952_3637 = _m_3633_a1_3635; ({ V t_3638 = d_Rules_dformer_uview(ops_1379_3618, ctx_1380_3619, clo_new(w_Value_das_uran, 1, 0), ((V)&S_78), p2951_3636); V _r; if (tag_of(t_3638) == 0) _r = t_3638; else { V bound2954_3639 = FLD(t_3638, 0); _r = ({ V _r = 0; V m_3640 = bound2954_3639; if ((tag_of(m_3640) == 0)) { V _m_3640_a0_3641 = FLD(m_3640, 0); V _m_3640_a1_3642 = FLD(m_3640, 1); _r = ({ V p2955_3643 = _m_3640_a0_3641; ({ V p2956_3644 = _m_3640_a1_3642; ({ V _r = 0; V m_3645 = p2956_3644; if ((tag_of(m_3645) == 0)) { V _m_3645_a0_3646 = FLD(m_3645, 0); V _m_3645_a1_3647 = FLD(m_3645, 1); V _m_3645_a2_3648 = FLD(m_3645, 2); _r = ({ V p2957_3649 = _m_3645_a0_3646; ({ V p2958_3650 = _m_3645_a1_3647; ({ V p2959_3651 = _m_3645_a2_3648; ({ V t_3652 = ({ V local2970_3653 = d_Rules_das_uvcoll(p2957_3649); ({ V _r = 0; V m_3654 = local2970_3653; if (((m_3654) == NONE)) {  _r = ({ V __3655 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3654) != NONE)) { V _m_3654_a0_3656 = FLD(m_3654, 0); _r = ({ V x_3657 = _m_3654_a0_3656; DONE(x_3657); }); } else rt_panic("match: no case at kernel:2439"); _r; }); }); V _r; if (tag_of(t_3652) == 0) _r = t_3652; else { V bound2961_3658 = FLD(t_3652, 0); _r = ({ V t_3659 = ((((d_Big_dis_ule(d_Big_dzero(), bound2948_3630)) != FALSE_V ? d_Big_dis_ult(bound2948_3630, bound2961_3658) : FALSE_V)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(7, d_Rules_dleg_umsg()))); V _r; if (tag_of(t_3659) == 0) _r = t_3659; else { V bound2963_3660 = FLD(t_3659, 0); _r = ({ V t_3661 = d_Rules_dcoll_ulegs_uof(ops_1379_3618, ctx_1380_3619, p2958_3650); V _r; if (tag_of(t_3661) == 0) _r = t_3661; else { V bound2965_3662 = FLD(t_3661, 0); _r = ({ V t_3663 = d_Rules_dcoll_uleg_uty(ops_1379_3618, ctx_1380_3619, bound2965_3662, bound2948_3630); V _r; if (tag_of(t_3663) == 0) _r = t_3663; else { V bound2967_3664 = FLD(t_3663, 0); _r = DONE(rt_ctor2(0, bound2967_3664, p2952_3637)); } _r; }); } _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2438"); _r; }); }); }); } else rt_panic("match: no case at kernel:2438"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2436"); _r; }); } _r; }); } _r; });
}
V d_Value_das_uleg(V a_482_3665) {
  return ({ V scrut2980_3666 = a_482_3665; ({ V _r = 0; V m_3667 = scrut2980_3666; switch (tag_of(m_3667)) { case 0: { V _m_3667_a0_3668 = FLD(m_3667, 0); V _m_3667_a1_3669 = FLD(m_3667, 1); _r = ({ V p2981_3670 = _m_3667_a0_3668; ({ V p2982_3671 = _m_3667_a1_3669; NONE; }); }); break; } case 1: { V _m_3667_a0_3672 = FLD(m_3667, 0); _r = ({ V p2983_3673 = _m_3667_a0_3672; SOME(p2983_3673); }); break; } case 2: { V _m_3667_a0_3674 = FLD(m_3667, 0); _r = ({ V p2984_3675 = _m_3667_a0_3674; NONE; }); break; } default: rt_panic("match: no case at kernel:2447"); } _r; }); });
}
V d_Rules_dcoll_ubeta(V ev_1309_3676, V r_1310_3677) {
  return ({ V scrut2975_3678 = r_1310_3677; ({ V _r = 0; V m_3679 = scrut2975_3678; switch (tag_of(m_3679)) { case 0: { V _m_3679_a0_3680 = FLD(m_3679, 0); V _m_3679_a1_3681 = FLD(m_3679, 1); V _m_3679_a2_3682 = FLD(m_3679, 2); _r = ({ V p2976_3683 = _m_3679_a0_3680; ({ V p2977_3684 = _m_3679_a1_3681; ({ V p2978_3685 = _m_3679_a2_3682; d_Rules_dlet_u(d_Value_das_uleg(p2977_3684), ({ V _c = clo_new(lam_3703, 1, 2); CLO_ENV(_c)[0] = p2978_3685; CLO_ENV(_c)[1] = ev_1309_3676; _c; })); }); }); }); break; } case 1: { V _m_3679_a0_3704 = FLD(m_3679, 0); V _m_3679_a1_3705 = FLD(m_3679, 1); V _m_3679_a2_3706 = FLD(m_3679, 2); V _m_3679_a3_3707 = FLD(m_3679, 3); _r = ({ V p3001_3708 = _m_3679_a0_3704; ({ V p3002_3709 = _m_3679_a1_3705; ({ V p3003_3710 = _m_3679_a2_3706; ({ V p3004_3711 = _m_3679_a3_3707; d_Rules_dlet_u(d_Value_das_uin(p3004_3711), ({ V _c = clo_new(lam_3755, 1, 3); CLO_ENV(_c)[0] = p3002_3709; CLO_ENV(_c)[1] = ev_1309_3676; CLO_ENV(_c)[2] = p3003_3710; _c; })); }); }); }); }); break; } default: rt_panic("match: no case at kernel:2451"); } _r; }); });
}
V d_Rules_dcoll_udiagram_uarity(V _s_1247_3756) {
  return d_Big_dzero();
}
V d_Rules_dcoll_uspine_uty(V ops_1474_3757, V ctx_1475_3758, V _s_1476_3759, V dclo_1477_3760, V addr_1478_3761) {
  return ({ V local3036_3762 = d_Value_das_uleg(addr_1478_3761); ({ V _r = 0; V m_3763 = local3036_3762; if (((m_3763) == NONE)) {  _r = ({ V __3764 = UNIT; DONE(NONE); }); } else if (((m_3763) != NONE)) { V _m_3763_a0_3765 = FLD(m_3763, 0); _r = ({ V value_3766 = _m_3763_a0_3765; ({ V local3038_3767 = value_3766; ({ V t_3768 = d_Rules_dcoll_ulegs_uof(ops_1474_3757, ctx_1475_3758, dclo_1477_3760); V _r; if (tag_of(t_3768) == 0) _r = t_3768; else { V bound3040_3769 = FLD(t_3768, 0); _r = ({ V local3043_3770 = d_Rules_dat(local3038_3767, bound3040_3769); ({ V _r = 0; V m_3771 = local3043_3770; if (((m_3771) == NONE)) {  _r = ({ V __3772 = UNIT; DONE(NONE); }); } else if (((m_3771) != NONE)) { V _m_3771_a0_3773 = FLD(m_3771, 0); _r = ({ V value_3774 = _m_3771_a0_3773; ({ V local3045_3775 = value_3774; ({ V _r = 0; V m_3776 = d_Rules_dopen_uclosure(ap(d_Get_dRules_dOps_do_uev(ops_1474_3757), ctx_1475_3758), d_Get_dValue_dVleg_dvl_uclo(local3045_3775), NIL); switch (tag_of(m_3776)) { case 1: { V _m_3776_a0_3777 = FLD(m_3776, 0); _r = ({ V item3048_3778 = _m_3776_a0_3777; DONE(({ V local3047_3779 = item3048_3778; SOME(rt_ctor2(0, NONE, local3047_3779)); })); }); break; } case 0: { V _m_3776_a0_3780 = FLD(m_3776, 0); _r = ({ V item3049_3781 = _m_3776_a0_3780; FAIL(item3049_3781); }); break; } default: rt_panic("match: no case at kernel:2463"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2463"); _r; }); }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2461"); _r; }); });
}
V d_Rules_dcoll_ueta_uran(V ops_1447_3782, V ctx_1448_3783, V s_1449_3784, V dclo_1450_3785, V a_1451_3786, V b_1452_3787) {
  return ({ V t_3788 = ({ V local3073_3789 = d_Rules_das_uvcoll(s_1449_3784); ({ V _r = 0; V m_3790 = local3073_3789; if (((m_3790) == NONE)) {  _r = ({ V __3791 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3790) != NONE)) { V _m_3790_a0_3792 = FLD(m_3790, 0); _r = ({ V x_3793 = _m_3790_a0_3792; DONE(x_3793); }); } else rt_panic("match: no case at kernel:2467"); _r; }); }); V _r; if (tag_of(t_3788) == 0) _r = t_3788; else { V bound3051_3794 = FLD(t_3788, 0); _r = ({ V t_3795 = d_Rules_dcoll_ulegs_uof(ops_1447_3782, ctx_1448_3783, dclo_1450_3785); V _r; if (tag_of(t_3795) == 0) _r = t_3795; else { V bound3053_3796 = FLD(t_3795, 0); _r = ({ V scrut3054_3797 = ap(d_Get_dRules_dOps_do_uev(ops_1447_3782), ctx_1448_3783); d_SeqList_dfold(({ V _c = clo_new(lam_3808, 2, 7); CLO_ENV(_c)[0] = ops_1447_3782; CLO_ENV(_c)[1] = ctx_1448_3783; CLO_ENV(_c)[2] = bound3053_3796; CLO_ENV(_c)[3] = scrut3054_3797; CLO_ENV(_c)[4] = s_1449_3784; CLO_ENV(_c)[5] = a_1451_3786; CLO_ENV(_c)[6] = b_1452_3787; _c; }), d_SeqList_dinit(bound3051_3794, clo_new(lam_3810, 1, 0)), DONE(TRUE_V)); }); } _r; }); } _r; });
}
V d_Rules_dcoll_uconv_udiagram(V ops_1464_3811, V ctx_1465_3812, V _s_1466_3813, V d1_1467_3814, V d2_1468_3815) {
  return ({ V scrut3074_3816 = ap(d_Get_dRules_dOps_do_uev(ops_1464_3811), ctx_1465_3812); ({ V t_3817 = d_Rules_dopen_uclosure(scrut3074_3816, d1_1467_3814, NIL); V _r; if (tag_of(t_3817) == 0) _r = t_3817; else { V bound3076_3818 = FLD(t_3817, 0); _r = ({ V t_3819 = d_Rules_dopen_uclosure(scrut3074_3816, d2_1468_3815, NIL); V _r; if (tag_of(t_3819) == 0) _r = t_3819; else { V bound3078_3820 = FLD(t_3819, 0); _r = ap3(d_Get_dRules_dOps_do_uconv_utype(ops_1464_3811), ctx_1465_3812, bound3076_3818, bound3078_3820); } _r; }); } _r; }); });
}
V d_Rules_dcoll_uann_ulvl_ueq(V s_1485_3821, V u1_1486_3822, V u2_1487_3823) {
  return ({ V local3081_3824 = d_Rules_das_uvcoll(s_1485_3821); ({ V _r = 0; V m_3825 = local3081_3824; if (((m_3825) == NONE)) {  _r = ({ V __3826 = UNIT; TRUE_V; }); } else if (((m_3825) != NONE)) { V _m_3825_a0_3827 = FLD(m_3825, 0); _r = ({ V value_3828 = _m_3825_a0_3827; ({ V local3083_3829 = value_3828; ((d_Big_dis_ueq(local3083_3829, d_Big_dzero())) != FALSE_V ? d_Level_dequal(maybe_default(u1_1486_3822, d_Level_dzero()), maybe_default(u2_1487_3823, d_Level_dzero())) : TRUE_V); }); }); } else rt_panic("match: no case at kernel:2486"); _r; }); });
}
V d_Rules_dcoll_upack(V param_1491_3830) {
  return ({ V scrut2712_3831 = param_1491_3830; ({ Obj *_o = rt_ctor(0, 17); _o->f[0] = clo_new(w_Rules_dcoll_ulevels, 5, 0); _o->f[1] = clo_new(w_Rules_dcoll_ulevels, 5, 0); _o->f[2] = clo_new(w_Rules_dcoll_uintro_uin, 7, 0); _o->f[3] = clo_new(w_Rules_dcoll_uelim_uelim, 5, 0); _o->f[4] = clo_new(w_Rules_dcoll_uintro_usec, 6, 0); _o->f[5] = clo_new(w_Rules_dcoll_uelim_uout, 6, 0); _o->f[6] = clo_new(w_Rules_dcoll_ubeta, 2, 0); _o->f[7] = rt_ctor2(0, TRUE_V, FALSE_V); _o->f[8] = clo_new(w_Rules_dcoll_udiagram_uarity, 1, 0); _o->f[9] = clo_new(w_Rules_dcoll_uspine_uty, 5, 0); _o->f[10] = SOME(clo_new(w_Rules_dcoll_ueta_uran, 6, 0)); _o->f[11] = NONE; _o->f[12] = clo_new(w_Rules_dcoll_uconv_udiagram, 5, 0); _o->f[13] = clo_new(w_Rules_dcoll_uann_ulvl_ueq, 3, 0); _o->f[14] = clo_new(lam_3836, 4, 0); _o->f[15] = clo_new(lam_3841, 4, 0); _o->f[16] = clo_new(w_Rules_dno_usubsingleton, 3, 0); (V)_o; }); });
}
V d_Rules_dmu_utelescope_uuses(V ops_1534_3842, V ctx_1535_3843, V mode_1536_3844, V what_1537_3845, V tele_1538_3846, V args_1539_3847, V env_1540_3848) {
  return ({ V t_3849 = ({ V local3156_3850 = d_Rules_dzip(tele_1538_3846, args_1539_3847); ({ V _r = 0; V m_3851 = local3156_3850; if (((m_3851) == NONE)) {  _r = ({ V __3852 = UNIT; FAIL(rt_ctor1(4, str_concat(CON(what_1537_3845, CON(((V)&S_79), CON(d_Big_dshow(d_Big_dof_unat(list_length(tele_1538_3846))), CON(((V)&S_80), CON(d_Big_dshow(d_Big_dof_unat(list_length(args_1539_3847))), NIL)))))))); }); } else if (((m_3851) != NONE)) { V _m_3851_a0_3853 = FLD(m_3851, 0); _r = ({ V x_3854 = _m_3851_a0_3853; DONE(x_3854); }); } else rt_panic("match: no case at kernel:2494"); _r; }); }); V _r; if (tag_of(t_3849) == 0) _r = t_3849; else { V bound3131_3855 = FLD(t_3849, 0); _r = ({ V scrut3132_3856 = ap(d_Get_dRules_dOps_do_uev(ops_1534_3842), ctx_1535_3843); d_SeqList_dfold(({ V _c = clo_new(lam_3885, 2, 4); CLO_ENV(_c)[0] = scrut3132_3856; CLO_ENV(_c)[1] = ops_1534_3842; CLO_ENV(_c)[2] = ctx_1535_3843; CLO_ENV(_c)[3] = mode_1536_3844; _c; }), bound3131_3855, DONE(rt_ctor2(0, env_1540_3848, d_Quantity_dempty()))); }); } _r; });
}
V d_Rules_dmu_utelescope(V ops_1557_3886, V ctx_1558_3887, V mode_1559_3888, V what_1560_3889, V tele_1561_3890, V args_1562_3891, V env_1563_3892) {
  return ({ V _r = 0; V m_3893 = d_Rules_dmu_utelescope_uuses(ops_1557_3886, ctx_1558_3887, mode_1559_3888, what_1560_3889, tele_1561_3890, args_1562_3891, env_1563_3892); switch (tag_of(m_3893)) { case 1: { V _m_3893_a0_3894 = FLD(m_3893, 0); _r = ({ V item3157_3895 = _m_3893_a0_3894; DONE(({ V local3129_3896 = item3157_3895; d_Get_dTuple2_dv0(local3129_3896); })); }); break; } case 0: { V _m_3893_a0_3897 = FLD(m_3893, 0); _r = ({ V item3158_3898 = _m_3893_a0_3897; FAIL(item3158_3898); }); break; } default: rt_panic("match: no case at kernel:2506"); } _r; });
}
V d_Rules_dmu_uparams_uof(V diagram_1527_3899) {
  return ({ V local3164_3900 = ({ V local3161_3901 = d_Rules_das_utsec(diagram_1527_3899); ({ V _r = 0; V m_3902 = local3161_3901; if (((m_3902) == NONE)) {  _r = ({ V __3903 = UNIT; FAIL(rt_ctor1(4, d_Rules_ddiagram_umsg())); }); } else if (((m_3902) != NONE)) { V _m_3902_a0_3904 = FLD(m_3902, 0); _r = ({ V x_3905 = _m_3902_a0_3904; DONE(x_3905); }); } else rt_panic("match: no case at kernel:2510"); _r; }); }); ({ V _r = 0; V m_3906 = local3164_3900; switch (tag_of(m_3906)) { case 1: { V _m_3906_a0_3907 = FLD(m_3906, 0); _r = ({ V item3172_3908 = _m_3906_a0_3907; DONE(({ V local3166_3909 = item3172_3908; ({ V scrut3167_3910 = local3166_3909; ({ V _r = 0; V m_3911 = scrut3167_3910; if ((tag_of(m_3911) == 0)) { V _m_3911_a0_3912 = FLD(m_3911, 0); V _m_3911_a1_3913 = FLD(m_3911, 1); _r = ({ V p3168_3914 = _m_3911_a0_3912; ({ V p3169_3915 = _m_3911_a1_3913; d_SeqList_dmap(clo_new(lam_3917, 1, 0), p3169_3915); }); }); } else rt_panic("match: no case at kernel:2510"); _r; }); }); })); }); break; } case 0: { V _m_3906_a0_3918 = FLD(m_3906, 0); _r = ({ V item3173_3919 = _m_3906_a0_3918; FAIL(item3173_3919); }); break; } default: rt_panic("match: no case at kernel:2509"); } _r; }); });
}
V d_Positivity_dnonpositive_uword(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_81); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dmu_ufamily(V ops_1511_3920, V ctx_1512_3921, V n_1513_3922) {
  return ({ V t_3923 = ({ V local3180_3924 = ap2(d_Get_dRules_dOps_do_ufamily(ops_1511_3920), ctx_1512_3921, n_1513_3922); ({ V _r = 0; V m_3925 = local3180_3924; if (((m_3925) == NONE)) {  _r = ({ V __3926 = UNIT; FAIL(rt_ctor1(3, str_append(((V)&S_82), str_append(n_1513_3922, ((V)&S_83))))); }); } else if (((m_3925) != NONE)) { V _m_3925_a0_3927 = FLD(m_3925, 0); _r = ({ V x_3928 = _m_3925_a0_3927; DONE(x_3928); }); } else rt_panic("match: no case at kernel:2517"); _r; }); }); V _r; if (tag_of(t_3923) == 0) _r = t_3923; else { V bound3175_3929 = FLD(t_3923, 0); _r = ({ V scrut3176_3930 = d_Get_dPositivity_dFamily_df_ustatus(bound3175_3929); ({ V _r = 0; V m_3931 = scrut3176_3930; switch (tag_of(m_3931)) { case 0: {  _r = ({ V __3932 = UNIT; DONE(bound3175_3929); }); break; } case 1: {  _r = ({ V __3933 = UNIT; DONE(bound3175_3929); }); break; } case 2: { V _m_3931_a0_3934 = FLD(m_3931, 0); _r = ({ V p3177_3935 = _m_3931_a0_3934; ((d_Get_dPositivity_dFamily_df_upositive(bound3175_3929)) != FALSE_V ? DONE(bound3175_3929) : FAIL(rt_ctor1(0, d_Positivity_dnonpositive_uword()))); }); break; } default: rt_panic("match: no case at kernel:2519"); } _r; }); }); } _r; });
}
V d_Rules_das_uvmu(V s_1497_3936) {
  return ({ V scrut3181_3937 = s_1497_3936; ({ V _r = 0; V m_3938 = scrut3181_3937; switch (tag_of(m_3938)) { case 0: { V _m_3938_a0_3939 = FLD(m_3938, 0); V _m_3938_a1_3940 = FLD(m_3938, 1); V _m_3938_a2_3941 = FLD(m_3938, 2); _r = ({ V p3182_3942 = _m_3938_a0_3939; ({ V p3183_3943 = _m_3938_a1_3940; ({ V p3184_3944 = _m_3938_a2_3941; NONE; }); }); }); break; } case 1: { V _m_3938_a0_3945 = FLD(m_3938, 0); _r = ({ V p3185_3946 = _m_3938_a0_3945; NONE; }); break; } case 2: { V _m_3938_a0_3947 = FLD(m_3938, 0); V _m_3938_a1_3948 = FLD(m_3938, 1); _r = ({ V p3186_3949 = _m_3938_a0_3947; ({ V p3187_3950 = _m_3938_a1_3948; NONE; }); }); break; } case 3: { V _m_3938_a0_3951 = FLD(m_3938, 0); V _m_3938_a1_3952 = FLD(m_3938, 1); _r = ({ V p3188_3953 = _m_3938_a0_3951; ({ V p3189_3954 = _m_3938_a1_3952; SOME(rt_ctor2(0, p3188_3953, p3189_3954)); }); }); break; } case 4: { V _m_3938_a0_3955 = FLD(m_3938, 0); V _m_3938_a1_3956 = FLD(m_3938, 1); _r = ({ V p3190_3957 = _m_3938_a0_3955; ({ V p3191_3958 = _m_3938_a1_3956; NONE; }); }); break; } default: rt_panic("match: no case at kernel:2523"); } _r; }); });
}
V d_Rules_dmu_uform_ulan(V ops_1566_3959, V ctx_1567_3960, V s_1568_3961, V diagram_1569_3962, V expected_1570_3963) {
  return ({ V scrut3113_3964 = expected_1570_3963; ({ V scrut3114_3965 = ((V)0); ({ V t_3966 = ({ V local3194_3967 = d_Rules_das_uvmu(s_1568_3961); ({ V _r = 0; V m_3968 = local3194_3967; if (((m_3968) == NONE)) {  _r = ({ V __3969 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_3968) != NONE)) { V _m_3968_a0_3970 = FLD(m_3968, 0); _r = ({ V x_3971 = _m_3968_a0_3970; DONE(x_3971); }); } else rt_panic("match: no case at kernel:2529"); _r; }); }); V _r; if (tag_of(t_3966) == 0) _r = t_3966; else { V bound3116_3972 = FLD(t_3966, 0); _r = ({ V _r = 0; V m_3973 = bound3116_3972; if ((tag_of(m_3973) == 0)) { V _m_3973_a0_3974 = FLD(m_3973, 0); V _m_3973_a1_3975 = FLD(m_3973, 1); _r = ({ V p3117_3976 = _m_3973_a0_3974; ({ V p3118_3977 = _m_3973_a1_3975; ({ V t_3978 = d_Rules_dmu_ufamily(ops_1566_3959, ctx_1567_3960, p3117_3976); V _r; if (tag_of(t_3978) == 0) _r = t_3978; else { V bound3120_3979 = FLD(t_3978, 0); _r = ({ V t_3980 = d_Rules_dmu_uparams_uof(diagram_1569_3962); V _r; if (tag_of(t_3980) == 0) _r = t_3980; else { V bound3122_3981 = FLD(t_3980, 0); _r = ({ V t_3982 = d_Rules_dmu_utelescope(ops_1566_3959, ctx_1567_3960, scrut3114_3965, p3117_3976, d_Get_dPositivity_dFamily_df_uparams(bound3120_3979), bound3122_3981, NIL); V _r; if (tag_of(t_3982) == 0) _r = t_3982; else { V bound3124_3983 = FLD(t_3982, 0); _r = ({ V t_3984 = d_Rules_dmu_utelescope(ops_1566_3959, ctx_1567_3960, scrut3114_3965, str_append(((V)&S_84), p3117_3976), d_Get_dPositivity_dFamily_df_uindices(bound3120_3979), p3118_3977, bound3124_3983); V _r; if (tag_of(t_3984) == 0) _r = t_3984; else { V bound3126_3985 = FLD(t_3984, 0); _r = DONE(d_Get_dPositivity_dFamily_df_ulevel(bound3120_3979)); } _r; }); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2530"); _r; }); } _r; }); }); });
}
V d_Rules_dmu_uran_uword(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_85); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dmu_uindices(V ops_1597_3986, V ctx_1598_3987, V n_1599_3988, V ct_1600_3989, V ixv_1601_3990, V env_1602_3991) {
  return ({ V scrut3231_3992 = d_Big_dof_unat(list_length(d_Get_dPositivity_dCtor_dc_ures_uidx(ct_1600_3989))); ({ V t_3993 = ({ V local3251_3994 = d_Rules_dzip(d_Get_dPositivity_dCtor_dc_ures_uidx(ct_1600_3989), ixv_1601_3990); ({ V _r = 0; V m_3995 = local3251_3994; if (((m_3995) == NONE)) {  _r = ({ V __3996 = UNIT; FAIL(rt_ctor1(4, str_concat(CON(d_Get_dPositivity_dCtor_dc_uname(ct_1600_3989), CON(((V)&S_86), CON(d_Big_dshow(scrut3231_3992), CON(((V)&S_87), CON(n_1599_3988, CON(((V)&S_79), CON(d_Big_dshow(d_Big_dof_unat(list_length(ixv_1601_3990))), NIL)))))))))); }); } else if (((m_3995) != NONE)) { V _m_3995_a0_3997 = FLD(m_3995, 0); _r = ({ V x_3998 = _m_3995_a0_3997; DONE(x_3998); }); } else rt_panic("match: no case at kernel:2543"); _r; }); }); V _r; if (tag_of(t_3993) == 0) _r = t_3993; else { V bound3233_3999 = FLD(t_3993, 0); _r = ({ V scrut3234_4000 = ap(d_Get_dRules_dOps_do_uev(ops_1597_3986), ctx_1598_3987); d_SeqList_dfold(({ V _c = clo_new(lam_4015, 2, 6); CLO_ENV(_c)[0] = scrut3234_4000; CLO_ENV(_c)[1] = env_1602_3991; CLO_ENV(_c)[2] = ops_1597_3986; CLO_ENV(_c)[3] = ctx_1598_3987; CLO_ENV(_c)[4] = ct_1600_3989; CLO_ENV(_c)[5] = n_1599_3988; _c; }), bound3233_3999, DONE(UNIT)); }); } _r; }); });
}
V d_Rules_dmu_uparam_uenv(V ops_1588_4016, V ctx_1589_4017, V dclo_1590_4018) {
  return ({ V t_4019 = d_Rules_dcoll_ulegs_uof(ops_1588_4016, ctx_1589_4017, dclo_1590_4018); V _r; if (tag_of(t_4019) == 0) _r = t_4019; else { V bound3253_4020 = FLD(t_4019, 0); _r = ({ V scrut3254_4021 = ap(d_Get_dRules_dOps_do_uev(ops_1588_4016), ctx_1589_4017); ({ V t_4022 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_4024, 1, 1); CLO_ENV(_c)[0] = scrut3254_4021; _c; }), bound3253_4020)); V _r; if (tag_of(t_4022) == 0) _r = t_4022; else { V bound3256_4025 = FLD(t_4022, 0); _r = DONE(list_reverse(bound3256_4025)); } _r; }); }); } _r; });
}
V d_Term_das_uactor(V a_425_4026) {
  return ({ V scrut3263_4027 = a_425_4026; ({ V _r = 0; V m_4028 = scrut3263_4027; switch (tag_of(m_4028)) { case 0: { V _m_4028_a0_4029 = FLD(m_4028, 0); V _m_4028_a1_4030 = FLD(m_4028, 1); _r = ({ V p3264_4031 = _m_4028_a0_4029; ({ V p3265_4032 = _m_4028_a1_4030; NONE; }); }); break; } case 1: { V _m_4028_a0_4033 = FLD(m_4028, 0); _r = ({ V p3266_4034 = _m_4028_a0_4033; NONE; }); break; } case 2: { V _m_4028_a0_4035 = FLD(m_4028, 0); _r = ({ V p3267_4036 = _m_4028_a0_4035; SOME(p3267_4036); }); break; } default: rt_panic("match: no case at kernel:2562"); } _r; }); });
}
V d_Rules_dmu_uintro_uin(V ops_1615_4037, V ctx_1616_4038, V mode_1617_4039, V _s_1618_4040, V addr_1619_4041, V args_1620_4042, V expected_1621_4043) {
  return ({ V t_4044 = d_Rules_dformer_uview(ops_1615_4037, ctx_1616_4038, clo_new(w_Value_das_ulan, 1, 0), ((V)&S_92), expected_1621_4043); V _r; if (tag_of(t_4044) == 0) _r = t_4044; else { V bound3207_4045 = FLD(t_4044, 0); _r = ({ V _r = 0; V m_4046 = bound3207_4045; if ((tag_of(m_4046) == 0)) { V _m_4046_a0_4047 = FLD(m_4046, 0); V _m_4046_a1_4048 = FLD(m_4046, 1); _r = ({ V p3208_4049 = _m_4046_a0_4047; ({ V p3209_4050 = _m_4046_a1_4048; ({ V _r = 0; V m_4051 = p3209_4050; if ((tag_of(m_4051) == 0)) { V _m_4051_a0_4052 = FLD(m_4051, 0); V _m_4051_a1_4053 = FLD(m_4051, 1); V _m_4051_a2_4054 = FLD(m_4051, 2); _r = ({ V p3210_4055 = _m_4051_a0_4052; ({ V p3211_4056 = _m_4051_a1_4053; ({ V p3212_4057 = _m_4051_a2_4054; ({ V t_4058 = ({ V local3273_4059 = d_Rules_das_uvmu(p3210_4055); ({ V _r = 0; V m_4060 = local3273_4059; if (((m_4060) == NONE)) {  _r = ({ V __4061 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_4060) != NONE)) { V _m_4060_a0_4062 = FLD(m_4060, 0); _r = ({ V x_4063 = _m_4060_a0_4062; DONE(x_4063); }); } else rt_panic("match: no case at kernel:2568"); _r; }); }); V _r; if (tag_of(t_4058) == 0) _r = t_4058; else { V bound3214_4064 = FLD(t_4058, 0); _r = ({ V _r = 0; V m_4065 = bound3214_4064; if ((tag_of(m_4065) == 0)) { V _m_4065_a0_4066 = FLD(m_4065, 0); V _m_4065_a1_4067 = FLD(m_4065, 1); _r = ({ V p3215_4068 = _m_4065_a0_4066; ({ V p3216_4069 = _m_4065_a1_4067; ({ V t_4070 = ({ V local3270_4071 = d_Term_das_uactor(addr_1619_4041); ({ V _r = 0; V m_4072 = local3270_4071; if (((m_4072) == NONE)) {  _r = ({ V __4073 = UNIT; FAIL(rt_ctor1(7, ((V)&S_93))); }); } else if (((m_4072) != NONE)) { V _m_4072_a0_4074 = FLD(m_4072, 0); _r = ({ V x_4075 = _m_4072_a0_4074; DONE(x_4075); }); } else rt_panic("match: no case at kernel:2570"); _r; }); }); V _r; if (tag_of(t_4070) == 0) _r = t_4070; else { V bound3218_4076 = FLD(t_4070, 0); _r = ({ V t_4077 = d_Rules_dmu_ufamily(ops_1615_4037, ctx_1616_4038, p3215_4068); V _r; if (tag_of(t_4077) == 0) _r = t_4077; else { V bound3220_4078 = FLD(t_4077, 0); _r = ({ V t_4079 = ({ V local3261_4080 = d_Positivity_dctor_uof(bound3218_4076, bound3220_4078); ({ V _r = 0; V m_4081 = local3261_4080; if (((m_4081) == NONE)) {  _r = ({ V __4082 = UNIT; FAIL(rt_ctor1(3, str_append(bound3218_4076, str_append(((V)&S_94), p3215_4068)))); }); } else if (((m_4081) != NONE)) { V _m_4081_a0_4083 = FLD(m_4081, 0); _r = ({ V x_4084 = _m_4081_a0_4083; DONE(x_4084); }); } else rt_panic("match: no case at kernel:2573"); _r; }); }); V _r; if (tag_of(t_4079) == 0) _r = t_4079; else { V bound3222_4085 = FLD(t_4079, 0); _r = ({ V t_4086 = d_Rules_dmu_uparam_uenv(ops_1615_4037, ctx_1616_4038, p3211_4056); V _r; if (tag_of(t_4086) == 0) _r = t_4086; else { V bound3224_4087 = FLD(t_4086, 0); _r = ({ V t_4088 = d_Rules_dmu_utelescope_uuses(ops_1615_4037, ctx_1616_4038, mode_1617_4039, bound3218_4076, d_Get_dPositivity_dCtor_dc_uargs(bound3222_4085), args_1620_4042, bound3224_4087); V _r; if (tag_of(t_4088) == 0) _r = t_4088; else { V bound3226_4089 = FLD(t_4088, 0); _r = ({ V _r = 0; V m_4090 = bound3226_4089; if ((tag_of(m_4090) == 0)) { V _m_4090_a0_4091 = FLD(m_4090, 0); V _m_4090_a1_4092 = FLD(m_4090, 1); _r = ({ V p3227_4093 = _m_4090_a0_4091; ({ V p3228_4094 = _m_4090_a1_4092; ({ V t_4095 = d_Rules_dmu_uindices(ops_1615_4037, ctx_1616_4038, p3215_4068, bound3222_4085, p3216_4069, p3227_4093); V _r; if (tag_of(t_4095) == 0) _r = t_4095; else { V bound3230_4096 = FLD(t_4095, 0); _r = DONE(p3228_4094); } _r; }); }); }); } else rt_panic("match: no case at kernel:2576"); _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2569"); _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2567"); _r; }); }); }); } else rt_panic("match: no case at kernel:2567"); _r; }); } _r; });
}
V d_Rules_dmu_uresult(V ops_1650_4097, V ctx_1651_4098, V mo_1652_4099, V idx_1653_4100, V self_1654_4101) {
  return ap2(d_Get_dRules_dEvaluator_dev_ueval(ap(d_Get_dRules_dOps_do_uev(ops_1650_4097), ctx_1651_4098)), CON(self_1654_4101, list_reverse_go(idx_1653_4100, ap(d_Get_dRules_dOps_do_uenv(ops_1650_4097), ctx_1651_4098))), d_Get_dTerm_dMotive_dm_ubody(mo_1652_4099));
}
V d_Rules_dmu_ubranch(V ops_1718_4102, V ctx_1719_4103, V mode_1720_4104, V n_1721_4105, V fam_1722_4106, V mo_1723_4107, V penv_1724_4108, V branches_1725_4109, V c_1726_4110) {
  return ({ V t_4111 = ({ V local3394_4112 = d_Positivity_dctor_uof(c_1726_4110, fam_1722_4106); ({ V _r = 0; V m_4113 = local3394_4112; if (((m_4113) == NONE)) {  _r = ({ V __4114 = UNIT; FAIL(rt_ctor1(3, str_append(c_1726_4110, str_append(((V)&S_94), n_1721_4105)))); }); } else if (((m_4113) != NONE)) { V _m_4113_a0_4115 = FLD(m_4113, 0); _r = ({ V x_4116 = _m_4113_a0_4115; DONE(x_4116); }); } else rt_panic("match: no case at kernel:2585"); _r; }); }); V _r; if (tag_of(t_4111) == 0) _r = t_4111; else { V bound3316_4117 = FLD(t_4111, 0); _r = ({ V t_4118 = ({ V local3390_4119 = d_SeqList_dfind(({ V _c = clo_new(lam_4137, 1, 1); CLO_ENV(_c)[0] = c_1726_4110; _c; }), branches_1725_4109); ({ V _r = 0; V m_4138 = local3390_4119; if (((m_4138) == NONE)) {  _r = ({ V __4139 = UNIT; FAIL(rt_ctor1(8, str_concat(CON(((V)&S_95), CON(n_1721_4105, CON(((V)&S_96), CON(c_1726_4110, NIL))))))); }); } else if (((m_4138) != NONE)) { V _m_4138_a0_4140 = FLD(m_4138, 0); _r = ({ V x_4141 = _m_4138_a0_4140; DONE(x_4141); }); } else rt_panic("match: no case at kernel:2587"); _r; }); }); V _r; if (tag_of(t_4118) == 0) _r = t_4118; else { V bound3318_4142 = FLD(t_4118, 0); _r = ({ V _r = 0; V m_4143 = bound3318_4142; if ((tag_of(m_4143) == 0)) { V _m_4143_a0_4144 = FLD(m_4143, 0); V _m_4143_a1_4145 = FLD(m_4143, 1); _r = ({ V p3319_4146 = _m_4143_a0_4144; ({ V p3320_4147 = _m_4143_a1_4145; ({ V t_4148 = ({ V local3379_4149 = d_Rules_dzip(d_Get_dPositivity_dCtor_dc_uargs(bound3316_4117), d_Get_dTerm_dLeg_dl_ubinders(p3320_4147)); ({ V _r = 0; V m_4150 = local3379_4149; if (((m_4150) == NONE)) {  _r = ({ V __4151 = UNIT; FAIL(rt_ctor1(8, str_concat(CON(((V)&S_97), CON(c_1726_4110, CON(((V)&S_98), CON(d_Big_dshow(d_Big_dof_unat(list_length(d_Get_dTerm_dLeg_dl_ubinders(p3320_4147)))), CON(((V)&S_99), CON(c_1726_4110, CON(((V)&S_79), CON(d_Big_dshow(d_Big_dof_unat(list_length(d_Get_dPositivity_dCtor_dc_uargs(bound3316_4117)))), NIL))))))))))); }); } else if (((m_4150) != NONE)) { V _m_4150_a0_4152 = FLD(m_4150, 0); _r = ({ V x_4153 = _m_4150_a0_4152; DONE(x_4153); }); } else rt_panic("match: no case at kernel:2590"); _r; }); }); V _r; if (tag_of(t_4148) == 0) _r = t_4148; else { V bound3322_4154 = FLD(t_4148, 0); _r = ({ V scrut3323_4155 = ap(d_Get_dRules_dOps_do_uev(ops_1718_4102), ctx_1719_4103); ({ V _r = 0; V m_4156 = d_SeqList_dfold(({ V _c = clo_new(lam_4205, 2, 2); CLO_ENV(_c)[0] = scrut3323_4155; CLO_ENV(_c)[1] = ops_1718_4102; _c; }), bound3322_4154, DONE(rt_ctor3(0, ctx_1719_4103, penv_1724_4108, NIL))); switch (tag_of(m_4156)) { case 1: { V _m_4156_a0_4206 = FLD(m_4156, 0); _r = ({ V item3374_4207 = _m_4156_a0_4206; ({ V local3360_4208 = item3374_4207; ({ V scrut3361_4209 = local3360_4208; ({ V _r = 0; V m_4210 = scrut3361_4209; if ((tag_of(m_4210) == 0)) { V _m_4210_a0_4211 = FLD(m_4210, 0); V _m_4210_a1_4212 = FLD(m_4210, 1); V _m_4210_a2_4213 = FLD(m_4210, 2); _r = ({ V p3362_4214 = _m_4210_a0_4211; ({ V p3363_4215 = _m_4210_a1_4212; ({ V p3364_4216 = _m_4210_a2_4213; ({ V t_4217 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_4219, 1, 2); CLO_ENV(_c)[0] = scrut3323_4155; CLO_ENV(_c)[1] = p3363_4215; _c; }), d_Get_dPositivity_dCtor_dc_ures_uidx(bound3316_4117))); V _r; if (tag_of(t_4217) == 0) _r = t_4217; else { V bound3366_4220 = FLD(t_4217, 0); _r = ({ V scrut3367_4221 = rt_ctor3(3, rt_ctor2(3, n_1721_4105, bound3366_4220), rt_ctor1(2, c_1726_4110), list_reverse(p3364_4216)); ({ V t_4222 = d_Rules_dmu_uresult(ops_1718_4102, ctx_1719_4103, mo_1723_4107, bound3366_4220, scrut3367_4221); V _r; if (tag_of(t_4222) == 0) _r = t_4222; else { V bound3369_4223 = FLD(t_4222, 0); _r = ({ V t_4224 = apn(d_Get_dRules_dOps_do_ucheck(ops_1718_4102), 4, (V[]){p3362_4214, d_Quantity_druntime(mode_1720_4104), d_Get_dTerm_dLeg_dl_ubody(p3320_4147), bound3369_4223}); V _r; if (tag_of(t_4224) == 0) _r = t_4224; else { V bound3371_4225 = FLD(t_4224, 0); _r = apn(d_Get_dRules_dOps_do_uclose(ops_1718_4102), 4, (V[]){p3362_4214, ap(d_Get_dRules_dOps_do_usize(ops_1718_4102), ctx_1719_4103), mode_1720_4104, bound3371_4225}); } _r; }); } _r; }); }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2597"); _r; }); }); }); }); break; } case 0: { V _m_4156_a0_4226 = FLD(m_4156, 0); _r = ({ V item3375_4227 = _m_4156_a0_4226; FAIL(item3375_4227); }); break; } default: rt_panic("match: no case at kernel:2592"); } _r; }); }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2589"); _r; }); } _r; }); } _r; });
}
V d_Rules_dmu_ucount(V x_1696_4228, V xs_1697_4229) {
  return d_Big_dof_unat(list_length(d_SeqList_dfilter(({ V _c = clo_new(lam_4231, 1, 1); CLO_ENV(_c)[0] = x_1696_4228; _c; }), xs_1697_4229)));
}
V d_Rules_dmu_ucover(V n_1700_4232, V names_1701_4233, V branches_1702_4234) {
  return ({ V scrut3400_4235 = d_SeqList_dfilter_umap(clo_new(lam_4243, 1, 0), branches_1702_4234); ({ V t_4244 = ((d_Big_dis_ueq(d_Big_dof_unat(list_length(scrut3400_4235)), d_Big_dof_unat(list_length(branches_1702_4234)))) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(7, str_append(((V)&S_101), str_append(n_1700_4232, ((V)&S_102)))))); V _r; if (tag_of(t_4244) == 0) _r = t_4244; else { V bound3402_4245 = FLD(t_4244, 0); _r = ({ V t_4246 = d_SeqList_dfold(({ V _c = clo_new(lam_4253, 2, 2); CLO_ENV(_c)[0] = scrut3400_4235; CLO_ENV(_c)[1] = n_1700_4232; _c; }), names_1701_4233, DONE(UNIT)); V _r; if (tag_of(t_4246) == 0) _r = t_4246; else { V bound3404_4254 = FLD(t_4246, 0); _r = d_SeqList_dfold(({ V _c = clo_new(lam_4261, 2, 2); CLO_ENV(_c)[0] = names_1701_4233; CLO_ENV(_c)[1] = n_1700_4232; _c; }), scrut3400_4235, DONE(UNIT)); } _r; }); } _r; }); });
}
V d_Rules_dmu_uctor_unames(V n_1691_4262, V fam_1692_4263) {
  return ({ V scrut3427_4264 = d_Get_dPositivity_dFamily_df_ustatus(fam_1692_4263); ({ V _r = 0; V m_4265 = scrut3427_4264; switch (tag_of(m_4265)) { case 0: {  _r = ({ V __4266 = UNIT; FAIL(rt_ctor1(3, str_append(((V)&S_82), str_append(n_1691_4262, ((V)&S_104))))); }); break; } case 1: {  _r = ({ V __4267 = UNIT; FAIL(rt_ctor1(4, str_append(((V)&S_82), str_append(n_1691_4262, ((V)&S_105))))); }); break; } case 2: { V _m_4265_a0_4268 = FLD(m_4265, 0); _r = ({ V p3428_4269 = _m_4265_a0_4268; DONE(p3428_4269); }); break; } default: rt_panic("match: no case at kernel:2625"); } _r; }); });
}
V d_Rules_dmu_uzero_ueliminable(V fam_1502_4270) {
  return ({ V scrut3430_4271 = d_Get_dPositivity_dFamily_df_ustatus(fam_1502_4270); ({ V _r = 0; V m_4272 = scrut3430_4271; switch (tag_of(m_4272)) { case 0: {  _r = ({ V __4273 = UNIT; FALSE_V; }); break; } case 1: {  _r = ({ V __4274 = UNIT; FALSE_V; }); break; } case 2: { V _m_4272_a0_4275 = FLD(m_4272, 0); _r = ({ V p3431_4276 = _m_4272_a0_4275; ({ V _r = 0; V m_4277 = p3431_4276; if (((m_4277) == NIL)) {  _r = ({ V __4278 = UNIT; TRUE_V; }); } else if (((m_4277) != NIL)) { V _m_4277_a0_4279 = FLD(m_4277, 0); V _m_4277_a1_4280 = FLD(m_4277, 1); _r = ({ V p3432_4281 = _m_4277_a0_4279; ({ V p3433_4282 = _m_4277_a1_4280; ({ V _r = 0; V m_4283 = p3433_4282; if (((m_4283) == NIL)) {  _r = ({ V __4284 = UNIT; ({ V local3436_4285 = d_Positivity_dctor_uof(p3432_4281, fam_1502_4270); ({ V _r = 0; V m_4286 = local3436_4285; if (((m_4286) == NONE)) {  _r = ({ V __4287 = UNIT; FALSE_V; }); } else if (((m_4286) != NONE)) { V _m_4286_a0_4288 = FLD(m_4286, 0); _r = ({ V value_4289 = _m_4286_a0_4288; ({ V local3438_4290 = value_4289; ((d_SeqList_dall(clo_new(lam_4300, 1, 0), d_Get_dPositivity_dCtor_dc_uargs(local3438_4290))) != FALSE_V ? ((d_Get_dPositivity_dCtor_dc_uself_urec(local3438_4290)) ^ 1u) : FALSE_V); }); }); } else rt_panic("match: no case at kernel:2629"); _r; }); }); }); } else if (((m_4283) != NIL)) { V _m_4283_a0_4301 = FLD(m_4283, 0); V _m_4283_a1_4302 = FLD(m_4283, 1); _r = ({ V p3445_4303 = _m_4283_a0_4301; ({ V p3446_4304 = _m_4283_a1_4302; FALSE_V; }); }); } else rt_panic("match: no case at kernel:2629"); _r; }); }); }); } else rt_panic("match: no case at kernel:2629"); _r; }); }); break; } default: rt_panic("match: no case at kernel:2629"); } _r; }); });
}
V d_Rules_dmu_ularge_uword(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_106); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dmu_ularge(V n_1686_4305, V fam_1687_4306, V mlvl_1688_4307) {
  return ({ V scrut3429_4308 = UNIT; ((((d_Level_dequal(d_Get_dPositivity_dFamily_df_ulevel(fam_1687_4306), d_Level_dzero())) ^ 1u)) != FALSE_V ? DONE(UNIT) : ((d_Level_dequal(mlvl_1688_4307, d_Level_dzero())) != FALSE_V ? DONE(UNIT) : ((d_Rules_dmu_uzero_ueliminable(fam_1687_4306)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(5, str_concat(CON(d_Rules_dmu_ularge_uword(), CON(((V)&S_107), CON(n_1686_4305, NIL))))))))); });
}
V d_Rules_dmu_umotive_ulvl(V ops_1657_4309, V ctx_1658_4310, V n_1659_4311, V fam_1660_4312, V mo_1661_4313, V dclo_1662_4314, V u_1663_4315, V penv_1664_4316) {
  return ({ V t_4317 = ({ V local3489_4318 = d_Rules_dzip(d_Get_dPositivity_dFamily_df_uindices(fam_1660_4312), d_Get_dTerm_dMotive_dm_uidx(mo_1661_4313)); ({ V _r = 0; V m_4319 = local3489_4318; if (((m_4319) == NONE)) {  _r = ({ V __4320 = UNIT; FAIL(rt_ctor1(4, str_append(((V)&S_108), str_append(n_1659_4311, ((V)&S_109))))); }); } else if (((m_4319) != NONE)) { V _m_4319_a0_4321 = FLD(m_4319, 0); _r = ({ V x_4322 = _m_4319_a0_4321; DONE(x_4322); }); } else rt_panic("match: no case at kernel:2641"); _r; }); }); V _r; if (tag_of(t_4317) == 0) _r = t_4317; else { V bound3448_4323 = FLD(t_4317, 0); _r = ({ V scrut3449_4324 = ap(d_Get_dRules_dOps_do_uev(ops_1657_4309), ctx_1658_4310); ({ V _r = 0; V m_4325 = d_SeqList_dfold(({ V _c = clo_new(lam_4362, 2, 2); CLO_ENV(_c)[0] = scrut3449_4324; CLO_ENV(_c)[1] = ops_1657_4309; _c; }), bound3448_4323, DONE(rt_ctor3(0, ctx_1658_4310, penv_1664_4316, NIL))); switch (tag_of(m_4325)) { case 1: { V _m_4325_a0_4363 = FLD(m_4325, 0); _r = ({ V item3484_4364 = _m_4325_a0_4363; ({ V local3478_4365 = item3484_4364; ({ V scrut3479_4366 = local3478_4365; ({ V _r = 0; V m_4367 = scrut3479_4366; if ((tag_of(m_4367) == 0)) { V _m_4367_a0_4368 = FLD(m_4367, 0); V _m_4367_a1_4369 = FLD(m_4367, 1); V _m_4367_a2_4370 = FLD(m_4367, 2); _r = ({ V p3480_4371 = _m_4367_a0_4368; ({ V p3481_4372 = _m_4367_a1_4369; ({ V p3482_4373 = _m_4367_a2_4370; ({ V scrut3483_4374 = rt_ctor3(1, rt_ctor2(3, n_1659_4311, list_reverse(p3482_4373)), dclo_1662_4314, u_1663_4315); ap2(d_Get_dRules_dOps_do_uinfer_uuniv(ops_1657_4309), apn(d_Get_dRules_dOps_do_ubind(ops_1657_4309), 4, (V[]){d_Get_dTerm_dMotive_dm_uself(mo_1661_4313), ((V)0), scrut3483_4374, p3480_4371}), d_Get_dTerm_dMotive_dm_ubody(mo_1661_4313)); }); }); }); }); } else rt_panic("match: no case at kernel:2647"); _r; }); }); }); }); break; } case 0: { V _m_4325_a0_4375 = FLD(m_4325, 0); _r = ({ V item3485_4376 = _m_4325_a0_4375; FAIL(item3485_4376); }); break; } default: rt_panic("match: no case at kernel:2643"); } _r; }); }); } _r; });
}
V d_Rules_dmu_umotive_uword(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_110); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dmu_umotive_uof(V n_1640_4377, V fam_1641_4378, V ixv_1642_4379, V e_1643_4380) {
  return ({ V t_4381 = ({ V local3503_4382 = d_Get_dTerm_dElim_de_umotive(e_1643_4380); ({ V _r = 0; V m_4383 = local3503_4382; if (((m_4383) == NONE)) {  _r = ({ V __4384 = UNIT; FAIL(rt_ctor1(10, d_Rules_dmu_umotive_uword())); }); } else if (((m_4383) != NONE)) { V _m_4383_a0_4385 = FLD(m_4383, 0); _r = ({ V x_4386 = _m_4383_a0_4385; DONE(x_4386); }); } else rt_panic("match: no case at kernel:2655"); _r; }); }); V _r; if (tag_of(t_4381) == 0) _r = t_4381; else { V bound3491_4387 = FLD(t_4381, 0); _r = ({ V t_4388 = ({ V local3500_4389 = d_Get_dTerm_dMotive_dm_uind(bound3491_4387); ({ V _r = 0; V m_4390 = local3500_4389; if (((m_4390) == NONE)) {  _r = ({ V __4391 = UNIT; FAIL(rt_ctor1(4, str_append(((V)&S_111), str_append(n_1640_4377, ((V)&S_112))))); }); } else if (((m_4390) != NONE)) { V _m_4390_a0_4392 = FLD(m_4390, 0); _r = ({ V x_4393 = _m_4390_a0_4392; DONE(x_4393); }); } else rt_panic("match: no case at kernel:2656"); _r; }); }); V _r; if (tag_of(t_4388) == 0) _r = t_4388; else { V bound3493_4394 = FLD(t_4388, 0); _r = ({ V scrut3494_4395 = d_Big_dof_unat(list_length(d_Get_dPositivity_dFamily_df_uindices(fam_1641_4378))); ({ V scrut3495_4396 = d_Big_dof_unat(list_length(d_Get_dTerm_dMotive_dm_uidx(bound3491_4387))); ({ V scrut3496_4397 = UNIT; ((((d_NativeString_dequal(bound3493_4394, n_1640_4377)) ^ 1u)) != FALSE_V ? FAIL(rt_ctor1(4, str_concat(CON(((V)&S_113), CON(bound3493_4394, CON(((V)&S_114), CON(n_1640_4377, NIL))))))) : ((((d_Big_dis_ueq(scrut3495_4396, scrut3494_4395)) ^ 1u)) != FALSE_V ? FAIL(rt_ctor1(4, str_concat(CON(((V)&S_108), CON(n_1640_4377, CON(((V)&S_98), CON(d_Big_dshow(scrut3495_4396), CON(((V)&S_115), CON(d_Big_dshow(scrut3494_4395), NIL))))))))) : ((((d_Big_dis_ueq(d_Big_dof_unat(list_length(ixv_1642_4379)), scrut3494_4395)) ^ 1u)) != FALSE_V ? FAIL(rt_ctor1(4, str_concat(CON(n_1640_4377, CON(((V)&S_116), CON(d_Big_dshow(d_Big_dof_unat(list_length(ixv_1642_4379))), CON(((V)&S_115), CON(d_Big_dshow(scrut3494_4395), NIL)))))))) : DONE(bound3491_4387)))); }); }); }); } _r; }); } _r; });
}
V d_Rules_dmu_uelim_uelim(V ops_1761_4398, V ctx_1762_4399, V mode_1763_4400, V e_1764_4401, V expected_1765_4402) {
  return ({ V scrut3275_4403 = expected_1765_4402; ({ V t_4404 = d_Rules_dinfer_uscrutinee(ops_1761_4398, ctx_1762_4399, mode_1763_4400, e_1764_4401); V _r; if (tag_of(t_4404) == 0) _r = t_4404; else { V bound3277_4405 = FLD(t_4404, 0); _r = ({ V _r = 0; V m_4406 = bound3277_4405; if ((tag_of(m_4406) == 0)) { V _m_4406_a0_4407 = FLD(m_4406, 0); V _m_4406_a1_4408 = FLD(m_4406, 1); _r = ({ V p3278_4409 = _m_4406_a0_4407; ({ V p3279_4410 = _m_4406_a1_4408; ({ V t_4411 = d_Rules_dformer_uview(ops_1761_4398, ctx_1762_4399, clo_new(w_Value_das_ulan, 1, 0), ((V)&S_48), p3278_4409); V _r; if (tag_of(t_4411) == 0) _r = t_4411; else { V bound3281_4412 = FLD(t_4411, 0); _r = ({ V _r = 0; V m_4413 = bound3281_4412; if ((tag_of(m_4413) == 0)) { V _m_4413_a0_4414 = FLD(m_4413, 0); V _m_4413_a1_4415 = FLD(m_4413, 1); _r = ({ V p3282_4416 = _m_4413_a0_4414; ({ V p3283_4417 = _m_4413_a1_4415; ({ V _r = 0; V m_4418 = p3283_4417; if ((tag_of(m_4418) == 0)) { V _m_4418_a0_4419 = FLD(m_4418, 0); V _m_4418_a1_4420 = FLD(m_4418, 1); V _m_4418_a2_4421 = FLD(m_4418, 2); _r = ({ V p3284_4422 = _m_4418_a0_4419; ({ V p3285_4423 = _m_4418_a1_4420; ({ V p3286_4424 = _m_4418_a2_4421; ({ V t_4425 = ({ V local3506_4426 = d_Rules_das_uvmu(p3284_4422); ({ V _r = 0; V m_4427 = local3506_4426; if (((m_4427) == NONE)) {  _r = ({ V __4428 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_4427) != NONE)) { V _m_4427_a0_4429 = FLD(m_4427, 0); _r = ({ V x_4430 = _m_4427_a0_4429; DONE(x_4430); }); } else rt_panic("match: no case at kernel:2669"); _r; }); }); V _r; if (tag_of(t_4425) == 0) _r = t_4425; else { V bound3288_4431 = FLD(t_4425, 0); _r = ({ V _r = 0; V m_4432 = bound3288_4431; if ((tag_of(m_4432) == 0)) { V _m_4432_a0_4433 = FLD(m_4432, 0); V _m_4432_a1_4434 = FLD(m_4432, 1); _r = ({ V p3289_4435 = _m_4432_a0_4433; ({ V p3290_4436 = _m_4432_a1_4434; ({ V t_4437 = d_Rules_dmu_ufamily(ops_1761_4398, ctx_1762_4399, p3289_4435); V _r; if (tag_of(t_4437) == 0) _r = t_4437; else { V bound3292_4438 = FLD(t_4437, 0); _r = ({ V t_4439 = d_Rules_dmu_umotive_uof(p3289_4435, bound3292_4438, p3290_4436, e_1764_4401); V _r; if (tag_of(t_4439) == 0) _r = t_4439; else { V bound3294_4440 = FLD(t_4439, 0); _r = ({ V t_4441 = d_Rules_dmu_uparam_uenv(ops_1761_4398, ctx_1762_4399, p3285_4423); V _r; if (tag_of(t_4441) == 0) _r = t_4441; else { V bound3296_4442 = FLD(t_4441, 0); _r = ({ V t_4443 = d_Rules_dmu_umotive_ulvl(ops_1761_4398, ctx_1762_4399, p3289_4435, bound3292_4438, bound3294_4440, p3285_4423, p3286_4424, bound3296_4442); V _r; if (tag_of(t_4443) == 0) _r = t_4443; else { V bound3298_4444 = FLD(t_4443, 0); _r = ({ V t_4445 = d_Rules_dmu_ularge(p3289_4435, bound3292_4438, bound3298_4444); V _r; if (tag_of(t_4445) == 0) _r = t_4445; else { V bound3300_4446 = FLD(t_4445, 0); _r = ({ V t_4447 = d_Rules_dmu_uctor_unames(p3289_4435, bound3292_4438); V _r; if (tag_of(t_4447) == 0) _r = t_4447; else { V bound3302_4448 = FLD(t_4447, 0); _r = ({ V t_4449 = d_Rules_dmu_ucover(p3289_4435, bound3302_4448, d_Get_dTerm_dElim_de_ubranches(e_1764_4401)); V _r; if (tag_of(t_4449) == 0) _r = t_4449; else { V bound3304_4450 = FLD(t_4449, 0); _r = ({ V t_4451 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_4453, 1, 8); CLO_ENV(_c)[0] = ops_1761_4398; CLO_ENV(_c)[1] = ctx_1762_4399; CLO_ENV(_c)[2] = mode_1763_4400; CLO_ENV(_c)[3] = p3289_4435; CLO_ENV(_c)[4] = bound3292_4438; CLO_ENV(_c)[5] = bound3294_4440; CLO_ENV(_c)[6] = bound3296_4442; CLO_ENV(_c)[7] = e_1764_4401; _c; }), bound3302_4448)); V _r; if (tag_of(t_4451) == 0) _r = t_4451; else { V bound3306_4454 = FLD(t_4451, 0); _r = ({ V t_4455 = ap2(d_Get_dRules_dOps_do_ueval(ops_1761_4398), ctx_1762_4399, d_Get_dTerm_dElim_de_uscrut(e_1764_4401)); V _r; if (tag_of(t_4455) == 0) _r = t_4455; else { V bound3308_4456 = FLD(t_4455, 0); _r = ({ V t_4457 = d_Rules_dmu_uresult(ops_1761_4398, ctx_1762_4399, bound3294_4440, p3290_4436, bound3308_4456); V _r; if (tag_of(t_4457) == 0) _r = t_4457; else { V bound3310_4458 = FLD(t_4457, 0); _r = ({ V scrut3311_4459 = d_SeqList_dfold(clo_new(w_Quantity_dalternative, 2, 0), bound3306_4454, d_Quantity_dunreachable()); DONE(rt_ctor2(0, bound3310_4458, d_Quantity_dsequence(p3279_4410, d_Quantity_dscale(mode_1763_4400, scrut3311_4459)))); }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2670"); _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2668"); _r; }); }); }); } else rt_panic("match: no case at kernel:2668"); _r; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:2666"); _r; }); } _r; }); });
}
V d_Value_das_uctor(V a_486_4460) {
  return ({ V scrut3549_4461 = a_486_4460; ({ V _r = 0; V m_4462 = scrut3549_4461; switch (tag_of(m_4462)) { case 0: { V _m_4462_a0_4463 = FLD(m_4462, 0); V _m_4462_a1_4464 = FLD(m_4462, 1); _r = ({ V p3550_4465 = _m_4462_a0_4463; ({ V p3551_4466 = _m_4462_a1_4464; NONE; }); }); break; } case 1: { V _m_4462_a0_4467 = FLD(m_4462, 0); _r = ({ V p3552_4468 = _m_4462_a0_4467; NONE; }); break; } case 2: { V _m_4462_a0_4469 = FLD(m_4462, 0); _r = ({ V p3553_4470 = _m_4462_a0_4469; SOME(p3553_4470); }); break; } default: rt_panic("match: no case at kernel:2687"); } _r; }); });
}
V d_Rules_dmu_ubeta(V ev_1790_4471, V r_1791_4472) {
  return ({ V scrut3533_4473 = r_1791_4472; ({ V _r = 0; V m_4474 = scrut3533_4473; switch (tag_of(m_4474)) { case 0: { V _m_4474_a0_4475 = FLD(m_4474, 0); V _m_4474_a1_4476 = FLD(m_4474, 1); V _m_4474_a2_4477 = FLD(m_4474, 2); _r = ({ V p3534_4478 = _m_4474_a0_4475; ({ V p3535_4479 = _m_4474_a1_4476; ({ V p3536_4480 = _m_4474_a2_4477; FAIL(rt_ctor1(0, d_Rules_dmu_uran_uword())); }); }); }); break; } case 1: { V _m_4474_a0_4481 = FLD(m_4474, 0); V _m_4474_a1_4482 = FLD(m_4474, 1); V _m_4474_a2_4483 = FLD(m_4474, 2); V _m_4474_a3_4484 = FLD(m_4474, 3); _r = ({ V p3537_4485 = _m_4474_a0_4481; ({ V p3538_4486 = _m_4474_a1_4482; ({ V p3539_4487 = _m_4474_a2_4483; ({ V p3540_4488 = _m_4474_a3_4484; d_Rules_dlet_u(d_Value_das_uin(p3540_4488), ({ V _c = clo_new(lam_4532, 1, 3); CLO_ENV(_c)[0] = p3538_4486; CLO_ENV(_c)[1] = ev_1790_4471; CLO_ENV(_c)[2] = p3539_4487; _c; })); }); }); }); }); break; } default: rt_panic("match: no case at kernel:2691"); } _r; }); });
}
V d_Rules_dmu_ulan_ulvl(V ops_1809_4533, V ctx_1810_4534, V s_1811_4535, V _ls_1812_4536) {
  return ({ V t_4537 = ({ V local3593_4538 = d_Rules_das_uvmu(s_1811_4535); ({ V _r = 0; V m_4539 = local3593_4538; if (((m_4539) == NONE)) {  _r = ({ V __4540 = UNIT; FAIL(rt_ctor1(4, d_Rules_dwrong_upack())); }); } else if (((m_4539) != NONE)) { V _m_4539_a0_4541 = FLD(m_4539, 0); _r = ({ V x_4542 = _m_4539_a0_4541; DONE(x_4542); }); } else rt_panic("match: no case at kernel:2698"); _r; }); }); V _r; if (tag_of(t_4537) == 0) _r = t_4537; else { V bound3586_4543 = FLD(t_4537, 0); _r = ({ V _r = 0; V m_4544 = bound3586_4543; if ((tag_of(m_4544) == 0)) { V _m_4544_a0_4545 = FLD(m_4544, 0); V _m_4544_a1_4546 = FLD(m_4544, 1); _r = ({ V p3587_4547 = _m_4544_a0_4545; ({ V p3588_4548 = _m_4544_a1_4546; ({ V t_4549 = d_Rules_dmu_ufamily(ops_1809_4533, ctx_1810_4534, p3587_4547); V _r; if (tag_of(t_4549) == 0) _r = t_4549; else { V bound3590_4550 = FLD(t_4549, 0); _r = DONE(d_Get_dPositivity_dFamily_df_ulevel(bound3590_4550)); } _r; }); }); }); } else rt_panic("match: no case at kernel:2699"); _r; }); } _r; });
}
V d_Rules_dmu_usubsingleton(V ops_1517_4551, V ctx_1518_4552, V s_1519_4553) {
  return ({ V local3604_4554 = d_Rules_das_uvmu(s_1519_4553); ({ V _r = 0; V m_4555 = local3604_4554; if (((m_4555) == NONE)) {  _r = ({ V __4556 = UNIT; DONE(FALSE_V); }); } else if (((m_4555) != NONE)) { V _m_4555_a0_4557 = FLD(m_4555, 0); _r = ({ V value_4558 = _m_4555_a0_4557; ({ V local3606_4559 = value_4558; ({ V scrut3607_4560 = local3606_4559; ({ V _r = 0; V m_4561 = scrut3607_4560; if ((tag_of(m_4561) == 0)) { V _m_4561_a0_4562 = FLD(m_4561, 0); V _m_4561_a1_4563 = FLD(m_4561, 1); _r = ({ V p3608_4564 = _m_4561_a0_4562; ({ V p3609_4565 = _m_4561_a1_4563; ({ V local3612_4566 = d_Rules_dmu_ufamily(ops_1517_4551, ctx_1518_4552, p3608_4564); ({ V _r = 0; V m_4567 = local3612_4566; switch (tag_of(m_4567)) { case 1: { V _m_4567_a0_4568 = FLD(m_4567, 0); _r = ({ V x_4569 = _m_4567_a0_4568; ({ V local3614_4570 = x_4569; DONE(((d_Level_dequal(d_Get_dPositivity_dFamily_df_ulevel(local3614_4570), d_Level_dzero())) != FALSE_V ? d_Rules_dmu_uzero_ueliminable(local3614_4570) : FALSE_V)); }); }); break; } case 0: { V _m_4567_a0_4571 = FLD(m_4567, 0); _r = ({ V x_4572 = _m_4567_a0_4571; ({ V local3616_4573 = x_4572; DONE(FALSE_V); }); }); break; } default: rt_panic("match: no case at kernel:2705"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:2705"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2704"); _r; }); });
}
V d_Rules_dmu_upack(V param_1845_4574) {
  return ({ V scrut3112_4575 = param_1845_4574; ({ Obj *_o = rt_ctor(0, 17); _o->f[0] = clo_new(w_Rules_dmu_uform_ulan, 5, 0); _o->f[1] = clo_new(lam_4581, 5, 0); _o->f[2] = clo_new(w_Rules_dmu_uintro_uin, 7, 0); _o->f[3] = clo_new(w_Rules_dmu_uelim_uelim, 5, 0); _o->f[4] = clo_new(lam_4588, 6, 0); _o->f[5] = clo_new(lam_4595, 6, 0); _o->f[6] = clo_new(w_Rules_dmu_ubeta, 2, 0); _o->f[7] = rt_ctor2(0, FALSE_V, FALSE_V); _o->f[8] = clo_new(w_Rules_dcoll_udiagram_uarity, 1, 0); _o->f[9] = clo_new(lam_4601, 5, 0); _o->f[10] = NONE; _o->f[11] = NONE; _o->f[12] = clo_new(w_Rules_dcoll_uconv_udiagram, 5, 0); _o->f[13] = clo_new(w_Rules_dspi_uann_ulvl_ueq, 3, 0); _o->f[14] = clo_new(w_Rules_dmu_ulan_ulvl, 4, 0); _o->f[15] = clo_new(lam_4606, 4, 0); _o->f[16] = clo_new(w_Rules_dmu_usubsingleton, 3, 0); (V)_o; }); });
}
V d_Rules_drules(V s_1848_4607) {
  return ({ V scrut2068_4608 = s_1848_4607; ({ V _r = 0; V m_4609 = scrut2068_4608; switch (tag_of(m_4609)) { case 0: { V _m_4609_a0_4610 = FLD(m_4609, 0); V _m_4609_a1_4611 = FLD(m_4609, 1); V _m_4609_a2_4612 = FLD(m_4609, 2); _r = ({ V p2069_4613 = _m_4609_a0_4610; ({ V p2070_4614 = _m_4609_a1_4611; ({ V p2071_4615 = _m_4609_a2_4612; DONE(d_Rules_dspi_upack(UNIT)); }); }); }); break; } case 1: { V _m_4609_a0_4616 = FLD(m_4609, 0); _r = ({ V p2711_4617 = _m_4609_a0_4616; DONE(d_Rules_dcoll_upack(UNIT)); }); break; } case 2: { V _m_4609_a0_4618 = FLD(m_4609, 0); V _m_4609_a1_4619 = FLD(m_4609, 1); _r = ({ V p3108_4620 = _m_4609_a0_4618; ({ V p3109_4621 = _m_4609_a1_4619; FAIL(rt_ctor1(0, d_Rules_dspar_uword())); }); }); break; } case 3: { V _m_4609_a0_4622 = FLD(m_4609, 0); V _m_4609_a1_4623 = FLD(m_4609, 1); _r = ({ V p3110_4624 = _m_4609_a0_4622; ({ V p3111_4625 = _m_4609_a1_4623; DONE(d_Rules_dmu_upack(UNIT)); }); }); break; } case 4: { V _m_4609_a0_4626 = FLD(m_4609, 0); V _m_4609_a1_4627 = FLD(m_4609, 1); _r = ({ V p3618_4628 = _m_4609_a0_4626; ({ V p3619_4629 = _m_4609_a1_4627; FAIL(rt_ctor1(0, d_Rules_dsnu_uword())); }); }); break; } default: rt_panic("match: no case at kernel:2713"); } _r; }); });
}
V d_Rules_delim_uvalue(V ev_1858_4630, V s_1859_4631, V q_1860_4632, V mo_1861_4633, V branches_1862_4634, V env_1863_4635, V v_1864_4636) {
  return ({ V _r = 0; V m_4637 = d_Rules_drules(s_1859_4631); switch (tag_of(m_4637)) { case 1: { V _m_4637_a0_4638 = FLD(m_4637, 0); _r = ({ V item3622_4639 = _m_4637_a0_4638; ({ V local3621_4640 = item3622_4639; d_Rules_delim_uwith(d_Get_dRules_dRule_upack_dbeta(local3621_4640), ev_1858_4630, s_1859_4631, q_1860_4632, mo_1861_4633, branches_1862_4634, env_1863_4635, v_1864_4636); }); }); break; } case 0: { V _m_4637_a0_4641 = FLD(m_4637, 0); _r = ({ V item3623_4642 = _m_4637_a0_4641; FAIL(item3623_4642); }); break; } default: rt_panic("match: no case at kernel:2716"); } _r; });
}
V d_Eval_dleg_uclosure(V env_946_4643, V lg_947_4644) {
  return rt_ctor2(0, d_Get_dTerm_dLeg_dl_ubinders(lg_947_4644), d_Value_dclose(env_946_4643, d_Get_dTerm_dLeg_dl_ubody(lg_947_4644)));
}
V d_Global_dfind(V name_758_4645, V globals_759_4646) {
  return d_Assoc_dfind(clo_new(lam_4649, 2, 0), name_758_4645, d_Get_dGlobal_dentries(globals_759_4646));
}
V d_Global_ddef_uof(V e_782_4650) {
  return ({ V scrut3680_4651 = e_782_4650; ({ V _r = 0; V m_4652 = scrut3680_4651; switch (tag_of(m_4652)) { case 0: { V _m_4652_a0_4653 = FLD(m_4652, 0); _r = ({ V p3681_4654 = _m_4652_a0_4653; SOME(p3681_4654); }); break; } case 1: { V _m_4652_a0_4655 = FLD(m_4652, 0); _r = ({ V p3682_4656 = _m_4652_a0_4655; NONE; }); break; } case 2: { V _m_4652_a0_4657 = FLD(m_4652, 0); _r = ({ V p3683_4658 = _m_4652_a0_4657; NONE; }); break; } default: rt_panic("match: no case at kernel:2726"); } _r; }); });
}
V d_Eval_dguarded_uframe(V k_1071_4659, V frames_1072_4660) {
_top: ;
  return ({ V scrut3712_4661 = frames_1072_4660; ({ V _r = 0; V m_4662 = scrut3712_4661; if (((m_4662) == NIL)) {  _r = ({ V __4663 = UNIT; FALSE_V; }); } else if (((m_4662) != NIL)) { V _m_4662_a0_4664 = FLD(m_4662, 0); V _m_4662_a1_4665 = FLD(m_4662, 1); _r = ({ V p3713_4666 = _m_4662_a0_4664; ({ V p3714_4667 = _m_4662_a1_4665; ({ V _r = 0; V m_4668 = p3713_4666; switch (tag_of(m_4668)) { case 0: { V _m_4668_a0_4669 = FLD(m_4668, 0); V _m_4668_a1_4670 = FLD(m_4668, 1); _r = ({ V p3715_4671 = _m_4668_a0_4669; ({ V p3716_4672 = _m_4668_a1_4670; ({ V local3719_4673 = d_Value_das_upt(p3716_4672); ({ V _r = 0; V m_4674 = local3719_4673; if (((m_4674) == NONE)) {  _r = ({ V __4675 = UNIT; FALSE_V; }); } else if (((m_4674) != NONE)) { V _m_4674_a0_4676 = FLD(m_4674, 0); _r = ({ V value_4677 = _m_4674_a0_4676; ({ V local3721_4678 = value_4677; ({ V scrut3722_4679 = local3721_4678; ({ V _r = 0; V m_4680 = scrut3722_4679; if ((tag_of(m_4680) == 0)) { V _m_4680_a0_4681 = FLD(m_4680, 0); V _m_4680_a1_4682 = FLD(m_4680, 1); _r = ({ V p3723_4683 = _m_4680_a0_4681; ({ V p3724_4684 = _m_4680_a1_4682; ((d_Big_dis_ult(d_Big_dzero(), k_1071_4659)) != FALSE_V ? ({ V a_4685 = d_NativeInt_dsub(k_1071_4659, d_Big_done()); V a_4686 = p3714_4667; k_1071_4659 = a_4685; frames_1072_4660 = a_4686;  goto _top; (V)0; }) : ((d_Big_dis_ult(k_1071_4659, d_Big_dzero())) != FALSE_V ? FALSE_V : ((V)maybe_is_some(({ V local3727_4687 = d_Value_das_uin(p3724_4684); ({ V local3731_4688 = local3727_4687; ({ V local3733_4689 = clo_new(lam_4699, 1, 0); ({ V _r = 0; V m_4700 = local3731_4688; if (((m_4700) == NONE)) {  _r = ({ V __4701 = UNIT; NONE; }); } else if (((m_4700) != NONE)) { V _m_4700_a0_4702 = FLD(m_4700, 0); _r = ({ V item3735_4703 = _m_4700_a0_4702; ap(local3733_4689, item3735_4703); }); } else rt_panic("match: no case at kernel:2731"); _r; }); }); }); }))))); }); }); } else rt_panic("match: no case at kernel:2731"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2730"); _r; }); }); }); }); break; } case 1: { V _m_4668_a0_4704 = FLD(m_4668, 0); _r = ({ V p3743_4705 = _m_4668_a0_4704; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:2730"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2730"); _r; }); });
}
V d_Rules_dout_uvalue(V ev_1851_4706, V s_1852_4707, V addr_1853_4708, V v_1854_4709) {
  return ({ V _r = 0; V m_4710 = d_Rules_drules(s_1852_4707); switch (tag_of(m_4710)) { case 1: { V _m_4710_a0_4711 = FLD(m_4710, 0); _r = ({ V item3760_4712 = _m_4710_a0_4711; ({ V local3759_4713 = item3760_4712; d_Rules_dout_uwith(d_Get_dRules_dRule_upack_dbeta(local3759_4713), ev_1851_4706, s_1852_4707, addr_1853_4708, v_1854_4709); }); }); break; } case 0: { V _m_4710_a0_4714 = FLD(m_4710, 0); _r = ({ V item3761_4715 = _m_4710_a0_4714; FAIL(item3761_4715); }); break; } default: rt_panic("match: no case at kernel:2735"); } _r; });
}
V d_Eval_dreplay(V globals_1083_4716, V head_1084_4717, V frames_1085_4718) {
  return d_SeqList_dfold(({ V _c = clo_new(lam_4733, 2, 1); CLO_ENV(_c)[0] = globals_1083_4716; _c; }), frames_1085_4718, DONE(head_1084_4717));
}
V d_Global_dprim_uof(V e_790_4734) {
  return ({ V scrut3777_4735 = e_790_4734; ({ V _r = 0; V m_4736 = scrut3777_4735; switch (tag_of(m_4736)) { case 0: { V _m_4736_a0_4737 = FLD(m_4736, 0); _r = ({ V p3778_4738 = _m_4736_a0_4737; NONE; }); break; } case 1: { V _m_4736_a0_4739 = FLD(m_4736, 0); _r = ({ V p3779_4740 = _m_4736_a0_4739; NONE; }); break; } case 2: { V _m_4736_a0_4741 = FLD(m_4736, 0); _r = ({ V p3780_4742 = _m_4736_a0_4741; SOME(p3780_4742); }); break; } default: rt_panic("match: no case at kernel:2747"); } _r; }); });
}
V d_Global_dfind_uprim(V name_819_4743, V globals_820_4744) {
  return ({ V _r = 0; V m_4745 = d_Global_dfind(name_819_4743, globals_820_4744); if (((m_4745) == NONE)) {  _r = ({ V __4746 = UNIT; NONE; }); } else if (((m_4745) != NONE)) { V _m_4745_a0_4747 = FLD(m_4745, 0); _r = ({ V item3782_4748 = _m_4745_a0_4747; d_Global_dprim_uof(item3782_4748); }); } else rt_panic("match: no case at kernel:2750"); _r; });
}
V d_Eval_dhead_uprim(V globals_1042_4749, V h_1043_4750) {
  return ({ V scrut3772_4751 = h_1043_4750; ({ V _r = 0; V m_4752 = scrut3772_4751; switch (tag_of(m_4752)) { case 0: { V _m_4752_a0_4753 = FLD(m_4752, 0); _r = ({ V p3773_4754 = _m_4752_a0_4753; NONE; }); break; } case 1: { V _m_4752_a0_4755 = FLD(m_4752, 0); _r = ({ V p3774_4756 = _m_4752_a0_4755; ({ V _r = 0; V m_4757 = d_Global_dfind_uprim(p3774_4756, globals_1042_4749); if (((m_4757) == NONE)) {  _r = ({ V __4758 = UNIT; NONE; }); } else if (((m_4757) != NONE)) { V _m_4757_a0_4759 = FLD(m_4757, 0); _r = ({ V item3784_4760 = _m_4757_a0_4759; SOME(({ V local3776_4761 = item3784_4760; d_Get_dGlobal_dPrim_uentry_dprim(local3776_4761); })); }); } else rt_panic("match: no case at kernel:2754"); _r; }); }); break; } default: rt_panic("match: no case at kernel:2754"); } _r; }); });
}
V d_Value_das_ulit(V v_468_4762) {
  return ({ V scrut3817_4763 = v_468_4762; ({ V _r = 0; V m_4764 = scrut3817_4763; switch (tag_of(m_4764)) { case 0: { V _m_4764_a0_4765 = FLD(m_4764, 0); _r = ({ V p3818_4766 = _m_4764_a0_4765; NONE; }); break; } case 1: { V _m_4764_a0_4767 = FLD(m_4764, 0); V _m_4764_a1_4768 = FLD(m_4764, 1); V _m_4764_a2_4769 = FLD(m_4764, 2); _r = ({ V p3819_4770 = _m_4764_a0_4767; ({ V p3820_4771 = _m_4764_a1_4768; ({ V p3821_4772 = _m_4764_a2_4769; NONE; }); }); }); break; } case 2: { V _m_4764_a0_4773 = FLD(m_4764, 0); V _m_4764_a1_4774 = FLD(m_4764, 1); V _m_4764_a2_4775 = FLD(m_4764, 2); _r = ({ V p3822_4776 = _m_4764_a0_4773; ({ V p3823_4777 = _m_4764_a1_4774; ({ V p3824_4778 = _m_4764_a2_4775; NONE; }); }); }); break; } case 3: { V _m_4764_a0_4779 = FLD(m_4764, 0); V _m_4764_a1_4780 = FLD(m_4764, 1); V _m_4764_a2_4781 = FLD(m_4764, 2); _r = ({ V p3825_4782 = _m_4764_a0_4779; ({ V p3826_4783 = _m_4764_a1_4780; ({ V p3827_4784 = _m_4764_a2_4781; NONE; }); }); }); break; } case 4: { V _m_4764_a0_4785 = FLD(m_4764, 0); V _m_4764_a1_4786 = FLD(m_4764, 1); _r = ({ V p3828_4787 = _m_4764_a0_4785; ({ V p3829_4788 = _m_4764_a1_4786; NONE; }); }); break; } case 5: { V _m_4764_a0_4789 = FLD(m_4764, 0); _r = ({ V p3830_4790 = _m_4764_a0_4789; SOME(p3830_4790); }); break; } case 6: { V _m_4764_a0_4791 = FLD(m_4764, 0); V _m_4764_a1_4792 = FLD(m_4764, 1); _r = ({ V p3831_4793 = _m_4764_a0_4791; ({ V p3832_4794 = _m_4764_a1_4792; NONE; }); }); break; } default: rt_panic("match: no case at kernel:2758"); } _r; }); });
}
V d_Eval_dspine_uliterals(V sp_1046_4795) {
  return d_SeqList_dfold(clo_new(lam_4831, 2, 0), sp_1046_4795, SOME(NIL));
}
V d_Prim_darity(V p_303_4832) {
  return ({ V scrut3843_4833 = p_303_4832; ({ V _r = 0; V m_4834 = scrut3843_4833; switch (tag_of(m_4834)) { case 0: {  _r = ({ V __4835 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 1: {  _r = ({ V __4836 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 2: {  _r = ({ V __4837 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 3: {  _r = ({ V __4838 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } case 4: {  _r = ({ V __4839 = UNIT; d_Big_dof_unat(NAT_SMALL(2ull)); }); break; } default: rt_panic("match: no case at kernel:2767"); } _r; }); });
}
V d_Prim_das_unat(V l_651_4840) {
  return ({ V scrut3863_4841 = l_651_4840; ({ V _r = 0; V m_4842 = scrut3863_4841; switch (tag_of(m_4842)) { case 0: { V _m_4842_a0_4843 = FLD(m_4842, 0); _r = ({ V p3864_4844 = _m_4842_a0_4843; NONE; }); break; } case 1: { V _m_4842_a0_4845 = FLD(m_4842, 0); _r = ({ V p3865_4846 = _m_4842_a0_4845; ((d_Big_dis_ult(d_Bignum_dsign(p3865_4846), d_Big_dzero())) != FALSE_V ? NONE : SOME(p3865_4846)); }); break; } default: rt_panic("match: no case at kernel:2771"); } _r; }); });
}
V d_Prim_dtwo_unats(V args_837_4847) {
  return ({ V local3849_4848 = d_Rules_dtwo_uof(args_837_4847); ({ V local3853_4849 = local3849_4848; ({ V local3855_4850 = clo_new(lam_4868, 1, 0); ({ V _r = 0; V m_4869 = local3853_4849; if (((m_4869) == NONE)) {  _r = ({ V __4870 = UNIT; NONE; }); } else if (((m_4869) != NONE)) { V _m_4869_a0_4871 = FLD(m_4869, 0); _r = ({ V item3857_4872 = _m_4869_a0_4871; ap(local3855_4850, item3857_4872); }); } else rt_panic("match: no case at kernel:2774"); _r; }); }); }); });
}
V d_Rules_dbool_uvalue(V b_808_4873) {
  return rt_ctor3(3, rt_ctor1(1, d_Big_dof_unat(NAT_SMALL(2ull))), rt_ctor1(1, ((b_808_4873) != FALSE_V ? d_Big_done() : d_Big_dzero())), CON(rt_ctor2(4, rt_ctor1(1, d_Big_dzero()), NIL), NIL));
}
V d_Bignum_dcompare(V left_443_4874, V right_444_4875) {
  return d_Big_dcompare(left_443_4874, right_444_4875);
}
V d_Prim_dcompare_uop(V p_832_4876) {
  return ({ V scrut3892_4877 = p_832_4876; ({ V _r = 0; V m_4878 = scrut3892_4877; switch (tag_of(m_4878)) { case 0: {  _r = ({ V __4879 = UNIT; NONE; }); break; } case 1: {  _r = ({ V __4880 = UNIT; NONE; }); break; } case 2: {  _r = ({ V __4881 = UNIT; NONE; }); break; } case 3: {  _r = ({ V __4882 = UNIT; SOME(clo_new(w_Bignum_dequal, 2, 0)); }); break; } case 4: {  _r = ({ V __4883 = UNIT; SOME(clo_new(lam_4886, 2, 0)); }); break; } default: rt_panic("match: no case at kernel:2785"); } _r; }); });
}
V d_Prim_dadd(V a_813_4887, V b_814_4888) {
  return DONE(d_Bignum_dadd(a_813_4887, b_814_4888));
}
V d_Bignum_dsub(V left_458_4889, V right_459_4890) {
  return ((d_Big_dis_ule(d_Bignum_dcompare(left_458_4889, right_459_4890), d_Big_dzero())) != FALSE_V ? d_Big_dzero() : d_Big_dsub(left_458_4889, right_459_4890));
}
V d_Prim_dsub(V a_821_4891, V b_822_4892) {
  return DONE(d_Bignum_dsub(a_821_4891, b_822_4892));
}
V d_Prim_dmul(V a_825_4893, V b_826_4894) {
  return DONE(d_Bignum_dmul(a_825_4893, b_826_4894));
}
V d_Prim_darith(V p_829_4895) {
  return ({ V scrut3910_4896 = p_829_4895; ({ V _r = 0; V m_4897 = scrut3910_4896; switch (tag_of(m_4897)) { case 0: {  _r = ({ V __4898 = UNIT; SOME(clo_new(w_Prim_dadd, 2, 0)); }); break; } case 1: {  _r = ({ V __4899 = UNIT; SOME(clo_new(w_Prim_dsub, 2, 0)); }); break; } case 2: {  _r = ({ V __4900 = UNIT; SOME(clo_new(w_Prim_dmul, 2, 0)); }); break; } case 3: {  _r = ({ V __4901 = UNIT; NONE; }); break; } case 4: {  _r = ({ V __4902 = UNIT; NONE; }); break; } default: rt_panic("match: no case at kernel:2801"); } _r; }); });
}
V d_Prim_dreduce(V p_869_4903, V args_870_4904) {
  return ({ V local3915_4905 = ({ V local3902_4906 = d_Prim_dtwo_unats(args_870_4904); ({ V _r = 0; V m_4907 = local3902_4906; if (((m_4907) == NONE)) {  _r = ({ V __4908 = UNIT; NONE; }); } else if (((m_4907) != NONE)) { V _m_4907_a0_4909 = FLD(m_4907, 0); _r = ({ V value_4910 = _m_4907_a0_4909; ({ V local3904_4911 = value_4910; ({ V scrut3905_4912 = local3904_4911; ({ V _r = 0; V m_4913 = scrut3905_4912; if ((tag_of(m_4913) == 0)) { V _m_4913_a0_4914 = FLD(m_4913, 0); V _m_4913_a1_4915 = FLD(m_4913, 1); _r = ({ V p3906_4916 = _m_4913_a0_4914; ({ V p3907_4917 = _m_4913_a1_4915; ({ V _r = 0; V m_4918 = d_Prim_darith(p_869_4903); if (((m_4918) == NONE)) {  _r = ({ V __4919 = UNIT; NONE; }); } else if (((m_4918) != NONE)) { V _m_4918_a0_4920 = FLD(m_4918, 0); _r = ({ V item3912_4921 = _m_4918_a0_4920; SOME(({ V local3909_4922 = item3912_4921; ap2(local3909_4922, p3906_4916, p3907_4917); })); }); } else rt_panic("match: no case at kernel:2805"); _r; }); }); }); } else rt_panic("match: no case at kernel:2805"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2804"); _r; }); }); ({ V _r = 0; V m_4923 = local3915_4905; if (((m_4923) == NONE)) {  _r = ({ V __4924 = UNIT; DONE(NONE); }); } else if (((m_4923) != NONE)) { V _m_4923_a0_4925 = FLD(m_4923, 0); _r = ({ V value_4926 = _m_4923_a0_4925; ({ V local3917_4927 = value_4926; ({ V _r = 0; V m_4928 = local3917_4927; switch (tag_of(m_4928)) { case 1: { V _m_4928_a0_4929 = FLD(m_4928, 0); _r = ({ V item3920_4930 = _m_4928_a0_4929; DONE(({ V local3919_4931 = item3920_4930; SOME(rt_ctor1(1, local3919_4931)); })); }); break; } case 0: { V _m_4928_a0_4932 = FLD(m_4928, 0); _r = ({ V item3921_4933 = _m_4928_a0_4932; FAIL(item3921_4933); }); break; } default: rt_panic("match: no case at kernel:2804"); } _r; }); }); }); } else rt_panic("match: no case at kernel:2804"); _r; }); });
}
V d_Prim_dapply(V p_899_4934, V args_900_4935) {
  return ({ V scrut3899_4936 = ({ V local3876_4937 = d_Prim_dtwo_unats(args_900_4935); ({ V local3880_4938 = local3876_4937; ({ V local3882_4939 = ({ V _c = clo_new(lam_4952, 1, 1); CLO_ENV(_c)[0] = p_899_4934; _c; }); ({ V _r = 0; V m_4953 = local3880_4938; if (((m_4953) == NONE)) {  _r = ({ V __4954 = UNIT; NONE; }); } else if (((m_4953) != NONE)) { V _m_4953_a0_4955 = FLD(m_4953, 0); _r = ({ V item3884_4956 = _m_4953_a0_4955; ap(local3882_4939, item3884_4956); }); } else rt_panic("match: no case at kernel:2808"); _r; }); }); }); }); ({ V local3924_4957 = d_Prim_dreduce(p_899_4934, args_900_4935); ({ V _r = 0; V m_4958 = local3924_4957; switch (tag_of(m_4958)) { case 1: { V _m_4958_a0_4959 = FLD(m_4958, 0); _r = ({ V item3929_4960 = _m_4958_a0_4959; DONE(({ V local3926_4961 = item3929_4960; ({ V _r = 0; V m_4962 = local3926_4961; if (((m_4962) == NONE)) {  _r = ({ V __4963 = UNIT; scrut3899_4936; }); } else if (((m_4962) != NONE)) { V _m_4962_a0_4964 = FLD(m_4962, 0); _r = ({ V value_4965 = _m_4962_a0_4964; ({ V local3928_4966 = value_4965; SOME(rt_ctor1(5, local3928_4966)); }); }); } else rt_panic("match: no case at kernel:2810"); _r; }); })); }); break; } case 0: { V _m_4958_a0_4967 = FLD(m_4958, 0); _r = ({ V item3930_4968 = _m_4958_a0_4967; FAIL(item3930_4968); }); break; } default: rt_panic("match: no case at kernel:2810"); } _r; }); }); });
}
V d_Eval_dprim_ustep(V globals_987_4969, V v_988_4970) {
  return ({ V local3766_4971 = d_Value_das_uneutral(v_988_4970); ({ V _r = 0; V m_4972 = local3766_4971; if (((m_4972) == NONE)) {  _r = ({ V __4973 = UNIT; DONE(v_988_4970); }); } else if (((m_4972) != NONE)) { V _m_4972_a0_4974 = FLD(m_4972, 0); _r = ({ V value_4975 = _m_4972_a0_4974; ({ V local3768_4976 = value_4975; ({ V scrut3769_4977 = local3768_4976; ({ V _r = 0; V m_4978 = scrut3769_4977; if ((tag_of(m_4978) == 0)) { V _m_4978_a0_4979 = FLD(m_4978, 0); V _m_4978_a1_4980 = FLD(m_4978, 1); _r = ({ V p3770_4981 = _m_4978_a0_4979; ({ V p3771_4982 = _m_4978_a1_4980; ({ V local3787_4983 = d_Eval_dhead_uprim(globals_987_4969, p3770_4981); ({ V _r = 0; V m_4984 = local3787_4983; if (((m_4984) == NONE)) {  _r = ({ V __4985 = UNIT; DONE(v_988_4970); }); } else if (((m_4984) != NONE)) { V _m_4984_a0_4986 = FLD(m_4984, 0); _r = ({ V value_4987 = _m_4984_a0_4986; ({ V local3789_4988 = value_4987; ({ V local3840_4989 = d_Eval_dspine_uliterals(p3771_4982); ({ V _r = 0; V m_4990 = local3840_4989; if (((m_4990) == NONE)) {  _r = ({ V __4991 = UNIT; DONE(v_988_4970); }); } else if (((m_4990) != NONE)) { V _m_4990_a0_4992 = FLD(m_4990, 0); _r = ({ V value_4993 = _m_4990_a0_4992; ({ V local3842_4994 = value_4993; ((d_Big_dis_ueq(d_Big_dof_unat(list_length(local3842_4994)), d_Prim_darity(local3789_4988))) != FALSE_V ? ({ V _r = 0; V m_4995 = d_Prim_dapply(local3789_4988, local3842_4994); switch (tag_of(m_4995)) { case 1: { V _m_4995_a0_4996 = FLD(m_4995, 0); _r = ({ V item3931_4997 = _m_4995_a0_4996; DONE(({ V local3846_4998 = item3931_4997; maybe_default(local3846_4998, v_988_4970); })); }); break; } case 0: { V _m_4995_a0_4999 = FLD(m_4995, 0); _r = ({ V item3932_5000 = _m_4995_a0_4999; FAIL(item3932_5000); }); break; } default: rt_panic("match: no case at kernel:2814"); } _r; }) : DONE(v_988_4970)); }); }); } else rt_panic("match: no case at kernel:2814"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2814"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2814"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2813"); _r; }); });
}
V d_Eval_dwhnf(V globals_1056_5001, V v_1057_5002) {
  return ({ V t_5003 = d_Eval_dprim_ustep(globals_1056_5001, v_1057_5002); V _r; if (tag_of(t_5003) == 0) _r = t_5003; else { V bound3649_5004 = FLD(t_5003, 0); _r = ({ V scrut3702_5005 = ({ V local3652_5006 = d_Value_das_uneutral(bound3649_5004); ({ V local3656_5007 = local3652_5006; ({ V local3658_5008 = ({ V _c = clo_new(lam_5043, 1, 1); CLO_ENV(_c)[0] = globals_1056_5001; _c; }); ({ V _r = 0; V m_5044 = local3656_5007; if (((m_5044) == NONE)) {  _r = ({ V __5045 = UNIT; NONE; }); } else if (((m_5044) != NONE)) { V _m_5044_a0_5046 = FLD(m_5044, 0); _r = ({ V item3660_5047 = _m_5044_a0_5046; ap(local3658_5008, item3660_5047); }); } else rt_panic("match: no case at kernel:2819"); _r; }); }); }); }); ({ V local3705_5048 = scrut3702_5005; ({ V _r = 0; V m_5049 = local3705_5048; if (((m_5049) == NONE)) {  _r = ({ V __5050 = UNIT; DONE(bound3649_5004); }); } else if (((m_5049) != NONE)) { V _m_5049_a0_5051 = FLD(m_5049, 0); _r = ({ V value_5052 = _m_5049_a0_5051; ({ V local3707_5053 = value_5052; ({ V scrut3708_5054 = local3707_5053; ({ V _r = 0; V m_5055 = scrut3708_5054; if ((tag_of(m_5055) == 0)) { V _m_5055_a0_5056 = FLD(m_5055, 0); V _m_5055_a1_5057 = FLD(m_5055, 1); V _m_5055_a2_5058 = FLD(m_5055, 2); _r = ({ V p3709_5059 = _m_5055_a0_5056; ({ V p3710_5060 = _m_5055_a1_5057; ({ V p3711_5061 = _m_5055_a2_5058; ((d_Eval_dguarded_uframe(p3710_5060, p3711_5061)) != FALSE_V ? ({ V t_5062 = d_Eval_deval(globals_1056_5001, NIL, p3709_5059); V _r; if (tag_of(t_5062) == 0) _r = t_5062; else { V bound3745_5063 = FLD(t_5062, 0); _r = d_Eval_dreplay(globals_1056_5001, bound3745_5063, p3711_5061); } _r; }) : DONE(bound3649_5004)); }); }); }); } else rt_panic("match: no case at kernel:2823"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:2822"); _r; }); }); }); } _r; });
}
V d_Value_das_uuniv(V v_441_5064) {
  return ({ V scrut3962_5065 = v_441_5064; ({ V _r = 0; V m_5066 = scrut3962_5065; switch (tag_of(m_5066)) { case 0: { V _m_5066_a0_5067 = FLD(m_5066, 0); _r = ({ V p3963_5068 = _m_5066_a0_5067; SOME(p3963_5068); }); break; } case 1: { V _m_5066_a0_5069 = FLD(m_5066, 0); V _m_5066_a1_5070 = FLD(m_5066, 1); V _m_5066_a2_5071 = FLD(m_5066, 2); _r = ({ V p3964_5072 = _m_5066_a0_5069; ({ V p3965_5073 = _m_5066_a1_5070; ({ V p3966_5074 = _m_5066_a2_5071; NONE; }); }); }); break; } case 2: { V _m_5066_a0_5075 = FLD(m_5066, 0); V _m_5066_a1_5076 = FLD(m_5066, 1); V _m_5066_a2_5077 = FLD(m_5066, 2); _r = ({ V p3967_5078 = _m_5066_a0_5075; ({ V p3968_5079 = _m_5066_a1_5076; ({ V p3969_5080 = _m_5066_a2_5077; NONE; }); }); }); break; } case 3: { V _m_5066_a0_5081 = FLD(m_5066, 0); V _m_5066_a1_5082 = FLD(m_5066, 1); V _m_5066_a2_5083 = FLD(m_5066, 2); _r = ({ V p3970_5084 = _m_5066_a0_5081; ({ V p3971_5085 = _m_5066_a1_5082; ({ V p3972_5086 = _m_5066_a2_5083; NONE; }); }); }); break; } case 4: { V _m_5066_a0_5087 = FLD(m_5066, 0); V _m_5066_a1_5088 = FLD(m_5066, 1); _r = ({ V p3973_5089 = _m_5066_a0_5087; ({ V p3974_5090 = _m_5066_a1_5088; NONE; }); }); break; } case 5: { V _m_5066_a0_5091 = FLD(m_5066, 0); _r = ({ V p3975_5092 = _m_5066_a0_5091; NONE; }); break; } case 6: { V _m_5066_a0_5093 = FLD(m_5066, 0); V _m_5066_a1_5094 = FLD(m_5066, 1); _r = ({ V p3976_5095 = _m_5066_a0_5093; ({ V p3977_5096 = _m_5066_a1_5094; NONE; }); }); break; } default: rt_panic("match: no case at kernel:2829"); } _r; }); });
}
V d_Eval_dlevel_uof_uann(V globals_984_5097, V env_985_5098, V ty_986_5099) {
  return ({ V local3953_5100 = ({ V _r = 0; V m_5101 = d_Eval_deval(globals_984_5097, env_985_5098, ty_986_5099); switch (tag_of(m_5101)) { case 1: { V _m_5101_a0_5102 = FLD(m_5101, 0); _r = ({ V x_5103 = _m_5101_a0_5102; SOME(x_5103); }); break; } case 0: { V _m_5101_a0_5104 = FLD(m_5101, 0); _r = ({ V __5105 = _m_5101_a0_5104; NONE; }); break; } default: rt_panic("match: no case at kernel:2832"); } _r; }); ({ V local3957_5106 = local3953_5100; ({ V local3959_5107 = clo_new(w_Value_das_uuniv, 1, 0); ({ V _r = 0; V m_5108 = local3957_5106; if (((m_5108) == NONE)) {  _r = ({ V __5109 = UNIT; NONE; }); } else if (((m_5108) != NONE)) { V _m_5108_a0_5110 = FLD(m_5108, 0); _r = ({ V item3961_5111 = _m_5108_a0_5110; ap(local3959_5107, item3961_5111); }); } else rt_panic("match: no case at kernel:2832"); _r; }); }); }); });
}
V d_Eval_dannotate(V globals_968_5112, V env_969_5113, V v_970_5114, V ty_971_5115) {
  return ({ V scrut3981_5116 = ({ V _c = clo_new(lam_5124, 1, 3); CLO_ENV(_c)[0] = globals_968_5112; CLO_ENV(_c)[1] = env_969_5113; CLO_ENV(_c)[2] = ty_971_5115; _c; }); ({ V local3995_5125 = ({ V local3984_5126 = d_Value_das_ulan(v_970_5114); ({ V _r = 0; V m_5127 = local3984_5126; if (((m_5127) == NONE)) {  _r = ({ V __5128 = UNIT; NONE; }); } else if (((m_5127) != NONE)) { V _m_5127_a0_5129 = FLD(m_5127, 0); _r = ({ V item3992_5130 = _m_5127_a0_5129; SOME(({ V local3986_5131 = item3992_5130; ({ V scrut3987_5132 = local3986_5131; ({ V _r = 0; V m_5133 = scrut3987_5132; if ((tag_of(m_5133) == 0)) { V _m_5133_a0_5134 = FLD(m_5133, 0); V _m_5133_a1_5135 = FLD(m_5133, 1); V _m_5133_a2_5136 = FLD(m_5133, 2); _r = ({ V p3988_5137 = _m_5133_a0_5134; ({ V p3989_5138 = _m_5133_a1_5135; ({ V p3990_5139 = _m_5133_a2_5136; rt_ctor3(1, p3988_5137, p3989_5138, ap(scrut3981_5116, p3990_5139)); }); }); }); } else rt_panic("match: no case at kernel:2838"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:2837"); _r; }); }); ({ V _r = 0; V m_5140 = local3995_5125; if (((m_5140) == NONE)) {  _r = ({ V __5141 = UNIT; ({ V local4009_5142 = ({ V local3998_5143 = d_Value_das_uran(v_970_5114); ({ V _r = 0; V m_5144 = local3998_5143; if (((m_5144) == NONE)) {  _r = ({ V __5145 = UNIT; NONE; }); } else if (((m_5144) != NONE)) { V _m_5144_a0_5146 = FLD(m_5144, 0); _r = ({ V item4006_5147 = _m_5144_a0_5146; SOME(({ V local4000_5148 = item4006_5147; ({ V scrut4001_5149 = local4000_5148; ({ V _r = 0; V m_5150 = scrut4001_5149; if ((tag_of(m_5150) == 0)) { V _m_5150_a0_5151 = FLD(m_5150, 0); V _m_5150_a1_5152 = FLD(m_5150, 1); V _m_5150_a2_5153 = FLD(m_5150, 2); _r = ({ V p4002_5154 = _m_5150_a0_5151; ({ V p4003_5155 = _m_5150_a1_5152; ({ V p4004_5156 = _m_5150_a2_5153; rt_ctor3(2, p4002_5154, p4003_5155, ap(scrut3981_5116, p4004_5156)); }); }); }); } else rt_panic("match: no case at kernel:2837"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:2836"); _r; }); }); maybe_default(local4009_5142, v_970_5114); }); }); } else if (((m_5140) != NONE)) { V _m_5140_a0_5157 = FLD(m_5140, 0); _r = ({ V value_5158 = _m_5140_a0_5157; ({ V local4011_5159 = value_5158; local4011_5159; }); }); } else rt_panic("match: no case at kernel:2836"); _r; }); }); });
}
V d_Eval_deval_uglobal(V globals_956_5160, V n_957_5161) {
  return ({ V scrut4014_5162 = rt_ctor2(6, rt_ctor1(1, n_957_5161), NIL); ({ V local4020_5163 = ({ V local4017_5164 = d_Global_dfind(n_957_5161, globals_956_5160); ({ V _r = 0; V m_5165 = local4017_5164; if (((m_5165) == NONE)) {  _r = ({ V __5166 = UNIT; FAIL(rt_ctor1(3, n_957_5161)); }); } else if (((m_5165) != NONE)) { V _m_5165_a0_5167 = FLD(m_5165, 0); _r = ({ V x_5168 = _m_5165_a0_5167; DONE(x_5168); }); } else rt_panic("match: no case at kernel:2842"); _r; }); }); ({ V local4024_5169 = local4020_5163; ({ V local4026_5170 = ({ V _c = clo_new(lam_5178, 1, 2); CLO_ENV(_c)[0] = scrut4014_5162; CLO_ENV(_c)[1] = globals_956_5160; _c; }); ({ V _r = 0; V m_5179 = local4024_5169; switch (tag_of(m_5179)) { case 1: { V _m_5179_a0_5180 = FLD(m_5179, 0); _r = ({ V item4027_5181 = _m_5179_a0_5180; ap(local4026_5170, item4027_5181); }); break; } case 0: { V _m_5179_a0_5182 = FLD(m_5179, 0); _r = ({ V item4028_5183 = _m_5179_a0_5182; FAIL(item4028_5183); }); break; } default: rt_panic("match: no case at kernel:2842"); } _r; }); }); }); }); });
}
V d_Rules_dauto_uword(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_117); rt_root(&memo); done = 1; }
  return memo;
}
V d_Eval_deval(V globals_539_5184, V env_540_5185, V tm_541_5186) {
_top: ;
  return ({ V scrut1995_5187 = tm_541_5186; ({ V _r = 0; V m_5188 = scrut1995_5187; switch (tag_of(m_5188)) { case 0: { V _m_5188_a0_5189 = FLD(m_5188, 0); _r = ({ V p1996_5190 = _m_5188_a0_5189; ({ V local1999_5191 = d_Rules_dat(p1996_5190, env_540_5185); ({ V _r = 0; V m_5192 = local1999_5191; if (((m_5192) == NONE)) {  _r = ({ V __5193 = UNIT; FAIL(rt_ctor1(3, str_concat(CON(((V)&S_118), CON(d_Big_dshow(p1996_5190), CON(((V)&S_119), NIL)))))); }); } else if (((m_5192) != NONE)) { V _m_5192_a0_5194 = FLD(m_5192, 0); _r = ({ V x_5195 = _m_5192_a0_5194; DONE(x_5195); }); } else rt_panic("match: no case at kernel:2849"); _r; }); }); }); break; } case 1: { V _m_5188_a0_5196 = FLD(m_5188, 0); _r = ({ V p2000_5197 = _m_5188_a0_5196; DONE(rt_ctor1(0, p2000_5197)); }); break; } case 2: { V _m_5188_a0_5198 = FLD(m_5188, 0); V _m_5188_a1_5199 = FLD(m_5188, 1); _r = ({ V p2001_5200 = _m_5188_a0_5198; ({ V p2002_5201 = _m_5188_a1_5199; ({ V t_5202 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5204, 1, 2); CLO_ENV(_c)[0] = globals_539_5184; CLO_ENV(_c)[1] = env_540_5185; _c; }), p2001_5200); V _r; if (tag_of(t_5202) == 0) _r = t_5202; else { V bound2004_5205 = FLD(t_5202, 0); _r = DONE(rt_ctor3(1, bound2004_5205, d_Value_dclose(env_540_5185, p2002_5201), NONE)); } _r; }); }); }); break; } case 3: { V _m_5188_a0_5206 = FLD(m_5188, 0); V _m_5188_a1_5207 = FLD(m_5188, 1); _r = ({ V p2027_5208 = _m_5188_a0_5206; ({ V p2028_5209 = _m_5188_a1_5207; ({ V t_5210 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5212, 1, 2); CLO_ENV(_c)[0] = globals_539_5184; CLO_ENV(_c)[1] = env_540_5185; _c; }), p2027_5208); V _r; if (tag_of(t_5210) == 0) _r = t_5210; else { V bound2030_5213 = FLD(t_5210, 0); _r = DONE(rt_ctor3(2, bound2030_5213, d_Value_dclose(env_540_5185, p2028_5209), NONE)); } _r; }); }); }); break; } case 4: { V _m_5188_a0_5214 = FLD(m_5188, 0); V _m_5188_a1_5215 = FLD(m_5188, 1); V _m_5188_a2_5216 = FLD(m_5188, 2); _r = ({ V p2034_5217 = _m_5188_a0_5214; ({ V p2035_5218 = _m_5188_a1_5215; ({ V p2036_5219 = _m_5188_a2_5216; ({ V t_5220 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5222, 1, 2); CLO_ENV(_c)[0] = globals_539_5184; CLO_ENV(_c)[1] = env_540_5185; _c; }), p2034_5217); V _r; if (tag_of(t_5220) == 0) _r = t_5220; else { V bound2038_5223 = FLD(t_5220, 0); _r = ({ V t_5224 = d_Eval_deval_uaddr(globals_539_5184, env_540_5185, p2035_5218); V _r; if (tag_of(t_5224) == 0) _r = t_5224; else { V bound2040_5225 = FLD(t_5224, 0); _r = ({ V t_5226 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_5228, 1, 2); CLO_ENV(_c)[0] = globals_539_5184; CLO_ENV(_c)[1] = env_540_5185; _c; }), p2036_5219)); V _r; if (tag_of(t_5226) == 0) _r = t_5226; else { V bound2042_5229 = FLD(t_5226, 0); _r = DONE(rt_ctor3(3, bound2038_5223, bound2040_5225, bound2042_5229)); } _r; }); } _r; }); } _r; }); }); }); }); break; } case 5: { V _m_5188_a0_5230 = FLD(m_5188, 0); _r = ({ V p2058_5231 = _m_5188_a0_5230; ({ V t_5232 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5234, 1, 2); CLO_ENV(_c)[0] = globals_539_5184; CLO_ENV(_c)[1] = env_540_5185; _c; }), d_Get_dTerm_dElim_de_ushape(p2058_5231)); V _r; if (tag_of(t_5232) == 0) _r = t_5232; else { V bound2060_5235 = FLD(t_5232, 0); _r = ({ V t_5236 = d_Eval_deval(globals_539_5184, env_540_5185, d_Get_dTerm_dElim_de_uscrut(p2058_5231)); V _r; if (tag_of(t_5236) == 0) _r = t_5236; else { V bound2062_5237 = FLD(t_5236, 0); _r = d_Rules_delim_uvalue(d_Eval_dev(globals_539_5184), bound2060_5235, d_Get_dTerm_dElim_de_uscrut_uq(p2058_5231), d_Get_dTerm_dElim_de_umotive(p2058_5231), d_Get_dTerm_dElim_de_ubranches(p2058_5231), env_540_5185, bound2062_5237); } _r; }); } _r; }); }); break; } case 6: { V _m_5188_a0_5238 = FLD(m_5188, 0); V _m_5188_a1_5239 = FLD(m_5188, 1); _r = ({ V p3627_5240 = _m_5188_a0_5238; ({ V p3628_5241 = _m_5188_a1_5239; ({ V t_5242 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5244, 1, 2); CLO_ENV(_c)[0] = globals_539_5184; CLO_ENV(_c)[1] = env_540_5185; _c; }), p3627_5240); V _r; if (tag_of(t_5242) == 0) _r = t_5242; else { V bound3630_5245 = FLD(t_5242, 0); _r = DONE(rt_ctor2(4, bound3630_5245, d_SeqList_dmap(({ V _c = clo_new(lam_5247, 1, 1); CLO_ENV(_c)[0] = env_540_5185; _c; }), p3628_5241))); } _r; }); }); }); break; } case 7: { V _m_5188_a0_5248 = FLD(m_5188, 0); V _m_5188_a1_5249 = FLD(m_5188, 1); V _m_5188_a2_5250 = FLD(m_5188, 2); _r = ({ V p3637_5251 = _m_5188_a0_5248; ({ V p3638_5252 = _m_5188_a1_5249; ({ V p3639_5253 = _m_5188_a2_5250; ({ V t_5254 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5256, 1, 2); CLO_ENV(_c)[0] = globals_539_5184; CLO_ENV(_c)[1] = env_540_5185; _c; }), p3637_5251); V _r; if (tag_of(t_5254) == 0) _r = t_5254; else { V bound3641_5257 = FLD(t_5254, 0); _r = ({ V t_5258 = d_Eval_deval_uaddr(globals_539_5184, env_540_5185, p3638_5252); V _r; if (tag_of(t_5258) == 0) _r = t_5258; else { V bound3643_5259 = FLD(t_5258, 0); _r = ({ V t_5260 = d_Eval_deval(globals_539_5184, env_540_5185, p3639_5253); V _r; if (tag_of(t_5260) == 0) _r = t_5260; else { V bound3645_5261 = FLD(t_5260, 0); _r = ({ V t_5262 = d_Rules_dout_uvalue(d_Eval_dev(globals_539_5184), bound3641_5257, bound3643_5259, bound3645_5261); V _r; if (tag_of(t_5262) == 0) _r = t_5262; else { V bound3647_5263 = FLD(t_5262, 0); _r = d_Eval_dwhnf(globals_539_5184, bound3647_5263); } _r; }); } _r; }); } _r; }); } _r; }); }); }); }); break; } case 8: { V _m_5188_a0_5264 = FLD(m_5188, 0); V _m_5188_a1_5265 = FLD(m_5188, 1); V _m_5188_a2_5266 = FLD(m_5188, 2); V _m_5188_a3_5267 = FLD(m_5188, 3); _r = ({ V p3936_5268 = _m_5188_a0_5264; ({ V p3937_5269 = _m_5188_a1_5265; ({ V p3938_5270 = _m_5188_a2_5266; ({ V p3939_5271 = _m_5188_a3_5267; ({ V t_5272 = d_Eval_deval(globals_539_5184, env_540_5185, p3938_5270); V _r; if (tag_of(t_5272) == 0) _r = t_5272; else { V bound3941_5273 = FLD(t_5272, 0); _r = ({ V a_5274 = CON(bound3941_5273, env_540_5185); V a_5275 = p3939_5271; env_540_5185 = a_5274; tm_541_5186 = a_5275;  goto _top; (V)0; }); } _r; }); }); }); }); }); break; } case 9: { V _m_5188_a0_5276 = FLD(m_5188, 0); V _m_5188_a1_5277 = FLD(m_5188, 1); _r = ({ V p3942_5278 = _m_5188_a0_5276; ({ V p3943_5279 = _m_5188_a1_5277; ({ V t_5280 = d_Eval_deval(globals_539_5184, env_540_5185, p3942_5278); V _r; if (tag_of(t_5280) == 0) _r = t_5280; else { V bound3945_5281 = FLD(t_5280, 0); _r = DONE(d_Eval_dannotate(globals_539_5184, env_540_5185, bound3945_5281, p3943_5279)); } _r; }); }); }); break; } case 10: { V _m_5188_a0_5282 = FLD(m_5188, 0); _r = ({ V p4013_5283 = _m_5188_a0_5282; d_Eval_deval_uglobal(globals_539_5184, p4013_5283); }); break; } case 11: { V _m_5188_a0_5284 = FLD(m_5188, 0); _r = ({ V p4037_5285 = _m_5188_a0_5284; DONE(rt_ctor1(5, p4037_5285)); }); break; } case 12: {  _r = ({ V __5286 = UNIT; FAIL(rt_ctor1(0, d_Rules_dauto_uword())); }); break; } default: rt_panic("match: no case at kernel:2849"); } _r; }); });
}
V d_Eval_dquote_uformer(V globals_1122_5287, V size_1123_5288, V s_1124_5289, V dclo_1125_5290, V u_1126_5291, V build_1127_5292) {
  return ({ V t_5293 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5295, 1, 2); CLO_ENV(_c)[0] = globals_1122_5287; CLO_ENV(_c)[1] = size_1123_5288; _c; }), s_1124_5289); V _r; if (tag_of(t_5293) == 0) _r = t_5293; else { V bound4059_5296 = FLD(t_5293, 0); _r = ({ V _r = 0; V m_5297 = d_Rules_drules(s_1124_5289); switch (tag_of(m_5297)) { case 1: { V _m_5297_a0_5298 = FLD(m_5297, 0); _r = ({ V item4077_5299 = _m_5297_a0_5298; ({ V local4062_5300 = item4077_5299; ({ V scrut4063_5301 = ap(d_Get_dRules_dRule_upack_ddiagram_uarity(local4062_5300), s_1124_5289); ({ V scrut4066_5302 = d_SeqList_dinit(scrut4063_5301, ({ V _c = clo_new(lam_5304, 1, 1); CLO_ENV(_c)[0] = size_1123_5288; _c; })); ({ V t_5305 = d_Rules_dopen_uclosure(d_Eval_dev(globals_1122_5287), dclo_1125_5290, scrut4066_5302); V _r; if (tag_of(t_5305) == 0) _r = t_5305; else { V bound4068_5306 = FLD(t_5305, 0); _r = ({ V t_5307 = d_Eval_dquote(globals_1122_5287, d_NativeInt_dadd(size_1123_5288, scrut4063_5301), bound4068_5306); V _r; if (tag_of(t_5307) == 0) _r = t_5307; else { V bound4070_5308 = FLD(t_5307, 0); _r = ({ V scrut4071_5309 = ap(build_1127_5292, rt_ctor2(0, bound4059_5296, bound4070_5308)); DONE(({ V local4074_5310 = u_1126_5291; ({ V _r = 0; V m_5311 = local4074_5310; if (((m_5311) == NONE)) {  _r = ({ V __5312 = UNIT; scrut4071_5309; }); } else if (((m_5311) != NONE)) { V _m_5311_a0_5313 = FLD(m_5311, 0); _r = ({ V value_5314 = _m_5311_a0_5313; ({ V local4076_5315 = value_5314; rt_ctor2(9, scrut4071_5309, rt_ctor1(1, local4076_5315)); }); }); } else rt_panic("match: no case at kernel:2882"); _r; }); })); }); } _r; }); } _r; }); }); }); }); }); break; } case 0: { V _m_5297_a0_5316 = FLD(m_5297, 0); _r = ({ V item4078_5317 = _m_5297_a0_5316; FAIL(item4078_5317); }); break; } default: rt_panic("match: no case at kernel:2876"); } _r; }); } _r; });
}
V d_Eval_dquote_uaddr(V globals_1145_5318, V size_1146_5319, V a_1147_5320) {
  return ({ V scrut4103_5321 = a_1147_5320; ({ V _r = 0; V m_5322 = scrut4103_5321; switch (tag_of(m_5322)) { case 0: { V _m_5322_a0_5323 = FLD(m_5322, 0); V _m_5322_a1_5324 = FLD(m_5322, 1); _r = ({ V p4104_5325 = _m_5322_a0_5323; ({ V p4105_5326 = _m_5322_a1_5324; ({ V _r = 0; V m_5327 = d_Eval_dquote(globals_1145_5318, size_1146_5319, p4105_5326); switch (tag_of(m_5327)) { case 1: { V _m_5327_a0_5328 = FLD(m_5327, 0); _r = ({ V item4108_5329 = _m_5327_a0_5328; DONE(({ V local4107_5330 = item4108_5329; rt_ctor2(0, p4104_5325, local4107_5330); })); }); break; } case 0: { V _m_5327_a0_5331 = FLD(m_5327, 0); _r = ({ V item4109_5332 = _m_5327_a0_5331; FAIL(item4109_5332); }); break; } default: rt_panic("match: no case at kernel:2886"); } _r; }); }); }); break; } case 1: { V _m_5322_a0_5333 = FLD(m_5322, 0); _r = ({ V p4110_5334 = _m_5322_a0_5333; DONE(rt_ctor1(1, p4110_5334)); }); break; } case 2: { V _m_5322_a0_5335 = FLD(m_5322, 0); _r = ({ V p4111_5336 = _m_5322_a0_5335; DONE(rt_ctor1(2, p4111_5336)); }); break; } default: rt_panic("match: no case at kernel:2886"); } _r; }); });
}
V d_Eval_dquote_uleg(V globals_1137_5337, V size_1138_5338, V lg_1139_5339) {
  return ({ V scrut4124_5340 = d_Big_dof_unat(list_length(d_Get_dValue_dVleg_dvl_ubinders(lg_1139_5339))); ({ V scrut4127_5341 = d_SeqList_dinit(scrut4124_5340, ({ V _c = clo_new(lam_5343, 1, 1); CLO_ENV(_c)[0] = size_1138_5338; _c; })); ({ V t_5344 = d_Rules_dopen_uclosure(d_Eval_dev(globals_1137_5337), d_Get_dValue_dVleg_dvl_uclo(lg_1139_5339), scrut4127_5341); V _r; if (tag_of(t_5344) == 0) _r = t_5344; else { V bound4129_5345 = FLD(t_5344, 0); _r = ({ V t_5346 = d_Eval_dquote(globals_1137_5337, d_NativeInt_dadd(size_1138_5338, scrut4124_5340), bound4129_5345); V _r; if (tag_of(t_5346) == 0) _r = t_5346; else { V bound4131_5347 = FLD(t_5346, 0); _r = DONE(rt_ctor2(0, d_Get_dValue_dVleg_dvl_ubinders(lg_1139_5339), bound4131_5347)); } _r; }); } _r; }); }); });
}
V d_Eval_dquote_uneutral(V globals_1153_5348, V size_1154_5349, V h_1155_5350, V sp_1156_5351) {
  return ({ V scrut4141_5352 = ({ V scrut4138_5353 = h_1155_5350; ({ V _r = 0; V m_5354 = scrut4138_5353; switch (tag_of(m_5354)) { case 0: { V _m_5354_a0_5355 = FLD(m_5354, 0); _r = ({ V p4139_5356 = _m_5354_a0_5355; rt_ctor1(0, d_NativeInt_dsub(d_NativeInt_dsub(size_1154_5349, p4139_5356), d_Big_done())); }); break; } case 1: { V _m_5354_a0_5357 = FLD(m_5354, 0); _r = ({ V p4140_5358 = _m_5354_a0_5357; rt_ctor1(10, p4140_5358); }); break; } default: rt_panic("match: no case at kernel:2898"); } _r; }); }); d_SeqList_dfold(({ V _c = clo_new(lam_5381, 2, 2); CLO_ENV(_c)[0] = globals_1153_5348; CLO_ENV(_c)[1] = size_1154_5349; _c; }), list_reverse(sp_1156_5351), DONE(scrut4141_5352)); });
}
V d_Eval_dquote(V globals_1093_5382, V size_1094_5383, V v_1095_5384) {
  return ({ V scrut4048_5385 = v_1095_5384; ({ V _r = 0; V m_5386 = scrut4048_5385; switch (tag_of(m_5386)) { case 0: { V _m_5386_a0_5387 = FLD(m_5386, 0); _r = ({ V p4049_5388 = _m_5386_a0_5387; DONE(rt_ctor1(1, p4049_5388)); }); break; } case 1: { V _m_5386_a0_5389 = FLD(m_5386, 0); V _m_5386_a1_5390 = FLD(m_5386, 1); V _m_5386_a2_5391 = FLD(m_5386, 2); _r = ({ V p4050_5392 = _m_5386_a0_5389; ({ V p4051_5393 = _m_5386_a1_5390; ({ V p4052_5394 = _m_5386_a2_5391; d_Eval_dquote_uformer(globals_1093_5382, size_1094_5383, p4050_5392, p4051_5393, p4052_5394, clo_new(lam_5402, 1, 0)); }); }); }); break; } case 2: { V _m_5386_a0_5403 = FLD(m_5386, 0); V _m_5386_a1_5404 = FLD(m_5386, 1); V _m_5386_a2_5405 = FLD(m_5386, 2); _r = ({ V p4083_5406 = _m_5386_a0_5403; ({ V p4084_5407 = _m_5386_a1_5404; ({ V p4085_5408 = _m_5386_a2_5405; d_Eval_dquote_uformer(globals_1093_5382, size_1094_5383, p4083_5406, p4084_5407, p4085_5408, clo_new(lam_5416, 1, 0)); }); }); }); break; } case 3: { V _m_5386_a0_5417 = FLD(m_5386, 0); V _m_5386_a1_5418 = FLD(m_5386, 1); V _m_5386_a2_5419 = FLD(m_5386, 2); _r = ({ V p4091_5420 = _m_5386_a0_5417; ({ V p4092_5421 = _m_5386_a1_5418; ({ V p4093_5422 = _m_5386_a2_5419; ({ V t_5423 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5425, 1, 2); CLO_ENV(_c)[0] = globals_1093_5382; CLO_ENV(_c)[1] = size_1094_5383; _c; }), p4091_5420); V _r; if (tag_of(t_5423) == 0) _r = t_5423; else { V bound4095_5426 = FLD(t_5423, 0); _r = ({ V t_5427 = d_Eval_dquote_uaddr(globals_1093_5382, size_1094_5383, p4092_5421); V _r; if (tag_of(t_5427) == 0) _r = t_5427; else { V bound4097_5428 = FLD(t_5427, 0); _r = ({ V t_5429 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_5431, 1, 2); CLO_ENV(_c)[0] = globals_1093_5382; CLO_ENV(_c)[1] = size_1094_5383; _c; }), p4093_5422)); V _r; if (tag_of(t_5429) == 0) _r = t_5429; else { V bound4099_5432 = FLD(t_5429, 0); _r = DONE(rt_ctor3(4, bound4095_5426, bound4097_5428, bound4099_5432)); } _r; }); } _r; }); } _r; }); }); }); }); break; } case 4: { V _m_5386_a0_5433 = FLD(m_5386, 0); V _m_5386_a1_5434 = FLD(m_5386, 1); _r = ({ V p4115_5435 = _m_5386_a0_5433; ({ V p4116_5436 = _m_5386_a1_5434; ({ V t_5437 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_5439, 1, 2); CLO_ENV(_c)[0] = globals_1093_5382; CLO_ENV(_c)[1] = size_1094_5383; _c; }), p4115_5435); V _r; if (tag_of(t_5437) == 0) _r = t_5437; else { V bound4118_5440 = FLD(t_5437, 0); _r = ({ V t_5441 = d_Rules_dall_uok(d_SeqList_dmap(({ V _c = clo_new(lam_5443, 1, 2); CLO_ENV(_c)[0] = globals_1093_5382; CLO_ENV(_c)[1] = size_1094_5383; _c; }), p4116_5436)); V _r; if (tag_of(t_5441) == 0) _r = t_5441; else { V bound4120_5444 = FLD(t_5441, 0); _r = DONE(rt_ctor2(6, bound4118_5440, bound4120_5444)); } _r; }); } _r; }); }); }); break; } case 5: { V _m_5386_a0_5445 = FLD(m_5386, 0); _r = ({ V p4135_5446 = _m_5386_a0_5445; DONE(rt_ctor1(11, p4135_5446)); }); break; } case 6: { V _m_5386_a0_5447 = FLD(m_5386, 0); V _m_5386_a1_5448 = FLD(m_5386, 1); _r = ({ V p4136_5449 = _m_5386_a0_5447; ({ V p4137_5450 = _m_5386_a1_5448; d_Eval_dquote_uneutral(globals_1093_5382, size_1094_5383, p4136_5449, p4137_5450); }); }); break; } default: rt_panic("match: no case at kernel:2911"); } _r; }); });
}
V d_Level_dof_uint(V n_341_5451) {
  return ((d_Big_dis_ule(d_Big_dzero(), n_341_5451)) != FALSE_V ? SOME(n_341_5451) : NONE);
}
V d_Rules_dunit_uval(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor2(6, rt_ctor1(1, d_Big_dzero()), NIL); rt_root(&memo); done = 1; }
  return memo;
}
V d_Budget_dexhausted(V b_301_5452) {
  return ap(d_Get_dBudget_dpoll(b_301_5452), UNIT);
}
V d_Check_dbudget_umsg(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_120); rt_root(&memo); done = 1; }
  return memo;
}
V d_Check_dreadable(V mode_493_5453, V q_494_5454) {
  return ((d_Quantity_dequal(mode_493_5453, ((V)0))) != FALSE_V ? TRUE_V : ((d_Quantity_dequal(q_494_5454, ((V)0))) ^ 1u));
}
V d_Quantity_doccurrence(V level_622_5455, V q_623_5456) {
  return ({ V scrut4302_5457 = d_Assoc_dsingleton(level_622_5455, rt_ctor2(0, q_623_5456, q_623_5456)); rt_ctor2(0, SOME(scrut4302_5457), scrut4302_5457); });
}
V d_Level_dsucc(V l_296_5458) {
  return d_NativeInt_dadd(l_296_5458, d_Big_done());
}
V d_Check_dno_uinfer(V what_482_5459) {
  return rt_ctor1(10, str_append(what_482_5459, ((V)&S_121)));
}
V d_Quantity_dinterval(V level_601_5460, V uses_602_5461) {
  return maybe_default(d_Assoc_dfind(clo_new(lam_5464, 2, 0), level_601_5460, uses_602_5461), rt_ctor2(0, ((V)0), ((V)0)));
}
V d_Quantity_dused(V level_683_5465, V uses_684_5466) {
  return ({ V scrut4367_5467 = d_Quantity_dinterval(level_683_5465, d_Get_dQuantity_dUsage_dreads(uses_684_5466)); ({ V _r = 0; V m_5468 = scrut4367_5467; if ((tag_of(m_5468) == 0)) { V _m_5468_a0_5469 = FLD(m_5468, 0); V _m_5468_a1_5470 = FLD(m_5468, 1); _r = ({ V p4368_5471 = _m_5468_a0_5469; ({ V p4369_5472 = _m_5468_a1_5470; ((d_Quantity_dequal(p4369_5472, ((V)0))) ^ 1u); }); }); } else rt_panic("match: no case at kernel:2952"); _r; }); });
}
V d_Check_ddefine(V x_473_5473, V q_474_5474, V ty_475_5475, V v_476_5476, V c_477_5477) {
  return ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dCheck_dCtx_dglobals(c_477_5477); _o->f[1] = CON(v_476_5476, d_Get_dCheck_dCtx_denv(c_477_5477)); _o->f[2] = CON(rt_ctor3(0, x_473_5473, q_474_5474, ty_475_5475), d_Get_dCheck_dCtx_dlocals(c_477_5477)); _o->f[3] = d_NativeInt_dadd(d_Get_dCheck_dCtx_dsize(c_477_5477), d_Big_done()); _o->f[4] = d_Get_dCheck_dCtx_dbudget(c_477_5477); (V)_o; });
}
V d_Quantity_dget(V level_667_5478, V uses_668_5479) {
  return ({ V scrut4399_5480 = d_Quantity_dinterval(level_667_5478, d_Get_dQuantity_dUsage_dreads(uses_668_5479)); ({ V _r = 0; V m_5481 = scrut4399_5480; if ((tag_of(m_5481) == 0)) { V _m_5481_a0_5482 = FLD(m_5481, 0); V _m_5481_a1_5483 = FLD(m_5481, 1); _r = ({ V p4400_5484 = _m_5481_a0_5482; ({ V p4401_5485 = _m_5481_a1_5483; ({ V _r = 0; V m_5486 = d_Get_dQuantity_dUsage_dpaths(uses_668_5479); if (((m_5486) == NONE)) {  _r = ({ V __5487 = UNIT; rt_ctor2(0, ((V)1), d_Quantity_dmaximum(((V)1), p4401_5485)); }); } else if (((m_5486) != NONE)) { V _m_5486_a0_5488 = FLD(m_5486, 0); _r = ({ V value_5489 = _m_5486_a0_5488; ({ V local4404_5490 = value_5489; d_Quantity_dinterval(level_667_5478, local4404_5490); }); }); } else rt_panic("match: no case at kernel:2959"); _r; }); }); }); } else rt_panic("match: no case at kernel:2959"); _r; }); });
}
V d_Quantity_dat_umost_uonce(V level_689_5491, V uses_690_5492) {
  return ({ V scrut4405_5493 = d_Quantity_dget(level_689_5491, uses_690_5492); ({ V _r = 0; V m_5494 = scrut4405_5493; if ((tag_of(m_5494) == 0)) { V _m_5494_a0_5495 = FLD(m_5494, 0); V _m_5494_a1_5496 = FLD(m_5494, 1); _r = ({ V p4406_5497 = _m_5494_a0_5495; ({ V p4407_5498 = _m_5494_a1_5496; ((d_Quantity_dequal(p4407_5498, ((V)2))) ^ 1u); }); }); } else rt_panic("match: no case at kernel:2963"); _r; }); });
}
V d_Quantity_dexactly_uonce(V level_677_5499, V uses_678_5500) {
  return ({ V scrut4408_5501 = d_Quantity_dget(level_677_5499, uses_678_5500); ({ V _r = 0; V m_5502 = scrut4408_5501; if ((tag_of(m_5502) == 0)) { V _m_5502_a0_5503 = FLD(m_5502, 0); V _m_5502_a1_5504 = FLD(m_5502, 1); _r = ({ V p4409_5505 = _m_5502_a0_5503; ({ V p4410_5506 = _m_5502_a1_5504; ((d_Quantity_dequal(p4409_5505, ((V)1))) != FALSE_V ? d_Quantity_dequal(p4410_5506, ((V)1)) : FALSE_V); }); }); } else rt_panic("match: no case at kernel:2967"); _r; }); });
}
V d_Quantity_dremove(V level_673_5507, V uses_674_5508) {
  return rt_ctor2(0, ({ V _r = 0; V m_5509 = d_Get_dQuantity_dUsage_dpaths(uses_674_5508); if (((m_5509) == NONE)) {  _r = ({ V __5510 = UNIT; NONE; }); } else if (((m_5509) != NONE)) { V _m_5509_a0_5511 = FLD(m_5509, 0); _r = ({ V item4416_5512 = _m_5509_a0_5511; SOME(({ V local4414_5513 = item4416_5512; d_Assoc_dremove(clo_new(lam_5516, 2, 0), level_673_5507, local4414_5513); })); }); } else rt_panic("match: no case at kernel:2970"); _r; }), d_Assoc_dremove(clo_new(lam_5519, 2, 0), level_673_5507, d_Get_dQuantity_dUsage_dreads(uses_674_5508)));
}
V d_Check_dclose(V _opt__585_5520, V c_571_5521, V size_572_5522, V mode_573_5523, V uses_574_5524) {
  return ({ V scrut4386_5525 = ({ V scrut4384_5526 = _opt__585_5520; ({ V _r = 0; V m_5527 = scrut4384_5526; if (((m_5527) == NONE)) {  _r = ({ V __5528 = UNIT; FALSE_V; }); } else if (((m_5527) != NONE)) { V _m_5527_a0_5529 = FLD(m_5527, 0); _r = ({ V p4385_5530 = _m_5527_a0_5529; p4385_5530; }); } else rt_panic("match: no case at kernel:2974"); _r; }); }); d_SeqList_dfold(({ V _c = clo_new(lam_5549, 2, 3); CLO_ENV(_c)[0] = size_572_5522; CLO_ENV(_c)[1] = mode_573_5523; CLO_ENV(_c)[2] = scrut4386_5525; _c; }), d_SeqList_dmapi(({ V _c = clo_new(lam_5552, 2, 1); CLO_ENV(_c)[0] = c_571_5521; _c; }), d_Get_dCheck_dCtx_dlocals(c_571_5521)), DONE(uses_574_5524)); });
}
V d_Pp_dnth_uname(V n_293_5553, V names_294_5554) {
_top: ;
  return ({ V scrut4443_5555 = names_294_5554; ({ V _r = 0; V m_5556 = scrut4443_5555; if (((m_5556) == NIL)) {  _r = ({ V __5557 = UNIT; NONE; }); } else if (((m_5556) != NIL)) { V _m_5556_a0_5558 = FLD(m_5556, 0); V _m_5556_a1_5559 = FLD(m_5556, 1); _r = ({ V p4444_5560 = _m_5556_a0_5558; ({ V p4445_5561 = _m_5556_a1_5559; ((d_Big_dis_ueq(n_293_5553, d_Big_dzero())) != FALSE_V ? SOME(p4444_5560) : ({ V a_5562 = d_NativeInt_dsub(n_293_5553, d_Big_done()); V a_5563 = p4445_5561; n_293_5553 = a_5562; names_294_5554 = a_5563;  goto _top; (V)0; })); }); }); } else rt_panic("match: no case at kernel:2983"); _r; }); });
}
V d_Level_dto_ustring(V l_344_5564) {
  return d_Big_dshow(l_344_5564);
}
V d_Pp_dshape(V names_690_5565, V s_697_5566) {
  return ({ V scrut4452_5567 = s_697_5566; ({ V _r = 0; V m_5568 = scrut4452_5567; switch (tag_of(m_5568)) { case 0: { V _m_5568_a0_5569 = FLD(m_5568, 0); V _m_5568_a1_5570 = FLD(m_5568, 1); V _m_5568_a2_5571 = FLD(m_5568, 2); _r = ({ V p4453_5572 = _m_5568_a0_5569; ({ V p4454_5573 = _m_5568_a1_5570; ({ V p4455_5574 = _m_5568_a2_5571; str_concat(CON(((V)&S_126), CON(d_Quantity_dto_ustring(p4453_5572), CON(((V)&S_42), CON(p4454_5573, CON(((V)&S_42), CON(d_Pp_dterm(names_690_5565, p4455_5574), NIL))))))); }); }); }); break; } case 1: { V _m_5568_a0_5575 = FLD(m_5568, 0); _r = ({ V p4456_5576 = _m_5568_a0_5575; str_concat(CON(((V)&S_127), CON(d_Big_dshow(p4456_5576), NIL))); }); break; } case 2: { V _m_5568_a0_5577 = FLD(m_5568, 0); V _m_5568_a1_5578 = FLD(m_5568, 1); _r = ({ V p4457_5579 = _m_5568_a0_5577; ({ V p4458_5580 = _m_5568_a1_5578; str_concat(CON(((V)&S_128), CON(d_Pp_dterm(names_690_5565, p4457_5579), CON(((V)&S_42), CON(d_Pp_dterm(names_690_5565, p4458_5580), NIL))))); }); }); break; } case 3: { V _m_5568_a0_5581 = FLD(m_5568, 0); V _m_5568_a1_5582 = FLD(m_5568, 1); _r = ({ V p4459_5583 = _m_5568_a0_5581; ({ V p4460_5584 = _m_5568_a1_5582; str_concat(CON(((V)&S_129), CON(p4459_5583, CON(((V)&S_130), CON(str_join(d_SeqList_dmap(({ V _c = clo_new(lam_5586, 1, 1); CLO_ENV(_c)[0] = names_690_5565; _c; }), p4460_5584), ((V)&S_131)), CON(((V)&S_132), NIL)))))); }); }); break; } case 4: { V _m_5568_a0_5587 = FLD(m_5568, 0); V _m_5568_a1_5588 = FLD(m_5568, 1); _r = ({ V p4464_5589 = _m_5568_a0_5587; ({ V p4465_5590 = _m_5568_a1_5588; str_concat(CON(((V)&S_133), CON(p4464_5589, CON(((V)&S_130), CON(str_join(d_SeqList_dmap(({ V _c = clo_new(lam_5592, 1, 1); CLO_ENV(_c)[0] = names_690_5565; _c; }), p4465_5590), ((V)&S_131)), CON(((V)&S_132), NIL)))))); }); }); break; } default: rt_panic("match: no case at kernel:2990"); } _r; }); });
}
V d_Pp_dunder(V s_782_5593, V names_783_5594) {
  return ({ V scrut4469_5595 = s_782_5593; ({ V _r = 0; V m_5596 = scrut4469_5595; switch (tag_of(m_5596)) { case 0: { V _m_5596_a0_5597 = FLD(m_5596, 0); V _m_5596_a1_5598 = FLD(m_5596, 1); V _m_5596_a2_5599 = FLD(m_5596, 2); _r = ({ V p4470_5600 = _m_5596_a0_5597; ({ V p4471_5601 = _m_5596_a1_5598; ({ V p4472_5602 = _m_5596_a2_5599; CON(p4471_5601, names_783_5594); }); }); }); break; } case 1: { V _m_5596_a0_5603 = FLD(m_5596, 0); _r = ({ V p4473_5604 = _m_5596_a0_5603; names_783_5594; }); break; } case 2: { V _m_5596_a0_5605 = FLD(m_5596, 0); V _m_5596_a1_5606 = FLD(m_5596, 1); _r = ({ V p4474_5607 = _m_5596_a0_5605; ({ V p4475_5608 = _m_5596_a1_5606; names_783_5594; }); }); break; } case 3: { V _m_5596_a0_5609 = FLD(m_5596, 0); V _m_5596_a1_5610 = FLD(m_5596, 1); _r = ({ V p4476_5611 = _m_5596_a0_5609; ({ V p4477_5612 = _m_5596_a1_5610; names_783_5594; }); }); break; } case 4: { V _m_5596_a0_5613 = FLD(m_5596, 0); V _m_5596_a1_5614 = FLD(m_5596, 1); _r = ({ V p4478_5615 = _m_5596_a0_5613; ({ V p4479_5616 = _m_5596_a1_5614; names_783_5594; }); }); break; } default: rt_panic("match: no case at kernel:2994"); } _r; }); });
}
V d_Pp_daddr(V names_845_5617, V a_846_5618) {
  return ({ V scrut4485_5619 = a_846_5618; ({ V _r = 0; V m_5620 = scrut4485_5619; switch (tag_of(m_5620)) { case 0: { V _m_5620_a0_5621 = FLD(m_5620, 0); V _m_5620_a1_5622 = FLD(m_5620, 1); _r = ({ V p4486_5623 = _m_5620_a0_5621; ({ V p4487_5624 = _m_5620_a1_5622; str_concat(CON(((V)&S_134), CON(d_Quantity_dto_ustring(p4486_5623), CON(((V)&S_42), CON(d_Pp_dterm(names_845_5617, p4487_5624), CON(((V)&S_135), NIL)))))); }); }); break; } case 1: { V _m_5620_a0_5625 = FLD(m_5620, 0); _r = ({ V p4488_5626 = _m_5620_a0_5625; str_concat(CON(((V)&S_136), CON(d_Big_dshow(p4488_5626), CON(((V)&S_135), NIL)))); }); break; } case 2: { V _m_5620_a0_5627 = FLD(m_5620, 0); _r = ({ V p4489_5628 = _m_5620_a0_5627; str_concat(CON(((V)&S_137), CON(p4489_5628, CON(((V)&S_135), NIL)))); }); break; } default: rt_panic("match: no case at kernel:2998"); } _r; }); });
}
V d_Pp_dbinder_unames(V bs_591_5629) {
  return d_SeqList_dmap(clo_new(lam_5637, 1, 0), bs_591_5629);
}
V d_Pp_dpush(V names_663_5638, V added_664_5639) {
  return d_SeqList_dfold(clo_new(lam_5642, 2, 0), added_664_5639, names_663_5638);
}
V d_Pp_dleg(V names_851_5643, V lg_852_5644) {
  return ({ V scrut4511_5645 = d_Pp_dbinder_unames(d_Get_dTerm_dLeg_dl_ubinders(lg_852_5644)); str_concat(CON(str_join(scrut4511_5645, ((V)&S_42)), CON(((V)&S_138), CON(d_Pp_dterm(d_Pp_dpush(names_851_5643, scrut4511_5645), d_Get_dTerm_dLeg_dl_ubody(lg_852_5644)), NIL)))); });
}
V d_Pp_delim(V names_854_5646, V e_855_5647) {
  return ({ V scrut4500_5648 = ({ V local4496_5649 = d_Get_dTerm_dElim_de_umotive(e_855_5647); ({ V _r = 0; V m_5650 = local4496_5649; if (((m_5650) == NONE)) {  _r = ({ V __5651 = UNIT; SNIL; }); } else if (((m_5650) != NONE)) { V _m_5650_a0_5652 = FLD(m_5650, 0); _r = ({ V value_5653 = _m_5650_a0_5652; ({ V local4498_5654 = value_5653; ({ V scrut4499_5655 = list_append(CON(d_Get_dTerm_dMotive_dm_uself(local4498_5654), list_reverse(d_Get_dTerm_dMotive_dm_uidx(local4498_5654))), names_854_5646); str_concat(CON(((V)&S_139), CON(d_Get_dTerm_dMotive_dm_uself(local4498_5654), CON(((V)&S_140), CON(d_Pp_dterm(scrut4499_5655, d_Get_dTerm_dMotive_dm_ubody(local4498_5654)), NIL))))); }); }); }); } else rt_panic("match: no case at kernel:3012"); _r; }); }); ({ V scrut4516_5656 = ({ V _c = clo_new(lam_5664, 1, 1); CLO_ENV(_c)[0] = names_854_5646; _c; }); str_concat(CON(((V)&S_142), CON(d_Pp_dshape(names_854_5646, d_Get_dTerm_dElim_de_ushape(e_855_5647)), CON(((V)&S_42), CON(d_Pp_dterm(names_854_5646, d_Get_dTerm_dElim_de_uscrut(e_855_5647)), CON(scrut4500_5648, CON(((V)&S_143), CON(str_join(d_SeqList_dmap(scrut4516_5656, d_Get_dTerm_dElim_de_ubranches(e_855_5647)), SNIL), CON(((V)&S_135), NIL))))))))); }); });
}
V d_Pp_dliteral(V l_332_5665) {
  return ({ V scrut4533_5666 = l_332_5665; ({ V _r = 0; V m_5667 = scrut4533_5666; switch (tag_of(m_5667)) { case 0: { V _m_5667_a0_5668 = FLD(m_5667, 0); _r = ({ V p4534_5669 = _m_5667_a0_5668; str_append(((V)&S_144), str_append(d_NativeString_descaped(p4534_5669), ((V)&S_144))); }); break; } case 1: { V _m_5667_a0_5670 = FLD(m_5667, 0); _r = ({ V p4535_5671 = _m_5667_a0_5670; d_Bignum_dto_ustring(p4535_5671); }); break; } default: rt_panic("match: no case at kernel:3020"); } _r; }); });
}
V d_Pp_dterm(V names_785_5672, V tm_786_5673) {
  return ({ V scrut4441_5674 = tm_786_5673; ({ V _r = 0; V m_5675 = scrut4441_5674; switch (tag_of(m_5675)) { case 0: { V _m_5675_a0_5676 = FLD(m_5675, 0); _r = ({ V p4442_5677 = _m_5675_a0_5676; ({ V local4448_5678 = d_Pp_dnth_uname(p4442_5677, names_785_5672); maybe_default(local4448_5678, str_concat(CON(((V)&S_145), CON(d_Big_dshow(p4442_5677), NIL)))); }); }); break; } case 1: { V _m_5675_a0_5679 = FLD(m_5675, 0); _r = ({ V p4449_5680 = _m_5675_a0_5679; str_append(((V)&S_146), d_Level_dto_ustring(p4449_5680)); }); break; } case 2: { V _m_5675_a0_5681 = FLD(m_5675, 0); V _m_5675_a1_5682 = FLD(m_5675, 1); _r = ({ V p4450_5683 = _m_5675_a0_5681; ({ V p4451_5684 = _m_5675_a1_5682; str_concat(CON(((V)&S_147), CON(d_Pp_dshape(names_785_5672, p4450_5683), CON(((V)&S_42), CON(d_Pp_dterm(d_Pp_dunder(p4450_5683, names_785_5672), p4451_5684), CON(((V)&S_135), NIL)))))); }); }); break; } case 3: { V _m_5675_a0_5685 = FLD(m_5675, 0); V _m_5675_a1_5686 = FLD(m_5675, 1); _r = ({ V p4480_5687 = _m_5675_a0_5685; ({ V p4481_5688 = _m_5675_a1_5686; str_concat(CON(((V)&S_148), CON(d_Pp_dshape(names_785_5672, p4480_5687), CON(((V)&S_42), CON(d_Pp_dterm(d_Pp_dunder(p4480_5687, names_785_5672), p4481_5688), CON(((V)&S_135), NIL)))))); }); }); break; } case 4: { V _m_5675_a0_5689 = FLD(m_5675, 0); V _m_5675_a1_5690 = FLD(m_5675, 1); V _m_5675_a2_5691 = FLD(m_5675, 2); _r = ({ V p4482_5692 = _m_5675_a0_5689; ({ V p4483_5693 = _m_5675_a1_5690; ({ V p4484_5694 = _m_5675_a2_5691; str_concat(CON(((V)&S_149), CON(d_Pp_dshape(names_785_5672, p4482_5692), CON(((V)&S_42), CON(d_Pp_daddr(names_785_5672, p4483_5693), CON(((V)&S_130), CON(str_join(d_SeqList_dmap(({ V _c = clo_new(lam_5696, 1, 1); CLO_ENV(_c)[0] = names_785_5672; _c; }), p4484_5694), ((V)&S_131)), CON(((V)&S_150), NIL)))))))); }); }); }); break; } case 5: { V _m_5675_a0_5697 = FLD(m_5675, 0); _r = ({ V p4493_5698 = _m_5675_a0_5697; d_Pp_delim(names_785_5672, p4493_5698); }); break; } case 6: { V _m_5675_a0_5699 = FLD(m_5675, 0); V _m_5675_a1_5700 = FLD(m_5675, 1); _r = ({ V p4517_5701 = _m_5675_a0_5699; ({ V p4518_5702 = _m_5675_a1_5700; str_concat(CON(((V)&S_151), CON(d_Pp_dshape(names_785_5672, p4517_5701), CON(((V)&S_130), CON(str_join(d_SeqList_dmap(({ V _c = clo_new(lam_5704, 1, 1); CLO_ENV(_c)[0] = names_785_5672; _c; }), p4518_5702), ((V)&S_131)), CON(((V)&S_150), NIL)))))); }); }); break; } case 7: { V _m_5675_a0_5705 = FLD(m_5675, 0); V _m_5675_a1_5706 = FLD(m_5675, 1); V _m_5675_a2_5707 = FLD(m_5675, 2); _r = ({ V p4522_5708 = _m_5675_a0_5705; ({ V p4523_5709 = _m_5675_a1_5706; ({ V p4524_5710 = _m_5675_a2_5707; str_concat(CON(((V)&S_152), CON(d_Pp_dshape(names_785_5672, p4522_5708), CON(((V)&S_42), CON(d_Pp_daddr(names_785_5672, p4523_5709), CON(((V)&S_42), CON(d_Pp_dterm(names_785_5672, p4524_5710), CON(((V)&S_135), NIL)))))))); }); }); }); break; } case 8: { V _m_5675_a0_5711 = FLD(m_5675, 0); V _m_5675_a1_5712 = FLD(m_5675, 1); V _m_5675_a2_5713 = FLD(m_5675, 2); V _m_5675_a3_5714 = FLD(m_5675, 3); _r = ({ V p4525_5715 = _m_5675_a0_5711; ({ V p4526_5716 = _m_5675_a1_5712; ({ V p4527_5717 = _m_5675_a2_5713; ({ V p4528_5718 = _m_5675_a3_5714; str_concat(CON(((V)&S_153), CON(p4525_5715, CON(((V)&S_154), CON(d_Pp_dterm(names_785_5672, p4526_5716), CON(((V)&S_155), CON(d_Pp_dterm(names_785_5672, p4527_5717), CON(((V)&S_156), CON(d_Pp_dterm(CON(p4525_5715, names_785_5672), p4528_5718), NIL))))))))); }); }); }); }); break; } case 9: { V _m_5675_a0_5719 = FLD(m_5675, 0); V _m_5675_a1_5720 = FLD(m_5675, 1); _r = ({ V p4529_5721 = _m_5675_a0_5719; ({ V p4530_5722 = _m_5675_a1_5720; str_concat(CON(((V)&S_157), CON(d_Pp_dterm(names_785_5672, p4529_5721), CON(((V)&S_154), CON(d_Pp_dterm(names_785_5672, p4530_5722), CON(((V)&S_135), NIL)))))); }); }); break; } case 10: { V _m_5675_a0_5723 = FLD(m_5675, 0); _r = ({ V p4531_5724 = _m_5675_a0_5723; p4531_5724; }); break; } case 11: { V _m_5675_a0_5725 = FLD(m_5675, 0); _r = ({ V p4532_5726 = _m_5675_a0_5725; d_Pp_dliteral(p4532_5726); }); break; } case 12: {  _r = ({ V __5727 = UNIT; ((V)&S_158); }); break; } default: rt_panic("match: no case at kernel:3024"); } _r; }); });
}
V d_Check_dpp_uvalue(V c_958_5728, V v_959_5729) {
  return ({ V local4540_5730 = ({ V local4437_5731 = d_Eval_dquote(d_Get_dCheck_dCtx_dglobals(c_958_5728), d_Get_dCheck_dCtx_dsize(c_958_5728), v_959_5729); ({ V _r = 0; V m_5732 = local4437_5731; switch (tag_of(m_5732)) { case 1: { V _m_5732_a0_5733 = FLD(m_5732, 0); _r = ({ V item4536_5734 = _m_5732_a0_5733; DONE(({ V local4440_5735 = item4536_5734; d_Pp_dterm(d_Check_dnames_uof(c_958_5728), local4440_5735); })); }); break; } case 0: { V _m_5732_a0_5736 = FLD(m_5732, 0); _r = ({ V item4537_5737 = _m_5732_a0_5736; FAIL(item4537_5737); }); break; } default: rt_panic("match: no case at kernel:3027"); } _r; }); }); ({ V _r = 0; V m_5738 = local4540_5730; switch (tag_of(m_5738)) { case 1: { V _m_5738_a0_5739 = FLD(m_5738, 0); _r = ({ V x_5740 = _m_5738_a0_5739; x_5740; }); break; } case 0: { V _m_5738_a0_5741 = FLD(m_5738, 0); _r = ({ V __5742 = _m_5738_a0_5741; ((V)&S_159); }); break; } default: rt_panic("match: no case at kernel:3027"); } _r; }); });
}
V d_Conv_dplaceholder(void) {
  static V memo; static int done;
  if (!done) { memo = rt_ctor1(0, d_Level_dzero()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Conv_dis_uprop(V ops_774_5743, V ctx_775_5744, V ty_776_5745) {
  return ({ V local4557_5746 = ({ V _r = 0; V m_5747 = ({ V local4544_5748 = ap2(d_Get_dRules_dOps_do_uquote(ops_774_5743), ctx_775_5744, ty_776_5745); ({ V local4548_5749 = local4544_5748; ({ V local4550_5750 = ({ V _c = clo_new(lam_5752, 1, 2); CLO_ENV(_c)[0] = ops_774_5743; CLO_ENV(_c)[1] = ctx_775_5744; _c; }); ({ V _r = 0; V m_5753 = local4548_5749; switch (tag_of(m_5753)) { case 1: { V _m_5753_a0_5754 = FLD(m_5753, 0); _r = ({ V item4551_5755 = _m_5753_a0_5754; ap(local4550_5750, item4551_5755); }); break; } case 0: { V _m_5753_a0_5756 = FLD(m_5753, 0); _r = ({ V item4552_5757 = _m_5753_a0_5756; FAIL(item4552_5757); }); break; } default: rt_panic("match: no case at kernel:3033"); } _r; }); }); }); }); switch (tag_of(m_5747)) { case 1: { V _m_5747_a0_5758 = FLD(m_5747, 0); _r = ({ V x_5759 = _m_5747_a0_5758; SOME(x_5759); }); break; } case 0: { V _m_5747_a0_5760 = FLD(m_5747, 0); _r = ({ V __5761 = _m_5747_a0_5760; NONE; }); break; } default: rt_panic("match: no case at kernel:3033"); } _r; }); ({ V _r = 0; V m_5762 = local4557_5746; if (((m_5762) == NONE)) {  _r = ({ V __5763 = UNIT; FALSE_V; }); } else if (((m_5762) != NONE)) { V _m_5762_a0_5764 = FLD(m_5762, 0); _r = ({ V value_5765 = _m_5762_a0_5764; ({ V local4559_5766 = value_5765; d_Level_dequal(local4559_5766, d_Level_dzero()); }); }); } else rt_panic("match: no case at kernel:3033"); _r; }); });
}
V d_Conv_duniv_ucase(V a_845_5767, V b_846_5768) {
  return ({ V _r = 0; V m_5769 = d_Value_das_uuniv(a_845_5767); if (((m_5769) == NONE)) {  _r = ({ V __5770 = UNIT; NONE; }); } else if (((m_5769) != NONE)) { V _m_5769_a0_5771 = FLD(m_5769, 0); _r = ({ V item4583_5772 = _m_5769_a0_5771; ({ V local4577_5773 = item4583_5772; ({ V _r = 0; V m_5774 = d_Value_das_uuniv(b_846_5768); if (((m_5774) == NONE)) {  _r = ({ V __5775 = UNIT; NONE; }); } else if (((m_5774) != NONE)) { V _m_5774_a0_5776 = FLD(m_5774, 0); _r = ({ V item4581_5777 = _m_5774_a0_5776; SOME(({ V local4579_5778 = item4581_5777; DONE(d_Level_dequal(local4577_5773, local4579_5778)); })); }); } else rt_panic("match: no case at kernel:3036"); _r; }); }); }); } else rt_panic("match: no case at kernel:3036"); _r; });
}
V d_Literal_dequal(V a_453_5779, V b_454_5780) {
  return ({ V scrut4591_5781 = rt_ctor2(0, a_453_5779, b_454_5780); ({ V _r = 0; V m_5782 = scrut4591_5781; if ((tag_of(m_5782) == 0)) { V _m_5782_a0_5783 = FLD(m_5782, 0); V _m_5782_a1_5784 = FLD(m_5782, 1); _r = ({ V p4592_5785 = _m_5782_a0_5783; ({ V p4593_5786 = _m_5782_a1_5784; ({ V _r = 0; V m_5787 = p4592_5785; switch (tag_of(m_5787)) { case 0: { V _m_5787_a0_5788 = FLD(m_5787, 0); _r = ({ V p4594_5789 = _m_5787_a0_5788; ({ V _r = 0; V m_5790 = p4593_5786; switch (tag_of(m_5790)) { case 0: { V _m_5790_a0_5791 = FLD(m_5790, 0); _r = ({ V p4595_5792 = _m_5790_a0_5791; d_NativeString_dequal(p4594_5789, p4595_5792); }); break; } case 1: { V _m_5790_a0_5793 = FLD(m_5790, 0); _r = ({ V p4596_5794 = _m_5790_a0_5793; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:3040"); } _r; }); }); break; } case 1: { V _m_5787_a0_5795 = FLD(m_5787, 0); _r = ({ V p4597_5796 = _m_5787_a0_5795; ({ V _r = 0; V m_5797 = p4593_5786; switch (tag_of(m_5797)) { case 0: { V _m_5797_a0_5798 = FLD(m_5797, 0); _r = ({ V p4598_5799 = _m_5797_a0_5798; FALSE_V; }); break; } case 1: { V _m_5797_a0_5800 = FLD(m_5797, 0); _r = ({ V p4599_5801 = _m_5797_a0_5800; d_Bignum_dequal(p4597_5796, p4599_5801); }); break; } default: rt_panic("match: no case at kernel:3040"); } _r; }); }); break; } default: rt_panic("match: no case at kernel:3040"); } _r; }); }); }); } else rt_panic("match: no case at kernel:3040"); _r; }); });
}
V d_Conv_dlit_ucase(V a_849_5802, V b_850_5803) {
  return ({ V _r = 0; V m_5804 = d_Value_das_ulit(a_849_5802); if (((m_5804) == NONE)) {  _r = ({ V __5805 = UNIT; NONE; }); } else if (((m_5804) != NONE)) { V _m_5804_a0_5806 = FLD(m_5804, 0); _r = ({ V item4603_5807 = _m_5804_a0_5806; ({ V local4588_5808 = item4603_5807; ({ V _r = 0; V m_5809 = d_Value_das_ulit(b_850_5803); if (((m_5809) == NONE)) {  _r = ({ V __5810 = UNIT; NONE; }); } else if (((m_5809) != NONE)) { V _m_5809_a0_5811 = FLD(m_5809, 0); _r = ({ V item4601_5812 = _m_5809_a0_5811; SOME(({ V local4590_5813 = item4601_5812; DONE(d_Literal_dequal(local4588_5808, local4590_5813)); })); }); } else rt_panic("match: no case at kernel:3043"); _r; }); }); }); } else rt_panic("match: no case at kernel:3043"); _r; });
}
V d_Rules_dpayload_ueq(V eq_679_5814, V xs_680_5815, V ys_681_5816) {
_top: ;
  return ({ V scrut4682_5817 = rt_ctor2(0, xs_680_5815, ys_681_5816); ({ V _r = 0; V m_5818 = scrut4682_5817; if ((tag_of(m_5818) == 0)) { V _m_5818_a0_5819 = FLD(m_5818, 0); V _m_5818_a1_5820 = FLD(m_5818, 1); _r = ({ V p4683_5821 = _m_5818_a0_5819; ({ V p4684_5822 = _m_5818_a1_5820; ({ V _r = 0; V m_5823 = p4683_5821; if (((m_5823) == NIL)) {  _r = ({ V __5824 = UNIT; ({ V _r = 0; V m_5825 = p4684_5822; if (((m_5825) == NIL)) {  _r = ({ V __5826 = UNIT; DONE(TRUE_V); }); } else if (((m_5825) != NIL)) { V _m_5825_a0_5827 = FLD(m_5825, 0); V _m_5825_a1_5828 = FLD(m_5825, 1); _r = ({ V p4685_5829 = _m_5825_a0_5827; ({ V p4686_5830 = _m_5825_a1_5828; DONE(FALSE_V); }); }); } else rt_panic("match: no case at kernel:3047"); _r; }); }); } else if (((m_5823) != NIL)) { V _m_5823_a0_5831 = FLD(m_5823, 0); V _m_5823_a1_5832 = FLD(m_5823, 1); _r = ({ V p4687_5833 = _m_5823_a0_5831; ({ V p4688_5834 = _m_5823_a1_5832; ({ V _r = 0; V m_5835 = p4684_5822; if (((m_5835) == NIL)) {  _r = ({ V __5836 = UNIT; DONE(FALSE_V); }); } else if (((m_5835) != NIL)) { V _m_5835_a0_5837 = FLD(m_5835, 0); V _m_5835_a1_5838 = FLD(m_5835, 1); _r = ({ V p4689_5839 = _m_5835_a0_5837; ({ V p4690_5840 = _m_5835_a1_5838; ({ V t_5841 = ap2(eq_679_5814, p4687_5833, p4689_5839); V _r; if (tag_of(t_5841) == 0) _r = t_5841; else { V bound4692_5842 = FLD(t_5841, 0); _r = ((bound4692_5842) != FALSE_V ? ({ V a_5843 = p4688_5834; V a_5844 = p4690_5840; xs_680_5815 = a_5843; ys_681_5816 = a_5844;  goto _top; (V)0; }) : DONE(FALSE_V)); } _r; }); }); }); } else rt_panic("match: no case at kernel:3047"); _r; }); }); }); } else rt_panic("match: no case at kernel:3047"); _r; }); }); }); } else rt_panic("match: no case at kernel:3047"); _r; }); });
}
V d_Rules_dshape_ueq(V eq_689_5845, V a_690_5846, V b_691_5847) {
  return ({ V scrut4633_5848 = rt_ctor2(0, a_690_5846, b_691_5847); ({ V _r = 0; V m_5849 = scrut4633_5848; if ((tag_of(m_5849) == 0)) { V _m_5849_a0_5850 = FLD(m_5849, 0); V _m_5849_a1_5851 = FLD(m_5849, 1); _r = ({ V p4634_5852 = _m_5849_a0_5850; ({ V p4635_5853 = _m_5849_a1_5851; ({ V _r = 0; V m_5854 = p4634_5852; switch (tag_of(m_5854)) { case 0: { V _m_5854_a0_5855 = FLD(m_5854, 0); V _m_5854_a1_5856 = FLD(m_5854, 1); V _m_5854_a2_5857 = FLD(m_5854, 2); _r = ({ V p4636_5858 = _m_5854_a0_5855; ({ V p4637_5859 = _m_5854_a1_5856; ({ V p4638_5860 = _m_5854_a2_5857; ({ V _r = 0; V m_5861 = p4635_5853; switch (tag_of(m_5861)) { case 0: { V _m_5861_a0_5862 = FLD(m_5861, 0); V _m_5861_a1_5863 = FLD(m_5861, 1); V _m_5861_a2_5864 = FLD(m_5861, 2); _r = ({ V p4639_5865 = _m_5861_a0_5862; ({ V p4640_5866 = _m_5861_a1_5863; ({ V p4641_5867 = _m_5861_a2_5864; ((d_Quantity_dequal(p4636_5858, p4639_5865)) != FALSE_V ? ap2(eq_689_5845, p4638_5860, p4641_5867) : DONE(FALSE_V)); }); }); }); break; } case 1: { V _m_5861_a0_5868 = FLD(m_5861, 0); _r = ({ V p4642_5869 = _m_5861_a0_5868; DONE(FALSE_V); }); break; } case 2: { V _m_5861_a0_5870 = FLD(m_5861, 0); V _m_5861_a1_5871 = FLD(m_5861, 1); _r = ({ V p4643_5872 = _m_5861_a0_5870; ({ V p4644_5873 = _m_5861_a1_5871; DONE(FALSE_V); }); }); break; } case 3: { V _m_5861_a0_5874 = FLD(m_5861, 0); V _m_5861_a1_5875 = FLD(m_5861, 1); _r = ({ V p4645_5876 = _m_5861_a0_5874; ({ V p4646_5877 = _m_5861_a1_5875; DONE(FALSE_V); }); }); break; } case 4: { V _m_5861_a0_5878 = FLD(m_5861, 0); V _m_5861_a1_5879 = FLD(m_5861, 1); _r = ({ V p4647_5880 = _m_5861_a0_5878; ({ V p4648_5881 = _m_5861_a1_5879; DONE(FALSE_V); }); }); break; } default: rt_panic("match: no case at kernel:3053"); } _r; }); }); }); }); break; } case 1: { V _m_5854_a0_5882 = FLD(m_5854, 0); _r = ({ V p4649_5883 = _m_5854_a0_5882; ({ V _r = 0; V m_5884 = p4635_5853; switch (tag_of(m_5884)) { case 0: { V _m_5884_a0_5885 = FLD(m_5884, 0); V _m_5884_a1_5886 = FLD(m_5884, 1); V _m_5884_a2_5887 = FLD(m_5884, 2); _r = ({ V p4650_5888 = _m_5884_a0_5885; ({ V p4651_5889 = _m_5884_a1_5886; ({ V p4652_5890 = _m_5884_a2_5887; DONE(FALSE_V); }); }); }); break; } case 1: { V _m_5884_a0_5891 = FLD(m_5884, 0); _r = ({ V p4653_5892 = _m_5884_a0_5891; DONE(d_Big_dis_ueq(p4649_5883, p4653_5892)); }); break; } case 2: { V _m_5884_a0_5893 = FLD(m_5884, 0); V _m_5884_a1_5894 = FLD(m_5884, 1); _r = ({ V p4654_5895 = _m_5884_a0_5893; ({ V p4655_5896 = _m_5884_a1_5894; DONE(FALSE_V); }); }); break; } case 3: { V _m_5884_a0_5897 = FLD(m_5884, 0); V _m_5884_a1_5898 = FLD(m_5884, 1); _r = ({ V p4656_5899 = _m_5884_a0_5897; ({ V p4657_5900 = _m_5884_a1_5898; DONE(FALSE_V); }); }); break; } case 4: { V _m_5884_a0_5901 = FLD(m_5884, 0); V _m_5884_a1_5902 = FLD(m_5884, 1); _r = ({ V p4658_5903 = _m_5884_a0_5901; ({ V p4659_5904 = _m_5884_a1_5902; DONE(FALSE_V); }); }); break; } default: rt_panic("match: no case at kernel:3053"); } _r; }); }); break; } case 2: { V _m_5854_a0_5905 = FLD(m_5854, 0); V _m_5854_a1_5906 = FLD(m_5854, 1); _r = ({ V p4660_5907 = _m_5854_a0_5905; ({ V p4661_5908 = _m_5854_a1_5906; ({ V _r = 0; V m_5909 = p4635_5853; switch (tag_of(m_5909)) { case 0: { V _m_5909_a0_5910 = FLD(m_5909, 0); V _m_5909_a1_5911 = FLD(m_5909, 1); V _m_5909_a2_5912 = FLD(m_5909, 2); _r = ({ V p4662_5913 = _m_5909_a0_5910; ({ V p4663_5914 = _m_5909_a1_5911; ({ V p4664_5915 = _m_5909_a2_5912; DONE(FALSE_V); }); }); }); break; } case 1: { V _m_5909_a0_5916 = FLD(m_5909, 0); _r = ({ V p4665_5917 = _m_5909_a0_5916; DONE(FALSE_V); }); break; } case 2: { V _m_5909_a0_5918 = FLD(m_5909, 0); V _m_5909_a1_5919 = FLD(m_5909, 1); _r = ({ V p4666_5920 = _m_5909_a0_5918; ({ V p4667_5921 = _m_5909_a1_5919; FAIL(rt_ctor1(0, d_Rules_dspar_uword())); }); }); break; } case 3: { V _m_5909_a0_5922 = FLD(m_5909, 0); V _m_5909_a1_5923 = FLD(m_5909, 1); _r = ({ V p4668_5924 = _m_5909_a0_5922; ({ V p4669_5925 = _m_5909_a1_5923; DONE(FALSE_V); }); }); break; } case 4: { V _m_5909_a0_5926 = FLD(m_5909, 0); V _m_5909_a1_5927 = FLD(m_5909, 1); _r = ({ V p4670_5928 = _m_5909_a0_5926; ({ V p4671_5929 = _m_5909_a1_5927; DONE(FALSE_V); }); }); break; } default: rt_panic("match: no case at kernel:3053"); } _r; }); }); }); break; } case 3: { V _m_5854_a0_5930 = FLD(m_5854, 0); V _m_5854_a1_5931 = FLD(m_5854, 1); _r = ({ V p4672_5932 = _m_5854_a0_5930; ({ V p4673_5933 = _m_5854_a1_5931; ({ V _r = 0; V m_5934 = p4635_5853; switch (tag_of(m_5934)) { case 0: { V _m_5934_a0_5935 = FLD(m_5934, 0); V _m_5934_a1_5936 = FLD(m_5934, 1); V _m_5934_a2_5937 = FLD(m_5934, 2); _r = ({ V p4674_5938 = _m_5934_a0_5935; ({ V p4675_5939 = _m_5934_a1_5936; ({ V p4676_5940 = _m_5934_a2_5937; DONE(FALSE_V); }); }); }); break; } case 1: { V _m_5934_a0_5941 = FLD(m_5934, 0); _r = ({ V p4677_5942 = _m_5934_a0_5941; DONE(FALSE_V); }); break; } case 2: { V _m_5934_a0_5943 = FLD(m_5934, 0); V _m_5934_a1_5944 = FLD(m_5934, 1); _r = ({ V p4678_5945 = _m_5934_a0_5943; ({ V p4679_5946 = _m_5934_a1_5944; DONE(FALSE_V); }); }); break; } case 3: { V _m_5934_a0_5947 = FLD(m_5934, 0); V _m_5934_a1_5948 = FLD(m_5934, 1); _r = ({ V p4680_5949 = _m_5934_a0_5947; ({ V p4681_5950 = _m_5934_a1_5948; ((d_NativeString_dequal(p4672_5932, p4680_5949)) != FALSE_V ? d_Rules_dpayload_ueq(eq_689_5845, p4673_5933, p4681_5950) : DONE(FALSE_V)); }); }); break; } case 4: { V _m_5934_a0_5951 = FLD(m_5934, 0); V _m_5934_a1_5952 = FLD(m_5934, 1); _r = ({ V p4693_5953 = _m_5934_a0_5951; ({ V p4694_5954 = _m_5934_a1_5952; DONE(FALSE_V); }); }); break; } default: rt_panic("match: no case at kernel:3053"); } _r; }); }); }); break; } case 4: { V _m_5854_a0_5955 = FLD(m_5854, 0); V _m_5854_a1_5956 = FLD(m_5854, 1); _r = ({ V p4695_5957 = _m_5854_a0_5955; ({ V p4696_5958 = _m_5854_a1_5956; ({ V _r = 0; V m_5959 = p4635_5853; switch (tag_of(m_5959)) { case 0: { V _m_5959_a0_5960 = FLD(m_5959, 0); V _m_5959_a1_5961 = FLD(m_5959, 1); V _m_5959_a2_5962 = FLD(m_5959, 2); _r = ({ V p4697_5963 = _m_5959_a0_5960; ({ V p4698_5964 = _m_5959_a1_5961; ({ V p4699_5965 = _m_5959_a2_5962; DONE(FALSE_V); }); }); }); break; } case 1: { V _m_5959_a0_5966 = FLD(m_5959, 0); _r = ({ V p4700_5967 = _m_5959_a0_5966; DONE(FALSE_V); }); break; } case 2: { V _m_5959_a0_5968 = FLD(m_5959, 0); V _m_5959_a1_5969 = FLD(m_5959, 1); _r = ({ V p4701_5970 = _m_5959_a0_5968; ({ V p4702_5971 = _m_5959_a1_5969; DONE(FALSE_V); }); }); break; } case 3: { V _m_5959_a0_5972 = FLD(m_5959, 0); V _m_5959_a1_5973 = FLD(m_5959, 1); _r = ({ V p4703_5974 = _m_5959_a0_5972; ({ V p4704_5975 = _m_5959_a1_5973; DONE(FALSE_V); }); }); break; } case 4: { V _m_5959_a0_5976 = FLD(m_5959, 0); V _m_5959_a1_5977 = FLD(m_5959, 1); _r = ({ V p4705_5978 = _m_5959_a0_5976; ({ V p4706_5979 = _m_5959_a1_5977; FAIL(rt_ctor1(0, d_Rules_dsnu_uword())); }); }); break; } default: rt_panic("match: no case at kernel:3053"); } _r; }); }); }); break; } default: rt_panic("match: no case at kernel:3053"); } _r; }); }); }); } else rt_panic("match: no case at kernel:3053"); _r; }); });
}
V d_Conv_dformer_ucase(V ops_857_5980, V ctx_858_5981, V sd_859_5982, V a_860_5983, V b_861_5984) {
  return ({ V scrut4608_5985 = ({ V scrut4607_5986 = sd_859_5982; ({ V _r = 0; V m_5987 = scrut4607_5986; switch (tag_of(m_5987)) { case 0: {  _r = ({ V __5988 = UNIT; clo_new(w_Value_das_uran, 1, 0); }); break; } case 1: {  _r = ({ V __5989 = UNIT; clo_new(w_Value_das_ulan, 1, 0); }); break; } default: rt_panic("match: no case at kernel:3057"); } _r; }); }); ({ V _r = 0; V m_5990 = ap(scrut4608_5985, a_860_5983); if (((m_5990) == NONE)) {  _r = ({ V __5991 = UNIT; NONE; }); } else if (((m_5990) != NONE)) { V _m_5990_a0_5992 = FLD(m_5990, 0); _r = ({ V item4713_5993 = _m_5990_a0_5992; ({ V local4610_5994 = item4713_5993; ({ V scrut4611_5995 = local4610_5994; ({ V _r = 0; V m_5996 = scrut4611_5995; if ((tag_of(m_5996) == 0)) { V _m_5996_a0_5997 = FLD(m_5996, 0); V _m_5996_a1_5998 = FLD(m_5996, 1); V _m_5996_a2_5999 = FLD(m_5996, 2); _r = ({ V p4612_6000 = _m_5996_a0_5997; ({ V p4613_6001 = _m_5996_a1_5998; ({ V p4614_6002 = _m_5996_a2_5999; ({ V _r = 0; V m_6003 = ap(scrut4608_5985, b_861_5984); if (((m_6003) == NONE)) {  _r = ({ V __6004 = UNIT; NONE; }); } else if (((m_6003) != NONE)) { V _m_6003_a0_6005 = FLD(m_6003, 0); _r = ({ V item4710_6006 = _m_6003_a0_6005; SOME(({ V local4616_6007 = item4710_6006; ({ V scrut4617_6008 = local4616_6007; ({ V _r = 0; V m_6009 = scrut4617_6008; if ((tag_of(m_6009) == 0)) { V _m_6009_a0_6010 = FLD(m_6009, 0); V _m_6009_a1_6011 = FLD(m_6009, 1); V _m_6009_a2_6012 = FLD(m_6009, 2); _r = ({ V p4618_6013 = _m_6009_a0_6010; ({ V p4619_6014 = _m_6009_a1_6011; ({ V p4620_6015 = _m_6009_a2_6012; ({ V _r = 0; V m_6016 = d_Rules_drules(p4612_6000); switch (tag_of(m_6016)) { case 1: { V _m_6016_a0_6017 = FLD(m_6016, 0); _r = ({ V item4707_6018 = _m_6016_a0_6017; ({ V local4623_6019 = item4707_6018; ({ V t_6020 = d_Rules_dshape_ueq(({ V _c = clo_new(lam_6023, 2, 2); CLO_ENV(_c)[0] = ops_857_5980; CLO_ENV(_c)[1] = ctx_858_5981; _c; }), p4612_6000, p4618_6013); V _r; if (tag_of(t_6020) == 0) _r = t_6020; else { V bound4625_6024 = FLD(t_6020, 0); _r = ({ V scrut4626_6025 = UNIT; ((((bound4625_6024) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ((((ap3(d_Get_dRules_dRule_upack_dann_ulvl_ueq(local4623_6019), p4612_6000, p4614_6002, p4620_6015)) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : apn(d_Get_dRules_dRule_upack_dconv_udiagram(local4623_6019), 5, (V[]){ops_857_5980, ctx_858_5981, p4612_6000, p4613_6001, p4619_6014}))); }); } _r; }); }); }); break; } case 0: { V _m_6016_a0_6026 = FLD(m_6016, 0); _r = ({ V item4708_6027 = _m_6016_a0_6026; FAIL(item4708_6027); }); break; } default: rt_panic("match: no case at kernel:3060"); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3060"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3059"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3059"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3058"); _r; }); });
}
V d_Conv_dconv_ulist(V ops_1091_6028, V ctx_1092_6029, V xs_1093_6030, V ys_1094_6031) {
  return d_Rules_dpayload_ueq(({ V _c = clo_new(lam_6034, 2, 2); CLO_ENV(_c)[0] = ops_1091_6028; CLO_ENV(_c)[1] = ctx_1092_6029; _c; }), xs_1093_6030, ys_1094_6031);
}
V d_Conv_dopt_uelse(V o_315_6035, V dflt_316_6036, V f_317_6037) {
  return ap(({ V _r = 0; V m_6038 = o_315_6035; if (((m_6038) == NONE)) {  _r = ({ V __6039 = UNIT; dflt_316_6036; }); } else if (((m_6038) != NONE)) { V _m_6038_a0_6040 = FLD(m_6038, 0); _r = ({ V value_6041 = _m_6038_a0_6040; ({ V local4762_6042 = value_6041; ({ V _c = clo_new(lam_6045, 1, 2); CLO_ENV(_c)[0] = f_317_6037; CLO_ENV(_c)[1] = local4762_6042; _c; }); }); }); } else rt_panic("match: no case at kernel:3069"); _r; }), UNIT);
}
V d_Conv_dfirst_uof(V xs_343_6046) {
  return ({ V local4804_6047 = d_SeqList_dfold(clo_new(lam_6055, 2, 0), xs_343_6046, NONE); maybe_default(local4804_6047, DONE(FALSE_V)); });
}
V d_Conv_dconv_uaddr(V ops_971_6056, V ctx_972_6057, V arg_ty_973_6058, V a1_974_6059, V a2_975_6060) {
  return d_Conv_dfirst_uof(CON(({ V _c = clo_new(lam_6090, 1, 5); CLO_ENV(_c)[0] = a1_974_6059; CLO_ENV(_c)[1] = a2_975_6060; CLO_ENV(_c)[2] = arg_ty_973_6058; CLO_ENV(_c)[3] = ops_971_6056; CLO_ENV(_c)[4] = ctx_972_6057; _c; }), CON(({ V _c = clo_new(lam_6103, 1, 2); CLO_ENV(_c)[0] = a1_974_6059; CLO_ENV(_c)[1] = a2_975_6060; _c; }), CON(({ V _c = clo_new(lam_6116, 1, 2); CLO_ENV(_c)[0] = a1_974_6059; CLO_ENV(_c)[1] = a2_975_6060; _c; }), NIL))));
}
V d_Conv_din_ucase(V ops_873_6117, V ctx_874_6118, V a_875_6119, V b_876_6120) {
  return ({ V _r = 0; V m_6121 = d_Value_das_uin(a_875_6119); if (((m_6121) == NONE)) {  _r = ({ V __6122 = UNIT; NONE; }); } else if (((m_6121) != NONE)) { V _m_6121_a0_6123 = FLD(m_6121, 0); _r = ({ V item4815_6124 = _m_6121_a0_6123; ({ V local4721_6125 = item4815_6124; ({ V scrut4722_6126 = local4721_6125; ({ V _r = 0; V m_6127 = scrut4722_6126; if ((tag_of(m_6127) == 0)) { V _m_6127_a0_6128 = FLD(m_6127, 0); V _m_6127_a1_6129 = FLD(m_6127, 1); V _m_6127_a2_6130 = FLD(m_6127, 2); _r = ({ V p4723_6131 = _m_6127_a0_6128; ({ V p4724_6132 = _m_6127_a1_6129; ({ V p4725_6133 = _m_6127_a2_6130; ({ V _r = 0; V m_6134 = d_Value_das_uin(b_876_6120); if (((m_6134) == NONE)) {  _r = ({ V __6135 = UNIT; NONE; }); } else if (((m_6134) != NONE)) { V _m_6134_a0_6136 = FLD(m_6134, 0); _r = ({ V item4812_6137 = _m_6134_a0_6136; SOME(({ V local4727_6138 = item4812_6137; ({ V scrut4728_6139 = local4727_6138; ({ V _r = 0; V m_6140 = scrut4728_6139; if ((tag_of(m_6140) == 0)) { V _m_6140_a0_6141 = FLD(m_6140, 0); V _m_6140_a1_6142 = FLD(m_6140, 1); V _m_6140_a2_6143 = FLD(m_6140, 2); _r = ({ V p4729_6144 = _m_6140_a0_6141; ({ V p4730_6145 = _m_6140_a1_6142; ({ V p4731_6146 = _m_6140_a2_6143; ({ V t_6147 = d_Rules_dshape_ueq(({ V _c = clo_new(lam_6150, 2, 2); CLO_ENV(_c)[0] = ops_873_6117; CLO_ENV(_c)[1] = ctx_874_6118; _c; }), p4723_6131, p4729_6144); V _r; if (tag_of(t_6147) == 0) _r = t_6147; else { V bound4733_6151 = FLD(t_6147, 0); _r = ({ V t_6152 = d_Conv_dconv_uaddr(ops_873_6117, ctx_874_6118, NONE, p4724_6132, p4730_6145); V _r; if (tag_of(t_6152) == 0) _r = t_6152; else { V bound4735_6153 = FLD(t_6152, 0); _r = ({ V scrut4736_6154 = UNIT; ((((bound4733_6151) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ((((bound4735_6153) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : d_Conv_dconv_ulist(ops_873_6117, ctx_874_6118, p4725_6133, p4731_6146))); }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3088"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3087"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3087"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3086"); _r; });
}
V d_Conv_dgrow(V ops_1196_6155, V ctx_1197_6156, V n_1198_6157) {
  return d_SeqList_dfold(({ V _c = clo_new(lam_6160, 2, 1); CLO_ENV(_c)[0] = ops_1196_6155; _c; }), d_SeqList_dinit(n_1198_6157, clo_new(lam_6162, 1, 0)), ctx_1197_6156);
}
V d_Conv_dconv_uclosures(V ops_1101_6163, V ctx_1102_6164, V arity_1103_6165, V x_1104_6166, V other_arity_1105_6167, V y_1106_6168) {
  return ((((d_Big_dis_ueq(arity_1103_6165, other_arity_1105_6167)) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ({ V scrut4836_6169 = ap(d_Get_dRules_dOps_do_usize(ops_1101_6163), ctx_1102_6164); ({ V scrut4839_6170 = d_SeqList_dinit(arity_1103_6165, ({ V _c = clo_new(lam_6172, 1, 2); CLO_ENV(_c)[0] = scrut4836_6169; CLO_ENV(_c)[1] = arity_1103_6165; _c; })); ({ V scrut4840_6173 = ap(d_Get_dRules_dOps_do_uev(ops_1101_6163), ctx_1102_6164); ({ V t_6174 = ap2(d_Get_dRules_dEvaluator_dev_ueval(scrut4840_6173), list_append(scrut4839_6170, d_Get_dValue_dClosure_denv(x_1104_6166)), d_Get_dValue_dClosure_dbody(x_1104_6166)); V _r; if (tag_of(t_6174) == 0) _r = t_6174; else { V bound4842_6175 = FLD(t_6174, 0); _r = ({ V t_6176 = ap2(d_Get_dRules_dEvaluator_dev_ueval(scrut4840_6173), list_append(scrut4839_6170, d_Get_dValue_dClosure_denv(y_1106_6168)), d_Get_dValue_dClosure_dbody(y_1106_6168)); V _r; if (tag_of(t_6176) == 0) _r = t_6176; else { V bound4844_6177 = FLD(t_6176, 0); _r = d_Conv_dconv_utype(UNIT, UNIT, ops_1101_6163, d_Conv_dgrow(ops_1101_6163, ctx_1102_6164, arity_1103_6165), bound4842_6175, bound4844_6177); } _r; }); } _r; }); }); }); }));
}
V d_Conv_dconv_ulegs(V ops_1095_6178, V ctx_1096_6179, V xs_1097_6180, V ys_1098_6181) {
  return d_Rules_dpayload_ueq(({ V _c = clo_new(lam_6184, 2, 2); CLO_ENV(_c)[0] = ops_1095_6178; CLO_ENV(_c)[1] = ctx_1096_6179; _c; }), xs_1097_6180, ys_1098_6181);
}
V d_Conv_dsec_ucase(V ops_887_6185, V ctx_888_6186, V a_889_6187, V b_890_6188) {
  return ({ V _r = 0; V m_6189 = d_Value_das_usec(a_889_6187); if (((m_6189) == NONE)) {  _r = ({ V __6190 = UNIT; NONE; }); } else if (((m_6189) != NONE)) { V _m_6189_a0_6191 = FLD(m_6189, 0); _r = ({ V item4860_6192 = _m_6189_a0_6191; ({ V local4820_6193 = item4860_6192; ({ V scrut4821_6194 = local4820_6193; ({ V _r = 0; V m_6195 = scrut4821_6194; if ((tag_of(m_6195) == 0)) { V _m_6195_a0_6196 = FLD(m_6195, 0); V _m_6195_a1_6197 = FLD(m_6195, 1); _r = ({ V p4822_6198 = _m_6195_a0_6196; ({ V p4823_6199 = _m_6195_a1_6197; ({ V _r = 0; V m_6200 = d_Value_das_usec(b_890_6188); if (((m_6200) == NONE)) {  _r = ({ V __6201 = UNIT; NONE; }); } else if (((m_6200) != NONE)) { V _m_6200_a0_6202 = FLD(m_6200, 0); _r = ({ V item4858_6203 = _m_6200_a0_6202; SOME(({ V local4825_6204 = item4858_6203; ({ V scrut4826_6205 = local4825_6204; ({ V _r = 0; V m_6206 = scrut4826_6205; if ((tag_of(m_6206) == 0)) { V _m_6206_a0_6207 = FLD(m_6206, 0); V _m_6206_a1_6208 = FLD(m_6206, 1); _r = ({ V p4827_6209 = _m_6206_a0_6207; ({ V p4828_6210 = _m_6206_a1_6208; ({ V t_6211 = d_Rules_dshape_ueq(({ V _c = clo_new(lam_6214, 2, 2); CLO_ENV(_c)[0] = ops_887_6185; CLO_ENV(_c)[1] = ctx_888_6186; _c; }), p4822_6198, p4827_6209); V _r; if (tag_of(t_6211) == 0) _r = t_6211; else { V bound4830_6215 = FLD(t_6211, 0); _r = ({ V scrut4831_6216 = UNIT; ((((bound4830_6215) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : d_Conv_dconv_ulegs(ops_887_6185, ctx_888_6186, p4823_6199, p4828_6210)); }); } _r; }); }); }); } else rt_panic("match: no case at kernel:3112"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3111"); _r; }); }); }); } else rt_panic("match: no case at kernel:3111"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3110"); _r; });
}
V d_Value_dhead_uequal(V a_490_6217, V b_491_6218) {
  return ({ V scrut4875_6219 = rt_ctor2(0, a_490_6217, b_491_6218); ({ V _r = 0; V m_6220 = scrut4875_6219; if ((tag_of(m_6220) == 0)) { V _m_6220_a0_6221 = FLD(m_6220, 0); V _m_6220_a1_6222 = FLD(m_6220, 1); _r = ({ V p4876_6223 = _m_6220_a0_6221; ({ V p4877_6224 = _m_6220_a1_6222; ({ V _r = 0; V m_6225 = p4876_6223; switch (tag_of(m_6225)) { case 0: { V _m_6225_a0_6226 = FLD(m_6225, 0); _r = ({ V p4878_6227 = _m_6225_a0_6226; ({ V _r = 0; V m_6228 = p4877_6224; switch (tag_of(m_6228)) { case 0: { V _m_6228_a0_6229 = FLD(m_6228, 0); _r = ({ V p4879_6230 = _m_6228_a0_6229; d_Big_dis_ueq(p4878_6227, p4879_6230); }); break; } case 1: { V _m_6228_a0_6231 = FLD(m_6228, 0); _r = ({ V p4880_6232 = _m_6228_a0_6231; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:3119"); } _r; }); }); break; } case 1: { V _m_6225_a0_6233 = FLD(m_6225, 0); _r = ({ V p4881_6234 = _m_6225_a0_6233; ({ V _r = 0; V m_6235 = p4877_6224; switch (tag_of(m_6235)) { case 0: { V _m_6235_a0_6236 = FLD(m_6235, 0); _r = ({ V p4882_6237 = _m_6235_a0_6236; FALSE_V; }); break; } case 1: { V _m_6235_a0_6238 = FLD(m_6235, 0); _r = ({ V p4883_6239 = _m_6235_a0_6238; d_NativeString_dequal(p4881_6234, p4883_6239); }); break; } default: rt_panic("match: no case at kernel:3119"); } _r; }); }); break; } default: rt_panic("match: no case at kernel:3119"); } _r; }); }); }); } else rt_panic("match: no case at kernel:3119"); _r; }); });
}
V d_Conv_dspine_ustep(V ops_959_6240, V ctx_960_6241, V hty_961_6242, V s_962_6243, V addr_963_6244) {
  return ({ V t_6245 = ap2(d_Get_dRules_dOps_do_uwhnf(ops_959_6240), ctx_960_6241, hty_961_6242); V _r; if (tag_of(t_6245) == 0) _r = t_6245; else { V bound4921_6246 = FLD(t_6245, 0); _r = d_Conv_dopt_uelse(d_Value_das_uran(bound4921_6246), clo_new(lam_6249, 1, 0), ({ V _c = clo_new(lam_6265, 1, 4); CLO_ENV(_c)[0] = s_962_6243; CLO_ENV(_c)[1] = ops_959_6240; CLO_ENV(_c)[2] = ctx_960_6241; CLO_ENV(_c)[3] = addr_963_6244; _c; })); } _r; });
}
V d_Conv_dbranch_uaddr(V ops_1174_6266, V ctx_1175_6267, V env1_1176_6268, V env2_1177_6269, V a1_1178_6270, V a2_1179_6271) {
  return ({ V scrut4968_6272 = ap(d_Get_dRules_dOps_do_uev(ops_1174_6266), ctx_1175_6267); d_Conv_dfirst_uof(CON(({ V _c = clo_new(lam_6301, 1, 7); CLO_ENV(_c)[0] = a1_1178_6270; CLO_ENV(_c)[1] = a2_1179_6271; CLO_ENV(_c)[2] = scrut4968_6272; CLO_ENV(_c)[3] = env1_1176_6268; CLO_ENV(_c)[4] = env2_1177_6269; CLO_ENV(_c)[5] = ops_1174_6266; CLO_ENV(_c)[6] = ctx_1175_6267; _c; }), CON(({ V _c = clo_new(lam_6314, 1, 2); CLO_ENV(_c)[0] = a1_1178_6270; CLO_ENV(_c)[1] = a2_1179_6271; _c; }), CON(({ V _c = clo_new(lam_6327, 1, 2); CLO_ENV(_c)[0] = a1_1178_6270; CLO_ENV(_c)[1] = a2_1179_6271; _c; }), NIL)))); });
}
V d_Conv_dconv_ubranches(V ops_1161_6328, V ctx_1162_6329, V env1_1163_6330, V env2_1164_6331, V bs1_1165_6332, V bs2_1166_6333) {
  return d_Rules_dpayload_ueq(({ V _c = clo_new(lam_6350, 2, 4); CLO_ENV(_c)[0] = ops_1161_6328; CLO_ENV(_c)[1] = ctx_1162_6329; CLO_ENV(_c)[2] = env1_1163_6330; CLO_ENV(_c)[3] = env2_1164_6331; _c; }), bs1_1165_6332, bs2_1166_6333);
}
V d_Conv_dconv_umotive(V ops_1146_6351, V ctx_1147_6352, V m1_1148_6353, V m2_1149_6354) {
  return ({ V local5016_6355 = d_Get_dValue_dStuck_uelim_ds_umotive(m1_1148_6353); ({ V _r = 0; V m_6356 = local5016_6355; if (((m_6356) == NONE)) {  _r = ({ V __6357 = UNIT; DONE(((((V)maybe_is_some(d_Get_dValue_dStuck_uelim_ds_umotive(m2_1149_6354)))) ^ 1u)); }); } else if (((m_6356) != NONE)) { V _m_6356_a0_6358 = FLD(m_6356, 0); _r = ({ V value_6359 = _m_6356_a0_6358; ({ V local5018_6360 = value_6359; ({ V local5021_6361 = d_Get_dValue_dStuck_uelim_ds_umotive(m2_1149_6354); ({ V _r = 0; V m_6362 = local5021_6361; if (((m_6362) == NONE)) {  _r = ({ V __6363 = UNIT; DONE(FALSE_V); }); } else if (((m_6362) != NONE)) { V _m_6362_a0_6364 = FLD(m_6362, 0); _r = ({ V value_6365 = _m_6362_a0_6364; ({ V local5023_6366 = value_6365; ({ V scrut5024_6367 = d_Big_dof_unat(list_length(d_Get_dTerm_dMotive_dm_uidx(local5018_6360))); ({ V scrut5025_6368 = d_Big_dof_unat(list_length(d_Get_dTerm_dMotive_dm_uidx(local5023_6366))); ({ V scrut5026_6369 = UNIT; ((((d_Big_dis_ueq(scrut5024_6367, scrut5025_6368)) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ({ V scrut5027_6370 = ap(d_Get_dRules_dOps_do_usize(ops_1146_6351), ctx_1147_6352); ({ V scrut5030_6371 = d_SeqList_dinit(scrut5024_6367, ({ V _c = clo_new(lam_6373, 1, 2); CLO_ENV(_c)[0] = scrut5027_6370; CLO_ENV(_c)[1] = scrut5024_6367; _c; })); ({ V scrut5031_6374 = d_Value_dvar(d_NativeInt_dadd(scrut5027_6370, scrut5024_6367)); ({ V scrut5032_6375 = ap(d_Get_dRules_dOps_do_uev(ops_1146_6351), ctx_1147_6352); ({ V t_6376 = ap2(d_Get_dRules_dEvaluator_dev_ueval(scrut5032_6375), CON(scrut5031_6374, list_append(scrut5030_6371, d_Get_dValue_dStuck_uelim_ds_uenv(m1_1148_6353))), d_Get_dTerm_dMotive_dm_ubody(local5018_6360)); V _r; if (tag_of(t_6376) == 0) _r = t_6376; else { V bound5034_6377 = FLD(t_6376, 0); _r = ({ V t_6378 = ap2(d_Get_dRules_dEvaluator_dev_ueval(scrut5032_6375), CON(scrut5031_6374, list_append(scrut5030_6371, d_Get_dValue_dStuck_uelim_ds_uenv(m2_1149_6354))), d_Get_dTerm_dMotive_dm_ubody(local5023_6366)); V _r; if (tag_of(t_6378) == 0) _r = t_6378; else { V bound5036_6379 = FLD(t_6378, 0); _r = d_Conv_dconv_utype(UNIT, UNIT, ops_1146_6351, d_Conv_dgrow(ops_1146_6351, ctx_1147_6352, d_NativeInt_dadd(scrut5024_6367, d_Big_done())), bound5034_6377, bound5036_6379); } _r; }); } _r; }); }); }); }); })); }); }); }); }); }); } else rt_panic("match: no case at kernel:3148"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3148"); _r; }); });
}
V d_Conv_dconv_ustuck(V ops_1113_6380, V ctx_1114_6381, V m1_1115_6382, V m2_1116_6383) {
  return ({ V t_6384 = d_Rules_dshape_ueq(({ V _c = clo_new(lam_6387, 2, 2); CLO_ENV(_c)[0] = ops_1113_6380; CLO_ENV(_c)[1] = ctx_1114_6381; _c; }), d_Get_dValue_dStuck_uelim_ds_ushape(m1_1115_6382), d_Get_dValue_dStuck_uelim_ds_ushape(m2_1116_6383)); V _r; if (tag_of(t_6384) == 0) _r = t_6384; else { V bound4952_6388 = FLD(t_6384, 0); _r = ({ V t_6389 = d_Conv_dconv_umotive(ops_1113_6380, ctx_1114_6381, m1_1115_6382, m2_1116_6383); V _r; if (tag_of(t_6389) == 0) _r = t_6389; else { V bound4954_6390 = FLD(t_6389, 0); _r = ({ V scrut4955_6391 = UNIT; ((((bound4952_6388) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ((((d_Quantity_dequal(d_Get_dValue_dStuck_uelim_ds_uscrut_uq(m1_1115_6382), d_Get_dValue_dStuck_uelim_ds_uscrut_uq(m2_1116_6383))) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ((((bound4954_6390) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : d_Conv_dconv_ubranches(ops_1113_6380, ctx_1114_6381, d_Get_dValue_dStuck_uelim_ds_uenv(m1_1115_6382), d_Get_dValue_dStuck_uelim_ds_uenv(m2_1116_6383), d_Get_dValue_dStuck_uelim_ds_ubranches(m1_1115_6382), d_Get_dValue_dStuck_uelim_ds_ubranches(m2_1116_6383))))); }); } _r; }); } _r; });
}
V d_Conv_dconv_uspine(V q0_6392, V A0_6393, V ops_909_6394, V ctx_910_6395, V hty_911_6396, V sp1_912_6397, V sp2_913_6398) {
_top: ;
  return ({ V scrut4886_6399 = rt_ctor2(0, sp1_912_6397, sp2_913_6398); ({ V _r = 0; V m_6400 = scrut4886_6399; if ((tag_of(m_6400) == 0)) { V _m_6400_a0_6401 = FLD(m_6400, 0); V _m_6400_a1_6402 = FLD(m_6400, 1); _r = ({ V p4887_6403 = _m_6400_a0_6401; ({ V p4888_6404 = _m_6400_a1_6402; ({ V _r = 0; V m_6405 = p4887_6403; if (((m_6405) == NIL)) {  _r = ({ V __6406 = UNIT; ({ V _r = 0; V m_6407 = p4888_6404; if (((m_6407) == NIL)) {  _r = ({ V __6408 = UNIT; DONE(TRUE_V); }); } else if (((m_6407) != NIL)) { V _m_6407_a0_6409 = FLD(m_6407, 0); V _m_6407_a1_6410 = FLD(m_6407, 1); _r = ({ V p4889_6411 = _m_6407_a0_6409; ({ V p4890_6412 = _m_6407_a1_6410; DONE(FALSE_V); }); }); } else rt_panic("match: no case at kernel:3169"); _r; }); }); } else if (((m_6405) != NIL)) { V _m_6405_a0_6413 = FLD(m_6405, 0); V _m_6405_a1_6414 = FLD(m_6405, 1); _r = ({ V p4891_6415 = _m_6405_a0_6413; ({ V p4892_6416 = _m_6405_a1_6414; ({ V _r = 0; V m_6417 = p4891_6415; switch (tag_of(m_6417)) { case 0: { V _m_6417_a0_6418 = FLD(m_6417, 0); V _m_6417_a1_6419 = FLD(m_6417, 1); _r = ({ V p4893_6420 = _m_6417_a0_6418; ({ V p4894_6421 = _m_6417_a1_6419; ({ V _r = 0; V m_6422 = p4888_6404; if (((m_6422) == NIL)) {  _r = ({ V __6423 = UNIT; DONE(FALSE_V); }); } else if (((m_6422) != NIL)) { V _m_6422_a0_6424 = FLD(m_6422, 0); V _m_6422_a1_6425 = FLD(m_6422, 1); _r = ({ V p4895_6426 = _m_6422_a0_6424; ({ V p4896_6427 = _m_6422_a1_6425; ({ V _r = 0; V m_6428 = p4895_6426; switch (tag_of(m_6428)) { case 0: { V _m_6428_a0_6429 = FLD(m_6428, 0); V _m_6428_a1_6430 = FLD(m_6428, 1); _r = ({ V p4897_6431 = _m_6428_a0_6429; ({ V p4898_6432 = _m_6428_a1_6430; ({ V t_6433 = d_Rules_dshape_ueq(({ V _c = clo_new(lam_6436, 2, 4); CLO_ENV(_c)[0] = q0_6392; CLO_ENV(_c)[1] = A0_6393; CLO_ENV(_c)[2] = ops_909_6394; CLO_ENV(_c)[3] = ctx_910_6395; _c; }), p4893_6420, p4897_6431); V _r; if (tag_of(t_6433) == 0) _r = t_6433; else { V bound4900_6437 = FLD(t_6433, 0); _r = ({ V t_6438 = d_Conv_dspine_ustep(ops_909_6394, ctx_910_6395, hty_911_6396, p4893_6420, p4894_6421); V _r; if (tag_of(t_6438) == 0) _r = t_6438; else { V bound4902_6439 = FLD(t_6438, 0); _r = ({ V scrut4908_6440 = ({ V _r = 0; V m_6441 = bound4902_6439; if (((m_6441) == NONE)) {  _r = ({ V __6442 = UNIT; NONE; }); } else if (((m_6441) != NONE)) { V _m_6441_a0_6443 = FLD(m_6441, 0); _r = ({ V item4907_6444 = _m_6441_a0_6443; ({ V local4905_6445 = item4907_6444; d_Get_dTuple2_dv0(local4905_6445); }); }); } else rt_panic("match: no case at kernel:3172"); _r; }); ({ V scrut4915_6446 = ({ V local4911_6447 = bound4902_6439; ({ V _r = 0; V m_6448 = local4911_6447; if (((m_6448) == NONE)) {  _r = ({ V __6449 = UNIT; d_Conv_dplaceholder(); }); } else if (((m_6448) != NONE)) { V _m_6448_a0_6450 = FLD(m_6448, 0); _r = ({ V value_6451 = _m_6448_a0_6450; ({ V local4914_6452 = value_6451; d_Get_dTuple2_dv1(local4914_6452); }); }); } else rt_panic("match: no case at kernel:3173"); _r; }); }); ({ V t_6453 = d_Conv_dconv_uaddr(ops_909_6394, ctx_910_6395, scrut4908_6440, p4894_6421, p4898_6432); V _r; if (tag_of(t_6453) == 0) _r = t_6453; else { V bound4917_6454 = FLD(t_6453, 0); _r = ({ V scrut4918_6455 = UNIT; ((((bound4900_6437) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ((((bound4917_6454) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ({ V a_6456 = scrut4915_6446; V a_6457 = p4892_6416; V a_6458 = p4896_6427; hty_911_6396 = a_6456; sp1_912_6397 = a_6457; sp2_913_6398 = a_6458;  goto _top; (V)0; }))); }); } _r; }); }); }); } _r; }); } _r; }); }); }); break; } case 1: { V _m_6428_a0_6459 = FLD(m_6428, 0); _r = ({ V p4942_6460 = _m_6428_a0_6459; DONE(FALSE_V); }); break; } default: rt_panic("match: no case at kernel:3169"); } _r; }); }); }); } else rt_panic("match: no case at kernel:3169"); _r; }); }); }); break; } case 1: { V _m_6417_a0_6461 = FLD(m_6417, 0); _r = ({ V p4943_6462 = _m_6417_a0_6461; ({ V _r = 0; V m_6463 = p4888_6404; if (((m_6463) == NIL)) {  _r = ({ V __6464 = UNIT; DONE(FALSE_V); }); } else if (((m_6463) != NIL)) { V _m_6463_a0_6465 = FLD(m_6463, 0); V _m_6463_a1_6466 = FLD(m_6463, 1); _r = ({ V p4944_6467 = _m_6463_a0_6465; ({ V p4945_6468 = _m_6463_a1_6466; ({ V _r = 0; V m_6469 = p4944_6467; switch (tag_of(m_6469)) { case 0: { V _m_6469_a0_6470 = FLD(m_6469, 0); V _m_6469_a1_6471 = FLD(m_6469, 1); _r = ({ V p4946_6472 = _m_6469_a0_6470; ({ V p4947_6473 = _m_6469_a1_6471; DONE(FALSE_V); }); }); break; } case 1: { V _m_6469_a0_6474 = FLD(m_6469, 0); _r = ({ V p4948_6475 = _m_6469_a0_6474; ({ V t_6476 = d_Conv_dconv_ustuck(ops_909_6394, ctx_910_6395, p4943_6462, p4948_6475); V _r; if (tag_of(t_6476) == 0) _r = t_6476; else { V bound4950_6477 = FLD(t_6476, 0); _r = ((bound4950_6477) != FALSE_V ? ({ V a_6478 = d_Conv_dplaceholder(); V a_6479 = p4892_6416; V a_6480 = p4945_6468; hty_911_6396 = a_6478; sp1_912_6397 = a_6479; sp2_913_6398 = a_6480;  goto _top; (V)0; }) : DONE(FALSE_V)); } _r; }); }); break; } default: rt_panic("match: no case at kernel:3177"); } _r; }); }); }); } else rt_panic("match: no case at kernel:3177"); _r; }); }); break; } default: rt_panic("match: no case at kernel:3169"); } _r; }); }); }); } else rt_panic("match: no case at kernel:3169"); _r; }); }); }); } else rt_panic("match: no case at kernel:3169"); _r; }); });
}
V d_Conv_dneutral_ucase(V ops_898_6481, V ctx_899_6482, V a_900_6483, V b_901_6484) {
  return ({ V _r = 0; V m_6485 = d_Value_das_uneutral(a_900_6483); if (((m_6485) == NONE)) {  _r = ({ V __6486 = UNIT; NONE; }); } else if (((m_6485) != NONE)) { V _m_6485_a0_6487 = FLD(m_6485, 0); _r = ({ V item5047_6488 = _m_6485_a0_6487; ({ V local4865_6489 = item5047_6488; ({ V scrut4866_6490 = local4865_6489; ({ V _r = 0; V m_6491 = scrut4866_6490; if ((tag_of(m_6491) == 0)) { V _m_6491_a0_6492 = FLD(m_6491, 0); V _m_6491_a1_6493 = FLD(m_6491, 1); _r = ({ V p4867_6494 = _m_6491_a0_6492; ({ V p4868_6495 = _m_6491_a1_6493; ({ V _r = 0; V m_6496 = d_Value_das_uneutral(b_901_6484); if (((m_6496) == NONE)) {  _r = ({ V __6497 = UNIT; NONE; }); } else if (((m_6496) != NONE)) { V _m_6496_a0_6498 = FLD(m_6496, 0); _r = ({ V item5045_6499 = _m_6496_a0_6498; SOME(({ V local4870_6500 = item5045_6499; ({ V scrut4871_6501 = local4870_6500; ({ V _r = 0; V m_6502 = scrut4871_6501; if ((tag_of(m_6502) == 0)) { V _m_6502_a0_6503 = FLD(m_6502, 0); V _m_6502_a1_6504 = FLD(m_6502, 1); _r = ({ V p4872_6505 = _m_6502_a0_6503; ({ V p4873_6506 = _m_6502_a1_6504; ({ V scrut4874_6507 = UNIT; ((((d_Value_dhead_uequal(p4867_6494, p4872_6505)) ^ 1u)) != FALSE_V ? DONE(FALSE_V) : ({ V t_6508 = ap2(d_Get_dRules_dOps_do_uhead_uty(ops_898_6481), ctx_899_6482, p4867_6494); V _r; if (tag_of(t_6508) == 0) _r = t_6508; else { V bound4885_6509 = FLD(t_6508, 0); _r = d_Conv_dconv_uspine(UNIT, UNIT, ops_898_6481, ctx_899_6482, bound4885_6509, list_reverse(p4868_6495), list_reverse(p4873_6506)); } _r; })); }); }); }); } else rt_panic("match: no case at kernel:3184"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3183"); _r; }); }); }); } else rt_panic("match: no case at kernel:3183"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3182"); _r; });
}
V d_Conv_dstructural(V ops_832_6510, V ctx_833_6511, V a_834_6512, V b_835_6513) {
  return ({ V t_6514 = ap2(d_Get_dRules_dOps_do_uwhnf(ops_832_6510), ctx_833_6511, a_834_6512); V _r; if (tag_of(t_6514) == 0) _r = t_6514; else { V bound4570_6515 = FLD(t_6514, 0); _r = ({ V t_6516 = ap2(d_Get_dRules_dOps_do_uwhnf(ops_832_6510), ctx_833_6511, b_835_6513); V _r; if (tag_of(t_6516) == 0) _r = t_6516; else { V bound4572_6517 = FLD(t_6516, 0); _r = d_Conv_dfirst_uof(CON(({ V _c = clo_new(lam_6520, 1, 2); CLO_ENV(_c)[0] = bound4570_6515; CLO_ENV(_c)[1] = bound4572_6517; _c; }), CON(({ V _c = clo_new(lam_6523, 1, 2); CLO_ENV(_c)[0] = bound4570_6515; CLO_ENV(_c)[1] = bound4572_6517; _c; }), CON(({ V _c = clo_new(lam_6526, 1, 4); CLO_ENV(_c)[0] = ops_832_6510; CLO_ENV(_c)[1] = ctx_833_6511; CLO_ENV(_c)[2] = bound4570_6515; CLO_ENV(_c)[3] = bound4572_6517; _c; }), CON(({ V _c = clo_new(lam_6529, 1, 4); CLO_ENV(_c)[0] = ops_832_6510; CLO_ENV(_c)[1] = ctx_833_6511; CLO_ENV(_c)[2] = bound4570_6515; CLO_ENV(_c)[3] = bound4572_6517; _c; }), CON(({ V _c = clo_new(lam_6532, 1, 4); CLO_ENV(_c)[0] = ops_832_6510; CLO_ENV(_c)[1] = ctx_833_6511; CLO_ENV(_c)[2] = bound4570_6515; CLO_ENV(_c)[3] = bound4572_6517; _c; }), CON(({ V _c = clo_new(lam_6535, 1, 4); CLO_ENV(_c)[0] = ops_832_6510; CLO_ENV(_c)[1] = ctx_833_6511; CLO_ENV(_c)[2] = bound4570_6515; CLO_ENV(_c)[3] = bound4572_6517; _c; }), CON(({ V _c = clo_new(lam_6538, 1, 4); CLO_ENV(_c)[0] = ops_832_6510; CLO_ENV(_c)[1] = ctx_833_6511; CLO_ENV(_c)[2] = bound4570_6515; CLO_ENV(_c)[3] = bound4572_6517; _c; }), NIL)))))))); } _r; }); } _r; });
}
V d_Conv_dexpansion_uof(V pack_597_6539, V sd_598_6540) {
  return ({ V scrut5092_6541 = sd_598_6540; ({ V _r = 0; V m_6542 = scrut5092_6541; switch (tag_of(m_6542)) { case 0: {  _r = ({ V __6543 = UNIT; ((d_Get_dRules_dEta_urow_deta_uran(d_Get_dRules_dRule_upack_deta(pack_597_6539))) != FALSE_V ? d_Get_dRules_dRule_upack_dexpand_uran(pack_597_6539) : NONE); }); break; } case 1: {  _r = ({ V __6544 = UNIT; ((d_Get_dRules_dEta_urow_deta_ulan(d_Get_dRules_dRule_upack_deta(pack_597_6539))) != FALSE_V ? d_Get_dRules_dRule_upack_dexpand_ulan(pack_597_6539) : NONE); }); break; } default: rt_panic("match: no case at kernel:3205"); } _r; }); });
}
V d_Conv_deta_ustep(V ops_806_6545, V ctx_807_6546, V w_808_6547, V a_809_6548, V b_810_6549) {
  return ({ V scrut5079_6550 = ({ V local5064_6551 = ({ V local5053_6552 = d_Value_das_uran(w_808_6547); ({ V _r = 0; V m_6553 = local5053_6552; if (((m_6553) == NONE)) {  _r = ({ V __6554 = UNIT; NONE; }); } else if (((m_6553) != NONE)) { V _m_6553_a0_6555 = FLD(m_6553, 0); _r = ({ V item5061_6556 = _m_6553_a0_6555; SOME(({ V local5055_6557 = item5061_6556; ({ V scrut5056_6558 = local5055_6557; ({ V _r = 0; V m_6559 = scrut5056_6558; if ((tag_of(m_6559) == 0)) { V _m_6559_a0_6560 = FLD(m_6559, 0); V _m_6559_a1_6561 = FLD(m_6559, 1); V _m_6559_a2_6562 = FLD(m_6559, 2); _r = ({ V p5057_6563 = _m_6559_a0_6560; ({ V p5058_6564 = _m_6559_a1_6561; ({ V p5059_6565 = _m_6559_a2_6562; rt_ctor3(0, ((V)0), p5057_6563, p5058_6564); }); }); }); } else rt_panic("match: no case at kernel:3210"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3209"); _r; }); }); ({ V _r = 0; V m_6566 = local5064_6551; if (((m_6566) == NONE)) {  _r = ({ V __6567 = UNIT; ({ V local5067_6568 = d_Value_das_ulan(w_808_6547); ({ V _r = 0; V m_6569 = local5067_6568; if (((m_6569) == NONE)) {  _r = ({ V __6570 = UNIT; NONE; }); } else if (((m_6569) != NONE)) { V _m_6569_a0_6571 = FLD(m_6569, 0); _r = ({ V item5075_6572 = _m_6569_a0_6571; SOME(({ V local5069_6573 = item5075_6572; ({ V scrut5070_6574 = local5069_6573; ({ V _r = 0; V m_6575 = scrut5070_6574; if ((tag_of(m_6575) == 0)) { V _m_6575_a0_6576 = FLD(m_6575, 0); V _m_6575_a1_6577 = FLD(m_6575, 1); V _m_6575_a2_6578 = FLD(m_6575, 2); _r = ({ V p5071_6579 = _m_6575_a0_6576; ({ V p5072_6580 = _m_6575_a1_6577; ({ V p5073_6581 = _m_6575_a2_6578; rt_ctor3(0, ((V)1), p5071_6579, p5072_6580); }); }); }); } else rt_panic("match: no case at kernel:3209"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3208"); _r; }); }); }); } else if (((m_6566) != NONE)) { V _m_6566_a0_6582 = FLD(m_6566, 0); _r = ({ V value_6583 = _m_6566_a0_6582; ({ V local5078_6584 = value_6583; SOME(local5078_6584); }); }); } else rt_panic("match: no case at kernel:3208"); _r; }); }); d_Conv_dopt_uelse(scrut5079_6550, clo_new(lam_6587, 1, 0), ({ V _c = clo_new(lam_6614, 1, 4); CLO_ENV(_c)[0] = ops_806_6545; CLO_ENV(_c)[1] = ctx_807_6546; CLO_ENV(_c)[2] = a_809_6548; CLO_ENV(_c)[3] = b_810_6549; _c; })); });
}
V d_Conv_dsubsingleton_ustep(V ops_797_6615, V ctx_798_6616, V w_799_6617) {
  return d_Conv_dopt_uelse(d_Value_das_ulan(w_799_6617), clo_new(lam_6620, 1, 0), ({ V _c = clo_new(lam_6636, 1, 2); CLO_ENV(_c)[0] = ops_797_6615; CLO_ENV(_c)[1] = ctx_798_6616; _c; }));
}
V d_Conv_dconv(V q0_6637, V A0_6638, V ops_764_6639, V ctx_765_6640, V ty_766_6641, V a_767_6642, V b_768_6643) {
  return ({ V scrut4541_6644 = UNIT; ((d_Conv_dis_uprop(ops_764_6639, ctx_765_6640, ty_766_6641)) != FALSE_V ? DONE(TRUE_V) : ({ V t_6645 = ap2(d_Get_dRules_dOps_do_uwhnf(ops_764_6639), ctx_765_6640, ty_766_6641); V _r; if (tag_of(t_6645) == 0) _r = t_6645; else { V bound4561_6646 = FLD(t_6645, 0); _r = ({ V t_6647 = d_Conv_dsubsingleton_ustep(ops_764_6639, ctx_765_6640, bound4561_6646); V _r; if (tag_of(t_6647) == 0) _r = t_6647; else { V bound4563_6648 = FLD(t_6647, 0); _r = ((bound4563_6648) != FALSE_V ? DONE(TRUE_V) : ({ V t_6649 = d_Conv_deta_ustep(ops_764_6639, ctx_765_6640, bound4561_6646, a_767_6642, b_768_6643); V _r; if (tag_of(t_6649) == 0) _r = t_6649; else { V bound4565_6650 = FLD(t_6649, 0); _r = d_Conv_dopt_uelse(bound4565_6650, ({ V _c = clo_new(lam_6653, 1, 4); CLO_ENV(_c)[0] = ops_764_6639; CLO_ENV(_c)[1] = ctx_765_6640; CLO_ENV(_c)[2] = a_767_6642; CLO_ENV(_c)[3] = b_768_6643; _c; }), clo_new(lam_6655, 1, 0)); } _r; })); } _r; }); } _r; })); });
}
V d_Conv_dconv_utype(V q0_6656, V A0_6657, V ops_828_6658, V ctx_829_6659, V a_830_6660, V b_831_6661) {
  return d_Conv_dconv(q0_6656, A0_6657, ops_828_6658, ctx_829_6659, d_Conv_dplaceholder(), a_830_6660, b_831_6661);
}
V d_Check_densure(V c_1320_6662, V got_1321_6663, V expected_1322_6664) {
  return ({ V t_6665 = d_Conv_dconv_utype(UNIT, UNIT, d_Check_dops(), c_1320_6662, got_1321_6663, expected_1322_6664); V _r; if (tag_of(t_6665) == 0) _r = t_6665; else { V bound4434_6666 = FLD(t_6665, 0); _r = ((bound4434_6666) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, str_concat(CON(((V)&S_161), CON(d_Check_dpp_uvalue(c_1320_6662, got_1321_6663), CON(((V)&S_162), CON(d_Check_dpp_uvalue(c_1320_6662, expected_1322_6664), NIL)))))))); } _r; });
}
V d_Check_dcheck_uformer(V c_1310_6667, V s_1311_6668, V diagram_1312_6669, V expected_1313_6670, V left_1314_6671) {
  return ({ V t_6672 = d_Eval_dwhnf(d_Get_dCheck_dCtx_dglobals(c_1310_6667), expected_1313_6670); V _r; if (tag_of(t_6672) == 0) _r = t_6672; else { V bound5133_6673 = FLD(t_6672, 0); _r = ({ V t_6674 = ({ V local5147_6675 = d_Value_das_uuniv(bound5133_6673); ({ V _r = 0; V m_6676 = local5147_6675; if (((m_6676) == NONE)) {  _r = ({ V __6677 = UNIT; FAIL(rt_ctor1(5, str_append(((V)&S_163), d_Check_dpp_uvalue(c_1310_6667, bound5133_6673)))); }); } else if (((m_6676) != NONE)) { V _m_6676_a0_6678 = FLD(m_6676, 0); _r = ({ V x_6679 = _m_6676_a0_6678; DONE(x_6679); }); } else rt_panic("match: no case at kernel:3242"); _r; }); }); V _r; if (tag_of(t_6674) == 0) _r = t_6674; else { V bound5135_6680 = FLD(t_6674, 0); _r = ({ V _r = 0; V m_6681 = d_Rules_drules(s_1311_6668); switch (tag_of(m_6681)) { case 1: { V _m_6681_a0_6682 = FLD(m_6681, 0); _r = ({ V item5142_6683 = _m_6681_a0_6682; ({ V local5138_6684 = item5142_6683; ({ V scrut5139_6685 = ((left_1314_6671) != FALSE_V ? d_Get_dRules_dRule_upack_dform_ulan(local5138_6684) : d_Get_dRules_dRule_upack_dform_uran(local5138_6684)); ({ V t_6686 = apn(scrut5139_6685, 5, (V[]){d_Check_dops(), c_1310_6667, s_1311_6668, diagram_1312_6669, SOME(bound5135_6680)}); V _r; if (tag_of(t_6686) == 0) _r = t_6686; else { V bound5141_6687 = FLD(t_6686, 0); _r = ((d_Level_dequal(bound5141_6687, bound5135_6680)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(5, str_concat(CON(((V)&S_164), CON(d_Level_dto_ustring(bound5141_6687), CON(((V)&S_165), CON(d_Level_dto_ustring(bound5135_6680), NIL)))))))); } _r; }); }); }); }); break; } case 0: { V _m_6681_a0_6688 = FLD(m_6681, 0); _r = ({ V item5143_6689 = _m_6681_a0_6688; FAIL(item5143_6689); }); break; } default: rt_panic("match: no case at kernel:3243"); } _r; }); } _r; }); } _r; });
}
V d_Check_dcheck_uuses(V c_1277_6690, V mode_1278_6691, V t_1279_6692, V expected_1280_6693) {
  return ({ V scrut4425_6694 = t_1279_6692; ({ V _r = 0; V m_6695 = scrut4425_6694; switch (tag_of(m_6695)) { case 0: { V _m_6695_a0_6696 = FLD(m_6695, 0); _r = ({ V p4426_6697 = _m_6695_a0_6696; ({ V t_6698 = d_Check_dinfer_uuses(c_1277_6690, mode_1278_6691, t_1279_6692); V _r; if (tag_of(t_6698) == 0) _r = t_6698; else { V bound4428_6699 = FLD(t_6698, 0); _r = ({ V _r = 0; V m_6700 = bound4428_6699; if ((tag_of(m_6700) == 0)) { V _m_6700_a0_6701 = FLD(m_6700, 0); V _m_6700_a1_6702 = FLD(m_6700, 1); _r = ({ V p4429_6703 = _m_6700_a0_6701; ({ V p4430_6704 = _m_6700_a1_6702; ({ V t_6705 = d_Check_densure(c_1277_6690, p4429_6703, expected_1280_6693); V _r; if (tag_of(t_6705) == 0) _r = t_6705; else { V bound4432_6706 = FLD(t_6705, 0); _r = DONE(p4430_6704); } _r; }); }); }); } else rt_panic("match: no case at kernel:3252"); _r; }); } _r; }); }); break; } case 1: { V _m_6695_a0_6707 = FLD(m_6695, 0); _r = ({ V p5120_6708 = _m_6695_a0_6707; ({ V t_6709 = d_Check_dinfer_uuses(c_1277_6690, mode_1278_6691, t_1279_6692); V _r; if (tag_of(t_6709) == 0) _r = t_6709; else { V bound5122_6710 = FLD(t_6709, 0); _r = ({ V _r = 0; V m_6711 = bound5122_6710; if ((tag_of(m_6711) == 0)) { V _m_6711_a0_6712 = FLD(m_6711, 0); V _m_6711_a1_6713 = FLD(m_6711, 1); _r = ({ V p5123_6714 = _m_6711_a0_6712; ({ V p5124_6715 = _m_6711_a1_6713; ({ V t_6716 = d_Check_densure(c_1277_6690, p5123_6714, expected_1280_6693); V _r; if (tag_of(t_6716) == 0) _r = t_6716; else { V bound5126_6717 = FLD(t_6716, 0); _r = DONE(p5124_6715); } _r; }); }); }); } else rt_panic("match: no case at kernel:3256"); _r; }); } _r; }); }); break; } case 2: { V _m_6695_a0_6718 = FLD(m_6695, 0); V _m_6695_a1_6719 = FLD(m_6695, 1); _r = ({ V p5127_6720 = _m_6695_a0_6718; ({ V p5128_6721 = _m_6695_a1_6719; ({ V _r = 0; V m_6722 = d_Check_dcheck_uformer(c_1277_6690, p5127_6720, p5128_6721, expected_1280_6693, TRUE_V); switch (tag_of(m_6722)) { case 1: { V _m_6722_a0_6723 = FLD(m_6722, 0); _r = ({ V item5148_6724 = _m_6722_a0_6723; DONE(({ V local5130_6725 = item5148_6724; ({ V scrut5131_6726 = local5130_6725; d_Quantity_dempty(); }); })); }); break; } case 0: { V _m_6722_a0_6727 = FLD(m_6722, 0); _r = ({ V item5149_6728 = _m_6722_a0_6727; FAIL(item5149_6728); }); break; } default: rt_panic("match: no case at kernel:3258"); } _r; }); }); }); break; } case 3: { V _m_6695_a0_6729 = FLD(m_6695, 0); V _m_6695_a1_6730 = FLD(m_6695, 1); _r = ({ V p5150_6731 = _m_6695_a0_6729; ({ V p5151_6732 = _m_6695_a1_6730; ({ V _r = 0; V m_6733 = d_Check_dcheck_uformer(c_1277_6690, p5150_6731, p5151_6732, expected_1280_6693, FALSE_V); switch (tag_of(m_6733)) { case 1: { V _m_6733_a0_6734 = FLD(m_6733, 0); _r = ({ V item5155_6735 = _m_6733_a0_6734; DONE(({ V local5153_6736 = item5155_6735; ({ V scrut5154_6737 = local5153_6736; d_Quantity_dempty(); }); })); }); break; } case 0: { V _m_6733_a0_6738 = FLD(m_6733, 0); _r = ({ V item5156_6739 = _m_6733_a0_6738; FAIL(item5156_6739); }); break; } default: rt_panic("match: no case at kernel:3259"); } _r; }); }); }); break; } case 4: { V _m_6695_a0_6740 = FLD(m_6695, 0); V _m_6695_a1_6741 = FLD(m_6695, 1); V _m_6695_a2_6742 = FLD(m_6695, 2); _r = ({ V p5157_6743 = _m_6695_a0_6740; ({ V p5158_6744 = _m_6695_a1_6741; ({ V p5159_6745 = _m_6695_a2_6742; ({ V _r = 0; V m_6746 = d_Rules_drules(p5157_6743); switch (tag_of(m_6746)) { case 1: { V _m_6746_a0_6747 = FLD(m_6746, 0); _r = ({ V item5163_6748 = _m_6746_a0_6747; ({ V local5162_6749 = item5163_6748; apn(d_Get_dRules_dRule_upack_dintro_uin(local5162_6749), 7, (V[]){d_Check_dops(), c_1277_6690, mode_1278_6691, p5157_6743, p5158_6744, p5159_6745, expected_1280_6693}); }); }); break; } case 0: { V _m_6746_a0_6750 = FLD(m_6746, 0); _r = ({ V item5164_6751 = _m_6746_a0_6750; FAIL(item5164_6751); }); break; } default: rt_panic("match: no case at kernel:3260"); } _r; }); }); }); }); break; } case 5: { V _m_6695_a0_6752 = FLD(m_6695, 0); _r = ({ V p5165_6753 = _m_6695_a0_6752; ({ V _r = 0; V m_6754 = d_Rules_drules(d_Get_dTerm_dElim_de_ushape(p5165_6753)); switch (tag_of(m_6754)) { case 1: { V _m_6754_a0_6755 = FLD(m_6754, 0); _r = ({ V item5175_6756 = _m_6754_a0_6755; ({ V local5168_6757 = item5175_6756; ({ V t_6758 = apn(d_Get_dRules_dRule_upack_delim_uelim(local5168_6757), 5, (V[]){d_Check_dops(), c_1277_6690, mode_1278_6691, p5165_6753, SOME(expected_1280_6693)}); V _r; if (tag_of(t_6758) == 0) _r = t_6758; else { V bound5170_6759 = FLD(t_6758, 0); _r = ({ V _r = 0; V m_6760 = bound5170_6759; if ((tag_of(m_6760) == 0)) { V _m_6760_a0_6761 = FLD(m_6760, 0); V _m_6760_a1_6762 = FLD(m_6760, 1); _r = ({ V p5171_6763 = _m_6760_a0_6761; ({ V p5172_6764 = _m_6760_a1_6762; ({ V t_6765 = d_Check_densure(c_1277_6690, p5171_6763, expected_1280_6693); V _r; if (tag_of(t_6765) == 0) _r = t_6765; else { V bound5174_6766 = FLD(t_6765, 0); _r = DONE(p5172_6764); } _r; }); }); }); } else rt_panic("match: no case at kernel:3262"); _r; }); } _r; }); }); }); break; } case 0: { V _m_6754_a0_6767 = FLD(m_6754, 0); _r = ({ V item5176_6768 = _m_6754_a0_6767; FAIL(item5176_6768); }); break; } default: rt_panic("match: no case at kernel:3260"); } _r; }); }); break; } case 6: { V _m_6695_a0_6769 = FLD(m_6695, 0); V _m_6695_a1_6770 = FLD(m_6695, 1); _r = ({ V p5177_6771 = _m_6695_a0_6769; ({ V p5178_6772 = _m_6695_a1_6770; ({ V _r = 0; V m_6773 = d_Rules_drules(p5177_6771); switch (tag_of(m_6773)) { case 1: { V _m_6773_a0_6774 = FLD(m_6773, 0); _r = ({ V item5182_6775 = _m_6773_a0_6774; ({ V local5181_6776 = item5182_6775; apn(d_Get_dRules_dRule_upack_dintro_usec(local5181_6776), 6, (V[]){d_Check_dops(), c_1277_6690, mode_1278_6691, p5177_6771, p5178_6772, expected_1280_6693}); }); }); break; } case 0: { V _m_6773_a0_6777 = FLD(m_6773, 0); _r = ({ V item5183_6778 = _m_6773_a0_6777; FAIL(item5183_6778); }); break; } default: rt_panic("match: no case at kernel:3264"); } _r; }); }); }); break; } case 7: { V _m_6695_a0_6779 = FLD(m_6695, 0); V _m_6695_a1_6780 = FLD(m_6695, 1); V _m_6695_a2_6781 = FLD(m_6695, 2); _r = ({ V p5184_6782 = _m_6695_a0_6779; ({ V p5185_6783 = _m_6695_a1_6780; ({ V p5186_6784 = _m_6695_a2_6781; ({ V t_6785 = d_Check_dinfer_uuses(c_1277_6690, mode_1278_6691, t_1279_6692); V _r; if (tag_of(t_6785) == 0) _r = t_6785; else { V bound5188_6786 = FLD(t_6785, 0); _r = ({ V _r = 0; V m_6787 = bound5188_6786; if ((tag_of(m_6787) == 0)) { V _m_6787_a0_6788 = FLD(m_6787, 0); V _m_6787_a1_6789 = FLD(m_6787, 1); _r = ({ V p5189_6790 = _m_6787_a0_6788; ({ V p5190_6791 = _m_6787_a1_6789; ({ V t_6792 = d_Check_densure(c_1277_6690, p5189_6790, expected_1280_6693); V _r; if (tag_of(t_6792) == 0) _r = t_6792; else { V bound5192_6793 = FLD(t_6792, 0); _r = DONE(p5190_6791); } _r; }); }); }); } else rt_panic("match: no case at kernel:3266"); _r; }); } _r; }); }); }); }); break; } case 8: { V _m_6695_a0_6794 = FLD(m_6695, 0); V _m_6695_a1_6795 = FLD(m_6695, 1); V _m_6695_a2_6796 = FLD(m_6695, 2); V _m_6695_a3_6797 = FLD(m_6695, 3); _r = ({ V p5193_6798 = _m_6695_a0_6794; ({ V p5194_6799 = _m_6695_a1_6795; ({ V p5195_6800 = _m_6695_a2_6796; ({ V p5196_6801 = _m_6695_a3_6797; ({ V _r = 0; V m_6802 = d_Check_dlet_ubody(c_1277_6690, mode_1278_6691, p5193_6798, p5194_6799, p5195_6800, ({ V _c = clo_new(lam_6806, 1, 3); CLO_ENV(_c)[0] = mode_1278_6691; CLO_ENV(_c)[1] = p5196_6801; CLO_ENV(_c)[2] = expected_1280_6693; _c; })); switch (tag_of(m_6802)) { case 1: { V _m_6802_a0_6807 = FLD(m_6802, 0); _r = ({ V item5204_6808 = _m_6802_a0_6807; DONE(({ V local5199_6809 = item5204_6808; d_Get_dTuple2_dv1(local5199_6809); })); }); break; } case 0: { V _m_6802_a0_6810 = FLD(m_6802, 0); _r = ({ V item5205_6811 = _m_6802_a0_6810; FAIL(item5205_6811); }); break; } default: rt_panic("match: no case at kernel:3268"); } _r; }); }); }); }); }); break; } case 9: { V _m_6695_a0_6812 = FLD(m_6695, 0); V _m_6695_a1_6813 = FLD(m_6695, 1); _r = ({ V p5206_6814 = _m_6695_a0_6812; ({ V p5207_6815 = _m_6695_a1_6813; ({ V t_6816 = d_Check_dinfer_uuses(c_1277_6690, mode_1278_6691, t_1279_6692); V _r; if (tag_of(t_6816) == 0) _r = t_6816; else { V bound5209_6817 = FLD(t_6816, 0); _r = ({ V _r = 0; V m_6818 = bound5209_6817; if ((tag_of(m_6818) == 0)) { V _m_6818_a0_6819 = FLD(m_6818, 0); V _m_6818_a1_6820 = FLD(m_6818, 1); _r = ({ V p5210_6821 = _m_6818_a0_6819; ({ V p5211_6822 = _m_6818_a1_6820; ({ V t_6823 = d_Check_densure(c_1277_6690, p5210_6821, expected_1280_6693); V _r; if (tag_of(t_6823) == 0) _r = t_6823; else { V bound5213_6824 = FLD(t_6823, 0); _r = DONE(p5211_6822); } _r; }); }); }); } else rt_panic("match: no case at kernel:3272"); _r; }); } _r; }); }); }); break; } case 10: { V _m_6695_a0_6825 = FLD(m_6695, 0); _r = ({ V p5214_6826 = _m_6695_a0_6825; ({ V t_6827 = d_Check_dinfer_uuses(c_1277_6690, mode_1278_6691, t_1279_6692); V _r; if (tag_of(t_6827) == 0) _r = t_6827; else { V bound5216_6828 = FLD(t_6827, 0); _r = ({ V _r = 0; V m_6829 = bound5216_6828; if ((tag_of(m_6829) == 0)) { V _m_6829_a0_6830 = FLD(m_6829, 0); V _m_6829_a1_6831 = FLD(m_6829, 1); _r = ({ V p5217_6832 = _m_6829_a0_6830; ({ V p5218_6833 = _m_6829_a1_6831; ({ V t_6834 = d_Check_densure(c_1277_6690, p5217_6832, expected_1280_6693); V _r; if (tag_of(t_6834) == 0) _r = t_6834; else { V bound5220_6835 = FLD(t_6834, 0); _r = DONE(p5218_6833); } _r; }); }); }); } else rt_panic("match: no case at kernel:3276"); _r; }); } _r; }); }); break; } case 11: { V _m_6695_a0_6836 = FLD(m_6695, 0); _r = ({ V p5221_6837 = _m_6695_a0_6836; ({ V t_6838 = d_Check_dinfer_uuses(c_1277_6690, mode_1278_6691, t_1279_6692); V _r; if (tag_of(t_6838) == 0) _r = t_6838; else { V bound5223_6839 = FLD(t_6838, 0); _r = ({ V _r = 0; V m_6840 = bound5223_6839; if ((tag_of(m_6840) == 0)) { V _m_6840_a0_6841 = FLD(m_6840, 0); V _m_6840_a1_6842 = FLD(m_6840, 1); _r = ({ V p5224_6843 = _m_6840_a0_6841; ({ V p5225_6844 = _m_6840_a1_6842; ({ V t_6845 = d_Check_densure(c_1277_6690, p5224_6843, expected_1280_6693); V _r; if (tag_of(t_6845) == 0) _r = t_6845; else { V bound5227_6846 = FLD(t_6845, 0); _r = DONE(p5225_6844); } _r; }); }); }); } else rt_panic("match: no case at kernel:3280"); _r; }); } _r; }); }); break; } case 12: {  _r = ({ V __6847 = UNIT; ({ V t_6848 = d_Check_dinfer_uuses(c_1277_6690, mode_1278_6691, t_1279_6692); V _r; if (tag_of(t_6848) == 0) _r = t_6848; else { V bound5229_6849 = FLD(t_6848, 0); _r = ({ V _r = 0; V m_6850 = bound5229_6849; if ((tag_of(m_6850) == 0)) { V _m_6850_a0_6851 = FLD(m_6850, 0); V _m_6850_a1_6852 = FLD(m_6850, 1); _r = ({ V p5230_6853 = _m_6850_a0_6851; ({ V p5231_6854 = _m_6850_a1_6852; ({ V t_6855 = d_Check_densure(c_1277_6690, p5230_6853, expected_1280_6693); V _r; if (tag_of(t_6855) == 0) _r = t_6855; else { V bound5233_6856 = FLD(t_6855, 0); _r = DONE(p5231_6854); } _r; }); }); }); } else rt_panic("match: no case at kernel:3284"); _r; }); } _r; }); }); break; } default: rt_panic("match: no case at kernel:3250"); } _r; }); });
}
V d_Check_dinfer_uuniv(V c_1003_6857, V t_1004_6858) {
  return ({ V t_6859 = d_Check_dinfer_uuses(c_1003_6857, ((V)0), t_1004_6858); V _r; if (tag_of(t_6859) == 0) _r = t_6859; else { V bound5235_6860 = FLD(t_6859, 0); _r = ({ V _r = 0; V m_6861 = bound5235_6860; if ((tag_of(m_6861) == 0)) { V _m_6861_a0_6862 = FLD(m_6861, 0); V _m_6861_a1_6863 = FLD(m_6861, 1); _r = ({ V p5236_6864 = _m_6861_a0_6862; ({ V p5237_6865 = _m_6861_a1_6863; ({ V t_6866 = d_Eval_dwhnf(d_Get_dCheck_dCtx_dglobals(c_1003_6857), p5236_6864); V _r; if (tag_of(t_6866) == 0) _r = t_6866; else { V bound5239_6867 = FLD(t_6866, 0); _r = ({ V local5242_6868 = d_Value_das_uuniv(bound5239_6867); ({ V _r = 0; V m_6869 = local5242_6868; if (((m_6869) == NONE)) {  _r = ({ V __6870 = UNIT; FAIL(rt_ctor1(5, str_append(((V)&S_166), d_Check_dpp_uvalue(c_1003_6857, bound5239_6867)))); }); } else if (((m_6869) != NONE)) { V _m_6869_a0_6871 = FLD(m_6869, 0); _r = ({ V x_6872 = _m_6869_a0_6871; DONE(x_6872); }); } else rt_panic("match: no case at kernel:3293"); _r; }); }); } _r; }); }); }); } else rt_panic("match: no case at kernel:3291"); _r; }); } _r; });
}
V d_Check_dlet_ubody(V c_1324_6873, V mode_1325_6874, V x_1326_6875, V ty_1327_6876, V def_1328_6877, V body_1329_6878) {
  return ({ V t_6879 = d_Check_dinfer_uuniv(c_1324_6873, ty_1327_6876); V _r; if (tag_of(t_6879) == 0) _r = t_6879; else { V bound4352_6880 = FLD(t_6879, 0); _r = ({ V t_6881 = d_Eval_deval(d_Get_dCheck_dCtx_dglobals(c_1324_6873), d_Get_dCheck_dCtx_denv(c_1324_6873), ty_1327_6876); V _r; if (tag_of(t_6881) == 0) _r = t_6881; else { V bound4354_6882 = FLD(t_6881, 0); _r = ({ V t_6883 = d_Check_dcheck_uuses(c_1324_6873, d_Quantity_druntime(mode_1325_6874), def_1328_6877, bound4354_6882); V _r; if (tag_of(t_6883) == 0) _r = t_6883; else { V bound4356_6884 = FLD(t_6883, 0); _r = ({ V t_6885 = d_Eval_deval(d_Get_dCheck_dCtx_dglobals(c_1324_6873), d_Get_dCheck_dCtx_denv(c_1324_6873), def_1328_6877); V _r; if (tag_of(t_6885) == 0) _r = t_6885; else { V bound4358_6886 = FLD(t_6885, 0); _r = ({ V scrut4374_6887 = d_SeqList_dexists(({ V _c = clo_new(lam_6902, 1, 2); CLO_ENV(_c)[0] = c_1324_6873; CLO_ENV(_c)[1] = bound4356_6884; _c; }), d_SeqList_dmapi(clo_new(lam_6905, 2, 0), d_Get_dCheck_dCtx_dlocals(c_1324_6873))); ({ V scrut4375_6906 = ((d_Quantity_dequal(mode_1325_6874, ((V)0))) != FALSE_V ? ((V)0) : ((scrut4374_6887) != FALSE_V ? ((V)1) : ((V)2))); ({ V scrut4376_6907 = d_Check_ddefine(x_1326_6875, scrut4375_6906, bound4354_6882, bound4358_6886, c_1324_6873); ({ V t_6908 = ap(body_1329_6878, scrut4376_6907); V _r; if (tag_of(t_6908) == 0) _r = t_6908; else { V bound4378_6909 = FLD(t_6908, 0); _r = ({ V _r = 0; V m_6910 = bound4378_6909; if ((tag_of(m_6910) == 0)) { V _m_6910_a0_6911 = FLD(m_6910, 0); V _m_6910_a1_6912 = FLD(m_6910, 1); _r = ({ V p4379_6913 = _m_6910_a0_6911; ({ V p4380_6914 = _m_6910_a1_6912; ({ V t_6915 = d_Check_dclose(SOME(scrut4374_6887), scrut4376_6907, d_Get_dCheck_dCtx_dsize(c_1324_6873), mode_1325_6874, p4380_6914); V _r; if (tag_of(t_6915) == 0) _r = t_6915; else { V bound4382_6916 = FLD(t_6915, 0); _r = DONE(rt_ctor2(0, p4379_6913, d_Quantity_dsequence(d_Quantity_dscale(mode_1325_6874, bound4356_6884), bound4382_6916))); } _r; }); }); }); } else rt_panic("match: no case at kernel:3307"); _r; }); } _r; }); }); }); }); } _r; }); } _r; }); } _r; }); } _r; });
}
V d_Global_dentry_uty(V e_776_6917) {
  return ({ V scrut5287_6918 = e_776_6917; ({ V _r = 0; V m_6919 = scrut5287_6918; switch (tag_of(m_6919)) { case 0: { V _m_6919_a0_6920 = FLD(m_6919, 0); _r = ({ V p5288_6921 = _m_6919_a0_6920; d_Get_dGlobal_dDef_uentry_dty(p5288_6921); }); break; } case 1: { V _m_6919_a0_6922 = FLD(m_6919, 0); _r = ({ V p5289_6923 = _m_6919_a0_6922; d_Get_dGlobal_dAxiom_uentry_dax_uty(p5289_6923); }); break; } case 2: { V _m_6919_a0_6924 = FLD(m_6919, 0); _r = ({ V p5290_6925 = _m_6919_a0_6924; d_Get_dGlobal_dPrim_uentry_dp_uty(p5290_6925); }); break; } default: rt_panic("match: no case at kernel:3313"); } _r; }); });
}
V d_Check_dhead_uty(V c_970_6926, V h_971_6927) {
  return ({ V scrut5254_6928 = h_971_6927; ({ V _r = 0; V m_6929 = scrut5254_6928; switch (tag_of(m_6929)) { case 0: { V _m_6929_a0_6930 = FLD(m_6929, 0); _r = ({ V p5255_6931 = _m_6929_a0_6930; ({ V local5261_6932 = ({ V local5258_6933 = d_Rules_dat(d_NativeInt_dsub(d_NativeInt_dsub(d_Get_dCheck_dCtx_dsize(c_970_6926), p5255_6931), d_Big_done()), d_Get_dCheck_dCtx_dlocals(c_970_6926)); ({ V _r = 0; V m_6934 = local5258_6933; if (((m_6934) == NONE)) {  _r = ({ V __6935 = UNIT; FAIL(rt_ctor1(3, ((V)&S_167))); }); } else if (((m_6934) != NONE)) { V _m_6934_a0_6936 = FLD(m_6934, 0); _r = ({ V x_6937 = _m_6934_a0_6936; DONE(x_6937); }); } else rt_panic("match: no case at kernel:3318"); _r; }); }); ({ V _r = 0; V m_6938 = local5261_6932; switch (tag_of(m_6938)) { case 1: { V _m_6938_a0_6939 = FLD(m_6938, 0); _r = ({ V item5268_6940 = _m_6938_a0_6939; DONE(({ V local5263_6941 = item5268_6940; ({ V scrut5264_6942 = local5263_6941; ({ V _r = 0; V m_6943 = scrut5264_6942; if ((tag_of(m_6943) == 0)) { V _m_6943_a0_6944 = FLD(m_6943, 0); V _m_6943_a1_6945 = FLD(m_6943, 1); V _m_6943_a2_6946 = FLD(m_6943, 2); _r = ({ V p5265_6947 = _m_6943_a0_6944; ({ V p5266_6948 = _m_6943_a1_6945; ({ V p5267_6949 = _m_6943_a2_6946; p5267_6949; }); }); }); } else rt_panic("match: no case at kernel:3318"); _r; }); }); })); }); break; } case 0: { V _m_6938_a0_6950 = FLD(m_6938, 0); _r = ({ V item5269_6951 = _m_6938_a0_6950; FAIL(item5269_6951); }); break; } default: rt_panic("match: no case at kernel:3317"); } _r; }); }); }); break; } case 1: { V _m_6929_a0_6952 = FLD(m_6929, 0); _r = ({ V p5270_6953 = _m_6929_a0_6952; ({ V local5276_6954 = ({ V local5273_6955 = d_Global_dfind(p5270_6953, d_Get_dCheck_dCtx_dglobals(c_970_6926)); ({ V _r = 0; V m_6956 = local5273_6955; if (((m_6956) == NONE)) {  _r = ({ V __6957 = UNIT; FAIL(rt_ctor1(3, p5270_6953)); }); } else if (((m_6956) != NONE)) { V _m_6956_a0_6958 = FLD(m_6956, 0); _r = ({ V x_6959 = _m_6956_a0_6958; DONE(x_6959); }); } else rt_panic("match: no case at kernel:3318"); _r; }); }); ({ V local5280_6960 = local5276_6954; ({ V local5282_6961 = ({ V _c = clo_new(lam_6963, 1, 1); CLO_ENV(_c)[0] = c_970_6926; _c; }); ({ V _r = 0; V m_6964 = local5280_6960; switch (tag_of(m_6964)) { case 1: { V _m_6964_a0_6965 = FLD(m_6964, 0); _r = ({ V item5283_6966 = _m_6964_a0_6965; ap(local5282_6961, item5283_6966); }); break; } case 0: { V _m_6964_a0_6967 = FLD(m_6964, 0); _r = ({ V item5284_6968 = _m_6964_a0_6967; FAIL(item5284_6968); }); break; } default: rt_panic("match: no case at kernel:3318"); } _r; }); }); }); }); }); break; } default: rt_panic("match: no case at kernel:3317"); } _r; }); });
}
V d_Check_dstring_uword(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_168); rt_root(&memo); done = 1; }
  return memo;
}
V d_Check_dinfer_unode(V c_1012_6969, V mode_1013_6970, V t_1014_6971) {
  return ({ V scrut4295_6972 = t_1014_6971; ({ V _r = 0; V m_6973 = scrut4295_6972; switch (tag_of(m_6973)) { case 0: { V _m_6973_a0_6974 = FLD(m_6973, 0); _r = ({ V p4296_6975 = _m_6973_a0_6974; ({ V t_6976 = ({ V local4305_6977 = d_Rules_dat(p4296_6975, d_Get_dCheck_dCtx_dlocals(c_1012_6969)); ({ V _r = 0; V m_6978 = local4305_6977; if (((m_6978) == NONE)) {  _r = ({ V __6979 = UNIT; FAIL(rt_ctor1(3, str_concat(CON(((V)&S_118), CON(d_Big_dshow(p4296_6975), CON(((V)&S_169), NIL)))))); }); } else if (((m_6978) != NONE)) { V _m_6978_a0_6980 = FLD(m_6978, 0); _r = ({ V x_6981 = _m_6978_a0_6980; DONE(x_6981); }); } else rt_panic("match: no case at kernel:3326"); _r; }); }); V _r; if (tag_of(t_6976) == 0) _r = t_6976; else { V bound4298_6982 = FLD(t_6976, 0); _r = ({ V _r = 0; V m_6983 = bound4298_6982; if ((tag_of(m_6983) == 0)) { V _m_6983_a0_6984 = FLD(m_6983, 0); V _m_6983_a1_6985 = FLD(m_6983, 1); V _m_6983_a2_6986 = FLD(m_6983, 2); _r = ({ V p4299_6987 = _m_6983_a0_6984; ({ V p4300_6988 = _m_6983_a1_6985; ({ V p4301_6989 = _m_6983_a2_6986; ((d_Check_dreadable(mode_1013_6970, p4300_6988)) != FALSE_V ? DONE(rt_ctor2(0, p4301_6989, d_Quantity_doccurrence(d_NativeInt_dsub(d_NativeInt_dsub(d_Get_dCheck_dCtx_dsize(c_1012_6969), p4296_6975), d_Big_done()), mode_1013_6970))) : FAIL(rt_ctor1(6, str_concat(CON(((V)&S_170), CON(p4299_6987, CON(((V)&S_171), NIL))))))); }); }); }); } else rt_panic("match: no case at kernel:3327"); _r; }); } _r; }); }); break; } case 1: { V _m_6973_a0_6990 = FLD(m_6973, 0); _r = ({ V p4307_6991 = _m_6973_a0_6990; DONE(rt_ctor2(0, rt_ctor1(0, d_Level_dsucc(p4307_6991)), d_Quantity_dempty())); }); break; } case 2: { V _m_6973_a0_6992 = FLD(m_6973, 0); V _m_6973_a1_6993 = FLD(m_6973, 1); _r = ({ V p4308_6994 = _m_6973_a0_6992; ({ V p4309_6995 = _m_6973_a1_6993; ({ V _r = 0; V m_6996 = d_Rules_drules(p4308_6994); switch (tag_of(m_6996)) { case 1: { V _m_6996_a0_6997 = FLD(m_6996, 0); _r = ({ V item4315_6998 = _m_6996_a0_6997; ({ V local4312_6999 = item4315_6998; ({ V t_7000 = apn(d_Get_dRules_dRule_upack_dform_ulan(local4312_6999), 5, (V[]){d_Check_dops(), c_1012_6969, p4308_6994, p4309_6995, NONE}); V _r; if (tag_of(t_7000) == 0) _r = t_7000; else { V bound4314_7001 = FLD(t_7000, 0); _r = DONE(rt_ctor2(0, rt_ctor1(0, bound4314_7001), d_Quantity_dempty())); } _r; }); }); }); break; } case 0: { V _m_6996_a0_7002 = FLD(m_6996, 0); _r = ({ V item4316_7003 = _m_6996_a0_7002; FAIL(item4316_7003); }); break; } default: rt_panic("match: no case at kernel:3327"); } _r; }); }); }); break; } case 3: { V _m_6973_a0_7004 = FLD(m_6973, 0); V _m_6973_a1_7005 = FLD(m_6973, 1); _r = ({ V p4317_7006 = _m_6973_a0_7004; ({ V p4318_7007 = _m_6973_a1_7005; ({ V _r = 0; V m_7008 = d_Rules_drules(p4317_7006); switch (tag_of(m_7008)) { case 1: { V _m_7008_a0_7009 = FLD(m_7008, 0); _r = ({ V item4324_7010 = _m_7008_a0_7009; ({ V local4321_7011 = item4324_7010; ({ V t_7012 = apn(d_Get_dRules_dRule_upack_dform_uran(local4321_7011), 5, (V[]){d_Check_dops(), c_1012_6969, p4317_7006, p4318_7007, NONE}); V _r; if (tag_of(t_7012) == 0) _r = t_7012; else { V bound4323_7013 = FLD(t_7012, 0); _r = DONE(rt_ctor2(0, rt_ctor1(0, bound4323_7013), d_Quantity_dempty())); } _r; }); }); }); break; } case 0: { V _m_7008_a0_7014 = FLD(m_7008, 0); _r = ({ V item4325_7015 = _m_7008_a0_7014; FAIL(item4325_7015); }); break; } default: rt_panic("match: no case at kernel:3329"); } _r; }); }); }); break; } case 4: { V _m_6973_a0_7016 = FLD(m_6973, 0); V _m_6973_a1_7017 = FLD(m_6973, 1); V _m_6973_a2_7018 = FLD(m_6973, 2); _r = ({ V p4326_7019 = _m_6973_a0_7016; ({ V p4327_7020 = _m_6973_a1_7017; ({ V p4328_7021 = _m_6973_a2_7018; FAIL(d_Check_dno_uinfer(((V)&S_172))); }); }); }); break; } case 5: { V _m_6973_a0_7022 = FLD(m_6973, 0); _r = ({ V p4329_7023 = _m_6973_a0_7022; ({ V _r = 0; V m_7024 = d_Rules_drules(d_Get_dTerm_dElim_de_ushape(p4329_7023)); switch (tag_of(m_7024)) { case 1: { V _m_7024_a0_7025 = FLD(m_7024, 0); _r = ({ V item4333_7026 = _m_7024_a0_7025; ({ V local4332_7027 = item4333_7026; apn(d_Get_dRules_dRule_upack_delim_uelim(local4332_7027), 5, (V[]){d_Check_dops(), c_1012_6969, mode_1013_6970, p4329_7023, NONE}); }); }); break; } case 0: { V _m_7024_a0_7028 = FLD(m_7024, 0); _r = ({ V item4334_7029 = _m_7024_a0_7028; FAIL(item4334_7029); }); break; } default: rt_panic("match: no case at kernel:3331"); } _r; }); }); break; } case 6: { V _m_6973_a0_7030 = FLD(m_6973, 0); V _m_6973_a1_7031 = FLD(m_6973, 1); _r = ({ V p4335_7032 = _m_6973_a0_7030; ({ V p4336_7033 = _m_6973_a1_7031; FAIL(d_Check_dno_uinfer(((V)&S_173))); }); }); break; } case 7: { V _m_6973_a0_7034 = FLD(m_6973, 0); V _m_6973_a1_7035 = FLD(m_6973, 1); V _m_6973_a2_7036 = FLD(m_6973, 2); _r = ({ V p4337_7037 = _m_6973_a0_7034; ({ V p4338_7038 = _m_6973_a1_7035; ({ V p4339_7039 = _m_6973_a2_7036; ({ V _r = 0; V m_7040 = d_Rules_drules(p4337_7037); switch (tag_of(m_7040)) { case 1: { V _m_7040_a0_7041 = FLD(m_7040, 0); _r = ({ V item4343_7042 = _m_7040_a0_7041; ({ V local4342_7043 = item4343_7042; apn(d_Get_dRules_dRule_upack_delim_uout(local4342_7043), 6, (V[]){d_Check_dops(), c_1012_6969, mode_1013_6970, p4337_7037, p4338_7038, p4339_7039}); }); }); break; } case 0: { V _m_7040_a0_7044 = FLD(m_7040, 0); _r = ({ V item4344_7045 = _m_7040_a0_7044; FAIL(item4344_7045); }); break; } default: rt_panic("match: no case at kernel:3331"); } _r; }); }); }); }); break; } case 8: { V _m_6973_a0_7046 = FLD(m_6973, 0); V _m_6973_a1_7047 = FLD(m_6973, 1); V _m_6973_a2_7048 = FLD(m_6973, 2); V _m_6973_a3_7049 = FLD(m_6973, 3); _r = ({ V p4345_7050 = _m_6973_a0_7046; ({ V p4346_7051 = _m_6973_a1_7047; ({ V p4347_7052 = _m_6973_a2_7048; ({ V p4348_7053 = _m_6973_a3_7049; d_Check_dlet_ubody(c_1012_6969, mode_1013_6970, p4345_7050, p4346_7051, p4347_7052, ({ V _c = clo_new(lam_7055, 1, 2); CLO_ENV(_c)[0] = mode_1013_6970; CLO_ENV(_c)[1] = p4348_7053; _c; })); }); }); }); }); break; } case 9: { V _m_6973_a0_7056 = FLD(m_6973, 0); V _m_6973_a1_7057 = FLD(m_6973, 1); _r = ({ V p5243_7058 = _m_6973_a0_7056; ({ V p5244_7059 = _m_6973_a1_7057; ({ V t_7060 = d_Check_dinfer_uuniv(c_1012_6969, p5244_7059); V _r; if (tag_of(t_7060) == 0) _r = t_7060; else { V bound5246_7061 = FLD(t_7060, 0); _r = ({ V t_7062 = d_Eval_deval(d_Get_dCheck_dCtx_dglobals(c_1012_6969), d_Get_dCheck_dCtx_denv(c_1012_6969), p5244_7059); V _r; if (tag_of(t_7062) == 0) _r = t_7062; else { V bound5248_7063 = FLD(t_7062, 0); _r = ({ V t_7064 = d_Check_dcheck_uuses(c_1012_6969, mode_1013_6970, p5243_7058, bound5248_7063); V _r; if (tag_of(t_7064) == 0) _r = t_7064; else { V bound5250_7065 = FLD(t_7064, 0); _r = DONE(rt_ctor2(0, bound5248_7063, bound5250_7065)); } _r; }); } _r; }); } _r; }); }); }); break; } case 10: { V _m_6973_a0_7066 = FLD(m_6973, 0); _r = ({ V p5251_7067 = _m_6973_a0_7066; ({ V t_7068 = d_Check_dhead_uty(c_1012_6969, rt_ctor1(1, p5251_7067)); V _r; if (tag_of(t_7068) == 0) _r = t_7068; else { V bound5253_7069 = FLD(t_7068, 0); _r = DONE(rt_ctor2(0, bound5253_7069, d_Quantity_dempty())); } _r; }); }); break; } case 11: { V _m_6973_a0_7070 = FLD(m_6973, 0); _r = ({ V p5291_7071 = _m_6973_a0_7070; ({ V _r = 0; V m_7072 = p5291_7071; switch (tag_of(m_7072)) { case 0: { V _m_7072_a0_7073 = FLD(m_7072, 0); _r = ({ V p5292_7074 = _m_7072_a0_7073; FAIL(rt_ctor1(0, d_Check_dstring_uword())); }); break; } case 1: { V _m_7072_a0_7075 = FLD(m_7072, 0); _r = ({ V p5293_7076 = _m_7072_a0_7075; ((d_Big_dis_ult(d_Bignum_dsign(p5293_7076), d_Big_dzero())) != FALSE_V ? FAIL(rt_ctor1(4, ((V)&S_174))) : ({ V t_7077 = d_Eval_deval(d_Get_dCheck_dCtx_dglobals(c_1012_6969), NIL, d_Prim_dnat_uty()); V _r; if (tag_of(t_7077) == 0) _r = t_7077; else { V bound5295_7078 = FLD(t_7077, 0); _r = DONE(rt_ctor2(0, bound5295_7078, d_Quantity_dempty())); } _r; })); }); break; } default: rt_panic("match: no case at kernel:3337"); } _r; }); }); break; } case 12: {  _r = ({ V __7079 = UNIT; FAIL(rt_ctor1(0, d_Rules_dauto_uword())); }); break; } default: rt_panic("match: no case at kernel:3325"); } _r; }); });
}
V d_Check_dinfer_uuses(V c_1009_7080, V mode_1010_7081, V t_1011_7082) {
  return ((d_Budget_dexhausted(d_Get_dCheck_dCtx_dbudget(c_1009_7080))) != FALSE_V ? FAIL(rt_ctor1(11, d_Check_dbudget_umsg())) : d_Check_dinfer_unode(c_1009_7080, mode_1010_7081, t_1011_7082));
}
V d_Check_dbind(V x_467_7083, V q_468_7084, V ty_469_7085, V c_470_7086) {
  return ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dCheck_dCtx_dglobals(c_470_7086); _o->f[1] = CON(d_Value_dvar(d_Get_dCheck_dCtx_dsize(c_470_7086)), d_Get_dCheck_dCtx_denv(c_470_7086)); _o->f[2] = CON(rt_ctor3(0, x_467_7083, q_468_7084, ty_469_7085), d_Get_dCheck_dCtx_dlocals(c_470_7086)); _o->f[3] = d_NativeInt_dadd(d_Get_dCheck_dCtx_dsize(c_470_7086), d_Big_done()); _o->f[4] = d_Get_dCheck_dCtx_dbudget(c_470_7086); (V)_o; });
}
V d_Check_dops(void) {
  static V memo; static int done;
  if (!done) { memo = ({ Obj *_o = rt_ctor(0, 16); _o->f[0] = clo_new(lam_7090, 3, 0); _o->f[1] = clo_new(lam_7095, 4, 0); _o->f[2] = clo_new(lam_7100, 4, 0); _o->f[3] = clo_new(lam_7103, 2, 0); _o->f[4] = clo_new(lam_7108, 4, 0); _o->f[5] = clo_new(lam_7112, 3, 0); _o->f[6] = clo_new(lam_7115, 2, 0); _o->f[7] = clo_new(lam_7118, 2, 0); _o->f[8] = clo_new(lam_7123, 4, 0); _o->f[9] = clo_new(lam_7125, 1, 0); _o->f[10] = clo_new(lam_7127, 1, 0); _o->f[11] = clo_new(lam_7129, 1, 0); _o->f[12] = clo_new(lam_7132, 2, 0); _o->f[13] = clo_new(lam_7135, 2, 0); _o->f[14] = clo_new(lam_7138, 2, 0); _o->f[15] = clo_new(lam_7141, 2, 0); (V)_o; }); rt_root(&memo); done = 1; }
  return memo;
}
V d_Check_dinfer(V c_1350_7142, V mode_1351_7143, V t_1352_7144) {
  return ({ V _r = 0; V m_7145 = d_Check_dinfer_uuses(c_1350_7142, d_Quantity_druntime(mode_1351_7143), t_1352_7144); switch (tag_of(m_7145)) { case 1: { V _m_7145_a0_7146 = FLD(m_7145, 0); _r = ({ V item5432_7147 = _m_7145_a0_7146; DONE(({ V local5431_7148 = item5432_7147; d_Get_dTuple2_dv0(local5431_7148); })); }); break; } case 0: { V _m_7145_a0_7149 = FLD(m_7145, 0); _r = ({ V item5433_7150 = _m_7145_a0_7149; FAIL(item5433_7150); }); break; } default: rt_panic("match: no case at kernel:3351"); } _r; });
}
V d_Check_dcheck(V c_1355_7151, V mode_1356_7152, V t_1357_7153, V expected_1358_7154) {
  return ({ V _r = 0; V m_7155 = d_Check_dcheck_uuses(c_1355_7151, d_Quantity_druntime(mode_1356_7152), t_1357_7153, expected_1358_7154); switch (tag_of(m_7155)) { case 1: { V _m_7155_a0_7156 = FLD(m_7155, 0); _r = ({ V item6286_7157 = _m_7155_a0_7156; DONE(({ V local6285_7158 = item6286_7157; UNIT; })); }); break; } case 0: { V _m_7155_a0_7159 = FLD(m_7155, 0); _r = ({ V item6287_7160 = _m_7155_a0_7159; FAIL(item6287_7160); }); break; } default: rt_panic("match: no case at kernel:3354"); } _r; });
}
V d_Check_dmissing_ubody(V n_1370_7161) {
  return rt_ctor1(10, str_append(((V)&S_175), str_append(n_1370_7161, ((V)&S_176))));
}
V d_Check_dcheck_udecl(V globals_1373_7162, V budget_1374_7163, V d_1375_7164) {
  return ({ V scrut6274_7165 = d_Check_dmake(globals_1373_7162, budget_1374_7163); ({ V t_7166 = d_Check_dinfer_uuniv(scrut6274_7165, d_Get_dCheck_dDecl_dd_uty(d_1375_7164)); V _r; if (tag_of(t_7166) == 0) _r = t_7166; else { V bound6276_7167 = FLD(t_7166, 0); _r = ({ V t_7168 = d_Eval_deval(globals_1373_7162, NIL, d_Get_dCheck_dDecl_dd_uty(d_1375_7164)); V _r; if (tag_of(t_7168) == 0) _r = t_7168; else { V bound6278_7169 = FLD(t_7168, 0); _r = ({ V scrut6279_7170 = d_Get_dCheck_dDecl_dd_ukind(d_1375_7164); ({ V _r = 0; V m_7171 = scrut6279_7170; switch (tag_of(m_7171)) { case 0: {  _r = ({ V __7172 = UNIT; ({ V t_7173 = ({ V local6290_7174 = d_Get_dCheck_dDecl_dd_ubody(d_1375_7164); ({ V _r = 0; V m_7175 = local6290_7174; if (((m_7175) == NONE)) {  _r = ({ V __7176 = UNIT; FAIL(d_Check_dmissing_ubody(d_Get_dCheck_dDecl_dd_uname(d_1375_7164))); }); } else if (((m_7175) != NONE)) { V _m_7175_a0_7177 = FLD(m_7175, 0); _r = ({ V x_7178 = _m_7175_a0_7177; DONE(x_7178); }); } else rt_panic("match: no case at kernel:3366"); _r; }); }); V _r; if (tag_of(t_7173) == 0) _r = t_7173; else { V bound6281_7179 = FLD(t_7173, 0); _r = ({ V t_7180 = d_Check_dcheck(scrut6274_7165, ((V)2), bound6281_7179, bound6278_7169); V _r; if (tag_of(t_7180) == 0) _r = t_7180; else { V bound6283_7181 = FLD(t_7180, 0); _r = DONE(rt_ctor1(0, ({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dCheck_dDecl_dd_uty(d_1375_7164); _o->f[1] = bound6281_7179; _o->f[2] = TRUE_V; _o->f[3] = NONE; _o->f[4] = FALSE_V; (V)_o; }))); } _r; }); } _r; }); }); break; } case 1: {  _r = ({ V __7182 = UNIT; DONE(rt_ctor1(1, rt_ctor1(0, d_Get_dCheck_dDecl_dd_uty(d_1375_7164)))); }); break; } default: rt_panic("match: no case at kernel:3365"); } _r; }); }); } _r; }); } _r; }); });
}
V d_Check_dcheck_udecls(V _opt__1395_7183, V globals_1384_7184, V ds_1385_7185) {
  return ({ V scrut6263_7186 = ({ V scrut6261_7187 = _opt__1395_7183; ({ V _r = 0; V m_7188 = scrut6261_7187; if (((m_7188) == NONE)) {  _r = ({ V __7189 = UNIT; d_Budget_dunlimited(); }); } else if (((m_7188) != NONE)) { V _m_7188_a0_7190 = FLD(m_7188, 0); _r = ({ V p6262_7191 = _m_7188_a0_7190; p6262_7191; }); } else rt_panic("match: no case at kernel:3372"); _r; }); }); ({ V local6294_7192 = d_SeqList_dfold(({ V _c = clo_new(lam_7204, 2, 1); CLO_ENV(_c)[0] = scrut6263_7186; _c; }), ds_1385_7185, DONE(rt_ctor2(0, globals_1384_7184, NIL))); ({ V _r = 0; V m_7205 = local6294_7192; switch (tag_of(m_7205)) { case 1: { V _m_7205_a0_7206 = FLD(m_7205, 0); _r = ({ V item6300_7207 = _m_7205_a0_7206; DONE(({ V local6296_7208 = item6300_7207; ({ V scrut6297_7209 = local6296_7208; ({ V _r = 0; V m_7210 = scrut6297_7209; if ((tag_of(m_7210) == 0)) { V _m_7210_a0_7211 = FLD(m_7210, 0); V _m_7210_a1_7212 = FLD(m_7210, 1); _r = ({ V p6298_7213 = _m_7210_a0_7211; ({ V p6299_7214 = _m_7210_a1_7212; list_reverse(p6299_7214); }); }); } else rt_panic("match: no case at kernel:3374"); _r; }); }); })); }); break; } case 0: { V _m_7205_a0_7215 = FLD(m_7205, 0); _r = ({ V item6301_7216 = _m_7205_a0_7215; FAIL(item6301_7216); }); break; } default: rt_panic("match: no case at kernel:3373"); } _r; }); }); });
}
V d_Check_dcheck_utelescope(V c_1422_7217, V tele_1423_7218) {
  return d_SeqList_dfold(clo_new(lam_7247, 2, 0), tele_1423_7218, DONE(c_1422_7217));
}
V d_Level_dle(V a_337_7248, V b_338_7249) {
  return d_Big_dis_ule(a_337_7248, b_338_7249);
}
V d_Check_dindex_urules(V c_1434_7250, V name_1435_7251, V level_1436_7252, V param_1442_7253) {
  return ({ V scrut6513_7254 = param_1442_7253; ({ V _r = 0; V m_7255 = scrut6513_7254; if ((tag_of(m_7255) == 0)) { V _m_7255_a0_7256 = FLD(m_7255, 0); V _m_7255_a1_7257 = FLD(m_7255, 1); V _m_7255_a2_7258 = FLD(m_7255, 2); _r = ({ V p6514_7259 = _m_7255_a0_7256; ({ V p6515_7260 = _m_7255_a1_7257; ({ V p6516_7261 = _m_7255_a2_7258; ({ V t_7262 = ((d_Quantity_dequal(p6514_7259, ((V)0))) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(12, str_concat(CON(((V)&S_177), CON(p6515_7260, CON(((V)&S_89), CON(name_1435_7251, CON(((V)&S_178), CON(d_Quantity_dto_ustring(p6514_7259), CON(((V)&S_179), NIL))))))))))); V _r; if (tag_of(t_7262) == 0) _r = t_7262; else { V bound6518_7263 = FLD(t_7262, 0); _r = ({ V t_7264 = d_Check_dinfer_uuniv(c_1434_7250, p6516_7261); V _r; if (tag_of(t_7264) == 0) _r = t_7264; else { V bound6520_7265 = FLD(t_7264, 0); _r = ((d_Level_dle(bound6520_7265, level_1436_7252)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(13, str_concat(CON(((V)&S_177), CON(p6515_7260, CON(((V)&S_89), CON(name_1435_7251, CON(((V)&S_180), CON(d_Level_dto_ustring(bound6520_7265), CON(((V)&S_181), CON(name_1435_7251, CON(((V)&S_182), CON(d_Level_dto_ustring(level_1436_7252), NIL)))))))))))))); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3389"); _r; }); });
}
V d_Check_dcheck_uindex_utelescope(V c_1445_7266, V name_1446_7267, V level_1447_7268, V tele_1448_7269) {
  return d_SeqList_dfold(({ V _c = clo_new(lam_7285, 2, 2); CLO_ENV(_c)[0] = name_1446_7267; CLO_ENV(_c)[1] = level_1447_7268; _c; }), tele_1448_7269, DONE(c_1445_7266));
}
V d_Global_dadd_ufamily(V name_771_7286, V fam_772_7287, V globals_773_7288) {
  return rt_ctor2(0, d_Get_dGlobal_dentries(globals_773_7288), d_Assoc_dadd(clo_new(lam_7291, 2, 0), name_771_7286, fam_772_7287, d_Get_dGlobal_dfamilies(globals_773_7288)));
}
V d_Check_ddeclare_ufamily(V _opt__1476_7292, V globals_1456_7293, V d_1457_7294) {
  return ({ V scrut6474_7295 = ({ V scrut6472_7296 = _opt__1476_7292; ({ V _r = 0; V m_7297 = scrut6472_7296; if (((m_7297) == NONE)) {  _r = ({ V __7298 = UNIT; d_Budget_dunlimited(); }); } else if (((m_7297) != NONE)) { V _m_7297_a0_7299 = FLD(m_7297, 0); _r = ({ V p6473_7300 = _m_7297_a0_7299; p6473_7300; }); } else rt_panic("match: no case at kernel:3403"); _r; }); }); ({ V t_7301 = ((((V)maybe_is_some(d_Global_dfind_ufamily(d_Get_dCheck_dFamily_udecl_dfam_uname(d_1457_7294), globals_1456_7293)))) != FALSE_V ? FAIL(rt_ctor1(4, str_append(((V)&S_82), str_append(d_Get_dCheck_dFamily_udecl_dfam_uname(d_1457_7294), ((V)&S_183))))) : DONE(UNIT)); V _r; if (tag_of(t_7301) == 0) _r = t_7301; else { V bound6476_7302 = FLD(t_7301, 0); _r = ({ V scrut6477_7303 = d_Check_dmake(globals_1456_7293, scrut6474_7295); ({ V _r = 0; V m_7304 = d_Check_dcheck_utelescope(scrut6477_7303, d_Get_dCheck_dFamily_udecl_dfam_uparams(d_1457_7294)); switch (tag_of(m_7304)) { case 1: { V _m_7304_a0_7305 = FLD(m_7304, 0); _r = ({ V item6532_7306 = _m_7304_a0_7305; ({ V local6503_7307 = item6532_7306; ({ V _r = 0; V m_7308 = d_Check_dcheck_uindex_utelescope(local6503_7307, d_Get_dCheck_dFamily_udecl_dfam_uname(d_1457_7294), d_Get_dCheck_dFamily_udecl_dfam_ulevel(d_1457_7294), d_Get_dCheck_dFamily_udecl_dfam_uindices(d_1457_7294)); switch (tag_of(m_7308)) { case 1: { V _m_7308_a0_7309 = FLD(m_7308, 0); _r = ({ V item6530_7310 = _m_7308_a0_7309; ({ V local6529_7311 = item6530_7310; DONE(d_Global_dadd_ufamily(d_Get_dCheck_dFamily_udecl_dfam_uname(d_1457_7294), ({ Obj *_o = rt_ctor(0, 7); _o->f[0] = d_Get_dCheck_dFamily_udecl_dfam_uname(d_1457_7294); _o->f[1] = d_Get_dCheck_dFamily_udecl_dfam_uparams(d_1457_7294); _o->f[2] = d_Get_dCheck_dFamily_udecl_dfam_uindices(d_1457_7294); _o->f[3] = d_Get_dCheck_dFamily_udecl_dfam_ulevel(d_1457_7294); _o->f[4] = ((V)0); _o->f[5] = NIL; _o->f[6] = FALSE_V; (V)_o; }), globals_1456_7293)); }); }); break; } case 0: { V _m_7308_a0_7312 = FLD(m_7308, 0); _r = ({ V item6531_7313 = _m_7308_a0_7312; FAIL(item6531_7313); }); break; } default: rt_panic("match: no case at kernel:3407"); } _r; }); }); }); break; } case 0: { V _m_7304_a0_7314 = FLD(m_7304, 0); _r = ({ V item6533_7315 = _m_7304_a0_7314; FAIL(item6533_7315); }); break; } default: rt_panic("match: no case at kernel:3407"); } _r; }); }); } _r; }); });
}
V d_Shape_dfamily(V s_367_7316) {
  return ({ V scrut6715_7317 = s_367_7316; ({ V _r = 0; V m_7318 = scrut6715_7317; switch (tag_of(m_7318)) { case 0: { V _m_7318_a0_7319 = FLD(m_7318, 0); V _m_7318_a1_7320 = FLD(m_7318, 1); V _m_7318_a2_7321 = FLD(m_7318, 2); _r = ({ V p6716_7322 = _m_7318_a0_7319; ({ V p6717_7323 = _m_7318_a1_7320; ({ V p6718_7324 = _m_7318_a2_7321; NONE; }); }); }); break; } case 1: { V _m_7318_a0_7325 = FLD(m_7318, 0); _r = ({ V p6719_7326 = _m_7318_a0_7325; NONE; }); break; } case 2: { V _m_7318_a0_7327 = FLD(m_7318, 0); V _m_7318_a1_7328 = FLD(m_7318, 1); _r = ({ V p6720_7329 = _m_7318_a0_7327; ({ V p6721_7330 = _m_7318_a1_7328; NONE; }); }); break; } case 3: { V _m_7318_a0_7331 = FLD(m_7318, 0); V _m_7318_a1_7332 = FLD(m_7318, 1); _r = ({ V p6722_7333 = _m_7318_a0_7331; ({ V p6723_7334 = _m_7318_a1_7332; SOME(p6722_7333); }); }); break; } case 4: { V _m_7318_a0_7335 = FLD(m_7318, 0); V _m_7318_a1_7336 = FLD(m_7318, 1); _r = ({ V p6724_7337 = _m_7318_a0_7335; ({ V p6725_7338 = _m_7318_a1_7336; SOME(p6724_7337); }); }); break; } default: rt_panic("match: no case at kernel:3411"); } _r; }); });
}
V d_Shape_dpayload(V s_355_7339) {
  return ({ V scrut6729_7340 = s_355_7339; ({ V _r = 0; V m_7341 = scrut6729_7340; switch (tag_of(m_7341)) { case 0: { V _m_7341_a0_7342 = FLD(m_7341, 0); V _m_7341_a1_7343 = FLD(m_7341, 1); V _m_7341_a2_7344 = FLD(m_7341, 2); _r = ({ V p6730_7345 = _m_7341_a0_7342; ({ V p6731_7346 = _m_7341_a1_7343; ({ V p6732_7347 = _m_7341_a2_7344; CON(p6732_7347, NIL); }); }); }); break; } case 1: { V _m_7341_a0_7348 = FLD(m_7341, 0); _r = ({ V p6733_7349 = _m_7341_a0_7348; NIL; }); break; } case 2: { V _m_7341_a0_7350 = FLD(m_7341, 0); V _m_7341_a1_7351 = FLD(m_7341, 1); _r = ({ V p6734_7352 = _m_7341_a0_7350; ({ V p6735_7353 = _m_7341_a1_7351; CON(p6734_7352, CON(p6735_7353, NIL)); }); }); break; } case 3: { V _m_7341_a0_7354 = FLD(m_7341, 0); V _m_7341_a1_7355 = FLD(m_7341, 1); _r = ({ V p6736_7356 = _m_7341_a0_7354; ({ V p6737_7357 = _m_7341_a1_7355; p6737_7357; }); }); break; } case 4: { V _m_7341_a0_7358 = FLD(m_7341, 0); V _m_7341_a1_7359 = FLD(m_7341, 1); _r = ({ V p6738_7360 = _m_7341_a0_7358; ({ V p6739_7361 = _m_7341_a1_7359; p6739_7361; }); }); break; } default: rt_panic("match: no case at kernel:3415"); } _r; }); });
}
V d_Local_dTerm_doccurs_ushape_df6700(V member_432_7362, V include_families_429_7363, V s_598_7364) {
  return ((((include_families_429_7363) != FALSE_V ? ({ V _r = 0; V m_7365 = d_Shape_dfamily(s_598_7364); if (((m_7365) == NONE)) {  _r = ({ V __7366 = UNIT; FALSE_V; }); } else if (((m_7365) != NONE)) { V _m_7365_a0_7367 = FLD(m_7365, 0); _r = ({ V value_7368 = _m_7365_a0_7367; ap(member_432_7362, value_7368); }); } else rt_panic("match: no case at kernel:3418"); _r; }) : FALSE_V)) != FALSE_V ? TRUE_V : d_SeqList_dexists(({ V _c = clo_new(lam_7370, 1, 2); CLO_ENV(_c)[0] = member_432_7362; CLO_ENV(_c)[1] = include_families_429_7363; _c; }), d_Shape_dpayload(s_598_7364)));
}
V d_Local_dTerm_doccurs_uaddr_df6701(V member_432_7371, V include_families_429_7372, V a_616_7373) {
  return ({ V local6762_7374 = d_Term_das_uapt(a_616_7373); ({ V _r = 0; V m_7375 = local6762_7374; if (((m_7375) == NONE)) {  _r = ({ V __7376 = UNIT; FALSE_V; }); } else if (((m_7375) != NONE)) { V _m_7375_a0_7377 = FLD(m_7375, 0); _r = ({ V value_7378 = _m_7375_a0_7377; ({ V local6764_7379 = value_7378; ({ V scrut6765_7380 = local6764_7379; ({ V _r = 0; V m_7381 = scrut6765_7380; if ((tag_of(m_7381) == 0)) { V _m_7381_a0_7382 = FLD(m_7381, 0); V _m_7381_a1_7383 = FLD(m_7381, 1); _r = ({ V p6766_7384 = _m_7381_a0_7382; ({ V p6767_7385 = _m_7381_a1_7383; ({ V local6770_7386 = p6767_7385; d_Local_dTerm_doccurs_df6699(member_432_7371, include_families_429_7372, local6770_7386); }); }); }); } else rt_panic("match: no case at kernel:3422"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3421"); _r; }); });
}
V d_Local_dTerm_doccurs_umotive_df6703(V member_432_7387, V include_families_429_7388, V mo_621_7389) {
  return ({ V local6786_7390 = mo_621_7389; ({ V _r = 0; V m_7391 = local6786_7390; if (((m_7391) == NONE)) {  _r = ({ V __7392 = UNIT; FALSE_V; }); } else if (((m_7391) != NONE)) { V _m_7391_a0_7393 = FLD(m_7391, 0); _r = ({ V value_7394 = _m_7391_a0_7393; ({ V local6788_7395 = value_7394; ({ V local6791_7396 = d_Get_dTerm_dMotive_dm_ubody(local6788_7395); d_Local_dTerm_doccurs_df6699(member_432_7387, include_families_429_7388, local6791_7396); }); }); }); } else rt_panic("match: no case at kernel:3425"); _r; }); });
}
V d_Local_dTerm_doccurs_uleg_df6702(V member_432_7397, V include_families_429_7398, V lg_620_7399) {
  return ({ V local6805_7400 = d_Get_dTerm_dLeg_dl_ubody(lg_620_7399); d_Local_dTerm_doccurs_df6699(member_432_7397, include_families_429_7398, local6805_7400); });
}
V d_Local_dTerm_doccurs_df6699(V member_432_7401, V include_families_429_7402, V tm_575_7403) {
_top: ;
  return ({ V scrut6707_7404 = tm_575_7403; ({ V _r = 0; V m_7405 = scrut6707_7404; switch (tag_of(m_7405)) { case 0: { V _m_7405_a0_7406 = FLD(m_7405, 0); _r = ({ V p6708_7407 = _m_7405_a0_7406; FALSE_V; }); break; } case 1: { V _m_7405_a0_7408 = FLD(m_7405, 0); _r = ({ V p6709_7409 = _m_7405_a0_7408; FALSE_V; }); break; } case 2: { V _m_7405_a0_7410 = FLD(m_7405, 0); V _m_7405_a1_7411 = FLD(m_7405, 1); _r = ({ V p6710_7412 = _m_7405_a0_7410; ({ V p6711_7413 = _m_7405_a1_7411; ((({ V local6714_7414 = p6710_7412; d_Local_dTerm_doccurs_ushape_df6700(member_432_7401, include_families_429_7402, local6714_7414); })) != FALSE_V ? TRUE_V : ({ V local6742_7415 = p6711_7413; ({ V a_7416 = local6742_7415; tm_575_7403 = a_7416;  goto _top; (V)0; }); })); }); }); break; } case 3: { V _m_7405_a0_7417 = FLD(m_7405, 0); V _m_7405_a1_7418 = FLD(m_7405, 1); _r = ({ V p6743_7419 = _m_7405_a0_7417; ({ V p6744_7420 = _m_7405_a1_7418; ((({ V local6747_7421 = p6743_7419; d_Local_dTerm_doccurs_ushape_df6700(member_432_7401, include_families_429_7402, local6747_7421); })) != FALSE_V ? TRUE_V : ({ V local6750_7422 = p6744_7420; ({ V a_7423 = local6750_7422; tm_575_7403 = a_7423;  goto _top; (V)0; }); })); }); }); break; } case 4: { V _m_7405_a0_7424 = FLD(m_7405, 0); V _m_7405_a1_7425 = FLD(m_7405, 1); V _m_7405_a2_7426 = FLD(m_7405, 2); _r = ({ V p6751_7427 = _m_7405_a0_7424; ({ V p6752_7428 = _m_7405_a1_7425; ({ V p6753_7429 = _m_7405_a2_7426; ((({ V local6756_7430 = p6751_7427; d_Local_dTerm_doccurs_ushape_df6700(member_432_7401, include_families_429_7402, local6756_7430); })) != FALSE_V ? TRUE_V : ((({ V local6759_7431 = p6752_7428; d_Local_dTerm_doccurs_uaddr_df6701(member_432_7401, include_families_429_7402, local6759_7431); })) != FALSE_V ? TRUE_V : d_SeqList_dexists(({ V _c = clo_new(lam_7433, 1, 2); CLO_ENV(_c)[0] = member_432_7401; CLO_ENV(_c)[1] = include_families_429_7402; _c; }), p6753_7429))); }); }); }); break; } case 5: { V _m_7405_a0_7434 = FLD(m_7405, 0); _r = ({ V p6774_7435 = _m_7405_a0_7434; ((({ V local6777_7436 = d_Get_dTerm_dElim_de_ushape(p6774_7435); d_Local_dTerm_doccurs_ushape_df6700(member_432_7401, include_families_429_7402, local6777_7436); })) != FALSE_V ? TRUE_V : ((({ V local6780_7437 = d_Get_dTerm_dElim_de_uscrut(p6774_7435); d_Local_dTerm_doccurs_df6699(member_432_7401, include_families_429_7402, local6780_7437); })) != FALSE_V ? TRUE_V : ((({ V local6783_7438 = d_Get_dTerm_dElim_de_umotive(p6774_7435); d_Local_dTerm_doccurs_umotive_df6703(member_432_7401, include_families_429_7402, local6783_7438); })) != FALSE_V ? TRUE_V : d_SeqList_dexists(({ V _c = clo_new(lam_7448, 1, 2); CLO_ENV(_c)[0] = member_432_7401; CLO_ENV(_c)[1] = include_families_429_7402; _c; }), d_Get_dTerm_dElim_de_ubranches(p6774_7435))))); }); break; } case 6: { V _m_7405_a0_7449 = FLD(m_7405, 0); V _m_7405_a1_7450 = FLD(m_7405, 1); _r = ({ V p6807_7451 = _m_7405_a0_7449; ({ V p6808_7452 = _m_7405_a1_7450; ((({ V local6811_7453 = p6807_7451; d_Local_dTerm_doccurs_ushape_df6700(member_432_7401, include_families_429_7402, local6811_7453); })) != FALSE_V ? TRUE_V : d_SeqList_dexists(({ V _c = clo_new(lam_7455, 1, 2); CLO_ENV(_c)[0] = member_432_7401; CLO_ENV(_c)[1] = include_families_429_7402; _c; }), p6808_7452)); }); }); break; } case 7: { V _m_7405_a0_7456 = FLD(m_7405, 0); V _m_7405_a1_7457 = FLD(m_7405, 1); V _m_7405_a2_7458 = FLD(m_7405, 2); _r = ({ V p6815_7459 = _m_7405_a0_7456; ({ V p6816_7460 = _m_7405_a1_7457; ({ V p6817_7461 = _m_7405_a2_7458; ((({ V local6820_7462 = p6815_7459; d_Local_dTerm_doccurs_ushape_df6700(member_432_7401, include_families_429_7402, local6820_7462); })) != FALSE_V ? TRUE_V : ((({ V local6823_7463 = p6816_7460; d_Local_dTerm_doccurs_uaddr_df6701(member_432_7401, include_families_429_7402, local6823_7463); })) != FALSE_V ? TRUE_V : ({ V local6826_7464 = p6817_7461; ({ V a_7465 = local6826_7464; tm_575_7403 = a_7465;  goto _top; (V)0; }); }))); }); }); }); break; } case 8: { V _m_7405_a0_7466 = FLD(m_7405, 0); V _m_7405_a1_7467 = FLD(m_7405, 1); V _m_7405_a2_7468 = FLD(m_7405, 2); V _m_7405_a3_7469 = FLD(m_7405, 3); _r = ({ V p6827_7470 = _m_7405_a0_7466; ({ V p6828_7471 = _m_7405_a1_7467; ({ V p6829_7472 = _m_7405_a2_7468; ({ V p6830_7473 = _m_7405_a3_7469; ((({ V local6833_7474 = p6828_7471; d_Local_dTerm_doccurs_df6699(member_432_7401, include_families_429_7402, local6833_7474); })) != FALSE_V ? TRUE_V : ((({ V local6836_7475 = p6829_7472; d_Local_dTerm_doccurs_df6699(member_432_7401, include_families_429_7402, local6836_7475); })) != FALSE_V ? TRUE_V : ({ V local6839_7476 = p6830_7473; ({ V a_7477 = local6839_7476; tm_575_7403 = a_7477;  goto _top; (V)0; }); }))); }); }); }); }); break; } case 9: { V _m_7405_a0_7478 = FLD(m_7405, 0); V _m_7405_a1_7479 = FLD(m_7405, 1); _r = ({ V p6840_7480 = _m_7405_a0_7478; ({ V p6841_7481 = _m_7405_a1_7479; ((({ V local6844_7482 = p6840_7480; d_Local_dTerm_doccurs_df6699(member_432_7401, include_families_429_7402, local6844_7482); })) != FALSE_V ? TRUE_V : ({ V local6847_7483 = p6841_7481; ({ V a_7484 = local6847_7483; tm_575_7403 = a_7484;  goto _top; (V)0; }); })); }); }); break; } case 10: { V _m_7405_a0_7485 = FLD(m_7405, 0); _r = ({ V p6848_7486 = _m_7405_a0_7485; ap(member_432_7401, p6848_7486); }); break; } case 11: { V _m_7405_a0_7487 = FLD(m_7405, 0); _r = ({ V p6849_7488 = _m_7405_a0_7487; FALSE_V; }); break; } case 12: {  _r = ({ V __7489 = UNIT; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:3432"); } _r; }); });
}
V d_Term_dexists_uname(V include_families_429_7490, V names_430_7491, V term_431_7492) {
  return ({ V scrut6698_7493 = ({ V _c = clo_new(lam_7497, 1, 1); CLO_ENV(_c)[0] = names_430_7491; _c; }); ({ V local6706_7498 = term_431_7492; d_Local_dTerm_doccurs_df6699(scrut6698_7493, include_families_429_7490, local6706_7498); }); });
}
V d_Positivity_doccurs(V names_569_7499, V t_570_7500) {
  return d_Term_dexists_uname(TRUE_V, names_569_7499, t_570_7500);
}
V d_Positivity_dself_urec(V names_651_7501, V args_652_7502) {
  return d_SeqList_dexists(({ V _c = clo_new(lam_7512, 1, 1); CLO_ENV(_c)[0] = names_651_7501; _c; }), args_652_7502);
}
V d_Check_dparameter_uat(V index_1478_7513, V tm_1479_7514) {
_top: ;
  return ({ V scrut6858_7515 = tm_1479_7514; ({ V _r = 0; V m_7516 = scrut6858_7515; switch (tag_of(m_7516)) { case 0: { V _m_7516_a0_7517 = FLD(m_7516, 0); _r = ({ V p6859_7518 = _m_7516_a0_7517; d_Big_dis_ueq(p6859_7518, index_1478_7513); }); break; } case 1: { V _m_7516_a0_7519 = FLD(m_7516, 0); _r = ({ V p6860_7520 = _m_7516_a0_7519; FALSE_V; }); break; } case 2: { V _m_7516_a0_7521 = FLD(m_7516, 0); V _m_7516_a1_7522 = FLD(m_7516, 1); _r = ({ V p6861_7523 = _m_7516_a0_7521; ({ V p6862_7524 = _m_7516_a1_7522; FALSE_V; }); }); break; } case 3: { V _m_7516_a0_7525 = FLD(m_7516, 0); V _m_7516_a1_7526 = FLD(m_7516, 1); _r = ({ V p6863_7527 = _m_7516_a0_7525; ({ V p6864_7528 = _m_7516_a1_7526; FALSE_V; }); }); break; } case 4: { V _m_7516_a0_7529 = FLD(m_7516, 0); V _m_7516_a1_7530 = FLD(m_7516, 1); V _m_7516_a2_7531 = FLD(m_7516, 2); _r = ({ V p6865_7532 = _m_7516_a0_7529; ({ V p6866_7533 = _m_7516_a1_7530; ({ V p6867_7534 = _m_7516_a2_7531; FALSE_V; }); }); }); break; } case 5: { V _m_7516_a0_7535 = FLD(m_7516, 0); _r = ({ V p6868_7536 = _m_7516_a0_7535; FALSE_V; }); break; } case 6: { V _m_7516_a0_7537 = FLD(m_7516, 0); V _m_7516_a1_7538 = FLD(m_7516, 1); _r = ({ V p6869_7539 = _m_7516_a0_7537; ({ V p6870_7540 = _m_7516_a1_7538; FALSE_V; }); }); break; } case 7: { V _m_7516_a0_7541 = FLD(m_7516, 0); V _m_7516_a1_7542 = FLD(m_7516, 1); V _m_7516_a2_7543 = FLD(m_7516, 2); _r = ({ V p6871_7544 = _m_7516_a0_7541; ({ V p6872_7545 = _m_7516_a1_7542; ({ V p6873_7546 = _m_7516_a2_7543; FALSE_V; }); }); }); break; } case 8: { V _m_7516_a0_7547 = FLD(m_7516, 0); V _m_7516_a1_7548 = FLD(m_7516, 1); V _m_7516_a2_7549 = FLD(m_7516, 2); V _m_7516_a3_7550 = FLD(m_7516, 3); _r = ({ V p6874_7551 = _m_7516_a0_7547; ({ V p6875_7552 = _m_7516_a1_7548; ({ V p6876_7553 = _m_7516_a2_7549; ({ V p6877_7554 = _m_7516_a3_7550; FALSE_V; }); }); }); }); break; } case 9: { V _m_7516_a0_7555 = FLD(m_7516, 0); V _m_7516_a1_7556 = FLD(m_7516, 1); _r = ({ V p6878_7557 = _m_7516_a0_7555; ({ V p6879_7558 = _m_7516_a1_7556; ({ V a_7559 = p6878_7557; tm_1479_7514 = a_7559;  goto _top; (V)0; }); }); }); break; } case 10: { V _m_7516_a0_7560 = FLD(m_7516, 0); _r = ({ V p6880_7561 = _m_7516_a0_7560; FALSE_V; }); break; } case 11: { V _m_7516_a0_7562 = FLD(m_7516, 0); _r = ({ V p6881_7563 = _m_7516_a0_7562; FALSE_V; }); break; } case 12: {  _r = ({ V __7564 = UNIT; FALSE_V; }); break; } default: rt_panic("match: no case at kernel:3448"); } _r; }); });
}
V d_Positivity_dabsent(V names_595_7565, V t_596_7566) {
  return ((d_Positivity_doccurs(names_595_7565, t_596_7566)) != FALSE_V ? FAIL(rt_ctor1(0, d_Positivity_dnonpositive_uword())) : DONE(UNIT));
}
V d_Positivity_dis_umember(V names_573_7567, V n_574_7568) {
  return ({ V local6900_7569 = n_574_7568; ({ V _r = 0; V m_7570 = local6900_7569; if (((m_7570) == NONE)) {  _r = ({ V __7571 = UNIT; FALSE_V; }); } else if (((m_7570) != NONE)) { V _m_7570_a0_7572 = FLD(m_7570, 0); _r = ({ V value_7573 = _m_7570_a0_7572; ({ V local6902_7574 = value_7573; d_SeqList_dexists(({ V _c = clo_new(lam_7576, 1, 1); CLO_ENV(_c)[0] = local6902_7574; _c; }), names_573_7567); }); }); } else rt_panic("match: no case at kernel:3454"); _r; }); });
}
V d_Positivity_dabsent_ulist(V names_607_7577, V ts_608_7578) {
  return ((d_SeqList_dexists(({ V _c = clo_new(lam_7580, 1, 1); CLO_ENV(_c)[0] = names_607_7577; _c; }), ts_608_7578)) != FALSE_V ? FAIL(rt_ctor1(0, d_Positivity_dnonpositive_uword())) : DONE(UNIT));
}
V d_Shape_dpoint_udom(V s_363_7581) {
  return ({ V scrut6916_7582 = s_363_7581; ({ V _r = 0; V m_7583 = scrut6916_7582; switch (tag_of(m_7583)) { case 0: { V _m_7583_a0_7584 = FLD(m_7583, 0); V _m_7583_a1_7585 = FLD(m_7583, 1); V _m_7583_a2_7586 = FLD(m_7583, 2); _r = ({ V p6917_7587 = _m_7583_a0_7584; ({ V p6918_7588 = _m_7583_a1_7585; ({ V p6919_7589 = _m_7583_a2_7586; SOME(p6919_7589); }); }); }); break; } case 1: { V _m_7583_a0_7590 = FLD(m_7583, 0); _r = ({ V p6920_7591 = _m_7583_a0_7590; NONE; }); break; } case 2: { V _m_7583_a0_7592 = FLD(m_7583, 0); V _m_7583_a1_7593 = FLD(m_7583, 1); _r = ({ V p6921_7594 = _m_7583_a0_7592; ({ V p6922_7595 = _m_7583_a1_7593; NONE; }); }); break; } case 3: { V _m_7583_a0_7596 = FLD(m_7583, 0); V _m_7583_a1_7597 = FLD(m_7583, 1); _r = ({ V p6923_7598 = _m_7583_a0_7596; ({ V p6924_7599 = _m_7583_a1_7597; NONE; }); }); break; } case 4: { V _m_7583_a0_7600 = FLD(m_7583, 0); V _m_7583_a1_7601 = FLD(m_7583, 1); _r = ({ V p6925_7602 = _m_7583_a0_7600; ({ V p6926_7603 = _m_7583_a1_7601; NONE; }); }); break; } default: rt_panic("match: no case at kernel:3461"); } _r; }); });
}
V d_Positivity_dpositive(V names_610_7604, V t_611_7605) {
_top: ;
  return ({ V scrut6893_7606 = t_611_7605; ({ V _r = 0; V m_7607 = scrut6893_7606; switch (tag_of(m_7607)) { case 0: { V _m_7607_a0_7608 = FLD(m_7607, 0); _r = ({ V p6894_7609 = _m_7607_a0_7608; d_Positivity_dabsent(names_610_7604, t_611_7605); }); break; } case 1: { V _m_7607_a0_7610 = FLD(m_7607, 0); _r = ({ V p6895_7611 = _m_7607_a0_7610; d_Positivity_dabsent(names_610_7604, t_611_7605); }); break; } case 2: { V _m_7607_a0_7612 = FLD(m_7607, 0); V _m_7607_a1_7613 = FLD(m_7607, 1); _r = ({ V p6896_7614 = _m_7607_a0_7612; ({ V p6897_7615 = _m_7607_a1_7613; ((d_Positivity_dis_umember(names_610_7604, d_Shape_dfamily(p6896_7614))) != FALSE_V ? ({ V _r = 0; V m_7616 = d_Positivity_dabsent_ulist(names_610_7604, d_Shape_dpayload(p6896_7614)); switch (tag_of(m_7616)) { case 1: { V _m_7616_a0_7617 = FLD(m_7616, 0); _r = ({ V item6912_7618 = _m_7616_a0_7617; ({ V local6910_7619 = item6912_7618; ({ V scrut6911_7620 = local6910_7619; d_Positivity_dabsent(names_610_7604, p6897_7615); }); }); }); break; } case 0: { V _m_7616_a0_7621 = FLD(m_7616, 0); _r = ({ V item6913_7622 = _m_7616_a0_7621; FAIL(item6913_7622); }); break; } default: rt_panic("match: no case at kernel:3465"); } _r; }) : d_Positivity_dabsent(names_610_7604, t_611_7605)); }); }); break; } case 3: { V _m_7607_a0_7623 = FLD(m_7607, 0); V _m_7607_a1_7624 = FLD(m_7607, 1); _r = ({ V p6914_7625 = _m_7607_a0_7623; ({ V p6915_7626 = _m_7607_a1_7624; ({ V local6929_7627 = d_Shape_dpoint_udom(p6914_7625); ({ V _r = 0; V m_7628 = local6929_7627; if (((m_7628) == NONE)) {  _r = ({ V __7629 = UNIT; d_Positivity_dabsent(names_610_7604, t_611_7605); }); } else if (((m_7628) != NONE)) { V _m_7628_a0_7630 = FLD(m_7628, 0); _r = ({ V value_7631 = _m_7628_a0_7630; ({ V local6931_7632 = value_7631; ({ V t_7633 = d_Positivity_dabsent(names_610_7604, local6931_7632); V _r; if (tag_of(t_7633) == 0) _r = t_7633; else { V bound6933_7634 = FLD(t_7633, 0); _r = ({ V a_7635 = p6915_7626; t_611_7605 = a_7635;  goto _top; (V)0; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:3466"); _r; }); }); }); }); break; } case 4: { V _m_7607_a0_7636 = FLD(m_7607, 0); V _m_7607_a1_7637 = FLD(m_7607, 1); V _m_7607_a2_7638 = FLD(m_7607, 2); _r = ({ V p6934_7639 = _m_7607_a0_7636; ({ V p6935_7640 = _m_7607_a1_7637; ({ V p6936_7641 = _m_7607_a2_7638; d_Positivity_dabsent(names_610_7604, t_611_7605); }); }); }); break; } case 5: { V _m_7607_a0_7642 = FLD(m_7607, 0); _r = ({ V p6937_7643 = _m_7607_a0_7642; d_Positivity_dabsent(names_610_7604, t_611_7605); }); break; } case 6: { V _m_7607_a0_7644 = FLD(m_7607, 0); V _m_7607_a1_7645 = FLD(m_7607, 1); _r = ({ V p6938_7646 = _m_7607_a0_7644; ({ V p6939_7647 = _m_7607_a1_7645; d_Positivity_dabsent(names_610_7604, t_611_7605); }); }); break; } case 7: { V _m_7607_a0_7648 = FLD(m_7607, 0); V _m_7607_a1_7649 = FLD(m_7607, 1); V _m_7607_a2_7650 = FLD(m_7607, 2); _r = ({ V p6940_7651 = _m_7607_a0_7648; ({ V p6941_7652 = _m_7607_a1_7649; ({ V p6942_7653 = _m_7607_a2_7650; ({ V local6949_7654 = ({ V _r = 0; V m_7655 = d_Shape_dpoint_udom(p6940_7651); if (((m_7655) == NONE)) {  _r = ({ V __7656 = UNIT; NONE; }); } else if (((m_7655) != NONE)) { V _m_7655_a0_7657 = FLD(m_7655, 0); _r = ({ V item6946_7658 = _m_7655_a0_7657; ({ V local6944_7659 = item6946_7658; d_Term_das_uapt(p6941_7652); }); }); } else rt_panic("match: no case at kernel:3471"); _r; }); ({ V _r = 0; V m_7660 = local6949_7654; if (((m_7660) == NONE)) {  _r = ({ V __7661 = UNIT; d_Positivity_dabsent(names_610_7604, t_611_7605); }); } else if (((m_7660) != NONE)) { V _m_7660_a0_7662 = FLD(m_7660, 0); _r = ({ V value_7663 = _m_7660_a0_7662; ({ V local6951_7664 = value_7663; ({ V scrut6952_7665 = local6951_7664; ({ V _r = 0; V m_7666 = scrut6952_7665; if ((tag_of(m_7666) == 0)) { V _m_7666_a0_7667 = FLD(m_7666, 0); V _m_7666_a1_7668 = FLD(m_7666, 1); _r = ({ V p6953_7669 = _m_7666_a0_7667; ({ V p6954_7670 = _m_7666_a1_7668; ({ V t_7671 = d_Positivity_dabsent(names_610_7604, p6954_7670); V _r; if (tag_of(t_7671) == 0) _r = t_7671; else { V bound6956_7672 = FLD(t_7671, 0); _r = ({ V a_7673 = p6942_7653; t_611_7605 = a_7673;  goto _top; (V)0; }); } _r; }); }); }); } else rt_panic("match: no case at kernel:3469"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3468"); _r; }); }); }); }); }); break; } case 8: { V _m_7607_a0_7674 = FLD(m_7607, 0); V _m_7607_a1_7675 = FLD(m_7607, 1); V _m_7607_a2_7676 = FLD(m_7607, 2); V _m_7607_a3_7677 = FLD(m_7607, 3); _r = ({ V p6957_7678 = _m_7607_a0_7674; ({ V p6958_7679 = _m_7607_a1_7675; ({ V p6959_7680 = _m_7607_a2_7676; ({ V p6960_7681 = _m_7607_a3_7677; d_Positivity_dabsent(names_610_7604, t_611_7605); }); }); }); }); break; } case 9: { V _m_7607_a0_7682 = FLD(m_7607, 0); V _m_7607_a1_7683 = FLD(m_7607, 1); _r = ({ V p6961_7684 = _m_7607_a0_7682; ({ V p6962_7685 = _m_7607_a1_7683; d_Positivity_dabsent(names_610_7604, t_611_7605); }); }); break; } case 10: { V _m_7607_a0_7686 = FLD(m_7607, 0); _r = ({ V p6963_7687 = _m_7607_a0_7686; DONE(UNIT); }); break; } case 11: { V _m_7607_a0_7688 = FLD(m_7607, 0); _r = ({ V p6964_7689 = _m_7607_a0_7688; d_Positivity_dabsent(names_610_7604, t_611_7605); }); break; } case 12: {  _r = ({ V __7690 = UNIT; d_Positivity_dabsent(names_610_7604, t_611_7605); }); break; } default: rt_panic("match: no case at kernel:3465"); } _r; }); });
}
V d_Positivity_dctor_ufields(V names_641_7691, V args_642_7692) {
  return d_SeqList_dfold(({ V _c = clo_new(lam_7705, 2, 1); CLO_ENV(_c)[0] = names_641_7691; _c; }), args_642_7692, DONE(UNIT));
}
V d_Check_dcheck_uctor(V c_1516_7706, V fam_1517_7707, V group_1518_7708, V cd_1519_7709) {
  return ({ V _r = 0; V m_7710 = d_SeqList_dfold(({ V _c = clo_new(lam_7740, 2, 2); CLO_ENV(_c)[0] = fam_1517_7707; CLO_ENV(_c)[1] = cd_1519_7709; _c; }), d_Get_dCheck_dCtor_udecl_dct_uargs(cd_1519_7709), DONE(c_1516_7706)); switch (tag_of(m_7710)) { case 1: { V _m_7710_a0_7741 = FLD(m_7710, 0); _r = ({ V item6965_7742 = _m_7710_a0_7741; ({ V local6673_7743 = item6965_7742; ({ V t_7744 = d_Positivity_dctor_ufields(group_1518_7708, d_Get_dCheck_dCtor_udecl_dct_uargs(cd_1519_7709)); V _r; if (tag_of(t_7744) == 0) _r = t_7744; else { V bound6675_7745 = FLD(t_7744, 0); _r = ({ V scrut6676_7746 = d_Big_dof_unat(list_length(d_Get_dPositivity_dFamily_df_uparams(fam_1517_7707))); ({ V scrut6677_7747 = d_Big_dof_unat(list_length(d_Get_dCheck_dCtor_udecl_dct_uargs(cd_1519_7709))); ({ V t_7748 = ((((d_Big_dis_ueq(d_Big_dof_unat(list_length(d_Get_dCheck_dCtor_udecl_dct_ures_uparams(cd_1519_7709))), scrut6676_7746)) != FALSE_V ? d_SeqList_dall(clo_new(lam_7750, 1, 0), d_SeqList_dmapi(({ V _c = clo_new(lam_7753, 2, 2); CLO_ENV(_c)[0] = scrut6677_7747; CLO_ENV(_c)[1] = scrut6676_7746; _c; }), d_Get_dCheck_dCtor_udecl_dct_ures_uparams(cd_1519_7709))) : FALSE_V)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, str_append(((V)&S_88), str_append(d_Get_dCheck_dCtor_udecl_dct_uname(cd_1519_7709), ((V)&S_186)))))); V _r; if (tag_of(t_7748) == 0) _r = t_7748; else { V bound6679_7754 = FLD(t_7748, 0); _r = ({ V t_7755 = d_Rules_dmu_utelescope(d_Check_dops(), local6673_7743, ((V)0), str_append(((V)&S_187), d_Get_dCheck_dCtor_udecl_dct_uname(cd_1519_7709)), d_Get_dPositivity_dFamily_df_uparams(fam_1517_7707), d_Get_dCheck_dCtor_udecl_dct_ures_uparams(cd_1519_7709), NIL); V _r; if (tag_of(t_7755) == 0) _r = t_7755; else { V bound6681_7756 = FLD(t_7755, 0); _r = ({ V scrut6682_7757 = d_Big_dof_unat(list_length(d_Get_dPositivity_dFamily_df_uindices(fam_1517_7707))); ({ V t_7758 = ((d_Big_dis_ueq(d_Big_dof_unat(list_length(d_Get_dCheck_dCtor_udecl_dct_ures_uidx(cd_1519_7709))), scrut6682_7757)) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, str_concat(CON(d_Get_dCheck_dCtor_udecl_dct_uname(cd_1519_7709), CON(((V)&S_86), CON(d_Big_dshow(d_Big_dof_unat(list_length(d_Get_dCheck_dCtor_udecl_dct_ures_uidx(cd_1519_7709)))), CON(((V)&S_87), CON(d_Get_dPositivity_dFamily_df_uname(fam_1517_7707), CON(((V)&S_79), CON(d_Big_dshow(scrut6682_7757), NIL))))))))))); V _r; if (tag_of(t_7758) == 0) _r = t_7758; else { V bound6684_7759 = FLD(t_7758, 0); _r = ({ V t_7760 = d_Rules_dmu_utelescope(d_Check_dops(), local6673_7743, ((V)0), str_append(((V)&S_188), d_Get_dCheck_dCtor_udecl_dct_uname(cd_1519_7709)), d_Get_dPositivity_dFamily_df_uindices(fam_1517_7707), d_Get_dCheck_dCtor_udecl_dct_ures_uidx(cd_1519_7709), bound6681_7756); V _r; if (tag_of(t_7760) == 0) _r = t_7760; else { V bound6686_7761 = FLD(t_7760, 0); _r = DONE(({ Obj *_o = rt_ctor(0, 5); _o->f[0] = d_Get_dCheck_dCtor_udecl_dct_uname(cd_1519_7709); _o->f[1] = d_Get_dCheck_dCtor_udecl_dct_uargs(cd_1519_7709); _o->f[2] = d_Get_dCheck_dCtor_udecl_dct_ures_uidx(cd_1519_7709); _o->f[3] = d_NativeInt_dadd(d_Big_dof_unat(list_length(d_Get_dPositivity_dFamily_df_uparams(fam_1517_7707))), d_Big_dof_unat(list_length(d_Get_dCheck_dCtor_udecl_dct_uargs(cd_1519_7709)))); _o->f[4] = d_Positivity_dself_urec(group_1518_7708, d_Get_dCheck_dCtor_udecl_dct_uargs(cd_1519_7709)); (V)_o; })); } _r; }); } _r; }); }); } _r; }); } _r; }); }); }); } _r; }); }); }); break; } case 0: { V _m_7710_a0_7762 = FLD(m_7710, 0); _r = ({ V item6966_7763 = _m_7710_a0_7762; FAIL(item6966_7763); }); break; } default: rt_panic("match: no case at kernel:3480"); } _r; });
}
V d_Check_ddefine_uctors(V _opt__1556_7764, V globals_1542_7765, V group_1543_7766, V name_1544_7767, V cds_1545_7768) {
  return ({ V scrut6625_7769 = ({ V scrut6623_7770 = _opt__1556_7764; ({ V _r = 0; V m_7771 = scrut6623_7770; if (((m_7771) == NONE)) {  _r = ({ V __7772 = UNIT; d_Budget_dunlimited(); }); } else if (((m_7771) != NONE)) { V _m_7771_a0_7773 = FLD(m_7771, 0); _r = ({ V p6624_7774 = _m_7771_a0_7773; p6624_7774; }); } else rt_panic("match: no case at kernel:3497"); _r; }); }); ({ V t_7775 = ({ V local6974_7776 = d_Global_dfind_ufamily(name_1544_7767, globals_1542_7765); ({ V _r = 0; V m_7777 = local6974_7776; if (((m_7777) == NONE)) {  _r = ({ V __7778 = UNIT; FAIL(rt_ctor1(3, str_append(((V)&S_82), str_append(name_1544_7767, ((V)&S_83))))); }); } else if (((m_7777) != NONE)) { V _m_7777_a0_7779 = FLD(m_7777, 0); _r = ({ V x_7780 = _m_7777_a0_7779; DONE(x_7780); }); } else rt_panic("match: no case at kernel:3499"); _r; }); }); V _r; if (tag_of(t_7775) == 0) _r = t_7775; else { V bound6627_7781 = FLD(t_7775, 0); _r = ({ V t_7782 = ({ V scrut6970_7783 = d_Get_dPositivity_dFamily_df_ustatus(bound6627_7781); ({ V _r = 0; V m_7784 = scrut6970_7783; switch (tag_of(m_7784)) { case 0: {  _r = ({ V __7785 = UNIT; DONE(UNIT); }); break; } case 1: {  _r = ({ V __7786 = UNIT; FAIL(rt_ctor1(4, str_append(((V)&S_189), str_append(name_1544_7767, ((V)&S_190))))); }); break; } case 2: { V _m_7784_a0_7787 = FLD(m_7784, 0); _r = ({ V p6971_7788 = _m_7784_a0_7787; FAIL(rt_ctor1(4, str_append(((V)&S_189), str_append(name_1544_7767, ((V)&S_190))))); }); break; } default: rt_panic("match: no case at kernel:3501"); } _r; }); }); V _r; if (tag_of(t_7782) == 0) _r = t_7782; else { V bound6629_7789 = FLD(t_7782, 0); _r = ({ V scrut6630_7790 = d_Check_dmake(globals_1542_7765, scrut6625_7769); ({ V _r = 0; V m_7791 = d_Check_dcheck_utelescope(scrut6630_7790, d_Get_dPositivity_dFamily_df_uparams(bound6627_7781)); switch (tag_of(m_7791)) { case 1: { V _m_7791_a0_7792 = FLD(m_7791, 0); _r = ({ V item6967_7793 = _m_7791_a0_7792; ({ V local6633_7794 = item6967_7793; ({ V t_7795 = d_SeqList_dfold(({ V _c = clo_new(lam_7802, 2, 3); CLO_ENV(_c)[0] = local6633_7794; CLO_ENV(_c)[1] = bound6627_7781; CLO_ENV(_c)[2] = group_1543_7766; _c; }), cds_1545_7768, DONE(NIL)); V _r; if (tag_of(t_7795) == 0) _r = t_7795; else { V bound6635_7803 = FLD(t_7795, 0); _r = DONE(d_Global_dadd_ufamily(name_1544_7767, ({ Obj *_o = rt_ctor(0, 7); _o->f[0] = d_Get_dPositivity_dFamily_df_uname(bound6627_7781); _o->f[1] = d_Get_dPositivity_dFamily_df_uparams(bound6627_7781); _o->f[2] = d_Get_dPositivity_dFamily_df_uindices(bound6627_7781); _o->f[3] = d_Get_dPositivity_dFamily_df_ulevel(bound6627_7781); _o->f[4] = rt_ctor1(2, d_SeqList_dmap(clo_new(lam_7805, 1, 0), cds_1545_7768)); _o->f[5] = bound6635_7803; _o->f[6] = TRUE_V; (V)_o; }), globals_1542_7765)); } _r; }); }); }); break; } case 0: { V _m_7791_a0_7806 = FLD(m_7791, 0); _r = ({ V item6968_7807 = _m_7791_a0_7806; FAIL(item6968_7807); }); break; } default: rt_panic("match: no case at kernel:3503"); } _r; }); }); } _r; }); } _r; }); });
}
V d_Order_das_ulam(V t_484_7808) {
  return ({ V scrut7085_7809 = t_484_7808; ({ V _r = 0; V m_7810 = scrut7085_7809; switch (tag_of(m_7810)) { case 0: { V _m_7810_a0_7811 = FLD(m_7810, 0); _r = ({ V p7086_7812 = _m_7810_a0_7811; NONE; }); break; } case 1: { V _m_7810_a0_7813 = FLD(m_7810, 0); _r = ({ V p7087_7814 = _m_7810_a0_7813; NONE; }); break; } case 2: { V _m_7810_a0_7815 = FLD(m_7810, 0); V _m_7810_a1_7816 = FLD(m_7810, 1); _r = ({ V p7088_7817 = _m_7810_a0_7815; ({ V p7089_7818 = _m_7810_a1_7816; NONE; }); }); break; } case 3: { V _m_7810_a0_7819 = FLD(m_7810, 0); V _m_7810_a1_7820 = FLD(m_7810, 1); _r = ({ V p7090_7821 = _m_7810_a0_7819; ({ V p7091_7822 = _m_7810_a1_7820; NONE; }); }); break; } case 4: { V _m_7810_a0_7823 = FLD(m_7810, 0); V _m_7810_a1_7824 = FLD(m_7810, 1); V _m_7810_a2_7825 = FLD(m_7810, 2); _r = ({ V p7092_7826 = _m_7810_a0_7823; ({ V p7093_7827 = _m_7810_a1_7824; ({ V p7094_7828 = _m_7810_a2_7825; NONE; }); }); }); break; } case 5: { V _m_7810_a0_7829 = FLD(m_7810, 0); _r = ({ V p7095_7830 = _m_7810_a0_7829; NONE; }); break; } case 6: { V _m_7810_a0_7831 = FLD(m_7810, 0); V _m_7810_a1_7832 = FLD(m_7810, 1); _r = ({ V p7096_7833 = _m_7810_a0_7831; ({ V p7097_7834 = _m_7810_a1_7832; ({ V _r = 0; V m_7835 = ({ V _r = 0; V m_7836 = d_Rules_das_uvpi(p7096_7833); if (((m_7836) == NONE)) {  _r = ({ V __7837 = UNIT; NONE; }); } else if (((m_7836) != NONE)) { V _m_7836_a0_7838 = FLD(m_7836, 0); _r = ({ V item7105_7839 = _m_7836_a0_7838; ({ V local7099_7840 = item7105_7839; ({ V scrut7100_7841 = local7099_7840; ({ V _r = 0; V m_7842 = scrut7100_7841; if ((tag_of(m_7842) == 0)) { V _m_7842_a0_7843 = FLD(m_7842, 0); V _m_7842_a1_7844 = FLD(m_7842, 1); V _m_7842_a2_7845 = FLD(m_7842, 2); _r = ({ V p7101_7846 = _m_7842_a0_7843; ({ V p7102_7847 = _m_7842_a1_7844; ({ V p7103_7848 = _m_7842_a2_7845; d_Rules_done_uof(p7097_7834); }); }); }); } else rt_panic("match: no case at kernel:3513"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3512"); _r; }); if (((m_7835) == NONE)) {  _r = ({ V __7849 = UNIT; NONE; }); } else if (((m_7835) != NONE)) { V _m_7835_a0_7850 = FLD(m_7835, 0); _r = ({ V item7119_7851 = _m_7835_a0_7850; ({ V local7107_7852 = item7119_7851; ({ V local7110_7853 = d_Rules_done_uof(d_Get_dTerm_dLeg_dl_ubinders(local7107_7852)); ({ V _r = 0; V m_7854 = local7110_7853; if (((m_7854) == NONE)) {  _r = ({ V __7855 = UNIT; NONE; }); } else if (((m_7854) != NONE)) { V _m_7854_a0_7856 = FLD(m_7854, 0); _r = ({ V item7117_7857 = _m_7854_a0_7856; SOME(({ V local7112_7858 = item7117_7857; ({ V scrut7113_7859 = local7112_7858; ({ V _r = 0; V m_7860 = scrut7113_7859; if ((tag_of(m_7860) == 0)) { V _m_7860_a0_7861 = FLD(m_7860, 0); V _m_7860_a1_7862 = FLD(m_7860, 1); _r = ({ V p7114_7863 = _m_7860_a0_7861; ({ V p7115_7864 = _m_7860_a1_7862; rt_ctor2(0, p7096_7833, local7107_7852); }); }); } else rt_panic("match: no case at kernel:3514"); _r; }); }); })); }); } else rt_panic("match: no case at kernel:3513"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3512"); _r; }); }); }); break; } case 7: { V _m_7810_a0_7865 = FLD(m_7810, 0); V _m_7810_a1_7866 = FLD(m_7810, 1); V _m_7810_a2_7867 = FLD(m_7810, 2); _r = ({ V p7121_7868 = _m_7810_a0_7865; ({ V p7122_7869 = _m_7810_a1_7866; ({ V p7123_7870 = _m_7810_a2_7867; NONE; }); }); }); break; } case 8: { V _m_7810_a0_7871 = FLD(m_7810, 0); V _m_7810_a1_7872 = FLD(m_7810, 1); V _m_7810_a2_7873 = FLD(m_7810, 2); V _m_7810_a3_7874 = FLD(m_7810, 3); _r = ({ V p7124_7875 = _m_7810_a0_7871; ({ V p7125_7876 = _m_7810_a1_7872; ({ V p7126_7877 = _m_7810_a2_7873; ({ V p7127_7878 = _m_7810_a3_7874; NONE; }); }); }); }); break; } case 9: { V _m_7810_a0_7879 = FLD(m_7810, 0); V _m_7810_a1_7880 = FLD(m_7810, 1); _r = ({ V p7128_7881 = _m_7810_a0_7879; ({ V p7129_7882 = _m_7810_a1_7880; NONE; }); }); break; } case 10: { V _m_7810_a0_7883 = FLD(m_7810, 0); _r = ({ V p7130_7884 = _m_7810_a0_7883; NONE; }); break; } case 11: { V _m_7810_a0_7885 = FLD(m_7810, 0); _r = ({ V p7131_7886 = _m_7810_a0_7885; NONE; }); break; } case 12: {  _r = ({ V __7887 = UNIT; NONE; }); break; } default: rt_panic("match: no case at kernel:3512"); } _r; }); });
}
V d_Order_dpeel(V n_708_7888, V t_709_7889) {
_top: ;
  return ({ V local7134_7890 = d_Order_das_ulam(t_709_7889); ({ V _r = 0; V m_7891 = local7134_7890; if (((m_7891) == NONE)) {  _r = ({ V __7892 = UNIT; rt_ctor2(0, n_708_7888, t_709_7889); }); } else if (((m_7891) != NONE)) { V _m_7891_a0_7893 = FLD(m_7891, 0); _r = ({ V value_7894 = _m_7891_a0_7893; ({ V local7136_7895 = value_7894; ({ V scrut7137_7896 = local7136_7895; ({ V _r = 0; V m_7897 = scrut7137_7896; if ((tag_of(m_7897) == 0)) { V _m_7897_a0_7898 = FLD(m_7897, 0); V _m_7897_a1_7899 = FLD(m_7897, 1); _r = ({ V p7138_7900 = _m_7897_a0_7898; ({ V p7139_7901 = _m_7897_a1_7899; ({ V a_7902 = d_NativeInt_dadd(n_708_7888, d_Big_done()); V a_7903 = d_Get_dTerm_dLeg_dl_ubody(p7139_7901); n_708_7888 = a_7902; t_709_7889 = a_7903;  goto _top; (V)0; }); }); }); } else rt_panic("match: no case at kernel:3518"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3517"); _r; }); });
}
V d_Order_dmentions(V group_739_7904, V t_740_7905) {
  return d_Term_dexists_uname(FALSE_V, group_739_7904, t_740_7905);
}
V d_Order_dstatus_uat(V st_743_7906, V ix_744_7907) {
  return d_Rules_dat(ix_744_7907, st_743_7906);
}
V d_Order_dok_uboth(V a_747_7908, V b_748_7909) {
  return ({ V _r = 0; V m_7910 = a_747_7908; if (((m_7910) == NONE)) {  _r = ({ V __7911 = UNIT; NONE; }); } else if (((m_7910) != NONE)) { V _m_7910_a0_7912 = FLD(m_7910, 0); _r = ({ V item7281_7913 = _m_7910_a0_7912; ({ V local7275_7914 = item7281_7913; ({ V _r = 0; V m_7915 = b_748_7909; if (((m_7915) == NONE)) {  _r = ({ V __7916 = UNIT; NONE; }); } else if (((m_7915) != NONE)) { V _m_7915_a0_7917 = FLD(m_7915, 0); _r = ({ V item7279_7918 = _m_7915_a0_7917; SOME(({ V local7277_7919 = item7279_7918; list_append(local7275_7914, local7277_7919); })); }); } else rt_panic("match: no case at kernel:3527"); _r; }); }); }); } else rt_panic("match: no case at kernel:3527"); _r; });
}
V d_Order_dok_uall(V xs_753_7920) {
  return d_SeqList_dfold(clo_new(w_Order_dok_uboth, 2, 0), xs_753_7920, SOME(NIL));
}
V d_Local_dOrder_dshape_uok_df7231(V group_769_7921, V guarded_call_783_7922, V principal_or_smaller_7923, V st_817_7924, V chain_818_7925, V s_819_7926) {
  return d_Order_dok_uall(d_SeqList_dmap(({ V _c = clo_new(lam_7931, 1, 5); CLO_ENV(_c)[0] = st_817_7924; CLO_ENV(_c)[1] = chain_818_7925; CLO_ENV(_c)[2] = group_769_7921; CLO_ENV(_c)[3] = guarded_call_783_7922; CLO_ENV(_c)[4] = principal_or_smaller_7923; _c; }), d_Shape_dpayload(s_819_7926)));
}
V d_Order_dunder_upoint(V s_763_7932, V st_764_7933) {
  return ({ V local7284_7934 = d_Shape_dpoint_udom(s_763_7932); ({ V _r = 0; V m_7935 = local7284_7934; if (((m_7935) == NONE)) {  _r = ({ V __7936 = UNIT; st_764_7933; }); } else if (((m_7935) != NONE)) { V _m_7935_a0_7937 = FLD(m_7935, 0); _r = ({ V value_7938 = _m_7935_a0_7937; ({ V local7286_7939 = value_7938; CON(((V)2), st_764_7933); }); }); } else rt_panic("match: no case at kernel:3536"); _r; }); });
}
V d_Local_dOrder_daddr_uok_df7232(V group_769_7940, V guarded_call_783_7941, V principal_or_smaller_7942, V st_820_7943, V chain_821_7944, V a_822_7945) {
  return ({ V local7339_7946 = d_Term_das_uapt(a_822_7945); ({ V _r = 0; V m_7947 = local7339_7946; if (((m_7947) == NONE)) {  _r = ({ V __7948 = UNIT; SOME(NIL); }); } else if (((m_7947) != NONE)) { V _m_7947_a0_7949 = FLD(m_7947, 0); _r = ({ V value_7950 = _m_7947_a0_7949; ({ V local7341_7951 = value_7950; ({ V scrut7342_7952 = local7341_7951; ({ V _r = 0; V m_7953 = scrut7342_7952; if ((tag_of(m_7953) == 0)) { V _m_7953_a0_7954 = FLD(m_7953, 0); V _m_7953_a1_7955 = FLD(m_7953, 1); _r = ({ V p7343_7956 = _m_7953_a0_7954; ({ V p7344_7957 = _m_7953_a1_7955; ({ V local7349_7958 = st_820_7943; ({ V local7351_7959 = chain_821_7944; ({ V local7353_7960 = p7344_7957; d_Local_dOrder_dok_df7230(group_769_7940, guarded_call_783_7941, principal_or_smaller_7942, local7349_7958, local7351_7959, local7353_7960); }); }); }); }); }); } else rt_panic("match: no case at kernel:3540"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3539"); _r; }); });
}
V d_Order_das_uvar(V t_687_7961) {
  return ({ V scrut7376_7962 = t_687_7961; ({ V _r = 0; V m_7963 = scrut7376_7962; switch (tag_of(m_7963)) { case 0: { V _m_7963_a0_7964 = FLD(m_7963, 0); _r = ({ V p7377_7965 = _m_7963_a0_7964; SOME(p7377_7965); }); break; } case 1: { V _m_7963_a0_7966 = FLD(m_7963, 0); _r = ({ V p7378_7967 = _m_7963_a0_7966; NONE; }); break; } case 2: { V _m_7963_a0_7968 = FLD(m_7963, 0); V _m_7963_a1_7969 = FLD(m_7963, 1); _r = ({ V p7379_7970 = _m_7963_a0_7968; ({ V p7380_7971 = _m_7963_a1_7969; NONE; }); }); break; } case 3: { V _m_7963_a0_7972 = FLD(m_7963, 0); V _m_7963_a1_7973 = FLD(m_7963, 1); _r = ({ V p7381_7974 = _m_7963_a0_7972; ({ V p7382_7975 = _m_7963_a1_7973; NONE; }); }); break; } case 4: { V _m_7963_a0_7976 = FLD(m_7963, 0); V _m_7963_a1_7977 = FLD(m_7963, 1); V _m_7963_a2_7978 = FLD(m_7963, 2); _r = ({ V p7383_7979 = _m_7963_a0_7976; ({ V p7384_7980 = _m_7963_a1_7977; ({ V p7385_7981 = _m_7963_a2_7978; NONE; }); }); }); break; } case 5: { V _m_7963_a0_7982 = FLD(m_7963, 0); _r = ({ V p7386_7983 = _m_7963_a0_7982; NONE; }); break; } case 6: { V _m_7963_a0_7984 = FLD(m_7963, 0); V _m_7963_a1_7985 = FLD(m_7963, 1); _r = ({ V p7387_7986 = _m_7963_a0_7984; ({ V p7388_7987 = _m_7963_a1_7985; NONE; }); }); break; } case 7: { V _m_7963_a0_7988 = FLD(m_7963, 0); V _m_7963_a1_7989 = FLD(m_7963, 1); V _m_7963_a2_7990 = FLD(m_7963, 2); _r = ({ V p7389_7991 = _m_7963_a0_7988; ({ V p7390_7992 = _m_7963_a1_7989; ({ V p7391_7993 = _m_7963_a2_7990; NONE; }); }); }); break; } case 8: { V _m_7963_a0_7994 = FLD(m_7963, 0); V _m_7963_a1_7995 = FLD(m_7963, 1); V _m_7963_a2_7996 = FLD(m_7963, 2); V _m_7963_a3_7997 = FLD(m_7963, 3); _r = ({ V p7392_7998 = _m_7963_a0_7994; ({ V p7393_7999 = _m_7963_a1_7995; ({ V p7394_8000 = _m_7963_a2_7996; ({ V p7395_8001 = _m_7963_a3_7997; NONE; }); }); }); }); break; } case 9: { V _m_7963_a0_8002 = FLD(m_7963, 0); V _m_7963_a1_8003 = FLD(m_7963, 1); _r = ({ V p7396_8004 = _m_7963_a0_8002; ({ V p7397_8005 = _m_7963_a1_8003; NONE; }); }); break; } case 10: { V _m_7963_a0_8006 = FLD(m_7963, 0); _r = ({ V p7398_8007 = _m_7963_a0_8006; NONE; }); break; } case 11: { V _m_7963_a0_8008 = FLD(m_7963, 0); _r = ({ V p7399_8009 = _m_7963_a0_8008; NONE; }); break; } case 12: {  _r = ({ V __8010 = UNIT; NONE; }); break; } default: rt_panic("match: no case at kernel:3544"); } _r; }); });
}
V d_Order_dunder(V s_756_8011, V bs_757_8012, V st_758_8013) {
  return d_SeqList_dfold(({ V _c = clo_new(lam_8016, 2, 1); CLO_ENV(_c)[0] = s_756_8011; _c; }), bs_757_8012, st_758_8013);
}
V d_Local_dOrder_delim_uok_df7235(V group_769_8017, V guarded_call_783_8018, V principal_or_smaller_8019, V st_840_8020, V chain_841_8021, V e_842_8022) {
  return ({ V scrut7400_8023 = d_Order_das_uvar(d_Get_dTerm_dElim_de_uscrut(e_842_8022)); ({ V scrut7406_8024 = ({ V local7403_8025 = scrut7400_8023; ({ V _r = 0; V m_8026 = local7403_8025; if (((m_8026) == NONE)) {  _r = ({ V __8027 = UNIT; FALSE_V; }); } else if (((m_8026) != NONE)) { V _m_8026_a0_8028 = FLD(m_8026, 0); _r = ({ V value_8029 = _m_8026_a0_8028; ({ V local7405_8030 = value_8029; ap2(principal_or_smaller_8019, st_840_8020, local7405_8030); }); }); } else rt_panic("match: no case at kernel:3551"); _r; }); }); ({ V scrut7407_8031 = ((scrut7406_8024) != FALSE_V ? ((V)1) : ((V)2)); ({ V scrut7416_8032 = ({ V _c = clo_new(lam_8041, 1, 3); CLO_ENV(_c)[0] = scrut7400_8023; CLO_ENV(_c)[1] = chain_841_8021; CLO_ENV(_c)[2] = scrut7406_8024; _c; }); ({ V scrut7436_8042 = ({ V local7419_8043 = d_Get_dTerm_dElim_de_umotive(e_842_8022); ({ V _r = 0; V m_8044 = local7419_8043; if (((m_8044) == NONE)) {  _r = ({ V __8045 = UNIT; SOME(NIL); }); } else if (((m_8044) != NONE)) { V _m_8044_a0_8046 = FLD(m_8044, 0); _r = ({ V value_8047 = _m_8044_a0_8046; ({ V local7421_8048 = value_8047; ({ V scrut7426_8049 = d_SeqList_dfold(clo_new(lam_8052, 2, 0), d_Get_dTerm_dMotive_dm_uidx(local7421_8048), CON(((V)2), st_840_8020)); ({ V local7431_8053 = scrut7426_8049; ({ V local7433_8054 = chain_841_8021; ({ V local7435_8055 = d_Get_dTerm_dMotive_dm_ubody(local7421_8048); d_Local_dOrder_dok_df7230(group_769_8017, guarded_call_783_8018, principal_or_smaller_8019, local7431_8053, local7433_8054, local7435_8055); }); }); }); }); }); }); } else rt_panic("match: no case at kernel:3555"); _r; }); }); ({ V scrut7464_8056 = ({ V _c = clo_new(lam_8070, 1, 7); CLO_ENV(_c)[0] = st_840_8020; CLO_ENV(_c)[1] = chain_841_8021; CLO_ENV(_c)[2] = group_769_8017; CLO_ENV(_c)[3] = guarded_call_783_8018; CLO_ENV(_c)[4] = principal_or_smaller_8019; CLO_ENV(_c)[5] = scrut7407_8031; CLO_ENV(_c)[6] = scrut7416_8032; _c; }); d_Order_dok_uall(CON(({ V local7469_8071 = st_840_8020; ({ V local7471_8072 = chain_841_8021; ({ V local7473_8073 = d_Get_dTerm_dElim_de_uscrut(e_842_8022); d_Local_dOrder_dok_df7230(group_769_8017, guarded_call_783_8018, principal_or_smaller_8019, local7469_8071, local7471_8072, local7473_8073); }); }); }), CON(({ V local7478_8074 = st_840_8020; ({ V local7480_8075 = chain_841_8021; ({ V local7482_8076 = d_Get_dTerm_dElim_de_ushape(e_842_8022); d_Local_dOrder_dshape_uok_df7231(group_769_8017, guarded_call_783_8018, principal_or_smaller_8019, local7478_8074, local7480_8075, local7482_8076); }); }); }), CON(scrut7436_8042, d_SeqList_dmap(scrut7464_8056, d_Get_dTerm_dElim_de_ubranches(e_842_8022)))))); }); }); }); }); }); });
}
V d_Local_dOrder_dleg_uok_df7233(V group_769_8077, V guarded_call_783_8078, V principal_or_smaller_8079, V st_826_8080, V chain_827_8081, V lg_828_8082) {
  return ({ V local7513_8083 = d_Order_dunder(((V)2), d_Get_dTerm_dLeg_dl_ubinders(lg_828_8082), st_826_8080); ({ V local7515_8084 = chain_827_8081; ({ V local7517_8085 = d_Get_dTerm_dLeg_dl_ubody(lg_828_8082); d_Local_dOrder_dok_df7230(group_769_8077, guarded_call_783_8078, principal_or_smaller_8079, local7513_8083, local7515_8084, local7517_8085); }); }); });
}
V d_Order_dspine(V t_728_8086, V args_729_8087, V shapes_730_8088) {
_top: ;
  return ({ V scrut7530_8089 = t_728_8086; ({ V _r = 0; V m_8090 = scrut7530_8089; switch (tag_of(m_8090)) { case 0: { V _m_8090_a0_8091 = FLD(m_8090, 0); _r = ({ V p7531_8092 = _m_8090_a0_8091; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); break; } case 1: { V _m_8090_a0_8093 = FLD(m_8090, 0); _r = ({ V p7532_8094 = _m_8090_a0_8093; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); break; } case 2: { V _m_8090_a0_8095 = FLD(m_8090, 0); V _m_8090_a1_8096 = FLD(m_8090, 1); _r = ({ V p7533_8097 = _m_8090_a0_8095; ({ V p7534_8098 = _m_8090_a1_8096; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); }); break; } case 3: { V _m_8090_a0_8099 = FLD(m_8090, 0); V _m_8090_a1_8100 = FLD(m_8090, 1); _r = ({ V p7535_8101 = _m_8090_a0_8099; ({ V p7536_8102 = _m_8090_a1_8100; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); }); break; } case 4: { V _m_8090_a0_8103 = FLD(m_8090, 0); V _m_8090_a1_8104 = FLD(m_8090, 1); V _m_8090_a2_8105 = FLD(m_8090, 2); _r = ({ V p7537_8106 = _m_8090_a0_8103; ({ V p7538_8107 = _m_8090_a1_8104; ({ V p7539_8108 = _m_8090_a2_8105; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); }); }); break; } case 5: { V _m_8090_a0_8109 = FLD(m_8090, 0); _r = ({ V p7540_8110 = _m_8090_a0_8109; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); break; } case 6: { V _m_8090_a0_8111 = FLD(m_8090, 0); V _m_8090_a1_8112 = FLD(m_8090, 1); _r = ({ V p7541_8113 = _m_8090_a0_8111; ({ V p7542_8114 = _m_8090_a1_8112; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); }); break; } case 7: { V _m_8090_a0_8115 = FLD(m_8090, 0); V _m_8090_a1_8116 = FLD(m_8090, 1); V _m_8090_a2_8117 = FLD(m_8090, 2); _r = ({ V p7543_8118 = _m_8090_a0_8115; ({ V p7544_8119 = _m_8090_a1_8116; ({ V p7545_8120 = _m_8090_a2_8117; ({ V local7548_8121 = d_Term_das_uapt(p7544_8119); ({ V _r = 0; V m_8122 = local7548_8121; if (((m_8122) == NONE)) {  _r = ({ V __8123 = UNIT; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); } else if (((m_8122) != NONE)) { V _m_8122_a0_8124 = FLD(m_8122, 0); _r = ({ V value_8125 = _m_8122_a0_8124; ({ V local7550_8126 = value_8125; ({ V scrut7551_8127 = local7550_8126; ({ V _r = 0; V m_8128 = scrut7551_8127; if ((tag_of(m_8128) == 0)) { V _m_8128_a0_8129 = FLD(m_8128, 0); V _m_8128_a1_8130 = FLD(m_8128, 1); _r = ({ V p7552_8131 = _m_8128_a0_8129; ({ V p7553_8132 = _m_8128_a1_8130; ({ V a_8133 = p7545_8120; V a_8134 = CON(p7553_8132, args_729_8087); V a_8135 = CON(p7543_8118, shapes_730_8088); t_728_8086 = a_8133; args_729_8087 = a_8134; shapes_730_8088 = a_8135;  goto _top; (V)0; }); }); }); } else rt_panic("match: no case at kernel:3567"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3566"); _r; }); }); }); }); }); break; } case 8: { V _m_8090_a0_8136 = FLD(m_8090, 0); V _m_8090_a1_8137 = FLD(m_8090, 1); V _m_8090_a2_8138 = FLD(m_8090, 2); V _m_8090_a3_8139 = FLD(m_8090, 3); _r = ({ V p7554_8140 = _m_8090_a0_8136; ({ V p7555_8141 = _m_8090_a1_8137; ({ V p7556_8142 = _m_8090_a2_8138; ({ V p7557_8143 = _m_8090_a3_8139; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); }); }); }); break; } case 9: { V _m_8090_a0_8144 = FLD(m_8090, 0); V _m_8090_a1_8145 = FLD(m_8090, 1); _r = ({ V p7558_8146 = _m_8090_a0_8144; ({ V p7559_8147 = _m_8090_a1_8145; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); }); break; } case 10: { V _m_8090_a0_8148 = FLD(m_8090, 0); _r = ({ V p7560_8149 = _m_8090_a0_8148; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); break; } case 11: { V _m_8090_a0_8150 = FLD(m_8090, 0); _r = ({ V p7561_8151 = _m_8090_a0_8150; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); break; } case 12: {  _r = ({ V __8152 = UNIT; rt_ctor3(0, t_728_8086, args_729_8087, shapes_730_8088); }); break; } default: rt_panic("match: no case at kernel:3566"); } _r; }); });
}
V d_Order_dmember(V group_334_8153, V n_335_8154) {
  return d_SeqList_dexists(({ V _c = clo_new(lam_8156, 1, 1); CLO_ENV(_c)[0] = n_335_8154; _c; }), group_334_8153);
}
V d_Local_dOrder_dspine_uok_df7234(V group_769_8157, V guarded_call_783_8158, V principal_or_smaller_8159, V st_829_8160, V chain_830_8161, V t_831_8162) {
  return ({ V scrut7562_8163 = d_Order_dspine(t_831_8162, NIL, NIL); ({ V _r = 0; V m_8164 = scrut7562_8163; if ((tag_of(m_8164) == 0)) { V _m_8164_a0_8165 = FLD(m_8164, 0); V _m_8164_a1_8166 = FLD(m_8164, 1); V _m_8164_a2_8167 = FLD(m_8164, 2); _r = ({ V p7563_8168 = _m_8164_a0_8165; ({ V p7564_8169 = _m_8164_a1_8166; ({ V p7565_8170 = _m_8164_a2_8167; ({ V scrut7684_8171 = ({ V scrut7566_8172 = p7563_8168; ({ V _r = 0; V m_8173 = scrut7566_8172; switch (tag_of(m_8173)) { case 0: { V _m_8173_a0_8174 = FLD(m_8173, 0); _r = ({ V p7567_8175 = _m_8173_a0_8174; SOME(NIL); }); break; } case 1: { V _m_8173_a0_8176 = FLD(m_8173, 0); _r = ({ V p7568_8177 = _m_8173_a0_8176; SOME(NIL); }); break; } case 2: { V _m_8173_a0_8178 = FLD(m_8173, 0); V _m_8173_a1_8179 = FLD(m_8173, 1); _r = ({ V p7569_8180 = _m_8173_a0_8178; ({ V p7570_8181 = _m_8173_a1_8179; ({ V local7575_8182 = st_829_8160; ({ V local7577_8183 = chain_830_8161; ({ V local7579_8184 = p7563_8168; d_Local_dOrder_dok_df7230(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7575_8182, local7577_8183, local7579_8184); }); }); }); }); }); break; } case 3: { V _m_8173_a0_8185 = FLD(m_8173, 0); V _m_8173_a1_8186 = FLD(m_8173, 1); _r = ({ V p7580_8187 = _m_8173_a0_8185; ({ V p7581_8188 = _m_8173_a1_8186; ({ V local7586_8189 = st_829_8160; ({ V local7588_8190 = chain_830_8161; ({ V local7590_8191 = p7563_8168; d_Local_dOrder_dok_df7230(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7586_8189, local7588_8190, local7590_8191); }); }); }); }); }); break; } case 4: { V _m_8173_a0_8192 = FLD(m_8173, 0); V _m_8173_a1_8193 = FLD(m_8173, 1); V _m_8173_a2_8194 = FLD(m_8173, 2); _r = ({ V p7591_8195 = _m_8173_a0_8192; ({ V p7592_8196 = _m_8173_a1_8193; ({ V p7593_8197 = _m_8173_a2_8194; ({ V local7598_8198 = st_829_8160; ({ V local7600_8199 = chain_830_8161; ({ V local7602_8200 = p7563_8168; d_Local_dOrder_dok_df7230(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7598_8198, local7600_8199, local7602_8200); }); }); }); }); }); }); break; } case 5: { V _m_8173_a0_8201 = FLD(m_8173, 0); _r = ({ V p7603_8202 = _m_8173_a0_8201; ({ V local7608_8203 = st_829_8160; ({ V local7610_8204 = chain_830_8161; ({ V local7612_8205 = p7563_8168; d_Local_dOrder_dok_df7230(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7608_8203, local7610_8204, local7612_8205); }); }); }); }); break; } case 6: { V _m_8173_a0_8206 = FLD(m_8173, 0); V _m_8173_a1_8207 = FLD(m_8173, 1); _r = ({ V p7613_8208 = _m_8173_a0_8206; ({ V p7614_8209 = _m_8173_a1_8207; ({ V local7619_8210 = st_829_8160; ({ V local7621_8211 = chain_830_8161; ({ V local7623_8212 = p7563_8168; d_Local_dOrder_dok_df7230(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7619_8210, local7621_8211, local7623_8212); }); }); }); }); }); break; } case 7: { V _m_8173_a0_8213 = FLD(m_8173, 0); V _m_8173_a1_8214 = FLD(m_8173, 1); V _m_8173_a2_8215 = FLD(m_8173, 2); _r = ({ V p7624_8216 = _m_8173_a0_8213; ({ V p7625_8217 = _m_8173_a1_8214; ({ V p7626_8218 = _m_8173_a2_8215; d_Order_dok_uall(CON(({ V local7631_8219 = st_829_8160; ({ V local7633_8220 = chain_830_8161; ({ V local7635_8221 = p7624_8216; d_Local_dOrder_dshape_uok_df7231(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7631_8219, local7633_8220, local7635_8221); }); }); }), CON(({ V local7640_8222 = st_829_8160; ({ V local7642_8223 = chain_830_8161; ({ V local7644_8224 = p7625_8217; d_Local_dOrder_daddr_uok_df7232(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7640_8222, local7642_8223, local7644_8224); }); }); }), CON(({ V local7649_8225 = st_829_8160; ({ V local7651_8226 = chain_830_8161; ({ V local7653_8227 = p7626_8218; d_Local_dOrder_dok_df7230(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7649_8225, local7651_8226, local7653_8227); }); }); }), NIL)))); }); }); }); break; } case 8: { V _m_8173_a0_8228 = FLD(m_8173, 0); V _m_8173_a1_8229 = FLD(m_8173, 1); V _m_8173_a2_8230 = FLD(m_8173, 2); V _m_8173_a3_8231 = FLD(m_8173, 3); _r = ({ V p7654_8232 = _m_8173_a0_8228; ({ V p7655_8233 = _m_8173_a1_8229; ({ V p7656_8234 = _m_8173_a2_8230; ({ V p7657_8235 = _m_8173_a3_8231; ({ V local7662_8236 = st_829_8160; ({ V local7664_8237 = chain_830_8161; ({ V local7666_8238 = p7563_8168; d_Local_dOrder_dok_df7230(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7662_8236, local7664_8237, local7666_8238); }); }); }); }); }); }); }); break; } case 9: { V _m_8173_a0_8239 = FLD(m_8173, 0); V _m_8173_a1_8240 = FLD(m_8173, 1); _r = ({ V p7667_8241 = _m_8173_a0_8239; ({ V p7668_8242 = _m_8173_a1_8240; ({ V local7673_8243 = st_829_8160; ({ V local7675_8244 = chain_830_8161; ({ V local7677_8245 = p7563_8168; d_Local_dOrder_dok_df7230(group_769_8157, guarded_call_783_8158, principal_or_smaller_8159, local7673_8243, local7675_8244, local7677_8245); }); }); }); }); }); break; } case 10: { V _m_8173_a0_8246 = FLD(m_8173, 0); _r = ({ V p7678_8247 = _m_8173_a0_8246; ({ V scrut7679_8248 = UNIT; ((((d_Order_dmember(group_769_8157, p7678_8247)) != FALSE_V ? ap2(guarded_call_783_8158, st_829_8160, p7564_8169) : FALSE_V)) != FALSE_V ? SOME(CON(rt_ctor2(0, p7678_8247, chain_830_8161), NIL)) : ((d_Order_dmember(group_769_8157, p7678_8247)) != FALSE_V ? NONE : SOME(NIL))); }); }); break; } case 11: { V _m_8173_a0_8249 = FLD(m_8173, 0); _r = ({ V p7683_8250 = _m_8173_a0_8249; SOME(NIL); }); break; } case 12: {  _r = ({ V __8251 = UNIT; SOME(NIL); }); break; } default: rt_panic("match: no case at kernel:3575"); } _r; }); }); d_Order_dok_uall(CON(scrut7684_8171, list_append(d_SeqList_dmap(({ V _c = clo_new(lam_8256, 1, 5); CLO_ENV(_c)[0] = st_829_8160; CLO_ENV(_c)[1] = chain_830_8161; CLO_ENV(_c)[2] = group_769_8157; CLO_ENV(_c)[3] = guarded_call_783_8158; CLO_ENV(_c)[4] = principal_or_smaller_8159; _c; }), p7565_8170), d_SeqList_dmap(({ V _c = clo_new(lam_8261, 1, 5); CLO_ENV(_c)[0] = st_829_8160; CLO_ENV(_c)[1] = chain_830_8161; CLO_ENV(_c)[2] = group_769_8157; CLO_ENV(_c)[3] = guarded_call_783_8158; CLO_ENV(_c)[4] = principal_or_smaller_8159; _c; }), p7564_8169)))); }); }); }); }); } else rt_panic("match: no case at kernel:3574"); _r; }); });
}
V d_Local_dOrder_dok_df7230(V group_769_8262, V guarded_call_783_8263, V principal_or_smaller_8264, V st_795_8265, V chain_796_8266, V t_797_8267) {
  return ({ V scrut7248_8268 = t_797_8267; ({ V _r = 0; V m_8269 = scrut7248_8268; switch (tag_of(m_8269)) { case 0: { V _m_8269_a0_8270 = FLD(m_8269, 0); _r = ({ V p7249_8271 = _m_8269_a0_8270; SOME(NIL); }); break; } case 1: { V _m_8269_a0_8272 = FLD(m_8269, 0); _r = ({ V p7250_8273 = _m_8269_a0_8272; SOME(NIL); }); break; } case 2: { V _m_8269_a0_8274 = FLD(m_8269, 0); V _m_8269_a1_8275 = FLD(m_8269, 1); _r = ({ V p7251_8276 = _m_8269_a0_8274; ({ V p7252_8277 = _m_8269_a1_8275; d_Order_dok_uall(CON(({ V local7257_8278 = st_795_8265; ({ V local7259_8279 = chain_796_8266; ({ V local7261_8280 = p7251_8276; d_Local_dOrder_dshape_uok_df7231(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7257_8278, local7259_8279, local7261_8280); }); }); }), CON(({ V local7291_8281 = d_Order_dunder_upoint(p7251_8276, st_795_8265); ({ V local7293_8282 = chain_796_8266; ({ V local7295_8283 = p7252_8277; d_Local_dOrder_dok_df7230(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7291_8281, local7293_8282, local7295_8283); }); }); }), NIL))); }); }); break; } case 3: { V _m_8269_a0_8284 = FLD(m_8269, 0); V _m_8269_a1_8285 = FLD(m_8269, 1); _r = ({ V p7296_8286 = _m_8269_a0_8284; ({ V p7297_8287 = _m_8269_a1_8285; d_Order_dok_uall(CON(({ V local7302_8288 = st_795_8265; ({ V local7304_8289 = chain_796_8266; ({ V local7306_8290 = p7296_8286; d_Local_dOrder_dshape_uok_df7231(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7302_8288, local7304_8289, local7306_8290); }); }); }), CON(({ V local7311_8291 = d_Order_dunder_upoint(p7296_8286, st_795_8265); ({ V local7313_8292 = chain_796_8266; ({ V local7315_8293 = p7297_8287; d_Local_dOrder_dok_df7230(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7311_8291, local7313_8292, local7315_8293); }); }); }), NIL))); }); }); break; } case 4: { V _m_8269_a0_8294 = FLD(m_8269, 0); V _m_8269_a1_8295 = FLD(m_8269, 1); V _m_8269_a2_8296 = FLD(m_8269, 2); _r = ({ V p7316_8297 = _m_8269_a0_8294; ({ V p7317_8298 = _m_8269_a1_8295; ({ V p7318_8299 = _m_8269_a2_8296; d_Order_dok_uall(CON(({ V local7323_8300 = st_795_8265; ({ V local7325_8301 = chain_796_8266; ({ V local7327_8302 = p7316_8297; d_Local_dOrder_dshape_uok_df7231(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7323_8300, local7325_8301, local7327_8302); }); }); }), CON(({ V local7332_8303 = st_795_8265; ({ V local7334_8304 = chain_796_8266; ({ V local7336_8305 = p7317_8298; d_Local_dOrder_daddr_uok_df7232(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7332_8303, local7334_8304, local7336_8305); }); }); }), d_SeqList_dmap(({ V _c = clo_new(lam_8310, 1, 5); CLO_ENV(_c)[0] = st_795_8265; CLO_ENV(_c)[1] = chain_796_8266; CLO_ENV(_c)[2] = group_769_8262; CLO_ENV(_c)[3] = guarded_call_783_8263; CLO_ENV(_c)[4] = principal_or_smaller_8264; _c; }), p7318_8299)))); }); }); }); break; } case 5: { V _m_8269_a0_8311 = FLD(m_8269, 0); _r = ({ V p7366_8312 = _m_8269_a0_8311; ({ V local7371_8313 = st_795_8265; ({ V local7373_8314 = chain_796_8266; ({ V local7375_8315 = p7366_8312; d_Local_dOrder_delim_uok_df7235(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7371_8313, local7373_8314, local7375_8315); }); }); }); }); break; } case 6: { V _m_8269_a0_8316 = FLD(m_8269, 0); V _m_8269_a1_8317 = FLD(m_8269, 1); _r = ({ V p7486_8318 = _m_8269_a0_8316; ({ V p7487_8319 = _m_8269_a1_8317; d_Order_dok_uall(CON(({ V local7492_8320 = st_795_8265; ({ V local7494_8321 = chain_796_8266; ({ V local7496_8322 = p7486_8318; d_Local_dOrder_dshape_uok_df7231(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7492_8320, local7494_8321, local7496_8322); }); }); }), d_SeqList_dmap(({ V _c = clo_new(lam_8327, 1, 5); CLO_ENV(_c)[0] = st_795_8265; CLO_ENV(_c)[1] = chain_796_8266; CLO_ENV(_c)[2] = group_769_8262; CLO_ENV(_c)[3] = guarded_call_783_8263; CLO_ENV(_c)[4] = principal_or_smaller_8264; _c; }), p7487_8319))); }); }); break; } case 7: { V _m_8269_a0_8328 = FLD(m_8269, 0); V _m_8269_a1_8329 = FLD(m_8269, 1); V _m_8269_a2_8330 = FLD(m_8269, 2); _r = ({ V p7518_8331 = _m_8269_a0_8328; ({ V p7519_8332 = _m_8269_a1_8329; ({ V p7520_8333 = _m_8269_a2_8330; ({ V local7525_8334 = st_795_8265; ({ V local7527_8335 = chain_796_8266; ({ V local7529_8336 = t_797_8267; d_Local_dOrder_dspine_uok_df7234(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7525_8334, local7527_8335, local7529_8336); }); }); }); }); }); }); break; } case 8: { V _m_8269_a0_8337 = FLD(m_8269, 0); V _m_8269_a1_8338 = FLD(m_8269, 1); V _m_8269_a2_8339 = FLD(m_8269, 2); V _m_8269_a3_8340 = FLD(m_8269, 3); _r = ({ V p7710_8341 = _m_8269_a0_8337; ({ V p7711_8342 = _m_8269_a1_8338; ({ V p7712_8343 = _m_8269_a2_8339; ({ V p7713_8344 = _m_8269_a3_8340; d_Order_dok_uall(CON(({ V local7718_8345 = st_795_8265; ({ V local7720_8346 = chain_796_8266; ({ V local7722_8347 = p7711_8342; d_Local_dOrder_dok_df7230(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7718_8345, local7720_8346, local7722_8347); }); }); }), CON(({ V local7727_8348 = st_795_8265; ({ V local7729_8349 = chain_796_8266; ({ V local7731_8350 = p7712_8343; d_Local_dOrder_dok_df7230(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7727_8348, local7729_8349, local7731_8350); }); }); }), CON(({ V local7736_8351 = CON(((V)2), st_795_8265); ({ V local7738_8352 = chain_796_8266; ({ V local7740_8353 = p7713_8344; d_Local_dOrder_dok_df7230(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7736_8351, local7738_8352, local7740_8353); }); }); }), NIL)))); }); }); }); }); break; } case 9: { V _m_8269_a0_8354 = FLD(m_8269, 0); V _m_8269_a1_8355 = FLD(m_8269, 1); _r = ({ V p7741_8356 = _m_8269_a0_8354; ({ V p7742_8357 = _m_8269_a1_8355; d_Order_dok_uall(CON(({ V local7747_8358 = st_795_8265; ({ V local7749_8359 = chain_796_8266; ({ V local7751_8360 = p7741_8356; d_Local_dOrder_dok_df7230(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7747_8358, local7749_8359, local7751_8360); }); }); }), CON(({ V local7756_8361 = st_795_8265; ({ V local7758_8362 = chain_796_8266; ({ V local7760_8363 = p7742_8357; d_Local_dOrder_dok_df7230(group_769_8262, guarded_call_783_8263, principal_or_smaller_8264, local7756_8361, local7758_8362, local7760_8363); }); }); }), NIL))); }); }); break; } case 10: { V _m_8269_a0_8364 = FLD(m_8269, 0); _r = ({ V p7761_8365 = _m_8269_a0_8364; ((d_Order_dmember(group_769_8262, p7761_8365)) != FALSE_V ? NONE : SOME(NIL)); }); break; } case 11: { V _m_8269_a0_8366 = FLD(m_8269, 0); _r = ({ V p7762_8367 = _m_8269_a0_8366; SOME(NIL); }); break; } case 12: {  _r = ({ V __8368 = UNIT; SOME(NIL); }); break; } default: rt_panic("match: no case at kernel:3581"); } _r; }); });
}
V d_Order_dpasses(V rule_768_8369, V group_769_8370, V k_770_8371, V formals_771_8372, V body_772_8373) {
  return ({ V scrut7183_8374 = clo_new(lam_8388, 2, 0); ({ V scrut7194_8389 = clo_new(lam_8403, 2, 0); ({ V scrut7229_8404 = ({ V _c = clo_new(lam_8465, 2, 3); CLO_ENV(_c)[0] = k_770_8371; CLO_ENV(_c)[1] = scrut7183_8374; CLO_ENV(_c)[2] = rule_768_8369; _c; }); ({ V scrut7238_8466 = d_SeqList_dinit(formals_771_8372, ({ V _c = clo_new(lam_8468, 1, 2); CLO_ENV(_c)[0] = formals_771_8372; CLO_ENV(_c)[1] = k_770_8371; _c; })); ({ V local7243_8469 = scrut7238_8466; ({ V local7245_8470 = NIL; ({ V local7247_8471 = body_772_8373; d_Local_dOrder_dok_df7230(group_769_8370, scrut7229_8404, scrut7194_8389, local7243_8469, local7245_8470, local7247_8471); }); }); }); }); }); }); });
}
V d_Order_drefusal(V members_896_8472) {
  return ({ V local7797_8473 = ({ V local7795_8474 = d_SeqList_dfold(clo_new(lam_8488, 2, 0), members_896_8472, NONE); maybe_default(local7795_8474, SNIL); }); rt_ctor1(14, local7797_8473); });
}
V d_Local_dOrder_dfirst_ufit_df7774(V bound_921_8489, V members_913_8490, V group_914_8491, V rows_at_928_8492, V k_939_8493) {
  return ({ V scrut7782_8494 = UNIT; ((d_Big_dis_ule(bound_921_8489, k_939_8493)) != FALSE_V ? FAIL(d_Order_drefusal(members_913_8490)) : ({ V local7817_8495 = ({ V _c = clo_new(lam_8509, 1, 5); CLO_ENV(_c)[0] = rows_at_928_8492; CLO_ENV(_c)[1] = k_939_8493; CLO_ENV(_c)[2] = bound_921_8489; CLO_ENV(_c)[3] = members_913_8490; CLO_ENV(_c)[4] = group_914_8491; _c; }); ap(local7817_8495, UNIT); })); });
}
V d_Order_dcertify(V _opt__947_8510, V members_913_8511) {
  return ({ V scrut7075_8512 = ({ V scrut7073_8513 = _opt__947_8510; ({ V _r = 0; V m_8514 = scrut7073_8513; if (((m_8514) == NONE)) {  _r = ({ V __8515 = UNIT; ((V)0); }); } else if (((m_8514) != NONE)) { V _m_8514_a0_8516 = FLD(m_8514, 0); _r = ({ V p7074_8517 = _m_8514_a0_8516; p7074_8517; }); } else rt_panic("match: no case at kernel:3604"); _r; }); }); ({ V scrut7079_8518 = d_SeqList_dmap(clo_new(lam_8520, 1, 0), members_913_8511); ({ V scrut7143_8521 = d_SeqList_dmap(clo_new(lam_8535, 1, 0), members_913_8511); ({ V scrut7160_8536 = ({ V local7159_8537 = d_SeqList_dfold(({ V _c = clo_new(lam_8554, 2, 1); CLO_ENV(_c)[0] = scrut7079_8518; _c; }), scrut7143_8521, NONE); maybe_default(local7159_8537, d_Big_dzero()); }); ({ V scrut7773_8555 = ({ V _c = clo_new(lam_8579, 1, 3); CLO_ENV(_c)[0] = scrut7075_8512; CLO_ENV(_c)[1] = scrut7079_8518; CLO_ENV(_c)[2] = scrut7143_8521; _c; }); ({ V scrut7775_8580 = UNIT; ((d_SeqList_dexists(({ V _c = clo_new(lam_8588, 1, 1); CLO_ENV(_c)[0] = scrut7079_8518; _c; }), members_913_8511)) != FALSE_V ? ({ V _r = 0; V m_8589 = ({ V local7781_8590 = d_Big_dzero(); d_Local_dOrder_dfirst_ufit_df7774(scrut7160_8536, members_913_8511, scrut7079_8518, scrut7773_8555, local7781_8590); }); switch (tag_of(m_8589)) { case 1: { V _m_8589_a0_8591 = FLD(m_8589, 0); _r = ({ V item7818_8592 = _m_8589_a0_8591; DONE(({ V local7778_8593 = item7818_8592; SOME(local7778_8593); })); }); break; } case 0: { V _m_8589_a0_8594 = FLD(m_8589, 0); _r = ({ V item7819_8595 = _m_8589_a0_8594; FAIL(item7819_8595); }); break; } default: rt_panic("match: no case at kernel:3615"); } _r; }) : DONE(NONE)); }); }); }); }); }); });
}
V d_Totality_dbudget_umsg(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_191); rt_root(&memo); done = 1; }
  return memo;
}
V d_Totality_dspend_ushape(V budget_520_8596, V s_521_8597) {
  return ({ V local7852_8598 = d_Rules_dmap_ushape(({ V _c = clo_new(lam_8607, 1, 1); CLO_ENV(_c)[0] = budget_520_8596; _c; }), s_521_8597); ({ V _r = 0; V m_8608 = local7852_8598; switch (tag_of(m_8608)) { case 1: { V _m_8608_a0_8609 = FLD(m_8608, 0); _r = ({ V item7855_8610 = _m_8608_a0_8609; DONE(({ V local7854_8611 = item7855_8610; UNIT; })); }); break; } case 0: { V _m_8608_a0_8612 = FLD(m_8608, 0); _r = ({ V item7856_8613 = _m_8608_a0_8612; FAIL(item7856_8613); }); break; } default: rt_panic("match: no case at kernel:3621"); } _r; }); });
}
V d_Totality_dspend_uaddr(V budget_644_8614, V a_645_8615) {
  return ({ V local7870_8616 = d_Term_das_uapt(a_645_8615); ({ V _r = 0; V m_8617 = local7870_8616; if (((m_8617) == NONE)) {  _r = ({ V __8618 = UNIT; DONE(UNIT); }); } else if (((m_8617) != NONE)) { V _m_8617_a0_8619 = FLD(m_8617, 0); _r = ({ V value_8620 = _m_8617_a0_8619; ({ V local7872_8621 = value_8620; ({ V scrut7873_8622 = local7872_8621; ({ V _r = 0; V m_8623 = scrut7873_8622; if ((tag_of(m_8623) == 0)) { V _m_8623_a0_8624 = FLD(m_8623, 0); V _m_8623_a1_8625 = FLD(m_8623, 1); _r = ({ V p7874_8626 = _m_8623_a0_8624; ({ V p7875_8627 = _m_8623_a1_8625; d_Totality_dspend(budget_644_8614, p7875_8627); }); }); } else rt_panic("match: no case at kernel:3626"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3625"); _r; }); });
}
V d_Totality_dspend_ubranches(V budget_669_8628, V brs_670_8629) {
  return d_SeqList_dfold(({ V _c = clo_new(lam_8642, 2, 1); CLO_ENV(_c)[0] = budget_669_8628; _c; }), brs_670_8629, DONE(UNIT));
}
V d_Totality_dspend_umotive(V budget_666_8643, V mo_667_8644) {
  return ({ V local7896_8645 = mo_667_8644; ({ V _r = 0; V m_8646 = local7896_8645; if (((m_8646) == NONE)) {  _r = ({ V __8647 = UNIT; DONE(UNIT); }); } else if (((m_8646) != NONE)) { V _m_8646_a0_8648 = FLD(m_8646, 0); _r = ({ V value_8649 = _m_8646_a0_8648; ({ V local7898_8650 = value_8649; d_Totality_dspend(budget_666_8643, d_Get_dTerm_dMotive_dm_ubody(local7898_8650)); }); }); } else rt_panic("match: no case at kernel:3636"); _r; }); });
}
V scc_30(uint32_t w, V *a) {
  V budget_367_8651;
  V t_368_8652;
  V budget_346_8653;
  V t_347_8654;
  switch (w) {
  default: budget_367_8651 = a[0]; t_368_8652 = a[1]; goto _m0;
  case 1: budget_346_8653 = a[0]; t_347_8654 = a[1]; goto _m1;
  }
_m0: ;
  return ({ V scrut7836_8655 = t_368_8652; ({ V _r = 0; V m_8656 = scrut7836_8655; switch (tag_of(m_8656)) { case 0: { V _m_8656_a0_8657 = FLD(m_8656, 0); _r = ({ V p7837_8658 = _m_8656_a0_8657; DONE(UNIT); }); break; } case 1: { V _m_8656_a0_8659 = FLD(m_8656, 0); _r = ({ V p7838_8660 = _m_8656_a0_8659; DONE(UNIT); }); break; } case 2: { V _m_8656_a0_8661 = FLD(m_8656, 0); V _m_8656_a1_8662 = FLD(m_8656, 1); _r = ({ V p7839_8663 = _m_8656_a0_8661; ({ V p7840_8664 = _m_8656_a1_8662; ({ V t_8665 = d_Totality_dspend_ushape(budget_367_8651, p7839_8663); V _r; if (tag_of(t_8665) == 0) _r = t_8665; else { V bound7842_8666 = FLD(t_8665, 0); _r = ({ V a_8667 = budget_367_8651; V a_8668 = p7840_8664; budget_346_8653 = a_8667; t_347_8654 = a_8668;  goto _m1; (V)0; }); } _r; }); }); }); break; } case 3: { V _m_8656_a0_8669 = FLD(m_8656, 0); V _m_8656_a1_8670 = FLD(m_8656, 1); _r = ({ V p7857_8671 = _m_8656_a0_8669; ({ V p7858_8672 = _m_8656_a1_8670; ({ V t_8673 = d_Totality_dspend_ushape(budget_367_8651, p7857_8671); V _r; if (tag_of(t_8673) == 0) _r = t_8673; else { V bound7860_8674 = FLD(t_8673, 0); _r = ({ V a_8675 = budget_367_8651; V a_8676 = p7858_8672; budget_346_8653 = a_8675; t_347_8654 = a_8676;  goto _m1; (V)0; }); } _r; }); }); }); break; } case 4: { V _m_8656_a0_8677 = FLD(m_8656, 0); V _m_8656_a1_8678 = FLD(m_8656, 1); V _m_8656_a2_8679 = FLD(m_8656, 2); _r = ({ V p7861_8680 = _m_8656_a0_8677; ({ V p7862_8681 = _m_8656_a1_8678; ({ V p7863_8682 = _m_8656_a2_8679; ({ V t_8683 = d_Totality_dspend_ushape(budget_367_8651, p7861_8680); V _r; if (tag_of(t_8683) == 0) _r = t_8683; else { V bound7865_8684 = FLD(t_8683, 0); _r = ({ V t_8685 = d_Totality_dspend_uaddr(budget_367_8651, p7862_8681); V _r; if (tag_of(t_8685) == 0) _r = t_8685; else { V bound7867_8686 = FLD(t_8685, 0); _r = d_Totality_dspend_uall(budget_367_8651, p7863_8682); } _r; }); } _r; }); }); }); }); break; } case 5: { V _m_8656_a0_8687 = FLD(m_8656, 0); _r = ({ V p7876_8688 = _m_8656_a0_8687; ({ V t_8689 = d_Totality_dspend_ushape(budget_367_8651, d_Get_dTerm_dElim_de_ushape(p7876_8688)); V _r; if (tag_of(t_8689) == 0) _r = t_8689; else { V bound7878_8690 = FLD(t_8689, 0); _r = ({ V t_8691 = d_Totality_dspend(budget_367_8651, d_Get_dTerm_dElim_de_uscrut(p7876_8688)); V _r; if (tag_of(t_8691) == 0) _r = t_8691; else { V bound7880_8692 = FLD(t_8691, 0); _r = ({ V t_8693 = d_Totality_dspend_umotive(budget_367_8651, d_Get_dTerm_dElim_de_umotive(p7876_8688)); V _r; if (tag_of(t_8693) == 0) _r = t_8693; else { V bound7882_8694 = FLD(t_8693, 0); _r = d_Totality_dspend_ubranches(budget_367_8651, d_Get_dTerm_dElim_de_ubranches(p7876_8688)); } _r; }); } _r; }); } _r; }); }); break; } case 6: { V _m_8656_a0_8695 = FLD(m_8656, 0); V _m_8656_a1_8696 = FLD(m_8656, 1); _r = ({ V p7899_8697 = _m_8656_a0_8695; ({ V p7900_8698 = _m_8656_a1_8696; ({ V t_8699 = d_Totality_dspend_ushape(budget_367_8651, p7899_8697); V _r; if (tag_of(t_8699) == 0) _r = t_8699; else { V bound7902_8700 = FLD(t_8699, 0); _r = d_Totality_dspend_uall(budget_367_8651, d_SeqList_dmap(clo_new(lam_8702, 1, 0), p7900_8698)); } _r; }); }); }); break; } case 7: { V _m_8656_a0_8703 = FLD(m_8656, 0); V _m_8656_a1_8704 = FLD(m_8656, 1); V _m_8656_a2_8705 = FLD(m_8656, 2); _r = ({ V p7905_8706 = _m_8656_a0_8703; ({ V p7906_8707 = _m_8656_a1_8704; ({ V p7907_8708 = _m_8656_a2_8705; ({ V t_8709 = d_Totality_dspend_ushape(budget_367_8651, p7905_8706); V _r; if (tag_of(t_8709) == 0) _r = t_8709; else { V bound7909_8710 = FLD(t_8709, 0); _r = ({ V t_8711 = d_Totality_dspend_uaddr(budget_367_8651, p7906_8707); V _r; if (tag_of(t_8711) == 0) _r = t_8711; else { V bound7911_8712 = FLD(t_8711, 0); _r = ({ V a_8713 = budget_367_8651; V a_8714 = p7907_8708; budget_346_8653 = a_8713; t_347_8654 = a_8714;  goto _m1; (V)0; }); } _r; }); } _r; }); }); }); }); break; } case 8: { V _m_8656_a0_8715 = FLD(m_8656, 0); V _m_8656_a1_8716 = FLD(m_8656, 1); V _m_8656_a2_8717 = FLD(m_8656, 2); V _m_8656_a3_8718 = FLD(m_8656, 3); _r = ({ V p7912_8719 = _m_8656_a0_8715; ({ V p7913_8720 = _m_8656_a1_8716; ({ V p7914_8721 = _m_8656_a2_8717; ({ V p7915_8722 = _m_8656_a3_8718; ({ V t_8723 = d_Totality_dspend(budget_367_8651, p7913_8720); V _r; if (tag_of(t_8723) == 0) _r = t_8723; else { V bound7917_8724 = FLD(t_8723, 0); _r = ({ V t_8725 = d_Totality_dspend(budget_367_8651, p7914_8721); V _r; if (tag_of(t_8725) == 0) _r = t_8725; else { V bound7919_8726 = FLD(t_8725, 0); _r = ({ V a_8727 = budget_367_8651; V a_8728 = p7915_8722; budget_346_8653 = a_8727; t_347_8654 = a_8728;  goto _m1; (V)0; }); } _r; }); } _r; }); }); }); }); }); break; } case 9: { V _m_8656_a0_8729 = FLD(m_8656, 0); V _m_8656_a1_8730 = FLD(m_8656, 1); _r = ({ V p7920_8731 = _m_8656_a0_8729; ({ V p7921_8732 = _m_8656_a1_8730; ({ V t_8733 = d_Totality_dspend(budget_367_8651, p7920_8731); V _r; if (tag_of(t_8733) == 0) _r = t_8733; else { V bound7923_8734 = FLD(t_8733, 0); _r = ({ V a_8735 = budget_367_8651; V a_8736 = p7921_8732; budget_346_8653 = a_8735; t_347_8654 = a_8736;  goto _m1; (V)0; }); } _r; }); }); }); break; } case 10: { V _m_8656_a0_8737 = FLD(m_8656, 0); _r = ({ V p7924_8738 = _m_8656_a0_8737; DONE(UNIT); }); break; } case 11: { V _m_8656_a0_8739 = FLD(m_8656, 0); _r = ({ V p7925_8740 = _m_8656_a0_8739; DONE(UNIT); }); break; } case 12: {  _r = ({ V __8741 = UNIT; DONE(UNIT); }); break; } default: rt_panic("match: no case at kernel:3640"); } _r; }); });
_m1: ;
  return ((d_Budget_dexhausted(budget_346_8653)) != FALSE_V ? FAIL(rt_ctor1(11, d_Totality_dbudget_umsg())) : ({ V a_8742 = budget_346_8653; V a_8743 = t_347_8654; budget_367_8651 = a_8742; t_368_8652 = a_8743;  goto _m0; (V)0; }));
}
V scc_30(uint32_t w, V *a);
V d_Totality_dspend_unode(V budget_367_8651, V t_368_8652) {
  V w_a[] = {budget_367_8651, t_368_8652};
  return scc_30(0, w_a);
}
V scc_30(uint32_t w, V *a);
V d_Totality_dspend(V budget_346_8653, V t_347_8654) {
  V w_a[] = {budget_346_8653, t_347_8654};
  return scc_30(1, w_a);
}
V d_Totality_dspend_uall(V budget_677_8744, V ts_678_8745) {
  return d_SeqList_dfold(({ V _c = clo_new(lam_8750, 2, 1); CLO_ENV(_c)[0] = budget_677_8744; _c; }), ts_678_8745, DONE(UNIT));
}
V d_Totality_dguard_ugroup(V _opt__757_8751, V globals_705_8752, V members_706_8753) {
  return ({ V scrut7068_8754 = ({ V scrut7066_8755 = _opt__757_8751; ({ V _r = 0; V m_8756 = scrut7066_8755; if (((m_8756) == NONE)) {  _r = ({ V __8757 = UNIT; d_Budget_dunlimited(); }); } else if (((m_8756) != NONE)) { V _m_8756_a0_8758 = FLD(m_8756, 0); _r = ({ V p7067_8759 = _m_8756_a0_8758; p7067_8759; }); } else rt_panic("match: no case at kernel:3673"); _r; }); }); ({ V scrut7069_8760 = globals_705_8752; ({ V t_8761 = d_Totality_dspend_uall(scrut7068_8754, d_SeqList_dmap(clo_new(lam_8763, 1, 0), members_706_8753)); V _r; if (tag_of(t_8761) == 0) _r = t_8761; else { V bound7071_8764 = FLD(t_8761, 0); _r = d_Order_dcertify(NONE, members_706_8753); } _r; }); }); });
}
V d_Order_dunwrap(V acc_714_8765, V t_715_8766) {
_top: ;
  return ({ V local7957_8767 = d_Order_das_ulam(t_715_8766); ({ V _r = 0; V m_8768 = local7957_8767; if (((m_8768) == NONE)) {  _r = ({ V __8769 = UNIT; rt_ctor2(0, list_reverse(acc_714_8765), t_715_8766); }); } else if (((m_8768) != NONE)) { V _m_8768_a0_8770 = FLD(m_8768, 0); _r = ({ V value_8771 = _m_8768_a0_8770; ({ V local7959_8772 = value_8771; ({ V scrut7960_8773 = local7959_8772; ({ V _r = 0; V m_8774 = scrut7960_8773; if ((tag_of(m_8774) == 0)) { V _m_8774_a0_8775 = FLD(m_8774, 0); V _m_8774_a1_8776 = FLD(m_8774, 1); _r = ({ V p7961_8777 = _m_8774_a0_8775; ({ V p7962_8778 = _m_8774_a1_8776; ({ V a_8779 = CON(rt_ctor2(0, p7961_8777, p7962_8778), acc_714_8765); V a_8780 = d_Get_dTerm_dLeg_dl_ubody(p7962_8778); acc_714_8765 = a_8779; t_715_8766 = a_8780;  goto _top; (V)0; }); }); }); } else rt_panic("match: no case at kernel:3681"); _r; }); }); }); }); } else rt_panic("match: no case at kernel:3680"); _r; }); });
}
V d_Order_drewrap(V ws_721_8781, V inner_722_8782) {
  return d_SeqList_dfold(clo_new(lam_8791, 2, 0), list_reverse(ws_721_8781), inner_722_8782);
}
V d_Order_dctor_ukey_umsg(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_192); rt_root(&memo); done = 1; }
  return memo;
}
V d_Order_dmotive_umsg(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_193); rt_root(&memo); done = 1; }
  return memo;
}
V d_Order_done_uelim_umsg(void) {
  static V memo; static int done;
  if (!done) { memo = ((V)&S_194); rt_root(&memo); done = 1; }
  return memo;
}
V d_Order_das_uelim(V t_683_8792) {
  return ({ V scrut8031_8793 = t_683_8792; ({ V _r = 0; V m_8794 = scrut8031_8793; switch (tag_of(m_8794)) { case 0: { V _m_8794_a0_8795 = FLD(m_8794, 0); _r = ({ V p8032_8796 = _m_8794_a0_8795; NONE; }); break; } case 1: { V _m_8794_a0_8797 = FLD(m_8794, 0); _r = ({ V p8033_8798 = _m_8794_a0_8797; NONE; }); break; } case 2: { V _m_8794_a0_8799 = FLD(m_8794, 0); V _m_8794_a1_8800 = FLD(m_8794, 1); _r = ({ V p8034_8801 = _m_8794_a0_8799; ({ V p8035_8802 = _m_8794_a1_8800; NONE; }); }); break; } case 3: { V _m_8794_a0_8803 = FLD(m_8794, 0); V _m_8794_a1_8804 = FLD(m_8794, 1); _r = ({ V p8036_8805 = _m_8794_a0_8803; ({ V p8037_8806 = _m_8794_a1_8804; NONE; }); }); break; } case 4: { V _m_8794_a0_8807 = FLD(m_8794, 0); V _m_8794_a1_8808 = FLD(m_8794, 1); V _m_8794_a2_8809 = FLD(m_8794, 2); _r = ({ V p8038_8810 = _m_8794_a0_8807; ({ V p8039_8811 = _m_8794_a1_8808; ({ V p8040_8812 = _m_8794_a2_8809; NONE; }); }); }); break; } case 5: { V _m_8794_a0_8813 = FLD(m_8794, 0); _r = ({ V p8041_8814 = _m_8794_a0_8813; SOME(p8041_8814); }); break; } case 6: { V _m_8794_a0_8815 = FLD(m_8794, 0); V _m_8794_a1_8816 = FLD(m_8794, 1); _r = ({ V p8042_8817 = _m_8794_a0_8815; ({ V p8043_8818 = _m_8794_a1_8816; NONE; }); }); break; } case 7: { V _m_8794_a0_8819 = FLD(m_8794, 0); V _m_8794_a1_8820 = FLD(m_8794, 1); V _m_8794_a2_8821 = FLD(m_8794, 2); _r = ({ V p8044_8822 = _m_8794_a0_8819; ({ V p8045_8823 = _m_8794_a1_8820; ({ V p8046_8824 = _m_8794_a2_8821; NONE; }); }); }); break; } case 8: { V _m_8794_a0_8825 = FLD(m_8794, 0); V _m_8794_a1_8826 = FLD(m_8794, 1); V _m_8794_a2_8827 = FLD(m_8794, 2); V _m_8794_a3_8828 = FLD(m_8794, 3); _r = ({ V p8047_8829 = _m_8794_a0_8825; ({ V p8048_8830 = _m_8794_a1_8826; ({ V p8049_8831 = _m_8794_a2_8827; ({ V p8050_8832 = _m_8794_a3_8828; NONE; }); }); }); }); break; } case 9: { V _m_8794_a0_8833 = FLD(m_8794, 0); V _m_8794_a1_8834 = FLD(m_8794, 1); _r = ({ V p8051_8835 = _m_8794_a0_8833; ({ V p8052_8836 = _m_8794_a1_8834; NONE; }); }); break; } case 10: { V _m_8794_a0_8837 = FLD(m_8794, 0); _r = ({ V p8053_8838 = _m_8794_a0_8837; NONE; }); break; } case 11: { V _m_8794_a0_8839 = FLD(m_8794, 0); _r = ({ V p8054_8840 = _m_8794_a0_8839; NONE; }); break; } case 12: {  _r = ({ V __8841 = UNIT; NONE; }); break; } default: rt_panic("match: no case at kernel:3698"); } _r; }); });
}
V d_Order_dtranslate_urecursive(V cert_955_8842, V body_956_8843) {
  return ({ V scrut7963_8844 = d_Order_dunwrap(NIL, body_956_8843); ({ V _r = 0; V m_8845 = scrut7963_8844; if ((tag_of(m_8845) == 0)) { V _m_8845_a0_8846 = FLD(m_8845, 0); V _m_8845_a1_8847 = FLD(m_8845, 1); _r = ({ V p7964_8848 = _m_8845_a0_8846; ({ V p7965_8849 = _m_8845_a1_8847; ({ V scrut7966_8850 = d_Big_dof_unat(list_length(p7964_8848)); ({ V t_8851 = ({ V local8057_8852 = d_Order_das_uelim(p7965_8849); ({ V _r = 0; V m_8853 = local8057_8852; if (((m_8853) == NONE)) {  _r = ({ V __8854 = UNIT; FAIL(rt_ctor1(4, d_Order_done_uelim_umsg())); }); } else if (((m_8853) != NONE)) { V _m_8853_a0_8855 = FLD(m_8853, 0); _r = ({ V x_8856 = _m_8853_a0_8855; DONE(x_8856); }); } else rt_panic("match: no case at kernel:3704"); _r; }); }); V _r; if (tag_of(t_8851) == 0) _r = t_8851; else { V bound7968_8857 = FLD(t_8851, 0); _r = ({ V t_8858 = ({ V local8030_8859 = d_Order_das_uvar(d_Get_dTerm_dElim_de_uscrut(bound7968_8857)); ({ V _r = 0; V m_8860 = local8030_8859; if (((m_8860) == NONE)) {  _r = ({ V __8861 = UNIT; FAIL(rt_ctor1(4, d_Order_done_uelim_umsg())); }); } else if (((m_8860) != NONE)) { V _m_8860_a0_8862 = FLD(m_8860, 0); _r = ({ V x_8863 = _m_8860_a0_8862; DONE(x_8863); }); } else rt_panic("match: no case at kernel:3705"); _r; }); }); V _r; if (tag_of(t_8858) == 0) _r = t_8858; else { V bound7970_8864 = FLD(t_8858, 0); _r = ({ V t_8865 = ({ V scrut8027_8866 = UNIT; ((d_Big_dis_ueq(bound7970_8864, d_NativeInt_dsub(d_NativeInt_dsub(scrut7966_8850, d_Big_done()), d_Get_dOrder_do_uarg(cert_955_8842)))) != FALSE_V ? DONE(UNIT) : FAIL(rt_ctor1(4, d_Order_done_uelim_umsg()))); }); V _r; if (tag_of(t_8865) == 0) _r = t_8865; else { V bound7972_8867 = FLD(t_8865, 0); _r = ({ V t_8868 = ({ V local8025_8869 = d_Get_dTerm_dElim_de_umotive(bound7968_8857); ({ V _r = 0; V m_8870 = local8025_8869; if (((m_8870) == NONE)) {  _r = ({ V __8871 = UNIT; FAIL(rt_ctor1(8, d_Order_dmotive_umsg())); }); } else if (((m_8870) != NONE)) { V _m_8870_a0_8872 = FLD(m_8870, 0); _r = ({ V x_8873 = _m_8870_a0_8872; DONE(x_8873); }); } else rt_panic("match: no case at kernel:3709"); _r; }); }); V _r; if (tag_of(t_8868) == 0) _r = t_8868; else { V bound7974_8874 = FLD(t_8868, 0); _r = ({ V t_8875 = d_SeqList_dfold(clo_new(lam_8892, 2, 0), d_Get_dTerm_dElim_de_ubranches(bound7968_8857), DONE(UNIT)); V _r; if (tag_of(t_8875) == 0) _r = t_8875; else { V bound7976_8893 = FLD(t_8875, 0); _r = ({ V t_8894 = d_SeqList_dfold(clo_new(lam_8916, 2, 0), d_Get_dOrder_do_urows(cert_955_8842), DONE(UNIT)); V _r; if (tag_of(t_8894) == 0) _r = t_8894; else { V bound7978_8917 = FLD(t_8894, 0); _r = DONE(d_Order_drewrap(p7964_8848, rt_ctor1(5, bound7968_8857))); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); } _r; }); }); }); }); } else rt_panic("match: no case at kernel:3702"); _r; }); });
}
V d_Order_dtranslate(V cert_953_8918, V body_954_8919) {
  return ((((d_Order_dmentions(d_Get_dOrder_do_ugroup(cert_953_8918), body_954_8919)) ^ 1u)) != FALSE_V ? DONE(body_954_8919) : d_Order_dtranslate_urecursive(cert_953_8918, body_954_8919));
}
V d_Check_dcheck_uterm(V _opt__1569_8920, V globals_1566_8921, V t_1567_8922, V ty_1568_8923) {
  return ({ V scrut8065_8924 = ({ V scrut8063_8925 = _opt__1569_8920; ({ V _r = 0; V m_8926 = scrut8063_8925; if (((m_8926) == NONE)) {  _r = ({ V __8927 = UNIT; d_Budget_dunlimited(); }); } else if (((m_8926) != NONE)) { V _m_8926_a0_8928 = FLD(m_8926, 0); _r = ({ V p8064_8929 = _m_8926_a0_8928; p8064_8929; }); } else rt_panic("match: no case at kernel:3727"); _r; }); }); d_Check_dcheck(d_Check_dmake(globals_1566_8921, scrut8065_8924), ((V)2), t_1567_8922, ty_1568_8923); });
}
V d_Global_dfind_udef(V name_794_8930, V globals_795_8931) {
  return ({ V _r = 0; V m_8932 = d_Global_dfind(name_794_8930, globals_795_8931); if (((m_8932) == NONE)) {  _r = ({ V __8933 = UNIT; NONE; }); } else if (((m_8932) != NONE)) { V _m_8932_a0_8934 = FLD(m_8932, 0); _r = ({ V item8490_8935 = _m_8932_a0_8934; d_Global_ddef_uof(item8490_8935); }); } else rt_panic("match: no case at kernel:3731"); _r; });
}
V d_Global_daxiom_uof(V e_786_8936) {
  return ({ V scrut8651_8937 = e_786_8936; ({ V _r = 0; V m_8938 = scrut8651_8937; switch (tag_of(m_8938)) { case 0: { V _m_8938_a0_8939 = FLD(m_8938, 0); _r = ({ V p8652_8940 = _m_8938_a0_8939; NONE; }); break; } case 1: { V _m_8938_a0_8941 = FLD(m_8938, 0); _r = ({ V p8653_8942 = _m_8938_a0_8941; SOME(p8653_8942); }); break; } case 2: { V _m_8938_a0_8943 = FLD(m_8938, 0); _r = ({ V p8654_8944 = _m_8938_a0_8943; NONE; }); break; } default: rt_panic("match: no case at kernel:3735"); } _r; }); });
}
V d_Term_dformers(void) {
  static V memo; static int done;
  if (!done) { memo = CON(((V)&S_195), CON(((V)&S_196), NIL)); rt_root(&memo); done = 1; }
  return memo;
}
V d_Term_dschema(void) {
  static V memo; static int done;
  if (!done) { memo = CON(((V)&S_197), CON(((V)&S_198), CON(((V)&S_199), CON(((V)&S_200), NIL)))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Shape_ddeclared(void) {
  static V memo; static int done;
  if (!done) { memo = CON(((V)&S_201), CON(((V)&S_202), CON(((V)&S_203), CON(((V)&S_204), CON(((V)&S_205), NIL))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Shape_dname(V s_372_8945) {
  return ({ V scrut15923_8946 = s_372_8945; ({ V _r = 0; V m_8947 = scrut15923_8946; switch (tag_of(m_8947)) { case 0: { V _m_8947_a0_8948 = FLD(m_8947, 0); V _m_8947_a1_8949 = FLD(m_8947, 1); V _m_8947_a2_8950 = FLD(m_8947, 2); _r = ({ V p15924_8951 = _m_8947_a0_8948; ({ V p15925_8952 = _m_8947_a1_8949; ({ V p15926_8953 = _m_8947_a2_8950; ((V)&S_201); }); }); }); break; } case 1: { V _m_8947_a0_8954 = FLD(m_8947, 0); _r = ({ V p15927_8955 = _m_8947_a0_8954; ((V)&S_202); }); break; } case 2: { V _m_8947_a0_8956 = FLD(m_8947, 0); V _m_8947_a1_8957 = FLD(m_8947, 1); _r = ({ V p15928_8958 = _m_8947_a0_8956; ({ V p15929_8959 = _m_8947_a1_8957; ((V)&S_203); }); }); break; } case 3: { V _m_8947_a0_8960 = FLD(m_8947, 0); V _m_8947_a1_8961 = FLD(m_8947, 1); _r = ({ V p15930_8962 = _m_8947_a0_8960; ({ V p15931_8963 = _m_8947_a1_8961; ((V)&S_204); }); }); break; } case 4: { V _m_8947_a0_8964 = FLD(m_8947, 0); V _m_8947_a1_8965 = FLD(m_8947, 1); _r = ({ V p15932_8966 = _m_8947_a0_8964; ({ V p15933_8967 = _m_8947_a1_8965; ((V)&S_205); }); }); break; } default: rt_panic("match: no case at kernel:3748"); } _r; }); });
}
V d_Rules_dsamples(void) {
  static V memo; static int done;
  if (!done) { memo = CON(rt_ctor3(0, ((V)2), ((V)&S_62), rt_ctor1(1, d_Level_dzero())), CON(rt_ctor1(1, d_Big_dzero()), CON(rt_ctor2(2, rt_ctor1(1, d_Level_dzero()), rt_ctor1(1, d_Level_dzero())), CON(rt_ctor2(3, ((V)&S_62), NIL), CON(rt_ctor2(4, ((V)&S_62), NIL), NIL))))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dpacks(void) {
  static V memo; static int done;
  if (!done) { memo = d_SeqList_dfilter_umap(clo_new(lam_8980, 1, 0), d_Rules_dsamples()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dadmitted(void) {
  static V memo; static int done;
  if (!done) { memo = d_SeqList_dmap(clo_new(lam_8982, 1, 0), d_Rules_dpacks()); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dnamed_udeclared(void) {
  static V memo; static int done;
  if (!done) { memo = CON(((V)&S_206), CON(((V)&S_207), CON(((V)&S_208), NIL))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_dnamed_upresent(void) {
  static V memo; static int done;
  if (!done) { memo = CON(((V)&S_206), CON(((V)&S_207), CON(((V)&S_208), NIL))); rt_root(&memo); done = 1; }
  return memo;
}
V d_Rules_deta_utable(void) {
  static V memo; static int done;
  if (!done) { memo = d_SeqList_dmap(clo_new(lam_8990, 1, 0), d_Rules_dpacks()); rt_root(&memo); done = 1; }
  return memo;
}
