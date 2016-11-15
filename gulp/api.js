module.exports = function(gulp, plugins, config) {

  const ANGULAR_PROJECT_PATH = '../angular-dart'; // for now use same alias as is used for angular.io

  gulp.task('get-api-docs', () => copyApiDocs());

  function copyApiDocs() {
    try {
      // checkAngularProjectPath();
      const ngDartDocPath = plugins.path.resolve(ANGULAR_PROJECT_PATH, 'doc', 'api');
      let sourceDirs = plugins.fs.readdirSync(ngDartDocPath)
        .filter(name => !name.match(/^index|^(?!angular2)|testing|codegen/));
      console.log(`Getting Dart API pages for ${sourceDirs.length} libraries + static-assets folder`);
      sourceDirs.push('static-assets');
      sourceDirs = sourceDirs.map(name => plugins.path.join(ngDartDocPath, name));

      const destPath = 'publish/angular/api';
      // Make boilerplate files read-only to avoid that they be edited by mistake.
      const destFileMode = '444';
      return copyFiles(sourceDirs, [destPath]).then(() => {
        console.log('Finished copying', sourceDirs.length, 'directories from', ngDartDocPath, 'to', destPath);
      }).catch((err) => {
        console.error(err);
      });

    } catch(err) {
      console.error(err);
      console.error(err.stack);
      throw err;
    }
  }

  // Copies fileNames into destPaths, setting the mode of the
  // files at the destination as optional_destFileMode if given.
  // returns a promise
  function copyFiles(fileNames, destPaths, optional_destFileMode) {
    var copy = plugins.q.denodeify(plugins.fs.copy);
    var chmod = plugins.q.denodeify(plugins.fs.chmod);
    var copyPromises = [];
    destPaths.forEach(function(destPath) {
      fileNames.forEach(function(fileName) {
        var baseName = plugins.path.basename(fileName);
        var destName = plugins.path.join(destPath, baseName);
        var p = copy(fileName, destName, { clobber: true});
        if(optional_destFileMode !== undefined) {
          p = p.then(function () {
            return chmod(destName, optional_destFileMode);
          });
        }
        copyPromises.push(p);
      });
    });
    return plugins.q.all(copyPromises);
  }

  // function checkAngularProjectPath(_ngPath) {
  //   var ngPath = plugins.path.resolve(_ngPath || ANGULAR_PROJECT_PATH);
  //   if (plugins.fs.existsSync(ngPath)) return;
  //   throw new Error('API related tasks require the angular2 repo to be at ' + ngPath);
  // }

};