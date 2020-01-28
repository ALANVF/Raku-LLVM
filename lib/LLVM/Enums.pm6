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