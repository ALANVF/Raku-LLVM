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