# Test Coverage for SonarQube LCOV Reports

This document explains how to run comprehensive test coverage for the companion registration feature
and generate LCOV reports for SonarQube analysis.

## Overview

The test suite includes comprehensive coverage tests designed to achieve high LCOV coverage for
SonarQube analysis:

- **Model Coverage Tests**: Tests all code paths in `CompanionRegistrationModel`
- **View Coverage Tests**: Tests all UI interactions and components
- **Integration Tests**: Tests complete workflows and edge cases
- **Edge Case Tests**: Tests boundary conditions and error scenarios

## Test Files

### 1. Model Coverage Tests

- `test/features/companion_registration/companion_registration_model_coverage_test.dart`
- Tests all methods and properties of the model
- Covers initialization, text operations, checkbox toggling, validation, and state management

### 2. View Coverage Tests

- `test/features/companion_registration/companion_registration_view_coverage_test.dart`
- Tests all UI components and user interactions
- Covers text input, checkbox toggling, button interactions, and form validation

### 3. Comprehensive Coverage Tests

- `test/features/companion_registration/companion_registration_coverage_test.dart`
- Combined model and view tests for maximum coverage
- Tests integration scenarios and edge cases

### 4. Integration Tests

- `test/features/companion_registration/companion_registration_integration_test.dart`
- Tests complete form workflows and user interaction scenarios
- Includes fixed checkbox toggling tests

## Running Coverage Tests

### Option 1: Using the Coverage Script (Recommended)

```bash
# Make script executable (if not already done)
chmod +x test_coverage.sh

# Run coverage tests
./test_coverage.sh
```

This script will:

1. Clean previous coverage data
2. Run all tests with coverage
3. Generate LCOV report
4. Display coverage summary
5. Show companion registration specific coverage

### Option 2: Manual Commands

```bash
# Clean and run tests with coverage
flutter clean
flutter test --coverage

# Generate HTML report (optional)
genhtml coverage/lcov.info -o coverage/html

# View coverage summary
lcov --summary coverage/lcov.info
```

### Option 3: Run Specific Test Files

```bash
# Run only companion registration coverage tests
flutter test test/features/companion_registration/companion_registration_coverage_test.dart --coverage

# Run model coverage tests
flutter test test/features/companion_registration/companion_registration_model_coverage_test.dart --coverage

# Run view coverage tests
flutter test test/features/companion_registration/companion_registration_view_coverage_test.dart --coverage
```

## Coverage Reports

### LCOV Report

- **Location**: `coverage/lcov.info`
- **Format**: LCOV format for SonarQube
- **Content**: Line-by-line coverage data

### HTML Report

- **Location**: `coverage/html/index.html`
- **Format**: Human-readable HTML report
- **Content**: Detailed coverage with highlighted lines

## SonarQube Integration

### Configuration

The project includes `sonar-project.properties` configured for:

- Flutter/Dart analysis
- LCOV coverage reports
- Proper exclusions and inclusions
- Quality gate thresholds

### Uploading to SonarQube

1. **Generate Coverage Report**:
   ```bash
   ./test_coverage.sh
   ```

2. **Run SonarQube Analysis**:
   ```bash
   sonar-scanner
   ```

3. **Verify Coverage in SonarQube Dashboard**:
    - Check coverage metrics
    - Review uncovered lines
    - Analyze quality gate results

## Coverage Targets

### Current Coverage Goals

- **Model Coverage**: 100% (all methods and properties)
- **View Coverage**: 95%+ (all UI interactions)
- **Integration Coverage**: 90%+ (complete workflows)
- **Overall Coverage**: 85%+

### Coverage Areas

#### Model Coverage

- ✅ Initialization and setup
- ✅ Text controller operations
- ✅ Checkbox state management
- ✅ Form validation
- ✅ State change methods
- ✅ Submit button functionality

#### View Coverage

- ✅ Widget building and rendering
- ✅ Text field interactions
- ✅ Checkbox toggling
- ✅ Button interactions
- ✅ Form validation
- ✅ Focus management
- ✅ Edge cases and error handling

#### Integration Coverage

- ✅ Complete form workflows
- ✅ User interaction scenarios
- ✅ State persistence
- ✅ Validation integration
- ✅ Rapid interaction handling

## Test Categories

### 1. Unit Tests

- Individual method testing
- Property validation
- State management
- Error handling

### 2. Widget Tests

- UI component rendering
- User interaction simulation
- Form validation
- State updates

### 3. Integration Tests

- Complete workflows
- Cross-component interactions
- Real-world scenarios
- Edge cases

### 4. Coverage Tests

- Code path coverage
- Branch coverage
- Line coverage
- Condition coverage

## Troubleshooting

### Common Issues

1. **Tests Getting Stuck**:
    - Use `pumpAndSettle()` instead of `pump()`
    - Add delays between rapid interactions
    - Reduce iteration counts in loops

2. **Coverage Not Generated**:
    - Ensure `--coverage` flag is used
    - Check for test failures
    - Verify `lcov` is installed

3. **SonarQube Not Reading Coverage**:
    - Verify `sonar-project.properties` configuration
    - Check LCOV file path
    - Ensure proper file permissions

### Debugging Commands

```bash
# Check if lcov is installed
which lcov

# Verify LCOV file format
head -20 coverage/lcov.info

# Check test execution
flutter test --verbose

# Run specific failing test
flutter test test/features/companion_registration/companion_registration_coverage_test.dart --verbose
```

## Best Practices

1. **Test Organization**:
    - Group related tests logically
    - Use descriptive test names
    - Include setup and teardown

2. **Coverage Optimization**:
    - Test all code paths
    - Include edge cases
    - Test error conditions

3. **Maintenance**:
    - Update tests when code changes
    - Monitor coverage trends
    - Address coverage gaps

## Next Steps

1. **Run Coverage Tests**: Execute `./test_coverage.sh`
2. **Review Results**: Check coverage summary and HTML report
3. **Upload to SonarQube**: Run `sonar-scanner`
4. **Analyze Dashboard**: Review coverage metrics and quality gate
5. **Improve Coverage**: Add tests for uncovered areas if needed

## Support

For issues with coverage tests or SonarQube integration:

1. Check the troubleshooting section
2. Review test logs and error messages
3. Verify configuration files
4. Consult Flutter testing documentation 