// Gulp tasks related to updating, and checking for freshness, pubspec.yaml files
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const _exec = plugins.execSyncAndLog;
  const gutil = plugins.gutil;
  const path = plugins.path;

  const chooseRegEx = argv.filter || '.';
  const skipRegEx = argv.skip || null;

  gulp.task('pub-upgrade', ['examples-pub-upgrade', 'ng-pkg-pub-upgrade']);

  gulp.task('pub-upgrade-and-check', ['pub-upgrade'],
    () => plugins.gitCheckDiff());

  gulp.task('ng-pkg-pub-upgrade-and-check', (doneCb) =>
    plugins.runSequence('ng-pkg-pub-upgrade', 'git-check-diff', doneCb));

  gulp.task('ng-pkg-pub-upgrade', () => {
    const pubspecPath = path.join(config.source, '_data');
    if (pubspecPath.match(skipRegEx) || !pubspecPath.match(chooseRegEx)) return;

    const output = _exec('pub upgrade', { cwd: pubspecPath });
    const updatesAvailable = output.match(/^[\-\+ ]+angular\w* .*available\)$/gm);
    if (updatesAvailable) {
      gutil.log(`Updates available:\n${updatesAvailable.join('\n')}`);
      process.exit(1);
    }
  });

};
