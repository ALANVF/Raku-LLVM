use LLVM;

my $mod = LLVM::Module.new: "test-module";
my $ctx = $mod.context;

# test defining/declaring functions
$mod.funcs<sum> = LLVM::Type.function($ctx.int32, [$ctx.int32, $ctx.int32]);
my $sum = $mod.funcs<sum>;

$mod.funcs<printf> = LLVM::Type.function($ctx.int32, [$ctx.int8.pointer], :vararg);
my $printf = $mod.funcs<printf>;

$mod.funcs<main> = LLVM::Type.function($ctx.int32, []);
my $main = $mod.funcs<main>;

# test the builder
my $builder = LLVM::Builder.new;

# define i32 @sum(i32, i32)
my $sum-entry = $sum.blocks.push("entry");
$builder.move-to-end($sum-entry);
$builder.build: {
	my $tmp = .add: $sum.params[0], $sum.params[1], :as<tmp>;
	.ret: $tmp
};

# define i32 @main()
my $main-entry = $main.blocks.push("entry");
$builder.move-to-end($main-entry);
$builder.build: {
	my $str = .global-string-ptr: 'from @main: %i'~"\n", :as<str>;
	my $res = .call: $sum, [$ctx.int32.const-int(1), $ctx.int32.const-int(2)], :as<res>;
	.call: $printf, [$str, $res];
	.ret: $ctx.int32.const-int(0)
};

$mod.verify(Abort-process-action);

# print the ir for the current module
say $mod.Str;

# test the execution engine
my $engine = LLVM::Engine.new: $mod;

# run the sum function
my $x = LLVM::Generic.int(LLVM::Type.int32, 1);
my $y = LLVM::Generic.int(LLVM::Type.int32, 2);
say 'from @sum: ', $engine.run-func($sum, [$x, $y]).Int;

# run the main function
$engine.run-func-as-main($main, [], []);

# write out the ir and bitcode
$mod.write-bitcode("sum.bc");
$mod.spurt("sum.ll");

# dispose the things
$builder.dispose;
$engine.dispose;
