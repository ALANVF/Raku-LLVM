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
