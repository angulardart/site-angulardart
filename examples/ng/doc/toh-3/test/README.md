The toh-3 is a refactoring of toh-2. The app component is simplified, factoring out

 - `hero.dart`
 - `hero_component.dart`

Given that toh-3 is a refactoring, the toh-2 `app_test`s run, without change,
over toh-3.

Changes/new features:

- Test a component other than the app component.
- Set `@Input` field.