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

subprojects {
    val configureProject: (Project) -> Unit = { proj ->
        val androidExt = proj.extensions.findByName("android")
        if (androidExt != null) {
            try {
                val m = androidExt.javaClass.getMethod("compileSdkVersion", Int::class.javaPrimitiveType)
                m.invoke(androidExt, 36)
            } catch (e: Exception) {
                try {
                    val m = androidExt.javaClass.getMethod("compileSdkVersion", java.lang.Integer::class.java)
                    m.invoke(androidExt, 36)
                } catch (e2: Exception) {
                    try {
                        val m = androidExt.javaClass.getMethod("setCompileSdk", java.lang.Integer::class.java)
                        m.invoke(androidExt, 36)
                    } catch (e3: Exception) {
                        proj.logger.error("Failed to set compileSdkVersion for ${proj.name}: $e3")
                    }
                }
            }
        }
    }

    if (state.executed) {
        configureProject(this)
    } else {
        afterEvaluate {
            configureProject(this)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
