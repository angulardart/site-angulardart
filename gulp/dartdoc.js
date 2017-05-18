'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const fs = plugins.fs;
  const path = plugins.path;

  const dartdocCmd = 'pub global run dartdoc'
  const libsToDoc = {
    acx: `angular_components`,
    ng: `angular2.common
      angular2.compiler
      angular2.core
      angular2.platform.browser
      angular2.platform.browser_static
      angular2.platform.common
      angular2.platform.common_dom
      angular2.router
      angular2.security
      angular2.transform.deferred_rewriter.dart
      angular2.transform.reflection_remover.dart
      angular2.transformer_dart`.replace(/\s+/g, ','),
  };

  const repoPath = config.repoPath;
  function path2ApiDocFor(r) {
    return path.resolve(repoPath[r], config.relDartDocApiDir);
  }

  const _projs = plugins.genDartdocForProjs();
  plugins.gutil.log(`Dartdocs targets: ${_projs.length ? _projs : 'no projects (all exist or are being skipped)'}.`);

  // Task: dartdoc
  // --dartdoc='all|none|acx|ng', default is 'all'.
  // --fast   skip prep and API doc generation if API docs already exist.
  // --clean  removes angular2 doc/api (and so forces regeneration of docs; i.e. --fast is ignored)
  gulp.task('dartdoc', _projs.map(p => `dartdoc-${p}`));

  _projs.forEach(p => {
    gulp.task(`dartdoc-${p}`, [`_dartdoc-${p}`]);

    // Task: _dartdoc-* is like the 'dartdoc' task but builds the docs even if --fast is used
    // (but --fast will still skip copying boilerplate files)
    gulp.task(`_dartdoc-${p}`, [`_dartdoc-clean-${p}`], cb => _dartdoc(p));

    gulp.task(`_dartdoc-clean-${p}`, () => _cleanIfArgSet(p));
  });

  function _cleanIfArgSet(proj) {
    if (!argv.clean) return;
    const cmd = `rm -Rf ${path2ApiDocFor(proj)}`;
    plugins.gutil.log(cmd);
    cp.execSync(cmd);
  }

  function _dartdoc(proj) {
    if (!proj) throw `_dartdoc(): no project specified`;
    return _dartdoc1(proj, libsToDoc[proj]);
  }

  function _dartdoc1(proj, libs) {
    const args = [];
    if (libs) args.push(`--include=${libs}`);
    args.push(`--output ${config.relDartDocApiDir}`);
    return plugins.q.all(
      plugins.execp(`${dartdocCmd} ${args.join(' ')}`, { cwd: repoPath[proj] }),
      plugins.execp(`${dartdocCmd} --version`)
    );
  }

};

// Extra from ng.io gulpfile that might prove useful soon:
//

// gulp.task('pub upgrade', [], function() {
//   const ngRepoPath = ngPathFor('dart');
//   if (argv.fast && fs.existsSync(path.resolve(ngRepoPath, 'packages'))) {
//     gutil.log('Skipping pub upgrade: --fast flag enabled and "packages" dir exists');
//     return true;
//   }
//   checkAngularProjectPath(ngRepoPath);
//   const pubUpgrade = spawnExt('pub', ['upgrade'], { cwd: ngRepoPath});
//   return pubUpgrade.promise;
// });

// gulp.task('dartdoc', ['pub upgrade'], function() {
//   const ngRepoPath = ngPathFor('dart');
//   if (argv.fast && fs.existsSync(path.resolve(ngRepoPath, relDartDocApiDir))) {
//     gutil.log(`Skipping dartdoc: --fast flag enabled and api dir exists (${relDartDocApiDir})`);
//     return true;
//   }
//   checkAngularProjectPath(ngRepoPath);
//   const topLevelLibFilePath = path.resolve(ngRepoPath, 'lib', 'angular2.dart');
//   const tmpPath = topLevelLibFilePath + '.disabled';
//   renameIfExistsSync(topLevelLibFilePath, tmpPath);
//   gutil.log(`Hiding top-level angular2 library: ${topLevelLibFilePath}`);
//   // Remove dartdoc '--add-crossdart' flag while we are fixing links to API pages.
//   const dartdoc = spawnExt('dartdoc', ['--output', relDartDocApiDir], { cwd: ngRepoPath});
//   return dartdoc.promise.finally(() => {
//       gutil.log(`Restoring top-level angular2 library: ${topLevelLibFilePath}`);
//       renameIfExistsSync(tmpPath, topLevelLibFilePath);
//   })
// });

// return dartdoc.promise.finally(() => {
//     gutil.log(`Restoring top-level angular2 library: ${topLevelLibFilePath}`);
//     renameIfExistsSync(tmpPath, topLevelLibFilePath);
