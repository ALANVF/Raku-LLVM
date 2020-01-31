class LLVM::FunctionsHelper {
	has LLVMModuleRef $.mod;
	
	submethod AT-KEY(Str $name) {
		return LLVM::Function.new: LLVMGetNamedFunction($!mod, $name)
	}
	
	submethod ASSIGN-KEY(Str $name, LLVM::Type $fn) {
		return LLVM::Function.new: LLVMAddFunction($!mod, $name, $fn.raw)
	}

	method head {
		return LLVM::Function.new: LLVMGetFirstFunction($!mod)
	}

	method tail {
		return LLVM::Function.new: LLVMGetLastFunction($!mod)
	}
}

class LLVM::GlobalsHelper {
	has LLVMModuleRef $.mod;

	submethod AT-KEY(Str $name) {
		return LLVM::GlobalVar.new: LLVMGetNamedGlobal($!mod, $name)
	}
	#sub LLVMAddGlobalInAddressSpace(LLVMModuleRef, LLVMTypeRef, Str, size_t) returns LLVMValueRef

	submethod ASSIGN-KEY(Str $name, LLVM::Type $type) {
		return LLVM::GlobalVar.new: LLVMAddGlobal($!mod, $type.raw, $name)
	}

	method head {
		return LLVM::GlobalVar.new: LLVMGetFirstGlobal($!mod)
	}

	method tail {
		return LLVM::GlobalVar.new: LLVMGetLastGlobal($!mod)
	}
}

class LLVM::Module is export {
	has LLVMModuleRef $.raw;
	has LLVM::FunctionsHelper $.funcs;
	has LLVM::GlobalsHelper $.globals;

	multi method new(LLVMModuleRef $mod) {
		self.bless:
			raw => $mod,
			funcs => LLVM::FunctionsHelper.new(:$mod),
			globals => LLVM::GlobalsHelper.new(:$mod)
	}
	multi method new(Str $name) {
		self.bless:
			raw => ($_ = LLVMModuleCreateWithName($name)),
			funcs => LLVM::FunctionsHelper.new(mod => $_),
			globals => LLVM::GlobalsHelper.new(mod => $_)
	}
	multi method new(Str $name, LLVM::Context $ctx) {
		self.bless:
			raw => ($_ = LLVMModuleCreateWithNameInContext($name, $ctx.raw)),
			funcs => LLVM::FunctionsHelper.new(mod => $_),
			globals => LLVM::GlobalsHelper.new(mod => $_)
	}

	method clone {
		return LLVM::Module.new: LLVMCloneModule($!raw)
	}

	method dispose {
		LLVMDisposeModule($!raw)
	}

	method verify(LLVM::VerifierFailureAction $action) {
		if LLVMVerifyModule($!raw, $action.Int, my Str $err) == 1 {
			$_ = $err;
			LLVMDisposeMessage($err);
			die "Internal LLVM Error: $_"
		}
	}
	
	method identifier is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method           {LLVMGetModuleIdentifier($raw, my size_t $)},
			STORE => method (Str $id) {LLVMSetModuleIdentifier($raw, $id, $id.chars)}
		)
	}

	method source-file-name is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method             {LLVMGetSourceFileName($raw, my size_t $)},
			STORE => method (Str $name) {LLVMSetSourceFileName($raw, $name, $name.chars)}
		)
	}
	
	method data-layout is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method           {LLVMGetDataLayoutStr($raw)},
			STORE => method (Str $dl) {LLVMSetDataLayout($raw, $dl)}
		)
	}

	method target is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method          {LLVMGetTarget($raw)},
			STORE => method (Str $t) {LLVMSetTarget($raw, $t)}
		)
	}

=begin todo
	method target-data is rw {
		Proxy.new(
			FETCH => method                        {LLVM::TargetData.new: LVMGetModuleDataLayout($!raw)},
			STORE => method (LLVM::TargetData $td) {LLVMSetModuleDataLayout($!raw, $td.raw)}
		)
	}
=end todo

	#sub LLVMAppendModuleInlineAsm(LLVMModuleRef, Str, size_t) # figure this out
	method inline-asm is rw {
		my $raw = $!raw;
		Proxy.new(
			FETCH => method            {LLVMGetModuleInlineAsm($raw, my size_t $)},
			STORE => method (Str $asm) {LLVMSetModuleInlineAsm2($raw, $asm, $asm.chars)}
		)
	}

	method context {
		return LLVM::Context.new: LLVMGetModuleContext($!raw)
	}

	#sub LLVMCopyModuleFlagsMetadata(LLVMModuleRef, size_t is rw)         returns CArray[int32]
	#sub LLVMGetModuleFlag(LLVMModuleRef, Str, size_t)                         returns LLVMMetadataRef
	#sub LLVMAddModuleFlag(LLVMModuleRef, int32, Str, size_t, LLVMMetadataRef)
	
	method dump {
		LLVMDumpModule($!raw)
	}
	
	#sub LLVMWriteBitcodeToMemoryBuffer(LLVMModuleRef)            returns LLVMMemoryBufferRef
	multi method write-bitcode(Str $file) {
		if LLVMWriteBitcodeToFile($!raw, $file) == 1 {
			die "LLVM error: error writing to file \"$file\""
		}
	}
	multi method write-bitcode(IO::Handle $io, :$unbuffered, :$close) {
		if LLVMWriteBitcodeToFD($!raw, $io.native-descriptor, so $close, so $unbuffered) == 1 {
			die "Internal LLVM error: failed to write to file handle $io"
		}
	}

	method spurt(Str $file) {
		if LLVMPrintModuleToFile($!raw, $file, my Str $err) == 1 {
			$_ = $err;
			LLVMDisposeMessage($err);
			die "Internal LLVM Error: $_"
		}
	}
	
	method Str {
		return LLVMPrintModuleToString($!raw)
	}
	
	method type(Str $name) {
		return LLVM::Type.new: LLVMGetTypeByName($!raw, $name)
	}

	#sub LLVMGetFirstNamedMetadata(LLVMModuleRef)                             returns LLVMNamedMDNodeRef
	#sub LLVMGetLastNamedMetadata(LLVMModuleRef)                              returns LLVMNamedMDNodeRef
	#sub LLVMGetNamedMetadata(LLVMModuleRef, Str, size_t)                     returns LLVMNamedMDNodeRef
	#sub LLVMGetOrInsertNamedMetadata(LLVMModuleRef, Str, size_t)             returns LLVMNamedMDNodeRef
	#sub LLVMGetNamedMetadataNumOperands(LLVMModuleRef, Str)                  returns size_t
	#sub LLVMGetNamedMetadataOperands(LLVMModuleRef, Str, LLVMValueRef is rw)
	#sub LLVMAddNamedMetadataOperand(LLVMModuleRef, Str, LLVMValueRef)
	
	#sub LLVMAddAlias(LLVMModuleRef, LLVMTypeRef, LLVMValueRef, Str) returns LLVMValueRef
	#sub LLVMGetNamedGlobalAlias(LLVMModuleRef, Str, size_t)         returns LLVMValueRef
	#sub LLVMGetFirstGlobalAlias(LLVMModuleRef)                      returns LLVMValueRef
	#sub LLVMGetLastGlobalAlias(LLVMModuleRef)                       returns LLVMValueRef
	
	#sub LLVMAddGlobalIFunc(LLVMModuleRef, Str, size_t, LLVMTypeRef, size_t, LLVMValueRef) returns LLVMValueRef
	#sub LLVMGetNamedGlobalIFunc(LLVMModuleRef, Str, size_t)                               returns LLVMValueRef
	#sub LLVMGetFirstGlobalIFunc(LLVMModuleRef)                                            returns LLVMValueRef
	#sub LLVMGetLastGlobalIFunc(LLVMModuleRef)                                             returns LLVMValueRef
	
	multi method intrinsic(Int $id, @params where {.all ~~ LLVM::Type}) {
		return LLVM::Intrinsic.new: LLVMGetIntrinsicDeclaration($!raw, $id, CArray[LLVMTypeRef].new(@params>>.raw), @params.elems)
	}
	multi method intrinsic(Str $name, @params where {.all ~~ LLVM::Type}) {
		return LLVM::Intrinsic.new: LLVMGetIntrinsicDeclaration($!raw, LLVMLookupIntrinsicID($name, $name.chars), CArray[LLVMTypeRef].new(@params>>.raw), @params.elems)
	}
	
	#sub LLVMCreateModuleProviderForExistingModule(LLVMModuleRef) returns LLVMModuleProviderRef
	#sub LLVMCreateFunctionPassManagerForModule(LLVMModuleRef)        returns LLVMPassManagerRef
}
