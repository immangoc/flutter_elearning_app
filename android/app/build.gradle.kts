plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    kotlin("android")                               // <- was id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.e_learning"

    // flutter.* are Strings in many templates; convert to Ints
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = flutter.ndkVersion

    // AGP 8+ / recent Flutter require Java 17
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.e_learning"

        // Kotlin DSL uses properties, not the old *Version(...) calls
        minSdk = flutter.minSdkVersion.toInt()
        targetSdk = flutter.targetSdkVersion.toInt()

        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            // Nếu sau này muốn bật lại shrink cho release, xem Cách B.
        }
    }


    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

flutter {
    source = "../.."
}

// Add your extra dependencies here if needed
dependencies {
    // implementation("...")
}
