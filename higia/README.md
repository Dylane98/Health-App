# higia

A new Flutter project.

---

## Refactor notes
- Dependency injection: `lib/services/service_locator.dart` (uses `get_it`). Call `await initServiceLocator()` in `main()` before `runApp()`.
- Services: see `lib/services/` (user, auth, pedometer, steps repository, lookup).

## Tests
- Unit tests are under `test/`. Example: `test/registration_data_test.dart` covers `RegistrationData` helpers.
- Run tests: `flutter test`
