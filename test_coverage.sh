#!/bin/bash

# Test Coverage Script for SonarQube LCOV Reports
# This script runs Flutter tests with coverage and generates LCOV reports

echo "🧪 Starting Flutter Test Coverage for SonarQube..."

# Clean previous coverage data
echo "🧹 Cleaning previous coverage data..."
rm -rf coverage/
flutter clean

# Run tests with coverage
echo "📊 Running tests with coverage..."
flutter test --coverage --test-randomize-ordering-seed random

# Check if tests passed
if [ $? -eq 0 ]; then
    echo "✅ Tests passed successfully!"
else
    echo "❌ Tests failed!"
    exit 1
fi

# Generate LCOV report
echo "📈 Generating LCOV report..."
genhtml coverage/lcov.info -o coverage/html

# Check if LCOV file exists
if [ -f "coverage/lcov.info" ]; then
    echo "✅ LCOV report generated successfully!"
    echo "📁 Coverage files location:"
    echo "   - LCOV data: coverage/lcov.info"
    echo "   - HTML report: coverage/html/index.html"
    
    # Display coverage summary
    echo "📊 Coverage Summary:"
    lcov --summary coverage/lcov.info
    
    # Check for companion registration coverage specifically
    echo "🎯 Companion Registration Coverage:"
    grep -A 10 "companion_registration" coverage/lcov.info || echo "No companion registration coverage data found"
    
else
    echo "❌ Failed to generate LCOV report!"
    exit 1
fi

echo "🎉 Coverage generation completed!"
echo "📋 Next steps:"
echo "   1. Upload coverage/lcov.info to SonarQube"
echo "   2. View detailed coverage at coverage/html/index.html"
echo "   3. Check SonarQube dashboard for coverage metrics" 