// WITH_STDLIB

// MODULE: m1-common
// FILE: common.kt

import kotlin.jvm.ImplicitlyActualizedByJvmDeclaration

@OptIn(ExperimentalMultiplatform::class)
<!IMPLICIT_ACTUAL_NO_ACTUAL_CLASS_MEMBER_FOR_EXPECTED_CLASS!>@ImplicitlyActualizedByJvmDeclaration<!>
expect class Foo {
    fun foo(a: Int)
}

// MODULE: lib()()()
// FILE: lib.kt
class Foo {
    fun foo(a: Int = 1) {}
}

// MODULE: m2-jvm(lib)()(m1-common)
// FILE: jvm.kt
