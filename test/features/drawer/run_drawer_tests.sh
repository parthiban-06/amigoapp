#!/bin/bash

# Drawer Feature Test Runner with LCOV Coverage
# This script runs all drawer-related tests and generates coverage reports

echo "🧪 Running Drawer Feature Tests with LCOV Coverage..."

# Set up environment
export FLUTTER_TEST_ARGS="--coverage"

# Create coverage directory if it doesn't exist
mkdir -p test_coverage/drawer

# Run the comprehensive drawer test
echo "📋 Running comprehensive drawer tests..."
flutter test test/features/drawer/drawer_comprehensive_test.dart \
  --coverage \
  --coverage-path=test_coverage/drawer/comprehensive_coverage.info

# Run individual test files for better granular coverage
echo "📋 Running drawer provider tests..."
flutter test test/features/drawer/provider/drawer_provider_test.dart \
  --coverage \
  --coverage-path=test_coverage/drawer/provider_coverage.info

echo "📋 Running drawer widget tests..."
flutter test test/features/drawer/widgets/drawer_widget_test.dart \
  --coverage \
  --coverage-path=test_coverage/drawer/widget_coverage.info

# Generate HTML coverage report
echo "📊 Generating HTML coverage report..."
genhtml test_coverage/drawer/comprehensive_coverage.info \
  -o test_coverage/drawer/html_report \
  --title="Drawer Feature Coverage Report"

# Display coverage summary
echo "📈 Coverage Summary:"
lcov --summary test_coverage/drawer/comprehensive_coverage.info

echo "✅ Drawer tests completed!"
echo "📁 Coverage report available at: test_coverage/drawer/html_report/index.html"

# Optional: Open coverage report in browser (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "🌐 Opening coverage report in browser..."
  open test_coverage/drawer/html_report/index.html
fi 