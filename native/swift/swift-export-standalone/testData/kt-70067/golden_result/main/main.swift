@_exported import ExportedKotlinPackages
@_implementationOnly import KotlinBridges_main
import KotlinRuntime

public extension ExportedKotlinPackages.testData.kt_70067.kt_70067 {
    @available(*, deprecated, obsoleted: 1.0, message: "Removed in Kotlin")
    public final class ErrorDeprecatedClass : KotlinRuntime.KotlinBase {
        public override init() {
            fatalError("unavailable")
        }
        public override init(
            __externalRCRef: Swift.UInt
        ) {
            super.init(__externalRCRef: __externalRCRef)
        }
    }
    public final class ExampleClass : KotlinRuntime.KotlinBase {
        public override init() {
            let __kt = testData_kt_70067_kt_70067_ExampleClass_init_allocate()
            super.init(__externalRCRef: __kt)
            testData_kt_70067_kt_70067_ExampleClass_init_initialize__TypesOfArguments__uintptr_t__(__kt)
        }
        public override init(
            __externalRCRef: Swift.UInt
        ) {
            super.init(__externalRCRef: __externalRCRef)
        }
        @available(*, deprecated, obsoleted: 1.0, message: "Removed in Kotlin")
        public func errorDeprecatedMethod() -> Swift.Void {
            fatalError("unavailable")
        }
        @available(*, deprecated, obsoleted: 1.0, message: "Removed in Kotlin")
        public func hiddenDeprecatedMethod() -> Swift.Void {
            fatalError("unavailable")
        }
    }
    @available(*, deprecated, obsoleted: 1.0, message: "Removed in Kotlin")
    public final class HiddenDeprecatedClass : KotlinRuntime.KotlinBase {
        public override init() {
            fatalError("unavailable")
        }
        public override init(
            __externalRCRef: Swift.UInt
        ) {
            super.init(__externalRCRef: __externalRCRef)
        }
    }
    @available(*, deprecated, obsoleted: 1.0, message: "Removed in Kotlin")
    public static var errorDeprecatedProperty: Swift.String {
        get {
            fatalError("unavailable")
        }
    }
    @available(*, deprecated, obsoleted: 1.0, message: "Removed in Kotlin")
    public static var hiddenDeprecatedProperty: Swift.String {
        get {
            fatalError("unavailable")
        }
    }
    @available(*, deprecated, obsoleted: 1.0, message: "Removed in Kotlin")
    public static func errorDeprecatedFunction() -> Swift.Void {
        fatalError("unavailable")
    }
    @available(*, deprecated, obsoleted: 1.0, message: "Removed in Kotlin")
    public static func hiddenDeprecatedFunction() -> Swift.Void {
        fatalError("unavailable")
    }
}
