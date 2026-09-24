# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# CameraX
-keep class androidx.camera.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep annotations
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions

# Don't warn
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**