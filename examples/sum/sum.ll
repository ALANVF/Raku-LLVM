; ModuleID = 'test-module'
source_filename = "test-module"

@str = private unnamed_addr constant [4 x i8] c"%i\0A\00"

define i32 @sum(i32, i32) {
entry:
  %tmp = add i32 %0, %1
  ret i32 %tmp
}

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %res = call i32 @sum(i32 1, i32 2)
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str, i32 0, i32 0), i32 %res)
  ret i32 0
}
