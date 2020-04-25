build_dir=./build
lib_dir=./lib

all: apple pony run

apple:
	cd ./libapple && make

check:
	@mkdir -p $(build_dir)
	@mkdir -p $(lib_dir)

pony: check copy-libs
	corral run -- ponyc --extfun --print-code -p $(lib_dir) -o ./build/ ./apple

copy-libs:
	@cp ./libapple/build/osx/lib/libapple.a $(lib_dir)/libapple-osx.a
	@cp ./libapple/build/ios/lib/libapple.a $(lib_dir)/libapple-ios.a

clean:
	rm -rf $(build_dir)

run:
	./build/apple

test: check-folders copy-libs
	corral run -- ponyc --extfun -V=0 -p $(lib_dir) -o ./build/ ./apple
	./build/apple





corral-fetch:
	@corral clean -q
	@corral fetch -q

corral-local:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add /Volumes/Development/Development/pony/pony.fileExt -q
	@corral add /Volumes/Development/Development/pony/pony.flow -q

corral-git:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add github.com/KittyMac/pony.fileExt.git -q
	@corral add github.com/KittyMac/pony.flow.git -q

ci: corral-git corral-fetch all
	
dev: corral-local corral-fetch all

