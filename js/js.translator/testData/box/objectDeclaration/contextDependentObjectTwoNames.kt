interface A {
    fun run()
}

// CHECK_FUNCTION_EXISTS: box$a$1 TARGET_BACKENDS=JS_IR
// CHECK_FUNCTION_EXISTS: box$a$1$run$b$1 TARGET_BACKENDS=JS_IR
// CHECK_FUNCTION_EXISTS: box$a$1$run$c$1 TARGET_BACKENDS=JS_IR
fun box(): String {
    var result = "FAILURE"

    val a: A = object : A {
        override fun run() {
            val b = object {
                fun foo() {
                    result = "OK"
                }
            }
            val c = object {
                fun foo() {
                    result = b.foo()
                }
            }
            c.foo()
        }
    }

    a.run()
    return result
}
