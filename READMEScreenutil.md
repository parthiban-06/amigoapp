# Flutter ScreenUtil Integration Guide

A comprehensive guide for integrating and using the flutter_screenutil package to create responsive
Flutter applications.

## Table of Contents

- [Installation](#installation)
- [Basic Setup](#basic-setup)
- [Usage](#usage)
    - [Size Extensions](#size-extensions)
    - [Responsive Text](#responsive-text)
    - [Responsive Widgets](#responsive-widgets)
    - [Custom Widgets](#custom-widgets)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)
- [Examples](#examples)

## Installation

Add flutter_screenutil to your pubspec.yaml file:

```yaml
dependencies:
  flutter_screenutil: ^5.9.0  # Use latest version
```

Run flutter pub get:

```bash
flutter pub get
```

## Basic Setup

Initialize ScreenUtil in your main.dart file:

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrap your app with ScreenUtilInit
    return ScreenUtilInit(
      // Design size from your Figma or Adobe XD canvas
      designSize: const Size(375, 812), // iPhone 13 size
      minTextAdapt: true,  // Enable minimum text adaptation
      splitScreenMode: true, // Support split screen
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: const HomePage(),
    );
  }
}
```

## Usage

### Size Extensions

ScreenUtil provides various extensions for making your UI responsive:

```dart
// Responsive width and height
Container(
  width: 100.w,    // Responsive width
  height: 200.h,   // Responsive height
  padding: EdgeInsets.all( 10.r), // Responsive padding
  margin: EdgeInsets.symmetric(
    horizontal: 15.w,
    vertical: 10.h,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular( 10.6), // Responsive radius
  ),
);

// Responsive positioning
Positioned(
  left:20.w,
  top: 30.h,
  child: Container(),
);

// Get screen information
double screenWidth = 1.sw;    // Screen width
double screenHeight = 1.sh;   // Screen height
double statusBarHeight = ScreenUtil().statusBarHeight;  // Status bar height
double bottomBarHeight = ScreenUtil().bottomBarHeight;  // Bottom bar height
```

### Responsive Text

Make your text responsive using the .sp extension:

```dart
// Basic text styling
Text(
  'Hello World',
  style: TextStyle(
    fontSize: 16.sp,
    height: 1.2.h,
    letterSpacing: 0.5.w,
  ),
);

// Theme text styling
ThemeData(
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      height: 1.5.h,
    ),
  ),
);
```

### Responsive Widgets

Create responsive custom widgets:

```dart
class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ResponsiveButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        minimumSize: Size(200.w, 48.h),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }
}
```

### Custom Widget Constants

Create a constants file for commonly used sizes:

```dart
// lib/constants/sizes.dart
abstract class Sizes {
  // Padding and margin sizes
  static double xs = 4.r;
  static double sm = 8.r;
  static double md = 16.r;
  static double lg = 24.r;
  static double xl = 32.r;

  // Font sizes
  static double fontXs = 12.sp;
  static double fontSm = 14.sp;
  static double fontMd = 16.sp;
  static double fontLg = 18.sp;
  static double fontXl = 20.sp;

  // Icon sizes
  static double iconXs = 16.r;
  static double iconSm = 20.r;
  static double iconMd = 24.r;
  static double iconLg = 32.r;

  // Button sizes
  static double buttonHeight = 48.h;
  static double buttonWidth = 120.w;
  static double buttonRadius = 8.r;

  // Input field sizes
  static double inputHeight = 56.h;
  static double inputRadius = 8.r;

  // Card sizes
  static double cardRadius = 16.r;
  static double cardPadding = 16.r;
}
```

## Best Practices

1. **Consistent Design Size:**

```dart
// Use the same design size across your app
const Size designSize = Size(375, 812);

// In main.dart
ScreenUtilInit(
  designSize: designSize,
  // ...
);
```

2. **Create Base Widgets:**

```dart
class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const AppText(
    this.text, {
    Key? key,
    this.fontSize,
    this.fontWeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize?.sp ?? 14.sp,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
```

3. **Responsive Spacing:**

```dart
class Spacing {
  static Widget vertical(double height) => SizedBox(height: height.h);
  static Widget horizontal(double width) => SizedBox(width: width.w);
}

// Usage
Column(
  children: [
    Text('First Item'),
    Spacing.vertical(16), // AppSizes.heightSmall spacing
    Text('Second Item'),
  ],
);
```

## Common Pitfalls

1. **Incorrect Import:**

```dart
// ❌ Wrong
import 'package:flutter_screenutil/screen_util.dart';

// ✅ Correct
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

2. **Missing ScreenUtilInit:**

```dart
// ❌ Wrong
void main() => runApp(MaterialApp(home: MyApp()));

// ✅ Correct
void main() => runApp(
  ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (_, child) => MaterialApp(home: child),
    child: const MyApp(),
  ),
);
```

3. **Using Raw Numbers:**

```dart
// ❌ Wrong
Container(
  width: 100,
  height: 200,
);

// ✅ Correct
Container(
  width: 100.w,
  height: 200.h,
);
```

## Examples

### Complete Screen Example

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 18.sp),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50.r,
              backgroundImage: AssetImage('assets/profile.png'),
            ),
            SizedBox(height: AppSizes.heightSmall),
            
            // Name
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            
            // Email
            Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height:AppSizes.heightTweentyFour),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('Posts', '245'),
                _buildStat('Followers', '10.2K'),
                _buildStat('Following', '89'),
              ],
            ),
            SizedBox(height:AppSizes.heightTweentyFour),
            
            // Edit Profile Button
            SizedBox(
              width: 200.w,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
```

This profile screen example demonstrates the comprehensive use of ScreenUtil for creating a fully
responsive UI that adapts to different screen sizes while maintaining visual consistency.