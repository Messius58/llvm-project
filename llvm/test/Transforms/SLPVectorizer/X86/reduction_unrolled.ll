; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -slp-vectorize-hor -S -mtriple=x86_64-unknown-linux-gnu -mcpu=bdver2 -debug < %s 2>&1 | FileCheck %s
; RUN: opt -slp-vectorizer -slp-vectorize-hor -S -mtriple=x86_64-unknown-linux-gnu -mcpu=core2 -debug < %s 2>&1 | FileCheck --check-prefix=SSE2 %s
; REQUIRES: asserts

; int test(unsigned int *p) {
;   int sum = 0;
;   for (int i = 0; i < 8; i++)
;     sum += p[i];
;   return sum;
; }

; Vector cost is 5, Scalar cost is 32
; CHECK: Adding cost -27 for reduction that starts with   %7 = load i32, i32* %arrayidx.7, align 4 (It is a splitting reduction)
; Vector cost is 17, Scalar cost is 16
; SSE2:  Adding cost 1 for reduction that starts with   %7 = load i32, i32* %arrayidx.7, align 4 (It is a splitting reduction)
define i32 @test(i32* nocapture readonly %p) {
; CHECK-LABEL: @test(
; CHECK:         [[BC:%.*]] = bitcast i32* %p to <8 x i32>*
; CHECK-NEXT:    [[LD:%.*]] = load <8 x i32>, <8 x i32>* [[BC]], align 4
; CHECK:         [[RDX_SHUF:%.*]] = shufflevector <8 x i32> [[LD]], <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX:%.*]] = add <8 x i32> [[LD]], [[RDX_SHUF]]
; CHECK-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <8 x i32> [[BIN_RDX]], <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX2:%.*]] = add <8 x i32> [[BIN_RDX]], [[RDX_SHUF1]]
; CHECK-NEXT:    [[RDX_SHUF3:%.*]] = shufflevector <8 x i32> [[BIN_RDX2]], <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[BIN_RDX4:%.*]] = add <8 x i32> [[BIN_RDX2]], [[RDX_SHUF3]]
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <8 x i32> [[BIN_RDX4]], i32 0
; CHECK:         ret i32 [[TMP2]]
;
; SSE2-LABEL: @test(
; SSE2:         [[BC:%.*]] = bitcast i32* %p to <8 x i32>*
; SSE2-NEXT:    [[LD:%.*]] = load <8 x i32>, <8 x i32>* [[BC]], align 4
; SSE2:         [[RDX_SHUF:%.*]] = shufflevector <8 x i32> [[LD]], <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
; SSE2-NEXT:    [[BIN_RDX:%.*]] = add <8 x i32> [[LD]], [[RDX_SHUF]]
; SSE2-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <8 x i32> [[BIN_RDX]], <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; SSE2-NEXT:    [[BIN_RDX2:%.*]] = add <8 x i32> [[BIN_RDX]], [[RDX_SHUF1]]
; SSE2-NEXT:    [[RDX_SHUF3:%.*]] = shufflevector <8 x i32> [[BIN_RDX2]], <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
; SSE2-NEXT:    [[BIN_RDX4:%.*]] = add <8 x i32> [[BIN_RDX2]], [[RDX_SHUF3]]
; SSE2-NEXT:    [[TMP2:%.*]] = extractelement <8 x i32> [[BIN_RDX4]], i32 0
; SSE2:         ret i32 [[TMP2]]
;
entry:
  %0 = load i32, i32* %p, align 4
  %arrayidx.1 = getelementptr inbounds i32, i32* %p, i64 1
  %1 = load i32, i32* %arrayidx.1, align 4
  %mul.18 = add i32 %1, %0
  %arrayidx.2 = getelementptr inbounds i32, i32* %p, i64 2
  %2 = load i32, i32* %arrayidx.2, align 4
  %mul.29 = add i32 %2, %mul.18
  %arrayidx.3 = getelementptr inbounds i32, i32* %p, i64 3
  %3 = load i32, i32* %arrayidx.3, align 4
  %mul.310 = add i32 %3, %mul.29
  %arrayidx.4 = getelementptr inbounds i32, i32* %p, i64 4
  %4 = load i32, i32* %arrayidx.4, align 4
  %mul.411 = add i32 %4, %mul.310
  %arrayidx.5 = getelementptr inbounds i32, i32* %p, i64 5
  %5 = load i32, i32* %arrayidx.5, align 4
  %mul.512 = add i32 %5, %mul.411
  %arrayidx.6 = getelementptr inbounds i32, i32* %p, i64 6
  %6 = load i32, i32* %arrayidx.6, align 4
  %mul.613 = add i32 %6, %mul.512
  %arrayidx.7 = getelementptr inbounds i32, i32* %p, i64 7
  %7 = load i32, i32* %arrayidx.7, align 4
  %mul.714 = add i32 %7, %mul.613
  ret i32 %mul.714
}
