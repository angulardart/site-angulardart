'use strict';

module.exports = function(gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const fs = plugins.fs;
  const path = plugins.path;

  const dartdocCmd = 'pub global run dartdoc'
  const libsToDoc =
     `angular2.common
      angular2.compiler
      angular2.core
      angular2.instrumentation
      angular2.platform.browser
      angular2.platform.browser_static
      angular2.platform.common
      angular2.platform.common_dom
      angular2.router
      angular2.security
      angular2.transform.deferred_rewriter.dart
      angular2.transform.reflection_remover.dart
      angular2.transformer_dart`.replace(/\s+/g, ',');

  const frags = config.frags;
  const ngApiDocPath = path.resolve(config.angularRepo, config.relDartDocApiDir);
  const ngFragsPath = path.join(ngApiDocPath, frags.dirName);
  const ngDocExFragDir = path.join(ngFragsPath, 'docs');

  // Task: dartdoc
  // --fast   skip prep and API doc generation if API docs already exist.
  // --clean  removes angular2 doc/api (and so forces regeneration of docs; i.e. --fast is ignored)
  gulp.task('dartdoc', skipDocGen() ? [] : ['_dartdoc-prep'], cb => {
    if (skipDocGen()) {
      plugins.gutil.log(`Skipping dartdoc: --fast flag enabled and API docs exists ${ngApiDocPath}`);
      return true;
    }
    return _dartdoc();
    // // checkAngularProjectPath(ngRepoPath);
    // const topLevelLibFilePath = path.resolve(ngRepoPath, 'lib', 'angular2.dart');
    // const tmpPath = topLevelLibFilePath + '.disabled';
    // renameIfExistsSync(topLevelLibFilePath, tmpPath);
    // gutil.log(`Hiding top-level angular2 library: ${topLevelLibFilePath}`);
    // // Remove dartdoc '--add-crossdart' flag while we are fixing links to API pages.
    // const dartdoc = spawnExt('dartdoc', ['--output', config.relDartDocApiDir], { cwd: ngRepoPath});
    // return dartdoc.promise.finally(() => {
    //     gutil.log(`Restoring top-level angular2 library: ${topLevelLibFilePath}`);
    //     renameIfExistsSync(tmpPath, topLevelLibFilePath);
    // })
  });

  // Task: _dartdoc is like the 'dartdoc' task but builds the docs even if --fast is used
  // (but --fast will still skip copying boilerplate files)
  gulp.task('_dartdoc', ['_dartdoc-prep'], cb => { _cleanIfArgSet(); _dartdoc(); });
  gulp.task('_dartdoc-prep', ['_dartdoc-clean', '_setup-fragments-for-dartdoc']);

  gulp.task('_dartdoc-clean', () => _cleanIfArgSet());

  function _cleanIfArgSet() {
    if (!argv.clean) return;
    const cmd = `rm -Rf ${ngApiDocPath}`;
    plugins.gutil.log(cmd);
    cp.execSync(cmd);
  }

  function skipDocGen() {
    return !argv.clean && argv.fast && fs.existsSync(ngApiDocPath);
  }

  function _dartdoc() {
    if (!fs.existsSync(ngFragsPath)) throw `_dartdoc(): fragments dir missing, ${ngFragsPath}`;
    const args = [
      `--include=${libsToDoc}`,
      `--example-path-prefix ${ngFragsPath}`,
      `--output ${config.relDartDocApiDir}`,
    ];
    return plugins.q.all(
      plugins.execp(`${dartdocCmd} ${args.join(' ')}`, { cwd: config.angularRepo }),
      plugins.execp(`${dartdocCmd} --version`)
    );
  }

  gulp.task('_clean-ng-frag', () => cp.execSync(`rm -Rf ${ngFragsPath}`));

  gulp.task('_setup-fragments-for-dartdoc', ['_dartdoc-clean', '_clean-ng-frag', 'create-example-fragments'], () => {
    // Fragments have been created via `create-example-fragments`.
    // Now copy/link the local fragments to the angular2 repo so that
    // dartdoc, when run over the angular2 repo, can find them.

    plugins.gutil.log(`Linking to fragment folders ${ngFragsPath}`);
    cp.execSync(`mkdir -p ${ngDocExFragDir}`);

    // Handle doc sample frags
    // plugins.gutil.log(`  cd ${ngDocExFragDir}`);
    plugins.fs.readdirSync(frags.path).forEach(subdir => {
      if (subdir.startsWith('_')) return true;
      const srcFragsPath = path.resolve(frags.path, subdir, 'dart');
      const cmd = `ln -s ${srcFragsPath} ${subdir}`;
      // plugins.gutil.log(`    ${cmd}`);
      cp.execSync(cmd, {cwd:ngDocExFragDir});
    });

    // Handle API samples
    // plugins.gutil.log(`  cd ${ngFragsPath}`);
    const apiFragsPath = path.join(frags.path, frags.apiDirName);
    plugins.fs.readdirSync(apiFragsPath).forEach(subdir => {
      const srcFragsPath = path.resolve(apiFragsPath, subdir); // Note: no dart subfolder needed here
      const cmd = `ln -s ${srcFragsPath} ${subdir}`;
      // plugins.gutil.log(`    ${cmd}`);
      cp.execSync(cmd, {cwd:ngFragsPath});
    });
    return true;
  });

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
