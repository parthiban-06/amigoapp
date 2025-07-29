# Core Module Unit Tests

This directory contains comprehensive unit tests for the core module of the Visa Amigo application.

## Test Structure

```
test/core/
├── theme/
│   └── theme_test.dart                    # Tests for VisaColors and VisaTheme
├── config/
│   ├── env_config_test.dart              # Tests for EnvConfig class
│   └── app_config_test.dart              # Tests for AppConfig class
├── base/
│   ├── view/
│   │   └── base_view_test.dart           # Tests for BaseView widget
│   └── viewmodel/
│       └── base_view_model_test.dart     # Tests for BaseViewModel class
├── core_module_integration_test.dart     # Comprehensive integration tests
└── README.md                             # This documentation file
```

## Test Coverage

### Theme Tests (`theme_test.dart`)

- **VisaColors**: Tests for all color constants and their relationships
- **VisaTheme**: Tests for light and dark theme configurations
- **Color Validation**: Tests for color validity and consistency
- **Theme Properties**: Tests for theme data structure and properties

### Configuration Tests (`env_config_test.dart`)

- **Environment Variables**: Tests for environment variable handling
- **Default Values**: Tests for fallback values when env vars are missing
- **API Configuration**: Tests for API URL and base URL validation
- **Firebase Configuration**: Tests for Firebase key properties
- **Environment Detection**: Tests for development/production environment detection

### App Configuration Tests (`app_config_test.dart`)

- **Singleton Pattern**: Tests for singleton implementation
- **Configuration Properties**: Tests for all configuration properties
- **Environment Integration**: Tests for integration with EnvConfig
- **URL Validation**: Tests for URL format and security
- **Performance**: Tests for efficient singleton behavior

### Base View Tests (`base_view_test.dart`)

- **Widget Structure**: Tests for widget architecture and parameters
- **State Management**: Tests for state management and lifecycle
- **Responsive Design**: Tests for mobile/desktop view handling
- **UI Configuration**: Tests for custom UI configuration options
- **Connectivity**: Tests for connectivity handling and internet dialogs

### Base ViewModel Tests (`base_view_model_test.dart`)

- **Class Structure**: Tests for class structure and imports
- **Future Implementation**: Tests for readiness for future implementation
- **Documentation**: Tests for proper documentation structure
- **Integration Readiness**: Tests for integration with BaseProvider

### Integration Tests (`core_module_integration_test.dart`)

- **Cross-Module Integration**: Tests for integration between core components
- **Configuration Consistency**: Tests for consistent configuration across modules
- **Theme Integration**: Tests for theme and configuration integration
- **Performance Integration**: Tests for performance and memory management
- **Error Handling**: Tests for graceful error handling

## Running Tests

### Run All Core Tests

```bash
flutter test test/core/
```

### Run Specific Test Categories

```bash
# Theme tests only
flutter test test/core/theme/

# Configuration tests only
flutter test test/core/config/

# Base tests only
flutter test test/core/base/

# Integration tests only
flutter test test/core/core_module_integration_test.dart
```

### Run Individual Test Files

```bash
# Theme tests
flutter test test/core/theme/theme_test.dart

# Environment config tests
flutter test test/core/config/env_config_test.dart

# App config tests
flutter test test/core/config/app_config_test.dart

# Base view tests
flutter test test/core/base/view/base_view_test.dart

# Base viewmodel tests
flutter test test/core/base/viewmodel/base_view_model_test.dart
```

## Test Categories

### Unit Tests

- **Individual Component Testing**: Each class and widget is tested in isolation
- **Property Validation**: All properties and methods are validated
- **Edge Cases**: Boundary conditions and edge cases are covered
- **Error Handling**: Error scenarios and fallback behavior are tested

### Integration Tests

- **Cross-Component Integration**: Tests how components work together
- **Configuration Consistency**: Ensures consistent behavior across modules
- **Performance Validation**: Tests for efficient resource usage
- **Memory Management**: Tests for proper memory handling

### Validation Tests

- **Data Validation**: Ensures data integrity and format validation
- **URL Validation**: Tests for proper URL formats and security
- **Color Validation**: Tests for valid color values and relationships
- **Configuration Validation**: Tests for valid configuration values

## Test Best Practices

### Naming Conventions

- Test files follow the pattern: `{class_name}_test.dart`
- Test groups use descriptive names that match the functionality
- Individual tests use clear, descriptive names

### Test Organization

- Tests are organized by functionality and component
- Related tests are grouped together
- Integration tests are separate from unit tests

### Assertion Patterns

- Use specific assertions for better error messages
- Test both positive and negative cases
- Validate edge cases and boundary conditions

### Documentation

- Each test group has clear documentation
- Complex tests include explanatory comments
- Test purpose and expected behavior are clearly stated

## Coverage Goals

### Target Coverage

- **Unit Tests**: 90%+ coverage for all core components
- **Integration Tests**: 100% coverage for cross-component interactions
- **Edge Cases**: 100% coverage for error scenarios and boundary conditions

### Quality Metrics

- **Test Reliability**: All tests should pass consistently
- **Test Performance**: Tests should run quickly and efficiently
- **Test Maintainability**: Tests should be easy to understand and maintain

## Dependencies

### Required Dependencies

- `flutter_test`: Core testing framework
- `flutter/material.dart`: For theme and widget testing
- `flutter_dotenv`: For environment configuration testing

### Optional Dependencies

- `mockito`: For mocking dependencies (if needed)
- `provider`: For provider testing (if needed)

## Maintenance

### Regular Maintenance

- Update tests when core components change
- Add new tests for new functionality
- Refactor tests for better maintainability
- Review and update test documentation

### Test Review Process

- Review test coverage regularly
- Ensure tests reflect current functionality
- Update tests for deprecated features
- Maintain test performance and reliability

## Troubleshooting

### Common Issues

1. **Import Errors**: Ensure all imports are correct and dependencies are available
2. **Test Failures**: Check if core components have changed and update tests accordingly
3. **Performance Issues**: Optimize tests for better performance
4. **Coverage Issues**: Add missing test cases for uncovered functionality

### Debugging Tips

- Use `flutter test --verbose` for detailed test output
- Run individual tests to isolate issues
- Check test dependencies and imports
- Review test logic and assertions

## Contributing

### Adding New Tests

1. Follow the existing test structure and naming conventions
2. Add comprehensive test coverage for new functionality
3. Include both positive and negative test cases
4. Document new tests clearly

### Updating Existing Tests

1. Ensure tests remain relevant to current functionality
2. Update tests when core components change
3. Maintain test performance and reliability
4. Update documentation as needed

### Test Review Checklist

- [ ] Tests cover all functionality
- [ ] Tests include edge cases
- [ ] Tests are well-documented
- [ ] Tests follow naming conventions
- [ ] Tests are efficient and reliable
- [ ] Tests integrate properly with existing test suite 