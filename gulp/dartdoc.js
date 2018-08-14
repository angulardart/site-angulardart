'use strict';

module.exports = function (gulp, plugins, config) {

  const fs = plugins.fs;
  const gulp_task = plugins.gulp_task;
  const _projs = config.dartdocProj;
  const path = plugins.path;

  const tmpPubPkgsPath = config.tmpPubPkgsPath;
  function mkPubPkgs() {
    if (!fs.existsSync(tmpPubPkgsPath)) plugins.execSyncAndLog(`mkdir -p ${tmpPubPkgsPath}`);
  }

  const libsToDoc = {
    acx: 'angular_components',
    forms: 'angular_forms',
    ng: 'angular,angular.security',
    router: 'angular_router',
    test: 'angular_test',
  };
  const pkgsFilePath = path.join(config.srcData, '.packages');

  gulp_task('dartdoc-info', () => {
    const msg = 'Dartdoc for packages:';
    if (_projs.length) {
      plugins.myLog(`${msg} ${_projs}.`);
      if (_projs.length) plugins.execSyncAndLog(`${config.dartdoc} --version`);
    } else {
      plugins.myLog(`${msg} no projects (all exist or are being skipped).`);
    }
  });

  config._dartdocProj.forEach(p => {
    if (_projs.includes(p)) {
      gulp.task(`dartdoc-${p}`, () => _dartdoc(p));
    } else {
      gulp_task(`dartdoc-${p}`, (done) => done());
    }
  });

  // Task: dartdoc
  // --[no-]dartdoc='all|none|acx|ng|...', default is 'all'.

  const dartdocTargets = _projs.map(p => `dartdoc-${p}`);
  if (dartdocTargets.length === 0) {
    gulp.task('dartdoc', (done) => done());
  } else {
    gulp.task('dartdoc',
      gulp.series('dartdoc-info', 'ng-pkg-pub-get',
        gulp.parallel(...dartdocTargets)));
  }

  function _dartdoc(proj) {
    if (!proj) throw `_dartdoc(): no project specified`;
    const projPath = _prep(proj);
    return _dartdoc1(proj, libsToDoc[proj], projPath);
  }

  let packages; // initialized lazily in _prep.
  function _prep(proj) {
    if (!packages) packages = fs.readFileSync(pkgsFilePath, { encoding: 'utf-8' });
    const pubPkgName = plugins.pkgAliasToPkgName(proj);
    const re = new RegExp(`^${pubPkgName}:(.*)$`, 'm');
    let match = packages.match(re);
    if (!match) _throw(proj, `can't find ${pubPkgName} in ${pkgsFilePath}`);
    // Sample entries:
    //   angular:../angular/lib/
    //   foo:file:///Users/chalin/.pub-cache/hosted/pub.dartlang.org/foo-1.0.0/lib/
    const pathToPkgSrcPath = match[1]
      .replace(/^\w+:\/\//, '') // Drop leading protocol, if any. E.g. 'file://'
      .replace(/^\.\.\/\.\.\//, '')   // Drop leading '../../' for relative paths
      .replace(/\/lib\/$/, ''); // Drop trailing '/lib'
    if (!fs.existsSync(pathToPkgSrcPath))
      _throw(proj, `package source directory not found: ${pathToPkgSrcPath} (${path.resolve(pathToPkgSrcPath)})`);
    plugins.myLog(`${pubPkgName} found at ${path.resolve(pathToPkgSrcPath)}.`);
    const pubPkgAndVersName = path.basename(pathToPkgSrcPath);
    if (!pubPkgAndVersName.match(new RegExp(`${pubPkgName}(\\b|-)`)))
      _throw(proj, `package source directory name should match /${pubPkgName}(\b|-*)/, but is ${pubPkgAndVersName}`);

    mkPubPkgs();
    const tmpPubPkgPath = path.join(tmpPubPkgsPath, pubPkgAndVersName);
    const apiDir = path.resolve(tmpPubPkgPath, config.relDartDocApiDir);
    const index_json = path.resolve(apiDir, 'index.json');

    if (!fs.existsSync(tmpPubPkgPath)) {
      plugins.execSyncAndLog(`cp -R ${pathToPkgSrcPath} ${tmpPubPkgPath}`);
      // const pubspecFile = `${tmpPubPkgPath}/pubspec.yaml`;
      // plugins.execSyncAndLog(`perl -i -pe "s/angular_test: ^2.0.0-alpha+8/angular_test: ^2.0.0-alpha+6/gm" ${pubspecFile}`);
      // const dep_ovr = '\ndependency_overrides:\n  angular_test: ^2.0.0-alpha+6\n';
      // plugins.myLog(`\nWARNING: appending to ${pubspecFile}: ${dep_ovr}\n`);
      // fs.appendFileSync(pubspecFile, dep_ovr);
    } else if (fs.existsSync(index_json)) {
      if (plugins.argv.useCachedApiDoc) {
        plugins.myLog(`Keeping previously generated API docs for ${pubPkgName} found at ${apiDir}:`);
        plugins.execSyncAndLog(`ls -l ${apiDir}`);
      } else {
        plugins.execSyncAndLog(`rm -Rf ${apiDir}`);
      }
    }
    // https://github.com/dart-lang/angular/issues/1097
    if (pubPkgAndVersName === 'angular_forms-2.0.0-alpha') {
      const pubspecFile = `${tmpPubPkgPath}/pubspec.yaml`;
      plugins.execSyncAndLog(`perl -i -pe "s/(angular_test: \\^2\\.0\\.0-alpha)\\+8/\\1+6/gm" ${pubspecFile}`);
    }
    return tmpPubPkgPath;
  }

  async function _dartdoc1(proj, libs, projPath) {
    const args = [];
    if (libs || libs === '') args.push(`--include=${libs}`);
    if (config.relDartDocApiDir !== 'doc/api') args.push(`--output ${config.relDartDocApiDir}`);

    const apiDir = path.resolve(projPath, config.relDartDocApiDir);
    const index_json = path.resolve(apiDir, 'index.json');
    if (plugins.argv.useCachedApiDoc && fs.existsSync(index_json)) {
      plugins.myLog(`Using previously generated API docs for ${proj} found at ${apiDir}.`);
      return;
    }

    try {
      await plugins.execp(`${config.dartdoc} ${args.join(' ')}`, { cwd: projPath });
    } catch (e) {
      if (plugins.argv.useCachedApiDoc && fs.existsSync(apiDir)) {
        plugins.myLog(`Dartdoc failed for ${proj}; deleting ${apiDir}.\nCaught error: ${e}`);
        plugins.execSyncAndLog(`rm -Rf ${apiDir}`);
      }
      throw e;
    }
    return;
  }

  function _throw(proj, msg) {
    throw `Dartdoc prep for ${proj}: ${msg}`;
  }
};
