class LLVM::Builder is export {
	has LLVMBuilderRef $.raw;

	multi method new(LLVMBuilderRef $bdr) {
		self.bless: raw => $bdr
	}
	multi method new {
		self.bless: raw => LLVMCreateBuilder
	}
	
	# figure this stuff out
	#sub LLVMInsertExistingBasicBlockAfterInsertBlock(LLVMBuilderRef, LLVMBasicBlockRef)
	##sub LLVMPositionBuilder(LLVMBuilderRef, LLVMBasicBlockRef, LLVMValueRef)
	##sub LLVMPositionBuilderBefore(LLVMBuilderRef, LLVMValueRef)
	##sub LLVMPositionBuilderAtEnd(LLVMBuilderRef, LLVMBasicBlockRef)
	#sub LLVMGetInsertBlock(LLVMBuilderRef)                                                                  returns 	LLVMBasicBlockRef	
	#sub LLVMClearInsertionPosition(LLVMBuilderRef)
	#sub LLVMInsertIntoBuilder(LLVMBuilderRef, LLVMValueRef)
	#sub LLVMInsertIntoBuilderWithName(LLVMBuilderRef, LLVMValueRef, Str)
	method move-to-end(LLVM::BasicBlock $bb) {
		LLVMPositionBuilderAtEnd($!raw, $bb.raw)
	}
	
	#sub LLVMGetCurrentDebugLocation2(LLVMBuilderRef)                                                        returns LLVMMetadataRef
	#sub LLVMSetCurrentDebugLocation2(LLVMBuilderRef, LLVMMetadataRef)
	#sub LLVMSetInstDebugLocation(LLVMBuilderRef, LLVMValueRef)
	
	#sub LLVMBuilderGetDefaultFPMathTag(LLVMBuilderRef)                                                      returns LLVMMetadataRef
	#sub LLVMBuilderSetDefaultFPMathTag(LLVMBuilderRef, LLVMMetadataRef)
	
	method dispose {
		LLVMDisposeBuilder($!raw)
	}

	method build(&fn) {
		fn self
	}

	#= Ops
	method bin-op(LLVM::Opcode $op, LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildBinOp($!raw, $op.Int, $lhs.raw, $rhs.raw, $as)
	}

	method ret-void {
		return LLVM::Instruction.new: LLVMBuildRetVoid($!raw)
	}

	multi method ret(LLVM::Value $val) {
		return LLVM::Instruction.new: LLVMBuildRet($!raw, $val.raw)
	}
	multi method ret(@vals where {.all ~~ LLVM::Value}) {
		return LLVM::Instruction.new: LLVMBuildAggregateRet($!raw, CArray[LLVMValueRef].new(@vals>>.raw), @vals.elems)
	}

	multi method br(LLVM::BasicBlock $bb) {
		return LLVM::Instruction.new: LLVMBuildBr($!raw, $bb.raw)
	}
	multi method br(LLVM::Value $cond, LLVM::BasicBlock $true, LLVM::BasicBlock $false) {
		return LLVM::Instruction.new: LLVMBuildCondBr($!raw, $cond.raw, $true.raw, $false.raw)
	}
	multi method br(LLVM::Value $addr, Int $num-dests) {
		return LLVM::Instruction.new: LLVMBuildIndirectBr($!raw, $addr.raw, $num-dests)
	}

	method switch(LLVM::Value $val, LLVM::BasicBlock $default, Int $num-cases) {
		return LLVM::Instruction.new: LLVMBuildSwitch($!raw, $val.raw, $default.raw, $num-cases)
	}
	
	multi method invoke(LLVM::Value $fn, @args where {.all ~~ LLVM::Value}, LLVM::BasicBlock $then, LLVM::BasicBlock $catch, Str :$as = "") {
		my $args = CArray[LLVMValueRef].new(@args>>.raw);
		return LLVM::Value.new: LLVMBuildInvoke($!raw, $fn.raw, $args, @args.elems, $then.raw, $catch.raw, $as)
	}
	multi method invoke(LLVM::Type $type, LLVM::Value $fn, @args where {.all ~~ LLVM::Value}, LLVM::BasicBlock $then, LLVM::BasicBlock $catch, Str :$as = "") {
		my $args = CArray[LLVMValueRef].new(@args>>.raw);
		return LLVM::Value.new: LLVMBuildInvoke2($!raw, $type.raw, $fn.raw, $args, @args.elems, $then.raw, $catch.raw, $as)
	}

	method unreachable {
		return LLVM::Instruction.new: LLVMBuildUnreachable($!raw)
	}

	method resume(LLVM::Value $exn) {
		return LLVM::Instruction.new: LLVMBuildResume($!raw, $exn.raw)
	}
	
	#sub LLVMBuildLandingPad(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, size_t, Str)                           returns LLVMValueRef
	#sub LLVMBuildCleanupRet(LLVMBuilderRef, LLVMValueRef, LLVMBasicBlockRef)                                  returns LLVMValueRef
	#sub LLVMBuildCatchRet(LLVMBuilderRef, LLVMValueRef, LLVMBasicBlockRef)                                    returns LLVMValueRef
	#sub LLVMBuildCatchPad(LLVMBuilderRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)                    returns LLVMValueRef
	#sub LLVMBuildCleanupPad(LLVMBuilderRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)                  returns LLVMValueRef
	#sub LLVMBuildCatchSwitch(LLVMBuilderRef, LLVMValueRef, LLVMBasicBlockRef, size_t, Str)                    returns LLVMValueRef
	
	method add(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildAdd($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method nsw-add(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNSWAdd($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method nuw-add(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNUWAdd($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method fadd(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFAdd($!raw, $lhs.raw, $rhs.raw, $as)
	}

	method sub(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildSub($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method nsw-sub(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNSWSub($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method nuw-sub(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNUWSub($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method fsub(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFSub($!raw, $lhs.raw, $rhs.raw, $as)
	}
	
	method mul(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildMul($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method nsw-mul(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNSWMul($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method nuw-mul(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNUWMul($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method fmul(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFMul($!raw, $lhs.raw, $rhs.raw, $as)
	}
	
	method udiv(LLVM::Value $lhs, LLVM::Value $rhs, :$exact, Str :$as = "") {
		if $exact {
			return LLVM::Value.new: LLVMBuildExactUDiv($!raw, $lhs.raw, $rhs.raw, $as)
		} else {
			return LLVM::Value.new: LLVMBuildUDiv($!raw, $lhs.raw, $rhs.raw, $as)
		}
	}
	method sdiv(LLVM::Value $lhs, LLVM::Value $rhs, :$exact, Str :$as = "") {
		if $exact {
			return LLVM::Value.new: LLVMBuildExactSDiv($!raw, $lhs.raw, $rhs.raw, $as)
		} else {
			return LLVM::Value.new: LLVMBuildSDiv($!raw, $lhs.raw, $rhs.raw, $as)
		}
	}
	method fdiv(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFDiv($!raw, $lhs.raw, $rhs.raw, $as)
	}

	method urem(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildURem($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method srem(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildSRem($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method frem(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFRem($!raw, $lhs.raw, $rhs.raw, $as)
	}

	method shl(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildShl($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method lshr(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildLShr($!raw, $lhs.raw, $rhs.raw, $as)
	}
	method ashr(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildAShr($!raw, $lhs.raw, $rhs.raw, $as)
	}

	method and(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildAnd($!raw, $lhs.raw, $rhs.raw, $as)
	}

	method or(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildOr($!raw, $lhs.raw, $rhs.raw, $as)
	}

	method xor(LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildXor($!raw, $lhs.raw, $rhs.raw, $as)
	}

	method neg(LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNeg($!raw, $val.raw, $as)
	}
	method nsw-neg(LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNSWNeg($!raw, $val.raw, $as)
	}
	method nuw-neg(LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNUWNeg($!raw, $val.raw, $as)
	}
	method fneg(LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFNeg($!raw, $val.raw, $as)
	}

	method not(LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildNot($!raw, $val.raw, $as)
	}
	
	method malloc(LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildMalloc($!raw, $type.raw, $as)
	}

	method array-malloc(LLVM::Type $type, LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildArrayMalloc($!raw, $type.raw, $val.raw, $as)
	}

	method memset(LLVM::Value $ptr, LLVM::Value $val, LLVM::Value $length, Int $align) {
		return LLVM::Instruction.new: LLVMBuildMemSet($!raw, $ptr.raw, $val.raw, $length.raw, $align)
	}
	
	method memcpy(LLVM::Value $dest, Int $dest-align, LLVM::Value $src, Int $src-align, LLVM::Value $size) {
		return LLVM::Instruction.new: LLVMBuildMemCpy($!raw, $dest.raw, $dest-align, $src.raw, $src-align, $size.raw)
	}

	method memmove(LLVM::Value $dest, Int $dest-align, LLVM::Value $src, Int $src-align, LLVM::Value $size) {
		return LLVM::Instruction.new: LLVMBuildMemMove($!raw, $dest.raw, $dest-align, $src.raw, $src-align, $size.raw)
	}

	method alloca(LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildAlloca($!raw, $type.raw, $as)
	}

	method array-alloca(LLVM::Type $type, LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildArrayAlloca($!raw, $type.raw, $val.raw, $as)
	}

	method free(LLVM::Value $val) {
		return LLVM::Instruction.new: LLVMBuildFree($!raw, $val.raw)
	}

	multi method load(LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildLoad($!raw, $val.raw, $as)
	}
	multi method load(LLVM::Type $type, LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildLoad2($!raw, $type.raw, $val.raw, $as)
	}

	method store(LLVM::Value $val, LLVM::Value $ptr) {
		return LLVM::Instruction.new: LLVMBuildStore($!raw, $val.raw, $ptr.raw)
	}

	multi method gep(LLVM::Value $ptr, @indices where {.all ~~ LLVM::Value}, Str :$as = "") {
		my $indices = CArray[LLVMValueRef].new(@indices>>.raw);
		return LLVM::Value.new: LLVMBuildGEP($!raw, $ptr.raw, $indices, @indices.elems, $as)
	}
	multi method gep(LLVM::Type $type, LLVM::Value $ptr, @indices where {.all ~~ LLVM::Value}, Str :$as = "") {
		my $indices = CArray[LLVMValueRef].new(@indices>>.raw);
		return LLVM::Value.new: LLVMBuildGEP2($!raw, $type.raw, $ptr.raw, $indices, @indices.elems, $as)
	}

	multi method inbounds-gep(LLVM::Value $ptr, @indices where {.all ~~ LLVM::Value}, Str :$as = "") {
		my $indices = CArray[LLVMValueRef].new(@indices>>.raw);
		return LLVM::Value.new: LLVMBuildInBoundsGEP($!raw, $ptr.raw, $indices, @indices.elems, $as)
	}
	multi method inbounds-gep(LLVM::Type $type, LLVM::Value $ptr, @indices where {.all ~~ LLVM::Value}, Str :$as = "") {
		my $indices = CArray[LLVMValueRef].new(@indices>>.raw);
		return LLVM::Value.new: LLVMBuildInBoundsGEP2($!raw, $type.raw, $ptr.raw, $indices, @indices.elems, $as)
	}

	multi method struct-gep(LLVM::Value $ptr, Int $index, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildStructGEP($!raw, $ptr.raw, $index, $as)
	}
	multi method struct-gep(LLVM::Type $type, LLVM::Value $ptr, Int $index, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildStructGEP2($!raw, $type.raw, $ptr.raw, $index, $as)
	}

	method global-string(Str $str, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildGlobalString($!raw, $str, $as)
	}

	method global-string-ptr(Str $str, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildGlobalStringPtr($!raw, $str, $as)
	}
	
	method trunc(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildTrunc($!raw, $val.raw, $type.raw, $as)
	}

	method zext(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildZExt($!raw, $val.raw, $type.raw, $as)
	}

	method sext(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildSExt($!raw, $val.raw, $type.raw, $as)
	}

	method fp-to-ui(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFPToUI($!raw, $val.raw, $type.raw, $as)
	}

	method fp-to-si(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFPToSI($!raw, $val.raw, $type.raw, $as)
	}

	method ui-to-fp(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildUIToFP($!raw, $val.raw, $type.raw, $as)
	}
	
	method si-to-fp(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildSIToFP($!raw, $val.raw, $type.raw, $as)
	}
	
	method fp-trunc(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFPTrunc($!raw, $val.raw, $type.raw, $as)
	}

	method fp-ext(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFPExt($!raw, $val.raw, $type.raw, $as)
	}

	method ptr-to-int(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildPtrToInt($!raw, $val.raw, $type.raw, $as)
	}

	method int-to-ptr(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildIntToPtr($!raw, $val.raw, $type.raw, $as)
	}

	method addr-space-cast(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildAddrSpaceCast($!raw, $val.raw, $type.raw, $as)
	}

	method cast(LLVM::Value $val, LLVM::Opcode $op, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildCast($!raw, $op.Int, $val.raw, $type.raw, $as)
	}

	method ptr-cast(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildPointerCast($!raw, $val.raw, $type.raw, $as)
	}

	method bit-cast(LLVM::Value $val, LLVM::Type $type, :$zext, :$sext, :$trunc, Str :$as = "") {
		with $zext {
			return LLVM::Value.new: LLVMBuildZExtOrBitCast($!raw, $val.raw, $type.raw, $as)
		} orwith $sext {
			return LLVM::Value.new: LLVMBuildSExtOrBitCast($!raw, $val.raw, $type.raw, $as)
		} orwith $trunc {
			return LLVM::Value.new: LLVMBuildTruncOrBitCast($!raw, $val.raw, $type.raw, $as)
		} else {
			return LLVM::Value.new: LLVMBuildBitCast($!raw, $val.raw, $type.raw, $as)
		}
	}

	method int-cast(LLVM::Value $val, LLVM::Type $type, :$signed, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildIntCast2($!raw, $val.raw, $type.raw, not $signed, $as)
	}

	method fp-cast(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFPCast($!raw, $val.raw, $type.raw, $as)
	}
	
	method icmp(LLVM::IntPredicate $cmp, LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildICmp($!raw, $cmp.Int, $lhs.raw, $rhs.raw, $as)
	}
	
	method fcmp(LLVM::RealPredicate $cmp, LLVM::Value $lhs, LLVM::Value $rhs, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFCmp($!raw, $cmp.Int, $lhs.raw, $rhs.raw, $as)
	}
	
	method phi(LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildPhi($!raw, $type.raw, $as)
	}
	
	multi method call(LLVM::Value $fn, @args where {.all ~~ LLVM::Value}, Str :$as = "") {
		my $args = CArray[LLVMValueRef].new(@args>>.raw);
		return LLVM::Value.new: LLVMBuildCall($!raw, $fn.raw, $args, @args.elems, $as)
	}
	multi method call(LLVM::Type $type, LLVM::Value $fn, @args where {.all ~~ LLVM::Value}, Str :$as = "") {
		my $args = CArray[LLVMValueRef].new(@args>>.raw);
		return LLVM::Value.new: LLVMBuildCall2($!raw, $type.raw, $fn.raw, $args, @args.elems, $as)
	}
	
	method select(LLVM::Value $val, LLVM::Value $true, LLVM::Value $false, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildSelect($!raw, $val.raw, $true.raw, $false.raw, $as)
	}
	
	method va-arg(LLVM::Value $val, LLVM::Type $type, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildVAArg($!raw, $val.raw, $type.raw, $as)
	}
	
	method extract-elem(LLVM::Value $vec, LLVM::Value $index, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildExtractElement($!raw, $vec.raw, $index.raw, $as)
	}
	
	method insert-elem(LLVM::Value $vec, LLVM::Value $val, LLVM::Value $index, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildInsertElement($!raw, $vec.raw, $val.raw, $index.raw, $as)
	}
	
	method shuffle-vec(LLVM::Value $vec1, LLVM::Value $vec2, LLVM::Value $mask, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildShuffleVector($!raw, $vec1.raw, $vec2.raw, $mask.raw, $as)
	}
	
	method extract-val(LLVM::Value $agg, Int $index, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildExtractElement($!raw, $agg.raw, $index, $as)
	}
	
	method insert-val(LLVM::Value $agg, LLVM::Value $val, Int $index, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildInsertElement($!raw, $agg.raw, $val.raw, $index, $as)
	}
	
	method is-null(LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildIsNull($!raw, $val.raw, $as)
	}
	
	method isn't-null(LLVM::Value $val, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildIsNotNull($!raw, $val.raw, $as)
	}
	
	method ptr-diff(LLVM::Value $ptr1, LLVM::Value $ptr2, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildPtrDiff($!raw, $ptr1.raw, $ptr2.raw, $as)
	}
	
	method fence(LLVM::AtomicOrdering $o, Bool :$single-thread!, Str :$as = "") {
		return LLVM::Value.new: LLVMBuildFence($!raw, $o.Int, $single-thread, $as)
	}
	
	method atomic-rmw(LLVM::AtomicRMWBinOp $rmw, LLVM::Value $ptr, LLVM::Value $val, LLVM::AtomicOrdering $o, Bool :$single-thread!) {
		return LLVM::Instruction.new: LLVMBuildAtomicRMW($!raw, $rmw.Int, $ptr.raw, $val.raw, $o.Int, $single-thread)
	}
	
	method atomic-cmp-xchg(LLVM::Value $ptr, LLVM::Value $cmp, LLVM::Value $new, LLVM::AtomicOrdering $success, LLVM::AtomicOrdering $failure, Bool :$single-thread!) {
		return LLVM::Instruction.new: LLVMBuildAtomicCmpXchg($!raw, $ptr.raw, $cmp.raw, $new.raw, $success.Int, $failure.Int, $single-thread)
	}
}
