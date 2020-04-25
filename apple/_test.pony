use "fileExt"
use "ponytest"
use "files"
use "flow"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
		test(_TestApple1)


class iso _TestApple1 is UnitTest
	fun name(): String => "Test 1: stub test"

	fun apply(h: TestHelper) =>
      h.long_test(30_000_000_000)
      
      h.complete(true)
	


