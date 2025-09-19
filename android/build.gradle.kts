import com.android.build.gradle.LibraryExtension

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

// <<< این بخش کلیدی است که با روش صحیح (withId) نوشته شده >>>
// این بلوک به صورت خودکار به پکیج‌های قدیمی namespace اضافه می‌کند
subprojects {
    plugins.withId("com.android.library") {
        extensions.findByType(LibraryExtension::class.java)?.apply {
            namespace = namespace ?: "com.example.${project.name.replace("-", "_")}"
        }
    }
}

