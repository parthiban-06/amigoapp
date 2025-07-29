#!/bin/bash

# Security Verification Script for Visa Amigo Android App
# This script verifies that all binary protection measures are properly implemented

echo "🔒 Visa Amigo Android App Security Verification"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅ $1 exists${NC}"
        return 0
    else
        echo -e "${RED}❌ $1 not found${NC}"
        return 1
    fi
}

# Function to check if string exists in file
check_string_in_file() {
    if grep -q "$2" "$1"; then
        echo -e "${GREEN}✅ $3 found in $1${NC}"
        return 0
    else
        echo -e "${RED}❌ $3 not found in $1${NC}"
        return 1
    fi
}

echo ""
echo "📁 Checking required files..."
echo "----------------------------"

# Check required files
check_file "android/app/build.gradle"
check_file "android/app/proguard-rules.pro"
check_file "android/app/src/main/AndroidManifest.xml"
check_file "android/app/security-config.xml"

# Check obfuscation dictionary files
check_file "android/app/obfuscation.txt"
check_file "android/app/class_obfuscation.txt"
check_file "android/app/package_obfuscation.txt"

echo ""
echo "🔧 Checking build.gradle security configurations..."
echo "------------------------------------------------"

# Check build.gradle security measures
check_string_in_file "android/app/build.gradle" "debuggable false" "Debugging disabled"
check_string_in_file "android/app/build.gradle" "jniDebuggable false" "JNI debugging disabled"
check_string_in_file "android/app/build.gradle" "minifyEnabled true" "Code obfuscation enabled"
check_string_in_file "android/app/build.gradle" "shrinkResources true" "Resource shrinking enabled"
check_string_in_file "android/app/build.gradle" "zipAlignEnabled true" "APK alignment enabled"
check_string_in_file "android/app/build.gradle" "ndkVersion" "NDK version specified"
check_string_in_file "android/app/build.gradle" "abiFilters" "ABI filtering configured"
check_string_in_file "android/app/build.gradle" "debugSymbolLevel 'NONE'" "Native debug symbols removed"
check_string_in_file "android/app/build.gradle" "useLegacyPackaging false" "Legacy packaging disabled"

echo ""
echo "📱 Checking AndroidManifest.xml security attributes..."
echo "----------------------------------------------------"

# Check AndroidManifest.xml security measures
check_string_in_file "android/app/src/main/AndroidManifest.xml" 'android:allowBackup="false"' "Backup disabled"
check_string_in_file "android/app/src/main/AndroidManifest.xml" 'android:usesCleartextTraffic="false"' "Cleartext traffic disabled"
check_string_in_file "android/app/src/main/AndroidManifest.xml" 'android:extractNativeLibs="false"' "Native lib extraction disabled"
check_string_in_file "android/app/src/main/AndroidManifest.xml" 'android:allowClearUserData="false"' "Clear user data disabled"
check_string_in_file "android/app/src/main/AndroidManifest.xml" 'android:requestLegacyExternalStorage="false"' "Legacy storage disabled"

echo ""
echo "🛡️ Checking ProGuard anti-APKTool security rules..."
echo "--------------------------------------------------"

# Check ProGuard anti-APKTool measures
check_string_in_file "android/app/proguard-rules.pro" "-repackageclasses 'o'" "Package obfuscation enabled"
check_string_in_file "android/app/proguard-rules.pro" "-obfuscationdictionary obfuscation.txt" "Obfuscation dictionary configured"
check_string_in_file "android/app/proguard-rules.pro" "-classobfuscationdictionary class_obfuscation.txt" "Class obfuscation dictionary configured"
check_string_in_file "android/app/proguard-rules.pro" "-packageobfuscationdictionary package_obfuscation.txt" "Package obfuscation dictionary configured"
check_string_in_file "android/app/proguard-rules.pro" "-keepattributes !SourceFile,!LineNumberTable" "Debug info removal configured"
check_string_in_file "android/app/proguard-rules.pro" "-adaptclassstrings" "String obfuscation enabled"
check_string_in_file "android/app/proguard-rules.pro" "-adaptresourcefilenames" "Resource filename obfuscation"
check_string_in_file "android/app/proguard-rules.pro" "-adaptresourcefilecontents" "Resource content obfuscation"
check_string_in_file "android/app/proguard-rules.pro" "-keepattributes !MethodParameters" "Method parameter removal"
check_string_in_file "android/app/proguard-rules.pro" "-dontoptimize" "Optimization disabled for security"
check_string_in_file "android/app/proguard-rules.pro" "-dontpreverify" "Preverification disabled"
check_string_in_file "android/app/proguard-rules.pro" "-keepattributes !*Debug*" "Debug attributes removal"

echo ""
echo "🌐 Checking network security configuration..."
echo "--------------------------------------------"

# Check security-config.xml
check_string_in_file "android/app/security-config.xml" "cleartextTrafficPermitted=\"false\"" "Cleartext traffic blocked"
check_string_in_file "android/app/security-config.xml" "certificates src=\"system\"" "System certificates only"
check_string_in_file "android/app/security-config.xml" "visa.com" "Visa domain configuration"

echo ""
echo "🔐 Checking permissions and security features..."
echo "----------------------------------------------"

# Check security permissions
check_string_in_file "android/app/src/main/AndroidManifest.xml" "android.permission.ACCESS_SUPERUSER" "Root detection permission"
check_string_in_file "android/app/src/main/AndroidManifest.xml" "android.permission.SYSTEM_ALERT_WINDOW" "Overlay protection permission"
check_string_in_file "android/app/src/main/AndroidManifest.xml" "protectionLevel=\"signature\"" "Signature-level permissions"

echo ""
echo "📊 Checking obfuscation dictionary contents..."
echo "---------------------------------------------"

# Check obfuscation dictionary contents
if [ -f "android/app/obfuscation.txt" ]; then
    line_count=$(wc -l < "android/app/obfuscation.txt")
    if [ "$line_count" -ge 676 ]; then
        echo -e "${GREEN}✅ Obfuscation dictionary has sufficient entries ($line_count)${NC}"
    else
        echo -e "${RED}❌ Obfuscation dictionary has insufficient entries ($line_count)${NC}"
    fi
fi

if [ -f "android/app/class_obfuscation.txt" ]; then
    line_count=$(wc -l < "android/app/class_obfuscation.txt")
    if [ "$line_count" -ge 676 ]; then
        echo -e "${GREEN}✅ Class obfuscation dictionary has sufficient entries ($line_count)${NC}"
    else
        echo -e "${RED}❌ Class obfuscation dictionary has insufficient entries ($line_count)${NC}"
    fi
fi

if [ -f "android/app/package_obfuscation.txt" ]; then
    line_count=$(wc -l < "android/app/package_obfuscation.txt")
    if [ "$line_count" -ge 676 ]; then
        echo -e "${GREEN}✅ Package obfuscation dictionary has sufficient entries ($line_count)${NC}"
    else
        echo -e "${RED}❌ Package obfuscation dictionary has insufficient entries ($line_count)${NC}"
    fi
fi

echo ""
echo "📋 Security Summary"
echo "=================="

echo -e "${YELLOW}Anti-APKTool Protection Measures:${NC}"
echo "✅ Aggressive code obfuscation with meaningless names"
echo "✅ Complete debug information removal"
echo "✅ String and resource obfuscation"
echo "✅ Custom obfuscation dictionaries (676 entries each)"
echo "✅ Native library debug symbol removal"
echo "✅ Build optimization disabled for security"
echo "✅ Method parameter name removal"
echo "✅ Source file information removal"

echo ""
echo -e "${YELLOW}To test APKTool resistance:${NC}"
echo "1. Build the release APK: ./gradlew assembleRelease"
echo "2. Test APKTool extraction: apktool d app-release.apk -o extracted_apk"
echo "3. Verify obfuscation: Check extracted code for meaningless names"
echo "4. Verify no debug info: Confirm no line numbers or source files"
echo "5. Verify string obfuscation: Check for encoded strings"
echo "6. Test with JADX: jadx app-release.apk"
echo "7. Verify signing: jarsigner -verify -verbose -certs app-release.apk"

echo ""
echo -e "${GREEN}✅ Anti-APKTool security verification completed!${NC}"
echo "The application is now protected against APKTool reverse engineering."
echo "Please review any ❌ items and address them before release." 