# Flutter and Dart VM rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Keep entry points for method channels
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers class * {
   public <init>(android.content.Context);
}

# Keep MainActivity
-keep class com.visa.eva.MainActivity { *; }

# Keep classes used by Firebase or other plugins
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Enhanced security: Remove all logging and debugging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}

# Remove debug information completely
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable,*Annotation*

# Aggressive obfuscation to prevent APKTool analysis
-repackageclasses 'o'
-obfuscationdictionary obfuscation.txt
-classobfuscationdictionary class_obfuscation.txt
-packageobfuscationdictionary package_obfuscation.txt

# Remove unused code and suppress warnings
-dontwarn **
-ignorewarnings

# Keep Firebase initialization
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Advanced security measures to prevent reverse engineering
-keepattributes !LocalVariableTable,!LocalVariableTypeTable
-keepattributes !Signature
-keepattributes !Exceptions

# Prevent reflection attacks and make APKTool analysis harder
-keepattributes !*Annotation*
-keepattributes !InnerClasses

# Aggressive string obfuscation
-adaptclassstrings
-adaptresourcefilenames
-adaptresourcefilecontents

# Remove method parameter names
-keepattributes !MethodParameters

# Keep essential Android components
-keep class android.support.v4.** { *; }
-keep class androidx.** { *; }
-dontwarn android.support.v4.**
-dontwarn androidx.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Anti-APKTool measures: Make class names meaningless
-repackageclasses 'a'
-allowaccessmodification

# Remove all debug information that APKTool could use
-keepattributes !SourceFile,!LineNumberTable,!LocalVariableTable,!LocalVariableTypeTable

# Make string analysis harder
-adaptclassstrings
-adaptresourcefilenames
-adaptresourcefilecontents

# Remove all annotations that could reveal information
-keepattributes !*Annotation*

# Prevent method inlining analysis
-dontoptimize

# Remove all exception information
-keepattributes !Exceptions

# Make control flow analysis harder
-dontpreverify

# Remove all debugging symbols
-keepattributes !*Debug*

# Anti-decompilation measures
-keepattributes !Code
-keepattributes !StackMapTable

# Make APKTool's analysis more difficult
-keepattributes !*Signature*
-keepattributes !*Deprecated*

# --- Additional Binary Protection Recommendations ---

# Anti-debugging: Remove debug info and block debuggers
-assumenosideeffects class android.os.Debug {
    public static boolean isDebuggerConnected();
    public static boolean isDebugging();
}
-assumenosideeffects class java.lang.System {
    public static void exit(int);
}

# Anti-tampering: Detect signature changes (implement runtime check in code)
# -keep class com.visa.eva.util.SignatureCheck { *; }

# String encryption: For advanced string encryption, consider commercial tools like DexGuard
# - No native ProGuard rule for string encryption; use obfuscation and avoid hardcoding secrets

# Recommendation: For maximum protection, consider integrating DexGuard or similar commercial solutions for:
# - String encryption
# - Class encryption
# - Runtime integrity checks
# - Root/jailbreak detection

# --- End of Binary Protection Recommendations ---

