Tests written for:

- Dashboard component illustrating the use of a mock router in the
  context of navigation that occurs through the routerLink directive.
- Heroes component, illustrating the use of a mock router in the
  context of imperative navigation.
- Hero detail component, illustrating the use of a mock Location
  and mock RouterState, w/o any Router.

In this part of the tutorial, these components are navigated to.

Changed/new:

- Create mock service classes using `Mockito`.
- Test of components that are navigated to:
  - Imperative navigation
  - RouterLink navigation
- Modified version of the toh-3 hero detail PO and test. Test alternatives
  vary based on injected values of `RouterState`.
- Test using mock router.
- Test using mock Location w/o a router.

----

Note: `all_test.dart` used as a single entry point for tests.
Other test files named, e.g., `test/heroes.dart`.
