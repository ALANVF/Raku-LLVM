# WARNING: large file!
# raku doesn't allow stubs to be used in other files so I have to include everything here :(

use NativeCall;
use NativeHelpers::Blob;
use LLVMC;

#| Predefine classes

class LLVM::Value is export {...}
class LLVM::Attribute is export {...}
class LLVM::BasicBlock is export {...}
class LLVM::Builder is export {...}
class LLVM::Context is export {...}
class LLVM::Engine is export {...}
class LLVM::Global is export {...}
class LLVM::Function is export {...}
class LLVM::Generic is export {...}
class LLVM::Instruction is export {...}
class LLVM::Intrinsic is export {...}
class LLVM::Metadata is export {...}
class LLVM::Module is export {...}
class LLVM::Type is export {...}



#| Enums

enum LLVM::Opcode is export (
	Ret             => 1,
	Br              => 2,
	Switch          => 3,
	Indirect-br     => 4,
	Invoke          => 5,

	Unreachable     => 7,
	Call-br         => 67,

	FNeg            => 66,

	IAdd            => 8,
	FAdd            => 9,
	ISub            => 10, # because Sub is already a pretty important name
	FSub            => 11,
	IMul            => 12,
	FMul            => 13,
	UDiv            => 14,
	SDiv            => 15,
	FDiv            => 16,
	URem            => 17,
	SRem            => 18,
	FRem            => 19,

	Shl             => 20,
	LShr            => 21,
	AShr            => 22,
	And             => 23,
	Or              => 24,
	Xor             => 25,

	Alloca          => 26,
	Load            => 27,
	Store           => 28,
	GEP             => 29,

	Trunc           => 30,
	ZExt            => 31,
	SExt            => 32,
	FP-to-UI        => 33,
	FP-to-SI        => 34,
	UI-to-FP        => 35,
	SI-to-FP        => 36,
	FP-trunc        => 37,
	FP-ext          => 38,
	Ptr-to-int      => 39,
	Int-to-ptr      => 40,
	Bit-cast        => 41,
	Addr-space-cast => 60,

	ICmp            => 42,
	FCmp            => 43,
	PHI             => 44,
	Call            => 45,
	Select          => 46,
	User-op1        => 47,
	User-op2        => 48,
	VAArg           => 49,
	Extract-element => 50,
	Insert-element  => 51,
	Shuffle-vector  => 52,
	Extract-value   => 53,
	Insert-value    => 54,

	Fence           => 55,
	Atomic-cmp-xchg => 56,
	Atomic-rmw      => 57,

	Resume          => 58,
	Landing-pad     => 59,
	Cleanup-ret     => 61,
	Catch-ret       => 62,
	Catch-pad       => 63,
	Cleanup-pad     => 64,
	Catch-switch    => 65
);

enum LLVM::IntPredicate is export (
	IntEQ  => 32,
	IntNE  => 33,
	IntUGT => 34,
	IntUGE => 35,
	IntULT => 36,
	IntULE => 37,
	IntSGT => 38,
	IntSGE => 39,
	IntSLT => 40,
	IntSLE => 41
);

enum LLVM::RealPredicate is export (
	RealPredicateFalse => 0,
	RealOEQ            => 1,
	RealOGT            => 2,
	RealOGE            => 3,
	RealOLT            => 4,
	RealOLE            => 5,
	RealONE            => 6,
	RealORD            => 7,
	RealUNO            => 8,
	RealUEQ            => 9,
	RealUGT            => 10,
	RealUGE            => 11,
	RealULT            => 12,
	RealULE            => 13,
	RealUNE            => 14,
	RealPredicateTrue  => 15
);

enum LLVM::AtomicOrdering is export (
	AtomicOrderingNotAtomic              => 0,
	AtomicOrderingUnordered              => 1,
	AtomicOrderingMonotonic              => 2,
	AtomicOrderingAcquire                => 4,
	AtomicOrderingRelease                => 5,
	AtomicOrderingAcquireRelease         => 6,
	AtomicOrderingSequentiallyConsistent => 7
);

enum LLVM::AtomicRMWBinOp is export (
	AtomicRMWBinOpXchg => 0,
	AtomicRMWBinOpAdd  => 1,
	AtomicRMWBinOpSub  => 2,
	AtomicRMWBinOpAnd  => 3,
	AtomicRMWBinOpNand => 4,
	AtomicRMWBinOpOr   => 5,
	AtomicRMWBinOpXor  => 6,
	AtomicRMWBinOpMax  => 7,
	AtomicRMWBinOpMin  => 8,
	AtomicRMWBinOpUMax => 9,
	AtomicRMWBinOpUMin => 10
);

enum LLVM::CallConv is export (
	CCallConv             => 0,
	FastCallConv          => 8,
	ColdCallConv          => 9,
	GHCCallConv           => 10,
	HiPECallConv          => 11,
	WebKitJSCallConv      => 12,
	AnyRegCallConv        => 13,
	PreserveMostCallConv  => 14,
	PreserveAllCallConv   => 15,
	SwiftCallConv         => 16,
	CXXFASTTLSCallConv    => 17,
	X86StdcallCallConv    => 64,
	X86FastcallCallConv   => 65,
	ARMAPCSCallConv       => 66,
	ARMAAPCSCallConv      => 67,
	ARMAAPCSVFPCallConv   => 68,
	MSP430INTRCallConv    => 69,
	X86ThisCallCallConv   => 70,
	PTXKernelCallConv     => 71,
	PTXDeviceCallConv     => 72,
	SPIRFUNCCallConv      => 75,
	SPIRKERNELCallConv    => 76,
	IntelOCLBICallConv    => 77,
	X8664SysVCallConv     => 78,
	Win64CallConv         => 79,
	X86VectorCallCallConv => 80,
	HHVMCallConv          => 81,
	HHVMCCallConv         => 82,
	X86INTRCallConv       => 83,
	AVRINTRCallConv       => 84,
	AVRSIGNALCallConv     => 85,
	AVRBUILTINCallConv    => 86,
	AMDGPUVSCallConv      => 87,
	AMDGPUGSCallConv      => 88,
	AMDGPUPSCallConv      => 89,
	AMDGPUCSCallConv      => 90,
	AMDGPUKERNELCallConv  => 91,
	X86RegCallCallConv    => 92,
	AMDGPUHSCallConv      => 93,
	MSP430BUILTINCallConv => 94,
	AMDGPULSCallConv      => 95,
	AMDGPUESCallConv      => 96
);

enum LLVM::ThreadLocalMode is export (
	NotThreadLocal         => 0,
	GeneralDynamicTLSModel => 1,
	LocalDynamicTLSModel   => 2,
	InitialExecTLSModel    => 3,
	LocalExecTLSModel      => 4
);

enum LLVM::VerifierFailureAction is export (
	Abort-process-action => 0,
	Print-message-action => 1,
	Return-status-action => 2
);

enum LLVM::TypeKind is export (
	VoidTypeKind      => 0,
	HalfTypeKind      => 1,
	FloatTypeKind     => 2,
	DoubleTypeKind    => 3,
	X86_FP80TypeKind  => 4,
	FP128TypeKind     => 5,
	PPC_FP128TypeKind => 6,
	LabelTypeKind     => 7,
	IntegerTypeKind   => 8,
	FunctionTypeKind  => 9,
	StructTypeKind    => 10,
	ArrayTypeKind     => 11,
	PointerTypeKind   => 12,
	VectorTypeKind    => 13,
	MetadataTypeKind  => 14,
	X86_MMXTypeKind   => 15,
	TokenTypeKind     => 16
);

enum LLVM::InlineAsmDialect is export (
	InlineAsmDialectATT   => 0,
	InlineAsmDialectIntel => 1
);

enum LLVM::ValueKind is export (
	ArgumentValueKind              => 0,
	BasicBlockValueKind            => 1,
	MemoryUseValueKind             => 2,
	MemoryDefValueKind             => 3,
	MemoryPhiValueKind             => 4,
	FunctionValueKind              => 5,
	GlobalAliasValueKind           => 6,
	GlobalIFuncValueKind           => 7,
	GlobalVariableValueKind        => 8,
	BlockAddressValueKind          => 9,
	ConstantExprValueKind          => 10,
	ConstantArrayValueKind         => 11,
	ConstantStructValueKind        => 12,
	ConstantVectorValueKind        => 13,
	UndefValueValueKind            => 14,
	ConstantAggregateZeroValueKind => 15,
	ConstantDataArrayValueKind     => 16,
	ConstantDataVectorValueKind    => 17,
	ConstantIntValueKind           => 18,
	ConstantFPValueKind            => 19,
	ConstantPointerNullValueKind   => 20,
	ConstantTokenNoneValueKind     => 21,
	MetadataAsValueValueKind       => 22,
	InlineAsmValueKind             => 23,
	InstructionValueKind           => 24
);

enum LLVM::Linkage is export (
	ExternalLinkage            => 0,
	AvailableExternallyLinkage => 1,
	LinkOnceAnyLinkage         => 2,
	LinkOnceODRLinkage         => 3,
	LinkOnceODRAutoHideLinkage => 4,
	WeakAnyLinkage             => 5,
	WeakODRLinkage             => 6,
	AppendingLinkage           => 7,
	InternalLinkage            => 8,
	PrivateLinkage             => 9,
	DLLImportLinkage           => 10,
	DLLExportLinkage           => 11,
	ExternalWeakLinkage        => 12,
	GhostLinkage               => 13,
	CommonLinkage              => 14,
	LinkerPrivateLinkage       => 15,
	LinkerPrivateWeakLinkage   => 16
);

enum LLVM::Visibility is export (
	DefaultVisibility   => 0,
	HiddenVisibility    => 1,
	ProtectedVisibility => 2
);

enum LLVM::UnnamedAddr is export (
	NoUnnamedAddr     => 0,
	LocalUnnamedAddr  => 1,
	GlobalUnnamedAddr => 2
);

enum LLVM::DLLStorageClass is export (
	DefaultStorageClass   => 0,
	DLLImportStorageClass => 1,
	DLLExportStorageClass => 2
);



#| Values

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
	method const-opcode {
		return LLVM::Opcode(LLVMGetConstOpcode($!raw))
	}

	method const-neg {
		return LLVM::Value.new: LLVMConstNeg($!raw)
	}

	method const-nsw-neg {
		return LLVM::Value.new: LLVMConstNSWNeg($!raw)
	}

	method const-nuw-neg {
		return LLVM::Value.new: LLVMConstNUWNeg($!raw)
	}

	method const-fneg {
		return LLVM::Value.new: LLVMConstFNeg($!raw)
	}

	method const-not {
		return LLVM::Value.new: LLVMConstNot($!raw)
	}

	method const-add(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstAdd($!raw, $value.raw)
	}

	method const-nsw-add(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstNSWAdd($!raw, $value.raw)
	}

	method const-nuw-add(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstNUWAdd($!raw, $value.raw)
	}

	method const-fadd(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstFAdd($!raw, $value.raw)
	}

	method const-sub(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstSub($!raw, $value.raw)
	}

	method const-nsw-sub(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstNSWSub($!raw, $value.raw)
	}

	method const-nuw-sub(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstNUWSub($!raw, $value.raw)
	}

	method const-fsub(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstFSub($!raw, $value.raw)
	}
	
	method const-mul(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstMul($!raw, $value.raw)
	}

	method const-nsw-mul(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstNSWMul($!raw, $value.raw)
	}

	method const-nuw-mul(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstNUWMul($!raw, $value.raw)
	}

	method const-fmul(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstFMul($!raw, $value.raw)
	}

	method const-udiv(LLVM::Value $value, :$exact) {
		if $exact {
			return LLVM::Value.new: LLVMConstExactUDiv($!raw, $value.raw)
		} else {
			return LLVM::Value.new: LLVMConstUDiv($!raw, $value.raw)
		}
	}

	method const-sdiv(LLVM::Value $value, :$exact) {
		if $exact {
			return LLVM::Value.new: LLVMConstExactSDiv($!raw, $value.raw)
		} else {
			return LLVM::Value.new: LLVMConstSDiv($!raw, $value.raw)
		}
	}

	method const-fdiv(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstFDiv($!raw, $value.raw)
	}
	
	method const-urem(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstURem($!raw, $value.raw)
	}

	method const-srem(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstSRem($!raw, $value.raw)
	}

	method const-frem(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstFRem($!raw, $value.raw)
	}

	method const-and(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstAnd($!raw, $value.raw)
	}

	method const-or(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstOr($!raw, $value.raw)
	}

	method const-xor(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstXor($!raw, $value.raw)
	}

	method const-shl(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstShl($!raw, $value.raw)
	}

	method const-lshr(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstLShr($!raw, $value.raw)
	}

	method const-ashr(LLVM::Value $value) {
		return LLVM::Value.new: LLVMConstAShr($!raw, $value.raw)
	}

	method const-icmp(LLVM::Value $with, LLVM::IntPredicate $cmp) {
		return LLVM::Value.new: LLVMConstICmp($cmp.Int, $!raw, $with.raw)
	}

	method const-fcmp(LLVM::Value $with, LLVM::RealPredicate $cmp) {
		return LLVM::Value.new: LLVMConstFCmp($cmp.Int, $!raw, $with.raw)
	}
	
	method const-gep(@indices where {.all ~~ LLVM::Value}) {
		return LLVM::Value.new: LLVMConstGEP($!raw, CArray[LLVMValueRef].new(@indices>>.raw), @indices.elems)
	}

	method const-inbounds-gep(@indices where {.all ~~ LLVM::Value}) {
		return LLVM::Value.new: LLVMConstInBoundsGEP($!raw, CArray[LLVMValueRef].new(@indices>>.raw), @indices.elems)
	}
	
	method const-trunc(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstTrunc($!raw, $type.raw)
	}

	method const-sext(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstSExt($!raw, $type.raw)
	}

	method const-zext(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstZExt($!raw, $type.raw)
	}

	method const-fp-trunc(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstFPTrunc($!raw, $type.raw)
	}

	method const-fp-ext(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstFPExt($!raw, $type.raw)
	}

	method const-ui-to-fp(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstUIToFP($!raw, $type.raw)
	}

	method const-si-to-fp(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstSIToFP($!raw, $type.raw)
	}

	method const-fp-to-ui(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstFPToUI($!raw, $type.raw)
	}

	method const-fp-to-si(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstFPToSI($!raw, $type.raw)
	}

	method const-ptr-to-int(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstPtrToInt($!raw, $type.raw)
	}

	method const-int-to-ptr(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstIntToPtr($!raw, $type.raw)
	}
	
	method const-bit-cast(LLVM::Type $type, :$zext, :$sext, :$trunc) {
		with $zext {
			return LLVM::Value.new: LLVMConstZExtOrBitCast($!raw, $type.raw)
		} orwith $sext {
			return LLVM::Value.new: LLVMConstSExtOrBitCast($!raw, $type.raw)
		} orwith $trunc {
			return LLVM::Value.new: LLVMConstTruncOrBitCast($!raw, $type.raw)
		} else {
			return LLVM::Value.new: LLVMConstBitCast($!raw, $type.raw)
		}
	}

	method const-addr-space-cast(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstAddrSpaceCast($!raw, $type.raw)
	}

	method const-ptr-cast(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstPointerCast($!raw, $type.raw)
	}

	method const-int-cast(LLVM::Type $type, :$signed = True) {
		return LLVM::Value.new: LLVMConstIntCast($!raw, $type.raw, so $signed)
	}

	method const-fp-cast(LLVM::Type $type) {
		return LLVM::Value.new: LLVMConstFPCast($!raw, $type.raw)
	}

	method const-select(LLVM::Value $true, LLVM::Value $false) {
		return LLVM::Value.new: LLVMConstSelect($!raw, $true.raw, $false.raw)
	}
	
	method const-extract-elem(LLVM::Value $index) {
		return LLVM::Value.new: LLVMConstExtractElement($!raw, $index.raw)
	}

	method const-insert-elem(LLVM::Value $value, LLVM::Value $index) {
		return LLVM::Value.new: LLVMConstInsertElement($!raw, $value.raw, $index.raw)
	}

	method const-shuffle-vec(LLVM::Value $vec, LLVM::Value $mask) {
		return LLVM::Value.new: LLVMConstShuffleVector($!raw, $vec.raw, $mask.raw)
	}

	method const-extract-val(@indices where {.all ~~ Int}) {
		return LLVM::Value.new: LLVMConstExtractValue($!raw, CArray[size_t].new(@indices), @indices.elems)
	}

	method const-insert-val(LLVM::Value $value, @indices where {.all ~~ Int}) {
		return LLVM::Value.new: LLVMConstExtractValue($!raw, $value.raw, CArray[size_t].new(@indices), @indices.elems)
	}
	
	# move this to LLVM::Function
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



#| Attributes

class LLVM::Attribute is export {
	has LLVMAttributeRef $.raw;

	method new(LLVMAttributeRef $attr) {
		self.bless: raw => $attr
	}

	multi method enum(::?CLASS:U: Str $enum, Int $value = 0, LLVM::Context $ctx = LLVM::Context.global) {
		my $kind = LLVMGetEnumAttributeKindForName($enum, $enum.chars);
		self.bless: raw => LLVMCreateEnumAttribute($ctx.raw, $kind, $value)
	}
	multi method enum(::?CLASS:U: Int $kind, Int $value = 0, LLVM::Context $ctx = LLVM::Context.global) {
		self.bless: raw => LLVMCreateEnumAttribute($ctx.raw, $kind, $value)
	}
	method string(::?CLASS:U: Str $kind, Str $value = "", LLVM::Context $ctx = LLVM::Context.global) {
		self.bless: raw => LLVMCreateStringAttribute($ctx.raw, $kind, $kind.chars, $value, $value.chars)
	}

	method is-enum   {return LLVMIsEnumAttribute($!raw).Bool}
	method is-string {return LLVMIsStringAttribute($!raw).Bool}

	method kind {
		if self.is-enum {
			return LLVMGetEnumAttributeKind($!raw)
		} else {
			return LLVMGetStringAttributeKind($!raw, my size_t $)
		}
	}
	
	method value {
		if self.is-enum {
			return LLVMGetEnumAttributeValue($!raw)
		} else {
			return LLVMGetStringAttributeValue($!raw, my size_t $)
		}
	}
}



#| Basic blocks

class LLVM::BasicBlock is export {
	has LLVMBasicBlockRef $.raw;

	method new(LLVMBasicBlockRef $bb) {
		self.bless: raw => $bb
	}

	method name {
		return LLVMGetBasicBlockName($!raw)
	}

	method parent(:$remove) {
		if $remove {
			LLVMRemoveBasicBlockFromParent($!raw)
		} else {
			return LLVM::Function.new: LLVMGetBasicBlockParent($!raw)
		}
	}

	method terminator {
		return LLVM::Instruction.new: LLVMGetBasicBlockTerminator($!raw)
	}

	method pred {
		return LLVM::BasicBlock.new: LLVMGetPreviousBasicBlock($!raw)
	}

	method succ {
		return LLVM::BasicBlock.new: LLVMGetNextBasicBlock($!raw)
	}

	method insert(Str $name) {
		return LLVM::BasicBlock.new: LLVMInsertBasicBlock($!raw, $name)
	}

	method delete {
		LLVMDeleteBasicBlock($!raw)
	}

	method move-before(LLVM::BasicBlock $bb) {
		LLVMMoveBasicBlockBefore($!raw, $bb.raw)
	}

	method move-after(LLVM::BasicBlock $bb) {
		LLVMMoveBasicBlockAfter($!raw, $bb.raw)
	}

	method head {
		return LLVM::Instruction.new: LLVMGetFirstInstruction($!raw)
	}

	method tail {
		return LLVM::Instruction.new: LLVMGetLastInstruction($!raw)
	}

	method Value {
		return LLVM::Value.new: LLVMBasicBlockAsValue($!raw)
	}
}

#| Builders

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
	#sub LLVMClearInsertionPosition(LLVMBuilderRef)
	#sub LLVMInsertIntoBuilder(LLVMBuilderRef, LLVMValueRef)
	#sub LLVMInsertIntoBuilderWithName(LLVMBuilderRef, LLVMValueRef, Str)
	
	method current-block {
		return LLVM::BasicBlock.new: LLVMGetInsertBlock($!raw)
	}
	
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

	#= Helper methods
	method current-func {
		return self.current-block.parent
	}

	#= Experimental methods
	method if(LLVM::Value $cond, &true, &false?) {
		with &false {
			my $true = self.current-func.blocks.push("");
			my $false = self.current-func.blocks.push("");
			my $end = self.current-func.blocks.push("");

			$true.move-after(self.current-block);

			self.br: $cond, $true, $false;

			# true block
			self.move-to-end($true);
			
			true self;

			unless $true.tail.is-term {
				self.br: $end;
			}

			# false block
			self.move-to-end($false);

			false self;

			unless $false.tail.is-term {
				self.br: $end
			}

			self.move-to-end($end);
		} else {
			my $true = self.current-func.blocks.push("");
			my $end = self.current-func.blocks.push("");

			$true.move-after(self.current-block);
			
			self.br: $cond, $true, $end;

			# true block
			self.move-to-end($true);
			
			true self;

			
			unless $true.tail.is-term {
				self.br: $end
			}

			self.move-to-end($end);
		}
	}
}

#| Contexts

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

	multi method intrinsic(Int $id, @params where {.all ~~ LLVM::Type}) {
		return LLVM::Type.new: LLVMIntrinsicGetType($!raw, $id, CArray[LLVMTypeRef].new(@params>>.raw), @params.elems)
	}
	multi method intrinsic(Str $name, @params where {.all ~~ LLVM::Type}) {
		return LLVM::Type.new: LLVMIntrinsicGetType($!raw, LLVMLookupIntrinsicID($name, $name.chars), CArray[LLVMTypeRef].new(@params>>.raw), @params.elems)
	}

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



#| Engines

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



#| Globals

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


#| Generics

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



#| Functions

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

	# should be in LLVM::Intrinsic?
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



#| Instructions

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
		return so LLVMIsATerminatorInst($.raw)
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



#| Intrinsics

class LLVM::Intrinsic is LLVM::Instruction is export {
	multi method id(::?CLASS:U: Str $name) {
		return LLVMLookupIntrinsicID($name, $name.chars)
	}

	multi method name(::?CLASS:U: Int $id) {
		return LLVMIntrinsicGetName($id, my size_t $)
	}

	multi method name(::?CLASS:U: Int $id, @types where {.all ~~ LLVM::Type}) {
		my $_name = LLVMIntrinsicCopyOverloadedName($id, CArray[LLVMTypeRef].new(@types>>.raw), @types.elems, my size_t $);
		my $name = $_name.clone;
		LLVMDisposeMessage($_name);
		return $name
	}

	multi method id(::?CLASS:D:) {
		return LLVMGetIntrinsicID($.raw)
	}

	method is-overloaded {
		return LLVMIntrinsicIsOverloaded(LLVMGetIntrinsicID($.raw)).Bool
	}
}



#| Metadata

class LLVM::Metadata is export {
	has LLVM::Context $.ctx;
	has LLVMMetadataRef $.raw;
	
	multi method new(LLVMValueRef $val) {
		self.bless: ctx => LLVM::Context.global, raw => LLVMValueAsMetadata($val)
	}
	multi method new(LLVM::Context $ctx, LLVMMetadataRef $md) {
		self.bless: :$ctx, raw => $md
	}
	multi method new(LLVM::Context $ctx, Str $str) {
		self.bless: :$ctx, LLVMMDStringInContext2($ctx.raw, $str, $str.chars)
	}
	multi method new(LLVM::Context $ctx, LLVM::Metadata @mds) {
		my $mds = CArray[LLVMMetadataRef].new(@mds>>.raw);
		self.bless: :$ctx, LLVMMDNodeInContext2($ctx.raw, $mds, @mds.elems)
	}
	multi method new(LLVMMetadataRef $md) {
		self.new: LLVM::Context.global, $md
	}
	multi method new(Str $str) {
		self.new: LLVM::Context.global, $str
	}
	multi method new(LLVM::Metadata @mds) {
		self.new: LLVM::Context.global, @mds
	}

	method !val {
		return LLVMMetadataAsValue($!ctx.raw, $!raw)
	}

	method elems {
		return LLVMGetMDNodeNumOperands(self!val)
	}

	method ops {
		my $ops = CArray[LLVMValueRef].allocate: LLVMGetMDNodeNumOperands(self!val);
		LLVMGetMDNodeOperands(self!val, $ops);
		return $ops.list.map: {LLVM::Metadata.new: $_}
	}

	method string {
		return LLVMGetMDString(self!val, my size_t $)
	}

	method Value {
		return LLVM::Value.new: self!val
	}
}

class LLVM::ValueMetadataEntry is export {
	has LLVMValueMetadataEntry $.raw;

	method new(LLVMValueMetadataEntry $vme) {
		self.bless: raw => $vme
	}
}

class LLVM::ValueMetadataEntries is export {
	has LLVM::ValueMetadataEntry @.entries;

	method new(@entries where {*.all ~~ LLVM::ValueMetadataEntry}) {
		self.bless: :@entries
	}
	
	method get-kind(Int $index) {
		return LLVMValueMetadataEntriesGetKind(CArray[LLVMValueMetadataEntry].new(@.entries>>.raw), $index)
	}

	method get-md(Int $index) {
		return LLVM::Metadata.new: LLVMValueMetadataEntriesGetMetadata(CArray[LLVMValueMetadataEntry].new(@.entries>>.raw), $index)
	}

	method dispose {
		LLVMDisposeValueMetadataEntries(CArray[LLVMValueMetadataEntry].new(@.entries>>.raw))
	}
}



#| Modules

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



#| Types

class LLVM::Type is export {
	has LLVMTypeRef $.raw;

	method int1(::?CLASS:U:)          {return LLVM::Type.new: LLVMInt1Type}
	method int8(::?CLASS:U:)          {return LLVM::Type.new: LLVMInt8Type}
	method int16(::?CLASS:U:)         {return LLVM::Type.new: LLVMInt16Type}
	method int32(::?CLASS:U:)         {return LLVM::Type.new: LLVMInt32Type}
	method int64(::?CLASS:U:)         {return LLVM::Type.new: LLVMInt64Type}
	method int128(::?CLASS:U:)        {return LLVM::Type.new: LLVMInt128Type}
	method int(::?CLASS:U: Int $bits) {return LLVM::Type.new: LLVMIntType($bits)}	

	method half(::?CLASS:U:)      {return LLVM::Type.new: LLVMHalfType}
	method float(::?CLASS:U:)     {return LLVM::Type.new: LLVMFloatType}
	method double(::?CLASS:U:)    {return LLVM::Type.new: LLVMDoubleType}
	method x86-fp80(::?CLASS:U:)  {return LLVM::Type.new: LLVMX86FP80Type}
	method fp128(::?CLASS:U:)     {return LLVM::Type.new: LLVMFP128Type}
	method ppc-fp128(::?CLASS:U:) {return LLVM::Type.new: LLVMPPCFP128Type}

	method struct(::?CLASS:U: @elems where *.all ~~ LLVM::Type, :$packed) {
		return LLVM::Type.new: LLVMStructType(CArray[LLVMTypeRef].new(@elems>>.raw), @elems.elems, so $packed)
	}
	# maybe switch to function([arg-types...] => return-type)
	method function(::?CLASS:U: LLVM::Type $ret, @params where {.all ~~ LLVM::Type}, :$vararg) {
		return LLVM::Type.new: LLVMFunctionType($ret.raw, CArray[LLVMTypeRef].new(@params>>.raw), @params.elems, so $vararg)
	}
	multi method pointer(::?CLASS:U: LLVM::Type $elem, Int $size = 0) {
		return LLVM::Type.new: LLVMPointerType($elem.raw, $size)
	}
	multi method array(::?CLASS:U: LLVM::Type $elem, Int $length) {
		return LLVM::Type.new: LLVMArrayType($elem.raw, $length)
	}
	multi method vector(::?CLASS:U: LLVM::Type $elem, Int $length) {
		return LLVM::Type.new: LLVMVectorType($elem.raw, $length)
	}

	method void(::?CLASS:U:)    {return LLVM::Type.new: LLVMVoidType}
	method label(::?CLASS:U:)   {return LLVM::Type.new: LLVMLabelType}
	method x86-mmx(::?CLASS:U:) {return LLVM::Type.new: LLVMX86MMXType}
	
	method new(LLVMTypeRef $ty) {
		self.bless: raw => $ty
	}

	method kind {
		return LLVM::TypeKind(LLVMGetTypeKind($!raw))
	}

	method context {
		return LLVM::Context.new: LLVMGetTypeContext($!raw)
	}

	method is-sized {
		return LLVMTypeIsSized($!raw).Bool
	}

	method align {
		return LLVM::Value.new: LLVMAlignOf($!raw)
	}

	method size {
		return LLVM::Value.new: LLVMSizeOf($!raw)
	}

	method undef {
		return LLVM::Value.new: LLVMGetUndef($!raw)
	}

	#= Numerics
	method width {
		return LLVMGetIntTypeWidth($!raw)
	}

	#= Functions
	method is-vararg {
		return LLVMIsFunctionVarArg($!raw).Bool
	}

	method return-type {
		return LLVM::Type.new: LLVMGetReturnType($!raw)
	}

	method count-params {
		return LLVMCountParamTypes($!raw)
	}

	method params {
		my $params = CArray[LLVMTypeRef].allocate: LLVMCountParamTypes($!raw);
		LLVMGetParamTypes($!raw, $params);
		return $params.list.map: {LLVM::Type.new: $_}
	}

	#= Positionals
	multi method elem-type {
		return LLVM::Type.new: LLVMGetElementType($!raw)
	}

	method num-contained-types {
		return LLVMGetNumContainedTypes($!raw)
	}

	# might have this wrong idk
	method subtypes {
		my $types = CArray[LLVMTypeRef].allocate: LLVMGetNumContainedTypes($!raw);
		LLVMGetSubtypes($!raw, $types);
		return $types.list.map: {LLVM::Type.new: $_}
	}

	method elems {
		given self.kind {
			when StructTypeKind {
				return self.count-elem-types
			}

			when ArrayTypeKind {
				return self.array-length
			}

			when VectorTypeKind {
				return self.vector-size
			}

			when PointerTypeKind {
				return self.addr-space / self.elem-type.size
			}

			default {
				die "Can't get the size of LLVM type `{self}`!"
			}
		}
	}

	#= Structs
	method name {
		return LLVMGetStructName($!raw)
	}

	method set-body(@elems where {.all ~~ LLVM::Type}, :$packed) {
		LLVMStructSetBody($!raw, CArray[LLVMTypeRef].new(@elems>>.raw), @elems.elems, so $packed);
		return self
	}

	method count-elem-types {
		return LLVMCountStructElementTypes($!raw)
	}

	method elem-types {
		my $elems = CArray[LLVMTypeRef].allocate: LLVMCountParamTypes($!raw);
		LLVMGetStructElementTypes($!raw, $elems);
		return $elems.list.map: {LLVM::Type.new: $_}
	}

	multi method elem-type(Int $index) {
		return LLVM::Type.new: LLVMStructGetTypeAtIndex($!raw, $index)
	}

	method is-packed  {return LLVMIsPackedStruct($!raw).Bool}
	method is-opaque  {return LLVMIsOpaqueStruct($!raw).Bool}
	method is-literal {return LLVMIsLiteralStruct($!raw).Bool}

	#= Arrays
	method array-length {
		return LLVMGetArrayLength($!raw)
	}

	multi method array(::?CLASS:D: Int $length) {
		return LLVM::Type.new: LLVMArrayType($!raw, $length)
	}

	#= Pointers
	method addr-space {
		return LLVMGetPointerAddressSpace($!raw)
	}

	multi method pointer(::?CLASS:D: Int $size = 0) {
		return LLVM::Type.new: LLVMPointerType($!raw, $size)
	}
	
	#= Vectors
	method vector-size {
		return LLVMGetVectorSize($!raw)
	}

	multi method vector(::?CLASS:D: Int $length) {
		return LLVM::Type.new: LLVMVectorType($!raw, $length)
	}

	#= Misc
	method dump {
		LLVMDumpType($!raw)
	}

	method Str {
		return LLVMPrintTypeToString($!raw)
	}

	method inline-asm(Str $asm, Str $constraints, LLVM::InlineAsmDialect $dialect, :$side-effects, :$align-stack) {
		return LLVM::Value.new: LLVMGetInlineAsm($!raw, $asm, $asm.chars, $constraints, $constraints.chars, so $side-effects, so $align-stack, $dialect.Int)
	}

	#= Constants
	method const-null {
		return LLVM::Value.new: LLVMConstNull($!raw)
	}

	method const-ones {
		return LLVM::Value.new: LLVMConstAllOnes($!raw)
	}

	method const-nullptr {
		return LLVM::Value.new: LLVMConstPointerNull($!raw)
	}

	multi method const-int(Int $value, :$signed = True) {
		return LLVM::Value.new: LLVMConstInt($!raw, $value, $signed)
	}
	#sub LLVMConstIntOfArbitraryPrecision(LLVMTypeRef, size_t, CArray[uint64]) returns LLVMValueRef
	multi method const-int(Str $value, Int :$radix = 10) {
		return LLVM::Value.new: LLVMConstIntOfStringAndSize($!raw, $value, $value.chars, $radix)
	}

	multi method const-real(Rat $value) {
		return LLVM::Value.new: LLVMConstReal($!raw, $value)
	}
	multi method const-real(Str $value) {
		return LLVM::Value.new: LLVMConstRealOfStringAndSize($!raw, $value, $value.chars)
	}

	method const-array(@values where {.all ~~ LLVM::Value}) {
		return LLVM::Value.new: LLVMConstArray($!raw, CArray[LLVMValueRef].new(@values>>.raw), @values.elems)
	}
	
	method const-named-struct(@values where {.all ~~ LLVM::Value}) {
		return LLVM::Value.new: LLVMConstNamedStruct($!raw, CArray[LLVMValueRef].new(@values>>.raw), @values.elems)
	}

	#= finish later
	#sub LLVMConstGEP2(LLVMTypeRef, LLVMValueRef, CArray[LLVMValueRef], size_t)         returns LLVMValueRef
	#sub LLVMConstInBoundsGEP2(LLVMTypeRef, LLVMValueRef, CArray[LLVMValueRef], size_t) returns LLVMValueRef
	#sub LLVMConstInlineAsm(LLVMTypeRef, Str, Str, int32, int32)                        returns LLVMValueRef
}