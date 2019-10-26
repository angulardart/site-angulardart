// Gulp tasks related to updating, and checking for freshness, pubspec.yaml files
'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const gulp_task = plugins.gulp_task;
  const ngPkgVers = config.ngPkgVers;
  const path = plugins.path;
  const srcData = config.srcData;

  const chooseRegEx = argv.filter || '.';
  const skipRegEx = argv.skip || null;

  ['get', 'upgrade'].forEach(cmd => {
    gulp_task(`root-pub-${cmd}`, () => plugins.execSyncAndLog(`pub ${cmd}`));

    gulp_task(`ng-pkg-pub-${cmd}`, () => {
      if (srcData.match(skipRegEx) || !srcData.match(chooseRegEx)) return;
      _runPubAndCheckForNewerNgPkgs(cmd);
      _updateNgPkgVers();
    });

    gulp_task(`pub-${cmd}`, [`root-pub-${cmd}`, `examples-pub-${cmd}`, `ng-pkg-pub-${cmd}`]);
    gulp_task(`pub-${cmd}-and-check`, [`pub-${cmd}`, () => plugins.gitCheckDiff()]);
  });

  gulp_task('_ng-pkg-vers-update', _updateNgPkgVers);

  // Update the config.ngPkgVersPath file based on the config.srcData pubspec.lock values
  function _updateNgPkgVers() {
    const pubspecLock = plugins.yamljs.load(path.join(config.srcData, 'pubspec.lock'));
    for (var pkg in ngPkgVers) {
      if (pkg === 'SDK') continue;
      const newPkgInfo = pubspecLock.packages[pkg];
      if (newPkgInfo) ngPkgVers[pkg].vers = newPkgInfo.version;
    }
    plugins.fs.writeFileSync(config.ngPkgVersPath, plugins.stringify(ngPkgVers) + '\n');
  }

  function _runPubAndCheckForNewerNgPkgs(cmd) {
    const output = plugins.execSyncAndLog(`pub ${cmd}`, { cwd: srcData });
    if (cmd !== 'upgrade') return;
    const updatesAvailable = output.match(/^..(angular\w*|build_\w+) (\S+)( \(was (\S+)\))?( \((\S+) available\))?$/gm);
    if (!updatesAvailable) {
      plugins.myLog(`All Angular packages are up-to-date.`);
      return;
    }
    // Check for updates, but don't report when an alpha/beta version is available relative to a stable version.
    const updatesAvailableToReport = [];
    updatesAvailable.forEach(u => {
      if (u.match(skipRegEx)) return true;
      const m = u.match(/^..(angular\w*|build_\w+) (\S+)( \(was (\S+)\))?( \((\S+) available\))?$/);
      const pkg = m[1], vers = m[2], was = m[3], wasVers = m[4], avail = m[5], availVers = m[6];
      // plugins.myLog(`>> pkg:${pkg}, vers:${vers}, wasVers:${wasVers || ''}, availVers:${availVers}`);
      if (wasVers || availVers && (vers.match(/alpha|beta/) || !availVers.match(/alpha|beta/))) {
        updatesAvailableToReport.push(u);
      }
    })
    if (updatesAvailableToReport.length) {
      const msg = `Angular package updates available:\n${updatesAvailableToReport.join('\n')}.\n`
        + 'Aborting. Update pubspec(s) before proceeding.\n';
      plugins.logAndExit1(msg);
    } else {
      plugins.myLog(`All angular and builder package verions in example pubspecs are up-to-date.`);
    }
  }
};
