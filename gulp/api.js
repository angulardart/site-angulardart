// Gulp task to copy previously built API docs.
'use strict';

module.exports = function (gulp, plugins, config) {

  const gulp_task = plugins.gulp_task;
  const path = plugins.path;
  const filter = plugins.filter;
  const rename = plugins.rename;

  const linkToApiHome = `<a href="/api" title="Webdev API reference home">
      <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0" x="0px" y="0px" viewBox="0 0 24 24" style="display: inline-block; width: 24px; margin-right: 4px;"><g id="surface1"><path style=" " d="M 20 20 L 20 12 L 22 12 L 12 3 L 2 12 L 4 12 L 4 20 C 4 20.601563 4.398438 21 5 21 L 10 21 L 10 14 L 14 14 L 14 21 L 19 21 C 19.601563 21 20 20.601563 20 20 Z "></path></g></svg>
    </a>
  `;

  function finalizeApiDocs(done) {
    config._dartdocProj.forEach(p => _copyToUnifiedApi(p));
    done();
  }

  // Copy (and patch) API docs for each project p specified via --dartdoc
  gulp.task('finalize-api-docs', finalizeApiDocs);

  function _copyToUnifiedApi(p) {
    const pkgsWithApiDocs = plugins.fs.readdirSync(config.tmpPubPkgsPath);
    const pkgName = plugins.pkgAliasToPkgName(p);
    const baseDir = plugins.getPathToApiDir(pkgName);
    if (!plugins.fs.existsSync(baseDir)) {
      const msg = `could not find API doc directory for ${p} under ${baseDir}`;
      if (config.dartdocProj.includes(p)) plugins.logAndExit1(`ERROR: ${msg}. Aborting.`);
      plugins.myLog(`WARNING: ${msg}`);
      return;
    }
    const dest = path.join(config.unifiedApiPath, pkgName);
    // Clean out any old API pages
    if (plugins.fs.existsSync(dest)) {
      plugins.execSyncAndLog(`rm -Rf ${dest}`);
    }
    plugins.myLog(` Copying ${baseDir} to ${dest}`);
    const indexHtml = filter(`${baseDir}/index.html`, { restore: true });
    // Classes with a field named `index`, gets it page generated as `index.html`, which of course
    // is the default index file for the directory. So we need to adjust its <base href>. E.g., see
    // - https://github.com/dart-lang/site-webdev/issues/271
    // - https://github.com/dart-lang/angular_components/issues/283
    const apiWithGetterNamedIndex = filter(`${baseDir}/angular_components/StepDirective/index.html`, { restore: true });
    return gulp.src([`${baseDir}/**`], { base: baseDir })
      .pipe(indexHtml)
      .pipe(plugins.replace(/<\/title>/, `$&\n  <base href="/api/${pkgName}/">`, { skipBinary: true }))
      .pipe(indexHtml.restore)

      .pipe(apiWithGetterNamedIndex)
      // Patch file; see https://github.com/dart-lang/site-webdev/issues/271
      .pipe(plugins.replace(/(<base href="..)\/..(">)/, '$1$2'))
      .pipe(apiWithGetterNamedIndex.restore)

      .pipe(plugins.replace(/<header id="title">/, `$&\n  ${linkToApiHome}`, { skipBinary: true }))

      .pipe(gulp.dest(dest));
  }

};
