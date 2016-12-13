// TODO: move ANGULAR_PROJECT_PATH and copyFiles to gulpfile.

module.exports = function(gulp, plugins, config) {

  const ANGULAR_PROJECT_PATH = '../angular-dart'; // for now use same alias as is used for angular.io
  const gutil = plugins.gutil;

  gulp.task('get-api-docs', () => copyApiDocs());

  function copyApiDocs() {
    try {
      // checkAngularProjectPath();
      const ngDartDocPath = plugins.path.resolve(ANGULAR_PROJECT_PATH, 'doc', 'api');
      let filesAndFolders = plugins.fs.readdirSync(ngDartDocPath)
        .filter(name => !name.match(/^(?!angular2)|testing|codegen/));
      gutil.log(`Getting Dart API pages for ${filesAndFolders.length} libraries + static-assets folder`);
      filesAndFolders.push('index.json', 'static-assets'); // JSON file used by API search
      filesAndFolders = filesAndFolders.map(name => plugins.path.join(ngDartDocPath, name));

      const destPath = 'publish/angular/api';
      // Make files read-only to avoid that they be edited by mistake.
      const destFileMode = '444';
      return copyFiles(filesAndFolders, [destPath]).then(() => {
        gutil.log('Finished copying', filesAndFolders.length, 'directories from', ngDartDocPath, 'to', destPath);
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