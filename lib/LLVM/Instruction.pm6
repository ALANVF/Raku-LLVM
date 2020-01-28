class LLVM::SuccessorsHelper {
	has LLVMValueRef $.val;
	
	submethod AT-POS(Int $index) {
		return LLVM::BasicBlock.new: LLVMGetSuccessor($!val, $index)
	}

	submethod ASSIGN-POS(Int $index, LLVM::BasicBlock $bb) {
		LLVMSetSuccessor($!val, $index, $bb.raw)
	}

	method elems {
		return LLVMGetNumSuccessors($!val)
	}

	method list {
		gather for ^self.elems {
			take self[$_]
		}.list
	}
}

class LLVM::ClausesHelper {
	has LLVMValueRef $.val;
	
	submethod AT-POS(Int $index) {
		return LLVM::Value.new: LLVMGetClause($!val, $index)
	}

	method push(LLVM::Value $clause) {
		LLVMAddClause($!val, $clause.raw)
	}

	method elems {
		return LLVMGetNumClauses($!val)
	}

	method list {
		gather for ^self.elems {
			take self[$_]
		}.list
	}
}

class LLVM::HandlersHelper {
	has LLVMValueRef $.val;
	
	submethod AT-POS(Int $index) {
		return self.list[$index]
	}

	method push(LLVM::BasicBlock $handler) {
		LLVMAddHandler($!val, $handler.raw)
	}

	method elems {
		return LLVMGetNumHandlers($!val)
	}
	
	method list {
		my $handlers = CArray[LLVMBasicBlockRef].allocate: LLVMGetNumHandlers($!val);
		LLVMGetHandlers($!val, $handlers);
		return $handlers.list.map({LLVM::BasicBlock.new: $_}).list
	}
}

class LLVM::Instruction is LLVM::Value is export {
	has LLVM::SuccessorsHelper $.successors;
	has LLVM::ClausesHelper $.clauses;
	has LLVM::HandlersHelper $.handlers;

	method new(LLVMValueRef $val) {
		self.bless:
			raw => $val,
			successors => LLVM::SuccessorsHelper.new(:$val),
			clauses => LLVM::ClausesHelper.new(:$val),
			handlers => LLVM::HandlersHelper.new(:$val)
	}

	multi method metadata(:$exists! where :so) {
		return LLVMHasMetadata($.raw).Bool
	}
	multi method metadata(Int $kind-id) is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                      {LLVM::Metadata.new: LLVMGetMetadata($raw, $kind-id)},
			STORE => method (LLVM::Metadata $md) {LLVMSetMetadata($raw, $kind-id, $md.Value.raw)}
		)
	}
	
	method call-conv is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                     {LLVM::CallConv(LLVMGetInstructionCallConv($raw))},
			STORE => method (LLVM::CallConv $c) {LLVMSetInstructionCallConv($raw, $c.Int)}
		)
	}
	
	method is-tail-call is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method           {LLVMIsTailCall($raw).Bool},
			STORE => method (Bool $e) {LLVMSetTailCall($raw, $e)}
		)
	}
	
	method normal-dest is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                        {LLVM::BasicBlock.new: LLVMGetNormalDest($raw)},
			STORE => method (LLVM::BasicBlock $bb) {LLVMSetNormalDest($raw, $bb.raw)}
		)
	}
	
	method unwind-dest is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                        {LLVM::BasicBlock.new: LLVMGetUnwindDest($raw)},
			STORE => method (LLVM::BasicBlock $bb) {LLVMSetUnwindDest($raw, $bb.raw)}
		)
	}
	
	method cond is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                    {LLVM::Value.new: LLVMGetCondition($raw)},
			STORE => method (LLVM::Value $val) {LLVMSetCondition($raw, $val.raw)}
		)
	}
	
	method is-inbounds is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method           {LLVMIsInBounds($raw).Bool},
			STORE => method (Bool $i) {LLVMSetIsInBounds($raw, $i)}
		)
	}
	
	method is-cleanup is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method           {LLVMIsCleanup($raw).Bool},
			STORE => method (Bool $c) {LLVMSetCleanup($raw, $c)}
		)
	}
	
	# funclets?
	#sub LLVMGetArgOperand(LLVMValueRef, size_t) returns LLVMValueRef
	#sub LLVMSetArgOperand(LLVMValueRef, size_t, LLVMValueRef)
	
	# takes/gets an instruction
	#sub LLVMGetParentCatchSwitch(LLVMValueRef) returns LLVMValueRef
	#sub LLVMSetParentCatchSwitch(LLVMValueRef, LLVMValueRef)
	
	method is-volatile is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method           {LLVMGetVolatile($raw).Bool},
			STORE => method (Bool $v) {LLVMSetVolatile($raw, $v)}
		)
	}
	
	method ordering is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                           {LLVM::AtomicOrdering(LLVMGetOrdering($raw))},
			STORE => method (LLVM::AtomicOrdering $o) {LLVMSetOrdering($raw, $o.Int)}
		)
	}
	
	method is-atomic-single-thread is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method           {LLVMIsAtomicSingleThread($raw).Bool},
			STORE => method (Bool $s) {LLVMSetAtomicSingleThread($raw, $s)}
		)
	}
	
	method success-ordering is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                           {LLVM::AtomicOrdering(LLVMGetCmpXchgSuccessOrdering($raw))},
			STORE => method (LLVM::AtomicOrdering $o) {LLVMSetCmpXchgSuccessOrdering($raw, $o.Int)}
		)
	}
	
	method failure-ordering is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                           {LLVM::AtomicOrdering(LLVMGetCmpXchgFailureOrdering($raw))},
			STORE => method (LLVM::AtomicOrdering $o) {LLVMSetCmpXchgFailureOrdering($raw, $o.Int)}
		)
	}
	
	method is-cond {return LLVMIsConditional($.raw).Bool}

	#sub LLVMInstructionGetAllMetadataOtherThanDebugLoc(LLVMValueRef, size_t is rw) returns CArray[LLVMValueMetadataEntry]
	
	method pred {
		return LLVM::Instruction.new: LLVMGetPreviousInstruction($.raw)
	}

	method succ {
		return LLVM::Instruction.new: LLVMGetNextInstruction($.raw)
	}

	method parent(:$remove, :$erase) {
		if $remove {
			LLVMInstructionRemoveFromParent($.raw)
		} elsif $erase {
			LLVMInstructionEraseFromParent($.raw)
		} else {
			return LLVM::BasicBlock.new: LLVMGetInstructionParent($.raw)
		}
	}
	
	method opcode {
		return LLVM::Opcode(LLVMGetInstructionOpcode($.raw))
	}

	method icmp-predicate {
		return LLVM::IntPredicate(LLVMGetICmpPredicate($.raw))
	}

	method fcmp-predicate {
		return LLVM::RealPredicate(LLVMGetFCmpPredicate($.raw))
	}
	
	method clone {
		return LLVM::Instruction.new: LLVMInstructionClone($.raw)
	}
	
	method num-ops {
		return LLVMGetNumArgOperands($.raw)
	}

	method param-align(Int $index, Int $align) {
		LLVMSetInstrParamAlignment($.raw, $index, $align)
	}
	
	method is-term {
		return LLVM::Value.new: LLVMIsATerminatorInst($.raw)
	}
	
	#= Attributes
	#sub LLVMAddCallSiteAttribute(LLVMValueRef, size_t, LLVMAttributeRef)
	#sub LLVMGetCallSiteAttributeCount(LLVMValueRef, size_t) returns size_t
	#sub LLVMGetCallSiteAttributes(LLVMValueRef, size_t, CArray[LLVMAttributeRef])
	#sub LLVMGetCallSiteEnumAttribute(LLVMValueRef, size_t, size_t) returns LLVMAttributeRef
	#sub LLVMGetCallSiteStringAttribute(LLVMValueRef, size_t, Str, size_t) returns LLVMAttributeRef
	#sub LLVMRemoveCallSiteEnumAttribute(LLVMValueRef, size_t, size_t)
	#sub LLVMRemoveCallSiteStringAttribute(LLVMValueRef, size_t, Str, size_t)
	
	method called-type {
		return LLVM::Type.new: LLVMGetCalledFunctionType($.raw)
	}

	method called-value {
		return LLVM::Value.new: LLVMGetCalledValue($.raw)
	}

	method alloc-type {
		return LLVM::Type.new: LLVMGetAllocatedType($.raw)
	}

	method default-dest {
		return LLVM::BasicBlock.new: LLVMGetSwitchDefaultDest($.raw)
	}

	#sub LLVMAddIncoming(LLVMValueRef, CArray[LLVMValueRef], CArray[LLVMBasicBlockRef], size_t)
	#sub LLVMCountIncoming(LLVMValueRef) returns size_t
	#sub LLVMGetIncomingValue(LLVMValueRef, size_t) returns LLVMValueRef
	#sub LLVMGetIncomingBlock(LLVMValueRef, size_t) returns LLVMBasicBlockRef
	
	method indices {
		return LLVMGetIndices($.raw).list
	}
	
	method add-case(LLVM::Value $val, LLVM::BasicBlock $bb) {
		LLVMAddCase($.raw, $val.raw, $bb.raw)
	}

	method add-dest(LLVM::BasicBlock $dest) {
		LLVMAddDestination($.raw, $dest.raw)
	}
}
