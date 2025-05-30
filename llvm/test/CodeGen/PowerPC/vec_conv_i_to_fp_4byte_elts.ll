; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr8 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P8
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-P9
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:     -mcpu=pwr9 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN: FileCheck %s --check-prefix=CHECK-BE

define i64 @test2elt(i64 %a.coerce) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mtfprd f0, r3
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xvcvuxwsp vs0, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtfprd f0, r3
; CHECK-P9-NEXT:    xxswapd v2, vs0
; CHECK-P9-NEXT:    xvcvuxwsp vs0, v2
; CHECK-P9-NEXT:    mfvsrld r3, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtfprd f0, r3
; CHECK-BE-NEXT:    xvcvuxwsp vs0, vs0
; CHECK-BE-NEXT:    mffprd r3, f0
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i64 %a.coerce to <2 x i32>
  %1 = uitofp <2 x i32> %0 to <2 x float>
  %2 = bitcast <2 x float> %1 to i64
  ret i64 %2
}

define <4 x float> @test4elt(<4 x i32> %a) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xvcvuxwsp v2, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xvcvuxwsp v2, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xvcvuxwsp v2, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = uitofp <4 x i32> %a to <4 x float>
  ret <4 x float> %0
}

define void @test8elt(ptr noalias nocapture sret(<8 x float>) %agg.result, ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    xvcvuxwsp vs1, vs1
; CHECK-P8-NEXT:    xvcvuxwsp vs0, vs0
; CHECK-P8-NEXT:    stxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 16(r4)
; CHECK-P9-NEXT:    lxv vs1, 0(r4)
; CHECK-P9-NEXT:    xvcvuxwsp vs1, vs1
; CHECK-P9-NEXT:    xvcvuxwsp vs0, vs0
; CHECK-P9-NEXT:    stxv vs0, 16(r3)
; CHECK-P9-NEXT:    stxv vs1, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 16(r4)
; CHECK-BE-NEXT:    lxv vs1, 0(r4)
; CHECK-BE-NEXT:    xvcvuxwsp vs1, vs1
; CHECK-BE-NEXT:    xvcvuxwsp vs0, vs0
; CHECK-BE-NEXT:    stxv vs0, 16(r3)
; CHECK-BE-NEXT:    stxv vs1, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x i32>, ptr %0, align 32
  %1 = uitofp <8 x i32> %a to <8 x float>
  store <8 x float> %1, ptr %agg.result, align 32
  ret void
}

define void @test16elt(ptr noalias nocapture sret(<16 x float>) %agg.result, ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 48
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    xvcvuxwsp vs0, vs0
; CHECK-P8-NEXT:    xvcvuxwsp vs2, vs2
; CHECK-P8-NEXT:    xvcvuxwsp vs1, vs1
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    xvcvuxwsp vs0, vs3
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r6
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r7
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 48(r4)
; CHECK-P9-NEXT:    lxv vs1, 32(r4)
; CHECK-P9-NEXT:    lxv vs2, 16(r4)
; CHECK-P9-NEXT:    lxv vs3, 0(r4)
; CHECK-P9-NEXT:    xvcvuxwsp vs3, vs3
; CHECK-P9-NEXT:    xvcvuxwsp vs2, vs2
; CHECK-P9-NEXT:    xvcvuxwsp vs1, vs1
; CHECK-P9-NEXT:    xvcvuxwsp vs0, vs0
; CHECK-P9-NEXT:    stxv vs0, 48(r3)
; CHECK-P9-NEXT:    stxv vs1, 32(r3)
; CHECK-P9-NEXT:    stxv vs2, 16(r3)
; CHECK-P9-NEXT:    stxv vs3, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 48(r4)
; CHECK-BE-NEXT:    lxv vs1, 32(r4)
; CHECK-BE-NEXT:    lxv vs2, 16(r4)
; CHECK-BE-NEXT:    lxv vs3, 0(r4)
; CHECK-BE-NEXT:    xvcvuxwsp vs3, vs3
; CHECK-BE-NEXT:    xvcvuxwsp vs2, vs2
; CHECK-BE-NEXT:    xvcvuxwsp vs1, vs1
; CHECK-BE-NEXT:    xvcvuxwsp vs0, vs0
; CHECK-BE-NEXT:    stxv vs0, 48(r3)
; CHECK-BE-NEXT:    stxv vs1, 32(r3)
; CHECK-BE-NEXT:    stxv vs2, 16(r3)
; CHECK-BE-NEXT:    stxv vs3, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i32>, ptr %0, align 64
  %1 = uitofp <16 x i32> %a to <16 x float>
  store <16 x float> %1, ptr %agg.result, align 64
  ret void
}

define i64 @test2elt_signed(i64 %a.coerce) local_unnamed_addr #0 {
; CHECK-P8-LABEL: test2elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    mtfprd f0, r3
; CHECK-P8-NEXT:    xxswapd v2, vs0
; CHECK-P8-NEXT:    xvcvsxwsp vs0, v2
; CHECK-P8-NEXT:    xxswapd vs0, vs0
; CHECK-P8-NEXT:    mffprd r3, f0
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test2elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    mtfprd f0, r3
; CHECK-P9-NEXT:    xxswapd v2, vs0
; CHECK-P9-NEXT:    xvcvsxwsp vs0, v2
; CHECK-P9-NEXT:    mfvsrld r3, vs0
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test2elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    mtfprd f0, r3
; CHECK-BE-NEXT:    xvcvsxwsp vs0, vs0
; CHECK-BE-NEXT:    mffprd r3, f0
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast i64 %a.coerce to <2 x i32>
  %1 = sitofp <2 x i32> %0 to <2 x float>
  %2 = bitcast <2 x float> %1 to i64
  ret i64 %2
}

define <4 x float> @test4elt_signed(<4 x i32> %a) local_unnamed_addr #1 {
; CHECK-P8-LABEL: test4elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xvcvsxwsp v2, v2
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test4elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xvcvsxwsp v2, v2
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test4elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    xvcvsxwsp v2, v2
; CHECK-BE-NEXT:    blr
entry:
  %0 = sitofp <4 x i32> %a to <4 x float>
  ret <4 x float> %0
}

define void @test8elt_signed(ptr noalias nocapture sret(<8 x float>) %agg.result, ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test8elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 16
; CHECK-P8-NEXT:    lxvd2x vs1, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    xvcvsxwsp vs1, vs1
; CHECK-P8-NEXT:    xvcvsxwsp vs0, vs0
; CHECK-P8-NEXT:    stxvd2x vs1, 0, r3
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test8elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 16(r4)
; CHECK-P9-NEXT:    lxv vs1, 0(r4)
; CHECK-P9-NEXT:    xvcvsxwsp vs1, vs1
; CHECK-P9-NEXT:    xvcvsxwsp vs0, vs0
; CHECK-P9-NEXT:    stxv vs0, 16(r3)
; CHECK-P9-NEXT:    stxv vs1, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test8elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 16(r4)
; CHECK-BE-NEXT:    lxv vs1, 0(r4)
; CHECK-BE-NEXT:    xvcvsxwsp vs1, vs1
; CHECK-BE-NEXT:    xvcvsxwsp vs0, vs0
; CHECK-BE-NEXT:    stxv vs0, 16(r3)
; CHECK-BE-NEXT:    stxv vs1, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <8 x i32>, ptr %0, align 32
  %1 = sitofp <8 x i32> %a to <8 x float>
  store <8 x float> %1, ptr %agg.result, align 32
  ret void
}

define void @test16elt_signed(ptr noalias nocapture sret(<16 x float>) %agg.result, ptr nocapture readonly) local_unnamed_addr #2 {
; CHECK-P8-LABEL: test16elt_signed:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    li r5, 48
; CHECK-P8-NEXT:    li r6, 32
; CHECK-P8-NEXT:    li r7, 16
; CHECK-P8-NEXT:    lxvd2x vs3, 0, r4
; CHECK-P8-NEXT:    lxvd2x vs0, r4, r5
; CHECK-P8-NEXT:    lxvd2x vs1, r4, r6
; CHECK-P8-NEXT:    lxvd2x vs2, r4, r7
; CHECK-P8-NEXT:    xvcvsxwsp vs0, vs0
; CHECK-P8-NEXT:    xvcvsxwsp vs2, vs2
; CHECK-P8-NEXT:    xvcvsxwsp vs1, vs1
; CHECK-P8-NEXT:    stxvd2x vs0, r3, r5
; CHECK-P8-NEXT:    xvcvsxwsp vs0, vs3
; CHECK-P8-NEXT:    stxvd2x vs1, r3, r6
; CHECK-P8-NEXT:    stxvd2x vs2, r3, r7
; CHECK-P8-NEXT:    stxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    blr
;
; CHECK-P9-LABEL: test16elt_signed:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    lxv vs0, 48(r4)
; CHECK-P9-NEXT:    lxv vs1, 32(r4)
; CHECK-P9-NEXT:    lxv vs2, 16(r4)
; CHECK-P9-NEXT:    lxv vs3, 0(r4)
; CHECK-P9-NEXT:    xvcvsxwsp vs3, vs3
; CHECK-P9-NEXT:    xvcvsxwsp vs2, vs2
; CHECK-P9-NEXT:    xvcvsxwsp vs1, vs1
; CHECK-P9-NEXT:    xvcvsxwsp vs0, vs0
; CHECK-P9-NEXT:    stxv vs0, 48(r3)
; CHECK-P9-NEXT:    stxv vs1, 32(r3)
; CHECK-P9-NEXT:    stxv vs2, 16(r3)
; CHECK-P9-NEXT:    stxv vs3, 0(r3)
; CHECK-P9-NEXT:    blr
;
; CHECK-BE-LABEL: test16elt_signed:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    lxv vs0, 48(r4)
; CHECK-BE-NEXT:    lxv vs1, 32(r4)
; CHECK-BE-NEXT:    lxv vs2, 16(r4)
; CHECK-BE-NEXT:    lxv vs3, 0(r4)
; CHECK-BE-NEXT:    xvcvsxwsp vs3, vs3
; CHECK-BE-NEXT:    xvcvsxwsp vs2, vs2
; CHECK-BE-NEXT:    xvcvsxwsp vs1, vs1
; CHECK-BE-NEXT:    xvcvsxwsp vs0, vs0
; CHECK-BE-NEXT:    stxv vs0, 48(r3)
; CHECK-BE-NEXT:    stxv vs1, 32(r3)
; CHECK-BE-NEXT:    stxv vs2, 16(r3)
; CHECK-BE-NEXT:    stxv vs3, 0(r3)
; CHECK-BE-NEXT:    blr
entry:
  %a = load <16 x i32>, ptr %0, align 64
  %1 = sitofp <16 x i32> %a to <16 x float>
  store <16 x float> %1, ptr %agg.result, align 64
  ret void
}
