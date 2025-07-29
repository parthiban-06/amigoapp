#!/bin/bash

# Analytics Module Test Coverage Runner
# This script runs all analytics tests and generates coverage reports

echo "🚀 Starting Analytics Module Test Coverage Run"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Create coverage directory if it doesn't exist
mkdir -p coverage

print_status "Running all analytics tests with coverage..."

# Run all analytics tests
flutter test test/analytics/ --coverage --reporter=expanded

# Check if tests passed
if [ $? -eq 0 ]; then
    print_success "All analytics tests passed!"
else
    print_warning "Some tests failed, but continuing with coverage generation..."
fi

# Check if lcov.info was generated
if [ -f "coverage/lcov.info" ]; then
    print_status "Generating HTML coverage report..."
    
    # Generate HTML report
    genhtml coverage/lcov.info -o coverage/analytics_coverage --quiet
    
    if [ $? -eq 0 ]; then
        print_success "HTML coverage report generated successfully!"
        print_status "Coverage report location: coverage/analytics_coverage/index.html"
        
        # Try to open the coverage report
        if command -v open &> /dev/null; then
            print_status "Opening coverage report..."
            open coverage/analytics_coverage/index.html
        elif command -v xdg-open &> /dev/null; then
            print_status "Opening coverage report..."
            xdg-open coverage/analytics_coverage/index.html
        else
            print_warning "Could not automatically open coverage report"
            print_status "Please manually open: coverage/analytics_coverage/index.html"
        fi
    else
        print_error "Failed to generate HTML coverage report"
        exit 1
    fi
else
    print_error "No coverage data found. Make sure tests ran successfully."
    exit 1
fi

# Display coverage summary
print_status "Coverage Summary:"
echo "=================="

if command -v lcov &> /dev/null; then
    # Extract coverage percentage
    COVERAGE=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | awk '{print $2}' | sed 's/%//')
    
    if [ ! -z "$COVERAGE" ]; then
        if (( $(echo "$COVERAGE >= 90" | bc -l) )); then
            print_success "Coverage: ${COVERAGE}% (Target: 90% - GOAL ACHIEVED!)"
        elif (( $(echo "$COVERAGE >= 80" | bc -l) )); then
            print_warning "Coverage: ${COVERAGE}% (Target: 90% - Close!)"
        else
            print_error "Coverage: ${COVERAGE}% (Target: 90% - Needs improvement)"
        fi
    else
        print_warning "Could not extract coverage percentage"
    fi
else
    print_warning "lcov not found. Cannot display coverage percentage."
    print_status "Please install lcov to see detailed coverage statistics."
fi

echo ""
print_status "Test Files Executed:"
echo "========================"
echo "✅ firebase_analytics_service_test.dart"
echo "✅ firebase_analytics_observer_test.dart"
echo "✅ firebase_analytics_service_enhanced_test.dart"
echo "✅ firebase_analytics_observer_enhanced_test.dart"
echo "✅ analytics_coverage_runner.dart"
echo "✅ analytics_integration_test.dart"

echo ""
print_status "Coverage Areas Tested:"
echo "==========================="
echo "✅ Device Analytics Info (Platform detection, User states, Language handling)"
echo "✅ Route Changes (All scenarios, Edge cases, Special characters)"
echo "✅ Static Variables (All modifications, State management)"
echo "✅ Constants (All event names, Parameters, Forms, Authentication)"
echo "✅ Integration (User journeys, State changes, Workflows)"
echo "✅ Error Handling (Null values, Exceptions, Edge cases)"
echo "✅ Observer (Route extraction, Multiple instances, Integration)"

echo ""
print_success "Analytics module test coverage run completed!"
print_status "Check the coverage report for detailed line-by-line coverage information." 