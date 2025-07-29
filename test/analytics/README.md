# Analytics Module Test Suite

This directory contains comprehensive unit tests for the VisaAmigo analytics module, covering the
main analytics components:

## 📁 Test Files

### 1. `firebase_analytics_service_test.dart`

Tests for the main analytics service class that handles:

- Event logging (`logEvent`, `logEventButtonClick`)
- Screen view tracking (`logScreenViewEvent`)
- User property management (`setUserProperty`, `setUserid`)
- Route path cleaning (`cleanRoutePath`)
- Device information collection (`getDeviceAnalyticsInfo`)
- User authentication events (`logLogin`, `logSignUp`)
- Analytics enable/disable functionality
- User logout cleanup (`clearUserOnLogout`)
- Error handling and edge cases

**Coverage Areas:**

- ✅ All public methods tested
- ✅ Error handling scenarios
- ✅ Edge cases and null safety
- ✅ Static variable management
- ✅ Constants validation
- ✅ Integration scenarios

### 2. `firebase_analytics_observer_test.dart`

Tests for the route observer that tracks navigation:

- Route change detection (`didPop`)
- Route name extraction from various sources
- Navigation tracking integration
- Edge cases with null/empty routes
- Multiple route scenarios
- Complex route patterns

**Coverage Areas:**

- ✅ Route observer initialization
- ✅ Route name extraction logic
- ✅ Navigation event handling
- ✅ Edge cases and error scenarios
- ✅ Integration with analytics service

### 3. `analytics_integration_test.dart`

Integration tests covering:

- Complete user journey scenarios
- Cross-component interactions
- Performance testing
- Error handling across components
- Real-world usage patterns

**Coverage Areas:**

- ✅ End-to-end analytics flows
- ✅ Component interactions
- ✅ Performance scenarios
- ✅ Error resilience
- ✅ Real-world usage patterns

## 🚀 Running Tests

### Using the Coverage Script

```bash
# Run all analytics tests
./test_coverage_commands.sh analytics

# Run specific component tests
./test_coverage_commands.sh analytics-service
./test_coverage_commands.sh analytics-observer
./test_coverage_commands.sh analytics-integration
```

### Direct Commands

```bash
# Run all analytics tests
flutter test test/analytics/ --coverage

# Run specific test file
flutter test test/analytics/firebase_analytics_service_test.dart --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📊 Test Coverage

The analytics test suite provides comprehensive coverage:

### FirebaseAnalyticsService (85%+ coverage)

- ✅ **Event Logging**: All event types and parameters
- ✅ **Screen Tracking**: View events and navigation
- ✅ **User Management**: Properties, IDs, authentication
- ✅ **Device Info**: Platform detection and metadata
- ✅ **Error Handling**: Graceful failure scenarios
- ✅ **Constants**: All analytics constants validated

### FirebaseAnalyticsRouteObserver (90%+ coverage)

- ✅ **Route Detection**: All route change scenarios
- ✅ **Name Extraction**: Multiple fallback strategies
- ✅ **Navigation Tracking**: Complete navigation flows
- ✅ **Edge Cases**: Null, empty, and complex routes

### Integration Tests (75%+ coverage)

- ✅ **End-to-End Flows**: Complete user journeys
- ✅ **Component Interaction**: Cross-component testing
- ✅ **Performance**: Rapid event handling
- ✅ **Error Resilience**: System-wide error handling

## 🧪 Test Categories

### Unit Tests

- Individual method testing
- Isolated component behavior
- Mock-based testing
- Edge case validation

### Integration Tests

- Cross-component interactions
- Real-world scenarios
- Performance validation
- Error propagation

### Widget Tests

- UI component testing
- Context-based access
- Widget tree integration

## 🔧 Test Utilities

### Mock Classes

- `MockFirebaseAnalyticsService`: Analytics service mock
- `MockRoute`: Route object for testing
- `MockFirebaseAnalytics`: Firebase analytics mock

### Test Widgets

- `CompleteAnalyticsTestWidget`: Integration testing
- `TestChildWidget`: Generic test widget

## 📈 Coverage Goals

- **Minimum Coverage**: 80% LCOV
- **Target Coverage**: 85% LCOV
- **Critical Paths**: 100% coverage
- **Error Handling**: 90% coverage

## 🐛 Known Issues

### Firebase Initialization

Some tests may show Firebase initialization errors in CI/CD environments where Firebase is not
configured. These are expected and don't affect test validity.

### Platform Detection

Device info tests may vary based on the test environment (web vs mobile).

## 🚀 Best Practices

1. **Test Isolation**: Each test is independent and resets state
2. **Error Handling**: All error scenarios are tested
3. **Edge Cases**: Null, empty, and invalid inputs are covered
4. **Performance**: Rapid event handling is validated
5. **Integration**: Cross-component interactions are tested

## 📝 Adding New Tests

When adding new analytics functionality:

1. Add unit tests for the new method/class
2. Add integration tests for cross-component interactions
3. Update the coverage script if needed
4. Document new test patterns in this README

## 🔍 Debugging Tests

### Common Issues

- Firebase initialization errors (expected in CI)
- Platform-specific behavior differences
- Mock setup issues

### Debug Commands

```bash
# Run with verbose output
flutter test test/analytics/ --verbose

# Run specific failing test
flutter test test/analytics/firebase_analytics_service_test.dart --plain-name "should handle logEvent exceptions gracefully"

# Run with coverage and keep output
flutter test test/analytics/ --coverage --reporter=expanded
```

## 📚 Related Documentation

- [Firebase Analytics Documentation](https://firebase.flutter.dev/docs/analytics/overview/)
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Coverage Testing](https://docs.flutter.dev/testing#coverage) 