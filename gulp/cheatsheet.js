// Gulp tasks related to creating cheatsheet.json.
'use strict';

module.exports = function (gulp, plugins, config) {

  const Dgeni = require('dgeni');
  const path = plugins.path;

  const DOCS_PATH = config.DOCS_PATH;
  const TOOLS_PATH = config.TOOLS_PATH;

  const cheatsheetJsonPath = path.join(DOCS_PATH, 'dart', 'latest', 'guide', 'cheatsheet.json');

  gulp.task('build-cheatsheet', ['dartdoc'], function () {
    return buildDartCheatsheet();
  });

  function buildDartCheatsheet() {
    // FIXME: Dart API docs still have some 'js|ts' entries so we must keep 'js|ts' in the allowed languages for now.
    const ALLOWED_LANGUAGES = ['ts', 'js', 'dart'];
    const lang = 'dart';
    const vers = 'latest';
    // checkAngularProjectPath(ngPathFor(lang));
    try {
      const pkg = new Dgeni.Package('dartApiDocs', [require(path.resolve(TOOLS_PATH, 'dart-api-builder'))]);
      pkg.config(function (log, targetEnvironments, writeFilesProcessor) {
        log.level = config._dgeniLogLevel;
        ALLOWED_LANGUAGES.forEach(function (target) { targetEnvironments.addAllowed(target); });
        targetEnvironments.activate(lang);
        const outputPath = path.join(lang, vers, 'can-be-any-name-read-comment-below');
        // Note: cheatsheet data gets written to: outputPath + '/../guide';
        writeFilesProcessor.outputFolder = outputPath;
      });
      return new Dgeni([pkg]).generate().then(() =>
        plugins.fs.existsSync(cheatsheetJsonPath)
          ? plugins.execp(`mv ${cheatsheetJsonPath} src/angular/`) : true
      );
    } catch (err) {
      console.error(err);
      console.error(err.stack);
      throw err;
    }
  }

};
