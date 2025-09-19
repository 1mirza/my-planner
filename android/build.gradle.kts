allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")
subprojects {
    project.buildDir = File("${rootProject.buildDir}/${project.name}")
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}

// <<< این بخش کلیدی است که به زبان Kotlin نوشته شده >>>
// این بلوک به صورت خودکار به پکیج‌های قدیمی namespace اضافه می‌کند
subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library") || plugins.hasPlugin("com.android.application")) {
            android.namespace?.let { } ?: run {
                android.namespace = "com.example.${name.replace("-", "_")}"
            }
        }
    }
}

