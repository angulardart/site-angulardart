// TODO: consider merging gulp/api.js and this gulp/api-list.js.

// Gulp tasks to create api-list.json.
'use strict';

module.exports = function (gulp, plugins, config) {

  const fs = plugins.fs;
  const path = plugins.path;
  const log = require('./_log-factory')();
  log.level = 'info'; // config._logLevel;
  // Converts a dartdoc index.json file into an api-list.json file suitable for processing by the api directive:
  const preprocessor = require('./_preprocessDartDocData')(log);
  const apiListService = require('./_apiListService')(log);

  const TOOLS_PATH = config.TOOLS_PATH;

  gulp.task('build-api-list-json', ['dartdoc', '_get-sdk-doc-index-json'], () => buildApiListJson());

  const localDartApiIndexJson = path.resolve(config.LOCAL_TMP, 'index.json');
  const sdk = config.ngPkgVers.SDK;
  const url = `https://api.dartlang.org/${sdk.channel}/${sdk.vers}/index.json`;
  const curlCmd = `curl ${url} -o ${localDartApiIndexJson}`;

  gulp.task('_get-sdk-doc-index-json', ['_clean'], () => {
    if (!fs.existsSync(localDartApiIndexJson)) plugins.execSyncAndLog(curlCmd);
    if (fs.existsSync(localDartApiIndexJson) && fs.statSync(localDartApiIndexJson).size > 0) return;
    const msg = `ERROR: unexpected empty file: ${localDartApiIndexJson}
       because the fetched ${url} is empty.
       If this isn't a server error, then there is probably no SDK for the given channel and version.`;
    plugins.logAndExit1(msg);
  });

  function buildApiListJson() {
    _buildApiListJson();
  }

  function _buildApiListJson() {
    const destFolder = path.join(config.THIS_PROJECT_PATH, 'src', 'api');

    log.info(`Creating combined api-list.json:`);

    const apiListMap = Object.create(null);
    const pkgsWithApiDocs = fs.readdirSync(config.tmpPubPkgsPath);
    config._dartdocProj.forEach(pkgNameAlias => {
      const pkgName = plugins.pkgAliasToPkgName(pkgNameAlias);
      const dirName = pkgsWithApiDocs.find(d => d.match(new RegExp(`^${pkgName}($|-)`)));
      if (!dirName) {
        const msg = `WARNING: buildApiListJson found no folder for ${pkgNameAlias} under ${config.tmpPubPkgsPath}.`;
        if (plugins.argv.dartdoc) plugins.logAndExit1(msg);
        plugins.gutil.log(msg);
        return true;
      }
      const srcPath = path.join(config.tmpPubPkgsPath, dirName, config.relDartDocApiDir);
      const srcData = path.resolve(srcPath, 'index.json');
      if (fs.existsSync(srcData)) {
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
    _addToApiListMap(dartDocData, apiListMap);

    log.info('Total number of libraries across packages:', apiListMap.size);
    writeApiList(apiListMap, destFolder);
  }

  function _addToApiListMap(dartDocData, apiListMap, _pkgName, optAlias) {
    preprocessor.preprocess(dartDocData);
    const _apiListMap = apiListService.createApiListMap(dartDocData);
    const pkgName = _pkgName || 'SDK';
    const pkgAndAlias = pkgName + (optAlias ? ` (${optAlias})` : '');
    log.info(`  ${pkgAndAlias} has ${dartDocData.length} entries in ${Object.keys(_apiListMap).length} libraries`);
    for (let libName in _apiListMap) {
      const fullLibName = _pkgName ? `${pkgName}/${libName}` : libName;
      log.info(`    ${fullLibName}:`, libName, 'has', _apiListMap[libName].length, 'top-level entries');
      apiListMap[fullLibName] = _apiListMap[libName];
    }
  }

  function writeApiList(apiListMap, destFolder) {
    const apiListFilePath = path.join(destFolder, 'api-list.json');
    fs.writeFileSync(apiListFilePath, plugins.stringify(apiListMap));
    log.info('Wrote', Object.keys(apiListMap).length, 'library entries to', apiListFilePath);
  }
};
