allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}

// <<< این بخش کلیدی است که باید اضافه شود >>>
// این بلوک به صورت خودکار به پکیج‌های قدیمی namespace اضافه می‌کند
subprojects {
    afterEvaluate {project ->
        if (project.hasProperty("android")) {
            android {
                if (namespace == null) {
                    namespace "com.example.${project.name.replaceAll('-', '_').replaceAll(':', '.')}"
                }
            }
        }
    }
}

