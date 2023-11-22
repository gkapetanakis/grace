Hello
; ModuleID = 'grace'
source_filename = "grace"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%frame__global.main = type { void*, [2 x i32] }
%frame__global.main.g = type { %frame__global.main*, i32* }

define void @func__global.main.g(%frame__global.main* %0, i32* %1) {
entry:
  %frame_struct = alloca %frame__global.main.g, align 8
  %param_ptr = getelementptr inbounds %frame__global.main.g, %frame__global.main.g* %frame_struct, i32 0, i32 0
  store %frame__global.main* %0, %frame__global.main** %param_ptr, align 8
  %param_ptr1 = getelementptr inbounds %frame__global.main.g, %frame__global.main.g* %frame_struct, i32 0, i32 1
  store i32* %1, i32** %param_ptr1, align 8
  %link_ptr = getelementptr inbounds %frame__global.main.g, %frame__global.main.g* %frame_struct, i32 0, i32 0
  %link = load %frame__global.main*, %frame__global.main** %link_ptr, align 8
  %element_ptr = getelementptr inbounds %frame__global.main, %frame__global.main* %link, i32 0, i32 1
  %array_access = getelementptr [2 x i32], [2 x i32]* %element_ptr, i32 0, i32 0
  store i32 1, i32* %array_access, align 4
  ret void
}

define void @func__global.main(void* %0) {
entry:
  %frame_struct = alloca %frame__global.main, align 8
  %param_ptr = getelementptr inbounds %frame__global.main, %frame__global.main* %frame_struct, i32 0, i32 0
  store void* %0, void** %param_ptr, align 8
  %element_ptr = getelementptr inbounds %frame__global.main, %frame__global.main* %frame_struct, i32 0, i32 1
  %ref_ptr = getelementptr inbounds [2 x i32], [2 x i32]* %element_ptr, i32 0, i32 0
  call void @func__global.main.g(%frame__global.main* %frame_struct, i32* %ref_ptr)
  ret void
}

