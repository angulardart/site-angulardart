// TODO: consider merging gulp/api.js and this gulp/api-list.js.

// Gulp tasks to create api-list.json.
'use strict';

module.exports = function (gulp, plugins, config) {

  const path = plugins.path;
  const log = require('./_log-factory')();
  log.level = 'info'; // config._logLevel;
  // Converts a dartdoc index.json file into an api-list.json file suitable for processing by the api directive:
  const preprocessor = require('./_preprocessDartDocData')(log);
  const apiListService = require('./_apiListService')(log);

  const TOOLS_PATH = config.TOOLS_PATH;

  gulp.task('build-api-list-json', ['dartdoc', '_get-sdk-doc-index-json'], () => buildApiListJson());

  const localDartApiIndexJson = path.resolve(config.LOCAL_TMP, 'index.json');
  const curlCmd = `curl https://api.dartlang.org/stable/1.24.2/index.json -o ${localDartApiIndexJson}`;

  gulp.task('_get-sdk-doc-index-json', ['_clean'], () => {
    if (!plugins.fs.existsSync(localDartApiIndexJson)) plugins.child_process.execSync(curlCmd);
  });

  function buildApiListJson() {
    _buildApiListJson();
  }

  function _buildApiListJson() {
    const destFolder = path.join(config.THIS_PROJECT_PATH, 'src', 'api');

    log.info(`Creating combined api-list.json:`);

    const apiListMap = Object.create(null);
    config._dartdocProj.forEach(pkgNameAlias => {
      const pkgName = path.basename(config.repoPath[pkgNameAlias]);
      const srcPath = path.join(config.repoPath[pkgNameAlias], config.relDartDocApiDir);
      const srcData = path.resolve(srcPath, 'index.json');
      if (plugins.fs.existsSync(srcData)) {
        const dartDocData = require(srcData);
        _addToApiListMap(dartDocData, apiListMap, pkgName, pkgNameAlias);
      } else if (config.dartdocProj.indexOf(pkgNameAlias) > -1) {
        throw `ERROR: can't build API index for ${pkgNameAlias}. File not found: ${srcData}`;
      } else {
        // Only warn if this isn't a pkg that the user asked dartdocs for.
        plugins.gutil.log(`Warning: file not found: ${srcData}`);
      }
    });

    // Add selected SDK libraries
    const srcData = localDartApiIndexJson;
    const dartDocData = require(srcData).filter(e => e.href.match(/^dart-(async|core|convert|html)/));
    // Don't add SDK libraries yet:
    // _addToApiListMap(dartDocData, apiListMap);

    log.info('Total number of libraries across packages:', apiListMap.size);
    writeApiList(apiListMap, destFolder);
  }

  function _addToApiListMap(dartDocData, apiListMap, _pkgName, optAlias) {
    preprocessor.preprocess(dartDocData);
    const _apiListMap = apiListService.createApiListMap(dartDocData);
    const pkgName = _pkgName || 'SDK';
    const pkgAndAlias = pkgName + optAlias ? ` (${optAlias})` : '';
    log.info(`  ${pkgAndAlias} has ${dartDocData.length} entries in ${Object.keys(_apiListMap).length} libraries`);
    for (let libName in _apiListMap) {
      const fullLibName = _pkgName ? `${pkgName}/${libName}` : libName;
      log.info(`    ${fullLibName}:`, libName, 'has', _apiListMap[libName].length, 'top-level entries');
      apiListMap[fullLibName] = _apiListMap[libName];
    }
  }

  function _buildNgApiListJson() {
    const destFolder = path.join(config.THIS_PROJECT_PATH, 'src', 'angular', 'api');
    const srcPath = path.join(config.repoPath['ng'], config.relDartDocApiDir);
    const srcData = path.resolve(srcPath, 'index.json');
    const dartDocData = require(srcData);
    log.info('Number of Dart API entries loaded:', dartDocData.length);

    plugins.fs.writeFileSync(path.join(destFolder, 'index.json'), stringify(dartDocData));
    preprocessor.preprocess(dartDocData);
    const apiListMap = apiListService.createApiListMap(dartDocData);
    for (let libName in apiListMap) {
      log.info('  ', libName, 'has', apiListMap[libName].length, 'top-level entries');
    }
    writeApiList(apiListMap, destFolder);
  }

  function writeApiList(apiListMap, destFolder) {
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
