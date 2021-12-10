From 5c715a5887d43e54e3b66075a417cea2ca831862 Mon Sep 17 00:00:00 2001
From: wHo-EM-i <ehteshammalik18998@gmail.com>
Date: Fri, 10 Dec 2021 21:40:32 +0530
Subject: [PATCH] Makefile: Rework Polly optimizer flags

* The command line option -polly-opt-fusion has been removed in the latest LLVM toolchain (& Clang 14).
  The flag's functionality is frequently misunderstood and is rarely useful.

  Taken from: llvm/llvm-project@cb879d0#diff-ee4a4d2d0f10b5f8ac34888ffbb8ec1f638dff5cfdd01a6ae7e5d0e5488c46dc

Newly added flags:

(1) -polly-loopfusion-greedy : This will agressively try to fuse any loop regardless of profitability.
			       This is what users might have expected what -polly-opt-fusion=max would do.

    Taken from: llvm/llvm-project@6448925#diff-ee4a4d2d0f10b5f8ac34888ffbb8ec1f638dff5cfdd01a6ae7e5d0e5488c46dc

(2) -polly-reschedule=1 : Optimize SCoPs using ISL.

    Taken from: llvm/llvm-project@ced20c6#diff-ee4a4d2d0f10b5f8ac34888ffbb8ec1f638dff5cfdd01a6ae7e5d0e5488c46dc

(3) -polly-postopts=1 : Apply post-rescheduling optimizations such as tiling (requires -polly-reschedule).

    Taken from: llvm/llvm-project@ced20c6#diff-ee4a4d2d0f10b5f8ac34888ffbb8ec1f638dff5cfdd01a6ae7e5d0e5488c46dc

* (2) & (3) are command line options that allow to turn off certain parts of the schedule tree optimization pipeline.

Signed-off-by: Dakkshesh <dakkshesh5@gmail.com>
Signed-off-by: reaPeR1010 <reaPeR10x10x@gmail.com>
Signed-off-by: reaPeR1010 <rohan10102002@gmail.com>
Co-Authored-By: Tashfin Shakeer Rhythm <82944428+Tashar02@users.noreply.github.com>
Signed-off-by: ImSpiDy <spidy2713@gmail.com>
---
 Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 5a5d8b5ef729..3462bf34b3c1 100644
--- a/Makefile
+++ b/Makefile
@@ -679,7 +679,9 @@ ifeq ($(cc-name),clang)
 KBUILD_CFLAGS	+= -mllvm -polly \
 		   -mllvm -polly-run-dce \
 		   -mllvm -polly-run-inliner \
-		   -mllvm -polly-opt-fusion=max \
+		   -mllvm -polly-reschedule=1 \
+		   -mllvm -polly-loopfusion-greedy=1 \
+		   -mllvm -polly-postopts=1 \
 		   -mllvm -polly-ast-use-context \
 		   -mllvm -polly-detect-keep-going \
 		   -mllvm -polly-vectorizer=stripmine \
-- 
2.30.2

