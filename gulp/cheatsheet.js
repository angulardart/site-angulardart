// Gulp tasks related to creating cheatsheet.json.
'use strict';

module.exports = function (gulp, plugins, config) {

  const Dgeni = require('dgeni');
  const path = plugins.path;
  const replace = plugins.replace;

  const DOCS_PATH = config.DOCS_PATH;
  const TOOLS_PATH = config.TOOLS_PATH;

  gulp.task('build-cheatsheet', ['dartdoc', '_build-cheatsheet', '_fix-cheatsheet-in-place']);

  gulp.task('_build-cheatsheet', buildDartCheatsheet);

  gulp.task('_fix-cheatsheet-in-place', ['_build-cheatsheet'], cb => {
    const baseDir = config.ngDocSrc;
    return gulp.src([
      `${baseDir}/cheatsheet.json`,
    ], { base: baseDir })
      // Cheatsheet syntax examples cannot have lines that start with @ since lines
      // starting with @ mark the start of an dgeni annotation/directive. To get around this
      // we encode such lines as `!@`. This task rewrites that to just `@`.
      .pipe(replace('!@', '@'))
      .pipe(gulp.dest(config.ngDocSrc));
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
      return new Dgeni([pkg]).generate();
    } catch (err) {
      console.error(err);
      console.error(err.stack);
      throw err;
    }
  }

};
