class LLVM::Generic is export {
	has LLVMGenericValueRef $.raw;
	
	method new(LLVMGenericValueRef $gv) {
		self.bless: raw => $gv
	}
	
	method int(::?CLASS:U: LLVM::Type $type, Int $int, :$signed) {
		return LLVM::Generic.new: LLVMCreateGenericValueOfInt($type.raw, $int, not $signed)
	}
	
	method num(::?CLASS:U: LLVM::Type $type, Num $num) {
		return LLVM::Generic.new: LLVMCreateGenericValueOfFloat($type.raw, $num)
	}
	
	multi method ptr(::?CLASS:U: Pointer[void] $ptr) {
		return LLVM::Generic.new: LLVMCreateGenericValueOfPointer($ptr)
	}
	
	multi method ptr(::?CLASS:U: Blob $blob) {
		return LLVM::Generic.new: LLVMCreateGenericValueOfPointer(nativecast(Pointer[void], $blob))
	}
	
	method int-width {
		return LLVMGenericValueIntWidth($!raw)
	}
	
	method Int {
		return LLVMGenericValueToInt($!raw, True).Int
	}
	
	method UInt {
		return LLVMGenericValueToInt($!raw, False).UInt
	}
	
	method Num {
		return LLVMGenericValueToFloat(LLVMFloatType, $!raw).Num
	}
	
	method Rat {
		return LLVMGenericValueToFloat(LLVMDoubleType, $!raw).Rat
	}
	
	method FatRat {
		return LLVMGenericValueToFloat(LLVMFP128Type, $!raw).FatRat
	}
	
	method Pointer {
		return LLVMGenericValueToPointer($!raw)
	}
	
	method Blob {
		my $ptr = LLVMGenericValueToPointer($!raw);
		return blob-from-pointer $ptr, elems => nativesizeof($ptr) div nativesizeof(uint8), type => Blob[uint8]
	}
	
	method dispose {
		LLVMDisposeGenericValue($!raw)
	}
}
