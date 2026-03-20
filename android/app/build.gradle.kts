plugins {
    id("com.android.library")
}

android {
    namespace = "com.fluocode.admob"
    compileSdk = 34

    defaultConfig {
        minSdk = 21
        targetSdk = 34
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

dependencies {
    // Flash Runtime Extensions: copy FlashRuntimeExtensions.jar from the AIR SDK into app/libs/
    implementation(files("libs/FlashRuntimeExtensions.jar"))

    // Google Play services libraries for AdMob
    implementation("com.google.android.gms:play-services-ads:23.0.0")
    implementation("com.google.android.gms:play-services-ads-identifier:18.0.1")
    implementation("com.google.code.gson:gson:2.10.1")
}

// Packages compiled ANE Java bytecode into classes.jar (project classes only; dependencies are merged when the host app is built)
afterEvaluate {
    tasks.register<Jar>("aneJar") {
        val compileTask = tasks.named("compileReleaseJavaWithJavac", org.gradle.api.tasks.compile.JavaCompile::class)
        dependsOn(compileTask)
        from(compileTask.get().destinationDirectory)
        archiveFileName.set("classes.jar")
        destinationDirectory.set(layout.buildDirectory.dir("outputs"))
    }
}
