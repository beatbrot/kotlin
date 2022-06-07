plugins {
    kotlin("multiplatform").version("<pluginMarkerVersion>")
}

repositories {
    mavenLocal()
    mavenCentral()
}

kotlin {
    wasm {
        moduleName = "redefined-wasm-module-name"
        d8 {
        }
        binaries.executable()
    }
    js {
        moduleName = "redefined-js-module-name"
        browser {
        }
        binaries.executable()
    }
}