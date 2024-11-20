import com.android.build.gradle.internal.tasks.factory.dependsOn

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

// TODO: Update value to your plugin's name.
val pluginName = "GodotPoolakey"

// TODO: Update value to match your plugin's package name.
val pluginPackageName = "com.example.godotpoolakey"

android {
    namespace = pluginPackageName
    compileSdk = 33

    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        minSdk = 21

        manifestPlaceholders["godotPluginName"] = pluginName
        manifestPlaceholders["godotPluginPackageName"] = pluginPackageName
        buildConfigField("String", "GODOT_PLUGIN_NAME", "\"${pluginName}\"")
        setProperty("archivesBaseName", pluginName)

    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("org.godotengine:godot:4.2.0.stable")
    // TODO: Additional dependencies should be added to export_plugin.gd as well.
    implementation("com.github.cafebazaar.Poolakey:poolakey:2.2.0")
//    implementation("com.github.cafebazaar.CafeBazaarAuth:auth:1.0.2")

    testImplementation("junit:junit:4.13.2")
}