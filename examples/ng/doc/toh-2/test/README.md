Changes/new features relative to toh-1 tests:

- Factored `app_po.dart` out of `app_test.dart`.
- PO annotations applied to `List` fields.
- Illustrate use of multiple PO annotations per field, including `@optional`.
- Group tests using `group()`.
- Along with groups, use `setUpAll()` and `tearDownAll()`.
- Make fixture and PO variables global to share across group test functions.
