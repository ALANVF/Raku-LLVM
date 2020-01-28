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
		LLVM::LLVMMoveBasicBlockAfter($!raw, $bb.raw)
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