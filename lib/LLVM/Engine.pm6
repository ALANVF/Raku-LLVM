class LLVM::Engine is export {
	has LLVMExecutionEngineRef $.raw;
	
	method link-mc-jit(::?CLASS:U:) {
		LLVMLinkInMCJIT
	}

	method link-interp(::?CLASS:U:) {
		LLVMLinkInInterpreter
	}
	
	multi method new(::?CLASS:U: LLVMExecutionEngineRef $ee) {
		self.bless: raw => $ee
	}
	multi method new(::?CLASS:U: LLVM::Module $mod) {
		if LLVMCreateExecutionEngineForModule(my LLVMExecutionEngineRef $ee .= new, $mod.raw, my Str $err) == 0 {
			self.bless: raw => $ee
		} else {
			$_ = $err;
			LLVMDisposeMessage($err);
			die "Internal LLVM Error: $_"
		}
	}
	
	method interp(::?CLASS:U: LLVM::Module $mod) {
		if LLVMCreateInterpreterForModule(my LLVMExecutionEngineRef $ee .= new, $mod.raw, my Str $err) == 0 {
			self.bless: raw => $ee
		} else {
			$_ = $err;
			LLVMDisposeMessage($err);
			die "Internal LLVM Error: $_"
		}
	}
	
	method jit(::?CLASS:U: LLVM::Module $mod, Int $opt-level = 0) {
		if LLVMCreateJITCompilerForModule(my LLVMExecutionEngineRef $ee .= new, $mod.raw, $opt-level, my Str $err) == 0 {
			self.bless: raw => $ee
		} else {
			$_ = $err;
			LLVMDisposeMessage($err);
			die "Internal LLVM Error: $_"
		}
	}
	
	# what do do with the options object? do I init it before or after initing the mcjit?
	#sub LLVMCreateMCJITCompilerForModule(LLVMExecutionEngineRef is rw, LLVMModuleRef, LLVMMCJITCompilerOptions is rw, size_t, Str is rw) returns int32
	#method mcjit(::?CLASS:U: LLVM::Module $mod, $) {
		# do something with LLVMInitializeMCJITCompilerOptions?
	#	if LLVMCreateMCJITCompilerForModule(my LLVMExecutionEngineRef $ee, $mod.raw, $, $.size, my Str $err) == 0 {
	#		self.bless: raw => $ee
	#	} else {
	#		die "Internal LLVM Error: $err"
	#	}
	#}
	
	#sub LLVMGetExecutionEngineTargetData(LLVMExecutionEngineRef) returns LLVMTargetDataRef
	#sub LLVMGetExecutionEngineTargetMachine(LLVMExecutionEngineRef) returns LLVMTargetMachineRef
	
	method dispose {
		LLVMDisposeExecutionEngine($!raw)
	}
	
	method run-static-constr {
		LLVMRunStaticConstructors($!raw)
	}
	
	method run-static-destr {
		LLVMRunStaticDestructors($!raw)
	}

	method run-func-as-main(LLVM::Function $fn, @argv where {.all ~~ Str}, @env where {.all ~~ Str}) {
		return LLVMRunFunctionAsMain($!raw, $fn.raw, @argv.elems, CArray[Str].new(@argv), CArray[Str].new(@env))
	}
	
	method run-func(LLVM::Function $fn, @args where {.all ~~ LLVM::Generic}) {
		my $args = CArray[LLVMGenericValueRef].new(@args>>.raw);
		return LLVM::Generic.new: LLVMRunFunction($!raw, $fn.raw, @args.elems, $args)
	}

	method free-mc-for-func(LLVM::Function $fn) {
		LLVMFreeMachineCodeForFunction($!raw, $fn.raw)
	}

	method add-module(LLVM::Module $mod) {
		LLVMAddModule($!raw, $mod.raw)
	}

	method remove-module(LLVM::Module $mod) {
		if LLVMRemoveModule($!raw, $mod.raw, my LLVMModuleRef $, my Str $err) == 1 {
			$_ = $err;
			LLVMDisposeMessage($err);
			die "Internal LLVM Error: $_"
		}
	}

	method func(Str $name, :$exists) {
		if LLVMFindFunction($!raw, $name, my LLVMValueRef $val) == 0 {
			return $exists ?? True !! LLVM::Function.new: $val
		} elsif $exists {
			return False
		} else {
			die "LLVM Error: function `$name` does not exist!"
		}
	}
	
	method recompile-relink-func(LLVM::Function $fn) {
		my $ptr = LLVMRecompileAndRelinkFunction($!raw, $fn.raw);
		return blob-from-pointer $ptr, elems => nativesizeof($ptr) div nativesizeof(uint8), type => Blob[uint8]
	}
	
	method add-global-mapping(LLVM::Value $global, Blob $addr) {
		LLVMAddGlobalMapping($!raw, $global.raw, nativecast(Pointer[void], $addr))
	}
	
	method get-global-ptr(LLVM::Value $global) {
		my $ptr = LLVMGetPointerToGlobal($!raw, $global.raw);
		return blob-from-pointer $ptr, elems => nativesizeof($ptr) div nativesizeof(uint8), type => Blob[uint8]
	}
	
	method global-val-addr(Str $name) {
		return LLVMGetGlobalValueAddress($!raw, $name)
	}

	method func-addr(Str $name) {
		return LLVMGetFunctionAddress($!raw, $name)
	}
}
