import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mesh_frontend"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.0.13004108"

    // Dart-Defines
    val dartDefines = mutableMapOf<String, String>()
    if (project.hasProperty("dart-defines")) {
        val dartDefinesList = project.property("dart-defines") as String
        dartDefinesList.split(",").forEach { entry ->
            val decoded = String(Base64.getDecoder().decode(entry))
            val (key, value) = decoded.split("=", limit = 2)
            dartDefines[key] = value
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mesh_frontend"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "google_maps_api_key", dartDefines["GOOGLE_MAPS_API_KEY"] ?: "")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}