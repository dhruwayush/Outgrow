# Proguard rules for Outgrow
# Add any specific rules here if needed for dependencies like Hive or various plugins.

# flutter_local_notifications serialises scheduled notifications with Gson.
-keep class com.dexterous.** { *; }
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type
-keepattributes Signature
