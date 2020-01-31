# yea so raku doesn't allow stubs across multiple files.
# if you have a better way of doing this then let me know

use NativeCall;
use NativeHelpers::Blob;
use LLVMC;
use MONKEY-SEE-NO-EVAL;

EVAL "lib/LLVM/Enums.pm6".&slurp;

EVAL('
class LLVM::Value {...}
class LLVM::Attribute {...}
class LLVM::BasicBlock {...}
class LLVM::Builder {...}
class LLVM::Context {...}
class LLVM::Engine {...}
class LLVM::Global {...}
class LLVM::Function {...}
class LLVM::Generic {...}
class LLVM::Instruction {...}
class LLVM::Intrinsic {...}
class LLVM::Metadata {...}
class LLVM::Module {...}
class LLVM::Type {...}
' ~
	"lib/LLVM/Value.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Attribute.pm6".&slurp ~ "\n" ~
	"lib/LLVM/BasicBlock.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Builder.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Context.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Engine.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Global.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Function.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Generic.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Instruction.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Intrinsic.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Metadata.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Module.pm6".&slurp ~ "\n" ~
	"lib/LLVM/Type.pm6".&slurp
);
