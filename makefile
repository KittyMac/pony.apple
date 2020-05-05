build_dir=./build
lib_dir=./lib

clang_osx=$(shell xcrun --sdk macosx --find clang)
isysroot_osx=$(shell xcrun --sdk macosx --show-sdk-path)

framework_ponydir=/Volumes/Development/Development/pony
libponyrt_ios_library="/build/release/lib/ios/libponyrt.a"
libponyrt_osx_library="/build/release/lib/native/libponyrt.a"
libponyrt_header1="/src/libponyrt/pony.h"
libponyrt_header2="/src/common/pony/detail/atomics.h"


# This is a little tricky. libapple relies on "apple.h" existing, but it won't get created
# until ponyc is run. But the final ponyc relies on the libapple.a existing. So we run ponyc 
# first and tell it to output a .o (which doesn't rely on libapple.a existing).  Then build
# libapple.a, then do ponyc again to build the executable

all: clean pre_pony libapple post_pony run

.PHONY: libapple
libapple:
	@sed "s/<pony\/detail\/atomics.h>/\"atomics.h\"/" $(framework_ponydir)/ponyc/$(libponyrt_header1) > $(build_dir)/pony.h
	@sed "s/<pony\/detail\/atomics.h>/\"atomics.h\"/" $(framework_ponydir)/ponyc/$(libponyrt_header1) > $(build_dir)/pony.h
	@cp -p $(framework_ponydir)/ponyc/$(libponyrt_header2) $(build_dir)/
	@cp -p $(framework_ponydir)/ponyc/$(libponyrt_header2) $(build_dir)/
	cd ./libapple && make
	@cp ./libapple/build/osx/lib/libapple.a $(lib_dir)/libapple-osx.a
	@cp ./libapple/build/ios/lib/libapple.a $(lib_dir)/libapple-ios.a

check:
	@mkdir -p $(build_dir)
	@mkdir -p $(lib_dir)

pre_pony: check
	corral run -- ponyc -robj -p ./ -o $(build_dir) ./test_apple
	@rm -f $(build_dir)/test_apple.o
	mv $(build_dir)/test_apple.h $(build_dir)/apple.h

post_pony: check
	corral run -- ponyc --extfun -p $(lib_dir) -p ./ -o $(build_dir) ./test_apple

clean:
	rm -rf $(build_dir)

run:
	$(build_dir)/test_apple

debug:
	lldb $(build_dir)/test_apple

test: check-folders
	corral run -- ponyc -V=0 -p $(lib_dir) -o $(build_dir)/ ./test_apple
	$(build_dir)/test_apple





corral-fetch:
	@corral clean -q
	@corral fetch -q

corral-local:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add /Volumes/Development/Development/pony/pony.fileExt -q
	@corral add /Volumes/Development/Development/pony/pony.flow -q
	@corral add /Volumes/Development/Development/pony/pony.utility -q
	@corral add /Volumes/Development/Development/pony/regex -q

corral-git:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add github.com/KittyMac/pony.fileExt.git -q
	@corral add github.com/KittyMac/pony.flow.git -q
	@corral add github.com/KittyMac/pony.utility.git -q
	@corral add github.com/KittyMac/regex.git -q

ci: corral-git corral-fetch all
	
dev: corral-local corral-fetch all

