# https://llvm.org/doxygen/group__LLVMCCoreContext.html

class LLVM::Context is export {
	has LLVMContextRef $.raw;
	
	method global(::?CLASS:U:) {
		return LLVM::Context.new: LLVMGetGlobalContext
	}

	multi method new(LLVMContextRef $ctx) {
		self.bless: raw => $ctx
	}
	multi method new {
		self.bless: raw => LLVMContextCreate
	}

	method dispose {
		LLVMContextDispose($!raw)
	}

	method init-core {
		LLVMInitializeCore($!raw)
	}

	#sub LLVMParseBitcodeInContext(LLVMContextRef, LLVMMemoryBufferRef, LLVMModuleRef is rw, Str is rw)    
	#sub LLVMParseBitcodeInContext2(LLVMContextRef, LLVMMemoryBufferRef, LLVMModuleRef is rw)
	#sub LLVMGetBitcodeModuleInContext(LLVMContextRef, LLVMMemoryBufferRef, LLVMModuleRef is rw, Str is rw)
	#sub LLVMGetBitcodeModuleInContext2(LLVMContextRef, LLVMMemoryBufferRef, LLVMModuleRef is rw)

	#sub LLVMContextSetDiagnosticHandler(LLVMContextRef, Pointer, Pointer[void])
	#sub LLVMContextGetDiagnosticHandler(LLVMContextRef)                         returns Pointer
	#sub LLVMContextGetDiagnosticContext(LLVMContextRef)                         returns Pointer[void]
	#sub LLVMContextSetYieldCallback(LLVMContextRef, Pointer, Pointer[void])

	method discard-value-names is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method           {LLVMContextShouldDiscardValueNames($raw).Bool},
			STORE => method (Bool $c) {LLVMContextSetDiscardValueNames($raw, $c)}
		)
	}

	#sub LLVMGetMDKindIDInContext(LLVMContextRef, Str, size_t) returns size_t
	
	multi method enum-attr(Str $enum, Int $value = 0) {
		return LLVM::Attribute.enum($enum, $value, self)
	}
	multi method enum-attr(Int $kind, Int $value = 0) {
		return LLVM::Attribute.enum($kind, $value, self)
	}

	method string-attr(Str $kind, Str $value = "") {
		return LLVM::Attribute.string($kind, $value, self)
	}

	method int1           {return LLVM::Type.new: LLVMInt1TypeInContext($!raw)}
	method int8           {return LLVM::Type.new: LLVMInt8TypeInContext($!raw)}
	method int16          {return LLVM::Type.new: LLVMInt16TypeInContext($!raw)}
	method int32          {return LLVM::Type.new: LLVMInt32TypeInContext($!raw)}
	method int64          {return LLVM::Type.new: LLVMInt64TypeInContext($!raw)}
	method int128         {return LLVM::Type.new: LLVMInt128TypeInContext($!raw)}
	method int(Int $bits) {return LLVM::Type.new: LLVMIntTypeInContext($!raw, $bits)}	

	method half           {return LLVM::Type.new: LLVMHalfTypeInContext($!raw)}
	method float          {return LLVM::Type.new: LLVMFloatTypeInContext($!raw)}
	method double         {return LLVM::Type.new: LLVMDoubleTypeInContext($!raw)}
	method x86-fp80       {return LLVM::Type.new: LLVMX86FP80TypeInContext($!raw)}
	method fp128          {return LLVM::Type.new: LLVMFP128TypeInContext($!raw)}
	method ppc-fp128      {return LLVM::Type.new: LLVMPPCFP128TypeInContext($!raw)}

	multi method struct(@elems where {.all ~~ LLVM::Type}, :$packed) {
		return LLVM::Type.new: LLVMStructTypeInContext($!raw, CArray[LLVMTypeRef].new(@elems>>.raw), @elems.elems, so $packed)
	}
	multi method struct(Str $name) {
		return LLVM::Type.new: LLVMStructCreateNamed($!raw, $name)
	}

	method void     {return LLVM::Type.new: LLVMVoidTypeInContext($!raw)}
	method label    {return LLVM::Type.new: LLVMLabelTypeInContext($!raw)}
	method x86-mmx  {return LLVM::Type.new: LLVMX86MMXTypeInContext($!raw)}
	method token    {return LLVM::Type.new: LLVMTokenTypeInContext($!raw)}
	method metadata {return LLVM::Type.new: LLVMMetadataTypeInContext($!raw)}

	method const-str(Str $value, :$null-terminate = True) {
		return LLVM::Value.new: LLVMConstStringInContext($!raw, $value, $value.chars, not $null-terminate)
	}

	method const-struct(@values where {.all ~~ LLVM::Value}, :$packed) {
		return LLVM::Value.new: LLVMConstStructInContext($!raw, CArray[LLVMValueRef].new(@values>>.raw), @values.elems, so $packed)
	}

	#sub LLVMIntrinsicGetType(LLVMContextRef, size_t, CArray[LLVMTypeRef], size_t)          returns LLVMTypeRef

	#sub LLVMMDStringInContext2(LLVMContextRef, Str, size_t)                   returns LLVMMetadataRef
	#sub LLVMMDNodeInContext2(LLVMContextRef, CArray[LLVMMetadataRef], size_t) returns LLVMMetadataRef
	#sub LLVMMetadataAsValue(LLVMContextRef, LLVMMetadataRef)                  returns LLVMValueRef
	#sub LLVMMDStringInContext(LLVMContextRef, Str, size_t)                    returns LLVMValueRef
	#sub LLVMMDNodeInContext(LLVMContextRef, CArray[LLVMValueRef], size_t)     returns LLVMValueRef
	
	method basic-block(Str $name) {
		return LLVM::BasicBlock.new: LLVMCreateBasicBlockInContext($!raw, $name)
	}
	#sub LLVMAppendBasicBlockInContext(LLVMContextRef, LLVMValueRef, Str)                returns LLVMBasicBlockRef
	#sub LLVMInsertBasicBlockInContext(LLVMContextRef, LLVMBasicBlockRef, Str)           returns LLVMBasicBlockRef
	
	method builder {
		return LLVM::Builder.new: LLVMCreateBuilderInContext($!raw)
	}

	#sub LLVMIntPtrTypeInContext(LLVMContextRef, LLVMTargetDataRef) returns LLVMTypeRef
	#sub LLVMIntPtrTypeForASInContext(LLVMContextRef, LLVMTargetDataRef, size_t) returns LLVMTypeRef
}
