// SOURCE_RETENTION_ANNOTATIONS
// JSPECIFY_STATE: strict
// ISSUE: KT-71490

// FILE: J.java
import org.jspecify.annotations.*;

public enum J {
    A, B;

    public static J getPlatform() {
        return J.A;
    }

    @NonNull public static J getNonNull() {
        return J.A;
    }

    @Nullable public static J getNullable() {
        return J.A;
    }
}

// FILE: main.kt

fun test_1(): Int {
    return when (J.getPlatform()) {
        J.A -> 1
        J.B -> 2
    }
}

fun test_2(): Int {
    return when (J.getPlatform()) {
        J.A -> 1
        J.B -> 2
        null -> 3
    }
}

fun test_3(): Int {
    return when (J.getPlatform()) {
        J.A -> 1
        J.B -> 2
        else -> 3
    }
}

fun test_4(): Int {
    return when (J.getPlatform()) {
        J.A -> 1
        J.B -> 2
        null -> 3
        <!REDUNDANT_ELSE_IN_WHEN!>else<!> -> 4
    }
}

fun test_5(): Int {
    return when (J.getNonNull()) {
        J.A -> 1
        J.B -> 2
    }
}

fun test_6(): Int {
    return when (J.getNonNull()) {
        J.A -> 1
        J.B -> 2
        <!SENSELESS_NULL_IN_WHEN!>null<!> -> 3
    }
}

fun test_7(): Int {
    return when (J.getNonNull()) {
        J.A -> 1
        J.B -> 2
        <!REDUNDANT_ELSE_IN_WHEN!>else<!> -> 3
    }
}

fun test_8(): Int {
    return when (J.getNonNull()) {
        J.A -> 1
        J.B -> 2
        <!SENSELESS_NULL_IN_WHEN!>null<!> -> 3
        <!REDUNDANT_ELSE_IN_WHEN!>else<!> -> 4
    }
}


fun test_9(): Int {
    return <!NO_ELSE_IN_WHEN!>when<!> (J.getNullable()) {
        J.A -> 1
        J.B -> 2
    }
}

fun test_10(): Int {
    return when (J.getNullable()) {
        J.A -> 1
        J.B -> 2
        null -> 3
    }
}

fun test_11(): Int {
    return when (J.getNullable()) {
        J.A -> 1
        J.B -> 2
        else -> 3
    }
}

fun test_12(): Int {
    return when (J.getNullable()) {
        J.A -> 1
        J.B -> 2
        null -> 3
        <!REDUNDANT_ELSE_IN_WHEN!>else<!> -> 4
    }
}
