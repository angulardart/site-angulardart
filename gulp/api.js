// Gulp task to copy previously built angular2 API docs.
'use strict';

module.exports = function(gulp, plugins, config) {

  const ANGULAR_PROJECT_PATH = '../angular-dart'; // for now use same alias as is used for angular.io
  const gutil = plugins.gutil;

  gulp.task('get-api-docs', () => copyApiDocs());

  function copyApiDocs() {
    try {
      // checkAngularProjectPath();
      const ngDartDocPath = plugins.path.resolve(config.ANGULAR_PROJECT_PATH, 'doc', 'api');
      let filesAndFolders = plugins.fs.readdirSync(ngDartDocPath)
        .filter(name => !name.match(/^(?!angular2)|testing|codegen/));
      gutil.log(`Getting Dart API pages for ${filesAndFolders.length} libraries + static-assets folder`);
      filesAndFolders.push('index.json', 'static-assets'); // JSON file used by API search
      filesAndFolders = filesAndFolders.map(name => plugins.path.join(ngDartDocPath, name));

      const destPath = 'publish/angular/api';
      // Make files read-only to avoid that they be edited by mistake.
      const destFileMode = '444';
      return plugins.copyFiles(filesAndFolders, [destPath]).then(() => {
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

  // function checkAngularProjectPath(_ngPath) {
  //   var ngPath = plugins.path.resolve(_ngPath || config.ANGULAR_PROJECT_PATH);
  //   if (plugins.fs.existsSync(ngPath)) return;
  //   throw new Error('API related tasks require the angular2 repo to be at ' + ngPath);
  // }

};