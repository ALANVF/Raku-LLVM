class LLVM::Param is LLVM::Value is export {
	method parent {
		return LLVM::Function.new: LLVMGetParamParent($.raw)
	}
	
	method param-align(Int $align) {
		LLVMSetParamAlignment($.raw, $align)
	}
	
	method pred {
		return LLVM::Param.new: LLVMGetPreviousParam($.raw)
	}

	method succ {
		return LLVM::Param.new: LLVMGetNextParam($.raw)
	}
}

class LLVM::ParamsHelper {
	has LLVMValueRef $.fn;
	
	method elems {
		return LLVMCountParams($!fn)
	}

	method list {
		my $params = CArray[LLVMValueRef].allocate: LLVMCountParams($!fn);
		LLVMGetParams($!fn, $params);
		return $params.list.map({LLVM::Param.new: $_}).list
	}

	submethod AT-POS(Int $index) {
		return LLVM::Param.new: LLVMGetParam($!fn, $index)
	}

	method head {
		return LLVM::Param.new: LLVMGetFirstParam($!fn)
	}

	method tail {
		return LLVM::Param.new: LLVMGetLastParam($!fn)
	}
}

class LLVM::BasicBlocksHelper {
	has LLVMValueRef $.fn;

	submethod AT-KEY(Str $name) {
		return self.list.first: *.name eq $name
	}

	method elems {
		return LLVMCountBasicBlocks($!fn)
	}

	method list {
		my $blocks = CArray[LLVMBasicBlockRef].allocate: LLVMCountBasicBlocks($!fn);
		LLVMGetBasicBlocks($!fn, $blocks);
		return $blocks.list.map({LLVM::BasicBlock.new: $_}).list
	}

	method head {
		return LLVM::BasicBlock.new: LLVMGetFirstBasicBlock($!fn)
	}

	method tail {
		return LLVM::BasicBlock.new: LLVMGetLastBasicBlock($!fn)
	}

	method entry {
		return LLVM::BasicBlock.new: LLVMGetEntryBasicBlock($!fn)
	}

	multi method push(LLVM::BasicBlock $bb) {
		LLVMAppendExistingBasicBlock($!fn, $bb.raw);
		return $bb
	}

	multi method push(Str $name) {
		return LLVM::BasicBlock.new: LLVMAppendBasicBlock($!fn, $name)
	}
}

class LLVM::Function is LLVM::Global is export {
	has LLVM::ParamsHelper $.params;
	has LLVM::BasicBlocksHelper $.blocks;

	method new(LLVMValueRef $val) {
		self.bless:
			raw => $val,
			params => LLVM::ParamsHelper.new(fn => $val),
			blocks => LLVM::BasicBlocksHelper.new(fn => $val)
	}
	
	multi method personality-fn(:$exists! where :so) {
		return LLVMHasPersonalityFn($.raw).Bool
	}
	multi method personality-fn is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                     {LLVM::Function.new: LLVMGetPersonalityFn($raw)},
			STORE => method (LLVM::Function $p) {LLVMSetPersonalityFn($raw, $p.raw)}
		)
	}
	
	method call-conv is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                     {LLVM::CallConv(LLVMGetFunctionCallConv($raw))},
			STORE => method (LLVM::CallConv $c) {LLVMSetFunctionCallConv($raw, $c.Int)}
		)
	}

	method gc is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method          {LLVMGetGC($raw)},
			STORE => method (Str $n) {LLVMSetGC($raw, $n)}
		)
	}

	method intrinsic-id {
		return LLVMGetIntrinsicID($.raw)
	}

	method is-decl {
		return LLVMIsDeclaration($.raw).Bool
	}
	
	#= Attributes
	# make helper types for these later
	method add-attr(LLVM::Attribute $attr, :$ret, Int :$param) {
		with $ret {
			LLVMAddAttributeAtIndex($.raw, 0, $attr.raw)
		} orwith $param {
			LLVMAddAttributeAtIndex($.raw, $param + 1, $attr.raw)
		} else {
			LLVMAddAttributeAtIndex($.raw, -1, $attr.raw)
		}
	}
	#
	#method remove-attr()
	#method remove-param-attr()
	#method remove-ret-attr()
	#
	#method get-attr()
	#method get-param-attr()
	#method get-ret-attr()
	#
	#method get-attrs()
	#method get-param-attrs()
	#method get-ret-attrs()
	
	#sub LLVMGetAttributeCountAtIndex(LLVMValueRef, size_t) returns size_t
	#sub LLVMGetAttributesAtIndex(LLVMValueRef, size_t, CArray[LLVMAttributeRef])
	#sub LLVMGetEnumAttributeAtIndex(LLVMValueRef, size_t, size_t) returns LLVMAttributeRef
	#sub LLVMGetStringAttributeAtIndex(LLVMValueRef, size_t, Str, size_t) returns LLVMAttributeRef
	#sub LLVMRemoveEnumAttributeAtIndex(LLVMValueRef, size_t, size_t)
	#sub LLVMRemoveStringAttributeAtIndex(LLVMValueRef, size_t, Str, size_t)

	#= Misc
	method delete {
		LLVMDeleteFunction($.raw)
	}

	method pred {
		return LLVM::Function.new: LLVMGetPreviousFunction($.raw)
	}

	method succ {
		return LLVM::Function.new: LLVMGetNextFunction($.raw)
	}
}
