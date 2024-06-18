// WITH_STDLIB
// FULL_JDK
// TARGET_BACKEND: JVM_IR
// IGNORE_BACKEND: JVM
// IGNORE_BACKEND: ANDROID
import kotlin.coroutines.*
import kotlin.coroutines.intrinsics.*

fun blackhole(vararg a: Any?) {}

val spilledVariables = mutableSetOf<Pair<String, String>>()

var c: Continuation<Unit>? = null

suspend fun saveSpilledVariables() = suspendCoroutineUninterceptedOrReturn<Unit> { continuation ->
    spilledVariables.clear()
    for (field in continuation.javaClass.declaredFields) {
        if (field.name != "label" && (field.name.length != 3 || field.name[1] != '$')) continue
        field.isAccessible = true
        val fieldValue = when (val obj = field.get(continuation)) {
            is Array<*> -> obj.joinToString(prefix = "[", postfix = "]")
            else -> obj
        }
        spilledVariables += field.name to "$fieldValue"
    }
    c = continuation
    COROUTINE_SUSPENDED
}

suspend fun test() {
    var a: String? = "a"
    saveSpilledVariables()
    blackhole(a)
    a = null
    saveSpilledVariables()
    blackhole(a)
}

fun builder(c: suspend () -> Unit) {
    c.startCoroutine(Continuation(EmptyCoroutineContext) {
        it.getOrThrow()
    })
}

fun box(): String {
    builder {
        test()
    }

    val continuationName = "Continuation at NullCleanupKt\$box\$1.invokeSuspend(nullCleanup.kt:47)"
    if (spilledVariables != setOf("label" to "1", "L$0" to continuationName, "L$1" to "a")) return "FAIL 1: $spilledVariables"
    c?.resume(Unit)
    if (spilledVariables != setOf("label" to "2", "L$0" to continuationName, "L$1" to "a")) return "FAIL 2: $spilledVariables"
    c?.resume(Unit)
    if (spilledVariables != setOf("label" to "2", "L$0" to continuationName, "L$1" to "a")) return "FAIL 3: $spilledVariables"

    return "OK"
}