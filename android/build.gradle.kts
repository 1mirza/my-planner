import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")
subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
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
        if (project.plugins.hasPlugin("com.android.library") || project.plugins.hasPlugin("com.android.application")) {
            val android = project.extensions.findByType(BaseExtension::class.java)
            android?.namespace = android?.namespace ?: "com.example.${project.name.replace("-", "_")}"
        }
    }
}

