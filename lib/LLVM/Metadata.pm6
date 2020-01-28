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
