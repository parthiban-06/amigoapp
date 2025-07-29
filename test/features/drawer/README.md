# Drawer Feature Unit Tests

This directory contains comprehensive unit tests for the drawer feature to achieve high LCOV
coverage.

## Test Structure

```
test/features/drawer/
├── provider/
│   └── drawer_provider_test.dart          # Tests for DrawerProvider
├── screen/
│   └── drawer_screen_test.dart            # Tests for DrawerScreen
├── widgets/
│   └── drawer_widget_test.dart            # Tests for DrawerItemWidget
├── drawer_comprehensive_test.dart         # Combined comprehensive tests
├── run_drawer_tests.sh                    # Test runner script
└── README.md                              # This file
```

## Test Coverage

### DrawerProvider Tests

- ✅ Initialization with context and notification count
- ✅ Navigation methods (loadProfile, loadEvaChatHistory, loadExtra, loadfaq)
- ✅ Clipboard operations (copyToken)
- ✅ Error handling for null/empty values
- ✅ State management and notifications

### DrawerItemWidget Tests

- ✅ Widget rendering with various title formats
- ✅ Notification badge display (0, normal, 99+)
- ✅ Tap interactions and callbacks
- ✅ Edge cases (empty titles, special characters, long text)
- ✅ Layout structure validation

### Integration Tests

- ✅ Provider navigation flow
- ✅ Clipboard operations with different token states
- ✅ Widget notification count scenarios

## Running Tests

### Quick Start

```bash
# Run all drawer tests with coverage
./test/features/drawer/run_drawer_tests.sh
```

### Individual Test Files

```bash
# Run provider tests only
flutter test test/features/drawer/provider/drawer_provider_test.dart --coverage

# Run widget tests only
flutter test test/features/drawer/widgets/drawer_widget_test.dart --coverage

# Run comprehensive tests
flutter test test/features/drawer/drawer_comprehensive_test.dart --coverage
```

### Manual Coverage Generation

```bash
# Generate coverage info file
flutter test test/features/drawer/drawer_comprehensive_test.dart --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html --title="Drawer Coverage Report"

# View coverage summary
lcov --summary coverage/lcov.info
```

## Coverage Targets

The tests are designed to achieve high coverage across:

- **Line Coverage**: >95%
- **Branch Coverage**: >90%
- **Function Coverage**: 100%

## Test Patterns Used

1. **Mocking**: Using Mockito for external dependencies
2. **Testable Classes**: Creating testable versions of providers
3. **Widget Testing**: Using Flutter's widget testing framework
4. **Integration Testing**: Testing component interactions
5. **Edge Case Testing**: Handling null, empty, and boundary values

## Key Features Tested

### DrawerProvider

- Navigation routing
- Clipboard operations
- State initialization
- Error handling

### DrawerItemWidget

- Text rendering and splitting
- Notification badge logic
- Touch interactions
- Responsive layout

### DrawerScreen

- Menu item rendering
- Provider integration
- Responsive behavior
- Navigation callbacks

## Dependencies

The tests use the following testing dependencies:

- `flutter_test`
- `mockito`
- `provider` (for testing)

## Troubleshooting

### Common Issues

1. **Import Errors**: Ensure all required dependencies are in `pubspec.yaml`
2. **Mock Setup**: Verify mock objects are properly configured
3. **Widget Rendering**: Check theme and localization setup

### Debug Mode

```bash
# Run tests with verbose output
flutter test test/features/drawer/drawer_comprehensive_test.dart --verbose
```

## Contributing

When adding new features to the drawer:

1. Add corresponding tests to the appropriate test file
2. Update the comprehensive test file
3. Ensure coverage remains high
4. Run the test runner script to verify

## Coverage Reports

After running tests, coverage reports are available at:

- HTML Report: `test_coverage/drawer/html_report/index.html`
- LCOV File: `test_coverage/drawer/comprehensive_coverage.info` 