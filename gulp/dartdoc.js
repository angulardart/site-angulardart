'use strict';

module.exports = function (gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const fs = plugins.fs;
  const path = plugins.path;

  const dartdocCmd = 'pub global run dartdoc'
  const libsToDoc = {
    acx: '',
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

  const frags = config.frags;
  const repoPath = config.repoPath;
  function path2ApiDocFor(r) {
    return path.resolve(repoPath[r], config.relDartDocApiDir);
  }
  const ngFragsPath = path.join(path2ApiDocFor('ng'), frags.dirName);

  const _projs = plugins.genDartdocForProjs();
  plugins.gutil.log(`Generating dartdocs for ${_projs.length ? _projs : 'no projects (all exist or are being skipped)'}.`);

  // Task: dartdoc
  // --dartdoc='all|acx|ng', default is just 'ng'.
  // --fast   skip prep and API doc generation if API docs already exist.
  // --clean  removes angular2 doc/api (and so forces regeneration of docs; i.e. --fast is ignored)
  gulp.task('dartdoc', _projs.map(p => `_dartdoc-${p}`));

  _projs.forEach(p => {
    gulp.task(`dartdoc-${p}`, [`_dartdoc-${p}`]);

    // Task: _dartdoc-* is like the 'dartdoc' task but builds the docs even if --fast is used
    // (but --fast will still skip copying boilerplate files)
    gulp.task(`_dartdoc-${p}`, [`_dartdoc-prep-${p}`], cb => _dartdoc(p));

    gulp.task(`_dartdoc-clean-${p}`, () => _cleanIfArgSet(p));
  });

  gulp.task('_dartdoc-prep-acx', ['_dartdoc-clean-acx']);
  gulp.task('_dartdoc-prep-ng', ['_dartdoc-clean-ng', '_setup-fragments-for-dartdoc-ng']);

  function _cleanThenDartdoc(proj) {
    _cleanIfArgSet(proj);
    return _dartdoc(proj);
  }

  function _cleanIfArgSet(proj) {
    if (!argv.clean) return;
    const cmd = `rm -Rf ${path2ApiDocFor(proj)}`;
    plugins.gutil.log(cmd);
    cp.execSync(cmd);
  }

  function _dartdoc(proj) {
    if (!proj) throw `_dartdoc(): no project specified`;
    if (proj == 'ng' && !fs.existsSync(ngFragsPath)) throw `_dartdoc(${proj}): fragments dir missing, ${ngFragsPath}`;
    return _dartdoc1(proj, libsToDoc[proj]);
  }

  function _dartdoc1(proj, libs) {
    const args = [];
    if (libs) args.push(`--include=${libs}`);
    args.push(`--output ${config.relDartDocApiDir}`);
    // `--example-path-prefix ${ngFragsPath}`, // We don't use @example anymore
    return plugins.q.all(
      plugins.execp(`${dartdocCmd} ${args.join(' ')}`, { cwd: repoPath[proj] }),
      plugins.execp(`${dartdocCmd} --version`)
    );
  }

  gulp.task('_clean-ng-frag', () => cp.execSync(`rm -Rf ${ngFragsPath}`));

  gulp.task('_setup-fragments-for-dartdoc-ng',
    ['_dartdoc-clean-ng', '_clean-ng-frag', 'create-example-fragments'],
    () => _ngLinkFrags()
  );

  gulp.task('_ng-link-frags', () => _ngLinkFrags());

  function _ngLinkFrags() {
    // Fragments have been created via `create-example-fragments`.
    // Now copy/link the local fragments to the angular2 repo so that
    // dartdoc, when run over the angular2 repo, can find them.

    // Handle doc sample frags
    plugins.gutil.log(`Linking to fragment folders ${ngFragsPath}`);
    cp.execSync(`mkdir -p ${ngFragsPath}`);
    const webdevFragPath = path.resolve(frags.path);
    cp.execSync(`ln -s ${webdevFragPath} doc`, { cwd: ngFragsPath });
    cp.execSync(`ln -s doc docs`, { cwd: ngFragsPath });

    // Handle API samples
    // plugins.gutil.log(`  cd ${ngFragsPath}`);
    const apiFragsPath = path.join(frags.path, frags.apiDirName);
    plugins.fs.readdirSync(apiFragsPath).forEach(subdir => {
      const srcFragsPath = path.resolve(apiFragsPath, subdir); // Note: no dart subfolder needed here
      const cmd = `ln -s ${srcFragsPath} ${subdir}`;
      // plugins.gutil.log(`    ${cmd}`);
      cp.execSync(cmd, { cwd: ngFragsPath });
    });
    return true;
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
