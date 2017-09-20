// Gulp tasks related to updating, and checking for freshness, pubspec.yaml files
'use strict';

module.exports = function (gulp, plugins, config) {

  const _exec = plugins.execSyncAndLog;
  const gutil = plugins.gutil;
  const path = plugins.path;

  gulp.task('pub-upgrade-and-check', ['examples-pub-upgrade', 'ng-pkg-pub-upgrade'],
    () => plugins.gitCheckDiff());

  gulp.task('ng-pkg-pub-upgrade-and-check', (doneCb) =>
    plugins.runSequence('ng-pkg-pub-upgrade', 'git-check-diff', doneCb));

  gulp.task('ng-pkg-pub-upgrade', () => {
    const output = _exec('pub upgrade', { cwd: path.join(config.source, '_data') });
    const updatesAvailable = output.match(/^[\-\+ ]+angular\w* .*available\)$/gm);
    if(updatesAvailable) {
      gutil.log(`Updates available:\n${updatesAvailable.join('\n')}`);
      process.exit(1);
    }
  });

};
