use NativeCall;

# this is helpful: https://llvm.org/doxygen/group__LLVMC.html

unit module LLVMC;

constant $llvm = "LLVM-7";

#| Typedefs
class LLVMContextRef            is repr<CPointer> is export {}
class LLVMModuleRef             is repr<CPointer> is export {}
class LLVMPassRegistryRef       is repr<CPointer> is export {}
class LLVMPassManagerRef        is repr<CPointer> is export {}
class LLVMPassManagerBuilderRef is repr<CPointer> is export {}
class LLVMMetadataRef           is repr<CPointer> is export {}
class LLVMValueRef              is repr<CPointer> is export {}
class LLVMTypeRef               is repr<CPointer> is export {}
class LLVMNamedMDNodeRef        is repr<CPointer> is export {}
class LLVMDiagnosticInfoRef     is repr<CPointer> is export {}
class LLVMAttributeRef          is repr<CPointer> is export {}
class LLVMUseRef                is repr<CPointer> is export {}
class LLVMBasicBlockRef         is repr<CPointer> is export {}
class LLVMBuilderRef            is repr<CPointer> is export {}
class LLVMMemoryBufferRef       is repr<CPointer> is export {}
class LLVMModuleProviderRef     is repr<CPointer> is export {}
class LLVMGenericValueRef       is repr<CPointer> is export {}
class LLVMExecutionEngineRef    is repr<CPointer> is export {}
class LLVMMCJITMemoryManagerRef is repr<CPointer> is export {}
class LLVMTargetDataRef         is repr<CPointer> is export {}
class LLVMTargetMachineRef      is repr<CPointer> is export {}
class LLVMJITEventListenerRef   is repr<CPointer> is export {}
class LLVMSectionIteratorRef    is repr<CPointer> is export {}
class LLVMSymbolIteratorRef     is repr<CPointer> is export {}
class LLVMRelocationIteratorRef is repr<CPointer> is export {}
class LLVMObjectFileRef         is repr<CPointer> is export {}
class LLVMBinaryRef             is repr<CPointer> is export {}
class LLVMRemarkStringRef       is repr<CPointer> is export {}
class LLVMRemarkDebugLocRef     is repr<CPointer> is export {}
class LLVMRemarkArgRef          is repr<CPointer> is export {}
class LLVMRemarkEntryRef        is repr<CPointer> is export {}
class LLVMRemarkParserRef       is repr<CPointer> is export {}
class LLVMTargetLibraryInfoRef  is repr<CPointer> is export {}

class lto_module_t       is repr<CPointer> is export {}
class lto_code_gen_t     is repr<CPointer> is export {}
class thinlto_code_gen_t is repr<CPointer> is export {}
class lto_input_t        is repr<CPointer> is export {}

class LLVMModuleFlagEntry    is repr<CPointer> is export {}
class LLVMValueMetadataEntry is repr<CPointer> is export {}

# having fun https://llvm.org/doxygen/group__LLVMCExecutionEngine.html
class LLVMMCJITCompilerOptions is repr<CStruct> is export {
	has size_t $.OptLevel;
	has int32  $.CodeModel;
	has int32  $.NoFramePointerElim;
	has int32  $.EnableFastISel;
	has LLVMMCJITMemoryManagerRef $.MCJMM;
}

class LTOObjectBuffer is repr<CStruct> is export {
	has size_t $.Size;
	has Str    $.Buffer is rw;
}

#| Function Typedefs
sub term:<LLVMDiagnosticHandler>                        is export {:(LLVMDiagnosticInfoRef, Pointer[void])};
sub term:<LLVMYieldCallback>                            is export {:(LLVMContextRef, Pointer[void])};
sub term:<LLVMOpInfoCallback>                           is export {:(Pointer[void], uint64, uint64, uint64, int32, Pointer[void] --> int32)};
sub term:<LLVMSymbolLookupCallback>                     is export {:(Pointer[void], uint64, uint64 is rw, uint64, Str is rw --> Str)};
sub term:<LLVMMemoryManagerFinalizeMemoryCallback>      is export {:(Pointer[void], Str is rw --> int32)};
sub term:<LLVMMemoryManagerDestroyCallback>             is export {:(Pointer[void])};
sub term:<LLVMMemoryManagerAllocateCodeSectionCallback> is export {:(Pointer[void], uint64, size_t, size_t, Str --> CArray[uint8])};
sub term:<LLVMMemoryManagerAllocateDataSectionCallback> is export {:(Pointer[void], uint64, size_t, size_t, Str, int32 --> CArray[uint8])};
sub term:<lto_diagnostic_handler_t>                     is export {:(int32, Str, Pointer[void])};

#| Enums
enum LLVMByteOrdering is export (
	LLVMBigEndian    => 0,
	LLVMLittleEndian => 1
);

enum LLVMCodeModel is export (
	LLVMCodeModelDefault    => 0,
	LLVMCodeModelJITDefault => 1,
	LLVMCodeModelTiny       => 2,
	LLVMCodeModelSmall      => 3,
	LLVMCodeModelKernel     => 4,
	LLVMCodeModelMedium     => 5,
	LLVMCodeModelLarge      => 6
);

enum LLVMOpcode is export (
	LLVMRet            => 1,
	LLVMBr             => 2,
	LLVMSwitch         => 3,
	LLVMIndirectBr     => 4,
	LLVMInvoke         => 5,

	LLVMUnreachable    => 7,
	LLVMCallBr         => 67,

	LLVMFNeg           => 66,

	LLVMAdd            => 8,
	LLVMFAdd           => 9,
	LLVMSub            => 10,
	LLVMFSub           => 11,
	LLVMMul            => 12,
	LLVMFMul           => 13,
	LLVMUDiv           => 14,
	LLVMSDiv           => 15,
	LLVMFDiv           => 16,
	LLVMURem           => 17,
	LLVMSRem           => 18,
	LLVMFRem           => 19,

	LLVMShl            => 20,
	LLVMLShr           => 21,
	LLVMAShr           => 22,
	LLVMAnd            => 23,
	LLVMOr             => 24,
	LLVMXor            => 25,

	LLVMAlloca         => 26,
	LLVMLoad           => 27,
	LLVMStore          => 28,
	LLVMGetElementPtr  => 29,

	LLVMTrunc          => 30,
	LLVMZExt           => 31,
	LLVMSExt           => 32,
	LLVMFPToUI         => 33,
	LLVMFPToSI         => 34,
	LLVMUIToFP         => 35,
	LLVMSIToFP         => 36,
	LLVMFPTrunc        => 37,
	LLVMFPExt          => 38,
	LLVMPtrToInt       => 39,
	LLVMIntToPtr       => 40,
	LLVMBitCast        => 41,
	LLVMAddrSpaceCast  => 60,

	LLVMICmp           => 42,
	LLVMFCmp           => 43,
	LLVMPHI            => 44,
	LLVMCall           => 45,
	LLVMSelect         => 46,
	LLVMUserOp1        => 47,
	LLVMUserOp2        => 48,
	LLVMVAArg          => 49,
	LLVMExtractElement => 50,
	LLVMInsertElement  => 51,
	LLVMShuffleVector  => 52,
	LLVMExtractValue   => 53,
	LLVMInsertValue    => 54,

	LLVMFence          => 55,
	LLVMAtomicCmpXchg  => 56,
	LLVMAtomicRMW      => 57,

	LLVMResume         => 58,
	LLVMLandingPad     => 59,
	LLVMCleanupRet     => 61,
	LLVMCatchRet       => 62,
	LLVMCatchPad       => 63,
	LLVMCleanupPad     => 64,
	LLVMCatchSwitch    => 65
);

enum LLVMValueKind is export (
	LLVMArgumentValueKind              => 0,
	LLVMBasicBlockValueKind            => 1,
	LLVMMemoryUseValueKind             => 2,
	LLVMMemoryDefValueKind             => 3,
	LLVMMemoryPhiValueKind             => 4,
	LLVMFunctionValueKind              => 5,
	LLVMGlobalAliasValueKind           => 6,
	LLVMGlobalIFuncValueKind           => 7,
	LLVMGlobalVariableValueKind        => 8,
	LLVMBlockAddressValueKind          => 9,
	LLVMConstantExprValueKind          => 10,
	LLVMConstantArrayValueKind         => 11,
	LLVMConstantStructValueKind        => 12,
	LLVMConstantVectorValueKind        => 13,
	LLVMUndefValueValueKind            => 14,
	LLVMConstantAggregateZeroValueKind => 15,
	LLVMConstantDataArrayValueKind     => 16,
	LLVMConstantDataVectorValueKind    => 17,
	LLVMConstantIntValueKind           => 18,
	LLVMConstantFPValueKind            => 19,
	LLVMConstantPointerNullValueKind   => 20,
	LLVMConstantTokenNoneValueKind     => 21,
	LLVMMetadataAsValueValueKind       => 22,
	LLVMInlineAsmValueKind             => 23,
	LLVMInstructionValueKind           => 24
);

enum LLVMTypeKind is export (
	LLVMVoidTypeKind      => 0,
	LLVMHalfTypeKind      => 1,
	LLVMFloatTypeKind     => 2,
	LLVMDoubleTypeKind    => 3,
	LLVMX86_FP80TypeKind  => 4,
	LLVMFP128TypeKind     => 5,
	LLVMPPC_FP128TypeKind => 6,
	LLVMLabelTypeKind     => 7,
	LLVMIntegerTypeKind   => 8,
	LLVMFunctionTypeKind  => 9,
	LLVMStructTypeKind    => 10,
	LLVMArrayTypeKind     => 11,
	LLVMPointerTypeKind   => 12,
	LLVMVectorTypeKind    => 13,
	LLVMMetadataTypeKind  => 14,
	LLVMX86_MMXTypeKind   => 15,
	LLVMTokenTypeKind     => 16
);

enum LLVMModuleFlagBehavior is export (
	LLVMModuleFlagBehaviorError        => 0,
	LLVMModuleFlagBehaviorWarning      => 1,
	LLVMModuleFlagBehaviorRequire      => 2,
	LLVMModuleFlagBehaviorOverride     => 3,
	LLVMModuleFlagBehaviorAppend       => 4,
	LLVMModuleFlagBehaviorAppendUnique => 5
);

enum LLVMInlineAsmDialect is export (
	LLVMInlineAsmDialectATT   => 0,
	LLVMInlineAsmDialectIntel => 1
);

enum LLVMDiagnosticSeverity is export (
	LLVMDSError   => 0,
	LLVMDSWarning => 1,
	LLVMDSRemark  => 2,
	LLVMDSNote    => 3
);

enum LLVMIntPredicate is export (
	LLVMIntEQ  => 32,
	LLVMIntNE  => 33,
	LLVMIntUGT => 34,
	LLVMIntUGE => 35,
	LLVMIntULT => 36,
	LLVMIntULE => 37,
	LLVMIntSGT => 38,
	LLVMIntSGE => 39,
	LLVMIntSLT => 40,
	LLVMIntSLE => 41
);

enum LLVMRealPredicate is export (
	LLVMRealPredicateFalse => 0,
	LLVMRealOEQ            => 1,
	LLVMRealOGT            => 2,
	LLVMRealOGE            => 3,
	LLVMRealOLT            => 4,
	LLVMRealOLE            => 5,
	LLVMRealONE            => 6,
	LLVMRealORD            => 7,
	LLVMRealUNO            => 8,
	LLVMRealUEQ            => 9,
	LLVMRealUGT            => 10,
	LLVMRealUGE            => 11,
	LLVMRealULT            => 12,
	LLVMRealULE            => 13,
	LLVMRealUNE            => 14,
	LLVMRealPredicateTrue  => 15
);

enum LLVMLinkage is export (
	LLVMExternalLinkage            => 0,
	LLVMAvailableExternallyLinkage => 1,
	LLVMLinkOnceAnyLinkage         => 2,
	LLVMLinkOnceODRLinkage         => 3,
	LLVMLinkOnceODRAutoHideLinkage => 4,
	LLVMWeakAnyLinkage             => 5,
	LLVMWeakODRLinkage             => 6,
	LLVMAppendingLinkage           => 7,
	LLVMInternalLinkage            => 8,
	LLVMPrivateLinkage             => 9,
	LLVMDLLImportLinkage           => 10,
	LLVMDLLExportLinkage           => 11,
	LLVMExternalWeakLinkage        => 12,
	LLVMGhostLinkage               => 13,
	LLVMCommonLinkage              => 14,
	LLVMLinkerPrivateLinkage       => 15,
	LLVMLinkerPrivateWeakLinkage   => 16
);

enum LLVMVisibility is export (
	LLVMDefaultVisibility   => 0,
	LLVMHiddenVisibility    => 1,
	LLVMProtectedVisibility => 2
);

enum LLVMUnnamedAddr is export (
	LLVMNoUnnamedAddr     => 0,
	LLVMLocalUnnamedAddr  => 1,
	LLVMGlobalUnnamedAddr => 2
);

enum LLVMDLLStorageClass is export (
	LLVMDefaultStorageClass   => 0,
	LLVMDLLImportStorageClass => 1,
	LLVMDLLExportStorageClass => 2
);

enum LLVMThreadLocalMode is export (
	LLVMNotThreadLocal         => 0,
	LLVMGeneralDynamicTLSModel => 1,
	LLVMLocalDynamicTLSModel   => 2,
	LLVMInitialExecTLSModel    => 3,
	LLVMLocalExecTLSModel      => 4
);

enum LLVMCallConv is export (
	LLVMCCallConv             => 0,
	LLVMFastCallConv          => 8,
	LLVMColdCallConv          => 9,
	LLVMGHCCallConv           => 10,
	LLVMHiPECallConv          => 11,
	LLVMWebKitJSCallConv      => 12,
	LLVMAnyRegCallConv        => 13,
	LLVMPreserveMostCallConv  => 14,
	LLVMPreserveAllCallConv   => 15,
	LLVMSwiftCallConv         => 16,
	LLVMCXXFASTTLSCallConv    => 17,
	LLVMX86StdcallCallConv    => 64,
	LLVMX86FastcallCallConv   => 65,
	LLVMARMAPCSCallConv       => 66,
	LLVMARMAAPCSCallConv      => 67,
	LLVMARMAAPCSVFPCallConv   => 68,
	LLVMMSP430INTRCallConv    => 69,
	LLVMX86ThisCallCallConv   => 70,
	LLVMPTXKernelCallConv     => 71,
	LLVMPTXDeviceCallConv     => 72,
	LLVMSPIRFUNCCallConv      => 75,
	LLVMSPIRKERNELCallConv    => 76,
	LLVMIntelOCLBICallConv    => 77,
	LLVMX8664SysVCallConv     => 78,
	LLVMWin64CallConv         => 79,
	LLVMX86VectorCallCallConv => 80,
	LLVMHHVMCallConv          => 81,
	LLVMHHVMCCallConv         => 82,
	LLVMX86INTRCallConv       => 83,
	LLVMAVRINTRCallConv       => 84,
	LLVMAVRSIGNALCallConv     => 85,
	LLVMAVRBUILTINCallConv    => 86,
	LLVMAMDGPUVSCallConv      => 87,
	LLVMAMDGPUGSCallConv      => 88,
	LLVMAMDGPUPSCallConv      => 89,
	LLVMAMDGPUCSCallConv      => 90,
	LLVMAMDGPUKERNELCallConv  => 91,
	LLVMX86RegCallCallConv    => 92,
	LLVMAMDGPUHSCallConv      => 93,
	LLVMMSP430BUILTINCallConv => 94,
	LLVMAMDGPULSCallConv      => 95,
	LLVMAMDGPUESCallConv      => 96
);

enum LLVMLandingPadClauseTy is export (
	LLVMLandingPadCatch  => 0,
	LLVMLandingPadFilter => 1
);

enum LLVMAtomicOrdering is export (
	LLVMAtomicOrderingNotAtomic              => 0,
	LLVMAtomicOrderingUnordered              => 1,
	LLVMAtomicOrderingMonotonic              => 2,
	LLVMAtomicOrderingAcquire                => 4,
	LLVMAtomicOrderingRelease                => 5,
	LLVMAtomicOrderingAcquireRelease         => 6,
	LLVMAtomicOrderingSequentiallyConsistent => 7
);

enum LLVMAtomicRMWBinOp is export (
	LLVMAtomicRMWBinOpXchg => 0,
	LLVMAtomicRMWBinOpAdd  => 1,
	LLVMAtomicRMWBinOpSub  => 2,
	LLVMAtomicRMWBinOpAnd  => 3,
	LLVMAtomicRMWBinOpNand => 4,
	LLVMAtomicRMWBinOpOr   => 5,
	LLVMAtomicRMWBinOpXor  => 6,
	LLVMAtomicRMWBinOpMax  => 7,
	LLVMAtomicRMWBinOpMin  => 8,
	LLVMAtomicRMWBinOpUMax => 9,
	LLVMAtomicRMWBinOpUMin => 10
);

enum LLVMVerifierFailureAction is export (
	LLVMAbortProcessAction => 0,
	LLVMPrintMessageAction => 1,
	LLVMReturnStatusAction => 2
);

enum llvm_lto_status_t is export (
	LLVM_LTO_UNKNOWN              => 0,
	LLVM_LTO_OPT_SUCCESS          => 1,
	LLVM_LTO_READ_SUCCESS         => 2,
	LLVM_LTO_READ_FAILURE         => 3,
	LLVM_LTO_WRITE_FAILURE        => 4,
	LLVM_LTO_NO_TARGET            => 5,
	LLVM_LTO_NO_WORK              => 6,
	LLVM_LTO_MODULE_MERGE_FAILURE => 7,
	LLVM_LTO_ASM_FAILURE          => 8,
	LLVM_LTO_NULL_OBJECT          => 9
);

enum lto_symbol_attributes is export (
	LTO_SYMBOL_ALIGNMENT_MASK              => 0x0000001F,
	LTO_SYMBOL_PERMISSIONS_MASK            => 0x000000E0,
	LTO_SYMBOL_PERMISSIONS_CODE            => 0x000000A0,
	LTO_SYMBOL_PERMISSIONS_DATA            => 0x000000C0,
	LTO_SYMBOL_PERMISSIONS_RODATA          => 0x00000080,
	LTO_SYMBOL_DEFINITION_MASK             => 0x00000700,
	LTO_SYMBOL_DEFINITION_REGULAR          => 0x00000100,
	LTO_SYMBOL_DEFINITION_TENTATIVE        => 0x00000200,
	LTO_SYMBOL_DEFINITION_WEAK             => 0x00000300,
	LTO_SYMBOL_DEFINITION_UNDEFINED        => 0x00000400,
	LTO_SYMBOL_DEFINITION_WEAKUNDEF        => 0x00000500,
	LTO_SYMBOL_SCOPE_MASK                  => 0x00003800,
	LTO_SYMBOL_SCOPE_INTERNAL              => 0x00000800,
	LTO_SYMBOL_SCOPE_HIDDEN                => 0x00001000,
	LTO_SYMBOL_SCOPE_PROTECTED             => 0x00002000,
	LTO_SYMBOL_SCOPE_DEFAULT               => 0x00001800,
	LTO_SYMBOL_SCOPE_DEFAULT_CAN_BE_HIDDEN => 0x00002800,
	LTO_SYMBOL_COMDAT                      => 0x00004000,
	LTO_SYMBOL_ALIAS                       => 0x00008000
);

enum LLVMBinaryType is export (
	LLVMBinaryTypeArchive              => 0,
	LLVMBinaryTypeMachOUniversalBinary => 1,
	LLVMBinaryTypeCOFFImportFile       => 2,
	LLVMBinaryTypeIR                   => 3,
	LLVMBinaryTypeWinRes               => 4,
	LLVMBinaryTypeCOFF                 => 5,
	LLVMBinaryTypeELF32L               => 6,
	LLVMBinaryTypeELF32B               => 7,
	LLVMBinaryTypeELF64L               => 8,
	LLVMBinaryTypeELF64B               => 9,
	LLVMBinaryTypeMachO32L             => 10,
	LLVMBinaryTypeMachO32B             => 11,
	LLVMBinaryTypeMachO64L             => 12,
	LLVMBinaryTypeMachO64B             => 13,
	LLVMBinaryTypeWasm                 => 14
);

enum lto_debug_model is export (
	LTO_DEBUG_MODEL_NONE  => 0,
	LTO_DEBUG_MODEL_DWARF => 1
);

enum lto_codegen_model is export (
	LTO_CODEGEN_PIC_MODEL_STATIC         => 0,
	LTO_CODEGEN_PIC_MODEL_DYNAMIC        => 1,
	LTO_CODEGEN_PIC_MODEL_DYNAMIC_NO_PIC => 2,
	LTO_CODEGEN_PIC_MODEL_DEFAULT        => 3
);

enum lto_codegen_diagnostic_severity_t is export (
	LTO_DS_ERROR   => 0,
	LTO_DS_WARNING => 1,
	LTO_DS_REMARK  => 3,
	LTO_DS_NOTE    => 2
);

enum LLVMRemarkType is export (
	LLVMRemarkTypeUnknown           => 0,
	LLVMRemarkTypePassed            => 1,
	LLVMRemarkTypeMissed            => 2,
	LLVMRemarkTypeAnalysis          => 3,
	LLVMRemarkTypeAnalysisFPCommute => 4,
	LLVMRemarkTypeAnalysisAliasing  => 5,
	LLVMRemarkTypeFailure           => 6
);

#= Analysis
sub LLVMVerifyModule(LLVMModuleRef, int32, Str is rw) returns int32 is native($llvm) is export {*}
sub LLVMVerifyFunction(LLVMValueRef, int32)           returns int32 is native($llvm) is export {*}
sub LLVMViewFunctionCFG(LLVMValueRef)                               is native($llvm) is export {*}
sub LLVMViewFunctionCFGOnly(LLVMValueRef)                           is native($llvm) is export {*}

#= Bit Reader
sub LLVMParseBitcode(LLVMMemoryBufferRef, LLVMModuleRef is rw, Str is rw)                              returns int32 is native($llvm) is export {*}
sub LLVMParseBitcode2(LLVMMemoryBufferRef, LLVMModuleRef is rw)                                        returns int32 is native($llvm) is export {*}
sub LLVMParseBitcodeInContext(LLVMContextRef, LLVMMemoryBufferRef, LLVMModuleRef is rw, Str is rw)     returns int32 is native($llvm) is export {*}
sub LLVMParseBitcodeInContext2(LLVMContextRef, LLVMMemoryBufferRef, LLVMModuleRef is rw)               returns int32 is native($llvm) is export {*}
sub LLVMGetBitcodeModuleInContext(LLVMContextRef, LLVMMemoryBufferRef, LLVMModuleRef is rw, Str is rw) returns int32 is native($llvm) is export {*}
sub LLVMGetBitcodeModuleInContext2(LLVMContextRef, LLVMMemoryBufferRef, LLVMModuleRef is rw)           returns int32 is native($llvm) is export {*}
sub LLVMGetBitcodeModule(LLVMMemoryBufferRef, LLVMModuleRef is rw, Str is rw)                          returns int32 is native($llvm) is export {*}
sub LLVMGetBitcodeModule2(LLVMMemoryBufferRef, LLVMModuleRef is rw)                                    returns int32 is native($llvm) is export {*}

#= Bit Writer
sub LLVMWriteBitcodeToFile(LLVMModuleRef, Str)               returns int32               is native($llvm) is export {*}
sub LLVMWriteBitcodeToFD(LLVMModuleRef, int32, int32, int32) returns int32               is native($llvm) is export {*}
sub LLVMWriteBitcodeToFileHandle(LLVMModuleRef, int32)       returns int32               is native($llvm) is export {*}
sub LLVMWriteBitcodeToMemoryBuffer(LLVMModuleRef)            returns LLVMMemoryBufferRef is native($llvm) is export {*}

#= Transforms
sub LLVMAddAggressiveInstCombinerPass(LLVMPassManagerRef) is native($llvm) is export {*}

sub LLVMAddCoroEarlyPass(LLVMPassManagerRef)   is native($llvm) is export {*}
sub LLVMAddCoroSplitPass(LLVMPassManagerRef)   is native($llvm) is export {*}
sub LLVMAddCoroElidePass(LLVMPassManagerRef)   is native($llvm) is export {*}
sub LLVMAddCoroCleanupPass(LLVMPassManagerRef) is native($llvm) is export {*}

sub LLVMAddArgumentPromotionPass(LLVMPassManagerRef)      is native($llvm) is export {*}
sub LLVMAddConstantMergePass(LLVMPassManagerRef)          is native($llvm) is export {*}
sub LLVMAddCalledValuePropagationPass(LLVMPassManagerRef) is native($llvm) is export {*}
sub LLVMAddDeadArgEliminationPass(LLVMPassManagerRef)     is native($llvm) is export {*}
sub LLVMAddFunctionAttrsPass(LLVMPassManagerRef)          is native($llvm) is export {*}
sub LLVMAddFunctionInliningPass(LLVMPassManagerRef)       is native($llvm) is export {*}
sub LLVMAddAlwaysInlinerPass(LLVMPassManagerRef)          is native($llvm) is export {*}
sub LLVMAddGlobalDCEPass(LLVMPassManagerRef)              is native($llvm) is export {*}
sub LLVMAddGlobalOptimizerPass(LLVMPassManagerRef)        is native($llvm) is export {*}
sub LLVMAddIPConstantPropagationPass(LLVMPassManagerRef)  is native($llvm) is export {*}
sub LLVMAddPruneEHPass(LLVMPassManagerRef)                is native($llvm) is export {*}
sub LLVMAddIPSCCPPass(LLVMPassManagerRef)                 is native($llvm) is export {*}
sub LLVMAddInternalizePass(LLVMPassManagerRef, size_t)    is native($llvm) is export {*}
sub LLVMAddInternalizePassWithMustPreservePredicate(LLVMPassManagerRef, Pointer[void], Pointer #`[LLVMBool(*MustPreserve)(LLVMValueRef, void *)]) is native($llvm) is export {*}
sub LLVMAddStripDeadPrototypesPass(LLVMPassManagerRef)    is native($llvm) is export {*}
sub LLVMAddStripSymbolsPass(LLVMPassManagerRef)           is native($llvm) is export {*}

sub LLVMPassManagerBuilderCreate                                                                              returns LLVMPassManagerBuilderRef is native($llvm) is export {*}
sub LLVMPassManagerBuilderDispose(LLVMPassManagerBuilderRef)                                                                                    is native($llvm) is export {*}
sub LLVMPassManagerBuilderSetOptLevel(LLVMPassManagerBuilderRef, size_t)                                                                        is native($llvm) is export {*}
sub LLVMPassManagerBuilderSetSizeLevel(LLVMPassManagerBuilderRef, size_t)                                                                       is native($llvm) is export {*}
sub LLVMPassManagerBuilderSetDisableUnitAtATime(LLVMPassManagerBuilderRef, int32)                                                               is native($llvm) is export {*}
sub LLVMPassManagerBuilderSetDisableUnrollLoops(LLVMPassManagerBuilderRef, int32)                                                               is native($llvm) is export {*}
sub LLVMPassManagerBuilderSetDisableSimplifyLibCalls(LLVMPassManagerBuilderRef, int32)                                                          is native($llvm) is export {*}
sub LLVMPassManagerBuilderUseInlinerWithThreshold(LLVMPassManagerBuilderRef, size_t)                                                            is native($llvm) is export {*}
sub LLVMPassManagerBuilderPopulateFunctionPassManager(LLVMPassManagerBuilderRef, LLVMPassManagerRef)                                            is native($llvm) is export {*}
sub LLVMPassManagerBuilderPopulateModulePassManager(LLVMPassManagerBuilderRef, LLVMPassManagerRef)                                              is native($llvm) is export {*}
sub LLVMPassManagerBuilderPopulateLTOPassManager(LLVMPassManagerBuilderRef, LLVMPassManagerRef, int32, int32)                                   is native($llvm) is export {*}

sub LLVMAddAggressiveDCEPass(LLVMPassManagerRef)                            is native($llvm) is export {*}
sub LLVMAddBitTrackingDCEPass(LLVMPassManagerRef)                           is native($llvm) is export {*}
sub LLVMAddAlignmentFromAssumptionsPass(LLVMPassManagerRef)                 is native($llvm) is export {*}
sub LLVMAddCFGSimplificationPass(LLVMPassManagerRef)                        is native($llvm) is export {*}
sub LLVMAddDeadStoreEliminationPass(LLVMPassManagerRef)                     is native($llvm) is export {*}
sub LLVMAddScalarizerPass(LLVMPassManagerRef)                               is native($llvm) is export {*}
sub LLVMAddMergedLoadStoreMotionPass(LLVMPassManagerRef)                    is native($llvm) is export {*}
sub LLVMAddGVNPass(LLVMPassManagerRef)                                      is native($llvm) is export {*}
sub LLVMAddNewGVNPass(LLVMPassManagerRef)                                   is native($llvm) is export {*}
sub LLVMAddIndVarSimplifyPass(LLVMPassManagerRef)                           is native($llvm) is export {*}
sub LLVMAddInstructionCombiningPass(LLVMPassManagerRef)                     is native($llvm) is export {*}
sub LLVMAddJumpThreadingPass(LLVMPassManagerRef)                            is native($llvm) is export {*}
sub LLVMAddLICMPass(LLVMPassManagerRef)                                     is native($llvm) is export {*}
sub LLVMAddLoopDeletionPass(LLVMPassManagerRef)                             is native($llvm) is export {*}
sub LLVMAddLoopIdiomPass(LLVMPassManagerRef)                                is native($llvm) is export {*}
sub LLVMAddLoopRotatePass(LLVMPassManagerRef)                               is native($llvm) is export {*}
sub LLVMAddLoopRerollPass(LLVMPassManagerRef)                               is native($llvm) is export {*}
sub LLVMAddLoopUnrollPass(LLVMPassManagerRef)                               is native($llvm) is export {*}
sub LLVMAddLoopUnrollAndJamPass(LLVMPassManagerRef)                         is native($llvm) is export {*}
sub LLVMAddLoopUnswitchPass(LLVMPassManagerRef)                             is native($llvm) is export {*}
sub LLVMAddLowerAtomicPass(LLVMPassManagerRef)                              is native($llvm) is export {*}
sub LLVMAddMemCpyOptPass(LLVMPassManagerRef)                                is native($llvm) is export {*}
sub LLVMAddPartiallyInlineLibCallsPass(LLVMPassManagerRef)                  is native($llvm) is export {*}
sub LLVMAddReassociatePass(LLVMPassManagerRef)                              is native($llvm) is export {*}
sub LLVMAddSCCPPass(LLVMPassManagerRef)                                     is native($llvm) is export {*}
sub LLVMAddScalarReplAggregatesPass(LLVMPassManagerRef)                     is native($llvm) is export {*}
sub LLVMAddScalarReplAggregatesPassSSA(LLVMPassManagerRef)                  is native($llvm) is export {*}
sub LLVMAddScalarReplAggregatesPassWithThreshold(LLVMPassManagerRef, int32) is native($llvm) is export {*}
sub LLVMAddSimplifyLibCallsPass(LLVMPassManagerRef)                         is native($llvm) is export {*}
sub LLVMAddTailCallEliminationPass(LLVMPassManagerRef)                      is native($llvm) is export {*}
sub LLVMAddConstantPropagationPass(LLVMPassManagerRef)                      is native($llvm) is export {*}
sub LLVMAddDemoteMemoryToRegisterPass(LLVMPassManagerRef)                   is native($llvm) is export {*}
sub LLVMAddVerifierPass(LLVMPassManagerRef)                                 is native($llvm) is export {*}
sub LLVMAddCorrelatedValuePropagationPass(LLVMPassManagerRef)               is native($llvm) is export {*}
sub LLVMAddEarlyCSEPass(LLVMPassManagerRef)                                 is native($llvm) is export {*}
sub LLVMAddEarlyCSEMemSSAPass(LLVMPassManagerRef)                           is native($llvm) is export {*}
sub LLVMAddLowerExpectIntrinsicPass(LLVMPassManagerRef)                     is native($llvm) is export {*}
sub LLVMAddTypeBasedAliasAnalysisPass(LLVMPassManagerRef)                   is native($llvm) is export {*}
sub LLVMAddScopedNoAliasAAPass(LLVMPassManagerRef)                          is native($llvm) is export {*}
sub LLVMAddBasicAliasAnalysisPass(LLVMPassManagerRef)                       is native($llvm) is export {*}
sub LLVMAddUnifyFunctionExitNodesPass(LLVMPassManagerRef)                   is native($llvm) is export {*}

sub LLVMAddLowerSwitchPass(LLVMPassManagerRef)             is native($llvm) is export {*}
sub LLVMAddPromoteMemoryToRegisterPass(LLVMPassManagerRef) is native($llvm) is export {*}
sub LLVMAddAddDiscriminatorsPass(LLVMPassManagerRef)       is native($llvm) is export {*}

sub LLVMAddLoopVectorizePass(LLVMPassManagerRef) is native($llvm) is export {*}
sub LLVMAddSLPVectorizePass(LLVMPassManagerRef)  is native($llvm) is export {*}

#= Core
sub LLVMInitializeCore(LLVMContextRef) is native($llvm) is export {*}
sub LLVMShutdown                       is native($llvm) is export {*}
sub LLVMCreateMessage(Str) returns Str is native($llvm) is export {*}
sub LLVMDisposeMessage(Str)            is native($llvm) is export {*}

#| Contexts
sub LLVMContextCreate    returns LLVMContextRef is native($llvm) is export {*}
sub LLVMGetGlobalContext returns LLVMContextRef is native($llvm) is export {*}

sub LLVMContextSetDiagnosticHandler(LLVMContextRef, Pointer, Pointer[void])                       is native($llvm) is export {*}
sub LLVMContextGetDiagnosticHandler(LLVMContextRef)                         returns Pointer       is native($llvm) is export {*}
sub LLVMContextGetDiagnosticContext(LLVMContextRef)                         returns Pointer[void] is native($llvm) is export {*}

sub LLVMContextSetYieldCallback(LLVMContextRef, Pointer, Pointer[void])               is native($llvm) is export {*}
sub LLVMContextShouldDiscardValueNames(LLVMContextRef)                  returns int32 is native($llvm) is export {*}
sub LLVMContextSetDiscardValueNames(LLVMContextRef, int32)                            is native($llvm) is export {*}

sub LLVMContextDispose(LLVMContextRef) is native($llvm) is export {*}

sub LLVMGetDiagInfoDescription(LLVMDiagnosticInfoRef) returns Str is native($llvm) is export {*}
sub LLVMGetDiagInfoSeverity(LLVMDiagnosticInfoRef)    returns int32 is native($llvm) is export {*}

sub LLVMGetMDKindIDInContext(LLVMContextRef, Str, size_t) returns size_t is native($llvm) is export {*}
sub LLVMGetMDKindID(Str, size_t) returns size_t is native($llvm) is export {*}
sub LLVMGetEnumAttributeKindForName(Str, size_t) returns size_t is native($llvm) is export {*}
sub LLVMGetLastEnumAttributeKind returns size_t is native($llvm) is export {*}
sub LLVMCreateEnumAttribute(LLVMContextRef, size_t, uint64) returns LLVMAttributeRef is native($llvm) is export {*}
sub LLVMGetEnumAttributeKind(LLVMAttributeRef) returns size_t is native($llvm) is export {*}
sub LLVMGetEnumAttributeValue(LLVMAttributeRef) returns uint64 is native($llvm) is export {*}
sub LLVMCreateStringAttribute(LLVMContextRef, Str, size_t, Str, size_t) returns LLVMAttributeRef is native($llvm) is export {*}
sub LLVMGetStringAttributeKind(LLVMAttributeRef, size_t is rw) returns Str is native($llvm) is export {*}
sub LLVMGetStringAttributeValue(LLVMAttributeRef, size_t is rw) returns Str is native($llvm) is export {*}
sub LLVMIsEnumAttribute(LLVMAttributeRef) returns int32 is native($llvm) is export {*}
sub LLVMIsStringAttribute(LLVMAttributeRef) returns int32 is native($llvm) is export {*}

#| Modules
sub LLVMModuleCreateWithName(Str)                          returns LLVMModuleRef is native($llvm) is export {*}
sub LLVMModuleCreateWithNameInContext(Str, LLVMContextRef) returns LLVMModuleRef is native($llvm) is export {*}
sub LLVMCloneModule(LLVMModuleRef)                         returns LLVMModuleRef is native($llvm) is export {*}
sub LLVMDisposeModule(LLVMModuleRef)                                             is native($llvm) is export {*}
sub LLVMGetModuleIdentifier(LLVMModuleRef, size_t is rw)   returns Str           is native($llvm) is export {*}
sub LLVMSetModuleIdentifier(LLVMModuleRef, Str, size_t)                          is native($llvm) is export {*}
sub LLVMGetSourceFileName(LLVMModuleRef, size_t is rw)     returns Str           is native($llvm) is export {*}
sub LLVMSetSourceFileName(LLVMModuleRef, Str, size_t)                            is native($llvm) is export {*}
sub LLVMGetDataLayoutStr(LLVMModuleRef)                    returns Str           is native($llvm) is export {*}
sub LLVMGetDataLayout(LLVMModuleRef)                       returns Str           is native($llvm) is export {*}
sub LLVMSetDataLayout(LLVMModuleRef, Str)                                        is native($llvm) is export {*}
sub LLVMGetTarget(LLVMModuleRef)                           returns Str           is native($llvm) is export {*}
sub LLVMSetTarget(LLVMModuleRef, Str)                                            is native($llvm) is export {*}

sub LLVMCopyModuleFlagsMetadata(LLVMModuleRef, size_t is rw)         returns CArray[int32] is native($llvm) is export {*}
sub LLVMDisposeModuleFlagsMetadata(CArray[int32])                                          is native($llvm) is export {*}
sub LLVMModuleFlagEntriesGetFlagBehavior(CArray[int32], size_t)      returns int32         is native($llvm) is export {*}
sub LLVMModuleFlagEntriesGetKey(CArray[int32], size_t, size_t is rw) returns Str           is native($llvm) is export {*}

sub LLVMModuleFlagEntriesGetMetadata(CArray[int32], size_t)               returns LLVMMetadataRef is native($llvm) is export {*}
sub LLVMGetModuleFlag(LLVMModuleRef, Str, size_t)                         returns LLVMMetadataRef is native($llvm) is export {*}
sub LLVMAddModuleFlag(LLVMModuleRef, int32, Str, size_t, LLVMMetadataRef)                         is native($llvm) is export {*}
sub LLVMDumpModule(LLVMModuleRef)                                                                 is native($llvm) is export {*}
sub LLVMPrintModuleToFile(LLVMModuleRef, Str, Str is rw)                  returns int32           is native($llvm) is export {*}
sub LLVMPrintModuleToString(LLVMModuleRef)                                returns Str             is native($llvm) is export {*}

sub LLVMGetModuleInlineAsm(LLVMModuleRef, size_t is rw)                          returns Str            is native($llvm) is export {*}
sub LLVMSetModuleInlineAsm2(LLVMModuleRef, Str, size_t)                                                 is native($llvm) is export {*}
sub LLVMAppendModuleInlineAsm(LLVMModuleRef, Str, size_t)                                               is native($llvm) is export {*}
sub LLVMGetInlineAsm(LLVMTypeRef, Str, size_t, Str, size_t, int32, int32, int32) returns LLVMValueRef   is native($llvm) is export {*}
sub LLVMGetModuleContext(LLVMModuleRef)                                          returns LLVMContextRef is native($llvm) is export {*}
sub LLVMGetTypeByName(LLVMModuleRef, Str)                                        returns LLVMTypeRef    is native($llvm) is export {*}

sub LLVMGetFirstNamedMetadata(LLVMModuleRef)                             returns LLVMNamedMDNodeRef is native($llvm) is export {*}
sub LLVMGetLastNamedMetadata(LLVMModuleRef)                              returns LLVMNamedMDNodeRef is native($llvm) is export {*}
sub LLVMGetNextNamedMetadata(LLVMNamedMDNodeRef)                         returns LLVMNamedMDNodeRef is native($llvm) is export {*}
sub LLVMGetPreviousNamedMetadata(LLVMNamedMDNodeRef)                     returns LLVMNamedMDNodeRef is native($llvm) is export {*}
sub LLVMGetNamedMetadata(LLVMModuleRef, Str, size_t)                     returns LLVMNamedMDNodeRef is native($llvm) is export {*}
sub LLVMGetOrInsertNamedMetadata(LLVMModuleRef, Str, size_t)             returns LLVMNamedMDNodeRef is native($llvm) is export {*}
sub LLVMGetNamedMetadataName(LLVMNamedMDNodeRef, size_t is rw)           returns Str                is native($llvm) is export {*}
sub LLVMGetNamedMetadataNumOperands(LLVMModuleRef, Str)                  returns size_t             is native($llvm) is export {*}
sub LLVMGetNamedMetadataOperands(LLVMModuleRef, Str, CArray[LLVMValueRef])                          is native($llvm) is export {*}
sub LLVMAddNamedMetadataOperand(LLVMModuleRef, Str, LLVMValueRef)                                   is native($llvm) is export {*}

sub LLVMGetDebugLocDirectory(LLVMValueRef, size_t is rw) returns Str          is native($llvm) is export {*}
sub LLVMGetDebugLocFilename(LLVMValueRef, size_t is rw)  returns Str          is native($llvm) is export {*}
sub LLVMGetDebugLocLine(LLVMValueRef)                    returns size_t       is native($llvm) is export {*}
sub LLVMGetDebugLocColumn(LLVMValueRef)                  returns size_t       is native($llvm) is export {*}
sub LLVMAddFunction(LLVMModuleRef, Str, LLVMTypeRef)     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNamedFunction(LLVMModuleRef, Str)             returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetFirstFunction(LLVMModuleRef)                  returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetLastFunction(LLVMModuleRef)                   returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNextFunction(LLVMValueRef)                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetPreviousFunction(LLVMValueRef)                returns LLVMValueRef is native($llvm) is export {*}
sub LLVMSetModuleInlineAsm(LLVMModuleRef, Str)                                is native($llvm) is export {*}

#| Types
sub LLVMGetTypeKind(LLVMTypeRef)       returns int32          is native($llvm) is export {*}
sub LLVMTypeIsSized(LLVMTypeRef)       returns int32          is native($llvm) is export {*}
sub LLVMGetTypeContext(LLVMTypeRef)    returns LLVMContextRef is native($llvm) is export {*}
sub LLVMDumpType(LLVMTypeRef)                                 is native($llvm) is export {*}
sub LLVMPrintTypeToString(LLVMTypeRef) returns Str            is native($llvm) is export {*}

sub LLVMInt1TypeInContext(LLVMContextRef)        returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt8TypeInContext(LLVMContextRef)        returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt16TypeInContext(LLVMContextRef)       returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt32TypeInContext(LLVMContextRef)       returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt64TypeInContext(LLVMContextRef)       returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt128TypeInContext(LLVMContextRef)      returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMIntTypeInContext(LLVMContextRef, size_t) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt1Type                                 returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt8Type                                 returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt16Type                                returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt32Type                                returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt64Type                                returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMInt128Type                               returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMIntType(size_t)                          returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMGetIntTypeWidth(LLVMTypeRef)             returns size_t      is native($llvm) is export {*}

sub LLVMHalfTypeInContext(LLVMContextRef)     returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMFloatTypeInContext(LLVMContextRef)    returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMDoubleTypeInContext(LLVMContextRef)   returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMX86FP80TypeInContext(LLVMContextRef)  returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMFP128TypeInContext(LLVMContextRef)    returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMPPCFP128TypeInContext(LLVMContextRef) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMHalfType                              returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMFloatType                             returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMDoubleType                            returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMX86FP80Type                           returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMFP128Type                             returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMPPCFP128Type                          returns LLVMTypeRef is native($llvm) is export {*}

sub LLVMFunctionType(LLVMTypeRef, CArray[LLVMTypeRef], size_t, int32) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMIsFunctionVarArg(LLVMTypeRef)                                 returns int32       is native($llvm) is export {*}
sub LLVMGetReturnType(LLVMTypeRef)                                    returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMCountParamTypes(LLVMTypeRef)                                  returns size_t      is native($llvm) is export {*}
sub LLVMGetParamTypes(LLVMTypeRef, CArray[LLVMTypeRef])                                   is native($llvm) is export {*}

sub LLVMStructTypeInContext(LLVMContextRef, CArray[LLVMTypeRef], size_t, int32) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMStructType(CArray[LLVMTypeRef], size_t, int32)                          returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMStructCreateNamed(LLVMContextRef, Str)                                  returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMGetStructName(LLVMTypeRef)                                              returns Str         is native($llvm) is export {*}
sub LLVMStructSetBody(LLVMTypeRef, CArray[LLVMTypeRef], size_t, int32)                              is native($llvm) is export {*}
sub LLVMCountStructElementTypes(LLVMTypeRef)                                    returns size_t      is native($llvm) is export {*}
sub LLVMGetStructElementTypes(LLVMTypeRef, CArray[LLVMTypeRef])                                     is native($llvm) is export {*}
sub LLVMStructGetTypeAtIndex(LLVMTypeRef, size_t)                               returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMIsPackedStruct(LLVMTypeRef)                                             returns int32       is native($llvm) is export {*}
sub LLVMIsOpaqueStruct(LLVMTypeRef)                                             returns int32       is native($llvm) is export {*}
sub LLVMIsLiteralStruct(LLVMTypeRef)                                            returns int32       is native($llvm) is export {*}

sub LLVMGetElementType(LLVMTypeRef)                   returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMGetSubtypes(LLVMTypeRef, CArray[LLVMTypeRef])                     is native($llvm) is export {*}
sub LLVMGetNumContainedTypes(LLVMTypeRef)             returns size_t      is native($llvm) is export {*}
sub LLVMArrayType(LLVMTypeRef, size_t)                returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMGetArrayLength(LLVMTypeRef)                   returns size_t      is native($llvm) is export {*}
sub LLVMPointerType(LLVMTypeRef, size_t)              returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMGetPointerAddressSpace(LLVMTypeRef)           returns size_t      is native($llvm) is export {*}
sub LLVMVectorType(LLVMTypeRef, size_t)               returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMGetVectorSize(LLVMTypeRef)                    returns size_t      is native($llvm) is export {*}

sub LLVMVoidTypeInContext(LLVMContextRef)     returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMLabelTypeInContext(LLVMContextRef)    returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMX86MMXTypeInContext(LLVMContextRef)   returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMTokenTypeInContext(LLVMContextRef)    returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMMetadataTypeInContext(LLVMContextRef) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMVoidType                              returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMLabelType                             returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMX86MMXType                            returns LLVMTypeRef is native($llvm) is export {*}

#| Values
sub LLVMTypeOf(LLVMValueRef)                      returns LLVMTypeRef  is native($llvm) is export {*}
sub LLVMGetValueKind(LLVMValueRef)                returns int32        is native($llvm) is export {*}
sub LLVMGetValueName2(LLVMValueRef, size_t is rw) returns Str          is native($llvm) is export {*}
sub LLVMSetValueName2(LLVMValueRef, Str, size_t)                       is native($llvm) is export {*}
sub LLVMDumpValue(LLVMValueRef)                                        is native($llvm) is export {*}
sub LLVMPrintValueToString(LLVMValueRef)          returns Str          is native($llvm) is export {*}
sub LLVMReplaceAllUsesWith(LLVMValueRef, LLVMValueRef)                 is native($llvm) is export {*}
sub LLVMIsConstant(LLVMValueRef)                  returns int32        is native($llvm) is export {*}
sub LLVMIsUndef(LLVMValueRef)                     returns int32        is native($llvm) is export {*}
sub LLVMIsAMDNode(LLVMValueRef)                   returns LLVMValueRef is native($llvm) is export {*}
sub LLVMIsAMDString(LLVMValueRef)                 returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetValueName(LLVMValueRef)                returns Str          is native($llvm) is export {*}
sub LLVMSetValueName(LLVMValueRef, Str)                                is native($llvm) is export {*}

sub LLVMGetFirstUse(LLVMValueRef) returns LLVMUseRef   is native($llvm) is export {*}
sub LLVMGetNextUse(LLVMUseRef)    returns LLVMUseRef   is native($llvm) is export {*}
sub LLVMGetUser(LLVMUseRef)       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetUsedValue(LLVMUseRef)  returns LLVMValueRef is native($llvm) is export {*}

sub LLVMGetOperand(LLVMValueRef, size_t)               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetOperandUse(LLVMValueRef, size_t)            returns LLVMUseRef   is native($llvm) is export {*}
sub LLVMSetOperand(LLVMValueRef, size_t, LLVMValueRef)                      is native($llvm) is export {*}
sub LLVMGetNumOperands(LLVMValueRef)                   returns int32        is native($llvm) is export {*}

sub LLVMConstNull(LLVMTypeRef)        returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstAllOnes(LLVMTypeRef)     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetUndef(LLVMTypeRef)         returns LLVMValueRef is native($llvm) is export {*}
sub LLVMIsNull(LLVMValueRef)          returns int32        is native($llvm) is export {*}
sub LLVMConstPointerNull(LLVMTypeRef) returns LLVMValueRef is native($llvm) is export {*}

sub LLVMConstInt(LLVMTypeRef, ulonglong, int32)                           returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstIntOfArbitraryPrecision(LLVMTypeRef, size_t, CArray[uint64]) returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstIntOfString(LLVMTypeRef, Str, uint8)                         returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstIntOfStringAndSize(LLVMTypeRef, Str, size_t, uint8)          returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstReal(LLVMTypeRef, num64)                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstRealOfString(LLVMTypeRef, Str)                               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstRealOfStringAndSize(LLVMTypeRef, Str, size_t)                returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstIntGetZExtValue(LLVMValueRef)                                returns ulonglong    is native($llvm) is export {*}
sub LLVMConstIntGetSExtValue(LLVMValueRef)                                returns longlong     is native($llvm) is export {*}
sub LLVMConstRealGetDouble(LLVMValueRef, int32 is rw)                     returns num64        is native($llvm) is export {*}

sub LLVMConstStringInContext(LLVMContextRef, Str, size_t, int32)    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstString(Str, size_t, int32)                             returns LLVMValueRef is native($llvm) is export {*}
sub LLVMIsConstantString(LLVMValueRef)                              returns int32        is native($llvm) is export {*}
sub LLVMGetAsString(LLVMValueRef, size_t is rw)                     returns Str          is native($llvm) is export {*}
sub LLVMConstStructInContext(LLVMContextRef, CArray[LLVMValueRef], size_t, int32) returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstStruct(CArray[LLVMValueRef], size_t, int32)            returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstArray(LLVMTypeRef, CArray[LLVMValueRef], size_t)       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNamedStruct(LLVMTypeRef, CArray[LLVMValueRef], size_t) returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetElementAsConstant(LLVMValueRef, size_t)                  returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstVector(CArray[LLVMValueRef], size_t)                   returns LLVMValueRef is native($llvm) is export {*}

sub LLVMGetConstOpcode(LLVMValueRef)                                               returns int32        is native($llvm) is export {*}
sub LLVMAlignOf(LLVMTypeRef)                                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMSizeOf(LLVMTypeRef)                                                        returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNeg(LLVMValueRef)                                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNSWNeg(LLVMValueRef)                                                  returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNUWNeg(LLVMValueRef)                                                  returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFNeg(LLVMValueRef)                                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNot(LLVMValueRef)                                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstAdd(LLVMValueRef, LLVMValueRef)                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNSWAdd(LLVMValueRef, LLVMValueRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNUWAdd(LLVMValueRef, LLVMValueRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFAdd(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstSub(LLVMValueRef, LLVMValueRef)                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNSWSub(LLVMValueRef, LLVMValueRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNUWSub(LLVMValueRef, LLVMValueRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFSub(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstMul(LLVMValueRef, LLVMValueRef)                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNSWMul(LLVMValueRef, LLVMValueRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstNUWMul(LLVMValueRef, LLVMValueRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFMul(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstUDiv(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstExactUDiv(LLVMValueRef, LLVMValueRef)                                 returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstSDiv(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstExactSDiv(LLVMValueRef, LLVMValueRef)                                 returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFDiv(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstURem(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstSRem(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFRem(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstAnd(LLVMValueRef, LLVMValueRef)                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstOr(LLVMValueRef, LLVMValueRef)                                        returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstXor(LLVMValueRef, LLVMValueRef)                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstICmp(int32, LLVMValueRef, LLVMValueRef)                               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFCmp(int32, LLVMValueRef, LLVMValueRef)                               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstShl(LLVMValueRef, LLVMValueRef)                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstLShr(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstAShr(LLVMValueRef, LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstGEP(LLVMValueRef, CArray[LLVMValueRef], size_t)                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstGEP2(LLVMTypeRef, LLVMValueRef, CArray[LLVMValueRef], size_t)         returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstInBoundsGEP(LLVMValueRef, CArray[LLVMValueRef], size_t)               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstInBoundsGEP2(LLVMTypeRef, LLVMValueRef, CArray[LLVMValueRef], size_t) returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstTrunc(LLVMValueRef, LLVMTypeRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstSExt(LLVMValueRef, LLVMTypeRef)                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstZExt(LLVMValueRef, LLVMTypeRef)                                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFPTrunc(LLVMValueRef, LLVMTypeRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFPExt(LLVMValueRef, LLVMTypeRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstUIToFP(LLVMValueRef, LLVMTypeRef)                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstSIToFP(LLVMValueRef, LLVMTypeRef)                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFPToUI(LLVMValueRef, LLVMTypeRef)                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFPToSI(LLVMValueRef, LLVMTypeRef)                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstPtrToInt(LLVMValueRef, LLVMTypeRef)                                   returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstIntToPtr(LLVMValueRef, LLVMTypeRef)                                   returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstBitCast(LLVMValueRef, LLVMTypeRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstAddrSpaceCast(LLVMValueRef, LLVMTypeRef)                              returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstZExtOrBitCast(LLVMValueRef, LLVMTypeRef)                              returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstSExtOrBitCast(LLVMValueRef, LLVMTypeRef)                              returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstTruncOrBitCast(LLVMValueRef, LLVMTypeRef)                             returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstPointerCast(LLVMValueRef, LLVMTypeRef)                                returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstIntCast(LLVMValueRef, LLVMTypeRef, int32)                             returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstFPCast(LLVMValueRef, LLVMTypeRef)                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstSelect(LLVMValueRef, LLVMValueRef, LLVMValueRef)                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstExtractElement(LLVMValueRef, LLVMValueRef)                            returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstInsertElement(LLVMValueRef, LLVMValueRef, LLVMValueRef)               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstShuffleVector(LLVMValueRef, LLVMValueRef, LLVMValueRef)               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstExtractValue(LLVMValueRef, CArray[size_t], size_t)                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstInsertValue(LLVMValueRef, LLVMValueRef, CArray[size_t], size_t)       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMBlockAddress(LLVMValueRef, LLVMBasicBlockRef)                              returns LLVMValueRef is native($llvm) is export {*}
sub LLVMConstInlineAsm(LLVMTypeRef, Str, Str, int32, int32)                        returns LLVMValueRef is native($llvm) is export {*}

sub LLVMGetGlobalParent(LLVMValueRef)                                           returns LLVMModuleRef                  is native($llvm) is export {*}
sub LLVMIsDeclaration(LLVMValueRef)                                             returns int32                          is native($llvm) is export {*}
sub LLVMGetLinkage(LLVMValueRef)                                                returns int32                          is native($llvm) is export {*}
sub LLVMSetLinkage(LLVMValueRef, int32)                                                                                is native($llvm) is export {*}
sub LLVMGetSection(LLVMValueRef)                                                returns Str                            is native($llvm) is export {*}
sub LLVMSetSection(LLVMValueRef, Str)                                                                                  is native($llvm) is export {*}
sub LLVMGetVisibility(LLVMValueRef)                                             returns int32                          is native($llvm) is export {*}
sub LLVMSetVisibility(LLVMValueRef, int32)                                                                             is native($llvm) is export {*}
sub LLVMGetDLLStorageClass(LLVMValueRef)                                        returns int32                          is native($llvm) is export {*}
sub LLVMSetDLLStorageClass(LLVMValueRef, int32)                                                                        is native($llvm) is export {*}
sub LLVMGetUnnamedAddress(LLVMValueRef)                                         returns int32                          is native($llvm) is export {*}
sub LLVMSetUnnamedAddress(LLVMValueRef, int32)                                                                         is native($llvm) is export {*}
sub LLVMGlobalGetValueType(LLVMValueRef)                                        returns LLVMTypeRef                    is native($llvm) is export {*}
sub LLVMHasUnnamedAddr(LLVMValueRef)                                            returns int32                          is native($llvm) is export {*}
sub LLVMSetUnnamedAddr(LLVMValueRef, int32)                                                                            is native($llvm) is export {*}
sub LLVMGetAlignment(LLVMValueRef)                                              returns size_t                         is native($llvm) is export {*}
sub LLVMSetAlignment(LLVMValueRef, size_t)                                                                             is native($llvm) is export {*}
sub LLVMGlobalSetMetadata(LLVMValueRef, size_t, LLVMMetadataRef)                                                       is native($llvm) is export {*}
sub LLVMGlobalEraseMetadata(LLVMValueRef, size_t)                                                                      is native($llvm) is export {*}
sub LLVMGlobalClearMetadata(LLVMValueRef)                                                                              is native($llvm) is export {*}
sub LLVMGlobalCopyAllMetadata(LLVMValueRef, size_t is rw)                       returns CArray[LLVMValueMetadataEntry] is native($llvm) is export {*}
sub LLVMDisposeValueMetadataEntries(CArray[LLVMValueMetadataEntry])                                                    is native($llvm) is export {*}
sub LLVMValueMetadataEntriesGetKind(CArray[LLVMValueMetadataEntry], size_t)     returns size_t                         is native($llvm) is export {*}
sub LLVMValueMetadataEntriesGetMetadata(CArray[LLVMValueMetadataEntry], size_t) returns LLVMMetadataRef                is native($llvm) is export {*}

sub LLVMAddGlobal(LLVMModuleRef, LLVMTypeRef, Str)                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMAddGlobalInAddressSpace(LLVMModuleRef, LLVMTypeRef, Str, size_t) returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNamedGlobal(LLVMModuleRef, Str)                               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetFirstGlobal(LLVMModuleRef)                                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetLastGlobal(LLVMModuleRef)                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNextGlobal(LLVMValueRef)                                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetPreviousGlobal(LLVMValueRef)                                  returns LLVMValueRef is native($llvm) is export {*}
sub LLVMDeleteGlobal(LLVMValueRef)                                                            is native($llvm) is export {*}
sub LLVMGetInitializer(LLVMValueRef)                                     returns LLVMValueRef is native($llvm) is export {*}
sub LLVMSetInitializer(LLVMValueRef, LLVMValueRef)                                            is native($llvm) is export {*}
sub LLVMIsThreadLocal(LLVMValueRef)                                      returns int32        is native($llvm) is export {*}
sub LLVMSetThreadLocal(LLVMValueRef, int32)                                                   is native($llvm) is export {*}
sub LLVMIsGlobalConstant(LLVMValueRef)                                   returns int32        is native($llvm) is export {*}
sub LLVMSetGlobalConstant(LLVMValueRef, int32)                                                is native($llvm) is export {*}
sub LLVMGetThreadLocalMode(LLVMValueRef)                                 returns int32        is native($llvm) is export {*}
sub LLVMSetThreadLocalMode(LLVMValueRef, int32)                                               is native($llvm) is export {*}
sub LLVMIsExternallyInitialized(LLVMValueRef)                            returns int32        is native($llvm) is export {*}
sub LLVMSetExternallyInitialized(LLVMValueRef, int32)                                         is native($llvm) is export {*}

sub LLVMAddAlias(LLVMModuleRef, LLVMTypeRef, LLVMValueRef, Str) returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNamedGlobalAlias(LLVMModuleRef, Str, size_t)         returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetFirstGlobalAlias(LLVMModuleRef)                      returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetLastGlobalAlias(LLVMModuleRef)                       returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNextGlobalAlias(LLVMValueRef)                        returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetPreviousGlobalAlias(LLVMValueRef)                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMAliasGetAliasee(LLVMValueRef)                           returns LLVMValueRef is native($llvm) is export {*}
sub LLVMAliasSetAliasee(LLVMValueRef, LLVMValueRef)                                  is native($llvm) is export {*}

#func stuff
sub LLVMCountParams(LLVMValueRef)                     returns size_t       is native($llvm) is export {*}
sub LLVMGetParams(LLVMValueRef, CArray[LLVMValueRef])                      is native($llvm) is export {*}
sub LLVMGetParam(LLVMValueRef, size_t)                returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetParamParent(LLVMValueRef)                  returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetFirstParam(LLVMValueRef)                   returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetLastParam(LLVMValueRef)                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNextParam(LLVMValueRef)                    returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetPreviousParam(LLVMValueRef)                returns LLVMValueRef is native($llvm) is export {*}
sub LLVMSetParamAlignment(LLVMValueRef, size_t)                            is native($llvm) is export {*}

sub LLVMAddGlobalIFunc(LLVMModuleRef, Str, size_t, LLVMTypeRef, size_t, LLVMValueRef) returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNamedGlobalIFunc(LLVMModuleRef, Str, size_t)                               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetFirstGlobalIFunc(LLVMModuleRef)                                            returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetLastGlobalIFunc(LLVMModuleRef)                                             returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetNextGlobalIFunc(LLVMValueRef)                                              returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetPreviousGlobalIFunc(LLVMValueRef)                                          returns LLVMValueRef is native($llvm) is export {*}
sub LLVMGetGlobalIFuncResolver(LLVMValueRef)                                          returns LLVMValueRef is native($llvm) is export {*}
sub LLVMSetGlobalIFuncResolver(LLVMValueRef, LLVMValueRef)                                                 is native($llvm) is export {*}
sub LLVMEraseGlobalIFunc(LLVMValueRef)                                                                     is native($llvm) is export {*}
sub LLVMRemoveGlobalIFunc(LLVMValueRef)                                                                    is native($llvm) is export {*}

sub LLVMDeleteFunction(LLVMValueRef)                                                                            is native($llvm) is export {*}
sub LLVMHasPersonalityFn(LLVMValueRef)                                                 returns int32            is native($llvm) is export {*}
sub LLVMGetPersonalityFn(LLVMValueRef)                                                 returns LLVMValueRef     is native($llvm) is export {*}
sub LLVMSetPersonalityFn(LLVMValueRef, LLVMValueRef)                                                            is native($llvm) is export {*}
sub LLVMLookupIntrinsicID(Str, size_t)                                                 returns size_t           is native($llvm) is export {*}
sub LLVMGetIntrinsicID(LLVMValueRef)                                                   returns size_t           is native($llvm) is export {*}
sub LLVMGetIntrinsicDeclaration(LLVMModuleRef, size_t, CArray[LLVMTypeRef], size_t)    returns LLVMValueRef     is native($llvm) is export {*}
sub LLVMIntrinsicGetType(LLVMContextRef, size_t, CArray[LLVMTypeRef], size_t)          returns LLVMTypeRef      is native($llvm) is export {*}
sub LLVMIntrinsicGetName(size_t, size_t is rw)                                         returns Str              is native($llvm) is export {*}
sub LLVMIntrinsicCopyOverloadedName(size_t, CArray[LLVMTypeRef], size_t, size_t is rw) returns Str              is native($llvm) is export {*}
sub LLVMIntrinsicIsOverloaded(size_t)                                                  returns int32            is native($llvm) is export {*}
sub LLVMGetFunctionCallConv(LLVMValueRef)                                              returns size_t           is native($llvm) is export {*}
sub LLVMSetFunctionCallConv(LLVMValueRef, size_t)                                                               is native($llvm) is export {*}
sub LLVMGetGC(LLVMValueRef)                                                            returns Str              is native($llvm) is export {*}
sub LLVMSetGC(LLVMValueRef, Str)                                                                                is native($llvm) is export {*}
sub LLVMAddAttributeAtIndex(LLVMValueRef, size_t, LLVMAttributeRef)                                             is native($llvm) is export {*}
sub LLVMGetAttributeCountAtIndex(LLVMValueRef, size_t)                                 returns size_t           is native($llvm) is export {*}
sub LLVMGetAttributesAtIndex(LLVMValueRef, size_t, CArray[LLVMAttributeRef])                                    is native($llvm) is export {*}
sub LLVMGetEnumAttributeAtIndex(LLVMValueRef, size_t, size_t)                          returns LLVMAttributeRef is native($llvm) is export {*}
sub LLVMGetStringAttributeAtIndex(LLVMValueRef, size_t, Str, size_t)                   returns LLVMAttributeRef is native($llvm) is export {*}
sub LLVMRemoveEnumAttributeAtIndex(LLVMValueRef, size_t, size_t)                                                is native($llvm) is export {*}
sub LLVMRemoveStringAttributeAtIndex(LLVMValueRef, size_t, Str, size_t)                                         is native($llvm) is export {*}
sub LLVMAddTargetDependentFunctionAttr(LLVMValueRef, Str, Str)                                                  is native($llvm) is export {*}

#| Metadata
sub LLVMMDStringInContext2(LLVMContextRef, Str, size_t)                   returns LLVMMetadataRef is native($llvm) is export {*}
sub LLVMMDNodeInContext2(LLVMContextRef, CArray[LLVMMetadataRef], size_t) returns LLVMMetadataRef is native($llvm) is export {*}
sub LLVMMetadataAsValue(LLVMContextRef, LLVMMetadataRef)                  returns LLVMValueRef    is native($llvm) is export {*}
sub LLVMValueAsMetadata(LLVMValueRef)                                     returns LLVMMetadataRef is native($llvm) is export {*}
sub LLVMGetMDString(LLVMValueRef, size_t is rw)                           returns Str             is native($llvm) is export {*}
sub LLVMGetMDNodeNumOperands(LLVMValueRef)                                returns size_t          is native($llvm) is export {*}
sub LLVMGetMDNodeOperands(LLVMValueRef, CArray[LLVMValueRef])                                     is native($llvm) is export {*}
sub LLVMMDStringInContext(LLVMContextRef, Str, size_t)                    returns LLVMValueRef    is native($llvm) is export {*}
sub LLVMMDString(Str, size_t)                                             returns LLVMValueRef    is native($llvm) is export {*}
sub LLVMMDNodeInContext(LLVMContextRef, CArray[LLVMValueRef], size_t)     returns LLVMValueRef    is native($llvm) is export {*}
sub LLVMMDNode(CArray[LLVMValueRef], size_t)                              returns LLVMValueRef    is native($llvm) is export {*}

#| Basic Blocks
sub LLVMBasicBlockAsValue(LLVMBasicBlockRef)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMValueIsBasicBlock(LLVMValueRef)                                             returns int32             is native($llvm) is export {*}
sub LLVMValueAsBasicBlock(LLVMValueRef)                                             returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMGetBasicBlockName(LLVMBasicBlockRef)                                        returns Str               is native($llvm) is export {*}
sub LLVMGetBasicBlockParent(LLVMBasicBlockRef)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMGetBasicBlockTerminator(LLVMBasicBlockRef)                                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMCountBasicBlocks(LLVMValueRef)                                              returns size_t            is native($llvm) is export {*}
sub LLVMGetBasicBlocks(LLVMValueRef, CArray[LLVMBasicBlockRef])                                               is native($llvm) is export {*}
sub LLVMGetFirstBasicBlock(LLVMValueRef)                                            returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMGetLastBasicBlock(LLVMValueRef)                                             returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMGetNextBasicBlock(LLVMBasicBlockRef)                                        returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMGetPreviousBasicBlock(LLVMBasicBlockRef)                                    returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMGetEntryBasicBlock(LLVMValueRef)                                            returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMInsertExistingBasicBlockAfterInsertBlock(LLVMBuilderRef, LLVMBasicBlockRef)                           is native($llvm) is export {*}
sub LLVMAppendExistingBasicBlock(LLVMValueRef, LLVMBasicBlockRef)                                             is native($llvm) is export {*}
sub LLVMCreateBasicBlockInContext(LLVMContextRef, Str)                              returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMAppendBasicBlockInContext(LLVMContextRef, LLVMValueRef, Str)                returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMAppendBasicBlock(LLVMValueRef, Str)                                         returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMInsertBasicBlockInContext(LLVMContextRef, LLVMBasicBlockRef, Str)           returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMInsertBasicBlock(LLVMBasicBlockRef, Str)                                    returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMDeleteBasicBlock(LLVMBasicBlockRef)                                                                   is native($llvm) is export {*}
sub LLVMRemoveBasicBlockFromParent(LLVMBasicBlockRef)                                                         is native($llvm) is export {*}
sub LLVMMoveBasicBlockBefore(LLVMBasicBlockRef, LLVMBasicBlockRef)                                            is native($llvm) is export {*}
sub LLVMMoveBasicBlockAfter(LLVMBasicBlockRef, LLVMBasicBlockRef)                                             is native($llvm) is export {*}
sub LLVMGetFirstInstruction(LLVMBasicBlockRef)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMGetLastInstruction(LLVMBasicBlockRef)                                       returns LLVMValueRef      is native($llvm) is export {*}

#| Instructions
sub LLVMHasMetadata(LLVMValueRef)                       returns int32             is native($llvm) is export {*}
sub LLVMGetMetadata(LLVMValueRef, size_t)               returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMSetMetadata(LLVMValueRef, size_t, LLVMValueRef)                           is native($llvm) is export {*}
sub LLVMInstructionGetAllMetadataOtherThanDebugLoc(LLVMValueRef, size_t is rw) returns CArray[LLVMValueMetadataEntry] is native($llvm) is export {*}
sub LLVMGetInstructionParent(LLVMValueRef)              returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMGetNextInstruction(LLVMValueRef)                returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMGetPreviousInstruction(LLVMValueRef)            returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMInstructionRemoveFromParent(LLVMValueRef)                                 is native($llvm) is export {*}
sub LLVMInstructionEraseFromParent(LLVMValueRef)                                  is native($llvm) is export {*}
sub LLVMGetInstructionOpcode(LLVMValueRef)              returns int32             is native($llvm) is export {*}
sub LLVMGetICmpPredicate(LLVMValueRef)                  returns int32             is native($llvm) is export {*}
sub LLVMGetFCmpPredicate(LLVMValueRef)                  returns int32             is native($llvm) is export {*}
sub LLVMInstructionClone(LLVMValueRef)                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMIsATerminatorInst(LLVMValueRef)                 returns LLVMValueRef      is native($llvm) is export {*}

sub LLVMGetNumArgOperands(LLVMValueRef)                                       returns size_t            is native($llvm) is export {*}
sub LLVMSetInstructionCallConv(LLVMValueRef, size_t)                                                    is native($llvm) is export {*}
sub LLVMGetInstructionCallConv(LLVMValueRef)                                  returns size_t            is native($llvm) is export {*}
sub LLVMSetInstrParamAlignment(LLVMValueRef, size_t, size_t)                                            is native($llvm) is export {*}
sub LLVMAddCallSiteAttribute(LLVMValueRef, size_t, LLVMAttributeRef)                                    is native($llvm) is export {*}
sub LLVMGetCallSiteAttributeCount(LLVMValueRef, size_t)                       returns size_t            is native($llvm) is export {*}
sub LLVMGetCallSiteAttributes(LLVMValueRef, size_t, CArray[LLVMAttributeRef])                           is native($llvm) is export {*}
sub LLVMGetCallSiteEnumAttribute(LLVMValueRef, size_t, size_t)                returns LLVMAttributeRef  is native($llvm) is export {*}
sub LLVMGetCallSiteStringAttribute(LLVMValueRef, size_t, Str, size_t)         returns LLVMAttributeRef  is native($llvm) is export {*}
sub LLVMRemoveCallSiteEnumAttribute(LLVMValueRef, size_t, size_t)                                       is native($llvm) is export {*}
sub LLVMRemoveCallSiteStringAttribute(LLVMValueRef, size_t, Str, size_t)                                is native($llvm) is export {*}
sub LLVMGetCalledFunctionType(LLVMValueRef)                                   returns LLVMTypeRef       is native($llvm) is export {*}
sub LLVMGetCalledValue(LLVMValueRef)                                          returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMIsTailCall(LLVMValueRef)                                              returns int32             is native($llvm) is export {*}
sub LLVMSetTailCall(LLVMValueRef, int32)                                                                is native($llvm) is export {*}
sub LLVMGetNormalDest(LLVMValueRef)                                           returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMGetUnwindDest(LLVMValueRef)                                           returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMSetNormalDest(LLVMValueRef, LLVMBasicBlockRef)                                                  is native($llvm) is export {*}
sub LLVMSetUnwindDest(LLVMValueRef, LLVMBasicBlockRef)                                                  is native($llvm) is export {*}

sub LLVMGetNumSuccessors(LLVMValueRef)                        returns size_t            is native($llvm) is export {*}
sub LLVMGetSuccessor(LLVMValueRef, size_t)                    returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMSetSuccessor(LLVMValueRef, size_t, LLVMBasicBlockRef)                           is native($llvm) is export {*}
sub LLVMIsConditional(LLVMValueRef)                           returns int32             is native($llvm) is export {*}
sub LLVMGetCondition(LLVMValueRef)                            returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMSetCondition(LLVMValueRef, LLVMValueRef)                                        is native($llvm) is export {*}
sub LLVMGetSwitchDefaultDest(LLVMValueRef)                    returns LLVMBasicBlockRef is native($llvm) is export {*}

sub LLVMGetAllocatedType(LLVMValueRef) returns LLVMTypeRef is native($llvm) is export {*}

sub LLVMIsInBounds(LLVMValueRef)           returns int32 is native($llvm) is export {*}
sub LLVMSetIsInBounds(LLVMValueRef, int32)               is native($llvm) is export {*}

sub LLVMAddIncoming(LLVMValueRef, CArray[LLVMValueRef], CArray[LLVMBasicBlockRef], size_t) is native($llvm) is export {*}
sub LLVMCountIncoming(LLVMValueRef)            returns size_t            is native($llvm) is export {*}
sub LLVMGetIncomingValue(LLVMValueRef, size_t) returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMGetIncomingBlock(LLVMValueRef, size_t) returns LLVMBasicBlockRef is native($llvm) is export {*}

sub LLVMGetNumIndices(LLVMValueRef) returns size_t         is native($llvm) is export {*}
sub LLVMGetIndices(LLVMValueRef)    returns CArray[size_t] is native($llvm) is export {*}

#= Instruction Builder
sub LLVMCreateBuilderInContext(LLVMContextRef)                                                          returns LLVMBuilderRef    is native($llvm) is export {*}
sub LLVMCreateBuilder                                                                                   returns LLVMBuilderRef    is native($llvm) is export {*}
sub LLVMPositionBuilder(LLVMBuilderRef, LLVMBasicBlockRef, LLVMValueRef)                                                          is native($llvm) is export {*}
sub LLVMPositionBuilderBefore(LLVMBuilderRef, LLVMValueRef)                                                                       is native($llvm) is export {*}
sub LLVMPositionBuilderAtEnd(LLVMBuilderRef, LLVMBasicBlockRef)                                                                   is native($llvm) is export {*}
sub LLVMGetInsertBlock(LLVMBuilderRef)                                                                  returns LLVMBasicBlockRef is native($llvm) is export {*}
sub LLVMClearInsertionPosition(LLVMBuilderRef)                                                                                    is native($llvm) is export {*}
sub LLVMInsertIntoBuilder(LLVMBuilderRef, LLVMValueRef)                                                                           is native($llvm) is export {*}
sub LLVMInsertIntoBuilderWithName(LLVMBuilderRef, LLVMValueRef, Str)                                                              is native($llvm) is export {*}
sub LLVMDisposeBuilder(LLVMBuilderRef)                                                                                            is native($llvm) is export {*}
sub LLVMGetCurrentDebugLocation2(LLVMBuilderRef)                                                        returns LLVMMetadataRef   is native($llvm) is export {*}
sub LLVMSetCurrentDebugLocation2(LLVMBuilderRef, LLVMMetadataRef)                                                                 is native($llvm) is export {*}
sub LLVMSetInstDebugLocation(LLVMBuilderRef, LLVMValueRef)                                                                        is native($llvm) is export {*}
sub LLVMBuilderGetDefaultFPMathTag(LLVMBuilderRef)                                                      returns LLVMMetadataRef   is native($llvm) is export {*}
sub LLVMBuilderSetDefaultFPMathTag(LLVMBuilderRef, LLVMMetadataRef)                                                               is native($llvm) is export {*}
sub LLVMSetCurrentDebugLocation(LLVMBuilderRef, LLVMValueRef)                                                                     is native($llvm) is export {*}
sub LLVMGetCurrentDebugLocation(LLVMBuilderRef)                                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildRetVoid(LLVMBuilderRef)                                                                    returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildRet(LLVMBuilderRef, LLVMValueRef)                                                          returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildAggregateRet(LLVMBuilderRef, CArray[LLVMValueRef], size_t)                                 returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildBr(LLVMBuilderRef, LLVMBasicBlockRef)                                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCondBr(LLVMBuilderRef, LLVMValueRef, LLVMBasicBlockRef, LLVMBasicBlockRef)                 returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildSwitch(LLVMBuilderRef, LLVMValueRef, LLVMBasicBlockRef, size_t)                            returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildIndirectBr(LLVMBuilderRef, LLVMValueRef, size_t)                                           returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildInvoke(LLVMBuilderRef, LLVMValueRef, CArray[LLVMValueRef], size_t, LLVMBasicBlockRef, LLVMBasicBlockRef, Str)               returns LLVMValueRef is native($llvm) is export {*}
sub LLVMBuildInvoke2(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, CArray[LLVMValueRef], size_t, LLVMBasicBlockRef, LLVMBasicBlockRef, Str) returns LLVMValueRef is native($llvm) is export {*}
sub LLVMBuildUnreachable(LLVMBuilderRef)                                                                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildResume(LLVMBuilderRef, LLVMValueRef)                                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildLandingPad(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, size_t, Str)                           returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCleanupRet(LLVMBuilderRef, LLVMValueRef, LLVMBasicBlockRef)                                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCatchRet(LLVMBuilderRef, LLVMValueRef, LLVMBasicBlockRef)                                    returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCatchPad(LLVMBuilderRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)                    returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCleanupPad(LLVMBuilderRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCatchSwitch(LLVMBuilderRef, LLVMValueRef, LLVMBasicBlockRef, size_t, Str)                    returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMAddCase(LLVMValueRef, LLVMValueRef, LLVMBasicBlockRef)                                                                      is native($llvm) is export {*}
sub LLVMAddDestination(LLVMValueRef, LLVMBasicBlockRef)                                                                             is native($llvm) is export {*}
sub LLVMGetNumClauses(LLVMValueRef)                                                                       returns size_t            is native($llvm) is export {*}
sub LLVMGetClause(LLVMValueRef, size_t)                                                                   returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMAddClause(LLVMValueRef, LLVMValueRef)                                                                                       is native($llvm) is export {*}
sub LLVMIsCleanup(LLVMValueRef)                                                                           returns int32             is native($llvm) is export {*}
sub LLVMSetCleanup(LLVMValueRef, int32)                                                                                             is native($llvm) is export {*}
sub LLVMAddHandler(LLVMValueRef, LLVMBasicBlockRef)                                                                                 is native($llvm) is export {*}
sub LLVMGetNumHandlers(LLVMValueRef)                                                                      returns size_t            is native($llvm) is export {*}
sub LLVMGetHandlers(LLVMValueRef, CArray[LLVMBasicBlockRef])                                                                        is native($llvm) is export {*}
sub LLVMGetArgOperand(LLVMValueRef, size_t)                                                               returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMSetArgOperand(LLVMValueRef, size_t, LLVMValueRef)                                                                           is native($llvm) is export {*}
sub LLVMGetParentCatchSwitch(LLVMValueRef)                                                                returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMSetParentCatchSwitch(LLVMValueRef, LLVMValueRef)                                                                            is native($llvm) is export {*}
sub LLVMBuildAdd(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNSWAdd(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNUWAdd(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFAdd(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildSub(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNSWSub(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNUWSub(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFSub(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildMul(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNSWMul(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNUWMul(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFMul(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildUDiv(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildExactUDiv(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                   returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildSDiv(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildExactSDiv(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                   returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFDiv(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildURem(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildSRem(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFRem(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildShl(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildLShr(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildAShr(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildAnd(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildOr(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                          returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildXor(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildBinOp(LLVMBuilderRef, int32, LLVMValueRef, LLVMValueRef, Str)                                returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNeg(LLVMBuilderRef, LLVMValueRef, Str)                                                       returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNSWNeg(LLVMBuilderRef, LLVMValueRef, Str)                                                    returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNUWNeg(LLVMBuilderRef, LLVMValueRef, Str)                                                    returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFNeg(LLVMBuilderRef, LLVMValueRef, Str)                                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildNot(LLVMBuilderRef, LLVMValueRef, Str)                                                       returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildMalloc(LLVMBuilderRef, LLVMTypeRef, Str)                                                     returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildArrayMalloc(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, Str)                                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildMemSet(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, LLVMValueRef, size_t)                     returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildMemCpy(LLVMBuilderRef, LLVMValueRef, size_t, LLVMValueRef, size_t, LLVMValueRef)             returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildMemMove(LLVMBuilderRef, LLVMValueRef, size_t, LLVMValueRef, size_t, LLVMValueRef)            returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildAlloca(LLVMBuilderRef, LLVMTypeRef, Str)                                                     returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildArrayAlloca(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, Str)                                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFree(LLVMBuilderRef, LLVMValueRef)                                                           returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildLoad(LLVMBuilderRef, LLVMValueRef, Str)                                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildLoad2(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildStore(LLVMBuilderRef, LLVMValueRef, LLVMValueRef)                                            returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildGEP(LLVMBuilderRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildInBoundsGEP(LLVMBuilderRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)                 returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildStructGEP(LLVMBuilderRef, LLVMValueRef, size_t, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildGEP2(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)           returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildInBoundsGEP2(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)   returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildStructGEP2(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, size_t, Str)                           returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildGlobalString(LLVMBuilderRef, Str, Str)                                                       returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildGlobalStringPtr(LLVMBuilderRef, Str, Str)                                                    returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMGetVolatile(LLVMValueRef)                                                                         returns int32             is native($llvm) is export {*}
sub LLVMSetVolatile(LLVMValueRef, int32)                                                                                            is native($llvm) is export {*}
sub LLVMGetOrdering(LLVMValueRef)                                                                         returns int32             is native($llvm) is export {*}
sub LLVMSetOrdering(LLVMValueRef, int32)                                                                                            is native($llvm) is export {*}
sub LLVMBuildTrunc(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildZExt(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildSExt(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFPToUI(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                       returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFPToSI(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                       returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildUIToFP(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                       returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildSIToFP(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                       returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFPTrunc(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFPExt(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildPtrToInt(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                     returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildIntToPtr(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                     returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildBitCast(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildAddrSpaceCast(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildZExtOrBitCast(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildSExtOrBitCast(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildTruncOrBitCast(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                               returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCast(LLVMBuilderRef, int32, LLVMValueRef, LLVMTypeRef, Str)                                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildPointerCast(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                  returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildIntCast2(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, int32, Str)                              returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFPCast(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                       returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildIntCast(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildICmp(LLVMBuilderRef, int32, LLVMValueRef, LLVMValueRef, Str)                                 returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFCmp(LLVMBuilderRef, int32, LLVMValueRef, LLVMValueRef, Str)                                 returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildPhi(LLVMBuilderRef, LLVMTypeRef, Str)                                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCall(LLVMBuilderRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildCall2(LLVMBuilderRef, LLVMTypeRef, LLVMValueRef, CArray[LLVMValueRef], size_t, Str)          returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildSelect(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, LLVMValueRef, Str)                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildVAArg(LLVMBuilderRef, LLVMValueRef, LLVMTypeRef, Str)                                        returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildExtractElement(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                              returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildInsertElement(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, LLVMValueRef, Str)                 returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildShuffleVector(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, LLVMValueRef, Str)                 returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildExtractValue(LLVMBuilderRef, LLVMValueRef, size_t, Str)                                      returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildInsertValue(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, size_t, Str)                         returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildIsNull(LLVMBuilderRef, LLVMValueRef, Str)                                                    returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildIsNotNull(LLVMBuilderRef, LLVMValueRef, Str)                                                 returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildPtrDiff(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, Str)                                     returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildFence(LLVMBuilderRef, int32, int32, Str)                                                     returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildAtomicRMW(LLVMBuilderRef, int32, LLVMValueRef, LLVMValueRef, int32, int32)                   returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMBuildAtomicCmpXchg(LLVMBuilderRef, LLVMValueRef, LLVMValueRef, LLVMValueRef, int32, int32, int32) returns LLVMValueRef      is native($llvm) is export {*}
sub LLVMIsAtomicSingleThread(LLVMValueRef)                                                                returns int32             is native($llvm) is export {*}
sub LLVMSetAtomicSingleThread(LLVMValueRef, int32)                                                                                  is native($llvm) is export {*}
sub LLVMGetCmpXchgSuccessOrdering(LLVMValueRef)                                                           returns int32             is native($llvm) is export {*}
sub LLVMSetCmpXchgSuccessOrdering(LLVMValueRef, int32)                                                                              is native($llvm) is export {*}
sub LLVMGetCmpXchgFailureOrdering(LLVMValueRef)                                                           returns int32             is native($llvm) is export {*}
sub LLVMSetCmpXchgFailureOrdering(LLVMValueRef, int32)                                                                              is native($llvm) is export {*}

#= Module Providers
sub LLVMCreateModuleProviderForExistingModule(LLVMModuleRef) returns LLVMModuleProviderRef is native($llvm) is export {*}
sub LLVMDisposeModuleProvider(LLVMModuleProviderRef)                                       is native($llvm) is export {*}

#= Pass Registry
sub LLVMGetGlobalPassRegistry returns LLVMPassRegistryRef is native($llvm) is export {*}

#= Pass Managers
sub LLVMCreatePassManager                                        returns LLVMPassManagerRef is native($llvm) is export {*}
sub LLVMCreateFunctionPassManagerForModule(LLVMModuleRef)        returns LLVMPassManagerRef is native($llvm) is export {*}
sub LLVMCreateFunctionPassManager(LLVMModuleProviderRef)         returns LLVMPassManagerRef is native($llvm) is export {*}
sub LLVMRunPassManager(LLVMPassManagerRef, LLVMModuleRef)        returns int32              is native($llvm) is export {*}
sub LLVMInitializeFunctionPassManager(LLVMPassManagerRef)        returns int32              is native($llvm) is export {*}
sub LLVMRunFunctionPassManager(LLVMPassManagerRef, LLVMValueRef) returns int32              is native($llvm) is export {*}
sub LLVMFinalizeFunctionPassManager(LLVMPassManagerRef)          returns int32              is native($llvm) is export {*}
sub LLVMDisposePassManager(LLVMPassManagerRef)                                              is native($llvm) is export {*}

#= Threading
sub LLVMStartMultithreaded returns int32 is native($llvm) is export {*}
sub LLVMStopMultithreaded                is native($llvm) is export {*}
sub LLVMIsMultithreaded    returns int32 is native($llvm) is export {*}

#= Disassembler
sub LLVMCreateDisasm(Str, Pointer[void], int32, Pointer, Pointer)                      returns Pointer[void] is native($llvm) is export {*}
sub LLVMCreateDisasmCPU(Str, Str, Pointer[void], int32, Pointer, Pointer)              returns Pointer[void] is native($llvm) is export {*}
sub LLVMCreateDisasmCPUFeatures(Str, Str, Str, Pointer[void], int32, Pointer, Pointer) returns Pointer[void] is native($llvm) is export {*}
sub LLVMSetDisasmOptions(Pointer[void], uint64)                                        returns int32         is native($llvm) is export {*}
sub LLVMDisasmDispose(Pointer[void])                                                                         is native($llvm) is export {*}
sub LLVMDisasmInstruction(Pointer[void], CArray[uint8], uint64, uint64, Str, size_t)   returns size_t        is native($llvm) is export {*}

#= Execution Engine
sub LLVMLinkInMCJIT is native($llvm) is export {*}
sub LLVMLinkInInterpreter is native($llvm) is export {*}
sub LLVMCreateGenericValueOfInt(LLVMTypeRef, ulonglong, int32) returns LLVMGenericValueRef is native($llvm) is export {*}
sub LLVMCreateGenericValueOfPointer(Pointer[void]) returns LLVMGenericValueRef is native($llvm) is export {*}
sub LLVMCreateGenericValueOfFloat(LLVMTypeRef, num64) returns LLVMGenericValueRef is native($llvm) is export {*}
sub LLVMGenericValueIntWidth(LLVMGenericValueRef) returns size_t is native($llvm) is export {*}
sub LLVMGenericValueToInt(LLVMGenericValueRef, int32) returns ulonglong is native($llvm) is export {*}
sub LLVMGenericValueToPointer(LLVMGenericValueRef) returns Pointer[void] is native($llvm) is export {*}
sub LLVMGenericValueToFloat(LLVMTypeRef, LLVMGenericValueRef) returns num64 is native($llvm) is export {*}
sub LLVMDisposeGenericValue(LLVMGenericValueRef) is native($llvm) is export {*}
sub LLVMCreateExecutionEngineForModule(LLVMExecutionEngineRef is rw, LLVMModuleRef, Str is rw) returns int32 is native($llvm) is export {*}
sub LLVMCreateInterpreterForModule(LLVMExecutionEngineRef is rw, LLVMModuleRef, Str is rw) returns int32 is native($llvm) is export {*}
sub LLVMCreateJITCompilerForModule(LLVMExecutionEngineRef is rw, LLVMModuleRef, size_t, Str is rw) returns int32 is native($llvm) is export {*}
sub LLVMInitializeMCJITCompilerOptions(LLVMMCJITCompilerOptions is rw, size_t) is native($llvm) is export {*}
sub LLVMCreateMCJITCompilerForModule(LLVMExecutionEngineRef is rw, LLVMModuleRef, LLVMMCJITCompilerOptions is rw, size_t, Str is rw) returns int32 is native($llvm) is export {*}
sub LLVMDisposeExecutionEngine(LLVMExecutionEngineRef) is native($llvm) is export {*}
sub LLVMRunStaticConstructors(LLVMExecutionEngineRef) is native($llvm) is export {*}
sub LLVMRunStaticDestructors(LLVMExecutionEngineRef) is native($llvm) is export {*}
sub LLVMRunFunctionAsMain(LLVMExecutionEngineRef, LLVMValueRef, size_t, CArray[Str], CArray[Str]) returns int32 is native($llvm) is export {*}
sub LLVMRunFunction(LLVMExecutionEngineRef, LLVMValueRef, size_t, CArray[LLVMGenericValueRef]) returns LLVMGenericValueRef is native($llvm) is export {*}
sub LLVMFreeMachineCodeForFunction(LLVMExecutionEngineRef, LLVMValueRef) is native($llvm) is export {*}
sub LLVMAddModule(LLVMExecutionEngineRef, LLVMModuleRef) is native($llvm) is export {*}
sub LLVMRemoveModule(LLVMExecutionEngineRef, LLVMModuleRef, LLVMModuleRef is rw, Str is rw) returns int32 is native($llvm) is export {*}
sub LLVMFindFunction(LLVMExecutionEngineRef, Str, LLVMValueRef is rw) returns int32 is native($llvm) is export {*}
sub LLVMRecompileAndRelinkFunction(LLVMExecutionEngineRef, LLVMValueRef) returns Pointer[void] is native($llvm) is export {*}
sub LLVMGetExecutionEngineTargetData(LLVMExecutionEngineRef) returns LLVMTargetDataRef is native($llvm) is export {*}
sub LLVMGetExecutionEngineTargetMachine(LLVMExecutionEngineRef) returns LLVMTargetMachineRef is native($llvm) is export {*}
sub LLVMAddGlobalMapping(LLVMExecutionEngineRef, LLVMValueRef, Pointer[void]) is native($llvm) is export {*}
sub LLVMGetPointerToGlobal(LLVMExecutionEngineRef, LLVMValueRef) returns Pointer[void] is native($llvm) is export {*}
sub LLVMGetGlobalValueAddress(LLVMExecutionEngineRef, Str) returns uint64 is native($llvm) is export {*}
sub LLVMGetFunctionAddress(LLVMExecutionEngineRef, Str) returns uint64 is native($llvm) is export {*}
sub LLVMCreateSimpleMCJITMemoryManager(Pointer[void], Pointer, Pointer, Pointer, Pointer) returns LLVMMCJITMemoryManagerRef is native($llvm) is export {*}
sub LLVMDisposeMCJITMemoryManager(LLVMMCJITMemoryManagerRef) is native($llvm) is export {*}
sub LLVMCreateGDBRegistrationListener returns LLVMJITEventListenerRef is native($llvm) is export {*}
sub LLVMCreateIntelJITEventListener returns LLVMJITEventListenerRef is native($llvm) is export {*}
sub LLVMCreateOProfileJITEventListener returns LLVMJITEventListenerRef is native($llvm) is export {*}
sub LLVMCreatePerfJITEventListener returns LLVMJITEventListenerRef is native($llvm) is export {*}

#= Initialization Routines
#sub LLVMInitializeCore(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeTransformUtils(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeScalarOpts(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeObjCARCOpts(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeVectorization(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeInstCombine(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeAggressiveInstCombiner(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeIPO(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeInstrumentation(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeAnalysis(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeIPA(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeCodeGen(LLVMPassRegistryRef) is native($llvm) is export {*}
sub LLVMInitializeTarget(LLVMPassRegistryRef) is native($llvm) is export {*}

#= Link Time Optimizer
sub llvm_create_optimizer returns Pointer[void] is native($llvm) is export {*}
sub llvm_destroy_optimizer(Pointer[void]) is native($llvm) is export {*}
sub llvm_read_object_file(Pointer[void], Str) returns int32 is native($llvm) is export {*}
sub llvm_optimize_modules(Pointer[void], Str) returns int32 is native($llvm) is export {*}

#= LTO
sub lto_get_version returns Str is native($llvm) is export {*}
sub lto_get_error_message returns Str is native($llvm) is export {*}
sub lto_module_is_object_file(Str) returns bool is native($llvm) is export {*}
sub lto_module_is_object_file_for_target(Str, Str) returns bool is native($llvm) is export {*}
sub lto_module_has_objc_category(Pointer[void], size_t) returns bool is native($llvm) is export {*}
sub lto_module_is_object_file_in_memory(Pointer[void], size_t) returns bool is native($llvm) is export {*}
sub lto_module_is_object_file_in_memory_for_target(Pointer[void], size_t, Str) returns bool is native($llvm) is export {*}
sub lto_module_create(Str) returns lto_module_t is native($llvm) is export {*}
sub lto_module_create_from_memory(Pointer[void], size_t) returns lto_module_t is native($llvm) is export {*}
sub lto_module_create_from_memory_with_path(Pointer[void], size_t, Str) returns lto_module_t is native($llvm) is export {*}
sub lto_module_create_in_local_context(Pointer[void], size_t, Str) returns lto_module_t is native($llvm) is export {*}
sub lto_module_create_in_codegen_context(Pointer[void], size_t, Str, lto_code_gen_t) returns lto_module_t is native($llvm) is export {*}
sub lto_module_create_from_fd(int32, Str, size_t) returns lto_module_t is native($llvm) is export {*}
sub lto_module_create_from_fd_at_offset(int32, Str, size_t, size_t, uint32) returns lto_module_t is native($llvm) is export {*}
sub lto_module_dispose(lto_module_t) is native($llvm) is export {*}
sub lto_module_get_target_triple(lto_module_t) returns Str is native($llvm) is export {*}
sub lto_module_set_target_triple(lto_module_t, Str) is native($llvm) is export {*}
sub lto_module_get_symbol_name(lto_module_t, uint32) returns Str is native($llvm) is export {*}
sub lto_module_get_symbol_attribute(lto_module_t, uint32) returns int32 is native($llvm) is export {*}
sub lto_module_get_linkeropts(lto_module_t) returns Str is native($llvm) is export {*}
sub lto_codegen_set_diagnostic_handler(lto_code_gen_t, Pointer, Pointer[void]) is native($llvm) is export {*}
sub lto_codegen_create returns lto_code_gen_t is native($llvm) is export {*}
sub lto_codegen_create_in_local_context returns lto_code_gen_t is native($llvm) is export {*}
sub lto_codegen_dispose(lto_code_gen_t) is native($llvm) is export {*}
sub lto_codegen_add_module(lto_code_gen_t, lto_module_t) returns bool is native($llvm) is export {*}
sub lto_codegen_set_module(lto_code_gen_t, lto_module_t) is native($llvm) is export {*}
sub lto_codegen_set_debug_model(lto_code_gen_t, int32) returns bool is native($llvm) is export {*}
sub lto_codegen_set_pic_model(lto_code_gen_t, int32) returns bool is native($llvm) is export {*}
sub lto_codegen_set_cpu(lto_code_gen_t, Str) is native($llvm) is export {*}
sub lto_codegen_set_assembler_path(lto_code_gen_t, Str) is native($llvm) is export {*}
sub lto_codegen_set_assembler_args(lto_code_gen_t, CArray[Str], int32) is native($llvm) is export {*}
sub lto_codegen_add_must_preserve_symbol(lto_code_gen_t, Str) is native($llvm) is export {*}
sub lto_codegen_write_merged_modules(lto_code_gen_t, Str) returns bool is native($llvm) is export {*}
sub lto_codegen_compile(lto_code_gen_t, size_t is rw) returns Pointer[void] is native($llvm) is export {*}
sub lto_codegen_compile_to_file(lto_code_gen_t, CArray[Str]) returns bool is native($llvm) is export {*}
sub lto_codegen_optimize(lto_code_gen_t) returns bool is native($llvm) is export {*}
sub lto_codegen_compile_optimized(lto_code_gen_t, size_t is rw) returns Pointer[void] is native($llvm) is export {*}
sub lto_codegen_debug_options(lto_code_gen_t, Str) is native($llvm) is export {*}
sub lto_initialize_disassembler is native($llvm) is export {*}
sub lto_codegen_set_should_internalize(lto_code_gen_t, bool) is native($llvm) is export {*}
sub lto_codegen_set_should_embed_uselists(lto_code_gen_t, bool) is native($llvm) is export {*}

#= ThinLTO
sub thinlto_create_codegen returns thinlto_code_gen_t is native($llvm) is export {*}
sub thinlto_codegen_dispose(thinlto_code_gen_t) is native($llvm) is export {*}
sub thinlto_codegen_add_module(thinlto_code_gen_t, Str, Str, int32) is native($llvm) is export {*}
sub thinlto_codegen_process(thinlto_code_gen_t) is native($llvm) is export {*}
sub thinlto_module_get_object(thinlto_code_gen_t, uint32) returns LTOObjectBuffer is native($llvm) is export {*}
sub thinlto_module_get_object_file(thinlto_code_gen_t, uint32) returns Str is native($llvm) is export {*}
sub thinlto_codegen_set_pic_model(thinlto_code_gen_t, int32) returns bool is native($llvm) is export {*}
sub thinlto_codegen_set_savetemps_dir(thinlto_code_gen_t, Str) is native($llvm) is export {*}
sub thinlto_set_generated_objects_dir(thinlto_code_gen_t, Str) is native($llvm) is export {*}
sub thinlto_codegen_set_cpu(thinlto_code_gen_t, Str) is native($llvm) is export {*}
sub thinlto_codegen_disable_codegen(thinlto_code_gen_t, bool) is native($llvm) is export {*}
sub thinlto_codegen_set_codegen_only(thinlto_code_gen_t, bool) is native($llvm) is export {*}
sub thinlto_debug_options(CArray[Str], int32) is native($llvm) is export {*}
sub lto_module_is_thinlto(lto_module_t) returns bool is native($llvm) is export {*}
sub thinlto_codegen_add_must_preserve_symbol(thinlto_code_gen_t, Str, int32) is native($llvm) is export {*}
sub thinlto_codegen_add_cross_referenced_symbol(thinlto_code_gen_t, Str, int32) is native($llvm) is export {*}

sub thinlto_codegen_set_cache_dir(thinlto_code_gen_t, Str) is native($llvm) is export {*}
sub thinlto_codegen_set_cache_pruning_interval(thinlto_code_gen_t, int32) is native($llvm) is export {*}
sub thinlto_codegen_set_final_cache_size_relative_to_available_space(thinlto_code_gen_t, size_t) is native($llvm) is export {*}
sub thinlto_codegen_set_cache_entry_expiration(thinlto_code_gen_t, size_t) is native($llvm) is export {*}
sub thinlto_codegen_set_cache_size_bytes(thinlto_code_gen_t, size_t) is native($llvm) is export {*}
sub thinlto_codegen_set_cache_size_megabytes(thinlto_code_gen_t, size_t) is native($llvm) is export {*}
sub thinlto_codegen_set_cache_size_files(thinlto_code_gen_t, size_t) is native($llvm) is export {*}
sub lto_input_create(Pointer[void], size_t, Str) returns lto_input_t is native($llvm) is export {*}
sub lto_input_dispose(lto_input_t) is native($llvm) is export {*}
sub lto_input_get_num_dependent_libraries(lto_input_t) returns size_t is native($llvm) is export {*}
sub lto_input_get_dependent_library(lto_input_t, size_t, size_t is rw) returns Str is native($llvm) is export {*}

#= Object File reading & writing
sub LLVMCreateBinary(LLVMMemoryBufferRef, LLVMContextRef, Str is rw) returns LLVMBinaryRef is native($llvm) is export {*}
sub LLVMDisposeBinary(LLVMBinaryRef) is native($llvm) is export {*}
sub LLVMBinaryCopyMemoryBuffer(LLVMBinaryRef) returns LLVMMemoryBufferRef is native($llvm) is export {*}
sub LLVMBinaryGetType(LLVMBinaryRef) returns int32 is native($llvm) is export {*}
sub LLVMMachOUniversalBinaryCopyObjectForArch(LLVMBinaryRef, Str, size_t, Str is rw) returns LLVMBinaryRef is native($llvm) is export {*}
sub LLVMObjectFileCopySectionIterator(LLVMBinaryRef) returns LLVMSectionIteratorRef is native($llvm) is export {*}
sub LLVMObjectFileIsSectionIteratorAtEnd(LLVMBinaryRef, LLVMSectionIteratorRef) returns int32 is native($llvm) is export {*}
sub LLVMObjectFileCopySymbolIterator(LLVMBinaryRef) returns LLVMSymbolIteratorRef is native($llvm) is export {*}
sub LLVMObjectFileIsSymbolIteratorAtEnd(LLVMBinaryRef, LLVMSymbolIteratorRef) returns int32 is native($llvm) is export {*}
sub LLVMDisposeSectionIterator(LLVMSectionIteratorRef) is native($llvm) is export {*}
sub LLVMMoveToNextSection(LLVMSectionIteratorRef) is native($llvm) is export {*}
sub LLVMMoveToContainingSection(LLVMSectionIteratorRef, LLVMSymbolIteratorRef) is native($llvm) is export {*}
sub LLVMDisposeSymbolIterator(LLVMSymbolIteratorRef) is native($llvm) is export {*}
sub LLVMMoveToNextSymbol(LLVMSymbolIteratorRef) is native($llvm) is export {*}
sub LLVMGetSectionName(LLVMSectionIteratorRef) returns Str is native($llvm) is export {*}
sub LLVMGetSectionSize(LLVMSectionIteratorRef) returns uint64 is native($llvm) is export {*}
sub LLVMGetSectionContents(LLVMSectionIteratorRef) returns Str is native($llvm) is export {*}
sub LLVMGetSectionAddress(LLVMSectionIteratorRef) returns uint64 is native($llvm) is export {*}
sub LLVMGetSectionContainsSymbol(LLVMSectionIteratorRef, LLVMSymbolIteratorRef) returns int32 is native($llvm) is export {*}
sub LLVMGetRelocations(LLVMSectionIteratorRef) returns LLVMRelocationIteratorRef is native($llvm) is export {*}
sub LLVMDisposeRelocationIterator(LLVMRelocationIteratorRef) is native($llvm) is export {*}
sub LLVMIsRelocationIteratorAtEnd(LLVMSectionIteratorRef, LLVMRelocationIteratorRef) returns int32 is native($llvm) is export {*}
sub LLVMMoveToNextRelocation(LLVMRelocationIteratorRef) is native($llvm) is export {*}
sub LLVMGetSymbolName(LLVMSymbolIteratorRef) returns Str is native($llvm) is export {*}
sub LLVMGetSymbolAddress(LLVMSymbolIteratorRef) returns uint64 is native($llvm) is export {*}
sub LLVMGetSymbolSize(LLVMSymbolIteratorRef) returns uint64 is native($llvm) is export {*}
sub LLVMGetRelocationOffset(LLVMRelocationIteratorRef) returns uint64 is native($llvm) is export {*}
sub LLVMGetRelocationSymbol(LLVMRelocationIteratorRef) returns LLVMSymbolIteratorRef is native($llvm) is export {*}
sub LLVMGetRelocationType(LLVMRelocationIteratorRef) returns uint64 is native($llvm) is export {*}
sub LLVMGetRelocationTypeName(LLVMRelocationIteratorRef) returns Str is native($llvm) is export {*}
sub LLVMGetRelocationValueString(LLVMRelocationIteratorRef) returns Str is native($llvm) is export {*}
sub LLVMCreateObjectFile(LLVMMemoryBufferRef) returns LLVMObjectFileRef is native($llvm) is export {*}
sub LLVMDisposeObjectFile(LLVMObjectFileRef) is native($llvm) is export {*}
sub LLVMGetSections(LLVMObjectFileRef) returns LLVMSectionIteratorRef is native($llvm) is export {*}
sub LLVMIsSectionIteratorAtEnd(LLVMObjectFileRef, LLVMSectionIteratorRef) returns int32 is native($llvm) is export {*}
sub LLVMGetSymbols(LLVMObjectFileRef) returns LLVMSymbolIteratorRef is native($llvm) is export {*}
sub LLVMIsSymbolIteratorAtEnd(LLVMObjectFileRef, LLVMSymbolIteratorRef) returns int32 is native($llvm) is export {*}

#= Remarks
sub LLVMRemarkStringGetData(LLVMRemarkStringRef) returns Str is native($llvm) is export {*}
sub LLVMRemarkStringGetLen(LLVMRemarkStringRef) returns uint32 is native($llvm) is export {*}
sub LLVMRemarkDebugLocGetSourceFilePath(LLVMRemarkDebugLocRef) returns LLVMRemarkStringRef is native($llvm) is export {*}
sub LLVMRemarkDebugLocGetSourceLine(LLVMRemarkDebugLocRef) returns uint32 is native($llvm) is export {*}
sub LLVMRemarkDebugLocGetSourceColumn(LLVMRemarkDebugLocRef) returns uint32 is native($llvm) is export {*}
sub LLVMRemarkArgGetKey(LLVMRemarkArgRef) returns LLVMRemarkStringRef is native($llvm) is export {*}
sub LLVMRemarkArgGetValue(LLVMRemarkArgRef) returns LLVMRemarkStringRef is native($llvm) is export {*}
sub LLVMRemarkArgGetDebugLoc(LLVMRemarkArgRef) returns LLVMRemarkDebugLocRef is native($llvm) is export {*}
sub LLVMRemarkEntryDispose(LLVMRemarkEntryRef) is native($llvm) is export {*}
sub LLVMRemarkEntryGetPassName(LLVMRemarkEntryRef) returns LLVMRemarkStringRef is native($llvm) is export {*}
sub LLVMRemarkEntryGetRemarkName(LLVMRemarkEntryRef) returns LLVMRemarkStringRef is native($llvm) is export {*}
sub LLVMRemarkEntryGetFunctionName(LLVMRemarkEntryRef) returns LLVMRemarkStringRef is native($llvm) is export {*}
sub LLVMRemarkEntryGetDebugLoc(LLVMRemarkEntryRef) returns LLVMRemarkDebugLocRef is native($llvm) is export {*}
sub LLVMRemarkEntryGetHotness(LLVMRemarkEntryRef) returns uint64 is native($llvm) is export {*}
sub LLVMRemarkEntryGetNumArgs(LLVMRemarkEntryRef) returns uint32 is native($llvm) is export {*}
sub LLVMRemarkEntryGetFirstArg(LLVMRemarkEntryRef) returns LLVMRemarkArgRef is native($llvm) is export {*}
sub LLVMRemarkEntryGetNextArg(LLVMRemarkArgRef, LLVMRemarkEntryRef) returns LLVMRemarkArgRef is native($llvm) is export {*}
sub LLVMRemarkParserCreateYAML(Pointer[void], uint64) returns LLVMRemarkParserRef is native($llvm) is export {*}
sub LLVMRemarkParserGetNext(LLVMRemarkParserRef) returns LLVMRemarkEntryRef is native($llvm) is export {*}
sub LLVMRemarkParserHasError(LLVMRemarkParserRef) returns int32 is native($llvm) is export {*}
sub LLVMRemarkParserGetErrorMessage(LLVMRemarkParserRef) returns Str is native($llvm) is export {*}
sub LLVMRemarkParserDispose(LLVMRemarkParserRef) is native($llvm) is export {*}
sub LLVMRemarkVersion returns uint32 is native($llvm) is export {*}

#= Target information
sub LLVMInitializeAllTargetInfos is native($llvm) is export {*}
sub LLVMInitializeAllTargets is native($llvm) is export {*}
sub LLVMInitializeAllTargetMCs is native($llvm) is export {*}
sub LLVMInitializeAllAsmPrinters is native($llvm) is export {*}
sub LLVMInitializeAllAsmParsers is native($llvm) is export {*}
sub LLVMInitializeAllDisassemblers is native($llvm) is export {*}
sub LLVMInitializeNativeTarget returns int32 is native($llvm) is export {*}
sub LLVMInitializeNativeAsmParser returns int32 is native($llvm) is export {*}
sub LLVMInitializeNativeAsmPrinter returns int32 is native($llvm) is export {*}
sub LLVMInitializeNativeDisassembler returns int32 is native($llvm) is export {*}
sub LLVMGetModuleDataLayout(LLVMModuleRef) returns LLVMTargetDataRef is native($llvm) is export {*}
sub LLVMSetModuleDataLayout(LLVMModuleRef, LLVMTargetDataRef) is native($llvm) is export {*}
sub LLVMCreateTargetData(Str) returns LLVMTargetDataRef is native($llvm) is export {*}
sub LLVMDisposeTargetData(LLVMTargetDataRef) is native($llvm) is export {*}
sub LLVMAddTargetLibraryInfo(LLVMTargetLibraryInfoRef, LLVMPassManagerRef) is native($llvm) is export {*}
sub LLVMCopyStringRepOfTargetData(LLVMTargetDataRef) returns Str is native($llvm) is export {*}
sub LLVMPointerSize(LLVMTargetDataRef) returns size_t is native($llvm) is export {*}
sub LLVMPointerSizeForAS(LLVMTargetDataRef, size_t) returns size_t is native($llvm) is export {*}
sub LLVMIntPtrType(LLVMTargetDataRef) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMIntPtrTypeForAS(LLVMTargetDataRef, size_t) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMIntPtrTypeInContext(LLVMContextRef, LLVMTargetDataRef) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMIntPtrTypeForASInContext(LLVMContextRef, LLVMTargetDataRef, size_t) returns LLVMTypeRef is native($llvm) is export {*}
sub LLVMABIAlignmentOfType(LLVMTargetDataRef, LLVMTypeRef) returns size_t is native($llvm) is export {*}
sub LLVMCallFrameAlignmentOfType(LLVMTargetDataRef, LLVMTypeRef) returns size_t is native($llvm) is export {*}
sub LLVMPreferredAlignmentOfType(LLVMTargetDataRef, LLVMTypeRef) returns size_t is native($llvm) is export {*}
sub LLVMPreferredAlignmentOfGlobal(LLVMTargetDataRef, LLVMValueRef) returns size_t is native($llvm) is export {*}
sub LLVMElementAtOffset(LLVMTargetDataRef, LLVMTypeRef, ulonglong) returns size_t is native($llvm) is export {*}
