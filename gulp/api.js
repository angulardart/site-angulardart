// Gulp task to copy previously built API docs.
'use strict';

module.exports = function (gulp, plugins, config) {

  const _projs = plugins.genDartdocForProjs();
  const webdevDirName = {
    acx: 'components',
    ng: 'angular',
  }
  function destPath(p) { return `publish/${webdevDirName[p]}/api`; }
  function path2GeneratedAPI(p) {
    return plugins.path.resolve(config.repoPath[p], config.relDartDocApiDir);
  }
  const ngContentAstIndexRelPath = 'angular2.compiler/NgContentAst/index.html';

  // Copy (and patch) API docs to ${destPath(p)} for each project p specified via --dartdoc
  gulp.task('finalize-api-docs', _projs.map(p => `finalize-api-docs-${p}`));

  gulp.task('finalize-api-docs-acx', ['dartdoc-acx', '_api-copy-index+styles-acx', '_api-copy+patch-html-acx']);
  gulp.task('finalize-api-docs-ng', ['dartdoc-ng', '_api-copy-index+styles-ng', '_api-copy+patch-html-ng', '_api-patch-base-href-ng']);

  gulp.task('_api-copy-index+styles-acx', ['dartdoc-acx'], cb => apiCopyIndexAndStyles('acx'));
  gulp.task('_api-copy-index+styles-ng', ['dartdoc-ng'], cb => apiCopyIndexAndStyles('ng'));

  function apiCopyIndexAndStyles(p) {
    const baseDir = path2GeneratedAPI(p);
    const src = [
      `${baseDir}/index.json`,
      `${baseDir}/static-assets/**`,
    ];
    // ng uses the api-list directive to generate the index.html page, so don't copy it over.
    if (p == 'acx') src.push(`${baseDir}/index.html`);
    return gulp.src(src, { base: baseDir })
      // Patch the acx index.html so that assets can be found
      .pipe(plugins.replace(/<\/title>/, '$&\n  <base href="api/">', { skipBinary: true }))
      .pipe(gulp.dest(destPath(p)));
  }

  gulp.task('_api-copy+patch-html-acx', ['dartdoc-acx'], cb => apiCopyAndPatchHtml('acx'));
  gulp.task('_api-copy+patch-html-ng', ['dartdoc-ng'], cb => apiCopyAndPatchHtml('ng'));

  function apiCopyAndPatchHtml(p) {
    plugins.gutil.log(`Copy API docs to ${destPath(p)}`)
    const urlToExamples = 'http://angular-examples.github.io/';
    const baseDir = path2GeneratedAPI(p);
    return gulp.src([
      `${baseDir}/angular2*/**/*.html`,
      `!${baseDir}/${ngContentAstIndexRelPath}`,
    ], { base: baseDir })
      // Adjust hrefs to doc pages; https://github.com/dart-lang/site-webdev/issues/273
      // Because each API page has a <base href> which makes the href base equivalent to
      // /angular/api, we can either replace "docs/" in href="docs/..." with "../" or "/angular"
      // We could use something like cheerio but a simple in-place search/replace is good enough.

      // 2017-04-14: these transformations are temporary until all relative links
      // are eliminated from the angular2 and angular2_components API docs:
      .pipe(plugins.replace(/(href=")docs\//g, `$1/angular/`)) // ${webdevDirName[p]}
      .pipe(plugins.replace(/(href=")examples\//g, `$1${urlToExamples}`))
      .pipe(gulp.dest(destPath(p)));
  }

  gulp.task('_api-patch-base-href-ng', ['dartdoc-ng'], cb => {
    const p = 'ng';
    const baseDir = path2GeneratedAPI(p);
    return gulp.src([
      `${baseDir}/${ngContentAstIndexRelPath}`,
    ], { base: baseDir })
      // Patch file; see https://github.com/dart-lang/site-webdev/issues/271
      .pipe(plugins.replace(/(<base href="..)\/..(">)/, '$1$2'))
      .pipe(gulp.dest(destPath(p)));
  });

};