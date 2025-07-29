#!/bin/bash

# Build script for QA configuration
echo "Cleaning build..."
rm -rf build/
rm -rf ios/build/

echo "Installing pods..."
cd ios
pod install

echo "Building for QA configuration..."
xcodebuild -workspace Runner.xcworkspace -scheme qa -configuration Debug-qa -destination 'platform=iOS Simulator,name=iPhone 16 Plus' build

echo "Build completed!" 