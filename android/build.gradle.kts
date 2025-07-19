allprojects {
    repositories {
        google()
        mavenCentral()
    }

    subprojects {
         afterEvaluate {
             val androidExt = extensions.findByName("android")
             if (androidExt != null) {
                 // Set namespace if missing
                 val setNamespace = androidExt.javaClass.methods.find { m -> m.name == "setNamespace" }
                 val getNamespace = androidExt.javaClass.methods.find { m -> m.name == "getNamespace" }
                 val currentNamespace = getNamespace?.invoke(androidExt) as? String
                 if (currentNamespace.isNullOrEmpty()) {
                     val defaultNamespace = group.toString().replace('.', '_')
                     setNamespace?.invoke(androidExt, defaultNamespace)
                 }
                 // Enable buildConfig
                 val buildFeatures = androidExt.javaClass.methods.find { m -> m.name == "getBuildFeatures" }?.invoke(androidExt)
                 buildFeatures?.javaClass?.methods?.find { m -> m.name == "setBuildConfig" }?.invoke(buildFeatures, true)
             }

             // Task to ensure namespace and remove package attribute
             tasks.register("fixManifestsAndNamespace") {
                 doLast {
                     // Ensure namespace in build.gradle
                     val buildGradleFile = file("build.gradle")
                     if (buildGradleFile.exists()) {
                         val buildGradleContent = buildGradleFile.readText(Charsets.UTF_8)
                         val manifestFile = file("src/main/AndroidManifest.xml")
                         if (manifestFile.exists()) {
                             val manifestContent = manifestFile.readText(Charsets.UTF_8)
                             val packageRegex = Regex("""package="([^"]+)"""")
                             val match = packageRegex.find(manifestContent)
                             val packageName = match?.groups?.get(1)?.value
                             if (packageName != null && !buildGradleContent.contains("namespace")) {
                                 println("Setting namespace in ${buildGradleFile}")
                                 val newContent = buildGradleContent.replaceFirst(
                                     Regex("""android\s*\{"""),
                                     "android {\n    namespace '$packageName'"
                                 )
                                 buildGradleFile.writeText(newContent, Charsets.UTF_8)
                             }
                         }
                     }

                     // Remove package attribute from AndroidManifest.xml files
                     fileTree(mapOf("dir" to projectDir, "includes" to listOf("**/AndroidManifest.xml")))
                         .forEach { manifestFile ->
                             val manifestContent = manifestFile.readText(Charsets.UTF_8)
                             if (manifestContent.contains("package=")) {
                                 println("Removing package attribute from $manifestFile")
                                 val newContent = manifestContent.replace(Regex("""package="[^"]*""""), "")
                                 manifestFile.writeText(newContent, Charsets.UTF_8)
                             }
                         }
                 }
             }

             // Ensure the task runs before the build process
             tasks.matching { it.name.startsWith("preBuild") }.configureEach {
                 dependsOn("fixManifestsAndNamespace")
             }
         }
     }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    if (project.name == "flutter_jailbreak_detection") {
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            kotlinOptions {
                jvmTarget = "1.8"
            }
        }
    }
}