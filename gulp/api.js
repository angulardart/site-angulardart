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
    gulp.task(`finalize-api-docs-${p}`, [`dartdoc-${p}`], () => copyToUnifiedApi(p));
  });

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
