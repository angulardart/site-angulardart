// Gulp task to copy previously built API docs.
'use strict';

module.exports = function (gulp, plugins, config) {

  const path = plugins.path;
  const filter = require('gulp-filter');
  const rename = plugins.rename;

  const _projs = plugins.genDartdocForProjs();
  const webdevDirName = {
    acx: 'components',
    ng: 'angular',
  }
  function destPath(p) {
    const dir = webdevDirName[p];
    if (!dir) throw `webdevDirName mpa is missing a case for ${p}`;
    return `publish/${dir}/api`;
  }
  function path2GeneratedAPI(p) {
    return plugins.path.resolve(config.repoPath[p], config.relDartDocApiDir);
  }

  // Copy (and patch) API docs to ${destPath(p)} for each project p specified via --dartdoc
  gulp.task('finalize-api-docs', config.dartdocProj.map(p => `finalize-api-docs-${p}`));

  config.dartdocProj.forEach(p => {
    let deps = [`dartdoc-${p}`];
    if (p === 'acx' || p === 'ng') {
      gulp.task(`_api-copy-index+styles-${p}`, deps, () => apiCopyIndexAndStyles(p));
      gulp.task(`_api-copy+patch-html-${p}`, deps, () => apiCopyAndPatchHtml(p));
      deps = deps.concat([`_api-copy-index+styles-${p}`, `_api-copy+patch-html-${p}`]);
    }
    gulp.task(`finalize-api-docs-${p}`, deps, () => copyToUnifiedApi(p));
  });

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
      .pipe(plugins.replace(/<\/title>/, '$&\n  <base href="/components/api/">', { skipBinary: true }))
      .pipe(gulp.dest(destPath(p)));
  }

  function apiCopyAndPatchHtml(p) {
    plugins.gutil.log(`Copy API docs to ${destPath(p)}`)
    const urlToExamples = 'http://angular-examples.github.io/';
    const baseDir = path2GeneratedAPI(p);
    const ngContentAstIndex = filter(`${baseDir}/angular2.compiler/NgContentAst/index.html`, { restore: true });
    return gulp.src([
      `${baseDir}/angular*/**/*.html`,
    ], { base: baseDir })
      .pipe(ngContentAstIndex)
      // Patch file; see https://github.com/dart-lang/site-webdev/issues/271
      .pipe(plugins.replace(/(<base href="..)\/..(">)/, '$1$2'))
      .pipe(ngContentAstIndex.restore)
      .pipe(gulp.dest(destPath(p)));
  }

  function copyToUnifiedApi(p) {
    const pkgName = path.basename(config.repoPath[p]);
    const baseDir = path2GeneratedAPI(p);
    const src = [
      `${baseDir}/**`,
    ];
    const indexHtml = filter(`${baseDir}/index.html`, { restore: true });
    const ngContentAstIndex = filter(`${baseDir}/angular2.compiler/NgContentAst/index.html`, { restore: true });
    return gulp.src(src, { base: baseDir })
      .pipe(indexHtml)
      .pipe(plugins.replace(/<\/title>/, `$&\n  <base href="/api/${pkgName}/">`, { skipBinary: true }))
      .pipe(indexHtml.restore)

      .pipe(ngContentAstIndex)
      // Patch file; see https://github.com/dart-lang/site-webdev/issues/271
      .pipe(plugins.replace(/(<base href="..)\/..(">)/, '$1$2'))
      .pipe(ngContentAstIndex.restore)

      .pipe(gulp.dest(path.join(config.unifiedApiPath, pkgName)));
  }

};
