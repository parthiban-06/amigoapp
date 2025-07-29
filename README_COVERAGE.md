# Test Coverage Commands for VisaAmigo

This document provides comprehensive commands for running tests and generating coverage reports for
the VisaAmigo Flutter application.

## Quick Start

### 1. Using the Script (Recommended)

```bash
# Show all available commands
./test_coverage_commands.sh

# Run BaseView tests only
./test_coverage_commands.sh baseview

# Run utils tests
./test_coverage_commands.sh utils

# Run core module tests
./test_coverage_commands.sh core

# Run all tests
./test_coverage_commands.sh all

# Clean coverage data
./test_coverage_commands.sh clean
```

### 2. Direct Commands

#### Run All Tests with Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html_report
open coverage/html_report/index.html
```

#### Run Specific Module Tests

**Core Module:**

```bash
flutter test --coverage test/core/
genhtml coverage/lcov.info -o coverage/core_coverage
open coverage/core_coverage/index.html
```

**Utils Module:**

```bash
flutter test --coverage test/utils/
genhtml coverage/lcov.info -o coverage/utils_coverage
open coverage/utils_coverage/index.html
```

**Features Module:**

```bash
flutter test --coverage test/features/
genhtml coverage/lcov.info -o coverage/features_coverage
open coverage/features_coverage/index.html
```

#### Run Specific Feature Tests

**AI Assistant:**

```bash
flutter test --coverage test/features/ai_assistant/
genhtml coverage/lcov.info -o coverage/ai_assistant_coverage
open coverage/ai_assistant_coverage/index.html
```

**Notification:**

```bash
flutter test --coverage test/features/notification/
genhtml coverage/lcov.info -o coverage/notification_coverage
open coverage/notification_coverage/index.html
```

**Login/Signup:**

```bash
flutter test --coverage test/features/login/
genhtml coverage/lcov.info -o coverage/login_coverage
open coverage/login_coverage/index.html
```

**Companion:**

```bash
flutter test --coverage test/features/companion/
genhtml coverage/lcov.info -o coverage/companion_coverage
open coverage/companion_coverage/index.html
```

**Itinerary:**

```bash
flutter test --coverage test/features/itinerary/
genhtml coverage/lcov.info -o coverage/itinerary_coverage
open coverage/itinerary_coverage/index.html
```

**Wallet:**

```bash
flutter test --coverage test/features/wallet/
genhtml coverage/lcov.info -o coverage/wallet_coverage
open coverage/wallet_coverage/index.html
```

**Biometric:**

```bash
flutter test --coverage test/features/biometric/
genhtml coverage/lcov.info -o coverage/biometric_coverage
open coverage/biometric_coverage/index.html
```

#### Run Specific Test Files

**BaseView Tests Only:**

```bash
flutter test --coverage test/core/base/view/base_view_test.dart
genhtml coverage/lcov.info -o coverage/baseview_coverage
open coverage/baseview_coverage/index.html
```

**Specific Test File:**

```bash
flutter test --coverage test/utils/utils_test.dart
genhtml coverage/lcov.info -o coverage/utils_specific_coverage
open coverage/utils_specific_coverage/index.html
```

#### Run Tests by Pattern

**Tests with "BaseView" in name:**

```bash
flutter test --coverage --name="BaseView"
genhtml coverage/lcov.info -o coverage/baseview_pattern_coverage
open coverage/baseview_pattern_coverage/index.html
```

**Tests with "Utils" in name:**

```bash
flutter test --coverage --name="Utils"
genhtml coverage/lcov.info -o coverage/utils_pattern_coverage
open coverage/utils_pattern_coverage/index.html
```

**Tests with "Provider" in name:**

```bash
flutter test --coverage --name="Provider"
genhtml coverage/lcov.info -o coverage/provider_pattern_coverage
open coverage/provider_pattern_coverage/index.html
```

#### Multiple Test Files

```bash
flutter test --coverage test/utils/utils_test.dart test/utils/utils_datetime_test.dart
genhtml coverage/lcov.info -o coverage/multiple_utils_coverage
open coverage/multiple_utils_coverage/index.html
```

### 3. One-Liner Commands

**Quick BaseView Coverage:**

```bash
flutter test --coverage test/core/base/view/base_view_test.dart && genhtml coverage/lcov.info -o coverage/baseview_coverage && open coverage/baseview_coverage/index.html
```

**Quick Utils Coverage:**

```bash
flutter test --coverage test/utils/ && genhtml coverage/lcov.info -o coverage/utils_coverage && open coverage/utils_coverage/index.html
```

**Quick Core Coverage:**

```bash
flutter test --coverage test/core/ && genhtml coverage/lcov.info -o coverage/core_coverage && open coverage/core_coverage/index.html
```

## Utility Commands

### Clean Coverage Data

```bash
rm -rf coverage/
```

### Open Existing Report

```bash
open coverage/html_report/index.html
```

## Coverage Report Locations

All HTML reports are generated in the `coverage/` directory:

- `coverage/html_report/` - Main coverage report
- `coverage/core_coverage/` - Core module coverage
- `coverage/utils_coverage/` - Utils coverage
- `coverage/features_coverage/` - Features coverage
- `coverage/baseview_coverage/` - BaseView specific coverage
- `coverage/ai_assistant_coverage/` - AI Assistant coverage
- `coverage/notification_coverage/` - Notification coverage
- `coverage/login_coverage/` - Login coverage
- `coverage/companion_coverage/` - Companion coverage
- `coverage/itinerary_coverage/` - Itinerary coverage
- `coverage/wallet_coverage/` - Wallet coverage
- `coverage/biometric_coverage/` - Biometric coverage

## Script Usage

### Available Script Commands

```bash
./test_coverage_commands.sh <command> [options]
```

**Commands:**

- `all` - Run all tests with coverage
- `core` - Run core module tests
- `utils` - Run utils tests
- `features` - Run feature tests
- `specific <file>` - Run specific test file
- `pattern <pattern>` - Run tests by pattern
- `baseview` - Run BaseView tests only
- `ai` - Run AI Assistant tests
- `notification` - Run notification tests
- `auth` - Run login/signup tests
- `companion` - Run companion tests
- `itinerary` - Run itinerary tests
- `wallet` - Run wallet tests
- `biometric` - Run biometric tests
- `clean` - Clean coverage data
- `open` - Open main coverage report

### Examples

```bash
# Run BaseView tests
./test_coverage_commands.sh baseview

# Run specific test file
./test_coverage_commands.sh specific test/utils/utils_test.dart utils_specific

# Run tests by pattern
./test_coverage_commands.sh pattern 'BaseView' baseview_coverage

# Clean coverage data
./test_coverage_commands.sh clean
```

## Setup Aliases (Optional)

To make commands even easier, you can add aliases to your shell configuration:

```bash
# Add to ~/.zshrc or ~/.bashrc
source ./coverage_aliases.sh
```

Then you can use:

- `cov-all` - Run all tests
- `cov-core` - Run core tests
- `cov-utils` - Run utils tests
- `cov-baseview` - Run BaseView tests
- `cov-clean` - Clean coverage data
- `coverage` - Show script menu

## Prerequisites

1. **Flutter SDK** - Make sure Flutter is installed and configured
2. **lcov** - Install lcov for HTML report generation:
   ```bash
   # macOS
   brew install lcov
   
   # Ubuntu/Debian
   sudo apt-get install lcov
   
   # Windows
   # Download from https://github.com/linux-test-project/lcov
   ```

3. **genhtml** - Usually comes with lcov installation

## Troubleshooting

### Empty Coverage File

If you get "empty trace file" error:

```bash
# Clean coverage data first
rm -rf coverage/

# Run tests again
flutter test --coverage test/core/base/view/base_view_test.dart
```

### Missing genhtml

If genhtml is not found:

```bash
# Install lcov (includes genhtml)
brew install lcov  # macOS
sudo apt-get install lcov  # Ubuntu/Debian
```

### Platform-Specific Commands

For different operating systems, replace `open` with:

- **Linux:** `xdg-open coverage/report_name/index.html`
- **Windows:** `start coverage/report_name/index.html`

## Notes

- Coverage data is cumulative - running multiple test commands will combine coverage data
- Use `clean` command to reset coverage data between different test runs
- HTML reports provide detailed line-by-line coverage information
- The `--coverage` flag generates LCOV format data
- `genhtml` converts LCOV data to readable HTML reports

## Files Created

- `test_coverage_commands.sh` - Main script with all commands
- `coverage_commands.md` - Detailed command reference
- `coverage_aliases.sh` - Shell aliases for quick access
- `README_COVERAGE.md` - This comprehensive guide 