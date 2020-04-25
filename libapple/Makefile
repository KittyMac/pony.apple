
clang_ios=$(shell xcrun --sdk iphoneos --find clang)
libtool_ios=$(shell xcrun --sdk iphoneos --find libtool)
isysroot_ios=$(shell xcrun --sdk iphoneos --show-sdk-path)

clang_osx=$(shell xcrun --sdk macosx --find clang)
libtool_osx=$(shell xcrun --sdk macosx --find libtool)
isysroot_osx=$(shell xcrun --sdk macosx --show-sdk-path)


builddir_ios=./build/ios
libdir_ios=./build/ios/lib
includedir_ios=./build/ios/include

builddir_osx=./build/osx
libdir_osx=./build/osx/lib
includedir_osx=./build/osx/include


all: check osx ios
	
clean:
	rm -rf build/

check:
	@mkdir -p $(libdir_ios)
	@mkdir -p $(includedir_ios)
	@mkdir -p $(libdir_osx)
	@mkdir -p $(includedir_osx)

osx:
	cd $(builddir_osx) && $(clang_osx) -O3 -c ../../src/*.m -I../../src/ -arch x86_64 -isysroot $(isysroot_osx)
	@$(libtool_osx) -static $(builddir_osx)/*.o -o $(libdir_osx)/libapple.a
	cp src/*.h $(includedir_osx)/
	rm $(builddir_osx)/*.o

ios:
	cd $(builddir_ios) && $(clang_ios) -O3 -c ../../src/*.m -I../../src/ -arch arm64 -isysroot $(isysroot_ios)
	@$(libtool_ios) -static $(builddir_ios)/*.o -o $(libdir_ios)/libapple.a
	cp src/*.h $(includedir_ios)/
	rm $(builddir_ios)/*.o