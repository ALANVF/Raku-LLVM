class LLVM::Value is export {
	has LLVMValueRef $.raw;

	method new(LLVMValueRef $val) {
		self.bless: raw => $val
	}

	#sub LLVMVerifyFunction(LLVMValueRef, int32) returns int32
	#sub LLVMViewFunctionCFG(LLVMValueRef)
	#sub LLVMViewFunctionCFGOnly(LLVMValueRef)
	#sub LLVMGetDebugLocDirectory(LLVMValueRef, size_t is rw) returns Str
	#sub LLVMGetDebugLocFilename(LLVMValueRef, size_t is rw) returns Str
	#sub LLVMGetDebugLocLine(LLVMValueRef) returns size_t
	#sub LLVMGetDebugLocColumn(LLVMValueRef) returns size_t

	method type {
		return LLVM::Type.new: LLVMTypeOf($!raw)
	}

	method kind {
		return LLVM::ValueKind(LLVMGetValueKind($!raw))
	}

	method global-parent {
		return LLVM::Module.new: LLVMGetGlobalParent($!raw)
	}
	
	method name is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method             {LLVMGetValueName2($raw, my size_t $)},
			STORE => method (Str $name) {LLVMSetValueName2($raw, $name, $name.chars)}
		)
	}
	
	method linkage is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method                    {LLVM::Linkage(LLVMGetLinkage($raw))},
			STORE => method (LLVM::Linkage $l) {LLVMSetLinkage($raw, $l.Int)}
		)
	}
	
	method section is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method          {LLVMGetSection($raw)},
			STORE => method (Str $s) {LLVMSetSection($raw, $s)}
		)
	}
	
	method visibility is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method                       {LLVM::Visibility(LLVMGetVisibility($raw))},
			STORE => method (LLVM::Visibility $v) {LLVMSetVisibility($raw, $v.Int)}
		)
	}

	method dll-storage-class is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method                            {LLVM::DLLStorageClass(LLVMGetDLLStorageClass($raw))},
			STORE => method (LLVM::DLLStorageClass $c) {LLVMSetDLLStorageClass($raw, $c.Int)}
		)
	}
	
	method unnammed-address is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method                        {LLVM::UnnamedAddr(LLVMGetUnnamedAddress($raw))},
			STORE => method (LLVM::UnnamedAddr $a) {LLVMSetUnnamedAddress($raw, $a.Int)}
		)
	}
	
	method align is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method          {LLVMGetAlignment($raw)},
			STORE => method (Int $a) {LLVMSetAlignment($raw, $a)}
		)
	}
	
	#= Conditions
	method is-const        {return LLVMIsConstant($!raw).Bool}
	method is-const-string {return LLVMIsConstantString($!raw).Bool}
	method is-undef        {return LLVMIsUndef($!raw).Bool}
	method is-null         {return LLVMIsNull($!raw).Bool}
	method is-basic-block  {return LLVMValueIsBasicBlock($!raw).Bool}

	method is-md-node      {return LLVM::Value.new: LLVMIsAMDNode($!raw)}
	method is-md-string    {return LLVM::Value.new: LLVMIsAMDString($!raw)}

	#= Misc
	method dump {
		LLVMDumpValue($!raw)
	}

	method as-string {
		return LLVMGetAsString($!raw)
	}

	method Str {
		return LLVMPrintValueToString($!raw)
	}

	method replace-uses-with(LLVM::Value $val) {
		LLVMReplaceAllUsesWith($!raw, $val.raw)
	}

	#= Ops
	#sub LLVMGetFirstUse(LLVMValueRef) returns LLVMUseRef
	#sub LLVMGetOperandUse(LLVMValueRef, size_t) returns LLVMUseRef
	
	#sub LLVMGetOperand(LLVMValueRef, size_t) returns LLVMValueRef
	#sub LLVMSetOperand(LLVMValueRef, size_t, LLVMValueRef)
	#sub LLVMGetNumOperands(LLVMValueRef) returns int32
	#sub LLVMConstIntGetZExtValue(LLVMValueRef) returns ulonglong
	#sub LLVMConstIntGetSExtValue(LLVMValueRef) returns longlong
	#sub LLVMConstRealGetDouble(LLVMValueRef, int32 is rw) returns num64
	#sub LLVMGetElementAsConstant(LLVMValueRef, size_t) returns LLVMValueRef

	#= Constants
	#sub LLVMGetConstOpcode(LLVMValueRef) returns int32
	#sub LLVMConstNeg(LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNSWNeg(LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNUWNeg(LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstFNeg(LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNot(LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstAdd(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNSWAdd(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNUWAdd(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstFAdd(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstSub(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNSWSub(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNUWSub(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstFSub(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstMul(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNSWMul(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstNUWMul(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstFMul(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstUDiv(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstExactUDiv(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstSDiv(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstExactSDiv(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstFDiv(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstURem(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstSRem(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstFRem(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstAnd(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstOr(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstXor(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstShl(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstLShr(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstAShr(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstGEP(LLVMValueRef, CArray[LLVMValueRef], size_t) returns LLVMValueRef
	#sub LLVMConstInBoundsGEP(LLVMValueRef, CArray[LLVMValueRef], size_t) returns LLVMValueRef
	#sub LLVMConstTrunc(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstSExt(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstZExt(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstFPTrunc(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstFPExt(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstUIToFP(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstSIToFP(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstFPToUI(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstFPToSI(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstPtrToInt(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstIntToPtr(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstBitCast(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstAddrSpaceCast(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstZExtOrBitCast(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstSExtOrBitCast(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstTruncOrBitCast(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstPointerCast(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstIntCast(LLVMValueRef, LLVMTypeRef, int32) returns LLVMValueRef
	#sub LLVMConstFPCast(LLVMValueRef, LLVMTypeRef) returns LLVMValueRef
	#sub LLVMConstSelect(LLVMValueRef, LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstExtractElement(LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstInsertElement(LLVMValueRef, LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstShuffleVector(LLVMValueRef, LLVMValueRef, LLVMValueRef) returns LLVMValueRef
	#sub LLVMConstExtractValue(LLVMValueRef, CArray[size_t], size_t) returns LLVMValueRef
	#sub LLVMConstInsertValue(LLVMValueRef, LLVMValueRef, CArray[size_t], size_t) returns LLVMValueRef
	#sub LLVMBlockAddress(LLVMValueRef, LLVMBasicBlockRef) returns LLVMValueRef

	#= IFuncs
	#sub LLVMGetNextGlobalIFunc(LLVMValueRef) returns LLVMValueRef
	#sub LLVMGetPreviousGlobalIFunc(LLVMValueRef) returns LLVMValueRef
	#sub LLVMGetGlobalIFuncResolver(LLVMValueRef) returns LLVMValueRef
	#sub LLVMSetGlobalIFuncResolver(LLVMValueRef, LLVMValueRef)
	#sub LLVMEraseGlobalIFunc(LLVMValueRef)
	#sub LLVMRemoveGlobalIFunc(LLVMValueRef)

	#= Metadata
	method Metadata(LLVM::Context $ctx = LLVM::Context.global) {
		return LLVM::Metadata.new: $ctx, LLVMValueAsMetadata($!raw)
	}

	#= Basic Blocks
	method BasicBlock {
		return LLVM::BasicBlock.new: LLVMValueAsBasicBlock($!raw)
	}

	#= Instructions
	method Instruction {
		return LLVM::Instruction.new: $!raw
	}
}
