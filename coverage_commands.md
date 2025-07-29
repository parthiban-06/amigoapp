# Test Coverage Commands for VisaAmigo

## Quick Commands

### Run All Tests with Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html_report
open coverage/html_report/index.html
```

### Run Specific Folder Tests

#### Core Module Tests

```bash
flutter test --coverage test/core/
genhtml coverage/lcov.info -o coverage/core_coverage
open coverage/core_coverage/index.html
```

#### Utils Tests

```bash
flutter test --coverage test/utils/
genhtml coverage/lcov.info -o coverage/utils_coverage
open coverage/utils_coverage/index.html
```

#### Features Tests

```bash
flutter test --coverage test/features/
genhtml coverage/lcov.info -o coverage/features_coverage
open coverage/features_coverage/index.html
```

#### AI Assistant Tests

```bash
flutter test --coverage test/features/ai_assistant/
genhtml coverage/lcov.info -o coverage/ai_assistant_coverage
open coverage/ai_assistant_coverage/index.html
```

#### Notification Tests

```bash
flutter test --coverage test/features/notification/
genhtml coverage/lcov.info -o coverage/notification_coverage
open coverage/notification_coverage/index.html
```

#### Login/Signup Tests

```bash
flutter test --coverage test/features/login/
genhtml coverage/lcov.info -o coverage/login_coverage
open coverage/login_coverage/index.html
```

#### Companion Tests

```bash
flutter test --coverage test/features/companion/
genhtml coverage/lcov.info -o coverage/companion_coverage
open coverage/companion_coverage/index.html
```

#### Itinerary Tests

```bash
flutter test --coverage test/features/itinerary/
genhtml coverage/lcov.info -o coverage/itinerary_coverage
open coverage/itinerary_coverage/index.html
```

#### Wallet Tests

```bash
flutter test --coverage test/features/wallet/
genhtml coverage/lcov.info -o coverage/wallet_coverage
open coverage/wallet_coverage/index.html
```

#### Biometric Tests

```bash
flutter test --coverage test/features/biometric/
genhtml coverage/lcov.info -o coverage/biometric_coverage
open coverage/biometric_coverage/index.html
```

### Run Specific Test Files

#### BaseView Tests Only

```bash
flutter test --coverage test/core/base/view/base_view_test.dart
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

#### Specific Test File

```bash
flutter test --coverage test/utils/utils_test.dart
genhtml coverage/lcov.info -o coverage/utils_specific_coverage
open coverage/utils_specific_coverage/index.html
```

### Run Tests by Pattern

#### Tests with "BaseView" in name

```bash
flutter test --coverage --name="BaseView"
genhtml coverage/lcov.info -o coverage/baseview_pattern_coverage
open coverage/baseview_pattern_coverage/index.html
```

#### Tests with "Utils" in name

```bash
flutter test --coverage --name="Utils"
genhtml coverage/lcov.info -o coverage/utils_pattern_coverage
open coverage/utils_pattern_coverage/index.html
```

#### Tests with "Provider" in name

```bash
flutter test --coverage --name="Provider"
genhtml coverage/lcov.info -o coverage/provider_pattern_coverage
open coverage/provider_pattern_coverage/index.html
```

### Multiple Test Files

```bash
flutter test --coverage test/utils/utils_test.dart test/utils/utils_datetime_test.dart
genhtml coverage/lcov.info -o coverage/multiple_utils_coverage
open coverage/multiple_utils_coverage/index.html
```

### Clean Coverage Data

```bash
rm -rf coverage/
```

### One-Liner Commands

#### Quick BaseView Coverage

```bash
flutter test --coverage test/core/base/view/base_view_test.dart && genhtml coverage/lcov.info -o coverage/baseview_coverage && open coverage/baseview_coverage/index.html
```

#### Quick Utils Coverage

```bash
flutter test --coverage test/utils/ && genhtml coverage/lcov.info -o coverage/utils_coverage && open coverage/utils_coverage/index.html
```

#### Quick Core Coverage

```bash
flutter test --coverage test/core/ && genhtml coverage/lcov.info -o coverage/core_coverage && open coverage/core_coverage/index.html
```

## Using the Script

You can also use the provided script:

```bash
# Show menu
./test_coverage_commands.sh

# Run specific commands
./test_coverage_commands.sh baseview
./test_coverage_commands.sh utils
./test_coverage_commands.sh core
./test_coverage_commands.sh all
./test_coverage_commands.sh clean
./test_coverage_commands.sh open
```

## Coverage Report Locations

All HTML reports will be generated in the `coverage/` directory with descriptive names:

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

## Notes

- Make sure you have `genhtml` installed (usually comes with lcov)
- The `open` command works on macOS. For other systems, use:
    - Linux: `xdg-open coverage/report_name/index.html`
    - Windows: `start coverage/report_name/index.html`
- Coverage data is cumulative, so running multiple test commands will combine coverage data
- Use `clean` command to reset coverage data between different test runs 