allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Some plugins (e.g. file_picker 8.1.0) hardcode an older compileSdk in their own
// build.gradle and ignore the app's. flutter_plugin_android_lifecycle, pulled in
// transitively, now requires consumers to compile against API 36, so force any
// plugin subproject still below that up to match the app. The evaluationDependsOn
// above can leave :app already evaluated, so apply directly in that case.
subprojects {
    val bumpCompileSdk: Project.() -> Unit = {
        val android = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        val current = android?.compileSdkVersion?.substringAfter("android-")?.toIntOrNull()
        if (android != null && current != null && current < 36) {
            android.compileSdkVersion(36)
        }
    }
    if (state.executed) bumpCompileSdk() else afterEvaluate { bumpCompileSdk() }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
