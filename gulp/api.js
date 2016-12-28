// Gulp task to copy previously built angular2 API docs.
'use strict';

module.exports = function (gulp, plugins, config) {

  const destPath = 'publish/angular/api';
  const ngDartDocPath = plugins.path.resolve(config.angularRepo, config.relDartDocApiDir);
  const ngContentAstIndexRelPath = 'angular2.compiler/NgContentAst/index.html';

  // Copy (and path) API docs to ${destPath}
  gulp.task('finalize-api-docs', ['dartdoc', '_api-copy-index+styles', '_api-patch-html', '_api-patch-base-href']);

  gulp.task('_api-copy-index+styles', ['dartdoc'], cb => {
    const baseDir = ngDartDocPath;
    return gulp.src([
      `${baseDir}/index.json`,
      `${baseDir}/static-assets/**`,
    ], { base: baseDir })
      .pipe(gulp.dest(destPath));
  });

  gulp.task('_api-patch-html', ['dartdoc'], cb => {
    const urlToExamples = 'http://angular-examples.github.io/';
    const baseDir = ngDartDocPath;
    return gulp.src([
      `${baseDir}/angular2.*/**/*.html`,
      `!${baseDir}/${ngContentAstIndexRelPath}`,
    ], { base: baseDir })
      // Adjust hrefs to doc pages; https://github.com/dart-lang/site-webdev/issues/273
      // Because each API page has a <base href> which makes the href base equivalent to
      // /angular/api, we can either replace "docs/" in href="docs/..." with "../" or "/angular"
      // We could use something like cheerio but a simple in-place search/replace is good enough.
      .pipe(plugins.replace(/(href=")docs\//g, '$1/angular/'))
      .pipe(plugins.replace(/(href=")examples\//g, `$1${urlToExamples}`))
      .pipe(gulp.dest(destPath));
  });

  gulp.task('_api-patch-base-href', ['dartdoc'], cb => {
    const baseDir = ngDartDocPath;
    return gulp.src([
      `${baseDir}/${ngContentAstIndexRelPath}`,
    ], { base: baseDir })
      // Patch file; see https://github.com/dart-lang/site-webdev/issues/271
      .pipe(plugins.replace(/(<base href="..)\/..(">)/, '$1$2'))
      .pipe(gulp.dest(destPath));
  });

};