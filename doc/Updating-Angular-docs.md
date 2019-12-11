# Updating Angular docs

This page describes how to update the Angular docs ([angulardart.dev](https://angulardart.dev)).

## New release of the Dart SDK

1. Update the Dart SDK version in `src/_data/pkg-vers.json`.

## New release of AngularDart and Angular Components

**Note**: While it can _sometimes_ be possible to update the docs after a new version of Angular is released but before the corresponding version of Angular Components is available, it is generally advised to await for both.

Perform the following steps:

 1. [Re-run installation scripts](https://github.com/dart-lang/site-angulardart#3-run-installation-scripts).

    It isn't always necessary, but now and again, it picks up the most recent version of Node and/or other packages.

 2. Review and update [src/_data/pubspec.yaml](https://github.com/dart-lang/site-angulardart/blob/master/src/_data/pubspec.yaml).

    The `pubspec.lock` generated from this pubspec is used to determine the versions of packages to use for generating API docs. Generally `pubspec.yaml` doesn't require updates for patch releases.

 3. Run `npx gulp ng-pkg-pub-upgrade`

    This task updates [src/_data/pkg-vers.json](https://github.com/dart-lang/site-angulardart/blob/master/src/_data/pkg-vers.json) and warns if anything changed, and/or more recent versions of packages are available (which is usually an indication that `_data/pubspec.yaml` requires further updates).

 4. Run `npx gulp pub-upgrade-and-check`

    This gulp task runs `pub upgrade` over all samples and (again over) `src/_data`.

    **Note:** If an example is failing to upgrade, you can skip it using `--skip=<string>`.
    For example, the following command upgrades every example except template-syntax: `npx gulp pub-upgrade-and-check --skip=template`. For an example of doing the same on Travis, see the [diff from #1835](https://github.com/dart-lang/site-webdev/pull/1835/commits/755f30f982e3679ba84ed575ace741f6b697f6a5).

 5. (Optional) [Pull submodule upstream changes](https://github.com/dart-lang/site-angulardart/wiki/Git-submodule-notes#pull-upstream-changes) if you'd like to have the latest.

 6. Edit the following files, as necessary:
    * Files under [examples](https://github.com/dart-lang/site-angulardart/blob/master/examples):
      * If the dev version has been updated, edit the dev branch.
      * If the stable version requires code updates, edit the master.
      * To refresh code excerpts in the Markdown files, run:
      `./tool/refresh-code-excerpts.sh`
    * Content files.
      Note that these reflect the stable version, not the dev version.

 7. ASAP after the new Angular site has been pushed, update other repos that have Angular examples:
    * Use [dart-doc-syncer](https://github.com/dart-lang/dart-doc-syncer) to update the github.com/angular-examples repos.
      1. Clone https://github.com/dart-lang/dart-doc-syncer.
      1. `cd dart-doc-syncer; pub global activate --source path .`
      1. See what the sync would do: `dart_doc_syncer -k -m . -g 5 --no-push` OR (to limit to a single repo such as [angular-examples/structural-directives](https://github.com/angular-examples/structural-directives)) `dart_doc_syncer -k -m structural-directives -g 5 --no-push` (either one takes many minutes).
      1. Run the update by executing the same command, minus the `--no-push`.
         * This can take a very long time, during which you should **periodically check** whether it's still working or has paused to collect username and passwords.
         * Use `--skip template` to skip updating the template-syntax example.
         * If an update failed, fix the cause and update that repo. E.g. `dart_doc_syncer -k -m attribute-directives -g 5`
    * Update stagehand (see https://github.com/google/stagehand/wiki).

Tips:

* If the build fails on Travis but not locally:
  * Clear the Travis caches: Go to https://travis-ci.org/dart-lang/site-angulardart/caches and click **Delete all repository caches**.
  * Rebuild. Go to the **Pull Requests** tab (or whatever), click into the build that failed, and restart the build.
  * If the build still fails, you might have found a difference between the Mac & Linux builds. For example, the Linux file system is case sensitive, while macOS doesn't care about case.

See also:

* [Checklist: Update Samples w/ Latest A2 Version](https://docs.google.com/document/d/1IfLG2tCCk97M6eHjxLRqCpgvOwy0ls0pfM_Z9-QEfLQ/edit?usp=sharing)
