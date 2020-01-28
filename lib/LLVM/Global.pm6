class LLVM::GlobalMetadataHelper {
	has LLVMValueRef $.val;
	
	submethod AT-POS(Int $index) {
		return self.entries[$index]
	}

	submethod ASSIGN-POS(Int $index, LLVM::Metadata $md) {
		LLVMGlobalSetMetadata($!val, $index, $md.raw)
	}

	submethod DELETE-POS(Int $index) {
		LLVMGlobalEraseMetadata($!val, $index)
	}

	method clear {
		LLVMGlobalClearMetadata($!val)
	}

	method entries {
		return LLVM::ValueMetadataEntries.new: LLVMGlobalCopyAllMetadata($!val, my size_t $).list.map: {LLVM::ValueMetadataEntry.new: $_}
	}
}

class LLVM::Global is LLVM::Value is export {
	method value-type {
		return LLVM::Type.new: LLVMGlobalGetValueType($.raw)
	}
}

class LLVM::GlobalVar is LLVM::Global is export {
	has LLVM::GlobalMetadataHelper $.metadata;

	method new(LLVMValueRef $val) {
		self.bless: raw => $val, metadata => LLVM::GlobalMetadataHelper.new(:$val)
	}

	method init is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                  {LLVM::Value.new: LLVMGetInitializer($raw)},
			STORE => method (LLVM::Value $v) {LLVMSetInitializer($raw, $v.raw)}
		)
	}
	
	method is-thread-local is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method           {LLVMIsThreadLocal($raw).Bool},
			STORE => method (Bool $l) {LLVMSetThreadLocal($raw, $l)}
		)
	}

	method is-global-constant is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method           {LLVMIsGlobalConstant($raw).Bool},
			STORE => method (Bool $c) {LLVMSetGlobalConstant($raw, $c)}
		)
	}
	
	method thread-local-mode is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                            {LLVM::ThreadLocalMode(LLVMGetThreadLocalMode($raw))},
			STORE => method (LLVM::ThreadLocalMode $m) {LLVMSetThreadLocalMode($raw, $m.Int)}
		)
	}
	
	method is-extern-init is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method           {LLVMIsExternallyInitialized($raw).Bool},
			STORE => method (Bool $e) {LLVMSetExternallyInitialized($raw, $e)}
		)
	}
	
	method pred {
		return LLVM::GlobalVar.new: LLVMGetPreviousGlobal($.raw)
	}

	method succ {
		return LLVM::GlobalVar.new: LLVMGetNextGlobal($.raw)
	}
	
	method delete {
		LLVMDeleteGlobal($.raw)
	}
}

class LLVM::GlobalAlias is LLVM::Global is export {
	method aliasee is rw {
		my $raw = $.raw;
		Proxy.new(
			FETCH => method                  {LLVM::Value.new: LLVMAliasGetAliasee($raw)},
			STORE => method (LLVM::Value $v) {LLVMAliasSetAliasee($raw, $v.raw)}
		)
	}
	
	method pred {
		return LLVM::GlobalAlias.new: LLVMGetPreviousGlobalAlias($.raw)
	}

	method succ {
		return LLVM::GlobalAlias.new: LLVMGetNextGlobalAlias($.raw)
	}
}
