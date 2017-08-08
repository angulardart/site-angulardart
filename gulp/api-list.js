// TODO: consider merging gulp/api.js and this gulp/api-list.js.

// Gulp tasks to create api-list.json.
'use strict';

module.exports = function (gulp, plugins, config) {

  const path = plugins.path;
  const log = require('./_log-factory')();
  log.level = config._logLevel;
  // Converts a dartdoc index.json file into an api-list.json file suitable for processing by the api directive:
  const preprocessor = require('./_preprocessDartDocData')(log);
  const apiListService = require('./_apiListService')(log);

  const DOCS_PATH = config.DOCS_PATH;
  const TOOLS_PATH = config.TOOLS_PATH;

  gulp.task('build-api-list-json', ['dartdoc'], () => buildApiListJson());

  function buildApiListJson() {
    const srcPath = path.join(config.repoPath.ng, config.relDartDocApiDir);
    const srcData = path.resolve(srcPath, 'index.json');
    const dartDocData = require(srcData);
    log.info('Number of Dart API entries loaded:', dartDocData.length);

    const destFolder = path.join(config.THIS_PROJECT_PATH, 'src', 'angular', 'api');
    plugins.fs.writeFileSync(path.join(destFolder, 'index.json'), stringify(dartDocData));
    preprocessor.preprocess(dartDocData);
    const apiListMap = apiListService.createApiListMap(dartDocData);
    for (let name in apiListMap) {
      log.info('  ', name, 'has', apiListMap[name].length, 'top-level entries');
    }
    const apiListFilePath = path.join(destFolder, 'api-list.json');
    plugins.fs.writeFileSync(apiListFilePath, stringify(apiListMap));
    log.info('Wrote', Object.keys(apiListMap).length, 'library entries to', apiListFilePath);
  }

  function stringify(o) {
    return process.env.JEKYLL_ENV === 'production'
      ? JSON.stringify(o)
      : JSON.stringify(o, null, 2);
  }
};
