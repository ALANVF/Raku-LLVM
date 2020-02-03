# yea so raku doesn't allow stubs across multiple files.
# if you have a better way of doing this then let me know

use NativeCall;
use NativeHelpers::Blob;
use LLVMC;
use MONKEY-SEE-NO-EVAL;

BEGIN my $dir = $?FILE.IO.parent.CWD;

EVAL "$dir/LLVM/Enums.pm6".&slurp;

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
	"$dir/LLVM/Value.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Attribute.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/BasicBlock.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Builder.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Context.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Engine.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Global.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Function.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Generic.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Instruction.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Intrinsic.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Metadata.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Module.pm6".&slurp ~ "\n" ~
	"$dir/LLVM/Type.pm6".&slurp
);
