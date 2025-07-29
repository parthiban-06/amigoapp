#!/bin/bash

# Test Coverage Commands Script for VisaAmigo Flutter App
# This script provides various commands for running tests and generating HTML coverage reports

echo "=== VisaAmigo Test Coverage Commands ==="
echo ""

# Function to run tests and generate coverage for specific folders
run_folder_tests() {
    local folder_path=$1
    local report_name=$2
    
    echo "Running tests for folder: $folder_path"
    echo "Generating coverage report: $report_name"
    echo ""
    
    # Run tests with coverage for specific folder
    flutter test --coverage "$folder_path"
    
    # Generate HTML report
    if [ -f "coverage/lcov.info" ]; then
        genhtml coverage/lcov.info -o "coverage/$report_name"
        echo "✅ HTML report generated: coverage/$report_name"
        echo "📊 Open report: open coverage/$report_name/index.html"
    else
        echo "❌ No coverage data generated"
    fi
}

# Function to run specific test file
run_specific_test() {
    local test_file=$1
    local report_name=$2
    
    echo "Running test file: $test_file"
    echo "Generating coverage report: $report_name"
    echo ""
    
    flutter test --coverage "$test_file"
    
    if [ -f "coverage/lcov.info" ]; then
        genhtml coverage/lcov.info -o "coverage/$report_name"
        echo "✅ HTML report generated: coverage/$report_name"
        echo "📊 Open report: open coverage/$report_name/index.html"
    else
        echo "❌ No coverage data generated"
    fi
}

# Main menu
case "${1:-}" in
    "analytics")
        echo "📊 Running Analytics Module Tests"
        run_folder_tests "test/analytics/" "analytics_coverage"
        ;;
    "analytics-service")
        echo "📊 Running FirebaseAnalyticsService Tests"
        run_specific_test "test/analytics/firebase_analytics_service_test.dart" "analytics_service_coverage"
        ;;
    "analytics-observer")
        echo "📊 Running FirebaseAnalyticsRouteObserver Tests"
        run_specific_test "test/analytics/firebase_analytics_observer_test.dart" "analytics_observer_coverage"
        ;;
    "analytics-integration")
        echo "📊 Running Analytics Integration Tests"
        run_specific_test "test/analytics/analytics_integration_test.dart" "analytics_integration_coverage"
        ;;
    "baseview")
        echo "📊 Running BaseView Tests"
        run_specific_test "test/core/base/view/base_view_test.dart" "baseview_coverage"
        ;;
    "utils")
        echo "📊 Running Utils Tests"
        run_folder_tests "test/utils/" "utils_coverage"
        ;;
    "core")
        echo "📊 Running Core Module Tests"
        run_folder_tests "test/core/" "core_coverage"
        ;;
    "features")
        echo "📊 Running Features Tests"
        run_folder_tests "test/features/" "features_coverage"
        ;;
    "all")
        echo "📊 Running All Tests"
        flutter test --coverage
        if [ -f "coverage/lcov.info" ]; then
            genhtml coverage/lcov.info -o "coverage/html_report"
            echo "✅ HTML report generated: coverage/html_report"
            echo "📊 Open report: open coverage/html_report/index.html"
        fi
        ;;
    "clean")
        echo "🧹 Cleaning coverage data"
        rm -rf coverage/
        echo "✅ Coverage data cleaned"
        ;;
    "help"|"")
        echo "Available commands:"
        echo "  analytics          - Run all analytics module tests"
        echo "  analytics-service  - Run FirebaseAnalyticsService tests only"
        echo "  analytics-observer - Run FirebaseAnalyticsRouteObserver tests only"
        echo "  analytics-integration - Run analytics integration tests only"
        echo "  baseview           - Run BaseView tests only"
        echo "  utils              - Run utils tests only"
        echo "  core               - Run core module tests only"
        echo "  features           - Run features tests only"
        echo "  all                - Run all tests"
        echo "  clean              - Clean coverage data"
        echo "  help               - Show this help message"
        echo ""
        echo "Examples:"
        echo "  ./test_coverage_commands.sh analytics"
        echo "  ./test_coverage_commands.sh analytics-service"
        echo "  ./test_coverage_commands.sh all"
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo "Use './test_coverage_commands.sh help' for available commands"
        exit 1
        ;;
esac 