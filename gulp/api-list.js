// TODO: consider merging gulp/api.js and this gulp/api-list.js.

// Gulp tasks to create api-list.json.
'use strict';

module.exports = function (gulp, plugins, config) {

  const path = plugins.path;

  const DOCS_PATH = config.DOCS_PATH;
  const TOOLS_PATH = config.TOOLS_PATH;

  gulp.task('build-api-list-json', ['dartdoc'], () => buildApiListJson());

  function buildApiListJson() {
    const dab = require(path.resolve(TOOLS_PATH, 'dart-api-builder', 'dab'))(config.THIS_PROJECT_PATH);
    const log = dab.log;

    log.level = config._dgeniLogLevel;
    const dabInfo = dab.dartPkgConfigInfo;
    dabInfo.ngIoDartApiDocPath = path.join(config.THIS_PROJECT_PATH, 'src', 'angular', 'api'); // was: path.join(DOCS_PATH, 'dart', vers, 'api');
    dabInfo.ngDartDocPath = path.join(config.repoPath.ng, config.relDartDocApiDir);
    // Exclude API entries for developer/internal libraries. Also exclude entries for
    // the top-level catch all "angular2" library (otherwise every entry appears twice).
    dabInfo.excludeLibRegExp = new RegExp(/^(?!angular2)|testing|_|codegen|^angular2$/);

    try {
      // checkAngularProjectPath(ngPathFor('dart'));
      var destPath = dabInfo.ngIoDartApiDocPath;
      let filesAndFolders = plugins.fs.readdirSync(dabInfo.ngDartDocPath)
        .filter(name => !name.match(/^(?!angular2)|testing|codegen/))
        .map(name => path.join(dabInfo.ngDartDocPath, name));
      log.info(`Building Dart API list data for ${filesAndFolders.length} libraries`);

      const apiEntries = dab.loadApiDataAndSaveToApiListFile();
      const tmpDocsPath = path.resolve(path.join(process.env.HOME, 'tmp/docs.json'));
      if (plugins.argv.dumpDocsJson) plugins.fs.writeFileSync(tmpDocsPath, JSON.stringify(apiEntries, null, 2));
      // We don't actually need to create the page entries anymore.
      // dab.createApiDataAndJadeFiles(apiEntries);
    } catch(err) {
      console.error(err);
      console.error(err.stack);
      throw err;
    }
  }

};
