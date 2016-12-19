'use strict';

module.exports = function(gulp, plugins, config) {

  const argv = plugins.argv;
  const cp = plugins.child_process;
  const fs = plugins.fs;
  const path = plugins.path;

  const dartdocCmd = 'pub global run dartdoc'

  gulp.task('dartdoc', ['_setup-fragments-for-dartdoc'], () => {
    const ngRepoPath = config.angularRepo;
    if (argv.fast && fs.existsSync(path.resolve(ngRepoPath, config.relDartDocApiDir))) {
      plugins.gutil.log(`Skipping dartdoc: --fast flag enabled and api dir exists (${config.relDartDocApiDir})`);
      return true;
    }
    return plugins.q.all(
      plugins.execp(`${dartdocCmd} --version`),
      plugins.execp(`${dartdocCmd} --output ${config.relDartDocApiDir}`, { cwd: config.angularRepo })
    );
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

  gulp.task('_setup-fragments-for-dartdoc', ['create-example-fragments'], () => {
    const fragmentsDir = 'src/angular/_fragments';
    const ngRepoPath = config.angularRepo;
    const docsDir = path.resolve(ngRepoPath, 'docs');

    cp.execSync(`rm -Rf ${docsDir}`);
    cp.execSync(`mkdir ${docsDir}`);

    plugins.gutil.log(`Linking to fragment folders; cd ${docsDir}`);
    const fragFolders = plugins.fs.readdirSync(fragmentsDir);
    fragFolders.forEach(subdir => {
      const fragSubdir = path.resolve(fragmentsDir, subdir, 'dart');
      const cmd = `ln -s ${fragSubdir} ${subdir}`;
      plugins.gutil.log(cmd);
      cp.execSync(cmd, {cwd:docsDir});
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
