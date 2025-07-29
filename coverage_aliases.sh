#!/bin/bash

# Coverage Aliases for VisaAmigo
# Add these to your ~/.zshrc or ~/.bashrc for permanent access

# Main coverage script
alias coverage='./test_coverage_commands.sh'

# Quick commands
alias cov-all='flutter test --coverage && genhtml coverage/lcov.info -o coverage/html_report && open coverage/html_report/index.html'
alias cov-core='flutter test --coverage test/core/ && genhtml coverage/lcov.info -o coverage/core_coverage && open coverage/core_coverage/index.html'
alias cov-utils='flutter test --coverage test/utils/ && genhtml coverage/lcov.info -o coverage/utils_coverage && open coverage/utils_coverage/index.html'
alias cov-features='flutter test --coverage test/features/ && genhtml coverage/lcov.info -o coverage/features_coverage && open coverage/features_coverage/index.html'
alias cov-baseview='flutter test --coverage test/core/base/view/base_view_test.dart && genhtml coverage/lcov.info -o coverage/baseview_coverage && open coverage/baseview_coverage/index.html'
alias cov-ai='flutter test --coverage test/features/ai_assistant/ && genhtml coverage/lcov.info -o coverage/ai_assistant_coverage && open coverage/ai_assistant_coverage/index.html'
alias cov-notification='flutter test --coverage test/features/notification/ && genhtml coverage/lcov.info -o coverage/notification_coverage && open coverage/notification_coverage/index.html'
alias cov-auth='flutter test --coverage test/features/login/ test/features/signup/ && genhtml coverage/lcov.info -o coverage/auth_coverage && open coverage/auth_coverage/index.html'
alias cov-companion='flutter test --coverage test/features/companion/ && genhtml coverage/lcov.info -o coverage/companion_coverage && open coverage/companion_coverage/index.html'
alias cov-itinerary='flutter test --coverage test/features/itinerary/ && genhtml coverage/lcov.info -o coverage/itinerary_coverage && open coverage/itinerary_coverage/index.html'
alias cov-wallet='flutter test --coverage test/features/wallet/ && genhtml coverage/lcov.info -o coverage/wallet_coverage && open coverage/wallet_coverage/index.html'
alias cov-biometric='flutter test --coverage test/features/biometric/ && genhtml coverage/lcov.info -o coverage/biometric_coverage && open coverage/biometric_coverage/index.html'

# Utility commands
alias cov-clean='rm -rf coverage/'
alias cov-open='open coverage/html_report/index.html'

# Pattern-based commands
alias cov-pattern='flutter test --coverage --name="$1" && genhtml coverage/lcov.info -o coverage/pattern_coverage && open coverage/pattern_coverage/index.html'

echo "Coverage aliases loaded. Available commands:"
echo "  cov-all         - Run all tests with coverage"
echo "  cov-core        - Run core module tests"
echo "  cov-utils       - Run utils tests"
echo "  cov-features    - Run features tests"
echo "  cov-baseview    - Run BaseView tests only"
echo "  cov-ai          - Run AI Assistant tests"
echo "  cov-notification - Run notification tests"
echo "  cov-auth        - Run login/signup tests"
echo "  cov-companion   - Run companion tests"
echo "  cov-itinerary   - Run itinerary tests"
echo "  cov-wallet      - Run wallet tests"
echo "  cov-biometric   - Run biometric tests"
echo "  cov-clean       - Clean coverage data"
echo "  cov-open        - Open main coverage report"
echo "  coverage        - Show coverage script menu" 