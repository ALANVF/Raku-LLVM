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
