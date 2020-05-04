use "fileExt"
use "ponytest"
use "files"
use "flow"
use "utility"

use "framework:Foundation"
use "framework:AppKit" if osx

use "lib:apple-osx" if osx
use "lib:apple-ios" if ios


actor AppDelegate
  fun _use_main_thread():Bool => true
  
	new create(env:Env) =>
    ifdef osx then
  		@NSApplicationMain[I32](env.argc, env.argv)
    end


actor Main is TestList
	new create(env: Env) =>
    AppDelegate(env)
    @sleep[U32](U32(1))
    
    PonyTest(env, this)
  
	new make() => None

	fun tag tests(test: PonyTest) =>
		test(_TestApple1)
    test(_TestApple2)


class iso _TestApple1 is UnitTest
	fun name(): String => "Test 1: url download success"

	fun apply(h: TestHelper) =>
      h.long_test(30_000_000_000)
      
      URLDownload.get("https://i.ytimg.com/vi/SBjCQX7Lh2Q/maxresdefault.jpg", {(result:URLDownloadResult val) =>        
        match result
        | URLDownloadError => h.complete(false)
        | let _:Array[U8] val => h.complete(true)
        end
      })

class iso _TestApple2 is UnitTest
	fun name(): String => "Test 1: url download fail"

	fun apply(h: TestHelper) =>
      h.long_test(30_000_000_000)

      URLDownload.get("http://lakdhsbgfklwsadbhfd.com/SBjCQX7Lh2Q/lkjdafbgojbds.jpg", {(result:URLDownloadResult val) =>        
        match result
        | let err:URLDownloadError val => h.complete(err == "A server with the specified hostname could not be found.")
        | let _:Array[U8] val => h.complete(false)
        end
      })

      
	


