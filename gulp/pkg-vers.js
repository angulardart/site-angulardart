// Gulp tasks related to updating, and checking for freshness, pubspec.yaml files
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const _exec = plugins.execSyncAndLog;
  const gutil = plugins.gutil;
  const path = plugins.path;
  const srcData = config.srcData;

  const chooseRegEx = argv.filter || '.';
  const skipRegEx = argv.skip || null;

  ['get', 'upgrade'].forEach(cmd => {
    gulp.task(`pub-${cmd}-and-check`, [`pub-${cmd}`], () => plugins.gitCheckDiff());
    gulp.task(`pub-${cmd}`, [`examples-pub-${cmd}`, `ng-pkg-pub-${cmd}`]);

    gulp.task(`ng-pkg-pub-${cmd}`, () => {
      if (srcData.match(skipRegEx) || !srcData.match(chooseRegEx)) return;
      _pub(cmd);
    });
  });

  function _pub(cmd) {
    const output = _exec(`pub ${cmd}`, { cwd: srcData });
    if (cmd !== 'upgrade') return;
    const updatesAvailable = output.match(/^. angular\w* .*available\)$/gm);
    if (updatesAvailable) {
      const msg = `Angular package updates available:\n${updatesAvailable.join('\n')}.\n`
      + 'Aborting. Update pubspec(s) before proceeding.\n';
      plugins.logAndExit1(msg);
    }
  }
};
