The toh-4 is a refactoring of toh-3. The app component is simplified, factoring out
the `HeroService`.

Given that toh-4 is a refactoring, the toh-2 `app_test`s run, without change.

Changes/new features:

- Test a component requiring a service, that is _not_ replaced by a mock service.

In this particular case, we don't need to create a mock `HeroService`
since it is already a mock service. No extra steps are needed; DI injects an
instance of `HeroService` as specified by the app component `providers` list.
