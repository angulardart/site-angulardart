Tests written for:

- Dashboard component, illustrating the use of a real router, but
  a `MockPlatformLocation`.
- Heroes component, illustrating the use of a mock router.
- Hero detail component

In this part of the tutorial, these components are navigated to.

Changed/new:

- Create mock service classes using `Mockito`.
- Test of a components that are navigated to.
- Modified version of the toh-3 hero detail PO and test. Test alternatives
  vary based on injected values of `RouterParam`.
- Test using mock router.
- Test using real router but mock PlatformLocation.

----

Note: `all_test.dart` used as a single entry point for tests.
Other test files named, e.g., `test/heroes.dart`.
